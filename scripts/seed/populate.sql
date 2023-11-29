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

DROP INDEX IF EXISTS idx_song_name_fulltext;

DROP INDEX IF EXISTS idx_artist_name_fulltext;

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
    "email" varchar(128) UNIQUE,
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
    "user_id" varchar(128) NOT NULL,
    CONSTRAINT "playlists_id_pk" PRIMARY KEY ("id"),
    FOREIGN KEY ("user_id") REFERENCES "auth_user" ("id")
);

-- Index Tables
CREATE TABLE "album_songs" (
    "album_id" varchar(128) NOT NULL,
    "song_id" varchar(128) NOT NULL,
    "order" int NOT NULL DEFAULT 0,
    CONSTRAINT "album_songs_album_id_song_id_pk" PRIMARY KEY("album_id", "song_id"),
    UNIQUE (song_id),
    FOREIGN KEY ("album_id") REFERENCES "album" ("id"),
    FOREIGN KEY ("song_id") REFERENCES "song" ("id")
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

-- Indexes
CREATE INDEX idx_song_name_fulltext ON "song" USING GIN (to_tsvector('simple', "name"));

CREATE INDEX idx_artist_name_fulltext ON "artist" USING GIN (to_tsvector('simple', "name"));

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
-- Vance Joy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('eqtfp09rx501c0w', 'Vance Joy', '0@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f074ec8c25406680bf26422','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:0@artist.com', 'eqtfp09rx501c0w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('eqtfp09rx501c0w', 'Crafting folk-pop anthems that resonate with heartfelt sincerity.', 'Vance Joy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('71xk4m01yz3pmyjwo3ja2ut1kvn5fosvyb11asdxagqr9uw7fg','eqtfp09rx501c0w', 'https://i.scdn.co/image/ab67616d0000b273a9929deb093a6617d2493b03', 'Vance Joy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rdzpezaz5gd9msownrerarkj9ydavb5bkz21jp6nf2awtqftc4','Riptide','eqtfp09rx501c0w','POP','3JvrhDOgAt6p7K8mDyZwRd','https://p.scdn.co/mp3-preview/74698d907d114f4ba0b2c129bbf260724be80b64?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('71xk4m01yz3pmyjwo3ja2ut1kvn5fosvyb11asdxagqr9uw7fg', 'rdzpezaz5gd9msownrerarkj9ydavb5bkz21jp6nf2awtqftc4', '0');
-- Leo Santana
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jcfab1240p86f2q', 'Leo Santana', '1@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9c301d2486e33ad58c85db8e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:1@artist.com', 'jcfab1240p86f2q', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jcfab1240p86f2q', 'The architect of aural landscapes that inspire and captivate.', 'Leo Santana');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kbg6636xrde6uqsoi124ghs01zef4m66r99wrxbghinpen0cqd','jcfab1240p86f2q', 'https://i.scdn.co/image/ab67616d0000b273d5efcc40f158ae827c28eee9', 'Leo Santana Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('duh3gt1nyph4kaj1luskqccc7toiil7i7flu1yz8by78tfrqie','Zona De Perigo','jcfab1240p86f2q','POP','4lsQKByQ7m1o6oEKdrJycU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kbg6636xrde6uqsoi124ghs01zef4m66r99wrxbghinpen0cqd', 'duh3gt1nyph4kaj1luskqccc7toiil7i7flu1yz8by78tfrqie', '0');
-- Fuerza Regida
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('indl6q9wrzn915m', 'Fuerza Regida', '2@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1b85fbf9507041aab224336d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:2@artist.com', 'indl6q9wrzn915m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('indl6q9wrzn915m', 'Revitalizing the regional music scene with their unique sound and powerful lyrics.', 'Fuerza Regida');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ix2zyw0i10adwjffytzbw0ddaidarkzgf1oyg72ecuvtad8m7u','indl6q9wrzn915m', 'https://i.scdn.co/image/ab67616d0000b273cfe3eb72c48b93971e53efd9', 'Fuerza Regida Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d5gwote0pc8qwxm712gxn9nkqx3mb3zyjvtazdhca8nudji29e','SABOR FRESA','indl6q9wrzn915m','POP','1UMm1Qs3u59Wvk53zBUE8r','https://p.scdn.co/mp3-preview/590ae0b69465339d97ef5db9f7e36fe0c452fbb4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ix2zyw0i10adwjffytzbw0ddaidarkzgf1oyg72ecuvtad8m7u', 'd5gwote0pc8qwxm712gxn9nkqx3mb3zyjvtazdhca8nudji29e', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d6sia8aor11u0k1h0klwluesk5off7fer0nwb8wzqockqqr0e4','TQM','indl6q9wrzn915m','POP','368eeEO3Y2uZUQ6S5oIjcu','https://p.scdn.co/mp3-preview/63f6b66cfcc3d7bd396dcbe18d6e3dee05fdb956?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ix2zyw0i10adwjffytzbw0ddaidarkzgf1oyg72ecuvtad8m7u', 'd6sia8aor11u0k1h0klwluesk5off7fer0nwb8wzqockqqr0e4', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wvjeyvzp5591nzimio2lrqr4p6ujcbna8onehmqeuypoccz4i5','Bebe Dame','indl6q9wrzn915m','POP','0IKeDy5bT9G0bA7ZixRT4A','https://p.scdn.co/mp3-preview/408ffb4fffcd26cda82f2b3cda7726ea1f6ebd74?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ix2zyw0i10adwjffytzbw0ddaidarkzgf1oyg72ecuvtad8m7u', 'wvjeyvzp5591nzimio2lrqr4p6ujcbna8onehmqeuypoccz4i5', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r6ok55kjqgbtsonljffqzoykiqvvz121qq3c61f7lrxvxhkhk6','Ch y la Pizza','indl6q9wrzn915m','POP','0UbesRsX2TtiCeamOIVEkp','https://p.scdn.co/mp3-preview/212acba217ff0304f6cbb41eb8f43cd27d991c7b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ix2zyw0i10adwjffytzbw0ddaidarkzgf1oyg72ecuvtad8m7u', 'r6ok55kjqgbtsonljffqzoykiqvvz121qq3c61f7lrxvxhkhk6', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('za4vg9r3tio0lu8s5btjco521k2bo9xe3cppaao8q0xgmutupl','Igualito a Mi Ap','indl6q9wrzn915m','POP','17js0w8GTkTUFGFM6PYvBd','https://p.scdn.co/mp3-preview/f0f87682468e9baa92562cd4d797ce8af5337ca6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ix2zyw0i10adwjffytzbw0ddaidarkzgf1oyg72ecuvtad8m7u', 'za4vg9r3tio0lu8s5btjco521k2bo9xe3cppaao8q0xgmutupl', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2jji358jdfiau47tkw26imvwm2g5cuaxbl8hvnn7b7yhhxybrf','Dijeron Que No La Iba Lograr','indl6q9wrzn915m','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ix2zyw0i10adwjffytzbw0ddaidarkzgf1oyg72ecuvtad8m7u', '2jji358jdfiau47tkw26imvwm2g5cuaxbl8hvnn7b7yhhxybrf', '5');
-- Luke Combs
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6bty75uv49lu50f', 'Luke Combs', '3@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5db6179b28f7e3654898b279','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:3@artist.com', '6bty75uv49lu50f', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6bty75uv49lu50f', 'Reigniting country music with his powerful voice and relatable songs.', 'Luke Combs');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('42y7q0z2mf5ujil762iat11etyxwc7mm98rksldrkbhevb6ek0','6bty75uv49lu50f', 'https://i.scdn.co/image/ab67616d0000b273ca650d3a95022e0490434ba1', 'Luke Combs Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xi1brm96bbt41z21w4tzu7uyzr36ehq5et1caokq9yh69cxqxj','Fast Car','6bty75uv49lu50f','POP','1Lo0QY9cvc8sUB2vnIOxDT','https://p.scdn.co/mp3-preview/1dc0426c95058783e0fe1d70c41583ca98317108?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('42y7q0z2mf5ujil762iat11etyxwc7mm98rksldrkbhevb6ek0', 'xi1brm96bbt41z21w4tzu7uyzr36ehq5et1caokq9yh69cxqxj', '0');
-- Beach Weather
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5kfwykg1gvzkv1k', 'Beach Weather', '4@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebed9ce2779a99efc01b4f918c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:4@artist.com', '5kfwykg1gvzkv1k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5kfwykg1gvzkv1k', 'Sculpting soundwaves into masterpieces of auditory art.', 'Beach Weather');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('js0ot7wh1gbd5141e8wfu5p8646755ujewhuve9xiwc956ros5','5kfwykg1gvzkv1k', 'https://i.scdn.co/image/ab67616d0000b273a03e3d24ccee1c370899c342', 'Beach Weather Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('76nipgok9a3jfgx4o6f97w6lw6038a8i5aymgjqcuxhqc2a1ki','Sex, Drugs, Etc.','5kfwykg1gvzkv1k','POP','7MlDNspYwfqnHxORufupwq','https://p.scdn.co/mp3-preview/a423aecddb590788a61f2a7b4d325bf461f88dc8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('js0ot7wh1gbd5141e8wfu5p8646755ujewhuve9xiwc956ros5', '76nipgok9a3jfgx4o6f97w6lw6038a8i5aymgjqcuxhqc2a1ki', '0');
-- Coi Leray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hr8cz70pnkn4als', 'Coi Leray', '5@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:5@artist.com', 'hr8cz70pnkn4als', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hr8cz70pnkn4als', 'Elevating the ordinary to extraordinary through music.', 'Coi Leray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qgmkvp1b8or0zb7o7a07tagcmwdnkd62ktjnxudj3o2buakyrr','hr8cz70pnkn4als', 'https://i.scdn.co/image/ab67616d0000b2735626453d29a0124dea22fb1b', 'Coi Leray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0mdjot2sdqe0wxme1dzrzu267illd625day51btkn7p8ycz315','Players','hr8cz70pnkn4als','POP','6UN73IYd0hZxLi8wFPMQij',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qgmkvp1b8or0zb7o7a07tagcmwdnkd62ktjnxudj3o2buakyrr', '0mdjot2sdqe0wxme1dzrzu267illd625day51btkn7p8ycz315', '0');
-- Keane
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('55lctpg7vkg9qks', 'Keane', '6@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41222a45dc0b10f65cbe8160','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:6@artist.com', '55lctpg7vkg9qks', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('55lctpg7vkg9qks', 'Where words fail, my music speaks.', 'Keane');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l0dgagb0hha2g1ywflgs8eszs654ajnu70hznfehbcydccg6ba','55lctpg7vkg9qks', 'https://i.scdn.co/image/ab67616d0000b273045d0a38105fbe7bde43c490', 'Keane Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jycm7ygfvme89cmpm1n6vw8z66o8q5fiwgyle6ilpr2o429ir5','Somewhere Only We Know','55lctpg7vkg9qks','POP','0ll8uFnc0nANY35E0Lfxvg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l0dgagb0hha2g1ywflgs8eszs654ajnu70hznfehbcydccg6ba', 'jycm7ygfvme89cmpm1n6vw8z66o8q5fiwgyle6ilpr2o429ir5', '0');
-- Myke Towers
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s6di7r7qqbqlor0', 'Myke Towers', '7@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9e35c3c5de877f99a8f6192f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:7@artist.com', 's6di7r7qqbqlor0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s6di7r7qqbqlor0', 'A rising star in Latin music, known for his distinctive flow.', 'Myke Towers');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qlxyykd2pgw2m5z66pjfzknechjoio2b424ixzma8lry2m0ii7','s6di7r7qqbqlor0', 'https://i.scdn.co/image/ab67616d0000b2730656d5ce813ca3cc4b677e05', 'Myke Towers Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8166k9lwf2kotvkmwde943ea05urfcbdrk5gizdy1usug5k54w','LALA','s6di7r7qqbqlor0','POP','7ABLbnD53cQK00mhcaOUVG','https://p.scdn.co/mp3-preview/42772b16b4e575d1b15b0ec7f94e335539390d2d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qlxyykd2pgw2m5z66pjfzknechjoio2b424ixzma8lry2m0ii7', '8166k9lwf2kotvkmwde943ea05urfcbdrk5gizdy1usug5k54w', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gi63ppli8yyi94r4p3z9kpi0t4swy1o93xx9j3q7zg48zh8eus','PLAYA DEL INGL','s6di7r7qqbqlor0','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qlxyykd2pgw2m5z66pjfzknechjoio2b424ixzma8lry2m0ii7', 'gi63ppli8yyi94r4p3z9kpi0t4swy1o93xx9j3q7zg48zh8eus', '1');
-- Bruno Mars
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('51uc425q51msm2m', 'Bruno Mars', '8@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc36dd9eb55fb0db4911f25dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:8@artist.com', '51uc425q51msm2m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('51uc425q51msm2m', 'Uniting fans around the globe with universal rhythms.', 'Bruno Mars');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mjhjwz2j6wp4ow0pcuaz8we87sraipvo3z6ogmw8lwoyk2vamm','51uc425q51msm2m', 'https://i.scdn.co/image/ab67616d0000b273926f43e7cce571e62720fd46', 'Bruno Mars Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j8llqaz5cf7lrd0o4yojtwrfyd8wok6oc6gef5w1i0xaxfshmp','Locked Out Of Heaven','51uc425q51msm2m','POP','3w3y8KPTfNeOKPiqUTakBh','https://p.scdn.co/mp3-preview/5a0318e6c43964786d22b9431af35490e96cff3d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mjhjwz2j6wp4ow0pcuaz8we87sraipvo3z6ogmw8lwoyk2vamm', 'j8llqaz5cf7lrd0o4yojtwrfyd8wok6oc6gef5w1i0xaxfshmp', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fcpmigibrhkwnr99xbth1brl36d3sylg0lfc2sj9xtl378gbkq','When I Was Your Man','51uc425q51msm2m','POP','0nJW01T7XtvILxQgC5J7Wh','https://p.scdn.co/mp3-preview/159fc05584217baa99581c4821f52d04670db6b2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mjhjwz2j6wp4ow0pcuaz8we87sraipvo3z6ogmw8lwoyk2vamm', 'fcpmigibrhkwnr99xbth1brl36d3sylg0lfc2sj9xtl378gbkq', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1v1spn9378yapd9zzkfejtg32y8uuznmmruau2fbhwcs3crrho','Just The Way You Are','51uc425q51msm2m','POP','7BqBn9nzAq8spo5e7cZ0dJ','https://p.scdn.co/mp3-preview/6d1a901b10c7dc609d4c8628006b04bc6e672be8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mjhjwz2j6wp4ow0pcuaz8we87sraipvo3z6ogmw8lwoyk2vamm', '1v1spn9378yapd9zzkfejtg32y8uuznmmruau2fbhwcs3crrho', '2');
-- JVKE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('26wuphsmoevkqkf', 'JVKE', '9@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebce33386a81a202e149934ec1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:9@artist.com', '26wuphsmoevkqkf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('26wuphsmoevkqkf', 'A rising star, blending heartfelt lyrics with catchy pop melodies.', 'JVKE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kpcq7tueg0rhbs7gjduu25n9tfm24hq6vxh7f22xyo1xp6vyh6','26wuphsmoevkqkf', 'https://i.scdn.co/image/ab67616d0000b273c2504e80ba2f258697ab2954', 'JVKE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xw72p988ke0cth4hfh07mog0k9ngkwlcrc02lee8ba7eajjrb3','golden hour','26wuphsmoevkqkf','POP','5odlY52u43F5BjByhxg7wg','https://p.scdn.co/mp3-preview/bcc17f30841d6fbf3cd7954c3e3cf669f11b6a21?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kpcq7tueg0rhbs7gjduu25n9tfm24hq6vxh7f22xyo1xp6vyh6', 'xw72p988ke0cth4hfh07mog0k9ngkwlcrc02lee8ba7eajjrb3', '0');
-- Em Beihold
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('i8dukwbew92vsk9', 'Em Beihold', '10@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb23c885de4c81852c917608ac','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:10@artist.com', 'i8dukwbew92vsk9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('i8dukwbew92vsk9', 'A voice that captivates, combining depth of lyrics with a melodic finesse.', 'Em Beihold');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zuiwlphvlxyeipaovxp4vhc7l7r6xgvkudp5x5ndhos6cn4k8s','i8dukwbew92vsk9', NULL, 'Em Beihold Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zsf47ywqhudmq0eclv2bxr7hruzls8gl4kbxruc40axybv2hka','Until I Found You (with Em Beihold) - Em Beihold Version','i8dukwbew92vsk9','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zuiwlphvlxyeipaovxp4vhc7l7r6xgvkudp5x5ndhos6cn4k8s', 'zsf47ywqhudmq0eclv2bxr7hruzls8gl4kbxruc40axybv2hka', '0');
-- Shubh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gprxvq9gyjhevrx', 'Shubh', '11@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3eac18e003a215ce96654ce1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:11@artist.com', 'gprxvq9gyjhevrx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gprxvq9gyjhevrx', 'Blending genres for a fresh musical experience.', 'Shubh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pkq0fyuc79nynayi7cdn9qlx1jfsox5it9d1ibb7qaax7d8995','gprxvq9gyjhevrx', 'https://i.scdn.co/image/ab67616d0000b2731a8c4618eda885a406958dd0', 'Shubh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s2lj3j3zb7k45p592fwjmiigiq68ifch9c4u7n0kjmm2j9epma','Cheques','gprxvq9gyjhevrx','POP','4eBvRhTJ2AcxCsbfTUjoRp','https://p.scdn.co/mp3-preview/c607b777f851d56dd524f845957e24901adbf1eb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pkq0fyuc79nynayi7cdn9qlx1jfsox5it9d1ibb7qaax7d8995', 's2lj3j3zb7k45p592fwjmiigiq68ifch9c4u7n0kjmm2j9epma', '0');
-- Yahritza Y Su Esencia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lddrejudly51lq1', 'Yahritza Y Su Esencia', '12@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68d4ccdc175f594122f1eee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:12@artist.com', 'lddrejudly51lq1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lddrejudly51lq1', 'Infusing traditional melodies with youthful vigor.', 'Yahritza Y Su Esencia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4mlnqea6akjnbffaf3o3cymlmve197j5q4d6dli566g7bsa06t','lddrejudly51lq1', NULL, 'Yahritza Y Su Esencia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l2afkm21hufds9luujclk4lq92my6pqeyee8htyhfdz1wl7a5v','Frgil (feat. Grupo Front','lddrejudly51lq1','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4mlnqea6akjnbffaf3o3cymlmve197j5q4d6dli566g7bsa06t', 'l2afkm21hufds9luujclk4lq92my6pqeyee8htyhfdz1wl7a5v', '0');
-- Frank Ocean
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1r8z8s2prkneym0', 'Frank Ocean', '13@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebee3123e593174208f9754fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:13@artist.com', '1r8z8s2prkneym0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1r8z8s2prkneym0', 'A tapestry of rhythms that echo the pulse of life.', 'Frank Ocean');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('acsk1jxfaqbybfx2t85kia3lw6r2y7nyltemlp859qcb721ape','1r8z8s2prkneym0', 'https://i.scdn.co/image/ab67616d0000b273c5649add07ed3720be9d5526', 'Frank Ocean Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('msj2px3g88z72zoia5961ckrrsgwx0gxjy1520bt121rb6r64y','Pink + White','1r8z8s2prkneym0','POP','3xKsf9qdS1CyvXSMEid6g8','https://p.scdn.co/mp3-preview/0e3ca894e19c37cbbbd511d9eb682d8bee030126?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('acsk1jxfaqbybfx2t85kia3lw6r2y7nyltemlp859qcb721ape', 'msj2px3g88z72zoia5961ckrrsgwx0gxjy1520bt121rb6r64y', '0');
-- Tyler
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b9hmhchx8eqbxwq', 'Tyler', '14@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8278b782cbb5a3963db88ada','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:14@artist.com', 'b9hmhchx8eqbxwq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b9hmhchx8eqbxwq', 'Crafting a unique sonic identity in every track.', 'Tyler');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hk8pm996npplcgv7m6admr05cyj23v7xer2e4j9nkmyte7p3ed','b9hmhchx8eqbxwq', 'https://i.scdn.co/image/ab67616d0000b273aa95a399fd30fbb4f6f59fca', 'Tyler Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5g3gp1extti1qfmfrerwufaxcogz0mkjw79eqo6u5ohdgozlvz','DOGTOOTH','b9hmhchx8eqbxwq','POP','6OfOzTitafSnsaunQLuNFw','https://p.scdn.co/mp3-preview/5de4c8c30108bc114f9f38a28ac0832936a852bf?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hk8pm996npplcgv7m6admr05cyj23v7xer2e4j9nkmyte7p3ed', '5g3gp1extti1qfmfrerwufaxcogz0mkjw79eqo6u5ohdgozlvz', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2cvgssa50u0jegpofn72xtez9zh8puqi17vy1m37269jk9s821','SORRY NOT SORRY','b9hmhchx8eqbxwq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hk8pm996npplcgv7m6admr05cyj23v7xer2e4j9nkmyte7p3ed', '2cvgssa50u0jegpofn72xtez9zh8puqi17vy1m37269jk9s821', '1');
-- Conan Gray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qygpihzx3mn5g7d', 'Conan Gray', '15@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc1c8fa15e08cb31eeb03b771','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:15@artist.com', 'qygpihzx3mn5g7d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qygpihzx3mn5g7d', 'Creating a tapestry of tunes that celebrates diversity.', 'Conan Gray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d78itr3fl58rvergi15v6tb7avb4ez0nqxyp6nwut6ctyzbihm','qygpihzx3mn5g7d', 'https://i.scdn.co/image/ab67616d0000b27388e3cda6d29b2552d4d6bc43', 'Conan Gray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('or9etry7bcmib51cn4xzh092g92x402hw7wuxb2iyeuebgdieq','Heather','qygpihzx3mn5g7d','POP','4xqrdfXkTW4T0RauPLv3WA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d78itr3fl58rvergi15v6tb7avb4ez0nqxyp6nwut6ctyzbihm', 'or9etry7bcmib51cn4xzh092g92x402hw7wuxb2iyeuebgdieq', '0');
-- Brray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pn85yq3r10vnw9w', 'Brray', '16@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2c7fe2c8895d2cd41e25aed6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:16@artist.com', 'pn85yq3r10vnw9w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pn85yq3r10vnw9w', 'The architect of aural landscapes that inspire and captivate.', 'Brray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t4l0d9uxnsjdg0956f7fpgl6nobji9cjt242gtqm1ee48v0plf','pn85yq3r10vnw9w', NULL, 'Brray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1v58022lb8bb5b381t8pha8tjukvlb20issrsfzvi5xs3vbi2k','LOKERA','pn85yq3r10vnw9w','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t4l0d9uxnsjdg0956f7fpgl6nobji9cjt242gtqm1ee48v0plf', '1v58022lb8bb5b381t8pha8tjukvlb20issrsfzvi5xs3vbi2k', '0');
-- Mc Livinho
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hrinqf6o2odzdwu', 'Mc Livinho', '17@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd353ef9564cfbb5f2b3bffb2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:17@artist.com', 'hrinqf6o2odzdwu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hrinqf6o2odzdwu', 'Bringing Brazilian funk rhythms to the global music stage.', 'Mc Livinho');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hmp2ljgvhyryl2zbn0penubz009vztmou7o1zu4n496f2pdr92','hrinqf6o2odzdwu', 'https://i.scdn.co/image/ab67616d0000b273369c960fed23353176da1218', 'Mc Livinho Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s7aq9g50t5gb8hyfvqaq8j5t9abv0wkt1f1yh3mpjv0iyg1q2w','Novidade na ','hrinqf6o2odzdwu','POP','2uhw2oYbugGJbn10wipNX5','https://p.scdn.co/mp3-preview/6bff8c1079d87a672d6b9ee5c3c6ca5e7d9ff45b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hmp2ljgvhyryl2zbn0penubz009vztmou7o1zu4n496f2pdr92', 's7aq9g50t5gb8hyfvqaq8j5t9abv0wkt1f1yh3mpjv0iyg1q2w', '0');
-- Billie Eilish
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('575un7pwpvrvfe9', 'Billie Eilish', '18@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd8b9980db67272cb4d2c3daf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:18@artist.com', '575un7pwpvrvfe9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('575un7pwpvrvfe9', 'An icon in modern pop, known for her haunting vocals and introspective lyrics.', 'Billie Eilish');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1tn18l0jvrmcwqgkra4yhjm2f0nwtzjcxp3e0dj80j340vvjc5','575un7pwpvrvfe9', NULL, 'Billie Eilish Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7l9mf815b87xy1cbq4qwlqpxl8j6i0te0il5fr7ofjqhavfzn8','What Was I Made For? [From The Motion Picture "Barbie"]','575un7pwpvrvfe9','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1tn18l0jvrmcwqgkra4yhjm2f0nwtzjcxp3e0dj80j340vvjc5', '7l9mf815b87xy1cbq4qwlqpxl8j6i0te0il5fr7ofjqhavfzn8', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ls4mio3xeuqzhtmocmepo7pfuixh97c3w0z8aka84q77kimrl1','lovely - Bonus Track','575un7pwpvrvfe9','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1tn18l0jvrmcwqgkra4yhjm2f0nwtzjcxp3e0dj80j340vvjc5', 'ls4mio3xeuqzhtmocmepo7pfuixh97c3w0z8aka84q77kimrl1', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('77afzq8gd2srtcm7homs8120fw100om6izgf2wbmlsa70mgmq2','TV','575un7pwpvrvfe9','POP','3GYlZ7tbxLOxe6ewMNVTkw',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1tn18l0jvrmcwqgkra4yhjm2f0nwtzjcxp3e0dj80j340vvjc5', '77afzq8gd2srtcm7homs8120fw100om6izgf2wbmlsa70mgmq2', '2');
-- Melanie Martinez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e95u21k33pga83q', 'Melanie Martinez', '19@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb77ecd63aaebe2225b07c89f0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:19@artist.com', 'e95u21k33pga83q', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e95u21k33pga83q', 'A voice that echoes the sentiments of a generation.', 'Melanie Martinez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kovra2elym27imdn9j4adfn0saujsozqs2z7qag47zgz7boln5','e95u21k33pga83q', 'https://i.scdn.co/image/ab67616d0000b2733c6c534cdacc9cf53e6d2977', 'Melanie Martinez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rrkbvyhl0rlw0fczo4rlkcrbl80oq883vk83evghx3tc2k9wa8','VOID','e95u21k33pga83q','POP','6wmKvtSmyTqHNo44OBXVN1','https://p.scdn.co/mp3-preview/9a2ae9278ecfe2ed8d628dfe05699bf24395d6a0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kovra2elym27imdn9j4adfn0saujsozqs2z7qag47zgz7boln5', 'rrkbvyhl0rlw0fczo4rlkcrbl80oq883vk83evghx3tc2k9wa8', '0');
-- Lost Frequencies
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k9v3vp9qrlixuqt', 'Lost Frequencies', '20@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfd28880f1b1fa8f93d05eb76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:20@artist.com', 'k9v3vp9qrlixuqt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k9v3vp9qrlixuqt', 'A maestro of melodies, orchestrating auditory bliss.', 'Lost Frequencies');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2zr6clezvzb3mzwsral3ryz7bga8ay4fqi2r42po8lvl44lm8z','k9v3vp9qrlixuqt', 'https://i.scdn.co/image/ab67616d0000b2738d7a7f1855b04104ba59c18b', 'Lost Frequencies Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oiy7bd5b5trw0zz19wacrxk1excu7enzm7vc22lxf1360all8w','Where Are You Now','k9v3vp9qrlixuqt','POP','3uUuGVFu1V7jTQL60S1r8z','https://p.scdn.co/mp3-preview/e2646d5bc8c56e4a91582a03c089f8038772aecb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2zr6clezvzb3mzwsral3ryz7bga8ay4fqi2r42po8lvl44lm8z', 'oiy7bd5b5trw0zz19wacrxk1excu7enzm7vc22lxf1360all8w', '0');
-- Marshmello
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sr22zm31pq6mtv9', 'Marshmello', '21@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41e4a3b8c1d45a9e49b6de21','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:21@artist.com', 'sr22zm31pq6mtv9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sr22zm31pq6mtv9', 'An electronic music maestro known for his infectious beats.', 'Marshmello');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ph5bdlk84ox96kgplpv4huhfftm7ztfudrt2r8hsr7flvnvp9w','sr22zm31pq6mtv9', 'https://i.scdn.co/image/ab67616d0000b273f404676577626a87d92cf33f', 'Marshmello Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rxt44a8n25lu90uxf51zo1fojeak1uti06magkoq59v6u4dg2s','El Merengue','sr22zm31pq6mtv9','POP','51FvjPEGKq2zByeeEQ43V9','https://p.scdn.co/mp3-preview/a933b6e1d6a47e591c13192f2b5e58739d3d5a06?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ph5bdlk84ox96kgplpv4huhfftm7ztfudrt2r8hsr7flvnvp9w', 'rxt44a8n25lu90uxf51zo1fojeak1uti06magkoq59v6u4dg2s', '0');
-- Bomba Estreo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y0fpiso23dz0hxa', 'Bomba Estreo', '22@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcc4d7c642f167846d8aa743b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:22@artist.com', 'y0fpiso23dz0hxa', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y0fpiso23dz0hxa', 'A confluence of cultural beats and contemporary tunes.', 'Bomba Estreo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u0zwyl5350twfu0t5bd38shqyfnwp0ahnsq4vn3bwyt9zpi1to','y0fpiso23dz0hxa', NULL, 'Bomba Estreo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sj6t1k2oh1k0vh1uhsoio5hqz4gjw542zn0u9zfnyy489f4vvm','Ojitos Lindos','y0fpiso23dz0hxa','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u0zwyl5350twfu0t5bd38shqyfnwp0ahnsq4vn3bwyt9zpi1to', 'sj6t1k2oh1k0vh1uhsoio5hqz4gjw542zn0u9zfnyy489f4vvm', '0');
-- Steve Lacy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fj3v7ik333uapci', 'Steve Lacy', '23@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb09ac9d040c168d4e4f58eb42','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:23@artist.com', 'fj3v7ik333uapci', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fj3v7ik333uapci', 'Pioneering new paths in the musical landscape.', 'Steve Lacy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zi631l4exprvr1v6eaz5nydqu0vbfztwgndz7om9td4zyg1pax','fj3v7ik333uapci', 'https://i.scdn.co/image/ab67616d0000b27368968350c2550e36d96344ee', 'Steve Lacy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('usk3tpj6jdhlrk7k2fniuz43uwf5t7wpc69gdasrp0fombjx47','Bad Habit','fj3v7ik333uapci','POP','4k6Uh1HXdhtusDW5y8Gbvy','https://p.scdn.co/mp3-preview/efe7c2fdd8fa727a108a1270b114ebedabfd766c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zi631l4exprvr1v6eaz5nydqu0vbfztwgndz7om9td4zyg1pax', 'usk3tpj6jdhlrk7k2fniuz43uwf5t7wpc69gdasrp0fombjx47', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m7ixayu3rutycn8w6ueyrhr8l177enlgtfihhsyg1h6qpsp7k3','Dark Red','fj3v7ik333uapci','POP','3EaJDYHA0KnX88JvDhL9oa','https://p.scdn.co/mp3-preview/90b3855fd50a4c4878a2d5117ebe73f658a97285?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zi631l4exprvr1v6eaz5nydqu0vbfztwgndz7om9td4zyg1pax', 'm7ixayu3rutycn8w6ueyrhr8l177enlgtfihhsyg1h6qpsp7k3', '1');
-- Lewis Capaldi
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8jjpzf5dt39wkcf', 'Lewis Capaldi', '24@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebea7538654040e553a7b0fc28','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:24@artist.com', '8jjpzf5dt39wkcf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8jjpzf5dt39wkcf', 'Delivering emotional ballads with his powerful, soul-stirring voice.', 'Lewis Capaldi');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bjby7s6h35swesm3f1cfe3ltbsqspftyxdg1l9pmrs0o4flbxr','8jjpzf5dt39wkcf', 'https://i.scdn.co/image/ab67616d0000b273fc2101e6889d6ce9025f85f2', 'Lewis Capaldi Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z4paj0ev7zuaja4r237jy6mda35uejl48h0eaf7a47q4s0vk0e','Someone You Loved','8jjpzf5dt39wkcf','POP','7qEHsqek33rTcFNT9PFqLf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bjby7s6h35swesm3f1cfe3ltbsqspftyxdg1l9pmrs0o4flbxr', 'z4paj0ev7zuaja4r237jy6mda35uejl48h0eaf7a47q4s0vk0e', '0');
-- Tyler The Creator
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kgxlexj2p14bwkj', 'Tyler The Creator', '25@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:25@artist.com', 'kgxlexj2p14bwkj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kgxlexj2p14bwkj', 'Pushing the boundaries of music with unique style and bold lyrics.', 'Tyler The Creator');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lz7zrmbkopulnhf0ht01xq738kuzgl99y7mn9x13nlepcd1iwg','kgxlexj2p14bwkj', 'https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3', 'Tyler The Creator Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qygbmcrdvfbaozup0xasp500kawzanhm5v5i849fzynniwqb7o','See You Again','kgxlexj2p14bwkj','POP','7KA4W4McWYRpgf0fWsJZWB','https://p.scdn.co/mp3-preview/c703198293891e3b276800ea6b187cf7951d3d7d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lz7zrmbkopulnhf0ht01xq738kuzgl99y7mn9x13nlepcd1iwg', 'qygbmcrdvfbaozup0xasp500kawzanhm5v5i849fzynniwqb7o', '0');
-- Taiu
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vd51oxtl6iux3u5', 'Taiu', '26@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdb80abf52d59577d244b8019','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:26@artist.com', 'vd51oxtl6iux3u5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vd51oxtl6iux3u5', 'Sculpting soundwaves into masterpieces of auditory art.', 'Taiu');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('q8bv0ban8ntqc8hz5j2nmtxud9jlfl6ikfkmfp8vhb8kgo4faq','vd51oxtl6iux3u5', 'https://i.scdn.co/image/ab67616d0000b273d467bed4e6b2a01ea8569100', 'Taiu Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vbqe9nz17t8voc16a65d68tb8rucst0taqi9qw9x0hs30bnkup','Rara Vez','vd51oxtl6iux3u5','POP','7MVIfkyzuUmQ716j8U7yGR',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q8bv0ban8ntqc8hz5j2nmtxud9jlfl6ikfkmfp8vhb8kgo4faq', 'vbqe9nz17t8voc16a65d68tb8rucst0taqi9qw9x0hs30bnkup', '0');
-- Nicky Youre
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('608iev75alad5yr', 'Nicky Youre', '27@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe726c8549d387a241f979acd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:27@artist.com', '608iev75alad5yr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('608iev75alad5yr', 'A unique voice in the contemporary music scene.', 'Nicky Youre');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vkckcm09rlk28lvkgo3trnvgvdye0rpth4uvyu4n5byxfz8kdq','608iev75alad5yr', 'https://i.scdn.co/image/ab67616d0000b273ecd970d1d2623b6c7fc6080c', 'Nicky Youre Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n73rrdgebewy7jxn284r94vth8wkde7wu23r7n86898fa8vxmz','Sunroof','608iev75alad5yr','POP','5YqEzk3C5c3UZ1D5fJUlXA','https://p.scdn.co/mp3-preview/605058558fd8d10c420b56c41555e567645d5b60?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vkckcm09rlk28lvkgo3trnvgvdye0rpth4uvyu4n5byxfz8kdq', 'n73rrdgebewy7jxn284r94vth8wkde7wu23r7n86898fa8vxmz', '0');
-- Kaifi Khalil
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('78fhhgfwva96xpm', 'Kaifi Khalil', '28@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8b3d777345ecd2f25f408586','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:28@artist.com', '78fhhgfwva96xpm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('78fhhgfwva96xpm', 'A maestro of melodies, orchestrating auditory bliss.', 'Kaifi Khalil');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xvjrs8axcdyjatd7s7bug4a6hs34dfvp24sre85hy76bs17tl5','78fhhgfwva96xpm', 'https://i.scdn.co/image/ab67616d0000b2734697d4ee22b3f63c17a3b9ec', 'Kaifi Khalil Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ev1p5qquz6w0lmcp7q6ga8k9anpoda5gy16kkeemmph5tox83o','Kahani Suno 2.0','78fhhgfwva96xpm','POP','4VsP4Dm8gsibRxB5I2hEkw','https://p.scdn.co/mp3-preview/2c644e9345d1a0ab97e4541d26b6b8ccb2c889f9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xvjrs8axcdyjatd7s7bug4a6hs34dfvp24sre85hy76bs17tl5', 'ev1p5qquz6w0lmcp7q6ga8k9anpoda5gy16kkeemmph5tox83o', '0');
-- Miley Cyrus
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m5joqyuadtkl53u', 'Miley Cyrus', '29@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5af3b38f053486ab0784dee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:29@artist.com', 'm5joqyuadtkl53u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m5joqyuadtkl53u', 'Constantly evolving, from pop sensation to rock powerhouse.', 'Miley Cyrus');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gsty1m15dqx603jcko8z0zak7am92uexahhzg1go3lbmxj43ne','m5joqyuadtkl53u', 'https://i.scdn.co/image/ab67616d0000b273cd222052a2594be29a6616b5', 'Miley Cyrus Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hdw1rrijtsyqzmshebypj3bok7tb6poe8v00mqyuog3fhbku3u','Flowers','m5joqyuadtkl53u','POP','7DSAEUvxU8FajXtRloy8M0','https://p.scdn.co/mp3-preview/5184d19d1b7fcc3e7c067e38af45a7cc80851440?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gsty1m15dqx603jcko8z0zak7am92uexahhzg1go3lbmxj43ne', 'hdw1rrijtsyqzmshebypj3bok7tb6poe8v00mqyuog3fhbku3u', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r2l8unvvwp9dmafha643b3ti95dxp6czif1stgiu0jov96v5nd','Angels Like You','m5joqyuadtkl53u','POP','1daDRI9ahBonbWD8YcxOIB','https://p.scdn.co/mp3-preview/4db8314199c0d49e95c786792ecd06eadae9f510?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gsty1m15dqx603jcko8z0zak7am92uexahhzg1go3lbmxj43ne', 'r2l8unvvwp9dmafha643b3ti95dxp6czif1stgiu0jov96v5nd', '1');
-- Chris Brown
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wd1iloyc5skt3n1', 'Chris Brown', '30@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba48397e590a1c70e2cda7728','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:30@artist.com', 'wd1iloyc5skt3n1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wd1iloyc5skt3n1', 'Exploring the depths of sound and rhythm.', 'Chris Brown');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fubqytgro1xeruexmfb70nphopc1rm4opdr7a4qdj538n1hgee','wd1iloyc5skt3n1', 'https://i.scdn.co/image/ab67616d0000b2739a494f7d8909a6cc4ceb74ac', 'Chris Brown Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q8c8hzoxn87rcyr8rv0tp1qksxgu0yi33970ollxv721olcu1q','Under The Influence','wd1iloyc5skt3n1','POP','5IgjP7X4th6nMNDh4akUHb','https://p.scdn.co/mp3-preview/52295df71df20e33e1510e3983975cd59f6664a4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fubqytgro1xeruexmfb70nphopc1rm4opdr7a4qdj538n1hgee', 'q8c8hzoxn87rcyr8rv0tp1qksxgu0yi33970ollxv721olcu1q', '0');
-- Latto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2svqzjqpbt4gri3', 'Latto', '31@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:31@artist.com', '2svqzjqpbt4gri3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2svqzjqpbt4gri3', 'A bold and dynamic rapper, making waves with her fiery lyrics.', 'Latto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('72k37xabjuatoz1vxn1ugvj738snxgktfpqincbz714jgi7tqf','2svqzjqpbt4gri3', NULL, 'Latto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gv3fc6c7wm7evq5sovh8w5huhnayvfhzoor4vij1p4bnol6r83','Seven (feat. Latto) (Explicit Ver.)','2svqzjqpbt4gri3','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('72k37xabjuatoz1vxn1ugvj738snxgktfpqincbz714jgi7tqf', 'gv3fc6c7wm7evq5sovh8w5huhnayvfhzoor4vij1p4bnol6r83', '0');
-- Treyce
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wh7jkftwxvw7vmn', 'Treyce', '32@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7b48fa6e2c8280e205c5ea7b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:32@artist.com', 'wh7jkftwxvw7vmn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wh7jkftwxvw7vmn', 'A harmonious blend of passion and creativity.', 'Treyce');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i4ir3hoz586vtcejekprz3efxg18i6hk5i9tuosr5o0jz6alta','wh7jkftwxvw7vmn', NULL, 'Treyce Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('18duhyyj09lh3smfkuusgs8m15zepqx32exgcpoemcd6pfvrje','Lovezinho','wh7jkftwxvw7vmn','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i4ir3hoz586vtcejekprz3efxg18i6hk5i9tuosr5o0jz6alta', '18duhyyj09lh3smfkuusgs8m15zepqx32exgcpoemcd6pfvrje', '0');
-- Dave
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4osaf2tj4sx5ffh', 'Dave', '33@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:33@artist.com', '4osaf2tj4sx5ffh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4osaf2tj4sx5ffh', 'A master of words, blending rap with social commentary and raw emotion.', 'Dave');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('s409cb0ykjkn00gjrr8qn0bgp2pbdb7g3sswr3fdwj0o80enx1','4osaf2tj4sx5ffh', 'https://i.scdn.co/image/ab67616d0000b273e3a09a9ae3f1fa102c110e60', 'Dave Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2w80uqguadkppjd6c5vu3rcwz86lnfs79su52uwmyu631e31kq','Sprinter','4osaf2tj4sx5ffh','POP','2FDTHlrBguDzQkp7PVj16Q',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s409cb0ykjkn00gjrr8qn0bgp2pbdb7g3sswr3fdwj0o80enx1', '2w80uqguadkppjd6c5vu3rcwz86lnfs79su52uwmyu631e31kq', '0');
-- OneRepublic
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pf2bucftafbui39', 'OneRepublic', '34@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb57138b98e7ddd5a86ee97a9b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:34@artist.com', 'pf2bucftafbui39', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pf2bucftafbui39', 'Delivering anthemic pop-rock tracks that resonate globally.', 'OneRepublic');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wl92vbim860h6fsdwaidhkbm0ia1oxtffpdolsvlfxuqrr8qcs','pf2bucftafbui39', 'https://i.scdn.co/image/ab67616d0000b273ec96e006b8bdfc582610ec13', 'OneRepublic Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('74ypdqln1a71mjwclbqtfuxfxf0unihdg7a66r1le4nqlgi5vt','I Aint Worried','pf2bucftafbui39','POP','4h9wh7iOZ0GGn8QVp4RAOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wl92vbim860h6fsdwaidhkbm0ia1oxtffpdolsvlfxuqrr8qcs', '74ypdqln1a71mjwclbqtfuxfxf0unihdg7a66r1le4nqlgi5vt', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y0lra6eb50755e74ukwwhool9thnwaisl7u6t1xy8pse4nimgr','Counting Stars','pf2bucftafbui39','POP','2tpWsVSb9UEmDRxAl1zhX1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wl92vbim860h6fsdwaidhkbm0ia1oxtffpdolsvlfxuqrr8qcs', 'y0lra6eb50755e74ukwwhool9thnwaisl7u6t1xy8pse4nimgr', '1');
-- Tom Odell
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x0tysggxi2vsgm4', 'Tom Odell', '35@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb532e8dd8ba9fbd5e78105a78','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:35@artist.com', 'x0tysggxi2vsgm4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x0tysggxi2vsgm4', 'Stirring emotions with piano-driven melodies and poetic lyrics.', 'Tom Odell');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1o40gtyqjzndhxs71a0ttdcd4gl16uibnmck8db7s0egudejtv','x0tysggxi2vsgm4', 'https://i.scdn.co/image/ab67616d0000b2731917a0f3f4152622a040913f', 'Tom Odell Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qvde8z6qweeh7qwscta6ydkq9pydydah1te3abbqldb7ne9fk7','Another Love','x0tysggxi2vsgm4','POP','3JvKfv6T31zO0ini8iNItO','https://p.scdn.co/mp3-preview/0369cb748bc968ffd34fb4ac60f5403f2aad032f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1o40gtyqjzndhxs71a0ttdcd4gl16uibnmck8db7s0egudejtv', 'qvde8z6qweeh7qwscta6ydkq9pydydah1te3abbqldb7ne9fk7', '0');
-- Taylor Swift
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3qy25ogwngy9dhx', 'Taylor Swift', '36@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb859e4c14fa59296c8649e0e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:36@artist.com', '3qy25ogwngy9dhx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3qy25ogwngy9dhx', 'A storytelling icon, weaving life experiences into musical masterpieces.', 'Taylor Swift');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb','3qy25ogwngy9dhx', 'https://i.scdn.co/image/ab67616d0000b273e787cffec20aa2a396a61647', 'Taylor Swift Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1q5oynu39x6h4x3pftrcucwbyr07mz67xnxv834wotxfxkbt0p','Cruel Summer','3qy25ogwngy9dhx','POP','1BxfuPKGuaTgP7aM0Bbdwr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', '1q5oynu39x6h4x3pftrcucwbyr07mz67xnxv834wotxfxkbt0p', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oqqvkrvwew31s2wwtabkm147gqin4o0xsxlsl57m77v26e2d4b','I Can See You (Taylors Version) (From The ','3qy25ogwngy9dhx','POP','5kHMfzgLZP95O9NBy0ku4v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'oqqvkrvwew31s2wwtabkm147gqin4o0xsxlsl57m77v26e2d4b', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rwb1xnecgtojb48hwkkgpz080lmnywwerqdng035pwmriu3wjv','Anti-Hero','3qy25ogwngy9dhx','POP','0V3wPSX9ygBnCm8psDIegu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'rwb1xnecgtojb48hwkkgpz080lmnywwerqdng035pwmriu3wjv', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rfh9lypy042uh1urtijv8de6csa5a7r9s3x8pqdavfmxfuh6er','Blank Space','3qy25ogwngy9dhx','POP','1p80LdxRV74UKvL8gnD7ky',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'rfh9lypy042uh1urtijv8de6csa5a7r9s3x8pqdavfmxfuh6er', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3r6m301nun5e7qpde1tueanlvg4lshz7xbhwm0eidia0tpy67h','Style','3qy25ogwngy9dhx','POP','1hjRhYpWyqDpPahmSlUTlc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', '3r6m301nun5e7qpde1tueanlvg4lshz7xbhwm0eidia0tpy67h', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('djeaoysv495gejqyt83g4gws2ajl7bqt47j8ak6ppenq5rpoln','cardigan','3qy25ogwngy9dhx','POP','4R2kfaDFhslZEMJqAFNpdd',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'djeaoysv495gejqyt83g4gws2ajl7bqt47j8ak6ppenq5rpoln', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4v3w51qve61ofote7qp8ocn48nzbcz5ha7lpouysx7uga20jw7','Karma','3qy25ogwngy9dhx','POP','7KokYm8cMIXCsGVmUvKtqf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', '4v3w51qve61ofote7qp8ocn48nzbcz5ha7lpouysx7uga20jw7', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pjje012rlfldn4tvpth2tm2y00i8t0bezrlnint716yuwfl0o7','Enchanted (Taylors Version)','3qy25ogwngy9dhx','POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'pjje012rlfldn4tvpth2tm2y00i8t0bezrlnint716yuwfl0o7', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wcwoootefr9bacuui443jegod0nwaso75om2ej6fk8ljvoz1rn','Back To December (Taylors Version)','3qy25ogwngy9dhx','POP','79uDOz0zuuWS7HWxzMmTa2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'wcwoootefr9bacuui443jegod0nwaso75om2ej6fk8ljvoz1rn', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sudnrr5zwbpaan7f1l0trspimeeuiix8zc51btg3kpwg21n5xj','Dont Bl','3qy25ogwngy9dhx','POP','59ZmeIz57cGU5Gp9omjlYB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'sudnrr5zwbpaan7f1l0trspimeeuiix8zc51btg3kpwg21n5xj', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8sy2bbnxeoyt53i1q1rl5l1vk7lyvn7tlittuqqbv2hs4zi76w','Mine (Taylors Version)','3qy25ogwngy9dhx','POP','7G0gBu6nLdhFDPRLc0HdDG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', '8sy2bbnxeoyt53i1q1rl5l1vk7lyvn7tlittuqqbv2hs4zi76w', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j11vocwki6wafxmv8wfsglbhgp9zue1011f9a5pg76adl57hqh','august','3qy25ogwngy9dhx','POP','3hUxzQpSfdDqwM3ZTFQY0K',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'j11vocwki6wafxmv8wfsglbhgp9zue1011f9a5pg76adl57hqh', '11');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sr5kpyaiy2vanz3vua62t12xytsb6cylmixyd8y5unzwniivj9','Enchanted','3qy25ogwngy9dhx','POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'sr5kpyaiy2vanz3vua62t12xytsb6cylmixyd8y5unzwniivj9', '12');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('br0v9393zvkt1axlcd2zmpk4k4h1laao5gx2nmgfqdsphiv579','Shake It Off','3qy25ogwngy9dhx','POP','3pv7Q5v2dpdefwdWIvE7yH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'br0v9393zvkt1axlcd2zmpk4k4h1laao5gx2nmgfqdsphiv579', '13');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('figbinl4yvzsbdknr45n1cqctrl68olnokmo9bxsu40duf5z0e','You Belong With Me (Taylors Ve','3qy25ogwngy9dhx','POP','1qrpoAMXodY6895hGKoUpA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'figbinl4yvzsbdknr45n1cqctrl68olnokmo9bxsu40duf5z0e', '14');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('32nl86jqftw9vu2fz0e1mqw50378yfstpdb4hdsw1f4e8wquz0','Better Than Revenge (Taylors Version)','3qy25ogwngy9dhx','POP','0NwGC0v03ysCYINtg6ns58',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', '32nl86jqftw9vu2fz0e1mqw50378yfstpdb4hdsw1f4e8wquz0', '15');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t262b37x1ryp8iee876vo0oqkyd0iwnkkeno5iwnlbor4sslh6','Hits Different','3qy25ogwngy9dhx','POP','3xYJScVfxByb61dYHTwiby',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 't262b37x1ryp8iee876vo0oqkyd0iwnkkeno5iwnlbor4sslh6', '16');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ty1e85y2rp3y7fcuc4kgc0po3u2ip8k5xget15392pxwixjf5c','Karma (feat. Ice Spice)','3qy25ogwngy9dhx','POP','4i6cwNY6oIUU2XZxPIw82Y',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'ty1e85y2rp3y7fcuc4kgc0po3u2ip8k5xget15392pxwixjf5c', '17');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fna3lw719ldu6118n6n71ekgp0c3pkri88tihkgf4avxwoxax0','Lavender Haze','3qy25ogwngy9dhx','POP','5jQI2r1RdgtuT8S3iG8zFC',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'fna3lw719ldu6118n6n71ekgp0c3pkri88tihkgf4avxwoxax0', '18');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ndjl6nqita8qrkhgj4dxj0bjzuvaqj3ntfafre37jrb3olg11h','All Of The Girls You Loved Before','3qy25ogwngy9dhx','POP','4P9Q0GojKVXpRTJCaL3kyy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'ndjl6nqita8qrkhgj4dxj0bjzuvaqj3ntfafre37jrb3olg11h', '19');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dxp517pqis8jjxl2eulxdr5m8ekeclkzt01ydles99d6838opq','Midnight Rain','3qy25ogwngy9dhx','POP','3rWDp9tBPQR9z6U5YyRSK4',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'dxp517pqis8jjxl2eulxdr5m8ekeclkzt01ydles99d6838opq', '20');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fve4t53nvtefpmdel56ndbc03bulbubepkjtam81d94p7bdiwt','Youre On Your Own, Kid','3qy25ogwngy9dhx','POP','1yMjWvw0LRwW5EZBPh9UyF','https://p.scdn.co/mp3-preview/cb8981007d0606f43b3051b3633f890d0a70de8c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xi44bztqyrg1nd7erz59gq0cfxd0zeq9ao4nfm6iwthapvwlfb', 'fve4t53nvtefpmdel56ndbc03bulbubepkjtam81d94p7bdiwt', '21');
-- Sebastian Yatra
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mugo61fztc8nve0', 'Sebastian Yatra', '37@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb650a498358171e1990efeeff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:37@artist.com', 'mugo61fztc8nve0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mugo61fztc8nve0', 'Revolutionizing the music scene with innovative compositions.', 'Sebastian Yatra');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sy4p8i8iul7y4qzp13nk6azgiurfwqvxk58z6h9wa5qwgcrybj','mugo61fztc8nve0', 'https://i.scdn.co/image/ab67616d0000b2732d6016751b8ea5e66e83cd04', 'Sebastian Yatra Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bppj25ileptim3j3s73l2sjx8ujh2fx5up1y1hdfmmjtxrln34','VAGABUNDO','mugo61fztc8nve0','POP','1MB8kTH7VKvAMfL9SHgJmG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sy4p8i8iul7y4qzp13nk6azgiurfwqvxk58z6h9wa5qwgcrybj', 'bppj25ileptim3j3s73l2sjx8ujh2fx5up1y1hdfmmjtxrln34', '0');
-- The Walters
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b4tglkcqqmy3l93', 'The Walters', '38@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6c4366f40ea49c1318707f97','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:38@artist.com', 'b4tglkcqqmy3l93', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b4tglkcqqmy3l93', 'Where words fail, my music speaks.', 'The Walters');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vxm8kxuloowe5ilvrkwrgt679fcyhe3twtxckf0xttbk774ql3','b4tglkcqqmy3l93', 'https://i.scdn.co/image/ab67616d0000b2739214ff0109a0e062f8a6cf0f', 'The Walters Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iqqvx8bhyjfcmizklcd90ov4sbsypj2i6bmaui596s6svl8t43','I Love You So','b4tglkcqqmy3l93','POP','4SqWKzw0CbA05TGszDgMlc','https://p.scdn.co/mp3-preview/83919b3d62a4ae352229c0a779e8aa0c1b2f4f40?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vxm8kxuloowe5ilvrkwrgt679fcyhe3twtxckf0xttbk774ql3', 'iqqvx8bhyjfcmizklcd90ov4sbsypj2i6bmaui596s6svl8t43', '0');
-- MC Xenon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('919wz6xryb124el', 'MC Xenon', '39@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb14b5fcee11164723953781ff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:39@artist.com', '919wz6xryb124el', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('919wz6xryb124el', 'A symphony of emotions expressed through sound.', 'MC Xenon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vh7nirb1iqclyyw229k7n8pw6lb11m8vgi58yskxv71fgfo2lu','919wz6xryb124el', NULL, 'MC Xenon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s6dah8gtxkjbq2gvhuagao94xs7hv9geo5i0lku99182hy26yd','Sem Aliana no ','919wz6xryb124el','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vh7nirb1iqclyyw229k7n8pw6lb11m8vgi58yskxv71fgfo2lu', 's6dah8gtxkjbq2gvhuagao94xs7hv9geo5i0lku99182hy26yd', '0');
-- James Arthur
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8a23kihgfp93rip', 'James Arthur', '40@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2a0c6d0343c82be9dd6fce0b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:40@artist.com', '8a23kihgfp93rip', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8a23kihgfp93rip', 'The architect of aural landscapes that inspire and captivate.', 'James Arthur');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x5zjjgpi6wrd2b7xo7scnwe56tnjzerklwcm3tdizs5zdemhd9','8a23kihgfp93rip', 'https://i.scdn.co/image/ab67616d0000b273dc16d839ab77c64bdbeb3660', 'James Arthur Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gop7rb8rmd8ldi8z0og3r4le4e7nyecqd5lpsnra8nty0tv6h2','Cars Outside','8a23kihgfp93rip','POP','0otRX6Z89qKkHkQ9OqJpKt','https://p.scdn.co/mp3-preview/cfaa30729da8d2d8965fae154b6e9d0964a2ea6b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x5zjjgpi6wrd2b7xo7scnwe56tnjzerklwcm3tdizs5zdemhd9', 'gop7rb8rmd8ldi8z0og3r4le4e7nyecqd5lpsnra8nty0tv6h2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vnexom6lboujfmalg2h862iklz81g5qus3jvym3nxpya31zn6o','Say You Wont Let Go','8a23kihgfp93rip','POP','5uCax9HTNlzGybIStD3vDh','https://p.scdn.co/mp3-preview/2eed95a3c08cd10669768ce60d1140f85ba8b951?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x5zjjgpi6wrd2b7xo7scnwe56tnjzerklwcm3tdizs5zdemhd9', 'vnexom6lboujfmalg2h862iklz81g5qus3jvym3nxpya31zn6o', '1');
-- Lil Uzi Vert
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gzijieexqp3bxrt', 'Lil Uzi Vert', '41@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1234d2f516796badbdf16a89','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:41@artist.com', 'gzijieexqp3bxrt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gzijieexqp3bxrt', 'Weaving lyrical magic into every song.', 'Lil Uzi Vert');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cqo6i9n89cc6881omf2ii1j81xfj6kq67649fnf6msscgk70z8','gzijieexqp3bxrt', 'https://i.scdn.co/image/ab67616d0000b273438799bc344744c12028bb0f', 'Lil Uzi Vert Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ndgcn7bioi73xl6ggzil935tt55hyeu3z9qwxecvm5zczakxg4','Just Wanna Rock','gzijieexqp3bxrt','POP','4FyesJzVpA39hbYvcseO2d','https://p.scdn.co/mp3-preview/72dce26448e87be36c3776ded36b75a9fd01359e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cqo6i9n89cc6881omf2ii1j81xfj6kq67649fnf6msscgk70z8', 'ndgcn7bioi73xl6ggzil935tt55hyeu3z9qwxecvm5zczakxg4', '0');
-- Beyonc
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5uj3a4ny5jnu779', 'Beyonc', '42@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12e3f20d05a8d6cfde988715','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:42@artist.com', '5uj3a4ny5jnu779', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5uj3a4ny5jnu779', 'A beacon of innovation in the world of sound.', 'Beyonc');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y9oynkrzct24twcx4nw1ndk4ypk93wpzvvh0hlhcb1bppxbf40','5uj3a4ny5jnu779', 'https://i.scdn.co/image/ab67616d0000b2730e58a0f8308c1ad403d105e7', 'Beyonc Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2gtdy3wi45t91i6mueohgljt7ds0e93yqtzylkx82m2esfurb5','CUFF IT','5uj3a4ny5jnu779','POP','1xzi1Jcr7mEi9K2RfzLOqS','https://p.scdn.co/mp3-preview/1799de9ff42644af9773b6353358e54615696f19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y9oynkrzct24twcx4nw1ndk4ypk93wpzvvh0hlhcb1bppxbf40', '2gtdy3wi45t91i6mueohgljt7ds0e93yqtzylkx82m2esfurb5', '0');
-- Kordhell
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zb6okul3pd2fwi4', 'Kordhell', '43@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb15862815bf4d2446b8ecf55f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:43@artist.com', 'zb6okul3pd2fwi4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zb6okul3pd2fwi4', 'An odyssey of sound that defies conventions.', 'Kordhell');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d0wwow3i1wrn6i6pbb8vavn13h2csspdfcpk6q6ns9ew01bqz9','zb6okul3pd2fwi4', 'https://i.scdn.co/image/ab67616d0000b2731440ffaa43c53d65719e0150', 'Kordhell Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0puqr72wva7cwjn67o2uc6f67aerxbvet1ejnfecb63wwc3pjp','Murder In My Mind','zb6okul3pd2fwi4','POP','6qyS9qBy0mEk3qYaH8mPss','https://p.scdn.co/mp3-preview/ec3b94db31d9fb9821cfea0f7a4cdc9d2a85e969?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d0wwow3i1wrn6i6pbb8vavn13h2csspdfcpk6q6ns9ew01bqz9', '0puqr72wva7cwjn67o2uc6f67aerxbvet1ejnfecb63wwc3pjp', '0');
-- Kenshi Yonezu
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7l3gmcvmctqz3yg', 'Kenshi Yonezu', '44@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc147e0888e83919d317c1103','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:44@artist.com', '7l3gmcvmctqz3yg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7l3gmcvmctqz3yg', 'A confluence of cultural beats and contemporary tunes.', 'Kenshi Yonezu');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('exqqdg0pa6uwormcz4s7cbs1w0jwx0fokmqiz0251hsivfd37o','7l3gmcvmctqz3yg', 'https://i.scdn.co/image/ab67616d0000b273303d8545fce8302841c39859', 'Kenshi Yonezu Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('50u9fo1lq6e7gbf5a7jfl25x5r7zmoylz24xw4amqisto32s49','KICK BACK','7l3gmcvmctqz3yg','POP','3khEEPRyBeOUabbmOPJzAG','https://p.scdn.co/mp3-preview/003a7a062f469db238cf5206626f08f3263c68e6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('exqqdg0pa6uwormcz4s7cbs1w0jwx0fokmqiz0251hsivfd37o', '50u9fo1lq6e7gbf5a7jfl25x5r7zmoylz24xw4amqisto32s49', '0');
-- Pritam
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('t57y99bmeujsdym', 'Pritam', '45@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcb6926f44f620555ba444fca','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:45@artist.com', 't57y99bmeujsdym', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('t57y99bmeujsdym', 'An alchemist of harmonies, transforming notes into gold.', 'Pritam');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xopuitu33umveubpa2lcguth8mmr9mm6im2x10klofjdg8hu8j','t57y99bmeujsdym', NULL, 'Pritam Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3puqmgbnrbigq1c684qnq2mfnnu6wnyt88f4c565123psv6d65','Kesariya (From "Brahmastra")','t57y99bmeujsdym','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xopuitu33umveubpa2lcguth8mmr9mm6im2x10klofjdg8hu8j', '3puqmgbnrbigq1c684qnq2mfnnu6wnyt88f4c565123psv6d65', '0');
-- RM
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('l1lp2ml8t4zmhha', 'RM', '46@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3b8f6208d84e28f63841e43c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:46@artist.com', 'l1lp2ml8t4zmhha', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('l1lp2ml8t4zmhha', 'Pioneering new paths in the musical landscape.', 'RM');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7a888k3rspqsosv7qsyot6q9o1yi24cbgfkx6xg4mqnfya3wny','l1lp2ml8t4zmhha', NULL, 'RM Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0fb7ncyxppc1mfwctaywx6ucg21jjepzojs3wcmi3bprynce0a','Dont ever say love me (feat. RM of BTS)','l1lp2ml8t4zmhha','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7a888k3rspqsosv7qsyot6q9o1yi24cbgfkx6xg4mqnfya3wny', '0fb7ncyxppc1mfwctaywx6ucg21jjepzojs3wcmi3bprynce0a', '0');
-- Wisin & Yandel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j4n091raap1aekq', 'Wisin & Yandel', '47@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5496c4b788e181679069ee8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:47@artist.com', 'j4n091raap1aekq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j4n091raap1aekq', 'A beacon of innovation in the world of sound.', 'Wisin & Yandel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hrtaogi5bgopieyavzuzjc2b421y45bi91ojo0wvb37rx8c0vt','j4n091raap1aekq', 'https://i.scdn.co/image/ab67616d0000b2739f05bb270f81880fd844aae8', 'Wisin & Yandel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c9gi591z8rfgtbt4owzt4paxazjj14k2agmx333hm89cuy1m0o','Besos Moja2','j4n091raap1aekq','POP','6OzUIp8KjuwxJnCWkXp1uL','https://p.scdn.co/mp3-preview/8b17c9ae5706f7f2e41a6ec3470631b3094017b6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hrtaogi5bgopieyavzuzjc2b421y45bi91ojo0wvb37rx8c0vt', 'c9gi591z8rfgtbt4owzt4paxazjj14k2agmx333hm89cuy1m0o', '0');
-- Aerosmith
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('753jnjrrsczg34y', 'Aerosmith', '48@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5733401b4689b2064458e7d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:48@artist.com', '753jnjrrsczg34y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('753jnjrrsczg34y', 'Exploring the depths of sound and rhythm.', 'Aerosmith');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2ay6j2i7epxrag290lnmsgco5av33bf2h3cc79u7wxz3mc77vb','753jnjrrsczg34y', 'https://i.scdn.co/image/ab67616d0000b273bbf0146981704a073405b6c2', 'Aerosmith Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2nxjm2e1uo24myy28kg4xlu4guh3o8fxo7mowu1hgg80gadxrt','Dream On','753jnjrrsczg34y','POP','1xsYj84j7hUDDnTTerGWlH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2ay6j2i7epxrag290lnmsgco5av33bf2h3cc79u7wxz3mc77vb', '2nxjm2e1uo24myy28kg4xlu4guh3o8fxo7mowu1hgg80gadxrt', '0');
-- James Blake
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('97x7ec3yfjzlv7z', 'James Blake', '49@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb93fe5fc8fdb5a98248911a07','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:49@artist.com', '97x7ec3yfjzlv7z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('97x7ec3yfjzlv7z', 'A beacon of innovation in the world of sound.', 'James Blake');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wpb84fn2t9k3h3cnf1q6czcphmatd68fonhq6nubod1cqgj02z','97x7ec3yfjzlv7z', NULL, 'James Blake Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j1x23e6agkauqw7uipjgfjkhp7dew3clt97ss8wrbz7r3rgzys','Hummingbird (Metro Boomin & James Blake)','97x7ec3yfjzlv7z','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wpb84fn2t9k3h3cnf1q6czcphmatd68fonhq6nubod1cqgj02z', 'j1x23e6agkauqw7uipjgfjkhp7dew3clt97ss8wrbz7r3rgzys', '0');
-- Gabito Ballesteros
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('suk4x2vcupjmcl0', 'Gabito Ballesteros', '50@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:50@artist.com', 'suk4x2vcupjmcl0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('suk4x2vcupjmcl0', 'A vibrant force in the music scene, infusing every performance with passion.', 'Gabito Ballesteros');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('w4hno3k53liqmhajy7c6h4pqtbdf4k1lo5ekk8j38w34djlrhp','suk4x2vcupjmcl0', NULL, 'Gabito Ballesteros Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tiaq301c8ctje36xzp7no1fwi2q43y1c425fer4l1di8ahnhx1','LADY GAGA','suk4x2vcupjmcl0','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w4hno3k53liqmhajy7c6h4pqtbdf4k1lo5ekk8j38w34djlrhp', 'tiaq301c8ctje36xzp7no1fwi2q43y1c425fer4l1di8ahnhx1', '0');
-- Mr.Kitty
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('22nx15f2mtleds4', 'Mr.Kitty', '51@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb78ed447c78f07632e82ec0d8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:51@artist.com', '22nx15f2mtleds4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('22nx15f2mtleds4', 'A beacon of innovation in the world of sound.', 'Mr.Kitty');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('iqplcmwj49475c6nkdro17rpfda35kba6hi3tid2goadwh36ym','22nx15f2mtleds4', 'https://i.scdn.co/image/ab67616d0000b273b492477206075438e0751176', 'Mr.Kitty Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jqqzhe720urjgxtjyelhr1htspnac34sbwo8oza6bx74k7ix9h','After Dark','22nx15f2mtleds4','POP','2LKOHdMsL0K9KwcPRlJK2v','https://p.scdn.co/mp3-preview/eb9de15a4465f504ee0eadba93e7d265ee0ee6ba?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('iqplcmwj49475c6nkdro17rpfda35kba6hi3tid2goadwh36ym', 'jqqzhe720urjgxtjyelhr1htspnac34sbwo8oza6bx74k7ix9h', '0');
-- Don Omar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dv2eawbu6cy0um9', 'Don Omar', '52@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:52@artist.com', 'dv2eawbu6cy0um9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dv2eawbu6cy0um9', 'A maestro of melodies, orchestrating auditory bliss.', 'Don Omar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8zs31m6slh586meqrsuyjs8t28y2tr7rvvjxie74q9iawqmawm','dv2eawbu6cy0um9', 'https://i.scdn.co/image/ab67616d0000b2734640a26eb27649006be29a94', 'Don Omar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ol1yu5ql6s9i4vlobi0br3wkjmy9yeu5hov0ikqmm7z1zrncas','Danza Kuduro','dv2eawbu6cy0um9','POP','2a1o6ZejUi8U3wzzOtCOYw',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8zs31m6slh586meqrsuyjs8t28y2tr7rvvjxie74q9iawqmawm', 'ol1yu5ql6s9i4vlobi0br3wkjmy9yeu5hov0ikqmm7z1zrncas', '0');
-- Chino Pacas
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d40ltlvdnmqpfon', 'Chino Pacas', '53@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8ff524b416384fe673ebf52e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:53@artist.com', 'd40ltlvdnmqpfon', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('d40ltlvdnmqpfon', 'A harmonious blend of passion and creativity.', 'Chino Pacas');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u9slx3g66y5adr5ctkibwwaehviu3eu4gf64qykrvirf7aowki','d40ltlvdnmqpfon', 'https://i.scdn.co/image/ab67616d0000b2736a6ab689151163a1e9f60f36', 'Chino Pacas Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v5irfv6k4r4t2w0m995ac8nf3dykl7cr4xpzx7oy3jd5h0o9xp','El Gordo Trae El Mando','d40ltlvdnmqpfon','POP','3kf0WdFOalKWBkCCLJo4mA','https://p.scdn.co/mp3-preview/b7989992ce6651eea980627ad17b1f9a2fa2a224?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u9slx3g66y5adr5ctkibwwaehviu3eu4gf64qykrvirf7aowki', 'v5irfv6k4r4t2w0m995ac8nf3dykl7cr4xpzx7oy3jd5h0o9xp', '0');
-- TAEYANG
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y8e7hm18oaqbz3i', 'TAEYANG', '54@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb496189630cd3cb0c7b593fee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:54@artist.com', 'y8e7hm18oaqbz3i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y8e7hm18oaqbz3i', 'Delivering soul-stirring tunes that linger in the mind.', 'TAEYANG');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7y37hfsqyjur94qum91se7fr86rx5qi9g2l1e914x7pqkizbr5','y8e7hm18oaqbz3i', 'https://i.scdn.co/image/ab67616d0000b27346313223adf2b6d726388328', 'TAEYANG Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ykz1t2fkvk9edkhm4i7fs1ogqzppkxgg3vvjaduu4l2rpmcxoc','Shoong! (feat. LISA of BLACKPINK)','y8e7hm18oaqbz3i','POP','5HrIcZOo1DysX53qDRlRnt',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7y37hfsqyjur94qum91se7fr86rx5qi9g2l1e914x7pqkizbr5', 'ykz1t2fkvk9edkhm4i7fs1ogqzppkxgg3vvjaduu4l2rpmcxoc', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ow1u1v3oavkpbmb1w0zcpy2ov5eg3usspsgk8ogeday8s56q1p','VIBE (feat. Jimin of BTS)','y8e7hm18oaqbz3i','POP','4NIe9Is7bN5JWyTeCW2ahK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7y37hfsqyjur94qum91se7fr86rx5qi9g2l1e914x7pqkizbr5', 'ow1u1v3oavkpbmb1w0zcpy2ov5eg3usspsgk8ogeday8s56q1p', '1');
-- Olivia Rodrigo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z5786s2wg50k5lg', 'Olivia Rodrigo', '55@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe03a98785f3658f0b6461ec4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:55@artist.com', 'z5786s2wg50k5lg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z5786s2wg50k5lg', 'A new voice in pop, channeling raw emotions into her songs.', 'Olivia Rodrigo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('61mnyjsi88xpo7q27a6an6zge4dfcxbztcmi28tivn9gj2vrhc','z5786s2wg50k5lg', 'https://i.scdn.co/image/ab67616d0000b273e85259a1cae29a8d91f2093d', 'Olivia Rodrigo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rdm51hmni7q63osubn365malpy7cfpvyjjm23jhtibo0f6bfrg','vampire','z5786s2wg50k5lg','POP','1kuGVB7EU95pJObxwvfwKS',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('61mnyjsi88xpo7q27a6an6zge4dfcxbztcmi28tivn9gj2vrhc', 'rdm51hmni7q63osubn365malpy7cfpvyjjm23jhtibo0f6bfrg', '0');
-- Ariana Grande
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v02xy5841xsacm3', 'Ariana Grande', '56@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb456c82553e0efcb7e13365b1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:56@artist.com', 'v02xy5841xsacm3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v02xy5841xsacm3', 'A powerhouse vocalist, dominating pop with her range and iconic style.', 'Ariana Grande');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2lqvbf8a9705vp5ij3mydkc0t62y2v94rd9u95vzo16bkfsvu1','v02xy5841xsacm3', NULL, 'Ariana Grande Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lvsbhqyo3tfnjodd0osj2av9wj3y7iv0pysery3xpj4e4vjneo','Die For You - Remix','v02xy5841xsacm3','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2lqvbf8a9705vp5ij3mydkc0t62y2v94rd9u95vzo16bkfsvu1', 'lvsbhqyo3tfnjodd0osj2av9wj3y7iv0pysery3xpj4e4vjneo', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m98pasjkbywi8qbaroyljevswrzc4hvexrex8isgq2zqml1a65','Save Your Tears (with Ariana Grande) (Remix)','v02xy5841xsacm3','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2lqvbf8a9705vp5ij3mydkc0t62y2v94rd9u95vzo16bkfsvu1', 'm98pasjkbywi8qbaroyljevswrzc4hvexrex8isgq2zqml1a65', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9db4xjoy4izvyp12q3xfu9pn2fozh4m6mro2sj0n5hmadkkv62','Santa Tell Me','v02xy5841xsacm3','POP','0lizgQ7Qw35od7CYaoMBZb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2lqvbf8a9705vp5ij3mydkc0t62y2v94rd9u95vzo16bkfsvu1', '9db4xjoy4izvyp12q3xfu9pn2fozh4m6mro2sj0n5hmadkkv62', '2');
-- Kodak Black
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ygg8yu6c51v3pfx', 'Kodak Black', '57@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb70c05cf4dc9a7d3ffd02ba19','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:57@artist.com', 'ygg8yu6c51v3pfx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ygg8yu6c51v3pfx', 'Melodies that capture the essence of human emotion.', 'Kodak Black');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('45683lrfmdtehaoxg6qpq7w1yerp0x2jydxhd01qanro2avjgf','ygg8yu6c51v3pfx', 'https://i.scdn.co/image/ab67616d0000b273445afb6341d2685b959251cc', 'Kodak Black Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c6ngltveh0of75fagaph3gweye1kd32mjgc9hj7ghfzu0n4q1l','Angel Pt 1 (feat. Jimin of BTS, JVKE & Muni Long)','ygg8yu6c51v3pfx','POP','1vvcEHQdaUTvWt0EIUYcFK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('45683lrfmdtehaoxg6qpq7w1yerp0x2jydxhd01qanro2avjgf', 'c6ngltveh0of75fagaph3gweye1kd32mjgc9hj7ghfzu0n4q1l', '0');
-- Migrantes
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3jxxl96bdrcjdq2', 'Migrantes', '58@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb676e77ad14850536079e2ea8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:58@artist.com', '3jxxl96bdrcjdq2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3jxxl96bdrcjdq2', 'The architect of aural landscapes that inspire and captivate.', 'Migrantes');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4xezfxvet6sye2pxp9s124326vgq6ym8wax6mbq7z7ocyzu340','3jxxl96bdrcjdq2', NULL, 'Migrantes Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j34quqz5nsnjx2gbwwjurdbim1q7zqm60n0ow9ehv282fumkte','MERCHO','3jxxl96bdrcjdq2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4xezfxvet6sye2pxp9s124326vgq6ym8wax6mbq7z7ocyzu340', 'j34quqz5nsnjx2gbwwjurdbim1q7zqm60n0ow9ehv282fumkte', '0');
-- Carin Leon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cn18ygw1xaw3m5t', 'Carin Leon', '59@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb7cc22fee89df015c6ba2636','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:59@artist.com', 'cn18ygw1xaw3m5t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cn18ygw1xaw3m5t', 'Blending genres for a fresh musical experience.', 'Carin Leon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t43ju0m0w21w6bfia1hhz5bntap88heix41ti1a68nfgucdxqi','cn18ygw1xaw3m5t', 'https://i.scdn.co/image/ab67616d0000b273dc0bb68a08c069cf8467f1bd', 'Carin Leon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uuxoph3nturt2ay6cqvmoa4ft9gq674tevigqupb6mqvo4ox9w','Primera Cita','cn18ygw1xaw3m5t','POP','4mGrWfDISjNjgeQnH1B8IE','https://p.scdn.co/mp3-preview/7eea768397c9ad0989a55f26f4cffbe6f334874a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t43ju0m0w21w6bfia1hhz5bntap88heix41ti1a68nfgucdxqi', 'uuxoph3nturt2ay6cqvmoa4ft9gq674tevigqupb6mqvo4ox9w', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y96rzvim2cfoigy8ein6jt33pjf1ypi5wjc7bthlksci4wy3ny','Que Vuelvas','cn18ygw1xaw3m5t','POP','6Um358vY92UBv5DloTRX9L','https://p.scdn.co/mp3-preview/19a1e58ae965c24e3ca4d0637857456887e31cd1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t43ju0m0w21w6bfia1hhz5bntap88heix41ti1a68nfgucdxqi', 'y96rzvim2cfoigy8ein6jt33pjf1ypi5wjc7bthlksci4wy3ny', '1');
-- ENHYPEN
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tiod7163mzbxbjz', 'ENHYPEN', '60@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a48a236a01fa62db8c7a6f6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:60@artist.com', 'tiod7163mzbxbjz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tiod7163mzbxbjz', 'Uniting fans around the globe with universal rhythms.', 'ENHYPEN');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zvxlwv5j40hr8qw8rjabptowu2jbeqw6m4t1faripswl7qaghr','tiod7163mzbxbjz', 'https://i.scdn.co/image/ab67616d0000b2731d03b5e88cee6870778a4d27', 'ENHYPEN Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y7x6e8gokj2n1otasf3cfzh4lexofk4gs04hbq1klz0qwexk7o','Bite Me','tiod7163mzbxbjz','POP','7mpdNiaQvygj2rHoxkzMfa','https://p.scdn.co/mp3-preview/ff4e3c3d8464e572759ba2169332743c2889d97e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zvxlwv5j40hr8qw8rjabptowu2jbeqw6m4t1faripswl7qaghr', 'y7x6e8gokj2n1otasf3cfzh4lexofk4gs04hbq1klz0qwexk7o', '0');
-- P!nk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tf06ez53lv4icdb', 'P!nk', '61@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7bbad89a61061304ec842588','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:61@artist.com', 'tf06ez53lv4icdb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tf06ez53lv4icdb', 'Revolutionizing the music scene with innovative compositions.', 'P!nk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6t8yinnxt21v058da32m1y3fumoci8ofuhmft4mplcv6horeqp','tf06ez53lv4icdb', 'https://i.scdn.co/image/ab67616d0000b27302f93e92bdd5b3793eb688c0', 'P!nk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kkqzzpgs0szi64pykbqoagscu4gzcvhr89j2h48pn37kxj2dwg','TRUSTFALL','tf06ez53lv4icdb','POP','4FWbsd91QSvgr1dSWwW51e','https://p.scdn.co/mp3-preview/4a8b78e434e2dda75bc679955c3fbd8b4dad372b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6t8yinnxt21v058da32m1y3fumoci8ofuhmft4mplcv6horeqp', 'kkqzzpgs0szi64pykbqoagscu4gzcvhr89j2h48pn37kxj2dwg', '0');
-- Jimin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0k6d1v6nllffjko', 'Jimin', '62@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb59f8cfc8e71dcaf8c6ec4bde','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:62@artist.com', '0k6d1v6nllffjko', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0k6d1v6nllffjko', 'Known for his expressive voice and mesmerizing dance moves in BTS.', 'Jimin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l65m4jxa8z2f5v05er6l5ufuv1yuqbueif901an84k2vvxfnzc','0k6d1v6nllffjko', 'https://i.scdn.co/image/ab67616d0000b2732b46078245d0120690eb560d', 'Jimin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u01low24c4qbfjsbw8rpo3dvx4grrf5m7qi174kcpqjp72d6vy','Like Crazy','0k6d1v6nllffjko','POP','3Ua0m0YmEjrMi9XErKcNiR','https://p.scdn.co/mp3-preview/2db5f36096963d97afc870c50990d62d27858a43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l65m4jxa8z2f5v05er6l5ufuv1yuqbueif901an84k2vvxfnzc', 'u01low24c4qbfjsbw8rpo3dvx4grrf5m7qi174kcpqjp72d6vy', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('49z2qaxbu0rz71zr7jcapki4v1mgaq8b0wz0vbmepu946ktl4f','Set Me Free Pt.2','0k6d1v6nllffjko','POP','59hBR0BCtJsfIbV9VzCVAp','https://p.scdn.co/mp3-preview/275a3a0843bb55c251cda45ef17a905dab31624c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l65m4jxa8z2f5v05er6l5ufuv1yuqbueif901an84k2vvxfnzc', '49z2qaxbu0rz71zr7jcapki4v1mgaq8b0wz0vbmepu946ktl4f', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d1md3nxl8s5yge1ztcebatrov3mjlb7zk53j5mainyp9cc4f9l','Like Crazy (English Version)','0k6d1v6nllffjko','POP','0u8rZGtXJrLtiSe34FPjGG','https://p.scdn.co/mp3-preview/3752bae14d7952abe6f93649d85d53bfe98f1165?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l65m4jxa8z2f5v05er6l5ufuv1yuqbueif901an84k2vvxfnzc', 'd1md3nxl8s5yge1ztcebatrov3mjlb7zk53j5mainyp9cc4f9l', '2');
-- Baby Rasta
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b2e12pw9qccqxdy', 'Baby Rasta', '63@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb18f9c5cb23e65bd55af69f24','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:63@artist.com', 'b2e12pw9qccqxdy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b2e12pw9qccqxdy', 'Blending traditional rhythms with modern beats.', 'Baby Rasta');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5ui4nh4zg7iyec8gtopg3svi0yknecunhcrm161gakaqmy6u2y','b2e12pw9qccqxdy', NULL, 'Baby Rasta Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fmnox1jpax98jy3aoc5j5jzgcz413v7xl9unwv6xnvinnw3bkj','PUNTO 40','b2e12pw9qccqxdy','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5ui4nh4zg7iyec8gtopg3svi0yknecunhcrm161gakaqmy6u2y', 'fmnox1jpax98jy3aoc5j5jzgcz413v7xl9unwv6xnvinnw3bkj', '0');
-- J. Cole
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8hptog7hjhfp5fn', 'J. Cole', '64@artist.com', 'https://i.scdn.co/image/ab67616d0000b273d092fc596478080bb0e06aea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:64@artist.com', '8hptog7hjhfp5fn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8hptog7hjhfp5fn', 'A profound lyricist and rapper, known for his thought-provoking music.', 'J. Cole');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qdaurhskmtf212449ras6d8i3s4u06frpc6ugd1ohfb6c1vqfc','8hptog7hjhfp5fn', NULL, 'J. Cole Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gie926pbwtneadz3ybfx2qpuirir808gcmhbkgh3kn09qzy6jn','All My Life (feat. J. Cole)','8hptog7hjhfp5fn','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qdaurhskmtf212449ras6d8i3s4u06frpc6ugd1ohfb6c1vqfc', 'gie926pbwtneadz3ybfx2qpuirir808gcmhbkgh3kn09qzy6jn', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xcog7a81v61vec2jbxydv0d8yainv3xevcdyp2z1anqs825qbv','No Role Modelz','8hptog7hjhfp5fn','POP','68Dni7IE4VyPkTOH9mRWHr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qdaurhskmtf212449ras6d8i3s4u06frpc6ugd1ohfb6c1vqfc', 'xcog7a81v61vec2jbxydv0d8yainv3xevcdyp2z1anqs825qbv', '1');
-- Glass Animals
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8lgvf47g9p5yrw7', 'Glass Animals', '65@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb66b27eccb69756f8eceabc23','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:65@artist.com', '8lgvf47g9p5yrw7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8lgvf47g9p5yrw7', 'Crafting psychedelic pop with intricate melodies and immersive soundscapes.', 'Glass Animals');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jcy76pdsdyge56c55lcq9sqo2zvct6v6y5wowk8x2a0giwf8tc','8lgvf47g9p5yrw7', 'https://i.scdn.co/image/ab67616d0000b273712701c5e263efc8726b1464', 'Glass Animals Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4jg88raaq9ushpuef1ccyytsnv2n7l03yez8mkb95wbv8zdq83','Heat Waves','8lgvf47g9p5yrw7','POP','3USxtqRwSYz57Ewm6wWRMp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jcy76pdsdyge56c55lcq9sqo2zvct6v6y5wowk8x2a0giwf8tc', '4jg88raaq9ushpuef1ccyytsnv2n7l03yez8mkb95wbv8zdq83', '0');
-- Harry Styles
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('n2xbevldr4gf02m', 'Harry Styles', '66@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf7db7c8ede90a019c54590bb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:66@artist.com', 'n2xbevldr4gf02m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('n2xbevldr4gf02m', 'Defining modern pop-rock with his charismatic presence and bold choices.', 'Harry Styles');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4b993y3nphaukz2y3zi2la2pk7epwkgsjtr1uxjyvrsrcp7ic8','n2xbevldr4gf02m', 'https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0', 'Harry Styles Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('527jhp8my2g5lf21qfe0u8h5lqlop428kp0mrt1841gumkis09','As It Was','n2xbevldr4gf02m','POP','4Dvkj6JhhA12EX05fT7y2e','https://p.scdn.co/mp3-preview/c43dd07043b29e800c1a65b3a0102861fa3cf418?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4b993y3nphaukz2y3zi2la2pk7epwkgsjtr1uxjyvrsrcp7ic8', '527jhp8my2g5lf21qfe0u8h5lqlop428kp0mrt1841gumkis09', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qytnuvunb7virge560f1196qiwsdygbks7yhkomn9xk2l9bd9l','Watermelon Sugar','n2xbevldr4gf02m','POP','6UelLqGlWMcVH1E5c4H7lY','https://p.scdn.co/mp3-preview/824cd58da2e9a15eeaaa6746becc09093547a09b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4b993y3nphaukz2y3zi2la2pk7epwkgsjtr1uxjyvrsrcp7ic8', 'qytnuvunb7virge560f1196qiwsdygbks7yhkomn9xk2l9bd9l', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nfz4fa8ua4cbjov5np0y3ki5v3yj1ymkboawjeuppdf5i1rs83','Late Night Talking','n2xbevldr4gf02m','POP','1qEmFfgcLObUfQm0j1W2CK','https://p.scdn.co/mp3-preview/50f056e2ab4a1bef762661dbbf2da751beeffe39?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4b993y3nphaukz2y3zi2la2pk7epwkgsjtr1uxjyvrsrcp7ic8', 'nfz4fa8ua4cbjov5np0y3ki5v3yj1ymkboawjeuppdf5i1rs83', '2');
-- Yng Lvcas
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s7yx3ha2cluzw82', 'Yng Lvcas', '67@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:67@artist.com', 's7yx3ha2cluzw82', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s7yx3ha2cluzw82', 'Igniting the stage with electrifying performances.', 'Yng Lvcas');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('n690yc2f0869582i717mvs21mlot33h711d131sngcu7xdtzsn','s7yx3ha2cluzw82', 'https://i.scdn.co/image/ab67616d0000b273a04be3ad7c8c67f4109111a9', 'Yng Lvcas Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('35gvr6nui69gw1nhnb8ty8sy9id5bhwxohi2a096dh6payg47w','La Bebe','s7yx3ha2cluzw82','POP','2UW7JaomAMuX9pZrjVpHAU','https://p.scdn.co/mp3-preview/57c5d5266219b32d455ed22417155bbabde7170f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n690yc2f0869582i717mvs21mlot33h711d131sngcu7xdtzsn', '35gvr6nui69gw1nhnb8ty8sy9id5bhwxohi2a096dh6payg47w', '0');
-- (G)I-DLE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vkqnclz2qltt62y', '(G)I-DLE', '68@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8abd5f97fc52561939ebbc89','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:68@artist.com', 'vkqnclz2qltt62y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vkqnclz2qltt62y', 'Igniting the stage with electrifying performances.', '(G)I-DLE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4t4lwvrk2eis5fr3d9j5oy58prnxrhh0ws8v8enr8uvcb036oy','vkqnclz2qltt62y', 'https://i.scdn.co/image/ab67616d0000b27382dd2427e6d302711b1b9616', '(G)I-DLE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lqi3km8q4uvnxtw96eud81b7zm1abev2jeb2z1tw35ich5kgsz','Queencard','vkqnclz2qltt62y','POP','4uOBL4DDWWVx4RhYKlPbPC','https://p.scdn.co/mp3-preview/9f36e86bca0911d3f849197e8f531b9d0c34f002?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4t4lwvrk2eis5fr3d9j5oy58prnxrhh0ws8v8enr8uvcb036oy', 'lqi3km8q4uvnxtw96eud81b7zm1abev2jeb2z1tw35ich5kgsz', '0');
-- Duki
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nszra0it9iuf9um', 'Duki', '69@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4293b81686e67e3041aec80c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:69@artist.com', 'nszra0it9iuf9um', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nszra0it9iuf9um', 'An alchemist of harmonies, transforming notes into gold.', 'Duki');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zze4j96niivh4crt1wfbgei5n9u5a99l8pbqz8ndeb4cbvdfwr','nszra0it9iuf9um', NULL, 'Duki Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7q8syxibz5kmbgr84mem95j44liobx424nxyt9dv2npmxq0j4s','Marisola - Remix','nszra0it9iuf9um','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zze4j96niivh4crt1wfbgei5n9u5a99l8pbqz8ndeb4cbvdfwr', '7q8syxibz5kmbgr84mem95j44liobx424nxyt9dv2npmxq0j4s', '0');
-- Meghan Trainor
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yzomugfax41bdf1', 'Meghan Trainor', '70@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4d8f97058ff993df0f4eb9ee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:70@artist.com', 'yzomugfax41bdf1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yzomugfax41bdf1', 'An odyssey of sound that defies conventions.', 'Meghan Trainor');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('161gwnbjxdh1zu4fna0ijwca8trgdqj68w45z1dn6qg37fyzns','yzomugfax41bdf1', 'https://i.scdn.co/image/ab67616d0000b2731a4f1ada93881da4ca8060ff', 'Meghan Trainor Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qe3766i36yjgy7re0jy7sncumn950r71s83388w4dihz0wnxal','Made You Look','yzomugfax41bdf1','POP','0QHEIqNKsMoOY5urbzN48u','https://p.scdn.co/mp3-preview/f0eb89945aa820c0f30b5e97f8e2cab42d9f0a99?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('161gwnbjxdh1zu4fna0ijwca8trgdqj68w45z1dn6qg37fyzns', 'qe3766i36yjgy7re0jy7sncumn950r71s83388w4dihz0wnxal', '0');
-- Plan B
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u0pdmyqntzoms4o', 'Plan B', '71@artist.com', 'https://i.scdn.co/image/eb21793908d1eabe0fba02659bdff4e4a4b3724a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:71@artist.com', 'u0pdmyqntzoms4o', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u0pdmyqntzoms4o', 'Melodies that capture the essence of human emotion.', 'Plan B');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('v8sp8hdd0qhvdq7ziwe8xptsi83jw8fz7lin1w99twiqx3fj1e','u0pdmyqntzoms4o', 'https://i.scdn.co/image/ab67616d0000b273913ef74e0272d688c512200b', 'Plan B Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qen586jdrzxz06zkv2cdz4poxbdskd97wgn86uvbljaisgjzik','Es un Secreto','u0pdmyqntzoms4o','POP','7JwdbqIpiuWvGbRryKSuBz','https://p.scdn.co/mp3-preview/feeeb03d75e53b19bb2e67502a1b498e87cdfef8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v8sp8hdd0qhvdq7ziwe8xptsi83jw8fz7lin1w99twiqx3fj1e', 'qen586jdrzxz06zkv2cdz4poxbdskd97wgn86uvbljaisgjzik', '0');
-- Arctic Monkeys
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hmm7zmc5z23lubj', 'Arctic Monkeys', '72@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:72@artist.com', 'hmm7zmc5z23lubj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hmm7zmc5z23lubj', 'Rock innovators, known for their sharp lyrics and compelling sound.', 'Arctic Monkeys');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oxabm09i45gynczn6uswo88hhwxz66xdwl4gxh8n93dw9gnd3a','hmm7zmc5z23lubj', 'https://i.scdn.co/image/ab67616d0000b2734ae1c4c5c45aabe565499163', 'Arctic Monkeys Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7dm7fbteg47izoqce5p8u1nf4n0gjjwhqiau9ma0i3yck4b2h8','I Wanna Be Yours','hmm7zmc5z23lubj','POP','5XeFesFbtLpXzIVDNQP22n','https://p.scdn.co/mp3-preview/07de30bde8363d9ff78b72339245c151f67af451?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oxabm09i45gynczn6uswo88hhwxz66xdwl4gxh8n93dw9gnd3a', '7dm7fbteg47izoqce5p8u1nf4n0gjjwhqiau9ma0i3yck4b2h8', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qvbrcojeyitc584d20b1do1ndl6pxny4mudkgy3rsqxxmguvyw','505','hmm7zmc5z23lubj','POP','58ge6dfP91o9oXMzq3XkIS','https://p.scdn.co/mp3-preview/1b23606bada6aacb339535944c1fe505898195e1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oxabm09i45gynczn6uswo88hhwxz66xdwl4gxh8n93dw9gnd3a', 'qvbrcojeyitc584d20b1do1ndl6pxny4mudkgy3rsqxxmguvyw', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yp7jzun3aorz6ctvx00svxvtr8a66448cyz3qcn4xjri94f34w','Do I Wanna Know?','hmm7zmc5z23lubj','POP','5FVd6KXrgO9B3JPmC8OPst','https://p.scdn.co/mp3-preview/006bc465fe3d1c04dae93a050eca9d402a7322b8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oxabm09i45gynczn6uswo88hhwxz66xdwl4gxh8n93dw9gnd3a', 'yp7jzun3aorz6ctvx00svxvtr8a66448cyz3qcn4xjri94f34w', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ba7un8mmjufl4ufuezxoj0a0stenhowj6tav7b2payqg0utsnk','Whyd You Only Call Me When Youre High?','hmm7zmc5z23lubj','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oxabm09i45gynczn6uswo88hhwxz66xdwl4gxh8n93dw9gnd3a', 'ba7un8mmjufl4ufuezxoj0a0stenhowj6tav7b2payqg0utsnk', '3');
-- Andy Williams
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nm8a61ge64prfgf', 'Andy Williams', '73@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5888acdca5e748e796b4e69b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:73@artist.com', 'nm8a61ge64prfgf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nm8a61ge64prfgf', 'Blending genres for a fresh musical experience.', 'Andy Williams');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5q766vxub1ihvpnuoc3nit14o56mrvq5j56evel5p1gqrkxc5m','nm8a61ge64prfgf', 'https://i.scdn.co/image/ab67616d0000b27398073965947f92f1641b8356', 'Andy Williams Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aoywneckhccqs32nul0q6bnbru2svv2e549m4361h08box1md5','Its the Most Wonderful Time of the Year','nm8a61ge64prfgf','POP','5hslUAKq9I9CG2bAulFkHN','https://p.scdn.co/mp3-preview/853f441c5fc1b25ba88bb300c17119cde36da675?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5q766vxub1ihvpnuoc3nit14o56mrvq5j56evel5p1gqrkxc5m', 'aoywneckhccqs32nul0q6bnbru2svv2e549m4361h08box1md5', '0');
-- Oscar Maydon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ihnfebsqbpyk9tk', 'Oscar Maydon', '74@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8920adf64930d6f26e34b7c4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:74@artist.com', 'ihnfebsqbpyk9tk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ihnfebsqbpyk9tk', 'A tapestry of rhythms that echo the pulse of life.', 'Oscar Maydon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kmvta8lfsffdjwf19n2cehz3idd39tfq0j9mtqzdgshczwwo46','ihnfebsqbpyk9tk', 'https://i.scdn.co/image/ab67616d0000b2739b7e1ea3815a172019bc5e56', 'Oscar Maydon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0erq9hdgpz936j977bmh2exhcp3085gt6mw7m33rzcah489r2m','Fin de Semana','ihnfebsqbpyk9tk','POP','6TBzRwnX2oYd8aOrOuyK1p','https://p.scdn.co/mp3-preview/71ee8bdc0a34790ad549ba750665808f08f5e46b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kmvta8lfsffdjwf19n2cehz3idd39tfq0j9mtqzdgshczwwo46', '0erq9hdgpz936j977bmh2exhcp3085gt6mw7m33rzcah489r2m', '0');
-- Karol G
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('urukzo4jacgzh7m', 'Karol G', '75@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb284894d68fe2f80cad555110','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:75@artist.com', 'urukzo4jacgzh7m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('urukzo4jacgzh7m', 'A queen of reggaeton, known for her empowering anthems and vibrant performances.', 'Karol G');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ljf40k6l606t14sikp9c9j62t2ju2ztobzs06nc6c353mxf1qb','urukzo4jacgzh7m', 'https://i.scdn.co/image/ab67616d0000b27382de1ca074ae63cb18fce335', 'Karol G Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ego7bdr651yjh8nwa764ifca1je1p4e1r9xlos10y05ljpznyy','TQG','urukzo4jacgzh7m','POP','0DWdj2oZMBFSzRsi2Cvfzf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ljf40k6l606t14sikp9c9j62t2ju2ztobzs06nc6c353mxf1qb', 'ego7bdr651yjh8nwa764ifca1je1p4e1r9xlos10y05ljpznyy', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zks15pyl5rckmq9zyyzrxrqmefjwxyal6f7hdg9znck4uztg7m','AMARGURA','urukzo4jacgzh7m','POP','505v13epFXodT9fVAJ6h8k',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ljf40k6l606t14sikp9c9j62t2ju2ztobzs06nc6c353mxf1qb', 'zks15pyl5rckmq9zyyzrxrqmefjwxyal6f7hdg9znck4uztg7m', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jwu28lpdtcukl4a9gyjgogni8tqvdqtvpum7oh7qgfxzfgq4sv','S91','urukzo4jacgzh7m','POP','7EpOXgSRgnglRWr86pZfGU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ljf40k6l606t14sikp9c9j62t2ju2ztobzs06nc6c353mxf1qb', 'jwu28lpdtcukl4a9gyjgogni8tqvdqtvpum7oh7qgfxzfgq4sv', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gs6y2zoupf8brw7flmkkvsjtsh103059dh208w5a42mj1tur6g','MIENTRAS ME CURO DEL CORA','urukzo4jacgzh7m','POP','6otePxalBK8AVa20xhZYVQ',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ljf40k6l606t14sikp9c9j62t2ju2ztobzs06nc6c353mxf1qb', 'gs6y2zoupf8brw7flmkkvsjtsh103059dh208w5a42mj1tur6g', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wueguh3hlj48tn8lfkdioibo4svg2vas40renv0idwv3gi9bj3','X SI VOLVEMOS','urukzo4jacgzh7m','POP','4NoOME4Dhf4xgxbHDT7VGe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ljf40k6l606t14sikp9c9j62t2ju2ztobzs06nc6c353mxf1qb', 'wueguh3hlj48tn8lfkdioibo4svg2vas40renv0idwv3gi9bj3', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kpo5br8yogzk91u8sizt3vjbsstb4nvep37qg9oc86n81pm144','PROVENZA','urukzo4jacgzh7m','POP','3HqcNJdZ2seoGxhn0wVNDK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ljf40k6l606t14sikp9c9j62t2ju2ztobzs06nc6c353mxf1qb', 'kpo5br8yogzk91u8sizt3vjbsstb4nvep37qg9oc86n81pm144', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a2wal9ubprdh0u62bse7ochv0dfoipw8nk2l2n3zreie379y04','CAIRO','urukzo4jacgzh7m','POP','16dUQ4quIHDe4ZZ0wF1EMN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ljf40k6l606t14sikp9c9j62t2ju2ztobzs06nc6c353mxf1qb', 'a2wal9ubprdh0u62bse7ochv0dfoipw8nk2l2n3zreie379y04', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8glaq82cwwx7k9ebnix140w660vx56oa9ixbeunf47jjypgaq4','PERO T','urukzo4jacgzh7m','POP','1dw7qShk971xMD6r6mA4VN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ljf40k6l606t14sikp9c9j62t2ju2ztobzs06nc6c353mxf1qb', '8glaq82cwwx7k9ebnix140w660vx56oa9ixbeunf47jjypgaq4', '7');
-- Sean Paul
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('g382cvmg72e9slu', 'Sean Paul', '76@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb60c3e9abe7327c0097738f22','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:76@artist.com', 'g382cvmg72e9slu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('g382cvmg72e9slu', 'Blending traditional rhythms with modern beats.', 'Sean Paul');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('msmw7jj1epvioshu7bmpg0fglltq6d2xwdoij5gnsa6v9iqwf2','g382cvmg72e9slu', NULL, 'Sean Paul Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1rntiohxm44x5w2nlftxa7skfuf1jlpinz0dlq9cfh414rtcze','Nia Bo','g382cvmg72e9slu','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('msmw7jj1epvioshu7bmpg0fglltq6d2xwdoij5gnsa6v9iqwf2', '1rntiohxm44x5w2nlftxa7skfuf1jlpinz0dlq9cfh414rtcze', '0');
-- Kali Uchis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6gyhmcw7otrse4x', 'Kali Uchis', '77@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:77@artist.com', '6gyhmcw7otrse4x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6gyhmcw7otrse4x', 'A fusion of soul, R&B, and Latin beats, creating a unique sound experience.', 'Kali Uchis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kwmbzdxofdt3czdzeunt3x6qhvdk7hh9ongvm9fsvm7s6zabhi','6gyhmcw7otrse4x', 'https://i.scdn.co/image/ab67616d0000b27381fccd758776d16b87721b17', 'Kali Uchis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jqpe09nl9mbniu46ol6jfno16ti48qq4ebivjthpqou01poj9u','Moonlight','6gyhmcw7otrse4x','POP','0JmnkIqdlnUzPaf8sqBRs3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kwmbzdxofdt3czdzeunt3x6qhvdk7hh9ongvm9fsvm7s6zabhi', 'jqpe09nl9mbniu46ol6jfno16ti48qq4ebivjthpqou01poj9u', '0');
-- Troye Sivan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zwxwrq3p5kju4cx', 'Troye Sivan', '78@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26e8cb3ff6fc7744b312811b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:78@artist.com', 'zwxwrq3p5kju4cx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zwxwrq3p5kju4cx', 'A voice that encapsulates the spirit of modern pop.', 'Troye Sivan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3wp7dwpq4v4ehfshc73fxtv2ww8bcgpwt0msy3ywx44f5zqhvj','zwxwrq3p5kju4cx', 'https://i.scdn.co/image/ab67616d0000b27367103283a4eb57578a428252', 'Troye Sivan Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5wrckeggqtin4cdfm4e3gz27vj4zn142rs7kzhlqcfw7fohn01','Rush','zwxwrq3p5kju4cx','POP','4ZnkygoWLzcGbQYCm3lkae',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3wp7dwpq4v4ehfshc73fxtv2ww8bcgpwt0msy3ywx44f5zqhvj', '5wrckeggqtin4cdfm4e3gz27vj4zn142rs7kzhlqcfw7fohn01', '0');
-- Offset
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pkqitl53xgsmjaj', 'Offset', '79@artist.com', 'https://i.scdn.co/image/ab67616d0000b2736edd8e309824c6f3fd3f3466','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:79@artist.com', 'pkqitl53xgsmjaj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pkqitl53xgsmjaj', 'Uniting fans around the globe with universal rhythms.', 'Offset');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ssvxhja3xt3thhoxd9uvxc8czcktaof7o9js3juaqndu37nd65','pkqitl53xgsmjaj', 'https://i.scdn.co/image/ab67616d0000b2736ed9aef791159496b286179f', 'Offset Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tp7qnrwojsi2rlurn99bhac4g495g24sm8yr507vs6hefn7bh8','Danger (Spider) (Offset & JID)','pkqitl53xgsmjaj','POP','3X6qK1LdMkSOhklwRa2ZfG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ssvxhja3xt3thhoxd9uvxc8czcktaof7o9js3juaqndu37nd65', 'tp7qnrwojsi2rlurn99bhac4g495g24sm8yr507vs6hefn7bh8', '0');
-- A$AP Rocky
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s1zvezu2nk0mi7e', 'A$AP Rocky', '80@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:80@artist.com', 's1zvezu2nk0mi7e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s1zvezu2nk0mi7e', 'Weaving lyrical magic into every song.', 'A$AP Rocky');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jhms9w197mrwntjai340lq2wvpxtd1kmfkkop24ycn2o8jfe1n','s1zvezu2nk0mi7e', NULL, 'A$AP Rocky Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('phh6zaqayhke3p7hl1eryghhpf85oipqdidxhfl2bltdn3rae5','Am I Dreaming (Metro Boomin & A$AP Rocky, Roisee)','s1zvezu2nk0mi7e','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jhms9w197mrwntjai340lq2wvpxtd1kmfkkop24ycn2o8jfe1n', 'phh6zaqayhke3p7hl1eryghhpf85oipqdidxhfl2bltdn3rae5', '0');
-- Drake
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7i000c68bjomss4', 'Drake', '81@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb35ca7d2181258b51c0f2cf9e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:81@artist.com', '7i000c68bjomss4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7i000c68bjomss4', 'A sonic adventurer, always seeking new horizons in music.', 'Drake');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8v739cglx549kjzh8poo6qu2vbmbkwqgrrhjaymv3kiwk9zzox','7i000c68bjomss4', 'https://i.scdn.co/image/ab67616d0000b2738dc0d801766a5aa6a33cbe37', 'Drake Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7e6bchjnit7orw6jgnvgfol3t1v53n7ksmw14cjmi8zmnql4qo','Jimmy Cooks (feat. 21 Savage)','7i000c68bjomss4','POP','3F5CgOj3wFlRv51JsHbxhe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8v739cglx549kjzh8poo6qu2vbmbkwqgrrhjaymv3kiwk9zzox', '7e6bchjnit7orw6jgnvgfol3t1v53n7ksmw14cjmi8zmnql4qo', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5b85geoidcsihlf3waokmbmt2m38zkl1w6dfg7fa0hxti3wett','One Dance','7i000c68bjomss4','POP','1zi7xx7UVEFkmKfv06H8x0',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8v739cglx549kjzh8poo6qu2vbmbkwqgrrhjaymv3kiwk9zzox', '5b85geoidcsihlf3waokmbmt2m38zkl1w6dfg7fa0hxti3wett', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('itsxoxj08asnykfoz85tiyt41m1nzubhhxrvva4zoh7tucmcj1','Search & Rescue','7i000c68bjomss4','POP','7aRCf5cLOFN1U7kvtChY1G',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8v739cglx549kjzh8poo6qu2vbmbkwqgrrhjaymv3kiwk9zzox', 'itsxoxj08asnykfoz85tiyt41m1nzubhhxrvva4zoh7tucmcj1', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gspco8rqxijoo3yqmdyovde63vb7xct3j6qypij6uduba41txy','Rich Flex','7i000c68bjomss4','POP','1bDbXMyjaUIooNwFE9wn0N',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8v739cglx549kjzh8poo6qu2vbmbkwqgrrhjaymv3kiwk9zzox', 'gspco8rqxijoo3yqmdyovde63vb7xct3j6qypij6uduba41txy', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('piz66ejb4wv72u7cpv49ped7xd52nma1dtzgk73vidakj3nkgt','WAIT FOR U (feat. Drake & Tems)','7i000c68bjomss4','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8v739cglx549kjzh8poo6qu2vbmbkwqgrrhjaymv3kiwk9zzox', 'piz66ejb4wv72u7cpv49ped7xd52nma1dtzgk73vidakj3nkgt', '4');
-- Nicki Minaj
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kg47hoc3afsr5k6', 'Nicki Minaj', '82@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03578c92e15089c645b794f5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:82@artist.com', 'kg47hoc3afsr5k6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kg47hoc3afsr5k6', 'A rap icon known for her versatile flow and bold personality.', 'Nicki Minaj');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fm3wy1z2haeqw6z39samtfdaz1w4bkdn8klh684t9fy2rmlr1m','kg47hoc3afsr5k6', 'https://i.scdn.co/image/ab67616d0000b2737e8f938c02fac3b564931116', 'Nicki Minaj Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1l083wczzt1rlv71537f06yilqjkxtqqqnfro7xlt2j0to7fhj','Barbie World (with Aqua) [From Barbie The Album]','kg47hoc3afsr5k6','POP','741UUVE2kuITl0c6zuqqbO','https://p.scdn.co/mp3-preview/f654928ccaa4e6a9fb09a6eb3f208383eccc12a9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fm3wy1z2haeqw6z39samtfdaz1w4bkdn8klh684t9fy2rmlr1m', '1l083wczzt1rlv71537f06yilqjkxtqqqnfro7xlt2j0to7fhj', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n4svyd66xv8oes9bgpebetiztja5473xlqqaw6quyajds4yn4l','Princess Diana (with Nicki Minaj)','kg47hoc3afsr5k6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fm3wy1z2haeqw6z39samtfdaz1w4bkdn8klh684t9fy2rmlr1m', 'n4svyd66xv8oes9bgpebetiztja5473xlqqaw6quyajds4yn4l', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('smksldlroq29i2my3b418i28hi8fsfrzjl42agcxk74yyyd7o0','Red Ruby Da Sleeze','kg47hoc3afsr5k6','POP','4ZYAU4A2YBtlNdqOUtc7T2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fm3wy1z2haeqw6z39samtfdaz1w4bkdn8klh684t9fy2rmlr1m', 'smksldlroq29i2my3b418i28hi8fsfrzjl42agcxk74yyyd7o0', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rerj1i9s297p8zxspfkm6nl4hcup4jupepvoxq5akmog1qq1s4','Super Freaky Girl','kg47hoc3afsr5k6','POP','4C6Uex2ILwJi9sZXRdmqXp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fm3wy1z2haeqw6z39samtfdaz1w4bkdn8klh684t9fy2rmlr1m', 'rerj1i9s297p8zxspfkm6nl4hcup4jupepvoxq5akmog1qq1s4', '3');
-- Ayparia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f1ypca5tnpj44md', 'Ayparia', '83@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebff258a75f7364baaaf9ed011','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:83@artist.com', 'f1ypca5tnpj44md', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('f1ypca5tnpj44md', 'Delivering a unique blend of sounds, showcasing versatility and artistic depth.', 'Ayparia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6h90grcncskwziiqowvr11vay4gfysc37xfr654ice2raa8n2n','f1ypca5tnpj44md', NULL, 'Ayparia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h044i0wq8mp6lde4s5uw86zvkhkovwq7w7l2nuedn58ev4h0cg','MONTAGEM - FR PUNK','f1ypca5tnpj44md','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6h90grcncskwziiqowvr11vay4gfysc37xfr654ice2raa8n2n', 'h044i0wq8mp6lde4s5uw86zvkhkovwq7w7l2nuedn58ev4h0cg', '0');
-- Jasiel Nuez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ecpgmova8qqslha', 'Jasiel Nuez', '84@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:84@artist.com', 'ecpgmova8qqslha', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ecpgmova8qqslha', 'Pioneering new paths in the musical landscape.', 'Jasiel Nuez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('m9y5hy35qyngz35ryjdgxkoqgtedbhw7zqpdy6cum8mlvlk9g2','ecpgmova8qqslha', NULL, 'Jasiel Nuez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rcp15vpw32rtlabzfdz09wzu1wxct6ct89fnalito0mbw3jckb','LAGUNAS','ecpgmova8qqslha','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m9y5hy35qyngz35ryjdgxkoqgtedbhw7zqpdy6cum8mlvlk9g2', 'rcp15vpw32rtlabzfdz09wzu1wxct6ct89fnalito0mbw3jckb', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9tjcau5wceykb4yjlxdy2d5hwoqq3gc8lmwe5absjbvldsuqdb','Rosa Pastel','ecpgmova8qqslha','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m9y5hy35qyngz35ryjdgxkoqgtedbhw7zqpdy6cum8mlvlk9g2', '9tjcau5wceykb4yjlxdy2d5hwoqq3gc8lmwe5absjbvldsuqdb', '1');
-- Ana Castela
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ak0iz4cd58nubab', 'Ana Castela', '85@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26abde7ba3cfdfb8c1900baf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:85@artist.com', 'ak0iz4cd58nubab', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ak0iz4cd58nubab', 'A unique voice in the contemporary music scene.', 'Ana Castela');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oiauutku2s2dykr98u0x0l411jv5j2hr23wpiwgg8bp4u22vj4','ak0iz4cd58nubab', NULL, 'Ana Castela Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u314f2ubr3o7uzcr0uts4hxoas4q0fojjdshbhqfxxa9heegqb','Nosso Quadro','ak0iz4cd58nubab','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oiauutku2s2dykr98u0x0l411jv5j2hr23wpiwgg8bp4u22vj4', 'u314f2ubr3o7uzcr0uts4hxoas4q0fojjdshbhqfxxa9heegqb', '0');
-- Tini
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w0txublg4fvjb40', 'Tini', '86@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd1ee0c41d3c79e916b910696','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:86@artist.com', 'w0txublg4fvjb40', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w0txublg4fvjb40', 'An odyssey of sound that defies conventions.', 'Tini');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o74sut0ab72n8yyszxaud54mz33nvwdyjtzund5mmo9hjsgp92','w0txublg4fvjb40', 'https://i.scdn.co/image/ab67616d0000b273f5409c637b9a7244e0c0d11d', 'Tini Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3id2i4opy7ihcpxjst5jiwvdyptefqsy8lh1o278a89tdnbya0','Cupido','w0txublg4fvjb40','POP','04ndZkbKGthTgYSv3xS7en','https://p.scdn.co/mp3-preview/15bc4fa0d69ae03a045704bcc8731def7453458b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o74sut0ab72n8yyszxaud54mz33nvwdyjtzund5mmo9hjsgp92', '3id2i4opy7ihcpxjst5jiwvdyptefqsy8lh1o278a89tdnbya0', '0');
-- Sia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wcjpom89rkef94s', 'Sia', '87@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb25a749000611559f1719cc5f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:87@artist.com', 'wcjpom89rkef94s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wcjpom89rkef94s', 'Blending traditional rhythms with modern beats.', 'Sia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('f6z26q26vei1atxpklbpsud7t918m23aqatjd4aen41yt8j7uk','wcjpom89rkef94s', 'https://i.scdn.co/image/ab67616d0000b273754b2fddebe7039fdb912837', 'Sia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yo0a2a7ur6bvs61uva2bik2iww9a49u755du9nybitm4zd11ag','Unstoppable','wcjpom89rkef94s','POP','1yvMUkIOTeUNtNWlWRgANS','https://p.scdn.co/mp3-preview/99a07d00531c0053f55a46e94ed92b1560396754?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6z26q26vei1atxpklbpsud7t918m23aqatjd4aen41yt8j7uk', 'yo0a2a7ur6bvs61uva2bik2iww9a49u755du9nybitm4zd11ag', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('80emzd9cqpaz3fapxtp9i63qr6mupvl9oyugwgue9ammxyjyk8','Snowman','wcjpom89rkef94s','POP','7uoFMmxln0GPXQ0AcCBXRq','https://p.scdn.co/mp3-preview/a936030efc27a4fc52d8c42b20d03ca4cab30836?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6z26q26vei1atxpklbpsud7t918m23aqatjd4aen41yt8j7uk', '80emzd9cqpaz3fapxtp9i63qr6mupvl9oyugwgue9ammxyjyk8', '1');
-- Yandel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wxmqhptwwh6g1qd', 'Yandel', '88@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7dbaf2fabcbd4b37168397fd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:88@artist.com', 'wxmqhptwwh6g1qd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wxmqhptwwh6g1qd', 'A powerhouse of reggaeton, blending rhythms that move the soul.', 'Yandel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6nwqvhwbewo439aqt97w0vmapcdktdzd12awkyrn0gh088rpvo','wxmqhptwwh6g1qd', 'https://i.scdn.co/image/ab67616d0000b273b2aec01b56eeb74610532700', 'Yandel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('81qzgw0oozjij4dzgzkl28jbd4pcudl51icif55edxzro9mmi3','Yandel 150','wxmqhptwwh6g1qd','POP','4FAKtPVycI4DxoOHC01YqD','https://p.scdn.co/mp3-preview/338ed053ce26ccc3313b00b5e6153e60ffd2eb19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6nwqvhwbewo439aqt97w0vmapcdktdzd12awkyrn0gh088rpvo', '81qzgw0oozjij4dzgzkl28jbd4pcudl51icif55edxzro9mmi3', '0');
-- Kelly Clarkson
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('muc8jmpiyexdyt9', 'Kelly Clarkson', '89@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb305a7cc6760b53a67aaae19d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:89@artist.com', 'muc8jmpiyexdyt9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('muc8jmpiyexdyt9', 'A unique voice in the contemporary music scene.', 'Kelly Clarkson');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ypzdp6dsu3no9jo6b25zifqq2hvx7a6zy2lhsy0awsri5hg0mt','muc8jmpiyexdyt9', 'https://i.scdn.co/image/ab67616d0000b273f54a315f1d2445791fe601a7', 'Kelly Clarkson Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qt7xh7t9s1tgdm3kq9kk6rtqxpzsveuqpgtni8ilgaliof85d2','Underneath the Tree','muc8jmpiyexdyt9','POP','3YZE5qDV7u1ZD1gZc47ZeR','https://p.scdn.co/mp3-preview/9d6040eda6551e1746409ca2c8cf04d95475019a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ypzdp6dsu3no9jo6b25zifqq2hvx7a6zy2lhsy0awsri5hg0mt', 'qt7xh7t9s1tgdm3kq9kk6rtqxpzsveuqpgtni8ilgaliof85d2', '0');
-- Imagine Dragons
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gfeoq80jm33dibt', 'Imagine Dragons', '90@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb920dc1f617550de8388f368e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:90@artist.com', 'gfeoq80jm33dibt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gfeoq80jm33dibt', 'Uniting fans around the globe with universal rhythms.', 'Imagine Dragons');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7830mrv1x50w6c09a9dvdpj60wyqbofhjvvr4mvgle28zid5fz','gfeoq80jm33dibt', 'https://i.scdn.co/image/ab67616d0000b273fc915b69600dce2991a61f13', 'Imagine Dragons Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ookvmhdobu9pj49dcmq1vv5dxul5rzucylf0aeyymsnc6nihcf','Bones','gfeoq80jm33dibt','POP','54ipXppHLA8U4yqpOFTUhr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7830mrv1x50w6c09a9dvdpj60wyqbofhjvvr4mvgle28zid5fz', 'ookvmhdobu9pj49dcmq1vv5dxul5rzucylf0aeyymsnc6nihcf', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5bk1i17ftkq95ojq2ndcsmc8yeiaasgx4dchongouirsuq78xj','Believer','gfeoq80jm33dibt','POP','0pqnGHJpmpxLKifKRmU6WP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7830mrv1x50w6c09a9dvdpj60wyqbofhjvvr4mvgle28zid5fz', '5bk1i17ftkq95ojq2ndcsmc8yeiaasgx4dchongouirsuq78xj', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ws02i3tmdap06kw7u17qqeobsq4fp4j5db6dm62uvf6yj2c1y1','Demons','gfeoq80jm33dibt','POP','3LlAyCYU26dvFZBDUIMb7a',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7830mrv1x50w6c09a9dvdpj60wyqbofhjvvr4mvgle28zid5fz', 'ws02i3tmdap06kw7u17qqeobsq4fp4j5db6dm62uvf6yj2c1y1', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qvrxd2akpzbn551it51i990qktcs5ob5hc369rcfj22in2i0kq','Enemy (with JID) - from the series Arcane League of Legends','gfeoq80jm33dibt','POP','3CIyK1V4JEJkg02E4EJnDl',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7830mrv1x50w6c09a9dvdpj60wyqbofhjvvr4mvgle28zid5fz', 'qvrxd2akpzbn551it51i990qktcs5ob5hc369rcfj22in2i0kq', '3');
-- WizKid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b3i3ljdxoqil3lv', 'WizKid', '91@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9050b61368975fda051cdc06','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:91@artist.com', 'b3i3ljdxoqil3lv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b3i3ljdxoqil3lv', 'A tapestry of rhythms that echo the pulse of life.', 'WizKid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nedbe05gscejamb1uqy3eceaeo0bkonortoyvsnaibycuyfpy4','b3i3ljdxoqil3lv', NULL, 'WizKid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wtveg1z119kqqx0lxffowngjxzezoliytltwa568dsl02dpvcc','Link Up (Metro Boomin & Don Toliver, Wizkid feat. BEAM & Toian) - Spider-Verse Remix (Spider-Man: Across the Spider-Verse )','b3i3ljdxoqil3lv','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nedbe05gscejamb1uqy3eceaeo0bkonortoyvsnaibycuyfpy4', 'wtveg1z119kqqx0lxffowngjxzezoliytltwa568dsl02dpvcc', '0');
-- Arcangel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b4l19xl3bpg7irw', 'Arcangel', '92@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebafdf17286a0d7a23ad388587','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:92@artist.com', 'b4l19xl3bpg7irw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b4l19xl3bpg7irw', 'Melodies that capture the essence of human emotion.', 'Arcangel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tx28kn8djib25tjg4bdabebbvs9cldhs8bvzq7y1n52fk6la5h','b4l19xl3bpg7irw', 'https://i.scdn.co/image/ab67616d0000b27330326b23e30ae93d4d48165b', 'Arcangel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('976s2pydj5c0bdgt32pr4z775tahot1pxlx2tov37weazoeki0','La Jumpa','b4l19xl3bpg7irw','POP','2mnXxnrX5vCGolNkaFvVeM','https://p.scdn.co/mp3-preview/8bcdff4719a7a4211128ec93da03892e46c4bc6a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tx28kn8djib25tjg4bdabebbvs9cldhs8bvzq7y1n52fk6la5h', '976s2pydj5c0bdgt32pr4z775tahot1pxlx2tov37weazoeki0', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hl89xpkbc6el13kwveviesx7b66supv4w0uxmr59g6xdvqxn6c','Arcngel: Bzrp Music Sessions, Vol','b4l19xl3bpg7irw','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tx28kn8djib25tjg4bdabebbvs9cldhs8bvzq7y1n52fk6la5h', 'hl89xpkbc6el13kwveviesx7b66supv4w0uxmr59g6xdvqxn6c', '1');
-- a-ha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x3g49pqr606ud4r', 'a-ha', '93@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0168ba8148c07c2cdeb7d067','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:93@artist.com', 'x3g49pqr606ud4r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x3g49pqr606ud4r', 'A symphony of emotions expressed through sound.', 'a-ha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j41bvxktuxbddgxi00n4s4xmerjwneq63wk8demv7hp69h7krj','x3g49pqr606ud4r', 'https://i.scdn.co/image/ab67616d0000b273e8dd4db47e7177c63b0b7d53', 'a-ha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1yl5fbiu3yxllf89ykdjgdxl5kprr5zh18hh4k03n4peiljdqj','Take On Me','x3g49pqr606ud4r','POP','2WfaOiMkCvy7F5fcp2zZ8L','https://p.scdn.co/mp3-preview/ed66a8c444c35b2f5029c04ae8e18f69d952c2bb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j41bvxktuxbddgxi00n4s4xmerjwneq63wk8demv7hp69h7krj', '1yl5fbiu3yxllf89ykdjgdxl5kprr5zh18hh4k03n4peiljdqj', '0');
-- TV Girl
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lgr37ba4ir9061c', 'TV Girl', '94@artist.com', 'https://i.scdn.co/image/ab67616d0000b27332f5fec7a879ed6ef28f0dfd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:94@artist.com', 'lgr37ba4ir9061c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lgr37ba4ir9061c', 'Transcending language barriers through the universal language of music.', 'TV Girl');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('znai9pnj1uap07rmp7nemr5hv3crbdzazed4nv7cwzkow6tuol','lgr37ba4ir9061c', 'https://i.scdn.co/image/ab67616d0000b273e1bc1af856b42dd7fdba9f84', 'TV Girl Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gfz23jqpmrjv3jgd8ycuu8qt2p0xcy183j95b8uz1w4vwpq8mh','Lovers Rock','lgr37ba4ir9061c','POP','6dBUzqjtbnIa1TwYbyw5CM','https://p.scdn.co/mp3-preview/922a42db5aa8f8d335725697b7d7a12af6808f3a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('znai9pnj1uap07rmp7nemr5hv3crbdzazed4nv7cwzkow6tuol', 'gfz23jqpmrjv3jgd8ycuu8qt2p0xcy183j95b8uz1w4vwpq8mh', '0');
-- Gorillaz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mmij2ks15xinxfx', 'Gorillaz', '95@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb337d671a32b2f44d4a4e6cf2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:95@artist.com', 'mmij2ks15xinxfx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mmij2ks15xinxfx', 'An endless quest for musical perfection.', 'Gorillaz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tq7syazqp57owxtdjjrmp0v2ic7bjcfi25wh2pxw6mii8mwr7z','mmij2ks15xinxfx', 'https://i.scdn.co/image/ab67616d0000b2734b0ddebba0d5b34f2a2f07a4', 'Gorillaz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ff0iwddzwshxazx0f7s013h91p5czna5zu5w5vwyas4iw6nwrc','Tormenta (feat. Bad Bunny)','mmij2ks15xinxfx','POP','38UYeBLfvpnDSG9GznZdnL','https://p.scdn.co/mp3-preview/3f89a1c3ec527e23fdefdd03da7797b83eb6e14f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tq7syazqp57owxtdjjrmp0v2ic7bjcfi25wh2pxw6mii8mwr7z', 'ff0iwddzwshxazx0f7s013h91p5czna5zu5w5vwyas4iw6nwrc', '0');
-- Becky G
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rd8m8w3dcz3ym5n', 'Becky G', '96@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd132bf0d4a9203404cd66f79','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:96@artist.com', 'rd8m8w3dcz3ym5n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rd8m8w3dcz3ym5n', 'A sonic adventurer, always seeking new horizons in music.', 'Becky G');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('11tqonuubryo35coo2oldtmooqfnc12ej1b0ftiw0ba0b2uzsd','rd8m8w3dcz3ym5n', 'https://i.scdn.co/image/ab67616d0000b273c3bb167f0e78b15e5588c296', 'Becky G Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hb3akrrthrklf9hed0k0ghfil2ca30f6itx0y5rscn2qf3zz9x','Chanel','rd8m8w3dcz3ym5n','POP','5RcxRGvmYai7kpFSfxe5GY','https://p.scdn.co/mp3-preview/38dbb82dace64ea92e1dafe5989c1d1861656595?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('11tqonuubryo35coo2oldtmooqfnc12ej1b0ftiw0ba0b2uzsd', 'hb3akrrthrklf9hed0k0ghfil2ca30f6itx0y5rscn2qf3zz9x', '0');
-- SZA
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('40yl5xw1oy1gbm6', 'SZA', '97@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7eb7f6371aad8e67e01f0a03','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:97@artist.com', '40yl5xw1oy1gbm6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('40yl5xw1oy1gbm6', 'An avant-garde R&B artist painting vivid stories through her music.', 'SZA');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ll8nviq89o7168cc9l4jzuok00pduu9ognsvl7ysyv7vko1hsx','40yl5xw1oy1gbm6', 'https://i.scdn.co/image/ab67616d0000b2730c471c36970b9406233842a5', 'SZA Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ajthg59h23gnaygpuwvvmf9zxexlsyc5b1kwh5z039wzech0du','Kill Bill','40yl5xw1oy1gbm6','POP','1Qrg8KqiBpW07V7PNxwwwL','https://p.scdn.co/mp3-preview/4bd2dc84016f3743add7eea8b988407b1b900672?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ll8nviq89o7168cc9l4jzuok00pduu9ognsvl7ysyv7vko1hsx', 'ajthg59h23gnaygpuwvvmf9zxexlsyc5b1kwh5z039wzech0du', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xabdk9ej26i6a6zso35y5t3mfxy36tjggpeyrcteh4z6lfzfw5','Snooze','40yl5xw1oy1gbm6','POP','4iZ4pt7kvcaH6Yo8UoZ4s2','https://p.scdn.co/mp3-preview/8c53920b5fd2c3178afa36cac9eec68b5ee9204a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ll8nviq89o7168cc9l4jzuok00pduu9ognsvl7ysyv7vko1hsx', 'xabdk9ej26i6a6zso35y5t3mfxy36tjggpeyrcteh4z6lfzfw5', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l49f0nfdljp4l06o1dc9o564put8gzl9f026iiigi74cyhm7a0','Low','40yl5xw1oy1gbm6','POP','2GAhgAjOhEmItWLfgisyOn','https://p.scdn.co/mp3-preview/5b6dd5a1d06d0bdfd57382a584cbf0227b4d9a4b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ll8nviq89o7168cc9l4jzuok00pduu9ognsvl7ysyv7vko1hsx', 'l49f0nfdljp4l06o1dc9o564put8gzl9f026iiigi74cyhm7a0', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0yixr9g6snoaocbbplcrmuwq8o3yy9yk0vcub13g9vmw8rjcrg','Nobody Gets Me','40yl5xw1oy1gbm6','POP','5Y35SjAfXjjG0sFQ3KOxmm','https://p.scdn.co/mp3-preview/36cfe8fbfb78aa38ca3b222c4b9fc88cda992841?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ll8nviq89o7168cc9l4jzuok00pduu9ognsvl7ysyv7vko1hsx', '0yixr9g6snoaocbbplcrmuwq8o3yy9yk0vcub13g9vmw8rjcrg', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wequ48aojnuwstpxgjweraftev0pyt04g94zv18i7hz9phjpu2','Shirt','40yl5xw1oy1gbm6','POP','2wSTnntOPRi7aQneobFtU4','https://p.scdn.co/mp3-preview/8819fb0dc127d1d777a776f4d1186be783334ae5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ll8nviq89o7168cc9l4jzuok00pduu9ognsvl7ysyv7vko1hsx', 'wequ48aojnuwstpxgjweraftev0pyt04g94zv18i7hz9phjpu2', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7d26hpporfbr7r6tgow19ia08ur4kvvsqpqjgnpyapabx43xfn','Blind','40yl5xw1oy1gbm6','POP','2CSRrnOEELmhpq8iaAi9cd','https://p.scdn.co/mp3-preview/56cd00fd7aa857bd25e4ed25aebc0e41a24bfd4f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ll8nviq89o7168cc9l4jzuok00pduu9ognsvl7ysyv7vko1hsx', '7d26hpporfbr7r6tgow19ia08ur4kvvsqpqjgnpyapabx43xfn', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lb08uh1ektid8b87uxeypkwbk7mdcujnnezjzprrriuryi2b8d','Good Days','40yl5xw1oy1gbm6','POP','4PMqSO5qyjpvzhlLI5GnID','https://p.scdn.co/mp3-preview/d7fd97c8190baa298af9b4e778d2ba940fcd13a4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ll8nviq89o7168cc9l4jzuok00pduu9ognsvl7ysyv7vko1hsx', 'lb08uh1ektid8b87uxeypkwbk7mdcujnnezjzprrriuryi2b8d', '6');
-- Lizzo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yin097qo134772j', 'Lizzo', '98@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0d66b3670294bf801847dae2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:98@artist.com', 'yin097qo134772j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yin097qo134772j', 'A journey through the spectrum of sound in every album.', 'Lizzo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('en4hpbc5y27r0eztn0ue8gzafb48ork20xyfhzsnsyucq2nqy2','yin097qo134772j', 'https://i.scdn.co/image/ab67616d0000b273b817e721691aff3d67f26c04', 'Lizzo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hx2c6rj14s7npwu4l8bym2kaigopds8nsoo5npnwmwpoc5q6wi','About Damn Time','yin097qo134772j','POP','1PckUlxKqWQs3RlWXVBLw3','https://p.scdn.co/mp3-preview/bbf8a26d38f7d8c7191dd64bd7c21a4cec8b61a0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('en4hpbc5y27r0eztn0ue8gzafb48ork20xyfhzsnsyucq2nqy2', 'hx2c6rj14s7npwu4l8bym2kaigopds8nsoo5npnwmwpoc5q6wi', '0');
-- Rauw Alejandro
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xo4h14zvjre9d3o', 'Rauw Alejandro', '99@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9047f938310ea16b68a5bdeb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:99@artist.com', 'xo4h14zvjre9d3o', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xo4h14zvjre9d3o', 'A fusion of Latin trap and reggaeton, setting the stage on fire.', 'Rauw Alejandro');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j5wo7kahg0wup0d9tpxtbtqkmggtounvfii583ar22svb8bjtc','xo4h14zvjre9d3o', NULL, 'Rauw Alejandro Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mizwn0b5o5yjr6kiqopvc8bj00xuughbxwr31n4rpcjyv6q7i6','BESO','xo4h14zvjre9d3o','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j5wo7kahg0wup0d9tpxtbtqkmggtounvfii583ar22svb8bjtc', 'mizwn0b5o5yjr6kiqopvc8bj00xuughbxwr31n4rpcjyv6q7i6', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6mqa91lqf5rju3c83zdt4t60q38b6ucxdwfun97pz4s5anclwh','BABY HELLO','xo4h14zvjre9d3o','POP','2SOvWt6igzXViIjIiWNWEP','https://p.scdn.co/mp3-preview/8a9ca6c81e6e6ad48758f02017456405fd7a476d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j5wo7kahg0wup0d9tpxtbtqkmggtounvfii583ar22svb8bjtc', '6mqa91lqf5rju3c83zdt4t60q38b6ucxdwfun97pz4s5anclwh', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uyihj817dblbqfvnz4a7lqsygweqpb2wqnw2tqjftmw6a8lxxr','Rauw Alejandro: Bzrp Music Sessions, Vol. 56','xo4h14zvjre9d3o','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j5wo7kahg0wup0d9tpxtbtqkmggtounvfii583ar22svb8bjtc', 'uyihj817dblbqfvnz4a7lqsygweqpb2wqnw2tqjftmw6a8lxxr', '2');
-- New West
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s2zmna00o885fxp', 'New West', '100@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb32a5faa77c82348cf5d13590','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:100@artist.com', 's2zmna00o885fxp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s2zmna00o885fxp', 'Revolutionizing the music scene with innovative compositions.', 'New West');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u4ak292mdyfzhb18w0bhvhn4rwf93evg2fpd6a4u3340r65sge','s2zmna00o885fxp', 'https://i.scdn.co/image/ab67616d0000b2731bb5dc21200bfc56d8f7ef41', 'New West Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jdmcmul35hhqj83er54l43muo6a0n3zs4sfornjno8hwlhg629','Those Eyes','s2zmna00o885fxp','POP','50x1Ic8CaXkYNvjmxe3WXy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u4ak292mdyfzhb18w0bhvhn4rwf93evg2fpd6a4u3340r65sge', 'jdmcmul35hhqj83er54l43muo6a0n3zs4sfornjno8hwlhg629', '0');
-- Elley Duh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bq1b8e5cqw4og4f', 'Elley Duh', '101@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb44efd91d240d9853049612b4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:101@artist.com', 'bq1b8e5cqw4og4f', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bq1b8e5cqw4og4f', 'Uniting fans around the globe with universal rhythms.', 'Elley Duh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1btu9r6e3y2c89b5kznybf4seywufh0q9xrxsduqeqgp7my0iz','bq1b8e5cqw4og4f', 'https://i.scdn.co/image/ab67616d0000b27353a2e11c1bde700722fecd2e', 'Elley Duh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j82dqlatcsely851rpu2pfdoaew3cdxh8uysqn03q3kqbf4n65','MIDDLE OF THE NIGHT','bq1b8e5cqw4og4f','POP','58HvfVOeJY7lUuCqF0m3ly','https://p.scdn.co/mp3-preview/e7c2441dcf8e321237c35085e4aa05bd0dcfa2c4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1btu9r6e3y2c89b5kznybf4seywufh0q9xrxsduqeqgp7my0iz', 'j82dqlatcsely851rpu2pfdoaew3cdxh8uysqn03q3kqbf4n65', '0');
-- Stray Kids
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k813gk13aezm38e', 'Stray Kids', '102@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0610877c41cb9cc12ad39cc0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:102@artist.com', 'k813gk13aezm38e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k813gk13aezm38e', 'A confluence of cultural beats and contemporary tunes.', 'Stray Kids');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jmt3j6lssx1i4vknmum2djaa07dl3zftemo39hvoa0ftfv5uvr','k813gk13aezm38e', 'https://i.scdn.co/image/ab67616d0000b273e27ba26bc14a563bf3d09882', 'Stray Kids Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h6eqxs8xfcitd4mj3f6mdzr43yp94qvea0gymrtxm8xcaz9ii5','S-Class','k813gk13aezm38e','POP','3gTQwwDNJ42CCLo3Sf4JDd','https://p.scdn.co/mp3-preview/4ea586fdcc2c9aec34a18d2034d1dec78a3b5e25?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jmt3j6lssx1i4vknmum2djaa07dl3zftemo39hvoa0ftfv5uvr', 'h6eqxs8xfcitd4mj3f6mdzr43yp94qvea0gymrtxm8xcaz9ii5', '0');
-- Kanii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zdh3zymmy5ksy3n', 'Kanii', '103@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb777f2bab9e5f1e343c3126d4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:103@artist.com', 'zdh3zymmy5ksy3n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zdh3zymmy5ksy3n', 'An odyssey of sound that defies conventions.', 'Kanii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i5yexzfyd0za6aw54birvt4cptjkhndqh6c6895v2qnpeqvdxe','zdh3zymmy5ksy3n', 'https://i.scdn.co/image/ab67616d0000b273efae10889cd442784f3acd3d', 'Kanii Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('64fuawrkdm2lmx632c9q3z1o6y41zgiil128sln6r7getfg36e','I Know - PR1SVX Edit','zdh3zymmy5ksy3n','POP','3vcLw8QA3yCOkrj9oLSZNs','https://p.scdn.co/mp3-preview/146ad1bb65b8f9b097f356d2d5758657a06466dc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i5yexzfyd0za6aw54birvt4cptjkhndqh6c6895v2qnpeqvdxe', '64fuawrkdm2lmx632c9q3z1o6y41zgiil128sln6r7getfg36e', '0');
-- Charlie Puth
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0vl4qdhhnpxo5di', 'Charlie Puth', '104@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb63de91415970a2f5bc920fa8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:104@artist.com', '0vl4qdhhnpxo5di', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0vl4qdhhnpxo5di', 'A pop maestro, combining catchy melodies with his exceptional musical talent.', 'Charlie Puth');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7m2jzl1asrpi851m86fh406y86yzhx673dte2ru2ua6185ap5j','0vl4qdhhnpxo5di', 'https://i.scdn.co/image/ab67616d0000b27335d2e0ed94a934f2cc46fa49', 'Charlie Puth Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('feldhhhvhc6hgaix4sukzqhj2d4sm9x0tj8fpa41m6kl51gs8l','Left and Right (Feat. Jung Kook of BTS)','0vl4qdhhnpxo5di','POP','5Odq8ohlgIbQKMZivbWkEo','https://p.scdn.co/mp3-preview/9e4342eefa4f33df4e9b199e60dbce0f59e46eff?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7m2jzl1asrpi851m86fh406y86yzhx673dte2ru2ua6185ap5j', 'feldhhhvhc6hgaix4sukzqhj2d4sm9x0tj8fpa41m6kl51gs8l', '0');
-- Hotel Ugly
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pf1h5g9dtaxx41t', 'Hotel Ugly', '105@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb939033cc36c08ab68b33f760','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:105@artist.com', 'pf1h5g9dtaxx41t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pf1h5g9dtaxx41t', 'Redefining what it means to be an artist in the digital age.', 'Hotel Ugly');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dtc22gsthwxl0bc5245e969op1czdowjwlufub9wv2dgjocjgy','pf1h5g9dtaxx41t', 'https://i.scdn.co/image/ab67616d0000b273350ab7a839c04bfd5225a9f5', 'Hotel Ugly Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d3yizui400anwdxuunqgbz19n5y7aowqjvjvxptb9cdtmu06uw','Shut up My Moms Calling','pf1h5g9dtaxx41t','POP','3hxIUxnT27p5WcmjGUXNwx','https://p.scdn.co/mp3-preview/7642409265c74b714a2f0f0dd8663c031e253485?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dtc22gsthwxl0bc5245e969op1czdowjwlufub9wv2dgjocjgy', 'd3yizui400anwdxuunqgbz19n5y7aowqjvjvxptb9cdtmu06uw', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('muta88krixe0gon5zp5xwxd1vc6tmqwsii5z5jrrdiqxeh59j9','Shut up My Moms Calling - (Sped Up)','pf1h5g9dtaxx41t','POP','31mzt4ZV8C0f52pIz1NSwd','https://p.scdn.co/mp3-preview/4417d6fbf78b2a96b067dc092f888178b155b6b7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dtc22gsthwxl0bc5245e969op1czdowjwlufub9wv2dgjocjgy', 'muta88krixe0gon5zp5xwxd1vc6tmqwsii5z5jrrdiqxeh59j9', '1');
-- Eslabon Armado
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qpofogw46l2mzll', 'Eslabon Armado', '106@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5ccab5d3dc10a08d89cbd76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:106@artist.com', 'qpofogw46l2mzll', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qpofogw46l2mzll', 'Bringing a fresh take to traditional music, weaving in modern influences.', 'Eslabon Armado');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xfc84qbooh66587b2otyg76zhiijdqbijrmf1cux3r9vrztqjq','qpofogw46l2mzll', 'https://i.scdn.co/image/ab67616d0000b2732071a0c79802d9375a53bfef', 'Eslabon Armado Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8c6b173ge0hr9ydahx1u2vg3iboxsbw8zts55u75hnlosp7iv3','Ella Baila Sola','qpofogw46l2mzll','POP','3dnP0JxCgygwQH9Gm7q7nb','https://p.scdn.co/mp3-preview/5d39f3e17f1e20e2711d033001e48b8d4249b992?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xfc84qbooh66587b2otyg76zhiijdqbijrmf1cux3r9vrztqjq', '8c6b173ge0hr9ydahx1u2vg3iboxsbw8zts55u75hnlosp7iv3', '0');
-- Radiohead
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8pbxw5mqif5ef0s', 'Radiohead', '107@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba03696716c9ee605006047fd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:107@artist.com', '8pbxw5mqif5ef0s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8pbxw5mqif5ef0s', 'Blending traditional rhythms with modern beats.', 'Radiohead');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('00ucqpa1jjd2s9ewpg27jej46f8cjx6t8m5lagjko27y1zsi3m','8pbxw5mqif5ef0s', 'https://i.scdn.co/image/ab67616d0000b273df55e326ed144ab4f5cecf95', 'Radiohead Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nxn9f5hyudgo0f21mcf3f7lj40dkkywhmu5epjf7s2afz3br2z','Creep','8pbxw5mqif5ef0s','POP','70LcF31zb1H0PyJoS1Sx1r','https://p.scdn.co/mp3-preview/713b601d02641a850f2a3e6097aacaff52328d57?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('00ucqpa1jjd2s9ewpg27jej46f8cjx6t8m5lagjko27y1zsi3m', 'nxn9f5hyudgo0f21mcf3f7lj40dkkywhmu5epjf7s2afz3br2z', '0');
-- Wham!
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5w10lytz6nalvff', 'Wham!', '108@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03e73d13341a8419eea9fcfb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:108@artist.com', '5w10lytz6nalvff', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5w10lytz6nalvff', 'A confluence of cultural beats and contemporary tunes.', 'Wham!');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d4woy3us3eohptyrmyi6a9nclisvn9m7rm0khfnhrfxhk2srk6','5w10lytz6nalvff', 'https://i.scdn.co/image/ab67616d0000b273f2d2adaa21ad616df6241e7d', 'Wham! Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i698pcipxcvqgy1s3yxb0q84fdn5jnc22t8lf1u7ieamik1jr4','Last Christmas','5w10lytz6nalvff','POP','2FRnf9qhLbvw8fu4IBXx78','https://p.scdn.co/mp3-preview/5c6b42e86dba5ec9e8346a345b3a8822b2396d3f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d4woy3us3eohptyrmyi6a9nclisvn9m7rm0khfnhrfxhk2srk6', 'i698pcipxcvqgy1s3yxb0q84fdn5jnc22t8lf1u7ieamik1jr4', '0');
-- XXXTENTACION
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hqckmizaxokszp7', 'XXXTENTACION', '109@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf0c20db5ef6c6fbe5135d2e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:109@artist.com', 'hqckmizaxokszp7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hqckmizaxokszp7', 'A maestro of melodies, orchestrating auditory bliss.', 'XXXTENTACION');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1ye5nk4ntrhuh15112qnualk7pi0pt8bms0w1u9hvb25d7rq97','hqckmizaxokszp7', 'https://i.scdn.co/image/ab67616d0000b273203c89bd4391468eea4cc3f5', 'XXXTENTACION Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('14c40t76ight70gt87mg7eyx6qn4137s9owfuknf06v134kz2a','Revenge','hqckmizaxokszp7','POP','5TXDeTFVRVY7Cvt0Dw4vWW','https://p.scdn.co/mp3-preview/8f5fe8bb510463b2da20325c8600200bf2984d83?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1ye5nk4ntrhuh15112qnualk7pi0pt8bms0w1u9hvb25d7rq97', '14c40t76ight70gt87mg7eyx6qn4137s9owfuknf06v134kz2a', '0');
-- Junior H
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jjtapjdfmv9aqpa', 'Junior H', '110@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:110@artist.com', 'jjtapjdfmv9aqpa', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jjtapjdfmv9aqpa', 'A fresh voice in regional Mexican music, blending tradition with modernity.', 'Junior H');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mrxc8gsl8h4b8p3n23nmdt6jfxignmiu6zl0w6ex3ar9qsw56f','jjtapjdfmv9aqpa', 'https://i.scdn.co/image/ab67616d0000b27333ed356efed99b158c4267c6', 'Junior H Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7a2d0kt44fl0rh74dnz7d39y267mu3v3wk2wio2cjncjbgr7sn','El Azul','jjtapjdfmv9aqpa','POP','1haJsMtoBhHfvuM7XWuT3W','https://p.scdn.co/mp3-preview/f9df136c3a2d3c0c5424e2c4b75a303f35c08af5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrxc8gsl8h4b8p3n23nmdt6jfxignmiu6zl0w6ex3ar9qsw56f', '7a2d0kt44fl0rh74dnz7d39y267mu3v3wk2wio2cjncjbgr7sn', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5wm9dsmfvcagzg9xbp3cmrpfhefudzx8ivmfuj5h8gxdake5ej','LUNA','jjtapjdfmv9aqpa','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrxc8gsl8h4b8p3n23nmdt6jfxignmiu6zl0w6ex3ar9qsw56f', '5wm9dsmfvcagzg9xbp3cmrpfhefudzx8ivmfuj5h8gxdake5ej', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lcse0mm7k6zt7qdzszism5w4ff2fki7yepof6ovqf90ccke2z8','Abcdario','jjtapjdfmv9aqpa','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrxc8gsl8h4b8p3n23nmdt6jfxignmiu6zl0w6ex3ar9qsw56f', 'lcse0mm7k6zt7qdzszism5w4ff2fki7yepof6ovqf90ccke2z8', '2');
-- Skrillex
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('svgwnlajph4shla', 'Skrillex', '111@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb61f92702ca14484aa263a931','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:111@artist.com', 'svgwnlajph4shla', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('svgwnlajph4shla', 'The architect of aural landscapes that inspire and captivate.', 'Skrillex');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('575ojkzlvbxspfrnjt0eoxvleelnbf8teeltp9qls9midulovs','svgwnlajph4shla', 'https://i.scdn.co/image/ab67616d0000b273352f154c54727bc8024629bc', 'Skrillex Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4s027zvfuj7xiirwkmvg3vlk0ej9rfu427ew46m4hkgsz3dg4d','Rumble','svgwnlajph4shla','POP','1GfBLbAhZUWdseuDqhocmn','https://p.scdn.co/mp3-preview/eb79af9f809883de0632f02388ec354478612754?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('575ojkzlvbxspfrnjt0eoxvleelnbf8teeltp9qls9midulovs', '4s027zvfuj7xiirwkmvg3vlk0ej9rfu427ew46m4hkgsz3dg4d', '0');
-- Doja Cat
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2864y8uoqk6va3g', 'Doja Cat', '112@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7f6d6cac38d494e87692af99','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:112@artist.com', '2864y8uoqk6va3g', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2864y8uoqk6va3g', 'A visionary in the world of music, redefining genres.', 'Doja Cat');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7ky7dn3wqwqp4xi2pmljvm3mzccbstcz1r653c8ul17eomhsbq','2864y8uoqk6va3g', 'https://i.scdn.co/image/ab67616d0000b273be841ba4bc24340152e3a79a', 'Doja Cat Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8ys7czjo8gv1eeylzmifdha689zd4t5rvwrwv6fb4iredtc253','Woman','2864y8uoqk6va3g','POP','6Uj1ctrBOjOas8xZXGqKk4','https://p.scdn.co/mp3-preview/2ae0b61e45d9a5d6454a3e5ab75f8628dd89aa85?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7ky7dn3wqwqp4xi2pmljvm3mzccbstcz1r653c8ul17eomhsbq', '8ys7czjo8gv1eeylzmifdha689zd4t5rvwrwv6fb4iredtc253', '0');
-- El Chachito
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zx96suga7hawo6g', 'El Chachito', '113@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5ccab5d3dc10a08d89cbd76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:113@artist.com', 'zx96suga7hawo6g', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zx96suga7hawo6g', 'Creating a tapestry of tunes that celebrates diversity.', 'El Chachito');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zlc3mf0jgbnq4x416ed9dsjjbrelji5os3zqtmc349seofcjyz','zx96suga7hawo6g', 'https://i.scdn.co/image/ab67616d0000b27354c372ef8e7b53bb3c932ac5', 'El Chachito Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('csahcs6zsq0l1l6vtnzwwfnk4qbwuyyenzvh7v5sgbbyta6k4b','En Paris','zx96suga7hawo6g','POP','1Fuc3pBiPFxAeSJoO8tDh5','https://p.scdn.co/mp3-preview/c57f1229ca237b01f9dbd839bc3ca97f22395a87?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zlc3mf0jgbnq4x416ed9dsjjbrelji5os3zqtmc349seofcjyz', 'csahcs6zsq0l1l6vtnzwwfnk4qbwuyyenzvh7v5sgbbyta6k4b', '0');
-- The Neighbourhood
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uvzjafd6j377afj', 'The Neighbourhood', '114@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf0b5ac84376a0a4b2166816','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:114@artist.com', 'uvzjafd6j377afj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uvzjafd6j377afj', 'Melding alternative rock with introspective lyrics.', 'The Neighbourhood');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('iwemprloibo8x48s4bmymtl8phdnn8l09cdkmr8e8akzx0ptzg','uvzjafd6j377afj', 'https://i.scdn.co/image/ab67616d0000b2738265a736a1eb838ad5a0b921', 'The Neighbourhood Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9o5kclx1d1a4ab905x40owle4ith1hie2m51iikl5fpco0w4l5','Sweater Weather','uvzjafd6j377afj','POP','2QjOHCTQ1Jl3zawyYOpxh6','https://p.scdn.co/mp3-preview/877602f424a9dea277b13301ffc516f9fd1fbe7e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('iwemprloibo8x48s4bmymtl8phdnn8l09cdkmr8e8akzx0ptzg', '9o5kclx1d1a4ab905x40owle4ith1hie2m51iikl5fpco0w4l5', '0');
-- Mac DeMarco
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wb80bjp8giu8mfs', 'Mac DeMarco', '115@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3cef7752073cbbd2cc04c6f0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:115@artist.com', 'wb80bjp8giu8mfs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wb80bjp8giu8mfs', 'An endless quest for musical perfection.', 'Mac DeMarco');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vssg192y1gr3zibmu0v2ct0tbhcswwfppzat4x6lpum7n66m9g','wb80bjp8giu8mfs', 'https://i.scdn.co/image/ab67616d0000b273fa1323bb50728c7489980672', 'Mac DeMarco Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tew2vsip9yw70pzbv3g1rbjl50leservxrxix4tf43jd991b8m','Heart To Heart','wb80bjp8giu8mfs','POP','7EAMXbLcL0qXmciM5SwMh2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vssg192y1gr3zibmu0v2ct0tbhcswwfppzat4x6lpum7n66m9g', 'tew2vsip9yw70pzbv3g1rbjl50leservxrxix4tf43jd991b8m', '0');
-- The Weeknd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q0aqkbam9mb0yps', 'The Weeknd', '116@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:116@artist.com', 'q0aqkbam9mb0yps', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q0aqkbam9mb0yps', 'A trailblazer in the world of R&B, constantly redefining the genre.', 'The Weeknd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren','q0aqkbam9mb0yps', NULL, 'The Weeknd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nmsym524uk6k8xfqjcrghj3parg3sxclr21q2q120g55to3470','Popular (with Playboi Carti & Madonna) - The Idol Vol. 1 (Music from the HBO Original Series)','q0aqkbam9mb0yps','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren', 'nmsym524uk6k8xfqjcrghj3parg3sxclr21q2q120g55to3470', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ltarddzqvdyxjyfigwkdls5ymzsxh7681o2t69g1y77pd8k3g6','Creepin','q0aqkbam9mb0yps','POP','1zOf6IuM8HgaB4Jo6I8D11','https://p.scdn.co/mp3-preview/185d0909b7f2086f4cdd0af4b166df5676542343?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren', 'ltarddzqvdyxjyfigwkdls5ymzsxh7681o2t69g1y77pd8k3g6', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j6yuzi67b9st5pbopfcdqxgiw63v5euk5il58u3yi3xyb8glpp','Die For You','q0aqkbam9mb0yps','POP','2LBqCSwhJGcFQeTHMVGwy3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren', 'j6yuzi67b9st5pbopfcdqxgiw63v5euk5il58u3yi3xyb8glpp', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gd70guz94jkvln1k9qhg1d9ifqcfvdn0nc5v38woyro4ilil5d','Starboy','q0aqkbam9mb0yps','POP','7MXVkk9YMctZqd1Srtv4MB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren', 'gd70guz94jkvln1k9qhg1d9ifqcfvdn0nc5v38woyro4ilil5d', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n41u81698x22iowemyxcqqkkbw89cgkbznn7w1hzzx6shtzggf','Blinding Lights','q0aqkbam9mb0yps','POP','0VjIjW4GlUZAMYd2vXMi3b',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren', 'n41u81698x22iowemyxcqqkkbw89cgkbznn7w1hzzx6shtzggf', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('co2pw8rmmw8o0428h3zjt7yfaesy6jfv975cqegwm81bxfz125','Stargirl Interlude','q0aqkbam9mb0yps','POP','5gDWsRxpJ2lZAffh5p7K0w',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren', 'co2pw8rmmw8o0428h3zjt7yfaesy6jfv975cqegwm81bxfz125', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ccfi9350a9mb0m7ho23hqwoe3vsllcuv9dzcgdx1ebliadz018','Save Your Tears','q0aqkbam9mb0yps','POP','5QO79kh1waicV47BqGRL3g',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren', 'ccfi9350a9mb0m7ho23hqwoe3vsllcuv9dzcgdx1ebliadz018', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m36vo5bbj2sivhw2sr8sf7optbayie5fumupaoyjpfctkha5zk','Reminder','q0aqkbam9mb0yps','POP','37F0uwRSrdzkBiuj0D5UHI',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren', 'm36vo5bbj2sivhw2sr8sf7optbayie5fumupaoyjpfctkha5zk', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tqsxq1y8bqpux513z0pjipspfby80j179oxqsrfoq8ybfzdqkr','Double Fantasy (with Future)','q0aqkbam9mb0yps','POP','4VMRsbfZzd3SfQtaJ1Wpwi',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren', 'tqsxq1y8bqpux513z0pjipspfby80j179oxqsrfoq8ybfzdqkr', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tci4vytt8lm16h48g2nz168lw9k42cs5vhhateszdf02etafaq','I Was Never There','q0aqkbam9mb0yps','POP','1cKHdTo9u0ZymJdPGSh6nq',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren', 'tci4vytt8lm16h48g2nz168lw9k42cs5vhhateszdf02etafaq', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f9oltyyggf3cgd1kfelwlwjppndokl2c3xzdavrwnw0i8xmmsc','Call Out My Name','q0aqkbam9mb0yps','POP','09mEdoA6zrmBPgTEN5qXmN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren', 'f9oltyyggf3cgd1kfelwlwjppndokl2c3xzdavrwnw0i8xmmsc', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r8mqfpgxcc0e4vqvdzqzbw6ic703mxi6528w9i69zohlpgdo9p','The Hills','q0aqkbam9mb0yps','POP','7fBv7CLKzipRk6EC6TWHOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren', 'r8mqfpgxcc0e4vqvdzqzbw6ic703mxi6528w9i69zohlpgdo9p', '11');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9x3e3xexl8l4dd5h1zzs5fdicear5xzpn7o7ambphslk29m7d7','After Hours','q0aqkbam9mb0yps','POP','2p8IUWQDrpjuFltbdgLOag',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0vicpyqtec9p7yb27eoc40t3rhpsx3gktqyppjtog0zjn9dren', '9x3e3xexl8l4dd5h1zzs5fdicear5xzpn7o7ambphslk29m7d7', '12');
-- Nicky Jam
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zdxempszp12m1h1', 'Nicky Jam', '117@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb02bec146cac39466d3f8ee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:117@artist.com', 'zdxempszp12m1h1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zdxempszp12m1h1', 'Sculpting soundwaves into masterpieces of auditory art.', 'Nicky Jam');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('thgl5pawa0vybfpe7vk8uug9bwisbmqn2k416hfe4dk8c8pggq','zdxempszp12m1h1', 'https://i.scdn.co/image/ab67616d0000b273ea97d86f1fa8532cd8c75188', 'Nicky Jam Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g7gasnfva15eq8ngsh46j2ce37w9lnk8am3q2vkpukywnztlp2','69','zdxempszp12m1h1','POP','13Z5Q40pa1Ly7aQk1oW8Ce','https://p.scdn.co/mp3-preview/966457479d8cd723838150ddd1f3010f4383994d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('thgl5pawa0vybfpe7vk8uug9bwisbmqn2k416hfe4dk8c8pggq', 'g7gasnfva15eq8ngsh46j2ce37w9lnk8am3q2vkpukywnztlp2', '0');
-- Michael Bubl
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z3ergjg6r5ujudz', 'Michael Bubl', '118@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebef8cf61fea4923d2bde68200','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:118@artist.com', 'z3ergjg6r5ujudz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z3ergjg6r5ujudz', 'Music is my canvas, and notes are my paint.', 'Michael Bubl');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rzu6wtnzmq0jcpi3kb6rpyw4cw7nmz900v1wfchdcbyaaqqblk','z3ergjg6r5ujudz', 'https://i.scdn.co/image/ab67616d0000b273119e4094f07a8123b471ac1d', 'Michael Bubl Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dd5wmop7x2i8irujdzv8koxoto4f424w763f84qy6skuszn7gn','Its Beginning To Look A Lot Like Christmas','z3ergjg6r5ujudz','POP','5a1iz510sv2W9Dt1MvFd5R','https://p.scdn.co/mp3-preview/51f36d7e04069ef4869ea575fb21e5404710b1c4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rzu6wtnzmq0jcpi3kb6rpyw4cw7nmz900v1wfchdcbyaaqqblk', 'dd5wmop7x2i8irujdzv8koxoto4f424w763f84qy6skuszn7gn', '0');
-- Fifty Fifty
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lci4bkxoln7zc39', 'Fifty Fifty', '119@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5a60b0f886b5deb8518e4a41','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:119@artist.com', 'lci4bkxoln7zc39', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lci4bkxoln7zc39', 'Blending a rich array of genres to create a unique musical experience.', 'Fifty Fifty');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('17mdo9utzigmu0z58ac4zoc8anxhrozll07asnjky1d8xfqnzd','lci4bkxoln7zc39', 'https://i.scdn.co/image/ab67616d0000b27337c0b3670236c067c8e8bbcb', 'Fifty Fifty Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qb9pd613vsurakqpb8dkqsy97vo5ezftgp66ht2y3w229ya52s','Cupid - Twin Ver.','lci4bkxoln7zc39','POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('17mdo9utzigmu0z58ac4zoc8anxhrozll07asnjky1d8xfqnzd', 'qb9pd613vsurakqpb8dkqsy97vo5ezftgp66ht2y3w229ya52s', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rekbhxoc0a6pm4izwz350a9ofu1hhma7jcrjslapmnenticag6','Cupid','lci4bkxoln7zc39','POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('17mdo9utzigmu0z58ac4zoc8anxhrozll07asnjky1d8xfqnzd', 'rekbhxoc0a6pm4izwz350a9ofu1hhma7jcrjslapmnenticag6', '1');
-- Mariah Carey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ql79h3tcfqpx4h7', 'Mariah Carey', '120@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21b66418f7f3b86967f85bce','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:120@artist.com', 'ql79h3tcfqpx4h7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ql79h3tcfqpx4h7', 'A sonic adventurer, always seeking new horizons in music.', 'Mariah Carey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0fcyp1wruvfrjiavdj1s8ue5u5mnq274f8gyftd701mgofrwxc','ql79h3tcfqpx4h7', 'https://i.scdn.co/image/ab67616d0000b2734246e3158421f5abb75abc4f', 'Mariah Carey Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hd5zx7ft1w58u2xxsejmakzefdqn300nxy99air2ez0egdfs2e','All I Want for Christmas Is You','ql79h3tcfqpx4h7','POP','0bYg9bo50gSsH3LtXe2SQn','https://p.scdn.co/mp3-preview/6b1557cd25d543940a3decd85a7bf2bc136c51f8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0fcyp1wruvfrjiavdj1s8ue5u5mnq274f8gyftd701mgofrwxc', 'hd5zx7ft1w58u2xxsejmakzefdqn300nxy99air2ez0egdfs2e', '0');
-- Abhijay Sharma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f9po1yhpg0xhnt3', 'Abhijay Sharma', '121@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf58e0bff09fc766a22cd3bdb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:121@artist.com', 'f9po1yhpg0xhnt3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('f9po1yhpg0xhnt3', 'A harmonious blend of passion and creativity.', 'Abhijay Sharma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dc3vhuflpnj063bvdt69rgsjaf7l6c8d228gt0fht64nvllc6s','f9po1yhpg0xhnt3', NULL, 'Abhijay Sharma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k0e8cnq6gifmbljrcnzkwd51plwooouzkcvagrs754a6ft0i76','Obsessed','f9po1yhpg0xhnt3','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dc3vhuflpnj063bvdt69rgsjaf7l6c8d228gt0fht64nvllc6s', 'k0e8cnq6gifmbljrcnzkwd51plwooouzkcvagrs754a6ft0i76', '0');
-- sped up nightcore
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ubdekcbdaqey25o', 'sped up nightcore', '122@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebbf73929f8c684fed7af7e767','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:122@artist.com', 'ubdekcbdaqey25o', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ubdekcbdaqey25o', 'Crafting soundscapes that transport listeners to another world.', 'sped up nightcore');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9vcafq3n4p2pgvtt0gylw8ie8wbyjz5aspg6ug4na280jgnjs5','ubdekcbdaqey25o', NULL, 'sped up nightcore Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m904w4da5ldnke0bj3tbvum2swjyr4uwidevds19addajptf9d','Watch This - ARIZONATEARS Pluggnb Remix','ubdekcbdaqey25o','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9vcafq3n4p2pgvtt0gylw8ie8wbyjz5aspg6ug4na280jgnjs5', 'm904w4da5ldnke0bj3tbvum2swjyr4uwidevds19addajptf9d', '0');
-- Sachin-Jigar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jkxt5mhj3uhruif', 'Sachin-Jigar', '123@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba038d7d87f8577bbb9686bd3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:123@artist.com', 'jkxt5mhj3uhruif', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jkxt5mhj3uhruif', 'A tapestry of rhythms that echo the pulse of life.', 'Sachin-Jigar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hd50jkfawcdkrvw8n03y9qxq4k1af1srx3eoq97kjhwyeoz9pw','jkxt5mhj3uhruif', NULL, 'Sachin-Jigar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('11edw8dcwst48wetouxuf0dw4nk9unrhzacl27zmqcgoebwm51','Tere Vaaste (From "Zara Hatke Zara Bachke")','jkxt5mhj3uhruif','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hd50jkfawcdkrvw8n03y9qxq4k1af1srx3eoq97kjhwyeoz9pw', '11edw8dcwst48wetouxuf0dw4nk9unrhzacl27zmqcgoebwm51', '0');
-- Rma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8deod1lmvd93qq6', 'Rma', '124@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3b8f6208d84e28f63841e43c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:124@artist.com', '8deod1lmvd93qq6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8deod1lmvd93qq6', 'Pioneering new sounds and delivering electrifying performances.', 'Rma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('z8e65vgpkdb01ce3ktncyo568vejgq0efz6k7hecb200v54g0k','8deod1lmvd93qq6', NULL, 'Rma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vp0f6kw8vaa6f0dc5skdiu18zcn88qu4lowaor79td4mryoc7p','Calm Down (with Selena Gomez)','8deod1lmvd93qq6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z8e65vgpkdb01ce3ktncyo568vejgq0efz6k7hecb200v54g0k', 'vp0f6kw8vaa6f0dc5skdiu18zcn88qu4lowaor79td4mryoc7p', '0');
-- BLACKPINK
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qjr7oqzkamrgfq7', 'BLACKPINK', '125@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc9690bc711d04b3d4fd4b87c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:125@artist.com', 'qjr7oqzkamrgfq7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qjr7oqzkamrgfq7', 'A journey through the spectrum of sound in every album.', 'BLACKPINK');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8p5rnuxzthl1ro369wn7s07rdalgzlugfk1e4q90abz3xc2hfv','qjr7oqzkamrgfq7', 'https://i.scdn.co/image/ab67616d0000b273002ef53878df1b4e91c15406', 'BLACKPINK Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c861wptj254uztuplphqmhtd5w6ufm5aby6h265eqjrddvyb17','Shut Down','qjr7oqzkamrgfq7','POP','7gRFDGEzF9UkBV233yv2dc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8p5rnuxzthl1ro369wn7s07rdalgzlugfk1e4q90abz3xc2hfv', 'c861wptj254uztuplphqmhtd5w6ufm5aby6h265eqjrddvyb17', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gx5yogjl910dn6kx8gv94zgxyr5ngxekzz29g2e8qjux9u2dvk','Pink Venom','qjr7oqzkamrgfq7','POP','5zwwW9Oq7ubSxoCGyW1nbY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8p5rnuxzthl1ro369wn7s07rdalgzlugfk1e4q90abz3xc2hfv', 'gx5yogjl910dn6kx8gv94zgxyr5ngxekzz29g2e8qjux9u2dvk', '1');
-- Swae Lee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q6f0rgxv9tn91cb', 'Swae Lee', '126@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:126@artist.com', 'q6f0rgxv9tn91cb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q6f0rgxv9tn91cb', 'A harmonious blend of passion and creativity.', 'Swae Lee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('piqlf44knu594w24l07nyk9mg8fvdaqnx4ndl4rlspnjskbrap','q6f0rgxv9tn91cb', NULL, 'Swae Lee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5mh84w8dh72nphaqgwk6ns38czwuq58fpfkouueqs8bg9tvuw9','Calling (Spider-Man: Across the Spider-Verse) (Metro Boomin & Swae Lee, NAV, feat. A Boogie Wit da Hoodie)','q6f0rgxv9tn91cb','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('piqlf44knu594w24l07nyk9mg8fvdaqnx4ndl4rlspnjskbrap', '5mh84w8dh72nphaqgwk6ns38czwuq58fpfkouueqs8bg9tvuw9', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('je1xauijfgfyyeekp6hb1jhxfpqm6en2pvyop05se4i4ajmf1t','Annihilate (Spider-Man: Across the Spider-Verse) (Metro Boomin & Swae Lee, Lil Wayne, Offset)','q6f0rgxv9tn91cb','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('piqlf44knu594w24l07nyk9mg8fvdaqnx4ndl4rlspnjskbrap', 'je1xauijfgfyyeekp6hb1jhxfpqm6en2pvyop05se4i4ajmf1t', '1');
-- Doechii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h93mkoy03m1sgm2', 'Doechii', '127@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5f9f729e1e5182fbf1030dbe','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:127@artist.com', 'h93mkoy03m1sgm2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h93mkoy03m1sgm2', 'Breaking barriers with her unique sound and powerful lyrical storytelling.', 'Doechii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xzkspq5oaeyx0ev8d2almeramuhl8gta3756ktmbtg86zl0699','h93mkoy03m1sgm2', 'https://i.scdn.co/image/ab67616d0000b2732ee85751f6f503fa9a533eba', 'Doechii Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6t0iyxfzgbhzbm7gpectlibq1e7icrry63eup7y3av1bv5c9zp','What It Is (Solo Version)','h93mkoy03m1sgm2','POP','73RbfOTJIjHzi2pcVHjeHM',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xzkspq5oaeyx0ev8d2almeramuhl8gta3756ktmbtg86zl0699', '6t0iyxfzgbhzbm7gpectlibq1e7icrry63eup7y3av1bv5c9zp', '0');
-- Morgan Wallen
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wj5hh90k8ucfg4z', 'Morgan Wallen', '128@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21ed0100a3a4e5aa3c57f6dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:128@artist.com', 'wj5hh90k8ucfg4z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wj5hh90k8ucfg4z', 'Blending country charm with rock energy to create memorable tunes.', 'Morgan Wallen');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ren9oy5nqp3wurcjw414qtpqjj1d9swnj61euaakmq6rzmkw8c','wj5hh90k8ucfg4z', 'https://i.scdn.co/image/ab67616d0000b273705079df9a25a28b452c1fc9', 'Morgan Wallen Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pb1mby9uyinge05ic1npdub0fx0lhactlyvfxe0ojpy8f0fsgn','Last Night','wj5hh90k8ucfg4z','POP','7K3BhSpAxZBznislvUMVtn',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ren9oy5nqp3wurcjw414qtpqjj1d9swnj61euaakmq6rzmkw8c', 'pb1mby9uyinge05ic1npdub0fx0lhactlyvfxe0ojpy8f0fsgn', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nxt83i27ua697waob5x7bj5owy2ihcfj920xl3at4xnkxaabnp','You Proof','wj5hh90k8ucfg4z','POP','5W4kiM2cUYBJXKRudNyxjW',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ren9oy5nqp3wurcjw414qtpqjj1d9swnj61euaakmq6rzmkw8c', 'nxt83i27ua697waob5x7bj5owy2ihcfj920xl3at4xnkxaabnp', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4wlfq182hj0ch9fhwymm8ec5jrlqikb0x5elck09f0xd85pg0z','One Thing At A Time','wj5hh90k8ucfg4z','POP','1rXq0uoV4KTgRN64jXzIxo',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ren9oy5nqp3wurcjw414qtpqjj1d9swnj61euaakmq6rzmkw8c', '4wlfq182hj0ch9fhwymm8ec5jrlqikb0x5elck09f0xd85pg0z', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xn7oyxcnjkl0dkm1d8qaysrvhrobwt7n33v1im81mlh8y062nm','Aint Tha','wj5hh90k8ucfg4z','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ren9oy5nqp3wurcjw414qtpqjj1d9swnj61euaakmq6rzmkw8c', 'xn7oyxcnjkl0dkm1d8qaysrvhrobwt7n33v1im81mlh8y062nm', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p09rvm9wamckwkgo69zcpqtb41mw5vpfpciezggraazhifjjf5','Thinkin B','wj5hh90k8ucfg4z','POP','0PAcdVzhPO4gq1Iym9ESnK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ren9oy5nqp3wurcjw414qtpqjj1d9swnj61euaakmq6rzmkw8c', 'p09rvm9wamckwkgo69zcpqtb41mw5vpfpciezggraazhifjjf5', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lj5web5ugaxsiwnstjbxt06odj85fz5udzdjybynmmfhsi90uj','Everything I Love','wj5hh90k8ucfg4z','POP','03fs6oV5JAlbytRYf3371S',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ren9oy5nqp3wurcjw414qtpqjj1d9swnj61euaakmq6rzmkw8c', 'lj5web5ugaxsiwnstjbxt06odj85fz5udzdjybynmmfhsi90uj', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dqgc5ny35vl1ereq3wekkhztpl60pjnw846cic4it869sedrsz','I Wrote The Book','wj5hh90k8ucfg4z','POP','7phmBo7bB9I9YifAXqnlqV',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ren9oy5nqp3wurcjw414qtpqjj1d9swnj61euaakmq6rzmkw8c', 'dqgc5ny35vl1ereq3wekkhztpl60pjnw846cic4it869sedrsz', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ide1cfrifaak96raeo07m2of0ps9mdzzd6ctqnfo3nmrrvj4oc','Man Made A Bar (feat. Eric Church)','wj5hh90k8ucfg4z','POP','73zawW1ttszLRgT9By826D',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ren9oy5nqp3wurcjw414qtpqjj1d9swnj61euaakmq6rzmkw8c', 'ide1cfrifaak96raeo07m2of0ps9mdzzd6ctqnfo3nmrrvj4oc', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8nsl3c9oj35sbng7v13wh81tbkksyijxjfxd3islny4vu7188h','98 Braves','wj5hh90k8ucfg4z','POP','3oZ6dlSfCE9gZ55MGPJctc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ren9oy5nqp3wurcjw414qtpqjj1d9swnj61euaakmq6rzmkw8c', '8nsl3c9oj35sbng7v13wh81tbkksyijxjfxd3islny4vu7188h', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p2oc083zreodxqaj1ie0pnk0k7rtb3tenofh4kuc519yraawep','Thought You Should Know','wj5hh90k8ucfg4z','POP','3Qu3Zh4WTKhP9GEXo0aDnb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ren9oy5nqp3wurcjw414qtpqjj1d9swnj61euaakmq6rzmkw8c', 'p2oc083zreodxqaj1ie0pnk0k7rtb3tenofh4kuc519yraawep', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c4tjadm6qozq6psxp5xvm45mo6844ckp91u276hngp8y3zfcjn','Born With A Beer In My Hand','wj5hh90k8ucfg4z','POP','1BAU6v0fuAV914qMUEESR1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ren9oy5nqp3wurcjw414qtpqjj1d9swnj61euaakmq6rzmkw8c', 'c4tjadm6qozq6psxp5xvm45mo6844ckp91u276hngp8y3zfcjn', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('blpy4v6hr1144hn2v5wrtgqf7wd92vtmp3hqlgc85dxk1w0v1o','Devil Don','wj5hh90k8ucfg4z','POP','2PsbT927UanvyH9VprlNOu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ren9oy5nqp3wurcjw414qtpqjj1d9swnj61euaakmq6rzmkw8c', 'blpy4v6hr1144hn2v5wrtgqf7wd92vtmp3hqlgc85dxk1w0v1o', '11');
-- Labrinth
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ykeeyfrzac1vvgc', 'Labrinth', '129@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7885d725841e0338092f5f6f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:129@artist.com', 'ykeeyfrzac1vvgc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ykeeyfrzac1vvgc', 'Crafting a unique sonic identity in every track.', 'Labrinth');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zz78zrs9uv3jqmylgq7edqzwm42xrphouurd7x8wd7rifq60nl','ykeeyfrzac1vvgc', 'https://i.scdn.co/image/ab67616d0000b2731df535f5089e544a3cc86069', 'Labrinth Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ei5a1so4126vbvjcif2hbtgqwcvc9i0qmkryj7cvz975w8qkjs','Never Felt So Alone','ykeeyfrzac1vvgc','POP','6unndO70DvZfnXYcYQMyQJ','https://p.scdn.co/mp3-preview/d33db796d822aa77728af0f4abb06ccd596d2920?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zz78zrs9uv3jqmylgq7edqzwm42xrphouurd7x8wd7rifq60nl', 'ei5a1so4126vbvjcif2hbtgqwcvc9i0qmkryj7cvz975w8qkjs', '0');
-- Veigh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xtuqj2dl2tbif6n', 'Veigh', '130@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfe49a8f4b6b1a82a29f43112','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:130@artist.com', 'xtuqj2dl2tbif6n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xtuqj2dl2tbif6n', 'Delivering soul-stirring tunes that linger in the mind.', 'Veigh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lhp5qjj6ec5515d7w7oefz4do54whlw5kcy94begq3h4xvy0lc','xtuqj2dl2tbif6n', 'https://i.scdn.co/image/ab67616d0000b273ce0947b85c30490447dbbd91', 'Veigh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ggnw80hhirgz8cneavp5e27x62u5ybjk02vbgcrjhlvif7klbe','Novo Balan','xtuqj2dl2tbif6n','POP','4hKLzFvNwHF6dPosGT30ed','https://p.scdn.co/mp3-preview/af031ca41aac7b60676833187f323d94fc387bce?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lhp5qjj6ec5515d7w7oefz4do54whlw5kcy94begq3h4xvy0lc', 'ggnw80hhirgz8cneavp5e27x62u5ybjk02vbgcrjhlvif7klbe', '0');
-- IU
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('it8roshqqplc82j', 'IU', '131@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb006ff3c0136a71bfb9928d34','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:131@artist.com', 'it8roshqqplc82j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('it8roshqqplc82j', 'Where words fail, my music speaks.', 'IU');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nnbj5rclfwxg5svdhtleeituyx6dwhz7c6bdwg05xwb9fp8w3r','it8roshqqplc82j', NULL, 'IU Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fvsunnwdlq3u5p6rqsa9toja9ow0701mqkw6g7mizdw1fothe1','People Pt.2 (feat. IU)','it8roshqqplc82j','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nnbj5rclfwxg5svdhtleeituyx6dwhz7c6bdwg05xwb9fp8w3r', 'fvsunnwdlq3u5p6rqsa9toja9ow0701mqkw6g7mizdw1fothe1', '0');
-- Future
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('99wnbdntdllc0mj', 'Future', '132@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:132@artist.com', '99wnbdntdllc0mj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('99wnbdntdllc0mj', 'Exploring the depths of sound and rhythm.', 'Future');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('itzmzukazsrso79wwx87gxngq4samjs2xay9fzi0mdau9vxxnk','99wnbdntdllc0mj', NULL, 'Future Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5i1d9aqml06l2hk3nc7mgysa3ob96sft8ysj437nrewi7czigu','Too Many Nights (feat. Don Toliver & with Future)','99wnbdntdllc0mj','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('itzmzukazsrso79wwx87gxngq4samjs2xay9fzi0mdau9vxxnk', '5i1d9aqml06l2hk3nc7mgysa3ob96sft8ysj437nrewi7czigu', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z9izqkhvuo3t5yxo185pqmbmced5gx0etprjra3ysgl8q0t6al','All The Way Live (Spider-Man: Across the Spider-Verse) (Metro Boomin & Future, Lil Uzi Vert)','99wnbdntdllc0mj','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('itzmzukazsrso79wwx87gxngq4samjs2xay9fzi0mdau9vxxnk', 'z9izqkhvuo3t5yxo185pqmbmced5gx0etprjra3ysgl8q0t6al', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4uq38ljh5zosn8z8un7o3vzqzfta5f76nogtcas1vixpbtu4g3','Superhero (Heroes & Villains) [with Future & Chris Brown]','99wnbdntdllc0mj','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('itzmzukazsrso79wwx87gxngq4samjs2xay9fzi0mdau9vxxnk', '4uq38ljh5zosn8z8un7o3vzqzfta5f76nogtcas1vixpbtu4g3', '2');
-- Coldplay
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jqeddmsamv5vzmm', 'Coldplay', '133@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb989ed05e1f0570cc4726c2d3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:133@artist.com', 'jqeddmsamv5vzmm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jqeddmsamv5vzmm', 'Global icons in rock, known for their anthemic songs and impactful lyrics.', 'Coldplay');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('435lpe91aeprzjyormhtpk1qrbblr4e52wdb7vhu9sh03hxn72','jqeddmsamv5vzmm', 'https://i.scdn.co/image/ab67616d0000b273e21cc1db05580b6f2d2a3b6e', 'Coldplay Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m11ced2h94fqa66u5cd4zo3tan40s1hi9cxbx7cxp8w012f7vm','Viva La Vida','jqeddmsamv5vzmm','POP','1mea3bSkSGXuIRvnydlB5b','https://p.scdn.co/mp3-preview/fb9f4a9b0887326776b4fb7c6d331acd167a7778?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('435lpe91aeprzjyormhtpk1qrbblr4e52wdb7vhu9sh03hxn72', 'm11ced2h94fqa66u5cd4zo3tan40s1hi9cxbx7cxp8w012f7vm', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f33qjk0g48umnuxwwdgu7ax8suzmstbintib6pwv7i157mjuem','My Universe','jqeddmsamv5vzmm','POP','3FeVmId7tL5YN8B7R3imoM','https://p.scdn.co/mp3-preview/e6b780d0df7927114477a786b6a638cf40d19579?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('435lpe91aeprzjyormhtpk1qrbblr4e52wdb7vhu9sh03hxn72', 'f33qjk0g48umnuxwwdgu7ax8suzmstbintib6pwv7i157mjuem', '1');
-- Eminem
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3yfhv32utwgn9xn', 'Eminem', '134@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba00b11c129b27a88fc72f36b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:134@artist.com', '3yfhv32utwgn9xn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3yfhv32utwgn9xn', 'Exploring the depths of sound and rhythm.', 'Eminem');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tg4rslpy4p0adr3eojrqiipioe7eq6vu59y73zyq5gxz3cr44f','3yfhv32utwgn9xn', 'https://i.scdn.co/image/ab67616d0000b273726d48d93d02e1271774f023', 'Eminem Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hgd91qb34bwh64t622ocxtupikeu60o35w7ne2q9hcn6w5qhzn','Mockingbird','3yfhv32utwgn9xn','POP','561jH07mF1jHuk7KlaeF0s',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tg4rslpy4p0adr3eojrqiipioe7eq6vu59y73zyq5gxz3cr44f', 'hgd91qb34bwh64t622ocxtupikeu60o35w7ne2q9hcn6w5qhzn', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tbey4tiujgb89ad0f4lknlhhxs8um8fo8lci2xbdcub9h66vuf','Without Me','3yfhv32utwgn9xn','POP','7lQ8MOhq6IN2w8EYcFNSUk',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tg4rslpy4p0adr3eojrqiipioe7eq6vu59y73zyq5gxz3cr44f', 'tbey4tiujgb89ad0f4lknlhhxs8um8fo8lci2xbdcub9h66vuf', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gv6yaia4velz4zfbh4sv6jh93qfu5s0qoimcnz64lky5fce9cc','The Real Slim Shady','3yfhv32utwgn9xn','POP','3yfqSUWxFvZELEM4PmlwIR',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tg4rslpy4p0adr3eojrqiipioe7eq6vu59y73zyq5gxz3cr44f', 'gv6yaia4velz4zfbh4sv6jh93qfu5s0qoimcnz64lky5fce9cc', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l4pekt5wyu93l7tt0susqro3vxs2y79xk9igj2f6izysxpa78o','Lose Yourself - Soundtrack Version','3yfhv32utwgn9xn','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tg4rslpy4p0adr3eojrqiipioe7eq6vu59y73zyq5gxz3cr44f', 'l4pekt5wyu93l7tt0susqro3vxs2y79xk9igj2f6izysxpa78o', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w16zpnibwlr9q9cvlkk8507ct2ui8r7e51slyxb59zbij1x75s','Superman','3yfhv32utwgn9xn','POP','4woTEX1wYOTGDqNXuavlRC',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tg4rslpy4p0adr3eojrqiipioe7eq6vu59y73zyq5gxz3cr44f', 'w16zpnibwlr9q9cvlkk8507ct2ui8r7e51slyxb59zbij1x75s', '4');
-- MC Caverinha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sbxjwaj5ma2uqoy', 'MC Caverinha', '135@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb48d62acd2e6408096141a088','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:135@artist.com', 'sbxjwaj5ma2uqoy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sbxjwaj5ma2uqoy', 'Transcending language barriers through the universal language of music.', 'MC Caverinha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kwbty1dksml4yxdgdwxo297lahcfjcgiv21031i639rv62mn31','sbxjwaj5ma2uqoy', NULL, 'MC Caverinha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g63jux2fb0o4l6dloi5neygw9aic6s0h1b5o7i06mbnli72io4','Carto B','sbxjwaj5ma2uqoy','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kwbty1dksml4yxdgdwxo297lahcfjcgiv21031i639rv62mn31', 'g63jux2fb0o4l6dloi5neygw9aic6s0h1b5o7i06mbnli72io4', '0');
-- Ruth B.
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('knf06t6765z7zpo', 'Ruth B.', '136@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1da7ba1c178ab9f68d065197','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:136@artist.com', 'knf06t6765z7zpo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('knf06t6765z7zpo', 'Crafting soundscapes that transport listeners to another world.', 'Ruth B.');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('b3meodoa8ik5y1j42rpn8v4mvbs23um1viuv3wf3jgmfcu34dm','knf06t6765z7zpo', 'https://i.scdn.co/image/ab67616d0000b27397e971f3e53475091dc8d707', 'Ruth B. Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c4p53ckaaiypaazjuh5l2gpvlpmarrybhphptuvhditgis83b1','Dandelions','knf06t6765z7zpo','POP','2eAvDnpXP5W0cVtiI0PUxV','https://p.scdn.co/mp3-preview/3e55602bc286bc1fad9347931327e649ff9adfa1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('b3meodoa8ik5y1j42rpn8v4mvbs23um1viuv3wf3jgmfcu34dm', 'c4p53ckaaiypaazjuh5l2gpvlpmarrybhphptuvhditgis83b1', '0');
-- DJ Escobar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hwqyaa4t8lfqrgb', 'DJ Escobar', '137@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb62fa9c7f56a64dc956ec2621','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:137@artist.com', 'hwqyaa4t8lfqrgb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hwqyaa4t8lfqrgb', 'A unique voice in the contemporary music scene.', 'DJ Escobar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1x51hlrzh0jwnuhbwl93qkku8jnfv81lc0otaq18j0b13vlj5b','hwqyaa4t8lfqrgb', 'https://i.scdn.co/image/ab67616d0000b273769f6572dfa10ee7827edbf2', 'DJ Escobar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('90ji8mi6s12q8045pa4etd800vf7q7k58js7ew9old5rzb8ebd','Evoque Prata','hwqyaa4t8lfqrgb','POP','4mQ2UZzSH3T4o4Gr9phTgL','https://p.scdn.co/mp3-preview/f2c69618853c528447f24f0102d0e5404fe31ed9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1x51hlrzh0jwnuhbwl93qkku8jnfv81lc0otaq18j0b13vlj5b', '90ji8mi6s12q8045pa4etd800vf7q7k58js7ew9old5rzb8ebd', '0');
-- J Balvin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('387b3bl7o32xeb2', 'J Balvin', '138@artist.com', 'https://i.scdn.co/image/ab67616d0000b273498cf6571df9adf37e46b527','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:138@artist.com', '387b3bl7o32xeb2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('387b3bl7o32xeb2', 'Transcending language barriers through the universal language of music.', 'J Balvin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oon41sowlrha9qlqtt0q54aqgdh7213v1zyeuatthgbwxs5nbr','387b3bl7o32xeb2', 'https://i.scdn.co/image/ab67616d0000b2734891d9b25d8919448388f3bb', 'J Balvin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2nxph8llg9prquhlm6rhkzxyz7fy0o7qm8uceeyut6kyphuqwn','LA CANCI','387b3bl7o32xeb2','POP','0fea68AdmYNygeTGI4RC18',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oon41sowlrha9qlqtt0q54aqgdh7213v1zyeuatthgbwxs5nbr', '2nxph8llg9prquhlm6rhkzxyz7fy0o7qm8uceeyut6kyphuqwn', '0');
-- Nengo Flow
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ynjm925sj5uhp0x', 'Nengo Flow', '139@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebda3f48cf2309aacaab0edce2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:139@artist.com', 'ynjm925sj5uhp0x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ynjm925sj5uhp0x', 'Blending traditional rhythms with modern beats.', 'Nengo Flow');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9jgdjedey8fx6bomf93orwtdm5dbmruy5ss5exofen58ghijji','ynjm925sj5uhp0x', 'https://i.scdn.co/image/ab67616d0000b273ed132404686f567c8f793058', 'Nengo Flow Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4j2w5d2yyxlvd5boopkjp53oe5kmrxmf0h34n49y7vkyvblyz6','Gato de Noche','ynjm925sj5uhp0x','POP','54ELExv56KCAB4UP9cOCzC','https://p.scdn.co/mp3-preview/7d6a9dab2f3779eef37ef52603d20607a1390d91?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9jgdjedey8fx6bomf93orwtdm5dbmruy5ss5exofen58ghijji', '4j2w5d2yyxlvd5boopkjp53oe5kmrxmf0h34n49y7vkyvblyz6', '0');
-- Manuel Turizo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pgbr6ua9w6l3zvu', 'Manuel Turizo', '140@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebabd3e69b432d6187cf4e28c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:140@artist.com', 'pgbr6ua9w6l3zvu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pgbr6ua9w6l3zvu', 'A standout in reggaeton, known for his smooth voice and romantic lyrics.', 'Manuel Turizo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7t3mg9q0niug0hzfadx06hfvrzjpm3hc30c56n4rmgan8bfzf1','pgbr6ua9w6l3zvu', 'https://i.scdn.co/image/ab67616d0000b273c9f744b0d62da795bc21d04a', 'Manuel Turizo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('whrn2m9r85lez34ozn6va5yne1rnqhpgmzq3agcj32eg9r6euf','La Bachata','pgbr6ua9w6l3zvu','POP','5ww2BF9slyYgNOk37BlC4u','https://p.scdn.co/mp3-preview/0232b53fd7849e6696e1ab3099dd01dd00823f17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7t3mg9q0niug0hzfadx06hfvrzjpm3hc30c56n4rmgan8bfzf1', 'whrn2m9r85lez34ozn6va5yne1rnqhpgmzq3agcj32eg9r6euf', '0');
-- Bebe Rexha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jzk0gjpeko0u511', 'Bebe Rexha', '141@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41c4dd328bbea2f0a19c7522','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:141@artist.com', 'jzk0gjpeko0u511', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jzk0gjpeko0u511', 'A dynamic voice in pop music, known for her powerful vocals and catchy tunes.', 'Bebe Rexha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('r56po7qdtdpi6k20ke7dswugkn9sx9oo2rh7oiry3ctbf0f24m','jzk0gjpeko0u511', NULL, 'Bebe Rexha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4ocv5ur19megwo0jk23w7pqbor1soyvp4ukxyhxaq4c6srhhsw','Im Good (Blue)','jzk0gjpeko0u511','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r56po7qdtdpi6k20ke7dswugkn9sx9oo2rh7oiry3ctbf0f24m', '4ocv5ur19megwo0jk23w7pqbor1soyvp4ukxyhxaq4c6srhhsw', '0');
-- Rich The Kid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('swtkg9itczciju2', 'Rich The Kid', '142@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb10379ac1a13fa06e703bf421','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:142@artist.com', 'swtkg9itczciju2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('swtkg9itczciju2', 'Striking chords that resonate across generations.', 'Rich The Kid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3dvmi71dv8bxp4b78mv9o2gowaslj0emomfnfjm8luslgz3wjx','swtkg9itczciju2', NULL, 'Rich The Kid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('25ql5d1yqqfgopfoauu7jptebngutz4bg78pytikhs2bdti12x','Conexes de Mfia (feat. Rich ','swtkg9itczciju2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3dvmi71dv8bxp4b78mv9o2gowaslj0emomfnfjm8luslgz3wjx', '25ql5d1yqqfgopfoauu7jptebngutz4bg78pytikhs2bdti12x', '0');
-- Rosa Linn
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3ywksm2ddv4pr2f', 'Rosa Linn', '143@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5fe9684ed75d00000b63791','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:143@artist.com', '3ywksm2ddv4pr2f', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3ywksm2ddv4pr2f', 'Uniting fans around the globe with universal rhythms.', 'Rosa Linn');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o4kvk6sk0f4hit7delwy6c2ombb82m82foygfif8gwdl73czmi','3ywksm2ddv4pr2f', 'https://i.scdn.co/image/ab67616d0000b2731391b1fdb63da53e5b112224', 'Rosa Linn Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o82h4qdnldym22g6chkipjq7usjxbye66uaz1f9vodd0qr2mtf','SNAP','3ywksm2ddv4pr2f','POP','76OGwb5RA9h4FxQPT33ekc','https://p.scdn.co/mp3-preview/0a41500662a6b6223dcb026b20ef1437985574b8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o4kvk6sk0f4hit7delwy6c2ombb82m82foygfif8gwdl73czmi', 'o82h4qdnldym22g6chkipjq7usjxbye66uaz1f9vodd0qr2mtf', '0');
-- Omar Apollo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bjqpq2ipx14950u', 'Omar Apollo', '144@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0e2a3a2c664a4bbb14e44f8e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:144@artist.com', 'bjqpq2ipx14950u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bjqpq2ipx14950u', 'A sonic adventurer, always seeking new horizons in music.', 'Omar Apollo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xfcvoo2lz8i00c4smk8019kxtobg9ka68hfyva6l8521wd8sf8','bjqpq2ipx14950u', 'https://i.scdn.co/image/ab67616d0000b27390cf5d1ccfca2beb86149a19', 'Omar Apollo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qg1cv0dgwj0g1lwsofpevf719gs5v3wcqz58afyco3es7ol4za','Evergreen (You Didnt Deserve Me A','bjqpq2ipx14950u','POP','2TktkzfozZifbQhXjT6I33','https://p.scdn.co/mp3-preview/f9db43c10cfab231d9448792464a23f6e6d607e7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xfcvoo2lz8i00c4smk8019kxtobg9ka68hfyva6l8521wd8sf8', 'qg1cv0dgwj0g1lwsofpevf719gs5v3wcqz58afyco3es7ol4za', '0');
-- David Guetta
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('70x4xdcdbbcaqdo', 'David Guetta', '145@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:145@artist.com', '70x4xdcdbbcaqdo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('70x4xdcdbbcaqdo', 'A legend in the electronic music world, constantly innovating and entertaining.', 'David Guetta');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gyuxsk05omwjf9yx5qs5u6xefesik03dmsyribnkhn60oa9j9i','70x4xdcdbbcaqdo', 'https://i.scdn.co/image/ab67616d0000b2730b4ef75c3728599aa4104f7a', 'David Guetta Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('231hft1d1uj657xlxxtceovk5bgk5gek4f8kfqrwux96na4h8f','Baby Dont Hurt Me','70x4xdcdbbcaqdo','POP','3BKD1PwArikchz2Zrlp1qi','https://p.scdn.co/mp3-preview/a8f2e176e17e0f6298b42ef8e96118318fdd2b89?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gyuxsk05omwjf9yx5qs5u6xefesik03dmsyribnkhn60oa9j9i', '231hft1d1uj657xlxxtceovk5bgk5gek4f8kfqrwux96na4h8f', '0');
-- Chencho Corleone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u25hfv4cfgbj166', 'Chencho Corleone', '146@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2e862710857d2b3e1b5fb4f4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:146@artist.com', 'u25hfv4cfgbj166', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u25hfv4cfgbj166', 'A dynamic presence in reggaeton, known for his catchy beats and vibrant performances.', 'Chencho Corleone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('beiv43t93cqhtei6budggkewnd5i1j5r7qq8x2kavtg3xaxi0o','u25hfv4cfgbj166', NULL, 'Chencho Corleone Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0dkk0e52v2d6rxnggb2l1ygz1wag6nhoa9c48ol3pgw3trhl1j','Me Porto Bonito','u25hfv4cfgbj166','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('beiv43t93cqhtei6budggkewnd5i1j5r7qq8x2kavtg3xaxi0o', '0dkk0e52v2d6rxnggb2l1ygz1wag6nhoa9c48ol3pgw3trhl1j', '0');
-- Raim Laode
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ayr762sv9rnakm2', 'Raim Laode', '147@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f5fe38a2d25be089bf281e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:147@artist.com', 'ayr762sv9rnakm2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ayr762sv9rnakm2', 'A confluence of cultural beats and contemporary tunes.', 'Raim Laode');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wamktqob2o06feiwj1eo5op6mqmkx9jr0dzkpqeinjso39j8p3','ayr762sv9rnakm2', 'https://i.scdn.co/image/ab67616d0000b273f20ec6ba1f431a90dbf2e8b6', 'Raim Laode Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('322r3m8yptrtfqmuscsqem9kqnxkdl0hh9rmgufhj3kudrhgi7','Komang','ayr762sv9rnakm2','POP','2AaaE0qvFWtyT8srKNfRhH','https://p.scdn.co/mp3-preview/47575d13a133216ab684c5211af483a7524e89db?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wamktqob2o06feiwj1eo5op6mqmkx9jr0dzkpqeinjso39j8p3', '322r3m8yptrtfqmuscsqem9kqnxkdl0hh9rmgufhj3kudrhgi7', '0');
-- NF
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('52ehmcht50v0odo', 'NF', '148@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1cf142a710a2f3d9b7a62da1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:148@artist.com', '52ehmcht50v0odo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('52ehmcht50v0odo', 'Pioneering new paths in the musical landscape.', 'NF');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ek4e9d55it7mb1f0r5kuw26jta1vf1b9grlwksyzgpsnhm6z4v','52ehmcht50v0odo', 'https://i.scdn.co/image/ab67616d0000b273ff8a4276b3be31c839557439', 'NF Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ntafld4pqtehlzp705lrjnkstis7ljc4ut1fbztpoq2xhsax72','HAPPY','52ehmcht50v0odo','POP','3ZEno9fORwMA1HPecdLi0R',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ek4e9d55it7mb1f0r5kuw26jta1vf1b9grlwksyzgpsnhm6z4v', 'ntafld4pqtehlzp705lrjnkstis7ljc4ut1fbztpoq2xhsax72', '0');
-- Gunna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rvxr42jrzop24oa', 'Gunna', '149@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6501f8a7d50c56e86e46f920','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:149@artist.com', 'rvxr42jrzop24oa', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rvxr42jrzop24oa', 'A trailblazer in trap music, known for his smooth flow and catchy beats.', 'Gunna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9mkq54tqmthgk8olu1iaoue032teljpdyonvvasud4a9a5mzvq','rvxr42jrzop24oa', 'https://i.scdn.co/image/ab67616d0000b273017d5e26552345c4b1575b6c', 'Gunna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wkbnmb3w8g083gjo489fbedd7hj0fuukmolwluyc30r3os5sz0','fukumean','rvxr42jrzop24oa','POP','4rXLjWdF2ZZpXCVTfWcshS','https://p.scdn.co/mp3-preview/f237ab921af697ba9b49e12fa167c2ce1a82d6b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9mkq54tqmthgk8olu1iaoue032teljpdyonvvasud4a9a5mzvq', 'wkbnmb3w8g083gjo489fbedd7hj0fuukmolwluyc30r3os5sz0', '0');
-- LE SSERAFIM
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('68cvhfuc2fwoq44', 'LE SSERAFIM', '150@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb99752c006407988976248679','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:150@artist.com', '68cvhfuc2fwoq44', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('68cvhfuc2fwoq44', 'Pushing the boundaries of sound with each note.', 'LE SSERAFIM');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3kz46j7ocqs9o67lbvrobv7xj6amrp2chpaikoj9yed8dq98os','68cvhfuc2fwoq44', 'https://i.scdn.co/image/ab67616d0000b273a991995542d50a691b9ae5be', 'LE SSERAFIM Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qwloluwavl3plh5kftwmoanzvn8cz1ccrc5767ezm9q1vjw8tn','ANTIFRAGILE','68cvhfuc2fwoq44','POP','4fsQ0K37TOXa3hEQfjEic1','https://p.scdn.co/mp3-preview/97a1c7e470172e0993f8f65dc109ab9d017d7adc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3kz46j7ocqs9o67lbvrobv7xj6amrp2chpaikoj9yed8dq98os', 'qwloluwavl3plh5kftwmoanzvn8cz1ccrc5767ezm9q1vjw8tn', '0');
-- The Kid Laroi
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qztar9qdl13brig', 'The Kid Laroi', '151@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb393666951ab8b14e9c4ed386','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:151@artist.com', 'qztar9qdl13brig', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qztar9qdl13brig', 'A confluence of cultural beats and contemporary tunes.', 'The Kid Laroi');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('so74ccyatreqbn5kjsvv2bwuj6lezds152wfs4ms8095wsn0tj','qztar9qdl13brig', 'https://i.scdn.co/image/ab67616d0000b273a53643fc03785efb9926443d', 'The Kid Laroi Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sgupnar41ox57mnoufbpwkm1fz3i984eus8hax8fwmnsv7mdz4','Love Again','qztar9qdl13brig','POP','4sx6NRwL6Ol3V6m9exwGlQ','https://p.scdn.co/mp3-preview/4baae2685eaac7401ae183c54642c9ddf3b9e057?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('so74ccyatreqbn5kjsvv2bwuj6lezds152wfs4ms8095wsn0tj', 'sgupnar41ox57mnoufbpwkm1fz3i984eus8hax8fwmnsv7mdz4', '0');
-- Dean Lewis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yjknxzcqjty1vch', 'Dean Lewis', '152@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4fc14e184f9e05ba0676ddee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:152@artist.com', 'yjknxzcqjty1vch', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yjknxzcqjty1vch', 'Creating a tapestry of tunes that celebrates diversity.', 'Dean Lewis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('50zzohgfxlocecsg73z4i5n3rrl5jx0kwd3fdd3xn9zl6o95sx','yjknxzcqjty1vch', 'https://i.scdn.co/image/ab67616d0000b273bfedccaca3c8425fdc0a7c73', 'Dean Lewis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jonhbvm7f40a8l8ndokfm2uah239ywr6pj6hwne5ejms5q1ovx','How Do I Say Goodbye','yjknxzcqjty1vch','POP','5hnGrTBaEsdukpDF6aZg8a',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('50zzohgfxlocecsg73z4i5n3rrl5jx0kwd3fdd3xn9zl6o95sx', 'jonhbvm7f40a8l8ndokfm2uah239ywr6pj6hwne5ejms5q1ovx', '0');
-- ROSAL
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bq0btvyk6dzcmru', 'ROSAL', '153@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd7bb678bef6d2f26110cae49','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:153@artist.com', 'bq0btvyk6dzcmru', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bq0btvyk6dzcmru', 'Breathing new life into classic genres.', 'ROSAL');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j2p96dexh2omy7vtcshi7hz7g7eddhv8i0lre7t83d8apyfgsk','bq0btvyk6dzcmru', 'https://i.scdn.co/image/ab67616d0000b273efc0ef9dd996312ebaf0bf52', 'ROSAL Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zqo49a4a3xfog38loeh9k6lilp5crnzutqj4kkjrduk27sxinc','DESPECH','bq0btvyk6dzcmru','POP','53tfEupEzQRtVFOeZvk7xq','https://p.scdn.co/mp3-preview/304868e078d8f2c3209977997c47542181096b61?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j2p96dexh2omy7vtcshi7hz7g7eddhv8i0lre7t83d8apyfgsk', 'zqo49a4a3xfog38loeh9k6lilp5crnzutqj4kkjrduk27sxinc', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ktfl1kx56x9m3jv119ufsq3mn6d52z7t3jscb0mkmr5ybwugxj','LLYLM','bq0btvyk6dzcmru','POP','2SiAcexM2p1yX6joESbehd','https://p.scdn.co/mp3-preview/6f41063b2e36fb31fbd08c39b6c56012e239365b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j2p96dexh2omy7vtcshi7hz7g7eddhv8i0lre7t83d8apyfgsk', 'ktfl1kx56x9m3jv119ufsq3mn6d52z7t3jscb0mkmr5ybwugxj', '1');
-- Quevedo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kqixr6ranqz60q3', 'Quevedo', '154@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2394e996716534bc2c937a1a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:154@artist.com', 'kqixr6ranqz60q3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kqixr6ranqz60q3', 'Merging lyrical depth with compelling urban beats.', 'Quevedo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('h7tc7ipz5l8h0woloyiwhd4dbftp4c3quwpy2m5q1vfr9aljsn','kqixr6ranqz60q3', 'https://i.scdn.co/image/ab67616d0000b273a00a817b017c6f6bf8460be9', 'Quevedo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bai8xlhwfct8o31kzrdso134yvdsgf6f09eir5e0efn7f0jq8f','Columbia','kqixr6ranqz60q3','POP','6XbtvPmIpyCbjuT0e8cQtp','https://p.scdn.co/mp3-preview/e3d6df66fe67f618166a2cab858580ac8a96486a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h7tc7ipz5l8h0woloyiwhd4dbftp4c3quwpy2m5q1vfr9aljsn', 'bai8xlhwfct8o31kzrdso134yvdsgf6f09eir5e0efn7f0jq8f', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9sopcb1prvzs0aa9pg4hblc6mhmpo4a5adtpi6lfm2vqaz8huv','Punto G','kqixr6ranqz60q3','POP','4WiQA1AGWHFvaxBU6bHghs','https://p.scdn.co/mp3-preview/a1275d1dcfb4c25bc48821b19b81ff853386c148?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h7tc7ipz5l8h0woloyiwhd4dbftp4c3quwpy2m5q1vfr9aljsn', '9sopcb1prvzs0aa9pg4hblc6mhmpo4a5adtpi6lfm2vqaz8huv', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cpvu4hijm34ksydbywic7vf0pjpf3diogo65n374th18gi2wpr','Mami Chula','kqixr6ranqz60q3','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h7tc7ipz5l8h0woloyiwhd4dbftp4c3quwpy2m5q1vfr9aljsn', 'cpvu4hijm34ksydbywic7vf0pjpf3diogo65n374th18gi2wpr', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3gfz5u54z0nrgfps3m4xb5423evmzl72szoxid80a0ez3vbfvo','WANDA','kqixr6ranqz60q3','POP','0Iozrbed8spxoBnmtBMshO','https://p.scdn.co/mp3-preview/a6de4c6031032d886d67e88ec6db1a1c521ed023?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h7tc7ipz5l8h0woloyiwhd4dbftp4c3quwpy2m5q1vfr9aljsn', '3gfz5u54z0nrgfps3m4xb5423evmzl72szoxid80a0ez3vbfvo', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('26lbitb2kojyla45i112fm4myjmgd6b441w6xmg8eatzgjswt1','Vista Al Mar','kqixr6ranqz60q3','POP','5q86iSKkBtOoNkdgEDY5WV','https://p.scdn.co/mp3-preview/6896535fbb6690492102bdb7ca181f33de63ef4e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h7tc7ipz5l8h0woloyiwhd4dbftp4c3quwpy2m5q1vfr9aljsn', '26lbitb2kojyla45i112fm4myjmgd6b441w6xmg8eatzgjswt1', '4');
-- Sog
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ttbkzum7czz2vn5', 'Sog', '155@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:155@artist.com', 'ttbkzum7czz2vn5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ttbkzum7czz2vn5', 'Pioneering new paths in the musical landscape.', 'Sog');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nvdo09x81rffp6ucit4nn7sfpvt5p18y4xnyr1ackohe6b5g9y','ttbkzum7czz2vn5', NULL, 'Sog Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lwoxq2kb4sf354f49eutiu7f3bwkyfe0dvdun1ccvzjcckhug5','QUEMA','ttbkzum7czz2vn5','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nvdo09x81rffp6ucit4nn7sfpvt5p18y4xnyr1ackohe6b5g9y', 'lwoxq2kb4sf354f49eutiu7f3bwkyfe0dvdun1ccvzjcckhug5', '0');
-- NLE Choppa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3zfywe0urlwptrf', 'NLE Choppa', '156@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcc5865053e7177aeb0c26b62','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:156@artist.com', '3zfywe0urlwptrf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3zfywe0urlwptrf', 'Revolutionizing the music scene with innovative compositions.', 'NLE Choppa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ezhyn218ttq0s1a4g1s5hqpsl2n5t1j6ev9zntsmbkbn7w78u9','3zfywe0urlwptrf', 'https://i.scdn.co/image/ab67616d0000b27349a4f6c9a637e02252a0076d', 'NLE Choppa Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8wqtle9kmy9s2m0orlm6ckmc7hzbxfri4jz91ozqci7hap44o3','Slut Me Out','3zfywe0urlwptrf','POP','5BmB3OaQyYXCqRyN8iR2Yi','https://p.scdn.co/mp3-preview/84ef49a1e71bdac04b7dfb1dea3a56d1ffc50357?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ezhyn218ttq0s1a4g1s5hqpsl2n5t1j6ev9zntsmbkbn7w78u9', '8wqtle9kmy9s2m0orlm6ckmc7hzbxfri4jz91ozqci7hap44o3', '0');
-- Lord Huron
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ax8pm8nz2c9kz3x', 'Lord Huron', '157@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1d4e4e7e3c5d8fa494fc5f10','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:157@artist.com', 'ax8pm8nz2c9kz3x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ax8pm8nz2c9kz3x', 'An odyssey of sound that defies conventions.', 'Lord Huron');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fb9lneg21eyequ29lzp2zx1z01uxcvsgnlv55p1fsfd699s4xw','ax8pm8nz2c9kz3x', 'https://i.scdn.co/image/ab67616d0000b2739d2efe43d5b7ebc7cb60ca81', 'Lord Huron Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('buigrnein2kwdq82f9qtjhsmp91kb5bpivj910ijw05bxye7by','The Night We Met','ax8pm8nz2c9kz3x','POP','0QZ5yyl6B6utIWkxeBDxQN','https://p.scdn.co/mp3-preview/f10f271b165ee07e3d49d9f961d08b7ad74ebd5b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fb9lneg21eyequ29lzp2zx1z01uxcvsgnlv55p1fsfd699s4xw', 'buigrnein2kwdq82f9qtjhsmp91kb5bpivj910ijw05bxye7by', '0');
-- Baby Tate
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qz247uesv8fo1b1', 'Baby Tate', '158@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe7b0d119183e74ec390d7aec','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:158@artist.com', 'qz247uesv8fo1b1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qz247uesv8fo1b1', 'Harnessing the power of melody to tell compelling stories.', 'Baby Tate');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wcoy4n515e1jr8bgstz64ctuxbr1u22wigtl7sphcp1n4gvlds','qz247uesv8fo1b1', 'https://i.scdn.co/image/ab67616d0000b2732571034f34b381958f8cc727', 'Baby Tate Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('haa4zbq8ukdkpaaclq14bj5seimkf8ei8fqixlvyhqz2r2n4y6','Hey, Mickey!','qz247uesv8fo1b1','POP','3RKjTYlQrtLXCq5ncswBPp','https://p.scdn.co/mp3-preview/2bfe39402bec233fbb5b2c06ffedbbf4d6fbc38a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wcoy4n515e1jr8bgstz64ctuxbr1u22wigtl7sphcp1n4gvlds', 'haa4zbq8ukdkpaaclq14bj5seimkf8ei8fqixlvyhqz2r2n4y6', '0');
-- Joji
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wm8c4oksc6qhp4g', 'Joji', '159@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4111c95b5f430c3265c7304b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:159@artist.com', 'wm8c4oksc6qhp4g', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wm8c4oksc6qhp4g', 'Igniting the stage with electrifying performances.', 'Joji');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1i90ajy485tsrhvnxbuhnk971ikjemcpd8ye7k9788qlzw6nym','wm8c4oksc6qhp4g', 'https://i.scdn.co/image/ab67616d0000b27308596cc28b9f5b00bfe08ae7', 'Joji Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kxul8uiw0vqgxqftx7qmq2mche7tbp1skbljae07buhem3rhov','Glimpse of Us','wm8c4oksc6qhp4g','POP','6xGruZOHLs39ZbVccQTuPZ','https://p.scdn.co/mp3-preview/12e4a7ef3f1051424e6e282dfba83fe8448e122f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1i90ajy485tsrhvnxbuhnk971ikjemcpd8ye7k9788qlzw6nym', 'kxul8uiw0vqgxqftx7qmq2mche7tbp1skbljae07buhem3rhov', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4rzwt2zunhc1frg6y0pni00wf9ot6xsf8fxnww1a5qi15n6czw','Die For You','wm8c4oksc6qhp4g','POP','26hOm7dTtBi0TdpDGl141t','https://p.scdn.co/mp3-preview/85d19ba2d8274ab29f474b3baf07b6ac6ba6d35a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1i90ajy485tsrhvnxbuhnk971ikjemcpd8ye7k9788qlzw6nym', '4rzwt2zunhc1frg6y0pni00wf9ot6xsf8fxnww1a5qi15n6czw', '1');
-- Hozier
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cuuqcom0b4e9lfm', 'Hozier', '160@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad85a585103dfc2f3439119a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:160@artist.com', 'cuuqcom0b4e9lfm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cuuqcom0b4e9lfm', 'An odyssey of sound that defies conventions.', 'Hozier');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7mdig7wxo4znxdbj2q0vzarvyzafq0v7wt07docmpi5naten58','cuuqcom0b4e9lfm', 'https://i.scdn.co/image/ab67616d0000b2734ca68d59a4a29c856a4a39c2', 'Hozier Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6xc3rp254kj2gx8gupo716f6ph6cw0jhb4ewim6565vckymeq4','Take Me To Church','cuuqcom0b4e9lfm','POP','1CS7Sd1u5tWkstBhpssyjP','https://p.scdn.co/mp3-preview/d6170162e349338277c97d2fab42c386701a4089?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7mdig7wxo4znxdbj2q0vzarvyzafq0v7wt07docmpi5naten58', '6xc3rp254kj2gx8gupo716f6ph6cw0jhb4ewim6565vckymeq4', '0');
-- Mahalini
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lp3u81n6hy6qsat', 'Mahalini', '161@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb8333468abeb2e461d1ab5ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:161@artist.com', 'lp3u81n6hy6qsat', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lp3u81n6hy6qsat', 'A sonic adventurer, always seeking new horizons in music.', 'Mahalini');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('25dkjp5yh6sumtalduzbkrf04wuj0vlm3iuf15y5p25qk6kn6j','lp3u81n6hy6qsat', 'https://i.scdn.co/image/ab67616d0000b2736f713eb92ebf7ca05a562542', 'Mahalini Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zcy1dlyd4xh3tsuu2mqvskfdjuuhoji1eusque5ydpxidixegh','Sial','lp3u81n6hy6qsat','POP','6O0WEM0QNEhqpU50BKui7o','https://p.scdn.co/mp3-preview/1285e7f97156037b5c1c958513ff3f8176a68a33?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('25dkjp5yh6sumtalduzbkrf04wuj0vlm3iuf15y5p25qk6kn6j', 'zcy1dlyd4xh3tsuu2mqvskfdjuuhoji1eusque5ydpxidixegh', '0');
-- Alec Benjamin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k6pdpkpeihtsddb', 'Alec Benjamin', '162@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc7e8521887c99b10c8bbfbac','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:162@artist.com', 'k6pdpkpeihtsddb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k6pdpkpeihtsddb', 'Pioneering new paths in the musical landscape.', 'Alec Benjamin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bukr7n9nx9g2w6zmdi443f8mtrx2a9i17zus36i2zu6ff7frxg','k6pdpkpeihtsddb', 'https://i.scdn.co/image/ab67616d0000b273459d675aa0b6f3b211357370', 'Alec Benjamin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('82zgg8q2s2cw6aatnh1ymgmnxcfa4pyb02v9uxah3p0tepklui','Let Me Down Slowly','k6pdpkpeihtsddb','POP','2qxmye6gAegTMjLKEBoR3d','https://p.scdn.co/mp3-preview/19007111a4e21096bcefef77842d7179f0cdf12a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bukr7n9nx9g2w6zmdi443f8mtrx2a9i17zus36i2zu6ff7frxg', '82zgg8q2s2cw6aatnh1ymgmnxcfa4pyb02v9uxah3p0tepklui', '0');
-- Anggi Marito
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ppkm9rntyrplcmh', 'Anggi Marito', '163@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb604493f4d58b7d152a2d5f79','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:163@artist.com', 'ppkm9rntyrplcmh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ppkm9rntyrplcmh', 'A confluence of cultural beats and contemporary tunes.', 'Anggi Marito');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('59d2e3ljiw1zjmt0acaayfnyryzin87n7892hdy9sgcc0qrtrs','ppkm9rntyrplcmh', 'https://i.scdn.co/image/ab67616d0000b2732844c4e4e984ea408ab7fd6f', 'Anggi Marito Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bpmxuizl1hlvqfwj5r137rwmhmuhjdep8a71emt38ckveflzib','Tak Segampang Itu','ppkm9rntyrplcmh','POP','26cvTWJq2E1QqN4jyH2OTU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('59d2e3ljiw1zjmt0acaayfnyryzin87n7892hdy9sgcc0qrtrs', 'bpmxuizl1hlvqfwj5r137rwmhmuhjdep8a71emt38ckveflzib', '0');
-- PinkPantheress
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xw1xsxbxex3xcu8', 'PinkPantheress', '164@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03578c92e15089c645b794f5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:164@artist.com', 'xw1xsxbxex3xcu8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xw1xsxbxex3xcu8', 'Redefining pop music with her distinct sound and style.', 'PinkPantheress');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0ap9cwylpmwyju5gpbdf7gigci2olwuqekjmhl8mqczcbkmn0p','xw1xsxbxex3xcu8', 'https://i.scdn.co/image/ab67616d0000b2739567e1aa41657425d046733b', 'PinkPantheress Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('doiyek9t82xmzjjsuoouloniglz2stmyw43i8ky5auq9yr1psl','Boys a liar Pt. 2','xw1xsxbxex3xcu8','POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0ap9cwylpmwyju5gpbdf7gigci2olwuqekjmhl8mqczcbkmn0p', 'doiyek9t82xmzjjsuoouloniglz2stmyw43i8ky5auq9yr1psl', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7e370auazhqnt4tyd3vo9kfbzxifiedihtg601f9hu2vja12qw','Boys a liar','xw1xsxbxex3xcu8','POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0ap9cwylpmwyju5gpbdf7gigci2olwuqekjmhl8mqczcbkmn0p', '7e370auazhqnt4tyd3vo9kfbzxifiedihtg601f9hu2vja12qw', '1');
-- Grupo Frontera
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('n8rtvsatc1tgksr', 'Grupo Frontera', '165@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f1a7e9f510bf0501e209c58','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:165@artist.com', 'n8rtvsatc1tgksr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('n8rtvsatc1tgksr', 'Crafting melodies that resonate with the soul.', 'Grupo Frontera');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('97ofxo0kwy7mc93pt2x41zm4b01qvwm4tbv6x22o8ntaayakwt','n8rtvsatc1tgksr', 'https://i.scdn.co/image/ab67616d0000b27382ce4c7bbf861185252e82ae', 'Grupo Frontera Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nd3i9u8nc03uq54mcnwb2fu1d2hq2go3y296i1yo4mzb8fk4nh','No Se Va','n8rtvsatc1tgksr','POP','76kelNDs1ojicx1s6Urvck','https://p.scdn.co/mp3-preview/1aa36481ad26b54ce635e7eb7d7360353c09d9ea?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('97ofxo0kwy7mc93pt2x41zm4b01qvwm4tbv6x22o8ntaayakwt', 'nd3i9u8nc03uq54mcnwb2fu1d2hq2go3y296i1yo4mzb8fk4nh', '0');
-- Bizarrap
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y1j4ua2dei17jxk', 'Bizarrap', '166@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:166@artist.com', 'y1j4ua2dei17jxk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y1j4ua2dei17jxk', 'Revolutionizing the music scene with his unique production style and collaborations.', 'Bizarrap');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('utjy9ekdcnthp8i1emnj7a7ugbz9i2gofsu3opku69sb085rft','y1j4ua2dei17jxk', 'https://i.scdn.co/image/ab67616d0000b27315583045b2fdb7d7bab10e81', 'Bizarrap Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9r4s1y5l865wto5jk6yed3wf85iglwal1b88jc2oghfyz46i09','Peso Pluma: Bzrp Music Sessions, Vol. 55','y1j4ua2dei17jxk','POP','5AqiaZwhmC6dIbgWrD5SzV','https://p.scdn.co/mp3-preview/9d61998a29c2e8b52a7d46885352f5507eb219e2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('utjy9ekdcnthp8i1emnj7a7ugbz9i2gofsu3opku69sb085rft', '9r4s1y5l865wto5jk6yed3wf85iglwal1b88jc2oghfyz46i09', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wrm31r2z0374yxtz5u95syxly0enslka4z6nm5gvrhknlhzkcw','Quevedo: Bzrp Music Sessions, Vol. 52','y1j4ua2dei17jxk','POP','2tTmW7RDtMQtBk7m2rYeSw','https://p.scdn.co/mp3-preview/e9c0ed735e611f6af45bc946bd4c31590df09ed6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('utjy9ekdcnthp8i1emnj7a7ugbz9i2gofsu3opku69sb085rft', 'wrm31r2z0374yxtz5u95syxly0enslka4z6nm5gvrhknlhzkcw', '1');
-- Ozuna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mk0h2nko35bdhkb', 'Ozuna', '167@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd45efec1d439cfd8bd936421','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:167@artist.com', 'mk0h2nko35bdhkb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mk0h2nko35bdhkb', 'Dominating reggaeton and Latin trap with catchy tunes and charismatic energy.', 'Ozuna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7w1hgh7za6ab5h12ob7e8n2maja93bzkkwo5hejbsq6c4qy9dj','mk0h2nko35bdhkb', 'https://i.scdn.co/image/ab67616d0000b273125624f2e04f5a1ccb0dfb45', 'Ozuna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x3muxgzuffoetnwvixdpbydnqri6mygs736wtb4v9fewierpf7','Hey Mor','mk0h2nko35bdhkb','POP','1zsPaEkglFvxjAhrM8yhpr','https://p.scdn.co/mp3-preview/cd2d2242b748408da15c2b66f47d54b3f0793ae0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7w1hgh7za6ab5h12ob7e8n2maja93bzkkwo5hejbsq6c4qy9dj', 'x3muxgzuffoetnwvixdpbydnqri6mygs736wtb4v9fewierpf7', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1d56gh16lz9tcdljlhd78qvbhsrf09muk4fafoy8r2y7nsuh2h','Monoton','mk0h2nko35bdhkb','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7w1hgh7za6ab5h12ob7e8n2maja93bzkkwo5hejbsq6c4qy9dj', '1d56gh16lz9tcdljlhd78qvbhsrf09muk4fafoy8r2y7nsuh2h', '1');
-- Lil Durk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('azfe5tlmrre3ha0', 'Lil Durk', '168@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3513370298ee50e52dfc7326','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:168@artist.com', 'azfe5tlmrre3ha0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('azfe5tlmrre3ha0', 'An endless quest for musical perfection.', 'Lil Durk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('n9776zycby7o0l08nxrro935c185tttxis1kc3q8qen6eirmji','azfe5tlmrre3ha0', 'https://i.scdn.co/image/ab67616d0000b2736234c2c6d4bb935839ac4719', 'Lil Durk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('brm13aoy81w5k0t2dbvumo224pvkgzvh7y39nll8sgdlxkieg6','Stand By Me (feat. Morgan Wallen)','azfe5tlmrre3ha0','POP','1fXnu2HzxbDtoyvFPWG3Bw','https://p.scdn.co/mp3-preview/ed64766975b1f0b3aa57741935c3f20e833c47db?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n9776zycby7o0l08nxrro935c185tttxis1kc3q8qen6eirmji', 'brm13aoy81w5k0t2dbvumo224pvkgzvh7y39nll8sgdlxkieg6', '0');
-- Shakira
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e1e51amoxi92moj', 'Shakira', '169@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb284894d68fe2f80cad555110','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:169@artist.com', 'e1e51amoxi92moj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e1e51amoxi92moj', 'Harnessing the power of melody to tell compelling stories.', 'Shakira');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('eipf9b72m026mf2uiie1nipc9ixdkwa6qjsikedq30uqsc4e7w','e1e51amoxi92moj', NULL, 'Shakira Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fjyoj019iqs7qs2pqa9a4yic90jcrapoz3i54ioxuwkqjgsipf','Shakira: Bzrp Music Sessions, Vol. 53','e1e51amoxi92moj','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eipf9b72m026mf2uiie1nipc9ixdkwa6qjsikedq30uqsc4e7w', 'fjyoj019iqs7qs2pqa9a4yic90jcrapoz3i54ioxuwkqjgsipf', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6iclzxszp5d8w01x8gok51ppjviywtvefv2euh71a17l5m652l','Acrs','e1e51amoxi92moj','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eipf9b72m026mf2uiie1nipc9ixdkwa6qjsikedq30uqsc4e7w', '6iclzxszp5d8w01x8gok51ppjviywtvefv2euh71a17l5m652l', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iatc65hh5cu9zi5qfldjqdfojqfx8dpq0zelle5z5wou78pjxf','Te Felicito','e1e51amoxi92moj','POP','2rurDawMfoKP4uHyb2kJBt','https://p.scdn.co/mp3-preview/6b4b2be03b14bf758835c8f28f35834da35cc1c3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eipf9b72m026mf2uiie1nipc9ixdkwa6qjsikedq30uqsc4e7w', 'iatc65hh5cu9zi5qfldjqdfojqfx8dpq0zelle5z5wou78pjxf', '2');
-- Simone Mendes
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('oq4uqoxpkvowf08', 'Simone Mendes', '170@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb80e5acf09546a1fa2ca12a49','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:170@artist.com', 'oq4uqoxpkvowf08', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('oq4uqoxpkvowf08', 'A harmonious blend of passion and creativity.', 'Simone Mendes');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ul61li47p5t2hf9yum8ycgg6nb18z7b3wctm9zc6k464mbkwek','oq4uqoxpkvowf08', 'https://i.scdn.co/image/ab67616d0000b27379dcbcbbc872003eea5fd10f', 'Simone Mendes Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z3m2t0ykiri243xnyybtvs907io4azp0ccymuul0ymeisw0jiv','Erro Gostoso - Ao Vivo','oq4uqoxpkvowf08','POP','4R1XAT4Ix7kad727aKh7Pj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ul61li47p5t2hf9yum8ycgg6nb18z7b3wctm9zc6k464mbkwek', 'z3m2t0ykiri243xnyybtvs907io4azp0ccymuul0ymeisw0jiv', '0');
-- Big One
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('p1btj9rknv4spjv', 'Big One', '171@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcd00b46bac23bbfbcdcd10bc','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:171@artist.com', 'p1btj9rknv4spjv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('p1btj9rknv4spjv', 'Bringing a unique energy to every track, fusing various styles into a cohesive sound.', 'Big One');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('76uml1vdvt43lpej00euacrwj7z6n7t7poha15k5vbbfluo6lx','p1btj9rknv4spjv', NULL, 'Big One Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fy0pplbuncgxpw1jpxdwb7l9quil258fwwq5ak7gx8ojd6atga','Los del Espacio','p1btj9rknv4spjv','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('76uml1vdvt43lpej00euacrwj7z6n7t7poha15k5vbbfluo6lx', 'fy0pplbuncgxpw1jpxdwb7l9quil258fwwq5ak7gx8ojd6atga', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('avq0zuemurwl7eqfr92d0fs53kq1uni5tji4jzqpusmbqrh9mr','Un Finde | CROSSOVER #2','p1btj9rknv4spjv','POP','3tiJUOfAEqIrLFRQgGgdoY','https://p.scdn.co/mp3-preview/38b8f2c063a896c568b9741dcd6e194be0a0376b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('76uml1vdvt43lpej00euacrwj7z6n7t7poha15k5vbbfluo6lx', 'avq0zuemurwl7eqfr92d0fs53kq1uni5tji4jzqpusmbqrh9mr', '1');
-- Mambo Kingz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nboxeo5nw0blc9z', 'Mambo Kingz', '172@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb881ed0aa97cc8420685dc90e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:172@artist.com', 'nboxeo5nw0blc9z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nboxeo5nw0blc9z', 'Pushing the boundaries of sound with each note.', 'Mambo Kingz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('19qcalb06frkw2n7jqxt9im4i2ur1iyekyd97rukoqx833r43h','nboxeo5nw0blc9z', NULL, 'Mambo Kingz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zri3rwtyn237y36ed2sv2p91kgktnesx044cacywo24xygm0ed','Mejor Que Yo','nboxeo5nw0blc9z','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('19qcalb06frkw2n7jqxt9im4i2ur1iyekyd97rukoqx833r43h', 'zri3rwtyn237y36ed2sv2p91kgktnesx044cacywo24xygm0ed', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3p6qm7d5sdcxinrozvne9ygvstptiasvmeaub86h05ry2wf9sf','Mas Rica Que Ayer','nboxeo5nw0blc9z','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('19qcalb06frkw2n7jqxt9im4i2ur1iyekyd97rukoqx833r43h', '3p6qm7d5sdcxinrozvne9ygvstptiasvmeaub86h05ry2wf9sf', '1');
-- SEVENTEEN
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jtcoy7zahjyusd2', 'SEVENTEEN', '173@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb61916bb9f5c6a1a9ba1c9ab6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:173@artist.com', 'jtcoy7zahjyusd2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jtcoy7zahjyusd2', 'Creating a tapestry of tunes that celebrates diversity.', 'SEVENTEEN');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ll7xzj2g4sg2uyie96v72854q6wi1btpy9279pfpucscyd4knd','jtcoy7zahjyusd2', 'https://i.scdn.co/image/ab67616d0000b27380e31ba0c05187e6310ef264', 'SEVENTEEN Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o68y8dkcx2ixhm9b9peuhv2yu3xjthn2ax2nvmg7ijhhgzthrn','Super','jtcoy7zahjyusd2','POP','3AOf6YEpxQ894FmrwI9k96','https://p.scdn.co/mp3-preview/1dd31996959e603934dbe4c7d3ee377243a0f890?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ll7xzj2g4sg2uyie96v72854q6wi1btpy9279pfpucscyd4knd', 'o68y8dkcx2ixhm9b9peuhv2yu3xjthn2ax2nvmg7ijhhgzthrn', '0');
-- NewJeans
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jgufoendojitntk', 'NewJeans', '174@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5da361915b1fa48895d4f23f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:174@artist.com', 'jgufoendojitntk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jgufoendojitntk', 'Redefining K-pop with their fresh style and energetic performances.', 'NewJeans');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dvywmaju1413n98x88de7zk70wxgn03zvwx9wzg2gt6z6vtkq6','jgufoendojitntk', 'https://i.scdn.co/image/ab67616d0000b2733d98a0ae7c78a3a9babaf8af', 'NewJeans Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('99f1hp52isec9fxysxg6p5htajt9wpcknczarg5u9wf1mj34b1','Super Shy','jgufoendojitntk','POP','5sdQOyqq2IDhvmx2lHOpwd','https://p.scdn.co/mp3-preview/dab062e2cc708a2680ce84953a3581c5a679a230?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dvywmaju1413n98x88de7zk70wxgn03zvwx9wzg2gt6z6vtkq6', '99f1hp52isec9fxysxg6p5htajt9wpcknczarg5u9wf1mj34b1', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fhgueoehuyif9pwb7alurvaclc5wbzwqeb2buocpln6rd9tth4','New Jeans','jgufoendojitntk','POP','6rdkCkjk6D12xRpdMXy0I2','https://p.scdn.co/mp3-preview/a37b4269b0dc5e952826d8c43d1b7c072ac39b4c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dvywmaju1413n98x88de7zk70wxgn03zvwx9wzg2gt6z6vtkq6', 'fhgueoehuyif9pwb7alurvaclc5wbzwqeb2buocpln6rd9tth4', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j5912n11dm9b2lxyy2141ldndkvk83v91elqyo798hasadbcfa','OMG','jgufoendojitntk','POP','65FftemJ1DbbZ45DUfHJXE','https://p.scdn.co/mp3-preview/b9e344aa96afc45a56df77ca63c78786bdaa0047?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dvywmaju1413n98x88de7zk70wxgn03zvwx9wzg2gt6z6vtkq6', 'j5912n11dm9b2lxyy2141ldndkvk83v91elqyo798hasadbcfa', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m0xv5g5hv5gk0digl1uek0el2z0ok5uodfmc14fl9rie1j2v1g','Ditto','jgufoendojitntk','POP','3r8RuvgbX9s7ammBn07D3W','https://p.scdn.co/mp3-preview/4f048713ddfa434539dec7c3cb689f3393353edd?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dvywmaju1413n98x88de7zk70wxgn03zvwx9wzg2gt6z6vtkq6', 'm0xv5g5hv5gk0digl1uek0el2z0ok5uodfmc14fl9rie1j2v1g', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zecbt1js34kiqcuk0zfn09ffeq7dado53p28vq65fx6n4jvwqe','Hype Boy','jgufoendojitntk','POP','0a4MMyCrzT0En247IhqZbD','https://p.scdn.co/mp3-preview/7c55950057fc446dc2ce59671dff4fa6b3ef52a7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dvywmaju1413n98x88de7zk70wxgn03zvwx9wzg2gt6z6vtkq6', 'zecbt1js34kiqcuk0zfn09ffeq7dado53p28vq65fx6n4jvwqe', '4');
-- Mae Stephens
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x24ac5as6zrzney', 'Mae Stephens', '175@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb743f68b46b3909d5f74da093','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:175@artist.com', 'x24ac5as6zrzney', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x24ac5as6zrzney', 'A unique voice in the contemporary music scene.', 'Mae Stephens');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1474k99avj988pe4ks30inmyc4yvocuoyck4jvwiny1vlzq2sk','x24ac5as6zrzney', 'https://i.scdn.co/image/ab67616d0000b2731fc63c898797e3dbf04ad611', 'Mae Stephens Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6uu0arq5kx7j008bydf13em1x3zciq0ow2a63qc6e6i1vqyhf2','If We Ever Broke Up','x24ac5as6zrzney','POP','6maTPqynTmrkWIralgGaoP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1474k99avj988pe4ks30inmyc4yvocuoyck4jvwiny1vlzq2sk', '6uu0arq5kx7j008bydf13em1x3zciq0ow2a63qc6e6i1vqyhf2', '0');
-- King
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9gklal5yh00bdvs', 'King', '176@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5c0b2129a88c7d6ed0704556','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:176@artist.com', '9gklal5yh00bdvs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9gklal5yh00bdvs', 'The architect of aural landscapes that inspire and captivate.', 'King');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('s1hc9lxuys2np1kd0hfjyx4jrsebtxkdnez4irga5mq8r0jt7v','9gklal5yh00bdvs', 'https://i.scdn.co/image/ab67616d0000b27337f65266754703fd20d29854', 'King Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e2qretngwhk7rjj6ikm00g6nvg9rc6ctmsok7vnfwca88q3y5x','Maan Meri Jaan','9gklal5yh00bdvs','POP','1418IuVKQPTYqt7QNJ9RXN','https://p.scdn.co/mp3-preview/cf886ec5f6a46c234bcfdd043ab5db03db0015b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s1hc9lxuys2np1kd0hfjyx4jrsebtxkdnez4irga5mq8r0jt7v', 'e2qretngwhk7rjj6ikm00g6nvg9rc6ctmsok7vnfwca88q3y5x', '0');
-- Jain
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yru84je70i0qx8k', 'Jain', '177@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb673f287fead1f6c83b9b68ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:177@artist.com', 'yru84je70i0qx8k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yru84je70i0qx8k', 'Mixing electronic beats with multicultural influences to create a unique sound.', 'Jain');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mttecvbpugh4h4ayetmzm5xkfmcdft4vpgtz0nrly31boachm8','yru84je70i0qx8k', 'https://i.scdn.co/image/ab67616d0000b27364ba66f8a81c52364e55db50', 'Jain Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kkfj6z9se7k7nozise2m85ptcwzwu7jz1scfyux6d0nrtkiky0','Makeba','yru84je70i0qx8k','POP','4TNFLwe6DhtR3Wn1JKMqMJ','https://p.scdn.co/mp3-preview/41db29480f9d12734adf491d3b5dd4da1005047c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mttecvbpugh4h4ayetmzm5xkfmcdft4vpgtz0nrly31boachm8', 'kkfj6z9se7k7nozise2m85ptcwzwu7jz1scfyux6d0nrtkiky0', '0');
-- David Kushner
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3tnpscso2pig34x', 'David Kushner', '178@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12fd1bd22516e35ef8c2e591','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:178@artist.com', '3tnpscso2pig34x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3tnpscso2pig34x', 'A rising talent, creating music that resonates with a generation.', 'David Kushner');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('irku6wk4xetu1r6v3tk6biqwhluhzq81pt9yfjl4r3mlxj6f74','3tnpscso2pig34x', 'https://i.scdn.co/image/ab67616d0000b27395ca6a9b4083a86c149934ae', 'David Kushner Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8cvp90w5mjdkgnru9wujl47sd5u8tizmubqsl4eb4s1xnku2sq','Daylight','3tnpscso2pig34x','POP','1odExI7RdWc4BT515LTAwj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('irku6wk4xetu1r6v3tk6biqwhluhzq81pt9yfjl4r3mlxj6f74', '8cvp90w5mjdkgnru9wujl47sd5u8tizmubqsl4eb4s1xnku2sq', '0');
-- Stephen Sanchez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7nv2d0997qd0aj8', 'Stephen Sanchez', '179@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1e97fce6fa6fc4ebc3ebda25','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:179@artist.com', '7nv2d0997qd0aj8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7nv2d0997qd0aj8', 'A harmonious blend of passion and creativity.', 'Stephen Sanchez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yxdhpc2hq2j1w8m4f67smudfjb3tv2fbemu66a7t0waskjhd6c','7nv2d0997qd0aj8', 'https://i.scdn.co/image/ab67616d0000b2732bf0876d42b90a8852ad6244', 'Stephen Sanchez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5dapzp9g8qjyoxw692w1td38q98fhtdykit77vsi4j3xfkiy68','Until I Found You','7nv2d0997qd0aj8','POP','1Y3LN4zO1Edc2EluIoSPJN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yxdhpc2hq2j1w8m4f67smudfjb3tv2fbemu66a7t0waskjhd6c', '5dapzp9g8qjyoxw692w1td38q98fhtdykit77vsi4j3xfkiy68', '0');
-- Peso Pluma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vxnxt93t7zooogo', 'Peso Pluma', '180@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:180@artist.com', 'vxnxt93t7zooogo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vxnxt93t7zooogo', 'Infusing music with energetic beats and captivating lyrics.', 'Peso Pluma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3llx59suc5r5saj59fp1l2bw2qj0ngyu5vxqb1m6wj7h0swxx4','vxnxt93t7zooogo', NULL, 'Peso Pluma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9av19e1sjx1eq1san4y6dg14hjtxvhbb8ygj9hqb41tw9eysho','La Bebe - Remix','vxnxt93t7zooogo','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3llx59suc5r5saj59fp1l2bw2qj0ngyu5vxqb1m6wj7h0swxx4', '9av19e1sjx1eq1san4y6dg14hjtxvhbb8ygj9hqb41tw9eysho', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('btjyhdnvegph2ouq4fxy41vdhdvz5mx92ab1cyt5j16p57ygcs','TULUM','vxnxt93t7zooogo','POP','7bPp2NmpmyhLJ7zWazAXMu','https://p.scdn.co/mp3-preview/164468e67b8da8053036c68533ffa473ab680c51?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3llx59suc5r5saj59fp1l2bw2qj0ngyu5vxqb1m6wj7h0swxx4', 'btjyhdnvegph2ouq4fxy41vdhdvz5mx92ab1cyt5j16p57ygcs', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2z6m3qmrujtw26psds8f0dy3a2pfc6za594njfbv15yxa77d6o','Por las Noches','vxnxt93t7zooogo','POP','2VzCjpKvPB1l1tqLndtAQa','https://p.scdn.co/mp3-preview/ba2f667c373e2d12343ac00b162886caca060c93?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3llx59suc5r5saj59fp1l2bw2qj0ngyu5vxqb1m6wj7h0swxx4', '2z6m3qmrujtw26psds8f0dy3a2pfc6za594njfbv15yxa77d6o', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qbqkd0aflwwn5lftt7ly4tlaut0dgcfr5zk0c2371rkjb02abk','Bye','vxnxt93t7zooogo','POP','6n2P81rPk2RTzwnNNgFOdb','https://p.scdn.co/mp3-preview/94ef6a9f37e088fff4b37e098a46561e74dab95b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3llx59suc5r5saj59fp1l2bw2qj0ngyu5vxqb1m6wj7h0swxx4', 'qbqkd0aflwwn5lftt7ly4tlaut0dgcfr5zk0c2371rkjb02abk', '3');
-- Tainy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zac2nc7q35mijnz', 'Tainy', '181@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb50d43598b9074f0d6146127','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:181@artist.com', 'zac2nc7q35mijnz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zac2nc7q35mijnz', 'Revolutionizing reggaeton and Latin music with groundbreaking production.', 'Tainy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('aoalt4hq1wakd68gc2fnvvgt7euq2c3dfbhvbue2gdojc0ufsh','zac2nc7q35mijnz', 'https://i.scdn.co/image/ab67616d0000b273de7b9af78fbdda96c5a0635b', 'Tainy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jz8wpkpcno4h9r2ph6tnrx3py18phe0793zlz543m6mp6up5sm','MOJABI GHOST','zac2nc7q35mijnz','POP','4eMKD8MRroxCqugpsxCCNb','https://p.scdn.co/mp3-preview/a6d8180d52b759c3e3db9aa78e841ffc06e26c17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('aoalt4hq1wakd68gc2fnvvgt7euq2c3dfbhvbue2gdojc0ufsh', 'jz8wpkpcno4h9r2ph6tnrx3py18phe0793zlz543m6mp6up5sm', '0');
-- Loreen
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pr0bctdxna3irqu', 'Loreen', '182@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3ca2710f45c2993c415a1c5e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:182@artist.com', 'pr0bctdxna3irqu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pr0bctdxna3irqu', 'Pioneering new paths in the musical landscape.', 'Loreen');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ajgpc19dxv7efmmuykrtrtixi3x7q7r08a4z9y0f8w3dxgyyhz','pr0bctdxna3irqu', 'https://i.scdn.co/image/ab67616d0000b2732b0ba87db609976eee193bd6', 'Loreen Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1bo56kzodxmljstj46ahdettlzoz5skogszfcmndjrikydrtsd','Tattoo','pr0bctdxna3irqu','POP','1DmW5Ep6ywYwxc2HMT5BG6',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ajgpc19dxv7efmmuykrtrtixi3x7q7r08a4z9y0f8w3dxgyyhz', '1bo56kzodxmljstj46ahdettlzoz5skogszfcmndjrikydrtsd', '0');
-- Chris Molitor
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x9gdbrydguccgc0', 'Chris Molitor', '183@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03851b1c2471a8c0b57371c4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:183@artist.com', 'x9gdbrydguccgc0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x9gdbrydguccgc0', 'Delivering heartfelt music that speaks to the soul, blending folk and indie vibes.', 'Chris Molitor');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cre2hima2uc2kjci8kry48z08mecvd5r5euomdsgq5ge92okfv','x9gdbrydguccgc0', 'https://i.scdn.co/image/ab67616d0000b273be011d16b9360a7dee109774', 'Chris Molitor Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jfhudvr725wwi3m5tjzxcirgyi2rdrr6k5aki0tuwqoujqfcy9','Yellow','x9gdbrydguccgc0','POP','6tvs7zEP8d1SBgSqZQ84OT','https://p.scdn.co/mp3-preview/ea93f9b43fc638111ad661719037bfb88cd9c05d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cre2hima2uc2kjci8kry48z08mecvd5r5euomdsgq5ge92okfv', 'jfhudvr725wwi3m5tjzxcirgyi2rdrr6k5aki0tuwqoujqfcy9', '0');
-- sped up 8282
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ypkmn9t6d97l4lh', 'sped up 8282', '184@artist.com', 'https://i.scdn.co/image/ab67616d0000b2730a0ba228b5be4ffb7c7c59fb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:184@artist.com', 'ypkmn9t6d97l4lh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ypkmn9t6d97l4lh', 'Elevating the ordinary to extraordinary through music.', 'sped up 8282');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('akiiszm876l06w62do4xi9ebl20p8jhlm4njok9507oyto1h9i','ypkmn9t6d97l4lh', 'https://i.scdn.co/image/ab67616d0000b2730a0ba228b5be4ffb7c7c59fb', 'sped up 8282 Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8y32kjtopc1mruxffq8hbc9xe65lioz4dec4a8mid1qh3molc4','Cupid  Twin Ver. (FIFTY FIFTY)  Spe','ypkmn9t6d97l4lh','POP','3B228N0GxfUCwPyfNcJxps','https://p.scdn.co/mp3-preview/29e8870f55c261ec995edfe4a3e9f30e4d4527e0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('akiiszm876l06w62do4xi9ebl20p8jhlm4njok9507oyto1h9i', '8y32kjtopc1mruxffq8hbc9xe65lioz4dec4a8mid1qh3molc4', '0');
-- Ray Dalton
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kt0qd7te3alwu6q', 'Ray Dalton', '185@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb761f04a794923fde50fcb9fb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:185@artist.com', 'kt0qd7te3alwu6q', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kt0qd7te3alwu6q', 'Blending genres for a fresh musical experience.', 'Ray Dalton');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cr1wm10515u2m81du9jd2bvgtyz04m1tly6lfzx8wflsdo5ul9','kt0qd7te3alwu6q', NULL, 'Ray Dalton Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('smckoe4y156ctu6orjwpvr014bv7yffe795tped92la5weu7yj','Cant Hold Us (feat. Ray Dalton)','kt0qd7te3alwu6q','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cr1wm10515u2m81du9jd2bvgtyz04m1tly6lfzx8wflsdo5ul9', 'smckoe4y156ctu6orjwpvr014bv7yffe795tped92la5weu7yj', '0');
-- The Police
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z2vwu318jmg1hgq', 'The Police', '186@artist.com', 'https://i.scdn.co/image/1f73a61faca2942cd5ea29c2143184db8645f0b3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:186@artist.com', 'z2vwu318jmg1hgq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z2vwu318jmg1hgq', 'An odyssey of sound that defies conventions.', 'The Police');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('95pqvhobupb88jnoizziq27q3zfgc7gqhe1ngpap9y60iz5opd','z2vwu318jmg1hgq', 'https://i.scdn.co/image/ab67616d0000b2730408dc279dd7c7354ff41014', 'The Police Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yk7wcjp0129la094bsglww27ozgrag3dfjfdkkihd2cbigvwy8','Every Breath You Take - Remastered 2003','z2vwu318jmg1hgq','POP','0wF2zKJmgzjPTfircPJ2jg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('95pqvhobupb88jnoizziq27q3zfgc7gqhe1ngpap9y60iz5opd', 'yk7wcjp0129la094bsglww27ozgrag3dfjfdkkihd2cbigvwy8', '0');
-- Kaliii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yv6vnhsazucqz0c', 'Kaliii', '187@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb749bcc7f4b8d1d60f5f13744','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:187@artist.com', 'yv6vnhsazucqz0c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yv6vnhsazucqz0c', 'A visionary in the world of music, redefining genres.', 'Kaliii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kdzi841oywartr9d1w3y0gpw2e0jprgt9zv7ms4wr1z54nt45s','yv6vnhsazucqz0c', 'https://i.scdn.co/image/ab67616d0000b2733eecc265c134153c14794aab', 'Kaliii Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('44utk8dp6crcas952wkctrorwo8vlq4oprrqa725qq9bbjc90k','Area Codes','yv6vnhsazucqz0c','POP','7sliFe6W30tPBPh6dvZsIH','https://p.scdn.co/mp3-preview/d1beed2734f948ec9c33164d3aa818e04f4afd30?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kdzi841oywartr9d1w3y0gpw2e0jprgt9zv7ms4wr1z54nt45s', '44utk8dp6crcas952wkctrorwo8vlq4oprrqa725qq9bbjc90k', '0');
-- Zach Bryan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c7ma0j2xubsdwfb', 'Zach Bryan', '188@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4fd54df35bfcfa0fc9fc2da7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:188@artist.com', 'c7ma0j2xubsdwfb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c7ma0j2xubsdwfb', 'An endless quest for musical perfection.', 'Zach Bryan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d2aiehgjpk5tnfqa1txngvlwelckj9lhruf18xh1kmavpbokcr','c7ma0j2xubsdwfb', 'https://i.scdn.co/image/ab67616d0000b273b2b6670e3aca9bcd55fbabbb', 'Zach Bryan Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c224fx45osca9xc2v9849zev0upyltcd7z205wjkkyc09c9tgk','Something in the Orange','c7ma0j2xubsdwfb','POP','3WMj8moIAXJhHsyLaqIIHI','https://p.scdn.co/mp3-preview/d33dc9df586e24c9d8f640df08b776d94680f529?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d2aiehgjpk5tnfqa1txngvlwelckj9lhruf18xh1kmavpbokcr', 'c224fx45osca9xc2v9849zev0upyltcd7z205wjkkyc09c9tgk', '0');
-- Z Neto & Crist
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('g9usiidqgv5hkl4', 'Z Neto & Crist', '189@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1bb9201db3ff149830f0139a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:189@artist.com', 'g9usiidqgv5hkl4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('g9usiidqgv5hkl4', 'Harnessing the power of melody to tell compelling stories.', 'Z Neto & Crist');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('m9lniz7hgob3mfwev74tjeqf4m7nzwnu1uxx8sjjj28zm62xaz','g9usiidqgv5hkl4', 'https://i.scdn.co/image/ab67616d0000b27339833b5940945cf013e8406c', 'Z Neto & Crist Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('phg5f1w7met6sx6nko1v7l0i8sfoh8604qsnqkkho2l0j0x7zj','Oi Balde - Ao Vivo','g9usiidqgv5hkl4','POP','4xAGuRRKOgoaZbMGdmTD3N','https://p.scdn.co/mp3-preview/a6318531e5f8243a9d1df067570b50210b2729cc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m9lniz7hgob3mfwev74tjeqf4m7nzwnu1uxx8sjjj28zm62xaz', 'phg5f1w7met6sx6nko1v7l0i8sfoh8604qsnqkkho2l0j0x7zj', '0');
-- Miguel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pr9018xcjcd9gdk', 'Miguel', '190@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4669166b571594eade778990','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:190@artist.com', 'pr9018xcjcd9gdk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pr9018xcjcd9gdk', 'Crafting soundscapes that transport listeners to another world.', 'Miguel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1na98izd5pyzqsdabrwjr7dgkoc3p2wf84l2pld7mhuk5f3sga','pr9018xcjcd9gdk', 'https://i.scdn.co/image/ab67616d0000b273d5a8395b0d80b8c48a5d851c', 'Miguel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('or0cjhno9xvkrq85ukigdflnxsop41cxjljbsmfp39ognxjsrq','Sure Thing','pr9018xcjcd9gdk','POP','0JXXNGljqupsJaZsgSbMZV','https://p.scdn.co/mp3-preview/d337faa4bb71c8ac9a13998be64fbb0d7d8b8463?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1na98izd5pyzqsdabrwjr7dgkoc3p2wf84l2pld7mhuk5f3sga', 'or0cjhno9xvkrq85ukigdflnxsop41cxjljbsmfp39ognxjsrq', '0');
-- Bobby Helms
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tos5esbt3xpk6eb', 'Bobby Helms', '191@artist.com', 'https://i.scdn.co/image/1dcd3f5d64a65f19d085b8e78746e457bd2d2e05','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:191@artist.com', 'tos5esbt3xpk6eb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tos5esbt3xpk6eb', 'A beacon of innovation in the world of sound.', 'Bobby Helms');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vsa19mtnzj4jtu1yz7ti42xvadhqc5ilnheouy5x9cbnv1w0df','tos5esbt3xpk6eb', 'https://i.scdn.co/image/ab67616d0000b273fd56f3c7a294f5cfe51c7b17', 'Bobby Helms Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0g37s26mlzkjr0dqf06gp25e0dtvvhqay0z60cqfoz0tubyvud','Jingle Bell Rock','tos5esbt3xpk6eb','POP','7vQbuQcyTflfCIOu3Uzzya',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vsa19mtnzj4jtu1yz7ti42xvadhqc5ilnheouy5x9cbnv1w0df', '0g37s26mlzkjr0dqf06gp25e0dtvvhqay0z60cqfoz0tubyvud', '0');
-- Twisted
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tmm05gx9gyzzwzo', 'Twisted', '192@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2615ef39cf9128c447b31619','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:192@artist.com', 'tmm05gx9gyzzwzo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tmm05gx9gyzzwzo', 'Weaving lyrical magic into every song.', 'Twisted');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8oud76ga0m6iqvkd45drn0vbgfhm932rh024snujehaw2s0o1a','tmm05gx9gyzzwzo', 'https://i.scdn.co/image/ab67616d0000b273f5e2ffd88f07e55f34c361c8', 'Twisted Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('edxy82qruv4l4jv2zw2jtledcltmw2v3gfu60odvap663fudmz','WORTH NOTHING','tmm05gx9gyzzwzo','POP','3PjbA0O5olhampPMdaB0V1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8oud76ga0m6iqvkd45drn0vbgfhm932rh024snujehaw2s0o1a', 'edxy82qruv4l4jv2zw2jtledcltmw2v3gfu60odvap663fudmz', '0');
-- Maria Becerra
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yinkssk9w9xeapj', 'Maria Becerra', '193@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb6cfa517b8f5a152d63c4ffb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:193@artist.com', 'yinkssk9w9xeapj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yinkssk9w9xeapj', 'A vibrant new voice in Latin pop, fusing catchy melodies with urban sounds.', 'Maria Becerra');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cth60if7fintxzem0xt2ybk64j83dp8ani1fxzum7pjo2hkvds','yinkssk9w9xeapj', NULL, 'Maria Becerra Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9xlfw29zjow9tdhwtz45z7taff7jao3w0mqo2psyrj7nw9wmny','CORAZN VA','yinkssk9w9xeapj','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cth60if7fintxzem0xt2ybk64j83dp8ani1fxzum7pjo2hkvds', '9xlfw29zjow9tdhwtz45z7taff7jao3w0mqo2psyrj7nw9wmny', '0');
-- j-hope
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wzu5rt0hc2uny9h', 'j-hope', '194@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeb746063d1aafa2817ea11b5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:194@artist.com', 'wzu5rt0hc2uny9h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wzu5rt0hc2uny9h', 'A sonic adventurer, always seeking new horizons in music.', 'j-hope');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9xuyu9pwscon6ggsf0doigipjzr9r7j1juqggf3gq67zzxxc1g','wzu5rt0hc2uny9h', 'https://i.scdn.co/image/ab67616d0000b2735e8286ff63f7efce1881a02b', 'j-hope Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('25vic9jl550fzh09x30wp4u9hydfj97azb9dprlxy9dsp87qbl','on the street (with J. Cole)','wzu5rt0hc2uny9h','POP','5wxYxygyHpbgv0EXZuqb9V','https://p.scdn.co/mp3-preview/c69cf6ed41027bd08a5953b556cca144ff8ed2bf?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9xuyu9pwscon6ggsf0doigipjzr9r7j1juqggf3gq67zzxxc1g', '25vic9jl550fzh09x30wp4u9hydfj97azb9dprlxy9dsp87qbl', '0');
-- Jung Kook
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nxf7snu3dpyf3pd', 'Jung Kook', '195@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:195@artist.com', 'nxf7snu3dpyf3pd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nxf7snu3dpyf3pd', 'A member of BTS, captivating fans with his powerful vocals and dynamic performances.', 'Jung Kook');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('canc5g5dkqiqe93krb2fzpgiadetcjjgizql7odmo16h0xg33y','nxf7snu3dpyf3pd', 'https://i.scdn.co/image/ab67616d0000b273a7f42c375578df426b37638d', 'Jung Kook Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kp2g46yehbuanqdfx3ct9mpc4h6kbiu32av0eh4v8dlyqlm568','Still With You','nxf7snu3dpyf3pd','POP','0eFMbKCRw8KByXyWBw8WO7','https://p.scdn.co/mp3-preview/af2a740e10a6956dedd7e7f66fd65d7166e9187f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('canc5g5dkqiqe93krb2fzpgiadetcjjgizql7odmo16h0xg33y', 'kp2g46yehbuanqdfx3ct9mpc4h6kbiu32av0eh4v8dlyqlm568', '0');
-- Kendrick Lamar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('awwpstm7hw6is9n', 'Kendrick Lamar', '196@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb52696416126917a827b514d2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:196@artist.com', 'awwpstm7hw6is9n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('awwpstm7hw6is9n', 'A harmonious blend of passion and creativity.', 'Kendrick Lamar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dgiopb80qu0zsr20sq60bxpqgp3akcrz95h9cpnq61izku9fhk','awwpstm7hw6is9n', 'https://i.scdn.co/image/ab67616d0000b273d28d2ebdedb220e479743797', 'Kendrick Lamar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yvmznbf0hv9xpz9gnpcses50rk1qc8l9cf50e9cytju25bxr4p','Money Trees','awwpstm7hw6is9n','POP','2HbKqm4o0w5wEeEFXm2sD4',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dgiopb80qu0zsr20sq60bxpqgp3akcrz95h9cpnq61izku9fhk', 'yvmznbf0hv9xpz9gnpcses50rk1qc8l9cf50e9cytju25bxr4p', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tkn1shxhlebm7ftwomm5v9mfbcq7awfjv9jeq0bch9bwm3cfe0','AMERICA HAS A PROBLEM (feat. Kendrick Lamar)','awwpstm7hw6is9n','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dgiopb80qu0zsr20sq60bxpqgp3akcrz95h9cpnq61izku9fhk', 'tkn1shxhlebm7ftwomm5v9mfbcq7awfjv9jeq0bch9bwm3cfe0', '1');
-- Steve Aoki
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hclsknubcb6lnrp', 'Steve Aoki', '197@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:197@artist.com', 'hclsknubcb6lnrp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hclsknubcb6lnrp', 'A harmonious blend of passion and creativity.', 'Steve Aoki');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('md3l3zywukbzaw3b1dnmzfsn6lsy0tulzhzui4v2hq88kl6rqo','hclsknubcb6lnrp', NULL, 'Steve Aoki Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pu6emzisynxj0s3s6urun8dtv21wp5bftdki2z1m9tasn3nh67','Mu','hclsknubcb6lnrp','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('md3l3zywukbzaw3b1dnmzfsn6lsy0tulzhzui4v2hq88kl6rqo', 'pu6emzisynxj0s3s6urun8dtv21wp5bftdki2z1m9tasn3nh67', '0');
-- Dua Lipa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lz7pr73ohgzh2vv', 'Dua Lipa', '198@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1bbee4a02f85ecc58d385c3e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:198@artist.com', 'lz7pr73ohgzh2vv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lz7pr73ohgzh2vv', 'A pop phenomenon, known for her empowering anthems and dynamic presence.', 'Dua Lipa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u8vsrfirfh0eqt4egrdfc38zgqgsm849de1vzvtl4a5naydcbw','lz7pr73ohgzh2vv', 'https://i.scdn.co/image/ab67616d0000b2737dd3ba455ee3390cb55b0192', 'Dua Lipa Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('774upyhyifoq3bvw2kg790yu6x7hozt0f4zwcu0uvw6bqda2wu','Dance The Night (From Barbie The Album)','lz7pr73ohgzh2vv','POP','1vYXt7VSjH9JIM5oRRo7vA','https://p.scdn.co/mp3-preview/acaea048f50a3b30ca24b348c84a6047373baabb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u8vsrfirfh0eqt4egrdfc38zgqgsm849de1vzvtl4a5naydcbw', '774upyhyifoq3bvw2kg790yu6x7hozt0f4zwcu0uvw6bqda2wu', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m3qdhiy2dbhilwu55ilb7hnxmcjpgya879m2tvspeoxnrpo96w','Cold Heart - PNAU Remix','lz7pr73ohgzh2vv','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u8vsrfirfh0eqt4egrdfc38zgqgsm849de1vzvtl4a5naydcbw', 'm3qdhiy2dbhilwu55ilb7hnxmcjpgya879m2tvspeoxnrpo96w', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o4xa9lbcdh085igdngd9esh84m4ccp9rhkio7jzxmrf4hn9ryq','Dont Start Now','lz7pr73ohgzh2vv','POP','3li9IOaMFu8S56r9uP6wcO','https://p.scdn.co/mp3-preview/cfc6684fc467e40bb9c7e6da2ea1b22eeccb211c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u8vsrfirfh0eqt4egrdfc38zgqgsm849de1vzvtl4a5naydcbw', 'o4xa9lbcdh085igdngd9esh84m4ccp9rhkio7jzxmrf4hn9ryq', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0rzg9p9nhhr5cezl9miuupret4qtp63g8hwyyhlfsnx6860gm9','Levitating (feat. DaBaby)','lz7pr73ohgzh2vv','POP','5nujrmhLynf4yMoMtj8AQF','https://p.scdn.co/mp3-preview/6af6db91dba9103cca41d6d5225f6fe120fcfcd3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u8vsrfirfh0eqt4egrdfc38zgqgsm849de1vzvtl4a5naydcbw', '0rzg9p9nhhr5cezl9miuupret4qtp63g8hwyyhlfsnx6860gm9', '3');
-- Adele
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('44nar319n5sw9bf', 'Adele', '199@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68f6e5892075d7f22615bd17','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:199@artist.com', '44nar319n5sw9bf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('44nar319n5sw9bf', 'Pioneering new paths in the musical landscape.', 'Adele');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ap9ijwbsjfnm1nooqj8dvtnr8nwpu44qwcftmxn9ddxzo8bdj8','44nar319n5sw9bf', 'https://i.scdn.co/image/ab67616d0000b2732118bf9b198b05a95ded6300', 'Adele Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2wpb4suprf3f4cjvfxlgic9cns3c6ldn33fd68dg2it43unshp','Set Fire to the Rain','44nar319n5sw9bf','POP','73CMRj62VK8nUS4ezD2wvi','https://p.scdn.co/mp3-preview/6fc68c105e091645376471727960d2ba3cd0ee01?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ap9ijwbsjfnm1nooqj8dvtnr8nwpu44qwcftmxn9ddxzo8bdj8', '2wpb4suprf3f4cjvfxlgic9cns3c6ldn33fd68dg2it43unshp', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hhzebjl55o7l24fq1sneoq7rrx6dgyi4rygg0wpy0sj5zrde61','Easy On Me','44nar319n5sw9bf','POP','46IZ0fSY2mpAiktS3KOqds','https://p.scdn.co/mp3-preview/a0cd8077c79a4aa3dcaa68bbc5ecdeda46e8d13f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ap9ijwbsjfnm1nooqj8dvtnr8nwpu44qwcftmxn9ddxzo8bdj8', 'hhzebjl55o7l24fq1sneoq7rrx6dgyi4rygg0wpy0sj5zrde61', '1');
-- Nile Rodgers
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z6a644hsoqjbrxg', 'Nile Rodgers', '200@artist.com', 'https://i.scdn.co/image/6511b1fe261da3b6c6b69ae2aa771cfd307a18ae','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:200@artist.com', 'z6a644hsoqjbrxg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z6a644hsoqjbrxg', 'Blending traditional rhythms with modern beats.', 'Nile Rodgers');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rdmjzwu4y1eosj0ltydl0d2z5d3gtqxf94h8drek7enmvlvn6w','z6a644hsoqjbrxg', NULL, 'Nile Rodgers Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('osh5fcqefvh7irabsr7ajmof3h8gjfqho64oz3zw7fiqfk9er3','UNFORGIVEN (feat. Nile Rodgers)','z6a644hsoqjbrxg','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rdmjzwu4y1eosj0ltydl0d2z5d3gtqxf94h8drek7enmvlvn6w', 'osh5fcqefvh7irabsr7ajmof3h8gjfqho64oz3zw7fiqfk9er3', '0');
-- Gustavo Mioto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1jjx0e0n5hbmayc', 'Gustavo Mioto', '201@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcec51a9ef6fe19159cb0452f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:201@artist.com', '1jjx0e0n5hbmayc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1jjx0e0n5hbmayc', 'Breathing new life into classic genres.', 'Gustavo Mioto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('m1nen85fdrxxlsenov6nid0zpktb6m851857f4hailhmftp1eh','1jjx0e0n5hbmayc', 'https://i.scdn.co/image/ab67616d0000b27319bb2fb697a42c1084d71f6c', 'Gustavo Mioto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c15d8g067gll1uoorg4iz359bsmkk8uslzpr31uajpgymrvdtr','Eu Gosto Assim - Ao Vivo','1jjx0e0n5hbmayc','POP','4ASA1PZyWGbuc4d9N8OAcF',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m1nen85fdrxxlsenov6nid0zpktb6m851857f4hailhmftp1eh', 'c15d8g067gll1uoorg4iz359bsmkk8uslzpr31uajpgymrvdtr', '0');
-- Niall Horan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e52f1fdlxf0c3h1', 'Niall Horan', '202@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeccc1cde8e9fdcf1c9289897','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:202@artist.com', 'e52f1fdlxf0c3h1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e52f1fdlxf0c3h1', 'Sculpting soundwaves into masterpieces of auditory art.', 'Niall Horan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5gpoezti4y0crf43gq7a1bfrnwia8s5fvyqd4l6yi3vyil173s','e52f1fdlxf0c3h1', 'https://i.scdn.co/image/ab67616d0000b2732a368fea49f5c489a9dc3949', 'Niall Horan Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qphkboeanbhzgvspepwo1n9a07hk0gtghkm9ztzyfu5ad46xen','Heaven','e52f1fdlxf0c3h1','POP','5FQ77Cl1ndljtwwImdtjMy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5gpoezti4y0crf43gq7a1bfrnwia8s5fvyqd4l6yi3vyil173s', 'qphkboeanbhzgvspepwo1n9a07hk0gtghkm9ztzyfu5ad46xen', '0');
-- Libianca
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('54wkncpc8vb5i8d', 'Libianca', '203@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a42e7c32ead029c0285c12f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:203@artist.com', '54wkncpc8vb5i8d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('54wkncpc8vb5i8d', 'A fresh talent, blending Afrobeat rhythms with soulful melodies.', 'Libianca');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('h26qn95xegbdqbnrvc234m4vgbvvsfoo8u5ib1vymm304wc5oi','54wkncpc8vb5i8d', 'https://i.scdn.co/image/ab67616d0000b273fc342f95f117d48dbdde9735', 'Libianca Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xr5q7byr1hq0yzima23y9qltp4hi4d0pkzgivl2ormcjhid3wa','People','54wkncpc8vb5i8d','POP','26b3oVLrRUaaybJulow9kz','https://p.scdn.co/mp3-preview/abcbc9adf10ae4901b40b80a30dc194d589c2d62?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h26qn95xegbdqbnrvc234m4vgbvvsfoo8u5ib1vymm304wc5oi', 'xr5q7byr1hq0yzima23y9qltp4hi4d0pkzgivl2ormcjhid3wa', '0');
-- Don Toliver
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7yve97x4keropkg', 'Don Toliver', '204@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:204@artist.com', '7yve97x4keropkg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7yve97x4keropkg', 'Blending traditional rhythms with modern beats.', 'Don Toliver');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zbxy97l02i4vfnbhfet7hnb4wu0ptwrux7xwjo81vcrnnagerr','7yve97x4keropkg', 'https://i.scdn.co/image/ab67616d0000b273feeff698e6090e6b02f21ec0', 'Don Toliver Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x214n1i36q2sfh7qrpg0swgxskizlw9fcedyuw7xh6n415vu06','Private Landing (feat. Justin Bieber & Future)','7yve97x4keropkg','POP','52NGJPcLUzQq5w7uv4e5gf','https://p.scdn.co/mp3-preview/511bdf681359f3b57dfa25344f34c2b66ecc4326?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zbxy97l02i4vfnbhfet7hnb4wu0ptwrux7xwjo81vcrnnagerr', 'x214n1i36q2sfh7qrpg0swgxskizlw9fcedyuw7xh6n415vu06', '0');
-- Dean Martin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f1oiwnygfec7aul', 'Dean Martin', '205@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdc6d54b08006b8896cb199e5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:205@artist.com', 'f1oiwnygfec7aul', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('f1oiwnygfec7aul', 'A journey through the spectrum of sound in every album.', 'Dean Martin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hmrrddtp6rdrg2luuabi152ys49gxgj57unh6z142f4ep71hcl','f1oiwnygfec7aul', 'https://i.scdn.co/image/ab67616d0000b2736d88028a85c771f37374c8ea', 'Dean Martin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kihn2imlymubjfuwy9qrkvwlc3kbicq5e0e3kfb7174gimjnjd','Let It Snow! Let It Snow! Let It Snow!','f1oiwnygfec7aul','POP','2uFaJJtFpPDc5Pa95XzTvg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hmrrddtp6rdrg2luuabi152ys49gxgj57unh6z142f4ep71hcl', 'kihn2imlymubjfuwy9qrkvwlc3kbicq5e0e3kfb7174gimjnjd', '0');
-- Rihanna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pf7p6jefjtd190f', 'Rihanna', '206@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:206@artist.com', 'pf7p6jefjtd190f', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pf7p6jefjtd190f', 'Creating a tapestry of tunes that celebrates diversity.', 'Rihanna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hwaqzbz74jo2zgtvtadxd2fa7wzez1wrcm9olxfplr547vtxbd','pf7p6jefjtd190f', 'https://i.scdn.co/image/ab67616d0000b273bef074de9ca825bddaeb9f46', 'Rihanna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s9sy2hc01yz2rxjxatar1mwe4ydlvf4uuat2ynbv154l856p98','We Found Love','pf7p6jefjtd190f','POP','6qn9YLKt13AGvpq9jfO8py',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hwaqzbz74jo2zgtvtadxd2fa7wzez1wrcm9olxfplr547vtxbd', 's9sy2hc01yz2rxjxatar1mwe4ydlvf4uuat2ynbv154l856p98', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d2j7h7uluexthsfuzycr9dlv9311kms3diqs6y88ikd2l6oboq','Lift Me Up - From Black Panther: Wakanda Forever - Music From and Inspired By','pf7p6jefjtd190f','POP','35ovElsgyAtQwYPYnZJECg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hwaqzbz74jo2zgtvtadxd2fa7wzez1wrcm9olxfplr547vtxbd', 'd2j7h7uluexthsfuzycr9dlv9311kms3diqs6y88ikd2l6oboq', '1');
-- Sam Smith
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vlog9cfpooffwa6', 'Sam Smith', '207@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0aa135d864bdcf4eb112112','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:207@artist.com', 'vlog9cfpooffwa6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vlog9cfpooffwa6', 'A soulful voice delivering deep emotional resonance.', 'Sam Smith');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pa68c831u40wn7nwvgyrhn6abpqucrw6cwqwz0ujc2r81w7v42','vlog9cfpooffwa6', 'https://i.scdn.co/image/ab67616d0000b273a935e4689f15953311772cc4', 'Sam Smith Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('24sfv5fhpj3tj0wrhutk14ywbtgwx55h9k918arqpzzwtnqgri','Unholy (feat. Kim Petras)','vlog9cfpooffwa6','POP','3nqQXoyQOWXiESFLlDF1hG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pa68c831u40wn7nwvgyrhn6abpqucrw6cwqwz0ujc2r81w7v42', '24sfv5fhpj3tj0wrhutk14ywbtgwx55h9k918arqpzzwtnqgri', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z450cn288i85bdrwiqkfkso7ykddnzkf2pahsz5y8wuj91ivxo','Im Not Here To Make Friends','vlog9cfpooffwa6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pa68c831u40wn7nwvgyrhn6abpqucrw6cwqwz0ujc2r81w7v42', 'z450cn288i85bdrwiqkfkso7ykddnzkf2pahsz5y8wuj91ivxo', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4hiny6gppfrtoi5pcd0f8nbkgt3xoekd4nwjrxc1kwj3mhe30c','Im Not The Only One','vlog9cfpooffwa6','POP','5RYtz3cpYb28SV8f1FBtGc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pa68c831u40wn7nwvgyrhn6abpqucrw6cwqwz0ujc2r81w7v42', '4hiny6gppfrtoi5pcd0f8nbkgt3xoekd4nwjrxc1kwj3mhe30c', '2');
-- Justin Bieber
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3dq2p8ana5y2g0e', 'Justin Bieber', '208@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:208@artist.com', '3dq2p8ana5y2g0e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3dq2p8ana5y2g0e', 'From teen idol to global pop star, constantly evolving his sound.', 'Justin Bieber');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vvtkcmg1dduoaxll17uf5f7fn5ytc453p5s03of8sws0xvne4u','3dq2p8ana5y2g0e', NULL, 'Justin Bieber Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0cgn9t8krg2kfv4ll4oo8c6yupp3v74fvg8zdl63kemz8jtf6m','STAY (with Justin Bieber)','3dq2p8ana5y2g0e','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vvtkcmg1dduoaxll17uf5f7fn5ytc453p5s03of8sws0xvne4u', '0cgn9t8krg2kfv4ll4oo8c6yupp3v74fvg8zdl63kemz8jtf6m', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kn51cgelf0dvgzu5tzpnfn9x6jz1e54x7i34rh7qaa6al5mjam','Ghost','3dq2p8ana5y2g0e','POP','6I3mqTwhRpn34SLVafSH7G',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vvtkcmg1dduoaxll17uf5f7fn5ytc453p5s03of8sws0xvne4u', 'kn51cgelf0dvgzu5tzpnfn9x6jz1e54x7i34rh7qaa6al5mjam', '1');
-- Bad Bunny
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w0s753qbu65d2x3', 'Bad Bunny', '209@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9ad50e478a469448c6f369df','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:209@artist.com', 'w0s753qbu65d2x3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w0s753qbu65d2x3', 'A trailblazer in Latin trap and reggaeton, known for his charismatic style and innovative music.', 'Bad Bunny');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5x3uv562epx1bsqiv0nkuzed5x2ouysu8kkoqjiv9n313gd7rt','w0s753qbu65d2x3', 'https://i.scdn.co/image/ab67616d0000b273ab5c9cd818ad6ed3e9b79cd1', 'Bad Bunny Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kgwe4nwo2mcmaoxzmam7b7owz6nc2hjdz0s1i8ox7wbsy0p3w2','WHERE SHE GOES','w0s753qbu65d2x3','POP','7ro0hRteUMfnOioTFI5TG1','https://p.scdn.co/mp3-preview/b9b7e4c982b33ee23c4867f7a3025e3598c35760?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5x3uv562epx1bsqiv0nkuzed5x2ouysu8kkoqjiv9n313gd7rt', 'kgwe4nwo2mcmaoxzmam7b7owz6nc2hjdz0s1i8ox7wbsy0p3w2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ui0ux19efr74kxjzv8ue88henvkclsxj5jrac9gi2sdz1yx39t','un x100to','w0s753qbu65d2x3','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5x3uv562epx1bsqiv0nkuzed5x2ouysu8kkoqjiv9n313gd7rt', 'ui0ux19efr74kxjzv8ue88henvkclsxj5jrac9gi2sdz1yx39t', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tfvtaajuwwqb96hmf55sxi66b81zqn34fh6nzh2mpv84gnrmob','Coco Chanel','w0s753qbu65d2x3','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5x3uv562epx1bsqiv0nkuzed5x2ouysu8kkoqjiv9n313gd7rt', 'tfvtaajuwwqb96hmf55sxi66b81zqn34fh6nzh2mpv84gnrmob', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6dk4y8hbhy7y4zxaby25t4u8nhknwz2ibdqqo0hi5shspqiw7t','Titi Me Pregunt','w0s753qbu65d2x3','POP','1IHWl5LamUGEuP4ozKQSXZ','https://p.scdn.co/mp3-preview/53a6217761f8fdfcff92189cafbbd1cc21fdb813?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5x3uv562epx1bsqiv0nkuzed5x2ouysu8kkoqjiv9n313gd7rt', '6dk4y8hbhy7y4zxaby25t4u8nhknwz2ibdqqo0hi5shspqiw7t', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nwuo3pb19gzfpd4il2ly40r21w2p37qbid4hk063i9ti2kh4qy','Efecto','w0s753qbu65d2x3','POP','5Eax0qFko2dh7Rl2lYs3bx','https://p.scdn.co/mp3-preview/a622a47c8df98ef72676608511c0b2e1d5d51268?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5x3uv562epx1bsqiv0nkuzed5x2ouysu8kkoqjiv9n313gd7rt', 'nwuo3pb19gzfpd4il2ly40r21w2p37qbid4hk063i9ti2kh4qy', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1za05ufq9zii7i2s516ry3di8aelmnqdm0ays1ezihk3s4xjii','Neverita','w0s753qbu65d2x3','POP','31i56LZnwE6uSu3exoHjtB','https://p.scdn.co/mp3-preview/b50a3cafa2eb688f811d4079812649bfba050417?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5x3uv562epx1bsqiv0nkuzed5x2ouysu8kkoqjiv9n313gd7rt', '1za05ufq9zii7i2s516ry3di8aelmnqdm0ays1ezihk3s4xjii', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5nows23jfdvfclxfdwv00cu5mjdgptqujyt194rfh7bm4tdvhw','Moscow Mule','w0s753qbu65d2x3','POP','6Xom58OOXk2SoU711L2IXO','https://p.scdn.co/mp3-preview/77b12f38abcff65705166d67b5657f70cd890635?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5x3uv562epx1bsqiv0nkuzed5x2ouysu8kkoqjiv9n313gd7rt', '5nows23jfdvfclxfdwv00cu5mjdgptqujyt194rfh7bm4tdvhw', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dozsnoqnrrsy1it84uh7a8sk8hk3vbjm9oag3s0ietjusbye3p','Yonaguni','w0s753qbu65d2x3','POP','2JPLbjOn0wPCngEot2STUS','https://p.scdn.co/mp3-preview/cbade9b0e669565ac8c7c07490f961e4c471b9ee?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5x3uv562epx1bsqiv0nkuzed5x2ouysu8kkoqjiv9n313gd7rt', 'dozsnoqnrrsy1it84uh7a8sk8hk3vbjm9oag3s0ietjusbye3p', '7');
-- Lil Nas X
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d0h72o1nbv6yk20', 'Lil Nas X', '210@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd66f1e0c883f319443d68c45','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:210@artist.com', 'd0h72o1nbv6yk20', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('d0h72o1nbv6yk20', 'A journey through the spectrum of sound in every album.', 'Lil Nas X');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('drhj1srqg0kyyhvk37yksbl5s4f35y78zcaqp6l700c63mrsdv','d0h72o1nbv6yk20', 'https://i.scdn.co/image/ab67616d0000b27304cd9a1664fb4539a55643fe', 'Lil Nas X Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rd67zn7a67z9j9vuumvvwfvl0r2ofinl11we24rgj8bif5e2pi','STAR WALKIN (League of Legends Worlds Anthem)','d0h72o1nbv6yk20','POP','38T0tPVZHcPZyhtOcCP7pF','https://p.scdn.co/mp3-preview/ffa9d53ff1f83a322ac0523d7a6ce13b231e4a3a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('drhj1srqg0kyyhvk37yksbl5s4f35y78zcaqp6l700c63mrsdv', 'rd67zn7a67z9j9vuumvvwfvl0r2ofinl11we24rgj8bif5e2pi', '0');
-- Travis Scott
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q5v6zuzc7xdujct', 'Travis Scott', '211@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:211@artist.com', 'q5v6zuzc7xdujct', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q5v6zuzc7xdujct', 'A visionary in the world of music, redefining genres.', 'Travis Scott');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lxlmv9g2bp0h1b02q34y5gtpziv4w955n1ci2pyz431nv7pggf','q5v6zuzc7xdujct', NULL, 'Travis Scott Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d0n59p55h7s3bqbf4k5zzoxhginczwwj1rarl6y8s4c20r7kcg','Trance (with Travis Scott & Young Thug)','q5v6zuzc7xdujct','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lxlmv9g2bp0h1b02q34y5gtpziv4w955n1ci2pyz431nv7pggf', 'd0n59p55h7s3bqbf4k5zzoxhginczwwj1rarl6y8s4c20r7kcg', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uisb5sxywcx5pey3u2qum6wv6ytzwxmsq2rlc3irh31utc5tl7','Niagara Falls (Foot or 2) [with Travis Scott & 21 Savage]','q5v6zuzc7xdujct','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lxlmv9g2bp0h1b02q34y5gtpziv4w955n1ci2pyz431nv7pggf', 'uisb5sxywcx5pey3u2qum6wv6ytzwxmsq2rlc3irh31utc5tl7', '1');
-- BTS
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('14bxm9a1sm77hte', 'BTS', '212@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd642648235ebf3460d2d1f6a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:212@artist.com', '14bxm9a1sm77hte', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('14bxm9a1sm77hte', 'A global phenomenon, setting new standards in K-pop with their music and performances.', 'BTS');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('r10woxbdmb22w9o0zhqnsm1var0gbtb6jwagw4zxdpsxyn3zmx','14bxm9a1sm77hte', 'https://i.scdn.co/image/ab67616d0000b2738a701e76e8845928f6cd81c8', 'BTS Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('loba7mmjlo79auc1z4trmt3wqqvt9n5sm2unjnoujth1bo7we3','Take Two','14bxm9a1sm77hte','POP','5IAESfJjmOYu7cHyX557kz','https://p.scdn.co/mp3-preview/ef43da30a06fcad16898e9fff1cadd0ccf953fc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r10woxbdmb22w9o0zhqnsm1var0gbtb6jwagw4zxdpsxyn3zmx', 'loba7mmjlo79auc1z4trmt3wqqvt9n5sm2unjnoujth1bo7we3', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j20vhy8tfzbs976swv7xoucivm5z4rm52rfd53co0vtfiy4sav','Dreamers [Music from the FIFA World Cup Qatar 2022 Official Soundtrack]','14bxm9a1sm77hte','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r10woxbdmb22w9o0zhqnsm1var0gbtb6jwagw4zxdpsxyn3zmx', 'j20vhy8tfzbs976swv7xoucivm5z4rm52rfd53co0vtfiy4sav', '1');
-- Natanael Cano
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('i4wsyaew4h56nfs', 'Natanael Cano', '213@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0819edd43096a2f0dde7cd44','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:213@artist.com', 'i4wsyaew4h56nfs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('i4wsyaew4h56nfs', 'Melodies that capture the essence of human emotion.', 'Natanael Cano');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7a8nmqjwq1ah8o9thmp5rtmlph4emmcg1gak52eiqlxcr5rnig','i4wsyaew4h56nfs', 'https://i.scdn.co/image/ab67616d0000b273e2e093427065eaca9e2f2970', 'Natanael Cano Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t6v3hle8m79ygtv7lliinra4w6ukxuufz11u3pkqr9b6cbtjug','Mi Bello Angel','i4wsyaew4h56nfs','POP','4t46soaqA758rbukTO5pp1','https://p.scdn.co/mp3-preview/07854d155311327027a073aeb36f0f61cdb07096?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7a8nmqjwq1ah8o9thmp5rtmlph4emmcg1gak52eiqlxcr5rnig', 't6v3hle8m79ygtv7lliinra4w6ukxuufz11u3pkqr9b6cbtjug', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nu0gi8e60d88n13a5bki6kfzgtpefcpb7znd2h18pifk3quuvg','PRC','i4wsyaew4h56nfs','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7a8nmqjwq1ah8o9thmp5rtmlph4emmcg1gak52eiqlxcr5rnig', 'nu0gi8e60d88n13a5bki6kfzgtpefcpb7znd2h18pifk3quuvg', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ekos1hnq637csnd0xuonuf0vx8srh4mwdfs35cqghy26xit873','AMG','i4wsyaew4h56nfs','POP','1lRtH4FszTrwwlK5gTSbXO','https://p.scdn.co/mp3-preview/2a54eb02ee2a7e8c47c6107f16272a19a0e6362b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7a8nmqjwq1ah8o9thmp5rtmlph4emmcg1gak52eiqlxcr5rnig', 'ekos1hnq637csnd0xuonuf0vx8srh4mwdfs35cqghy26xit873', '2');
-- Semicenk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('50wjbwk0cz6vyev', 'Semicenk', '214@artist.com', 'https://i.scdn.co/image/ab67616d0000b2730b8da935d3ba07f14f01eb32','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:214@artist.com', '50wjbwk0cz6vyev', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('50wjbwk0cz6vyev', 'Where words fail, my music speaks.', 'Semicenk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('82xc9csunsevmtll8iyvww4ybcoc5t8718tqfuazp012pmjtcb','50wjbwk0cz6vyev', NULL, 'Semicenk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p14yvyegc0jvtp6wrzhv10j98rg68pmf3mksigvva898a0l0fv','Piman De','50wjbwk0cz6vyev','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('82xc9csunsevmtll8iyvww4ybcoc5t8718tqfuazp012pmjtcb', 'p14yvyegc0jvtp6wrzhv10j98rg68pmf3mksigvva898a0l0fv', '0');
-- Calvin Harris
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nrzpl4fyg05pzrp', 'Calvin Harris', '215@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb37bff6aa1d42bede9048750f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:215@artist.com', 'nrzpl4fyg05pzrp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nrzpl4fyg05pzrp', 'Crafting a unique sonic identity in every track.', 'Calvin Harris');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('joccnt10uc42ksmpa2z9fhttxekui62dy80y51bo78xwuxwy10','nrzpl4fyg05pzrp', 'https://i.scdn.co/image/ab67616d0000b273c58e22815048f8dfb1aa8bd0', 'Calvin Harris Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('io6lrugkmkfjxfvfkdjo3r5l1la1cavwq4learbauvmmq8z64o','Miracle (with Ellie Goulding)','nrzpl4fyg05pzrp','POP','5eTaQYBE1yrActixMAeLcZ','https://p.scdn.co/mp3-preview/48a88093bc85e735791115290125fc354f8ed068?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('joccnt10uc42ksmpa2z9fhttxekui62dy80y51bo78xwuxwy10', 'io6lrugkmkfjxfvfkdjo3r5l1la1cavwq4learbauvmmq8z64o', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d7s3ejwsgoopcmc5qn95q94f5m77bmfh445p372vertcde66kw','One Kiss (with Dua Lipa)','nrzpl4fyg05pzrp','POP','7ef4DlsgrMEH11cDZd32M6','https://p.scdn.co/mp3-preview/0c09da1fe6f1da091c05057835e6be2312e2dc18?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('joccnt10uc42ksmpa2z9fhttxekui62dy80y51bo78xwuxwy10', 'd7s3ejwsgoopcmc5qn95q94f5m77bmfh445p372vertcde66kw', '1');
-- Kate Bush
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xqa2oudaurme9yo', 'Kate Bush', '216@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb187017724e58e78ee1f5a8e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:216@artist.com', 'xqa2oudaurme9yo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xqa2oudaurme9yo', 'A beacon of innovation in the world of sound.', 'Kate Bush');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('h3mxtan7tyamou94f78x7iup1g5skdqfqqj6yxvpudb1kx9534','xqa2oudaurme9yo', 'https://i.scdn.co/image/ab67616d0000b273ad08f4b38efbff0c0da0f252', 'Kate Bush Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wme9f0pr0zmmazw80xtcorudyxdfzqf5s0m3oyaxt2kkiq68m6','Running Up That Hill (A Deal With God)','xqa2oudaurme9yo','POP','1PtQJZVZIdWIYdARpZRDFO','https://p.scdn.co/mp3-preview/861d26b52ece3e3ad72a7dc3463daece3478801a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h3mxtan7tyamou94f78x7iup1g5skdqfqqj6yxvpudb1kx9534', 'wme9f0pr0zmmazw80xtcorudyxdfzqf5s0m3oyaxt2kkiq68m6', '0');
-- Lady Gaga
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x6j51d2iaofwxva', 'Lady Gaga', '217@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc8d3d98a1bccbe71393dbfbf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:217@artist.com', 'x6j51d2iaofwxva', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x6j51d2iaofwxva', 'A symphony of emotions expressed through sound.', 'Lady Gaga');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ur1ditxsm1k013tyn5j5flc2dpl186c0ylg8n113dh2yfmkxr9','x6j51d2iaofwxva', 'https://i.scdn.co/image/ab67616d0000b273a47c0e156ea3cebe37fdcab8', 'Lady Gaga Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l3z6ait3gkg56nai2qpsqsokyzqpgdj2u4vhabltq7h1omqdmc','Bloody Mary','x6j51d2iaofwxva','POP','11BKm0j4eYoCPPpCONAVwA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ur1ditxsm1k013tyn5j5flc2dpl186c0ylg8n113dh2yfmkxr9', 'l3z6ait3gkg56nai2qpsqsokyzqpgdj2u4vhabltq7h1omqdmc', '0');
-- Lana Del Rey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('entgfu86v5914tl', 'Lana Del Rey', '218@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb99cacf8acd5378206767261','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:218@artist.com', 'entgfu86v5914tl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('entgfu86v5914tl', 'An ethereal presence in music, known for her cinematic and nostalgic sound.', 'Lana Del Rey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('an9ofc58uho668ba0387vofexfcf04jgqvfkzkau6h8gdv1x4r','entgfu86v5914tl', 'https://i.scdn.co/image/ab67616d0000b273aa27708d07f49c82ff0d0dae', 'Lana Del Rey Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rlj7u6yd8rcv6qsv7wbhfj1qcf70k4xiwynlmqam5dpijh1vhu','Say Yes To Heaven','entgfu86v5914tl','POP','6GGtHZgBycCgGBUhZo81xe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('an9ofc58uho668ba0387vofexfcf04jgqvfkzkau6h8gdv1x4r', 'rlj7u6yd8rcv6qsv7wbhfj1qcf70k4xiwynlmqam5dpijh1vhu', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1zub63knm505b4fi9lb5ytclz2yfyfyb3c38zmpxf3ifyz32gl','Summertime Sadness','entgfu86v5914tl','POP','1Ist6PR2BZR3n2z2Y5R6S1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('an9ofc58uho668ba0387vofexfcf04jgqvfkzkau6h8gdv1x4r', '1zub63knm505b4fi9lb5ytclz2yfyfyb3c38zmpxf3ifyz32gl', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('b43qns89y04qcsf98phgr4cg3i2az4oy9qdui4i4khb3pupldk','Radio','entgfu86v5914tl','POP','3QhfFRPkhPCR1RMJWV1gde',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('an9ofc58uho668ba0387vofexfcf04jgqvfkzkau6h8gdv1x4r', 'b43qns89y04qcsf98phgr4cg3i2az4oy9qdui4i4khb3pupldk', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ttoy51xzyjs7sddi08o7zcbs1dgihbgy00oa3c9sagdbcx51uy','Snow On The Beach (feat. More Lana Del Rey)','entgfu86v5914tl','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('an9ofc58uho668ba0387vofexfcf04jgqvfkzkau6h8gdv1x4r', 'ttoy51xzyjs7sddi08o7zcbs1dgihbgy00oa3c9sagdbcx51uy', '3');
-- Feid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z4x6aqlh951t24w', 'Feid', '219@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0a248d29f8faa91f971e5cae','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:219@artist.com', 'z4x6aqlh951t24w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z4x6aqlh951t24w', 'A standout artist in urban Latin music, known for his catchy melodies and smooth vocals.', 'Feid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('z8lsvd6wis35d3c60fxr20b8r8rs9tzda8d0kbdrscanzw6uut','z4x6aqlh951t24w', 'https://i.scdn.co/image/ab67616d0000b27329ebee2b5fb008871fcd201a', 'Feid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0309bhk9itao26pyp05jaqu03yefmkjdivmur76i74edyg6i9u','Classy 101','z4x6aqlh951t24w','POP','6XSqqQIy7Lm7SnwxS4NrGx',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z8lsvd6wis35d3c60fxr20b8r8rs9tzda8d0kbdrscanzw6uut', '0309bhk9itao26pyp05jaqu03yefmkjdivmur76i74edyg6i9u', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('meyjkbrg8n1xxpk8lnqgioeicl11x2hjzgla1j0pgmotylx7jt','El Cielo','z4x6aqlh951t24w','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z8lsvd6wis35d3c60fxr20b8r8rs9tzda8d0kbdrscanzw6uut', 'meyjkbrg8n1xxpk8lnqgioeicl11x2hjzgla1j0pgmotylx7jt', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jylvw2tj7og5get9ang4rlry1jwo6d4znbymt546nb3hiyrpfi','Feliz Cumpleaos Fe','z4x6aqlh951t24w','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z8lsvd6wis35d3c60fxr20b8r8rs9tzda8d0kbdrscanzw6uut', 'jylvw2tj7og5get9ang4rlry1jwo6d4znbymt546nb3hiyrpfi', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0p5jhy9ii2uboc44o6t5o5axxlhtmbaj616d9uj6m90bmqxxy5','POLARIS - Remix','z4x6aqlh951t24w','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z8lsvd6wis35d3c60fxr20b8r8rs9tzda8d0kbdrscanzw6uut', '0p5jhy9ii2uboc44o6t5o5axxlhtmbaj616d9uj6m90bmqxxy5', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p54vkjicjp6o0eus814hw1lfft4053548e1iziix5ox6i02oov','CHORRITO PA LAS ANIMAS','z4x6aqlh951t24w','POP','0CYTGMBYkwUxrj1MWDLrC5',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z8lsvd6wis35d3c60fxr20b8r8rs9tzda8d0kbdrscanzw6uut', 'p54vkjicjp6o0eus814hw1lfft4053548e1iziix5ox6i02oov', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bwct3kx25ws2i9ey7efewyue9onxsdnt3gdgmtcwl13s1v49pi','Normal','z4x6aqlh951t24w','POP','0T2pB7P1VdXPhLdQZ488uH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z8lsvd6wis35d3c60fxr20b8r8rs9tzda8d0kbdrscanzw6uut', 'bwct3kx25ws2i9ey7efewyue9onxsdnt3gdgmtcwl13s1v49pi', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c6t9heodnut5jflr7nixeyme0hvg98vi6q4wv0hjg15elb0lyu','REMIX EXCLUSIVO','z4x6aqlh951t24w','POP','3eqCJfgJJs8iKx49KO12s3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z8lsvd6wis35d3c60fxr20b8r8rs9tzda8d0kbdrscanzw6uut', 'c6t9heodnut5jflr7nixeyme0hvg98vi6q4wv0hjg15elb0lyu', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lcq4o9grzmmynqt8dz3h5o69v6oxgw1h7g5kon4m5wxy2o0gm3','LA INOCENTE','z4x6aqlh951t24w','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z8lsvd6wis35d3c60fxr20b8r8rs9tzda8d0kbdrscanzw6uut', 'lcq4o9grzmmynqt8dz3h5o69v6oxgw1h7g5kon4m5wxy2o0gm3', '7');
-- RAYE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9llckzpiniyodfx', 'RAYE', '220@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0550f0badff3ad04802b1e86','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:220@artist.com', '9llckzpiniyodfx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9llckzpiniyodfx', 'Pioneering new paths in the musical landscape.', 'RAYE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('12jxitx6mzvmdwi5sk82n3srqgjszkm2uja7qmmrgqa18eejl6','9llckzpiniyodfx', 'https://i.scdn.co/image/ab67616d0000b27394e5237ce925531dbb38e75f', 'RAYE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yn12h9tixlxrw6unm4q9ah0emxen63xc3kxh4s57ysuuzwq9hj','Escapism.','9llckzpiniyodfx','POP','5mHdCZtVyb4DcJw8799hZp','https://p.scdn.co/mp3-preview/8a8fcaf9ddf050562048d1632ddc880c9ce7c972?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('12jxitx6mzvmdwi5sk82n3srqgjszkm2uja7qmmrgqa18eejl6', 'yn12h9tixlxrw6unm4q9ah0emxen63xc3kxh4s57ysuuzwq9hj', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oi6e7uj2lsl7hn698ug0kvmm4lv54qpshjxkxsibp9y3lwgscv','Escapism. - Sped Up','9llckzpiniyodfx','POP','3XCpS4k8WqNnCpcDOSRRuz','https://p.scdn.co/mp3-preview/22be59e4d5da403513e02e90c27bc1d0965b5f1f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('12jxitx6mzvmdwi5sk82n3srqgjszkm2uja7qmmrgqa18eejl6', 'oi6e7uj2lsl7hn698ug0kvmm4lv54qpshjxkxsibp9y3lwgscv', '1');
-- d4vd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vn4zkg9pcdqppii', 'd4vd', '221@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad447187a35f422307e88ad3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:221@artist.com', 'vn4zkg9pcdqppii', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vn4zkg9pcdqppii', 'Harnessing the power of melody to tell compelling stories.', 'd4vd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zkze0sdjd9h89br2jfg6p8cadqsimeqzulki2iupx1a8kt85oq','vn4zkg9pcdqppii', 'https://i.scdn.co/image/ab67616d0000b27364fa1bda999f4fbd2b7c4bb7', 'd4vd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n13p77gmxbv1eo1oxw7vddw8mxk47q79r3k713z1agff5mq36q','Here With Me','vn4zkg9pcdqppii','POP','5LrN7yUQAzvthd4QujgPFr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zkze0sdjd9h89br2jfg6p8cadqsimeqzulki2iupx1a8kt85oq', 'n13p77gmxbv1eo1oxw7vddw8mxk47q79r3k713z1agff5mq36q', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rp66y2goonhgguqcbomaq6i9rpif3fjb639m2566k5brrxp3d6','Romantic Homicide','vn4zkg9pcdqppii','POP','1xK59OXxi2TAAAbmZK0kBL',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zkze0sdjd9h89br2jfg6p8cadqsimeqzulki2iupx1a8kt85oq', 'rp66y2goonhgguqcbomaq6i9rpif3fjb639m2566k5brrxp3d6', '1');
-- Arijit Singh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c66xrygfmspt0zq', 'Arijit Singh', '222@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0261696c5df3be99da6ed3f3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:222@artist.com', 'c66xrygfmspt0zq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c66xrygfmspt0zq', 'Igniting the stage with electrifying performances.', 'Arijit Singh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3eq6fisixoad05xmmt3set9jnsky4zs3gn4b03v16lmb2q36pg','c66xrygfmspt0zq', NULL, 'Arijit Singh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('71chf1ubzeewvfc511cd3np3g6181fmdpzs7cz0cyz1yc09zpi','Phir Aur Kya Chahiye (From "Zara Hatke Zara Bachke")','c66xrygfmspt0zq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3eq6fisixoad05xmmt3set9jnsky4zs3gn4b03v16lmb2q36pg', '71chf1ubzeewvfc511cd3np3g6181fmdpzs7cz0cyz1yc09zpi', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a57673hgodctqwni0xzhrf5py8q4knjhrdm1cc7c2scd32sr5j','Apna Bana Le (From "Bhediya")','c66xrygfmspt0zq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3eq6fisixoad05xmmt3set9jnsky4zs3gn4b03v16lmb2q36pg', 'a57673hgodctqwni0xzhrf5py8q4knjhrdm1cc7c2scd32sr5j', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sinn41mf9ugabx57wm0z68x7hwg91xrdcx4qnza31sygwz84xd','Jhoome Jo Pathaan','c66xrygfmspt0zq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3eq6fisixoad05xmmt3set9jnsky4zs3gn4b03v16lmb2q36pg', 'sinn41mf9ugabx57wm0z68x7hwg91xrdcx4qnza31sygwz84xd', '2');
-- Coolio
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vuiosshzuro3kv1', 'Coolio', '223@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5ea53fc78df8f7e7559e228d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:223@artist.com', 'vuiosshzuro3kv1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vuiosshzuro3kv1', 'Music is my canvas, and notes are my paint.', 'Coolio');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('aqjz5o5dihr7bxkqv8cjm2r97y48i67ivk6xafcnwxq8dq7rf8','vuiosshzuro3kv1', 'https://i.scdn.co/image/ab67616d0000b273c31d3c870a3dbaf7b53186cc', 'Coolio Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t026mvwzcp42u61nfardj2c9nplypyrhqmqfloa651sy2hnf3l','Gangstas Paradise','vuiosshzuro3kv1','POP','1DIXPcTDzTj8ZMHt3PDt8p','https://p.scdn.co/mp3-preview/1454c63a66c27ac745f874d6c113270a9c62d28e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('aqjz5o5dihr7bxkqv8cjm2r97y48i67ivk6xafcnwxq8dq7rf8', 't026mvwzcp42u61nfardj2c9nplypyrhqmqfloa651sy2hnf3l', '0');
-- Agust D
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sa5qbuqf2kei1d0', 'Agust D', '224@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb191d43dca6f2f5a126e43e4b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:224@artist.com', 'sa5qbuqf2kei1d0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sa5qbuqf2kei1d0', 'Breathing new life into classic genres.', 'Agust D');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uzghwvs3ud2ilbk4jdkm1mmi5iygzh5e01v7nnb3xwkcf0g1s4','sa5qbuqf2kei1d0', 'https://i.scdn.co/image/ab67616d0000b273fa9247b68471b82d2125651e', 'Agust D Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lckdsiymbjq0ps9hhdivxmnzmoeqlyu4barvxew9zcmf7l0wkk','Haegeum','sa5qbuqf2kei1d0','POP','4bjN59DRXFRxBE1g5ne6B1','https://p.scdn.co/mp3-preview/3c2f1894de0f6a51f557131c3eb275cb8bc80831?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uzghwvs3ud2ilbk4jdkm1mmi5iygzh5e01v7nnb3xwkcf0g1s4', 'lckdsiymbjq0ps9hhdivxmnzmoeqlyu4barvxew9zcmf7l0wkk', '0');
-- TOMORROW X TOGETHER
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wgpgwwafvyhp22y', 'TOMORROW X TOGETHER', '225@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8b446e5bd3820ac772155b31','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:225@artist.com', 'wgpgwwafvyhp22y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wgpgwwafvyhp22y', 'Sculpting soundwaves into masterpieces of auditory art.', 'TOMORROW X TOGETHER');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6i75ub7qf6239o5h4fnvgma714eas211lnqeo1a7l4m2e9jn86','wgpgwwafvyhp22y', 'https://i.scdn.co/image/ab67616d0000b2733bb056e3160b85ee86c1194d', 'TOMORROW X TOGETHER Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e1zd9oal3t4kdu615mg5tr2mikd8gf1cqkbcw15bzht3lk1c7x','Sugar Rush Ride','wgpgwwafvyhp22y','POP','0rhI6gvOeCKA502RdJAbfs','https://p.scdn.co/mp3-preview/691f502777012a09541b5265cfddaa4401470759?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6i75ub7qf6239o5h4fnvgma714eas211lnqeo1a7l4m2e9jn86', 'e1zd9oal3t4kdu615mg5tr2mikd8gf1cqkbcw15bzht3lk1c7x', '0');
-- Daddy Yankee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('p0xbqnvxrimrsyc', 'Daddy Yankee', '226@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf9ad208bbff79c1ce09c77c1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:226@artist.com', 'p0xbqnvxrimrsyc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('p0xbqnvxrimrsyc', 'Striking chords that resonate across generations.', 'Daddy Yankee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3ukxoyrycwj9j304qatxcamvdeka9z9vscn7y1n9uxcvw4u080','p0xbqnvxrimrsyc', 'https://i.scdn.co/image/ab67616d0000b2736bdcdf82ecce36bff808a40c', 'Daddy Yankee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pywdqsf4xvofu3ujxjoqe4v5t2ksmlyyt5w0s619iwqz0l6udy','Gasolina','p0xbqnvxrimrsyc','POP','228BxWXUYQPJrJYHDLOHkj','https://p.scdn.co/mp3-preview/7c545be6847f3a6b13c4ad9c70d10a34f49a92d3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3ukxoyrycwj9j304qatxcamvdeka9z9vscn7y1n9uxcvw4u080', 'pywdqsf4xvofu3ujxjoqe4v5t2ksmlyyt5w0s619iwqz0l6udy', '0');
-- Sabrina Carpenter
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s9b1cmzfhppcgme', 'Sabrina Carpenter', '227@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb00e540b760b56d02cc415c47','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:227@artist.com', 's9b1cmzfhppcgme', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s9b1cmzfhppcgme', 'Igniting the stage with electrifying performances.', 'Sabrina Carpenter');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('b0ta2fulds7h06ynx17sc5pf90wwp2lnxshx1iwyher5635ic2','s9b1cmzfhppcgme', 'https://i.scdn.co/image/ab67616d0000b273700f7bf79c9f063ad0362bdf', 'Sabrina Carpenter Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('evsus8h8nghfhdcpl1gk3xs1qervidoekhxmozz4s5m49gkwfw','Nonsense','s9b1cmzfhppcgme','POP','6dgUya35uo964z7GZXM07g',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('b0ta2fulds7h06ynx17sc5pf90wwp2lnxshx1iwyher5635ic2', 'evsus8h8nghfhdcpl1gk3xs1qervidoekhxmozz4s5m49gkwfw', '0');
-- Freddie Dredd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rsm6ze9nc0cgybo', 'Freddie Dredd', '228@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9d100e5a9cf34beab8e75750','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:228@artist.com', 'rsm6ze9nc0cgybo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rsm6ze9nc0cgybo', 'Breathing new life into classic genres.', 'Freddie Dredd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('h67quvlqx5b65e9bde9vylzk5oiqsez8ytyt9myerddpwro9wr','rsm6ze9nc0cgybo', 'https://i.scdn.co/image/ab67616d0000b27369b381d574b329409bd806e6', 'Freddie Dredd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('necdsqrccwraqegrwg1w42k7zu0bz9urbgmdeud6p2efd6oou7','Limbo','rsm6ze9nc0cgybo','POP','37F7E7BKEw2E4O2L7u0IEp','https://p.scdn.co/mp3-preview/1715e2acb52d6fdd0e4b11ea8792688c12987ff7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h67quvlqx5b65e9bde9vylzk5oiqsez8ytyt9myerddpwro9wr', 'necdsqrccwraqegrwg1w42k7zu0bz9urbgmdeud6p2efd6oou7', '0');
-- Styrx
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fdpexz86gxsjgyy', 'Styrx', '229@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfef3008e708e59efaa5667ed','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:229@artist.com', 'fdpexz86gxsjgyy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fdpexz86gxsjgyy', 'An endless quest for musical perfection.', 'Styrx');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('f6a0mh6mslnzuw9b50dvdv8j56gepk2xkfyfrfljrf327ztivy','fdpexz86gxsjgyy', NULL, 'Styrx Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a24hhhgkzwilpyhf1m0fz13ngtd9eyj3tspbgzvkj40918hjho','Agudo Mgi','fdpexz86gxsjgyy','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6a0mh6mslnzuw9b50dvdv8j56gepk2xkfyfrfljrf327ztivy', 'a24hhhgkzwilpyhf1m0fz13ngtd9eyj3tspbgzvkj40918hjho', '0');
-- Jack Harlow
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fu136hu0mfkup1h', 'Jack Harlow', '230@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5ee4635b0775e342e064657','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:230@artist.com', 'fu136hu0mfkup1h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fu136hu0mfkup1h', 'Pioneering new paths in the musical landscape.', 'Jack Harlow');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y9u5a8lq3pzh523sxrl1nzmogbdmy7g6x1osgq3mazhty5og93','fu136hu0mfkup1h', NULL, 'Jack Harlow Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7rx2xrmvpsnpqvm72th8k8lw6is1perw3kf9hmvbqlxeg4wv8m','INDUSTRY BABY (feat. Jack Harlow)','fu136hu0mfkup1h','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y9u5a8lq3pzh523sxrl1nzmogbdmy7g6x1osgq3mazhty5og93', '7rx2xrmvpsnpqvm72th8k8lw6is1perw3kf9hmvbqlxeg4wv8m', '0');
-- Yuridia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gcrbmnbmy2whs26', 'Yuridia', '231@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb238b537cb702308e59f709bf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:231@artist.com', 'gcrbmnbmy2whs26', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gcrbmnbmy2whs26', 'A tapestry of rhythms that echo the pulse of life.', 'Yuridia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7ij6rb2puaf645n6ez0u2n92uhts6zcl82f703nwz0lpmor80e','gcrbmnbmy2whs26', 'https://i.scdn.co/image/ab67616d0000b2732e9425d8413217cc2942cacf', 'Yuridia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tdgafpvkzi5xf93ml9dgodmwneyogoj8n2j5xcdtpqwuatec1f','Qu Ago','gcrbmnbmy2whs26','POP','4H6o1bxKRGzmsE0vzo968m','https://p.scdn.co/mp3-preview/5576fde4795672bfa292bbf58adf0f9159af0be3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7ij6rb2puaf645n6ez0u2n92uhts6zcl82f703nwz0lpmor80e', 'tdgafpvkzi5xf93ml9dgodmwneyogoj8n2j5xcdtpqwuatec1f', '0');
-- Tears For Fears
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ijtuw25oknhrbeb', 'Tears For Fears', '232@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb42ed2cb48c231f545a5a3dad','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:232@artist.com', 'ijtuw25oknhrbeb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ijtuw25oknhrbeb', 'Pushing the boundaries of sound with each note.', 'Tears For Fears');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('itjvk4zxld8jlqrts13b3dj0k6ar1bllkqom3fdh060a73f6op','ijtuw25oknhrbeb', 'https://i.scdn.co/image/ab67616d0000b27322463d6939fec9e17b2a6235', 'Tears For Fears Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('15ndc4uiiiho11k2hm4poyf0us93jfaa86ybz4tt1xh1z4ovjq','Everybody Wants To Rule The World','ijtuw25oknhrbeb','POP','4RvWPyQ5RL0ao9LPZeSouE',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('itjvk4zxld8jlqrts13b3dj0k6ar1bllkqom3fdh060a73f6op', '15ndc4uiiiho11k2hm4poyf0us93jfaa86ybz4tt1xh1z4ovjq', '0');
-- Ed Sheeran
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uk27xnqfudrhv61', 'Ed Sheeran', '233@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3bcef85e105dfc42399ef0ba','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:233@artist.com', 'uk27xnqfudrhv61', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uk27xnqfudrhv61', 'Igniting the stage with electrifying performances.', 'Ed Sheeran');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hs39oknnustqxuolo0f3dr4q1cpfo866gqccg4mi8sa15opsw1','uk27xnqfudrhv61', 'https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96', 'Ed Sheeran Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2zhmcwu1thz5y5wemlj7trpfgkeby832q0myvrym2alknznnhg','Perfect','uk27xnqfudrhv61','POP','0tgVpDi06FyKpA1z0VMD4v','https://p.scdn.co/mp3-preview/4e30857a3c7da3f8891483643e310bb233afadd2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hs39oknnustqxuolo0f3dr4q1cpfo866gqccg4mi8sa15opsw1', '2zhmcwu1thz5y5wemlj7trpfgkeby832q0myvrym2alknznnhg', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q6qwsmizragkm32sspl1lwfl3lhgl36ygo6it8ji026jh9bkoe','Shape of You','uk27xnqfudrhv61','POP','7qiZfU4dY1lWllzX7mPBI3','https://p.scdn.co/mp3-preview/7339548839a263fd721d01eb3364a848cad16fa7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hs39oknnustqxuolo0f3dr4q1cpfo866gqccg4mi8sa15opsw1', 'q6qwsmizragkm32sspl1lwfl3lhgl36ygo6it8ji026jh9bkoe', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hb42yfapepgaf3rixyns9kewd7gi1lmb573qiti7ge9hc928u0','Eyes Closed','uk27xnqfudrhv61','POP','3p7XQpdt8Dr6oMXSvRZ9bg','https://p.scdn.co/mp3-preview/7cd2576f2d27799fe8c515c4e0fc880870a5cc88?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hs39oknnustqxuolo0f3dr4q1cpfo866gqccg4mi8sa15opsw1', 'hb42yfapepgaf3rixyns9kewd7gi1lmb573qiti7ge9hc928u0', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vkq1mjid8vfeh3dmjuzioams1hd6vc2nsqfym3h32kc87qjbbt','Curtains','uk27xnqfudrhv61','POP','6ZZf5a8oiInHDkBe9zXfLP','https://p.scdn.co/mp3-preview/5a519e5823df4fe468c8a45a7104a632553e09a5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hs39oknnustqxuolo0f3dr4q1cpfo866gqccg4mi8sa15opsw1', 'vkq1mjid8vfeh3dmjuzioams1hd6vc2nsqfym3h32kc87qjbbt', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ky0gtvl430dlp2fd8zafajs3qazt7fd9qgb9tklzond25538cx','Shivers','uk27xnqfudrhv61','POP','50nfwKoDiSYg8zOCREWAm5','https://p.scdn.co/mp3-preview/08cec59d36ac30ae9ce1e2944f206251859844af?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hs39oknnustqxuolo0f3dr4q1cpfo866gqccg4mi8sa15opsw1', 'ky0gtvl430dlp2fd8zafajs3qazt7fd9qgb9tklzond25538cx', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mqqbe4d2iolmnd47pqaa0cdy9pgredfrcsxqvzmemk7jal2bb1','Bad Habits','uk27xnqfudrhv61','POP','3rmo8F54jFF8OgYsqTxm5d','https://p.scdn.co/mp3-preview/22f3a86c8a83e364db595007f9ac1d666596a335?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hs39oknnustqxuolo0f3dr4q1cpfo866gqccg4mi8sa15opsw1', 'mqqbe4d2iolmnd47pqaa0cdy9pgredfrcsxqvzmemk7jal2bb1', '5');
-- INTERWORLD
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ei2lqtc74qqrtpt', 'INTERWORLD', '234@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4ba846e4a963c8558471e3af','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:234@artist.com', 'ei2lqtc74qqrtpt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ei2lqtc74qqrtpt', 'A unique voice in the contemporary music scene.', 'INTERWORLD');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vl9z137pve2pw8bxc08js899imub8aq4ywamvo9ro5wpngwmeu','ei2lqtc74qqrtpt', 'https://i.scdn.co/image/ab67616d0000b273b852a616ae3a49a1f6b0f16e', 'INTERWORLD Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9ag8r0f74dq23ytu0kkhj2l4bfjfaprn4q7mkwmkcs1rdhkc97','METAMORPHOSIS','ei2lqtc74qqrtpt','POP','2ksyzVfU0WJoBpu8otr4pz','https://p.scdn.co/mp3-preview/61baac6cfee58ae57f9f767a86fa5e99f9797664?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vl9z137pve2pw8bxc08js899imub8aq4ywamvo9ro5wpngwmeu', '9ag8r0f74dq23ytu0kkhj2l4bfjfaprn4q7mkwmkcs1rdhkc97', '0');
-- Brenda Lee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8j62x9yh0ip6wyl', 'Brenda Lee', '235@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4ea49bdca366a3baa5cbb006','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:235@artist.com', '8j62x9yh0ip6wyl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8j62x9yh0ip6wyl', 'A journey through the spectrum of sound in every album.', 'Brenda Lee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8jfz5nlzf09vpr7zyta6zeueh5wgdocvd8wsu1nybep94be2tc','8j62x9yh0ip6wyl', 'https://i.scdn.co/image/ab67616d0000b2737845f74d6db14b400fa61cd3', 'Brenda Lee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pu62teto80gks02thavffgs3mm76zk6j0v97hlptwvvgmho3vp','Rockin Around The Christmas Tree','8j62x9yh0ip6wyl','POP','2EjXfH91m7f8HiJN1yQg97',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8jfz5nlzf09vpr7zyta6zeueh5wgdocvd8wsu1nybep94be2tc', 'pu62teto80gks02thavffgs3mm76zk6j0v97hlptwvvgmho3vp', '0');
-- Peggy Gou
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3ozcfkp8ask9pq4', 'Peggy Gou', '236@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf5c17aa075c03c5c4d2c693','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:236@artist.com', '3ozcfkp8ask9pq4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3ozcfkp8ask9pq4', 'A dynamic force in the electronic music scene, known for her eclectic mixes.', 'Peggy Gou');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('aqk8658fnthbujlenmcuath03f56clefg2ilacetwj9bz9io88','3ozcfkp8ask9pq4', 'https://i.scdn.co/image/ab67616d0000b27388d71aadd009fe1a83df88f2', 'Peggy Gou Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o2vwgafty1m9c6kd7eina6dd49x2tyk8dub3u9famwlc8oc9or','(It Goes Like) Nanana - Edit','3ozcfkp8ask9pq4','POP','23RoR84KodL5HWvUTneQ1w','https://p.scdn.co/mp3-preview/e36e0bd4714844f1f9d992398b41a3e333f15cc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('aqk8658fnthbujlenmcuath03f56clefg2ilacetwj9bz9io88', 'o2vwgafty1m9c6kd7eina6dd49x2tyk8dub3u9famwlc8oc9or', '0');
-- Kenia OS
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s2dgxnwyq4fozie', 'Kenia OS', '237@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7cee297b5eaaa121f9558d7e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:237@artist.com', 's2dgxnwyq4fozie', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s2dgxnwyq4fozie', 'Blending traditional rhythms with modern beats.', 'Kenia OS');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e48zt38hkxfktd7oz97h5ee0ij0w1rbyh126agemq56el00q9j','s2dgxnwyq4fozie', 'https://i.scdn.co/image/ab67616d0000b2739afe5698b0a9559dabc44ac8', 'Kenia OS Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kh1bpihn3wtk9p4t69fhc41ai1qs7ep5bo0o5hx7sr7g8kulyl','Malas Decisiones','s2dgxnwyq4fozie','POP','6Xj014IHwbLVjiVT6H89on','https://p.scdn.co/mp3-preview/9a71f09b224a9e6f521743423bd53e99c7c4793c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e48zt38hkxfktd7oz97h5ee0ij0w1rbyh126agemq56el00q9j', 'kh1bpihn3wtk9p4t69fhc41ai1qs7ep5bo0o5hx7sr7g8kulyl', '0');
-- James Hype
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3ero27mbz5x0pw3', 'James Hype', '238@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3735de17f641144240511000','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:238@artist.com', '3ero27mbz5x0pw3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3ero27mbz5x0pw3', 'A confluence of cultural beats and contemporary tunes.', 'James Hype');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ueq07o13ts5t3xvqa35xvgrk2q3e5lhoeyr21wd8wqfyi8efv5','3ero27mbz5x0pw3', 'https://i.scdn.co/image/ab67616d0000b2736cc861b5c9c7cdef61b010b4', 'James Hype Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4jsg1auyzxxrhz1cx0g3u6k1fi3n95gssyfbrk1q49resz8zpd','Ferrari','3ero27mbz5x0pw3','POP','4zN21mbAuaD0WqtmaTZZeP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ueq07o13ts5t3xvqa35xvgrk2q3e5lhoeyr21wd8wqfyi8efv5', '4jsg1auyzxxrhz1cx0g3u6k1fi3n95gssyfbrk1q49resz8zpd', '0');
-- Bellakath
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uungk060in1oyqu', 'Bellakath', '239@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb008a12ca09c3acec7c536d53','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:239@artist.com', 'uungk060in1oyqu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uungk060in1oyqu', 'Igniting the stage with electrifying performances.', 'Bellakath');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wwaota8f2k87wpgmjsb0kzn46dhn4dp0og858ap48j16puzhs3','uungk060in1oyqu', 'https://i.scdn.co/image/ab67616d0000b273584e78471da03acbc05dde0b', 'Bellakath Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5czmb1rsct5j6s36mlkjusi49vz69oaccfqocju2v4qcadoxeb','Gatita','uungk060in1oyqu','POP','4ilZV1WNjL7IxwE81OnaRY','https://p.scdn.co/mp3-preview/ed363508374055584f0a42a003473c065fbe4f61?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wwaota8f2k87wpgmjsb0kzn46dhn4dp0og858ap48j16puzhs3', '5czmb1rsct5j6s36mlkjusi49vz69oaccfqocju2v4qcadoxeb', '0');
-- Tory Lanez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('72f4bgx30qmtwm8', 'Tory Lanez', '240@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebbd5d3e1b363c3e26710661c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:240@artist.com', '72f4bgx30qmtwm8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('72f4bgx30qmtwm8', 'Melodies that capture the essence of human emotion.', 'Tory Lanez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('727jarikg6qayf38ixq9aji2rd8mzfbwmyqly16h48so6gb3k2','72f4bgx30qmtwm8', 'https://i.scdn.co/image/ab67616d0000b2730c5f23cbf0b1ab7e37d0dc67', 'Tory Lanez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y6oa6lnjgtlqbyr5yxrg0hzwgyqk38pwyh0t26wl1bgjjfez9i','The Color Violet','72f4bgx30qmtwm8','POP','3azJifCSqg9fRij2yKIbWz','https://p.scdn.co/mp3-preview/1d7c627bf549328110519c4bd21ac39d7ca50ea1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('727jarikg6qayf38ixq9aji2rd8mzfbwmyqly16h48so6gb3k2', 'y6oa6lnjgtlqbyr5yxrg0hzwgyqk38pwyh0t26wl1bgjjfez9i', '0');
-- Cigarettes After Sex
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('thhghq68a54fzzg', 'Cigarettes After Sex', '241@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb41a26ad71de86acf45dc886','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:241@artist.com', 'thhghq68a54fzzg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('thhghq68a54fzzg', 'A tapestry of rhythms that echo the pulse of life.', 'Cigarettes After Sex');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2r169z88rfl7euefxruuirxwptc01er10ukye6nn2e38e8nrph','thhghq68a54fzzg', 'https://i.scdn.co/image/ab67616d0000b27312b69bf576f5e80291f75161', 'Cigarettes After Sex Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a5kannb3wvx9jqj5fz5rpk186kswh8yrq4gp5z5lxotsgr0bj3','Apocalypse','thhghq68a54fzzg','POP','0yc6Gst2xkRu0eMLeRMGCX','https://p.scdn.co/mp3-preview/1f89f0156113dfb87572382b531459bb8cb711a1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2r169z88rfl7euefxruuirxwptc01er10ukye6nn2e38e8nrph', 'a5kannb3wvx9jqj5fz5rpk186kswh8yrq4gp5z5lxotsgr0bj3', '0');
-- ThxSoMch
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nytna450p5nlo2m', 'ThxSoMch', '242@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcce84671d294b0cefb8fe1c0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:242@artist.com', 'nytna450p5nlo2m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nytna450p5nlo2m', 'Sculpting soundwaves into masterpieces of auditory art.', 'ThxSoMch');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ps1igbze167tpcuirh43k6sy2xm2cx53q2n5zfi4l2ifkxwo9t','nytna450p5nlo2m', 'https://i.scdn.co/image/ab67616d0000b27360ddc59c8d590a37cf2348f3', 'ThxSoMch Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jjrjq8x0idsewckl0ndpoithtietkm88fhbd32yimagxtron3b','SPIT IN MY FACE!','nytna450p5nlo2m','POP','1N8TTK1Uoy7UvQNUazfUt5','https://p.scdn.co/mp3-preview/a4146e5dd430d70eda83e57506ba5ed402935200?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ps1igbze167tpcuirh43k6sy2xm2cx53q2n5zfi4l2ifkxwo9t', 'jjrjq8x0idsewckl0ndpoithtietkm88fhbd32yimagxtron3b', '0');
-- Metro Boomin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hretjw5fftmnfni', 'Metro Boomin', '243@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:243@artist.com', 'hretjw5fftmnfni', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hretjw5fftmnfni', 'Where words fail, my music speaks.', 'Metro Boomin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9xsa2sgr6kcq5jubdsar0t7o1ukg1wtrurbvxl67i47604ueu2','hretjw5fftmnfni', 'https://i.scdn.co/image/ab67616d0000b2736ed9aef791159496b286179f', 'Metro Boomin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sxplhgm7ixfsyw08btkwva72418njcvxtvxwftzai06kgl8hyy','Self Love (Spider-Man: Across the Spider-Verse) (Metro Boomin & Coi Leray)','hretjw5fftmnfni','POP','0AAMnNeIc6CdnfNU85GwCH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9xsa2sgr6kcq5jubdsar0t7o1ukg1wtrurbvxl67i47604ueu2', 'sxplhgm7ixfsyw08btkwva72418njcvxtvxwftzai06kgl8hyy', '0');
-- Maroon 5
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ujkjrdqsd2qajq4', 'Maroon 5', '244@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:244@artist.com', 'ujkjrdqsd2qajq4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ujkjrdqsd2qajq4', 'Pioneering new paths in the musical landscape.', 'Maroon 5');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('w5dth68ofbgo6tlkzodzgdyo682vwxsgdjyxua8sgcpcd5zsod','ujkjrdqsd2qajq4', 'https://i.scdn.co/image/ab67616d0000b273ce7d499847da02a9cbd1c084', 'Maroon 5 Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g7npiqoa9y6asqklq60drw3qbxxtcrwj21iqoh7xyfnaubfqt3','Payphone','ujkjrdqsd2qajq4','POP','4P0osvTXoSYZZC2n8IFH3c',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w5dth68ofbgo6tlkzodzgdyo682vwxsgdjyxua8sgcpcd5zsod', 'g7npiqoa9y6asqklq60drw3qbxxtcrwj21iqoh7xyfnaubfqt3', '0');
-- Cartel De Santa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z2l1dc51pw679rl', 'Cartel De Santa', '245@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb72d02b5f21c6364c3d1928d7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:245@artist.com', 'z2l1dc51pw679rl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z2l1dc51pw679rl', 'Crafting soundscapes that transport listeners to another world.', 'Cartel De Santa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l93beqfye0httr9co4bzqhenv708wyxii32dj2jjhfb01yw7yw','z2l1dc51pw679rl', 'https://i.scdn.co/image/ab67616d0000b273608e249e118a39e897f149ce', 'Cartel De Santa Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gluvjff2b5nfyrm9zffxtm2dkacbx9o4nsfinft6n6phks6x87','Shorty Party','z2l1dc51pw679rl','POP','55ZATsjPlTeSTNJOuW90pW','https://p.scdn.co/mp3-preview/861a31225cff10db2eedeb5c28bf6d0a4ecc4bc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l93beqfye0httr9co4bzqhenv708wyxii32dj2jjhfb01yw7yw', 'gluvjff2b5nfyrm9zffxtm2dkacbx9o4nsfinft6n6phks6x87', '0');
-- One Direction
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7dc32vxsqjk5wen', 'One Direction', '246@artist.com', 'https://i.scdn.co/image/5bb443424a1ad71603c43d67f5af1a04da6bb3c8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:246@artist.com', '7dc32vxsqjk5wen', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7dc32vxsqjk5wen', 'A symphony of emotions expressed through sound.', 'One Direction');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('szifqn5bu1jfgmua1iz1i1p0dm1jq2fj7br5h5zvgc541ujed8','7dc32vxsqjk5wen', 'https://i.scdn.co/image/ab67616d0000b273d304ba2d71de306812eebaf4', 'One Direction Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p8vqz50xnaydc5x73p54tiee3nwdxkfek8lv5qn3kno2rrhb6k','Night Changes','7dc32vxsqjk5wen','POP','5O2P9iiztwhomNh8xkR9lJ','https://p.scdn.co/mp3-preview/359be833b46b250c696bbb64caa5dc91f2a38c6a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('szifqn5bu1jfgmua1iz1i1p0dm1jq2fj7br5h5zvgc541ujed8', 'p8vqz50xnaydc5x73p54tiee3nwdxkfek8lv5qn3kno2rrhb6k', '0');
-- dennis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k71tsajni44iw1i', 'dennis', '247@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8a1ec9781a1542458b3b961b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:247@artist.com', 'k71tsajni44iw1i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k71tsajni44iw1i', 'Transcending language barriers through the universal language of music.', 'dennis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cnqcukmap19k2hwoobp7d86thb5kcsltm9vnk2bn2z5u6gipts','k71tsajni44iw1i', 'https://i.scdn.co/image/ab67616d0000b273ddfc406de0d7dbc2e339f016', 'dennis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iihyqs3o9bh3f3c3wl2x7yvmx01q4erl6nzn2qn4it1xie3u92','T','k71tsajni44iw1i','POP','35FW5OEe4p38LdjK1KqT2X','https://p.scdn.co/mp3-preview/eaa522f48564e43e33e00c011aef0489526d1072?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cnqcukmap19k2hwoobp7d86thb5kcsltm9vnk2bn2z5u6gipts', 'iihyqs3o9bh3f3c3wl2x7yvmx01q4erl6nzn2qn4it1xie3u92', '0');
-- BLESSD
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bsutgg51xmpqmeo', 'BLESSD', '248@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:248@artist.com', 'bsutgg51xmpqmeo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bsutgg51xmpqmeo', 'Redefining what it means to be an artist in the digital age.', 'BLESSD');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0k7tv56g7hwn3tzp9lvbj5zjnempc4ps9gasg3nbm32ccw7f6n','bsutgg51xmpqmeo', NULL, 'BLESSD Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fw8ljoznoznc0aqvxdtj1mx8c5cwqova2vnnl29jkekw6p7gyd','Las Morras','bsutgg51xmpqmeo','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0k7tv56g7hwn3tzp9lvbj5zjnempc4ps9gasg3nbm32ccw7f6n', 'fw8ljoznoznc0aqvxdtj1mx8c5cwqova2vnnl29jkekw6p7gyd', '0');
-- Creedence Clearwater Revival
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wcgp9msffoz1sqe', 'Creedence Clearwater Revival', '249@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd2e2b04b7ba5d60b72f54506','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:249@artist.com', 'wcgp9msffoz1sqe', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wcgp9msffoz1sqe', 'Elevating the ordinary to extraordinary through music.', 'Creedence Clearwater Revival');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1fq8ubmv4780lhluei18ivltbnfttc3hq66dxafnw7zvqvgizo','wcgp9msffoz1sqe', 'https://i.scdn.co/image/ab67616d0000b27351f311c2fb06ad2789e3ff91', 'Creedence Clearwater Revival Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6cw40dcamp24wef7so98ys3kj0sxi1tvm622iyvgjv40zo6olj','Have You Ever Seen The Rain?','wcgp9msffoz1sqe','POP','2LawezPeJhN4AWuSB0GtAU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1fq8ubmv4780lhluei18ivltbnfttc3hq66dxafnw7zvqvgizo', '6cw40dcamp24wef7so98ys3kj0sxi1tvm622iyvgjv40zo6olj', '0');
-- IVE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2laortrs87s4gy6', 'IVE', '250@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0e46f140189de1eba9ab6230','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:250@artist.com', '2laortrs87s4gy6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2laortrs87s4gy6', 'Transcending language barriers through the universal language of music.', 'IVE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yhzza5w3db4keg91borjby3jserkzxh4w8lutjwslcopumhrjq','2laortrs87s4gy6', 'https://i.scdn.co/image/ab67616d0000b27325ef3cec1eceefd4db2f91c8', 'IVE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('txcuqb49df2is76qdaxxuzffrsj65ioadxnngxcs9h8jotpeep','I AM','2laortrs87s4gy6','POP','70t7Q6AYG6ZgTYmJWcnkUM','https://p.scdn.co/mp3-preview/8d1fa5354093e98745ccef77ecb60fac3c9d38d0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yhzza5w3db4keg91borjby3jserkzxh4w8lutjwslcopumhrjq', 'txcuqb49df2is76qdaxxuzffrsj65ioadxnngxcs9h8jotpeep', '0');
-- Jack Black
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('patgzx00yzjn36f', 'Jack Black', '251@artist.com', 'https://i.scdn.co/image/ab6772690000c46ca156a562884cb76eeb0b75e9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:251@artist.com', 'patgzx00yzjn36f', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('patgzx00yzjn36f', 'Elevating the ordinary to extraordinary through music.', 'Jack Black');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('q316mcvtkinrnggrjb4tly6chtyn4y87e2fh1vrthkqv3g93dq','patgzx00yzjn36f', NULL, 'Jack Black Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t2vunsezm41zprwvz0dgfom3r3l2olf8phrjf8nywq38rm4nr0','Peaches (from The Super Mario Bros. Movie)','patgzx00yzjn36f','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q316mcvtkinrnggrjb4tly6chtyn4y87e2fh1vrthkqv3g93dq', 't2vunsezm41zprwvz0dgfom3r3l2olf8phrjf8nywq38rm4nr0', '0');
-- Linkin Park
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xu29jbgh1e3jqa8', 'Linkin Park', '252@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb811da3b2e7c9e5a9c1a6c4f7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:252@artist.com', 'xu29jbgh1e3jqa8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xu29jbgh1e3jqa8', 'Crafting melodies that resonate with the soul.', 'Linkin Park');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jxr4rplgyubs6pewi5vk383fbx9b0v4ezjmat9whsh6my9tm3s','xu29jbgh1e3jqa8', 'https://i.scdn.co/image/ab67616d0000b273b4ad7ebaf4575f120eb3f193', 'Linkin Park Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6yg9zdhp8y5irjh2kneochrosary1t129rbj5cdyfemfssle4q','Numb','xu29jbgh1e3jqa8','POP','2nLtzopw4rPReszdYBJU6h','https://p.scdn.co/mp3-preview/15e1178c9eb7f626ac1112ad8f56eccbec2cd6e5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jxr4rplgyubs6pewi5vk383fbx9b0v4ezjmat9whsh6my9tm3s', '6yg9zdhp8y5irjh2kneochrosary1t129rbj5cdyfemfssle4q', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f1mceoe1du7pfkz8ok91l431f665e36f0v7trpy2qli0kt6oq8','In The End','xu29jbgh1e3jqa8','POP','60a0Rd6pjrkxjPbaKzXjfq','https://p.scdn.co/mp3-preview/b5ee275ca337899f762b1c1883c11e24a04075b0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jxr4rplgyubs6pewi5vk383fbx9b0v4ezjmat9whsh6my9tm3s', 'f1mceoe1du7pfkz8ok91l431f665e36f0v7trpy2qli0kt6oq8', '1');
-- Central Cee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q8kma2qtmh57bmq', 'Central Cee', '253@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5fe7cabb8de1c0266cd2179c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:253@artist.com', 'q8kma2qtmh57bmq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q8kma2qtmh57bmq', 'Where words fail, my music speaks.', 'Central Cee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i8kxl1v56maji8e85y63pbs77kzyf8yoo8ff1c6et0pu5e5vvm','q8kma2qtmh57bmq', 'https://i.scdn.co/image/ab67616d0000b273cbb3701743a568e7f1c4e967', 'Central Cee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9c3ltoxh2ma19x0w18rmgfsk6p4ufdzxkfosqiycj40opb1ycj','LET GO','q8kma2qtmh57bmq','POP','3zkyus0njMCL6phZmNNEeN','https://p.scdn.co/mp3-preview/5391f8e7621898d3f5237e297e3fbcabe1fe3494?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i8kxl1v56maji8e85y63pbs77kzyf8yoo8ff1c6et0pu5e5vvm', '9c3ltoxh2ma19x0w18rmgfsk6p4ufdzxkfosqiycj40opb1ycj', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3lqtcn0qpow3od9pplsdidrka6a86gkwe0w7paw2vbx1w5elst','Doja','q8kma2qtmh57bmq','POP','3LtpKP5abr2qqjunvjlX5i','https://p.scdn.co/mp3-preview/41105628e270a026ac9aecacd44e3373fceb9f43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i8kxl1v56maji8e85y63pbs77kzyf8yoo8ff1c6et0pu5e5vvm', '3lqtcn0qpow3od9pplsdidrka6a86gkwe0w7paw2vbx1w5elst', '1');
-- Post Malone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('oivmthopknwjkiq', 'Post Malone', '254@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:254@artist.com', 'oivmthopknwjkiq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('oivmthopknwjkiq', 'Blurring genre lines with his unique blend of hip-hop and pop.', 'Post Malone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9vvl7ekbk6bg7yejsr1y26zsbx1f12d4lzrrcbtxlcymwkbygb','oivmthopknwjkiq', 'https://i.scdn.co/image/ab67616d0000b2739478c87599550dd73bfa7e02', 'Post Malone Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bxzwmtp7xy5zvj8hnal2bnycr7n9prabf2ten88n3fjje9rdjp','Sunflower - Spider-Man: Into the Spider-Verse','oivmthopknwjkiq','POP','0RiRZpuVRbi7oqRdSMwhQY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9vvl7ekbk6bg7yejsr1y26zsbx1f12d4lzrrcbtxlcymwkbygb', 'bxzwmtp7xy5zvj8hnal2bnycr7n9prabf2ten88n3fjje9rdjp', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('orw6dww37tsqqnpkyt7e25jzqjw67ba1tsp4yisdbw6fw56p6w','Overdrive','oivmthopknwjkiq','POP','3t0ic4mkhvhamrKDkulB8v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9vvl7ekbk6bg7yejsr1y26zsbx1f12d4lzrrcbtxlcymwkbygb', 'orw6dww37tsqqnpkyt7e25jzqjw67ba1tsp4yisdbw6fw56p6w', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ea0jtulsh5mmfwdt1jse3ugmj9i1wmwkk4dogp7lfy4bldyl6d','Chemical','oivmthopknwjkiq','POP','5w40ZYhbBMAlHYNDaVJIUu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9vvl7ekbk6bg7yejsr1y26zsbx1f12d4lzrrcbtxlcymwkbygb', 'ea0jtulsh5mmfwdt1jse3ugmj9i1wmwkk4dogp7lfy4bldyl6d', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9lg60iuvyl45tc9iqljb3by2uve4ncdrx74cf5ewek3po1fmv5','Circles','oivmthopknwjkiq','POP','21jGcNKet2qwijlDFuPiPb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9vvl7ekbk6bg7yejsr1y26zsbx1f12d4lzrrcbtxlcymwkbygb', '9lg60iuvyl45tc9iqljb3by2uve4ncdrx74cf5ewek3po1fmv5', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wzry7pifoxhi6k50f5xxlldom6ggwp06g85s8n72cf8xs2kbyj','I Like You (A Happier Song) (with Doja Cat)','oivmthopknwjkiq','POP','0O6u0VJ46W86TxN9wgyqDj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9vvl7ekbk6bg7yejsr1y26zsbx1f12d4lzrrcbtxlcymwkbygb', 'wzry7pifoxhi6k50f5xxlldom6ggwp06g85s8n72cf8xs2kbyj', '4');
-- Robin Schulz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bcuiqeacp3tmv1s', 'Robin Schulz', '255@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2615ef39cf9128c447b31619','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:255@artist.com', 'bcuiqeacp3tmv1s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bcuiqeacp3tmv1s', 'A maestro of melodies, orchestrating auditory bliss.', 'Robin Schulz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('veydlvv6oxaxrzimz5672d74kskc1i5yhpqlbosm5gfygmgxgg','bcuiqeacp3tmv1s', NULL, 'Robin Schulz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iykoocbe4fz7kb9tl2npbzg4ejhabj0xgd52k0q92ldbmy4688','Miss You','bcuiqeacp3tmv1s','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('veydlvv6oxaxrzimz5672d74kskc1i5yhpqlbosm5gfygmgxgg', 'iykoocbe4fz7kb9tl2npbzg4ejhabj0xgd52k0q92ldbmy4688', '0');
-- Israel & Rodolffo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wlaiyx5mfwjtrqg', 'Israel & Rodolffo', '256@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb697f5ad0867793de624bbb5f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:256@artist.com', 'wlaiyx5mfwjtrqg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wlaiyx5mfwjtrqg', 'A harmonious blend of passion and creativity.', 'Israel & Rodolffo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jy8np0gztj4czrlp412q6pwe7av2j9wxo548vde803tm8caibv','wlaiyx5mfwjtrqg', 'https://i.scdn.co/image/ab67616d0000b2736ccbcc3358d31dcba6e7c035', 'Israel & Rodolffo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f13wn0t4b8l3l89zjeyfznit1y3a2dcoqnywjnm63j67xtkhlc','Seu Brilho Sumiu - Ao Vivo','wlaiyx5mfwjtrqg','POP','3PH1nUysW7ybo3Yu8sqlPN','https://p.scdn.co/mp3-preview/125d70024c88bb1bf45666f6396dc21a181c416e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jy8np0gztj4czrlp412q6pwe7av2j9wxo548vde803tm8caibv', 'f13wn0t4b8l3l89zjeyfznit1y3a2dcoqnywjnm63j67xtkhlc', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kqt0yl4pwaczn5xjqz726r4mjb1ao6fg672aqhrjw9l2e0p5fs','Bombonzinho - Ao Vivo','wlaiyx5mfwjtrqg','POP','0SCMVUZ21uYYB8cc0ScfbV','https://p.scdn.co/mp3-preview/b7d7cfb08d5384a52deb562a3e496881c978a9f1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jy8np0gztj4czrlp412q6pwe7av2j9wxo548vde803tm8caibv', 'kqt0yl4pwaczn5xjqz726r4mjb1ao6fg672aqhrjw9l2e0p5fs', '1');
-- Vishal-Shekhar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zvn49ux8fsligun', 'Vishal-Shekhar', '257@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb90b6c3d093f9b02aad628eaf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:257@artist.com', 'zvn49ux8fsligun', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zvn49ux8fsligun', 'Redefining what it means to be an artist in the digital age.', 'Vishal-Shekhar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gdr6nh6s3jy1d0xce4nwct3oqo1f669r845z5e4g5s0xqxfohw','zvn49ux8fsligun', NULL, 'Vishal-Shekhar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u5zyer798fjd9hhbb5pmsyn73ixyk3kuuqck9nx980hfjxcdn9','Besharam Rang (From "Pathaan")','zvn49ux8fsligun','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gdr6nh6s3jy1d0xce4nwct3oqo1f669r845z5e4g5s0xqxfohw', 'u5zyer798fjd9hhbb5pmsyn73ixyk3kuuqck9nx980hfjxcdn9', '0');
-- Mc Pedrinho
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('59v41h5z77la80h', 'Mc Pedrinho', '258@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba19ab278a7a01b077bb17e75','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:258@artist.com', '59v41h5z77la80h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('59v41h5z77la80h', 'Exploring the depths of sound and rhythm.', 'Mc Pedrinho');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nmcu4efjk7rqml75xcn4tdna2puox8x0f9pbvwk4ucfhwke64j','59v41h5z77la80h', 'https://i.scdn.co/image/ab67616d0000b27319d60821e80a801506061776', 'Mc Pedrinho Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4ru8noes56vm4k95en2jywrk7rv3ad3058j90wjixn6y9pz8gn','Gol Bolinha, Gol Quadrado 2','59v41h5z77la80h','POP','0U9CZWq6umZsN432nh3WWT','https://p.scdn.co/mp3-preview/385a48d0a130895b2b0ec2f731cc744207d0a745?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nmcu4efjk7rqml75xcn4tdna2puox8x0f9pbvwk4ucfhwke64j', '4ru8noes56vm4k95en2jywrk7rv3ad3058j90wjixn6y9pz8gn', '0');
-- Tisto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('56qlqdwrlemz4x7', 'Tisto', '259@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7afd1dcf8bc34612f16ee39c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:259@artist.com', '56qlqdwrlemz4x7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('56qlqdwrlemz4x7', 'Crafting soundscapes that transport listeners to another world.', 'Tisto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9p81b5y43zjeubq35udzf2sm4ehy6sgjyk0df7dhrgz95luhus','56qlqdwrlemz4x7', NULL, 'Tisto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8bnldu8pphtk1rqz6e0nj6gj2khftdbnrfyupu1e2k6pveschy','10:35','56qlqdwrlemz4x7','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9p81b5y43zjeubq35udzf2sm4ehy6sgjyk0df7dhrgz95luhus', '8bnldu8pphtk1rqz6e0nj6gj2khftdbnrfyupu1e2k6pveschy', '0');
-- Beach House
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zvnp1vvibg0wah0', 'Beach House', '260@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb3e38a46a56a423d8f741c09','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:260@artist.com', 'zvnp1vvibg0wah0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zvnp1vvibg0wah0', 'Blending genres for a fresh musical experience.', 'Beach House');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4anec8j6nqp5rar59uvb1onhxlu2d1p1vxmvarz4plwqo782wy','zvnp1vvibg0wah0', 'https://i.scdn.co/image/ab67616d0000b2739b7190e673e46271b2754aab', 'Beach House Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('27pyo3r5avfun98ngodci8s1r81p4bodskxj5lt3pq8rm3ee07','Space Song','zvnp1vvibg0wah0','POP','7H0ya83CMmgFcOhw0UB6ow','https://p.scdn.co/mp3-preview/3d50d7331c2ef197699e796d08cf8d4009591be0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4anec8j6nqp5rar59uvb1onhxlu2d1p1vxmvarz4plwqo782wy', '27pyo3r5avfun98ngodci8s1r81p4bodskxj5lt3pq8rm3ee07', '0');
-- Halsey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('irgjo1gx7ofx2ud', 'Halsey', '261@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd707e1c5177614c4ec95a06c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:261@artist.com', 'irgjo1gx7ofx2ud', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('irgjo1gx7ofx2ud', 'A confluence of cultural beats and contemporary tunes.', 'Halsey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('iwpyxqroxd0on7zu3gkc2puo40thco12csmf9d3r1mjtxnmcwt','irgjo1gx7ofx2ud', 'https://i.scdn.co/image/ab67616d0000b273f19310c007c0fad365b0542e', 'Halsey Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2e03hyvihnu8uj2ozxtzsno3cmp2zdv6vbzftyd1x3l648ukrk','Lilith (feat. SUGA of BTS) (Diablo IV Anthem)','irgjo1gx7ofx2ud','POP','3l6LBCOL9nPsSY29TUY2VE',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('iwpyxqroxd0on7zu3gkc2puo40thco12csmf9d3r1mjtxnmcwt', '2e03hyvihnu8uj2ozxtzsno3cmp2zdv6vbzftyd1x3l648ukrk', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ybn0v8hncb6a0ud6ad0m1b6hct7h7xciyex7w05ucjfkl4wr5w','Boy With Luv (feat. Halsey)','irgjo1gx7ofx2ud','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('iwpyxqroxd0on7zu3gkc2puo40thco12csmf9d3r1mjtxnmcwt', 'ybn0v8hncb6a0ud6ad0m1b6hct7h7xciyex7w05ucjfkl4wr5w', '1');
-- Seafret
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m776l0jbmoip4h1', 'Seafret', '262@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7f753324eacfbe0db36d64e5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:262@artist.com', 'm776l0jbmoip4h1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m776l0jbmoip4h1', 'A maestro of melodies, orchestrating auditory bliss.', 'Seafret');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('20pw1cswsrv406jh4yfyumllhmtrkt20ufchlddwtlr1zoy2wt','m776l0jbmoip4h1', 'https://i.scdn.co/image/ab67616d0000b2738c33272a7c77042f5eb39d75', 'Seafret Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4sm57onuinggiqyyb43d0h6mytjtefj5p3bm6v6gnndvr0r2n5','Atlantis','m776l0jbmoip4h1','POP','1Fid2jjqsHViMX6xNH70hE','https://p.scdn.co/mp3-preview/2097364ff6c9f41d658ea1b00a5e2153dc61144b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('20pw1cswsrv406jh4yfyumllhmtrkt20ufchlddwtlr1zoy2wt', '4sm57onuinggiqyyb43d0h6mytjtefj5p3bm6v6gnndvr0r2n5', '0');
-- Lizzy McAlpine
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('elvvp76cyghnbsa', 'Lizzy McAlpine', '263@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb10e2b618880f429a3967185','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:263@artist.com', 'elvvp76cyghnbsa', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('elvvp76cyghnbsa', 'Pioneering new paths in the musical landscape.', 'Lizzy McAlpine');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jjzpskuhdxhq03skca4jf28dsghx3nkoofmkcjy4baf1lo0rtq','elvvp76cyghnbsa', 'https://i.scdn.co/image/ab67616d0000b273d370fdc4dbc47778b9b667c3', 'Lizzy McAlpine Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ci5hsq8bdd47qx3jqd13tzyftn4mfnt8j5r2pnv7bpo0ld9w0e','ceilings','elvvp76cyghnbsa','POP','2L9N0zZnd37dwF0clgxMGI','https://p.scdn.co/mp3-preview/580782ffb17d468fe5d000bdf86cc07926ff9a5a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jjzpskuhdxhq03skca4jf28dsghx3nkoofmkcjy4baf1lo0rtq', 'ci5hsq8bdd47qx3jqd13tzyftn4mfnt8j5r2pnv7bpo0ld9w0e', '0');
-- R
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('t4cbdb9vc3trbap', 'R', '264@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6334ab6a83196f36475ada7f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:264@artist.com', 't4cbdb9vc3trbap', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('t4cbdb9vc3trbap', 'A visionary in the world of music, redefining genres.', 'R');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('olm0dpd0hgqsdzkjxsnswapr199jwsqlrufnzcauhtfuniz5me','t4cbdb9vc3trbap', 'https://i.scdn.co/image/ab67616d0000b273a3a7f38ea2033aa501afd4cf', 'R Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nls84pcych3nhjjl0d536avo1v3c5lngfrj93o1aa3myorhbw2','Calm Down','t4cbdb9vc3trbap','POP','0WtM2NBVQNNJLh6scP13H8',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('olm0dpd0hgqsdzkjxsnswapr199jwsqlrufnzcauhtfuniz5me', 'nls84pcych3nhjjl0d536avo1v3c5lngfrj93o1aa3myorhbw2', '0');
-- Marlia Mendo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lqdcc3zfk2ey0st', 'Marlia Mendo', '265@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebffaebdbc972967729f688e25','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:265@artist.com', 'lqdcc3zfk2ey0st', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lqdcc3zfk2ey0st', 'Pioneering new paths in the musical landscape.', 'Marlia Mendo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('76tf7dxayd6hcx195h2gfgb74n69n1i8m8lhy5f9dm8w4y4igw','lqdcc3zfk2ey0st', NULL, 'Marlia Mendo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g9qf2mn1rahrhi74ogmzmriksw0qv6w952odl4l1bzb1v01aee','Le','lqdcc3zfk2ey0st','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('76tf7dxayd6hcx195h2gfgb74n69n1i8m8lhy5f9dm8w4y4igw', 'g9qf2mn1rahrhi74ogmzmriksw0qv6w952odl4l1bzb1v01aee', '0');
-- Grupo Marca Registrada
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('buewdf7fgroeb7g', 'Grupo Marca Registrada', '266@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8059103a66f9c25b91b375a9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:266@artist.com', 'buewdf7fgroeb7g', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('buewdf7fgroeb7g', 'A unique voice in the contemporary music scene.', 'Grupo Marca Registrada');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('twx9kbi5x0pcch2yso0rq23y2q21jyvd3bg5ld7z3n75czrt2x','buewdf7fgroeb7g', 'https://i.scdn.co/image/ab67616d0000b273bae22025cf282ad72b167e79', 'Grupo Marca Registrada Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('631v1xk5rofzvciyu12mk5dv1fko44qzmsdlud9wg8agh9kqs4','Di Que Si','buewdf7fgroeb7g','POP','0pliiCOWPN0IId8sXAqNJr','https://p.scdn.co/mp3-preview/622a816595469fdb54c42c88259f303266dc8aa7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('twx9kbi5x0pcch2yso0rq23y2q21jyvd3bg5ld7z3n75czrt2x', '631v1xk5rofzvciyu12mk5dv1fko44qzmsdlud9wg8agh9kqs4', '0');
-- JISOO
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bdt640g4hfpthqx', 'JISOO', '267@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcb6017286dd64ca6b77c879f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:267@artist.com', 'bdt640g4hfpthqx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bdt640g4hfpthqx', 'A voice that echoes the sentiments of a generation.', 'JISOO');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wyipo5rjdyfsei89aivvnn3qfnxphftvkowyt6l06iafpyj1u4','bdt640g4hfpthqx', 'https://i.scdn.co/image/ab67616d0000b273f35b8a6c03cc633f734bd8ac', 'JISOO Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mkuag4s7kb9ivuyvkbq6pb8dkyylzk34cfg14kucqu75cksslu','FLOWER','bdt640g4hfpthqx','POP','69CrOS7vEHIrhC2ILyEi0s',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wyipo5rjdyfsei89aivvnn3qfnxphftvkowyt6l06iafpyj1u4', 'mkuag4s7kb9ivuyvkbq6pb8dkyylzk34cfg14kucqu75cksslu', '0');


-- File: insert_relationships.sql
-- Users
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7niawzo6bb63u2u', 'Ivan Davis (0)', '0@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:0@g.com', '7niawzo6bb63u2u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h9grz328f3wfk9g', 'Hannah Davis (1)', '1@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:1@g.com', 'h9grz328f3wfk9g', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m4t851dyjzqe6qh', 'Alice Garcia (2)', '2@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:2@g.com', 'm4t851dyjzqe6qh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kcp913in2bq0pft', 'Alice Garcia (3)', '3@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:3@g.com', 'kcp913in2bq0pft', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dze8m8msphmg7nh', 'Diana Brown (4)', '4@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:4@g.com', 'dze8m8msphmg7nh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2wt2309ehptszic', 'Fiona Smith (5)', '5@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:5@g.com', '2wt2309ehptszic', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pxu54pmgawm34b5', 'Ivan Brown (6)', '6@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:6@g.com', 'pxu54pmgawm34b5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nz4nme54t9n8mts', 'Julia Davis (7)', '7@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:7@g.com', 'nz4nme54t9n8mts', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('czeh5bn7jkh7am1', 'Diana Jones (8)', '8@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:8@g.com', 'czeh5bn7jkh7am1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ehjowsa0xfnqkor', 'Julia Rodriguez (9)', '9@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:9@g.com', 'ehjowsa0xfnqkor', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
-- Playlists
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('ns5z00unyu4dfhxoyapr5pm522radtfp1m6ov7i8ngbnnib95c', 'Playlist 0', '2023-11-17 17:00:08.000','7niawzo6bb63u2u');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gfz23jqpmrjv3jgd8ycuu8qt2p0xcy183j95b8uz1w4vwpq8mh', 'ns5z00unyu4dfhxoyapr5pm522radtfp1m6ov7i8ngbnnib95c', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3p6qm7d5sdcxinrozvne9ygvstptiasvmeaub86h05ry2wf9sf', 'ns5z00unyu4dfhxoyapr5pm522radtfp1m6ov7i8ngbnnib95c', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5wm9dsmfvcagzg9xbp3cmrpfhefudzx8ivmfuj5h8gxdake5ej', 'ns5z00unyu4dfhxoyapr5pm522radtfp1m6ov7i8ngbnnib95c', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('82zgg8q2s2cw6aatnh1ymgmnxcfa4pyb02v9uxah3p0tepklui', 'ns5z00unyu4dfhxoyapr5pm522radtfp1m6ov7i8ngbnnib95c', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jycm7ygfvme89cmpm1n6vw8z66o8q5fiwgyle6ilpr2o429ir5', 'ns5z00unyu4dfhxoyapr5pm522radtfp1m6ov7i8ngbnnib95c', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mkuag4s7kb9ivuyvkbq6pb8dkyylzk34cfg14kucqu75cksslu', 'ns5z00unyu4dfhxoyapr5pm522radtfp1m6ov7i8ngbnnib95c', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('txcuqb49df2is76qdaxxuzffrsj65ioadxnngxcs9h8jotpeep', 'ns5z00unyu4dfhxoyapr5pm522radtfp1m6ov7i8ngbnnib95c', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wcwoootefr9bacuui443jegod0nwaso75om2ej6fk8ljvoz1rn', 'ns5z00unyu4dfhxoyapr5pm522radtfp1m6ov7i8ngbnnib95c', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ndjl6nqita8qrkhgj4dxj0bjzuvaqj3ntfafre37jrb3olg11h', 'ns5z00unyu4dfhxoyapr5pm522radtfp1m6ov7i8ngbnnib95c', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('c6t9heodnut5jflr7nixeyme0hvg98vi6q4wv0hjg15elb0lyu', 'ns5z00unyu4dfhxoyapr5pm522radtfp1m6ov7i8ngbnnib95c', 1);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('v5d3wm06auzaj88abtlwmq4xm7qz976olp1et58ztznqn7gq4l', 'Playlist 1', '2023-11-17 17:00:08.000','7niawzo6bb63u2u');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2w80uqguadkppjd6c5vu3rcwz86lnfs79su52uwmyu631e31kq', 'v5d3wm06auzaj88abtlwmq4xm7qz976olp1et58ztznqn7gq4l', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('csahcs6zsq0l1l6vtnzwwfnk4qbwuyyenzvh7v5sgbbyta6k4b', 'v5d3wm06auzaj88abtlwmq4xm7qz976olp1et58ztznqn7gq4l', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('kihn2imlymubjfuwy9qrkvwlc3kbicq5e0e3kfb7174gimjnjd', 'v5d3wm06auzaj88abtlwmq4xm7qz976olp1et58ztznqn7gq4l', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('l2afkm21hufds9luujclk4lq92my6pqeyee8htyhfdz1wl7a5v', 'v5d3wm06auzaj88abtlwmq4xm7qz976olp1et58ztznqn7gq4l', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('blpy4v6hr1144hn2v5wrtgqf7wd92vtmp3hqlgc85dxk1w0v1o', 'v5d3wm06auzaj88abtlwmq4xm7qz976olp1et58ztznqn7gq4l', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('15ndc4uiiiho11k2hm4poyf0us93jfaa86ybz4tt1xh1z4ovjq', 'v5d3wm06auzaj88abtlwmq4xm7qz976olp1et58ztznqn7gq4l', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('w16zpnibwlr9q9cvlkk8507ct2ui8r7e51slyxb59zbij1x75s', 'v5d3wm06auzaj88abtlwmq4xm7qz976olp1et58ztznqn7gq4l', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0fb7ncyxppc1mfwctaywx6ucg21jjepzojs3wcmi3bprynce0a', 'v5d3wm06auzaj88abtlwmq4xm7qz976olp1et58ztznqn7gq4l', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2cvgssa50u0jegpofn72xtez9zh8puqi17vy1m37269jk9s821', 'v5d3wm06auzaj88abtlwmq4xm7qz976olp1et58ztznqn7gq4l', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('o68y8dkcx2ixhm9b9peuhv2yu3xjthn2ax2nvmg7ijhhgzthrn', 'v5d3wm06auzaj88abtlwmq4xm7qz976olp1et58ztznqn7gq4l', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('lnrxc8pytqn4s2ex6rsg0pgxwu7wjsxdl3qnbkob8or6piyhyf', 'Playlist 0', '2023-11-17 17:00:08.000','h9grz328f3wfk9g');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tew2vsip9yw70pzbv3g1rbjl50leservxrxix4tf43jd991b8m', 'lnrxc8pytqn4s2ex6rsg0pgxwu7wjsxdl3qnbkob8or6piyhyf', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0cgn9t8krg2kfv4ll4oo8c6yupp3v74fvg8zdl63kemz8jtf6m', 'lnrxc8pytqn4s2ex6rsg0pgxwu7wjsxdl3qnbkob8or6piyhyf', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('rd67zn7a67z9j9vuumvvwfvl0r2ofinl11we24rgj8bif5e2pi', 'lnrxc8pytqn4s2ex6rsg0pgxwu7wjsxdl3qnbkob8or6piyhyf', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('kn51cgelf0dvgzu5tzpnfn9x6jz1e54x7i34rh7qaa6al5mjam', 'lnrxc8pytqn4s2ex6rsg0pgxwu7wjsxdl3qnbkob8or6piyhyf', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('26lbitb2kojyla45i112fm4myjmgd6b441w6xmg8eatzgjswt1', 'lnrxc8pytqn4s2ex6rsg0pgxwu7wjsxdl3qnbkob8or6piyhyf', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m36vo5bbj2sivhw2sr8sf7optbayie5fumupaoyjpfctkha5zk', 'lnrxc8pytqn4s2ex6rsg0pgxwu7wjsxdl3qnbkob8or6piyhyf', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1v1spn9378yapd9zzkfejtg32y8uuznmmruau2fbhwcs3crrho', 'lnrxc8pytqn4s2ex6rsg0pgxwu7wjsxdl3qnbkob8or6piyhyf', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('l49f0nfdljp4l06o1dc9o564put8gzl9f026iiigi74cyhm7a0', 'lnrxc8pytqn4s2ex6rsg0pgxwu7wjsxdl3qnbkob8or6piyhyf', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5wrckeggqtin4cdfm4e3gz27vj4zn142rs7kzhlqcfw7fohn01', 'lnrxc8pytqn4s2ex6rsg0pgxwu7wjsxdl3qnbkob8or6piyhyf', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nd3i9u8nc03uq54mcnwb2fu1d2hq2go3y296i1yo4mzb8fk4nh', 'lnrxc8pytqn4s2ex6rsg0pgxwu7wjsxdl3qnbkob8or6piyhyf', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('cudrhdcl3qlhaz6moxo7bwr2lizi7cbey3gtl59zhwh65ry27l', 'Playlist 1', '2023-11-17 17:00:08.000','h9grz328f3wfk9g');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('c6t9heodnut5jflr7nixeyme0hvg98vi6q4wv0hjg15elb0lyu', 'cudrhdcl3qlhaz6moxo7bwr2lizi7cbey3gtl59zhwh65ry27l', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tkn1shxhlebm7ftwomm5v9mfbcq7awfjv9jeq0bch9bwm3cfe0', 'cudrhdcl3qlhaz6moxo7bwr2lizi7cbey3gtl59zhwh65ry27l', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dqgc5ny35vl1ereq3wekkhztpl60pjnw846cic4it869sedrsz', 'cudrhdcl3qlhaz6moxo7bwr2lizi7cbey3gtl59zhwh65ry27l', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('50u9fo1lq6e7gbf5a7jfl25x5r7zmoylz24xw4amqisto32s49', 'cudrhdcl3qlhaz6moxo7bwr2lizi7cbey3gtl59zhwh65ry27l', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8y32kjtopc1mruxffq8hbc9xe65lioz4dec4a8mid1qh3molc4', 'cudrhdcl3qlhaz6moxo7bwr2lizi7cbey3gtl59zhwh65ry27l', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jjrjq8x0idsewckl0ndpoithtietkm88fhbd32yimagxtron3b', 'cudrhdcl3qlhaz6moxo7bwr2lizi7cbey3gtl59zhwh65ry27l', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0puqr72wva7cwjn67o2uc6f67aerxbvet1ejnfecb63wwc3pjp', 'cudrhdcl3qlhaz6moxo7bwr2lizi7cbey3gtl59zhwh65ry27l', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('77afzq8gd2srtcm7homs8120fw100om6izgf2wbmlsa70mgmq2', 'cudrhdcl3qlhaz6moxo7bwr2lizi7cbey3gtl59zhwh65ry27l', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('haa4zbq8ukdkpaaclq14bj5seimkf8ei8fqixlvyhqz2r2n4y6', 'cudrhdcl3qlhaz6moxo7bwr2lizi7cbey3gtl59zhwh65ry27l', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1v1spn9378yapd9zzkfejtg32y8uuznmmruau2fbhwcs3crrho', 'cudrhdcl3qlhaz6moxo7bwr2lizi7cbey3gtl59zhwh65ry27l', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('r6aylsvd3wx8vg9wi2wt1ce6gulvo3n3jjzytf8i4ngcht1do8', 'Playlist 0', '2023-11-17 17:00:08.000','m4t851dyjzqe6qh');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5bk1i17ftkq95ojq2ndcsmc8yeiaasgx4dchongouirsuq78xj', 'r6aylsvd3wx8vg9wi2wt1ce6gulvo3n3jjzytf8i4ngcht1do8', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r2l8unvvwp9dmafha643b3ti95dxp6czif1stgiu0jov96v5nd', 'r6aylsvd3wx8vg9wi2wt1ce6gulvo3n3jjzytf8i4ngcht1do8', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('csahcs6zsq0l1l6vtnzwwfnk4qbwuyyenzvh7v5sgbbyta6k4b', 'r6aylsvd3wx8vg9wi2wt1ce6gulvo3n3jjzytf8i4ngcht1do8', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('c6ngltveh0of75fagaph3gweye1kd32mjgc9hj7ghfzu0n4q1l', 'r6aylsvd3wx8vg9wi2wt1ce6gulvo3n3jjzytf8i4ngcht1do8', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wueguh3hlj48tn8lfkdioibo4svg2vas40renv0idwv3gi9bj3', 'r6aylsvd3wx8vg9wi2wt1ce6gulvo3n3jjzytf8i4ngcht1do8', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gie926pbwtneadz3ybfx2qpuirir808gcmhbkgh3kn09qzy6jn', 'r6aylsvd3wx8vg9wi2wt1ce6gulvo3n3jjzytf8i4ngcht1do8', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7l9mf815b87xy1cbq4qwlqpxl8j6i0te0il5fr7ofjqhavfzn8', 'r6aylsvd3wx8vg9wi2wt1ce6gulvo3n3jjzytf8i4ngcht1do8', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('loba7mmjlo79auc1z4trmt3wqqvt9n5sm2unjnoujth1bo7we3', 'r6aylsvd3wx8vg9wi2wt1ce6gulvo3n3jjzytf8i4ngcht1do8', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('evsus8h8nghfhdcpl1gk3xs1qervidoekhxmozz4s5m49gkwfw', 'r6aylsvd3wx8vg9wi2wt1ce6gulvo3n3jjzytf8i4ngcht1do8', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('322r3m8yptrtfqmuscsqem9kqnxkdl0hh9rmgufhj3kudrhgi7', 'r6aylsvd3wx8vg9wi2wt1ce6gulvo3n3jjzytf8i4ngcht1do8', 5);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('sqd85jsbeqepyu3b83tn0oh1gt8h8wgaojm15590l7t9th5ipo', 'Playlist 1', '2023-11-17 17:00:08.000','m4t851dyjzqe6qh');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ci5hsq8bdd47qx3jqd13tzyftn4mfnt8j5r2pnv7bpo0ld9w0e', 'sqd85jsbeqepyu3b83tn0oh1gt8h8wgaojm15590l7t9th5ipo', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yn12h9tixlxrw6unm4q9ah0emxen63xc3kxh4s57ysuuzwq9hj', 'sqd85jsbeqepyu3b83tn0oh1gt8h8wgaojm15590l7t9th5ipo', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('u01low24c4qbfjsbw8rpo3dvx4grrf5m7qi174kcpqjp72d6vy', 'sqd85jsbeqepyu3b83tn0oh1gt8h8wgaojm15590l7t9th5ipo', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('j6yuzi67b9st5pbopfcdqxgiw63v5euk5il58u3yi3xyb8glpp', 'sqd85jsbeqepyu3b83tn0oh1gt8h8wgaojm15590l7t9th5ipo', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nwuo3pb19gzfpd4il2ly40r21w2p37qbid4hk063i9ti2kh4qy', 'sqd85jsbeqepyu3b83tn0oh1gt8h8wgaojm15590l7t9th5ipo', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('11edw8dcwst48wetouxuf0dw4nk9unrhzacl27zmqcgoebwm51', 'sqd85jsbeqepyu3b83tn0oh1gt8h8wgaojm15590l7t9th5ipo', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yo0a2a7ur6bvs61uva2bik2iww9a49u755du9nybitm4zd11ag', 'sqd85jsbeqepyu3b83tn0oh1gt8h8wgaojm15590l7t9th5ipo', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jwu28lpdtcukl4a9gyjgogni8tqvdqtvpum7oh7qgfxzfgq4sv', 'sqd85jsbeqepyu3b83tn0oh1gt8h8wgaojm15590l7t9th5ipo', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('lqi3km8q4uvnxtw96eud81b7zm1abev2jeb2z1tw35ich5kgsz', 'sqd85jsbeqepyu3b83tn0oh1gt8h8wgaojm15590l7t9th5ipo', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('necdsqrccwraqegrwg1w42k7zu0bz9urbgmdeud6p2efd6oou7', 'sqd85jsbeqepyu3b83tn0oh1gt8h8wgaojm15590l7t9th5ipo', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('6j5glnc0zvdbym08py0uysf8mw6mteqla5v95287p40pj7aek5', 'Playlist 0', '2023-11-17 17:00:08.000','kcp913in2bq0pft');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zks15pyl5rckmq9zyyzrxrqmefjwxyal6f7hdg9znck4uztg7m', '6j5glnc0zvdbym08py0uysf8mw6mteqla5v95287p40pj7aek5', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1rntiohxm44x5w2nlftxa7skfuf1jlpinz0dlq9cfh414rtcze', '6j5glnc0zvdbym08py0uysf8mw6mteqla5v95287p40pj7aek5', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tkn1shxhlebm7ftwomm5v9mfbcq7awfjv9jeq0bch9bwm3cfe0', '6j5glnc0zvdbym08py0uysf8mw6mteqla5v95287p40pj7aek5', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e1zd9oal3t4kdu615mg5tr2mikd8gf1cqkbcw15bzht3lk1c7x', '6j5glnc0zvdbym08py0uysf8mw6mteqla5v95287p40pj7aek5', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('iatc65hh5cu9zi5qfldjqdfojqfx8dpq0zelle5z5wou78pjxf', '6j5glnc0zvdbym08py0uysf8mw6mteqla5v95287p40pj7aek5', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tfvtaajuwwqb96hmf55sxi66b81zqn34fh6nzh2mpv84gnrmob', '6j5glnc0zvdbym08py0uysf8mw6mteqla5v95287p40pj7aek5', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gs6y2zoupf8brw7flmkkvsjtsh103059dh208w5a42mj1tur6g', '6j5glnc0zvdbym08py0uysf8mw6mteqla5v95287p40pj7aek5', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8bnldu8pphtk1rqz6e0nj6gj2khftdbnrfyupu1e2k6pveschy', '6j5glnc0zvdbym08py0uysf8mw6mteqla5v95287p40pj7aek5', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9o5kclx1d1a4ab905x40owle4ith1hie2m51iikl5fpco0w4l5', '6j5glnc0zvdbym08py0uysf8mw6mteqla5v95287p40pj7aek5', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0fb7ncyxppc1mfwctaywx6ucg21jjepzojs3wcmi3bprynce0a', '6j5glnc0zvdbym08py0uysf8mw6mteqla5v95287p40pj7aek5', 5);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('apukr43kasi9r8cjpwgl7m07t0suqw6g6i46gea6ggkz12i9ac', 'Playlist 1', '2023-11-17 17:00:08.000','kcp913in2bq0pft');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tqsxq1y8bqpux513z0pjipspfby80j179oxqsrfoq8ybfzdqkr', 'apukr43kasi9r8cjpwgl7m07t0suqw6g6i46gea6ggkz12i9ac', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('774upyhyifoq3bvw2kg790yu6x7hozt0f4zwcu0uvw6bqda2wu', 'apukr43kasi9r8cjpwgl7m07t0suqw6g6i46gea6ggkz12i9ac', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('35gvr6nui69gw1nhnb8ty8sy9id5bhwxohi2a096dh6payg47w', 'apukr43kasi9r8cjpwgl7m07t0suqw6g6i46gea6ggkz12i9ac', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('j5912n11dm9b2lxyy2141ldndkvk83v91elqyo798hasadbcfa', 'apukr43kasi9r8cjpwgl7m07t0suqw6g6i46gea6ggkz12i9ac', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dxp517pqis8jjxl2eulxdr5m8ekeclkzt01ydles99d6838opq', 'apukr43kasi9r8cjpwgl7m07t0suqw6g6i46gea6ggkz12i9ac', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r8mqfpgxcc0e4vqvdzqzbw6ic703mxi6528w9i69zohlpgdo9p', 'apukr43kasi9r8cjpwgl7m07t0suqw6g6i46gea6ggkz12i9ac', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gi63ppli8yyi94r4p3z9kpi0t4swy1o93xx9j3q7zg48zh8eus', 'apukr43kasi9r8cjpwgl7m07t0suqw6g6i46gea6ggkz12i9ac', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gie926pbwtneadz3ybfx2qpuirir808gcmhbkgh3kn09qzy6jn', 'apukr43kasi9r8cjpwgl7m07t0suqw6g6i46gea6ggkz12i9ac', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jycm7ygfvme89cmpm1n6vw8z66o8q5fiwgyle6ilpr2o429ir5', 'apukr43kasi9r8cjpwgl7m07t0suqw6g6i46gea6ggkz12i9ac', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wtveg1z119kqqx0lxffowngjxzezoliytltwa568dsl02dpvcc', 'apukr43kasi9r8cjpwgl7m07t0suqw6g6i46gea6ggkz12i9ac', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('eo1ulpb5ibgvfnfy269p8a9ftrp5skq41mtr7se1v2aze7glys', 'Playlist 0', '2023-11-17 17:00:08.000','dze8m8msphmg7nh');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('j34quqz5nsnjx2gbwwjurdbim1q7zqm60n0ow9ehv282fumkte', 'eo1ulpb5ibgvfnfy269p8a9ftrp5skq41mtr7se1v2aze7glys', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('whrn2m9r85lez34ozn6va5yne1rnqhpgmzq3agcj32eg9r6euf', 'eo1ulpb5ibgvfnfy269p8a9ftrp5skq41mtr7se1v2aze7glys', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('s6dah8gtxkjbq2gvhuagao94xs7hv9geo5i0lku99182hy26yd', 'eo1ulpb5ibgvfnfy269p8a9ftrp5skq41mtr7se1v2aze7glys', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0mdjot2sdqe0wxme1dzrzu267illd625day51btkn7p8ycz315', 'eo1ulpb5ibgvfnfy269p8a9ftrp5skq41mtr7se1v2aze7glys', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('231hft1d1uj657xlxxtceovk5bgk5gek4f8kfqrwux96na4h8f', 'eo1ulpb5ibgvfnfy269p8a9ftrp5skq41mtr7se1v2aze7glys', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('msj2px3g88z72zoia5961ckrrsgwx0gxjy1520bt121rb6r64y', 'eo1ulpb5ibgvfnfy269p8a9ftrp5skq41mtr7se1v2aze7glys', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qvde8z6qweeh7qwscta6ydkq9pydydah1te3abbqldb7ne9fk7', 'eo1ulpb5ibgvfnfy269p8a9ftrp5skq41mtr7se1v2aze7glys', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gd70guz94jkvln1k9qhg1d9ifqcfvdn0nc5v38woyro4ilil5d', 'eo1ulpb5ibgvfnfy269p8a9ftrp5skq41mtr7se1v2aze7glys', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6t0iyxfzgbhzbm7gpectlibq1e7icrry63eup7y3av1bv5c9zp', 'eo1ulpb5ibgvfnfy269p8a9ftrp5skq41mtr7se1v2aze7glys', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m11ced2h94fqa66u5cd4zo3tan40s1hi9cxbx7cxp8w012f7vm', 'eo1ulpb5ibgvfnfy269p8a9ftrp5skq41mtr7se1v2aze7glys', 1);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('g0y9vvs09gxvf0wis1vao270335lmxuv81vosc21hqulg6oqvh', 'Playlist 1', '2023-11-17 17:00:08.000','dze8m8msphmg7nh');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('smckoe4y156ctu6orjwpvr014bv7yffe795tped92la5weu7yj', 'g0y9vvs09gxvf0wis1vao270335lmxuv81vosc21hqulg6oqvh', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('p54vkjicjp6o0eus814hw1lfft4053548e1iziix5ox6i02oov', 'g0y9vvs09gxvf0wis1vao270335lmxuv81vosc21hqulg6oqvh', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('g7npiqoa9y6asqklq60drw3qbxxtcrwj21iqoh7xyfnaubfqt3', 'g0y9vvs09gxvf0wis1vao270335lmxuv81vosc21hqulg6oqvh', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wueguh3hlj48tn8lfkdioibo4svg2vas40renv0idwv3gi9bj3', 'g0y9vvs09gxvf0wis1vao270335lmxuv81vosc21hqulg6oqvh', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t026mvwzcp42u61nfardj2c9nplypyrhqmqfloa651sy2hnf3l', 'g0y9vvs09gxvf0wis1vao270335lmxuv81vosc21hqulg6oqvh', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('631v1xk5rofzvciyu12mk5dv1fko44qzmsdlud9wg8agh9kqs4', 'g0y9vvs09gxvf0wis1vao270335lmxuv81vosc21hqulg6oqvh', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tiaq301c8ctje36xzp7no1fwi2q43y1c425fer4l1di8ahnhx1', 'g0y9vvs09gxvf0wis1vao270335lmxuv81vosc21hqulg6oqvh', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jonhbvm7f40a8l8ndokfm2uah239ywr6pj6hwne5ejms5q1ovx', 'g0y9vvs09gxvf0wis1vao270335lmxuv81vosc21hqulg6oqvh', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yp7jzun3aorz6ctvx00svxvtr8a66448cyz3qcn4xjri94f34w', 'g0y9vvs09gxvf0wis1vao270335lmxuv81vosc21hqulg6oqvh', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d3yizui400anwdxuunqgbz19n5y7aowqjvjvxptb9cdtmu06uw', 'g0y9vvs09gxvf0wis1vao270335lmxuv81vosc21hqulg6oqvh', 1);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('2mggowgp7ix5j5aq1v0kuj4aer6iqhqtmsphykmdhtuktr256g', 'Playlist 0', '2023-11-17 17:00:08.000','2wt2309ehptszic');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1bo56kzodxmljstj46ahdettlzoz5skogszfcmndjrikydrtsd', '2mggowgp7ix5j5aq1v0kuj4aer6iqhqtmsphykmdhtuktr256g', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yo0a2a7ur6bvs61uva2bik2iww9a49u755du9nybitm4zd11ag', '2mggowgp7ix5j5aq1v0kuj4aer6iqhqtmsphykmdhtuktr256g', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('iihyqs3o9bh3f3c3wl2x7yvmx01q4erl6nzn2qn4it1xie3u92', '2mggowgp7ix5j5aq1v0kuj4aer6iqhqtmsphykmdhtuktr256g', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('kxul8uiw0vqgxqftx7qmq2mche7tbp1skbljae07buhem3rhov', '2mggowgp7ix5j5aq1v0kuj4aer6iqhqtmsphykmdhtuktr256g', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xcog7a81v61vec2jbxydv0d8yainv3xevcdyp2z1anqs825qbv', '2mggowgp7ix5j5aq1v0kuj4aer6iqhqtmsphykmdhtuktr256g', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xi1brm96bbt41z21w4tzu7uyzr36ehq5et1caokq9yh69cxqxj', '2mggowgp7ix5j5aq1v0kuj4aer6iqhqtmsphykmdhtuktr256g', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8166k9lwf2kotvkmwde943ea05urfcbdrk5gizdy1usug5k54w', '2mggowgp7ix5j5aq1v0kuj4aer6iqhqtmsphykmdhtuktr256g', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2zhmcwu1thz5y5wemlj7trpfgkeby832q0myvrym2alknznnhg', '2mggowgp7ix5j5aq1v0kuj4aer6iqhqtmsphykmdhtuktr256g', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3gfz5u54z0nrgfps3m4xb5423evmzl72szoxid80a0ez3vbfvo', '2mggowgp7ix5j5aq1v0kuj4aer6iqhqtmsphykmdhtuktr256g', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0fb7ncyxppc1mfwctaywx6ucg21jjepzojs3wcmi3bprynce0a', '2mggowgp7ix5j5aq1v0kuj4aer6iqhqtmsphykmdhtuktr256g', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('hltz7le2kz2reopg5jyef4ps7oolxad0eg6zqqkkgp78hobtzr', 'Playlist 1', '2023-11-17 17:00:08.000','2wt2309ehptszic');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ndgcn7bioi73xl6ggzil935tt55hyeu3z9qwxecvm5zczakxg4', 'hltz7le2kz2reopg5jyef4ps7oolxad0eg6zqqkkgp78hobtzr', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sxplhgm7ixfsyw08btkwva72418njcvxtvxwftzai06kgl8hyy', 'hltz7le2kz2reopg5jyef4ps7oolxad0eg6zqqkkgp78hobtzr', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wvjeyvzp5591nzimio2lrqr4p6ujcbna8onehmqeuypoccz4i5', 'hltz7le2kz2reopg5jyef4ps7oolxad0eg6zqqkkgp78hobtzr', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('64fuawrkdm2lmx632c9q3z1o6y41zgiil128sln6r7getfg36e', 'hltz7le2kz2reopg5jyef4ps7oolxad0eg6zqqkkgp78hobtzr', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dqgc5ny35vl1ereq3wekkhztpl60pjnw846cic4it869sedrsz', 'hltz7le2kz2reopg5jyef4ps7oolxad0eg6zqqkkgp78hobtzr', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r6ok55kjqgbtsonljffqzoykiqvvz121qq3c61f7lrxvxhkhk6', 'hltz7le2kz2reopg5jyef4ps7oolxad0eg6zqqkkgp78hobtzr', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pjje012rlfldn4tvpth2tm2y00i8t0bezrlnint716yuwfl0o7', 'hltz7le2kz2reopg5jyef4ps7oolxad0eg6zqqkkgp78hobtzr', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gi63ppli8yyi94r4p3z9kpi0t4swy1o93xx9j3q7zg48zh8eus', 'hltz7le2kz2reopg5jyef4ps7oolxad0eg6zqqkkgp78hobtzr', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8nsl3c9oj35sbng7v13wh81tbkksyijxjfxd3islny4vu7188h', 'hltz7le2kz2reopg5jyef4ps7oolxad0eg6zqqkkgp78hobtzr', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0mdjot2sdqe0wxme1dzrzu267illd625day51btkn7p8ycz315', 'hltz7le2kz2reopg5jyef4ps7oolxad0eg6zqqkkgp78hobtzr', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('k77tkf9tokjidfu5air3h01l8by3kzt095ugyarsivufnzab4m', 'Playlist 0', '2023-11-17 17:00:08.000','pxu54pmgawm34b5');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dozsnoqnrrsy1it84uh7a8sk8hk3vbjm9oag3s0ietjusbye3p', 'k77tkf9tokjidfu5air3h01l8by3kzt095ugyarsivufnzab4m', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('n13p77gmxbv1eo1oxw7vddw8mxk47q79r3k713z1agff5mq36q', 'k77tkf9tokjidfu5air3h01l8by3kzt095ugyarsivufnzab4m', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vbqe9nz17t8voc16a65d68tb8rucst0taqi9qw9x0hs30bnkup', 'k77tkf9tokjidfu5air3h01l8by3kzt095ugyarsivufnzab4m', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3id2i4opy7ihcpxjst5jiwvdyptefqsy8lh1o278a89tdnbya0', 'k77tkf9tokjidfu5air3h01l8by3kzt095ugyarsivufnzab4m', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5b85geoidcsihlf3waokmbmt2m38zkl1w6dfg7fa0hxti3wett', 'k77tkf9tokjidfu5air3h01l8by3kzt095ugyarsivufnzab4m', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sr5kpyaiy2vanz3vua62t12xytsb6cylmixyd8y5unzwniivj9', 'k77tkf9tokjidfu5air3h01l8by3kzt095ugyarsivufnzab4m', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('feldhhhvhc6hgaix4sukzqhj2d4sm9x0tj8fpa41m6kl51gs8l', 'k77tkf9tokjidfu5air3h01l8by3kzt095ugyarsivufnzab4m', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t262b37x1ryp8iee876vo0oqkyd0iwnkkeno5iwnlbor4sslh6', 'k77tkf9tokjidfu5air3h01l8by3kzt095ugyarsivufnzab4m', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ykz1t2fkvk9edkhm4i7fs1ogqzppkxgg3vvjaduu4l2rpmcxoc', 'k77tkf9tokjidfu5air3h01l8by3kzt095ugyarsivufnzab4m', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zri3rwtyn237y36ed2sv2p91kgktnesx044cacywo24xygm0ed', 'k77tkf9tokjidfu5air3h01l8by3kzt095ugyarsivufnzab4m', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('5tnt0pw3od7qlmebajepd2y1xr42etu2j4t0e0gmkiu9y3lqk4', 'Playlist 1', '2023-11-17 17:00:08.000','pxu54pmgawm34b5');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('32nl86jqftw9vu2fz0e1mqw50378yfstpdb4hdsw1f4e8wquz0', '5tnt0pw3od7qlmebajepd2y1xr42etu2j4t0e0gmkiu9y3lqk4', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r2l8unvvwp9dmafha643b3ti95dxp6czif1stgiu0jov96v5nd', '5tnt0pw3od7qlmebajepd2y1xr42etu2j4t0e0gmkiu9y3lqk4', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t262b37x1ryp8iee876vo0oqkyd0iwnkkeno5iwnlbor4sslh6', '5tnt0pw3od7qlmebajepd2y1xr42etu2j4t0e0gmkiu9y3lqk4', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('g63jux2fb0o4l6dloi5neygw9aic6s0h1b5o7i06mbnli72io4', '5tnt0pw3od7qlmebajepd2y1xr42etu2j4t0e0gmkiu9y3lqk4', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('x214n1i36q2sfh7qrpg0swgxskizlw9fcedyuw7xh6n415vu06', '5tnt0pw3od7qlmebajepd2y1xr42etu2j4t0e0gmkiu9y3lqk4', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fy0pplbuncgxpw1jpxdwb7l9quil258fwwq5ak7gx8ojd6atga', '5tnt0pw3od7qlmebajepd2y1xr42etu2j4t0e0gmkiu9y3lqk4', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3gfz5u54z0nrgfps3m4xb5423evmzl72szoxid80a0ez3vbfvo', '5tnt0pw3od7qlmebajepd2y1xr42etu2j4t0e0gmkiu9y3lqk4', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r8mqfpgxcc0e4vqvdzqzbw6ic703mxi6528w9i69zohlpgdo9p', '5tnt0pw3od7qlmebajepd2y1xr42etu2j4t0e0gmkiu9y3lqk4', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('82zgg8q2s2cw6aatnh1ymgmnxcfa4pyb02v9uxah3p0tepklui', '5tnt0pw3od7qlmebajepd2y1xr42etu2j4t0e0gmkiu9y3lqk4', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8nsl3c9oj35sbng7v13wh81tbkksyijxjfxd3islny4vu7188h', '5tnt0pw3od7qlmebajepd2y1xr42etu2j4t0e0gmkiu9y3lqk4', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('alpa4al5u00678584te0ah23i6m2yl7zxv78h05fzkrmdmsbr8', 'Playlist 0', '2023-11-17 17:00:08.000','nz4nme54t9n8mts');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ei5a1so4126vbvjcif2hbtgqwcvc9i0qmkryj7cvz975w8qkjs', 'alpa4al5u00678584te0ah23i6m2yl7zxv78h05fzkrmdmsbr8', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wvjeyvzp5591nzimio2lrqr4p6ujcbna8onehmqeuypoccz4i5', 'alpa4al5u00678584te0ah23i6m2yl7zxv78h05fzkrmdmsbr8', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sxplhgm7ixfsyw08btkwva72418njcvxtvxwftzai06kgl8hyy', 'alpa4al5u00678584te0ah23i6m2yl7zxv78h05fzkrmdmsbr8', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sr5kpyaiy2vanz3vua62t12xytsb6cylmixyd8y5unzwniivj9', 'alpa4al5u00678584te0ah23i6m2yl7zxv78h05fzkrmdmsbr8', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m36vo5bbj2sivhw2sr8sf7optbayie5fumupaoyjpfctkha5zk', 'alpa4al5u00678584te0ah23i6m2yl7zxv78h05fzkrmdmsbr8', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hdw1rrijtsyqzmshebypj3bok7tb6poe8v00mqyuog3fhbku3u', 'alpa4al5u00678584te0ah23i6m2yl7zxv78h05fzkrmdmsbr8', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qvde8z6qweeh7qwscta6ydkq9pydydah1te3abbqldb7ne9fk7', 'alpa4al5u00678584te0ah23i6m2yl7zxv78h05fzkrmdmsbr8', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('a2wal9ubprdh0u62bse7ochv0dfoipw8nk2l2n3zreie379y04', 'alpa4al5u00678584te0ah23i6m2yl7zxv78h05fzkrmdmsbr8', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('io6lrugkmkfjxfvfkdjo3r5l1la1cavwq4learbauvmmq8z64o', 'alpa4al5u00678584te0ah23i6m2yl7zxv78h05fzkrmdmsbr8', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m904w4da5ldnke0bj3tbvum2swjyr4uwidevds19addajptf9d', 'alpa4al5u00678584te0ah23i6m2yl7zxv78h05fzkrmdmsbr8', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('vr11x784tbirj8lvgnvdjlxtzsf8l1xpjxoxc4hc8gktx1ilro', 'Playlist 1', '2023-11-17 17:00:08.000','nz4nme54t9n8mts');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tiaq301c8ctje36xzp7no1fwi2q43y1c425fer4l1di8ahnhx1', 'vr11x784tbirj8lvgnvdjlxtzsf8l1xpjxoxc4hc8gktx1ilro', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3p6qm7d5sdcxinrozvne9ygvstptiasvmeaub86h05ry2wf9sf', 'vr11x784tbirj8lvgnvdjlxtzsf8l1xpjxoxc4hc8gktx1ilro', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3r6m301nun5e7qpde1tueanlvg4lshz7xbhwm0eidia0tpy67h', 'vr11x784tbirj8lvgnvdjlxtzsf8l1xpjxoxc4hc8gktx1ilro', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1v1spn9378yapd9zzkfejtg32y8uuznmmruau2fbhwcs3crrho', 'vr11x784tbirj8lvgnvdjlxtzsf8l1xpjxoxc4hc8gktx1ilro', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5wm9dsmfvcagzg9xbp3cmrpfhefudzx8ivmfuj5h8gxdake5ej', 'vr11x784tbirj8lvgnvdjlxtzsf8l1xpjxoxc4hc8gktx1ilro', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xn7oyxcnjkl0dkm1d8qaysrvhrobwt7n33v1im81mlh8y062nm', 'vr11x784tbirj8lvgnvdjlxtzsf8l1xpjxoxc4hc8gktx1ilro', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hb3akrrthrklf9hed0k0ghfil2ca30f6itx0y5rscn2qf3zz9x', 'vr11x784tbirj8lvgnvdjlxtzsf8l1xpjxoxc4hc8gktx1ilro', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('rekbhxoc0a6pm4izwz350a9ofu1hhma7jcrjslapmnenticag6', 'vr11x784tbirj8lvgnvdjlxtzsf8l1xpjxoxc4hc8gktx1ilro', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z9izqkhvuo3t5yxo185pqmbmced5gx0etprjra3ysgl8q0t6al', 'vr11x784tbirj8lvgnvdjlxtzsf8l1xpjxoxc4hc8gktx1ilro', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('oiy7bd5b5trw0zz19wacrxk1excu7enzm7vc22lxf1360all8w', 'vr11x784tbirj8lvgnvdjlxtzsf8l1xpjxoxc4hc8gktx1ilro', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('5nyxvrfg6fkxftjxk3palfzdb2ca3axoeoqaso1ebdtgzlu2ty', 'Playlist 0', '2023-11-17 17:00:08.000','czeh5bn7jkh7am1');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tbey4tiujgb89ad0f4lknlhhxs8um8fo8lci2xbdcub9h66vuf', '5nyxvrfg6fkxftjxk3palfzdb2ca3axoeoqaso1ebdtgzlu2ty', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('kpo5br8yogzk91u8sizt3vjbsstb4nvep37qg9oc86n81pm144', '5nyxvrfg6fkxftjxk3palfzdb2ca3axoeoqaso1ebdtgzlu2ty', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4hiny6gppfrtoi5pcd0f8nbkgt3xoekd4nwjrxc1kwj3mhe30c', '5nyxvrfg6fkxftjxk3palfzdb2ca3axoeoqaso1ebdtgzlu2ty', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('oiy7bd5b5trw0zz19wacrxk1excu7enzm7vc22lxf1360all8w', '5nyxvrfg6fkxftjxk3palfzdb2ca3axoeoqaso1ebdtgzlu2ty', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('11edw8dcwst48wetouxuf0dw4nk9unrhzacl27zmqcgoebwm51', '5nyxvrfg6fkxftjxk3palfzdb2ca3axoeoqaso1ebdtgzlu2ty', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3id2i4opy7ihcpxjst5jiwvdyptefqsy8lh1o278a89tdnbya0', '5nyxvrfg6fkxftjxk3palfzdb2ca3axoeoqaso1ebdtgzlu2ty', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yvmznbf0hv9xpz9gnpcses50rk1qc8l9cf50e9cytju25bxr4p', '5nyxvrfg6fkxftjxk3palfzdb2ca3axoeoqaso1ebdtgzlu2ty', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cpvu4hijm34ksydbywic7vf0pjpf3diogo65n374th18gi2wpr', '5nyxvrfg6fkxftjxk3palfzdb2ca3axoeoqaso1ebdtgzlu2ty', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('rerj1i9s297p8zxspfkm6nl4hcup4jupepvoxq5akmog1qq1s4', '5nyxvrfg6fkxftjxk3palfzdb2ca3axoeoqaso1ebdtgzlu2ty', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('15ndc4uiiiho11k2hm4poyf0us93jfaa86ybz4tt1xh1z4ovjq', '5nyxvrfg6fkxftjxk3palfzdb2ca3axoeoqaso1ebdtgzlu2ty', 0);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('70tftnks570h6ohw015a4sg79zcdbqdno7b3o9uyn603wjs61v', 'Playlist 1', '2023-11-17 17:00:08.000','czeh5bn7jkh7am1');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('lb08uh1ektid8b87uxeypkwbk7mdcujnnezjzprrriuryi2b8d', '70tftnks570h6ohw015a4sg79zcdbqdno7b3o9uyn603wjs61v', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m3qdhiy2dbhilwu55ilb7hnxmcjpgya879m2tvspeoxnrpo96w', '70tftnks570h6ohw015a4sg79zcdbqdno7b3o9uyn603wjs61v', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('f13wn0t4b8l3l89zjeyfznit1y3a2dcoqnywjnm63j67xtkhlc', '70tftnks570h6ohw015a4sg79zcdbqdno7b3o9uyn603wjs61v', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jycm7ygfvme89cmpm1n6vw8z66o8q5fiwgyle6ilpr2o429ir5', '70tftnks570h6ohw015a4sg79zcdbqdno7b3o9uyn603wjs61v', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('74ypdqln1a71mjwclbqtfuxfxf0unihdg7a66r1le4nqlgi5vt', '70tftnks570h6ohw015a4sg79zcdbqdno7b3o9uyn603wjs61v', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3id2i4opy7ihcpxjst5jiwvdyptefqsy8lh1o278a89tdnbya0', '70tftnks570h6ohw015a4sg79zcdbqdno7b3o9uyn603wjs61v', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h6eqxs8xfcitd4mj3f6mdzr43yp94qvea0gymrtxm8xcaz9ii5', '70tftnks570h6ohw015a4sg79zcdbqdno7b3o9uyn603wjs61v', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jjrjq8x0idsewckl0ndpoithtietkm88fhbd32yimagxtron3b', '70tftnks570h6ohw015a4sg79zcdbqdno7b3o9uyn603wjs61v', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2gtdy3wi45t91i6mueohgljt7ds0e93yqtzylkx82m2esfurb5', '70tftnks570h6ohw015a4sg79zcdbqdno7b3o9uyn603wjs61v', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('90ji8mi6s12q8045pa4etd800vf7q7k58js7ew9old5rzb8ebd', '70tftnks570h6ohw015a4sg79zcdbqdno7b3o9uyn603wjs61v', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('h05ux36j5cw0fqf0ggtifg32qrbp7othw4y4xsadk1atcusoxp', 'Playlist 0', '2023-11-17 17:00:08.000','ehjowsa0xfnqkor');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('774upyhyifoq3bvw2kg790yu6x7hozt0f4zwcu0uvw6bqda2wu', 'h05ux36j5cw0fqf0ggtifg32qrbp7othw4y4xsadk1atcusoxp', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('25ql5d1yqqfgopfoauu7jptebngutz4bg78pytikhs2bdti12x', 'h05ux36j5cw0fqf0ggtifg32qrbp7othw4y4xsadk1atcusoxp', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('c224fx45osca9xc2v9849zev0upyltcd7z205wjkkyc09c9tgk', 'h05ux36j5cw0fqf0ggtifg32qrbp7othw4y4xsadk1atcusoxp', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4rzwt2zunhc1frg6y0pni00wf9ot6xsf8fxnww1a5qi15n6czw', 'h05ux36j5cw0fqf0ggtifg32qrbp7othw4y4xsadk1atcusoxp', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9x3e3xexl8l4dd5h1zzs5fdicear5xzpn7o7ambphslk29m7d7', 'h05ux36j5cw0fqf0ggtifg32qrbp7othw4y4xsadk1atcusoxp', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9lg60iuvyl45tc9iqljb3by2uve4ncdrx74cf5ewek3po1fmv5', 'h05ux36j5cw0fqf0ggtifg32qrbp7othw4y4xsadk1atcusoxp', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tkn1shxhlebm7ftwomm5v9mfbcq7awfjv9jeq0bch9bwm3cfe0', 'h05ux36j5cw0fqf0ggtifg32qrbp7othw4y4xsadk1atcusoxp', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2wpb4suprf3f4cjvfxlgic9cns3c6ldn33fd68dg2it43unshp', 'h05ux36j5cw0fqf0ggtifg32qrbp7othw4y4xsadk1atcusoxp', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0erq9hdgpz936j977bmh2exhcp3085gt6mw7m33rzcah489r2m', 'h05ux36j5cw0fqf0ggtifg32qrbp7othw4y4xsadk1atcusoxp', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('buigrnein2kwdq82f9qtjhsmp91kb5bpivj910ijw05bxye7by', 'h05ux36j5cw0fqf0ggtifg32qrbp7othw4y4xsadk1atcusoxp', 1);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('s5o3tg0dv60p8gnewf06fx4e7bpml1ynvjmvycnhvmdmq25rd0', 'Playlist 1', '2023-11-17 17:00:08.000','ehjowsa0xfnqkor');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tqsxq1y8bqpux513z0pjipspfby80j179oxqsrfoq8ybfzdqkr', 's5o3tg0dv60p8gnewf06fx4e7bpml1ynvjmvycnhvmdmq25rd0', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('o4xa9lbcdh085igdngd9esh84m4ccp9rhkio7jzxmrf4hn9ryq', 's5o3tg0dv60p8gnewf06fx4e7bpml1ynvjmvycnhvmdmq25rd0', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('g9qf2mn1rahrhi74ogmzmriksw0qv6w952odl4l1bzb1v01aee', 's5o3tg0dv60p8gnewf06fx4e7bpml1ynvjmvycnhvmdmq25rd0', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('q6qwsmizragkm32sspl1lwfl3lhgl36ygo6it8ji026jh9bkoe', 's5o3tg0dv60p8gnewf06fx4e7bpml1ynvjmvycnhvmdmq25rd0', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2nxph8llg9prquhlm6rhkzxyz7fy0o7qm8uceeyut6kyphuqwn', 's5o3tg0dv60p8gnewf06fx4e7bpml1ynvjmvycnhvmdmq25rd0', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m36vo5bbj2sivhw2sr8sf7optbayie5fumupaoyjpfctkha5zk', 's5o3tg0dv60p8gnewf06fx4e7bpml1ynvjmvycnhvmdmq25rd0', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m904w4da5ldnke0bj3tbvum2swjyr4uwidevds19addajptf9d', 's5o3tg0dv60p8gnewf06fx4e7bpml1ynvjmvycnhvmdmq25rd0', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dxp517pqis8jjxl2eulxdr5m8ekeclkzt01ydles99d6838opq', 's5o3tg0dv60p8gnewf06fx4e7bpml1ynvjmvycnhvmdmq25rd0', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5mh84w8dh72nphaqgwk6ns38czwuq58fpfkouueqs8bg9tvuw9', 's5o3tg0dv60p8gnewf06fx4e7bpml1ynvjmvycnhvmdmq25rd0', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e2qretngwhk7rjj6ikm00g6nvg9rc6ctmsok7vnfwca88q3y5x', 's5o3tg0dv60p8gnewf06fx4e7bpml1ynvjmvycnhvmdmq25rd0', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('k7ucgvllyibm6j7wlcrxumsedssqep2h2glg7x1bzt89296qsz', 'Playlist 0', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9db4xjoy4izvyp12q3xfu9pn2fozh4m6mro2sj0n5hmadkkv62', 'k7ucgvllyibm6j7wlcrxumsedssqep2h2glg7x1bzt89296qsz', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xi1brm96bbt41z21w4tzu7uyzr36ehq5et1caokq9yh69cxqxj', 'k7ucgvllyibm6j7wlcrxumsedssqep2h2glg7x1bzt89296qsz', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d0n59p55h7s3bqbf4k5zzoxhginczwwj1rarl6y8s4c20r7kcg', 'k7ucgvllyibm6j7wlcrxumsedssqep2h2glg7x1bzt89296qsz', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8nsl3c9oj35sbng7v13wh81tbkksyijxjfxd3islny4vu7188h', 'k7ucgvllyibm6j7wlcrxumsedssqep2h2glg7x1bzt89296qsz', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bpmxuizl1hlvqfwj5r137rwmhmuhjdep8a71emt38ckveflzib', 'k7ucgvllyibm6j7wlcrxumsedssqep2h2glg7x1bzt89296qsz', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4uq38ljh5zosn8z8un7o3vzqzfta5f76nogtcas1vixpbtu4g3', 'k7ucgvllyibm6j7wlcrxumsedssqep2h2glg7x1bzt89296qsz', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1q5oynu39x6h4x3pftrcucwbyr07mz67xnxv834wotxfxkbt0p', 'k7ucgvllyibm6j7wlcrxumsedssqep2h2glg7x1bzt89296qsz', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('u314f2ubr3o7uzcr0uts4hxoas4q0fojjdshbhqfxxa9heegqb', 'k7ucgvllyibm6j7wlcrxumsedssqep2h2glg7x1bzt89296qsz', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tbey4tiujgb89ad0f4lknlhhxs8um8fo8lci2xbdcub9h66vuf', 'k7ucgvllyibm6j7wlcrxumsedssqep2h2glg7x1bzt89296qsz', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4j2w5d2yyxlvd5boopkjp53oe5kmrxmf0h34n49y7vkyvblyz6', 'k7ucgvllyibm6j7wlcrxumsedssqep2h2glg7x1bzt89296qsz', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('tvf5z4lwtba7anz5ljf6gpnxq7drkwmjpbhpjod24l2kzzfmew', 'Playlist 1', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3puqmgbnrbigq1c684qnq2mfnnu6wnyt88f4c565123psv6d65', 'tvf5z4lwtba7anz5ljf6gpnxq7drkwmjpbhpjod24l2kzzfmew', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tfvtaajuwwqb96hmf55sxi66b81zqn34fh6nzh2mpv84gnrmob', 'tvf5z4lwtba7anz5ljf6gpnxq7drkwmjpbhpjod24l2kzzfmew', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('piz66ejb4wv72u7cpv49ped7xd52nma1dtzgk73vidakj3nkgt', 'tvf5z4lwtba7anz5ljf6gpnxq7drkwmjpbhpjod24l2kzzfmew', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('za4vg9r3tio0lu8s5btjco521k2bo9xe3cppaao8q0xgmutupl', 'tvf5z4lwtba7anz5ljf6gpnxq7drkwmjpbhpjod24l2kzzfmew', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d5gwote0pc8qwxm712gxn9nkqx3mb3zyjvtazdhca8nudji29e', 'tvf5z4lwtba7anz5ljf6gpnxq7drkwmjpbhpjod24l2kzzfmew', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('buigrnein2kwdq82f9qtjhsmp91kb5bpivj910ijw05bxye7by', 'tvf5z4lwtba7anz5ljf6gpnxq7drkwmjpbhpjod24l2kzzfmew', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('631v1xk5rofzvciyu12mk5dv1fko44qzmsdlud9wg8agh9kqs4', 'tvf5z4lwtba7anz5ljf6gpnxq7drkwmjpbhpjod24l2kzzfmew', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xcog7a81v61vec2jbxydv0d8yainv3xevcdyp2z1anqs825qbv', 'tvf5z4lwtba7anz5ljf6gpnxq7drkwmjpbhpjod24l2kzzfmew', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nwuo3pb19gzfpd4il2ly40r21w2p37qbid4hk063i9ti2kh4qy', 'tvf5z4lwtba7anz5ljf6gpnxq7drkwmjpbhpjod24l2kzzfmew', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ba7un8mmjufl4ufuezxoj0a0stenhowj6tav7b2payqg0utsnk', 'tvf5z4lwtba7anz5ljf6gpnxq7drkwmjpbhpjod24l2kzzfmew', 4);
-- User Likes
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', '6cw40dcamp24wef7so98ys3kj0sxi1tvm622iyvgjv40zo6olj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', 'btjyhdnvegph2ouq4fxy41vdhdvz5mx92ab1cyt5j16p57ygcs');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', 'fna3lw719ldu6118n6n71ekgp0c3pkri88tihkgf4avxwoxax0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', 'gd70guz94jkvln1k9qhg1d9ifqcfvdn0nc5v38woyro4ilil5d');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', '25vic9jl550fzh09x30wp4u9hydfj97azb9dprlxy9dsp87qbl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', '2cvgssa50u0jegpofn72xtez9zh8puqi17vy1m37269jk9s821');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', 'g7npiqoa9y6asqklq60drw3qbxxtcrwj21iqoh7xyfnaubfqt3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', 'ggnw80hhirgz8cneavp5e27x62u5ybjk02vbgcrjhlvif7klbe');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', 'y6oa6lnjgtlqbyr5yxrg0hzwgyqk38pwyh0t26wl1bgjjfez9i');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', '2w80uqguadkppjd6c5vu3rcwz86lnfs79su52uwmyu631e31kq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', 'lj5web5ugaxsiwnstjbxt06odj85fz5udzdjybynmmfhsi90uj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', 'o68y8dkcx2ixhm9b9peuhv2yu3xjthn2ax2nvmg7ijhhgzthrn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', 'pb1mby9uyinge05ic1npdub0fx0lhactlyvfxe0ojpy8f0fsgn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', 'm7ixayu3rutycn8w6ueyrhr8l177enlgtfihhsyg1h6qpsp7k3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('7niawzo6bb63u2u', '7rx2xrmvpsnpqvm72th8k8lw6is1perw3kf9hmvbqlxeg4wv8m');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', 'zcy1dlyd4xh3tsuu2mqvskfdjuuhoji1eusque5ydpxidixegh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', 'wvjeyvzp5591nzimio2lrqr4p6ujcbna8onehmqeuypoccz4i5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', 'sgupnar41ox57mnoufbpwkm1fz3i984eus8hax8fwmnsv7mdz4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', '3id2i4opy7ihcpxjst5jiwvdyptefqsy8lh1o278a89tdnbya0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', 'figbinl4yvzsbdknr45n1cqctrl68olnokmo9bxsu40duf5z0e');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', 'ttoy51xzyjs7sddi08o7zcbs1dgihbgy00oa3c9sagdbcx51uy');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', '4sm57onuinggiqyyb43d0h6mytjtefj5p3bm6v6gnndvr0r2n5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', 'wcwoootefr9bacuui443jegod0nwaso75om2ej6fk8ljvoz1rn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', 'fvsunnwdlq3u5p6rqsa9toja9ow0701mqkw6g7mizdw1fothe1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', '9lg60iuvyl45tc9iqljb3by2uve4ncdrx74cf5ewek3po1fmv5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', '77afzq8gd2srtcm7homs8120fw100om6izgf2wbmlsa70mgmq2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', 'jz8wpkpcno4h9r2ph6tnrx3py18phe0793zlz543m6mp6up5sm');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', '231hft1d1uj657xlxxtceovk5bgk5gek4f8kfqrwux96na4h8f');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', 'djeaoysv495gejqyt83g4gws2ajl7bqt47j8ak6ppenq5rpoln');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('h9grz328f3wfk9g', 'ea0jtulsh5mmfwdt1jse3ugmj9i1wmwkk4dogp7lfy4bldyl6d');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', 'btjyhdnvegph2ouq4fxy41vdhdvz5mx92ab1cyt5j16p57ygcs');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', 'fve4t53nvtefpmdel56ndbc03bulbubepkjtam81d94p7bdiwt');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', 'lwoxq2kb4sf354f49eutiu7f3bwkyfe0dvdun1ccvzjcckhug5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', 's2lj3j3zb7k45p592fwjmiigiq68ifch9c4u7n0kjmm2j9epma');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', 'phg5f1w7met6sx6nko1v7l0i8sfoh8604qsnqkkho2l0j0x7zj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', 'sr5kpyaiy2vanz3vua62t12xytsb6cylmixyd8y5unzwniivj9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', 'bai8xlhwfct8o31kzrdso134yvdsgf6f09eir5e0efn7f0jq8f');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', '6xc3rp254kj2gx8gupo716f6ph6cw0jhb4ewim6565vckymeq4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', '5dapzp9g8qjyoxw692w1td38q98fhtdykit77vsi4j3xfkiy68');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', '18duhyyj09lh3smfkuusgs8m15zepqx32exgcpoemcd6pfvrje');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', 'dd5wmop7x2i8irujdzv8koxoto4f424w763f84qy6skuszn7gn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', '6uu0arq5kx7j008bydf13em1x3zciq0ow2a63qc6e6i1vqyhf2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', 'yk7wcjp0129la094bsglww27ozgrag3dfjfdkkihd2cbigvwy8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', 'i698pcipxcvqgy1s3yxb0q84fdn5jnc22t8lf1u7ieamik1jr4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m4t851dyjzqe6qh', 'qytnuvunb7virge560f1196qiwsdygbks7yhkomn9xk2l9bd9l');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', 'ekos1hnq637csnd0xuonuf0vx8srh4mwdfs35cqghy26xit873');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', 'qvbrcojeyitc584d20b1do1ndl6pxny4mudkgy3rsqxxmguvyw');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', '0mdjot2sdqe0wxme1dzrzu267illd625day51btkn7p8ycz315');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', '8cvp90w5mjdkgnru9wujl47sd5u8tizmubqsl4eb4s1xnku2sq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', 'z9izqkhvuo3t5yxo185pqmbmced5gx0etprjra3ysgl8q0t6al');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', '6dk4y8hbhy7y4zxaby25t4u8nhknwz2ibdqqo0hi5shspqiw7t');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', 'vbqe9nz17t8voc16a65d68tb8rucst0taqi9qw9x0hs30bnkup');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', 'iykoocbe4fz7kb9tl2npbzg4ejhabj0xgd52k0q92ldbmy4688');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', '8wqtle9kmy9s2m0orlm6ckmc7hzbxfri4jz91ozqci7hap44o3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', '4j2w5d2yyxlvd5boopkjp53oe5kmrxmf0h34n49y7vkyvblyz6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', 'zri3rwtyn237y36ed2sv2p91kgktnesx044cacywo24xygm0ed');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', '2w80uqguadkppjd6c5vu3rcwz86lnfs79su52uwmyu631e31kq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', 'j82dqlatcsely851rpu2pfdoaew3cdxh8uysqn03q3kqbf4n65');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', 'hl89xpkbc6el13kwveviesx7b66supv4w0uxmr59g6xdvqxn6c');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('kcp913in2bq0pft', '77afzq8gd2srtcm7homs8120fw100om6izgf2wbmlsa70mgmq2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', '1yl5fbiu3yxllf89ykdjgdxl5kprr5zh18hh4k03n4peiljdqj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', 'avq0zuemurwl7eqfr92d0fs53kq1uni5tji4jzqpusmbqrh9mr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', 'co2pw8rmmw8o0428h3zjt7yfaesy6jfv975cqegwm81bxfz125');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', '527jhp8my2g5lf21qfe0u8h5lqlop428kp0mrt1841gumkis09');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', 'iqqvx8bhyjfcmizklcd90ov4sbsypj2i6bmaui596s6svl8t43');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', 'u01low24c4qbfjsbw8rpo3dvx4grrf5m7qi174kcpqjp72d6vy');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', 'pb1mby9uyinge05ic1npdub0fx0lhactlyvfxe0ojpy8f0fsgn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', '7a2d0kt44fl0rh74dnz7d39y267mu3v3wk2wio2cjncjbgr7sn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', 'l4pekt5wyu93l7tt0susqro3vxs2y79xk9igj2f6izysxpa78o');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', 'qvde8z6qweeh7qwscta6ydkq9pydydah1te3abbqldb7ne9fk7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', 'j1x23e6agkauqw7uipjgfjkhp7dew3clt97ss8wrbz7r3rgzys');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', 'rwb1xnecgtojb48hwkkgpz080lmnywwerqdng035pwmriu3wjv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', 'dqgc5ny35vl1ereq3wekkhztpl60pjnw846cic4it869sedrsz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', 'wme9f0pr0zmmazw80xtcorudyxdfzqf5s0m3oyaxt2kkiq68m6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dze8m8msphmg7nh', '0cgn9t8krg2kfv4ll4oo8c6yupp3v74fvg8zdl63kemz8jtf6m');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', '2z6m3qmrujtw26psds8f0dy3a2pfc6za594njfbv15yxa77d6o');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', '6dk4y8hbhy7y4zxaby25t4u8nhknwz2ibdqqo0hi5shspqiw7t');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', 'l2afkm21hufds9luujclk4lq92my6pqeyee8htyhfdz1wl7a5v');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', 'msj2px3g88z72zoia5961ckrrsgwx0gxjy1520bt121rb6r64y');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', '8y32kjtopc1mruxffq8hbc9xe65lioz4dec4a8mid1qh3molc4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', 'v5irfv6k4r4t2w0m995ac8nf3dykl7cr4xpzx7oy3jd5h0o9xp');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', '7dm7fbteg47izoqce5p8u1nf4n0gjjwhqiau9ma0i3yck4b2h8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', 'vkq1mjid8vfeh3dmjuzioams1hd6vc2nsqfym3h32kc87qjbbt');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', 'gx5yogjl910dn6kx8gv94zgxyr5ngxekzz29g2e8qjux9u2dvk');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', '64fuawrkdm2lmx632c9q3z1o6y41zgiil128sln6r7getfg36e');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', 'smksldlroq29i2my3b418i28hi8fsfrzjl42agcxk74yyyd7o0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', '0rzg9p9nhhr5cezl9miuupret4qtp63g8hwyyhlfsnx6860gm9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', 'mizwn0b5o5yjr6kiqopvc8bj00xuughbxwr31n4rpcjyv6q7i6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', 'zcy1dlyd4xh3tsuu2mqvskfdjuuhoji1eusque5ydpxidixegh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2wt2309ehptszic', 'dd5wmop7x2i8irujdzv8koxoto4f424w763f84qy6skuszn7gn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', '1v1spn9378yapd9zzkfejtg32y8uuznmmruau2fbhwcs3crrho');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', '6dk4y8hbhy7y4zxaby25t4u8nhknwz2ibdqqo0hi5shspqiw7t');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', 'fmnox1jpax98jy3aoc5j5jzgcz413v7xl9unwv6xnvinnw3bkj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', '8sy2bbnxeoyt53i1q1rl5l1vk7lyvn7tlittuqqbv2hs4zi76w');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', '81qzgw0oozjij4dzgzkl28jbd4pcudl51icif55edxzro9mmi3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', 'j5912n11dm9b2lxyy2141ldndkvk83v91elqyo798hasadbcfa');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', 'rxt44a8n25lu90uxf51zo1fojeak1uti06magkoq59v6u4dg2s');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', 'jylvw2tj7og5get9ang4rlry1jwo6d4znbymt546nb3hiyrpfi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', '1d56gh16lz9tcdljlhd78qvbhsrf09muk4fafoy8r2y7nsuh2h');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', 'r2l8unvvwp9dmafha643b3ti95dxp6czif1stgiu0jov96v5nd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', 'bppj25ileptim3j3s73l2sjx8ujh2fx5up1y1hdfmmjtxrln34');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', '4j2w5d2yyxlvd5boopkjp53oe5kmrxmf0h34n49y7vkyvblyz6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', 'v5irfv6k4r4t2w0m995ac8nf3dykl7cr4xpzx7oy3jd5h0o9xp');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', 'g7gasnfva15eq8ngsh46j2ce37w9lnk8am3q2vkpukywnztlp2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('pxu54pmgawm34b5', 'n13p77gmxbv1eo1oxw7vddw8mxk47q79r3k713z1agff5mq36q');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', 'ci5hsq8bdd47qx3jqd13tzyftn4mfnt8j5r2pnv7bpo0ld9w0e');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', 'dozsnoqnrrsy1it84uh7a8sk8hk3vbjm9oag3s0ietjusbye3p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', 'mqqbe4d2iolmnd47pqaa0cdy9pgredfrcsxqvzmemk7jal2bb1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', 'd3yizui400anwdxuunqgbz19n5y7aowqjvjvxptb9cdtmu06uw');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', 'j5912n11dm9b2lxyy2141ldndkvk83v91elqyo798hasadbcfa');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', '7dm7fbteg47izoqce5p8u1nf4n0gjjwhqiau9ma0i3yck4b2h8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', '1v58022lb8bb5b381t8pha8tjukvlb20issrsfzvi5xs3vbi2k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', 'c861wptj254uztuplphqmhtd5w6ufm5aby6h265eqjrddvyb17');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', '0mdjot2sdqe0wxme1dzrzu267illd625day51btkn7p8ycz315');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', 'ekos1hnq637csnd0xuonuf0vx8srh4mwdfs35cqghy26xit873');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', 's7aq9g50t5gb8hyfvqaq8j5t9abv0wkt1f1yh3mpjv0iyg1q2w');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', '1bo56kzodxmljstj46ahdettlzoz5skogszfcmndjrikydrtsd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', 'j1x23e6agkauqw7uipjgfjkhp7dew3clt97ss8wrbz7r3rgzys');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', 'oqqvkrvwew31s2wwtabkm147gqin4o0xsxlsl57m77v26e2d4b');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('nz4nme54t9n8mts', 'ookvmhdobu9pj49dcmq1vv5dxul5rzucylf0aeyymsnc6nihcf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', 'mizwn0b5o5yjr6kiqopvc8bj00xuughbxwr31n4rpcjyv6q7i6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', 'aoywneckhccqs32nul0q6bnbru2svv2e549m4361h08box1md5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', 'jqqzhe720urjgxtjyelhr1htspnac34sbwo8oza6bx74k7ix9h');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', '2e03hyvihnu8uj2ozxtzsno3cmp2zdv6vbzftyd1x3l648ukrk');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', 'rd67zn7a67z9j9vuumvvwfvl0r2ofinl11we24rgj8bif5e2pi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', '0yixr9g6snoaocbbplcrmuwq8o3yy9yk0vcub13g9vmw8rjcrg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', '8glaq82cwwx7k9ebnix140w660vx56oa9ixbeunf47jjypgaq4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', 'rlj7u6yd8rcv6qsv7wbhfj1qcf70k4xiwynlmqam5dpijh1vhu');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', 'ci5hsq8bdd47qx3jqd13tzyftn4mfnt8j5r2pnv7bpo0ld9w0e');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', 'wequ48aojnuwstpxgjweraftev0pyt04g94zv18i7hz9phjpu2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', 'o4xa9lbcdh085igdngd9esh84m4ccp9rhkio7jzxmrf4hn9ryq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', 'qvrxd2akpzbn551it51i990qktcs5ob5hc369rcfj22in2i0kq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', '5wrckeggqtin4cdfm4e3gz27vj4zn142rs7kzhlqcfw7fohn01');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', 'ty1e85y2rp3y7fcuc4kgc0po3u2ip8k5xget15392pxwixjf5c');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('czeh5bn7jkh7am1', 'doiyek9t82xmzjjsuoouloniglz2stmyw43i8ky5auq9yr1psl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', 'g9qf2mn1rahrhi74ogmzmriksw0qv6w952odl4l1bzb1v01aee');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', '77afzq8gd2srtcm7homs8120fw100om6izgf2wbmlsa70mgmq2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', '1d56gh16lz9tcdljlhd78qvbhsrf09muk4fafoy8r2y7nsuh2h');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', '8sy2bbnxeoyt53i1q1rl5l1vk7lyvn7tlittuqqbv2hs4zi76w');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', 'rrkbvyhl0rlw0fczo4rlkcrbl80oq883vk83evghx3tc2k9wa8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', '8glaq82cwwx7k9ebnix140w660vx56oa9ixbeunf47jjypgaq4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', '8cvp90w5mjdkgnru9wujl47sd5u8tizmubqsl4eb4s1xnku2sq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', '8nsl3c9oj35sbng7v13wh81tbkksyijxjfxd3islny4vu7188h');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', '5g3gp1extti1qfmfrerwufaxcogz0mkjw79eqo6u5ohdgozlvz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', 'smksldlroq29i2my3b418i28hi8fsfrzjl42agcxk74yyyd7o0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', '2nxjm2e1uo24myy28kg4xlu4guh3o8fxo7mowu1hgg80gadxrt');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', '5wm9dsmfvcagzg9xbp3cmrpfhefudzx8ivmfuj5h8gxdake5ej');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', 'z9izqkhvuo3t5yxo185pqmbmced5gx0etprjra3ysgl8q0t6al');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', 'wkbnmb3w8g083gjo489fbedd7hj0fuukmolwluyc30r3os5sz0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ehjowsa0xfnqkor', 'ev1p5qquz6w0lmcp7q6ga8k9anpoda5gy16kkeemmph5tox83o');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'uisb5sxywcx5pey3u2qum6wv6ytzwxmsq2rlc3irh31utc5tl7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '9xlfw29zjow9tdhwtz45z7taff7jao3w0mqo2psyrj7nw9wmny');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 's6dah8gtxkjbq2gvhuagao94xs7hv9geo5i0lku99182hy26yd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 's2lj3j3zb7k45p592fwjmiigiq68ifch9c4u7n0kjmm2j9epma');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '4ocv5ur19megwo0jk23w7pqbor1soyvp4ukxyhxaq4c6srhhsw');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '231hft1d1uj657xlxxtceovk5bgk5gek4f8kfqrwux96na4h8f');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'j8llqaz5cf7lrd0o4yojtwrfyd8wok6oc6gef5w1i0xaxfshmp');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '0dkk0e52v2d6rxnggb2l1ygz1wag6nhoa9c48ol3pgw3trhl1j');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'yo0a2a7ur6bvs61uva2bik2iww9a49u755du9nybitm4zd11ag');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'c861wptj254uztuplphqmhtd5w6ufm5aby6h265eqjrddvyb17');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'j1x23e6agkauqw7uipjgfjkhp7dew3clt97ss8wrbz7r3rgzys');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '2nxph8llg9prquhlm6rhkzxyz7fy0o7qm8uceeyut6kyphuqwn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '44utk8dp6crcas952wkctrorwo8vlq4oprrqa725qq9bbjc90k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '82zgg8q2s2cw6aatnh1ymgmnxcfa4pyb02v9uxah3p0tepklui');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'nls84pcych3nhjjl0d536avo1v3c5lngfrj93o1aa3myorhbw2');
-- User Song Recommendations
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('u6qmktvgav49wmbo11ryowyzay23r7r8i5w5tbv0nuhb4vhw6d', '7niawzo6bb63u2u', 'hgd91qb34bwh64t622ocxtupikeu60o35w7ne2q9hcn6w5qhzn', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('mromkihjobinjcakuzrfhtj048lvzljvpgawlpizutypmmvz7m', '7niawzo6bb63u2u', 'ttoy51xzyjs7sddi08o7zcbs1dgihbgy00oa3c9sagdbcx51uy', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('rexqjmbb2wlg5vnw4eds8opvamm4a0b2vrttpe7k54sxw0qq59', '7niawzo6bb63u2u', 'c15d8g067gll1uoorg4iz359bsmkk8uslzpr31uajpgymrvdtr', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('uic33urnhuwn572ffyt4l4za3esr4dt29zaxr5zy6wtxam3fqm', '7niawzo6bb63u2u', 'vkq1mjid8vfeh3dmjuzioams1hd6vc2nsqfym3h32kc87qjbbt', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('m4p2iztumfmk6l95vwmalzro7kujy2gnz3s3y7yhn6v5n4mj5e', '7niawzo6bb63u2u', 'o4xa9lbcdh085igdngd9esh84m4ccp9rhkio7jzxmrf4hn9ryq', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('t0mak3ke4c0kjbeg4tubtizntvclasfc3d3ic1eu56121pm9st', '7niawzo6bb63u2u', 'gfz23jqpmrjv3jgd8ycuu8qt2p0xcy183j95b8uz1w4vwpq8mh', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('t9jvwxriaizvtbx3umcc8lxfj0qjwqirzlpe1v90dy3pbs6lag', '7niawzo6bb63u2u', 'uuxoph3nturt2ay6cqvmoa4ft9gq674tevigqupb6mqvo4ox9w', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ezrhmldjsxaieakyw0gnaxe98m22c4egyki2l92idexb6es1px', '7niawzo6bb63u2u', '50u9fo1lq6e7gbf5a7jfl25x5r7zmoylz24xw4amqisto32s49', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('7cvg5991izc94rmgeqivvebh3rp15rok63ly478024l1r2dcxz', 'h9grz328f3wfk9g', 'qygbmcrdvfbaozup0xasp500kawzanhm5v5i849fzynniwqb7o', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('drnvgjbmt5gdrl7atvcd2xblz5xja37d7pa6golr2bl5vniu5l', 'h9grz328f3wfk9g', 'l4pekt5wyu93l7tt0susqro3vxs2y79xk9igj2f6izysxpa78o', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ykmj0su1shpzo8aqc7rda624w3ltqlzmgnsoamhqwux7jpwj1k', 'h9grz328f3wfk9g', 'xabdk9ej26i6a6zso35y5t3mfxy36tjggpeyrcteh4z6lfzfw5', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('4bli10zthtw2n4bjel7pd3ox4zddmdrdrob4qd8085dc8fjyim', 'h9grz328f3wfk9g', 'orw6dww37tsqqnpkyt7e25jzqjw67ba1tsp4yisdbw6fw56p6w', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('v8u3ao35bnvaw3cne0ddm3tdcxp7vdyrgq6isxv9u8msy0vqxt', 'h9grz328f3wfk9g', 'y6oa6lnjgtlqbyr5yxrg0hzwgyqk38pwyh0t26wl1bgjjfez9i', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8cbupx1x7pa3gulg5e7fyccx7zt44lj2j53p116gra53xl67jk', 'h9grz328f3wfk9g', 'btjyhdnvegph2ouq4fxy41vdhdvz5mx92ab1cyt5j16p57ygcs', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0asb4u0txbvus188gjvjb99gheld8zlg0v73g0z399nv9mmni4', 'h9grz328f3wfk9g', 'o2vwgafty1m9c6kd7eina6dd49x2tyk8dub3u9famwlc8oc9or', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('bwjeipe8k0gl6bh3cohvjllggyu0sxz63j97jtgxo0epcz0d2t', 'h9grz328f3wfk9g', 'ookvmhdobu9pj49dcmq1vv5dxul5rzucylf0aeyymsnc6nihcf', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('skoektvd2m8idnksc1g24ndc7j7yid2zgu7izugqr0aziyyeun', 'm4t851dyjzqe6qh', 'za4vg9r3tio0lu8s5btjco521k2bo9xe3cppaao8q0xgmutupl', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('27p7r956udqozq2181l8looouklg21ri3ivxyre85wvftpll50', 'm4t851dyjzqe6qh', 'tqsxq1y8bqpux513z0pjipspfby80j179oxqsrfoq8ybfzdqkr', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('inyp2wzdcnlhajeps7qot69rcmu26rb6qsfgy6ofgrmbxu9893', 'm4t851dyjzqe6qh', 'csahcs6zsq0l1l6vtnzwwfnk4qbwuyyenzvh7v5sgbbyta6k4b', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('rt7folmqpr1e6tiuks2w3ae64rq6p5v6bnsiy22a2giqgqtw2t', 'm4t851dyjzqe6qh', 'qwloluwavl3plh5kftwmoanzvn8cz1ccrc5767ezm9q1vjw8tn', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('2sa3dsiwjpv508gj2vmtljq6gz2j0gmmcw1ga5ewgzms8ynzjd', 'm4t851dyjzqe6qh', 'mizwn0b5o5yjr6kiqopvc8bj00xuughbxwr31n4rpcjyv6q7i6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('trc47028i0s94fx8nt0d5sm9k4xen39c93xiu1mm23ccyjxhh2', 'm4t851dyjzqe6qh', 'kihn2imlymubjfuwy9qrkvwlc3kbicq5e0e3kfb7174gimjnjd', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('rf2p4mlw7c6vl3hfrimkich7csdtgerql3l8mi43izq3o0rrd2', 'm4t851dyjzqe6qh', '5wrckeggqtin4cdfm4e3gz27vj4zn142rs7kzhlqcfw7fohn01', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('dq5doetz5m7o60isi7kpy1fuyc0rvfv4j64k25ynel051a5l7y', 'm4t851dyjzqe6qh', '1yl5fbiu3yxllf89ykdjgdxl5kprr5zh18hh4k03n4peiljdqj', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('uz9tfqvxy5q2rzmodbsgqglrsjkewawppi8zzn417c5wxafw02', 'kcp913in2bq0pft', '3gfz5u54z0nrgfps3m4xb5423evmzl72szoxid80a0ez3vbfvo', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('of3k9j19d6xu8aeui8ajaqjabzp8xeicjgsip4yfn2a9825oen', 'kcp913in2bq0pft', 'xn7oyxcnjkl0dkm1d8qaysrvhrobwt7n33v1im81mlh8y062nm', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('r8j84nyiwnqqttd1zvy8ww3n3ghcoce2ttmxfgqzdhwftstidn', 'kcp913in2bq0pft', 'fy0pplbuncgxpw1jpxdwb7l9quil258fwwq5ak7gx8ojd6atga', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('1arqq1k3vdjwnqnpfzcbauwxbsmg74rxnzgsejlju7d50lee55', 'kcp913in2bq0pft', 'hl89xpkbc6el13kwveviesx7b66supv4w0uxmr59g6xdvqxn6c', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('n991u5h4ngx70klek4t7228faa9but5bfi48biimhqq6nv70va', 'kcp913in2bq0pft', 'bpmxuizl1hlvqfwj5r137rwmhmuhjdep8a71emt38ckveflzib', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ajyvtrz84enc24a3elkm2d1jsrxaxl6yvyz268i8uxczl00ejw', 'kcp913in2bq0pft', '49z2qaxbu0rz71zr7jcapki4v1mgaq8b0wz0vbmepu946ktl4f', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('6ly3mkfjl3yut32rowa87jy6o3mpruhwvv0lkfvk82jxprwfkl', 'kcp913in2bq0pft', 'e2qretngwhk7rjj6ikm00g6nvg9rc6ctmsok7vnfwca88q3y5x', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ak7rrh0qqvgfz9xf671fb1tu9ivqczyhhno8hjxvyzf5meuuam', 'kcp913in2bq0pft', 'p14yvyegc0jvtp6wrzhv10j98rg68pmf3mksigvva898a0l0fv', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('4uj2k6jwr7fi332gkgfk96dq1dd15lh89prmw9wfyxsgt9yg4e', 'dze8m8msphmg7nh', 'iatc65hh5cu9zi5qfldjqdfojqfx8dpq0zelle5z5wou78pjxf', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('cpoxjr4yaw2g67asmmqad1472qk3kmzosx089t9j2hba6aoav1', 'dze8m8msphmg7nh', '2z6m3qmrujtw26psds8f0dy3a2pfc6za594njfbv15yxa77d6o', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('q7dyxe5fyhthuufggflkeatc45q3701z92cyr7713u6k360818', 'dze8m8msphmg7nh', 'loba7mmjlo79auc1z4trmt3wqqvt9n5sm2unjnoujth1bo7we3', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('6td4ls6rg0v8wzlxjsi74hipu6agyjxwmkdu0fy6tgm5cwon9o', 'dze8m8msphmg7nh', 'lckdsiymbjq0ps9hhdivxmnzmoeqlyu4barvxew9zcmf7l0wkk', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('zn97ymxfqfgme614vqq3d5canpvgod2ovy8e372hwt7dqb45fe', 'dze8m8msphmg7nh', 'hb42yfapepgaf3rixyns9kewd7gi1lmb573qiti7ge9hc928u0', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('06sqepevb9f3w8c5xtebc290q460ls39bdizgemtxtgrchcpon', 'dze8m8msphmg7nh', '9x3e3xexl8l4dd5h1zzs5fdicear5xzpn7o7ambphslk29m7d7', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('1oxvhvb0emjv16t6zh31fuclg8f1np6z4fis5djyl9ggxy83pa', 'dze8m8msphmg7nh', 'r6ok55kjqgbtsonljffqzoykiqvvz121qq3c61f7lrxvxhkhk6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0ma5vpmtxuq7lflyl6f1d3npbebzr6wkj0ejewturshv5pxfjx', 'dze8m8msphmg7nh', 'y7x6e8gokj2n1otasf3cfzh4lexofk4gs04hbq1klz0qwexk7o', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('2c0v5dc9w96j90sy1xdfval5sttxi4m1eiztdpw8lo45lh4wf1', '2wt2309ehptszic', 'ba7un8mmjufl4ufuezxoj0a0stenhowj6tav7b2payqg0utsnk', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('h3rbtkc4ux38qi7gdb0chwpoosvfpxkwndc0fsmol0nniorjgg', '2wt2309ehptszic', 'uyihj817dblbqfvnz4a7lqsygweqpb2wqnw2tqjftmw6a8lxxr', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('rj212hcajjz2ugtr3ouk61aybvozxotertjqn8442f63idum7l', '2wt2309ehptszic', 'fna3lw719ldu6118n6n71ekgp0c3pkri88tihkgf4avxwoxax0', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ms1qtgex8mo2ozw4d763gvhaoernrml5c0qj59l48wnsfk3l3b', '2wt2309ehptszic', 'uisb5sxywcx5pey3u2qum6wv6ytzwxmsq2rlc3irh31utc5tl7', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('xdj2pcrxnvx060fr67hgv2agpgstbkzvs4jz2yc9z64yxu8a5k', '2wt2309ehptszic', 'r8mqfpgxcc0e4vqvdzqzbw6ic703mxi6528w9i69zohlpgdo9p', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('cvealf6dcnh3swe2g6z0xv08r3yede0tje2wtprr2ka0rlwaum', '2wt2309ehptszic', 'zcy1dlyd4xh3tsuu2mqvskfdjuuhoji1eusque5ydpxidixegh', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('lgvwn53lrb3pw9h1w2qu521a6zuxadkwbkdukfb9o1ic1aeyy1', '2wt2309ehptszic', '11edw8dcwst48wetouxuf0dw4nk9unrhzacl27zmqcgoebwm51', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('s672x2edxr9cvl3qfs7gc8df7ptjw51md788n7ale3y9m2jbkv', '2wt2309ehptszic', '3lqtcn0qpow3od9pplsdidrka6a86gkwe0w7paw2vbx1w5elst', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5t26w9msebq96s29v0tcae6x62e1lw9q8iyh0l018vst0dvgjt', 'pxu54pmgawm34b5', '5g3gp1extti1qfmfrerwufaxcogz0mkjw79eqo6u5ohdgozlvz', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('m3nelppe8vlzdubnk90des54jozyndkbgwhil9r5fj5n09ajg3', 'pxu54pmgawm34b5', 'hd5zx7ft1w58u2xxsejmakzefdqn300nxy99air2ez0egdfs2e', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('07tsr4n717rqs40ed15rcnvt3luua8034tqb4pjcjnmhndxeam', 'pxu54pmgawm34b5', '8sy2bbnxeoyt53i1q1rl5l1vk7lyvn7tlittuqqbv2hs4zi76w', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('50xs7da3twhygmo962ehfgyikkyz1178yf2au9rsq3lky319qb', 'pxu54pmgawm34b5', 'q6qwsmizragkm32sspl1lwfl3lhgl36ygo6it8ji026jh9bkoe', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5fyxpxy6bo9re1r6prir9czt5cpi6cgk67fhje2hifv0hr4m4u', 'pxu54pmgawm34b5', 'l4pekt5wyu93l7tt0susqro3vxs2y79xk9igj2f6izysxpa78o', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('6d5xvv59xm10rugp939o3prb41pqt7uu1f1104t7g56eickww2', 'pxu54pmgawm34b5', 'lckdsiymbjq0ps9hhdivxmnzmoeqlyu4barvxew9zcmf7l0wkk', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('toefi6k4erb1apngw341mnwseb5w99wakonf49bl35xidi2o8c', 'pxu54pmgawm34b5', 'nmsym524uk6k8xfqjcrghj3parg3sxclr21q2q120g55to3470', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5jeridzri4l82zbg41spc8ggrs9w2dzt2z3nig1ipw6iaojq20', 'pxu54pmgawm34b5', 'rd67zn7a67z9j9vuumvvwfvl0r2ofinl11we24rgj8bif5e2pi', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0e46hv0n6fv69lrexq9ekb7ahg28bujroav8hfkbhykyjapvry', 'nz4nme54t9n8mts', 's9sy2hc01yz2rxjxatar1mwe4ydlvf4uuat2ynbv154l856p98', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('9tvrt23nof1h5760dgryh46widlvtkzmdeu88aljwavkircico', 'nz4nme54t9n8mts', 'gop7rb8rmd8ldi8z0og3r4le4e7nyecqd5lpsnra8nty0tv6h2', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('quuwck5bezun3lifz1jj16zrfunabuh0ili07lf4isz1ge6oec', 'nz4nme54t9n8mts', '9c3ltoxh2ma19x0w18rmgfsk6p4ufdzxkfosqiycj40opb1ycj', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('pz7oh1aovw6a3729dmwmoy7qpgaszzn9oq95loxctfcxc7lwi9', 'nz4nme54t9n8mts', 'n41u81698x22iowemyxcqqkkbw89cgkbznn7w1hzzx6shtzggf', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('omzwzp0d1bq0falbm59s2y5c94otfe0t3x8qt459jr8pmi6wgv', 'nz4nme54t9n8mts', 'vbqe9nz17t8voc16a65d68tb8rucst0taqi9qw9x0hs30bnkup', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('11icpg2vvgh9wtnqeu5oqlb838csgeysgb9z84mtjiaopzt6fh', 'nz4nme54t9n8mts', '7dm7fbteg47izoqce5p8u1nf4n0gjjwhqiau9ma0i3yck4b2h8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('jhl8bfqshkoan1dmherc5f57kf9xasi409lqaifh4ck3gu4k45', 'nz4nme54t9n8mts', 'kpo5br8yogzk91u8sizt3vjbsstb4nvep37qg9oc86n81pm144', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('99mft5229pjzuovzzuuv291zk5rjscrf3ki15jjx9xewmpwoxl', 'nz4nme54t9n8mts', 'br0v9393zvkt1axlcd2zmpk4k4h1laao5gx2nmgfqdsphiv579', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('oiz2vwswkj65j1untza5v3d4ybdj9ig76daogxjwey54ey8wt3', 'czeh5bn7jkh7am1', 'fmnox1jpax98jy3aoc5j5jzgcz413v7xl9unwv6xnvinnw3bkj', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('azeeslqm1w9lx712slu8ydjpeab41a2tt54qczxxh2tn72rj1h', 'czeh5bn7jkh7am1', '8166k9lwf2kotvkmwde943ea05urfcbdrk5gizdy1usug5k54w', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('s7xy9tipdmunieb3f31n9vf9w9nbnt4z7y84rda8wbq0evnszn', 'czeh5bn7jkh7am1', '1zub63knm505b4fi9lb5ytclz2yfyfyb3c38zmpxf3ifyz32gl', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ih1562caei50dr9p2gkonhcmq3vy16cymwk94bznzeko0u8qmu', 'czeh5bn7jkh7am1', 'gfz23jqpmrjv3jgd8ycuu8qt2p0xcy183j95b8uz1w4vwpq8mh', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('r3c8y6rp6bf5rmzffatzgphsbw4c42jqkzh7hg9wv7y2zyh8c4', 'czeh5bn7jkh7am1', 'mkuag4s7kb9ivuyvkbq6pb8dkyylzk34cfg14kucqu75cksslu', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('q3qz12fhuroya2t3lql92zxf5kkzzqrvhv9x56qcnmbremggaz', 'czeh5bn7jkh7am1', 'wme9f0pr0zmmazw80xtcorudyxdfzqf5s0m3oyaxt2kkiq68m6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('l9yhyad41nedluxa6qz2hxpqcgv33fvuitidkqeku0lnjo3pbl', 'czeh5bn7jkh7am1', '24sfv5fhpj3tj0wrhutk14ywbtgwx55h9k918arqpzzwtnqgri', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('de4e94w43r3k7nwtqflsowmuub4ye1uwgb2nfwb6sf8ecltuy6', 'czeh5bn7jkh7am1', '9tjcau5wceykb4yjlxdy2d5hwoqq3gc8lmwe5absjbvldsuqdb', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('rg1y3yd46pjbuzmy7xlx5g22r7fy5egxnpsvoej0texk46wvj9', 'ehjowsa0xfnqkor', '4v3w51qve61ofote7qp8ocn48nzbcz5ha7lpouysx7uga20jw7', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('da3ao4f0ufhum9olafb161lqiay8f97f65l6rl32flgp2bo4ru', 'ehjowsa0xfnqkor', 'jwu28lpdtcukl4a9gyjgogni8tqvdqtvpum7oh7qgfxzfgq4sv', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('4mjb93bp45lw2vxc9rmli42s521ovkb2wm1ij2lpxsx1jwvq71', 'ehjowsa0xfnqkor', '9sopcb1prvzs0aa9pg4hblc6mhmpo4a5adtpi6lfm2vqaz8huv', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('anvjk1gxk4vhb797tx9hkb7rv8edm7s06bkm0qysumzftj1wyr', 'ehjowsa0xfnqkor', '8nsl3c9oj35sbng7v13wh81tbkksyijxjfxd3islny4vu7188h', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('c1bbok4m4rpyqt6jda74j41gb2nmduaj4u8bijssxs3vn0otqe', 'ehjowsa0xfnqkor', 'a24hhhgkzwilpyhf1m0fz13ngtd9eyj3tspbgzvkj40918hjho', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('9xo5rj6kr394hm4y747d1h5j6qvo58y53h190h1wcasdkx72m9', 'ehjowsa0xfnqkor', 'tdgafpvkzi5xf93ml9dgodmwneyogoj8n2j5xcdtpqwuatec1f', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('a1p02hvui7tglq4kov9zloksw8a3wkyr39cp54apcc71jtz85u', 'ehjowsa0xfnqkor', 'ttoy51xzyjs7sddi08o7zcbs1dgihbgy00oa3c9sagdbcx51uy', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('kt575ohmqzloibqsnvr17q74xpuj8ffslnt319mu9dfimu6m6i', 'ehjowsa0xfnqkor', 'ego7bdr651yjh8nwa764ifca1je1p4e1r9xlos10y05ljpznyy', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5gatza93aqky5tm7n809a3ob715gnov89jg77swg0dk23sx8fs', 'icqlt67n2fd7p34', 'x3muxgzuffoetnwvixdpbydnqri6mygs736wtb4v9fewierpf7', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('kx4694vp1ix72lwrcvy52yctq8yq0xa60cmc22xdn2b5jp6uxu', 'icqlt67n2fd7p34', 'tiaq301c8ctje36xzp7no1fwi2q43y1c425fer4l1di8ahnhx1', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ri1cbh2qjx4uvnrla35aitjljqtf3ztskafu1qkqyxplhsrtzq', 'icqlt67n2fd7p34', '14c40t76ight70gt87mg7eyx6qn4137s9owfuknf06v134kz2a', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('9wz9vnqbdofcie6owd03wzefsntnpi624a0p7vxw3c1380ym6m', 'icqlt67n2fd7p34', 'r2l8unvvwp9dmafha643b3ti95dxp6czif1stgiu0jov96v5nd', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('v8mqmrxpgcfd54aqj184tcgpejsmstgs3ry5pkhheqyf51645j', 'icqlt67n2fd7p34', '64fuawrkdm2lmx632c9q3z1o6y41zgiil128sln6r7getfg36e', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('dppifrghb5p1xa59mdmgtmgqv6imvyg13evex45vmf3hlzf80y', 'icqlt67n2fd7p34', '32nl86jqftw9vu2fz0e1mqw50378yfstpdb4hdsw1f4e8wquz0', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5j6b2mro5fm8wfy88tfbxj4qeydotfgenjqdgejq3gdbnsk4vb', 'icqlt67n2fd7p34', 'l2afkm21hufds9luujclk4lq92my6pqeyee8htyhfdz1wl7a5v', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('yzrdlgwn8myv4z30z9ih44aginyybo6lpe758xrrhyibr5wvg4', 'icqlt67n2fd7p34', '0p5jhy9ii2uboc44o6t5o5axxlhtmbaj616d9uj6m90bmqxxy5', '2023-11-17 17:00:08.000');


