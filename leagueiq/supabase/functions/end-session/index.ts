import { corsHeaders } from '../_shared/cors.ts'
import {
  adminClient, getToken, respond, unauthorized, badRequest, serverError,
  calcLevel, calcMasteryLevel, sendPushNotification,
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
    const { session_id } = body
    if (!session_id) return badRequest('session_id is required')

    // Fetch session
    const { data: session, error: sessionErr } = await db
      .from('game_sessions')
      .select('*')
      .eq('id', session_id)
      .eq('user_id', user.id)
      .single()

    if (sessionErr || !session) return badRequest('Session not found')
    if (session.status === 'completed') return badRequest('Session already completed')
    if (session.status === 'expired') return badRequest('Session has expired')

    // Mark session completed
    const { data: completedSession, error: completeErr } = await db
      .from('game_sessions')
      .update({ status: 'completed', completed_at: new Date().toISOString() })
      .eq('id', session_id)
      .select()
      .single()

    if (completeErr || !completedSession) return serverError('Failed to complete session')

    // Count correct answers
    const { data: answers } = await db
      .from('session_answers')
      .select('is_correct')
      .eq('session_id', session_id)

    const correctCount = (answers ?? []).filter((a) => a.is_correct).length
    const xpEarned = completedSession.xp_earned

    // Fetch current profile
    const { data: profile, error: profileErr } = await db
      .from('profiles')
      .select('xp, level, streak, push_token, notifications_enabled')
      .eq('id', user.id)
      .single()

    if (profileErr || !profile) return serverError('Failed to fetch profile')

    const newXp = profile.xp + xpEarned
    const newLevel = calcLevel(newXp)
    const levelUp = newLevel !== profile.level ? newLevel : null

    // Update streak: only if mode is daily_challenge or at least 5/10 correct
    const today = new Date().toISOString().split('T')[0]
    let newStreak = profile.streak

    if (completedSession.mode === 'daily_challenge' || correctCount >= Math.ceil(completedSession.total_questions / 2)) {
      newStreak = profile.streak + 1
    }

    // Update profile
    await db
      .from('profiles')
      .update({ xp: newXp, level: newLevel, streak: newStreak })
      .eq('id', user.id)

    // Upsert leaderboard entry
    const { data: existingLb } = await db
      .from('leaderboard')
      .select('id, total_score, weekly_score, games_played, best_score')
      .eq('user_id', user.id)
      .eq('league_id', completedSession.league_id)
      .single()

    if (existingLb) {
      await db
        .from('leaderboard')
        .update({
          total_score: existingLb.total_score + completedSession.score,
          weekly_score: existingLb.weekly_score + completedSession.score,
          games_played: existingLb.games_played + 1,
          best_score: Math.max(existingLb.best_score, completedSession.score),
        })
        .eq('id', existingLb.id)
    } else {
      await db.from('leaderboard').insert({
        user_id: user.id,
        league_id: completedSession.league_id,
        total_score: completedSession.score,
        weekly_score: completedSession.score,
        games_played: 1,
        best_score: completedSession.score,
      })
    }

    // Update league mastery if a category was completed
    if (completedSession.category_id && correctCount >= Math.ceil(completedSession.total_questions * 0.7)) {
      const { data: mastery } = await db
        .from('league_mastery')
        .select('*')
        .eq('user_id', user.id)
        .eq('league_id', completedSession.league_id)
        .single()

      if (mastery) {
        // Only increment if this category wasn't already counted
        const newCount = mastery.categories_completed + 1
        const newMasteryLevel = calcMasteryLevel(newCount)
        await db
          .from('league_mastery')
          .update({ categories_completed: newCount, mastery_level: newMasteryLevel })
          .eq('id', mastery.id)
      } else {
        await db.from('league_mastery').insert({
          user_id: user.id,
          league_id: completedSession.league_id,
          categories_completed: 1,
          mastery_level: calcMasteryLevel(1),
        })
      }
    }

    // Get leaderboard position
    const { count: lbPosition } = await db
      .from('leaderboard')
      .select('id', { count: 'exact' })
      .eq('league_id', completedSession.league_id)
      .gt('total_score', completedSession.score + (existingLb?.total_score ?? 0))

    // Notify on level up
    if (levelUp && profile.push_token && profile.notifications_enabled) {
      const levelEmoji: Record<string, string> = {
        Silver: '🥈', Gold: '🥇', Platinum: '💎', Legend: '👑',
      }
      const emoji = levelEmoji[levelUp] ?? '⬆️'
      await sendPushNotification(
        profile.push_token,
        `${emoji} Level Up!`,
        `You've reached ${levelUp}. Keep playing to climb higher!`,
        { type: 'level_up', new_level: levelUp },
      )
    }

    return respond({
      session: completedSession,
      correct_count: correctCount,
      xp_earned: xpEarned,
      level_up: levelUp,
      streak: newStreak,
      leaderboard_position: (lbPosition ?? 0) + 1,
    })
  } catch (e) {
    return serverError(e.message)
  }
})
