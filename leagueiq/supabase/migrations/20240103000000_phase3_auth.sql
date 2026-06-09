-- ============================================================
-- LeagueIQ — Phase 3: Auth & Onboarding
-- ============================================================

-- Add onboarding fields to profiles
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS preferred_league_id uuid REFERENCES public.leagues(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS onboarding_completed boolean NOT NULL DEFAULT false;

-- Update profile trigger to handle OAuth providers (Google avatar, unique username)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  _username text;
  _avatar   text;
BEGIN
  _username := COALESCE(
    new.raw_user_meta_data->>'username',
    split_part(new.email, '@', 1),
    'user_' || substr(new.id::text, 1, 8)
  );

  _avatar := COALESCE(
    new.raw_user_meta_data->>'avatar_url',
    new.raw_user_meta_data->>'picture'
  );

  -- Ensure uniqueness on collision (e.g. duplicate email prefixes)
  WHILE EXISTS (SELECT 1 FROM public.profiles WHERE username = _username) LOOP
    _username := _username || '_' || substr(gen_random_uuid()::text, 1, 4);
  END LOOP;

  INSERT INTO public.profiles (id, username, avatar_url)
  VALUES (new.id, _username, _avatar)
  ON CONFLICT (id) DO NOTHING;

  RETURN new;
END;
$$;
