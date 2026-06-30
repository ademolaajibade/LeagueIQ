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
    const today = new Date().toISOString().split('T')[0]

    // Try to fetch today's scheduled QOTD
    const { data: qotd } = await db
      .from('question_of_the_day')
      .select('id, date, question_id')
      .eq('date', today)
      .single()

    let questionId: string

    if (qotd) {
      questionId = qotd.question_id
    } else {
      // Pick a random active question and pin it for the rest of today
      const { data: allQuestions } = await db
        .from('questions')
        .select('id')
        .eq('is_active', true)
        .limit(500)

      if (!allQuestions || allQuestions.length === 0) return serverError('No questions available')
      questionId = allQuestions[Math.floor(Math.random() * allQuestions.length)].id

      // Save so every subsequent request today gets the same question
      await db
        .from('question_of_the_day')
        .upsert({ question_id: questionId, date: today }, { onConflict: 'date' })
    }

    const { data: question, error: qErr } = await db
      .from('questions')
      .select('id, league_id, category_id, question, options, correct_answer, difficulty, fact, is_active, created_at')
      .eq('id', questionId)
      .single()

    if (qErr || !question) return serverError('Failed to fetch question')

    // Return the user's prior pick if they already answered today
    const { data: priorAnswer } = await db
      .from('qotd_answers')
      .select('picked')
      .eq('user_id', user.id)
      .eq('date', today)
      .maybeSingle()

    return respond({ date: today, question, user_pick: priorAnswer?.picked ?? null })
  } catch (e) {
    return serverError(e.message)
  }
})
