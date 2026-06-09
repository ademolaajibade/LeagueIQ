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
    const { match_id, question_id, selected_answer, time_taken_ms } = body

    if (!match_id || !question_id || selected_answer == null || time_taken_ms == null) {
      return badRequest('match_id, question_id, selected_answer, and time_taken_ms are required')
    }

    // Fetch match
    const { data: match, error: matchErr } = await db
      .from('matches')
      .select('*')
      .eq('id', match_id)
      .single()

    if (matchErr || !match) return badRequest('Match not found')
    if (match.status !== 'active') return badRequest('Match is not active')
    if (match.player1_id !== user.id && match.player2_id !== user.id) {
      return badRequest('You are not a player in this match')
    }

    // Verify question belongs to match
    const questionIds: string[] = match.question_ids as string[]
    if (!questionIds.includes(question_id)) {
      return badRequest('Question does not belong to this match')
    }

    // Fetch question with correct_answer
    const { data: question, error: qErr } = await db
      .from('questions')
      .select('id, correct_answer, difficulty, fact')
      .eq('id', question_id)
      .single()

    if (qErr || !question) return badRequest('Question not found')

    const isCorrect = selected_answer === question.correct_answer

    // Insert match answer (unique constraint prevents duplicates)
    const { error: insertErr } = await db.from('match_answers').insert({
      match_id,
      user_id: user.id,
      question_id,
      selected_answer,
      is_correct: isCorrect,
      time_taken_ms,
    })

    if (insertErr) {
      if (insertErr.code === '23505') return badRequest('Answer already submitted')
      return serverError('Failed to record answer')
    }

    return respond({
      is_correct: isCorrect,
      correct_answer: question.correct_answer,
      fact: question.fact,
    })
  } catch (e) {
    return serverError(e.message)
  }
})
