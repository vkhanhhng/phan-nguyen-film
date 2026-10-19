# Phan Nguyen Film

Portfolio site for director Phan Nguyen. Plain static site (no build step) on Vercel, data in Supabase.

- `index.html`: the whole site (home, work, about, admin at `/admin`)
- `js/config.js`: Supabase project URL + anon key (public values)
- `supabase/setup.sql`: run once in Supabase SQL Editor (table, security rules, thumbnail bucket, videos)

Typeface: Jean-Luc by Atelier Carvalho Bernau, http://carvalho-bernau.com, embedded under its freeware licence
(unmodified .otf files; the required notice sits under the @font-face rules in `index.html`).
