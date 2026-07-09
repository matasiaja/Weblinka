-- ============================================
-- Inwentaryzacja sklepu — schemat bazy danych
-- Uruchom to w Supabase SQL Editor po utworzeniu projektu
-- ============================================

create extension if not exists "pgcrypto";

create table categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  parent_id uuid references categories(id) on delete cascade,
  created_at timestamptz default now()
);

create index categories_parent_idx on categories(parent_id);
-- nazwa unikalna wśród kategorii głównych, i osobno wśród podkategorii tego samego rodzica
create unique index categories_toplevel_name_uidx on categories(name) where parent_id is null;
create unique index categories_child_name_uidx on categories(parent_id, name) where parent_id is not null;

create table locations (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_at timestamptz default now()
);

create table products (
  id uuid primary key default gen_random_uuid(),
  barcode text not null unique,
  name text not null,
  category_id uuid references categories(id) on delete set null,
  location_id uuid references locations(id) on delete set null,
  unit text not null default 'szt',
  shelf_target integer not null default 0,     -- ile powinno być na półce
  current_stock integer not null default 0,     -- ile jest teraz (ostatnie liczenie)
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index products_barcode_idx on products(barcode);
create index products_category_idx on products(category_id);
create index products_location_idx on products(location_id);

-- Historia liczeń (audyt tego co się działo przy każdym skanie)
create table stock_checks (
  id uuid primary key default gen_random_uuid(),
  product_id uuid references products(id) on delete cascade,
  counted_stock integer not null,
  target_stock integer not null,
  checked_at timestamptz default now()
);

-- ============================================
-- RLS — dostęp tylko dla zalogowanych (Ty)
-- ============================================
alter table categories enable row level security;
alter table locations enable row level security;
alter table products enable row level security;
alter table stock_checks enable row level security;

create policy "auth_full_access" on categories for all
  to authenticated using (true) with check (true);

create policy "auth_full_access" on locations for all
  to authenticated using (true) with check (true);

create policy "auth_full_access" on products for all
  to authenticated using (true) with check (true);

create policy "auth_full_access" on stock_checks for all
  to authenticated using (true) with check (true);

-- ============================================
-- Auto-update updated_at
-- ============================================
create or replace function set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger trg_products_updated_at
  before update on products
  for each row execute function set_updated_at();
