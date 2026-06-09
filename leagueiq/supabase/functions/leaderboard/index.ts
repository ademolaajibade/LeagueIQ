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
    const body = await req.json().catch(() => ({}))
    const { league_id, period = 'all_time', limit = 50 } = body

    if (period === 'survival') {
      // Survival leaderboard from survival_sessions
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

      const ranked = (entries ?? []).map((e, i) => ({ ...e, rank: i + 1 }))
      const userRank = ranked.find((e) => e.user_id === user.id)?.rank ?? null

      return respond({ entries: ranked, current_user_rank: userRank })
    }

    // Standard leaderboard from leaderboard table
    const scoreColumn = period === 'weekly' ? 'weekly_score' : 'total_score'

    let query = db
      .from('leaderboard')
      .select(`
        id, user_id, league_id, total_score, weekly_score, games_played, best_score, updated_at,
        profiles:user_id (username, avatar_url, level, club_id)
      `)
      .order(scoreColumn, { ascending: false })
      .limit(limit)

    if (league_id) query = query.eq('league_id', league_id)

    const { data: entries, error } = await query

    if (error) return serverError('Failed to fetch leaderboard')

    const ranked = (entries ?? []).map((e, i) => ({ ...e, rank: i + 1 }))
    const userEntry = ranked.find((e) => e.user_id === user.id)
    let currentUserRank = userEntry?.rank ?? null

    if (!currentUserRank) {
      // User is outside top N — compute rank
      const { data: userLbEntry } = await db
        .from('leaderboard')
        .select(scoreColumn)
        .eq('user_id', user.id)
        .maybeSingle()

      if (userLbEntry) {
        let rankQuery = db
          .from('leaderboard')
          .select('id', { count: 'exact' })
          .gt(scoreColumn, userLbEntry[scoreColumn as keyof typeof userLbEntry])

        if (league_id) rankQuery = rankQuery.eq('league_id', league_id)

        const { count } = await rankQuery
        currentUserRank = (count ?? 0) + 1
      }
    }

    return respond({ entries: ranked, current_user_rank: currentUserRank })
  } catch (e) {
    return serverError(e.message)
  }
})
