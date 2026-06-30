-- ============================================================
-- LeagueIQ — Fixes: streak gate, mastery dedup, weekly reset
-- ============================================================

-- ── Profiles: track the last date the streak was incremented ─
alter table public.profiles
  add column if not exists last_streak_date date;

-- ── League mastery: track which category IDs are completed ───
-- Prevents the same category from counting multiple times.
alter table public.league_mastery
  add column if not exists completed_category_ids jsonb not null default '[]'::jsonb;

-- ── Weekly leaderboard reset ─────────────────────────────────
-- Runs every Monday at 00:00 UTC
-- Requires pg_cron (enabled in phase 9 migration)
select cron.schedule(
  'leagueiq-weekly-leaderboard-reset',
  '0 0 * * 1',
  $$ update public.leaderboard set weekly_score = 0 $$
);
