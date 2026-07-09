-- ============================================
-- Migracja: podkategorie dla kategorii
-- Uruchom raz w Supabase SQL Editor (istniejący projekt)
-- ============================================

alter table categories drop constraint if exists categories_name_key;
alter table categories add column if not exists parent_id uuid references categories(id) on delete cascade;

create index if not exists categories_parent_idx on categories(parent_id);
create unique index if not exists categories_toplevel_name_uidx on categories(name) where parent_id is null;
create unique index if not exists categories_child_name_uidx on categories(parent_id, name) where parent_id is not null;
