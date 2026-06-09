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
      // Fall back to a random active question
      const { data: allQuestions } = await db
        .from('questions')
        .select('id')
        .eq('is_active', true)
        .limit(500)

      if (!allQuestions || allQuestions.length === 0) return serverError('No questions available')
      questionId = allQuestions[Math.floor(Math.random() * allQuestions.length)].id
    }

    // Fetch question without correct_answer
    const { data: question, error: qErr } = await db
      .from('questions')
      .select('id, league_id, category_id, question, options, difficulty, fact, is_active, created_at')
      .eq('id', questionId)
      .single()

    if (qErr || !question) return serverError('Failed to fetch question')

    return respond({ date: today, question })
  } catch (e) {
    return serverError(e.message)
  }
})
