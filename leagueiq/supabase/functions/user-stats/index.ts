import { corsHeaders } from '../_shared/cors.ts'
import { adminClient, getToken, respond, unauthorized, serverError } from '../_shared/supabase.ts'

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  const token = getToken(req)
  if (!token) return unauthorized()

  const db = adminClient()
  const { data: { user }, error: authErr } = await db.auth.getUser(token)
  if (authErr || !user) return unauthorized()

  try {
    const { data: profile, error: profileErr } = await db
      .from('profiles')
      .select('*')
      .eq('id', user.id)
      .single()

    if (profileErr || !profile) return serverError('Failed to fetch profile')

    const { data: sessions } = await db
      .from('game_sessions')
      .select('id, league_id, category_id, mode, score, xp_earned, total_questions, completed_at')
      .eq('user_id', user.id)
      .eq('status', 'completed')
      .order('completed_at', { ascending: false })
      .limit(200)

    const sessionList = sessions ?? []
    const sessionIds  = sessionList.map((s) => s.id)

    // Accuracy via server-side COUNT — avoids row-limit truncation
    let overallAccuracy = 0
    if (sessionIds.length > 0) {
      const [{ count: totalAnswered }, { count: totalCorrect }] = await Promise.all([
        db.from('session_answers')
          .select('*', { count: 'exact', head: true })
          .in('session_id', sessionIds),
        db.from('session_answers')
          .select('*', { count: 'exact', head: true })
          .in('session_id', sessionIds)
          .eq('is_correct', true),
      ])
      overallAccuracy = (totalAnswered ?? 0) > 0
        ? Math.round(((totalCorrect ?? 0) / (totalAnswered ?? 0)) * 100)
        : 0
    }

    // Per-league stats derived from session data — no extra query needed
    const leagueStats: Record<string, { games_played: number; accuracy: number; games: number }> = {}
    for (const s of sessionList) {
      if (!leagueStats[s.league_id]) {
        leagueStats[s.league_id] = { games_played: 0, accuracy: 0, games: 0 }
      }
      leagueStats[s.league_id].games_played++
    }

    const { data: mastery } = await db
      .from('league_mastery')
      .select('*')
      .eq('user_id', user.id)

    const { data: survivalBest } = await db
      .from('survival_sessions')
      .select('questions_survived, league_id')
      .eq('user_id', user.id)
      .not('ended_at', 'is', null)
      .order('questions_survived', { ascending: false })
      .limit(1)
      .maybeSingle()

    const xpTimeline = sessionList
      .slice(0, 30)
      .reverse()
      .map((s) => ({ date: s.completed_at, xp_earned: s.xp_earned }))

    const bestStreak = sessionList.length > 0
      ? Math.max(...sessionList.map((s) => s.score))
      : 0

    return respond({
      profile,
      games_played:     sessionList.length,
      accuracy:         overallAccuracy,
      best_streak:      bestStreak,
      xp_total:         profile.xp,
      overall_accuracy: overallAccuracy,
      league_stats:     leagueStats,
      mastery:          mastery ?? [],
      survival_best:    survivalBest?.questions_survived ?? 0,
      xp_timeline:      xpTimeline,
    })
  } catch (e) {
    return serverError(e.message)
  }
})
