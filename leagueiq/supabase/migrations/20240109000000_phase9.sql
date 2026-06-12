-- ============================================================
-- LeagueIQ — Phase 9: Push Notifications
-- ============================================================
-- Before running, set these database settings in Supabase SQL editor:
--   ALTER DATABASE postgres SET app.supabase_url TO 'https://YOUR-REF.supabase.co';
--   ALTER DATABASE postgres SET app.service_role_key TO 'YOUR-SERVICE-ROLE-KEY';
-- ============================================================

-- Enable required extensions
create extension if not exists pg_cron with schema extensions;
create extension if not exists pg_net  with schema extensions;

-- ── Add notifications_enabled to profiles ───────────────────
alter table public.profiles
  add column if not exists notifications_enabled boolean not null default true;

-- ── Helper: dispatch a notification type via Edge Function ──
create or replace function private.dispatch_notification(notification_type text)
returns void language plpgsql security definer as $$
begin
  perform net.http_post(
    url     := current_setting('app.supabase_url', true) || '/functions/v1/send-notifications',
    headers := jsonb_build_object(
      'Content-Type',  'application/json',
      'Authorization', 'Bearer ' || current_setting('app.service_role_key', true)
    ),
    body    := jsonb_build_object('type', notification_type)::text
  );
exception when others then
  -- swallow errors so cron job doesn't fail the whole run
  null;
end;
$$;

-- ── Cron schedules ──────────────────────────────────────────

-- Daily Challenge available — 8am UTC every day
select cron.schedule(
  'leagueiq-daily-challenge-notif',
  '0 8 * * *',
  $$ select private.dispatch_notification('daily_challenge') $$
);

-- Streak at risk — 9pm UTC every day
select cron.schedule(
  'leagueiq-streak-at-risk-notif',
  '0 21 * * *',
  $$ select private.dispatch_notification('streak_at_risk') $$
);

-- Tournament ending soon — Sunday at 6pm UTC
select cron.schedule(
  'leagueiq-tournament-ending-notif',
  '0 18 * * 0',
  $$ select private.dispatch_notification('tournament_ending') $$
);
