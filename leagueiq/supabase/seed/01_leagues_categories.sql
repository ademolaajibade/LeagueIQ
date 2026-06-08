-- ============================================================
-- LeagueIQ — Seed: Leagues, Categories, User Levels, Clubs
-- ============================================================

-- ============================================================
-- LEAGUES
-- ============================================================
insert into public.leagues (id, slug, name, accent_color) values
  ('11111111-1111-1111-1111-111111111111', 'epl',        'English Premier League', '#7C3AED'),
  ('22222222-2222-2222-2222-222222222222', 'la_liga',    'La Liga',                '#EF4444'),
  ('33333333-3333-3333-3333-333333333333', 'serie_a',    'Serie A',                '#3B82F6'),
  ('44444444-4444-4444-4444-444444444444', 'bundesliga', 'Bundesliga',             '#EF4444'),
  ('55555555-5555-5555-5555-555555555555', 'ligue_1',    'Ligue 1',                '#1D4ED8')
on conflict (slug) do nothing;

-- ============================================================
-- CATEGORIES (7 per league)
-- ============================================================

-- EPL
insert into public.categories (league_id, slug, name) values
  ('11111111-1111-1111-1111-111111111111', 'club_history',    'Club History'),
  ('11111111-1111-1111-1111-111111111111', 'famous_players',  'Famous Players'),
  ('11111111-1111-1111-1111-111111111111', 'iconic_matches',  'Iconic Matches'),
  ('11111111-1111-1111-1111-111111111111', 'records_stats',   'Records & Stats'),
  ('11111111-1111-1111-1111-111111111111', 'managers',        'Managers'),
  ('11111111-1111-1111-1111-111111111111', 'transfers',       'Transfers'),
  ('11111111-1111-1111-1111-111111111111', 'stadium_culture', 'Stadium & Culture')
on conflict (league_id, slug) do nothing;

-- La Liga
insert into public.categories (league_id, slug, name) values
  ('22222222-2222-2222-2222-222222222222', 'club_history',    'Club History'),
  ('22222222-2222-2222-2222-222222222222', 'famous_players',  'Famous Players'),
  ('22222222-2222-2222-2222-222222222222', 'el_clasico',      'El Clásico'),
  ('22222222-2222-2222-2222-222222222222', 'records_stats',   'Records & Stats'),
  ('22222222-2222-2222-2222-222222222222', 'managers',        'Managers'),
  ('22222222-2222-2222-2222-222222222222', 'transfers',       'Transfers'),
  ('22222222-2222-2222-2222-222222222222', 'stadium_culture', 'Stadium & Culture')
on conflict (league_id, slug) do nothing;

-- Serie A
insert into public.categories (league_id, slug, name) values
  ('33333333-3333-3333-3333-333333333333', 'club_history',    'Club History'),
  ('33333333-3333-3333-3333-333333333333', 'famous_players',  'Famous Players'),
  ('33333333-3333-3333-3333-333333333333', 'derby_classics',  'Derby della Madonnina / Derby d''Italia'),
  ('33333333-3333-3333-3333-333333333333', 'records_stats',   'Records & Stats'),
  ('33333333-3333-3333-3333-333333333333', 'managers',        'Managers'),
  ('33333333-3333-3333-3333-333333333333', 'transfers',       'Transfers'),
  ('33333333-3333-3333-3333-333333333333', 'stadium_culture', 'Stadium & Culture')
on conflict (league_id, slug) do nothing;

-- Bundesliga
insert into public.categories (league_id, slug, name) values
  ('44444444-4444-4444-4444-444444444444', 'club_history',    'Club History'),
  ('44444444-4444-4444-4444-444444444444', 'famous_players',  'Famous Players'),
  ('44444444-4444-4444-4444-444444444444', 'der_klassiker',   'Der Klassiker'),
  ('44444444-4444-4444-4444-444444444444', 'records_stats',   'Records & Stats'),
  ('44444444-4444-4444-4444-444444444444', 'managers',        'Managers'),
  ('44444444-4444-4444-4444-444444444444', 'transfers',       'Transfers'),
  ('44444444-4444-4444-4444-444444444444', 'stadium_culture', 'Stadium & Culture')
on conflict (league_id, slug) do nothing;

-- Ligue 1
insert into public.categories (league_id, slug, name) values
  ('55555555-5555-5555-5555-555555555555', 'club_history',    'Club History'),
  ('55555555-5555-5555-5555-555555555555', 'famous_players',  'Famous Players'),
  ('55555555-5555-5555-5555-555555555555', 'le_classique',    'Le Classique'),
  ('55555555-5555-5555-5555-555555555555', 'records_stats',   'Records & Stats'),
  ('55555555-5555-5555-5555-555555555555', 'managers',        'Managers'),
  ('55555555-5555-5555-5555-555555555555', 'transfers',       'Transfers'),
  ('55555555-5555-5555-5555-555555555555', 'stadium_culture', 'Stadium & Culture')
