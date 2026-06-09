// Mirror of root types/index.ts — keep in sync when root changes

export type LeagueSlug       = 'epl' | 'la_liga' | 'serie_a' | 'bundesliga' | 'ligue_1'
export type Difficulty       = 'easy' | 'medium' | 'hard'
export type GameMode         = 'quick_play' | 'daily_challenge' | 'speed_round' | 'category_blitz'
export type SessionStatus    = 'active' | 'completed' | 'expired'
export type MatchStatus      = 'waiting' | 'active' | 'completed'
export type TournamentStatus = 'upcoming' | 'active' | 'completed'
export type MasteryLevel     = 'Rookie' | 'Fan' | 'Expert' | 'Ultras👑'
export type UserLevel        = 'Bronze' | 'Silver' | 'Gold' | 'Platinum' | 'Legend'
export type UserRole         = 'user' | 'admin'
export type SubPlan          = 'monthly' | 'yearly'
export type SubStatus        = 'active' | 'expired' | 'cancelled'

export interface League {
  id:           string
  slug:         LeagueSlug
  name:         string
  accent_color: string
  logo_url:     string | null
  created_at:   string
}

export interface Club {
  id:         string
  league_id:  string
  name:       string
  crest_url:  string | null
  created_at: string
}

export interface Category {
  id:         string
  league_id:  string
  slug:       string
  name:       string
  created_at: string
}

export interface UserLevelConfig {
  id:          string
  level_name:  UserLevel
  xp_required: number
  badge_url:   string | null
  sort_order:  number
}

export interface Profile {
  id:                   string
  username:             string
  avatar_url:           string | null
  role:                 UserRole
  is_premium:           boolean
  xp:                   number
  level:                UserLevel
  streak:               number
  streak_shield:        boolean
  club_id:              string | null
  preferred_league_id:  string | null
  onboarding_completed: boolean
  push_token:           string | null
  created_at:           string
  updated_at:           string
}

export interface Question {
  id:             string
  league_id:      string
  category_id:    string
  question:       string
  options:        [string, string, string, string]
  correct_answer: 0 | 1 | 2 | 3
  difficulty:     Difficulty
  fact:           string | null
  is_active:      boolean
  created_at:     string
}

export interface QuestionOfTheDay {
  id:          string
  question_id: string
  date:        string
  created_at:  string
  question?:   Question
}

export interface GameSession {
  id:              string
  user_id:         string
  league_id:       string
  category_id:     string | null
  mode:            GameMode
  status:          SessionStatus
  score:           number
  xp_earned:       number
  total_questions: number
  started_at:      string
  completed_at:    string | null
  expires_at:      string
}

export interface SessionAnswer {
  id:              string
  session_id:      string
  question_id:     string
  selected_answer: 0 | 1 | 2 | 3 | null
  is_correct:      boolean
  time_taken_ms:   number | null
  answered_at:     string
}

export interface SurvivalSession {
  id:                 string
  user_id:            string
  league_id:          string
  questions_survived: number
  ended_at:           string | null
  created_at:         string
}

export interface Match {
  id:           string
  league_id:    string
  status:       MatchStatus
  question_ids: string[]
  player1_id:   string
  player2_id:   string | null
  winner_id:    string | null
  created_at:   string
}

export interface MatchAnswer {
  id:              string
  match_id:        string
  user_id:         string
  question_id:     string
  selected_answer: 0 | 1 | 2 | 3 | null
  is_correct:      boolean
  time_taken_ms:   number | null
  answered_at:     string
}

export interface FriendChallenge {
  id:             string
  creator_id:     string
  token:          string
  league_id:      string
  category_id:    string | null
  question_ids:   string[]
  creator_score:  number | null
  opponent_id:    string | null
  opponent_score: number | null
  created_at:     string
}

export interface Tournament {
  id:         string
  league_id:  string
  starts_at:  string
  ends_at:    string
  status:     TournamentStatus
  created_at: string
}

export interface TournamentEntry {
  id:            string
  tournament_id: string
  user_id:       string
  score:         number
  completed_at:  string | null
  created_at:    string
}

export interface LeagueMastery {
  id:                   string
  user_id:              string
  league_id:            string
  mastery_level:        MasteryLevel
  categories_completed: number
  updated_at:           string
}

export interface LeaderboardEntry {
  id:           string
  user_id:      string
  league_id:    string
  total_score:  number
  weekly_score: number
  games_played: number
  best_score:   number
  updated_at:   string
  profile?:     Pick<Profile, 'username' | 'avatar_url' | 'level' | 'club_id'>
}

export interface Subscription {
  id:                 string
  user_id:            string
  provider:           string
  plan:               SubPlan
  status:             SubStatus
  provider_reference: string | null
  started_at:         string
  expires_at:         string | null
  created_at:         string
  updated_at:         string
}

export interface DailyChallenge {
  id:           string
  league_id:    string
  question_ids: string[]
  date:         string
  created_at:   string
}

// ── Edge Function Payloads ────────────────────────────────────

export interface StartSessionPayload {
  league_id:    string
  category_id?: string
  mode:         GameMode
}
export interface StartSessionResponse {
  session:   GameSession
  questions: Omit<Question, 'correct_answer'>[]
}

export interface SubmitAnswerPayload {
  session_id:      string
  question_id:     string
  selected_answer: 0 | 1 | 2 | 3 | null
  time_taken_ms:   number
}
export interface SubmitAnswerResponse {
  is_correct:     boolean
  correct_answer: 0 | 1 | 2 | 3
  fact:           string | null
  score:          number
  xp_earned:      number
}

export interface EndSessionResponse {
  session:              GameSession
  correct_count:        number
  xp_earned:            number
  level_up:             UserLevel | null
  streak:               number
  leaderboard_position: number | null
}

export interface StartSurvivalPayload { league_id: string }
export interface StartSurvivalResponse {
  session_id: string
  question:   Omit<Question, 'correct_answer'>
}

export interface SubmitSurvivalPayload {
  session_id:      string
  question_id:     string
  selected_answer: 0 | 1 | 2 | 3 | null
  time_taken_ms:   number
}
export interface SubmitSurvivalResponse {
  is_correct:         boolean
  correct_answer:     0 | 1 | 2 | 3
  fact:               string | null
  questions_survived: number
  next_question:      Omit<Question, 'correct_answer'> | null
}

export interface CreateMatchPayload  { league_id: string }
export interface CreateMatchResponse { match_id: string; join_code: string }

export interface CreateChallengePayload  { league_id: string; category_id?: string }
export interface CreateChallengeResponse { token: string; deep_link: string }

export interface LeaderboardPayload {
  league_id?: string
  period?:    'all_time' | 'weekly' | 'survival'
  limit?:     number
}
export interface LeaderboardResponse {
  entries:           (LeaderboardEntry & { rank: number })[]
  current_user_rank: number | null
}

export interface CreatePaymentPayload  { plan: SubPlan }
export interface CreatePaymentResponse { payment_url: string; reference: string }

export interface VerifyPaymentPayload { reference: string }
