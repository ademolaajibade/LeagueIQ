import { corsHeaders } from '../_shared/cors.ts'
import { adminClient, getToken, respond, unauthorized, serverError, badRequest } from '../_shared/supabase.ts'

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  const token = getToken(req)
  if (!token) return unauthorized()

  const db = adminClient()
  const { data: { user }, error: authErr } = await db.auth.getUser(token)
  if (authErr || !user) return unauthorized()

  try {
    const { question_id, picked } = await req.json()
    if (!question_id || picked == null) return badRequest('question_id and picked are required')

    const today = new Date().toISOString().split('T')[0]

    // Check if already answered today — one attempt per day, no updates
    const { data: existing } = await db
      .from('qotd_answers')
      .select('picked')
      .eq('user_id', user.id)
      .eq('date', today)
      .maybeSingle()

    const { data: question } = await db
      .from('questions')
      .select('correct_answer')
      .eq('id', question_id)
      .single()

    const correct_answer = question?.correct_answer ?? null

    if (existing) {
      const is_correct = correct_answer !== null && existing.picked === correct_answer
      return respond({ ok: true, correct_answer, is_correct, already_answered: true })
    }

    const { error } = await db
      .from('qotd_answers')
      .insert({ user_id: user.id, question_id, picked, date: today })

    if (error) return serverError(error.message)

    const is_correct = correct_answer !== null && picked === correct_answer

    return respond({ ok: true, correct_answer, is_correct, already_answered: false })
  } catch (e) {
    return serverError(e.message)
  }
})
