-- ============================================================
-- LeagueIQ — Phase 3: Auth Improvements
-- ============================================================

-- Add onboarding tracking and league preference to profiles
alter table public.profiles
  add column if not exists onboarding_completed boolean not null default false,
  add column if not exists preferred_league_id  uuid    references public.leagues(id) on delete set null;

create index if not exists profiles_preferred_league_idx on public.profiles (preferred_league_id);

-- Improved trigger: resolves username conflicts + captures OAuth avatar
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
declare
  base_username  text;
  final_username text;
  counter        int := 0;
begin
  base_username := coalesce(
    nullif(trim(new.raw_user_meta_data->>'username'), ''),
    regexp_replace(split_part(new.email, '@', 1), '[^a-zA-Z0-9_]', '', 'g')
  );

  if length(base_username) < 3 then
    base_username := base_username || '_user';
  end if;

  final_username := base_username;

  -- Resolve any username collisions (e.g. two Google accounts with same email prefix)
  while exists (select 1 from public.profiles where username = final_username) loop
    counter        := counter + 1;
    final_username := base_username || counter::text;
  end loop;

  insert into public.profiles (id, username, avatar_url)
  values (
    new.id,
    final_username,
    coalesce(
      nullif(trim(new.raw_user_meta_data->>'avatar_url'), ''),
      nullif(trim(new.raw_user_meta_data->>'picture'),    '')
    )
  );

  return new;
end;
$$;
