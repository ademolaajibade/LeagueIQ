-- Phase 7: Monetization — webhook_events log table

create table public.webhook_events (
  id          uuid        primary key default gen_random_uuid(),
  provider    text        not null,
  event_type  text        not null,
  payload     jsonb,
  created_at  timestamptz not null default now()
);

-- Service role only — no user-facing reads needed
alter table public.webhook_events enable row level security;

create policy "Service role can manage webhook_events"
  on public.webhook_events for all using (auth.role() = 'service_role');

-- Index for debugging by event type
create index webhook_events_event_type_idx on public.webhook_events(event_type);
create index webhook_events_created_at_idx on public.webhook_events(created_at desc);
