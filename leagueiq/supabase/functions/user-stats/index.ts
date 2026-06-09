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
    // Fetch profile
    const { data: profile, error: profileErr } = await db
      .from('profiles')
      .select('*')
      .eq('id', user.id)
      .single()

    if (profileErr || !profile) return serverError('Failed to fetch profile')

    // Fetch completed game sessions
    const { data: sessions } = await db
      .from('game_sessions')
      .select('id, league_id, category_id, mode, score, xp_earned, total_questions, completed_at')
      .eq('user_id', user.id)
      .eq('status', 'completed')
      .order('completed_at', { ascending: false })
      .limit(200)

    // Fetch session answers for accuracy
    const sessionIds = (sessions ?? []).map((s) => s.id)
    let allAnswers: Array<{ session_id: string; is_correct: boolean; question_id: string }> = []

    if (sessionIds.length > 0) {
      const { data: answers } = await db
        .from('session_answers')
        .select('session_id, is_correct, question_id')
        .in('session_id', sessionIds)

      allAnswers = answers ?? []
    }

    // Accuracy per session
    const totalAnswered = allAnswers.length
    const totalCorrect = allAnswers.filter((a) => a.is_correct).length
    const overallAccuracy = totalAnswered > 0 ? Math.round((totalCorrect / totalAnswered) * 100) : 0

    // Games played + best score per league
    const leagueStats: Record<string, { games_played: number; total_correct: number; total_answered: number; best_score: number }> = {}
    for (const session of sessions ?? []) {
      if (!leagueStats[session.league_id]) {
        leagueStats[session.league_id] = { games_played: 0, total_correct: 0, total_answered: 0, best_score: 0 }
      }
      leagueStats[session.league_id].games_played++
      if (session.score > leagueStats[session.league_id].best_score) {
        leagueStats[session.league_id].best_score = session.score
      }
    }
    for (const answer of allAnswers) {
      const session = (sessions ?? []).find((s) => s.id === answer.session_id)
      if (!session) continue
      if (!leagueStats[session.league_id]) continue
      leagueStats[session.league_id].total_answered++
      if (answer.is_correct) leagueStats[session.league_id].total_correct++
    }

    // League mastery
    const { data: mastery } = await db
      .from('league_mastery')
      .select('*')
      .eq('user_id', user.id)

    // Survival best score
    const { data: survivalBest } = await db
      .from('survival_sessions')
      .select('questions_survived, league_id')
      .eq('user_id', user.id)
      .not('ended_at', 'is', null)
      .order('questions_survived', { ascending: false })
      .limit(1)
      .maybeSingle()

    // XP timeline (last 30 sessions)
    const xpTimeline = (sessions ?? [])
      .slice(0, 30)
      .reverse()
      .map((s) => ({ date: s.completed_at, xp_earned: s.xp_earned }))

    return respond({
      profile,
      games_played: (sessions ?? []).length,
      overall_accuracy: overallAccuracy,
      league_stats: leagueStats,
      mastery: mastery ?? [],
      survival_best: survivalBest?.questions_survived ?? 0,
      xp_timeline: xpTimeline,
    })
  } catch (e) {
    return serverError(e.message)
  }
})
