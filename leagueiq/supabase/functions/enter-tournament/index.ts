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
    const { data: tournament, error: tournErr } = await db
      .from('tournaments')
      .select('*')
      .eq('id', tournament_id)
      .single()

    if (tournErr || !tournament) return badRequest('Tournament not found')
    if (tournament.status !== 'active') return badRequest('Tournament is not active')

    // Upsert tournament entry
    const { data: entry, error: entryErr } = await db
      .from('tournament_entries')
      .upsert(
        { tournament_id, user_id: user.id },
        { onConflict: 'tournament_id,user_id', ignoreDuplicates: true },
      )
      .select()
      .single()

    if (entryErr) return serverError('Failed to enter tournament')

    // Fetch 10 random questions from the tournament's league
    const { data: questions } = await db
      .from('questions')
      .select('id, league_id, category_id, question, options, difficulty, fact, is_active, created_at')
      .eq('league_id', tournament.league_id)
      .eq('is_active', true)
      .limit(200)

    if (!questions || questions.length < 10) return serverError('Not enough questions for tournament')

    const picked = questions.sort(() => Math.random() - 0.5).slice(0, 10)

    return respond({ tournament, entry, questions: picked })
  } catch (e) {
    return serverError(e.message)
  }
})
