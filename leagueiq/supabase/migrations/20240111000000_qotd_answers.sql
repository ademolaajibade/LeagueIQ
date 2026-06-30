-- Track which QOTD answer each user picked, one per day
create table if not exists qotd_answers (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  question_id uuid not null references questions(id) on delete cascade,
  picked      smallint not null,
  date        date not null default current_date,
  created_at  timestamptz not null default now(),
  unique (user_id, date)
);

alter table qotd_answers enable row level security;

create policy "users manage own qotd answers" on qotd_answers
  for all using (auth.uid() = user_id);
