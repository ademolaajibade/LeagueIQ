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
    const { league_id } = body
    if (!league_id) return badRequest('league_id is required')

    // Pick 10 random questions from the league
    const { data: questions } = await db
      .from('questions')
      .select('id')
      .eq('league_id', league_id)
      .eq('is_active', true)
      .limit(200)

    if (!questions || questions.length < 10) return serverError('Not enough questions for match')

    const shuffled = questions.map((q) => q.id).sort(() => Math.random() - 0.5)
    const questionIds = shuffled.slice(0, 10)

    // Create match record
    const { data: match, error: matchErr } = await db
      .from('matches')
      .insert({
        league_id,
        player1_id: user.id,
        question_ids: questionIds,
        status: 'waiting',
      })
      .select()
      .single()

    if (matchErr || !match) return serverError('Failed to create match')

    // Join code = first 8 chars of match ID uppercased
    const joinCode = match.id.replace(/-/g, '').slice(0, 8).toUpperCase()

    return respond({ match_id: match.id, join_code: joinCode })
  } catch (e) {
    return serverError(e.message)
  }
})
