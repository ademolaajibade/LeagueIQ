import { corsHeaders } from '../_shared/cors.ts'
import { adminClient, respond, unauthorized, badRequest, serverError } from '../_shared/supabase.ts'

// This function is called by pg_cron — authenticated with the service role key.
// Supported types: daily_challenge | streak_at_risk | tournament_ending
Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  // Verify caller is the service role (pg_cron or backend trigger)
  const authHeader = req.headers.get('Authorization')
  const token = authHeader?.startsWith('Bearer ') ? authHeader.slice(7) : null
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  if (!token || token !== serviceKey) return unauthorized()

  try {
    const body = await req.json()
    const { type } = body as { type: string }
    if (!type) return badRequest('type is required')

    const db = adminClient()
    const messages: ExpoMessage[] = []

    if (type === 'daily_challenge') {
      // All users with push token and notifications enabled
      const { data: users } = await db
        .from('profiles')
        .select('push_token')
        .not('push_token', 'is', null)
        .eq('notifications_enabled', true)

      for (const u of users ?? []) {
        messages.push({
          to:    u.push_token!,
          title: '⚽ Daily Challenge Ready!',
          body:  'Your daily football trivia challenge is live. Keep your streak going!',
          data:  { type: 'daily_challenge' },
        })
      }

    } else if (type === 'streak_at_risk') {
      // Users with streak > 0 who haven't completed a game today
      const today = new Date().toISOString().split('T')[0]

      const { data: playedToday } = await db
        .from('game_sessions')
        .select('user_id')
        .gte('completed_at', today)
        .eq('status', 'completed')

      const playedIds = new Set((playedToday ?? []).map((r) => r.user_id))

      const { data: atRisk } = await db
        .from('profiles')
        .select('id, push_token, streak')
        .not('push_token', 'is', null)
        .eq('notifications_enabled', true)
        .gt('streak', 0)

      for (const u of atRisk ?? []) {
        if (!playedIds.has(u.id)) {
          messages.push({
            to:    u.push_token!,
            title: '🔥 Streak at Risk!',
            body:  `Your ${u.streak}-day streak ends at midnight. Play now to keep it alive!`,
            data:  { type: 'streak_at_risk' },
          })
        }
      }

    } else if (type === 'tournament_ending') {
      // Active tournaments ending within the next 24 hours
      const now = new Date()
      const in24h = new Date(now.getTime() + 24 * 60 * 60 * 1000).toISOString()

      const { data: tournaments } = await db
        .from('tournaments')
        .select('id, name, ends_at')
        .eq('status', 'active')
        .lte('ends_at', in24h)
        .gte('ends_at', now.toISOString())

      for (const t of tournaments ?? []) {
        const { data: entries } = await db
          .from('tournament_entries')
          .select('user_id')
          .eq('tournament_id', t.id)

        const userIds = (entries ?? []).map((e) => e.user_id)
        if (!userIds.length) continue

        const { data: participants } = await db
          .from('profiles')
          .select('push_token')
          .in('id', userIds)
          .not('push_token', 'is', null)
          .eq('notifications_enabled', true)

        for (const p of participants ?? []) {
          messages.push({
            to:    p.push_token!,
            title: '🏆 Tournament Ending Soon!',
            body:  `${t.name} closes in less than 24 hours. Submit your final score!`,
            data:  { type: 'tournament_ending', tournament_id: t.id },
          })
        }
      }

    } else {
      return badRequest(`Unknown notification type: ${type}`)
    }

    if (messages.length > 0) {
      await sendExpoPush(messages)
    }

    return respond({ sent: messages.length })
  } catch (e) {
    return serverError(e.message)
  }
})

// ── Expo Push API ─────────────────────────────────────────────

interface ExpoMessage {
  to:    string
  title: string
  body:  string
  data?: Record<string, unknown>
  sound?: 'default'
  badge?: number
}

async function sendExpoPush(messages: ExpoMessage[]): Promise<void> {
  // Expo push API accepts up to 100 messages per request
  const chunks: ExpoMessage[][] = []
  for (let i = 0; i < messages.length; i += 100) {
    chunks.push(messages.slice(i, i + 100))
  }

  for (const chunk of chunks) {
    const payload = chunk.map((m) => ({ ...m, sound: 'default' as const }))
    await fetch('https://exp.host/--/api/v2/push/send', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
      body:    JSON.stringify(payload),
    })
  }
}
