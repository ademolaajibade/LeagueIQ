-- ============================================================
-- LeagueIQ — Phase 1: Full Schema
-- ============================================================

create extension if not exists "pgcrypto";

-- ============================================================
-- SHARED TRIGGER: updated_at
-- ============================================================
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ============================================================
-- LEAGUES
-- ============================================================
create table public.leagues (
  id           uuid        primary key default gen_random_uuid(),
  slug         text        unique not null,  -- epl | la_liga | serie_a | bundesliga | ligue_1
  name         text        not null,
  accent_color text        not null,
  logo_url     text,
  created_at   timestamptz not null default now()
);

alter table public.leagues enable row level security;

create policy "Leagues are publicly readable"
  on public.leagues for select using (true);

-- ============================================================
-- CLUBS  (for club allegiance on profiles)
-- ============================================================
create table public.clubs (
  id         uuid        primary key default gen_random_uuid(),
  league_id  uuid        not null references public.leagues(id) on delete cascade,
  name       text        not null,
  crest_url  text,
  created_at timestamptz not null default now()
);

create index clubs_league_idx on public.clubs (league_id);

alter table public.clubs enable row level security;

create policy "Clubs are publicly readable"
  on public.clubs for select using (true);

-- ============================================================
-- CATEGORIES
-- ============================================================
create table public.categories (
  id         uuid        primary key default gen_random_uuid(),
  league_id  uuid        not null references public.leagues(id) on delete cascade,
  slug       text        not null,
  name       text        not null,
  created_at timestamptz not null default now(),
  unique (league_id, slug)
);

create index categories_league_idx on public.categories (league_id);

alter table public.categories enable row level security;

create policy "Categories are publicly readable"
  on public.categories for select using (true);

-- ============================================================
-- USER LEVELS  (XP thresholds — Bronze → Silver → Gold → Platinum → Legend)
-- ============================================================
create table public.user_levels (
  id           uuid     primary key default gen_random_uuid(),
  level_name   text     unique not null,
  xp_required  int      not null,
  badge_url    text,
  sort_order   smallint not null
);

alter table public.user_levels enable row level security;

create policy "User levels are publicly readable"
  on public.user_levels for select using (true);

-- ============================================================
-- PROFILES
-- ============================================================
create table public.profiles (
  id            uuid        primary key references auth.users(id) on delete cascade,
  username      text        unique not null,
  avatar_url    text,
  role          text        not null default 'user'   check (role in ('user', 'admin')),
  is_premium    boolean     not null default false,
  xp            int         not null default 0,
  level         text        not null default 'Bronze' check (level in ('Bronze', 'Silver', 'Gold', 'Platinum', 'Legend')),
  streak        int         not null default 0,
  streak_shield boolean     not null default false,
  club_id       uuid        references public.clubs(id) on delete set null,
  push_token    text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Profiles are publicly readable"
  on public.profiles for select using (true);

create policy "Users can update own profile"
  on public.profiles for update using (auth.uid() = id);

create trigger profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- Auto-create profile on new Supabase Auth user
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, username)
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data->>'username',
      split_part(new.email, '@', 1)
    )
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ============================================================
-- QUESTIONS
-- ============================================================
create table public.questions (
  id             uuid        primary key default gen_random_uuid(),
  league_id      uuid        not null references public.leagues(id) on delete cascade,
  category_id    uuid        not null references public.categories(id) on delete cascade,
  question       text        not null,
  options        jsonb       not null,   -- ["A", "B", "C", "D"]
  correct_answer smallint    not null check (correct_answer between 0 and 3),
  difficulty     text        not null check (difficulty in ('easy', 'medium', 'hard')),
  fact           text,                   -- "Did You Know" shown post-answer
  is_active      boolean     not null default true,
  created_at     timestamptz not null default now()
);

create index questions_league_category_idx on public.questions (league_id, category_id);
create index questions_active_idx          on public.questions (is_active) where is_active = true;

alter table public.questions enable row level security;

create policy "Active questions are readable by authenticated users"
  on public.questions for select
  using (is_active = true and auth.role() = 'authenticated');

