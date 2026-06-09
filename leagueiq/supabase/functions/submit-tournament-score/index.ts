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
    const { tournament_id, score } = body

    if (!tournament_id || score == null) return badRequest('tournament_id and score are required')

    // Fetch tournament
    const { data: tournament } = await db
      .from('tournaments')
      .select('id, status')
      .eq('id', tournament_id)
      .single()

    if (!tournament) return badRequest('Tournament not found')
    if (tournament.status !== 'active') return badRequest('Tournament is not active')

    // Fetch existing entry
    const { data: entry, error: entryErr } = await db
      .from('tournament_entries')
      .select('id, score, completed_at')
      .eq('tournament_id', tournament_id)
      .eq('user_id', user.id)
      .single()

    if (entryErr || !entry) return badRequest('You have not entered this tournament')

    // Only update if this score is higher (best score counts)
    if (score > entry.score) {
      await db
        .from('tournament_entries')
        .update({ score, completed_at: new Date().toISOString() })
        .eq('id', entry.id)
    }

    // Get current rank
    const { count: rank } = await db
      .from('tournament_entries')
      .select('id', { count: 'exact' })
      .eq('tournament_id', tournament_id)
      .gt('score', score)

    return respond({
      tournament_id,
      score: Math.max(score, entry.score),
      rank: (rank ?? 0) + 1,
    })
  } catch (e) {
    return serverError(e.message)
  }
})
