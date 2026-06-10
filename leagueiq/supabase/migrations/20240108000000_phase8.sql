-- Phase 8: Admin Panel
alter table public.profiles
  add column if not exists is_banned boolean not null default false;

-- Admins can update any profile (role promotion + banning)
create policy "Admins can update any profile"
  on public.profiles for update
  using (
    exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin')
  );

-- Admins can manage clubs
create policy "Admins can manage clubs"
  on public.clubs for all
  using (
    exists (select 1 from public.profiles where id = auth.uid() and role = 'admin')
  );
