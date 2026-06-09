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

    const today = new Date().toISOString().split('T')[0]

    // Fetch today's daily challenge for this league
    let { data: challenge } = await db
      .from('daily_challenges')
      .select('*')
      .eq('league_id', league_id)
      .eq('date', today)
      .single()

    if (!challenge) {
      // Generate today's daily challenge
      const { data: allQuestions } = await db
        .from('questions')
        .select('id')
        .eq('league_id', league_id)
        .eq('is_active', true)
        .limit(300)

      if (!allQuestions || allQuestions.length < 10) return serverError('Not enough questions')

      const shuffled = allQuestions.sort(() => Math.random() - 0.5)
      const questionIds = shuffled.slice(0, 10).map((q) => q.id)

      const { data: newChallenge, error: insertErr } = await db
        .from('daily_challenges')
        .upsert({ league_id, question_ids: questionIds, date: today }, { onConflict: 'league_id,date' })
        .select()
        .single()

      if (insertErr || !newChallenge) return serverError('Failed to create daily challenge')
      challenge = newChallenge
    }

    // Fetch questions without correct_answer
    const questionIds: string[] = challenge.question_ids as string[]
    const { data: questions, error: qErr } = await db
      .from('questions')
      .select('id, league_id, category_id, question, options, difficulty, fact, is_active, created_at')
      .in('id', questionIds)

    if (qErr) return serverError('Failed to fetch questions')

    const ordered = questionIds
      .map((id) => questions?.find((q) => q.id === id))
      .filter(Boolean)

    return respond({ challenge, questions: ordered })
  } catch (e) {
    return serverError(e.message)
  }
})
