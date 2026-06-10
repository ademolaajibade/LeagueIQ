import { createClient } from '@/lib/supabase/client'
import type {
  StartSessionPayload,
  StartSessionResponse,
  SubmitAnswerPayload,
  SubmitAnswerResponse,
  EndSessionResponse,
  StartSurvivalPayload,
  StartSurvivalResponse,
  SubmitSurvivalPayload,
  SubmitSurvivalResponse,
  CreateMatchPayload,
  CreateMatchResponse,
  CreateChallengePayload,
  CreateChallengeResponse,
  LeaderboardPayload,
  LeaderboardResponse,
  CreatePaymentPayload,
  CreatePaymentResponse,
  VerifyPaymentPayload,
  League,
  Category,
  LeagueMastery,
} from '@/types'

async function invoke<T>(fn: string, body?: object): Promise<T> {
  const supabase = createClient()
  const { data, error } = await supabase.functions.invoke<T>(fn, { body })
  if (error) throw new Error(error.message)
  if (!data) throw new Error(`No data from ${fn}`)
  return data
}

// ── Single-player ─────────────────────────────────────────────

export const startSession = (p: StartSessionPayload) =>
  invoke<StartSessionResponse>('start-session', p)

export const submitAnswer = (p: SubmitAnswerPayload) =>
  invoke<SubmitAnswerResponse>('submit-answer', p)

export const endSession = (sessionId: string) =>
  invoke<EndSessionResponse>('end-session', { session_id: sessionId })

// ── Survival ──────────────────────────────────────────────────

export const startSurvival = (p: StartSurvivalPayload) =>
  invoke<StartSurvivalResponse>('start-survival', p)

export const submitSurvivalAnswer = (p: SubmitSurvivalPayload) =>
  invoke<SubmitSurvivalResponse>('submit-survival-answer', p)

// ── 1v1 ───────────────────────────────────────────────────────

export const createMatch = (p: CreateMatchPayload) =>
  invoke<CreateMatchResponse>('create-match', p)

export const joinMatch = (joinCode: string) =>
  invoke<{ match_id: string }>('join-match', { join_code: joinCode })

export const submitMatchAnswer = (p: {
  match_id: string
  question_id: string
  selected_answer: 0 | 1 | 2 | 3 | null
  time_taken_ms: number
}) => invoke<SubmitAnswerResponse>('submit-match-answer', p)

export const endMatch = (matchId: string) =>
  invoke<{ winner_id: string | null }>('end-match', { match_id: matchId })

// ── Friend challenges ─────────────────────────────────────────

export const createChallenge = (p: CreateChallengePayload) =>
  invoke<CreateChallengeResponse>('create-challenge', p)

export const acceptChallenge = (token: string) =>
  invoke<StartSessionResponse>('accept-challenge', { token })

// ── Tournaments ───────────────────────────────────────────────

export const enterTournament = (tournamentId: string) =>
  invoke<StartSessionResponse>('enter-tournament', { tournament_id: tournamentId })

export const submitTournamentScore = (tournamentId: string, score: number) =>
  invoke<void>('submit-tournament-score', { tournament_id: tournamentId, score })

// ── Content ───────────────────────────────────────────────────

export const getQuestionOfTheDay = () =>
  invoke<{ question: import('@/types').Question }>('question-of-the-day')

export const getDailyChallenge = (leagueId: string) =>
  invoke<StartSessionResponse>('daily-challenge', { league_id: leagueId })

export const getLeaderboard = (p: LeaderboardPayload) =>
  invoke<LeaderboardResponse>('leaderboard', p)

export const getUserStats = () =>
  invoke<{
    games_played: number
    accuracy: number
    best_streak: number
    xp_total: number
    per_league: Record<string, { accuracy: number; games: number }>
  }>('user-stats')

// ── Payments ──────────────────────────────────────────────────

export const createPayment = (p: CreatePaymentPayload) =>
  invoke<CreatePaymentResponse>('create-payment', p)

export const verifyPayment = (p: VerifyPaymentPayload) =>
  invoke<{ verified: boolean; subscription?: unknown }>('verify-payment', p)

export const activateXpBooster = () =>
  invoke<{ xp_booster_expires_at: string }>('activate-xp-booster')

// ── DB helpers ────────────────────────────────────────────────

export async function fetchLeagues(): Promise<League[]> {
  const supabase = createClient()
  const { data, error } = await supabase
    .from('leagues')
    .select('*')
    .order('name')
  if (error) throw error
  return (data ?? []) as League[]
}

export async function fetchCategories(leagueId: string): Promise<Category[]> {
  const supabase = createClient()
  const { data, error } = await supabase
    .from('categories')
    .select('*')
    .eq('league_id', leagueId)
    .order('name')
  if (error) throw error
  return (data ?? []) as Category[]
}

export async function fetchLeagueMastery(userId: string): Promise<LeagueMastery[]> {
  const supabase = createClient()
  const { data, error } = await supabase
    .from('league_mastery')
    .select('*')
    .eq('user_id', userId)
  if (error) throw error
  return (data ?? []) as LeagueMastery[]
}