create policy "Admins can manage questions"
  on public.questions for all
  using (
    exists (select 1 from public.profiles where id = auth.uid() and role = 'admin')
  );

-- ============================================================
-- QUESTION OF THE DAY
-- ============================================================
create table public.question_of_the_day (
  id          uuid        primary key default gen_random_uuid(),
  question_id uuid        not null references public.questions(id) on delete cascade,
  date        date        unique not null,
  created_at  timestamptz not null default now()
);

alter table public.question_of_the_day enable row level security;

create policy "Question of the day is readable by authenticated users"
  on public.question_of_the_day for select using (auth.role() = 'authenticated');

create policy "Admins can manage question of the day"
  on public.question_of_the_day for all
  using (
    exists (select 1 from public.profiles where id = auth.uid() and role = 'admin')
  );

-- ============================================================
-- GAME SESSIONS  (Quick Play, Daily Challenge, Speed Round, Category Blitz)
-- ============================================================
create table public.game_sessions (
  id              uuid        primary key default gen_random_uuid(),
  user_id         uuid        not null references auth.users(id) on delete cascade,
  league_id       uuid        not null references public.leagues(id),
  category_id     uuid        references public.categories(id),
  mode            text        not null check (mode in ('quick_play', 'daily_challenge', 'speed_round', 'category_blitz')),
  status          text        not null default 'active' check (status in ('active', 'completed', 'expired')),
  score           int         not null default 0,
  xp_earned       int         not null default 0,
  total_questions int         not null default 10,
  started_at      timestamptz not null default now(),
  completed_at    timestamptz,
  expires_at      timestamptz not null default (now() + interval '15 minutes')
);

create index game_sessions_user_idx   on public.game_sessions (user_id);
create index game_sessions_status_idx on public.game_sessions (status);

alter table public.game_sessions enable row level security;

create policy "Users can view own sessions"
  on public.game_sessions for select using (auth.uid() = user_id);

create policy "Users can insert own sessions"
  on public.game_sessions for insert with check (auth.uid() = user_id);

create policy "Users can update own sessions"
  on public.game_sessions for update using (auth.uid() = user_id);

-- ============================================================
-- SESSION ANSWERS
-- ============================================================
create table public.session_answers (
  id              uuid        primary key default gen_random_uuid(),
  session_id      uuid        not null references public.game_sessions(id) on delete cascade,
  question_id     uuid        not null references public.questions(id),
  selected_answer smallint,   -- null = timed out
  is_correct      boolean     not null,
  time_taken_ms   int,
  answered_at     timestamptz not null default now(),
  unique (session_id, question_id)
);

create index session_answers_session_idx on public.session_answers (session_id);

alter table public.session_answers enable row level security;

create policy "Users can view answers for own sessions"
  on public.session_answers for select
  using (
    exists (select 1 from public.game_sessions where id = session_id and user_id = auth.uid())
  );

create policy "Users can insert answers for own active sessions"
  on public.session_answers for insert
  with check (
    exists (
      select 1 from public.game_sessions
      where id = session_id and user_id = auth.uid() and status = 'active'
    )
  );

-- ============================================================
-- SURVIVAL SESSIONS
-- ============================================================
create table public.survival_sessions (
  id                 uuid        primary key default gen_random_uuid(),
  user_id            uuid        not null references auth.users(id) on delete cascade,
  league_id          uuid        not null references public.leagues(id),
  questions_survived int         not null default 0,
  ended_at           timestamptz,
  created_at         timestamptz not null default now()
);

create index survival_sessions_user_idx  on public.survival_sessions (user_id);
create index survival_sessions_score_idx on public.survival_sessions (questions_survived desc);

alter table public.survival_sessions enable row level security;

create policy "Survival sessions are publicly readable (for leaderboard)"
  on public.survival_sessions for select using (true);

create policy "Users can insert own survival sessions"
  on public.survival_sessions for insert with check (auth.uid() = user_id);

create policy "Service role can update survival sessions"
  on public.survival_sessions for update using (auth.role() = 'service_role');

