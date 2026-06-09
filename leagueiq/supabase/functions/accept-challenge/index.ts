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

    // Second call: opponent submits their score after playing
    if (body.challenge_id && body.opponent_score != null) {
      const { challenge_id, opponent_score } = body

      const { data: challenge } = await db
        .from('friend_challenges')
        .select('*')
        .eq('id', challenge_id)
        .single()

      if (!challenge) return badRequest('Challenge not found')
      if (challenge.opponent_id && challenge.opponent_id !== user.id) {
        return badRequest('Another opponent has already accepted this challenge')
      }

      await db
        .from('friend_challenges')
        .update({ opponent_id: user.id, opponent_score })
        .eq('id', challenge_id)

      // Determine result
      const creatorScore = challenge.creator_score ?? 0
      let result: 'creator' | 'opponent' | 'tie' = 'tie'
      if (creatorScore > opponent_score) result = 'creator'
      else if (opponent_score > creatorScore) result = 'opponent'

      return respond({
        challenge_id,
        creator_score: creatorScore,
        opponent_score,
        result,
      })
    }

    // First call: fetch questions by token
    const { token: challengeToken } = body
    if (!challengeToken) return badRequest('token is required')

    const { data: challenge, error: challengeErr } = await db
      .from('friend_challenges')
      .select('*')
      .eq('token', challengeToken)
      .single()

    if (challengeErr || !challenge) return badRequest('Challenge not found')
    if (challenge.creator_id === user.id) return badRequest('Cannot accept your own challenge')

    // Fetch questions without correct_answer
    const questionIds: string[] = challenge.question_ids as string[]
    const { data: questions } = await db
      .from('questions')
      .select('id, league_id, category_id, question, options, difficulty, fact, is_active, created_at')
      .in('id', questionIds)

    const orderedQuestions = questionIds
      .map((id) => questions?.find((q) => q.id === id))
      .filter(Boolean)

    // Set opponent_id if not already set
    if (!challenge.opponent_id) {
      await db
        .from('friend_challenges')
        .update({ opponent_id: user.id })
        .eq('id', challenge.id)
    }

    return respond({
      challenge_id: challenge.id,
      creator_score: challenge.creator_score,
      questions: orderedQuestions,
    })
  } catch (e) {
    return serverError(e.message)
  }
})
