import { corsHeaders } from '../_shared/cors.ts'
import { adminClient, getToken, respond, unauthorized, badRequest, serverError } from '../_shared/supabase.ts'

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  const token = getToken(req)
  if (!token) return unauthorized()

  const db = adminClient()
  const { data: { user }, error: authErr } = await db.auth.getUser(token)
  if (authErr || !user) return unauthorized()

  try {
    const body = await req.json()
    const { tournament_id } = body
    if (!tournament_id) return badRequest('tournament_id is required')

    // Fetch tournament
    const { data: tournament } = await db
      .from('tournaments')
      .select('*')
      .eq('id', tournament_id)
      .single()

    if (!tournament) return badRequest('Tournament not found')

    // Fetch top 50 entries with profile info
    const { data: entries, error: entriesErr } = await db
      .from('tournament_entries')
      .select(`
        id, score, completed_at, user_id,
        profiles:user_id (username, avatar_url, level, club_id)
      `)
      .eq('tournament_id', tournament_id)
      .order('score', { ascending: false })
      .limit(50)

    if (entriesErr) return serverError('Failed to fetch leaderboard')

    const ranked = (entries ?? []).map((entry, i) => ({ ...entry, rank: i + 1 }))

    // Find current user's rank
    const userEntry = ranked.find((e) => e.user_id === user.id)
    let currentUserRank = userEntry?.rank ?? null

    if (!currentUserRank) {
      // User is outside top 50 — get their position
      const { data: userEntryData } = await db
        .from('tournament_entries')
        .select('score')
        .eq('tournament_id', tournament_id)
        .eq('user_id', user.id)
        .single()

      if (userEntryData) {
        const { count } = await db
          .from('tournament_entries')
          .select('id', { count: 'exact' })
          .eq('tournament_id', tournament_id)
          .gt('score', userEntryData.score)

        currentUserRank = (count ?? 0) + 1
      }
    }

    return respond({ tournament, entries: ranked, current_user_rank: currentUserRank })
  } catch (e) {
    return serverError(e.message)
  }
})
