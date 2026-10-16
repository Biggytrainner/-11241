-- คลังอุปกรณ์ทางกายภาพบำบัด: ฐานข้อมูลกลาง Supabase (ไม่ใช้หน้า Login)
-- คำเตือน: policy นี้เปิดให้ผู้ที่มี URL เว็บและ anon key อ่าน/เขียนข้อมูลได้
-- ห้ามใช้กับข้อมูลผู้ป่วยหรือข้อมูลอ่อนไหวจนกว่าจะเพิ่มระบบยืนยันตัวตนและสิทธิ์ที่เหมาะสม
create table if not exists public.app_state (
  id text primary key check (id = 'main'),
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.app_state enable row level security;

drop policy if exists "authenticated users can read app state" on public.app_state;
drop policy if exists "authenticated users can insert app state" on public.app_state;
drop policy if exists "authenticated users can update app state" on public.app_state;
drop policy if exists "public can read app state" on public.app_state;
drop policy if exists "public can insert app state" on public.app_state;
drop policy if exists "public can update app state" on public.app_state;

create policy "public can read app state"
  on public.app_state for select to anon, authenticated using (true);
create policy "public can insert app state"
  on public.app_state for insert to anon, authenticated with check (true);
create policy "public can update app state"
  on public.app_state for update to anon, authenticated using (true) with check (true);

grant select, insert, update on public.app_state to anon, authenticated;
