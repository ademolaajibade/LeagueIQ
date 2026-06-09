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

    // Create survival session
    const { data: session, error: sessionErr } = await db
      .from('survival_sessions')
      .insert({ user_id: user.id, league_id })
      .select()
      .single()

    if (sessionErr || !session) return serverError('Failed to create survival session')

    // Pick first random question
    const { data: questions } = await db
      .from('questions')
      .select('id, league_id, category_id, question, options, difficulty, fact, is_active, created_at')
      .eq('league_id', league_id)
      .eq('is_active', true)
      .limit(200)

    if (!questions || questions.length === 0) return serverError('No questions available')

    const question = questions[Math.floor(Math.random() * questions.length)]

    // Store seen question
    await db
      .from('survival_sessions')
      .update({ question_ids_seen: [question.id] })
      .eq('id', session.id)

    return respond({ session_id: session.id, question })
  } catch (e) {
    return serverError(e.message)
  }
})
