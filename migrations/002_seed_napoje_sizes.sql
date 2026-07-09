-- ============================================
-- Kategoria "Napoje" z podkategoriami rozmiarów
-- Uruchom po 001_category_subcategories.sql
-- ============================================

insert into categories (name)
values ('Napoje')
on conflict (name) where parent_id is null do nothing;

insert into categories (name, parent_id)
select size, (select id from categories where name = 'Napoje' and parent_id is null)
from (values
  ('0,3l'),
  ('0,33l'),
  ('0,4l'),
  ('0,5l'),
  ('0,7l'),
  ('0,85l'),
  ('1l'),
  ('1,2l'),
  ('1,25l'),
  ('1,5l'),
  ('1,75l'),
  ('2l')
) as sizes(size)
on conflict (parent_id, name) where parent_id is not null do nothing;