-- ============================================================
-- MATCHES  (Head-to-Head 1v1 via Supabase Realtime)
-- ============================================================
create table public.matches (
  id           uuid        primary key default gen_random_uuid(),
  league_id    uuid        not null references public.leagues(id),
  status       text        not null default 'waiting' check (status in ('waiting', 'active', 'completed')),
  question_ids jsonb       not null default '[]',
  player1_id   uuid        not null references auth.users(id),
  player2_id   uuid        references auth.users(id),
  winner_id    uuid        references auth.users(id),
  created_at   timestamptz not null default now()
);

create index matches_player1_idx on public.matches (player1_id);
create index matches_player2_idx on public.matches (player2_id);
create index matches_status_idx  on public.matches (status);

alter table public.matches enable row level security;

create policy "Players can view their matches"
  on public.matches for select
  using (player1_id = auth.uid() or player2_id = auth.uid());

create policy "Service role can manage matches"
  on public.matches for all using (auth.role() = 'service_role');

-- ============================================================
-- MATCH ANSWERS
-- ============================================================
create table public.match_answers (
  id              uuid        primary key default gen_random_uuid(),
  match_id        uuid        not null references public.matches(id) on delete cascade,
  user_id         uuid        not null references auth.users(id),
  question_id     uuid        not null references public.questions(id),
  selected_answer smallint,
  is_correct      boolean     not null,
  time_taken_ms   int,
  answered_at     timestamptz not null default now(),
  unique (match_id, user_id, question_id)
);

create index match_answers_match_idx on public.match_answers (match_id);

alter table public.match_answers enable row level security;

create policy "Players can view answers in their matches"
  on public.match_answers for select
  using (
    exists (
      select 1 from public.matches
      where id = match_id and (player1_id = auth.uid() or player2_id = auth.uid())
    )
  );

create policy "Service role can manage match answers"
  on public.match_answers for all using (auth.role() = 'service_role');

-- ============================================================
-- FRIEND CHALLENGES
-- ============================================================
create table public.friend_challenges (
  id             uuid        primary key default gen_random_uuid(),
  creator_id     uuid        not null references auth.users(id) on delete cascade,
  token          text        unique not null default encode(gen_random_bytes(12), 'hex'),
  league_id      uuid        not null references public.leagues(id),
  category_id    uuid        references public.categories(id),
  question_ids   jsonb       not null default '[]',
  creator_score  int,
  opponent_id    uuid        references auth.users(id),
  opponent_score int,
  created_at     timestamptz not null default now()
);

create index friend_challenges_creator_idx on public.friend_challenges (creator_id);

alter table public.friend_challenges enable row level security;

create policy "Creator and opponent can view their challenges"
  on public.friend_challenges for select
  using (creator_id = auth.uid() or opponent_id = auth.uid());

create policy "Users can create challenges"
  on public.friend_challenges for insert with check (auth.uid() = creator_id);

create policy "Service role can manage friend challenges"
  on public.friend_challenges for all using (auth.role() = 'service_role');

-- ============================================================
-- TOURNAMENTS
-- ============================================================
create table public.tournaments (
  id         uuid        primary key default gen_random_uuid(),
  league_id  uuid        not null references public.leagues(id),
  starts_at  timestamptz not null,
  ends_at    timestamptz not null,
  status     text        not null default 'upcoming' check (status in ('upcoming', 'active', 'completed')),
  created_at timestamptz not null default now()
);

alter table public.tournaments enable row level security;

create policy "Tournaments are publicly readable"
  on public.tournaments for select using (true);

create policy "Admins can manage tournaments"
  on public.tournaments for all
  using (
    exists (select 1 from public.profiles where id = auth.uid() and role = 'admin')
  );

-- ============================================================
-- TOURNAMENT ENTRIES
-- ============================================================
create table public.tournament_entries (
  id            uuid        primary key default gen_random_uuid(),
  tournament_id uuid        not null references public.tournaments(id) on delete cascade,
  user_id       uuid        not null references auth.users(id) on delete cascade,
  score         int         not null default 0,
  completed_at  timestamptz,
  created_at    timestamptz not null default now(),
  unique (tournament_id, user_id)
);

