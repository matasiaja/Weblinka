-- ============================================
-- Migracja: zdjęcie produktu (z Open Food Facts)
-- Uruchom raz w Supabase SQL Editor (istniejący projekt)
-- ============================================

alter table products add column if not exists image_url text;
