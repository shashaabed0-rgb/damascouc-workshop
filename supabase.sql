-- مركز الدمشقي للصيانة: مساحة بيانات مشتركة لجميع الموظفين المسجلين
create table if not exists public.shared_workspace (
  id text primary key check (id = 'main'),
  devices jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.shared_workspace enable row level security;

-- كل مستخدم مسجل يستطيع قراءة وتحديث مساحة المركز المشتركة.
-- لا تمنح هذه السياسات وصولاً لغير المستخدمين المصادق عليهم.
drop policy if exists "authenticated users can read shared workspace" on public.shared_workspace;
create policy "authenticated users can read shared workspace"
  on public.shared_workspace for select to authenticated using (true);

drop policy if exists "authenticated users can create shared workspace" on public.shared_workspace;
create policy "authenticated users can create shared workspace"
  on public.shared_workspace for insert to authenticated with check (true);

drop policy if exists "authenticated users can update shared workspace" on public.shared_workspace;
create policy "authenticated users can update shared workspace"
  on public.shared_workspace for update to authenticated using (true) with check (true);

grant select, insert, update on public.shared_workspace to authenticated;

-- فعّل Realtime للجدول من Supabase Dashboard > Database > Publications
-- إذا لم يكن مضافاً تلقائياً، أضفه إلى publication supabase_realtime.
