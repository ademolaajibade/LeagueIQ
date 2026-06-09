-- ============================================================
-- LeagueIQ — Phase 4: Schema additions for Edge Function game logic
-- ============================================================

-- Store which questions belong to each session (security: prevents answer injection)
ALTER TABLE public.game_sessions
  ADD COLUMN IF NOT EXISTS question_ids jsonb NOT NULL DEFAULT '[]';

-- XP booster expiry on profile (premium feature: 2x XP for 24h)
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS xp_booster_expires_at timestamptz;

-- Track seen questions per survival session (avoid repeating questions)
ALTER TABLE public.survival_sessions
  ADD COLUMN IF NOT EXISTS question_ids_seen jsonb NOT NULL DEFAULT '[]';
