# Weblinka

System inwentaryzacji dla sklepu Wędlinka. Webowa appka (Supabase) do skanowania kodów kreskowych towaru na półce, sprawdzania stanu vs. celu, listy braków do uzupełnienia i eksportu do Excela.

## Funkcje
- Skanowanie kodów kreskowych kamerą telefonu (zakładka "Uzupełnij półkę")
- Podgląd stanu magazynowego z kolorowym statusem (zielony/żółty/czerwony)
- Lista braków posortowana od największego niedoboru
- Eksport do Excela (lista braków lub pełny stan)
- Zarządzanie kategoriami i lokalizacjami
- Logowanie przez Supabase Auth — dostęp tylko dla właściciela

## Stack
- Czysty HTML/JS (jeden plik `index.html`), bez buildu
- [Supabase](https://supabase.com) — baza danych, autoryzacja
- [html5-qrcode](https://github.com/mebjas/html5-qrcode) — skanowanie kodów kreskowych
- [SheetJS](https://sheetjs.com) — eksport do Excela

## Konfiguracja
Baza danych i RLS znajdują się w `schema.sql`. Dane logowania Supabase (URL, anon key) są już wpisane w `index.html`.

## Hosting
Plik `index.html` jest w pełni statyczny — można go hostować na Netlify, Vercel, GitHub Pages lub dowolnym serwerze.
