import { corsHeaders } from '../_shared/cors.ts'
import { adminClient, getToken, respond, unauthorized, badRequest, serverError } from '../_shared/supabase.ts'

// Question counts per mode
const MODE_QUESTION_COUNT: Record<string, number> = {
  quick_play: 5,
  daily_challenge: 10,
  speed_round: 10, // free users; premium users get 20
  category_blitz: 10,
}
const SPEED_ROUND_PREMIUM_COUNT = 20

// Session expiry in minutes per mode
const MODE_EXPIRY_MINUTES: Record<string, number> = {
  quick_play: 10,
  daily_challenge: 20,
  speed_round: 5,
  category_blitz: 10,
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  const token = getToken(req)
  if (!token) return unauthorized()

  const db = adminClient()
  const { data: { user }, error: authErr } = await db.auth.getUser(token)
  if (authErr || !user) return unauthorized()

  try {
    const body = await req.json()
    const { league_id, category_id, mode } = body

    if (!league_id || !mode) return badRequest('league_id and mode are required')
    if (!MODE_QUESTION_COUNT[mode]) return badRequest(`Invalid mode: ${mode}`)

    // Check premium status for modes with tiered question counts
    let isPremium = false
    if (mode === 'speed_round') {
      const { data: profile } = await db.from('profiles').select('is_premium').eq('id', user.id).single()
      isPremium = profile?.is_premium ?? false
    }

    const questionCount = mode === 'speed_round' && isPremium
      ? SPEED_ROUND_PREMIUM_COUNT
      : MODE_QUESTION_COUNT[mode]
    const expiryMinutes = MODE_EXPIRY_MINUTES[mode]

    let questionIds: string[] = []

    if (mode === 'daily_challenge') {
      // Fetch today's daily challenge for this league
      const today = new Date().toISOString().split('T')[0]
      const { data: dc, error: dcErr } = await db
        .from('daily_challenges')
        .select('question_ids')
        .eq('league_id', league_id)
        .eq('date', today)
        .single()

      if (dcErr || !dc) {
        // Auto-generate today's daily challenge
        const { data: qs } = await db
          .from('questions')
          .select('id')
          .eq('league_id', league_id)
          .eq('is_active', true)
          .order('id')
          .limit(200)
        if (!qs || qs.length < 5) return badRequest('Not enough questions for daily challenge')
        const shuffled = qs.map((q) => q.id).sort(() => Math.random() - 0.5)
        questionIds = shuffled.slice(0, Math.min(10, qs.length))
        await db.from('daily_challenges').upsert({
          league_id,
          question_ids: questionIds,
          date: today,
        }, { onConflict: 'league_id,date' })
      } else {
        questionIds = dc.question_ids as string[]
      }
    } else if (mode === 'category_blitz') {
      // 10 random questions across all leagues, no category filter
      const { data: qs } = await db
        .from('questions')
        .select('id')
        .eq('is_active', true)
        .limit(200)
      if (!qs || qs.length < 5) return badRequest('Not enough questions for Category Blitz')
      const shuffled = qs.map((q) => q.id).sort(() => Math.random() - 0.5)
      questionIds = shuffled.slice(0, Math.min(questionCount, qs.length))
    } else {
      // quick_play and speed_round: pick from league + optional category
      let query = db
        .from('questions')
        .select('id')
        .eq('league_id', league_id)
        .eq('is_active', true)

      if (category_id) query = query.eq('category_id', category_id)

      const { data: qs } = await query.limit(300)
      if (!qs || qs.length < 5) {
        return badRequest(`Not enough questions (need at least 5, found ${qs?.length ?? 0})`)
      }
      const shuffled = qs.map((q) => q.id).sort(() => Math.random() - 0.5)
      questionIds = shuffled.slice(0, Math.min(questionCount, qs.length))
    }

    // Fetch full question data (without correct_answer)
    const { data: questions, error: qErr } = await db
      .from('questions')
      .select('id, league_id, category_id, question, options, difficulty, fact, is_active, created_at')
      .in('id', questionIds)

    if (qErr || !questions) return serverError('Failed to fetch questions')

    // Preserve the randomized order
    const orderedQuestions = questionIds
      .map((id) => questions.find((q) => q.id === id))
      .filter(Boolean)

    // Create session
    const expiresAt = new Date(Date.now() + expiryMinutes * 60 * 1000).toISOString()
    const { data: session, error: sessionErr } = await db
      .from('game_sessions')
      .insert({
        user_id: user.id,
        league_id,
        category_id: category_id ?? null,
        mode,
        total_questions: questionIds.length,
        question_ids: questionIds,
        expires_at: expiresAt,
      })
      .select()
      .single()

    if (sessionErr || !session) return serverError('Failed to create session')

    return respond({ session, questions: orderedQuestions })
  } catch (e) {
    return serverError(e.message)
  }
})