create index tournament_entries_score_idx on public.tournament_entries (tournament_id, score desc);

alter table public.tournament_entries enable row level security;

create policy "Tournament entries are publicly readable"
  on public.tournament_entries for select using (true);

create policy "Users can enter tournaments"
  on public.tournament_entries for insert with check (auth.uid() = user_id);

create policy "Service role can update tournament entries"
  on public.tournament_entries for update using (auth.role() = 'service_role');

-- ============================================================
-- DAILY CHALLENGES
-- ============================================================
create table public.daily_challenges (
  id           uuid        primary key default gen_random_uuid(),
  league_id    uuid        not null references public.leagues(id),
  question_ids jsonb       not null default '[]',
  date         date        not null,
  created_at   timestamptz not null default now(),
  unique (league_id, date)
);

alter table public.daily_challenges enable row level security;

create policy "Daily challenges are publicly readable"
  on public.daily_challenges for select using (true);

create policy "Service role can manage daily challenges"
  on public.daily_challenges for all using (auth.role() = 'service_role');

-- ============================================================
-- LEAGUE MASTERY
-- ============================================================
create table public.league_mastery (
  id                   uuid        primary key default gen_random_uuid(),
  user_id              uuid        not null references auth.users(id) on delete cascade,
  league_id            uuid        not null references public.leagues(id),
  mastery_level        text        not null default 'Rookie' check (mastery_level in ('Rookie', 'Fan', 'Expert', 'Ultras')),
  categories_completed int         not null default 0,
  updated_at           timestamptz not null default now(),
  unique (user_id, league_id)
);

alter table public.league_mastery enable row level security;

create policy "League mastery is publicly readable"
  on public.league_mastery for select using (true);

create policy "Service role can manage league mastery"
  on public.league_mastery for all using (auth.role() = 'service_role');

create trigger league_mastery_updated_at
  before update on public.league_mastery
  for each row execute function public.set_updated_at();

-- ============================================================
-- LEADERBOARD
-- Aggregated per user per league. Global = sum across all leagues (computed in Edge Function).
-- Survival leaderboard is computed directly from survival_sessions.
-- ============================================================
create table public.leaderboard (
  id           uuid        primary key default gen_random_uuid(),
  user_id      uuid        not null references auth.users(id) on delete cascade,
  league_id    uuid        not null references public.leagues(id),
  total_score  int         not null default 0,
  weekly_score int         not null default 0,
  games_played int         not null default 0,
  best_score   int         not null default 0,
  updated_at   timestamptz not null default now(),
  unique (user_id, league_id)
);

create index leaderboard_total_idx  on public.leaderboard (league_id, total_score desc);
create index leaderboard_weekly_idx on public.leaderboard (league_id, weekly_score desc);

alter table public.leaderboard enable row level security;

create policy "Leaderboard is publicly readable"
  on public.leaderboard for select using (true);

create policy "Service role can manage leaderboard"
  on public.leaderboard for all using (auth.role() = 'service_role');

create trigger leaderboard_updated_at
  before update on public.leaderboard
  for each row execute function public.set_updated_at();

-- ============================================================
-- SUBSCRIPTIONS
-- ============================================================
create table public.subscriptions (
  id                 uuid        primary key default gen_random_uuid(),
  user_id            uuid        not null unique references auth.users(id) on delete cascade,
  provider           text        not null default 'paystack',
  plan               text        not null check (plan in ('monthly', 'yearly')),
  status             text        not null check (status in ('active', 'expired', 'cancelled')),
  provider_reference text,
  started_at         timestamptz not null default now(),
  expires_at         timestamptz,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

alter table public.subscriptions enable row level security;

create policy "Users can view own subscription"
  on public.subscriptions for select using (auth.uid() = user_id);

create policy "Service role can manage subscriptions"
  on public.subscriptions for all using (auth.role() = 'service_role');

create trigger subscriptions_updated_at
  before update on public.subscriptions
  for each row execute function public.set_updated_at();
