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
    const { match_id } = body
    if (!match_id) return badRequest('match_id is required')

    // Find the match
    const { data: match, error: matchErr } = await db
      .from('matches')
      .select('*')
      .eq('id', match_id)
      .single()

    if (matchErr || !match) return badRequest('Match not found')
    if (match.status !== 'waiting') return badRequest('Match is no longer available')
    if (match.player1_id === user.id) return badRequest('Cannot join your own match')

    // Update match to active with player2
    const { data: updatedMatch, error: updateErr } = await db
      .from('matches')
      .update({ player2_id: user.id, status: 'active' })
      .eq('id', match_id)
      .select()
      .single()

    if (updateErr || !updatedMatch) return serverError('Failed to join match')

    // Fetch questions without correct_answer
    const questionIds: string[] = updatedMatch.question_ids as string[]
    const { data: questions } = await db
      .from('questions')
      .select('id, league_id, category_id, question, options, difficulty, fact, is_active, created_at')
      .in('id', questionIds)

    const orderedQuestions = questionIds
      .map((id) => questions?.find((q) => q.id === id))
      .filter(Boolean)

    return respond({ match: updatedMatch, questions: orderedQuestions })
  } catch (e) {
    return serverError(e.message)
  }
})
