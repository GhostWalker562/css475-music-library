-- Playlists
INSERT INTO "playlist" ("id", "name", "created_at", "creator_id") VALUES ('woh6zydz2cm4r9c6lfpk6f5tc33jtvzba1362wg81n5zmbllnn', 'Playlist 0', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sw7ur9xnv28g12afgdiv2lgywon8wzah4i12wf7y0d2pxdh5pk', 'woh6zydz2cm4r9c6lfpk6f5tc33jtvzba1362wg81n5zmbllnn', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('x1jeisgqhdizvhxbc5c9hb3uutz5pz80wa4o12yqsn3oma1iaf', 'woh6zydz2cm4r9c6lfpk6f5tc33jtvzba1362wg81n5zmbllnn', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3vzk5fb5w1qxefq7iy82pq5cdpig9yf4lkyoe8hr1dji9ijto5', 'woh6zydz2cm4r9c6lfpk6f5tc33jtvzba1362wg81n5zmbllnn', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vwr6uv8r990rf02cd9mmtr1rh9dcfdk3ilin4rtdqa6u7hh3o5', 'woh6zydz2cm4r9c6lfpk6f5tc33jtvzba1362wg81n5zmbllnn', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sig7uzt7q6k0l4z50kxrc1eqhxcqen54gcp3s78jd00i3rxeq9', 'woh6zydz2cm4r9c6lfpk6f5tc33jtvzba1362wg81n5zmbllnn', 1);
INSERT INTO "playlist" ("id", "name", "created_at", "creator_id") VALUES ('g2w1u86erll2pb5ph1msrmd5fpkn44m78c7dz1fcm7s7mpzggq', 'Playlist 1', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7l0t0jpcll7zcrqyis2re44tix1p0zwzchl60ksv3u8mh5r4c4', 'g2w1u86erll2pb5ph1msrmd5fpkn44m78c7dz1fcm7s7mpzggq', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('u22oe79s4gqq3a8x86cuzzfkzfv8j6oga05eeb6wnfv5ix7pdf', 'g2w1u86erll2pb5ph1msrmd5fpkn44m78c7dz1fcm7s7mpzggq', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('iy57c5r15qshav24j4yqs19i6ey1sjm7f7udnks32iih2w4ubh', 'g2w1u86erll2pb5ph1msrmd5fpkn44m78c7dz1fcm7s7mpzggq', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('a0q5h0zsdx4d96bg2u5jouiifkm9c40d90jli6q985l3ql3wjo', 'g2w1u86erll2pb5ph1msrmd5fpkn44m78c7dz1fcm7s7mpzggq', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('g3c6knm7k45u0qd79yrpw1pfc39carbdhcpe5t4ehubske0hce', 'g2w1u86erll2pb5ph1msrmd5fpkn44m78c7dz1fcm7s7mpzggq', 3);
-- User Likes
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'z79hm0lvrnsm1m7rb6hl7n5f0xeogdo4xlw2467dkniea52pfn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'sf12f6cbiswrrbql90km7rt9nxjj8cp40yklkecrexoucmjhoc');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '9wpm0ktt8cvq6kcxhtniumm5yi8abkj730p2qzy989w1znmf7e');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'dch7hhq7mid1kgj8i7qvppz8sgis0h6i3l893nyqnkzfi5iya8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'vwr6uv8r990rf02cd9mmtr1rh9dcfdk3ilin4rtdqa6u7hh3o5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'iy57c5r15qshav24j4yqs19i6ey1sjm7f7udnks32iih2w4ubh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'g3jhx8ok64k9vbqji4qbfm84ve0gwvlee2grpf4ypn8uray7dj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '4hacol20ec6he2uouskts6kcdz1cryfrlqy97k2mkej8878q02');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'wmkut41tysv4faghqhdmbiaqt4skd6611nmluhqzi0myqgwopg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'crpzji7v4zwn2d112ijhoio4g6fqb6ggjx9vgwl41e40fsve9p');
-- User Song Recommendations
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('9vr0fsua4l1tb69ttjkdh8t8z6jxa9029tvfjt1blxu61jk9d1', 'icqlt67n2fd7p34', 'xv3idiaovwrzam6ebhiuetdtbshqsab6rofm9qlyndqm5bbs8c', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('20fb3hjs3fr4qwtf8egc44av6nflbmyknw4299twc97npef6a0', 'icqlt67n2fd7p34', 'crpzji7v4zwn2d112ijhoio4g6fqb6ggjx9vgwl41e40fsve9p', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5zzab9f00pju0rlligkmm8j4k2v6i0j26gehjbf07nbgfsd9gf', 'icqlt67n2fd7p34', 'hf346wzw1fmxl4yzljxucikk2erqtmmyj7qgdcg9p84d2qkg56', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('qqliyef0yznpwua4m6bjz4c2b98vwbptfytvyq42arh8y7c6qp', 'icqlt67n2fd7p34', 'h2w3oymnw4qyzzw35hkh044wl26heahry23i8h7jx32qsd4fex', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('deintdhyu1q117h17rlztm8ajx8vcnziv7j532o9yo6au9z03t', 'icqlt67n2fd7p34', 'g3c6knm7k45u0qd79yrpw1pfc39carbdhcpe5t4ehubske0hce', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('30mx7kvrw7a3euz4ugzot0hi3ka336vklgljlksx6jpmsfem6e', 'icqlt67n2fd7p34', '9i95lp3l3j4pki8cu318e151u5qys5yzk494v1gb9sqky51bmc', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0d2lb9u8pyd0piax13l54rkagvxc3ubhrbhvc4cv0jcm76rf77', 'icqlt67n2fd7p34', 'eqrcobm8wbd983y7ehno8rwrt9rnu8d6wkar51jjtwqh3l1a9g', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('axprmarex43uo9i3nsqwkssgv7svdvg92k6ytfh0uvoi82nuuj', 'icqlt67n2fd7p34', 'n6o6ob68jyib3xndrpgm3sojf0xphktl3zdrtslrbxa53tdtzh', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('28ktthr7ewy92ryqfc2fa1h5dgkbkj6bsjgka2u7zm508m6sa9', 'icqlt67n2fd7p34', '7jbv68iw7iy42o54jvqf8tm03qe9ezzoa91g1qhpmrxevu8hua', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('3a482hwb9hlkanpnikre3hir6pdev9k1kjx5p16lrje2uhp1ge', 'icqlt67n2fd7p34', '8lfmibly2ccexw79eqlew66c6n2rmlzv9qybeb3q2udhnfpw4a', '2023-11-17 17:00:08.000');
