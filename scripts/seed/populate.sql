-- File: create_tables.sql
DROP TABLE IF EXISTS "password_reset";

DROP TABLE IF EXISTS "user_session";

DROP TABLE IF EXISTS "user_key";

DROP TABLE IF EXISTS "user_song_recommendations";

DROP TABLE IF EXISTS "user_likes";

DROP TABLE IF EXISTS "playlist_songs";

DROP TABLE IF EXISTS "album_songs";

DROP TABLE IF EXISTS "playlist";

DROP TABLE IF EXISTS "album";

DROP TABLE IF EXISTS "song";

DROP TABLE IF EXISTS "artist";

DROP TABLE IF EXISTS "auth_user";

DROP TYPE IF EXISTS "genre";

-- Enums
CREATE TYPE "genre" AS ENUM(
    'COUNTRY',
    'POP',
    'RAP',
    'ROCK',
    'CLASSICAL',
    'JAZZ'
);

-- Auth Tables
CREATE TABLE "auth_user" (
    "id" varchar(15) NOT NULL,
    "username" varchar(128) NOT NULL,
    "github_username" varchar(255) UNIQUE,
    "email" varchar(255) UNIQUE,
    "created_at" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "profile_image_url" varchar(255),
    CONSTRAINT "auth_user_id" PRIMARY KEY("id")
);

CREATE TABLE "user_key" (
    "id" varchar(255) NOT NULL,
    "user_id" varchar(15) NOT NULL,
    "hashed_password" varchar(255),
    CONSTRAINT "user_key_id" PRIMARY KEY("id"),
    FOREIGN KEY ("user_id") REFERENCES "auth_user" ("id")
);

CREATE TABLE "user_session" (
    "id" varchar(128) NOT NULL,
    "user_id" varchar(15) NOT NULL,
    "active_expires" bigint NOT NULL,
    "idle_expires" bigint NOT NULL,
    CONSTRAINT "user_session_id" PRIMARY KEY("id"),
    FOREIGN KEY ("user_id") REFERENCES "auth_user" ("id")
);

CREATE TABLE "password_reset" (
    "id" varchar(128) NOT NULL,
    "expires" bigint NOT NULL,
    "user_id" varchar(15) NOT NULL,
    CONSTRAINT "password_reset_id" PRIMARY KEY("id"),
    FOREIGN KEY ("user_id") REFERENCES "auth_user" ("id")
);

-- Application Tables
CREATE TABLE "artist"(
    "id" varchar(15) NOT NULL,
    "bio" varchar(400) NOT NULL,
    "name" varchar(128) NOT NULL,
    CONSTRAINT "artist_id_pk" PRIMARY KEY ("id"),
    FOREIGN KEY ("id") REFERENCES "auth_user" ("id")
);

CREATE TABLE "album"(
    "id" varchar(128) NOT NULL,
    "artist_id" varchar(15) NOT NULL,
    "cover_image_url" varchar(255),
    "name" varchar(128) NOT NULL,
    "created_at" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "albums_id_pk" PRIMARY KEY ("id"),
    FOREIGN KEY ("artist_id") REFERENCES "artist" ("id")
);

CREATE TABLE "song" (
    "id" varchar(128) NOT NULL,
    "name" varchar (128) NOT NULL,
    "artist_id" varchar(15) NOT NULL,
    "duration" int NOT NULL,
    "genre" "genre" NOT NULL,
    "spotify_id" varchar(128),
    "preview_url" varchar(255),
    "created_at" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "songs_id_pk" PRIMARY KEY ("id"),
    FOREIGN KEY ("artist_id") REFERENCES "artist" ("id")
);

CREATE TABLE "playlist" (
    "id" varchar(128) NOT NULL,
    "name" varchar (128) NOT NULL,
    "created_at" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "creator_id" varchar(128) NOT NULL,
    CONSTRAINT "playlists_id_pk" PRIMARY KEY ("id"),
    FOREIGN KEY ("creator_id") REFERENCES "auth_user" ("id")
);

-- Index Tables
CREATE TABLE "album_songs" (
    "album_id" varchar(128) NOT NULL,
    "song_id" varchar(128) NOT NULL,
    "order" int NOT NULL DEFAULT 0,
    CONSTRAINT "album_songs_album_id_song_id_pk" PRIMARY KEY("album_id", "song_id"),
    UNIQUE (song_id),
    FOREIGN KEY ("album_id") REFERENCES "album" ("id")
);

CREATE TABLE "playlist_songs" (
    "playlist_id" varchar(128) NOT NULL,
    "song_id" varchar(128) NOT NULL,
    "order" int NOT NULL DEFAULT 0,
    CONSTRAINT "playlist_songs_playlist_id_song_id_pk" PRIMARY KEY("playlist_id", "song_id"),
    FOREIGN KEY ("playlist_id") REFERENCES "playlist" ("id"),
    FOREIGN KEY ("song_id") REFERENCES "song" ("id")
);

CREATE TABLE "user_likes" (
    "user_id" varchar(15) NOT NULL,
    "song_id" varchar(128) NOT NULL,
    CONSTRAINT "user_likes_user_id_song_id_pk" PRIMARY KEY("user_id", "song_id"),
    FOREIGN KEY ("user_id") REFERENCES "auth_user" ("id"),
    FOREIGN KEY ("song_id") REFERENCES "song" ("id")
);

CREATE TABLE "user_song_recommendations" (
    "id" varchar(128) NOT NULL,
    "user_id" varchar(15) NOT NULL,
    "song_id" varchar(128) NOT NULL,
    "created_at" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "user_song_recommendations_id_user_id_song_id_pk" PRIMARY KEY("id", "user_id", "song_id"),
    FOREIGN KEY ("user_id") REFERENCES "auth_user" ("id"),
    FOREIGN KEY ("song_id") REFERENCES "song" ("id")
);

-- File: insert_admin.sql
INSERT INTO
    "auth_user" (
        "id",
        "username",
        "email",
        "created_at"
    )
VALUES
    (
        'icqlt67n2fd7p34',
        'Admin',
        'g@g.com',
        '2023-11-17 17:00:08.000'
    );

INSERT INTO
    "user_key" ("id", "user_id", "hashed_password")
VALUES
    (
        'email:g@g.com',
        'icqlt67n2fd7p34',
        's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189'
    );

