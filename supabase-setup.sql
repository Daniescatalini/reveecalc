-- Rode este arquivo no Supabase em SQL Editor > New query.
-- Ele cria uma tabela para cada pessoa salvar os dados da calculadora.

create table if not exists public.calculator_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  email text,
  full_name text,
  app_state jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.calculator_profiles enable row level security;

drop policy if exists "Users can read their calculator profile" on public.calculator_profiles;
create policy "Users can read their calculator profile"
on public.calculator_profiles
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert their calculator profile" on public.calculator_profiles;
create policy "Users can insert their calculator profile"
on public.calculator_profiles
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update their calculator profile" on public.calculator_profiles;
create policy "Users can update their calculator profile"
on public.calculator_profiles
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
