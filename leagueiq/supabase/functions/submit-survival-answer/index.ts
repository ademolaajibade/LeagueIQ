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
    const { session_id, question_id, selected_answer, time_taken_ms } = body

    if (!session_id || !question_id || selected_answer == null || time_taken_ms == null) {
      return badRequest('session_id, question_id, selected_answer, and time_taken_ms are required')
    }

    // Fetch survival session
    const { data: session, error: sessionErr } = await db
      .from('survival_sessions')
      .select('*')
      .eq('id', session_id)
      .eq('user_id', user.id)
      .single()

    if (sessionErr || !session) return badRequest('Survival session not found')
    if (session.ended_at != null) return badRequest('Survival session already ended')

    // Fetch question with correct_answer
    const { data: question, error: qErr } = await db
      .from('questions')
      .select('id, correct_answer, difficulty, fact, league_id')
      .eq('id', question_id)
      .single()

    if (qErr || !question) return badRequest('Question not found')
    if (question.league_id !== session.league_id) return badRequest('Question does not match session league')

    const isCorrect = selected_answer === question.correct_answer
    const seenIds: string[] = (session.question_ids_seen as string[]) ?? []

    if (isCorrect) {
      // Increment survived count, add to seen list
      const newSurvivedCount = session.questions_survived + 1
      const newSeenIds = [...seenIds, question_id]

      await db
        .from('survival_sessions')
        .update({
          questions_survived: newSurvivedCount,
          question_ids_seen: newSeenIds,
        })
        .eq('id', session_id)

      // Pick next question (exclude already seen)
      const { data: remaining } = await db
        .from('questions')
        .select('id, league_id, category_id, question, options, difficulty, fact, is_active, created_at')
        .eq('league_id', session.league_id)
        .eq('is_active', true)
        .not('id', 'in', `(${newSeenIds.map((id) => `'${id}'`).join(',')})`)
        .limit(100)

      const nextQuestion = remaining && remaining.length > 0
        ? remaining[Math.floor(Math.random() * remaining.length)]
        : null

      if (nextQuestion) {
        await db
          .from('survival_sessions')
          .update({ question_ids_seen: [...newSeenIds, nextQuestion.id] })
          .eq('id', session_id)
      }

      return respond({
        is_correct: true,
        correct_answer: question.correct_answer,
        fact: question.fact,
        questions_survived: newSurvivedCount,
        next_question: nextQuestion,
      })
    } else {
      // Game over — record ended_at
      await db
        .from('survival_sessions')
        .update({ ended_at: new Date().toISOString() })
        .eq('id', session_id)

      return respond({
        is_correct: false,
        correct_answer: question.correct_answer,
        fact: question.fact,
        questions_survived: session.questions_survived,
        next_question: null,
      })
    }
  } catch (e) {
    return serverError(e.message)
  }
})
