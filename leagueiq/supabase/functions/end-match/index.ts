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
    const { match_id } = body
    if (!match_id) return badRequest('match_id is required')

    // Fetch match
    const { data: match, error: matchErr } = await db
      .from('matches')
      .select('*')
      .eq('id', match_id)
      .single()

    if (matchErr || !match) return badRequest('Match not found')
    if (match.player1_id !== user.id && match.player2_id !== user.id) {
      return badRequest('You are not a player in this match')
    }
    if (match.status === 'completed') return badRequest('Match already completed')
    if (match.status !== 'active') return badRequest('Match is not active')

    // Count correct answers per player
    const { data: answers } = await db
      .from('match_answers')
      .select('user_id, is_correct')
      .eq('match_id', match_id)

    const allAnswers = answers ?? []
    const questionCount = (match.question_ids as string[]).length

    const p1Correct = allAnswers.filter((a) => a.user_id === match.player1_id && a.is_correct).length
    const p2Correct = allAnswers.filter((a) => a.user_id === match.player2_id && a.is_correct).length

    const p1Total = allAnswers.filter((a) => a.user_id === match.player1_id).length
    const p2Total = allAnswers.filter((a) => a.user_id === match.player2_id).length

    // Only end if both players have answered all questions (or caller forces end)
    if (p1Total < questionCount && p2Total < questionCount) {
      return respond({
        status: 'in_progress',
        player1_score: p1Correct,
        player2_score: p2Correct,
        player1_answered: p1Total,
        player2_answered: p2Total,
        total_questions: questionCount,
      })
    }

    let winnerId: string | null = null
    if (p1Correct > p2Correct) winnerId = match.player1_id
    else if (p2Correct > p1Correct) winnerId = match.player2_id
    // tie = null winner

    // Mark match completed
    const { data: completedMatch } = await db
      .from('matches')
      .update({ status: 'completed', winner_id: winnerId })
      .eq('id', match_id)
      .select()
      .single()

    // Award XP: winner gets 50 XP, loser gets 20 XP, tie = 30 XP each
    const winnerXp = 50
    const loserXp = 20
    const tieXp = 30

    for (const playerId of [match.player1_id, match.player2_id]) {
      if (!playerId) continue
      const xp = winnerId === null ? tieXp : playerId === winnerId ? winnerXp : loserXp
      const { data: profile } = await db
        .from('profiles')
        .select('xp, level')
        .eq('id', playerId)
        .single()
      if (profile) {
        const newXp = profile.xp + xp
        const newLevel = calcLevel(newXp)
        await db.from('profiles').update({ xp: newXp, level: newLevel }).eq('id', playerId)
      }
    }

    return respond({
      status: 'completed',
      match: completedMatch,
      player1_score: p1Correct,
      player2_score: p2Correct,
      winner_id: winnerId,
    })
  } catch (e) {
    return serverError(e.message)
  }
})

function calcLevel(xp: number): string {
  if (xp >= 10000) return 'Legend'
  if (xp >= 5000) return 'Platinum'
  if (xp >= 2000) return 'Gold'
  if (xp >= 500) return 'Silver'
  return 'Bronze'
}
