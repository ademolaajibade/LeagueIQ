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

    // Second call: creator submits their score after playing
    if (body.challenge_id && body.creator_score != null) {
      const { challenge_id, creator_score } = body

      const { data: challenge } = await db
        .from('friend_challenges')
        .select('id, creator_id')
        .eq('id', challenge_id)
        .single()

      if (!challenge) return badRequest('Challenge not found')
      if (challenge.creator_id !== user.id) return badRequest('Not the creator of this challenge')

      await db
        .from('friend_challenges')
        .update({ creator_score })
        .eq('id', challenge_id)

      return respond({ ok: true })
    }

    // First call: create a new challenge
    const { league_id, category_id } = body
    if (!league_id) return badRequest('league_id is required')

    // Pick 10 random questions
    let query = db
      .from('questions')
      .select('id, league_id, category_id, question, options, difficulty, fact, is_active, created_at')
      .eq('league_id', league_id)
      .eq('is_active', true)

    if (category_id) query = query.eq('category_id', category_id)

    const { data: questions } = await query.limit(200)
    if (!questions || questions.length < 10) return serverError('Not enough questions')

    const shuffled = questions.sort(() => Math.random() - 0.5)
    const picked = shuffled.slice(0, 10)
    const questionIds = picked.map((q) => q.id)

    // Create challenge record
    const { data: challenge, error: challengeErr } = await db
      .from('friend_challenges')
      .insert({
        creator_id: user.id,
        league_id,
        category_id: category_id ?? null,
        question_ids: questionIds,
      })
      .select()
      .single()

    if (challengeErr || !challenge) return serverError('Failed to create challenge')

    const deepLink = `leagueiq://challenge/${challenge.token}`

    return respond({
      challenge_id: challenge.id,
      token: challenge.token,
      deep_link: deepLink,
      questions: picked,
    })
  } catch (e) {
    return serverError(e.message)
  }
})
