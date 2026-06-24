import { corsHeaders } from '../_shared/cors.ts'
import { adminClient, getToken, respond, unauthorized, serverError } from '../_shared/supabase.ts'

// Supabase joins return the key as the table name ("profiles"), but the client
// type and leaderboard page expect it as "profile" (singular). We normalise here.
// deno-lint-ignore no-explicit-any
function normaliseEntry(e: any, rank: number) {
  return { ...e, id: e.id ?? e.user_id, profile: e.profiles ?? null, rank }
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  const token = getToken(req)
  if (!token) return unauthorized()

  const db = adminClient()
  const { data: { user }, error: authErr } = await db.auth.getUser(token)
  if (authErr || !user) return unauthorized()

  try {
    const body = await req.json().catch(() => ({}))
    const { league_id, period = 'all_time', limit = 50 } = body

    if (period === 'survival') {
      const { data: entries, error } = await db
        .from('survival_sessions')
        .select(`
          id, user_id, league_id, questions_survived, ended_at, created_at,
          profiles:user_id (username, avatar_url, level, club_id)
        `)
        .not('ended_at', 'is', null)
        .order('questions_survived', { ascending: false })
        .limit(limit)

      if (error) return serverError('Failed to fetch survival leaderboard')

      const ranked = (entries ?? []).map((e, i) => normaliseEntry(e, i + 1))
      const userRank = ranked.find((e) => e.user_id === user.id)?.rank ?? null

      return respond({ entries: ranked, current_user_rank: userRank })
    }

    const scoreColumn = period === 'weekly' ? 'weekly_score' : 'total_score'

    if (!league_id) {
      // Global — fetch scores only (no join) to keep rank computation reliable
      const { data: allEntries, error: scoresErr } = await db
        .from('leaderboard')
        .select('user_id, total_score, weekly_score, games_played, best_score')
        .limit(10000)

      if (scoresErr) return serverError('Failed to fetch leaderboard')

      // deno-lint-ignore no-explicit-any
      const userMap = new Map<string, any>()
      for (const e of allEntries ?? []) {
        const uid = e.user_id as string
        const existing = userMap.get(uid)
        if (existing) {
          existing.total_score  += (e.total_score  as number) ?? 0
          existing.weekly_score += (e.weekly_score as number) ?? 0
          existing.games_played += (e.games_played as number) ?? 0
          existing.best_score    = Math.max(existing.best_score, (e.best_score as number) ?? 0)
        } else {
          userMap.set(uid, {
            user_id:      uid,
            total_score:  (e.total_score  as number) ?? 0,
            weekly_score: (e.weekly_score as number) ?? 0,
            games_played: (e.games_played as number) ?? 0,
            best_score:   (e.best_score   as number) ?? 0,
          })
        }
      }

      const sorted = [...userMap.values()].sort(
        // deno-lint-ignore no-explicit-any
        (a: any, b: any) => (b[scoreColumn] ?? 0) - (a[scoreColumn] ?? 0)
      )

      const userIdx = sorted.findIndex((e) => e.user_id === user.id)
      const currentUserRank = userIdx >= 0 ? userIdx + 1 : null

      // Fetch profiles for top N entries separately
      const topN = sorted.slice(0, limit)
      const topIds = topN.map((e) => e.user_id)
      const { data: profiles } = await db
        .from('profiles')
        .select('id, username, avatar_url, level')
        .in('id', topIds)

      // deno-lint-ignore no-explicit-any
      const profileMap = new Map((profiles ?? []).map((p: any) => [p.id, p]))
      const ranked = topN.map((e, i) => normaliseEntry(
        { ...e, profiles: profileMap.get(e.user_id) ?? null },
        i + 1,
      ))

      return respond({ entries: ranked, current_user_rank: currentUserRank })
    }

    // League-specific leaderboard
    const { data: entries, error } = await db
      .from('leaderboard')
      .select(`
        id, user_id, league_id, total_score, weekly_score, games_played, best_score, updated_at,
        profiles:user_id (username, avatar_url, level, club_id)
      `)
      .eq('league_id', league_id)
      .order(scoreColumn, { ascending: false })
      .limit(limit)

    if (error) return serverError('Failed to fetch leaderboard')

    const ranked = (entries ?? []).map((e, i) => normaliseEntry(e, i + 1))
    const userEntry = ranked.find((e) => e.user_id === user.id)
    let currentUserRank = userEntry?.rank ?? null

    if (!currentUserRank) {
      // User outside top N in this league — count rows above them
      const { data: userLbEntry } = await db
        .from('leaderboard')
        .select(scoreColumn)
        .eq('user_id', user.id)
        .eq('league_id', league_id)
        .maybeSingle()

      if (userLbEntry) {
        const { count } = await db
          .from('leaderboard')
          .select('id', { count: 'exact' })
          .eq('league_id', league_id)
          // deno-lint-ignore no-explicit-any
          .gt(scoreColumn, (userLbEntry as any)[scoreColumn])

        currentUserRank = (count ?? 0) + 1
      }
    }

    return respond({ entries: ranked, current_user_rank: currentUserRank })
  } catch (e) {
    return serverError(e.message)
  }
})