on conflict (league_id, slug) do nothing;

-- ============================================================
-- USER LEVELS
-- ============================================================
insert into public.user_levels (level_name, xp_required, sort_order) values
  ('Bronze',   0,    1),
  ('Silver',   500,  2),
  ('Gold',     1500, 3),
  ('Platinum', 3500, 4),
  ('Legend',   7500, 5)
on conflict (level_name) do nothing;

-- ============================================================
-- CLUBS
-- Sample clubs per league for club allegiance picker.
-- Extend this list in Phase 2 seeding.
-- ============================================================

-- EPL
insert into public.clubs (league_id, name) values
  ('11111111-1111-1111-1111-111111111111', 'Arsenal'),
  ('11111111-1111-1111-1111-111111111111', 'Aston Villa'),
  ('11111111-1111-1111-1111-111111111111', 'Chelsea'),
  ('11111111-1111-1111-1111-111111111111', 'Everton'),
  ('11111111-1111-1111-1111-111111111111', 'Liverpool'),
  ('11111111-1111-1111-1111-111111111111', 'Manchester City'),
  ('11111111-1111-1111-1111-111111111111', 'Manchester United'),
  ('11111111-1111-1111-1111-111111111111', 'Newcastle United'),
  ('11111111-1111-1111-1111-111111111111', 'Tottenham Hotspur'),
  ('11111111-1111-1111-1111-111111111111', 'West Ham United');

-- La Liga
insert into public.clubs (league_id, name) values
  ('22222222-2222-2222-2222-222222222222', 'Athletic Club'),
  ('22222222-2222-2222-2222-222222222222', 'Atlético de Madrid'),
  ('22222222-2222-2222-2222-222222222222', 'FC Barcelona'),
  ('22222222-2222-2222-2222-222222222222', 'Getafe CF'),
  ('22222222-2222-2222-2222-222222222222', 'Girona FC'),
  ('22222222-2222-2222-2222-222222222222', 'Real Betis'),
  ('22222222-2222-2222-2222-222222222222', 'Real Madrid'),
  ('22222222-2222-2222-2222-222222222222', 'Real Sociedad'),
  ('22222222-2222-2222-2222-222222222222', 'Sevilla FC'),
  ('22222222-2222-2222-2222-222222222222', 'Villarreal CF');

-- Serie A
insert into public.clubs (league_id, name) values
  ('33333333-3333-3333-3333-333333333333', 'AC Milan'),
  ('33333333-3333-3333-3333-333333333333', 'AS Roma'),
  ('33333333-3333-3333-3333-333333333333', 'Atalanta BC'),
  ('33333333-3333-3333-3333-333333333333', 'Bologna FC'),
  ('33333333-3333-3333-3333-333333333333', 'Fiorentina'),
  ('33333333-3333-3333-3333-333333333333', 'Inter Milan'),
  ('33333333-3333-3333-3333-333333333333', 'Juventus'),
  ('33333333-3333-3333-3333-333333333333', 'Lazio'),
  ('33333333-3333-3333-3333-333333333333', 'Napoli'),
  ('33333333-3333-3333-3333-333333333333', 'Torino FC');

-- Bundesliga
insert into public.clubs (league_id, name) values
  ('44444444-4444-4444-4444-444444444444', 'Bayer Leverkusen'),
  ('44444444-4444-4444-4444-444444444444', 'Bayern Munich'),
  ('44444444-4444-4444-4444-444444444444', 'Borussia Dortmund'),
  ('44444444-4444-4444-4444-444444444444', 'Borussia Mönchengladbach'),
  ('44444444-4444-4444-4444-444444444444', 'Eintracht Frankfurt'),
  ('44444444-4444-4444-4444-444444444444', 'Hoffenheim'),
  ('44444444-4444-4444-4444-444444444444', 'RB Leipzig'),
  ('44444444-4444-4444-4444-444444444444', 'SC Freiburg'),
  ('44444444-4444-4444-4444-444444444444', 'VfB Stuttgart'),
  ('44444444-4444-4444-4444-444444444444', 'Wolfsburg');

-- Ligue 1
insert into public.clubs (league_id, name) values
  ('55555555-5555-5555-5555-555555555555', 'AS Monaco'),
  ('55555555-5555-5555-5555-555555555555', 'Lens'),
  ('55555555-5555-5555-5555-555555555555', 'Lille OSC'),
  ('55555555-5555-5555-5555-555555555555', 'Lyon'),
  ('55555555-5555-5555-5555-555555555555', 'Marseille'),
  ('55555555-5555-5555-5555-555555555555', 'Montpellier'),
  ('55555555-5555-5555-5555-555555555555', 'Nice'),
  ('55555555-5555-5555-5555-555555555555', 'Paris Saint-Germain'),
  ('55555555-5555-5555-5555-555555555555', 'Rennes'),
  ('55555555-5555-5555-5555-555555555555', 'Strasbourg');
