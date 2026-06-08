-- ============================================================
-- LeagueIQ — Seed: Question of the Day Queue (90 days)
-- Randomly selects one active question per day for 90 days
-- starting from current_date, distributed across all leagues.
-- ============================================================

do $$
declare
  v_start_date date := current_date;
  v_day        integer;
  v_q_id       uuid;
  v_league_ids uuid[] := array[
    '11111111-1111-1111-1111-111111111111',  -- EPL
    '22222222-2222-2222-2222-222222222222',  -- La Liga
    '33333333-3333-3333-3333-333333333333',  -- Serie A
    '44444444-4444-4444-4444-444444444444',  -- Bundesliga
    '55555555-5555-5555-5555-555555555555'   -- Ligue 1
  ];
  v_league_id  uuid;
  v_used_ids   uuid[] := '{}';
begin
  -- Clear any existing future QOTD entries to avoid conflicts
  delete from public.question_of_the_day
  where date >= current_date;

  for v_day in 0..89 loop
    -- Rotate through leagues evenly (day 0=EPL, 1=La Liga, 2=Serie A, 3=Bundesliga, 4=Ligue 1, repeat)
    v_league_id := v_league_ids[(v_day % 5) + 1];

    -- Pick a random active question from this league that hasn't been used yet
    select q.id into v_q_id
    from public.questions q
    where q.league_id = v_league_id
      and q.is_active = true
      and q.id != all(v_used_ids)
    order by random()
    limit 1;

    -- If we exhausted questions for this league, reset the used list for it and retry
    if v_q_id is null then
      -- Remove only this league's used IDs from the exclusion list
      select array_agg(uid) into v_used_ids
      from unnest(v_used_ids) as uid
      where uid not in (
        select id from public.questions where league_id = v_league_id
      );

      select q.id into v_q_id
      from public.questions q
      where q.league_id = v_league_id
        and q.is_active = true
        and q.id != all(coalesce(v_used_ids, '{}'))
      order by random()
      limit 1;
    end if;

    -- Insert QOTD entry if a question was found
    if v_q_id is not null then
      insert into public.question_of_the_day (question_id, date)
      values (v_q_id, v_start_date + v_day)
      on conflict (date) do update
        set question_id = excluded.question_id;

      -- Track used question to avoid repeats
      v_used_ids := array_append(v_used_ids, v_q_id);
    end if;

    v_q_id := null;
  end loop;

  raise notice 'QOTD queue seeded: 90 entries from % to %',
    v_start_date, v_start_date + 89;
end;
$$;
