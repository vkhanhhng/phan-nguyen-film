-- Phan Nguyen Film: run once in Supabase → SQL Editor → New query → Run.

create table if not exists public.works (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  client      text not null default '',
  year        int,
  format      text not null default 'horizontal' check (format in ('horizontal','vertical')),
  category    text not null default 'commercials' check (category in ('commercials','music-video','films')),
  video_url   text not null default '',
  youtube_id  text not null default '',
  thumb_url   text not null default '',
  credits     text not null default '',
  featured    boolean not null default false,
  sort_order  numeric not null default 0,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Everyone can read; only signed-in admins can change anything.
alter table public.works enable row level security;
drop policy if exists "works are public" on public.works;
create policy "works are public" on public.works for select using (true);
drop policy if exists "admins manage works" on public.works;
create policy "admins manage works" on public.works for all to authenticated using (true) with check (true);

-- Public bucket for custom thumbnails; only admins can upload or delete.
insert into storage.buckets (id, name, public) values ('thumbs', 'thumbs', true) on conflict (id) do nothing;
drop policy if exists "thumbs are public" on storage.objects;
create policy "thumbs are public" on storage.objects for select using (bucket_id = 'thumbs');
drop policy if exists "admins upload thumbs" on storage.objects;
create policy "admins upload thumbs" on storage.objects for insert to authenticated with check (bucket_id = 'thumbs');
drop policy if exists "admins edit thumbs" on storage.objects;
create policy "admins edit thumbs" on storage.objects for update to authenticated using (bucket_id = 'thumbs');
drop policy if exists "admins delete thumbs" on storage.objects;
create policy "admins delete thumbs" on storage.objects for delete to authenticated using (bucket_id = 'thumbs');

-- The 48 videos from the prototype (only inserted if the table is empty).
insert into public.works (title, client, year, format, category, video_url, youtube_id, thumb_url, credits, featured, sort_order)
select * from (values
  ($q$Velia P - Ride The City | Espero$q$, $q$Espero$q$, 2026, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=s5bQCgL9ZcQ$q$, $q$s5bQCgL9ZcQ$q$, $q$https://i.ytimg.com/vi/s5bQCgL9ZcQ/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, true, 1),
  ($q$Kokomi 90 | Masan$q$, $q$Masan$q$, 2026, $q$vertical$q$, $q$commercials$q$, $q$https://www.tiktok.com/@kokomi.vietnam/video/7656771591061196040?is_from_webapp=1&sender_device=pc&web_id=7653485076936787464$q$, $q$$q$, $q$$q$, $q$Director: Phan Nguyen$q$, false, 2),
  ($q$Mason Nguyen | Vi Vu ft. CongB, Wokeup$q$, $q$Mason Nguyen$q$, 2026, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=VEptnVyCHQs$q$, $q$VEptnVyCHQs$q$, $q$https://i.ytimg.com/vi/VEptnVyCHQs/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, true, 3),
  ($q$Thach Thuc Ga Khong Lo ft. Hoang Xuan Vinh | DFIW 2025$q$, $q$DFIW 2025$q$, 2025, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=u9DthQPJYP4$q$, $q$u9DthQPJYP4$q$, $q$https://i.ytimg.com/vi/u9DthQPJYP4/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, true, 4),
  ($q$Giao Nhanh Ma Ve Nha | Giao Hang Nhanh$q$, $q$Giao Hang Nhanh$q$, 2025, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=KgfkNtlwRkg&t=96s$q$, $q$KgfkNtlwRkg$q$, $q$https://i.ytimg.com/vi/KgfkNtlwRkg/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, true, 5),
  ($q$Rapid Lofi | DFIW 2025$q$, $q$DFIW 2025$q$, 2025, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=fXBqMHDGICw$q$, $q$fXBqMHDGICw$q$, $q$https://i.ytimg.com/vi/fXBqMHDGICw/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 6),
  ($q$DT-67 | Espero$q$, $q$Espero$q$, 2025, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=eF5_ofQP2Gg$q$, $q$eF5_ofQP2Gg$q$, $q$https://i.ytimg.com/vi/eF5_ofQP2Gg/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 7),
  ($q$Classic Plus | Espero$q$, $q$Espero$q$, 2025, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=qCsK3pHHdkE$q$, $q$qCsK3pHHdkE$q$, $q$https://i.ytimg.com/vi/qCsK3pHHdkE/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 8),
  ($q$12 Months Replay | Dropbox$q$, $q$Dropbox$q$, 2025, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=Gd0dT7EfTGM&t=16s$q$, $q$Gd0dT7EfTGM$q$, $q$https://i.ytimg.com/vi/Gd0dT7EfTGM/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, true, 9),
  ($q$Services | KienlongBank$q$, $q$KienlongBank$q$, 2025, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=zIiF5QYm5nQ&t=18s$q$, $q$zIiF5QYm5nQ$q$, $q$https://i.ytimg.com/vi/zIiF5QYm5nQ/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 10),
  ($q$Cinematic B-Roll ft. Contentory | Viettel Store$q$, $q$Viettel Store$q$, 2025, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=3wrcsM4JIt0$q$, $q$3wrcsM4JIt0$q$, $q$https://i.ytimg.com/vi/3wrcsM4JIt0/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 11),
  ($q$Trigger | 66$q$, $q$66$q$, 2025, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=zsiCuBVToU4$q$, $q$zsiCuBVToU4$q$, $q$https://i.ytimg.com/vi/zsiCuBVToU4/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 12),
  ($q$New Carnival | Kia$q$, $q$Kia$q$, 2025, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=OHJal28y4YU$q$, $q$OHJal28y4YU$q$, $q$https://i.ytimg.com/vi/OHJal28y4YU/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, true, 13),
  ($q$Sportage | Kia$q$, $q$Kia$q$, 2025, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=Jzqgeok6H9Y$q$, $q$Jzqgeok6H9Y$q$, $q$https://i.ytimg.com/vi/Jzqgeok6H9Y/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 14),
  ($q$Pizza Sushi Shrimp & Beefsteak Cheese | Pizza Hut$q$, $q$Pizza Hut$q$, 2025, $q$vertical$q$, $q$commercials$q$, $q$https://youtube.com/shorts/1uVFLoCM9pM?si=J4tQTvC5FD1pLM3v$q$, $q$1uVFLoCM9pM$q$, $q$https://i.ytimg.com/vi/1uVFLoCM9pM/oardefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 15),
  ($q$Year End Party Pizza | Pizza Hut$q$, $q$Pizza Hut$q$, 2025, $q$vertical$q$, $q$commercials$q$, $q$https://youtube.com/shorts/l1Qy2JGlvg0?si=aQvUO94k0in7Qsp0$q$, $q$l1Qy2JGlvg0$q$, $q$https://i.ytimg.com/vi/l1Qy2JGlvg0/oardefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 16),
  ($q$Festival Pizza | Pizza Hut$q$, $q$Pizza Hut$q$, 2025, $q$vertical$q$, $q$commercials$q$, $q$https://youtube.com/shorts/x87U3pgAfD8?si=7NSo8Cn1XPD9jvTx$q$, $q$x87U3pgAfD8$q$, $q$https://i.ytimg.com/vi/x87U3pgAfD8/oardefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 17),
  ($q$It's Time? Eat Timeee!!!! | Pizza Hut$q$, $q$Pizza Hut$q$, 2025, $q$vertical$q$, $q$commercials$q$, $q$https://www.facebook.com/share/r/1HifhLksQN/$q$, $q$$q$, $q$$q$, $q$Director: Phan Nguyen$q$, false, 18),
  ($q$Pizza Kid | Pizza Hut$q$, $q$Pizza Hut$q$, 2025, $q$vertical$q$, $q$commercials$q$, $q$https://www.facebook.com/share/r/1CPGxYkQA4/$q$, $q$$q$, $q$$q$, $q$Director: Phan Nguyen$q$, false, 19),
  ($q$Pizza Bear | Pizza Hut$q$, $q$Pizza Hut$q$, 2025, $q$vertical$q$, $q$commercials$q$, $q$https://www.facebook.com/share/r/19hMKeugq8/$q$, $q$$q$, $q$$q$, $q$Director: Phan Nguyen$q$, false, 20),
  ($q$Phat Huy T4 | Ngay Binh Thuong Quen Nguoi Minh Thuong$q$, $q$Phat Huy T4$q$, 2025, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=Mkwgq9NssAA$q$, $q$Mkwgq9NssAA$q$, $q$https://i.ytimg.com/vi/Mkwgq9NssAA/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 21),
  ($q$Phan Linh ft. Ngoc | Nguoi Binh Thuong$q$, $q$Phan Linh ft. Ngoc$q$, 2024, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=XgNvimMAyg4$q$, $q$XgNvimMAyg4$q$, $q$https://i.ytimg.com/vi/XgNvimMAyg4/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 22),
  ($q$Nuoc Mat Tinh Yeu$q$, $q$$q$, 2024, $q$vertical$q$, $q$films$q$, $q$https://youtube.com/shorts/-DuHoPmH6Eo$q$, $q$-DuHoPmH6Eo$q$, $q$https://i.ytimg.com/vi/-DuHoPmH6Eo/oardefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 23),
  ($q$House Rule | BHD Cinema$q$, $q$BHD Cinema$q$, 2023, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=5jaDagWG5S8&t=1s$q$, $q$5jaDagWG5S8$q$, $q$https://i.ytimg.com/vi/5jaDagWG5S8/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 24),
  ($q$J&T Stories | J&T Express$q$, $q$J&T Express$q$, 2023, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=2Nu3bop-dY4$q$, $q$2Nu3bop-dY4$q$, $q$https://i.ytimg.com/vi/2Nu3bop-dY4/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 25),
  ($q$Tet Holiday | J&T Express$q$, $q$J&T Express$q$, 2023, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=YiqG_EvnFWs$q$, $q$YiqG_EvnFWs$q$, $q$https://i.ytimg.com/vi/YiqG_EvnFWs/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 26),
  ($q$Liz Kim Cuong x Do Hieu | Kho Mo De Dong$q$, $q$Liz Kim Cuong x Do Hieu$q$, 2023, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=HkWqCME7wds$q$, $q$HkWqCME7wds$q$, $q$https://i.ytimg.com/vi/HkWqCME7wds/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 27),
  ($q$Dang Quan Pino | Dung Lo Da Co Anh Day (Dance)$q$, $q$Dang Quan Pino$q$, 2023, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=Y0URHFgBggk$q$, $q$Y0URHFgBggk$q$, $q$https://i.ytimg.com/vi/Y0URHFgBggk/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 28),
  ($q$Dang Quan Pino | Sau Chia Tay (Remake)$q$, $q$Dang Quan Pino$q$, 2023, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=GmnJFLAZqbc$q$, $q$GmnJFLAZqbc$q$, $q$https://i.ytimg.com/vi/GmnJFLAZqbc/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 29),
  ($q$Bac Si Hanh Phuc (Good Doctor)$q$, $q$$q$, 2023, $q$horizontal$q$, $q$films$q$, $q$https://www.youtube.com/watch?v=ZW2RYdq0Zi0$q$, $q$ZW2RYdq0Zi0$q$, $q$https://i.ytimg.com/vi/ZW2RYdq0Zi0/maxresdefault.jpg$q$, $q$Assistant Director: Phan Nguyen$q$, false, 30),
  ($q$Saigon River - The Place That Connects Us | An Lam Retreats$q$, $q$An Lam Retreats$q$, 2022, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=qywPlMjJ7Nc&t=1s$q$, $q$qywPlMjJ7Nc$q$, $q$https://i.ytimg.com/vi/qywPlMjJ7Nc/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, true, 31),
  ($q$Van Mai Huong x Chau Dang Khoa x BlackA | Let's Talk About Love$q$, $q$Van Mai Huong x Chau Dang Khoa x BlackA$q$, 2022, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=4IBG227ZooU$q$, $q$4IBG227ZooU$q$, $q$https://i.ytimg.com/vi/4IBG227ZooU/sddefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 32),
  ($q$Quang Ha x Khac Viet | Ngoai Tinh$q$, $q$Quang Ha x Khac Viet$q$, 2022, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=2tU-CUMS6e8$q$, $q$2tU-CUMS6e8$q$, $q$https://i.ytimg.com/vi/2tU-CUMS6e8/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 33),
  ($q$Hoang Duc Thinh & Vuong Anh Tu | May Ma Khong May$q$, $q$Hoang Duc Thinh & Vuong Anh Tu$q$, 2022, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=QaQpa5JvBRI$q$, $q$QaQpa5JvBRI$q$, $q$https://i.ytimg.com/vi/QaQpa5JvBRI/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 34),
  ($q$Jason T & Vuong Anh Tu | Ket Thuc Mo$q$, $q$Jason T & Vuong Anh Tu$q$, 2022, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=A-uTkXbrsHQ$q$, $q$A-uTkXbrsHQ$q$, $q$https://i.ytimg.com/vi/A-uTkXbrsHQ/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 35),
  ($q$Dang Quan Pino | Chang The Yeu Them Ai$q$, $q$Dang Quan Pino$q$, 2022, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=8PSmW-dN6BU$q$, $q$8PSmW-dN6BU$q$, $q$https://i.ytimg.com/vi/8PSmW-dN6BU/sddefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 36),
  ($q$Dang Quan Pino | Anh Van Yeu (Disco Funk Ver.)$q$, $q$Dang Quan Pino$q$, 2022, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=W4Fl4tvB-Ts$q$, $q$W4Fl4tvB-Ts$q$, $q$https://i.ytimg.com/vi/W4Fl4tvB-Ts/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 37),
  ($q$Sofia x Addy Tran | Ai Chung Tinh Duoc Mai (Cover)$q$, $q$Sofia x Addy Tran$q$, 2022, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=M0YZ_Rr-8DI$q$, $q$M0YZ_Rr-8DI$q$, $q$https://i.ytimg.com/vi/M0YZ_Rr-8DI/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 38),
  ($q$Sobe | Lua Chon Mai Sau$q$, $q$Sobe$q$, 2021, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=5kf3zxueJ4s$q$, $q$5kf3zxueJ4s$q$, $q$https://i.ytimg.com/vi/5kf3zxueJ4s/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 39),
  ($q$Pham Dinh Thai Ngan x Annie | Lieu Ta Se (#LTS)$q$, $q$Pham Dinh Thai Ngan x Annie$q$, 2021, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=BAhB0g-tSO0$q$, $q$BAhB0g-tSO0$q$, $q$https://i.ytimg.com/vi/BAhB0g-tSO0/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 40),
  ($q$Sofia x Tilo x Nhi | Nho Nguoi Hay Nho (Remix)$q$, $q$Sofia x Tilo x Nhi$q$, 2021, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=N4NnOiTiA4U$q$, $q$N4NnOiTiA4U$q$, $q$https://i.ytimg.com/vi/N4NnOiTiA4U/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 41),
  ($q$Sofia | Nho Nguoi Hay Nho (Live at Le Jardin)$q$, $q$Sofia$q$, 2021, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=vbfT6rlh2Pw$q$, $q$vbfT6rlh2Pw$q$, $q$https://i.ytimg.com/vi/vbfT6rlh2Pw/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 42),
  ($q$A Journey From Farm To Table | TH true MILK$q$, $q$TH true MILK$q$, 2020, $q$horizontal$q$, $q$commercials$q$, $q$https://www.youtube.com/watch?v=DGn6Ko2BeWM$q$, $q$DGn6Ko2BeWM$q$, $q$https://i.ytimg.com/vi/DGn6Ko2BeWM/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 43),
  ($q$Lynk Lee | Khong Dam$q$, $q$Lynk Lee$q$, 2020, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=KCF7W4J_IFE$q$, $q$KCF7W4J_IFE$q$, $q$https://i.ytimg.com/vi/KCF7W4J_IFE/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 44),
  ($q$IA x Le Thien Hieu | My Stories (#ADEV2)$q$, $q$IA x Le Thien Hieu$q$, 2020, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=qcF-5oTR3rY$q$, $q$qcF-5oTR3rY$q$, $q$https://i.ytimg.com/vi/qcF-5oTR3rY/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 45),
  ($q$Dinh Manh Ninh | Tien Len Viet Nam$q$, $q$Dinh Manh Ninh$q$, 2018, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=SAuyNd5sioA$q$, $q$SAuyNd5sioA$q$, $q$https://i.ytimg.com/vi/SAuyNd5sioA/maxresdefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 46),
  ($q$Lynk Lee | Cho Mot Ngay Nang$q$, $q$Lynk Lee$q$, 2017, $q$horizontal$q$, $q$music-video$q$, $q$https://www.youtube.com/watch?v=jbSb1jdIMpA$q$, $q$jbSb1jdIMpA$q$, $q$https://i.ytimg.com/vi/jbSb1jdIMpA/sddefault.jpg$q$, $q$Director: Phan Nguyen$q$, false, 47),
  ($q$Hanh Phuc Cua Con | Short Film$q$, $q$$q$, 2017, $q$horizontal$q$, $q$films$q$, $q$https://www.facebook.com/share/v/1DcvbWQSHw/$q$, $q$$q$, $q$$q$, $q$Director: Phan Nguyen$q$, false, 48)
) as v(title, client, year, format, category, video_url, youtube_id, thumb_url, credits, featured, sort_order)
where not exists (select 1 from public.works);
