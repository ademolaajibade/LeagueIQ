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
  is_banned:            boolean
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

export interface LeagueMastery {
  id:                   string
  user_id:              string
  league_id:            string
  mastery_level:        MasteryLevel
  categories_completed: number
  created_at:           string
  updated_at:           string
}

export interface LeaderboardEntry {
  id:           string
  user_id:      string
  league_id:    string | null
  total_score:  number
  weekly_score: number
  rank:         number
  profile?: {
    username:   string
    level:      UserLevel
    avatar_url: string | null
  }
}

// Edge Function payloads / responses

export interface StartSessionPayload {
  league_id:   string
  category_id?: string
  mode:        GameMode
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
  xp_delta:       number
  fact:           string | null
}

export interface EndSessionResponse {
  xp_earned:           number
  total_score:         number
  level_up:            UserLevel | null
  streak:              number
  leaderboard_position: number | null
}

export interface StartSurvivalPayload {
  league_id: string
}

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
  is_correct:     boolean
  correct_answer: 0 | 1 | 2 | 3
  fact:           string | null
  next_question:  Omit<Question, 'correct_answer'> | null
}

export interface CreateMatchPayload {
  league_id: string
}

export interface CreateMatchResponse {
  match_id:  string
  join_code: string
}

export interface CreateChallengePayload {
  league_id:    string
  category_id?: string
}

export interface CreateChallengeResponse {
  token:     string
  share_url: string
}

export interface LeaderboardPayload {
  league_id?: string
  period:     'all_time' | 'weekly' | 'survival'
  limit?:     number
}

export interface LeaderboardResponse {
  entries:           LeaderboardEntry[]
  current_user_rank: number | null
}

export interface CreatePaymentPayload {
  plan: SubPlan
}

export interface CreatePaymentResponse {
  payment_url: string
  reference:   string
}

export interface VerifyPaymentPayload {
  reference: string
}
