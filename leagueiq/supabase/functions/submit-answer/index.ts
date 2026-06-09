import { corsHeaders } from '../_shared/cors.ts'
import {
  adminClient, getToken, respond, unauthorized, badRequest, serverError, calcXp,
} from '../_shared/supabase.ts'

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

    // Fetch session
    const { data: session, error: sessionErr } = await db
      .from('game_sessions')
      .select('*')
      .eq('id', session_id)
      .eq('user_id', user.id)
      .single()

    if (sessionErr || !session) return badRequest('Session not found')
    if (session.status !== 'active') return badRequest('Session is not active')
    if (new Date(session.expires_at) < new Date()) {
      await db.from('game_sessions').update({ status: 'expired' }).eq('id', session_id)
      return badRequest('Session has expired')
    }

    // Verify question belongs to this session
    const questionIds: string[] = session.question_ids ?? []
    if (!questionIds.includes(question_id)) {
      return badRequest('Question does not belong to this session')
    }

    // Fetch question (with correct_answer — server-side only)
    const { data: question, error: qErr } = await db
      .from('questions')
      .select('id, correct_answer, difficulty, fact')
      .eq('id', question_id)
      .single()

    if (qErr || !question) return badRequest('Question not found')

    const isCorrect = selected_answer === question.correct_answer

    // Check XP booster
    const { data: profile } = await db
      .from('profiles')
      .select('xp_booster_expires_at')
      .eq('id', user.id)
      .single()

    const boosterActive =
      profile?.xp_booster_expires_at != null &&
      new Date(profile.xp_booster_expires_at) > new Date()

    const xpEarned = isCorrect ? calcXp(question.difficulty, time_taken_ms, boosterActive) : 0

    // Insert answer (unique constraint prevents duplicates)
    const { error: insertErr } = await db.from('session_answers').insert({
      session_id,
      question_id,
      selected_answer,
      is_correct: isCorrect,
      time_taken_ms,
    })

    if (insertErr) {
      if (insertErr.code === '23505') return badRequest('Answer already submitted for this question')
      return serverError('Failed to record answer')
    }

    // Update session score and xp_earned
    const { data: updatedSession, error: updateErr } = await db
      .from('game_sessions')
      .update({
        score: session.score + (isCorrect ? 1 : 0),
        xp_earned: session.xp_earned + xpEarned,
      })
      .eq('id', session_id)
      .select('score, xp_earned')
      .single()

    if (updateErr) return serverError('Failed to update session')

    return respond({
      is_correct: isCorrect,
      correct_answer: question.correct_answer,
      fact: question.fact,
      score: updatedSession.score,
      xp_earned: xpEarned,
    })
  } catch (e) {
    return serverError(e.message)
  }
})