-- File: insert_songs.sql
-- Latto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q1ujsh9e6own2y2', 'Latto', '0@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:0@artist.com', 'q1ujsh9e6own2y2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q1ujsh9e6own2y2', 'A bold and dynamic rapper, making waves with her fiery lyrics.', 'Latto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zln1dmkqjowungh5yrigenmy8vwmow3tv7lqqmycaqemtberwv','q1ujsh9e6own2y2', NULL, 'Latto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sig7uzt7q6k0l4z50kxrc1eqhxcqen54gcp3s78jd00i3rxeq9','Seven (feat. Latto) (Explicit Ver.)','q1ujsh9e6own2y2',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zln1dmkqjowungh5yrigenmy8vwmow3tv7lqqmycaqemtberwv', 'sig7uzt7q6k0l4z50kxrc1eqhxcqen54gcp3s78jd00i3rxeq9', '0');
-- BTS
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s6ty1rpgjd2pn3p', 'BTS', '1@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd642648235ebf3460d2d1f6a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:1@artist.com', 's6ty1rpgjd2pn3p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s6ty1rpgjd2pn3p', 'A global phenomenon, setting new standards in K-pop with their music and performances.', 'BTS');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zkunv1eq3uhov27deg9qncbgw20rxamlztinkx27utgzatepvm','s6ty1rpgjd2pn3p', 'https://i.scdn.co/image/ab67616d0000b2738a701e76e8845928f6cd81c8', 'BTS Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('53sknifm64yz427q3l5k0kcauk4p0ek4tblc07j4aob60kxxoj','Take Two','s6ty1rpgjd2pn3p',100,'POP','5IAESfJjmOYu7cHyX557kz','https://p.scdn.co/mp3-preview/ef43da30a06fcad16898e9fff1cadd0ccf953fc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zkunv1eq3uhov27deg9qncbgw20rxamlztinkx27utgzatepvm', '53sknifm64yz427q3l5k0kcauk4p0ek4tblc07j4aob60kxxoj', '0');
-- Fuerza Regida
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3jqxmljs9czv5o8', 'Fuerza Regida', '2@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1b85fbf9507041aab224336d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:2@artist.com', '3jqxmljs9czv5o8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3jqxmljs9czv5o8', 'Revitalizing the regional music scene with their unique sound and powerful lyrics.', 'Fuerza Regida');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hcxs842n9nv394scqa52xm6f737qkew1l6op7kq9umfyn6t9fr','3jqxmljs9czv5o8', 'https://i.scdn.co/image/ab67616d0000b273cfe3eb72c48b93971e53efd9', 'Fuerza Regida Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h4osqq35rvnyiylfs4gmty0nx5eezt80fn0nfa4p3m0bw857m3','SABOR FRESA','3jqxmljs9czv5o8',100,'POP','1UMm1Qs3u59Wvk53zBUE8r','https://p.scdn.co/mp3-preview/590ae0b69465339d97ef5db9f7e36fe0c452fbb4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hcxs842n9nv394scqa52xm6f737qkew1l6op7kq9umfyn6t9fr', 'h4osqq35rvnyiylfs4gmty0nx5eezt80fn0nfa4p3m0bw857m3', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z79hm0lvrnsm1m7rb6hl7n5f0xeogdo4xlw2467dkniea52pfn','TQM','3jqxmljs9czv5o8',100,'POP','368eeEO3Y2uZUQ6S5oIjcu','https://p.scdn.co/mp3-preview/63f6b66cfcc3d7bd396dcbe18d6e3dee05fdb956?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hcxs842n9nv394scqa52xm6f737qkew1l6op7kq9umfyn6t9fr', 'z79hm0lvrnsm1m7rb6hl7n5f0xeogdo4xlw2467dkniea52pfn', '1');
-- Em Beihold
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rkt534k4rjii2ie', 'Em Beihold', '3@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1e97fce6fa6fc4ebc3ebda25','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:3@artist.com', 'rkt534k4rjii2ie', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rkt534k4rjii2ie', 'A voice that captivates, combining depth of lyrics with a melodic finesse.', 'Em Beihold');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2ij5g80rzveqspjbun7mf7aqt0ltewxgovd31hs7zk2ugn3ig8','rkt534k4rjii2ie', NULL, 'Em Beihold Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9wpm0ktt8cvq6kcxhtniumm5yi8abkj730p2qzy989w1znmf7e','Until I Found You (with Em Beihold) - Em Beihold Version','rkt534k4rjii2ie',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2ij5g80rzveqspjbun7mf7aqt0ltewxgovd31hs7zk2ugn3ig8', '9wpm0ktt8cvq6kcxhtniumm5yi8abkj730p2qzy989w1znmf7e', '0');
-- Charlie Puth
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bfgvdftwg8om5rq', 'Charlie Puth', '4@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:4@artist.com', 'bfgvdftwg8om5rq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bfgvdftwg8om5rq', 'A pop maestro, combining catchy melodies with his exceptional musical talent.', 'Charlie Puth');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rfmwq7irhkipkup6v6u4cibjf0m3e02vfxxe2ofmxj8ke8tyo4','bfgvdftwg8om5rq', 'https://i.scdn.co/image/ab67616d0000b27335d2e0ed94a934f2cc46fa49', 'Charlie Puth Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('99mm18bko0ski8gnk6gh9paes4bbvah9nqaanrpf34u30o9n3j','Left and Right (Feat. Jung Kook of BTS)','bfgvdftwg8om5rq',100,'POP','5Odq8ohlgIbQKMZivbWkEo','https://p.scdn.co/mp3-preview/9e4342eefa4f33df4e9b199e60dbce0f59e46eff?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rfmwq7irhkipkup6v6u4cibjf0m3e02vfxxe2ofmxj8ke8tyo4', '99mm18bko0ski8gnk6gh9paes4bbvah9nqaanrpf34u30o9n3j', '0');
-- Mc Livinho
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zkxn7k3qvp30adv', 'Mc Livinho', '5@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd353ef9564cfbb5f2b3bffb2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:5@artist.com', 'zkxn7k3qvp30adv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zkxn7k3qvp30adv', 'Bringing Brazilian funk rhythms to the global music stage.', 'Mc Livinho');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1mufgnn03k11zi04jtxggrf1jabbriwhwcvfj9egxnrrdapzy5','zkxn7k3qvp30adv', 'https://i.scdn.co/image/ab67616d0000b273369c960fed23353176da1218', 'Mc Livinho Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('eqrcobm8wbd983y7ehno8rwrt9rnu8d6wkar51jjtwqh3l1a9g','Novidade na ','zkxn7k3qvp30adv',100,'POP','2uhw2oYbugGJbn10wipNX5','https://p.scdn.co/mp3-preview/6bff8c1079d87a672d6b9ee5c3c6ca5e7d9ff45b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1mufgnn03k11zi04jtxggrf1jabbriwhwcvfj9egxnrrdapzy5', 'eqrcobm8wbd983y7ehno8rwrt9rnu8d6wkar51jjtwqh3l1a9g', '0');
-- Marshmello
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ljb3lkvdbvzzdi4', 'Marshmello', '6@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41e4a3b8c1d45a9e49b6de21','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:6@artist.com', 'ljb3lkvdbvzzdi4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ljb3lkvdbvzzdi4', 'An electronic music maestro known for his infectious beats.', 'Marshmello');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dcneufw3ctzjjg78b2i3dc1tw2cy7gp4mwmfefcuy4lyx6psvb','ljb3lkvdbvzzdi4', 'https://i.scdn.co/image/ab67616d0000b273f404676577626a87d92cf33f', 'Marshmello Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c3pjmo7xugxutq033nbeqrntfmbj5zkdq3wwchgkgstry4dcmf','El Merengue','ljb3lkvdbvzzdi4',100,'POP','51FvjPEGKq2zByeeEQ43V9','https://p.scdn.co/mp3-preview/a933b6e1d6a47e591c13192f2b5e58739d3d5a06?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dcneufw3ctzjjg78b2i3dc1tw2cy7gp4mwmfefcuy4lyx6psvb', 'c3pjmo7xugxutq033nbeqrntfmbj5zkdq3wwchgkgstry4dcmf', '0');
-- Miley Cyrus
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('obpj2lm0pe8lmi5', 'Miley Cyrus', '7@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5af3b38f053486ab0784dee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:7@artist.com', 'obpj2lm0pe8lmi5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('obpj2lm0pe8lmi5', 'Constantly evolving, from pop sensation to rock powerhouse.', 'Miley Cyrus');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wq7kutpl6wvm8xg73o9j9f1ssgpcf5zfel2go14lp9cvt3189s','obpj2lm0pe8lmi5', 'https://i.scdn.co/image/ab67616d0000b273cd222052a2594be29a6616b5', 'Miley Cyrus Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9btoj4piqq7b0rloti5oqq5xksvvkbhimizwts3l5fmaaou92m','Flowers','obpj2lm0pe8lmi5',100,'POP','7DSAEUvxU8FajXtRloy8M0','https://p.scdn.co/mp3-preview/5184d19d1b7fcc3e7c067e38af45a7cc80851440?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wq7kutpl6wvm8xg73o9j9f1ssgpcf5zfel2go14lp9cvt3189s', '9btoj4piqq7b0rloti5oqq5xksvvkbhimizwts3l5fmaaou92m', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dwj58jhsnfps8sclqbt6def58tj1thzkr3dcahzwa02hyxr1hw','Angels Like You','obpj2lm0pe8lmi5',100,'POP','1daDRI9ahBonbWD8YcxOIB','https://p.scdn.co/mp3-preview/4db8314199c0d49e95c786792ecd06eadae9f510?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wq7kutpl6wvm8xg73o9j9f1ssgpcf5zfel2go14lp9cvt3189s', 'dwj58jhsnfps8sclqbt6def58tj1thzkr3dcahzwa02hyxr1hw', '1');
-- Harry Styles
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('t394zs4r0jvjyv8', 'Harry Styles', '8@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf7db7c8ede90a019c54590bb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:8@artist.com', 't394zs4r0jvjyv8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('t394zs4r0jvjyv8', 'Defining modern pop-rock with his charismatic presence and bold choices.', 'Harry Styles');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5bn8yrv27invzvuur6p3kb5encfe2gp9xjf0xhargprec4244t','t394zs4r0jvjyv8', 'https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0', 'Harry Styles Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('crpzji7v4zwn2d112ijhoio4g6fqb6ggjx9vgwl41e40fsve9p','As It Was','t394zs4r0jvjyv8',100,'POP','4Dvkj6JhhA12EX05fT7y2e','https://p.scdn.co/mp3-preview/c43dd07043b29e800c1a65b3a0102861fa3cf418?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5bn8yrv27invzvuur6p3kb5encfe2gp9xjf0xhargprec4244t', 'crpzji7v4zwn2d112ijhoio4g6fqb6ggjx9vgwl41e40fsve9p', '0');
-- Vance Joy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('21oqwwxkoz87cgl', 'Vance Joy', '9@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f074ec8c25406680bf26422','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:9@artist.com', '21oqwwxkoz87cgl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('21oqwwxkoz87cgl', 'Crafting folk-pop anthems that resonate with heartfelt sincerity.', 'Vance Joy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rrwu0mesogmvov9xe70rd2tc5f3gy7citk8ghwfgv1n9xf5qks','21oqwwxkoz87cgl', 'https://i.scdn.co/image/ab67616d0000b273a9929deb093a6617d2493b03', 'Vance Joy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vwr6uv8r990rf02cd9mmtr1rh9dcfdk3ilin4rtdqa6u7hh3o5','Riptide','21oqwwxkoz87cgl',100,'POP','3JvrhDOgAt6p7K8mDyZwRd','https://p.scdn.co/mp3-preview/74698d907d114f4ba0b2c129bbf260724be80b64?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rrwu0mesogmvov9xe70rd2tc5f3gy7citk8ghwfgv1n9xf5qks', 'vwr6uv8r990rf02cd9mmtr1rh9dcfdk3ilin4rtdqa6u7hh3o5', '0');
-- The Neighbourhood
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xr8ne8nxxawxta0', 'The Neighbourhood', '10@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf0b5ac84376a0a4b2166816','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:10@artist.com', 'xr8ne8nxxawxta0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xr8ne8nxxawxta0', 'Melding alternative rock with introspective lyrics.', 'The Neighbourhood');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nir4cumc98kxmjtz12ts1f4gkhb52bijunpm7vp8eb53g8qar3','xr8ne8nxxawxta0', 'https://i.scdn.co/image/ab67616d0000b2738265a736a1eb838ad5a0b921', 'The Neighbourhood Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9i95lp3l3j4pki8cu318e151u5qys5yzk494v1gb9sqky51bmc','Sweater Weather','xr8ne8nxxawxta0',100,'POP','2QjOHCTQ1Jl3zawyYOpxh6','https://p.scdn.co/mp3-preview/877602f424a9dea277b13301ffc516f9fd1fbe7e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nir4cumc98kxmjtz12ts1f4gkhb52bijunpm7vp8eb53g8qar3', '9i95lp3l3j4pki8cu318e151u5qys5yzk494v1gb9sqky51bmc', '0');
-- Feid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('g4snihvufgc5a2k', 'Feid', '11@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0a248d29f8faa91f971e5cae','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:11@artist.com', 'g4snihvufgc5a2k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('g4snihvufgc5a2k', 'A standout artist in urban Latin music, known for his catchy melodies and smooth vocals.', 'Feid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qpt15l0ld0s4jpy2dmerx1x9kqocs6e4d0rmtv49saxmqqtcd5','g4snihvufgc5a2k', 'https://i.scdn.co/image/ab67616d0000b27329ebee2b5fb008871fcd201a', 'Feid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qsllpy08rbtc96nfqqzju4cwvkzcql2nwdvktex60bjwqtd3hb','Classy 101','g4snihvufgc5a2k',100,'POP','6XSqqQIy7Lm7SnwxS4NrGx',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qpt15l0ld0s4jpy2dmerx1x9kqocs6e4d0rmtv49saxmqqtcd5', 'qsllpy08rbtc96nfqqzju4cwvkzcql2nwdvktex60bjwqtd3hb', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4hacol20ec6he2uouskts6kcdz1cryfrlqy97k2mkej8878q02','El Cielo','g4snihvufgc5a2k',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qpt15l0ld0s4jpy2dmerx1x9kqocs6e4d0rmtv49saxmqqtcd5', '4hacol20ec6he2uouskts6kcdz1cryfrlqy97k2mkej8878q02', '1');
-- Maria Becerra
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zg6btjpvkn1ovqa', 'Maria Becerra', '12@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb6cfa517b8f5a152d63c4ffb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:12@artist.com', 'zg6btjpvkn1ovqa', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zg6btjpvkn1ovqa', 'A vibrant new voice in Latin pop, fusing catchy melodies with urban sounds.', 'Maria Becerra');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oxmrhifg2i3n3br1ru1bie3jczkoxt3h2yld1niunfi3w7ewn3','zg6btjpvkn1ovqa', NULL, 'Maria Becerra Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g3c6knm7k45u0qd79yrpw1pfc39carbdhcpe5t4ehubske0hce','CORAZN VA','zg6btjpvkn1ovqa',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oxmrhifg2i3n3br1ru1bie3jczkoxt3h2yld1niunfi3w7ewn3', 'g3c6knm7k45u0qd79yrpw1pfc39carbdhcpe5t4ehubske0hce', '0');
-- Ozuna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0t3hxc9x2vh8gkw', 'Ozuna', '13@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd45efec1d439cfd8bd936421','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:13@artist.com', '0t3hxc9x2vh8gkw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0t3hxc9x2vh8gkw', 'Dominating reggaeton and Latin trap with catchy tunes and charismatic energy.', 'Ozuna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0d99vd4888f3nryn3vordztgr3h1pa05j37xukbm6wcn29e2hj','0t3hxc9x2vh8gkw', 'https://i.scdn.co/image/ab67616d0000b273125624f2e04f5a1ccb0dfb45', 'Ozuna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8tmjuju0hlkdy3yhp75nbrys4hgyoazx78v8giyu8fcedwq5fs','Hey Mor','0t3hxc9x2vh8gkw',100,'POP','1zsPaEkglFvxjAhrM8yhpr','https://p.scdn.co/mp3-preview/cd2d2242b748408da15c2b66f47d54b3f0793ae0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0d99vd4888f3nryn3vordztgr3h1pa05j37xukbm6wcn29e2hj', '8tmjuju0hlkdy3yhp75nbrys4hgyoazx78v8giyu8fcedwq5fs', '0');
-- Sam Smith
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u52v37w3o49jvuc', 'Sam Smith', '14@artist.com', 'https://i.scdn.co/image/c589b50021995a40811097e48a9c65f9c4b423ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:14@artist.com', 'u52v37w3o49jvuc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u52v37w3o49jvuc', 'A soulful voice delivering deep emotional resonance.', 'Sam Smith');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('017r7ygnpvb0prk5f59psukysuguwbb3qafz4p1akk70cag4tn','u52v37w3o49jvuc', 'https://i.scdn.co/image/ab67616d0000b273a935e4689f15953311772cc4', 'Sam Smith Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w3ahwxst9n5wvue90uhxjiaxxgl4wtj9qovpxu728illo0g5tm','Unholy (feat. Kim Petras)','u52v37w3o49jvuc',100,'POP','3nqQXoyQOWXiESFLlDF1hG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('017r7ygnpvb0prk5f59psukysuguwbb3qafz4p1akk70cag4tn', 'w3ahwxst9n5wvue90uhxjiaxxgl4wtj9qovpxu728illo0g5tm', '0');
-- Troye Sivan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nahpjj0494scdxf', 'Troye Sivan', '15@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26e8cb3ff6fc7744b312811b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:15@artist.com', 'nahpjj0494scdxf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nahpjj0494scdxf', 'A voice that encapsulates the spirit of modern pop.', 'Troye Sivan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1jm33flvzm609fkoxxpjvar2w88jy8mljfh2952ot5qlb29xr4','nahpjj0494scdxf', 'https://i.scdn.co/image/ab67616d0000b27367103283a4eb57578a428252', 'Troye Sivan Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mhgbx29m4s4a9jymy2eo22dot840ar9wv2s39qat3a5593v5qt','Rush','nahpjj0494scdxf',100,'POP','4ZnkygoWLzcGbQYCm3lkae',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1jm33flvzm609fkoxxpjvar2w88jy8mljfh2952ot5qlb29xr4', 'mhgbx29m4s4a9jymy2eo22dot840ar9wv2s39qat3a5593v5qt', '0');
-- Doechii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7vp332d7mre33kl', 'Doechii', '16@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5f9f729e1e5182fbf1030dbe','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:16@artist.com', '7vp332d7mre33kl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7vp332d7mre33kl', 'Breaking barriers with her unique sound and powerful lyrical storytelling.', 'Doechii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fvz4zn80904vul3v5s0rwwi4s4h5amqwg0lwgn6xsid1sfse1a','7vp332d7mre33kl', 'https://i.scdn.co/image/ab67616d0000b2732ee85751f6f503fa9a533eba', 'Doechii Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ntgw5n0vr4m0xwouq1vvj4xx8csqanhol11bx05a8cmpse2p3n','What It Is (Solo Version)','7vp332d7mre33kl',100,'POP','73RbfOTJIjHzi2pcVHjeHM',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fvz4zn80904vul3v5s0rwwi4s4h5amqwg0lwgn6xsid1sfse1a', 'ntgw5n0vr4m0xwouq1vvj4xx8csqanhol11bx05a8cmpse2p3n', '0');
-- Myke Towers
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nv7daoj9c8xhpym', 'Myke Towers', '17@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9e35c3c5de877f99a8f6192f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:17@artist.com', 'nv7daoj9c8xhpym', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nv7daoj9c8xhpym', 'A rising star in Latin music, known for his distinctive flow.', 'Myke Towers');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mion6pzbt2vslveqrj4zw4vi9wkde6kueivm5wnln3mkva3enm','nv7daoj9c8xhpym', 'https://i.scdn.co/image/ab67616d0000b2730656d5ce813ca3cc4b677e05', 'Myke Towers Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ldryg588y31ty7aacn550b5qur6rcsi6qvik65uev8tv79fsd9','LALA','nv7daoj9c8xhpym',100,'POP','7ABLbnD53cQK00mhcaOUVG','https://p.scdn.co/mp3-preview/42772b16b4e575d1b15b0ec7f94e335539390d2d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mion6pzbt2vslveqrj4zw4vi9wkde6kueivm5wnln3mkva3enm', 'ldryg588y31ty7aacn550b5qur6rcsi6qvik65uev8tv79fsd9', '0');
-- Taylor Swift
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c1a5b93sr7m2sif', 'Taylor Swift', '18@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb859e4c14fa59296c8649e0e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:18@artist.com', 'c1a5b93sr7m2sif', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c1a5b93sr7m2sif', 'A storytelling icon, weaving life experiences into musical masterpieces.', 'Taylor Swift');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6eamhcd7140165347e0f73t59z7syy9hxa64c8xcqmgh93872f','c1a5b93sr7m2sif', 'https://i.scdn.co/image/ab67616d0000b273e787cffec20aa2a396a61647', 'Taylor Swift Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h7ur1oan26piqrt6uh0d4kwmsht6qwhh0w3uy6vblj1cztjvt8','Cruel Summer','c1a5b93sr7m2sif',100,'POP','1BxfuPKGuaTgP7aM0Bbdwr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6eamhcd7140165347e0f73t59z7syy9hxa64c8xcqmgh93872f', 'h7ur1oan26piqrt6uh0d4kwmsht6qwhh0w3uy6vblj1cztjvt8', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wmkut41tysv4faghqhdmbiaqt4skd6611nmluhqzi0myqgwopg','I Can See You (Taylors Version) (From The ','c1a5b93sr7m2sif',100,'POP','5kHMfzgLZP95O9NBy0ku4v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6eamhcd7140165347e0f73t59z7syy9hxa64c8xcqmgh93872f', 'wmkut41tysv4faghqhdmbiaqt4skd6611nmluhqzi0myqgwopg', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9udpoe4evae2ducgimur83i30e3f33j5nm0r0jrf6kssz4b4m8','Anti-Hero','c1a5b93sr7m2sif',100,'POP','0V3wPSX9ygBnCm8psDIegu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6eamhcd7140165347e0f73t59z7syy9hxa64c8xcqmgh93872f', '9udpoe4evae2ducgimur83i30e3f33j5nm0r0jrf6kssz4b4m8', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7imkefvsau4h2g9laisgtfew2s584qm6hj1048kcl80th3do32','Blank Space','c1a5b93sr7m2sif',100,'POP','1p80LdxRV74UKvL8gnD7ky',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6eamhcd7140165347e0f73t59z7syy9hxa64c8xcqmgh93872f', '7imkefvsau4h2g9laisgtfew2s584qm6hj1048kcl80th3do32', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9xd41ok21aqatsksddr2s0bvav7mo1ybaonvd11ejqhhq51mnh','Style','c1a5b93sr7m2sif',100,'POP','1hjRhYpWyqDpPahmSlUTlc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6eamhcd7140165347e0f73t59z7syy9hxa64c8xcqmgh93872f', '9xd41ok21aqatsksddr2s0bvav7mo1ybaonvd11ejqhhq51mnh', '4');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0696r22e66uivbcyf8v0t4pqjcd5pi0rn9rh5iuzy34ibsplcq','cardigan','c1a5b93sr7m2sif',100,'POP','4R2kfaDFhslZEMJqAFNpdd',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6eamhcd7140165347e0f73t59z7syy9hxa64c8xcqmgh93872f', '0696r22e66uivbcyf8v0t4pqjcd5pi0rn9rh5iuzy34ibsplcq', '5');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fut88d39y6vvty50siugipxsu5q434wwg006w65fqq0ytukhi8','Karma','c1a5b93sr7m2sif',100,'POP','7KokYm8cMIXCsGVmUvKtqf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6eamhcd7140165347e0f73t59z7syy9hxa64c8xcqmgh93872f', 'fut88d39y6vvty50siugipxsu5q434wwg006w65fqq0ytukhi8', '6');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u22oe79s4gqq3a8x86cuzzfkzfv8j6oga05eeb6wnfv5ix7pdf','Enchanted (Taylors Version)','c1a5b93sr7m2sif',100,'POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6eamhcd7140165347e0f73t59z7syy9hxa64c8xcqmgh93872f', 'u22oe79s4gqq3a8x86cuzzfkzfv8j6oga05eeb6wnfv5ix7pdf', '7');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('64wwbrxnynej34wcmrmxpksevo491wb80oy34anhx345zz91rb','Back To December (Taylors Version)','c1a5b93sr7m2sif',100,'POP','79uDOz0zuuWS7HWxzMmTa2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6eamhcd7140165347e0f73t59z7syy9hxa64c8xcqmgh93872f', '64wwbrxnynej34wcmrmxpksevo491wb80oy34anhx345zz91rb', '8');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kb2uy5m9qpujoml6kvadibgpgwpojj1vx7qi1ztt75qp8l8n6a','Dont Bl','c1a5b93sr7m2sif',100,'POP','59ZmeIz57cGU5Gp9omjlYB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6eamhcd7140165347e0f73t59z7syy9hxa64c8xcqmgh93872f', 'kb2uy5m9qpujoml6kvadibgpgwpojj1vx7qi1ztt75qp8l8n6a', '9');
-- Nicki Minaj
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v6zp0ml8d4w4amw', 'Nicki Minaj', '19@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03578c92e15089c645b794f5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:19@artist.com', 'v6zp0ml8d4w4amw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v6zp0ml8d4w4amw', 'A rap icon known for her versatile flow and bold personality.', 'Nicki Minaj');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3nlti299ox5noc0j9nf2az5oyk5pqsa8wq8zl38e2zv7no4xg4','v6zp0ml8d4w4amw', 'https://i.scdn.co/image/ab67616d0000b2737e8f938c02fac3b564931116', 'Nicki Minaj Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hxflg3f9y889bd8wnuzqtbaov21v83ii06ggpikrcfv4d3j2fx','Barbie World (with Aqua) [From Barbie The Album]','v6zp0ml8d4w4amw',100,'POP','741UUVE2kuITl0c6zuqqbO','https://p.scdn.co/mp3-preview/f654928ccaa4e6a9fb09a6eb3f208383eccc12a9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3nlti299ox5noc0j9nf2az5oyk5pqsa8wq8zl38e2zv7no4xg4', 'hxflg3f9y889bd8wnuzqtbaov21v83ii06ggpikrcfv4d3j2fx', '0');
-- Dave
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e7pltbm3mesev7u', 'Dave', '20@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5fe7cabb8de1c0266cd2179c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:20@artist.com', 'e7pltbm3mesev7u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e7pltbm3mesev7u', 'A master of words, blending rap with social commentary and raw emotion.', 'Dave');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('aqwbjqy8s2pualk487mxxfvsnmjksm2iev2e5is96wt8latlrn','e7pltbm3mesev7u', 'https://i.scdn.co/image/ab67616d0000b273e3a09a9ae3f1fa102c110e60', 'Dave Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3vzk5fb5w1qxefq7iy82pq5cdpig9yf4lkyoe8hr1dji9ijto5','Sprinter','e7pltbm3mesev7u',100,'POP','2FDTHlrBguDzQkp7PVj16Q',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('aqwbjqy8s2pualk487mxxfvsnmjksm2iev2e5is96wt8latlrn', '3vzk5fb5w1qxefq7iy82pq5cdpig9yf4lkyoe8hr1dji9ijto5', '0');
-- Olivia Rodrigo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pskoanfqyz9lmsb', 'Olivia Rodrigo', '21@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe03a98785f3658f0b6461ec4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:21@artist.com', 'pskoanfqyz9lmsb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pskoanfqyz9lmsb', 'A new voice in pop, channeling raw emotions into her songs.', 'Olivia Rodrigo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ibjr03sbfl74m9skelgxp3f6szvrzxn3xrkco4shqsvunrqunc','pskoanfqyz9lmsb', 'https://i.scdn.co/image/ab67616d0000b273e85259a1cae29a8d91f2093d', 'Olivia Rodrigo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('225fjtacfvybhlb68s5x1qck0kwe7ldahk98ep8agzuf4xot52','vampire','pskoanfqyz9lmsb',100,'POP','1kuGVB7EU95pJObxwvfwKS',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ibjr03sbfl74m9skelgxp3f6szvrzxn3xrkco4shqsvunrqunc', '225fjtacfvybhlb68s5x1qck0kwe7ldahk98ep8agzuf4xot52', '0');
-- Big One
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4yq62yf9d78jb6d', 'Big One', '22@artist.com', 'https://i.scdn.co/image/ab67616d0000b273ba9f82cc282b2de6cf7c0246','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:22@artist.com', '4yq62yf9d78jb6d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4yq62yf9d78jb6d', 'Bringing a unique energy to every track, fusing various styles into a cohesive sound.', 'Big One');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u62i4zthti1lq1vlvb4mws2dul3moqssre1lq3pqjwvdnuvd8f','4yq62yf9d78jb6d', NULL, 'Big One Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sw7ur9xnv28g12afgdiv2lgywon8wzah4i12wf7y0d2pxdh5pk','Los del Espacio','4yq62yf9d78jb6d',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u62i4zthti1lq1vlvb4mws2dul3moqssre1lq3pqjwvdnuvd8f', 'sw7ur9xnv28g12afgdiv2lgywon8wzah4i12wf7y0d2pxdh5pk', '0');
-- Bizarrap
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jzhqd3b7pm4foj8', 'Bizarrap', '23@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:23@artist.com', 'jzhqd3b7pm4foj8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jzhqd3b7pm4foj8', 'Revolutionizing the music scene with his unique production style and collaborations.', 'Bizarrap');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('iw1pznivjrjapsmh4s8zbpavf63ytgpfwz3jlokbpmufjq3eut','jzhqd3b7pm4foj8', 'https://i.scdn.co/image/ab67616d0000b27315583045b2fdb7d7bab10e81', 'Bizarrap Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2ornmisla901yrm14cbhxfyxg8mqpa0kjxfm7jp8tpxnliw25w','Peso Pluma: Bzrp Music Sessions, Vol. 55','jzhqd3b7pm4foj8',100,'POP','5AqiaZwhmC6dIbgWrD5SzV','https://p.scdn.co/mp3-preview/9d61998a29c2e8b52a7d46885352f5507eb219e2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('iw1pznivjrjapsmh4s8zbpavf63ytgpfwz3jlokbpmufjq3eut', '2ornmisla901yrm14cbhxfyxg8mqpa0kjxfm7jp8tpxnliw25w', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a0q5h0zsdx4d96bg2u5jouiifkm9c40d90jli6q985l3ql3wjo','Quevedo: Bzrp Music Sessions, Vol. 52','jzhqd3b7pm4foj8',100,'POP','2tTmW7RDtMQtBk7m2rYeSw','https://p.scdn.co/mp3-preview/e9c0ed735e611f6af45bc946bd4c31590df09ed6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('iw1pznivjrjapsmh4s8zbpavf63ytgpfwz3jlokbpmufjq3eut', 'a0q5h0zsdx4d96bg2u5jouiifkm9c40d90jli6q985l3ql3wjo', '1');
-- Peggy Gou
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('oczhyktys36l2i0', 'Peggy Gou', '24@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf5c17aa075c03c5c4d2c693','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:24@artist.com', 'oczhyktys36l2i0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('oczhyktys36l2i0', 'A dynamic force in the electronic music scene, known for her eclectic mixes.', 'Peggy Gou');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('otv6u4p9gj9uqyu6q53vuzfwu7vxd6ty5zzl34zw5na2tv9qfq','oczhyktys36l2i0', 'https://i.scdn.co/image/ab67616d0000b27388d71aadd009fe1a83df88f2', 'Peggy Gou Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0e0egaehgsxkliojjxzipe449j237i9ilu4lkbdu9n5e6lozw1','(It Goes Like) Nanana - Edit','oczhyktys36l2i0',100,'POP','23RoR84KodL5HWvUTneQ1w','https://p.scdn.co/mp3-preview/e36e0bd4714844f1f9d992398b41a3e333f15cc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('otv6u4p9gj9uqyu6q53vuzfwu7vxd6ty5zzl34zw5na2tv9qfq', '0e0egaehgsxkliojjxzipe449j237i9ilu4lkbdu9n5e6lozw1', '0');
-- David Kushner
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('eebh0o7mffp1ioh', 'David Kushner', '25@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12fd1bd22516e35ef8c2e591','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:25@artist.com', 'eebh0o7mffp1ioh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('eebh0o7mffp1ioh', 'A rising talent, creating music that resonates with a generation.', 'David Kushner');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dyrfmozhho0n88rsx9rx8fvzn41nl31fvkuu1r36qhi79jh9g8','eebh0o7mffp1ioh', 'https://i.scdn.co/image/ab67616d0000b27395ca6a9b4083a86c149934ae', 'David Kushner Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e84guuk6tqklo98xqi0ewkp2s52btxni8d4vp6d7i5op2cylzr','Daylight','eebh0o7mffp1ioh',100,'POP','1odExI7RdWc4BT515LTAwj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dyrfmozhho0n88rsx9rx8fvzn41nl31fvkuu1r36qhi79jh9g8', 'e84guuk6tqklo98xqi0ewkp2s52btxni8d4vp6d7i5op2cylzr', '0');
-- Dua Lipa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('84dzis14lckipc4', 'Dua Lipa', '26@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1bbee4a02f85ecc58d385c3e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:26@artist.com', '84dzis14lckipc4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('84dzis14lckipc4', 'A pop phenomenon, known for her empowering anthems and dynamic presence.', 'Dua Lipa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xk6336ke80w4gx8yhl9ef5t81zve55u011zwtzykx74rwwqyuj','84dzis14lckipc4', 'https://i.scdn.co/image/ab67616d0000b2737dd3ba455ee3390cb55b0192', 'Dua Lipa Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kzq0c3rndj0oig1run9ipg7ef851kqi0sawi8s6eiqehhis9lo','Dance The Night (From Barbie The Album)','84dzis14lckipc4',100,'POP','1vYXt7VSjH9JIM5oRRo7vA','https://p.scdn.co/mp3-preview/acaea048f50a3b30ca24b348c84a6047373baabb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xk6336ke80w4gx8yhl9ef5t81zve55u011zwtzykx74rwwqyuj', 'kzq0c3rndj0oig1run9ipg7ef851kqi0sawi8s6eiqehhis9lo', '0');
-- Gabito Ballesteros
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rsbaynuggs97ai3', 'Gabito Ballesteros', '27@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:27@artist.com', 'rsbaynuggs97ai3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rsbaynuggs97ai3', 'A vibrant force in the music scene, infusing every performance with passion.', 'Gabito Ballesteros');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kxjw03fpw4rwe11ai2f4tv0bzeqnixzasgxuvbywt798sv8mow','rsbaynuggs97ai3', NULL, 'Gabito Ballesteros Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sf12f6cbiswrrbql90km7rt9nxjj8cp40yklkecrexoucmjhoc','LADY GAGA','rsbaynuggs97ai3',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kxjw03fpw4rwe11ai2f4tv0bzeqnixzasgxuvbywt798sv8mow', 'sf12f6cbiswrrbql90km7rt9nxjj8cp40yklkecrexoucmjhoc', '0');
-- Bebe Rexha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h9ywl4vgyhl4xrb', 'Bebe Rexha', '28@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc692afc666512dc946a7358f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:28@artist.com', 'h9ywl4vgyhl4xrb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h9ywl4vgyhl4xrb', 'A dynamic voice in pop music, known for her powerful vocals and catchy tunes.', 'Bebe Rexha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('phmr3bb04kfrgsglo03l1umzohhqkrcwzozqmy7l4ykk6wxvsg','h9ywl4vgyhl4xrb', NULL, 'Bebe Rexha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8pahllyvs6bngwruibl102kp4r5xxrig8fi7q2341tum1qqu38','Im Good (Blue)','h9ywl4vgyhl4xrb',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('phmr3bb04kfrgsglo03l1umzohhqkrcwzozqmy7l4ykk6wxvsg', '8pahllyvs6bngwruibl102kp4r5xxrig8fi7q2341tum1qqu38', '0');
-- Jain
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y4z9gt5vi7yog2b', 'Jain', '29@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb673f287fead1f6c83b9b68ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:29@artist.com', 'y4z9gt5vi7yog2b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y4z9gt5vi7yog2b', 'Mixing electronic beats with multicultural influences to create a unique sound.', 'Jain');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6cut4k6dul5kk50z2e4yuwaysecqe4xzuo7jhqt0phq8xagllc','y4z9gt5vi7yog2b', 'https://i.scdn.co/image/ab67616d0000b27364ba66f8a81c52364e55db50', 'Jain Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qwjags6fefvxrpjk4ep9ric17937qs49mhmvdwbkqx2g9xm4sr','Makeba','y4z9gt5vi7yog2b',100,'POP','4TNFLwe6DhtR3Wn1JKMqMJ','https://p.scdn.co/mp3-preview/41db29480f9d12734adf491d3b5dd4da1005047c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6cut4k6dul5kk50z2e4yuwaysecqe4xzuo7jhqt0phq8xagllc', 'qwjags6fefvxrpjk4ep9ric17937qs49mhmvdwbkqx2g9xm4sr', '0');
-- Billie Eilish
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tfh008jb0rlty9z', 'Billie Eilish', '30@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd8b9980db67272cb4d2c3daf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:30@artist.com', 'tfh008jb0rlty9z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tfh008jb0rlty9z', 'An icon in modern pop, known for her haunting vocals and introspective lyrics.', 'Billie Eilish');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('k1ruypdnhglzfbks2pzqsqu1spsc1ohgob9j5snf2nt3c2ipt7','tfh008jb0rlty9z', NULL, 'Billie Eilish Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t0m5ehy57jeibwdh9jdrd4gdzhfzk30tuhro1u6qf0cdz9qthe','What Was I Made For? [From The Motion Picture "Barbie"]','tfh008jb0rlty9z',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k1ruypdnhglzfbks2pzqsqu1spsc1ohgob9j5snf2nt3c2ipt7', 't0m5ehy57jeibwdh9jdrd4gdzhfzk30tuhro1u6qf0cdz9qthe', '0');
-- Tainy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('138dp2by5os0a20', 'Tainy', '31@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb50d43598b9074f0d6146127','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:31@artist.com', '138dp2by5os0a20', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('138dp2by5os0a20', 'Revolutionizing reggaeton and Latin music with groundbreaking production.', 'Tainy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0yggxckc1dlhdvj036ttjuf03qrbxeki49okucm5lxdqdw4mqb','138dp2by5os0a20', 'https://i.scdn.co/image/ab67616d0000b273de7b9af78fbdda96c5a0635b', 'Tainy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aie47g325jb882ttzr0japlnj4zr1lhlc2lcft91kvjbc1iht7','MOJABI GHOST','138dp2by5os0a20',100,'POP','4eMKD8MRroxCqugpsxCCNb','https://p.scdn.co/mp3-preview/a6d8180d52b759c3e3db9aa78e841ffc06e26c17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0yggxckc1dlhdvj036ttjuf03qrbxeki49okucm5lxdqdw4mqb', 'aie47g325jb882ttzr0japlnj4zr1lhlc2lcft91kvjbc1iht7', '0');
-- Karol G
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v5rxhfap3gmqrjo', 'Karol G', '32@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeb97a2403d7b9a631ce0f59c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:32@artist.com', 'v5rxhfap3gmqrjo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v5rxhfap3gmqrjo', 'A queen of reggaeton, known for her empowering anthems and vibrant performances.', 'Karol G');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kchgceaud486svr1mx8tgtc5udus66jo18z6nc6cvwqzw9j4fx','v5rxhfap3gmqrjo', 'https://i.scdn.co/image/ab67616d0000b27382de1ca074ae63cb18fce335', 'Karol G Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dch7hhq7mid1kgj8i7qvppz8sgis0h6i3l893nyqnkzfi5iya8','TQG','v5rxhfap3gmqrjo',100,'POP','0DWdj2oZMBFSzRsi2Cvfzf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kchgceaud486svr1mx8tgtc5udus66jo18z6nc6cvwqzw9j4fx', 'dch7hhq7mid1kgj8i7qvppz8sgis0h6i3l893nyqnkzfi5iya8', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mhscsk5jrh2nv5if3nr3d35qj9d072l3mf3fmzris74qrjynqz','AMARGURA','v5rxhfap3gmqrjo',100,'POP','505v13epFXodT9fVAJ6h8k',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kchgceaud486svr1mx8tgtc5udus66jo18z6nc6cvwqzw9j4fx', 'mhscsk5jrh2nv5if3nr3d35qj9d072l3mf3fmzris74qrjynqz', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7jbv68iw7iy42o54jvqf8tm03qe9ezzoa91g1qhpmrxevu8hua','S91','v5rxhfap3gmqrjo',100,'POP','7EpOXgSRgnglRWr86pZfGU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kchgceaud486svr1mx8tgtc5udus66jo18z6nc6cvwqzw9j4fx', '7jbv68iw7iy42o54jvqf8tm03qe9ezzoa91g1qhpmrxevu8hua', '2');
-- Quevedo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('icbskm42rnhegnh', 'Quevedo', '33@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2394e996716534bc2c937a1a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:33@artist.com', 'icbskm42rnhegnh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('icbskm42rnhegnh', 'Merging lyrical depth with compelling urban beats.', 'Quevedo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hjemgo8clv4cgpsnjh6dc80ckyeckos55ll8qro1a9eluyuhqq','icbskm42rnhegnh', 'https://i.scdn.co/image/ab67616d0000b273a00a817b017c6f6bf8460be9', 'Quevedo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0f4f2hvz976cew606k8n4gi199q8ashakdldnogwdsmuwi6unz','Columbia','icbskm42rnhegnh',100,'POP','6XbtvPmIpyCbjuT0e8cQtp','https://p.scdn.co/mp3-preview/e3d6df66fe67f618166a2cab858580ac8a96486a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hjemgo8clv4cgpsnjh6dc80ckyeckos55ll8qro1a9eluyuhqq', '0f4f2hvz976cew606k8n4gi199q8ashakdldnogwdsmuwi6unz', '0');
-- Morgan Wallen
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jub60wfbk26caip', 'Morgan Wallen', '34@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21ed0100a3a4e5aa3c57f6dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:34@artist.com', 'jub60wfbk26caip', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jub60wfbk26caip', 'Blending country charm with rock energy to create memorable tunes.', 'Morgan Wallen');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6e2vj6xy61ku3i55fs9njmvjvp7nnvzpwn97mfup3lfz9zf04o','jub60wfbk26caip', 'https://i.scdn.co/image/ab67616d0000b273705079df9a25a28b452c1fc9', 'Morgan Wallen Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lvm6is87pemmni76gbv81alls3a899s8ip2bngoxvid7up0ia8','Last Night','jub60wfbk26caip',100,'POP','7K3BhSpAxZBznislvUMVtn',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6e2vj6xy61ku3i55fs9njmvjvp7nnvzpwn97mfup3lfz9zf04o', 'lvm6is87pemmni76gbv81alls3a899s8ip2bngoxvid7up0ia8', '0');
-- Fifty Fifty
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nv1i1iff2q073vp', 'Fifty Fifty', '35@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5a60b0f886b5deb8518e4a41','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:35@artist.com', 'nv1i1iff2q073vp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nv1i1iff2q073vp', 'Blending a rich array of genres to create a unique musical experience.', 'Fifty Fifty');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('egswo2ev5re8gsm480a5he4tqd9hxo53np358k7cdw5piy8rfe','nv1i1iff2q073vp', 'https://i.scdn.co/image/ab67616d0000b27337c0b3670236c067c8e8bbcb', 'Fifty Fifty Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('caschy3279ddnajrkpomvvu0f9hkdrj0hm2pv4qrkrb8pkknpi','Cupid - Twin Ver.','nv1i1iff2q073vp',100,'POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('egswo2ev5re8gsm480a5he4tqd9hxo53np358k7cdw5piy8rfe', 'caschy3279ddnajrkpomvvu0f9hkdrj0hm2pv4qrkrb8pkknpi', '0');
-- Jimin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('iljfckhxnsrbgnm', 'Jimin', '36@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb59f8cfc8e71dcaf8c6ec4bde','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:36@artist.com', 'iljfckhxnsrbgnm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('iljfckhxnsrbgnm', 'Known for his expressive voice and mesmerizing dance moves in BTS.', 'Jimin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('r3ciq48lzm19q7tqa2iw9okkrjy1sq8w29kieoyvmdqzyadjaa','iljfckhxnsrbgnm', 'https://i.scdn.co/image/ab67616d0000b2732b46078245d0120690eb560d', 'Jimin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8irqiz26w4qowfe38oul2sp6kix8b0zvtqs5yy1a0vwzgrszuh','Like Crazy','iljfckhxnsrbgnm',100,'POP','3Ua0m0YmEjrMi9XErKcNiR','https://p.scdn.co/mp3-preview/2db5f36096963d97afc870c50990d62d27858a43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r3ciq48lzm19q7tqa2iw9okkrjy1sq8w29kieoyvmdqzyadjaa', '8irqiz26w4qowfe38oul2sp6kix8b0zvtqs5yy1a0vwzgrszuh', '0');
-- Gunna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ivox2ewf8d67q0n', 'Gunna', '37@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6501f8a7d50c56e86e46f920','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:37@artist.com', 'ivox2ewf8d67q0n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ivox2ewf8d67q0n', 'A trailblazer in trap music, known for his smooth flow and catchy beats.', 'Gunna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uz8jdcx8nquw1gvfpzujcjqwfiqqxjkwa92ctj3dmzwy0m1m4f','ivox2ewf8d67q0n', 'https://i.scdn.co/image/ab67616d0000b273017d5e26552345c4b1575b6c', 'Gunna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n6o6ob68jyib3xndrpgm3sojf0xphktl3zdrtslrbxa53tdtzh','fukumean','ivox2ewf8d67q0n',100,'POP','4rXLjWdF2ZZpXCVTfWcshS','https://p.scdn.co/mp3-preview/f237ab921af697ba9b49e12fa167c2ce1a82d6b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uz8jdcx8nquw1gvfpzujcjqwfiqqxjkwa92ctj3dmzwy0m1m4f', 'n6o6ob68jyib3xndrpgm3sojf0xphktl3zdrtslrbxa53tdtzh', '0');
-- Jung Kook
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('n1tt7j565r51a1s', 'Jung Kook', '38@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:38@artist.com', 'n1tt7j565r51a1s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('n1tt7j565r51a1s', 'A member of BTS, captivating fans with his powerful vocals and dynamic performances.', 'Jung Kook');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ga77lbw8c7ru956ltrnbu96dls3mspmtuaouz0wgoxjskbn7ey','n1tt7j565r51a1s', 'https://i.scdn.co/image/ab67616d0000b273a7f42c375578df426b37638d', 'Jung Kook Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o61bvroq39pd8td0et3osz2mhccng0w6x75fi2adx4ds2ot63c','Still With You','n1tt7j565r51a1s',100,'POP','0eFMbKCRw8KByXyWBw8WO7','https://p.scdn.co/mp3-preview/af2a740e10a6956dedd7e7f66fd65d7166e9187f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ga77lbw8c7ru956ltrnbu96dls3mspmtuaouz0wgoxjskbn7ey', 'o61bvroq39pd8td0et3osz2mhccng0w6x75fi2adx4ds2ot63c', '0');
-- JVKE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mrrekhcq3mvmy8q', 'JVKE', '39@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebce33386a81a202e149934ec1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:39@artist.com', 'mrrekhcq3mvmy8q', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mrrekhcq3mvmy8q', 'A rising star, blending heartfelt lyrics with catchy pop melodies.', 'JVKE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zsdwbfyiaf5fy1bpd13ix2s5zhsai3sy4c9t3tb4ytanjk20xc','mrrekhcq3mvmy8q', 'https://i.scdn.co/image/ab67616d0000b273c2504e80ba2f258697ab2954', 'JVKE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5214ttlnzo4rlo6r71fx1y12bzznvko81m7k177mivjo21i29u','golden hour','mrrekhcq3mvmy8q',100,'POP','5odlY52u43F5BjByhxg7wg','https://p.scdn.co/mp3-preview/bcc17f30841d6fbf3cd7954c3e3cf669f11b6a21?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zsdwbfyiaf5fy1bpd13ix2s5zhsai3sy4c9t3tb4ytanjk20xc', '5214ttlnzo4rlo6r71fx1y12bzznvko81m7k177mivjo21i29u', '0');
-- NewJeans
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2via4medwzxk7sh', 'NewJeans', '40@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5da361915b1fa48895d4f23f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:40@artist.com', '2via4medwzxk7sh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2via4medwzxk7sh', 'Redefining K-pop with their fresh style and energetic performances.', 'NewJeans');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zvsq6prfzb2pxh9aro1slcj0unb7m25t0mqoscqvkttmkutq23','2via4medwzxk7sh', 'https://i.scdn.co/image/ab67616d0000b2733d98a0ae7c78a3a9babaf8af', 'NewJeans Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0adcreesmne4dj5x4xwpwxurth09rdbo6yxvhmrzm6kub1q5bl','Super Shy','2via4medwzxk7sh',100,'POP','5sdQOyqq2IDhvmx2lHOpwd','https://p.scdn.co/mp3-preview/dab062e2cc708a2680ce84953a3581c5a679a230?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zvsq6prfzb2pxh9aro1slcj0unb7m25t0mqoscqvkttmkutq23', '0adcreesmne4dj5x4xwpwxurth09rdbo6yxvhmrzm6kub1q5bl', '0');
-- OneRepublic
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cimq9n6qa3wan7q', 'OneRepublic', '41@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb57138b98e7ddd5a86ee97a9b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:41@artist.com', 'cimq9n6qa3wan7q', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cimq9n6qa3wan7q', 'Delivering anthemic pop-rock tracks that resonate globally.', 'OneRepublic');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('crohgj8twx2lglhaf86q6b0kmtflt3cuq9uc0l48rizbhw2e6i','cimq9n6qa3wan7q', 'https://i.scdn.co/image/ab67616d0000b273ec96e006b8bdfc582610ec13', 'OneRepublic Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1qriamjof0p7au0neuh1xpqb7itju9dizzpr17ovktblkyjtoq','I Aint Worried','cimq9n6qa3wan7q',100,'POP','4h9wh7iOZ0GGn8QVp4RAOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('crohgj8twx2lglhaf86q6b0kmtflt3cuq9uc0l48rizbhw2e6i', '1qriamjof0p7au0neuh1xpqb7itju9dizzpr17ovktblkyjtoq', '0');
-- Rauw Alejandro
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xpft9yfr1r3soy8', 'Rauw Alejandro', '42@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9047f938310ea16b68a5bdeb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:42@artist.com', 'xpft9yfr1r3soy8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xpft9yfr1r3soy8', 'A fusion of Latin trap and reggaeton, setting the stage on fire.', 'Rauw Alejandro');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6jzvmjelemufg9wy6jh8kythnhoe8tkrnp66uv7xfpd622lngd','xpft9yfr1r3soy8', NULL, 'Rauw Alejandro Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xv3idiaovwrzam6ebhiuetdtbshqsab6rofm9qlyndqm5bbs8c','BESO','xpft9yfr1r3soy8',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6jzvmjelemufg9wy6jh8kythnhoe8tkrnp66uv7xfpd622lngd', 'xv3idiaovwrzam6ebhiuetdtbshqsab6rofm9qlyndqm5bbs8c', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x4hnvcupo6d89wvw3huyjadr0e96ghnyvzdxbnhc4mb73hkn92','BABY HELLO','xpft9yfr1r3soy8',100,'POP','2SOvWt6igzXViIjIiWNWEP','https://p.scdn.co/mp3-preview/8a9ca6c81e6e6ad48758f02017456405fd7a476d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6jzvmjelemufg9wy6jh8kythnhoe8tkrnp66uv7xfpd622lngd', 'x4hnvcupo6d89wvw3huyjadr0e96ghnyvzdxbnhc4mb73hkn92', '1');
-- Eslabon Armado
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vegsdvaoo6x1o30', 'Eslabon Armado', '43@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:43@artist.com', 'vegsdvaoo6x1o30', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vegsdvaoo6x1o30', 'Bringing a fresh take to traditional music, weaving in modern influences.', 'Eslabon Armado');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ksy4amd505mjpvac1a0t8zvou273uedzdpcvivdchywyk1ofpl','vegsdvaoo6x1o30', 'https://i.scdn.co/image/ab67616d0000b2732071a0c79802d9375a53bfef', 'Eslabon Armado Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7l0t0jpcll7zcrqyis2re44tix1p0zwzchl60ksv3u8mh5r4c4','Ella Baila Sola','vegsdvaoo6x1o30',100,'POP','3dnP0JxCgygwQH9Gm7q7nb','https://p.scdn.co/mp3-preview/5d39f3e17f1e20e2711d033001e48b8d4249b992?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ksy4amd505mjpvac1a0t8zvou273uedzdpcvivdchywyk1ofpl', '7l0t0jpcll7zcrqyis2re44tix1p0zwzchl60ksv3u8mh5r4c4', '0');
-- Yahritza Y Su Esencia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fbhcdi7u0wni0si', 'Yahritza Y Su Esencia', '44@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68d4ccdc175f594122f1eee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:44@artist.com', 'fbhcdi7u0wni0si', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fbhcdi7u0wni0si', 'Infusing traditional melodies with youthful vigor.', 'Yahritza Y Su Esencia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yj94eyb7145n435144wnnoig3kguqb5c06jprf5en4l9hcnhh3','fbhcdi7u0wni0si', NULL, 'Yahritza Y Su Esencia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jcsipmkj84o1aqdl2cqo2h98fh65m8cz3iofgkz1rmvgxm780o','Frgil (feat. Grupo Front','fbhcdi7u0wni0si',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yj94eyb7145n435144wnnoig3kguqb5c06jprf5en4l9hcnhh3', 'jcsipmkj84o1aqdl2cqo2h98fh65m8cz3iofgkz1rmvgxm780o', '0');
-- J. Cole
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('doginaz5cckl7ew', 'J. Cole', '45@artist.com', 'https://i.scdn.co/image/ab67616d0000b273d092fc596478080bb0e06aea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:45@artist.com', 'doginaz5cckl7ew', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('doginaz5cckl7ew', 'A profound lyricist and rapper, known for his thought-provoking music.', 'J. Cole');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7aoa19usjpcvrjuknx4rlveqjfskw887yf5x4ucd8twfe47bue','doginaz5cckl7ew', NULL, 'J. Cole Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1tyqac8sffldask8sxivpxs27apfycnixqfhsp17qfl6di0q6i','All My Life (feat. J. Cole)','doginaz5cckl7ew',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7aoa19usjpcvrjuknx4rlveqjfskw887yf5x4ucd8twfe47bue', '1tyqac8sffldask8sxivpxs27apfycnixqfhsp17qfl6di0q6i', '0');
-- David Guetta
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s5w5fxd2wvr5k9i', 'David Guetta', '46@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:46@artist.com', 's5w5fxd2wvr5k9i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s5w5fxd2wvr5k9i', 'A legend in the electronic music world, constantly innovating and entertaining.', 'David Guetta');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('av8hjw5b8ujra8oaskxsb22kb39g9wou5owud4f1yot50s7sbk','s5w5fxd2wvr5k9i', 'https://i.scdn.co/image/ab67616d0000b2730b4ef75c3728599aa4104f7a', 'David Guetta Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('08uiwaqahwfaiz0vwzby96ft27f9cw952dlf1346biqddeilyi','Baby Dont Hurt Me','s5w5fxd2wvr5k9i',100,'POP','3BKD1PwArikchz2Zrlp1qi','https://p.scdn.co/mp3-preview/a8f2e176e17e0f6298b42ef8e96118318fdd2b89?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('av8hjw5b8ujra8oaskxsb22kb39g9wou5owud4f1yot50s7sbk', '08uiwaqahwfaiz0vwzby96ft27f9cw952dlf1346biqddeilyi', '0');
-- Luke Combs
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vo9zxczmakovgdr', 'Luke Combs', '47@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5db6179b28f7e3654898b279','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:47@artist.com', 'vo9zxczmakovgdr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vo9zxczmakovgdr', 'Reigniting country music with his powerful voice and relatable songs.', 'Luke Combs');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lyxur0v9zrsmkducueggsobem9bm5ez99kgkbbh3m4g3u9558z','vo9zxczmakovgdr', 'https://i.scdn.co/image/ab67616d0000b273ca650d3a95022e0490434ba1', 'Luke Combs Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yiu0vzjvyil7ssj0ohodd3lq8dkxmmpt19m44vb8468f3z1o3y','Fast Car','vo9zxczmakovgdr',100,'POP','1Lo0QY9cvc8sUB2vnIOxDT','https://p.scdn.co/mp3-preview/1dc0426c95058783e0fe1d70c41583ca98317108?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lyxur0v9zrsmkducueggsobem9bm5ez99kgkbbh3m4g3u9558z', 'yiu0vzjvyil7ssj0ohodd3lq8dkxmmpt19m44vb8468f3z1o3y', '0');
-- Justin Bieber
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f130h1u025256qp', 'Justin Bieber', '48@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:48@artist.com', 'f130h1u025256qp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('f130h1u025256qp', 'From teen idol to global pop star, constantly evolving his sound.', 'Justin Bieber');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jaz31q13wwlxgxg17s2kke4u4fg6k0rzi0jzawbefq9quyz8ye','f130h1u025256qp', NULL, 'Justin Bieber Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fekkw43xn1nlthh8l23h8prfy83ihcsbxggbxt9t1swe1lhej2','STAY (with Justin Bieber)','f130h1u025256qp',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jaz31q13wwlxgxg17s2kke4u4fg6k0rzi0jzawbefq9quyz8ye', 'fekkw43xn1nlthh8l23h8prfy83ihcsbxggbxt9t1swe1lhej2', '0');
-- Libianca
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0fzyhjjlz9upbdm', 'Libianca', '49@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a42e7c32ead029c0285c12f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:49@artist.com', '0fzyhjjlz9upbdm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0fzyhjjlz9upbdm', 'A fresh talent, blending Afrobeat rhythms with soulful melodies.', 'Libianca');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y1nx7iauqmv0241xw7j4ddisvkh4mi5kmjf6tq8dobyh3kw1ka','0fzyhjjlz9upbdm', 'https://i.scdn.co/image/ab67616d0000b273fc342f95f117d48dbdde9735', 'Libianca Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tjg4gv6qbo71cgqgd22r8bto6yy92tduiw2kzqus7ocul9q9kg','People','0fzyhjjlz9upbdm',100,'POP','26b3oVLrRUaaybJulow9kz','https://p.scdn.co/mp3-preview/abcbc9adf10ae4901b40b80a30dc194d589c2d62?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y1nx7iauqmv0241xw7j4ddisvkh4mi5kmjf6tq8dobyh3kw1ka', 'tjg4gv6qbo71cgqgd22r8bto6yy92tduiw2kzqus7ocul9q9kg', '0');
-- Rma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k7r4izmqveg3up7', 'Rma', '50@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0c8eb928813cd06614c0710d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:50@artist.com', 'k7r4izmqveg3up7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k7r4izmqveg3up7', 'Pioneering new sounds and delivering electrifying performances.', 'Rma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('97yhnwv2jsr5uk1l1evj21ymlsjbezmhatepzob74y9s9eusaw','k7r4izmqveg3up7', NULL, 'Rma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('63r4cv2htfux71wv8e7ubdpkxllrutzak7z8tw1806vb4ub7ld','Calm Down (with Selena Gomez)','k7r4izmqveg3up7',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('97yhnwv2jsr5uk1l1evj21ymlsjbezmhatepzob74y9s9eusaw', '63r4cv2htfux71wv8e7ubdpkxllrutzak7z8tw1806vb4ub7ld', '0');
-- Tom Odell
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2aie75t85xsc02w', 'Tom Odell', '51@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb532e8dd8ba9fbd5e78105a78','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:51@artist.com', '2aie75t85xsc02w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2aie75t85xsc02w', 'Stirring emotions with piano-driven melodies and poetic lyrics.', 'Tom Odell');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kzney4wn3e445p1yow0zyfj0poz8yz73wcxj2frzxwxqhaxf4a','2aie75t85xsc02w', 'https://i.scdn.co/image/ab67616d0000b2731917a0f3f4152622a040913f', 'Tom Odell Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h2w3oymnw4qyzzw35hkh044wl26heahry23i8h7jx32qsd4fex','Another Love','2aie75t85xsc02w',100,'POP','3JvKfv6T31zO0ini8iNItO','https://p.scdn.co/mp3-preview/0369cb748bc968ffd34fb4ac60f5403f2aad032f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kzney4wn3e445p1yow0zyfj0poz8yz73wcxj2frzxwxqhaxf4a', 'h2w3oymnw4qyzzw35hkh044wl26heahry23i8h7jx32qsd4fex', '0');
-- Ayparia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('55ebtwc3eenqyqb', 'Ayparia', '52@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb85a54675cc99eca02c11797a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:52@artist.com', '55ebtwc3eenqyqb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('55ebtwc3eenqyqb', 'Delivering a unique blend of sounds, showcasing versatility and artistic depth.', 'Ayparia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g9ryzo9siicjfq21jddamm54c6mr08tfzooqqb3sdy6bc6fsyr','55ebtwc3eenqyqb', NULL, 'Ayparia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x1jeisgqhdizvhxbc5c9hb3uutz5pz80wa4o12yqsn3oma1iaf','MONTAGEM - FR PUNK','55ebtwc3eenqyqb',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g9ryzo9siicjfq21jddamm54c6mr08tfzooqqb3sdy6bc6fsyr', 'x1jeisgqhdizvhxbc5c9hb3uutz5pz80wa4o12yqsn3oma1iaf', '0');
-- Chris Molitor
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9ckejn83bb1i8if', 'Chris Molitor', '53@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03851b1c2471a8c0b57371c4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:53@artist.com', '9ckejn83bb1i8if', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9ckejn83bb1i8if', 'Delivering heartfelt music that speaks to the soul, blending folk and indie vibes.', 'Chris Molitor');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tfpffri4gdit2hbkyh0hfssbft0696hawm8i561e0zb1zm7sgu','9ckejn83bb1i8if', 'https://i.scdn.co/image/ab67616d0000b273be011d16b9360a7dee109774', 'Chris Molitor Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9u6w64iyx47nh537fshgy39hik68kykpvz5sgasslehycjgaan','Yellow','9ckejn83bb1i8if',100,'POP','6tvs7zEP8d1SBgSqZQ84OT','https://p.scdn.co/mp3-preview/ea93f9b43fc638111ad661719037bfb88cd9c05d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tfpffri4gdit2hbkyh0hfssbft0696hawm8i561e0zb1zm7sgu', '9u6w64iyx47nh537fshgy39hik68kykpvz5sgasslehycjgaan', '0');
-- The Weeknd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('i4ukqc17vo008bx', 'The Weeknd', '54@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:54@artist.com', 'i4ukqc17vo008bx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('i4ukqc17vo008bx', 'A trailblazer in the world of R&B, constantly redefining the genre.', 'The Weeknd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('k8go8ot8ts5mpaj1phjmdycr8er0cpbffpzdonyae2md1yo73p','i4ukqc17vo008bx', NULL, 'The Weeknd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9kslj0x22jsg15bzurwd8i7enlk6bdllfbtyuh8c76t3rk1sos','Popular (with Playboi Carti & Madonna) - The Idol Vol. 1 (Music from the HBO Original Series)','i4ukqc17vo008bx',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k8go8ot8ts5mpaj1phjmdycr8er0cpbffpzdonyae2md1yo73p', '9kslj0x22jsg15bzurwd8i7enlk6bdllfbtyuh8c76t3rk1sos', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('muueo2m4gmn1xhi6gdymbieahy5rrk24e811zl9xjf7zg8rjzl','Creepin','i4ukqc17vo008bx',100,'POP','0GVaOXDGwtnH8gCURYyEaK','https://p.scdn.co/mp3-preview/a2b11e2f0cb8ef4a0316a686e73da9ec2b203e6e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k8go8ot8ts5mpaj1phjmdycr8er0cpbffpzdonyae2md1yo73p', 'muueo2m4gmn1xhi6gdymbieahy5rrk24e811zl9xjf7zg8rjzl', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ai0yq25ugizmzjqr16miazz1x20v34iqm4amvrpa4yuthdes72','Die For You','i4ukqc17vo008bx',100,'POP','2LBqCSwhJGcFQeTHMVGwy3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k8go8ot8ts5mpaj1phjmdycr8er0cpbffpzdonyae2md1yo73p', 'ai0yq25ugizmzjqr16miazz1x20v34iqm4amvrpa4yuthdes72', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g3jhx8ok64k9vbqji4qbfm84ve0gwvlee2grpf4ypn8uray7dj','Starboy','i4ukqc17vo008bx',100,'POP','7MXVkk9YMctZqd1Srtv4MB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k8go8ot8ts5mpaj1phjmdycr8er0cpbffpzdonyae2md1yo73p', 'g3jhx8ok64k9vbqji4qbfm84ve0gwvlee2grpf4ypn8uray7dj', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d4a4aftt2k780ph17xeyak5gfdjow3dlmozzuyfnv4x70os1ec','Blinding Lights','i4ukqc17vo008bx',100,'POP','0VjIjW4GlUZAMYd2vXMi3b',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k8go8ot8ts5mpaj1phjmdycr8er0cpbffpzdonyae2md1yo73p', 'd4a4aftt2k780ph17xeyak5gfdjow3dlmozzuyfnv4x70os1ec', '4');
-- Ariana Grande
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vgaz4pxzsrndtvn', 'Ariana Grande', '55@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb456c82553e0efcb7e13365b1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:55@artist.com', 'vgaz4pxzsrndtvn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vgaz4pxzsrndtvn', 'A powerhouse vocalist, dominating pop with her range and iconic style.', 'Ariana Grande');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vt142ymtnu7t2pdlu6a4tezynlte5xrkc8qc6ksmzexf16bqp9','vgaz4pxzsrndtvn', NULL, 'Ariana Grande Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v90fd86kvnqebi97o25w792p34p7rsng6lsf1nw6tbnmykowtw','Die For You - Remix','vgaz4pxzsrndtvn',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vt142ymtnu7t2pdlu6a4tezynlte5xrkc8qc6ksmzexf16bqp9', 'v90fd86kvnqebi97o25w792p34p7rsng6lsf1nw6tbnmykowtw', '0');
-- Coldplay
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nb1on2ryza8776m', 'Coldplay', '56@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb989ed05e1f0570cc4726c2d3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:56@artist.com', 'nb1on2ryza8776m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nb1on2ryza8776m', 'Global icons in rock, known for their anthemic songs and impactful lyrics.', 'Coldplay');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5miybx1cuak86jb8513znv72iqan0jgcgetgcf72c4ol29ne65','nb1on2ryza8776m', 'https://i.scdn.co/image/ab67616d0000b273e21cc1db05580b6f2d2a3b6e', 'Coldplay Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vfiz3p4kspehu8e92b3skdohoh78vom7ss4sxw6uv4kvhjtq3g','Viva La Vida','nb1on2ryza8776m',100,'POP','1mea3bSkSGXuIRvnydlB5b','https://p.scdn.co/mp3-preview/fb9f4a9b0887326776b4fb7c6d331acd167a7778?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5miybx1cuak86jb8513znv72iqan0jgcgetgcf72c4ol29ne65', 'vfiz3p4kspehu8e92b3skdohoh78vom7ss4sxw6uv4kvhjtq3g', '0');
-- Peso Pluma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u17pwxui8bn44j8', 'Peso Pluma', '57@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:57@artist.com', 'u17pwxui8bn44j8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u17pwxui8bn44j8', 'Infusing music with energetic beats and captivating lyrics.', 'Peso Pluma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2cnjmd0cuasl410kml8ml1i5efl335vrnf86eva6twlsbxiir7','u17pwxui8bn44j8', NULL, 'Peso Pluma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iy57c5r15qshav24j4yqs19i6ey1sjm7f7udnks32iih2w4ubh','La Bebe - Remix','u17pwxui8bn44j8',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2cnjmd0cuasl410kml8ml1i5efl335vrnf86eva6twlsbxiir7', 'iy57c5r15qshav24j4yqs19i6ey1sjm7f7udnks32iih2w4ubh', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ozlp274iem00mdnhjyxoayc8oiedqna80v7e5ae24fhsyqd4z2','TULUM','u17pwxui8bn44j8',100,'POP','7bPp2NmpmyhLJ7zWazAXMu','https://p.scdn.co/mp3-preview/164468e67b8da8053036c68533ffa473ab680c51?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2cnjmd0cuasl410kml8ml1i5efl335vrnf86eva6twlsbxiir7', 'ozlp274iem00mdnhjyxoayc8oiedqna80v7e5ae24fhsyqd4z2', '1');
-- Lana Del Rey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1soqkk39gs5y936', 'Lana Del Rey', '58@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb99cacf8acd5378206767261','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:58@artist.com', '1soqkk39gs5y936', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1soqkk39gs5y936', 'An ethereal presence in music, known for her cinematic and nostalgic sound.', 'Lana Del Rey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ocm2mmvkkzno188pqfmpw0uyl8zzryfy1s1guc2fbbokro2a5a','1soqkk39gs5y936', 'https://i.scdn.co/image/ab67616d0000b273aa27708d07f49c82ff0d0dae', 'Lana Del Rey Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o7d5k8lncydse9wv8halcjv5r6vcor92fozhdei9qpvzzhg1mn','Say Yes To Heaven','1soqkk39gs5y936',100,'POP','6GGtHZgBycCgGBUhZo81xe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocm2mmvkkzno188pqfmpw0uyl8zzryfy1s1guc2fbbokro2a5a', 'o7d5k8lncydse9wv8halcjv5r6vcor92fozhdei9qpvzzhg1mn', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8lfmibly2ccexw79eqlew66c6n2rmlzv9qybeb3q2udhnfpw4a','Summertime Sadness','1soqkk39gs5y936',100,'POP','1Ist6PR2BZR3n2z2Y5R6S1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocm2mmvkkzno188pqfmpw0uyl8zzryfy1s1guc2fbbokro2a5a', '8lfmibly2ccexw79eqlew66c6n2rmlzv9qybeb3q2udhnfpw4a', '1');
-- Kali Uchis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q45k7o3lwlgy7vb', 'Kali Uchis', '59@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:59@artist.com', 'q45k7o3lwlgy7vb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q45k7o3lwlgy7vb', 'A fusion of soul, R&B, and Latin beats, creating a unique sound experience.', 'Kali Uchis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zhii9xkev1fopl6af6nukrr1nmqlf1jn080a7woe9zrem1umj2','q45k7o3lwlgy7vb', 'https://i.scdn.co/image/ab67616d0000b27381fccd758776d16b87721b17', 'Kali Uchis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2xyoz5m0w971021g1qr9jhyh20hhej5hs8uok8occwgsp8jbx2','Moonlight','q45k7o3lwlgy7vb',100,'POP','0JmnkIqdlnUzPaf8sqBRs3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zhii9xkev1fopl6af6nukrr1nmqlf1jn080a7woe9zrem1umj2', '2xyoz5m0w971021g1qr9jhyh20hhej5hs8uok8occwgsp8jbx2', '0');
-- Tyler The Creator
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('n30jizkg3mhd9l0', 'Tyler The Creator', '60@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8278b782cbb5a3963db88ada','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:60@artist.com', 'n30jizkg3mhd9l0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('n30jizkg3mhd9l0', 'Pushing the boundaries of music with unique style and bold lyrics.', 'Tyler The Creator');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pfqq7zoca6w14uh1ws27qqofgqcp8dw71yxyxd3u5377g6o18z','n30jizkg3mhd9l0', 'https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3', 'Tyler The Creator Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c95oc3afdgdahunq00rcktoj1jga5ocih4vykm7gxkelvssc8v','See You Again','n30jizkg3mhd9l0',100,'POP','7KA4W4McWYRpgf0fWsJZWB','https://p.scdn.co/mp3-preview/c703198293891e3b276800ea6b187cf7951d3d7d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pfqq7zoca6w14uh1ws27qqofgqcp8dw71yxyxd3u5377g6o18z', 'c95oc3afdgdahunq00rcktoj1jga5ocih4vykm7gxkelvssc8v', '0');
-- Yandel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8nmaz3uwaq8oagz', 'Yandel', '61@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7dbaf2fabcbd4b37168397fd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:61@artist.com', '8nmaz3uwaq8oagz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8nmaz3uwaq8oagz', 'A powerhouse of reggaeton, blending rhythms that move the soul.', 'Yandel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8g1tqhd1qegsmgtfp82cjreh93him8b43t7m23ry35xd568zzx','8nmaz3uwaq8oagz', 'https://i.scdn.co/image/ab67616d0000b273b2aec01b56eeb74610532700', 'Yandel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7nhdz1c5km3c47salrkak0ne7angpq0dfrzk3wizh9r4uwbj82','Yandel 150','8nmaz3uwaq8oagz',100,'POP','4FAKtPVycI4DxoOHC01YqD','https://p.scdn.co/mp3-preview/338ed053ce26ccc3313b00b5e6153e60ffd2eb19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8g1tqhd1qegsmgtfp82cjreh93him8b43t7m23ry35xd568zzx', '7nhdz1c5km3c47salrkak0ne7angpq0dfrzk3wizh9r4uwbj82', '0');
-- Bad Bunny
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vctaagrqwol2ks2', 'Bad Bunny', '62@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9ad50e478a469448c6f369df','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:62@artist.com', 'vctaagrqwol2ks2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vctaagrqwol2ks2', 'A trailblazer in Latin trap and reggaeton, known for his charismatic style and innovative music.', 'Bad Bunny');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fq5l5de5y2qd0bo3tpxlg3c73bocgo0ydqirbe23vg18u30n7c','vctaagrqwol2ks2', 'https://i.scdn.co/image/ab67616d0000b273ab5c9cd818ad6ed3e9b79cd1', 'Bad Bunny Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iy227n2g34ptafbrpfrwfwbjq49p8rc84wvdzbi48n4psx4hlh','WHERE SHE GOES','vctaagrqwol2ks2',100,'POP','7ro0hRteUMfnOioTFI5TG1','https://p.scdn.co/mp3-preview/b9b7e4c982b33ee23c4867f7a3025e3598c35760?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fq5l5de5y2qd0bo3tpxlg3c73bocgo0ydqirbe23vg18u30n7c', 'iy227n2g34ptafbrpfrwfwbjq49p8rc84wvdzbi48n4psx4hlh', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jpq5ues2mcj85hwth5pc8ls3ys8xasx8yu190rkqr0g1jfy3ay','un x100to','vctaagrqwol2ks2',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fq5l5de5y2qd0bo3tpxlg3c73bocgo0ydqirbe23vg18u30n7c', 'jpq5ues2mcj85hwth5pc8ls3ys8xasx8yu190rkqr0g1jfy3ay', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3aek4jrhqigmc9hi4icodotl238jr3dbwqvcwm06sqihtyx1ey','Coco Chanel','vctaagrqwol2ks2',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fq5l5de5y2qd0bo3tpxlg3c73bocgo0ydqirbe23vg18u30n7c', '3aek4jrhqigmc9hi4icodotl238jr3dbwqvcwm06sqihtyx1ey', '2');
-- Arctic Monkeys
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z2txv6moormec2q', 'Arctic Monkeys', '63@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:63@artist.com', 'z2txv6moormec2q', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z2txv6moormec2q', 'Rock innovators, known for their sharp lyrics and compelling sound.', 'Arctic Monkeys');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i1d2nl3oht3p7h9qpip4l4vjp7ny7woo5m4ktcyvbe02avr2pv','z2txv6moormec2q', 'https://i.scdn.co/image/ab67616d0000b2734ae1c4c5c45aabe565499163', 'Arctic Monkeys Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3vxmrdt35vrud3fevsuiuwxonjagjib4fhnjzyps2vsi175ku6','I Wanna Be Yours','z2txv6moormec2q',100,'POP','5XeFesFbtLpXzIVDNQP22n','https://p.scdn.co/mp3-preview/07de30bde8363d9ff78b72339245c151f67af451?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i1d2nl3oht3p7h9qpip4l4vjp7ny7woo5m4ktcyvbe02avr2pv', '3vxmrdt35vrud3fevsuiuwxonjagjib4fhnjzyps2vsi175ku6', '0');
-- Junior H
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z7ci5hl2d9k1q2j', 'Junior H', '64@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5ccab5d3dc10a08d89cbd76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:64@artist.com', 'z7ci5hl2d9k1q2j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z7ci5hl2d9k1q2j', 'A fresh voice in regional Mexican music, blending tradition with modernity.', 'Junior H');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1cajvamag3a8fowvptu8iqg9ad6lqm1x5v8fjhspesi4xsbm18','z7ci5hl2d9k1q2j', 'https://i.scdn.co/image/ab67616d0000b27333ed356efed99b158c4267c6', 'Junior H Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hf346wzw1fmxl4yzljxucikk2erqtmmyj7qgdcg9p84d2qkg56','El Azul','z7ci5hl2d9k1q2j',100,'POP','1haJsMtoBhHfvuM7XWuT3W','https://p.scdn.co/mp3-preview/f9df136c3a2d3c0c5424e2c4b75a303f35c08af5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1cajvamag3a8fowvptu8iqg9ad6lqm1x5v8fjhspesi4xsbm18', 'hf346wzw1fmxl4yzljxucikk2erqtmmyj7qgdcg9p84d2qkg56', '0');
-- Post Malone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('g4vmo78dh5ohksq', 'Post Malone', '65@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:65@artist.com', 'g4vmo78dh5ohksq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('g4vmo78dh5ohksq', 'Blurring genre lines with his unique blend of hip-hop and pop.', 'Post Malone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ipj8589edkexc633gqah9onnded6v3nsnrfiqsds5rzqcuoc2j','g4vmo78dh5ohksq', 'https://i.scdn.co/image/ab67616d0000b2739478c87599550dd73bfa7e02', 'Post Malone Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6x1t821ag5bzraf4mgqrvnxn94h4anxlkdpaqqrvpt8l2xhurv','Sunflower - Spider-Man: Into the Spider-Verse','g4vmo78dh5ohksq',100,'POP','0RiRZpuVRbi7oqRdSMwhQY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ipj8589edkexc633gqah9onnded6v3nsnrfiqsds5rzqcuoc2j', '6x1t821ag5bzraf4mgqrvnxn94h4anxlkdpaqqrvpt8l2xhurv', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vj9hdosv24xvf44x3jirjwdi61ymvl56bgogfhyb7opqbjozma','Overdrive','g4vmo78dh5ohksq',100,'POP','3t0ic4mkhvhamrKDkulB8v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ipj8589edkexc633gqah9onnded6v3nsnrfiqsds5rzqcuoc2j', 'vj9hdosv24xvf44x3jirjwdi61ymvl56bgogfhyb7opqbjozma', '1');
-- PinkPantheress
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6uemnp3n985w22n', 'PinkPantheress', '66@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5168e912bd9bd91607cd07dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:66@artist.com', '6uemnp3n985w22n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6uemnp3n985w22n', 'Redefining pop music with her distinct sound and style.', 'PinkPantheress');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9isl8lah82nv7xstnairpfoqlp2mxjvuuvyoqdkk5dawa5sdw3','6uemnp3n985w22n', 'https://i.scdn.co/image/ab67616d0000b2739567e1aa41657425d046733b', 'PinkPantheress Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rwbqq8dw5stysrv2atexy0o4203rivwiupi9ngugw64zm2b73y','Boys a liar Pt. 2','6uemnp3n985w22n',100,'POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9isl8lah82nv7xstnairpfoqlp2mxjvuuvyoqdkk5dawa5sdw3', 'rwbqq8dw5stysrv2atexy0o4203rivwiupi9ngugw64zm2b73y', '0');
-- Lewis Capaldi
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1wl4zp7p0ovexw9', 'Lewis Capaldi', '67@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebea7538654040e553a7b0fc28','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:67@artist.com', '1wl4zp7p0ovexw9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1wl4zp7p0ovexw9', 'Delivering emotional ballads with his powerful, soul-stirring voice.', 'Lewis Capaldi');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3yhzmwav9epgzmlefv4614d2rn8oul73xdy5delajrkr20ikpk','1wl4zp7p0ovexw9', 'https://i.scdn.co/image/ab67616d0000b273fc2101e6889d6ce9025f85f2', 'Lewis Capaldi Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lxkbv0n2xsg7hqgyu3ahzrebctrxwg9i8cevxfsi1jzwfqasv3','Someone You Loved','1wl4zp7p0ovexw9',100,'POP','7qEHsqek33rTcFNT9PFqLf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3yhzmwav9epgzmlefv4614d2rn8oul73xdy5delajrkr20ikpk', 'lxkbv0n2xsg7hqgyu3ahzrebctrxwg9i8cevxfsi1jzwfqasv3', '0');
-- Glass Animals
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('otqovrab9kbjjo6', 'Glass Animals', '68@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb66b27eccb69756f8eceabc23','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:68@artist.com', 'otqovrab9kbjjo6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('otqovrab9kbjjo6', 'Crafting psychedelic pop with intricate melodies and immersive soundscapes.', 'Glass Animals');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rm73e7zal999zk5tov5fqbsdwon1krnlgcgdxwb1yusmyiskvt','otqovrab9kbjjo6', 'https://i.scdn.co/image/ab67616d0000b273712701c5e263efc8726b1464', 'Glass Animals Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0a36ahl07wtjuehpbl1a56d6nuwolzabwbipry0lx06oqcb2y8','Heat Waves','otqovrab9kbjjo6',100,'POP','3USxtqRwSYz57Ewm6wWRMp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rm73e7zal999zk5tov5fqbsdwon1krnlgcgdxwb1yusmyiskvt', '0a36ahl07wtjuehpbl1a56d6nuwolzabwbipry0lx06oqcb2y8', '0');
-- d4vd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1js3wj5qqf7g4v6', 'd4vd', '69@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad447187a35f422307e88ad3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:69@artist.com', '1js3wj5qqf7g4v6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1js3wj5qqf7g4v6', 'An alchemist of harmonies, transforming notes into gold.', 'd4vd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u5t8n08acykkvdna1kkuw0rvhykgrct22bu6e159n1dwf9mtn7','1js3wj5qqf7g4v6', 'https://i.scdn.co/image/ab67616d0000b27364fa1bda999f4fbd2b7c4bb7', 'd4vd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ycve1n8pmjor8jz8xqbk6n149acz6ojicr0ttzinqyb7h9lk0w','Here With Me','1js3wj5qqf7g4v6',100,'POP','5LrN7yUQAzvthd4QujgPFr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u5t8n08acykkvdna1kkuw0rvhykgrct22bu6e159n1dwf9mtn7', 'ycve1n8pmjor8jz8xqbk6n149acz6ojicr0ttzinqyb7h9lk0w', '0');
-- SZA
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mbynp63nl3iawlx', 'SZA', '70@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7eb7f6371aad8e67e01f0a03','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:70@artist.com', 'mbynp63nl3iawlx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mbynp63nl3iawlx', 'An avant-garde R&B artist painting vivid stories through her music.', 'SZA');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7bck730hd47y423iose8h0cdgkilo34ykmpduemngpag9fhsv5','mbynp63nl3iawlx', 'https://i.scdn.co/image/ab67616d0000b2730c471c36970b9406233842a5', 'SZA Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('osjzxf1bqg4kkrr7q5ox65ej0juj5lzhv1015aix73hhhf41n7','Kill Bill','mbynp63nl3iawlx',100,'POP','1Qrg8KqiBpW07V7PNxwwwL','https://p.scdn.co/mp3-preview/4bd2dc84016f3743add7eea8b988407b1b900672?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7bck730hd47y423iose8h0cdgkilo34ykmpduemngpag9fhsv5', 'osjzxf1bqg4kkrr7q5ox65ej0juj5lzhv1015aix73hhhf41n7', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nvb586n55x5qms4fg9csvmccs1hwvwg8off2uzv6lm462tuvkn','Snooze','mbynp63nl3iawlx',100,'POP','4iZ4pt7kvcaH6Yo8UoZ4s2','https://p.scdn.co/mp3-preview/8c53920b5fd2c3178afa36cac9eec68b5ee9204a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7bck730hd47y423iose8h0cdgkilo34ykmpduemngpag9fhsv5', 'nvb586n55x5qms4fg9csvmccs1hwvwg8off2uzv6lm462tuvkn', '1');
-- dennis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j8ufhy5kelv6sys', 'dennis', '71@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8a1ec9781a1542458b3b961b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:71@artist.com', 'j8ufhy5kelv6sys', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j8ufhy5kelv6sys', 'A tapestry of rhythms that echo the pulse of life.', 'dennis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sw2x43bj0lh221nw9hfixg5tdky1f4iv6yhlf9gbw9o9bj05an','j8ufhy5kelv6sys', 'https://i.scdn.co/image/ab67616d0000b273ddfc406de0d7dbc2e339f016', 'dennis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8lvkjeh938m8v61rbk67v3mirhegp257mvho29xd771egl4qog','T','j8ufhy5kelv6sys',100,'POP','35FW5OEe4p38LdjK1KqT2X','https://p.scdn.co/mp3-preview/eaa522f48564e43e33e00c011aef0489526d1072?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sw2x43bj0lh221nw9hfixg5tdky1f4iv6yhlf9gbw9o9bj05an', '8lvkjeh938m8v61rbk67v3mirhegp257mvho29xd771egl4qog', '0');
-- Manuel Turizo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('104pbabzown7j40', 'Manuel Turizo', '72@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebabd3e69b432d6187cf4e28c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:72@artist.com', '104pbabzown7j40', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('104pbabzown7j40', 'A standout in reggaeton, known for his smooth voice and romantic lyrics.', 'Manuel Turizo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('eta53odq2a27wupaa7jmqvwntbd2lxrt93257puj4bo01x4qqn','104pbabzown7j40', 'https://i.scdn.co/image/ab67616d0000b273c9f744b0d62da795bc21d04a', 'Manuel Turizo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vlyf8q2bu5hejx48byuaekeybcg7i2i01478buywrgiw5g71kv','La Bachata','104pbabzown7j40',100,'POP','5ww2BF9slyYgNOk37BlC4u','https://p.scdn.co/mp3-preview/0232b53fd7849e6696e1ab3099dd01dd00823f17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eta53odq2a27wupaa7jmqvwntbd2lxrt93257puj4bo01x4qqn', 'vlyf8q2bu5hejx48byuaekeybcg7i2i01478buywrgiw5g71kv', '0');
-- Chencho Corleone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('p9zj4tdox5uml9c', 'Chencho Corleone', '73@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2e862710857d2b3e1b5fb4f4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:73@artist.com', 'p9zj4tdox5uml9c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('p9zj4tdox5uml9c', 'A dynamic presence in reggaeton, known for his catchy beats and vibrant performances.', 'Chencho Corleone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xmkqvefoxc5j95048uhxc1jiz8k7939r97ml5z7w90gxpozzrt','p9zj4tdox5uml9c', NULL, 'Chencho Corleone Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2ccnwzu90kspu1v60z3sg8dm6b5eaa9xnwwohv6mj1rze283az','Me Porto Bonito','p9zj4tdox5uml9c',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xmkqvefoxc5j95048uhxc1jiz8k7939r97ml5z7w90gxpozzrt', '2ccnwzu90kspu1v60z3sg8dm6b5eaa9xnwwohv6mj1rze283az', '0');


-- File: insert_relationships.sql
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


