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

CREATE INDEX idx_album_name_fulltext ON "album" USING GIN (to_tsvector('simple', "name"));

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
-- Chris Molitor
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ne8sgmg0bqhsvc5', 'Chris Molitor', '0@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03851b1c2471a8c0b57371c4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:0@artist.com', 'ne8sgmg0bqhsvc5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ne8sgmg0bqhsvc5', 'Delivering heartfelt music that speaks to the soul, blending folk and indie vibes.', 'Chris Molitor');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rywuk4r90yysnepdx6z30c414rms5rltem7nf137kztrh2duf9','ne8sgmg0bqhsvc5', 'https://i.scdn.co/image/ab67616d0000b273be011d16b9360a7dee109774', 'Yellow','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3f55axmxlixkigp2lnk9o6cf3u2q6nhtc9jlskj18vq441ppx5','Yellow','ne8sgmg0bqhsvc5','POP','6tvs7zEP8d1SBgSqZQ84OT','https://p.scdn.co/mp3-preview/ea93f9b43fc638111ad661719037bfb88cd9c05d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rywuk4r90yysnepdx6z30c414rms5rltem7nf137kztrh2duf9', '3f55axmxlixkigp2lnk9o6cf3u2q6nhtc9jlskj18vq441ppx5', '0');
-- Baby Rasta
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gym9wyc5m5cn4cw', 'Baby Rasta', '1@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb18f9c5cb23e65bd55af69f24','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:1@artist.com', 'gym9wyc5m5cn4cw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gym9wyc5m5cn4cw', 'A beacon of innovation in the world of sound.', 'Baby Rasta');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o9ijdlv1ycex7i0c7atksl6uvyxm4vovrcgkb4p2erw8nvc2n2','gym9wyc5m5cn4cw', NULL, 'Baby Rasta Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1213xa09yy31lf4nz8wg1ujdnpkd8rjewkuqqye1e0sk1kvbjm','PUNTO 40','gym9wyc5m5cn4cw','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o9ijdlv1ycex7i0c7atksl6uvyxm4vovrcgkb4p2erw8nvc2n2', '1213xa09yy31lf4nz8wg1ujdnpkd8rjewkuqqye1e0sk1kvbjm', '0');
-- Ed Sheeran
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2es9r6ba1fthtzy', 'Ed Sheeran', '2@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3bcef85e105dfc42399ef0ba','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:2@artist.com', '2es9r6ba1fthtzy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2es9r6ba1fthtzy', 'A unique voice in the contemporary music scene.', 'Ed Sheeran');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4h9231xpcc0m33kzmpydtd2dq532o6kd8oj7nc4z1z7gi2ipa6','2es9r6ba1fthtzy', 'https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96', '÷ (Deluxe)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('em1a3qkl4r9u4ggdsz926pgcp8cl2nmtvaqbzdprxtpovxc5wa','Perfect','2es9r6ba1fthtzy','POP','0tgVpDi06FyKpA1z0VMD4v','https://p.scdn.co/mp3-preview/4e30857a3c7da3f8891483643e310bb233afadd2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4h9231xpcc0m33kzmpydtd2dq532o6kd8oj7nc4z1z7gi2ipa6', 'em1a3qkl4r9u4ggdsz926pgcp8cl2nmtvaqbzdprxtpovxc5wa', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5hio7seg1182j3fxhpriwt4ocnbyyx3ehf6ussutj7m9h9ns4w','Shape of You','2es9r6ba1fthtzy','POP','7qiZfU4dY1lWllzX7mPBI3','https://p.scdn.co/mp3-preview/7339548839a263fd721d01eb3364a848cad16fa7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4h9231xpcc0m33kzmpydtd2dq532o6kd8oj7nc4z1z7gi2ipa6', '5hio7seg1182j3fxhpriwt4ocnbyyx3ehf6ussutj7m9h9ns4w', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u4a98vv0dcctzci0oigh1kj0b5dyumi3bgnu3lwdl8fdglngac','Eyes Closed','2es9r6ba1fthtzy','POP','3p7XQpdt8Dr6oMXSvRZ9bg','https://p.scdn.co/mp3-preview/7cd2576f2d27799fe8c515c4e0fc880870a5cc88?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4h9231xpcc0m33kzmpydtd2dq532o6kd8oj7nc4z1z7gi2ipa6', 'u4a98vv0dcctzci0oigh1kj0b5dyumi3bgnu3lwdl8fdglngac', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tzap2xpoccfl6rc6ywk49ofqb01jgkgs3nj0hmvb5a1hvtp6jz','Curtains','2es9r6ba1fthtzy','POP','6ZZf5a8oiInHDkBe9zXfLP','https://p.scdn.co/mp3-preview/5a519e5823df4fe468c8a45a7104a632553e09a5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4h9231xpcc0m33kzmpydtd2dq532o6kd8oj7nc4z1z7gi2ipa6', 'tzap2xpoccfl6rc6ywk49ofqb01jgkgs3nj0hmvb5a1hvtp6jz', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mqjltqu8wl2tzewdjza50yjh31jbj2g34q8z7i0pmm70klqfw2','Shivers','2es9r6ba1fthtzy','POP','50nfwKoDiSYg8zOCREWAm5','https://p.scdn.co/mp3-preview/08cec59d36ac30ae9ce1e2944f206251859844af?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4h9231xpcc0m33kzmpydtd2dq532o6kd8oj7nc4z1z7gi2ipa6', 'mqjltqu8wl2tzewdjza50yjh31jbj2g34q8z7i0pmm70klqfw2', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('202q69wz2ij0rj4qedy1l0ytgjihh04phzj41ocd7rq78vi1yx','Bad Habits','2es9r6ba1fthtzy','POP','3rmo8F54jFF8OgYsqTxm5d','https://p.scdn.co/mp3-preview/22f3a86c8a83e364db595007f9ac1d666596a335?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4h9231xpcc0m33kzmpydtd2dq532o6kd8oj7nc4z1z7gi2ipa6', '202q69wz2ij0rj4qedy1l0ytgjihh04phzj41ocd7rq78vi1yx', '5');
-- Doechii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6k1fskiwn7rdhsq', 'Doechii', '3@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5f9f729e1e5182fbf1030dbe','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:3@artist.com', '6k1fskiwn7rdhsq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6k1fskiwn7rdhsq', 'Breaking barriers with her unique sound and powerful lyrical storytelling.', 'Doechii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8u3o63iev2hwana2uqwfa4uv2qei6kfa2ch7qvtq79e18n520h','6k1fskiwn7rdhsq', 'https://i.scdn.co/image/ab67616d0000b2732ee85751f6f503fa9a533eba', 'What It Is (Versions)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ic1pbl714s3kojg4tv4u64tia0naw0fg184gbjxvijysjhpy2o','What It Is (Solo Version)','6k1fskiwn7rdhsq','POP','73RbfOTJIjHzi2pcVHjeHM',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8u3o63iev2hwana2uqwfa4uv2qei6kfa2ch7qvtq79e18n520h', 'ic1pbl714s3kojg4tv4u64tia0naw0fg184gbjxvijysjhpy2o', '0');
-- Peso Pluma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('as74k1ywio8298u', 'Peso Pluma', '4@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:4@artist.com', 'as74k1ywio8298u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('as74k1ywio8298u', 'Infusing music with energetic beats and captivating lyrics.', 'Peso Pluma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('06u7izbkcr34pvpf7lpe6aoojbhoc84xhm0aw4hs50ghismv05','as74k1ywio8298u', NULL, 'GÉNESIS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rrnpkqxag4wdb9escrsgfk284ltfvqjzmftuyufof9kjs87eup','La Bebe - Remix','as74k1ywio8298u','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('06u7izbkcr34pvpf7lpe6aoojbhoc84xhm0aw4hs50ghismv05', 'rrnpkqxag4wdb9escrsgfk284ltfvqjzmftuyufof9kjs87eup', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i03ml727c0pl3xqy0ae3zuzi76ae2x5oxmwjtttr3t9t2iwzjj','TULUM','as74k1ywio8298u','POP','7bPp2NmpmyhLJ7zWazAXMu','https://p.scdn.co/mp3-preview/164468e67b8da8053036c68533ffa473ab680c51?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('06u7izbkcr34pvpf7lpe6aoojbhoc84xhm0aw4hs50ghismv05', 'i03ml727c0pl3xqy0ae3zuzi76ae2x5oxmwjtttr3t9t2iwzjj', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uc2l21m6rv6watkqtqfm94qhnilamdz5rg2f2alde2l0eh13n0','Por las Noches','as74k1ywio8298u','POP','2VzCjpKvPB1l1tqLndtAQa','https://p.scdn.co/mp3-preview/ba2f667c373e2d12343ac00b162886caca060c93?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('06u7izbkcr34pvpf7lpe6aoojbhoc84xhm0aw4hs50ghismv05', 'uc2l21m6rv6watkqtqfm94qhnilamdz5rg2f2alde2l0eh13n0', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i3ib4vi6mqo6zueryt4oqpel8nc1glfei0ppmcv3gf4ms58ut9','Bye','as74k1ywio8298u','POP','6n2P81rPk2RTzwnNNgFOdb','https://p.scdn.co/mp3-preview/94ef6a9f37e088fff4b37e098a46561e74dab95b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('06u7izbkcr34pvpf7lpe6aoojbhoc84xhm0aw4hs50ghismv05', 'i3ib4vi6mqo6zueryt4oqpel8nc1glfei0ppmcv3gf4ms58ut9', '3');
-- Luke Combs
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uduw2bhkkr1tg33', 'Luke Combs', '5@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5db6179b28f7e3654898b279','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:5@artist.com', 'uduw2bhkkr1tg33', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uduw2bhkkr1tg33', 'Reigniting country music with his powerful voice and relatable songs.', 'Luke Combs');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ovokxbiwd2ocy9bejyqpzxvxer8oa1sphyco2vfquf3452eu7v','uduw2bhkkr1tg33', 'https://i.scdn.co/image/ab67616d0000b273ca650d3a95022e0490434ba1', 'Gettin Old','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i4gbcpxx5gj3vryr9htn707p3gaz0fbe9t3ghxrglkh692x3v9','Fast Car','uduw2bhkkr1tg33','POP','1Lo0QY9cvc8sUB2vnIOxDT','https://p.scdn.co/mp3-preview/1dc0426c95058783e0fe1d70c41583ca98317108?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ovokxbiwd2ocy9bejyqpzxvxer8oa1sphyco2vfquf3452eu7v', 'i4gbcpxx5gj3vryr9htn707p3gaz0fbe9t3ghxrglkh692x3v9', '0');
-- Dean Lewis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fcan35k9m59qjpu', 'Dean Lewis', '6@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4fc14e184f9e05ba0676ddee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:6@artist.com', 'fcan35k9m59qjpu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fcan35k9m59qjpu', 'Crafting melodies that resonate with the soul.', 'Dean Lewis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yhta03niyqzi8920mztsak7qddwwc6ftm281epal97w693qr6x','fcan35k9m59qjpu', 'https://i.scdn.co/image/ab67616d0000b273991f6658282ef028f93b11e0', 'The Hardest Love','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u3ehxa50pj3cytdmoqn5bvh9xlorv7jsg6y1u8gds1qs8ronk3','How Do I Say Goodbye','fcan35k9m59qjpu','POP','1aOl53hkZGHkl2Snhr7opL',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yhta03niyqzi8920mztsak7qddwwc6ftm281epal97w693qr6x', 'u3ehxa50pj3cytdmoqn5bvh9xlorv7jsg6y1u8gds1qs8ronk3', '0');
-- Israel & Rodolffo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('l25t03sjemz7s61', 'Israel & Rodolffo', '7@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9600f2bcc76e77811c90f518','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:7@artist.com', 'l25t03sjemz7s61', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('l25t03sjemz7s61', 'Sculpting soundwaves into masterpieces of auditory art.', 'Israel & Rodolffo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bv8eihqqta3d93evtfax199mobs2g3auqaonile6og0f5u2lmb','l25t03sjemz7s61', 'https://i.scdn.co/image/ab67616d0000b2736ccbcc3358d31dcba6e7c035', 'Lets Bora, Vol. 2 (Ao Vivo)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('86c27bmrux4kayzgsq0affmicul495i3rs60ycs0rk9jpm81f9','Seu Brilho Sumiu - Ao Vivo','l25t03sjemz7s61','POP','3PH1nUysW7ybo3Yu8sqlPN','https://p.scdn.co/mp3-preview/125d70024c88bb1bf45666f6396dc21a181c416e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bv8eihqqta3d93evtfax199mobs2g3auqaonile6og0f5u2lmb', '86c27bmrux4kayzgsq0affmicul495i3rs60ycs0rk9jpm81f9', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7332ouigtglri0trp2ewaxx6z7tnhz95wt014cfls2e7ec5fm7','Bombonzinho - Ao Vivo','l25t03sjemz7s61','POP','0SCMVUZ21uYYB8cc0ScfbV','https://p.scdn.co/mp3-preview/b7d7cfb08d5384a52deb562a3e496881c978a9f1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bv8eihqqta3d93evtfax199mobs2g3auqaonile6og0f5u2lmb', '7332ouigtglri0trp2ewaxx6z7tnhz95wt014cfls2e7ec5fm7', '1');
-- Aerosmith
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ggf2qrhmtatv2pq', 'Aerosmith', '8@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5733401b4689b2064458e7d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:8@artist.com', 'ggf2qrhmtatv2pq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ggf2qrhmtatv2pq', 'Delivering soul-stirring tunes that linger in the mind.', 'Aerosmith');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('evt64a1lelz0g10aaftwet590o0os088pihfpik6kjninrt73u','ggf2qrhmtatv2pq', 'https://i.scdn.co/image/ab67616d0000b273bbf0146981704a073405b6c2', 'Aerosmith','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9hfp24l98dqmvt8pl6cs11a40qwxeqo3qo22fnwhfiueyx43g2','Dream On','ggf2qrhmtatv2pq','POP','1xsYj84j7hUDDnTTerGWlH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('evt64a1lelz0g10aaftwet590o0os088pihfpik6kjninrt73u', '9hfp24l98dqmvt8pl6cs11a40qwxeqo3qo22fnwhfiueyx43g2', '0');
-- The Police
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('anedxlmhop6rif5', 'The Police', '9@artist.com', 'https://i.scdn.co/image/1f73a61faca2942cd5ea29c2143184db8645f0b3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:9@artist.com', 'anedxlmhop6rif5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('anedxlmhop6rif5', 'Harnessing the power of melody to tell compelling stories.', 'The Police');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qya2y4xfle4ca02bd28ci1j2upssfll0hsrt8bxh6pkn5xew5s','anedxlmhop6rif5', 'https://i.scdn.co/image/ab67616d0000b2730408dc279dd7c7354ff41014', 'Every Breath You Take The Classics','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dxac228r6huksxb3uhraod1o0m9v6wgx8zk3t764j30b3a3zwh','Every Breath You Take - Remastered 2003','anedxlmhop6rif5','POP','0wF2zKJmgzjPTfircPJ2jg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qya2y4xfle4ca02bd28ci1j2upssfll0hsrt8bxh6pkn5xew5s', 'dxac228r6huksxb3uhraod1o0m9v6wgx8zk3t764j30b3a3zwh', '0');
-- Stray Kids
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('id7w84n14zhl7fm', 'Stray Kids', '10@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0610877c41cb9cc12ad39cc0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:10@artist.com', 'id7w84n14zhl7fm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('id7w84n14zhl7fm', 'A symphony of emotions expressed through sound.', 'Stray Kids');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1v1byjis5axi06hle93ibnyt1ujsv3sumw2opfdub3yjx2jm3v','id7w84n14zhl7fm', 'https://i.scdn.co/image/ab67616d0000b273e27ba26bc14a563bf3d09882', '5-STAR','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c3dfe9zyndnmwwhdgo15t0y8xqhny46m4i51jj73lbd8sfokc0','S-Class','id7w84n14zhl7fm','POP','3gTQwwDNJ42CCLo3Sf4JDd','https://p.scdn.co/mp3-preview/4ea586fdcc2c9aec34a18d2034d1dec78a3b5e25?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1v1byjis5axi06hle93ibnyt1ujsv3sumw2opfdub3yjx2jm3v', 'c3dfe9zyndnmwwhdgo15t0y8xqhny46m4i51jj73lbd8sfokc0', '0');
-- Arcangel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b7pjrid4c0ghyns', 'Arcangel', '11@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebafdf17286a0d7a23ad388587','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:11@artist.com', 'b7pjrid4c0ghyns', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b7pjrid4c0ghyns', 'A symphony of emotions expressed through sound.', 'Arcangel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uwau340fehsaoh3xxdxop53r8lf3er93ghev4glza1foopctp4','b7pjrid4c0ghyns', 'https://i.scdn.co/image/ab67616d0000b27330326b23e30ae93d4d48165b', 'Sr. Santos','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x3r87c7b551v9cvcvk7roa1679lvy66u6gqoo5se5m66dn4uq1','La Jumpa','b7pjrid4c0ghyns','POP','2mnXxnrX5vCGolNkaFvVeM','https://p.scdn.co/mp3-preview/8bcdff4719a7a4211128ec93da03892e46c4bc6a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uwau340fehsaoh3xxdxop53r8lf3er93ghev4glza1foopctp4', 'x3r87c7b551v9cvcvk7roa1679lvy66u6gqoo5se5m66dn4uq1', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fhw3z051bi78nsyz0folarajkojkxojqi85yj1i8m5rusrphra','Arcngel: Bzrp Music Sessions, Vol','b7pjrid4c0ghyns','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uwau340fehsaoh3xxdxop53r8lf3er93ghev4glza1foopctp4', 'fhw3z051bi78nsyz0folarajkojkxojqi85yj1i8m5rusrphra', '1');
-- Yandel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wve49k0qhvfkurp', 'Yandel', '12@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7dbaf2fabcbd4b37168397fd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:12@artist.com', 'wve49k0qhvfkurp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wve49k0qhvfkurp', 'A powerhouse of reggaeton, blending rhythms that move the soul.', 'Yandel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('v4pj7kkmlj2b3v7jwdlxhpfmh1pqeqq3keoynb72m3t14ig117','wve49k0qhvfkurp', 'https://i.scdn.co/image/ab67616d0000b273b2aec01b56eeb74610532700', 'Resistencia','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zb0adgflrhgf4bfacvw8e8ntlc13y3ojpc8yf8xhbpvjn568bs','Yandel 150','wve49k0qhvfkurp','POP','4FAKtPVycI4DxoOHC01YqD','https://p.scdn.co/mp3-preview/338ed053ce26ccc3313b00b5e6153e60ffd2eb19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v4pj7kkmlj2b3v7jwdlxhpfmh1pqeqq3keoynb72m3t14ig117', 'zb0adgflrhgf4bfacvw8e8ntlc13y3ojpc8yf8xhbpvjn568bs', '0');
-- Shubh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dwfaurdgt8xr0iq', 'Shubh', '13@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3eac18e003a215ce96654ce1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:13@artist.com', 'dwfaurdgt8xr0iq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dwfaurdgt8xr0iq', 'Exploring the depths of sound and rhythm.', 'Shubh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yg5ewuq1zmevygujvqj4sxwnloz2zwb9idpuvyig8jbx7ff2sz','dwfaurdgt8xr0iq', 'https://i.scdn.co/image/ab67616d0000b2731a8c4618eda885a406958dd0', 'Still Rollin','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uq0saizd49jdwf9yi8h4rrws3xf16mjgtpgmni5tdvnqc9i8lz','Cheques','dwfaurdgt8xr0iq','POP','4eBvRhTJ2AcxCsbfTUjoRp','https://p.scdn.co/mp3-preview/c607b777f851d56dd524f845957e24901adbf1eb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yg5ewuq1zmevygujvqj4sxwnloz2zwb9idpuvyig8jbx7ff2sz', 'uq0saizd49jdwf9yi8h4rrws3xf16mjgtpgmni5tdvnqc9i8lz', '0');
-- El Chachito
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xddfmaz8r3t1t04', 'El Chachito', '14@artist.com', 'https://i.scdn.co/image/ab67616d0000b27354c372ef8e7b53bb3c932ac5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:14@artist.com', 'xddfmaz8r3t1t04', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xddfmaz8r3t1t04', 'An endless quest for musical perfection.', 'El Chachito');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mmbdvismu04wqa7e4py15c020hrjyrd56zz7u28vziexce75zp','xddfmaz8r3t1t04', 'https://i.scdn.co/image/ab67616d0000b27354c372ef8e7b53bb3c932ac5', 'En Paris','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nbtej2xkzs372wdlc7kr2k13yriqmgzjqc3nkf5lyjafsgm1kf','En Paris','xddfmaz8r3t1t04','POP','1Fuc3pBiPFxAeSJoO8tDh5','https://p.scdn.co/mp3-preview/c57f1229ca237b01f9dbd839bc3ca97f22395a87?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mmbdvismu04wqa7e4py15c020hrjyrd56zz7u28vziexce75zp', 'nbtej2xkzs372wdlc7kr2k13yriqmgzjqc3nkf5lyjafsgm1kf', '0');
-- Sia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3fbm90t7ybajs68', 'Sia', '15@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb25a749000611559f1719cc5f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:15@artist.com', '3fbm90t7ybajs68', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3fbm90t7ybajs68', 'Blending traditional rhythms with modern beats.', 'Sia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wque2pxp4sjnwe06yl0i0l2a2vdvk1aa12mdyomtybep2hob9y','3fbm90t7ybajs68', 'https://i.scdn.co/image/ab67616d0000b273754b2fddebe7039fdb912837', 'This Is Acting (Deluxe Version)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1eyy3xrg2jup5ws6l4kq60k9ru4s942plxr0m2apjplsmo74hd','Unstoppable','3fbm90t7ybajs68','POP','1yvMUkIOTeUNtNWlWRgANS','https://p.scdn.co/mp3-preview/99a07d00531c0053f55a46e94ed92b1560396754?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wque2pxp4sjnwe06yl0i0l2a2vdvk1aa12mdyomtybep2hob9y', '1eyy3xrg2jup5ws6l4kq60k9ru4s942plxr0m2apjplsmo74hd', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qkjpkzc81xztuzoxtqf3lf8xxn0bxsawesmnns5s1qo6yx4ly9','Snowman','3fbm90t7ybajs68','POP','7uoFMmxln0GPXQ0AcCBXRq','https://p.scdn.co/mp3-preview/a936030efc27a4fc52d8c42b20d03ca4cab30836?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wque2pxp4sjnwe06yl0i0l2a2vdvk1aa12mdyomtybep2hob9y', 'qkjpkzc81xztuzoxtqf3lf8xxn0bxsawesmnns5s1qo6yx4ly9', '1');
-- IU
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bmivqfn1ab0130o', 'IU', '16@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb191d43dca6f2f5a126e43e4b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:16@artist.com', 'bmivqfn1ab0130o', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bmivqfn1ab0130o', 'Melodies that capture the essence of human emotion.', 'IU');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2qozf4ih4qv6xusjp7tls8wzukq3fzo8t73i5mkypgw0uk9khm','bmivqfn1ab0130o', NULL, 'IU Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oeyptrtwsqiuf7p2ys4spn7cnntvn1to800i1m6sphro11cmc0','People Pt.2 (feat. IU)','bmivqfn1ab0130o','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2qozf4ih4qv6xusjp7tls8wzukq3fzo8t73i5mkypgw0uk9khm', 'oeyptrtwsqiuf7p2ys4spn7cnntvn1to800i1m6sphro11cmc0', '0');
-- Nicky Youre
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hnjb5291v9y01bu', 'Nicky Youre', '17@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe726c8549d387a241f979acd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:17@artist.com', 'hnjb5291v9y01bu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hnjb5291v9y01bu', 'Elevating the ordinary to extraordinary through music.', 'Nicky Youre');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yc83vuib1qjldgwcrsxacg5bpec98gegj1af3uzehmcu14v39a','hnjb5291v9y01bu', 'https://i.scdn.co/image/ab67616d0000b273ecd970d1d2623b6c7fc6080c', 'Good Times Go','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tirrhpzzf0sdv4wy5pxb8cus9x2imkh8st06jqj6vcguh9rt29','Sunroof','hnjb5291v9y01bu','POP','5YqEzk3C5c3UZ1D5fJUlXA','https://p.scdn.co/mp3-preview/605058558fd8d10c420b56c41555e567645d5b60?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yc83vuib1qjldgwcrsxacg5bpec98gegj1af3uzehmcu14v39a', 'tirrhpzzf0sdv4wy5pxb8cus9x2imkh8st06jqj6vcguh9rt29', '0');
-- Kendrick Lamar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gqaiagp13a8v68v', 'Kendrick Lamar', '18@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9c48431caf52a2d0f38433ff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:18@artist.com', 'gqaiagp13a8v68v', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gqaiagp13a8v68v', 'Sculpting soundwaves into masterpieces of auditory art.', 'Kendrick Lamar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bc9zw9lm937mipxh4cwq5eoedyyj7wxhvpwy8kgl1i80kic6zr','gqaiagp13a8v68v', 'https://i.scdn.co/image/ab67616d0000b273d28d2ebdedb220e479743797', 'good kid, m.A.A.d city','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g9epnmcvk2xpoaz64ikqx1hspjwjhm91b66e6suw9yy7gbhnlm','Money Trees','gqaiagp13a8v68v','POP','2HbKqm4o0w5wEeEFXm2sD4',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bc9zw9lm937mipxh4cwq5eoedyyj7wxhvpwy8kgl1i80kic6zr', 'g9epnmcvk2xpoaz64ikqx1hspjwjhm91b66e6suw9yy7gbhnlm', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tl6v6u96iuct0b42ypxwlacf4ty35zvh32yq92st14ect3m95c','AMERICA HAS A PROBLEM (feat. Kendrick Lamar)','gqaiagp13a8v68v','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bc9zw9lm937mipxh4cwq5eoedyyj7wxhvpwy8kgl1i80kic6zr', 'tl6v6u96iuct0b42ypxwlacf4ty35zvh32yq92st14ect3m95c', '1');
-- Manuel Turizo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xmudskftfwq9loj', 'Manuel Turizo', '19@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebabd3e69b432d6187cf4e28c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:19@artist.com', 'xmudskftfwq9loj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xmudskftfwq9loj', 'A standout in reggaeton, known for his smooth voice and romantic lyrics.', 'Manuel Turizo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e601spnzml1jau7ybde6v9r0jsgszap187hck68c53jtt5pfsb','xmudskftfwq9loj', 'https://i.scdn.co/image/ab67616d0000b2734dd99565ae6453deab7c26e1', '2000','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ursgtho05mrhq0gwqnrsaja9fwut2nc85f8m5v5xvqwmagrab1','La Bachata','xmudskftfwq9loj','POP','3tt9i3Hhzq84dPS8H7iSiJ','https://p.scdn.co/mp3-preview/0232b53fd7849e6696e1ab3099dd01dd00823f17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e601spnzml1jau7ybde6v9r0jsgszap187hck68c53jtt5pfsb', 'ursgtho05mrhq0gwqnrsaja9fwut2nc85f8m5v5xvqwmagrab1', '0');
-- Olivia Rodrigo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8m62ipocbqtnvgr', 'Olivia Rodrigo', '20@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe03a98785f3658f0b6461ec4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:20@artist.com', '8m62ipocbqtnvgr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8m62ipocbqtnvgr', 'A new voice in pop, channeling raw emotions into her songs.', 'Olivia Rodrigo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dawa4tfbej8v0kwrttroff2l4zp427pmwc37tyolhsbtfl0o4c','8m62ipocbqtnvgr', 'https://i.scdn.co/image/ab67616d0000b273e85259a1cae29a8d91f2093d', 'GUTS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jlyp40x4pn4b4wrytzn3x9wme3nmvsd85w19bl33yidjt7qgvu','vampire','8m62ipocbqtnvgr','POP','1kuGVB7EU95pJObxwvfwKS',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dawa4tfbej8v0kwrttroff2l4zp427pmwc37tyolhsbtfl0o4c', 'jlyp40x4pn4b4wrytzn3x9wme3nmvsd85w19bl33yidjt7qgvu', '0');
-- Sog
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xnff9odef6963q6', 'Sog', '21@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe898d69306ccb5bc978ded3a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:21@artist.com', 'xnff9odef6963q6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xnff9odef6963q6', 'Redefining what it means to be an artist in the digital age.', 'Sog');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ibzugscums41jxs96h6ntrj5jdqcbvhgkng11nfj45lhl4h9kp','xnff9odef6963q6', NULL, 'Sog Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ec1sholhl3q95x3lxyy23zd17k9ttvqjcbxg1u2qlkqq9wqi01','QUEMA','xnff9odef6963q6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ibzugscums41jxs96h6ntrj5jdqcbvhgkng11nfj45lhl4h9kp', 'ec1sholhl3q95x3lxyy23zd17k9ttvqjcbxg1u2qlkqq9wqi01', '0');
-- Chris Brown
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0xh4erf7xc5ner6', 'Chris Brown', '22@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba48397e590a1c70e2cda7728','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:22@artist.com', '0xh4erf7xc5ner6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0xh4erf7xc5ner6', 'A confluence of cultural beats and contemporary tunes.', 'Chris Brown');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2m204e1fp1ilz1t62ri8sox9hr9sohtoknx6xips8ezudo6bru','0xh4erf7xc5ner6', 'https://i.scdn.co/image/ab67616d0000b2739a494f7d8909a6cc4ceb74ac', 'Indigo (Extended)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e5pxvo6p5pttomyvx2jirzd2wd166tuhyrj8u0q4fuj42e0bhx','Under The Influence','0xh4erf7xc5ner6','POP','5IgjP7X4th6nMNDh4akUHb','https://p.scdn.co/mp3-preview/52295df71df20e33e1510e3983975cd59f6664a4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2m204e1fp1ilz1t62ri8sox9hr9sohtoknx6xips8ezudo6bru', 'e5pxvo6p5pttomyvx2jirzd2wd166tuhyrj8u0q4fuj42e0bhx', '0');
-- Melanie Martinez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xu6d9w6gkvqsyg4', 'Melanie Martinez', '23@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb77ecd63aaebe2225b07c89f0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:23@artist.com', 'xu6d9w6gkvqsyg4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xu6d9w6gkvqsyg4', 'Crafting soundscapes that transport listeners to another world.', 'Melanie Martinez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('01tqrzttvw7a9dlpx2xaw1w6jftnimi0bamacuz4p3ujdbz225','xu6d9w6gkvqsyg4', 'https://i.scdn.co/image/ab67616d0000b2733c6c534cdacc9cf53e6d2977', 'PORTALS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uroemw1aotlgq5eh1f8dx6c7f4w7to8mds7gzzqieq3vxtg8ho','VOID','xu6d9w6gkvqsyg4','POP','6wmKvtSmyTqHNo44OBXVN1','https://p.scdn.co/mp3-preview/9a2ae9278ecfe2ed8d628dfe05699bf24395d6a0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('01tqrzttvw7a9dlpx2xaw1w6jftnimi0bamacuz4p3ujdbz225', 'uroemw1aotlgq5eh1f8dx6c7f4w7to8mds7gzzqieq3vxtg8ho', '0');
-- Migrantes
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3lgbj8h2hbrgyti', 'Migrantes', '24@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb676e77ad14850536079e2ea8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:24@artist.com', '3lgbj8h2hbrgyti', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3lgbj8h2hbrgyti', 'A harmonious blend of passion and creativity.', 'Migrantes');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1juhj2zo94j2lqlfbjyb002bc5afzvf7261l3p9ncwscfgv1jo','3lgbj8h2hbrgyti', NULL, 'Migrantes Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('txevoxtz5mgh7axj2njeb9cwr6e8rwrwjyt5juknpaf98f128t','MERCHO','3lgbj8h2hbrgyti','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1juhj2zo94j2lqlfbjyb002bc5afzvf7261l3p9ncwscfgv1jo', 'txevoxtz5mgh7axj2njeb9cwr6e8rwrwjyt5juknpaf98f128t', '0');
-- Hozier
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nnoi54uvwg83rft', 'Hozier', '25@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad85a585103dfc2f3439119a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:25@artist.com', 'nnoi54uvwg83rft', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nnoi54uvwg83rft', 'A journey through the spectrum of sound in every album.', 'Hozier');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('f36cinp5p1kb675dutre5yxty3uprulc598abnx37q4zvs06ic','nnoi54uvwg83rft', 'https://i.scdn.co/image/ab67616d0000b2734ca68d59a4a29c856a4a39c2', 'Hozier (Expanded Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cebfygr2ot3ix8ixfhhmlt70p6giia7w6pwgvag33ger01f8p2','Take Me To Church','nnoi54uvwg83rft','POP','1CS7Sd1u5tWkstBhpssyjP','https://p.scdn.co/mp3-preview/d6170162e349338277c97d2fab42c386701a4089?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f36cinp5p1kb675dutre5yxty3uprulc598abnx37q4zvs06ic', 'cebfygr2ot3ix8ixfhhmlt70p6giia7w6pwgvag33ger01f8p2', '0');
-- dennis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ll9v52m9v79zvma', 'dennis', '26@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8a1ec9781a1542458b3b961b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:26@artist.com', 'll9v52m9v79zvma', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ll9v52m9v79zvma', 'Pioneering new paths in the musical landscape.', 'dennis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('osq1idgubznmjbmp5l9470znc0qs15u8ghwg9ouk1msfcv3kbu','ll9v52m9v79zvma', 'https://i.scdn.co/image/ab67616d0000b273ddfc406de0d7dbc2e339f016', 'Tá OK (Remix)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vxtouxm5yx63w81phgpkzhw5wlif5iqomt8ka3qe3iuxzfknt5','T','ll9v52m9v79zvma','POP','35FW5OEe4p38LdjK1KqT2X','https://p.scdn.co/mp3-preview/eaa522f48564e43e33e00c011aef0489526d1072?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('osq1idgubznmjbmp5l9470znc0qs15u8ghwg9ouk1msfcv3kbu', 'vxtouxm5yx63w81phgpkzhw5wlif5iqomt8ka3qe3iuxzfknt5', '0');
-- NLE Choppa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vny7t47q4sjxr6s', 'NLE Choppa', '27@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcc5865053e7177aeb0c26b62','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:27@artist.com', 'vny7t47q4sjxr6s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vny7t47q4sjxr6s', 'An odyssey of sound that defies conventions.', 'NLE Choppa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ihs57aszgatbej9dorp5vx9wc93pqhsv8g8xm0bouu7n8wz792','vny7t47q4sjxr6s', 'https://i.scdn.co/image/ab67616d0000b27349a4f6c9a637e02252a0076d', 'SLUT ME OUT','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w9m60qqzctg5lkefl4sui8eojsnvx8cycyak95uygor0zgtl2c','Slut Me Out','vny7t47q4sjxr6s','POP','5BmB3OaQyYXCqRyN8iR2Yi','https://p.scdn.co/mp3-preview/84ef49a1e71bdac04b7dfb1dea3a56d1ffc50357?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ihs57aszgatbej9dorp5vx9wc93pqhsv8g8xm0bouu7n8wz792', 'w9m60qqzctg5lkefl4sui8eojsnvx8cycyak95uygor0zgtl2c', '0');
-- Tini
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lprr9piqv181a48', 'Tini', '28@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd1ee0c41d3c79e916b910696','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:28@artist.com', 'lprr9piqv181a48', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lprr9piqv181a48', 'Striking chords that resonate across generations.', 'Tini');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nq80pr04uhrmf3l1euikz5sgvucuo6qtp3a71p4hcy9piyi02f','lprr9piqv181a48', 'https://i.scdn.co/image/ab67616d0000b273f5409c637b9a7244e0c0d11d', 'Cupido','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('beyvfwp0lront7ario8yumasnwjn71vxiydc5d8asjzjuofqqe','Cupido','lprr9piqv181a48','POP','04ndZkbKGthTgYSv3xS7en','https://p.scdn.co/mp3-preview/15bc4fa0d69ae03a045704bcc8731def7453458b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nq80pr04uhrmf3l1euikz5sgvucuo6qtp3a71p4hcy9piyi02f', 'beyvfwp0lront7ario8yumasnwjn71vxiydc5d8asjzjuofqqe', '0');
-- Bobby Helms
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('p18qiz77fv95ln3', 'Bobby Helms', '29@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebbec4ae689dc30a2b59a19038','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:29@artist.com', 'p18qiz77fv95ln3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('p18qiz77fv95ln3', 'Melodies that capture the essence of human emotion.', 'Bobby Helms');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('295x8k18051i06t0azvvy7wmrbp0rb03air2rnhgv1c264mbw0','p18qiz77fv95ln3', 'https://i.scdn.co/image/ab67616d0000b273fd56f3c7a294f5cfe51c7b17', 'Jingle Bell Rock/Captain Santa Claus (And His Reindeer Space Patrol)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y3tn434ftr3vb573y3iy19k5y4gjc26cd1dq83hcjbj4zpy2q2','Jingle Bell Rock','p18qiz77fv95ln3','POP','7vQbuQcyTflfCIOu3Uzzya',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('295x8k18051i06t0azvvy7wmrbp0rb03air2rnhgv1c264mbw0', 'y3tn434ftr3vb573y3iy19k5y4gjc26cd1dq83hcjbj4zpy2q2', '0');
-- Becky G
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('saakm9c2rfmsjg1', 'Becky G', '30@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd132bf0d4a9203404cd66f79','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:30@artist.com', 'saakm9c2rfmsjg1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('saakm9c2rfmsjg1', 'Harnessing the power of melody to tell compelling stories.', 'Becky G');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('veme6x4w8ql7jjcq5bkb4h8jdyxcltxvrlsan8y7odi9ro1jgd','saakm9c2rfmsjg1', 'https://i.scdn.co/image/ab67616d0000b273c3bb167f0e78b15e5588c296', 'CHANEL','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hghb961ki99uwr3ot57h3cu3zy7m1rp1ysst1wste233uht11j','Chanel','saakm9c2rfmsjg1','POP','5RcxRGvmYai7kpFSfxe5GY','https://p.scdn.co/mp3-preview/38dbb82dace64ea92e1dafe5989c1d1861656595?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('veme6x4w8ql7jjcq5bkb4h8jdyxcltxvrlsan8y7odi9ro1jgd', 'hghb961ki99uwr3ot57h3cu3zy7m1rp1ysst1wste233uht11j', '0');
-- Vance Joy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ahx80rtae8y3qwb', 'Vance Joy', '31@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f074ec8c25406680bf26422','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:31@artist.com', 'ahx80rtae8y3qwb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ahx80rtae8y3qwb', 'Crafting folk-pop anthems that resonate with heartfelt sincerity.', 'Vance Joy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4uh93pqv0ag56fefqfuvmn45qydy13r75ku24ysdtofcuyoxae','ahx80rtae8y3qwb', 'https://i.scdn.co/image/ab67616d0000b273a9929deb093a6617d2493b03', 'Dream Your Life Away (Special Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wgu4erzqjj5cyfx6o30ot44wjaqglvpk69edxgra7z2pd5ovue','Riptide','ahx80rtae8y3qwb','POP','3JvrhDOgAt6p7K8mDyZwRd','https://p.scdn.co/mp3-preview/74698d907d114f4ba0b2c129bbf260724be80b64?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4uh93pqv0ag56fefqfuvmn45qydy13r75ku24ysdtofcuyoxae', 'wgu4erzqjj5cyfx6o30ot44wjaqglvpk69edxgra7z2pd5ovue', '0');
-- Gunna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ds04m3ab1gnhl0t', 'Gunna', '32@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6501f8a7d50c56e86e46f920','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:32@artist.com', 'ds04m3ab1gnhl0t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ds04m3ab1gnhl0t', 'A trailblazer in trap music, known for his smooth flow and catchy beats.', 'Gunna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6ibfhrral66zskftbp8ewuau5tkat2xv1prdhmrfosddejncoj','ds04m3ab1gnhl0t', 'https://i.scdn.co/image/ab67616d0000b273017d5e26552345c4b1575b6c', 'a Gift & a Curse','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('b04x4row23r4f5s31drq2agvhj0xajx7h1cgynym3hml66td3r','fukumean','ds04m3ab1gnhl0t','POP','4rXLjWdF2ZZpXCVTfWcshS','https://p.scdn.co/mp3-preview/f237ab921af697ba9b49e12fa167c2ce1a82d6b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6ibfhrral66zskftbp8ewuau5tkat2xv1prdhmrfosddejncoj', 'b04x4row23r4f5s31drq2agvhj0xajx7h1cgynym3hml66td3r', '0');
-- Em Beihold
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jyprhxp8mcphued', 'Em Beihold', '33@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb23c885de4c81852c917608ac','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:33@artist.com', 'jyprhxp8mcphued', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jyprhxp8mcphued', 'A voice that captivates, combining depth of lyrics with a melodic finesse.', 'Em Beihold');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7daggb6kp3si4qtmlbboo8yqtxmik1revqxdlkkpncrn1ms38v','jyprhxp8mcphued', NULL, 'Em Beihold Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u6k004mohxzwfi2myw2rgq8dyio6osxf3nmmm3rztw4g9k9c1l','Until I Found You (with Em Beihold) - Em Beihold Version','jyprhxp8mcphued','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7daggb6kp3si4qtmlbboo8yqtxmik1revqxdlkkpncrn1ms38v', 'u6k004mohxzwfi2myw2rgq8dyio6osxf3nmmm3rztw4g9k9c1l', '0');
-- Central Cee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('o0jocck81tzwb8n', 'Central Cee', '34@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5fe7cabb8de1c0266cd2179c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:34@artist.com', 'o0jocck81tzwb8n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('o0jocck81tzwb8n', 'Uniting fans around the globe with universal rhythms.', 'Central Cee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7pocu80xmt3xr3diniez5zuuufm3hkr2em5lsc1rsp1oq20bib','o0jocck81tzwb8n', 'https://i.scdn.co/image/ab67616d0000b273cbb3701743a568e7f1c4e967', 'LET GO','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sq34zl9m0tdikxy32flthrdjc9ow98ns75v6yv9uw8inoh7i90','LET GO','o0jocck81tzwb8n','POP','3zkyus0njMCL6phZmNNEeN','https://p.scdn.co/mp3-preview/5391f8e7621898d3f5237e297e3fbcabe1fe3494?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7pocu80xmt3xr3diniez5zuuufm3hkr2em5lsc1rsp1oq20bib', 'sq34zl9m0tdikxy32flthrdjc9ow98ns75v6yv9uw8inoh7i90', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ms4aax2dgpqkp4ul03ag6qsf7l8ov8xafv4nt67cgtciqmwgn9','Doja','o0jocck81tzwb8n','POP','3LtpKP5abr2qqjunvjlX5i','https://p.scdn.co/mp3-preview/41105628e270a026ac9aecacd44e3373fceb9f43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7pocu80xmt3xr3diniez5zuuufm3hkr2em5lsc1rsp1oq20bib', 'ms4aax2dgpqkp4ul03ag6qsf7l8ov8xafv4nt67cgtciqmwgn9', '1');
-- PinkPantheress
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q7vn7pfyekf8g4q', 'PinkPantheress', '35@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb90ddbcd825c7b6142d269e26','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:35@artist.com', 'q7vn7pfyekf8g4q', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q7vn7pfyekf8g4q', 'Redefining pop music with her distinct sound and style.', 'PinkPantheress');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6iq4msppg4w80nna8t7iposy1phnm1wwleewzbwsqyq74vbd2t','q7vn7pfyekf8g4q', 'https://i.scdn.co/image/ab67616d0000b2739567e1aa41657425d046733b', 'Boys a liar Pt. 2','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('arzk05j8tus8a8wkl8vmg04kfng8forvlsmpaxmmu8u8qt6rot','Boys a liar Pt. 2','q7vn7pfyekf8g4q','POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6iq4msppg4w80nna8t7iposy1phnm1wwleewzbwsqyq74vbd2t', 'arzk05j8tus8a8wkl8vmg04kfng8forvlsmpaxmmu8u8qt6rot', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v9goq5vxou8c33mbq4hyu3ycls8s4jif6jlh6w6qa63y2s7qjy','Boys a liar','q7vn7pfyekf8g4q','POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6iq4msppg4w80nna8t7iposy1phnm1wwleewzbwsqyq74vbd2t', 'v9goq5vxou8c33mbq4hyu3ycls8s4jif6jlh6w6qa63y2s7qjy', '1');
-- BLACKPINK
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pyy1e0o848a1dis', 'BLACKPINK', '36@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc9690bc711d04b3d4fd4b87c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:36@artist.com', 'pyy1e0o848a1dis', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pyy1e0o848a1dis', 'Crafting melodies that resonate with the soul.', 'BLACKPINK');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('78ros4fbhamicdcmvcmbpshy5balvunq04o8vq7dvnv8no8qw5','pyy1e0o848a1dis', 'https://i.scdn.co/image/ab67616d0000b273002ef53878df1b4e91c15406', 'BORN PINK','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ev7sdf1zmocihay3tzkngx0ulanoeinsuay8q8hldx72n66o80','Shut Down','pyy1e0o848a1dis','POP','7gRFDGEzF9UkBV233yv2dc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('78ros4fbhamicdcmvcmbpshy5balvunq04o8vq7dvnv8no8qw5', 'ev7sdf1zmocihay3tzkngx0ulanoeinsuay8q8hldx72n66o80', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ozo894c2w4jpc2rvg4a7hxkzc0j74j6p63a1sk4tuhmx6eg9b5','Pink Venom','pyy1e0o848a1dis','POP','5zwwW9Oq7ubSxoCGyW1nbY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('78ros4fbhamicdcmvcmbpshy5balvunq04o8vq7dvnv8no8qw5', 'ozo894c2w4jpc2rvg4a7hxkzc0j74j6p63a1sk4tuhmx6eg9b5', '1');
-- Keane
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9nzeg9i5koekd52', 'Keane', '37@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41222a45dc0b10f65cbe8160','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:37@artist.com', '9nzeg9i5koekd52', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9nzeg9i5koekd52', 'Blending traditional rhythms with modern beats.', 'Keane');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oqmyxedvmc1hbd2c1kpwbji5xydknjzcx89dzjnfasrjq5pe4r','9nzeg9i5koekd52', 'https://i.scdn.co/image/ab67616d0000b273045d0a38105fbe7bde43c490', 'Hopes And Fears','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dqamd1pe0qhwoib99kqmw6lzvxylwp8y8bdo1zvr1m5hdflrqg','Somewhere Only We Know','9nzeg9i5koekd52','POP','0ll8uFnc0nANY35E0Lfxvg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oqmyxedvmc1hbd2c1kpwbji5xydknjzcx89dzjnfasrjq5pe4r', 'dqamd1pe0qhwoib99kqmw6lzvxylwp8y8bdo1zvr1m5hdflrqg', '0');
-- Omar Apollo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('by5m05wymldmpkj', 'Omar Apollo', '38@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0e2a3a2c664a4bbb14e44f8e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:38@artist.com', 'by5m05wymldmpkj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('by5m05wymldmpkj', 'A voice that echoes the sentiments of a generation.', 'Omar Apollo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ivou2i9xl93jn9bn3qff893zza8lkbnyrmx508r2c9ua1dsg1l','by5m05wymldmpkj', 'https://i.scdn.co/image/ab67616d0000b27390cf5d1ccfca2beb86149a19', 'Ivory','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i8fge2jlhuhre75cuu4m1h74x05hbyakchlpf4r8tzoc29513a','Evergreen (You Didnt Deserve Me A','by5m05wymldmpkj','POP','2TktkzfozZifbQhXjT6I33','https://p.scdn.co/mp3-preview/f9db43c10cfab231d9448792464a23f6e6d607e7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ivou2i9xl93jn9bn3qff893zza8lkbnyrmx508r2c9ua1dsg1l', 'i8fge2jlhuhre75cuu4m1h74x05hbyakchlpf4r8tzoc29513a', '0');
-- Future
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('48447fb0b7ejk5j', 'Future', '39@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:39@artist.com', '48447fb0b7ejk5j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('48447fb0b7ejk5j', 'An alchemist of harmonies, transforming notes into gold.', 'Future');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gmjfk7hqjf0ilveqqnuk1900m6aryqe42res9261c6r57h7ebo','48447fb0b7ejk5j', NULL, 'Future Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7obhzb93qq4lwhndmyhbvhg8tj4ygexxm2dz852lhjakmt34h5','Too Many Nights (feat. Don Toliver & with Future)','48447fb0b7ejk5j','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gmjfk7hqjf0ilveqqnuk1900m6aryqe42res9261c6r57h7ebo', '7obhzb93qq4lwhndmyhbvhg8tj4ygexxm2dz852lhjakmt34h5', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bo1bbpjab4te9okrkby6dy9c3jd8tt6nsg3oxwb5hngkaefrin','All The Way Live (Spider-Man: Across the Spider-Verse) (Metro Boomin & Future, Lil Uzi Vert)','48447fb0b7ejk5j','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gmjfk7hqjf0ilveqqnuk1900m6aryqe42res9261c6r57h7ebo', 'bo1bbpjab4te9okrkby6dy9c3jd8tt6nsg3oxwb5hngkaefrin', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4h3pi11e4x431gwqplg9ssmukyxy92fxfys5y32h8yyfouuftw','Superhero (Heroes & Villains) [with Future & Chris Brown]','48447fb0b7ejk5j','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gmjfk7hqjf0ilveqqnuk1900m6aryqe42res9261c6r57h7ebo', '4h3pi11e4x431gwqplg9ssmukyxy92fxfys5y32h8yyfouuftw', '2');
-- Ray Dalton
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mf8e4fnc6wg6zby', 'Ray Dalton', '40@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb761f04a794923fde50fcb9fb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:40@artist.com', 'mf8e4fnc6wg6zby', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mf8e4fnc6wg6zby', 'Crafting soundscapes that transport listeners to another world.', 'Ray Dalton');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ludu9bs9x32vydrf2nds2i7pt9n3uwwgym2nt2kvt0025hve1r','mf8e4fnc6wg6zby', NULL, 'Ray Dalton Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jgqo619wp1xgetfjspf7ugi13rml4i3vh6gmzcv2w0v12cfugl','Cant Hold Us (feat. Ray Dalton)','mf8e4fnc6wg6zby','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ludu9bs9x32vydrf2nds2i7pt9n3uwwgym2nt2kvt0025hve1r', 'jgqo619wp1xgetfjspf7ugi13rml4i3vh6gmzcv2w0v12cfugl', '0');
-- Cartel De Santa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wruay3cycnwq4dj', 'Cartel De Santa', '41@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:41@artist.com', 'wruay3cycnwq4dj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wruay3cycnwq4dj', 'Transcending language barriers through the universal language of music.', 'Cartel De Santa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6cpk3hr3dq52ubfmz696a7i3oa0garp38d9dhujcb45hsyexof','wruay3cycnwq4dj', 'https://i.scdn.co/image/ab67616d0000b273608e249e118a39e897f149ce', 'Shorty Party','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4uozw2nw3mb9xj282w45zhep78bswn103wc1axmalhp622llkp','Shorty Party','wruay3cycnwq4dj','POP','55ZATsjPlTeSTNJOuW90pW','https://p.scdn.co/mp3-preview/861a31225cff10db2eedeb5c28bf6d0a4ecc4bc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6cpk3hr3dq52ubfmz696a7i3oa0garp38d9dhujcb45hsyexof', '4uozw2nw3mb9xj282w45zhep78bswn103wc1axmalhp622llkp', '0');
-- Kenshi Yonezu
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e6ga36iwuedcgvc', 'Kenshi Yonezu', '42@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc147e0888e83919d317c1103','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:42@artist.com', 'e6ga36iwuedcgvc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e6ga36iwuedcgvc', 'Sculpting soundwaves into masterpieces of auditory art.', 'Kenshi Yonezu');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nllcbfvvvdw6b2ll6cpzziayu23dnezg2tf5xueoxa1vdzcrqf','e6ga36iwuedcgvc', 'https://i.scdn.co/image/ab67616d0000b273303d8545fce8302841c39859', 'KICK BACK','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('stp2923uwsmx56oewh2u7s9jxn5x8174uvaj9skw9m3k3y9otx','KICK BACK','e6ga36iwuedcgvc','POP','3khEEPRyBeOUabbmOPJzAG','https://p.scdn.co/mp3-preview/003a7a062f469db238cf5206626f08f3263c68e6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nllcbfvvvdw6b2ll6cpzziayu23dnezg2tf5xueoxa1vdzcrqf', 'stp2923uwsmx56oewh2u7s9jxn5x8174uvaj9skw9m3k3y9otx', '0');
-- Pritam
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('78wpwt9vwogb7sx', 'Pritam', '43@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcb6926f44f620555ba444fca','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:43@artist.com', '78wpwt9vwogb7sx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('78wpwt9vwogb7sx', 'The architect of aural landscapes that inspire and captivate.', 'Pritam');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7hzlik3p88xvevpulgy7r7gclygul3654z2kkw2pwyzc9k9u88','78wpwt9vwogb7sx', NULL, 'Pritam Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wbmj6qeazrydjfy9m4c7r0eu4rj13dnmbwsghyq0k3xqip073k','Kesariya (From "Brahmastra")','78wpwt9vwogb7sx','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7hzlik3p88xvevpulgy7r7gclygul3654z2kkw2pwyzc9k9u88', 'wbmj6qeazrydjfy9m4c7r0eu4rj13dnmbwsghyq0k3xqip073k', '0');
-- The Walters
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('g8kfm08ih6w7w09', 'The Walters', '44@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6c4366f40ea49c1318707f97','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:44@artist.com', 'g8kfm08ih6w7w09', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('g8kfm08ih6w7w09', 'Pushing the boundaries of sound with each note.', 'The Walters');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zpd8mho20zmcewajnz9a6tu77i2mxkruhyz59so7na82aghkox','g8kfm08ih6w7w09', 'https://i.scdn.co/image/ab67616d0000b2739214ff0109a0e062f8a6cf0f', 'I Love You So','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('b398j5sigafjwtk82jj3meb1mfmuao6xp8fnqti956ouql335r','I Love You So','g8kfm08ih6w7w09','POP','4SqWKzw0CbA05TGszDgMlc','https://p.scdn.co/mp3-preview/83919b3d62a4ae352229c0a779e8aa0c1b2f4f40?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zpd8mho20zmcewajnz9a6tu77i2mxkruhyz59so7na82aghkox', 'b398j5sigafjwtk82jj3meb1mfmuao6xp8fnqti956ouql335r', '0');
-- Steve Lacy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ralu2vcdnh4ot3c', 'Steve Lacy', '45@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb09ac9d040c168d4e4f58eb42','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:45@artist.com', 'ralu2vcdnh4ot3c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ralu2vcdnh4ot3c', 'Igniting the stage with electrifying performances.', 'Steve Lacy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('n7kmbkwwh84ogppga4stg0bdqis8cl2l337nzh4si6taxrf4f8','ralu2vcdnh4ot3c', 'https://i.scdn.co/image/ab67616d0000b27368968350c2550e36d96344ee', 'Gemini Rights','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c7fz87n6u64ye65la1gm8ouk6cbtkwqawy4pikat1lgd6iej90','Bad Habit','ralu2vcdnh4ot3c','POP','4k6Uh1HXdhtusDW5y8Gbvy','https://p.scdn.co/mp3-preview/efe7c2fdd8fa727a108a1270b114ebedabfd766c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n7kmbkwwh84ogppga4stg0bdqis8cl2l337nzh4si6taxrf4f8', 'c7fz87n6u64ye65la1gm8ouk6cbtkwqawy4pikat1lgd6iej90', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r9f0xpawdhrjvtnio8jbo8obm6tn3zczuw5omxmzxtd2liizdx','Dark Red','ralu2vcdnh4ot3c','POP','3EaJDYHA0KnX88JvDhL9oa','https://p.scdn.co/mp3-preview/90b3855fd50a4c4878a2d5117ebe73f658a97285?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n7kmbkwwh84ogppga4stg0bdqis8cl2l337nzh4si6taxrf4f8', 'r9f0xpawdhrjvtnio8jbo8obm6tn3zczuw5omxmzxtd2liizdx', '1');
-- P!nk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ushkxxc0eakadgm', 'P!nk', '46@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7bbad89a61061304ec842588','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:46@artist.com', 'ushkxxc0eakadgm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ushkxxc0eakadgm', 'Creating a tapestry of tunes that celebrates diversity.', 'P!nk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('unsg891lfafkylr1mtrj3sxb3ujn6c4d4z509vp7a3spoldsjp','ushkxxc0eakadgm', 'https://i.scdn.co/image/ab67616d0000b27302f93e92bdd5b3793eb688c0', 'TRUSTFALL','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nk9pyxaflcslanhibci27qtxmmvezraj6e99wyzdm2yxt4n6pi','TRUSTFALL','ushkxxc0eakadgm','POP','4FWbsd91QSvgr1dSWwW51e','https://p.scdn.co/mp3-preview/4a8b78e434e2dda75bc679955c3fbd8b4dad372b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('unsg891lfafkylr1mtrj3sxb3ujn6c4d4z509vp7a3spoldsjp', 'nk9pyxaflcslanhibci27qtxmmvezraj6e99wyzdm2yxt4n6pi', '0');
-- JISOO
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('t5nkq4awcw33doj', 'JISOO', '47@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcb6017286dd64ca6b77c879f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:47@artist.com', 't5nkq4awcw33doj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('t5nkq4awcw33doj', 'Pushing the boundaries of sound with each note.', 'JISOO');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7i9v598731t7fjs4qp0z3sij6wckii13ev17x3zaqp23zt284w','t5nkq4awcw33doj', 'https://i.scdn.co/image/ab67616d0000b273f35b8a6c03cc633f734bd8ac', 'ME','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('icxla4zb0oytw63yvmt0zsxciafpumyz8vdnsthaxlr9kfwccj','FLOWER','t5nkq4awcw33doj','POP','69CrOS7vEHIrhC2ILyEi0s',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7i9v598731t7fjs4qp0z3sij6wckii13ev17x3zaqp23zt284w', 'icxla4zb0oytw63yvmt0zsxciafpumyz8vdnsthaxlr9kfwccj', '0');
-- Rauw Alejandro
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4fti8akipib2a9z', 'Rauw Alejandro', '48@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9047f938310ea16b68a5bdeb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:48@artist.com', '4fti8akipib2a9z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4fti8akipib2a9z', 'A fusion of Latin trap and reggaeton, setting the stage on fire.', 'Rauw Alejandro');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jaftdyrgluueabfosp071slaj911unidjirgj0jckyluv00nuj','4fti8akipib2a9z', NULL, 'PLAYA SATURNO','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('feg3jpgk3yxqwzs0v06r6deasnq0mqf4ogdhr4av17ws8n8vw2','BESO','4fti8akipib2a9z','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jaftdyrgluueabfosp071slaj911unidjirgj0jckyluv00nuj', 'feg3jpgk3yxqwzs0v06r6deasnq0mqf4ogdhr4av17ws8n8vw2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mnrq5nt5gqkjp7fi6edsfz93fp552v2wtk3lq6ull16vv2qg4w','BABY HELLO','4fti8akipib2a9z','POP','21N77gfWYoQDvrLvaeiQgi','https://p.scdn.co/mp3-preview/561b48e3a4ed3c4c4d9fc3d12425198d31e98809?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jaftdyrgluueabfosp071slaj911unidjirgj0jckyluv00nuj', 'mnrq5nt5gqkjp7fi6edsfz93fp552v2wtk3lq6ull16vv2qg4w', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w78mf2zwv7sa924hq1wma1or2i7ms9aiajk90vt2zuvpyfhno6','Rauw Alejandro: Bzrp Music Sessions, Vol. 56','4fti8akipib2a9z','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jaftdyrgluueabfosp071slaj911unidjirgj0jckyluv00nuj', 'w78mf2zwv7sa924hq1wma1or2i7ms9aiajk90vt2zuvpyfhno6', '2');
-- XXXTENTACION
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('spncxup781jm5t8', 'XXXTENTACION', '49@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf0c20db5ef6c6fbe5135d2e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:49@artist.com', 'spncxup781jm5t8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('spncxup781jm5t8', 'The heartbeat of a new generation of music lovers.', 'XXXTENTACION');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wo6hxtgqr0qivpk91fo9zwsbn3s9otnejsahmhflxkz77g82ku','spncxup781jm5t8', 'https://i.scdn.co/image/ab67616d0000b273203c89bd4391468eea4cc3f5', '17','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wff079sfc5bhqyb3twj50hr7glzack3nobwv5x497jinw08gvd','Revenge','spncxup781jm5t8','POP','5TXDeTFVRVY7Cvt0Dw4vWW','https://p.scdn.co/mp3-preview/8f5fe8bb510463b2da20325c8600200bf2984d83?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wo6hxtgqr0qivpk91fo9zwsbn3s9otnejsahmhflxkz77g82ku', 'wff079sfc5bhqyb3twj50hr7glzack3nobwv5x497jinw08gvd', '0');
-- Big One
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c94mq8t2dw3hrk2', 'Big One', '50@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba4bdcd4a70e31bb4cba3ad34','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:50@artist.com', 'c94mq8t2dw3hrk2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c94mq8t2dw3hrk2', 'Bringing a unique energy to every track, fusing various styles into a cohesive sound.', 'Big One');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j90jwai23f92atxjem8f5qjcwtv5ucdn7356dy5vceckd37hoo','c94mq8t2dw3hrk2', NULL, 'Un Finde | CROSSOVER #2','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('78t23ca320da5vs0dm7mxnsks5fkmorii1cnd827067edzw8gi','Los del Espacio','c94mq8t2dw3hrk2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j90jwai23f92atxjem8f5qjcwtv5ucdn7356dy5vceckd37hoo', '78t23ca320da5vs0dm7mxnsks5fkmorii1cnd827067edzw8gi', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ndtc2uend2rolbjkyrjy6z9jmsxqn27ub7yn28yie5m33kuaj6','Un Finde | CROSSOVER #2','c94mq8t2dw3hrk2','POP','3tiJUOfAEqIrLFRQgGgdoY','https://p.scdn.co/mp3-preview/38b8f2c063a896c568b9741dcd6e194be0a0376b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j90jwai23f92atxjem8f5qjcwtv5ucdn7356dy5vceckd37hoo', 'ndtc2uend2rolbjkyrjy6z9jmsxqn27ub7yn28yie5m33kuaj6', '1');
-- TOMORROW X TOGETHER
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4yxrn2zwp02423y', 'TOMORROW X TOGETHER', '51@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8b446e5bd3820ac772155b31','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:51@artist.com', '4yxrn2zwp02423y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4yxrn2zwp02423y', 'An endless quest for musical perfection.', 'TOMORROW X TOGETHER');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o8s6thd4v74m8i3y9fhvbd5zgbj7gbb287cegqt7e2ccgku9k7','4yxrn2zwp02423y', 'https://i.scdn.co/image/ab67616d0000b2733bb056e3160b85ee86c1194d', 'The Name Chapter: TEMPTATION','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k9wxa87ptuh3uieot3j0e0yglbi6mg7q58wmqbrsdkdluz6ubo','Sugar Rush Ride','4yxrn2zwp02423y','POP','0rhI6gvOeCKA502RdJAbfs','https://p.scdn.co/mp3-preview/691f502777012a09541b5265cfddaa4401470759?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o8s6thd4v74m8i3y9fhvbd5zgbj7gbb287cegqt7e2ccgku9k7', 'k9wxa87ptuh3uieot3j0e0yglbi6mg7q58wmqbrsdkdluz6ubo', '0');
-- Billie Eilish
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('g85vjz2sf26e807', 'Billie Eilish', '52@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd8b9980db67272cb4d2c3daf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:52@artist.com', 'g85vjz2sf26e807', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('g85vjz2sf26e807', 'An icon in modern pop, known for her haunting vocals and introspective lyrics.', 'Billie Eilish');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hm8qkv8huu8k6lyl3ax6ypb5e9b61oetdkcrej4dslp7ss4z88','g85vjz2sf26e807', NULL, 'Guitar Songs','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5u76ig28rq3k60k63q6ild90gb3oxppg873otub34jamwzx9uq','What Was I Made For? [From The Motion Picture "Barbie"]','g85vjz2sf26e807','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hm8qkv8huu8k6lyl3ax6ypb5e9b61oetdkcrej4dslp7ss4z88', '5u76ig28rq3k60k63q6ild90gb3oxppg873otub34jamwzx9uq', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nwptpt1zhvu09u5v2u7tobiy5caopsx2ltn7tpjls4kku9f9y6','lovely - Bonus Track','g85vjz2sf26e807','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hm8qkv8huu8k6lyl3ax6ypb5e9b61oetdkcrej4dslp7ss4z88', 'nwptpt1zhvu09u5v2u7tobiy5caopsx2ltn7tpjls4kku9f9y6', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iadpshn11f894ehfcf31o1xzcxxahxijv0dnkkmb1ffibdq30z','TV','g85vjz2sf26e807','POP','3GYlZ7tbxLOxe6ewMNVTkw',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hm8qkv8huu8k6lyl3ax6ypb5e9b61oetdkcrej4dslp7ss4z88', 'iadpshn11f894ehfcf31o1xzcxxahxijv0dnkkmb1ffibdq30z', '2');
-- Miguel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('imofq1scmjz9f3n', 'Miguel', '53@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4669166b571594eade778990','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:53@artist.com', 'imofq1scmjz9f3n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('imofq1scmjz9f3n', 'Music is my canvas, and notes are my paint.', 'Miguel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wznr2t2ob3543bl7ckcypz6thg3yyc1mtkitfhi8dgf82cgoko','imofq1scmjz9f3n', 'https://i.scdn.co/image/ab67616d0000b273d5a8395b0d80b8c48a5d851c', 'All I Want Is You','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x20w1byc8vg499h3ydgctbhux4udtwf7db9n3b9hyd50qi47y7','Sure Thing','imofq1scmjz9f3n','POP','0JXXNGljqupsJaZsgSbMZV','https://p.scdn.co/mp3-preview/d337faa4bb71c8ac9a13998be64fbb0d7d8b8463?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wznr2t2ob3543bl7ckcypz6thg3yyc1mtkitfhi8dgf82cgoko', 'x20w1byc8vg499h3ydgctbhux4udtwf7db9n3b9hyd50qi47y7', '0');
-- Rosa Linn
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('epjhoaryu43ppmi', 'Rosa Linn', '54@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5fe9684ed75d00000b63791','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:54@artist.com', 'epjhoaryu43ppmi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('epjhoaryu43ppmi', 'A sonic adventurer, always seeking new horizons in music.', 'Rosa Linn');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('p3t3jdk4zppqa5ito1h4s9gnfzr7i4hjgdr3l2hx0z01p3lj4l','epjhoaryu43ppmi', 'https://i.scdn.co/image/ab67616d0000b2731391b1fdb63da53e5b112224', 'SNAP','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qe431edk5zy3ws8bzoikmiozynrx3lga1ghi7kdp8g91mbc736','SNAP','epjhoaryu43ppmi','POP','76OGwb5RA9h4FxQPT33ekc','https://p.scdn.co/mp3-preview/0a41500662a6b6223dcb026b20ef1437985574b8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p3t3jdk4zppqa5ito1h4s9gnfzr7i4hjgdr3l2hx0z01p3lj4l', 'qe431edk5zy3ws8bzoikmiozynrx3lga1ghi7kdp8g91mbc736', '0');
-- Labrinth
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2d8glqvcbrx0x6k', 'Labrinth', '55@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7885d725841e0338092f5f6f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:55@artist.com', '2d8glqvcbrx0x6k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2d8glqvcbrx0x6k', 'Transcending language barriers through the universal language of music.', 'Labrinth');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ivf9tyklhnlpah6yrfyu9w8rk4nca3l0gwe9g9vfhf10o2p44w','2d8glqvcbrx0x6k', 'https://i.scdn.co/image/ab67616d0000b2731df535f5089e544a3cc86069', 'Ends & Begins','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5jn7lq4oe903xpugfhy3ldo1qwkf2pjj2wsf1miw61cndqaw4s','Never Felt So Alone','2d8glqvcbrx0x6k','POP','6unndO70DvZfnXYcYQMyQJ','https://p.scdn.co/mp3-preview/d33db796d822aa77728af0f4abb06ccd596d2920?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ivf9tyklhnlpah6yrfyu9w8rk4nca3l0gwe9g9vfhf10o2p44w', '5jn7lq4oe903xpugfhy3ldo1qwkf2pjj2wsf1miw61cndqaw4s', '0');
-- Lord Huron
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kxeanlsddsrhevy', 'Lord Huron', '56@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1d4e4e7e3c5d8fa494fc5f10','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:56@artist.com', 'kxeanlsddsrhevy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kxeanlsddsrhevy', 'Transcending language barriers through the universal language of music.', 'Lord Huron');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1brr09cfrgclp3a1q5f9l4smm31fjny4ly19s372hkdylx0hfs','kxeanlsddsrhevy', 'https://i.scdn.co/image/ab67616d0000b2739d2efe43d5b7ebc7cb60ca81', 'Strange Trails','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9jb0ox6l3yva4o3kgcsvv9kpvjvxi2wpt5mi8ngqdwq0a6up5x','The Night We Met','kxeanlsddsrhevy','POP','0QZ5yyl6B6utIWkxeBDxQN','https://p.scdn.co/mp3-preview/f10f271b165ee07e3d49d9f961d08b7ad74ebd5b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1brr09cfrgclp3a1q5f9l4smm31fjny4ly19s372hkdylx0hfs', '9jb0ox6l3yva4o3kgcsvv9kpvjvxi2wpt5mi8ngqdwq0a6up5x', '0');
-- Vishal-Shekhar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9ygw0aa3wr1pobi', 'Vishal-Shekhar', '57@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb90b6c3d093f9b02aad628eaf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:57@artist.com', '9ygw0aa3wr1pobi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9ygw0aa3wr1pobi', 'Crafting a unique sonic identity in every track.', 'Vishal-Shekhar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0e3ixx35485qyabl7ijrbghh6brgb9jb19s5qw5v8hj1rez2q5','9ygw0aa3wr1pobi', NULL, 'Vishal-Shekhar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o1k8fei4zzecmv1xt8n1mdee2k1erz094038wixwmmwr3wxaxe','Besharam Rang (From "Pathaan")','9ygw0aa3wr1pobi','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0e3ixx35485qyabl7ijrbghh6brgb9jb19s5qw5v8hj1rez2q5', 'o1k8fei4zzecmv1xt8n1mdee2k1erz094038wixwmmwr3wxaxe', '0');
-- Anggi Marito
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wsqav00elhxk6am', 'Anggi Marito', '58@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb604493f4d58b7d152a2d5f79','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:58@artist.com', 'wsqav00elhxk6am', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wsqav00elhxk6am', 'An endless quest for musical perfection.', 'Anggi Marito');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d4cw88oys5t6mg8iw1fex953ebsrju7ke7gzjsiuvszyykovb3','wsqav00elhxk6am', 'https://i.scdn.co/image/ab67616d0000b2732844c4e4e984ea408ab7fd6f', 'Tak Segampang Itu','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('njhrk1qt647il1fjx4g5qk5fl525qsu049dhl3gwc078q2hzz1','Tak Segampang Itu','wsqav00elhxk6am','POP','26cvTWJq2E1QqN4jyH2OTU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d4cw88oys5t6mg8iw1fex953ebsrju7ke7gzjsiuvszyykovb3', 'njhrk1qt647il1fjx4g5qk5fl525qsu049dhl3gwc078q2hzz1', '0');
-- Maria Becerra
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jbyx2t0b5vvrzxo', 'Maria Becerra', '59@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb6cfa517b8f5a152d63c4ffb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:59@artist.com', 'jbyx2t0b5vvrzxo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jbyx2t0b5vvrzxo', 'A vibrant new voice in Latin pop, fusing catchy melodies with urban sounds.', 'Maria Becerra');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o4409o2la69vopjpqxl8ijdnl3p0g325nrn83xi8qqsy5pyuui','jbyx2t0b5vvrzxo', NULL, 'Maria Becerra Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h7taqp889bxrr7z6hio0j3k26qyfg3xj5scmhq1i6fr281gel4','CORAZN VA','jbyx2t0b5vvrzxo','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o4409o2la69vopjpqxl8ijdnl3p0g325nrn83xi8qqsy5pyuui', 'h7taqp889bxrr7z6hio0j3k26qyfg3xj5scmhq1i6fr281gel4', '0');
-- Maroon 5
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u8ottdojcgbunc8', 'Maroon 5', '60@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf8349dfb619a7f842242de77','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:60@artist.com', 'u8ottdojcgbunc8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u8ottdojcgbunc8', 'A symphony of emotions expressed through sound.', 'Maroon 5');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2uokyjgjucekfdwgbm9uqu8mn3goitdc9l7uh94w14uwaozzki','u8ottdojcgbunc8', 'https://i.scdn.co/image/ab67616d0000b273ce7d499847da02a9cbd1c084', 'Overexposed (Deluxe)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('knx7zgjfje1xzu4dus5uxhe8zk7dv2y349x2knjgkym0u2wj6j','Payphone','u8ottdojcgbunc8','POP','4P0osvTXoSYZZC2n8IFH3c',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2uokyjgjucekfdwgbm9uqu8mn3goitdc9l7uh94w14uwaozzki', 'knx7zgjfje1xzu4dus5uxhe8zk7dv2y349x2knjgkym0u2wj6j', '0');
-- NewJeans
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('532zqzx9pgy9fy1', 'NewJeans', '61@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5da361915b1fa48895d4f23f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:61@artist.com', '532zqzx9pgy9fy1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('532zqzx9pgy9fy1', 'Redefining K-pop with their fresh style and energetic performances.', 'NewJeans');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('snhxz8damfpc5i3sfj1bdc6o63hbhp7xaur65wcd8bcio95vxj','532zqzx9pgy9fy1', 'https://i.scdn.co/image/ab67616d0000b2733d98a0ae7c78a3a9babaf8af', 'NewJeans Super Shy','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z0jw7xui5vnmf2crvm14fx0kxe3la0ves48bzkh8fuog3z7xd1','Super Shy','532zqzx9pgy9fy1','POP','5sdQOyqq2IDhvmx2lHOpwd','https://p.scdn.co/mp3-preview/dab062e2cc708a2680ce84953a3581c5a679a230?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('snhxz8damfpc5i3sfj1bdc6o63hbhp7xaur65wcd8bcio95vxj', 'z0jw7xui5vnmf2crvm14fx0kxe3la0ves48bzkh8fuog3z7xd1', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6iepl8pdaw7xjyn1qe0f4ekkp0wnmx6c62x8wn1x31uzkvhcqu','New Jeans','532zqzx9pgy9fy1','POP','6rdkCkjk6D12xRpdMXy0I2','https://p.scdn.co/mp3-preview/a37b4269b0dc5e952826d8c43d1b7c072ac39b4c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('snhxz8damfpc5i3sfj1bdc6o63hbhp7xaur65wcd8bcio95vxj', '6iepl8pdaw7xjyn1qe0f4ekkp0wnmx6c62x8wn1x31uzkvhcqu', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z4naw3b7h2lkyk85a209njrze8qz5dupkysl61lqa01mz286fr','OMG','532zqzx9pgy9fy1','POP','65FftemJ1DbbZ45DUfHJXE','https://p.scdn.co/mp3-preview/b9e344aa96afc45a56df77ca63c78786bdaa0047?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('snhxz8damfpc5i3sfj1bdc6o63hbhp7xaur65wcd8bcio95vxj', 'z4naw3b7h2lkyk85a209njrze8qz5dupkysl61lqa01mz286fr', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nm62n7cirt9irz510eg2c9g7x6t5tp3v74zgay9tfrelfpksdo','Ditto','532zqzx9pgy9fy1','POP','3r8RuvgbX9s7ammBn07D3W','https://p.scdn.co/mp3-preview/4f048713ddfa434539dec7c3cb689f3393353edd?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('snhxz8damfpc5i3sfj1bdc6o63hbhp7xaur65wcd8bcio95vxj', 'nm62n7cirt9irz510eg2c9g7x6t5tp3v74zgay9tfrelfpksdo', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('95vj72c3fucn0yjq91nxvaphw2r5m5tjyviq3l25exa2fcgd34','Hype Boy','532zqzx9pgy9fy1','POP','0a4MMyCrzT0En247IhqZbD','https://p.scdn.co/mp3-preview/7c55950057fc446dc2ce59671dff4fa6b3ef52a7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('snhxz8damfpc5i3sfj1bdc6o63hbhp7xaur65wcd8bcio95vxj', '95vj72c3fucn0yjq91nxvaphw2r5m5tjyviq3l25exa2fcgd34', '4');
-- Travis Scott
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b9k96warvtvamjc', 'Travis Scott', '62@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb19c2790744c792d05570bb71','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:62@artist.com', 'b9k96warvtvamjc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b9k96warvtvamjc', 'Crafting melodies that resonate with the soul.', 'Travis Scott');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0nwce2wrxvr4fcm0bcduz5is1fojh6x1uoo9v0p23pgdnh204b','b9k96warvtvamjc', NULL, 'Travis Scott Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nrrorbefqvsf38gyitu6ilv8g5ybg3m4sfh0446mhh3lqj91q3','Trance (with Travis Scott & Young Thug)','b9k96warvtvamjc','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0nwce2wrxvr4fcm0bcduz5is1fojh6x1uoo9v0p23pgdnh204b', 'nrrorbefqvsf38gyitu6ilv8g5ybg3m4sfh0446mhh3lqj91q3', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y0ol5de4qevut0p2fgq4tz6ij4ijb9d2eihgqgwkvt2vpix02t','Niagara Falls (Foot or 2) [with Travis Scott & 21 Savage]','b9k96warvtvamjc','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0nwce2wrxvr4fcm0bcduz5is1fojh6x1uoo9v0p23pgdnh204b', 'y0ol5de4qevut0p2fgq4tz6ij4ijb9d2eihgqgwkvt2vpix02t', '1');
-- Jain
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e12602wqoz39m9e', 'Jain', '63@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb673f287fead1f6c83b9b68ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:63@artist.com', 'e12602wqoz39m9e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e12602wqoz39m9e', 'Mixing electronic beats with multicultural influences to create a unique sound.', 'Jain');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qvtn6wrssgdoi4ms0m1d90er32z2ttpibqzenqv37wu57zxq2q','e12602wqoz39m9e', 'https://i.scdn.co/image/ab67616d0000b27364ba66f8a81c52364e55db50', 'Zanaka (Deluxe)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dyd6dnf5e0gk52zfx2b97jghz4965pafk7dkj7lmmvyyhmyfrj','Makeba','e12602wqoz39m9e','POP','4TNFLwe6DhtR3Wn1JKMqMJ','https://p.scdn.co/mp3-preview/41db29480f9d12734adf491d3b5dd4da1005047c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qvtn6wrssgdoi4ms0m1d90er32z2ttpibqzenqv37wu57zxq2q', 'dyd6dnf5e0gk52zfx2b97jghz4965pafk7dkj7lmmvyyhmyfrj', '0');
-- BLESSD
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lecmpqs3btubdyf', 'BLESSD', '64@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb261b09aa72e689605bb96758','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:64@artist.com', 'lecmpqs3btubdyf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lecmpqs3btubdyf', 'Crafting soundscapes that transport listeners to another world.', 'BLESSD');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vtn1wuwv9y2fidqs2r09p4wi5ryv892k38o66hg1lroi8l0yzc','lecmpqs3btubdyf', NULL, 'BLESSD Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d45ale4efqag572l18cxmh2aekzpgrl5ye9hhulsi8c93vtdy7','Las Morras','lecmpqs3btubdyf','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vtn1wuwv9y2fidqs2r09p4wi5ryv892k38o66hg1lroi8l0yzc', 'd45ale4efqag572l18cxmh2aekzpgrl5ye9hhulsi8c93vtdy7', '0');
-- Ariana Grande
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hahje81szec72sh', 'Ariana Grande', '65@artist.com', 'https://i.scdn.co/image/ab67616d0000b273a40e82a624fd71db16151256','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:65@artist.com', 'hahje81szec72sh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hahje81szec72sh', 'A powerhouse vocalist, dominating pop with her range and iconic style.', 'Ariana Grande');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y2nu7pj9ixow5aem3my3l4qt7r9wxbava9n15oxiliif60b45e','hahje81szec72sh', NULL, 'Santa Tell Me','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xyouboj9zk6lwcxm8bnan2nrsdnupdvze6pz2b3gr4cc1vywb1','Die For You - Remix','hahje81szec72sh','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y2nu7pj9ixow5aem3my3l4qt7r9wxbava9n15oxiliif60b45e', 'xyouboj9zk6lwcxm8bnan2nrsdnupdvze6pz2b3gr4cc1vywb1', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s7xsbz925zx7mfn0xjyen0fy156mvohfbzin7l5h71i9bbcmzy','Save Your Tears (with Ariana Grande) (Remix)','hahje81szec72sh','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y2nu7pj9ixow5aem3my3l4qt7r9wxbava9n15oxiliif60b45e', 's7xsbz925zx7mfn0xjyen0fy156mvohfbzin7l5h71i9bbcmzy', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p0ok53glppgs0liave6aac6rar0hlv1bhcijg1lgrkvfgu62b0','Santa Tell Me','hahje81szec72sh','POP','0lizgQ7Qw35od7CYaoMBZb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y2nu7pj9ixow5aem3my3l4qt7r9wxbava9n15oxiliif60b45e', 'p0ok53glppgs0liave6aac6rar0hlv1bhcijg1lgrkvfgu62b0', '2');
-- Elley Duh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1y053841fo43nio', 'Elley Duh', '66@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb44efd91d240d9853049612b4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:66@artist.com', '1y053841fo43nio', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1y053841fo43nio', 'Blending traditional rhythms with modern beats.', 'Elley Duh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pxlnffffww2fi3eplgnzogsx0m8z4xjtyfyou55rncwnk20tvc','1y053841fo43nio', 'https://i.scdn.co/image/ab67616d0000b27353a2e11c1bde700722fecd2e', 'MIDDLE OF THE NIGHT','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mfutxn2g1yxuq8laewglb2wm8rsisw3dvz6sahzinasea07173','MIDDLE OF THE NIGHT','1y053841fo43nio','POP','58HvfVOeJY7lUuCqF0m3ly','https://p.scdn.co/mp3-preview/e7c2441dcf8e321237c35085e4aa05bd0dcfa2c4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pxlnffffww2fi3eplgnzogsx0m8z4xjtyfyou55rncwnk20tvc', 'mfutxn2g1yxuq8laewglb2wm8rsisw3dvz6sahzinasea07173', '0');
-- Seafret
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1ykhpj3s1d4orb1', 'Seafret', '67@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7f753324eacfbe0db36d64e5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:67@artist.com', '1ykhpj3s1d4orb1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1ykhpj3s1d4orb1', 'Blending traditional rhythms with modern beats.', 'Seafret');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('91e89chh7sivl4dcwbe95nqcpcadrdu19dej55h4p8v9f42d2u','1ykhpj3s1d4orb1', 'https://i.scdn.co/image/ab67616d0000b2738c33272a7c77042f5eb39d75', 'Tell Me Its Real (Expanded Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3k1xpc9jillq1kix1odkiuk2xo8s6z7418owlksl8erfdca1pc','Atlantis','1ykhpj3s1d4orb1','POP','1Fid2jjqsHViMX6xNH70hE','https://p.scdn.co/mp3-preview/2097364ff6c9f41d658ea1b00a5e2153dc61144b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('91e89chh7sivl4dcwbe95nqcpcadrdu19dej55h4p8v9f42d2u', '3k1xpc9jillq1kix1odkiuk2xo8s6z7418owlksl8erfdca1pc', '0');
-- Gabito Ballesteros
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m9kph1oi8dqq18k', 'Gabito Ballesteros', '68@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1f256a76f868b8f595f729d5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:68@artist.com', 'm9kph1oi8dqq18k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m9kph1oi8dqq18k', 'A vibrant force in the music scene, infusing every performance with passion.', 'Gabito Ballesteros');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0z1svgo6c20p4tmb38t4cgpvsz2epo9xsk0ku0q6d3pjkqxfoc','m9kph1oi8dqq18k', NULL, 'Gabito Ballesteros Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2ljj2xkjiolb1hsfqbdv4wbbhrvrv6yx7r8qj1dekadjao8gda','LADY GAGA','m9kph1oi8dqq18k','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0z1svgo6c20p4tmb38t4cgpvsz2epo9xsk0ku0q6d3pjkqxfoc', '2ljj2xkjiolb1hsfqbdv4wbbhrvrv6yx7r8qj1dekadjao8gda', '0');
-- Raim Laode
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v1u7hpi7098zvok', 'Raim Laode', '69@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f5fe38a2d25be089bf281e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:69@artist.com', 'v1u7hpi7098zvok', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v1u7hpi7098zvok', 'A journey through the spectrum of sound in every album.', 'Raim Laode');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('q5h39x5tv3htpka2gmz16mudrx055tuks6dck8xv9457ru5m2s','v1u7hpi7098zvok', 'https://i.scdn.co/image/ab67616d0000b2735733fcb8f308e4bca3d3a1c9', 'Komang','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ub37mjtvcp6m3p6hi67t2bn8ai7ais6m0ubnsl5n4530b18wkc','Komang','v1u7hpi7098zvok','POP','654ZF6YNWjQS2NhwR3QnX7','https://p.scdn.co/mp3-preview/de2ec1a10faf62ec1c6af15bd45b3d93b2c9ee67?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q5h39x5tv3htpka2gmz16mudrx055tuks6dck8xv9457ru5m2s', 'ub37mjtvcp6m3p6hi67t2bn8ai7ais6m0ubnsl5n4530b18wkc', '0');
-- Halsey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('47rw7lhgzpqiqoi', 'Halsey', '70@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0fad315ccb6b38517152d2cc','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:70@artist.com', '47rw7lhgzpqiqoi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('47rw7lhgzpqiqoi', 'Igniting the stage with electrifying performances.', 'Halsey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3ctyuqsaz20bi82yovtivf6ez5sfru7039zdqphg6rrs1nseqe','47rw7lhgzpqiqoi', 'https://i.scdn.co/image/ab67616d0000b273f19310c007c0fad365b0542e', 'Lilith (feat. SUGA of BTS) (Diablo IV Anthem)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('14e54g31h5k3xr510wehk06cebq8rm7rrxoexy4unfdgrorw5g','Lilith (feat. SUGA of BTS) (Diablo IV Anthem)','47rw7lhgzpqiqoi','POP','3l6LBCOL9nPsSY29TUY2VE',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3ctyuqsaz20bi82yovtivf6ez5sfru7039zdqphg6rrs1nseqe', '14e54g31h5k3xr510wehk06cebq8rm7rrxoexy4unfdgrorw5g', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ahc8jaua3rgxo6drajycgqy3noa5iem7w613jm0nblwz757m6l','Boy With Luv (feat. Halsey)','47rw7lhgzpqiqoi','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3ctyuqsaz20bi82yovtivf6ez5sfru7039zdqphg6rrs1nseqe', 'ahc8jaua3rgxo6drajycgqy3noa5iem7w613jm0nblwz757m6l', '1');
-- Ayparia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fmz2wgdmis5eeq8', 'Ayparia', '71@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebff258a75f7364baaaf9ed011','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:71@artist.com', 'fmz2wgdmis5eeq8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fmz2wgdmis5eeq8', 'Delivering a unique blend of sounds, showcasing versatility and artistic depth.', 'Ayparia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rjaqa8eolo5k3gc8dp23t1taarhaixiwlu3g0stmi09ia0avqc','fmz2wgdmis5eeq8', NULL, 'Ayparia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9jv4z2dubzpmnejiwjzg0vbe6igh462ryfbbj1ccnpeg392ste','MONTAGEM - FR PUNK','fmz2wgdmis5eeq8','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rjaqa8eolo5k3gc8dp23t1taarhaixiwlu3g0stmi09ia0avqc', '9jv4z2dubzpmnejiwjzg0vbe6igh462ryfbbj1ccnpeg392ste', '0');
-- RAYE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3gqbw8lsyu28c6p', 'RAYE', '72@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6338990250f5d5a447650ba9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:72@artist.com', '3gqbw8lsyu28c6p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3gqbw8lsyu28c6p', 'Breathing new life into classic genres.', 'RAYE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1w48yf78rn3ka8ygo7t60el32gyg1xz05rgnm2j0y6mi3x5hsy','3gqbw8lsyu28c6p', 'https://i.scdn.co/image/ab67616d0000b27394e5237ce925531dbb38e75f', 'My 21st Century Blues','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3i0anx66gs5pfcxefspo2qkyq499hc3xzoqkz38smi12t2mabz','Escapism.','3gqbw8lsyu28c6p','POP','5mHdCZtVyb4DcJw8799hZp','https://p.scdn.co/mp3-preview/8a8fcaf9ddf050562048d1632ddc880c9ce7c972?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1w48yf78rn3ka8ygo7t60el32gyg1xz05rgnm2j0y6mi3x5hsy', '3i0anx66gs5pfcxefspo2qkyq499hc3xzoqkz38smi12t2mabz', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fwmrydsi4jj2aaj3v8exschbluu5trf7dgnw3wgrkmonf890t4','Escapism. - Sped Up','3gqbw8lsyu28c6p','POP','3XCpS4k8WqNnCpcDOSRRuz','https://p.scdn.co/mp3-preview/22be59e4d5da403513e02e90c27bc1d0965b5f1f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1w48yf78rn3ka8ygo7t60el32gyg1xz05rgnm2j0y6mi3x5hsy', 'fwmrydsi4jj2aaj3v8exschbluu5trf7dgnw3wgrkmonf890t4', '1');
-- Duki
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w90kur3e91sqgsu', 'Duki', '73@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdc25969093ccc4655316c9b9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:73@artist.com', 'w90kur3e91sqgsu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w90kur3e91sqgsu', 'A beacon of innovation in the world of sound.', 'Duki');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j3uq6skyt50z8klim5mazfh1guqebqkh4vwb2wtuy1xzhjvvsj','w90kur3e91sqgsu', NULL, 'Duki Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jekfbim0uqfxpjyydqp8lm0pfeq3vxg36z6w70d8r3rqqvgltl','Marisola - Remix','w90kur3e91sqgsu','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j3uq6skyt50z8klim5mazfh1guqebqkh4vwb2wtuy1xzhjvvsj', 'jekfbim0uqfxpjyydqp8lm0pfeq3vxg36z6w70d8r3rqqvgltl', '0');
-- One Direction
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mo04ggbk0x1qp7d', 'One Direction', '74@artist.com', 'https://i.scdn.co/image/5bb443424a1ad71603c43d67f5af1a04da6bb3c8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:74@artist.com', 'mo04ggbk0x1qp7d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mo04ggbk0x1qp7d', 'Igniting the stage with electrifying performances.', 'One Direction');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('iavds2da3e85sy53xo8o0bipz3m4sw3c8tz5qjetnklklalh1m','mo04ggbk0x1qp7d', 'https://i.scdn.co/image/ab67616d0000b273d304ba2d71de306812eebaf4', 'FOUR (Deluxe)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rcl77b0ud3p82x56nwpbebweyuoybdelc9ljeovd8j4dinh5lt','Night Changes','mo04ggbk0x1qp7d','POP','5O2P9iiztwhomNh8xkR9lJ','https://p.scdn.co/mp3-preview/359be833b46b250c696bbb64caa5dc91f2a38c6a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('iavds2da3e85sy53xo8o0bipz3m4sw3c8tz5qjetnklklalh1m', 'rcl77b0ud3p82x56nwpbebweyuoybdelc9ljeovd8j4dinh5lt', '0');
-- d4vd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ub77imvuesd6h11', 'd4vd', '75@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad447187a35f422307e88ad3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:75@artist.com', 'ub77imvuesd6h11', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ub77imvuesd6h11', 'A confluence of cultural beats and contemporary tunes.', 'd4vd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ryvvuj6ndju8rmou00g2jr4s5k2cjy308ypm3md8h0aiztqflt','ub77imvuesd6h11', 'https://i.scdn.co/image/ab67616d0000b27364fa1bda999f4fbd2b7c4bb7', 'Petals to Thorns','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5tlcwo2rxo40k9evviasllfw25923475l36ie547c4sv89xfyg','Here With Me','ub77imvuesd6h11','POP','5LrN7yUQAzvthd4QujgPFr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ryvvuj6ndju8rmou00g2jr4s5k2cjy308ypm3md8h0aiztqflt', '5tlcwo2rxo40k9evviasllfw25923475l36ie547c4sv89xfyg', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('js9y5020i7vxrrqogjd1z91xxzfl1jg84h03h02kpwksp9zpuc','Romantic Homicide','ub77imvuesd6h11','POP','1xK59OXxi2TAAAbmZK0kBL',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ryvvuj6ndju8rmou00g2jr4s5k2cjy308ypm3md8h0aiztqflt', 'js9y5020i7vxrrqogjd1z91xxzfl1jg84h03h02kpwksp9zpuc', '1');
-- RM
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('iw9qvrb6ghhrv2x', 'RM', '76@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3b8f6208d84e28f63841e43c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:76@artist.com', 'iw9qvrb6ghhrv2x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('iw9qvrb6ghhrv2x', 'Sculpting soundwaves into masterpieces of auditory art.', 'RM');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9xin13jy7hbrxb7h6ok9lhw21r2xvhc2fh4ete6a3qgpvhsblk','iw9qvrb6ghhrv2x', NULL, 'RM Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6dkx9v8378qswyeshdzk0r25yqkvska8rvxac872dch6w4v7bb','Dont ever say love me (feat. RM of BTS)','iw9qvrb6ghhrv2x','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9xin13jy7hbrxb7h6ok9lhw21r2xvhc2fh4ete6a3qgpvhsblk', '6dkx9v8378qswyeshdzk0r25yqkvska8rvxac872dch6w4v7bb', '0');
-- Z Neto & Crist
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sf11ltib2dkxtuh', 'Z Neto & Crist', '77@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1bb9201db3ff149830f0139a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:77@artist.com', 'sf11ltib2dkxtuh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sf11ltib2dkxtuh', 'Crafting a unique sonic identity in every track.', 'Z Neto & Crist');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('m5kdiea9wgw77mbryi8zi8x9mnn8rnip5wp0l537oe9ucr3l0l','sf11ltib2dkxtuh', 'https://i.scdn.co/image/ab67616d0000b27339833b5940945cf013e8406c', 'Escolhas, Vol. 2 (Ao Vivo)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bv5wi6lisowme9jybr33wpqng6ke1u9pah4a96rumq97ch2xos','Oi Balde - Ao Vivo','sf11ltib2dkxtuh','POP','4xAGuRRKOgoaZbMGdmTD3N','https://p.scdn.co/mp3-preview/a6318531e5f8243a9d1df067570b50210b2729cc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m5kdiea9wgw77mbryi8zi8x9mnn8rnip5wp0l537oe9ucr3l0l', 'bv5wi6lisowme9jybr33wpqng6ke1u9pah4a96rumq97ch2xos', '0');
-- Arctic Monkeys
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bjkzgkzw91k9qsy', 'Arctic Monkeys', '78@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:78@artist.com', 'bjkzgkzw91k9qsy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bjkzgkzw91k9qsy', 'Rock innovators, known for their sharp lyrics and compelling sound.', 'Arctic Monkeys');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6mxc88x6lmohsytxznydl3r4y81tpk2s06z2oyi7k0w2dt7ry0','bjkzgkzw91k9qsy', 'https://i.scdn.co/image/ab67616d0000b2734ae1c4c5c45aabe565499163', 'AM','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s1znquns0znjuqjprciq17vx285r4hf06rybwbehunmq7jcfr0','I Wanna Be Yours','bjkzgkzw91k9qsy','POP','5XeFesFbtLpXzIVDNQP22n','https://p.scdn.co/mp3-preview/07de30bde8363d9ff78b72339245c151f67af451?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6mxc88x6lmohsytxznydl3r4y81tpk2s06z2oyi7k0w2dt7ry0', 's1znquns0znjuqjprciq17vx285r4hf06rybwbehunmq7jcfr0', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gi15v9lmdfu5ra7njcgp2tdvetpafcd1io3nwf3719wlxkaskc','505','bjkzgkzw91k9qsy','POP','58ge6dfP91o9oXMzq3XkIS','https://p.scdn.co/mp3-preview/1b23606bada6aacb339535944c1fe505898195e1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6mxc88x6lmohsytxznydl3r4y81tpk2s06z2oyi7k0w2dt7ry0', 'gi15v9lmdfu5ra7njcgp2tdvetpafcd1io3nwf3719wlxkaskc', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vaw9bjss0fg722w80uxdrc21mecdu06d0lq7cykfg78z0xeeud','Do I Wanna Know?','bjkzgkzw91k9qsy','POP','5FVd6KXrgO9B3JPmC8OPst','https://p.scdn.co/mp3-preview/006bc465fe3d1c04dae93a050eca9d402a7322b8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6mxc88x6lmohsytxznydl3r4y81tpk2s06z2oyi7k0w2dt7ry0', 'vaw9bjss0fg722w80uxdrc21mecdu06d0lq7cykfg78z0xeeud', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('su25k8o11ce8pmf7gj2b5l7ta6wr41e3klncxje124o9qhkh9t','Whyd You Only Call Me When Youre High?','bjkzgkzw91k9qsy','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6mxc88x6lmohsytxznydl3r4y81tpk2s06z2oyi7k0w2dt7ry0', 'su25k8o11ce8pmf7gj2b5l7ta6wr41e3klncxje124o9qhkh9t', '3');
-- ThxSoMch
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k2s3br39g1sirb1', 'ThxSoMch', '79@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcce84671d294b0cefb8fe1c0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:79@artist.com', 'k2s3br39g1sirb1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k2s3br39g1sirb1', 'Music is my canvas, and notes are my paint.', 'ThxSoMch');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ts6wh5ay7jbb4jk53zf9uih54j3iph1s9yjcvanpky15ysfsre','k2s3br39g1sirb1', 'https://i.scdn.co/image/ab67616d0000b27360ddc59c8d590a37cf2348f3', 'SPIT IN MY FACE!','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6yubjx64r7234yodpjjpywq7tg979h51w9f7fz9el2q1yy49wh','SPIT IN MY FACE!','k2s3br39g1sirb1','POP','1N8TTK1Uoy7UvQNUazfUt5','https://p.scdn.co/mp3-preview/a4146e5dd430d70eda83e57506ba5ed402935200?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ts6wh5ay7jbb4jk53zf9uih54j3iph1s9yjcvanpky15ysfsre', '6yubjx64r7234yodpjjpywq7tg979h51w9f7fz9el2q1yy49wh', '0');
-- Beyonc
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yhaq0x5o7seoa2c', 'Beyonc', '80@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12e3f20d05a8d6cfde988715','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:80@artist.com', 'yhaq0x5o7seoa2c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yhaq0x5o7seoa2c', 'Igniting the stage with electrifying performances.', 'Beyonc');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1eq5tn2vwitiktuw0m206xl7ni7xvb8712a8b00vhp047vi2v6','yhaq0x5o7seoa2c', 'https://i.scdn.co/image/ab67616d0000b2730e58a0f8308c1ad403d105e7', 'RENAISSANCE','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gfecftrropyypp9pkjyjae5wlho7s1eq9ewxove01igsjm5p8y','CUFF IT','yhaq0x5o7seoa2c','POP','1xzi1Jcr7mEi9K2RfzLOqS','https://p.scdn.co/mp3-preview/1799de9ff42644af9773b6353358e54615696f19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1eq5tn2vwitiktuw0m206xl7ni7xvb8712a8b00vhp047vi2v6', 'gfecftrropyypp9pkjyjae5wlho7s1eq9ewxove01igsjm5p8y', '0');
-- Grupo Frontera
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z2hqbsbavc9m9e7', 'Grupo Frontera', '81@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f1a7e9f510bf0501e209c58','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:81@artist.com', 'z2hqbsbavc9m9e7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z2hqbsbavc9m9e7', 'A maestro of melodies, orchestrating auditory bliss.', 'Grupo Frontera');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kg6jl6y3wf1vx4yf8dkeseoqv8044r9o6v3ptwdd1j9k8yj50v','z2hqbsbavc9m9e7', 'https://i.scdn.co/image/ab67616d0000b27382ce4c7bbf861185252e82ae', 'El Comienzo','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3vumj6vr8xzsika50pozn8ca4hyyyfsqwxdjhvnru8fez1cl6e','No Se Va','z2hqbsbavc9m9e7','POP','76kelNDs1ojicx1s6Urvck','https://p.scdn.co/mp3-preview/1aa36481ad26b54ce635e7eb7d7360353c09d9ea?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kg6jl6y3wf1vx4yf8dkeseoqv8044r9o6v3ptwdd1j9k8yj50v', '3vumj6vr8xzsika50pozn8ca4hyyyfsqwxdjhvnru8fez1cl6e', '0');
-- Treyce
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('34u531d7xt9egho', 'Treyce', '82@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7b48fa6e2c8280e205c5ea7b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:82@artist.com', '34u531d7xt9egho', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('34u531d7xt9egho', 'Pioneering new paths in the musical landscape.', 'Treyce');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ega3gz5i1rmyzwakm6ux27v1p207ylomtbi88qy11qckcx0ri4','34u531d7xt9egho', NULL, 'Treyce Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lrahra5oicqu0fux3gsxeb99u71yag7st3pz1pcvwd7ymjz2sm','Lovezinho','34u531d7xt9egho','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ega3gz5i1rmyzwakm6ux27v1p207ylomtbi88qy11qckcx0ri4', 'lrahra5oicqu0fux3gsxeb99u71yag7st3pz1pcvwd7ymjz2sm', '0');
-- Chino Pacas
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7anutwwl4p3tp2r', 'Chino Pacas', '83@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8ff524b416384fe673ebf52e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:83@artist.com', '7anutwwl4p3tp2r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7anutwwl4p3tp2r', 'Striking chords that resonate across generations.', 'Chino Pacas');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ly144jdje9uxizy3hsi9o1mh4rkg3x3o5kf9amj6o8fzal7vsu','7anutwwl4p3tp2r', 'https://i.scdn.co/image/ab67616d0000b2736a6ab689151163a1e9f60f36', 'El Gordo Trae El Mando','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4u1ma8zswecmnno8nvjgtydjruibk2ac8slejm7zgvxa5opvrj','El Gordo Trae El Mando','7anutwwl4p3tp2r','POP','3kf0WdFOalKWBkCCLJo4mA','https://p.scdn.co/mp3-preview/b7989992ce6651eea980627ad17b1f9a2fa2a224?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ly144jdje9uxizy3hsi9o1mh4rkg3x3o5kf9amj6o8fzal7vsu', '4u1ma8zswecmnno8nvjgtydjruibk2ac8slejm7zgvxa5opvrj', '0');
-- Stephen Sanchez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3hmbka9hnsizt49', 'Stephen Sanchez', '84@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1e97fce6fa6fc4ebc3ebda25','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:84@artist.com', '3hmbka9hnsizt49', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3hmbka9hnsizt49', 'Igniting the stage with electrifying performances.', 'Stephen Sanchez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2em2cuzm3dw3d4vecyykpgvpqtizxsbbzvrkff12uvx01kc4zl','3hmbka9hnsizt49', 'https://i.scdn.co/image/ab67616d0000b2732bf0876d42b90a8852ad6244', 'Until I Found You (Em Beihold Version)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rfxs4keb44gsa6urriqs51o4ytvb5h3hq4gzo4cm4hehxznbhu','Until I Found You','3hmbka9hnsizt49','POP','1Y3LN4zO1Edc2EluIoSPJN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2em2cuzm3dw3d4vecyykpgvpqtizxsbbzvrkff12uvx01kc4zl', 'rfxs4keb44gsa6urriqs51o4ytvb5h3hq4gzo4cm4hehxznbhu', '0');
-- Glass Animals
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('i6chqkl83kpbt3v', 'Glass Animals', '85@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb66b27eccb69756f8eceabc23','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:85@artist.com', 'i6chqkl83kpbt3v', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('i6chqkl83kpbt3v', 'Crafting psychedelic pop with intricate melodies and immersive soundscapes.', 'Glass Animals');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7pmzg3mjn6khh1ooiygjkior3jvmoqr0k4s4psl8g9p0twe2cj','i6chqkl83kpbt3v', 'https://i.scdn.co/image/ab67616d0000b273712701c5e263efc8726b1464', 'Dreamland','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('72w1b86md4tu1fmsuy03jkjk1tgv46cke6z6wyw3887eppesuo','Heat Waves','i6chqkl83kpbt3v','POP','3USxtqRwSYz57Ewm6wWRMp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7pmzg3mjn6khh1ooiygjkior3jvmoqr0k4s4psl8g9p0twe2cj', '72w1b86md4tu1fmsuy03jkjk1tgv46cke6z6wyw3887eppesuo', '0');
-- Nile Rodgers
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4zlcwlan6slg8zt', 'Nile Rodgers', '86@artist.com', 'https://i.scdn.co/image/6511b1fe261da3b6c6b69ae2aa771cfd307a18ae','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:86@artist.com', '4zlcwlan6slg8zt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4zlcwlan6slg8zt', 'A unique voice in the contemporary music scene.', 'Nile Rodgers');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sa07z8j9shzn961d0d7tcw45hqtkj64tovzmtp6n4qwy5174mx','4zlcwlan6slg8zt', NULL, 'Nile Rodgers Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6t06ajldje5g38e0b4p6fyq6k6yxvhszvasibgfnkif5fliz16','UNFORGIVEN (feat. Nile Rodgers)','4zlcwlan6slg8zt','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sa07z8j9shzn961d0d7tcw45hqtkj64tovzmtp6n4qwy5174mx', '6t06ajldje5g38e0b4p6fyq6k6yxvhszvasibgfnkif5fliz16', '0');
-- Abhijay Sharma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('paox5cns6xqb50e', 'Abhijay Sharma', '87@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb27c847b083cba83db3b7574c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:87@artist.com', 'paox5cns6xqb50e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('paox5cns6xqb50e', 'Harnessing the power of melody to tell compelling stories.', 'Abhijay Sharma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('589bmze6f450yhh4w8zwrhckwznv3xw3r3wp8pra6qt2o7ud1z','paox5cns6xqb50e', NULL, 'Abhijay Sharma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mspt4lk8g96pz0kyqos9omkgp6ilox7kz2lgihcafglf2n8h25','Obsessed','paox5cns6xqb50e','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('589bmze6f450yhh4w8zwrhckwznv3xw3r3wp8pra6qt2o7ud1z', 'mspt4lk8g96pz0kyqos9omkgp6ilox7kz2lgihcafglf2n8h25', '0');
-- Coolio
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5k0jgcny7ohqs9s', 'Coolio', '88@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebff14146ae33324af5427131f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:88@artist.com', '5k0jgcny7ohqs9s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5k0jgcny7ohqs9s', 'Transcending language barriers through the universal language of music.', 'Coolio');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('546bdif52rfh3xnlrtg5bv5p9kf1pnxs5450z24p1zu6mxq4dh','5k0jgcny7ohqs9s', 'https://i.scdn.co/image/ab67616d0000b273c31d3c870a3dbaf7b53186cc', 'Gangstas Paradise','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5ccfvvppxdkd892rd7i1015v9pmbmozzzh143w1rllrkcwzdra','Gangstas Paradise','5k0jgcny7ohqs9s','POP','1DIXPcTDzTj8ZMHt3PDt8p','https://p.scdn.co/mp3-preview/1454c63a66c27ac745f874d6c113270a9c62d28e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('546bdif52rfh3xnlrtg5bv5p9kf1pnxs5450z24p1zu6mxq4dh', '5ccfvvppxdkd892rd7i1015v9pmbmozzzh143w1rllrkcwzdra', '0');
-- Miley Cyrus
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ydxwflfvcn7ngue', 'Miley Cyrus', '89@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5af3b38f053486ab0784dee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:89@artist.com', 'ydxwflfvcn7ngue', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ydxwflfvcn7ngue', 'Constantly evolving, from pop sensation to rock powerhouse.', 'Miley Cyrus');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('slh7mfii7xls97kndsmxn1aa6220ctxuqn6hkf3ggsaa5dwpdi','ydxwflfvcn7ngue', 'https://i.scdn.co/image/ab67616d0000b273cd222052a2594be29a6616b5', 'Endless Summer Vacation','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wpzsu0ehot8df3p99g4gknbd8uhr0d3s4dvu6gcqnecb2rosnk','Flowers','ydxwflfvcn7ngue','POP','7DSAEUvxU8FajXtRloy8M0','https://p.scdn.co/mp3-preview/5184d19d1b7fcc3e7c067e38af45a7cc80851440?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('slh7mfii7xls97kndsmxn1aa6220ctxuqn6hkf3ggsaa5dwpdi', 'wpzsu0ehot8df3p99g4gknbd8uhr0d3s4dvu6gcqnecb2rosnk', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('geezk4aae9vzdr37w2jmla8xqlkqsdfxcejonrv9539d5979gm','Angels Like You','ydxwflfvcn7ngue','POP','1daDRI9ahBonbWD8YcxOIB','https://p.scdn.co/mp3-preview/4db8314199c0d49e95c786792ecd06eadae9f510?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('slh7mfii7xls97kndsmxn1aa6220ctxuqn6hkf3ggsaa5dwpdi', 'geezk4aae9vzdr37w2jmla8xqlkqsdfxcejonrv9539d5979gm', '1');
-- Eminem
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('oxh17p65e61puhp', 'Eminem', '90@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba00b11c129b27a88fc72f36b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:90@artist.com', 'oxh17p65e61puhp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('oxh17p65e61puhp', 'An alchemist of harmonies, transforming notes into gold.', 'Eminem');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xbi62hl37w88aseubfetchcrr7vnqvscg7vu9ba28t3ho2g003','oxh17p65e61puhp', 'https://i.scdn.co/image/ab67616d0000b273726d48d93d02e1271774f023', 'Encore (Deluxe Version)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bwiymvc73hu33o28xfzyy7tyvi3m10aqsh175vjwspf52iwmzx','Mockingbird','oxh17p65e61puhp','POP','561jH07mF1jHuk7KlaeF0s',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xbi62hl37w88aseubfetchcrr7vnqvscg7vu9ba28t3ho2g003', 'bwiymvc73hu33o28xfzyy7tyvi3m10aqsh175vjwspf52iwmzx', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g8zp11in6y1tvtnaggvecdh95zjevc846etga8fhsjxmcij0z8','Without Me','oxh17p65e61puhp','POP','7lQ8MOhq6IN2w8EYcFNSUk',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xbi62hl37w88aseubfetchcrr7vnqvscg7vu9ba28t3ho2g003', 'g8zp11in6y1tvtnaggvecdh95zjevc846etga8fhsjxmcij0z8', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qxixmebiu4vyz7yxsz8dnhoq1h9kjwtjt1prm4jhtkw6e3sztl','The Real Slim Shady','oxh17p65e61puhp','POP','3yfqSUWxFvZELEM4PmlwIR',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xbi62hl37w88aseubfetchcrr7vnqvscg7vu9ba28t3ho2g003', 'qxixmebiu4vyz7yxsz8dnhoq1h9kjwtjt1prm4jhtkw6e3sztl', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3snxfly0v0r00wni7qfnfil67ooa8jurt6qxfxn598v3i5fkis','Lose Yourself - Soundtrack Version','oxh17p65e61puhp','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xbi62hl37w88aseubfetchcrr7vnqvscg7vu9ba28t3ho2g003', '3snxfly0v0r00wni7qfnfil67ooa8jurt6qxfxn598v3i5fkis', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iwoau2jsujnam96hyvnmef6q9ceinhi87zl1c2uohmjd8p6oiw','Superman','oxh17p65e61puhp','POP','4woTEX1wYOTGDqNXuavlRC',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xbi62hl37w88aseubfetchcrr7vnqvscg7vu9ba28t3ho2g003', 'iwoau2jsujnam96hyvnmef6q9ceinhi87zl1c2uohmjd8p6oiw', '4');
-- Lil Uzi Vert
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jyh07ozzfyfr8y6', 'Lil Uzi Vert', '91@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1234d2f516796badbdf16a89','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:91@artist.com', 'jyh07ozzfyfr8y6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jyh07ozzfyfr8y6', 'Delivering soul-stirring tunes that linger in the mind.', 'Lil Uzi Vert');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('apmyio2ba62f5cvv2k33fnpi2c4ksxywpihhkcvr2pqhpjp9e2','jyh07ozzfyfr8y6', 'https://i.scdn.co/image/ab67616d0000b273438799bc344744c12028bb0f', 'Just Wanna Rock','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kx6mkrh8rjs8i57nlza3bhar1aj3x1debpaob5pni3ta24q4u7','Just Wanna Rock','jyh07ozzfyfr8y6','POP','4FyesJzVpA39hbYvcseO2d','https://p.scdn.co/mp3-preview/72dce26448e87be36c3776ded36b75a9fd01359e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('apmyio2ba62f5cvv2k33fnpi2c4ksxywpihhkcvr2pqhpjp9e2', 'kx6mkrh8rjs8i57nlza3bhar1aj3x1debpaob5pni3ta24q4u7', '0');
-- Ruth B.
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ovqsdkpvykrlkg9', 'Ruth B.', '92@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1da7ba1c178ab9f68d065197','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:92@artist.com', 'ovqsdkpvykrlkg9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ovqsdkpvykrlkg9', 'A confluence of cultural beats and contemporary tunes.', 'Ruth B.');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tx8p5e6our9u8s1gz07lg9vohvu77s2iff2z1owjg0yh116lj5','ovqsdkpvykrlkg9', 'https://i.scdn.co/image/ab67616d0000b27397e971f3e53475091dc8d707', 'Safe Haven','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tm6uy30s8kcjye70ech5xkabkoh4asjs2y3rexu5aceqd64eya','Dandelions','ovqsdkpvykrlkg9','POP','2eAvDnpXP5W0cVtiI0PUxV','https://p.scdn.co/mp3-preview/3e55602bc286bc1fad9347931327e649ff9adfa1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tx8p5e6our9u8s1gz07lg9vohvu77s2iff2z1owjg0yh116lj5', 'tm6uy30s8kcjye70ech5xkabkoh4asjs2y3rexu5aceqd64eya', '0');
-- Jung Kook
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y8wzby6gur6z5f8', 'Jung Kook', '93@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:93@artist.com', 'y8wzby6gur6z5f8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y8wzby6gur6z5f8', 'A member of BTS, captivating fans with his powerful vocals and dynamic performances.', 'Jung Kook');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fa6ak0clueq2qp4is6p832hb6of7llxum4ndt4k3qveclttzbi','y8wzby6gur6z5f8', 'https://i.scdn.co/image/ab67616d0000b273a7f42c375578df426b37638d', 'Still With You','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sjn4s353fdccu72h985v1xuy1vrndhe49t9r7w74y4ychg3hyl','Still With You','y8wzby6gur6z5f8','POP','0eFMbKCRw8KByXyWBw8WO7','https://p.scdn.co/mp3-preview/af2a740e10a6956dedd7e7f66fd65d7166e9187f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fa6ak0clueq2qp4is6p832hb6of7llxum4ndt4k3qveclttzbi', 'sjn4s353fdccu72h985v1xuy1vrndhe49t9r7w74y4ychg3hyl', '0');
-- Lewis Capaldi
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jb9qsjqcxmtdssa', 'Lewis Capaldi', '94@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebea7538654040e553a7b0fc28','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:94@artist.com', 'jb9qsjqcxmtdssa', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jb9qsjqcxmtdssa', 'Delivering emotional ballads with his powerful, soul-stirring voice.', 'Lewis Capaldi');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xxmps8lw2b85q8wy9so3vrty0jn1nqenmn4urcw6le58vd3k2r','jb9qsjqcxmtdssa', 'https://i.scdn.co/image/ab67616d0000b273fc2101e6889d6ce9025f85f2', 'Divinely Uninspired To A Hellish Extent','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d5q9qdg9ypku6xud6rpwjytb535qzxs334ogi380dc1cnl1wqz','Someone You Loved','jb9qsjqcxmtdssa','POP','7qEHsqek33rTcFNT9PFqLf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xxmps8lw2b85q8wy9so3vrty0jn1nqenmn4urcw6le58vd3k2r', 'd5q9qdg9ypku6xud6rpwjytb535qzxs334ogi380dc1cnl1wqz', '0');
-- Zach Bryan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u2f6g8xqlam173r', 'Zach Bryan', '95@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4fd54df35bfcfa0fc9fc2da7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:95@artist.com', 'u2f6g8xqlam173r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u2f6g8xqlam173r', 'Breathing new life into classic genres.', 'Zach Bryan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('112a5lcvrbkk4fwb80hzz43hgyl70k41wu33y4631fu1zxx54q','u2f6g8xqlam173r', 'https://i.scdn.co/image/ab67616d0000b273b2b6670e3aca9bcd55fbabbb', 'Something in the Orange','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('58g1r1hh0s17zj3a8qj4rm7lpl60ddgmub8ic5t8vwvig21hrm','Something in the Orange','u2f6g8xqlam173r','POP','3WMj8moIAXJhHsyLaqIIHI','https://p.scdn.co/mp3-preview/d33dc9df586e24c9d8f640df08b776d94680f529?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('112a5lcvrbkk4fwb80hzz43hgyl70k41wu33y4631fu1zxx54q', '58g1r1hh0s17zj3a8qj4rm7lpl60ddgmub8ic5t8vwvig21hrm', '0');
-- Mc Pedrinho
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hv9w94lh8h4x2q5', 'Mc Pedrinho', '96@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd704ce4a93060fee76e59beb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:96@artist.com', 'hv9w94lh8h4x2q5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hv9w94lh8h4x2q5', 'Exploring the depths of sound and rhythm.', 'Mc Pedrinho');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7qis83q44zylwp3c6eiim2h3hf0vd9cdf043j3jjggw343dfh7','hv9w94lh8h4x2q5', 'https://i.scdn.co/image/ab67616d0000b27319d60821e80a801506061776', 'Gol Bolinha, Gol Quadrado 2','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8yeypude568menss46muanybxccacas08kse5go43hszj3y4tx','Gol Bolinha, Gol Quadrado 2','hv9w94lh8h4x2q5','POP','0U9CZWq6umZsN432nh3WWT','https://p.scdn.co/mp3-preview/385a48d0a130895b2b0ec2f731cc744207d0a745?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7qis83q44zylwp3c6eiim2h3hf0vd9cdf043j3jjggw343dfh7', '8yeypude568menss46muanybxccacas08kse5go43hszj3y4tx', '0');
-- King
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8b8wa5wihjrrjqq', 'King', '97@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5c0b2129a88c7d6ed0704556','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:97@artist.com', '8b8wa5wihjrrjqq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8b8wa5wihjrrjqq', 'Weaving lyrical magic into every song.', 'King');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7gj7p0uya2s04eipuutg4x6jhjbdcnzixig0q5w3enljkncixm','8b8wa5wihjrrjqq', 'https://i.scdn.co/image/ab67616d0000b27337f65266754703fd20d29854', 'Champagne Talk','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wsyfjcu3npqt62adfbuqch29wd54k6zouwe48nljowbe6h02mx','Maan Meri Jaan','8b8wa5wihjrrjqq','POP','1418IuVKQPTYqt7QNJ9RXN','https://p.scdn.co/mp3-preview/cf886ec5f6a46c234bcfdd043ab5db03db0015b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7gj7p0uya2s04eipuutg4x6jhjbdcnzixig0q5w3enljkncixm', 'wsyfjcu3npqt62adfbuqch29wd54k6zouwe48nljowbe6h02mx', '0');
-- Chencho Corleone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('llm029o3oqj1dr6', 'Chencho Corleone', '98@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2e862710857d2b3e1b5fb4f4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:98@artist.com', 'llm029o3oqj1dr6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('llm029o3oqj1dr6', 'A dynamic presence in reggaeton, known for his catchy beats and vibrant performances.', 'Chencho Corleone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7jpfezvdh93rp3vqeujg0fkjihthsywyycyh4jymcdmx3ha6it','llm029o3oqj1dr6', NULL, 'Chencho Corleone Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uuq2mixokanhpehcvw03f4np6heec34otn6gdu2vjipuzw5g76','Me Porto Bonito','llm029o3oqj1dr6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7jpfezvdh93rp3vqeujg0fkjihthsywyycyh4jymcdmx3ha6it', 'uuq2mixokanhpehcvw03f4np6heec34otn6gdu2vjipuzw5g76', '0');
-- Lost Frequencies
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7s4vetr945v1t8k', 'Lost Frequencies', '99@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a77aaa2cde6783b1ca727e9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:99@artist.com', '7s4vetr945v1t8k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7s4vetr945v1t8k', 'A unique voice in the contemporary music scene.', 'Lost Frequencies');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wr67fse9fav80mb51v06ncaukx9yks6di6pnszktk6gm0o2vmc','7s4vetr945v1t8k', 'https://i.scdn.co/image/ab67616d0000b2738d7a7f1855b04104ba59c18b', 'Where Are You Now','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xr6ul0zxp7ic6qmbrpkgwyqgwiwxb3xzaulqnv8h19j2q0mg94','Where Are You Now','7s4vetr945v1t8k','POP','3uUuGVFu1V7jTQL60S1r8z','https://p.scdn.co/mp3-preview/e2646d5bc8c56e4a91582a03c089f8038772aecb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wr67fse9fav80mb51v06ncaukx9yks6di6pnszktk6gm0o2vmc', 'xr6ul0zxp7ic6qmbrpkgwyqgwiwxb3xzaulqnv8h19j2q0mg94', '0');
-- Nengo Flow
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c9kndp78lt3731h', 'Nengo Flow', '100@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebda3f48cf2309aacaab0edce2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:100@artist.com', 'c9kndp78lt3731h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c9kndp78lt3731h', 'Pioneering new paths in the musical landscape.', 'Nengo Flow');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ya44lmf3jkrw33qmtgbd6b4se0wux0uboqbu5vda1a1pbi5zdd','c9kndp78lt3731h', 'https://i.scdn.co/image/ab67616d0000b273ed132404686f567c8f793058', 'Gato de Noche','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x5yg0s15fiy54w0ipx1eoevzbyzm6joe1mrph9tfyxw02qraun','Gato de Noche','c9kndp78lt3731h','POP','54ELExv56KCAB4UP9cOCzC','https://p.scdn.co/mp3-preview/7d6a9dab2f3779eef37ef52603d20607a1390d91?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ya44lmf3jkrw33qmtgbd6b4se0wux0uboqbu5vda1a1pbi5zdd', 'x5yg0s15fiy54w0ipx1eoevzbyzm6joe1mrph9tfyxw02qraun', '0');
-- Natanael Cano
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qczf56aj451htlg', 'Natanael Cano', '101@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0819edd43096a2f0dde7cd44','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:101@artist.com', 'qczf56aj451htlg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qczf56aj451htlg', 'Creating a tapestry of tunes that celebrates diversity.', 'Natanael Cano');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oxe4pxy6pu2j5jjhmj91fck8aooed5q79doxxm7umfcaeg091u','qczf56aj451htlg', 'https://i.scdn.co/image/ab67616d0000b273e2e093427065eaca9e2f2970', 'Nata Montana','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7husujkhprucpc1crvo46nkqk6s0f55l9mni6qky79jjt8i7jc','Mi Bello Angel','qczf56aj451htlg','POP','4t46soaqA758rbukTO5pp1','https://p.scdn.co/mp3-preview/07854d155311327027a073aeb36f0f61cdb07096?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oxe4pxy6pu2j5jjhmj91fck8aooed5q79doxxm7umfcaeg091u', '7husujkhprucpc1crvo46nkqk6s0f55l9mni6qky79jjt8i7jc', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('45sydhdsxkdkbalp3xdczwg1lpmnsieo3s5k1n54ab6kacw2j2','PRC','qczf56aj451htlg','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oxe4pxy6pu2j5jjhmj91fck8aooed5q79doxxm7umfcaeg091u', '45sydhdsxkdkbalp3xdczwg1lpmnsieo3s5k1n54ab6kacw2j2', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rzim8x8c5oekgpecgc0enc8n2kccb1j1d04loppoqf2ahze9tc','AMG','qczf56aj451htlg','POP','1lRtH4FszTrwwlK5gTSbXO','https://p.scdn.co/mp3-preview/2a54eb02ee2a7e8c47c6107f16272a19a0e6362b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oxe4pxy6pu2j5jjhmj91fck8aooed5q79doxxm7umfcaeg091u', 'rzim8x8c5oekgpecgc0enc8n2kccb1j1d04loppoqf2ahze9tc', '2');
-- The Kid Laroi
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f3clp673t9ghs05', 'The Kid Laroi', '102@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb393666951ab8b14e9c4ed386','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:102@artist.com', 'f3clp673t9ghs05', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('f3clp673t9ghs05', 'Transcending language barriers through the universal language of music.', 'The Kid Laroi');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rkbsb7v4coilbjn3rlahqybthk6215ziv029b8qv0rkzqb0dw6','f3clp673t9ghs05', 'https://i.scdn.co/image/ab67616d0000b273a53643fc03785efb9926443d', 'LOVE AGAIN','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7kfqj3lzua17qdrzno0abwfjj2e2zsotc8lvztgdfvlpm04c6z','Love Again','f3clp673t9ghs05','POP','4sx6NRwL6Ol3V6m9exwGlQ','https://p.scdn.co/mp3-preview/4baae2685eaac7401ae183c54642c9ddf3b9e057?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rkbsb7v4coilbjn3rlahqybthk6215ziv029b8qv0rkzqb0dw6', '7kfqj3lzua17qdrzno0abwfjj2e2zsotc8lvztgdfvlpm04c6z', '0');
-- Kodak Black
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2uoldeyaa21m4i1', 'Kodak Black', '103@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb70c05cf4dc9a7d3ffd02ba19','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:103@artist.com', '2uoldeyaa21m4i1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2uoldeyaa21m4i1', 'Sculpting soundwaves into masterpieces of auditory art.', 'Kodak Black');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('a6uhz0qrwahjp03mpwx1x4ubldnz6cs6lc7mnnsadupmb8b3zb','2uoldeyaa21m4i1', 'https://i.scdn.co/image/ab67616d0000b273445afb6341d2685b959251cc', 'Angel Pt. 1 (feat. Jimin of BTS, JVKE & Muni Long) [Trailer Version]','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gl72tkvv1vxut80c520l9ge953lt101ouhpr9ain0ewpu7hzr1','Angel Pt 1 (feat. Jimin of BTS, JVKE & Muni Long)','2uoldeyaa21m4i1','POP','1vvcEHQdaUTvWt0EIUYcFK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a6uhz0qrwahjp03mpwx1x4ubldnz6cs6lc7mnnsadupmb8b3zb', 'gl72tkvv1vxut80c520l9ge953lt101ouhpr9ain0ewpu7hzr1', '0');
-- James Arthur
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s0nxe14rvizjydh', 'James Arthur', '104@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2a0c6d0343c82be9dd6fce0b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:104@artist.com', 's0nxe14rvizjydh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s0nxe14rvizjydh', 'An odyssey of sound that defies conventions.', 'James Arthur');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hkf6w7wa6nfiui358921466z3gmemi8rpb8mqxa70dunzjka90','s0nxe14rvizjydh', 'https://i.scdn.co/image/ab67616d0000b273dc16d839ab77c64bdbeb3660', 'YOU','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vmhxijb85ijgf530o72gtm6kr8x1udit7vlp8ap4sl9u8yisld','Cars Outside','s0nxe14rvizjydh','POP','0otRX6Z89qKkHkQ9OqJpKt','https://p.scdn.co/mp3-preview/cfaa30729da8d2d8965fae154b6e9d0964a2ea6b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hkf6w7wa6nfiui358921466z3gmemi8rpb8mqxa70dunzjka90', 'vmhxijb85ijgf530o72gtm6kr8x1udit7vlp8ap4sl9u8yisld', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zlk8wbc902s7nd8sdrmv4384shg2rnjlrcmspstkbf9swwmbgc','Say You Wont Let Go','s0nxe14rvizjydh','POP','5uCax9HTNlzGybIStD3vDh','https://p.scdn.co/mp3-preview/2eed95a3c08cd10669768ce60d1140f85ba8b951?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hkf6w7wa6nfiui358921466z3gmemi8rpb8mqxa70dunzjka90', 'zlk8wbc902s7nd8sdrmv4384shg2rnjlrcmspstkbf9swwmbgc', '1');
-- Myke Towers
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ydahcc5zrg6covv', 'Myke Towers', '105@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9e35c3c5de877f99a8f6192f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:105@artist.com', 'ydahcc5zrg6covv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ydahcc5zrg6covv', 'A rising star in Latin music, known for his distinctive flow.', 'Myke Towers');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1shxmim2fxwjgh31dlcawj7qclsehskvtb4j9ls9qzau47en59','ydahcc5zrg6covv', 'https://i.scdn.co/image/ab67616d0000b2730656d5ce813ca3cc4b677e05', 'LA VIDA ES UNA','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('87q0i2qogwtn6ji6vou9lchw8p0l4dcyxbvfvgi5vexmo4nate','LALA','ydahcc5zrg6covv','POP','7ABLbnD53cQK00mhcaOUVG','https://p.scdn.co/mp3-preview/42772b16b4e575d1b15b0ec7f94e335539390d2d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1shxmim2fxwjgh31dlcawj7qclsehskvtb4j9ls9qzau47en59', '87q0i2qogwtn6ji6vou9lchw8p0l4dcyxbvfvgi5vexmo4nate', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qbae8skw0191pu0dcnekcl6oarunc8jrxweaayhlug87aha4xe','PLAYA DEL INGL','ydahcc5zrg6covv','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1shxmim2fxwjgh31dlcawj7qclsehskvtb4j9ls9qzau47en59', 'qbae8skw0191pu0dcnekcl6oarunc8jrxweaayhlug87aha4xe', '1');
-- Carin Leon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c6c8rng0icewfnh', 'Carin Leon', '106@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb7cc22fee89df015c6ba2636','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:106@artist.com', 'c6c8rng0icewfnh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c6c8rng0icewfnh', 'A journey through the spectrum of sound in every album.', 'Carin Leon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6jyjnfs0ky6awybmqzoajhgd6zpai3c2avyleg0dhplghkujh4','c6c8rng0icewfnh', 'https://i.scdn.co/image/ab67616d0000b273dc0bb68a08c069cf8467f1bd', 'Primera Cita','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hgi3nqz029egm2t6ihtcrefwvrhb2kbt2h15dz15z7zi9d0q5f','Primera Cita','c6c8rng0icewfnh','POP','4mGrWfDISjNjgeQnH1B8IE','https://p.scdn.co/mp3-preview/7eea768397c9ad0989a55f26f4cffbe6f334874a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6jyjnfs0ky6awybmqzoajhgd6zpai3c2avyleg0dhplghkujh4', 'hgi3nqz029egm2t6ihtcrefwvrhb2kbt2h15dz15z7zi9d0q5f', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hwrb2l4hugtujzry2ezvzbltn5djd7c5mu36kjxtv40adr1gfq','Que Vuelvas','c6c8rng0icewfnh','POP','6Um358vY92UBv5DloTRX9L','https://p.scdn.co/mp3-preview/19a1e58ae965c24e3ca4d0637857456887e31cd1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6jyjnfs0ky6awybmqzoajhgd6zpai3c2avyleg0dhplghkujh4', 'hwrb2l4hugtujzry2ezvzbltn5djd7c5mu36kjxtv40adr1gfq', '1');
-- Ozuna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vgg37nda0n16ee2', 'Ozuna', '107@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc80f303b208a480f52e8180b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:107@artist.com', 'vgg37nda0n16ee2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vgg37nda0n16ee2', 'Dominating reggaeton and Latin trap with catchy tunes and charismatic energy.', 'Ozuna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ojxa42zmtlddjruqil74el8l25e2z2crruawhxnawxg8q463t9','vgg37nda0n16ee2', 'https://i.scdn.co/image/ab67616d0000b273125624f2e04f5a1ccb0dfb45', 'OzuTochi','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9xlfl2pnreza9hz7nx6b1r8vgxx9agdoa7bq3464kufkbpisy6','Hey Mor','vgg37nda0n16ee2','POP','1zsPaEkglFvxjAhrM8yhpr','https://p.scdn.co/mp3-preview/cd2d2242b748408da15c2b66f47d54b3f0793ae0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ojxa42zmtlddjruqil74el8l25e2z2crruawhxnawxg8q463t9', '9xlfl2pnreza9hz7nx6b1r8vgxx9agdoa7bq3464kufkbpisy6', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1wht1txb94hg21oaphdqzfliqse1w98tei3r3cxrnxkxx6wm7x','Monoton','vgg37nda0n16ee2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ojxa42zmtlddjruqil74el8l25e2z2crruawhxnawxg8q463t9', '1wht1txb94hg21oaphdqzfliqse1w98tei3r3cxrnxkxx6wm7x', '1');
-- Rich The Kid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4i3iinv1jv9yyh2', 'Rich The Kid', '108@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb10379ac1a13fa06e703bf421','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:108@artist.com', '4i3iinv1jv9yyh2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4i3iinv1jv9yyh2', 'Crafting soundscapes that transport listeners to another world.', 'Rich The Kid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('a1bm2yytbqdqosdgrqxoi4rj3jh8imcwh77bry5briqhmhplxu','4i3iinv1jv9yyh2', NULL, 'Rich The Kid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7w5ovhhj3alwg0fnwjtfokeeqaavgnv8dwzby8cxb6gnqdfxkm','Conexes de Mfia (feat. Rich ','4i3iinv1jv9yyh2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a1bm2yytbqdqosdgrqxoi4rj3jh8imcwh77bry5briqhmhplxu', '7w5ovhhj3alwg0fnwjtfokeeqaavgnv8dwzby8cxb6gnqdfxkm', '0');
-- Taylor Swift
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('brsq0n2fh91x3su', 'Taylor Swift', '109@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb859e4c14fa59296c8649e0e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:109@artist.com', 'brsq0n2fh91x3su', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('brsq0n2fh91x3su', 'A storytelling icon, weaving life experiences into musical masterpieces.', 'Taylor Swift');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3','brsq0n2fh91x3su', 'https://i.scdn.co/image/ab67616d0000b273e787cffec20aa2a396a61647', 'Lover','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u3ex3bu45ycgt5q8p2pz90sddl7fpvb5azaik2lqcblvw9l0ey','Cruel Summer','brsq0n2fh91x3su','POP','1BxfuPKGuaTgP7aM0Bbdwr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', 'u3ex3bu45ycgt5q8p2pz90sddl7fpvb5azaik2lqcblvw9l0ey', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cqfp7zk9xqhfwt18pb34x9o2at2bk1on2xb1z6i5fq4kxa16jc','I Can See You (Taylors Version) (From The ','brsq0n2fh91x3su','POP','5kHMfzgLZP95O9NBy0ku4v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', 'cqfp7zk9xqhfwt18pb34x9o2at2bk1on2xb1z6i5fq4kxa16jc', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jvuh4gykdyx3n0tew3flit5xlipbdi1phql1mjhrc9ciaj5xjl','Anti-Hero','brsq0n2fh91x3su','POP','0V3wPSX9ygBnCm8psDIegu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', 'jvuh4gykdyx3n0tew3flit5xlipbdi1phql1mjhrc9ciaj5xjl', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qylow840ypassr6c1614hgpffg8be4ljtknrmz46cs1uv48u5x','Blank Space','brsq0n2fh91x3su','POP','1p80LdxRV74UKvL8gnD7ky',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', 'qylow840ypassr6c1614hgpffg8be4ljtknrmz46cs1uv48u5x', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('al9pkmiygg2o1r4cap22db78ht9krbu74do88pyo067nebvyab','Style','brsq0n2fh91x3su','POP','1hjRhYpWyqDpPahmSlUTlc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', 'al9pkmiygg2o1r4cap22db78ht9krbu74do88pyo067nebvyab', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2wq77wieb4nko1s45dv89o2cqryc46wd4mksaridvp9npic3cy','cardigan','brsq0n2fh91x3su','POP','4R2kfaDFhslZEMJqAFNpdd',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', '2wq77wieb4nko1s45dv89o2cqryc46wd4mksaridvp9npic3cy', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3uyf6rkfhnuwzf5mdfjh7ctxkfxdzcii1v2wjs9dzyzbjvlx3o','Karma','brsq0n2fh91x3su','POP','7KokYm8cMIXCsGVmUvKtqf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', '3uyf6rkfhnuwzf5mdfjh7ctxkfxdzcii1v2wjs9dzyzbjvlx3o', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('brx740os7ziddpn14o3hxz4x182myznrzp1axbjw7pum248g0m','Enchanted (Taylors Version)','brsq0n2fh91x3su','POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', 'brx740os7ziddpn14o3hxz4x182myznrzp1axbjw7pum248g0m', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a7zrkuhvtan30scu5sek8ivub9lpwy52h2b074he3gwinjawy3','Back To December (Taylors Version)','brsq0n2fh91x3su','POP','79uDOz0zuuWS7HWxzMmTa2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', 'a7zrkuhvtan30scu5sek8ivub9lpwy52h2b074he3gwinjawy3', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v2o5z7u40y3es9m3or9vetgkculgiwyqqytwh7fz336wlorn4j','Dont Bl','brsq0n2fh91x3su','POP','59ZmeIz57cGU5Gp9omjlYB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', 'v2o5z7u40y3es9m3or9vetgkculgiwyqqytwh7fz336wlorn4j', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ty2x94i646d3ktwzs3h2nj5jv2uxxdtcx7au4iw9gm0ge2lwne','Mine (Taylors Version)','brsq0n2fh91x3su','POP','7G0gBu6nLdhFDPRLc0HdDG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', 'ty2x94i646d3ktwzs3h2nj5jv2uxxdtcx7au4iw9gm0ge2lwne', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2720wsw2t58frrsd1w36xn5iqddgkvnq2ruhn32gi7p5crbvif','august','brsq0n2fh91x3su','POP','3hUxzQpSfdDqwM3ZTFQY0K',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', '2720wsw2t58frrsd1w36xn5iqddgkvnq2ruhn32gi7p5crbvif', '11');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e0ee4ddtj0xa40h3fxrrkem1o7dj4c93j45a3va0qs76aogvkc','Enchanted','brsq0n2fh91x3su','POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', 'e0ee4ddtj0xa40h3fxrrkem1o7dj4c93j45a3va0qs76aogvkc', '12');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('96susgyradd3nxvksj5ggkthq9o7y94a4rhybmv97sfg4t2rq4','Shake It Off','brsq0n2fh91x3su','POP','3pv7Q5v2dpdefwdWIvE7yH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', '96susgyradd3nxvksj5ggkthq9o7y94a4rhybmv97sfg4t2rq4', '13');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0rovztu72c1w4qa4118udrpw90lr33i11vxelvboqiktsaaaml','You Belong With Me (Taylors Ve','brsq0n2fh91x3su','POP','1qrpoAMXodY6895hGKoUpA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', '0rovztu72c1w4qa4118udrpw90lr33i11vxelvboqiktsaaaml', '14');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d11u0o6p75seqhe3jc6jr413l6j0ot224oiyewxcw97b90ok83','Better Than Revenge (Taylors Version)','brsq0n2fh91x3su','POP','0NwGC0v03ysCYINtg6ns58',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', 'd11u0o6p75seqhe3jc6jr413l6j0ot224oiyewxcw97b90ok83', '15');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7skhw48gtepy6qlbc7sjmveb7310zg8y9d5qsx9yva4rgmytqk','Hits Different','brsq0n2fh91x3su','POP','3xYJScVfxByb61dYHTwiby',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', '7skhw48gtepy6qlbc7sjmveb7310zg8y9d5qsx9yva4rgmytqk', '16');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('05lr6b9s9jauocinozp40qki2me9143396oj2sbwcdh22m9i9y','Karma (feat. Ice Spice)','brsq0n2fh91x3su','POP','4i6cwNY6oIUU2XZxPIw82Y',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', '05lr6b9s9jauocinozp40qki2me9143396oj2sbwcdh22m9i9y', '17');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xra9tg2sn3gunazpkqu15b4nzpqe15lwdf1kziqqkajy3k34zd','Lavender Haze','brsq0n2fh91x3su','POP','5jQI2r1RdgtuT8S3iG8zFC',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', 'xra9tg2sn3gunazpkqu15b4nzpqe15lwdf1kziqqkajy3k34zd', '18');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('isw2wopevmvh7wsiw7j4et845wx5ao372p8xzu7qyur5np2rkq','All Of The Girls You Loved Before','brsq0n2fh91x3su','POP','4P9Q0GojKVXpRTJCaL3kyy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', 'isw2wopevmvh7wsiw7j4et845wx5ao372p8xzu7qyur5np2rkq', '19');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9y5yqkm47e0jc8bosf317287y5s4pun429xakdhljt84jj43ap','Midnight Rain','brsq0n2fh91x3su','POP','3rWDp9tBPQR9z6U5YyRSK4',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', '9y5yqkm47e0jc8bosf317287y5s4pun429xakdhljt84jj43ap', '20');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('31nz28gkfp1j5evaqka1u9vxxbqzsip8g6q5yfv9l3w364rrlj','Youre On Your Own, Kid','brsq0n2fh91x3su','POP','1yMjWvw0LRwW5EZBPh9UyF','https://p.scdn.co/mp3-preview/cb8981007d0606f43b3051b3633f890d0a70de8c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mrtspu9gxwobrmaeh9086d2lcpgi4le7g0dwzf1xdv1r0tc8z3', '31nz28gkfp1j5evaqka1u9vxxbqzsip8g6q5yfv9l3w364rrlj', '21');
-- Latto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2cwabq1fhmic2gf', 'Latto', '110@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb149677e9b0d9ef7b229499d9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:110@artist.com', '2cwabq1fhmic2gf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2cwabq1fhmic2gf', 'A bold and dynamic rapper, making waves with her fiery lyrics.', 'Latto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('k5cscuqiv6tins83pcccnc6qrzpok9boeittirznbq2k815948','2cwabq1fhmic2gf', NULL, 'Latto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6vqcnmezizz8u1lojkjku5dp3xm5c6ajj7snftur8k730h9e2t','Seven (feat. Latto) (Explicit Ver.)','2cwabq1fhmic2gf','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k5cscuqiv6tins83pcccnc6qrzpok9boeittirznbq2k815948', '6vqcnmezizz8u1lojkjku5dp3xm5c6ajj7snftur8k730h9e2t', '0');
-- SEVENTEEN
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8te972pqob3own2', 'SEVENTEEN', '111@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb61916bb9f5c6a1a9ba1c9ab6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:111@artist.com', '8te972pqob3own2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8te972pqob3own2', 'Music is my canvas, and notes are my paint.', 'SEVENTEEN');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pkvtofp7rcojo6s3adnukxv1iwa5e35p96lwmfolzt7o64r2mg','8te972pqob3own2', 'https://i.scdn.co/image/ab67616d0000b27380e31ba0c05187e6310ef264', 'SEVENTEEN 10th Mini Album FML','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x4hnsgvl7yg39mq9kf38ay8tscrlsvugu9rlcu06eyf8sgm8ai','Super','8te972pqob3own2','POP','3AOf6YEpxQ894FmrwI9k96','https://p.scdn.co/mp3-preview/1dd31996959e603934dbe4c7d3ee377243a0f890?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pkvtofp7rcojo6s3adnukxv1iwa5e35p96lwmfolzt7o64r2mg', 'x4hnsgvl7yg39mq9kf38ay8tscrlsvugu9rlcu06eyf8sgm8ai', '0');
-- Fifty Fifty
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ijhhj8477nhp18a', 'Fifty Fifty', '112@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5a60b0f886b5deb8518e4a41','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:112@artist.com', 'ijhhj8477nhp18a', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ijhhj8477nhp18a', 'Blending a rich array of genres to create a unique musical experience.', 'Fifty Fifty');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qwhw2929dojig3h3kwmwi5j47zk8kwyqucki5e8lq7hg7g67oj','ijhhj8477nhp18a', 'https://i.scdn.co/image/ab67616d0000b27337c0b3670236c067c8e8bbcb', 'The Beginning: Cupid','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p4hdkcv4eaz9n99bs1o0xkzgktx9vcjynyxondppja0h7mw46s','Cupid - Twin Ver.','ijhhj8477nhp18a','POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qwhw2929dojig3h3kwmwi5j47zk8kwyqucki5e8lq7hg7g67oj', 'p4hdkcv4eaz9n99bs1o0xkzgktx9vcjynyxondppja0h7mw46s', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aa4ttw9i9udos8hew0nr3se48bvudqxq7je43nos6t8a2cl16i','Cupid','ijhhj8477nhp18a','POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qwhw2929dojig3h3kwmwi5j47zk8kwyqucki5e8lq7hg7g67oj', 'aa4ttw9i9udos8hew0nr3se48bvudqxq7je43nos6t8a2cl16i', '1');
-- David Kushner
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wrvagso01uewpf1', 'David Kushner', '113@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12fd1bd22516e35ef8c2e591','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:113@artist.com', 'wrvagso01uewpf1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wrvagso01uewpf1', 'A rising talent, creating music that resonates with a generation.', 'David Kushner');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('inst1dki88gwpo41sulxqsyz1njfxr4yclfdzsk3g7cdqk0m5p','wrvagso01uewpf1', 'https://i.scdn.co/image/ab67616d0000b27395ca6a9b4083a86c149934ae', 'Daylight','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6vrxah50xakfknq12txvkngjzwxcfn43skohx6re8lays3i2jr','Daylight','wrvagso01uewpf1','POP','1odExI7RdWc4BT515LTAwj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('inst1dki88gwpo41sulxqsyz1njfxr4yclfdzsk3g7cdqk0m5p', '6vrxah50xakfknq12txvkngjzwxcfn43skohx6re8lays3i2jr', '0');
-- Yuridia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wn97l8yxy559t0s', 'Yuridia', '114@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb238b537cb702308e59f709bf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:114@artist.com', 'wn97l8yxy559t0s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wn97l8yxy559t0s', 'Uniting fans around the globe with universal rhythms.', 'Yuridia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u0zwez0k4pi4p07gimme1p6ay94ibdyjojmtwns1kvhpuxso5x','wn97l8yxy559t0s', 'https://i.scdn.co/image/ab67616d0000b2732e9425d8413217cc2942cacf', 'Pa Luego Es Tarde','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ud16ebokqjgzu7ezjwakdef05on2ksjfrexzewex1he9jasx6o','Qu Ago','wn97l8yxy559t0s','POP','4H6o1bxKRGzmsE0vzo968m','https://p.scdn.co/mp3-preview/5576fde4795672bfa292bbf58adf0f9159af0be3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u0zwez0k4pi4p07gimme1p6ay94ibdyjojmtwns1kvhpuxso5x', 'ud16ebokqjgzu7ezjwakdef05on2ksjfrexzewex1he9jasx6o', '0');
-- Charlie Puth
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tjbqh497jl9ne8b', 'Charlie Puth', '115@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:115@artist.com', 'tjbqh497jl9ne8b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tjbqh497jl9ne8b', 'A pop maestro, combining catchy melodies with his exceptional musical talent.', 'Charlie Puth');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('61nm094wqj4akorle5zz545tl6wq8ue7ypfyg7h6q359npoazn','tjbqh497jl9ne8b', 'https://i.scdn.co/image/ab67616d0000b27335d2e0ed94a934f2cc46fa49', 'CHARLIE','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('afzbqq93426zxaboijngq22ao04eksf5m7hvduu1ws33zg37gl','Left and Right (Feat. Jung Kook of BTS)','tjbqh497jl9ne8b','POP','5Odq8ohlgIbQKMZivbWkEo','https://p.scdn.co/mp3-preview/9e4342eefa4f33df4e9b199e60dbce0f59e46eff?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('61nm094wqj4akorle5zz545tl6wq8ue7ypfyg7h6q359npoazn', 'afzbqq93426zxaboijngq22ao04eksf5m7hvduu1ws33zg37gl', '0');
-- Eslabon Armado
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lm389ae2tweya2d', 'Eslabon Armado', '116@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb114fc6846b9f0e0746baa6a7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:116@artist.com', 'lm389ae2tweya2d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lm389ae2tweya2d', 'Bringing a fresh take to traditional music, weaving in modern influences.', 'Eslabon Armado');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0kz1ojqtr8su3kjm37jb3d9yv7hwtbgj6io6px4yma3qsdp76u','lm389ae2tweya2d', 'https://i.scdn.co/image/ab67616d0000b2732071a0c79802d9375a53bfef', 'Ella Baila Sola','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('apvta40utwhgjoxkui10wrdwd98yy9lwufp94wsd7hvufplfz1','Ella Baila Sola','lm389ae2tweya2d','POP','3dnP0JxCgygwQH9Gm7q7nb','https://p.scdn.co/mp3-preview/5d39f3e17f1e20e2711d033001e48b8d4249b992?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0kz1ojqtr8su3kjm37jb3d9yv7hwtbgj6io6px4yma3qsdp76u', 'apvta40utwhgjoxkui10wrdwd98yy9lwufp94wsd7hvufplfz1', '0');
-- Karol G
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fd784tj5z9cma5r', 'Karol G', '117@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeb97a2403d7b9a631ce0f59c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:117@artist.com', 'fd784tj5z9cma5r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fd784tj5z9cma5r', 'A queen of reggaeton, known for her empowering anthems and vibrant performances.', 'Karol G');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xu4xukehcre5sj7bnnzsxxsxlsppew73va6rw79bn9subvy1gp','fd784tj5z9cma5r', 'https://i.scdn.co/image/ab67616d0000b27382de1ca074ae63cb18fce335', 'MAÑANA SERÁ BONITO','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('piykahgehe4orle0hepopbtzwg30e1ue3rvjqnqc021jg5dcss','TQG','fd784tj5z9cma5r','POP','0DWdj2oZMBFSzRsi2Cvfzf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xu4xukehcre5sj7bnnzsxxsxlsppew73va6rw79bn9subvy1gp', 'piykahgehe4orle0hepopbtzwg30e1ue3rvjqnqc021jg5dcss', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q7q37dk3s7eod10v57t3vbgci2uiqt1ccayxi8oxpd7eunp7sc','AMARGURA','fd784tj5z9cma5r','POP','505v13epFXodT9fVAJ6h8k',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xu4xukehcre5sj7bnnzsxxsxlsppew73va6rw79bn9subvy1gp', 'q7q37dk3s7eod10v57t3vbgci2uiqt1ccayxi8oxpd7eunp7sc', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ix5j3h0vwkgmgim0spvbdcks4r73xyfreq24qp2kpopceuf5bn','S91','fd784tj5z9cma5r','POP','7EpOXgSRgnglRWr86pZfGU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xu4xukehcre5sj7bnnzsxxsxlsppew73va6rw79bn9subvy1gp', 'ix5j3h0vwkgmgim0spvbdcks4r73xyfreq24qp2kpopceuf5bn', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mw1oo7ftxi9knt0zjns4js59m7lkol7i9nd7etnrzw3if7ikv9','MIENTRAS ME CURO DEL CORA','fd784tj5z9cma5r','POP','6otePxalBK8AVa20xhZYVQ',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xu4xukehcre5sj7bnnzsxxsxlsppew73va6rw79bn9subvy1gp', 'mw1oo7ftxi9knt0zjns4js59m7lkol7i9nd7etnrzw3if7ikv9', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h1tq45d7retobhrgr9krvgv31gwp9pfppuw6d94pb97ai331l8','X SI VOLVEMOS','fd784tj5z9cma5r','POP','4NoOME4Dhf4xgxbHDT7VGe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xu4xukehcre5sj7bnnzsxxsxlsppew73va6rw79bn9subvy1gp', 'h1tq45d7retobhrgr9krvgv31gwp9pfppuw6d94pb97ai331l8', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6mv2uhpkwkgszskmkkpx1cva7r8w7me06ahzf9f9fybqx4wrmg','PROVENZA','fd784tj5z9cma5r','POP','3HqcNJdZ2seoGxhn0wVNDK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xu4xukehcre5sj7bnnzsxxsxlsppew73va6rw79bn9subvy1gp', '6mv2uhpkwkgszskmkkpx1cva7r8w7me06ahzf9f9fybqx4wrmg', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i7qzormljtlcsdh7p9tgo51xzhakrz1yg7pq3zj8bqg867uexe','CAIRO','fd784tj5z9cma5r','POP','16dUQ4quIHDe4ZZ0wF1EMN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xu4xukehcre5sj7bnnzsxxsxlsppew73va6rw79bn9subvy1gp', 'i7qzormljtlcsdh7p9tgo51xzhakrz1yg7pq3zj8bqg867uexe', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qvrqrmlaurlmm4o22nrldu3ignzydyr5uurup2lx0wxksit3xh','PERO T','fd784tj5z9cma5r','POP','1dw7qShk971xMD6r6mA4VN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xu4xukehcre5sj7bnnzsxxsxlsppew73va6rw79bn9subvy1gp', 'qvrqrmlaurlmm4o22nrldu3ignzydyr5uurup2lx0wxksit3xh', '7');
-- Sabrina Carpenter
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('t1r7kk2akv386fd', 'Sabrina Carpenter', '118@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb00e540b760b56d02cc415c47','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:118@artist.com', 't1r7kk2akv386fd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('t1r7kk2akv386fd', 'Pioneering new paths in the musical landscape.', 'Sabrina Carpenter');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zrb1h9cfgo7g1xd7xpp2tjlr6pi6hdkafknot85spx27br9pj6','t1r7kk2akv386fd', 'https://i.scdn.co/image/ab67616d0000b273700f7bf79c9f063ad0362bdf', 'emails i cant send','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lygarft6wgpi3gybxs80bd5a6sj5741awlrpwkytqwcl2ocv7j','Nonsense','t1r7kk2akv386fd','POP','6dgUya35uo964z7GZXM07g',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zrb1h9cfgo7g1xd7xpp2tjlr6pi6hdkafknot85spx27br9pj6', 'lygarft6wgpi3gybxs80bd5a6sj5741awlrpwkytqwcl2ocv7j', '0');
-- Don Omar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f89exyfyxbx5420', 'Don Omar', '119@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:119@artist.com', 'f89exyfyxbx5420', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('f89exyfyxbx5420', 'Breathing new life into classic genres.', 'Don Omar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8wd14v2beby6vnomtgvqi9uut70x62au006r7rwpkqgurn68cu','f89exyfyxbx5420', 'https://i.scdn.co/image/ab67616d0000b2734640a26eb27649006be29a94', 'Meet The Orphans','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tdxpj9wy4nvj6zcarnnrokl2mwklr6qo9vh2f53qo1mmbp8isz','Danza Kuduro','f89exyfyxbx5420','POP','2a1o6ZejUi8U3wzzOtCOYw',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8wd14v2beby6vnomtgvqi9uut70x62au006r7rwpkqgurn68cu', 'tdxpj9wy4nvj6zcarnnrokl2mwklr6qo9vh2f53qo1mmbp8isz', '0');
-- Lizzo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('anks90h2ssvklxi', 'Lizzo', '120@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0d66b3670294bf801847dae2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:120@artist.com', 'anks90h2ssvklxi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('anks90h2ssvklxi', 'The architect of aural landscapes that inspire and captivate.', 'Lizzo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qiqmrrgnbz92pt06zq15drdlja6tunjbs2obthnq8uxy8jxbx6','anks90h2ssvklxi', 'https://i.scdn.co/image/ab67616d0000b273b817e721691aff3d67f26c04', 'About Damn Time','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hghxi3lljowhqzqyasalfs3j1t7xm8t4099f9xrldf160vke9n','About Damn Time','anks90h2ssvklxi','POP','1PckUlxKqWQs3RlWXVBLw3','https://p.scdn.co/mp3-preview/bbf8a26d38f7d8c7191dd64bd7c21a4cec8b61a0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qiqmrrgnbz92pt06zq15drdlja6tunjbs2obthnq8uxy8jxbx6', 'hghxi3lljowhqzqyasalfs3j1t7xm8t4099f9xrldf160vke9n', '0');
-- Drake
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bzqf302l4agnmx1', 'Drake', '121@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4293385d324db8558179afd9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:121@artist.com', 'bzqf302l4agnmx1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bzqf302l4agnmx1', 'Sculpting soundwaves into masterpieces of auditory art.', 'Drake');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('v9pti9v9aubswwzirkz3i8q85rcxdlpcmwxnxmiqvqit1y6v35','bzqf302l4agnmx1', 'https://i.scdn.co/image/ab67616d0000b2738dc0d801766a5aa6a33cbe37', 'Honestly, Nevermind','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6xzk598jm6zks9yz7vr4psqy00ggos3o26ts0smzbgxs5aouf5','Jimmy Cooks (feat. 21 Savage)','bzqf302l4agnmx1','POP','3F5CgOj3wFlRv51JsHbxhe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v9pti9v9aubswwzirkz3i8q85rcxdlpcmwxnxmiqvqit1y6v35', '6xzk598jm6zks9yz7vr4psqy00ggos3o26ts0smzbgxs5aouf5', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xqkbbbk8ys21fs0xnjwzqddvv711p7ennjqt1tt434z59us7tk','One Dance','bzqf302l4agnmx1','POP','1zi7xx7UVEFkmKfv06H8x0',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v9pti9v9aubswwzirkz3i8q85rcxdlpcmwxnxmiqvqit1y6v35', 'xqkbbbk8ys21fs0xnjwzqddvv711p7ennjqt1tt434z59us7tk', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d46xolc647hsmqeapk4o1qriycfs2uw5rddi7275zl9z90y0ps','Search & Rescue','bzqf302l4agnmx1','POP','7aRCf5cLOFN1U7kvtChY1G',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v9pti9v9aubswwzirkz3i8q85rcxdlpcmwxnxmiqvqit1y6v35', 'd46xolc647hsmqeapk4o1qriycfs2uw5rddi7275zl9z90y0ps', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ip929156853xsowdrrwqgrom470ai4g40l0rztzjxtanqtmf7j','Rich Flex','bzqf302l4agnmx1','POP','1bDbXMyjaUIooNwFE9wn0N',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v9pti9v9aubswwzirkz3i8q85rcxdlpcmwxnxmiqvqit1y6v35', 'ip929156853xsowdrrwqgrom470ai4g40l0rztzjxtanqtmf7j', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lq48tcm2k343edmyl2k6rsjff2ookvbo6d1aq2tuwnkn67d6sc','WAIT FOR U (feat. Drake & Tems)','bzqf302l4agnmx1','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v9pti9v9aubswwzirkz3i8q85rcxdlpcmwxnxmiqvqit1y6v35', 'lq48tcm2k343edmyl2k6rsjff2ookvbo6d1aq2tuwnkn67d6sc', '4');
-- Bebe Rexha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kf6vow23lj7u2o9', 'Bebe Rexha', '122@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc692afc666512dc946a7358f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:122@artist.com', 'kf6vow23lj7u2o9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kf6vow23lj7u2o9', 'A dynamic voice in pop music, known for her powerful vocals and catchy tunes.', 'Bebe Rexha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3gbt3l2mpqdfnl1po9nx6jzvl8ok9ejfiq26h1s7tu4qw1cd0o','kf6vow23lj7u2o9', NULL, 'Bebe Rexha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e92avkegchopir235rt3zsax1jvmznbbhm1f5uyyzzgdmx789k','Im Good (Blue)','kf6vow23lj7u2o9','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3gbt3l2mpqdfnl1po9nx6jzvl8ok9ejfiq26h1s7tu4qw1cd0o', 'e92avkegchopir235rt3zsax1jvmznbbhm1f5uyyzzgdmx789k', '0');
-- Grupo Marca Registrada
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jlbuid9rcy94xpz', 'Grupo Marca Registrada', '123@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8059103a66f9c25b91b375a9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:123@artist.com', 'jlbuid9rcy94xpz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jlbuid9rcy94xpz', 'A sonic adventurer, always seeking new horizons in music.', 'Grupo Marca Registrada');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('m8q7erj4arsg88rqsku1qbv9ffsbw28jg40swflx8l5ogw71ow','jlbuid9rcy94xpz', 'https://i.scdn.co/image/ab67616d0000b273bae22025cf282ad72b167e79', 'Dont Stop The Magic','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9qyrsm6a2zpimxgfmfuv1h6o0kcdmu5833ok77tijxasvo1oaf','Di Que Si','jlbuid9rcy94xpz','POP','0pliiCOWPN0IId8sXAqNJr','https://p.scdn.co/mp3-preview/622a816595469fdb54c42c88259f303266dc8aa7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m8q7erj4arsg88rqsku1qbv9ffsbw28jg40swflx8l5ogw71ow', '9qyrsm6a2zpimxgfmfuv1h6o0kcdmu5833ok77tijxasvo1oaf', '0');
-- Daddy Yankee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1knlrua5dxkhkua', 'Daddy Yankee', '124@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf9ad208bbff79c1ce09c77c1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:124@artist.com', '1knlrua5dxkhkua', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1knlrua5dxkhkua', 'A sonic adventurer, always seeking new horizons in music.', 'Daddy Yankee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e9fn9e8zkdfzsk6e4j5cm4vrc2bdx2rqbki8zv71sc8s3sw9bf','1knlrua5dxkhkua', 'https://i.scdn.co/image/ab67616d0000b2736bdcdf82ecce36bff808a40c', 'Barrio Fino (Bonus Track Version)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('b892p7srd0g4iqallk3be5lcozyk71wld4mdrs3v6862pq17a3','Gasolina','1knlrua5dxkhkua','POP','228BxWXUYQPJrJYHDLOHkj','https://p.scdn.co/mp3-preview/7c545be6847f3a6b13c4ad9c70d10a34f49a92d3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e9fn9e8zkdfzsk6e4j5cm4vrc2bdx2rqbki8zv71sc8s3sw9bf', 'b892p7srd0g4iqallk3be5lcozyk71wld4mdrs3v6862pq17a3', '0');
-- Mae Stephens
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('i7u71e86n8lkcf5', 'Mae Stephens', '125@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb743f68b46b3909d5f74da093','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:125@artist.com', 'i7u71e86n8lkcf5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('i7u71e86n8lkcf5', 'A tapestry of rhythms that echo the pulse of life.', 'Mae Stephens');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rl07cxop6rnyn7o9nqfxa73430qzyzu8lnm0irf3805naiclo4','i7u71e86n8lkcf5', 'https://i.scdn.co/image/ab67616d0000b2731fc63c898797e3dbf04ad611', 'If We Ever Broke Up','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aqgv3ewlph1fes5930mjq5b90g8yhzmd8hiiczbjt9mmdq3ocn','If We Ever Broke Up','i7u71e86n8lkcf5','POP','6maTPqynTmrkWIralgGaoP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rl07cxop6rnyn7o9nqfxa73430qzyzu8lnm0irf3805naiclo4', 'aqgv3ewlph1fes5930mjq5b90g8yhzmd8hiiczbjt9mmdq3ocn', '0');
-- Styrx
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mfoeqqrqk7avpyo', 'Styrx', '126@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb963fa55b3903ca75e781348b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:126@artist.com', 'mfoeqqrqk7avpyo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mfoeqqrqk7avpyo', 'Crafting soundscapes that transport listeners to another world.', 'Styrx');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rs2hrqxah4p3jm2ofne8qk5i4mdqmkkigi37vtcvscyjlq444e','mfoeqqrqk7avpyo', NULL, 'Styrx Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2e226eo0bsfpukgd7f11v6n2t2kinuxdgr23k9tv8uv66y3bam','Agudo Mgi','mfoeqqrqk7avpyo','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rs2hrqxah4p3jm2ofne8qk5i4mdqmkkigi37vtcvscyjlq444e', '2e226eo0bsfpukgd7f11v6n2t2kinuxdgr23k9tv8uv66y3bam', '0');
-- Dua Lipa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('836drgw06th9fxv', 'Dua Lipa', '127@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb6fff4b133bd150337490935','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:127@artist.com', '836drgw06th9fxv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('836drgw06th9fxv', 'A pop phenomenon, known for her empowering anthems and dynamic presence.', 'Dua Lipa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2oam87qg2h44eebrx95zs44kswa7xk9c74fkstxa26m535g5cb','836drgw06th9fxv', 'https://i.scdn.co/image/ab67616d0000b2737dd3ba455ee3390cb55b0192', 'Dance The Night (From Barbie The Album)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mf6vyl9znfsth62t0h6fgjjfmik17kxf1ddtaff48ayijl1ac4','Dance The Night (From Barbie The Album)','836drgw06th9fxv','POP','1vYXt7VSjH9JIM5oRRo7vA','https://p.scdn.co/mp3-preview/acaea048f50a3b30ca24b348c84a6047373baabb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2oam87qg2h44eebrx95zs44kswa7xk9c74fkstxa26m535g5cb', 'mf6vyl9znfsth62t0h6fgjjfmik17kxf1ddtaff48ayijl1ac4', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h2zprkccipwg1jvwmmn2buoof8rgzz8hr5qp077g4qm3fdsqp1','Cold Heart - PNAU Remix','836drgw06th9fxv','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2oam87qg2h44eebrx95zs44kswa7xk9c74fkstxa26m535g5cb', 'h2zprkccipwg1jvwmmn2buoof8rgzz8hr5qp077g4qm3fdsqp1', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('02e72oymv0hbh84xlbex79aki44opaslzw1lryiibub29xep1f','Dont Start Now','836drgw06th9fxv','POP','5OTdAwTZqmHfmate5zPJ1E','https://p.scdn.co/mp3-preview/cfc6684fc467e40bb9c7e6da2ea1b22eeccb211c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2oam87qg2h44eebrx95zs44kswa7xk9c74fkstxa26m535g5cb', '02e72oymv0hbh84xlbex79aki44opaslzw1lryiibub29xep1f', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9fp2yjerrg2llye29q8vghuojvzfni37zwnr3mseb354lz5z2f','Levitating (feat. DaBaby)','836drgw06th9fxv','POP','5nujrmhLynf4yMoMtj8AQF','https://p.scdn.co/mp3-preview/6af6db91dba9103cca41d6d5225f6fe120fcfcd3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2oam87qg2h44eebrx95zs44kswa7xk9c74fkstxa26m535g5cb', '9fp2yjerrg2llye29q8vghuojvzfni37zwnr3mseb354lz5z2f', '3');
-- Sam Smith
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v710vw2wv9yby84', 'Sam Smith', '128@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba8eef8322e55fc49ab436eea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:128@artist.com', 'v710vw2wv9yby84', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v710vw2wv9yby84', 'A soulful voice delivering deep emotional resonance.', 'Sam Smith');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gvwlox8m3ldqxcj0hzvwiqn3uhmael9j1r7p0709wmas1485wt','v710vw2wv9yby84', 'https://i.scdn.co/image/ab67616d0000b273a935e4689f15953311772cc4', 'Unholy (feat. Kim Petras)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2ytwlgo023lowpa01vkn60is8su210re4uy4tku1vif9ckvhwq','Unholy (feat. Kim Petras)','v710vw2wv9yby84','POP','3nqQXoyQOWXiESFLlDF1hG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gvwlox8m3ldqxcj0hzvwiqn3uhmael9j1r7p0709wmas1485wt', '2ytwlgo023lowpa01vkn60is8su210re4uy4tku1vif9ckvhwq', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f6xng93pylk39x4engesok2027v4mkr2aztoaprk1v7pj33u7d','Im Not Here To Make Friends','v710vw2wv9yby84','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gvwlox8m3ldqxcj0hzvwiqn3uhmael9j1r7p0709wmas1485wt', 'f6xng93pylk39x4engesok2027v4mkr2aztoaprk1v7pj33u7d', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ovi65a5cx764fqsn0vrpldxekycf3pqf56uubyfdsk9uiw7edq','Im Not The Only One','v710vw2wv9yby84','POP','5RYtz3cpYb28SV8f1FBtGc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gvwlox8m3ldqxcj0hzvwiqn3uhmael9j1r7p0709wmas1485wt', 'ovi65a5cx764fqsn0vrpldxekycf3pqf56uubyfdsk9uiw7edq', '2');
-- Jasiel Nuez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nu2p2pjbu2uo2dw', 'Jasiel Nuez', '129@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb94f3bfc067e8ba0293adb30a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:129@artist.com', 'nu2p2pjbu2uo2dw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nu2p2pjbu2uo2dw', 'Melodies that capture the essence of human emotion.', 'Jasiel Nuez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qm2y8ce99rbe7xyawqmuh5pb56li5u286c5ax1c8ncu3hejwht','nu2p2pjbu2uo2dw', NULL, 'Jasiel Nuez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z3xt05c4x2x4p5yhci7nhptk879ml42z5xldcl0pd60lezp144','LAGUNAS','nu2p2pjbu2uo2dw','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qm2y8ce99rbe7xyawqmuh5pb56li5u286c5ax1c8ncu3hejwht', 'z3xt05c4x2x4p5yhci7nhptk879ml42z5xldcl0pd60lezp144', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m91ouex85yf7e029wfkzmg1ev6kt98dvwwrofyunujpchanqgt','Rosa Pastel','nu2p2pjbu2uo2dw','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qm2y8ce99rbe7xyawqmuh5pb56li5u286c5ax1c8ncu3hejwht', 'm91ouex85yf7e029wfkzmg1ev6kt98dvwwrofyunujpchanqgt', '1');
-- MC Xenon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('o1vjo3cv3v07tpq', 'MC Xenon', '130@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb14b5fcee11164723953781ff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:130@artist.com', 'o1vjo3cv3v07tpq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('o1vjo3cv3v07tpq', 'Music is my canvas, and notes are my paint.', 'MC Xenon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hu35okr0kf56succh1o0nfn1qz8w18xgd52a80ndln5ygvr2sw','o1vjo3cv3v07tpq', NULL, 'MC Xenon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cqqe6c2pt949r0ywqauyftbkt4zqffzub2l5fi7lg18tbpctvu','Sem Aliana no ','o1vjo3cv3v07tpq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hu35okr0kf56succh1o0nfn1qz8w18xgd52a80ndln5ygvr2sw', 'cqqe6c2pt949r0ywqauyftbkt4zqffzub2l5fi7lg18tbpctvu', '0');
-- Rma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m10bbk0au8ium4w', 'Rma', '131@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7952358e33599027ae3c7f37','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:131@artist.com', 'm10bbk0au8ium4w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m10bbk0au8ium4w', 'Pioneering new sounds and delivering electrifying performances.', 'Rma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x8pzkyrlckwro2ygsgs1dfqm2x3omz69ousrny64doymitcmqe','m10bbk0au8ium4w', NULL, 'Rma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xi0qzaweaqa9duwgbur67j5gfb1ojep9aiofw0qrj31qw9dpgz','Calm Down (with Selena Gomez)','m10bbk0au8ium4w','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x8pzkyrlckwro2ygsgs1dfqm2x3omz69ousrny64doymitcmqe', 'xi0qzaweaqa9duwgbur67j5gfb1ojep9aiofw0qrj31qw9dpgz', '0');
-- The Neighbourhood
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('79ybtvu16ygivyw', 'The Neighbourhood', '132@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf0b5ac84376a0a4b2166816','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:132@artist.com', '79ybtvu16ygivyw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('79ybtvu16ygivyw', 'Melding alternative rock with introspective lyrics.', 'The Neighbourhood');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('p5443ie91339r5srtypcfdqiijjv4spkm6is8net6opzd5pp87','79ybtvu16ygivyw', 'https://i.scdn.co/image/ab67616d0000b2738265a736a1eb838ad5a0b921', 'I Love You.','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fago9dkhyr15aq9n3i88ds143thct0n8g25n5cqcf457nk6vqy','Sweater Weather','79ybtvu16ygivyw','POP','2QjOHCTQ1Jl3zawyYOpxh6','https://p.scdn.co/mp3-preview/877602f424a9dea277b13301ffc516f9fd1fbe7e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p5443ie91339r5srtypcfdqiijjv4spkm6is8net6opzd5pp87', 'fago9dkhyr15aq9n3i88ds143thct0n8g25n5cqcf457nk6vqy', '0');
-- a-ha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x58qiapr6zmkh9j', 'a-ha', '133@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0168ba8148c07c2cdeb7d067','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:133@artist.com', 'x58qiapr6zmkh9j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x58qiapr6zmkh9j', 'Crafting soundscapes that transport listeners to another world.', 'a-ha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('b85g1qs1o3ylbb7koyixbxhwnb98lv5lz4savtgpaxcpz6fte9','x58qiapr6zmkh9j', 'https://i.scdn.co/image/ab67616d0000b273e8dd4db47e7177c63b0b7d53', 'Hunting High and Low','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q98r4qqb7k2te0fum4rfsschtu9f6vrltvace2ixq81ulh4ucg','Take On Me','x58qiapr6zmkh9j','POP','2WfaOiMkCvy7F5fcp2zZ8L','https://p.scdn.co/mp3-preview/ed66a8c444c35b2f5029c04ae8e18f69d952c2bb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('b85g1qs1o3ylbb7koyixbxhwnb98lv5lz4savtgpaxcpz6fte9', 'q98r4qqb7k2te0fum4rfsschtu9f6vrltvace2ixq81ulh4ucg', '0');
-- Kali Uchis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tadxz1qy1qum3iw', 'Kali Uchis', '134@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:134@artist.com', 'tadxz1qy1qum3iw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tadxz1qy1qum3iw', 'A fusion of soul, R&B, and Latin beats, creating a unique sound experience.', 'Kali Uchis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rlg1pnycveydw3mrojbb3parzsbmtxa472valfnl7huujdrgt2','tadxz1qy1qum3iw', 'https://i.scdn.co/image/ab67616d0000b27381fccd758776d16b87721b17', 'Red Moon In Venus','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1in81aiejmym8prjwc6tg0yijx5gd1ohyyu7ew71735a6smpeh','Moonlight','tadxz1qy1qum3iw','POP','0JmnkIqdlnUzPaf8sqBRs3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rlg1pnycveydw3mrojbb3parzsbmtxa472valfnl7huujdrgt2', '1in81aiejmym8prjwc6tg0yijx5gd1ohyyu7ew71735a6smpeh', '0');
-- MC Caverinha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0bp9ectq2k1ix7c', 'MC Caverinha', '135@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb48d62acd2e6408096141a088','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:135@artist.com', '0bp9ectq2k1ix7c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0bp9ectq2k1ix7c', 'A visionary in the world of music, redefining genres.', 'MC Caverinha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5jy1iox3pahgdom2ebzcvs60ovooqd1xo6j3uq1l6e2108ylbq','0bp9ectq2k1ix7c', NULL, 'MC Caverinha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('36vrvq7us2i25gbgorbqzy0s79lbxzg05dbxgf557ltwb9y6ka','Carto B','0bp9ectq2k1ix7c','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5jy1iox3pahgdom2ebzcvs60ovooqd1xo6j3uq1l6e2108ylbq', '36vrvq7us2i25gbgorbqzy0s79lbxzg05dbxgf557ltwb9y6ka', '0');
-- Tom Odell
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6hlc2fmncpds21p', 'Tom Odell', '136@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb532e8dd8ba9fbd5e78105a78','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:136@artist.com', '6hlc2fmncpds21p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6hlc2fmncpds21p', 'Stirring emotions with piano-driven melodies and poetic lyrics.', 'Tom Odell');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('awebtfatdfuqxgcupj2ygi970qk64oyn7kpuoyljr55qbkc1mz','6hlc2fmncpds21p', 'https://i.scdn.co/image/ab67616d0000b2731917a0f3f4152622a040913f', 'Long Way Down (Deluxe)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z537olz80scpqssyzolvz3d1iv35wcykx09sqpjvoympa8o5kk','Another Love','6hlc2fmncpds21p','POP','3JvKfv6T31zO0ini8iNItO','https://p.scdn.co/mp3-preview/0369cb748bc968ffd34fb4ac60f5403f2aad032f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('awebtfatdfuqxgcupj2ygi970qk64oyn7kpuoyljr55qbkc1mz', 'z537olz80scpqssyzolvz3d1iv35wcykx09sqpjvoympa8o5kk', '0');
-- Justin Bieber
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hffnmqf4qe5296i', 'Justin Bieber', '137@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb393666951ab8b14e9c4ed386','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:137@artist.com', 'hffnmqf4qe5296i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hffnmqf4qe5296i', 'From teen idol to global pop star, constantly evolving his sound.', 'Justin Bieber');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lr07692cww0f6td6za5i2ogmwy00g6llgaesl8c02p4ic78ewl','hffnmqf4qe5296i', NULL, 'Justice','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e9mh37fodlq82nifuh7kwz9emyjvhxzfkoszkr0mh2psw3vfqn','STAY (with Justin Bieber)','hffnmqf4qe5296i','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lr07692cww0f6td6za5i2ogmwy00g6llgaesl8c02p4ic78ewl', 'e9mh37fodlq82nifuh7kwz9emyjvhxzfkoszkr0mh2psw3vfqn', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fspv60ry0uwdjz1hxk81813vqu2ww0me0kvgpvi0zgw9gtxld9','Ghost','hffnmqf4qe5296i','POP','6I3mqTwhRpn34SLVafSH7G',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lr07692cww0f6td6za5i2ogmwy00g6llgaesl8c02p4ic78ewl', 'fspv60ry0uwdjz1hxk81813vqu2ww0me0kvgpvi0zgw9gtxld9', '1');
-- TV Girl
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gcup2kqt77vnq53', 'TV Girl', '138@artist.com', 'https://i.scdn.co/image/ab67616d0000b27332f5fec7a879ed6ef28f0dfd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:138@artist.com', 'gcup2kqt77vnq53', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gcup2kqt77vnq53', 'A visionary in the world of music, redefining genres.', 'TV Girl');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uac4tea23spkvwbyfrgsfz1tl3w8ce8ejbab9qs76a0ilcr4c4','gcup2kqt77vnq53', 'https://i.scdn.co/image/ab67616d0000b273e1bc1af856b42dd7fdba9f84', 'French Exit','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hhivqp46lgcap71wrzhdkvjy652qpzz4vva8mmo14svmuaqn37','Lovers Rock','gcup2kqt77vnq53','POP','6dBUzqjtbnIa1TwYbyw5CM','https://p.scdn.co/mp3-preview/922a42db5aa8f8d335725697b7d7a12af6808f3a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uac4tea23spkvwbyfrgsfz1tl3w8ce8ejbab9qs76a0ilcr4c4', 'hhivqp46lgcap71wrzhdkvjy652qpzz4vva8mmo14svmuaqn37', '0');
-- DJ Escobar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ik5vkm9h448x5eh', 'DJ Escobar', '139@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb62fa9c7f56a64dc956ec2621','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:139@artist.com', 'ik5vkm9h448x5eh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ik5vkm9h448x5eh', 'A journey through the spectrum of sound in every album.', 'DJ Escobar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('z0df810wimi3xncdb68okjqnjncxz3iqbic88arqpc9yjk5dko','ik5vkm9h448x5eh', 'https://i.scdn.co/image/ab67616d0000b273769f6572dfa10ee7827edbf2', 'Evoque Prata - Remix Funk','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h22valt1zjl77hjfajmkw4645r0chrb6kpkr2ets2y9sy0g4ro','Evoque Prata','ik5vkm9h448x5eh','POP','4mQ2UZzSH3T4o4Gr9phTgL','https://p.scdn.co/mp3-preview/f2c69618853c528447f24f0102d0e5404fe31ed9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z0df810wimi3xncdb68okjqnjncxz3iqbic88arqpc9yjk5dko', 'h22valt1zjl77hjfajmkw4645r0chrb6kpkr2ets2y9sy0g4ro', '0');
-- Beach House
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('no571s4oadvfhlh', 'Beach House', '140@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb3e38a46a56a423d8f741c09','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:140@artist.com', 'no571s4oadvfhlh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('no571s4oadvfhlh', 'Redefining what it means to be an artist in the digital age.', 'Beach House');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9o3pm6u0wpalwiy78feg9yt1qc5ojcmplv83rodf3thp93sq9p','no571s4oadvfhlh', 'https://i.scdn.co/image/ab67616d0000b2739b7190e673e46271b2754aab', 'Depression Cherry','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jwprubuqi8ugala49mtkhpp9ne64x3lwvb4tx871o2ii3y0u6a','Space Song','no571s4oadvfhlh','POP','7H0ya83CMmgFcOhw0UB6ow','https://p.scdn.co/mp3-preview/3d50d7331c2ef197699e796d08cf8d4009591be0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9o3pm6u0wpalwiy78feg9yt1qc5ojcmplv83rodf3thp93sq9p', 'jwprubuqi8ugala49mtkhpp9ne64x3lwvb4tx871o2ii3y0u6a', '0');
-- Mariah Carey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bdaiymrwajupd1k', 'Mariah Carey', '141@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21b66418f7f3b86967f85bce','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:141@artist.com', 'bdaiymrwajupd1k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bdaiymrwajupd1k', 'A beacon of innovation in the world of sound.', 'Mariah Carey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o35ovk134mwprxxt0mhpca268e6agp695jyyshntk9q4w8j6mx','bdaiymrwajupd1k', 'https://i.scdn.co/image/ab67616d0000b2734246e3158421f5abb75abc4f', 'Merry Christmas','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1lcc1p6o8l5qqvvp1n7qtsnuc34gaxtriwwhps64y0wma2zrbx','All I Want for Christmas Is You','bdaiymrwajupd1k','POP','0bYg9bo50gSsH3LtXe2SQn','https://p.scdn.co/mp3-preview/6b1557cd25d543940a3decd85a7bf2bc136c51f8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o35ovk134mwprxxt0mhpca268e6agp695jyyshntk9q4w8j6mx', '1lcc1p6o8l5qqvvp1n7qtsnuc34gaxtriwwhps64y0wma2zrbx', '0');
-- Marshmello
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f9ope1lie3yn8vb', 'Marshmello', '142@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebabd3e69b432d6187cf4e28c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:142@artist.com', 'f9ope1lie3yn8vb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('f9ope1lie3yn8vb', 'An electronic music maestro known for his infectious beats.', 'Marshmello');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vr7jee5d5jo3q9fmqd0v5qutm64eccxi8ln1ovm30z300whkac','f9ope1lie3yn8vb', 'https://i.scdn.co/image/ab67616d0000b273f404676577626a87d92cf33f', 'El Merengue','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('go6v8hiprku8spcx8wvgf53vkymvypz8ge43l84skjjm59wmk8','El Merengue','f9ope1lie3yn8vb','POP','51FvjPEGKq2zByeeEQ43V9','https://p.scdn.co/mp3-preview/a933b6e1d6a47e591c13192f2b5e58739d3d5a06?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vr7jee5d5jo3q9fmqd0v5qutm64eccxi8ln1ovm30z300whkac', 'go6v8hiprku8spcx8wvgf53vkymvypz8ge43l84skjjm59wmk8', '0');
-- Freddie Dredd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3p1e6u2ht7rhbmo', 'Freddie Dredd', '143@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9d100e5a9cf34beab8e75750','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:143@artist.com', '3p1e6u2ht7rhbmo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3p1e6u2ht7rhbmo', 'Pioneering new paths in the musical landscape.', 'Freddie Dredd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sbgbbc30epq5bjnjlwawcricrpaxkwt5edw5by7qeeh2kg885e','3p1e6u2ht7rhbmo', 'https://i.scdn.co/image/ab67616d0000b27369b381d574b329409bd806e6', 'Freddies Inferno','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zqa4af57ncylydpu17dp1aul5poys5rcyow2hqk8ck3in8tk1y','Limbo','3p1e6u2ht7rhbmo','POP','37F7E7BKEw2E4O2L7u0IEp','https://p.scdn.co/mp3-preview/1715e2acb52d6fdd0e4b11ea8792688c12987ff7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sbgbbc30epq5bjnjlwawcricrpaxkwt5edw5by7qeeh2kg885e', 'zqa4af57ncylydpu17dp1aul5poys5rcyow2hqk8ck3in8tk1y', '0');
-- Agust D
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ogzd8ot17lh98kl', 'Agust D', '144@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb191d43dca6f2f5a126e43e4b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:144@artist.com', 'ogzd8ot17lh98kl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ogzd8ot17lh98kl', 'A tapestry of rhythms that echo the pulse of life.', 'Agust D');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1v5vdxqt2xur8sho6egrdqlgwx1set2gxi4bt7m6aqa3h9tv6f','ogzd8ot17lh98kl', 'https://i.scdn.co/image/ab67616d0000b273fa9247b68471b82d2125651e', 'D-DAY','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mz28vot5idvlesdqbsqkb8y2fx22zn9gy4asnd5baog0bvduzf','Haegeum','ogzd8ot17lh98kl','POP','4bjN59DRXFRxBE1g5ne6B1','https://p.scdn.co/mp3-preview/3c2f1894de0f6a51f557131c3eb275cb8bc80831?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1v5vdxqt2xur8sho6egrdqlgwx1set2gxi4bt7m6aqa3h9tv6f', 'mz28vot5idvlesdqbsqkb8y2fx22zn9gy4asnd5baog0bvduzf', '0');
-- Tory Lanez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ok4z7j95vx0ds7s', 'Tory Lanez', '145@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebbd5d3e1b363c3e26710661c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:145@artist.com', 'ok4z7j95vx0ds7s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ok4z7j95vx0ds7s', 'A harmonious blend of passion and creativity.', 'Tory Lanez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('to67hnnwu30xduyisus6ycwkgk2xztks943xts0witijq6vzej','ok4z7j95vx0ds7s', 'https://i.scdn.co/image/ab67616d0000b2730c5f23cbf0b1ab7e37d0dc67', 'Alone At Prom','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('80b4s3z4irsis38npkpfxk791ovsn0qloue774ocobtq5ux8ta','The Color Violet','ok4z7j95vx0ds7s','POP','3azJifCSqg9fRij2yKIbWz','https://p.scdn.co/mp3-preview/1d7c627bf549328110519c4bd21ac39d7ca50ea1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('to67hnnwu30xduyisus6ycwkgk2xztks943xts0witijq6vzej', '80b4s3z4irsis38npkpfxk791ovsn0qloue774ocobtq5ux8ta', '0');
-- Leo Santana
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kgp0zrsr9a903ah', 'Leo Santana', '146@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9c301d2486e33ad58c85db8e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:146@artist.com', 'kgp0zrsr9a903ah', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kgp0zrsr9a903ah', 'Where words fail, my music speaks.', 'Leo Santana');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wem78fjwzcc55z2zmszstr63wl9t4shlmzajiakl6gwoe9x6p5','kgp0zrsr9a903ah', 'https://i.scdn.co/image/ab67616d0000b273799dcbf5dcd77cea4549cbca', 'Confraternização da Firma 2023','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wz78y3l9b1rww6r73u6ozgfpjkhgbf5vmnlzmn27wfw6j63nay','Zona De Perigo','kgp0zrsr9a903ah','POP','04I2t1UTcXUNk0mWy1dRGd',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wem78fjwzcc55z2zmszstr63wl9t4shlmzajiakl6gwoe9x6p5', 'wz78y3l9b1rww6r73u6ozgfpjkhgbf5vmnlzmn27wfw6j63nay', '0');
-- Coi Leray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m7iu3pacumyhja2', 'Coi Leray', '147@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:147@artist.com', 'm7iu3pacumyhja2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m7iu3pacumyhja2', 'An odyssey of sound that defies conventions.', 'Coi Leray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i3nfknc2qdvdoa6yd3kf2tp7x5jm7xrxo1s5c2gqr509yx2ocg','m7iu3pacumyhja2', 'https://i.scdn.co/image/ab67616d0000b2735626453d29a0124dea22fb1b', 'Players','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3m9dgscc5gezlreemyqk2h1cqkhuy1f8aeyvzlcn03ccdolfk7','Players','m7iu3pacumyhja2','POP','6UN73IYd0hZxLi8wFPMQij',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i3nfknc2qdvdoa6yd3kf2tp7x5jm7xrxo1s5c2gqr509yx2ocg', '3m9dgscc5gezlreemyqk2h1cqkhuy1f8aeyvzlcn03ccdolfk7', '0');
-- Mahalini
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ea8y8vlps2zdccm', 'Mahalini', '148@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb8333468abeb2e461d1ab5ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:148@artist.com', 'ea8y8vlps2zdccm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ea8y8vlps2zdccm', 'Delivering soul-stirring tunes that linger in the mind.', 'Mahalini');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wmlrdz98hsa9d9v378wpl83zvsfl8detmwb9mu99y2awckn3nn','ea8y8vlps2zdccm', 'https://i.scdn.co/image/ab67616d0000b2736f713eb92ebf7ca05a562542', 'fábula','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tfhi7prfy7awjd3y87h42g8jeq1ouiyzkss77gdvzjhc4fzy7d','Sial','ea8y8vlps2zdccm','POP','6O0WEM0QNEhqpU50BKui7o','https://p.scdn.co/mp3-preview/1285e7f97156037b5c1c958513ff3f8176a68a33?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wmlrdz98hsa9d9v378wpl83zvsfl8detmwb9mu99y2awckn3nn', 'tfhi7prfy7awjd3y87h42g8jeq1ouiyzkss77gdvzjhc4fzy7d', '0');
-- Gustavo Mioto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('abdofcm0djeuzyg', 'Gustavo Mioto', '149@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcec51a9ef6fe19159cb0452f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:149@artist.com', 'abdofcm0djeuzyg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('abdofcm0djeuzyg', 'Blending genres for a fresh musical experience.', 'Gustavo Mioto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yuwbsxefu9ff9ruv2h7ims4h6n7eaip3uzrum8w491odjfseji','abdofcm0djeuzyg', 'https://i.scdn.co/image/ab67616d0000b27319bb2fb697a42c1084d71f6c', 'Eu Gosto Assim (Ao Vivo)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wo1phqxan7vambvnj8ibhet3c719v7y5nz20us9tm8zsbyitak','Eu Gosto Assim - Ao Vivo','abdofcm0djeuzyg','POP','4ASA1PZyWGbuc4d9N8OAcF',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yuwbsxefu9ff9ruv2h7ims4h6n7eaip3uzrum8w491odjfseji', 'wo1phqxan7vambvnj8ibhet3c719v7y5nz20us9tm8zsbyitak', '0');
-- ENHYPEN
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0dlmupm9krkepq2', 'ENHYPEN', '150@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a48a236a01fa62db8c7a6f6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:150@artist.com', '0dlmupm9krkepq2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0dlmupm9krkepq2', 'An odyssey of sound that defies conventions.', 'ENHYPEN');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('c0fgl0y0qfhh8mlqlfcwbkidrgjwpjsfoc6jrms8c4j2m7rvpz','0dlmupm9krkepq2', 'https://i.scdn.co/image/ab67616d0000b2731d03b5e88cee6870778a4d27', 'DARK BLOOD','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6e0g7uc5k4f2ijw3h94z6uuinqk0o85ip2iqekh3lyb5a0kjc4','Bite Me','0dlmupm9krkepq2','POP','7mpdNiaQvygj2rHoxkzMfa','https://p.scdn.co/mp3-preview/ff4e3c3d8464e572759ba2169332743c2889d97e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c0fgl0y0qfhh8mlqlfcwbkidrgjwpjsfoc6jrms8c4j2m7rvpz', '6e0g7uc5k4f2ijw3h94z6uuinqk0o85ip2iqekh3lyb5a0kjc4', '0');
-- j-hope
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pra16l57lkbbeny', 'j-hope', '151@artist.com', 'https://i.scdn.co/image/e8a48dd66904570087b66f1196b900554aef78a0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:151@artist.com', 'pra16l57lkbbeny', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pra16l57lkbbeny', 'The heartbeat of a new generation of music lovers.', 'j-hope');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kql4b6s0gmqycovqtjbu318gatblkowu4tegwbr307dj6qt77e','pra16l57lkbbeny', 'https://i.scdn.co/image/ab67616d0000b2735e8286ff63f7efce1881a02b', 'on the street (with J. Cole)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3ejxl0z9epqqv5zryyf0kc6cgef9djqfs0bayq4pq88sk7xc58','on the street (with J. Cole)','pra16l57lkbbeny','POP','5wxYxygyHpbgv0EXZuqb9V','https://p.scdn.co/mp3-preview/c69cf6ed41027bd08a5953b556cca144ff8ed2bf?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kql4b6s0gmqycovqtjbu318gatblkowu4tegwbr307dj6qt77e', '3ejxl0z9epqqv5zryyf0kc6cgef9djqfs0bayq4pq88sk7xc58', '0');
-- Jack Black
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('a692io572b6ehtw', 'Jack Black', '152@artist.com', 'https://i.scdn.co/image/ab6772690000c46ca156a562884cb76eeb0b75e9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:152@artist.com', 'a692io572b6ehtw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('a692io572b6ehtw', 'Crafting melodies that resonate with the soul.', 'Jack Black');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ongz9dp5xa7rwuq4oqhoekoufkfmsviujh327wpocw2fq312s0','a692io572b6ehtw', NULL, 'Jack Black Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0gy7kt5818in4t6v8doushzpax2d0ar564dh6iw6t2qzbsuoc2','Peaches (from The Super Mario Bros. Movie)','a692io572b6ehtw','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ongz9dp5xa7rwuq4oqhoekoufkfmsviujh327wpocw2fq312s0', '0gy7kt5818in4t6v8doushzpax2d0ar564dh6iw6t2qzbsuoc2', '0');
-- Don Toliver
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('blhhvxh67434jt4', 'Don Toliver', '153@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeb63bf6379a9ea8453a30020','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:153@artist.com', 'blhhvxh67434jt4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('blhhvxh67434jt4', 'Striking chords that resonate across generations.', 'Don Toliver');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('v6leum049nzakkhu8hm0a83bas3ly6eouoh87yq2sew5u2d1lc','blhhvxh67434jt4', 'https://i.scdn.co/image/ab67616d0000b273feeff698e6090e6b02f21ec0', 'Love Sick','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mkzuggn4476etrh3s68f196xsp0hu1jq6sbnrx85zrx40eooph','Private Landing (feat. Justin Bieber & Future)','blhhvxh67434jt4','POP','52NGJPcLUzQq5w7uv4e5gf','https://p.scdn.co/mp3-preview/511bdf681359f3b57dfa25344f34c2b66ecc4326?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v6leum049nzakkhu8hm0a83bas3ly6eouoh87yq2sew5u2d1lc', 'mkzuggn4476etrh3s68f196xsp0hu1jq6sbnrx85zrx40eooph', '0');
-- Taiu
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qf4zwhqzy28qyit', 'Taiu', '154@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4d66eec26b41815aa6fcf297','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:154@artist.com', 'qf4zwhqzy28qyit', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qf4zwhqzy28qyit', 'Revolutionizing the music scene with innovative compositions.', 'Taiu');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8ykecwrpx1e0z7txjt0ifex4p214fu8cvlqo8uvdynttiaze9b','qf4zwhqzy28qyit', 'https://i.scdn.co/image/ab67616d0000b273d467bed4e6b2a01ea8569100', 'Rara Vez','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v4rzqnnl80i4y0k7pkkl17ocyenp6n6r18wbuwnvknm68zpa2s','Rara Vez','qf4zwhqzy28qyit','POP','7MVIfkyzuUmQ716j8U7yGR',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8ykecwrpx1e0z7txjt0ifex4p214fu8cvlqo8uvdynttiaze9b', 'v4rzqnnl80i4y0k7pkkl17ocyenp6n6r18wbuwnvknm68zpa2s', '0');
-- Jack Harlow
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y6ht3p5owuoxvpe', 'Jack Harlow', '155@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5ee4635b0775e342e064657','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:155@artist.com', 'y6ht3p5owuoxvpe', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y6ht3p5owuoxvpe', 'Elevating the ordinary to extraordinary through music.', 'Jack Harlow');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('potwmu3b7x7f4lunhyzvfif9tpdrmm4lfldven3wg2t2mlnehw','y6ht3p5owuoxvpe', NULL, 'Jack Harlow Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kklef58bmbwu8lx63z4vgrdrvhl2u2zomktvhb6gv4haifefy4','INDUSTRY BABY (feat. Jack Harlow)','y6ht3p5owuoxvpe','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('potwmu3b7x7f4lunhyzvfif9tpdrmm4lfldven3wg2t2mlnehw', 'kklef58bmbwu8lx63z4vgrdrvhl2u2zomktvhb6gv4haifefy4', '0');
-- Simone Mendes
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('alt6c4eyf1xmpbp', 'Simone Mendes', '156@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb80e5acf09546a1fa2ca12a49','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:156@artist.com', 'alt6c4eyf1xmpbp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('alt6c4eyf1xmpbp', 'The heartbeat of a new generation of music lovers.', 'Simone Mendes');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5fcpw41bqdr1hif2q3z7aadb0cbl4fdvqgxs89klw293wkggy2','alt6c4eyf1xmpbp', 'https://i.scdn.co/image/ab67616d0000b27379dcbcbbc872003eea5fd10f', 'Churrasco','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7k1ett9fmn7n481g0a3tixn8a2mpp6aqz5fbjakqnyfwxh2o3p','Erro Gostoso - Ao Vivo','alt6c4eyf1xmpbp','POP','4R1XAT4Ix7kad727aKh7Pj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5fcpw41bqdr1hif2q3z7aadb0cbl4fdvqgxs89klw293wkggy2', '7k1ett9fmn7n481g0a3tixn8a2mpp6aqz5fbjakqnyfwxh2o3p', '0');
-- Beach Weather
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wix6jhju47b4auh', 'Beach Weather', '157@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebed9ce2779a99efc01b4f918c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:157@artist.com', 'wix6jhju47b4auh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wix6jhju47b4auh', 'Striking chords that resonate across generations.', 'Beach Weather');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vim743ja4of90f8ztufo79fhdak9jv029ribxtkev5p5w4s5pe','wix6jhju47b4auh', 'https://i.scdn.co/image/ab67616d0000b273a03e3d24ccee1c370899c342', 'Pineapple Sunrise','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q4cd3y0e2ufi31ufuihamef2nu4qf7n9o6mhdumy40pg07x19x','Sex, Drugs, Etc.','wix6jhju47b4auh','POP','7MlDNspYwfqnHxORufupwq','https://p.scdn.co/mp3-preview/a423aecddb590788a61f2a7b4d325bf461f88dc8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vim743ja4of90f8ztufo79fhdak9jv029ribxtkev5p5w4s5pe', 'q4cd3y0e2ufi31ufuihamef2nu4qf7n9o6mhdumy40pg07x19x', '0');
-- Fuerza Regida
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gbov92jauwtscjy', 'Fuerza Regida', '158@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1b85fbf9507041aab224336d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:158@artist.com', 'gbov92jauwtscjy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gbov92jauwtscjy', 'Revitalizing the regional music scene with their unique sound and powerful lyrics.', 'Fuerza Regida');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1teoz2jbe94sfzra490bshdxb3ryn5ofne5m2n68c2rglecyhk','gbov92jauwtscjy', 'https://i.scdn.co/image/ab67616d0000b273cfe3eb72c48b93971e53efd9', 'SABOR FRESA','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m1m82vbosu177pjcqiuwv9ezaid7s81iwq4iytuu1e3j6xq6dl','SABOR FRESA','gbov92jauwtscjy','POP','1UMm1Qs3u59Wvk53zBUE8r','https://p.scdn.co/mp3-preview/590ae0b69465339d97ef5db9f7e36fe0c452fbb4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1teoz2jbe94sfzra490bshdxb3ryn5ofne5m2n68c2rglecyhk', 'm1m82vbosu177pjcqiuwv9ezaid7s81iwq4iytuu1e3j6xq6dl', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uqe9dwjovn8xozinxwb89a1m4kbthdpiehps015hoaee2oj6e7','TQM','gbov92jauwtscjy','POP','368eeEO3Y2uZUQ6S5oIjcu','https://p.scdn.co/mp3-preview/63f6b66cfcc3d7bd396dcbe18d6e3dee05fdb956?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1teoz2jbe94sfzra490bshdxb3ryn5ofne5m2n68c2rglecyhk', 'uqe9dwjovn8xozinxwb89a1m4kbthdpiehps015hoaee2oj6e7', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2c0y83khmi1hka4kbz3lbfx3ee3eegu9xu3gvtc0xlrke0sxx7','Bebe Dame','gbov92jauwtscjy','POP','0IKeDy5bT9G0bA7ZixRT4A','https://p.scdn.co/mp3-preview/408ffb4fffcd26cda82f2b3cda7726ea1f6ebd74?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1teoz2jbe94sfzra490bshdxb3ryn5ofne5m2n68c2rglecyhk', '2c0y83khmi1hka4kbz3lbfx3ee3eegu9xu3gvtc0xlrke0sxx7', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nlvbpnh5eemgy6rdvv4p8ac7wgfdchgzyud2abp7sc77vsq8n4','Ch y la Pizza','gbov92jauwtscjy','POP','0UbesRsX2TtiCeamOIVEkp','https://p.scdn.co/mp3-preview/212acba217ff0304f6cbb41eb8f43cd27d991c7b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1teoz2jbe94sfzra490bshdxb3ryn5ofne5m2n68c2rglecyhk', 'nlvbpnh5eemgy6rdvv4p8ac7wgfdchgzyud2abp7sc77vsq8n4', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8e3e20de8zdoo2tqz1hyqgmsqso6t4338kqzsllnlmafibmdpf','Igualito a Mi Ap','gbov92jauwtscjy','POP','17js0w8GTkTUFGFM6PYvBd','https://p.scdn.co/mp3-preview/f0f87682468e9baa92562cd4d797ce8af5337ca6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1teoz2jbe94sfzra490bshdxb3ryn5ofne5m2n68c2rglecyhk', '8e3e20de8zdoo2tqz1hyqgmsqso6t4338kqzsllnlmafibmdpf', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6dm1i0f6dzje51j6h6upkoxqtwwnftg7fp3ocsh2v7ux08ybqv','Dijeron Que No La Iba Lograr','gbov92jauwtscjy','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1teoz2jbe94sfzra490bshdxb3ryn5ofne5m2n68c2rglecyhk', '6dm1i0f6dzje51j6h6upkoxqtwwnftg7fp3ocsh2v7ux08ybqv', '5');
-- SZA
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9g6in6xyi4josbk', 'SZA', '159@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0895066d172e1f51f520bc65','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:159@artist.com', '9g6in6xyi4josbk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9g6in6xyi4josbk', 'An avant-garde R&B artist painting vivid stories through her music.', 'SZA');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pb4qjacr92zrdgr8150s96bp1893ua4k267if4jnz9ejc6rq8f','9g6in6xyi4josbk', 'https://i.scdn.co/image/ab67616d0000b2730c471c36970b9406233842a5', 'SOS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ehw42w39v0fxkvyrpet75cs1bu0rousngh6f7rx16ivbk4dz8q','Kill Bill','9g6in6xyi4josbk','POP','1Qrg8KqiBpW07V7PNxwwwL','https://p.scdn.co/mp3-preview/4bd2dc84016f3743add7eea8b988407b1b900672?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pb4qjacr92zrdgr8150s96bp1893ua4k267if4jnz9ejc6rq8f', 'ehw42w39v0fxkvyrpet75cs1bu0rousngh6f7rx16ivbk4dz8q', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('341rdqf2uzwjc8wmcn1lzd6yi6zqe0e6aqloeychzazcz255pz','Snooze','9g6in6xyi4josbk','POP','4iZ4pt7kvcaH6Yo8UoZ4s2','https://p.scdn.co/mp3-preview/8c53920b5fd2c3178afa36cac9eec68b5ee9204a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pb4qjacr92zrdgr8150s96bp1893ua4k267if4jnz9ejc6rq8f', '341rdqf2uzwjc8wmcn1lzd6yi6zqe0e6aqloeychzazcz255pz', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('psz986vsv6htw0cn5rrzrfi2bp2mxyd3ot17z478207ge29ese','Low','9g6in6xyi4josbk','POP','2GAhgAjOhEmItWLfgisyOn','https://p.scdn.co/mp3-preview/5b6dd5a1d06d0bdfd57382a584cbf0227b4d9a4b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pb4qjacr92zrdgr8150s96bp1893ua4k267if4jnz9ejc6rq8f', 'psz986vsv6htw0cn5rrzrfi2bp2mxyd3ot17z478207ge29ese', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oaoxz7ockuslj6ocner8gbvcof9884te875kzc2h67l4ay5gfm','Nobody Gets Me','9g6in6xyi4josbk','POP','5Y35SjAfXjjG0sFQ3KOxmm','https://p.scdn.co/mp3-preview/36cfe8fbfb78aa38ca3b222c4b9fc88cda992841?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pb4qjacr92zrdgr8150s96bp1893ua4k267if4jnz9ejc6rq8f', 'oaoxz7ockuslj6ocner8gbvcof9884te875kzc2h67l4ay5gfm', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('niyrkbhs9p4q7e5bt5356rlp84oj3s4cb568m797remx0txcix','Shirt','9g6in6xyi4josbk','POP','2wSTnntOPRi7aQneobFtU4','https://p.scdn.co/mp3-preview/8819fb0dc127d1d777a776f4d1186be783334ae5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pb4qjacr92zrdgr8150s96bp1893ua4k267if4jnz9ejc6rq8f', 'niyrkbhs9p4q7e5bt5356rlp84oj3s4cb568m797remx0txcix', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kwwej20spj2wvi029kmze68sco124ocd642gy994hxfc40zn8a','Blind','9g6in6xyi4josbk','POP','2CSRrnOEELmhpq8iaAi9cd','https://p.scdn.co/mp3-preview/56cd00fd7aa857bd25e4ed25aebc0e41a24bfd4f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pb4qjacr92zrdgr8150s96bp1893ua4k267if4jnz9ejc6rq8f', 'kwwej20spj2wvi029kmze68sco124ocd642gy994hxfc40zn8a', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('50h5m7pq8eskdgw638piuptpzc2l22z0ujr2xrc3abnxfckdo8','Good Days','9g6in6xyi4josbk','POP','4PMqSO5qyjpvzhlLI5GnID','https://p.scdn.co/mp3-preview/d7fd97c8190baa298af9b4e778d2ba940fcd13a4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pb4qjacr92zrdgr8150s96bp1893ua4k267if4jnz9ejc6rq8f', '50h5m7pq8eskdgw638piuptpzc2l22z0ujr2xrc3abnxfckdo8', '6');
-- Arijit Singh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q762q4h8ycflwwm', 'Arijit Singh', '160@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0261696c5df3be99da6ed3f3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:160@artist.com', 'q762q4h8ycflwwm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q762q4h8ycflwwm', 'Elevating the ordinary to extraordinary through music.', 'Arijit Singh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ce1d0faqvffhe734n3a2kasbzir4wtelf0q6soz3rb0tp8aofl','q762q4h8ycflwwm', NULL, 'Arijit Singh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x30zqb73ddzdozm5b7577yy8ghnrebau72o62nb9gm7t4n5h9c','Phir Aur Kya Chahiye (From "Zara Hatke Zara Bachke")','q762q4h8ycflwwm','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ce1d0faqvffhe734n3a2kasbzir4wtelf0q6soz3rb0tp8aofl', 'x30zqb73ddzdozm5b7577yy8ghnrebau72o62nb9gm7t4n5h9c', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ojx5fdohgss4d9cyxtjv2oghpipanlnu8mjs7mlnmgb4av8ii3','Apna Bana Le (From "Bhediya")','q762q4h8ycflwwm','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ce1d0faqvffhe734n3a2kasbzir4wtelf0q6soz3rb0tp8aofl', 'ojx5fdohgss4d9cyxtjv2oghpipanlnu8mjs7mlnmgb4av8ii3', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('chvyrv1o76p839o31vbvy8hryf2egvsqgb7jp92oo6zt86hg0t','Jhoome Jo Pathaan','q762q4h8ycflwwm','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ce1d0faqvffhe734n3a2kasbzir4wtelf0q6soz3rb0tp8aofl', 'chvyrv1o76p839o31vbvy8hryf2egvsqgb7jp92oo6zt86hg0t', '2');
-- Baby Tate
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7mrttmdxsm1r8kq', 'Baby Tate', '161@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe7b0d119183e74ec390d7aec','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:161@artist.com', '7mrttmdxsm1r8kq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7mrttmdxsm1r8kq', 'An endless quest for musical perfection.', 'Baby Tate');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gseh1vcrsxh881bum61fh5180umzvvxgwo6x9e7ywxkvdmzzpy','7mrttmdxsm1r8kq', 'https://i.scdn.co/image/ab67616d0000b2732571034f34b381958f8cc727', 'Hey, Mickey!','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yn5sfq81z83fuhtowuwzl9fqugwqldpoz8lisyspkgczuik2vb','Hey, Mickey!','7mrttmdxsm1r8kq','POP','3RKjTYlQrtLXCq5ncswBPp','https://p.scdn.co/mp3-preview/2bfe39402bec233fbb5b2c06ffedbbf4d6fbc38a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gseh1vcrsxh881bum61fh5180umzvvxgwo6x9e7ywxkvdmzzpy', 'yn5sfq81z83fuhtowuwzl9fqugwqldpoz8lisyspkgczuik2vb', '0');
-- (G)I-DLE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v6hrsudon1v9t8f', '(G)I-DLE', '162@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8abd5f97fc52561939ebbc89','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:162@artist.com', 'v6hrsudon1v9t8f', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v6hrsudon1v9t8f', 'Music is my canvas, and notes are my paint.', '(G)I-DLE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('q5sabbmk6bu4eiitl2bulmen88f4t4fyxd3fyra8l3mu8a7gt2','v6hrsudon1v9t8f', 'https://i.scdn.co/image/ab67616d0000b27382dd2427e6d302711b1b9616', 'I feel','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z1e9vhu8fk6d7mifdb62lva6ql77hmv7uduit2nixbs4yeg3s4','Queencard','v6hrsudon1v9t8f','POP','4uOBL4DDWWVx4RhYKlPbPC','https://p.scdn.co/mp3-preview/9f36e86bca0911d3f849197e8f531b9d0c34f002?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q5sabbmk6bu4eiitl2bulmen88f4t4fyxd3fyra8l3mu8a7gt2', 'z1e9vhu8fk6d7mifdb62lva6ql77hmv7uduit2nixbs4yeg3s4', '0');
-- Loreen
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('22m0jd965kyuold', 'Loreen', '163@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3ca2710f45c2993c415a1c5e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:163@artist.com', '22m0jd965kyuold', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('22m0jd965kyuold', 'The heartbeat of a new generation of music lovers.', 'Loreen');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('h681loyngfdzyor5on34h4hv00rmw22uw8n6hs9013azrasw57','22m0jd965kyuold', 'https://i.scdn.co/image/ab67616d0000b2732b0ba87db609976eee193bd6', 'Tattoo','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4rphi63drvcnlgkl6edl6llk2fhz9pb5qfonj8dh078bd3ee0w','Tattoo','22m0jd965kyuold','POP','1DmW5Ep6ywYwxc2HMT5BG6',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h681loyngfdzyor5on34h4hv00rmw22uw8n6hs9013azrasw57', '4rphi63drvcnlgkl6edl6llk2fhz9pb5qfonj8dh078bd3ee0w', '0');
-- Lil Nas X
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('noct2gvjq6v95ze', 'Lil Nas X', '164@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd66f1e0c883f319443d68c45','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:164@artist.com', 'noct2gvjq6v95ze', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('noct2gvjq6v95ze', 'Crafting a unique sonic identity in every track.', 'Lil Nas X');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('msolct7ulycrddskx0g47hfs2td9abo3y5f1x5c1suu6st7b44','noct2gvjq6v95ze', 'https://i.scdn.co/image/ab67616d0000b27304cd9a1664fb4539a55643fe', 'STAR WALKIN (League of Legends Worlds Anthem)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rt24iqlbn371k8kj1drf2pz73ektsoujtb4tcl4vugvdijmsjf','STAR WALKIN (League of Legends Worlds Anthem)','noct2gvjq6v95ze','POP','38T0tPVZHcPZyhtOcCP7pF','https://p.scdn.co/mp3-preview/ffa9d53ff1f83a322ac0523d7a6ce13b231e4a3a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('msolct7ulycrddskx0g47hfs2td9abo3y5f1x5c1suu6st7b44', 'rt24iqlbn371k8kj1drf2pz73ektsoujtb4tcl4vugvdijmsjf', '0');
-- Sachin-Jigar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cpbgeub6b7gy1om', 'Sachin-Jigar', '165@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba038d7d87f8577bbb9686bd3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:165@artist.com', 'cpbgeub6b7gy1om', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cpbgeub6b7gy1om', 'Transcending language barriers through the universal language of music.', 'Sachin-Jigar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uryjviftqm3ldz12jmnf54y4b3aljp530i8kaw13hfkiaoohyj','cpbgeub6b7gy1om', NULL, 'Sachin-Jigar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zg5mhqgnx79enj6xpd80tcp2oq3reyfe92lonrhpz5n5w6s75e','Tere Vaaste (From "Zara Hatke Zara Bachke")','cpbgeub6b7gy1om','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uryjviftqm3ldz12jmnf54y4b3aljp530i8kaw13hfkiaoohyj', 'zg5mhqgnx79enj6xpd80tcp2oq3reyfe92lonrhpz5n5w6s75e', '0');
-- BTS
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('p8z3ctyb1pshr9j', 'BTS', '166@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd642648235ebf3460d2d1f6a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:166@artist.com', 'p8z3ctyb1pshr9j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('p8z3ctyb1pshr9j', 'A global phenomenon, setting new standards in K-pop with their music and performances.', 'BTS');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vx88y06odsox6ai6oszbg3ve1z9hmf8wdxjiv5qri8w7fgh583','p8z3ctyb1pshr9j', 'https://i.scdn.co/image/ab67616d0000b2738a701e76e8845928f6cd81c8', 'Take Two','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uqfvp7y0e1y4ay9068bvg1cpj8cvn9huszh3ki4l6dj12b2jvd','Take Two','p8z3ctyb1pshr9j','POP','5IAESfJjmOYu7cHyX557kz','https://p.scdn.co/mp3-preview/ef43da30a06fcad16898e9fff1cadd0ccf953fc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vx88y06odsox6ai6oszbg3ve1z9hmf8wdxjiv5qri8w7fgh583', 'uqfvp7y0e1y4ay9068bvg1cpj8cvn9huszh3ki4l6dj12b2jvd', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ncowl61c1xrurf6vfdc7goj5bcsx7ly37s2ux8dm7wzserhsi5','Dreamers [Music from the FIFA World Cup Qatar 2022 Official Soundtrack]','p8z3ctyb1pshr9j','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vx88y06odsox6ai6oszbg3ve1z9hmf8wdxjiv5qri8w7fgh583', 'ncowl61c1xrurf6vfdc7goj5bcsx7ly37s2ux8dm7wzserhsi5', '1');
-- Radiohead
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('otj1efpvrkjzcm8', 'Radiohead', '167@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba03696716c9ee605006047fd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:167@artist.com', 'otj1efpvrkjzcm8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('otj1efpvrkjzcm8', 'Weaving lyrical magic into every song.', 'Radiohead');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xqwwu66ounl2pdnep8dhb2gf80dzofwxg66ea26oxcvmsxoqux','otj1efpvrkjzcm8', 'https://i.scdn.co/image/ab67616d0000b273df55e326ed144ab4f5cecf95', 'Pablo Honey','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rcfx1o4io5ugp7tocs779ih01meafcjx988suyv2l4qlrn7hjy','Creep','otj1efpvrkjzcm8','POP','70LcF31zb1H0PyJoS1Sx1r','https://p.scdn.co/mp3-preview/713b601d02641a850f2a3e6097aacaff52328d57?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xqwwu66ounl2pdnep8dhb2gf80dzofwxg66ea26oxcvmsxoqux', 'rcfx1o4io5ugp7tocs779ih01meafcjx988suyv2l4qlrn7hjy', '0');
-- Lizzy McAlpine
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dp9rmtdwsmwlrrf', 'Lizzy McAlpine', '168@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb10e2b618880f429a3967185','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:168@artist.com', 'dp9rmtdwsmwlrrf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dp9rmtdwsmwlrrf', 'Delivering soul-stirring tunes that linger in the mind.', 'Lizzy McAlpine');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hezt70a74zpcb6w8t5eg9jnhha5yk1n1q95xutc9su503fmv24','dp9rmtdwsmwlrrf', 'https://i.scdn.co/image/ab67616d0000b273d370fdc4dbc47778b9b667c3', 'five seconds flat','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m6plkuhfguydp1mo23tl1woqpjnicdau4c2k9kxb4usq55sjwm','ceilings','dp9rmtdwsmwlrrf','POP','2L9N0zZnd37dwF0clgxMGI','https://p.scdn.co/mp3-preview/580782ffb17d468fe5d000bdf86cc07926ff9a5a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hezt70a74zpcb6w8t5eg9jnhha5yk1n1q95xutc9su503fmv24', 'm6plkuhfguydp1mo23tl1woqpjnicdau4c2k9kxb4usq55sjwm', '0');
-- Kaifi Khalil
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j4qoe7dtnws6qx9', 'Kaifi Khalil', '169@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8b3d777345ecd2f25f408586','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:169@artist.com', 'j4qoe7dtnws6qx9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j4qoe7dtnws6qx9', 'Where words fail, my music speaks.', 'Kaifi Khalil');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ngv5qq0rb7kmnozly8y1vhah5qfklbbw8zr1ggb94uxzfwzr8i','j4qoe7dtnws6qx9', 'https://i.scdn.co/image/ab67616d0000b2734697d4ee22b3f63c17a3b9ec', 'Kahani Suno 2.0','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('astts0995v1qwa1w498l2lq9xxfy05evb02tmsm8gez5arp19e','Kahani Suno 2.0','j4qoe7dtnws6qx9','POP','4VsP4Dm8gsibRxB5I2hEkw','https://p.scdn.co/mp3-preview/2c644e9345d1a0ab97e4541d26b6b8ccb2c889f9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ngv5qq0rb7kmnozly8y1vhah5qfklbbw8zr1ggb94uxzfwzr8i', 'astts0995v1qwa1w498l2lq9xxfy05evb02tmsm8gez5arp19e', '0');
-- Kate Bush
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9t8qlcyglj91p1s', 'Kate Bush', '170@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb187017724e58e78ee1f5a8e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:170@artist.com', '9t8qlcyglj91p1s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9t8qlcyglj91p1s', 'A tapestry of rhythms that echo the pulse of life.', 'Kate Bush');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('odzh0y3opqklfhnastnksw7izb3xqly5a6f5o65l4khctn5s7b','9t8qlcyglj91p1s', 'https://i.scdn.co/image/ab67616d0000b273ad08f4b38efbff0c0da0f252', 'Hounds Of Love','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yl5diiavbxz3b2g6nsgfolcupey8nmj9h9zrkvo6uuk8hwm5a5','Running Up That Hill (A Deal With God)','9t8qlcyglj91p1s','POP','1PtQJZVZIdWIYdARpZRDFO','https://p.scdn.co/mp3-preview/861d26b52ece3e3ad72a7dc3463daece3478801a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('odzh0y3opqklfhnastnksw7izb3xqly5a6f5o65l4khctn5s7b', 'yl5diiavbxz3b2g6nsgfolcupey8nmj9h9zrkvo6uuk8hwm5a5', '0');
-- ROSAL
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tet8xap2z7d8etn', 'ROSAL', '171@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd7bb678bef6d2f26110cae49','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:171@artist.com', 'tet8xap2z7d8etn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tet8xap2z7d8etn', 'Music is my canvas, and notes are my paint.', 'ROSAL');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('alup8fujqy23797fmu9klernjn8v2vzn9g50a0nh9f1d9d6u1k','tet8xap2z7d8etn', 'https://i.scdn.co/image/ab67616d0000b273efc0ef9dd996312ebaf0bf52', 'MOTOMAMI +','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vpaw9a42xngyxgknwksy87nqmcrzqa9gh1ub2gfaooawl0b7j8','DESPECH','tet8xap2z7d8etn','POP','53tfEupEzQRtVFOeZvk7xq','https://p.scdn.co/mp3-preview/304868e078d8f2c3209977997c47542181096b61?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('alup8fujqy23797fmu9klernjn8v2vzn9g50a0nh9f1d9d6u1k', 'vpaw9a42xngyxgknwksy87nqmcrzqa9gh1ub2gfaooawl0b7j8', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2xu4sblqoub7sruvhztlfxj23wzaw8t7f0inovcf9jwoq9peeq','LLYLM','tet8xap2z7d8etn','POP','2SiAcexM2p1yX6joESbehd','https://p.scdn.co/mp3-preview/6f41063b2e36fb31fbd08c39b6c56012e239365b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('alup8fujqy23797fmu9klernjn8v2vzn9g50a0nh9f1d9d6u1k', '2xu4sblqoub7sruvhztlfxj23wzaw8t7f0inovcf9jwoq9peeq', '1');
-- Andy Williams
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('a5ll0enjixf31cr', 'Andy Williams', '172@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5888acdca5e748e796b4e69b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:172@artist.com', 'a5ll0enjixf31cr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('a5ll0enjixf31cr', 'Blending genres for a fresh musical experience.', 'Andy Williams');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jjrgylkoa88e61rkysyiho75tf7s1xlpp3vqqa4p87tpu4wki7','a5ll0enjixf31cr', 'https://i.scdn.co/image/ab67616d0000b27398073965947f92f1641b8356', 'The Andy Williams Christmas Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5x5zm0q6guir18opswchqlx6vdv6ab87flqnmpvfbmzbai7rti','Its the Most Wonderful Time of the Year','a5ll0enjixf31cr','POP','5hslUAKq9I9CG2bAulFkHN','https://p.scdn.co/mp3-preview/853f441c5fc1b25ba88bb300c17119cde36da675?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jjrgylkoa88e61rkysyiho75tf7s1xlpp3vqqa4p87tpu4wki7', '5x5zm0q6guir18opswchqlx6vdv6ab87flqnmpvfbmzbai7rti', '0');
-- TAEYANG
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4vg952md4wax8vr', 'TAEYANG', '173@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb496189630cd3cb0c7b593fee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:173@artist.com', '4vg952md4wax8vr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4vg952md4wax8vr', 'A unique voice in the contemporary music scene.', 'TAEYANG');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qvbysvvit1p4uv8q1e2njnv3dgmkgh6yozf2vmc66u6y2021km','4vg952md4wax8vr', 'https://i.scdn.co/image/ab67616d0000b27346313223adf2b6d726388328', 'Down to Earth','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('szqfxxfufh5nr79ziomq6dn7rq25drgc9uwd4wpruq5red5f1k','Shoong! (feat. LISA of BLACKPINK)','4vg952md4wax8vr','POP','5HrIcZOo1DysX53qDRlRnt',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qvbysvvit1p4uv8q1e2njnv3dgmkgh6yozf2vmc66u6y2021km', 'szqfxxfufh5nr79ziomq6dn7rq25drgc9uwd4wpruq5red5f1k', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1ew64srlr5wnyarem6s0aukszgk3808zy39qwb7juhlsj5hs74','VIBE (feat. Jimin of BTS)','4vg952md4wax8vr','POP','4NIe9Is7bN5JWyTeCW2ahK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qvbysvvit1p4uv8q1e2njnv3dgmkgh6yozf2vmc66u6y2021km', '1ew64srlr5wnyarem6s0aukszgk3808zy39qwb7juhlsj5hs74', '1');
-- Tears For Fears
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ohksm04silgx65s', 'Tears For Fears', '174@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb42ed2cb48c231f545a5a3dad','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:174@artist.com', 'ohksm04silgx65s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ohksm04silgx65s', 'Pioneering new paths in the musical landscape.', 'Tears For Fears');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qv8kxkngar4fwqkhluz4eriioi0n91lq9x9hws7x0vzrp7650p','ohksm04silgx65s', 'https://i.scdn.co/image/ab67616d0000b27322463d6939fec9e17b2a6235', 'Songs From The Big Chair (Super Deluxe Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rpnvc98dfpy7vwgc0k6v0fxdaerb3oq78htf2kasuzbaqkcefd','Everybody Wants To Rule The World','ohksm04silgx65s','POP','4RvWPyQ5RL0ao9LPZeSouE',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qv8kxkngar4fwqkhluz4eriioi0n91lq9x9hws7x0vzrp7650p', 'rpnvc98dfpy7vwgc0k6v0fxdaerb3oq78htf2kasuzbaqkcefd', '0');
-- Creedence Clearwater Revival
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1fbt053pdj70iyz', 'Creedence Clearwater Revival', '175@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd2e2b04b7ba5d60b72f54506','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:175@artist.com', '1fbt053pdj70iyz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1fbt053pdj70iyz', 'An endless quest for musical perfection.', 'Creedence Clearwater Revival');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uum7a2bibjznsnbxm8aaldjozaj8qcistuomy2fjblzs3mif5t','1fbt053pdj70iyz', 'https://i.scdn.co/image/ab67616d0000b27351f311c2fb06ad2789e3ff91', 'Pendulum (Expanded Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v4zpbtd2kwt056r2qa4fsc0luao4r5uqwascatg9o8xsoqtatj','Have You Ever Seen The Rain?','1fbt053pdj70iyz','POP','2LawezPeJhN4AWuSB0GtAU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uum7a2bibjznsnbxm8aaldjozaj8qcistuomy2fjblzs3mif5t', 'v4zpbtd2kwt056r2qa4fsc0luao4r5uqwascatg9o8xsoqtatj', '0');
-- Peggy Gou
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kawl2umf3lpp2tm', 'Peggy Gou', '176@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf5c17aa075c03c5c4d2c693','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:176@artist.com', 'kawl2umf3lpp2tm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kawl2umf3lpp2tm', 'A dynamic force in the electronic music scene, known for her eclectic mixes.', 'Peggy Gou');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sfdg60piy5bpr5tvy0906sc8gsl7ma498l9t0dngad6n1qe1s9','kawl2umf3lpp2tm', 'https://i.scdn.co/image/ab67616d0000b27388d71aadd009fe1a83df88f2', '(It Goes Like) Nanana [Edit]','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3ezi2a213167nfd7aybvmqhj62v3j5lm5wxd6tilxdzaoo4wo6','(It Goes Like) Nanana - Edit','kawl2umf3lpp2tm','POP','23RoR84KodL5HWvUTneQ1w','https://p.scdn.co/mp3-preview/e36e0bd4714844f1f9d992398b41a3e333f15cc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sfdg60piy5bpr5tvy0906sc8gsl7ma498l9t0dngad6n1qe1s9', '3ezi2a213167nfd7aybvmqhj62v3j5lm5wxd6tilxdzaoo4wo6', '0');
-- Bruno Mars
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('aagzsnf91o97uiy', 'Bruno Mars', '177@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc36dd9eb55fb0db4911f25dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:177@artist.com', 'aagzsnf91o97uiy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('aagzsnf91o97uiy', 'A confluence of cultural beats and contemporary tunes.', 'Bruno Mars');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('iutlpyvc6web2m99aaojc0cdu00thr9rkmkwn9xohwhd7i93bi','aagzsnf91o97uiy', 'https://i.scdn.co/image/ab67616d0000b273926f43e7cce571e62720fd46', 'Unorthodox Jukebox','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l419ch2u2jlfy4bv3erne3ran3fvri0iv9279ynjn6grl9ddwd','Locked Out Of Heaven','aagzsnf91o97uiy','POP','3w3y8KPTfNeOKPiqUTakBh','https://p.scdn.co/mp3-preview/5a0318e6c43964786d22b9431af35490e96cff3d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('iutlpyvc6web2m99aaojc0cdu00thr9rkmkwn9xohwhd7i93bi', 'l419ch2u2jlfy4bv3erne3ran3fvri0iv9279ynjn6grl9ddwd', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gbv678g9gh9lle2r9x5k9jins3dtb9w0vo442qgtdn2pfm8drj','When I Was Your Man','aagzsnf91o97uiy','POP','0nJW01T7XtvILxQgC5J7Wh','https://p.scdn.co/mp3-preview/159fc05584217baa99581c4821f52d04670db6b2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('iutlpyvc6web2m99aaojc0cdu00thr9rkmkwn9xohwhd7i93bi', 'gbv678g9gh9lle2r9x5k9jins3dtb9w0vo442qgtdn2pfm8drj', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vlqkptpa0o805lie7pe2l7jl7u2v5didvpiypd0htibdq15zim','Just The Way You Are','aagzsnf91o97uiy','POP','7BqBn9nzAq8spo5e7cZ0dJ','https://p.scdn.co/mp3-preview/6d1a901b10c7dc609d4c8628006b04bc6e672be8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('iutlpyvc6web2m99aaojc0cdu00thr9rkmkwn9xohwhd7i93bi', 'vlqkptpa0o805lie7pe2l7jl7u2v5didvpiypd0htibdq15zim', '2');
-- Skrillex
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wmfwo2aacovfarm', 'Skrillex', '178@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb61f92702ca14484aa263a931','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:178@artist.com', 'wmfwo2aacovfarm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wmfwo2aacovfarm', 'A confluence of cultural beats and contemporary tunes.', 'Skrillex');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rr5fvfyk2d4c1vemwte8f6xlw3d342grab68jlmzwg9hg29psp','wmfwo2aacovfarm', 'https://i.scdn.co/image/ab67616d0000b2736382f06498259682f91cf981', 'Quest For Fire','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hhq3j70s30ajkwapyykakisgeewmzjmp7vws8hdwotks66qh17','Rumble','wmfwo2aacovfarm','POP','74fmYjFwt9CqEFAh8ybeBD','https://p.scdn.co/mp3-preview/eb79af9f809883de0632f02388ec354478612754?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rr5fvfyk2d4c1vemwte8f6xlw3d342grab68jlmzwg9hg29psp', 'hhq3j70s30ajkwapyykakisgeewmzjmp7vws8hdwotks66qh17', '0');
-- Linkin Park
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uv74piprun2jrk7', 'Linkin Park', '179@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb811da3b2e7c9e5a9c1a6c4f7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:179@artist.com', 'uv74piprun2jrk7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uv74piprun2jrk7', 'Striking chords that resonate across generations.', 'Linkin Park');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('obvsiccj83sgvd2geyuy9gyj3skghxfuseynfseh0qih5dqldy','uv74piprun2jrk7', 'https://i.scdn.co/image/ab67616d0000b273b4ad7ebaf4575f120eb3f193', 'Meteora','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cklfi2pq0ha1c3u33zqdfce3mstj5y9xfen1bz9taxbdelyaon','Numb','uv74piprun2jrk7','POP','2nLtzopw4rPReszdYBJU6h','https://p.scdn.co/mp3-preview/15e1178c9eb7f626ac1112ad8f56eccbec2cd6e5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('obvsiccj83sgvd2geyuy9gyj3skghxfuseynfseh0qih5dqldy', 'cklfi2pq0ha1c3u33zqdfce3mstj5y9xfen1bz9taxbdelyaon', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('89g0fqh4eis4hl88xjfj1bg2qqvdya1mmlgopbxa5i65irnsxy','In The End','uv74piprun2jrk7','POP','60a0Rd6pjrkxjPbaKzXjfq','https://p.scdn.co/mp3-preview/b5ee275ca337899f762b1c1883c11e24a04075b0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('obvsiccj83sgvd2geyuy9gyj3skghxfuseynfseh0qih5dqldy', '89g0fqh4eis4hl88xjfj1bg2qqvdya1mmlgopbxa5i65irnsxy', '1');
-- Plan B
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('afy65i3eudkd6gt', 'Plan B', '180@artist.com', 'https://i.scdn.co/image/eb21793908d1eabe0fba02659bdff4e4a4b3724a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:180@artist.com', 'afy65i3eudkd6gt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('afy65i3eudkd6gt', 'Striking chords that resonate across generations.', 'Plan B');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d1hqtbfxsd5ta7md9vjm4uukgggaihjwil4byk4ov3jz93w06o','afy65i3eudkd6gt', 'https://i.scdn.co/image/ab67616d0000b273913ef74e0272d688c512200b', 'House Of Pleasure','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8htkhiwle4vqwzcy5cddpjr0uq0erlqcss9u0wbaevkqf53thx','Es un Secreto','afy65i3eudkd6gt','POP','7JwdbqIpiuWvGbRryKSuBz','https://p.scdn.co/mp3-preview/feeeb03d75e53b19bb2e67502a1b498e87cdfef8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d1hqtbfxsd5ta7md9vjm4uukgggaihjwil4byk4ov3jz93w06o', '8htkhiwle4vqwzcy5cddpjr0uq0erlqcss9u0wbaevkqf53thx', '0');
-- Michael Bubl
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5is7eg8yg4t7qbj', 'Michael Bubl', '181@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebef8cf61fea4923d2bde68200','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:181@artist.com', '5is7eg8yg4t7qbj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5is7eg8yg4t7qbj', 'Uniting fans around the globe with universal rhythms.', 'Michael Bubl');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('stq7am8qwrw89bs6636a6ny9wra7xhedmuljqt2idyg99ic5t5','5is7eg8yg4t7qbj', 'https://i.scdn.co/image/ab67616d0000b273119e4094f07a8123b471ac1d', 'Christmas (Deluxe Special Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y5c6op6cbxuab72h88tog2aliefni8pzcs9z6rawudbu199zmo','Its Beginning To Look A Lot Like Christmas','5is7eg8yg4t7qbj','POP','5a1iz510sv2W9Dt1MvFd5R','https://p.scdn.co/mp3-preview/51f36d7e04069ef4869ea575fb21e5404710b1c4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('stq7am8qwrw89bs6636a6ny9wra7xhedmuljqt2idyg99ic5t5', 'y5c6op6cbxuab72h88tog2aliefni8pzcs9z6rawudbu199zmo', '0');
-- sped up nightcore
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fv8c89bbkh8ba8d', 'sped up nightcore', '182@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb54f60615e528d62665ef1d14','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:182@artist.com', 'fv8c89bbkh8ba8d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fv8c89bbkh8ba8d', 'Creating a tapestry of tunes that celebrates diversity.', 'sped up nightcore');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pyx52hz733jw9lee3b4aqp4tvfb2k3640nvf4h3nrdr4djidhi','fv8c89bbkh8ba8d', NULL, 'sped up nightcore Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bzfwhq5cj5r1tox0jq90e6wa9v3eitrhlkfo9z7nceug3iaeel','Watch This - ARIZONATEARS Pluggnb Remix','fv8c89bbkh8ba8d','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pyx52hz733jw9lee3b4aqp4tvfb2k3640nvf4h3nrdr4djidhi', 'bzfwhq5cj5r1tox0jq90e6wa9v3eitrhlkfo9z7nceug3iaeel', '0');
-- Sebastian Yatra
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('iut569ylc1s3csz', 'Sebastian Yatra', '183@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb650a498358171e1990efeeff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:183@artist.com', 'iut569ylc1s3csz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('iut569ylc1s3csz', 'A unique voice in the contemporary music scene.', 'Sebastian Yatra');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t02u3o5t5fkem51z6s5t0b6gag813ry1b37l3ohqki64po1k7x','iut569ylc1s3csz', 'https://i.scdn.co/image/ab67616d0000b2732d6016751b8ea5e66e83cd04', 'VAGABUNDO','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v1od7w9knwbyoqwa0o76guqpjzd6tjnni7wsca8d5gdml6pc49','VAGABUNDO','iut569ylc1s3csz','POP','1MB8kTH7VKvAMfL9SHgJmG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t02u3o5t5fkem51z6s5t0b6gag813ry1b37l3ohqki64po1k7x', 'v1od7w9knwbyoqwa0o76guqpjzd6tjnni7wsca8d5gdml6pc49', '0');
-- R
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('36081o8cj559esd', 'R', '184@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6334ab6a83196f36475ada7f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:184@artist.com', '36081o8cj559esd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('36081o8cj559esd', 'Breathing new life into classic genres.', 'R');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('azfsca6v885b5noje1suw1sqlyk1nvnf0wv9smz7hu9bczhtol','36081o8cj559esd', 'https://i.scdn.co/image/ab67616d0000b273a3a7f38ea2033aa501afd4cf', 'Calm Down (with Selena Gomez)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('malzuf7pt2sjljm36t0c2rv5iw2n8ctc2drhod18nwjb0riysv','Calm Down','36081o8cj559esd','POP','0WtM2NBVQNNJLh6scP13H8',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('azfsca6v885b5noje1suw1sqlyk1nvnf0wv9smz7hu9bczhtol', 'malzuf7pt2sjljm36t0c2rv5iw2n8ctc2drhod18nwjb0riysv', '0');
-- James Blake
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lqzw9dqdupzl4hp', 'James Blake', '185@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb93fe5fc8fdb5a98248911a07','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:185@artist.com', 'lqzw9dqdupzl4hp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lqzw9dqdupzl4hp', 'A sonic adventurer, always seeking new horizons in music.', 'James Blake');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ku8xva8p162wht6fxg2ofo1dvvmp8qg3b1clgzprpp8ybwcnfl','lqzw9dqdupzl4hp', NULL, 'James Blake Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dmfb4jqeld6liq0hgqvf3511xs5e25cd63mfr2n7qssgs0tbvj','Hummingbird (Metro Boomin & James Blake)','lqzw9dqdupzl4hp','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ku8xva8p162wht6fxg2ofo1dvvmp8qg3b1clgzprpp8ybwcnfl', 'dmfb4jqeld6liq0hgqvf3511xs5e25cd63mfr2n7qssgs0tbvj', '0');
-- Adele
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xrnz0796tnwfot4', 'Adele', '186@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68f6e5892075d7f22615bd17','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:186@artist.com', 'xrnz0796tnwfot4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xrnz0796tnwfot4', 'Crafting a unique sonic identity in every track.', 'Adele');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vegm1irlm1zo6tdfx6k8dfujdqd0catve404sqyw7xu6lc6aci','xrnz0796tnwfot4', 'https://i.scdn.co/image/ab67616d0000b2732118bf9b198b05a95ded6300', '21','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jkijtrorbaww5i9odeigsvcmt0okiu0ip0zj9cxp3zc6qxrs9b','Set Fire to the Rain','xrnz0796tnwfot4','POP','73CMRj62VK8nUS4ezD2wvi','https://p.scdn.co/mp3-preview/6fc68c105e091645376471727960d2ba3cd0ee01?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vegm1irlm1zo6tdfx6k8dfujdqd0catve404sqyw7xu6lc6aci', 'jkijtrorbaww5i9odeigsvcmt0okiu0ip0zj9cxp3zc6qxrs9b', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t0erpjo3hyxehrijzoq71go5xymfvwxphxn7qw5r7lnzt03pqh','Easy On Me','xrnz0796tnwfot4','POP','46IZ0fSY2mpAiktS3KOqds','https://p.scdn.co/mp3-preview/a0cd8077c79a4aa3dcaa68bbc5ecdeda46e8d13f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vegm1irlm1zo6tdfx6k8dfujdqd0catve404sqyw7xu6lc6aci', 't0erpjo3hyxehrijzoq71go5xymfvwxphxn7qw5r7lnzt03pqh', '1');
-- Kanii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xj84bszgk1bw8l4', 'Kanii', '187@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb777f2bab9e5f1e343c3126d4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:187@artist.com', 'xj84bszgk1bw8l4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xj84bszgk1bw8l4', 'The heartbeat of a new generation of music lovers.', 'Kanii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nrksegkc87qgptejod3uq3n3xyy1kgmgekp9lr49m3smvm1mo7','xj84bszgk1bw8l4', 'https://i.scdn.co/image/ab67616d0000b273efae10889cd442784f3acd3d', 'I Know (PR1SVX Edit)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pqzvx41rsmfvwi3ezuql7kek2iusds4djy0wsxxtj1s97dh4hc','I Know - PR1SVX Edit','xj84bszgk1bw8l4','POP','3vcLw8QA3yCOkrj9oLSZNs','https://p.scdn.co/mp3-preview/146ad1bb65b8f9b097f356d2d5758657a06466dc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nrksegkc87qgptejod3uq3n3xyy1kgmgekp9lr49m3smvm1mo7', 'pqzvx41rsmfvwi3ezuql7kek2iusds4djy0wsxxtj1s97dh4hc', '0');
-- Ana Castela
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('o0d4fb3nz2hl5o6', 'Ana Castela', '188@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26abde7ba3cfdfb8c1900baf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:188@artist.com', 'o0d4fb3nz2hl5o6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('o0d4fb3nz2hl5o6', 'A beacon of innovation in the world of sound.', 'Ana Castela');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1cz3a6uhpueiyvghgplv56hsmqdezshbtjad8e4icsnd6q80ea','o0d4fb3nz2hl5o6', NULL, 'Ana Castela Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v9ua63o4009evydx785v8gyotj3dii76mxxisw801ts15wwgc1','Nosso Quadro','o0d4fb3nz2hl5o6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1cz3a6uhpueiyvghgplv56hsmqdezshbtjad8e4icsnd6q80ea', 'v9ua63o4009evydx785v8gyotj3dii76mxxisw801ts15wwgc1', '0');
-- Quevedo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d5mystn7d761gns', 'Quevedo', '189@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2394e996716534bc2c937a1a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:189@artist.com', 'd5mystn7d761gns', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('d5mystn7d761gns', 'Merging lyrical depth with compelling urban beats.', 'Quevedo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hqo2bimcdq7z1w1z9gqdkrvlbdxuddl10818dlx3tdk82e2uyq','d5mystn7d761gns', 'https://i.scdn.co/image/ab67616d0000b273a00a817b017c6f6bf8460be9', 'Columbia','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('padww4zufk4i2qfgml0c583d0lihv4f91zpht2len5a7d88bwb','Columbia','d5mystn7d761gns','POP','6XbtvPmIpyCbjuT0e8cQtp','https://p.scdn.co/mp3-preview/e3d6df66fe67f618166a2cab858580ac8a96486a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hqo2bimcdq7z1w1z9gqdkrvlbdxuddl10818dlx3tdk82e2uyq', 'padww4zufk4i2qfgml0c583d0lihv4f91zpht2len5a7d88bwb', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wvdeq98vscdebzysfzn4z2vjoup9jalkppscgd8msbt083ui3e','Punto G','d5mystn7d761gns','POP','4WiQA1AGWHFvaxBU6bHghs','https://p.scdn.co/mp3-preview/a1275d1dcfb4c25bc48821b19b81ff853386c148?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hqo2bimcdq7z1w1z9gqdkrvlbdxuddl10818dlx3tdk82e2uyq', 'wvdeq98vscdebzysfzn4z2vjoup9jalkppscgd8msbt083ui3e', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('90i5a86ck5fnea66zbeoe4abpf5o6gk9iilg68k4j584gpmg3h','Mami Chula','d5mystn7d761gns','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hqo2bimcdq7z1w1z9gqdkrvlbdxuddl10818dlx3tdk82e2uyq', '90i5a86ck5fnea66zbeoe4abpf5o6gk9iilg68k4j584gpmg3h', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bytmrtmdppykzsf8f2c2by70ilyoz3pp5t22deh4tzz9k5ruu2','WANDA','d5mystn7d761gns','POP','0Iozrbed8spxoBnmtBMshO','https://p.scdn.co/mp3-preview/a6de4c6031032d886d67e88ec6db1a1c521ed023?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hqo2bimcdq7z1w1z9gqdkrvlbdxuddl10818dlx3tdk82e2uyq', 'bytmrtmdppykzsf8f2c2by70ilyoz3pp5t22deh4tzz9k5ruu2', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5hrv549n5wsvgnwvwrukwmzj98fk28kfj1fv1pgu2lsikqb6tq','Vista Al Mar','d5mystn7d761gns','POP','5q86iSKkBtOoNkdgEDY5WV','https://p.scdn.co/mp3-preview/6896535fbb6690492102bdb7ca181f33de63ef4e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hqo2bimcdq7z1w1z9gqdkrvlbdxuddl10818dlx3tdk82e2uyq', '5hrv549n5wsvgnwvwrukwmzj98fk28kfj1fv1pgu2lsikqb6tq', '4');
-- The Weeknd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dyz8z4od6yo4781', 'The Weeknd', '190@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:190@artist.com', 'dyz8z4od6yo4781', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dyz8z4od6yo4781', 'A trailblazer in the world of R&B, constantly redefining the genre.', 'The Weeknd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g','dyz8z4od6yo4781', NULL, 'Karaoke Picks Vol. 130','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zlz2hwr8yv91xtnyii8s41egl6u7lt9dae5iscac1wkku9l2r6','Popular (with Playboi Carti & Madonna) - The Idol Vol. 1 (Music from the HBO Original Series)','dyz8z4od6yo4781','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g', 'zlz2hwr8yv91xtnyii8s41egl6u7lt9dae5iscac1wkku9l2r6', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ttisb34av7wrc4b3fbhlne3b8youm0o4k0fekz64p2ludxjumo','Creepin','dyz8z4od6yo4781','POP','0GVaOXDGwtnH8gCURYyEaK','https://p.scdn.co/mp3-preview/a2b11e2f0cb8ef4a0316a686e73da9ec2b203e6e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g', 'ttisb34av7wrc4b3fbhlne3b8youm0o4k0fekz64p2ludxjumo', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3e4oq81ien4diygtu15uj8e883qrtlegznlej5r8vnuckye30s','Die For You','dyz8z4od6yo4781','POP','2LBqCSwhJGcFQeTHMVGwy3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g', '3e4oq81ien4diygtu15uj8e883qrtlegznlej5r8vnuckye30s', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qdj60cq463oppcohhk8svaabe66a87uza5d16vvsz6182r6y0l','Starboy','dyz8z4od6yo4781','POP','7MXVkk9YMctZqd1Srtv4MB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g', 'qdj60cq463oppcohhk8svaabe66a87uza5d16vvsz6182r6y0l', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2bleso5j9cr57q0jmywiekjorhyow0ejavf9xtldcsfntqvng2','Blinding Lights','dyz8z4od6yo4781','POP','0VjIjW4GlUZAMYd2vXMi3b',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g', '2bleso5j9cr57q0jmywiekjorhyow0ejavf9xtldcsfntqvng2', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('57y2hnk80wyqxq7sfhgcepfejws9mbg8305w77jamgzqtgtxe7','Stargirl Interlude','dyz8z4od6yo4781','POP','5gDWsRxpJ2lZAffh5p7K0w',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g', '57y2hnk80wyqxq7sfhgcepfejws9mbg8305w77jamgzqtgtxe7', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a1e2nk8b9h28yuzbm91wwojf1npnba5ibnpna4ta85m4o2xjmh','Save Your Tears','dyz8z4od6yo4781','POP','5QO79kh1waicV47BqGRL3g',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g', 'a1e2nk8b9h28yuzbm91wwojf1npnba5ibnpna4ta85m4o2xjmh', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('467no6tsztu9xj6raaczkd4jrkrgzd5fwtvtdxm77zogtqv9vj','Reminder','dyz8z4od6yo4781','POP','37F0uwRSrdzkBiuj0D5UHI',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g', '467no6tsztu9xj6raaczkd4jrkrgzd5fwtvtdxm77zogtqv9vj', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y1gqgf8gf7tlsrsnoy8zoa5dnob4pnt07xj4lbn81rh6vd25vd','Double Fantasy (with Future)','dyz8z4od6yo4781','POP','4VMRsbfZzd3SfQtaJ1Wpwi',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g', 'y1gqgf8gf7tlsrsnoy8zoa5dnob4pnt07xj4lbn81rh6vd25vd', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('280vbp3fxyt1d8ldft9mvgynlvaq9r639lgddz5fa2je37ri23','I Was Never There','dyz8z4od6yo4781','POP','1cKHdTo9u0ZymJdPGSh6nq',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g', '280vbp3fxyt1d8ldft9mvgynlvaq9r639lgddz5fa2je37ri23', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oebquvztz9i4lmewzw88ewj5t0s8vof568p1vo0mwgh517uea2','Call Out My Name','dyz8z4od6yo4781','POP','09mEdoA6zrmBPgTEN5qXmN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g', 'oebquvztz9i4lmewzw88ewj5t0s8vof568p1vo0mwgh517uea2', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pm3ad5y071i66pfcgruic55kc0fiv4dcnfiykm6dks4kfih1fr','The Hills','dyz8z4od6yo4781','POP','7fBv7CLKzipRk6EC6TWHOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g', 'pm3ad5y071i66pfcgruic55kc0fiv4dcnfiykm6dks4kfih1fr', '11');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tnfivcf3kjh280v7vvhklidixl381b3w73dcqforxuuycj6xqx','After Hours','dyz8z4od6yo4781','POP','2p8IUWQDrpjuFltbdgLOag',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ctom7i7h4096shwucxdjvnhyi0h7sog8homvj6clljwbw8t16g', 'tnfivcf3kjh280v7vvhklidixl381b3w73dcqforxuuycj6xqx', '12');
-- Mac DeMarco
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ztgsgm500z2hj1t', 'Mac DeMarco', '191@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3cef7752073cbbd2cc04c6f0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:191@artist.com', 'ztgsgm500z2hj1t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ztgsgm500z2hj1t', 'Pioneering new paths in the musical landscape.', 'Mac DeMarco');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('z7gbvyxxgq5imxmxfb3cuhsml9ndrx1i8ovyikg9tv8rya0i0y','ztgsgm500z2hj1t', 'https://i.scdn.co/image/ab67616d0000b273fa1323bb50728c7489980672', 'Here Comes The Cowboy','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6alxmr0fh95bmgngz0rzg7grack9rq1az7ynfu7ctxtd7dj668','Heart To Heart','ztgsgm500z2hj1t','POP','7EAMXbLcL0qXmciM5SwMh2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z7gbvyxxgq5imxmxfb3cuhsml9ndrx1i8ovyikg9tv8rya0i0y', '6alxmr0fh95bmgngz0rzg7grack9rq1az7ynfu7ctxtd7dj668', '0');
-- Junior H
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gd7qg6by9jv4jc6', 'Junior H', '192@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5ccab5d3dc10a08d89cbd76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:192@artist.com', 'gd7qg6by9jv4jc6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gd7qg6by9jv4jc6', 'A fresh voice in regional Mexican music, blending tradition with modernity.', 'Junior H');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e9fr2za8qaymm0mmnftp8vxvtirf3z00xrnxx5aby4j6zb29ri','gd7qg6by9jv4jc6', 'https://i.scdn.co/image/ab67616d0000b27333ed356efed99b158c4267c6', 'El Azul','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('huperpqolhh5jz71avams8txh6wfer9r9d56ug2jfqsfxlj5vb','El Azul','gd7qg6by9jv4jc6','POP','1haJsMtoBhHfvuM7XWuT3W','https://p.scdn.co/mp3-preview/f9df136c3a2d3c0c5424e2c4b75a303f35c08af5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e9fr2za8qaymm0mmnftp8vxvtirf3z00xrnxx5aby4j6zb29ri', 'huperpqolhh5jz71avams8txh6wfer9r9d56ug2jfqsfxlj5vb', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4kcxxq8r78cb73kars8tva93sw8sfaag3u9ohghsijbm4x9dyv','LUNA','gd7qg6by9jv4jc6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e9fr2za8qaymm0mmnftp8vxvtirf3z00xrnxx5aby4j6zb29ri', '4kcxxq8r78cb73kars8tva93sw8sfaag3u9ohghsijbm4x9dyv', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('liq2xhfu1bwfjky3zg6er94ippe3u3q8jfm37qsp8pwqxaea40','Abcdario','gd7qg6by9jv4jc6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e9fr2za8qaymm0mmnftp8vxvtirf3z00xrnxx5aby4j6zb29ri', 'liq2xhfu1bwfjky3zg6er94ippe3u3q8jfm37qsp8pwqxaea40', '2');
-- Niall Horan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yaw9rqhildf0g15', 'Niall Horan', '193@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeccc1cde8e9fdcf1c9289897','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:193@artist.com', 'yaw9rqhildf0g15', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yaw9rqhildf0g15', 'Pioneering new paths in the musical landscape.', 'Niall Horan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('k0b46twy3pr1l0mcl3o8rh9n9mzso2g326z8pm5j1nceqzx1tz','yaw9rqhildf0g15', 'https://i.scdn.co/image/ab67616d0000b2732a368fea49f5c489a9dc3949', 'The Show','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lcdgwtwh80fkza73g1pzc6kimngiup7p33ysk52dgfgceykr1q','Heaven','yaw9rqhildf0g15','POP','5FQ77Cl1ndljtwwImdtjMy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k0b46twy3pr1l0mcl3o8rh9n9mzso2g326z8pm5j1nceqzx1tz', 'lcdgwtwh80fkza73g1pzc6kimngiup7p33ysk52dgfgceykr1q', '0');
-- Kaliii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y72womfdfel1ofy', 'Kaliii', '194@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb749bcc7f4b8d1d60f5f13744','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:194@artist.com', 'y72womfdfel1ofy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y72womfdfel1ofy', 'Igniting the stage with electrifying performances.', 'Kaliii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e8ave8nw3nmyocmt8ubsdld3utvfxjprci5up46k9z49f74mnd','y72womfdfel1ofy', 'https://i.scdn.co/image/ab67616d0000b2733eecc265c134153c14794aab', 'Area Codes','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('udzg28hut04xq4zu243z3ft9m9cgjeuzo5472ev24hzafqfjo9','Area Codes','y72womfdfel1ofy','POP','7sliFe6W30tPBPh6dvZsIH','https://p.scdn.co/mp3-preview/d1beed2734f948ec9c33164d3aa818e04f4afd30?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e8ave8nw3nmyocmt8ubsdld3utvfxjprci5up46k9z49f74mnd', 'udzg28hut04xq4zu243z3ft9m9cgjeuzo5472ev24hzafqfjo9', '0');
-- Bellakath
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('07yg31sgeci16vn', 'Bellakath', '195@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb008a12ca09c3acec7c536d53','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:195@artist.com', '07yg31sgeci16vn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('07yg31sgeci16vn', 'The architect of aural landscapes that inspire and captivate.', 'Bellakath');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('n2d5rm28vp8lbdgkulhya10anjtqe8kdtg4v9awdd63etyb1xq','07yg31sgeci16vn', 'https://i.scdn.co/image/ab67616d0000b273584e78471da03acbc05dde0b', 'Gatita','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7b0nuxp14naovvi5bo0n2vh6s2fog013fx8kpv7i655rthzn5a','Gatita','07yg31sgeci16vn','POP','4ilZV1WNjL7IxwE81OnaRY','https://p.scdn.co/mp3-preview/ed363508374055584f0a42a003473c065fbe4f61?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n2d5rm28vp8lbdgkulhya10anjtqe8kdtg4v9awdd63etyb1xq', '7b0nuxp14naovvi5bo0n2vh6s2fog013fx8kpv7i655rthzn5a', '0');
-- Bad Bunny
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gdh4x1uz5w1p0y3', 'Bad Bunny', '196@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9ad50e478a469448c6f369df','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:196@artist.com', 'gdh4x1uz5w1p0y3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gdh4x1uz5w1p0y3', 'A trailblazer in Latin trap and reggaeton, known for his charismatic style and innovative music.', 'Bad Bunny');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fcujhseil4r4kk1dd7kinoknnqd8vsv3yespgbfqz9cfw56ono','gdh4x1uz5w1p0y3', 'https://i.scdn.co/image/ab67616d0000b273ab5c9cd818ad6ed3e9b79cd1', 'WHERE SHE GOES','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xwxnitoch8b7xbevdv00n2p6h9sqcttxazzb14aofcf8muqmef','WHERE SHE GOES','gdh4x1uz5w1p0y3','POP','7ro0hRteUMfnOioTFI5TG1','https://p.scdn.co/mp3-preview/b9b7e4c982b33ee23c4867f7a3025e3598c35760?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fcujhseil4r4kk1dd7kinoknnqd8vsv3yespgbfqz9cfw56ono', 'xwxnitoch8b7xbevdv00n2p6h9sqcttxazzb14aofcf8muqmef', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0j66sbaub01sr7lahlswzzr2wy9t3kvhzdjj3zr7sna99jypu8','un x100to','gdh4x1uz5w1p0y3','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fcujhseil4r4kk1dd7kinoknnqd8vsv3yespgbfqz9cfw56ono', '0j66sbaub01sr7lahlswzzr2wy9t3kvhzdjj3zr7sna99jypu8', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rbpeb3zf7v16zq34d6jkcs0vxh5aejc59jhrxaos7wlryvwnb9','Coco Chanel','gdh4x1uz5w1p0y3','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fcujhseil4r4kk1dd7kinoknnqd8vsv3yespgbfqz9cfw56ono', 'rbpeb3zf7v16zq34d6jkcs0vxh5aejc59jhrxaos7wlryvwnb9', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cevc2sjoye5s4jwz3pahlmbk4mgu38klffat0tpg78xg7gviob','Titi Me Pregunt','gdh4x1uz5w1p0y3','POP','1IHWl5LamUGEuP4ozKQSXZ','https://p.scdn.co/mp3-preview/53a6217761f8fdfcff92189cafbbd1cc21fdb813?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fcujhseil4r4kk1dd7kinoknnqd8vsv3yespgbfqz9cfw56ono', 'cevc2sjoye5s4jwz3pahlmbk4mgu38klffat0tpg78xg7gviob', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p15gbh3t6u0b8gxgzsksaiaa0hdmlucb80dl882sn89zsp02y6','Efecto','gdh4x1uz5w1p0y3','POP','5Eax0qFko2dh7Rl2lYs3bx','https://p.scdn.co/mp3-preview/a622a47c8df98ef72676608511c0b2e1d5d51268?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fcujhseil4r4kk1dd7kinoknnqd8vsv3yespgbfqz9cfw56ono', 'p15gbh3t6u0b8gxgzsksaiaa0hdmlucb80dl882sn89zsp02y6', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q4n0bzjhkihl8sqabt52l3khmzm5iuautqxhfv9hy1f14akon7','Neverita','gdh4x1uz5w1p0y3','POP','31i56LZnwE6uSu3exoHjtB','https://p.scdn.co/mp3-preview/b50a3cafa2eb688f811d4079812649bfba050417?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fcujhseil4r4kk1dd7kinoknnqd8vsv3yespgbfqz9cfw56ono', 'q4n0bzjhkihl8sqabt52l3khmzm5iuautqxhfv9hy1f14akon7', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cchvigtanf654ancuxutzgq0zlw2mmxlr1x422a6q11wbfoll8','Moscow Mule','gdh4x1uz5w1p0y3','POP','6Xom58OOXk2SoU711L2IXO','https://p.scdn.co/mp3-preview/77b12f38abcff65705166d67b5657f70cd890635?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fcujhseil4r4kk1dd7kinoknnqd8vsv3yespgbfqz9cfw56ono', 'cchvigtanf654ancuxutzgq0zlw2mmxlr1x422a6q11wbfoll8', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g5l5br3u1zca7xnmm4o6yq01nwtnwomh9lq6jy5zvkg9gmdt6j','Yonaguni','gdh4x1uz5w1p0y3','POP','2JPLbjOn0wPCngEot2STUS','https://p.scdn.co/mp3-preview/cbade9b0e669565ac8c7c07490f961e4c471b9ee?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fcujhseil4r4kk1dd7kinoknnqd8vsv3yespgbfqz9cfw56ono', 'g5l5br3u1zca7xnmm4o6yq01nwtnwomh9lq6jy5zvkg9gmdt6j', '7');
-- Meghan Trainor
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('i6crkfv9kja2yh1', 'Meghan Trainor', '197@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4d8f97058ff993df0f4eb9ee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:197@artist.com', 'i6crkfv9kja2yh1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('i6crkfv9kja2yh1', 'Creating a tapestry of tunes that celebrates diversity.', 'Meghan Trainor');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ihjhxgybwdl9342wxc9yuiv03v11ljchae4pizdvwcmlqee3n2','i6crkfv9kja2yh1', 'https://i.scdn.co/image/ab67616d0000b2731a4f1ada93881da4ca8060ff', 'Takin It Back','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cc364p8cx9x406nkokp6efwd0yfeobpv961c9w8vg4ok7i71sy','Made You Look','i6crkfv9kja2yh1','POP','0QHEIqNKsMoOY5urbzN48u','https://p.scdn.co/mp3-preview/f0eb89945aa820c0f30b5e97f8e2cab42d9f0a99?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ihjhxgybwdl9342wxc9yuiv03v11ljchae4pizdvwcmlqee3n2', 'cc364p8cx9x406nkokp6efwd0yfeobpv961c9w8vg4ok7i71sy', '0');
-- Mambo Kingz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w4tejlketk0j0bo', 'Mambo Kingz', '198@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb881ed0aa97cc8420685dc90e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:198@artist.com', 'w4tejlketk0j0bo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w4tejlketk0j0bo', 'Crafting a unique sonic identity in every track.', 'Mambo Kingz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ezdgge0ppszd66m995d4r2djh5tweapcuco3edp5xzyksgmo4s','w4tejlketk0j0bo', NULL, 'Mambo Kingz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lyghj9psriq65vuoxb0p5ppc1lgs2vc9umgg8fkigw9gztwq4j','Mejor Que Yo','w4tejlketk0j0bo','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ezdgge0ppszd66m995d4r2djh5tweapcuco3edp5xzyksgmo4s', 'lyghj9psriq65vuoxb0p5ppc1lgs2vc9umgg8fkigw9gztwq4j', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v30glqibrmww00xlefe1jtjkdni2zyeak9knyq6dh9i7q1z474','Mas Rica Que Ayer','w4tejlketk0j0bo','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ezdgge0ppszd66m995d4r2djh5tweapcuco3edp5xzyksgmo4s', 'v30glqibrmww00xlefe1jtjkdni2zyeak9knyq6dh9i7q1z474', '1');
-- Harry Styles
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uha70uobs4zi1d9', 'Harry Styles', '199@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf7db7c8ede90a019c54590bb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:199@artist.com', 'uha70uobs4zi1d9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uha70uobs4zi1d9', 'Defining modern pop-rock with his charismatic presence and bold choices.', 'Harry Styles');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uvdzklnetjex0s8gy57t9tsa7nvq07fx6mjw3kmj8nlcedaq6x','uha70uobs4zi1d9', 'https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0', 'Harrys House','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k9p0gbozavrj6r1nc6290i5qf9rhjgq6zmnfjhstvylqaeaw5t','As It Was','uha70uobs4zi1d9','POP','4Dvkj6JhhA12EX05fT7y2e','https://p.scdn.co/mp3-preview/c43dd07043b29e800c1a65b3a0102861fa3cf418?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uvdzklnetjex0s8gy57t9tsa7nvq07fx6mjw3kmj8nlcedaq6x', 'k9p0gbozavrj6r1nc6290i5qf9rhjgq6zmnfjhstvylqaeaw5t', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('juclmebks3etdezgkz1iag6p5bn1307qerus6dkr5yw8jlnwc4','Watermelon Sugar','uha70uobs4zi1d9','POP','6UelLqGlWMcVH1E5c4H7lY','https://p.scdn.co/mp3-preview/824cd58da2e9a15eeaaa6746becc09093547a09b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uvdzklnetjex0s8gy57t9tsa7nvq07fx6mjw3kmj8nlcedaq6x', 'juclmebks3etdezgkz1iag6p5bn1307qerus6dkr5yw8jlnwc4', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('59sb040zc34gxswkeqgtrixj8pvav7o1d2okrw847l729v4z0f','Late Night Talking','uha70uobs4zi1d9','POP','1qEmFfgcLObUfQm0j1W2CK','https://p.scdn.co/mp3-preview/50f056e2ab4a1bef762661dbbf2da751beeffe39?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uvdzklnetjex0s8gy57t9tsa7nvq07fx6mjw3kmj8nlcedaq6x', '59sb040zc34gxswkeqgtrixj8pvav7o1d2okrw847l729v4z0f', '2');
-- James Hype
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v92l3u2oxuxsbb9', 'James Hype', '200@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3735de17f641144240511000','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:200@artist.com', 'v92l3u2oxuxsbb9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v92l3u2oxuxsbb9', 'A maestro of melodies, orchestrating auditory bliss.', 'James Hype');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kl9659qzlxf14t49wsh9yti7ovhcn7tm5p9dviw8w6mpsipor6','v92l3u2oxuxsbb9', 'https://i.scdn.co/image/ab67616d0000b2736cc861b5c9c7cdef61b010b4', 'Ferrari','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s2xkriruncofvn1vvdrzgu93o6wsuhx9kzsctz8mmivvcpk973','Ferrari','v92l3u2oxuxsbb9','POP','4zN21mbAuaD0WqtmaTZZeP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kl9659qzlxf14t49wsh9yti7ovhcn7tm5p9dviw8w6mpsipor6', 's2xkriruncofvn1vvdrzgu93o6wsuhx9kzsctz8mmivvcpk973', '0');
-- Semicenk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('aeynqh3jm3cnn1o', 'Semicenk', '201@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf35dea329601372a4d84652e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:201@artist.com', 'aeynqh3jm3cnn1o', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('aeynqh3jm3cnn1o', 'A sonic adventurer, always seeking new horizons in music.', 'Semicenk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j3m8zvvim8zvo18i3ypssqwkimmb8hovn4rzb2fibx21dlhup6','aeynqh3jm3cnn1o', NULL, 'Semicenk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1sf1fa2v8rnqoz63hwwphuugvjm4syg6rdrhf08pl0wwvumynw','Piman De','aeynqh3jm3cnn1o','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j3m8zvvim8zvo18i3ypssqwkimmb8hovn4rzb2fibx21dlhup6', '1sf1fa2v8rnqoz63hwwphuugvjm4syg6rdrhf08pl0wwvumynw', '0');
-- Bomba Estreo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('l0gr5pbazajn79p', 'Bomba Estreo', '202@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcc4d7c642f167846d8aa743b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:202@artist.com', 'l0gr5pbazajn79p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('l0gr5pbazajn79p', 'Weaving lyrical magic into every song.', 'Bomba Estreo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6ccb9dz3rjock6q36ah5scjuowp3ixuinydlwflcrzzk3rgqi9','l0gr5pbazajn79p', NULL, 'Bomba Estreo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t1g9ccyifkchrx3ilca2rp0cx5qjurhuwk96b920beis7vrng5','Ojitos Lindos','l0gr5pbazajn79p','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6ccb9dz3rjock6q36ah5scjuowp3ixuinydlwflcrzzk3rgqi9', 't1g9ccyifkchrx3ilca2rp0cx5qjurhuwk96b920beis7vrng5', '0');
-- Sean Paul
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bqtrmoe0efnynnz', 'Sean Paul', '203@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb60c3e9abe7327c0097738f22','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:203@artist.com', 'bqtrmoe0efnynnz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bqtrmoe0efnynnz', 'Harnessing the power of melody to tell compelling stories.', 'Sean Paul');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('f88p0veb3npof7d7dnroua0l0ps29qsityoyj4b64j2vjvq3kw','bqtrmoe0efnynnz', NULL, 'Sean Paul Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1nmr78b0jxm7vc17jskm8qdpowy0lqyonyp976fglhan5ywu7h','Nia Bo','bqtrmoe0efnynnz','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f88p0veb3npof7d7dnroua0l0ps29qsityoyj4b64j2vjvq3kw', '1nmr78b0jxm7vc17jskm8qdpowy0lqyonyp976fglhan5ywu7h', '0');
-- Twisted
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('egr28wr75do4vsw', 'Twisted', '204@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2615ef39cf9128c447b31619','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:204@artist.com', 'egr28wr75do4vsw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('egr28wr75do4vsw', 'A beacon of innovation in the world of sound.', 'Twisted');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wutg66pe76ir3aay8pg4l90gynxjb0ajyhjthxtg6ft9z0pew7','egr28wr75do4vsw', 'https://i.scdn.co/image/ab67616d0000b273f5e2ffd88f07e55f34c361c8', 'WORTH NOTHING (feat. Oliver Tree) [Fast & Furious: Drift Tape/Phonk Vol 1]','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gss6l4n43knfgeegi73p8v5xc4px251qs4nvvavki26yc0g2vz','WORTH NOTHING','egr28wr75do4vsw','POP','3PjbA0O5olhampPMdaB0V1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wutg66pe76ir3aay8pg4l90gynxjb0ajyhjthxtg6ft9z0pew7', 'gss6l4n43knfgeegi73p8v5xc4px251qs4nvvavki26yc0g2vz', '0');
-- Calvin Harris
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bx0c1qas0n1k9af', 'Calvin Harris', '205@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb37bff6aa1d42bede9048750f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:205@artist.com', 'bx0c1qas0n1k9af', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bx0c1qas0n1k9af', 'Harnessing the power of melody to tell compelling stories.', 'Calvin Harris');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1c02o0teg5asaysbjlzlacmcq7aa7lv30fsew012gm7cb6jipo','bx0c1qas0n1k9af', 'https://i.scdn.co/image/ab67616d0000b273c58e22815048f8dfb1aa8bd0', 'Miracle (with Ellie Goulding)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2hhp96rsivgwpkqd709ho25err3dmw0qzgkpt5vy76u0hnn2ym','Miracle (with Ellie Goulding)','bx0c1qas0n1k9af','POP','5eTaQYBE1yrActixMAeLcZ','https://p.scdn.co/mp3-preview/48a88093bc85e735791115290125fc354f8ed068?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1c02o0teg5asaysbjlzlacmcq7aa7lv30fsew012gm7cb6jipo', '2hhp96rsivgwpkqd709ho25err3dmw0qzgkpt5vy76u0hnn2ym', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yu4iewlm4q349idabvhrums56hl0f8wxpzc3ymjhf8peh3pdps','One Kiss (with Dua Lipa)','bx0c1qas0n1k9af','POP','7ef4DlsgrMEH11cDZd32M6','https://p.scdn.co/mp3-preview/0c09da1fe6f1da091c05057835e6be2312e2dc18?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1c02o0teg5asaysbjlzlacmcq7aa7lv30fsew012gm7cb6jipo', 'yu4iewlm4q349idabvhrums56hl0f8wxpzc3ymjhf8peh3pdps', '1');
-- Tisto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hhmr3blycomr76y', 'Tisto', '206@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7afd1dcf8bc34612f16ee39c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:206@artist.com', 'hhmr3blycomr76y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hhmr3blycomr76y', 'A tapestry of rhythms that echo the pulse of life.', 'Tisto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gdgwdufl50aokls3pk0ltv1ailqchqpzlyewp83mo2frqh0z5f','hhmr3blycomr76y', NULL, 'Tisto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0qawf1q6tcocm5nxrqpczhc3ppm9i0yvrndpf2nugzap80s7nb','10:35','hhmr3blycomr76y','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gdgwdufl50aokls3pk0ltv1ailqchqpzlyewp83mo2frqh0z5f', '0qawf1q6tcocm5nxrqpczhc3ppm9i0yvrndpf2nugzap80s7nb', '0');
-- Kenia OS
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('otacg3fulmx5a8t', 'Kenia OS', '207@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7cee297b5eaaa121f9558d7e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:207@artist.com', 'otacg3fulmx5a8t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('otacg3fulmx5a8t', 'Crafting soundscapes that transport listeners to another world.', 'Kenia OS');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('p9xq9o12kpb1jowtpllpqgv5xmwuhq9ic2p5ns4es3rb87vmw4','otacg3fulmx5a8t', 'https://i.scdn.co/image/ab67616d0000b2739afe5698b0a9559dabc44ac8', 'K23','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zmutmjr451rg5y3nzbmmh6ln9gh809yu3j41qp2e0zcrd3esr2','Malas Decisiones','otacg3fulmx5a8t','POP','6Xj014IHwbLVjiVT6H89on','https://p.scdn.co/mp3-preview/9a71f09b224a9e6f521743423bd53e99c7c4793c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p9xq9o12kpb1jowtpllpqgv5xmwuhq9ic2p5ns4es3rb87vmw4', 'zmutmjr451rg5y3nzbmmh6ln9gh809yu3j41qp2e0zcrd3esr2', '0');
-- New West
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cm326spug1wx3ab', 'New West', '208@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb32a5faa77c82348cf5d13590','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:208@artist.com', 'cm326spug1wx3ab', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cm326spug1wx3ab', 'Elevating the ordinary to extraordinary through music.', 'New West');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('q86mdszho14f6yj3v7zj7x6nj36hhkrauyt5fcxw4sw5l1om9i','cm326spug1wx3ab', 'https://i.scdn.co/image/ab67616d0000b2731bb5dc21200bfc56d8f7ef41', 'Those Eyes','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xqwbek8o1j6btob6fqxojfx89j3rhq445amwlhru0ex2tism9q','Those Eyes','cm326spug1wx3ab','POP','50x1Ic8CaXkYNvjmxe3WXy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q86mdszho14f6yj3v7zj7x6nj36hhkrauyt5fcxw4sw5l1om9i', 'xqwbek8o1j6btob6fqxojfx89j3rhq445amwlhru0ex2tism9q', '0');
-- Dean Martin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('umxf5lh246rskal', 'Dean Martin', '209@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdc6d54b08006b8896cb199e5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:209@artist.com', 'umxf5lh246rskal', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('umxf5lh246rskal', 'Creating a tapestry of tunes that celebrates diversity.', 'Dean Martin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('knyfng6kq3eyre4ww2llr9jctiza9b66m5ntzuqhxgmkabqfcl','umxf5lh246rskal', 'https://i.scdn.co/image/ab67616d0000b2736d88028a85c771f37374c8ea', 'A Winter Romance','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2zjtcb3rl5aizkbjvrn8ce2u7n2xh3j3yv4hgjodan99sxzhly','Let It Snow! Let It Snow! Let It Snow!','umxf5lh246rskal','POP','2uFaJJtFpPDc5Pa95XzTvg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('knyfng6kq3eyre4ww2llr9jctiza9b66m5ntzuqhxgmkabqfcl', '2zjtcb3rl5aizkbjvrn8ce2u7n2xh3j3yv4hgjodan99sxzhly', '0');
-- Hotel Ugly
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ztjca57b3q8nyn0', 'Hotel Ugly', '210@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb939033cc36c08ab68b33f760','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:210@artist.com', 'ztjca57b3q8nyn0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ztjca57b3q8nyn0', 'A symphony of emotions expressed through sound.', 'Hotel Ugly');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ufrkftdwxvtx0dkgdhgi4akz6qzqbeieawjqvhtz44uohihywc','ztjca57b3q8nyn0', 'https://i.scdn.co/image/ab67616d0000b273350ab7a839c04bfd5225a9f5', 'Shut up My Moms Calling','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gazvx8pqxtjt9qa5g6q71blj3cyj182ofants0z5icz88ew7h3','Shut up My Moms Calling','ztjca57b3q8nyn0','POP','3hxIUxnT27p5WcmjGUXNwx','https://p.scdn.co/mp3-preview/7642409265c74b714a2f0f0dd8663c031e253485?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ufrkftdwxvtx0dkgdhgi4akz6qzqbeieawjqvhtz44uohihywc', 'gazvx8pqxtjt9qa5g6q71blj3cyj182ofants0z5icz88ew7h3', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k3p8yw6langkcrxj2qj9c0orrt6p05ukwr3hwvyvn3211cgdfd','Shut up My Moms Calling - (Sped Up)','ztjca57b3q8nyn0','POP','31mzt4ZV8C0f52pIz1NSwd','https://p.scdn.co/mp3-preview/4417d6fbf78b2a96b067dc092f888178b155b6b7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ufrkftdwxvtx0dkgdhgi4akz6qzqbeieawjqvhtz44uohihywc', 'k3p8yw6langkcrxj2qj9c0orrt6p05ukwr3hwvyvn3211cgdfd', '1');
-- Rihanna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7js4lkzw7syfib0', 'Rihanna', '211@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb99e4fca7c0b7cb166d915789','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:211@artist.com', '7js4lkzw7syfib0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7js4lkzw7syfib0', 'Harnessing the power of melody to tell compelling stories.', 'Rihanna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('n3fbarnwzhod5m2qkyq2lb89o8dcktqjnazkhdt5bgf3cetf98','7js4lkzw7syfib0', 'https://i.scdn.co/image/ab67616d0000b273bef074de9ca825bddaeb9f46', 'Talk That Talk','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('54qwthh89fsqtw4vbejx8w52i2y0vyusoo3r95gv8jcuqjp1a0','We Found Love','7js4lkzw7syfib0','POP','6qn9YLKt13AGvpq9jfO8py',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n3fbarnwzhod5m2qkyq2lb89o8dcktqjnazkhdt5bgf3cetf98', '54qwthh89fsqtw4vbejx8w52i2y0vyusoo3r95gv8jcuqjp1a0', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cggbxlbkafnsizzf6tdo0s1wo20p8mc817mgzqu810iq1t4okg','Lift Me Up - From Black Panther: Wakanda Forever - Music From and Inspired By','7js4lkzw7syfib0','POP','35ovElsgyAtQwYPYnZJECg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n3fbarnwzhod5m2qkyq2lb89o8dcktqjnazkhdt5bgf3cetf98', 'cggbxlbkafnsizzf6tdo0s1wo20p8mc817mgzqu810iq1t4okg', '1');
-- Oscar Maydon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nglul35fx4767rt', 'Oscar Maydon', '212@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8920adf64930d6f26e34b7c4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:212@artist.com', 'nglul35fx4767rt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nglul35fx4767rt', 'Redefining what it means to be an artist in the digital age.', 'Oscar Maydon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0ctkpntrm7m5ykhmzgheamj46ofgli2hw33h5zoyef7kdiqjge','nglul35fx4767rt', 'https://i.scdn.co/image/ab67616d0000b2739b7e1ea3815a172019bc5e56', 'Fin de Semana','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('owqh3k952wxav3go7g0s7e6npnlvizhsfdhkjwahro99houp9k','Fin de Semana','nglul35fx4767rt','POP','6TBzRwnX2oYd8aOrOuyK1p','https://p.scdn.co/mp3-preview/71ee8bdc0a34790ad549ba750665808f08f5e46b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0ctkpntrm7m5ykhmzgheamj46ofgli2hw33h5zoyef7kdiqjge', 'owqh3k952wxav3go7g0s7e6npnlvizhsfdhkjwahro99houp9k', '0');
-- Tyler The Creator
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tw727v6gf3jsf1n', 'Tyler The Creator', '213@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:213@artist.com', 'tw727v6gf3jsf1n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tw727v6gf3jsf1n', 'Pushing the boundaries of music with unique style and bold lyrics.', 'Tyler The Creator');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x7pfzib4u9bzhqo4zqq71ol8vnlw8yat2gnz9oefjtdog7xdzt','tw727v6gf3jsf1n', 'https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3', 'Flower Boy','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('364tdodfk9jnj8zt1ew75ipuv9n7vepzkboydzm9cv8ov3vofh','See You Again','tw727v6gf3jsf1n','POP','7KA4W4McWYRpgf0fWsJZWB','https://p.scdn.co/mp3-preview/c703198293891e3b276800ea6b187cf7951d3d7d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x7pfzib4u9bzhqo4zqq71ol8vnlw8yat2gnz9oefjtdog7xdzt', '364tdodfk9jnj8zt1ew75ipuv9n7vepzkboydzm9cv8ov3vofh', '0');
-- Alec Benjamin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pxafl5wevy0x17w', 'Alec Benjamin', '214@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6cab9e007b77913d63f12835','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:214@artist.com', 'pxafl5wevy0x17w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pxafl5wevy0x17w', 'An alchemist of harmonies, transforming notes into gold.', 'Alec Benjamin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2hbcvdyp0o60hb63zpxlelln8z3fszw1833dwfcc6j6v10ykwt','pxafl5wevy0x17w', 'https://i.scdn.co/image/ab67616d0000b273459d675aa0b6f3b211357370', 'Narrated For You','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sg8liz0v79chrw5bm8jmy8na6x1jfb28nbpl62dmhrcpcdw03y','Let Me Down Slowly','pxafl5wevy0x17w','POP','2qxmye6gAegTMjLKEBoR3d','https://p.scdn.co/mp3-preview/19007111a4e21096bcefef77842d7179f0cdf12a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2hbcvdyp0o60hb63zpxlelln8z3fszw1833dwfcc6j6v10ykwt', 'sg8liz0v79chrw5bm8jmy8na6x1jfb28nbpl62dmhrcpcdw03y', '0');
-- Wisin & Yandel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4hw38uo2abd6vaq', 'Wisin & Yandel', '215@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5496c4b788e181679069ee8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:215@artist.com', '4hw38uo2abd6vaq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4hw38uo2abd6vaq', 'Music is my canvas, and notes are my paint.', 'Wisin & Yandel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d29f5h0eat206gq0q84dff23qmcb3evk1srqtxf86vecx9dqyl','4hw38uo2abd6vaq', 'https://i.scdn.co/image/ab67616d0000b2739f05bb270f81880fd844aae8', 'La Última Misión','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vi7nj6l3yfpeimc0q0ik0g5x5yi1rjr731r2u06g3x30j21qii','Besos Moja2','4hw38uo2abd6vaq','POP','6OzUIp8KjuwxJnCWkXp1uL','https://p.scdn.co/mp3-preview/8b17c9ae5706f7f2e41a6ec3470631b3094017b6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d29f5h0eat206gq0q84dff23qmcb3evk1srqtxf86vecx9dqyl', 'vi7nj6l3yfpeimc0q0ik0g5x5yi1rjr731r2u06g3x30j21qii', '0');
-- WizKid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('urwb3uemmzj3haw', 'WizKid', '216@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9050b61368975fda051cdc06','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:216@artist.com', 'urwb3uemmzj3haw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('urwb3uemmzj3haw', 'The heartbeat of a new generation of music lovers.', 'WizKid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rzx3yjgvf1ca10s4yfkn1cjhhkxach0pc7dtcki1a10cmhkt2l','urwb3uemmzj3haw', NULL, 'WizKid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rmayka5q700qiwzkelnnlgsd4et1f7411v14rsmlde6ukej3u4','Link Up (Metro Boomin & Don Toliver, Wizkid feat. BEAM & Toian) - Spider-Verse Remix (Spider-Man: Across the Spider-Verse )','urwb3uemmzj3haw','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rzx3yjgvf1ca10s4yfkn1cjhhkxach0pc7dtcki1a10cmhkt2l', 'rmayka5q700qiwzkelnnlgsd4et1f7411v14rsmlde6ukej3u4', '0');
-- Swae Lee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('r19aogcf5p0vm4u', 'Swae Lee', '217@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:217@artist.com', 'r19aogcf5p0vm4u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('r19aogcf5p0vm4u', 'Crafting soundscapes that transport listeners to another world.', 'Swae Lee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('17xqx0ylmsn0bkgbfy6wvyc04bsnugti19709objw887yqjh9j','r19aogcf5p0vm4u', NULL, 'Swae Lee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hym8trqnpl50dn9qgq6s66qd8hoxxcbll83in8f0s6ioh38e78','Calling (Spider-Man: Across the Spider-Verse) (Metro Boomin & Swae Lee, NAV, feat. A Boogie Wit da Hoodie)','r19aogcf5p0vm4u','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('17xqx0ylmsn0bkgbfy6wvyc04bsnugti19709objw887yqjh9j', 'hym8trqnpl50dn9qgq6s66qd8hoxxcbll83in8f0s6ioh38e78', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zufan2i8y2u0xvb089f9n6n2yohpmpd2qywpkla42yp57ftih0','Annihilate (Spider-Man: Across the Spider-Verse) (Metro Boomin & Swae Lee, Lil Wayne, Offset)','r19aogcf5p0vm4u','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('17xqx0ylmsn0bkgbfy6wvyc04bsnugti19709objw887yqjh9j', 'zufan2i8y2u0xvb089f9n6n2yohpmpd2qywpkla42yp57ftih0', '1');
-- Morgan Wallen
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7c3xjsd0pkm5qd4', 'Morgan Wallen', '218@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21ed0100a3a4e5aa3c57f6dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:218@artist.com', '7c3xjsd0pkm5qd4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7c3xjsd0pkm5qd4', 'Blending country charm with rock energy to create memorable tunes.', 'Morgan Wallen');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ma44onlgae6ifnl23zhy8236asycbfdrutnfdu2grt0xk0a9ae','7c3xjsd0pkm5qd4', 'https://i.scdn.co/image/ab67616d0000b273705079df9a25a28b452c1fc9', 'One Thing At A Time','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ds66bailkql4487eco4zre3ugqqsgrq8zdhisq56bfn2omtiwj','Last Night','7c3xjsd0pkm5qd4','POP','7K3BhSpAxZBznislvUMVtn',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ma44onlgae6ifnl23zhy8236asycbfdrutnfdu2grt0xk0a9ae', 'ds66bailkql4487eco4zre3ugqqsgrq8zdhisq56bfn2omtiwj', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7lxmxocqd3evcmgbw2uykugxat63wv4tyub0jlbloe1vvspyhs','You Proof','7c3xjsd0pkm5qd4','POP','5W4kiM2cUYBJXKRudNyxjW',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ma44onlgae6ifnl23zhy8236asycbfdrutnfdu2grt0xk0a9ae', '7lxmxocqd3evcmgbw2uykugxat63wv4tyub0jlbloe1vvspyhs', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m4i0lan9f4c1ceda6w9gtpeeuwe5sdrsifrn9ry3samyikpcun','One Thing At A Time','7c3xjsd0pkm5qd4','POP','1rXq0uoV4KTgRN64jXzIxo',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ma44onlgae6ifnl23zhy8236asycbfdrutnfdu2grt0xk0a9ae', 'm4i0lan9f4c1ceda6w9gtpeeuwe5sdrsifrn9ry3samyikpcun', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4k333fr2gsdgbiv1ew2t9pzspqrczrxknhuipjoebwhsfdhnrh','Aint Tha','7c3xjsd0pkm5qd4','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ma44onlgae6ifnl23zhy8236asycbfdrutnfdu2grt0xk0a9ae', '4k333fr2gsdgbiv1ew2t9pzspqrczrxknhuipjoebwhsfdhnrh', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pj02gluqh0zcdlxcte9gy2viyh15q3c76hp17ietmpdne6ey02','Thinkin B','7c3xjsd0pkm5qd4','POP','0PAcdVzhPO4gq1Iym9ESnK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ma44onlgae6ifnl23zhy8236asycbfdrutnfdu2grt0xk0a9ae', 'pj02gluqh0zcdlxcte9gy2viyh15q3c76hp17ietmpdne6ey02', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bpmjvbs9kve9wtkjfzl8eg7a7mf4obuk6i0xlxg97gyj2glws4','Everything I Love','7c3xjsd0pkm5qd4','POP','03fs6oV5JAlbytRYf3371S',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ma44onlgae6ifnl23zhy8236asycbfdrutnfdu2grt0xk0a9ae', 'bpmjvbs9kve9wtkjfzl8eg7a7mf4obuk6i0xlxg97gyj2glws4', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0bll4odh3fvdhzaerbgdihm1rx0088x69ugz4ah2lr2s091dj0','I Wrote The Book','7c3xjsd0pkm5qd4','POP','7phmBo7bB9I9YifAXqnlqV',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ma44onlgae6ifnl23zhy8236asycbfdrutnfdu2grt0xk0a9ae', '0bll4odh3fvdhzaerbgdihm1rx0088x69ugz4ah2lr2s091dj0', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nf5anmxxbv3wlwu0516bdg4mt9515mexc219uud7cvgskvdltp','Man Made A Bar (feat. Eric Church)','7c3xjsd0pkm5qd4','POP','73zawW1ttszLRgT9By826D',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ma44onlgae6ifnl23zhy8236asycbfdrutnfdu2grt0xk0a9ae', 'nf5anmxxbv3wlwu0516bdg4mt9515mexc219uud7cvgskvdltp', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z1fcpdfite5blqui3614lpylg5q0l43in5egdm206s4nsidix8','98 Braves','7c3xjsd0pkm5qd4','POP','3oZ6dlSfCE9gZ55MGPJctc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ma44onlgae6ifnl23zhy8236asycbfdrutnfdu2grt0xk0a9ae', 'z1fcpdfite5blqui3614lpylg5q0l43in5egdm206s4nsidix8', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e6gvscinahha6ffk2wea2c0h9g1p1r0hgi38z8900st358ivaa','Thought You Should Know','7c3xjsd0pkm5qd4','POP','3Qu3Zh4WTKhP9GEXo0aDnb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ma44onlgae6ifnl23zhy8236asycbfdrutnfdu2grt0xk0a9ae', 'e6gvscinahha6ffk2wea2c0h9g1p1r0hgi38z8900st358ivaa', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yvwa8l4lb2r8zenjd4njaw024m240t3u09dbhc175i02ihn12f','Born With A Beer In My Hand','7c3xjsd0pkm5qd4','POP','1BAU6v0fuAV914qMUEESR1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ma44onlgae6ifnl23zhy8236asycbfdrutnfdu2grt0xk0a9ae', 'yvwa8l4lb2r8zenjd4njaw024m240t3u09dbhc175i02ihn12f', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0bwptmnwcji8c2h6xqlj6fezw5abl452h0wjxrg3j3zy0fezpi','Devil Don','7c3xjsd0pkm5qd4','POP','2PsbT927UanvyH9VprlNOu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ma44onlgae6ifnl23zhy8236asycbfdrutnfdu2grt0xk0a9ae', '0bwptmnwcji8c2h6xqlj6fezw5abl452h0wjxrg3j3zy0fezpi', '11');
-- Nicki Minaj
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yghn6nneh0kjkbc', 'Nicki Minaj', '219@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb54cd560d17307a51f3dc278a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:219@artist.com', 'yghn6nneh0kjkbc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yghn6nneh0kjkbc', 'A rap icon known for her versatile flow and bold personality.', 'Nicki Minaj');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1dsxro89idyiylgj3fzntphawedilluulbophtd0x9k97mhua8','yghn6nneh0kjkbc', 'https://i.scdn.co/image/ab67616d0000b2737e8f938c02fac3b564931116', 'Barbie World (with Aqua) [From Barbie The Album]','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6lgrblb712ftn6156y92gbhsb4gk2jbn1xaofue3iyzj7jaj2r','Barbie World (with Aqua) [From Barbie The Album]','yghn6nneh0kjkbc','POP','741UUVE2kuITl0c6zuqqbO','https://p.scdn.co/mp3-preview/f654928ccaa4e6a9fb09a6eb3f208383eccc12a9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1dsxro89idyiylgj3fzntphawedilluulbophtd0x9k97mhua8', '6lgrblb712ftn6156y92gbhsb4gk2jbn1xaofue3iyzj7jaj2r', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ukac6tnoicu7w40jl1rgq15qtdsg5nzq8e2z72igfyvepbne4r','Princess Diana (with Nicki Minaj)','yghn6nneh0kjkbc','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1dsxro89idyiylgj3fzntphawedilluulbophtd0x9k97mhua8', 'ukac6tnoicu7w40jl1rgq15qtdsg5nzq8e2z72igfyvepbne4r', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t1ppafvv78iaqtt9mcux68et1rq9ov224mjhq6dfpdhbdfod7z','Red Ruby Da Sleeze','yghn6nneh0kjkbc','POP','4ZYAU4A2YBtlNdqOUtc7T2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1dsxro89idyiylgj3fzntphawedilluulbophtd0x9k97mhua8', 't1ppafvv78iaqtt9mcux68et1rq9ov224mjhq6dfpdhbdfod7z', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f3y2bng2wqrh03qzb2np4hh5923gduoe34au73kdypoa26vp5c','Super Freaky Girl','yghn6nneh0kjkbc','POP','4C6Uex2ILwJi9sZXRdmqXp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1dsxro89idyiylgj3fzntphawedilluulbophtd0x9k97mhua8', 'f3y2bng2wqrh03qzb2np4hh5923gduoe34au73kdypoa26vp5c', '3');
-- Coldplay
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('akg8uj4dmzro7kv', 'Coldplay', '220@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb989ed05e1f0570cc4726c2d3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:220@artist.com', 'akg8uj4dmzro7kv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('akg8uj4dmzro7kv', 'Global icons in rock, known for their anthemic songs and impactful lyrics.', 'Coldplay');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tiseot8k27284dt1ko9tfbea82fib3yw6lm6c7rd1724viqmkt','akg8uj4dmzro7kv', 'https://i.scdn.co/image/ab67616d0000b273e21cc1db05580b6f2d2a3b6e', 'Viva La Vida or Death and All His Friends','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lqudaf2jfmwejtygsurfhk165wt65hctfw9ovhlod9opd2fpd9','Viva La Vida','akg8uj4dmzro7kv','POP','1mea3bSkSGXuIRvnydlB5b','https://p.scdn.co/mp3-preview/fb9f4a9b0887326776b4fb7c6d331acd167a7778?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tiseot8k27284dt1ko9tfbea82fib3yw6lm6c7rd1724viqmkt', 'lqudaf2jfmwejtygsurfhk165wt65hctfw9ovhlod9opd2fpd9', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('498kofbfekotdr0893ytyqw3i7e5uo0qkumzr8qt8038vc0otr','My Universe','akg8uj4dmzro7kv','POP','3FeVmId7tL5YN8B7R3imoM','https://p.scdn.co/mp3-preview/e6b780d0df7927114477a786b6a638cf40d19579?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tiseot8k27284dt1ko9tfbea82fib3yw6lm6c7rd1724viqmkt', '498kofbfekotdr0893ytyqw3i7e5uo0qkumzr8qt8038vc0otr', '1');
-- Yng Lvcas
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cxsaxgt3euwizza', 'Yng Lvcas', '221@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:221@artist.com', 'cxsaxgt3euwizza', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cxsaxgt3euwizza', 'Where words fail, my music speaks.', 'Yng Lvcas');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('47c4ez3my3gocb3vvsmlettn1lh3tgse91ugv7oxfajquakswc','cxsaxgt3euwizza', 'https://i.scdn.co/image/ab67616d0000b273a04be3ad7c8c67f4109111a9', 'La Bebe (Remix)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zwehlv44tejt3jpdf9ai9aznvgm79wpoog4ohtd4kg4p4vr387','La Bebe','cxsaxgt3euwizza','POP','2UW7JaomAMuX9pZrjVpHAU','https://p.scdn.co/mp3-preview/57c5d5266219b32d455ed22417155bbabde7170f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('47c4ez3my3gocb3vvsmlettn1lh3tgse91ugv7oxfajquakswc', 'zwehlv44tejt3jpdf9ai9aznvgm79wpoog4ohtd4kg4p4vr387', '0');
-- Brray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('73xy1mmncbw6s7y', 'Brray', '222@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9047f938310ea16b68a5bdeb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:222@artist.com', '73xy1mmncbw6s7y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('73xy1mmncbw6s7y', 'Crafting a unique sonic identity in every track.', 'Brray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7x8lv8mybmn6e3rp9k5g4ouwb1kfkrl8d9ef1qcchnas1zh24c','73xy1mmncbw6s7y', NULL, 'Brray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5cwvrbi2mzluyfedhop6p9hiwaqakpgwrtj8h9ov4ywfb68v5x','LOKERA','73xy1mmncbw6s7y','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7x8lv8mybmn6e3rp9k5g4ouwb1kfkrl8d9ef1qcchnas1zh24c', '5cwvrbi2mzluyfedhop6p9hiwaqakpgwrtj8h9ov4ywfb68v5x', '0');
-- Marlia Mendo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hp3okc23jx8svqw', 'Marlia Mendo', '223@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebffaebdbc972967729f688e25','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:223@artist.com', 'hp3okc23jx8svqw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hp3okc23jx8svqw', 'Pioneering new paths in the musical landscape.', 'Marlia Mendo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xn86b3qorxfdj7zxoz81tohfasq7tcyc1jr8xr76wrnl5j89ah','hp3okc23jx8svqw', NULL, 'Marlia Mendo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5nwvjxexhqwjfqp3qz8h552z1dydfu8yikb7lge79y5h0abn7j','Le','hp3okc23jx8svqw','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xn86b3qorxfdj7zxoz81tohfasq7tcyc1jr8xr76wrnl5j89ah', '5nwvjxexhqwjfqp3qz8h552z1dydfu8yikb7lge79y5h0abn7j', '0');
-- Troye Sivan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0ag1sgwaw74pb4s', 'Troye Sivan', '224@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26e8cb3ff6fc7744b312811b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:224@artist.com', '0ag1sgwaw74pb4s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0ag1sgwaw74pb4s', 'A voice that encapsulates the spirit of modern pop.', 'Troye Sivan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rtgakwp6upgwlow5svqvmq56zcue50z7swmbzoa7whneuho2xe','0ag1sgwaw74pb4s', 'https://i.scdn.co/image/ab67616d0000b27367103283a4eb57578a428252', 'Something To Give Each Other','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e5hpn0zk9fq4rsa490u0aew8bmsck97kugm9pfp4sp4lssahqg','Rush','0ag1sgwaw74pb4s','POP','4ZnkygoWLzcGbQYCm3lkae',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rtgakwp6upgwlow5svqvmq56zcue50z7swmbzoa7whneuho2xe', 'e5hpn0zk9fq4rsa490u0aew8bmsck97kugm9pfp4sp4lssahqg', '0');
-- Cigarettes After Sex
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('n4dzyv3qay20smu', 'Cigarettes After Sex', '225@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7004f7b65ad1bb1e4e4582bc','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:225@artist.com', 'n4dzyv3qay20smu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('n4dzyv3qay20smu', 'A maestro of melodies, orchestrating auditory bliss.', 'Cigarettes After Sex');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cp9ley973x1b1vyjl6r2uemhkpa2b6a0bj3jh80vsruadlcf9m','n4dzyv3qay20smu', 'https://i.scdn.co/image/ab67616d0000b27312b69bf576f5e80291f75161', 'Cigarettes After Sex','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p7n7s342m1bjo8u2h4y2ivletuhdlo3gtphvqktzxdesf5xh7v','Apocalypse','n4dzyv3qay20smu','POP','0yc6Gst2xkRu0eMLeRMGCX','https://p.scdn.co/mp3-preview/1f89f0156113dfb87572382b531459bb8cb711a1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cp9ley973x1b1vyjl6r2uemhkpa2b6a0bj3jh80vsruadlcf9m', 'p7n7s342m1bjo8u2h4y2ivletuhdlo3gtphvqktzxdesf5xh7v', '0');
-- sped up 8282
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('icvlc7tt1zd3qlw', 'sped up 8282', '226@artist.com', 'https://i.scdn.co/image/ab67616d0000b2730a0ba228b5be4ffb7c7c59fb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:226@artist.com', 'icvlc7tt1zd3qlw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('icvlc7tt1zd3qlw', 'Where words fail, my music speaks.', 'sped up 8282');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jvtylm9ajljfsixw7i7jcu9ib5371ts2w7xo4f0olz3rr5jmwg','icvlc7tt1zd3qlw', 'https://i.scdn.co/image/ab67616d0000b2730a0ba228b5be4ffb7c7c59fb', 'Cupid – Twin Ver. (FIFTY FIFTY) – Sped Up Version','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i796ebn3pu7ypzj8k0vydpq2cymth6610q62jimvzr9nrraxs8','Cupid  Twin Ver. (FIFTY FIFTY)  Spe','icvlc7tt1zd3qlw','POP','3B228N0GxfUCwPyfNcJxps','https://p.scdn.co/mp3-preview/29e8870f55c261ec995edfe4a3e9f30e4d4527e0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jvtylm9ajljfsixw7i7jcu9ib5371ts2w7xo4f0olz3rr5jmwg', 'i796ebn3pu7ypzj8k0vydpq2cymth6610q62jimvzr9nrraxs8', '0');
-- Imagine Dragons
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9p1m6sgioxp5fsq', 'Imagine Dragons', '227@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb920dc1f617550de8388f368e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:227@artist.com', '9p1m6sgioxp5fsq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9p1m6sgioxp5fsq', 'Crafting soundscapes that transport listeners to another world.', 'Imagine Dragons');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0c5z6gy1ewiugeu5mvbw69lcvbit7hnsbilybv86rt4pijarxl','9p1m6sgioxp5fsq', 'https://i.scdn.co/image/ab67616d0000b273fc915b69600dce2991a61f13', 'Mercury - Acts 1 & 2','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2u52nyjhchz5au4xdfxz94zn44cvbocj86ycxxy9vbyfleb6td','Bones','9p1m6sgioxp5fsq','POP','54ipXppHLA8U4yqpOFTUhr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0c5z6gy1ewiugeu5mvbw69lcvbit7hnsbilybv86rt4pijarxl', '2u52nyjhchz5au4xdfxz94zn44cvbocj86ycxxy9vbyfleb6td', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9gc96hbdav6xq5di36y8vo647mvoaqzmzvu6x8rso051j2y8b8','Believer','9p1m6sgioxp5fsq','POP','0pqnGHJpmpxLKifKRmU6WP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0c5z6gy1ewiugeu5mvbw69lcvbit7hnsbilybv86rt4pijarxl', '9gc96hbdav6xq5di36y8vo647mvoaqzmzvu6x8rso051j2y8b8', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('16146jkt6j4nh8t24zigk9bcf0fnladhnofqzpe0tw7xl9o7k0','Demons','9p1m6sgioxp5fsq','POP','3LlAyCYU26dvFZBDUIMb7a',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0c5z6gy1ewiugeu5mvbw69lcvbit7hnsbilybv86rt4pijarxl', '16146jkt6j4nh8t24zigk9bcf0fnladhnofqzpe0tw7xl9o7k0', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1lip0h1jhgiavbza72zl61qkj3eg6fpua67yezm2quou6oqaxb','Enemy (with JID) - from the series Arcane League of Legends','9p1m6sgioxp5fsq','POP','3CIyK1V4JEJkg02E4EJnDl',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0c5z6gy1ewiugeu5mvbw69lcvbit7hnsbilybv86rt4pijarxl', '1lip0h1jhgiavbza72zl61qkj3eg6fpua67yezm2quou6oqaxb', '3');
-- Metro Boomin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7izz460czr5tk8z', 'Metro Boomin', '228@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:228@artist.com', '7izz460czr5tk8z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7izz460czr5tk8z', 'Crafting a unique sonic identity in every track.', 'Metro Boomin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bnwwkqsiilvrw94z5dekyorok6b9wwm6nrgd2eqh5xl8xl2se6','7izz460czr5tk8z', 'https://i.scdn.co/image/ab67616d0000b2736ed9aef791159496b286179f', 'METRO BOOMIN PRESENTS SPIDER-MAN: ACROSS THE SPIDER-VERSE (SOUNDTRACK FROM AND INSPIRED BY THE MOTION PICTURE)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0vftd8ki6ykmtd7hi2oy0gb4lm87mjty3fs7wnxlwsf2266fki','Self Love (Spider-Man: Across the Spider-Verse) (Metro Boomin & Coi Leray)','7izz460czr5tk8z','POP','0AAMnNeIc6CdnfNU85GwCH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bnwwkqsiilvrw94z5dekyorok6b9wwm6nrgd2eqh5xl8xl2se6', '0vftd8ki6ykmtd7hi2oy0gb4lm87mjty3fs7wnxlwsf2266fki', '0');
-- LE SSERAFIM
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ux3siv1ybgdjd7d', 'LE SSERAFIM', '229@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb99752c006407988976248679','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:229@artist.com', 'ux3siv1ybgdjd7d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ux3siv1ybgdjd7d', 'Pioneering new paths in the musical landscape.', 'LE SSERAFIM');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ai7k6c2qejfxtmjyayb4rgixuy5mojx07k2tg4hahjyknsjyat','ux3siv1ybgdjd7d', 'https://i.scdn.co/image/ab67616d0000b273d71fd77b89d08bc1bda219c7', 'UNFORGIVEN','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x1bcbftcnqybomjvcvga6cmx35mu5ugcrgeo5s0mubpm1et529','ANTIFRAGILE','ux3siv1ybgdjd7d','POP','0bMoNdAnxNR0OuQbGDovrr','https://p.scdn.co/mp3-preview/c34779ecfb7b14b69518e8489df2227b02272772?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ai7k6c2qejfxtmjyayb4rgixuy5mojx07k2tg4hahjyknsjyat', 'x1bcbftcnqybomjvcvga6cmx35mu5ugcrgeo5s0mubpm1et529', '0');
-- Mr.Kitty
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nhbzznccn5bei5z', 'Mr.Kitty', '230@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb78ed447c78f07632e82ec0d8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:230@artist.com', 'nhbzznccn5bei5z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nhbzznccn5bei5z', 'Crafting a unique sonic identity in every track.', 'Mr.Kitty');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jft4an9ug3d23jcff8i1z2hpg35wzarc945dhr1j95v9rua4fb','nhbzznccn5bei5z', 'https://i.scdn.co/image/ab67616d0000b273b492477206075438e0751176', 'Time','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u3m0ohuvmi450ubxccjk9eiy555z7w0sasbtohwpm0g8jah5dw','After Dark','nhbzznccn5bei5z','POP','2LKOHdMsL0K9KwcPRlJK2v','https://p.scdn.co/mp3-preview/eb9de15a4465f504ee0eadba93e7d265ee0ee6ba?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jft4an9ug3d23jcff8i1z2hpg35wzarc945dhr1j95v9rua4fb', 'u3m0ohuvmi450ubxccjk9eiy555z7w0sasbtohwpm0g8jah5dw', '0');
-- Gorillaz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gfoine3ud3i3xh2', 'Gorillaz', '231@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb337d671a32b2f44d4a4e6cf2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:231@artist.com', 'gfoine3ud3i3xh2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gfoine3ud3i3xh2', 'A symphony of emotions expressed through sound.', 'Gorillaz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3igec5tqj6jqpb7pithzy3u57t9tmyebrs861wns3kl5c0kt46','gfoine3ud3i3xh2', 'https://i.scdn.co/image/ab67616d0000b2734b0ddebba0d5b34f2a2f07a4', 'Cracker Island','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6r163yjwc6soylf6wuzfc40e5pzrdxld068qgkftx9cpzglv2a','Tormenta (feat. Bad Bunny)','gfoine3ud3i3xh2','POP','38UYeBLfvpnDSG9GznZdnL','https://p.scdn.co/mp3-preview/3f89a1c3ec527e23fdefdd03da7797b83eb6e14f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3igec5tqj6jqpb7pithzy3u57t9tmyebrs861wns3kl5c0kt46', '6r163yjwc6soylf6wuzfc40e5pzrdxld068qgkftx9cpzglv2a', '0');
-- Conan Gray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lueozqqqmgesz97', 'Conan Gray', '232@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc1c8fa15e08cb31eeb03b771','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:232@artist.com', 'lueozqqqmgesz97', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lueozqqqmgesz97', 'Pushing the boundaries of sound with each note.', 'Conan Gray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('emvxiumo4k25urleseqov2vd8fpf6z0nd91mcqlqra5kz8pfu1','lueozqqqmgesz97', 'https://i.scdn.co/image/ab67616d0000b27388e3cda6d29b2552d4d6bc43', 'Kid Krow','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ktawgbpcq66xndtm0ivx5p9khwiqeu9p3jq4uzgwcnjobi8wkb','Heather','lueozqqqmgesz97','POP','4xqrdfXkTW4T0RauPLv3WA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('emvxiumo4k25urleseqov2vd8fpf6z0nd91mcqlqra5kz8pfu1', 'ktawgbpcq66xndtm0ivx5p9khwiqeu9p3jq4uzgwcnjobi8wkb', '0');
-- Bizarrap
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y62ee4dun27xy5j', 'Bizarrap', '233@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb14add0d3419426b84158b913','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:233@artist.com', 'y62ee4dun27xy5j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y62ee4dun27xy5j', 'Revolutionizing the music scene with his unique production style and collaborations.', 'Bizarrap');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u4q13ppobp5q358tn8pj4665jyalol7a9scho0afkqst2pgkrg','y62ee4dun27xy5j', 'https://i.scdn.co/image/ab67616d0000b27315583045b2fdb7d7bab10e81', 'Peso Pluma: Bzrp Music Sessions, Vol. 55','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zjdz9q2y8gwqqkt6kvyhhwruy12bmzfv3utfd5tdcpe1q8un0v','Peso Pluma: Bzrp Music Sessions, Vol. 55','y62ee4dun27xy5j','POP','5AqiaZwhmC6dIbgWrD5SzV','https://p.scdn.co/mp3-preview/9d61998a29c2e8b52a7d46885352f5507eb219e2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u4q13ppobp5q358tn8pj4665jyalol7a9scho0afkqst2pgkrg', 'zjdz9q2y8gwqqkt6kvyhhwruy12bmzfv3utfd5tdcpe1q8un0v', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hyn8diuxxu1efk76r7ma8pqjpgyh6wjjuxuewhh02spx7f1lvx','Quevedo: Bzrp Music Sessions, Vol. 52','y62ee4dun27xy5j','POP','2tTmW7RDtMQtBk7m2rYeSw','https://p.scdn.co/mp3-preview/e9c0ed735e611f6af45bc946bd4c31590df09ed6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u4q13ppobp5q358tn8pj4665jyalol7a9scho0afkqst2pgkrg', 'hyn8diuxxu1efk76r7ma8pqjpgyh6wjjuxuewhh02spx7f1lvx', '1');
-- J. Cole
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('upb44uu4oln08xi', 'J. Cole', '234@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb080d11275f15655a11b2610d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:234@artist.com', 'upb44uu4oln08xi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('upb44uu4oln08xi', 'A profound lyricist and rapper, known for his thought-provoking music.', 'J. Cole');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qzk6iyqzg77uu5t6i8my6innovax8x3balrvvdbkoe1qfj0tqa','upb44uu4oln08xi', NULL, '2014 Forest Hills Drive','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f00bo6nikvww6kddovgquyspx7h1mgwvug45ymsqlo8je945uj','All My Life (feat. J. Cole)','upb44uu4oln08xi','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qzk6iyqzg77uu5t6i8my6innovax8x3balrvvdbkoe1qfj0tqa', 'f00bo6nikvww6kddovgquyspx7h1mgwvug45ymsqlo8je945uj', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yknuzy346zm6x1ty0dt9wnlfzow4vwxu1r8a1cwltw26dsfj6w','No Role Modelz','upb44uu4oln08xi','POP','68Dni7IE4VyPkTOH9mRWHr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qzk6iyqzg77uu5t6i8my6innovax8x3balrvvdbkoe1qfj0tqa', 'yknuzy346zm6x1ty0dt9wnlfzow4vwxu1r8a1cwltw26dsfj6w', '1');
-- A$AP Rocky
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tqrknwxfm04x7nc', 'A$AP Rocky', '235@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5c58c41a506a0d6b32cc6cad','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:235@artist.com', 'tqrknwxfm04x7nc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tqrknwxfm04x7nc', 'Crafting a unique sonic identity in every track.', 'A$AP Rocky');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('awt98hkpepv49uh8t2dtla4pbbbt385sml4160snk4hu6ybvl2','tqrknwxfm04x7nc', NULL, 'A$AP Rocky Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('faf0cc2tdmhuqqjthig8sppskekx304v3e4db7wazqqc3szm9j','Am I Dreaming (Metro Boomin & A$AP Rocky, Roisee)','tqrknwxfm04x7nc','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('awt98hkpepv49uh8t2dtla4pbbbt385sml4160snk4hu6ybvl2', 'faf0cc2tdmhuqqjthig8sppskekx304v3e4db7wazqqc3szm9j', '0');
-- Libianca
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('eedq7h35rvocddu', 'Libianca', '236@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a42e7c32ead029c0285c12f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:236@artist.com', 'eedq7h35rvocddu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('eedq7h35rvocddu', 'A fresh talent, blending Afrobeat rhythms with soulful melodies.', 'Libianca');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('r2c78dxu2cbuczwq9i2hz39j9cspl0yym33lmm01dy0rjcgrxr','eedq7h35rvocddu', 'https://i.scdn.co/image/ab67616d0000b273fc342f95f117d48dbdde9735', 'People','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cztx3dmqbjbejjynara63sr9ipqa2ct6n4rdcejij7pxant2ps','People','eedq7h35rvocddu','POP','26b3oVLrRUaaybJulow9kz','https://p.scdn.co/mp3-preview/abcbc9adf10ae4901b40b80a30dc194d589c2d62?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r2c78dxu2cbuczwq9i2hz39j9cspl0yym33lmm01dy0rjcgrxr', 'cztx3dmqbjbejjynara63sr9ipqa2ct6n4rdcejij7pxant2ps', '0');
-- Steve Aoki
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x4h5uvmi2e4ccyz', 'Steve Aoki', '237@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5fb007a707c0ec3a7c1726af','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:237@artist.com', 'x4h5uvmi2e4ccyz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x4h5uvmi2e4ccyz', 'The heartbeat of a new generation of music lovers.', 'Steve Aoki');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qbm8a39e86nhbpeoqxr7n60tc1t572iacvaztxox5cdap5cu9v','x4h5uvmi2e4ccyz', NULL, 'Steve Aoki Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rrgc80nehpxjile22m4qp8awxej8qxin63swr2p3covxh6qy5q','Mu','x4h5uvmi2e4ccyz','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qbm8a39e86nhbpeoqxr7n60tc1t572iacvaztxox5cdap5cu9v', 'rrgc80nehpxjile22m4qp8awxej8qxin63swr2p3covxh6qy5q', '0');
-- Post Malone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b6ztxfel2z56nmy', 'Post Malone', '238@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:238@artist.com', 'b6ztxfel2z56nmy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b6ztxfel2z56nmy', 'Blurring genre lines with his unique blend of hip-hop and pop.', 'Post Malone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hg9ms1yi0mc2i4f4sa25dxvv8vmnqdps8lpoluwqjxpxa301r8','b6ztxfel2z56nmy', 'https://i.scdn.co/image/ab67616d0000b2739478c87599550dd73bfa7e02', 'Hollywoods Bleeding','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yh8v3nrznjnwayblhcp99quqf821t5fanu8o27nudbvryrx4sy','Sunflower - Spider-Man: Into the Spider-Verse','b6ztxfel2z56nmy','POP','0RiRZpuVRbi7oqRdSMwhQY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hg9ms1yi0mc2i4f4sa25dxvv8vmnqdps8lpoluwqjxpxa301r8', 'yh8v3nrznjnwayblhcp99quqf821t5fanu8o27nudbvryrx4sy', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nq8jbjqesspf1qchzxbg3809esit64t5df5o2sr6xb2wywscd6','Overdrive','b6ztxfel2z56nmy','POP','3t0ic4mkhvhamrKDkulB8v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hg9ms1yi0mc2i4f4sa25dxvv8vmnqdps8lpoluwqjxpxa301r8', 'nq8jbjqesspf1qchzxbg3809esit64t5df5o2sr6xb2wywscd6', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oz2w4iqhnlmjjl3ue9zely4legn8ayqe74dexhuf4s3sdsq7xl','Chemical','b6ztxfel2z56nmy','POP','5w40ZYhbBMAlHYNDaVJIUu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hg9ms1yi0mc2i4f4sa25dxvv8vmnqdps8lpoluwqjxpxa301r8', 'oz2w4iqhnlmjjl3ue9zely4legn8ayqe74dexhuf4s3sdsq7xl', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('csvif5fseh4l4z4hfahf90whlrwmlybsf15etbq90p7g3j3sij','Circles','b6ztxfel2z56nmy','POP','21jGcNKet2qwijlDFuPiPb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hg9ms1yi0mc2i4f4sa25dxvv8vmnqdps8lpoluwqjxpxa301r8', 'csvif5fseh4l4z4hfahf90whlrwmlybsf15etbq90p7g3j3sij', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nswhugehz3o4h0btjp166rnci39hc83egvhir6wzjpkz0lt2de','I Like You (A Happier Song) (with Doja Cat)','b6ztxfel2z56nmy','POP','0O6u0VJ46W86TxN9wgyqDj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hg9ms1yi0mc2i4f4sa25dxvv8vmnqdps8lpoluwqjxpxa301r8', 'nswhugehz3o4h0btjp166rnci39hc83egvhir6wzjpkz0lt2de', '4');
-- IVE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1st9mh84nghttz4', 'IVE', '239@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0e46f140189de1eba9ab6230','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:239@artist.com', '1st9mh84nghttz4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1st9mh84nghttz4', 'A harmonious blend of passion and creativity.', 'IVE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1t3wxr5w4xwox7gthmxhzobtqzxj585egnzv9z9zz4ax502sat','1st9mh84nghttz4', 'https://i.scdn.co/image/ab67616d0000b27325ef3cec1eceefd4db2f91c8', 'Ive IVE','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bt67f7lau76ig4ghdpt9wlubm59lc0595tz11cmvzp3za5i23e','I AM','1st9mh84nghttz4','POP','70t7Q6AYG6ZgTYmJWcnkUM','https://p.scdn.co/mp3-preview/8d1fa5354093e98745ccef77ecb60fac3c9d38d0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1t3wxr5w4xwox7gthmxhzobtqzxj585egnzv9z9zz4ax502sat', 'bt67f7lau76ig4ghdpt9wlubm59lc0595tz11cmvzp3za5i23e', '0');
-- Tyler
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xvjhygj90ki4zaj', 'Tyler', '240@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8278b782cbb5a3963db88ada','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:240@artist.com', 'xvjhygj90ki4zaj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xvjhygj90ki4zaj', 'Where words fail, my music speaks.', 'Tyler');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4juzhv15mvijlmwy0g7oh81825yf3v5uxi3rrndv3bzab4jwkd','xvjhygj90ki4zaj', 'https://i.scdn.co/image/ab67616d0000b273aa95a399fd30fbb4f6f59fca', 'CALL ME IF YOU GET LOST: The Estate Sale','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8wefmujvlygkzvm2czwanunf9chmi6e0kyzubcqydhp5znequ4','DOGTOOTH','xvjhygj90ki4zaj','POP','6OfOzTitafSnsaunQLuNFw','https://p.scdn.co/mp3-preview/5de4c8c30108bc114f9f38a28ac0832936a852bf?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4juzhv15mvijlmwy0g7oh81825yf3v5uxi3rrndv3bzab4jwkd', '8wefmujvlygkzvm2czwanunf9chmi6e0kyzubcqydhp5znequ4', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t1ov8w2q9w9nkn0ekzv4h7zssk8npny12n87tkgdalzxnvi3q0','SORRY NOT SORRY','xvjhygj90ki4zaj','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4juzhv15mvijlmwy0g7oh81825yf3v5uxi3rrndv3bzab4jwkd', 't1ov8w2q9w9nkn0ekzv4h7zssk8npny12n87tkgdalzxnvi3q0', '1');
-- Joji
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zikg04fkmflxo2a', 'Joji', '241@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4111c95b5f430c3265c7304b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:241@artist.com', 'zikg04fkmflxo2a', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zikg04fkmflxo2a', 'Music is my canvas, and notes are my paint.', 'Joji');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('udnzhoomw7oqhay0z6acbw7zmhffcrcxx47uhignj8f8e1ny9y','zikg04fkmflxo2a', 'https://i.scdn.co/image/ab67616d0000b27308596cc28b9f5b00bfe08ae7', 'Glimpse of Us','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z7o4ke43j5hpex1vx0q3fq5x0m71ixqyi0x4oparskqefqfldh','Glimpse of Us','zikg04fkmflxo2a','POP','6xGruZOHLs39ZbVccQTuPZ','https://p.scdn.co/mp3-preview/12e4a7ef3f1051424e6e282dfba83fe8448e122f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('udnzhoomw7oqhay0z6acbw7zmhffcrcxx47uhignj8f8e1ny9y', 'z7o4ke43j5hpex1vx0q3fq5x0m71ixqyi0x4oparskqefqfldh', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wpcyv51uyy9tsr7zotblc0eu60cjdlkic26oqhuty4qtyczxy7','Die For You','zikg04fkmflxo2a','POP','26hOm7dTtBi0TdpDGl141t','https://p.scdn.co/mp3-preview/85d19ba2d8274ab29f474b3baf07b6ac6ba6d35a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('udnzhoomw7oqhay0z6acbw7zmhffcrcxx47uhignj8f8e1ny9y', 'wpcyv51uyy9tsr7zotblc0eu60cjdlkic26oqhuty4qtyczxy7', '1');
-- Lady Gaga
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('oimbn6rp5bcnzdi', 'Lady Gaga', '242@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc8d3d98a1bccbe71393dbfbf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:242@artist.com', 'oimbn6rp5bcnzdi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('oimbn6rp5bcnzdi', 'Striking chords that resonate across generations.', 'Lady Gaga');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dkuojc2r7lu260sb8g23j6xuy6l7hti54957px6sx3l4w8ttii','oimbn6rp5bcnzdi', 'https://i.scdn.co/image/ab67616d0000b273a47c0e156ea3cebe37fdcab8', 'Born This Way (Special Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2bl2knghchqxnq1maw3upvkk3q6e5g52e7edn2m7einkxx0c4q','Bloody Mary','oimbn6rp5bcnzdi','POP','11BKm0j4eYoCPPpCONAVwA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dkuojc2r7lu260sb8g23j6xuy6l7hti54957px6sx3l4w8ttii', '2bl2knghchqxnq1maw3upvkk3q6e5g52e7edn2m7einkxx0c4q', '0');
-- Wham!
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2610vcm5ipbwkcm', 'Wham!', '243@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03e73d13341a8419eea9fcfb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:243@artist.com', '2610vcm5ipbwkcm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2610vcm5ipbwkcm', 'A maestro of melodies, orchestrating auditory bliss.', 'Wham!');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7av6kw6qjz3fihm3nzf3zqlzsyo2dqyo5p1zehquf1bcq16bb6','2610vcm5ipbwkcm', 'https://i.scdn.co/image/ab67616d0000b273f2d2adaa21ad616df6241e7d', 'LAST CHRISTMAS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ifsri5wx5wwxl2bv56b1i7l82t34937o2urprkmex3ebnfm7b5','Last Christmas','2610vcm5ipbwkcm','POP','2FRnf9qhLbvw8fu4IBXx78','https://p.scdn.co/mp3-preview/5c6b42e86dba5ec9e8346a345b3a8822b2396d3f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7av6kw6qjz3fihm3nzf3zqlzsyo2dqyo5p1zehquf1bcq16bb6', 'ifsri5wx5wwxl2bv56b1i7l82t34937o2urprkmex3ebnfm7b5', '0');
-- Kelly Clarkson
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dednzyr8jr6w66v', 'Kelly Clarkson', '244@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb305a7cc6760b53a67aaae19d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:244@artist.com', 'dednzyr8jr6w66v', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dednzyr8jr6w66v', 'Blending traditional rhythms with modern beats.', 'Kelly Clarkson');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rzuhj5iaokpinfw4c6papbcgxs9ewfpq0vdvc6nv1owzpw5vve','dednzyr8jr6w66v', 'https://i.scdn.co/image/ab67616d0000b273f54a315f1d2445791fe601a7', 'Wrapped In Red','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6yyd98j9ury6o0z6af0j8nxwxc39f60lnlq9veleehg6w9fe0j','Underneath the Tree','dednzyr8jr6w66v','POP','3YZE5qDV7u1ZD1gZc47ZeR','https://p.scdn.co/mp3-preview/9d6040eda6551e1746409ca2c8cf04d95475019a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rzuhj5iaokpinfw4c6papbcgxs9ewfpq0vdvc6nv1owzpw5vve', '6yyd98j9ury6o0z6af0j8nxwxc39f60lnlq9veleehg6w9fe0j', '0');
-- Robin Schulz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zch4ymr86wtcodd', 'Robin Schulz', '245@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb82c0d0d4ef6742997f03d678','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:245@artist.com', 'zch4ymr86wtcodd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zch4ymr86wtcodd', 'A symphony of emotions expressed through sound.', 'Robin Schulz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mp2iyo259di2kqrnrqhfc629mxzekus60et51qpc1ranwlafzo','zch4ymr86wtcodd', NULL, 'Robin Schulz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yglivicd8xwteg46a9bfevxu7iy8unhq3738e3b6bal1k4ejtk','Miss You','zch4ymr86wtcodd','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mp2iyo259di2kqrnrqhfc629mxzekus60et51qpc1ranwlafzo', 'yglivicd8xwteg46a9bfevxu7iy8unhq3738e3b6bal1k4ejtk', '0');
-- INTERWORLD
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0hk7s6m4udcse5u', 'INTERWORLD', '246@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4ba846e4a963c8558471e3af','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:246@artist.com', '0hk7s6m4udcse5u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0hk7s6m4udcse5u', 'An endless quest for musical perfection.', 'INTERWORLD');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4oozx2ogbp8ujxkz2prn12dttpyuo4yqtpy6sz4fhtjanqwgmd','0hk7s6m4udcse5u', 'https://i.scdn.co/image/ab67616d0000b273b852a616ae3a49a1f6b0f16e', 'METAMORPHOSIS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jg5st4jx2nhax6qxatwky468vm6fpg3d2vshtysa5pu897woed','METAMORPHOSIS','0hk7s6m4udcse5u','POP','2ksyzVfU0WJoBpu8otr4pz','https://p.scdn.co/mp3-preview/61baac6cfee58ae57f9f767a86fa5e99f9797664?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4oozx2ogbp8ujxkz2prn12dttpyuo4yqtpy6sz4fhtjanqwgmd', 'jg5st4jx2nhax6qxatwky468vm6fpg3d2vshtysa5pu897woed', '0');
-- NF
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v05dl68cee6dufe', 'NF', '247@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1cf142a710a2f3d9b7a62da1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:247@artist.com', 'v05dl68cee6dufe', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v05dl68cee6dufe', 'Uniting fans around the globe with universal rhythms.', 'NF');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4v4df7ufv0tb2ooun3k39prq30ueq4ymxg5g035256c3kwmscm','v05dl68cee6dufe', 'https://i.scdn.co/image/ab67616d0000b273ff8a4276b3be31c839557439', 'HOPE','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fq9u6kuc370r23w7ep5butpbo8oqvgeji271rqmgxa2waam3om','HAPPY','v05dl68cee6dufe','POP','3ZEno9fORwMA1HPecdLi0R',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4v4df7ufv0tb2ooun3k39prq30ueq4ymxg5g035256c3kwmscm', 'fq9u6kuc370r23w7ep5butpbo8oqvgeji271rqmgxa2waam3om', '0');
-- OneRepublic
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hk4z9rzrsucjfhi', 'OneRepublic', '248@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb57138b98e7ddd5a86ee97a9b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:248@artist.com', 'hk4z9rzrsucjfhi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hk4z9rzrsucjfhi', 'Delivering anthemic pop-rock tracks that resonate globally.', 'OneRepublic');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7w49tps69zavnduo05a9yyp2m9ufk8tra895cnm6glxfn1yg6y','hk4z9rzrsucjfhi', 'https://i.scdn.co/image/ab67616d0000b273ec96e006b8bdfc582610ec13', 'I Ain’t Worried (Music From The Motion Picture "Top Gun: Maverick")','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mpbhdelftnv99fhkng60rvygupmz24dbys4l1oyrddhlzvjihm','I Aint Worried','hk4z9rzrsucjfhi','POP','4h9wh7iOZ0GGn8QVp4RAOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7w49tps69zavnduo05a9yyp2m9ufk8tra895cnm6glxfn1yg6y', 'mpbhdelftnv99fhkng60rvygupmz24dbys4l1oyrddhlzvjihm', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4k7zy3pm7rtuokqb7vdr13t62nkkmr997tc1drcecrjfgmy1t1','Counting Stars','hk4z9rzrsucjfhi','POP','2tpWsVSb9UEmDRxAl1zhX1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7w49tps69zavnduo05a9yyp2m9ufk8tra895cnm6glxfn1yg6y', '4k7zy3pm7rtuokqb7vdr13t62nkkmr997tc1drcecrjfgmy1t1', '1');
-- Veigh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('aeqacfzzyprfys5', 'Veigh', '249@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfe49a8f4b6b1a82a29f43112','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:249@artist.com', 'aeqacfzzyprfys5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('aeqacfzzyprfys5', 'Transcending language barriers through the universal language of music.', 'Veigh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kvaw9oxlbho4iv0iqg6kpgdndhbg3i9m511alhwxgvermvjy3p','aeqacfzzyprfys5', 'https://i.scdn.co/image/ab67616d0000b273ce0947b85c30490447dbbd91', 'Dos Prédios Deluxe','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('auujvofdy6wobhhqyh7m5fp8qgehoj9snj9yghyvgqn9l90zzf','Novo Balan','aeqacfzzyprfys5','POP','4hKLzFvNwHF6dPosGT30ed','https://p.scdn.co/mp3-preview/af031ca41aac7b60676833187f323d94fc387bce?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kvaw9oxlbho4iv0iqg6kpgdndhbg3i9m511alhwxgvermvjy3p', 'auujvofdy6wobhhqyh7m5fp8qgehoj9snj9yghyvgqn9l90zzf', '0');
-- David Guetta
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jdvbhc3hkpbdsnw', 'David Guetta', '250@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf150017ca69c8793503c2d4f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:250@artist.com', 'jdvbhc3hkpbdsnw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jdvbhc3hkpbdsnw', 'A legend in the electronic music world, constantly innovating and entertaining.', 'David Guetta');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u8c55habbp2wfjh9cndudb7akuqkraz9r69qm56advso2mnsxv','jdvbhc3hkpbdsnw', 'https://i.scdn.co/image/ab67616d0000b2730b4ef75c3728599aa4104f7a', 'Baby Dont Hurt Me','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n3jkczar33ayqhxptxxv22m8a0iq3qkk4ru7vke8aeldo229kk','Baby Dont Hurt Me','jdvbhc3hkpbdsnw','POP','3BKD1PwArikchz2Zrlp1qi','https://p.scdn.co/mp3-preview/a8f2e176e17e0f6298b42ef8e96118318fdd2b89?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u8c55habbp2wfjh9cndudb7akuqkraz9r69qm56advso2mnsxv', 'n3jkczar33ayqhxptxxv22m8a0iq3qkk4ru7vke8aeldo229kk', '0');
-- Lana Del Rey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7rrw599zde1ce2x', 'Lana Del Rey', '251@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb99cacf8acd5378206767261','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:251@artist.com', '7rrw599zde1ce2x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7rrw599zde1ce2x', 'An ethereal presence in music, known for her cinematic and nostalgic sound.', 'Lana Del Rey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sodex329thebyjxqh0po4mqpgvf1x78pv2tkir6ce0jzgvv466','7rrw599zde1ce2x', 'https://i.scdn.co/image/ab67616d0000b273aa27708d07f49c82ff0d0dae', 'Say Yes To Heaven','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8lsvporcbdwoda6b6xaev99cdeggl0n68gum33xqh10fb3ajyr','Say Yes To Heaven','7rrw599zde1ce2x','POP','6GGtHZgBycCgGBUhZo81xe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sodex329thebyjxqh0po4mqpgvf1x78pv2tkir6ce0jzgvv466', '8lsvporcbdwoda6b6xaev99cdeggl0n68gum33xqh10fb3ajyr', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n1pghaqwgqhhk8e9u6318tlzej7gf12jgkcg0ukuemlvqyge64','Summertime Sadness','7rrw599zde1ce2x','POP','1Ist6PR2BZR3n2z2Y5R6S1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sodex329thebyjxqh0po4mqpgvf1x78pv2tkir6ce0jzgvv466', 'n1pghaqwgqhhk8e9u6318tlzej7gf12jgkcg0ukuemlvqyge64', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gdh350l5ajct10xfzilpdwigj2mu2ansmhdwiwb4lbmp9p0z1t','Radio','7rrw599zde1ce2x','POP','3QhfFRPkhPCR1RMJWV1gde',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sodex329thebyjxqh0po4mqpgvf1x78pv2tkir6ce0jzgvv466', 'gdh350l5ajct10xfzilpdwigj2mu2ansmhdwiwb4lbmp9p0z1t', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wbocjnn13pwauxf0zljvgrxrduheoe8k35jbrf9p1fmmn8cxfn','Snow On The Beach (feat. More Lana Del Rey)','7rrw599zde1ce2x','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sodex329thebyjxqh0po4mqpgvf1x78pv2tkir6ce0jzgvv466', 'wbocjnn13pwauxf0zljvgrxrduheoe8k35jbrf9p1fmmn8cxfn', '3');
-- Offset
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d0x0u1enqq9ujpj', 'Offset', '252@artist.com', 'https://i.scdn.co/image/ab67616d0000b2736edd8e309824c6f3fd3f3466','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:252@artist.com', 'd0x0u1enqq9ujpj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('d0x0u1enqq9ujpj', 'A beacon of innovation in the world of sound.', 'Offset');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xsu8n82qu3m2fxtgxcqw4ur1yixkmk54j9yyvei9iczzygnh8w','d0x0u1enqq9ujpj', 'https://i.scdn.co/image/ab67616d0000b2736ed9aef791159496b286179f', 'METRO BOOMIN PRESENTS SPIDER-MAN: ACROSS THE SPIDER-VERSE (SOUNDTRACK FROM AND INSPIRED BY THE MOTION PICTURE)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o1duc4t8l008oc28bbjpqv5m0506o9dbe0mrek5lsfnnhjyx0b','Danger (Spider) (Offset & JID)','d0x0u1enqq9ujpj','POP','3X6qK1LdMkSOhklwRa2ZfG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xsu8n82qu3m2fxtgxcqw4ur1yixkmk54j9yyvei9iczzygnh8w', 'o1duc4t8l008oc28bbjpqv5m0506o9dbe0mrek5lsfnnhjyx0b', '0');
-- Doja Cat
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('60tfhym69l2u6pl', 'Doja Cat', '253@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7f6d6cac38d494e87692af99','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:253@artist.com', '60tfhym69l2u6pl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('60tfhym69l2u6pl', 'A tapestry of rhythms that echo the pulse of life.', 'Doja Cat');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l9a2aj9yv25tnnlbfdu0arne03b8ajs4a1v29pmwig5gzykwam','60tfhym69l2u6pl', 'https://i.scdn.co/image/ab67616d0000b273be841ba4bc24340152e3a79a', 'Planet Her','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0zk1masxx73l2eve022vintx9wju1lv9ziz734tkot7qm9etzg','Woman','60tfhym69l2u6pl','POP','6Uj1ctrBOjOas8xZXGqKk4','https://p.scdn.co/mp3-preview/2ae0b61e45d9a5d6454a3e5ab75f8628dd89aa85?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l9a2aj9yv25tnnlbfdu0arne03b8ajs4a1v29pmwig5gzykwam', '0zk1masxx73l2eve022vintx9wju1lv9ziz734tkot7qm9etzg', '0');
-- Frank Ocean
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1gpo5w56q38klf6', 'Frank Ocean', '254@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebee3123e593174208f9754fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:254@artist.com', '1gpo5w56q38klf6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1gpo5w56q38klf6', 'A symphony of emotions expressed through sound.', 'Frank Ocean');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ksltdpyqz2gltua1fynvxbd6mgwq1emr99eff57p3jxvydwzd2','1gpo5w56q38klf6', 'https://i.scdn.co/image/ab67616d0000b273c5649add07ed3720be9d5526', 'Blonde','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pt7vlquc2qg9ddu33dnq91owfo0kzi1q67cr62t60yekkc4ehz','Pink + White','1gpo5w56q38klf6','POP','3xKsf9qdS1CyvXSMEid6g8','https://p.scdn.co/mp3-preview/0e3ca894e19c37cbbbd511d9eb682d8bee030126?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ksltdpyqz2gltua1fynvxbd6mgwq1emr99eff57p3jxvydwzd2', 'pt7vlquc2qg9ddu33dnq91owfo0kzi1q67cr62t60yekkc4ehz', '0');
-- Feid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xgoqnt39coh6lsr', 'Feid', '255@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9e7c05016af970bb9bf76cc1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:255@artist.com', 'xgoqnt39coh6lsr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xgoqnt39coh6lsr', 'A standout artist in urban Latin music, known for his catchy melodies and smooth vocals.', 'Feid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('95zlx68wrysxjrucdtecdvzfrtfqysdseh4z87ubnl9u5zl1cb','xgoqnt39coh6lsr', 'https://i.scdn.co/image/ab67616d0000b27329ebee2b5fb008871fcd201a', 'CLASSY 101','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('shy4e6psucjtroilgdr4oc9kdlxdh79l91uzzudhtvxwt7bzl7','Classy 101','xgoqnt39coh6lsr','POP','6XSqqQIy7Lm7SnwxS4NrGx',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('95zlx68wrysxjrucdtecdvzfrtfqysdseh4z87ubnl9u5zl1cb', 'shy4e6psucjtroilgdr4oc9kdlxdh79l91uzzudhtvxwt7bzl7', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('eviransr2mcsrtm3dpm781uiau3x84okejkopm5dyyr42f9de4','El Cielo','xgoqnt39coh6lsr','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('95zlx68wrysxjrucdtecdvzfrtfqysdseh4z87ubnl9u5zl1cb', 'eviransr2mcsrtm3dpm781uiau3x84okejkopm5dyyr42f9de4', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('azhis9j8y9togc6i2srjve5o5kituhz8w3410ct4p42tytzfsr','Feliz Cumpleaos Fe','xgoqnt39coh6lsr','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('95zlx68wrysxjrucdtecdvzfrtfqysdseh4z87ubnl9u5zl1cb', 'azhis9j8y9togc6i2srjve5o5kituhz8w3410ct4p42tytzfsr', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ks0jjxvb6zsgsli645g6adp7ao0ihdzwhzbf5l9v0gsxl39pcp','POLARIS - Remix','xgoqnt39coh6lsr','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('95zlx68wrysxjrucdtecdvzfrtfqysdseh4z87ubnl9u5zl1cb', 'ks0jjxvb6zsgsli645g6adp7ao0ihdzwhzbf5l9v0gsxl39pcp', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nqimqet7xy8xt0cnrn4mssw2ddoyqhfjax652hspv3ctf8fjph','CHORRITO PA LAS ANIMAS','xgoqnt39coh6lsr','POP','0CYTGMBYkwUxrj1MWDLrC5',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('95zlx68wrysxjrucdtecdvzfrtfqysdseh4z87ubnl9u5zl1cb', 'nqimqet7xy8xt0cnrn4mssw2ddoyqhfjax652hspv3ctf8fjph', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ob4sb91wwirashkj31in2v52aim1l2tzxgishypcj1fo21ni2h','Normal','xgoqnt39coh6lsr','POP','0T2pB7P1VdXPhLdQZ488uH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('95zlx68wrysxjrucdtecdvzfrtfqysdseh4z87ubnl9u5zl1cb', 'ob4sb91wwirashkj31in2v52aim1l2tzxgishypcj1fo21ni2h', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gvareg5mcks0k2uy66jo4ie8ao1qo7z8m89z0dm6lt81h5d4bg','REMIX EXCLUSIVO','xgoqnt39coh6lsr','POP','3eqCJfgJJs8iKx49KO12s3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('95zlx68wrysxjrucdtecdvzfrtfqysdseh4z87ubnl9u5zl1cb', 'gvareg5mcks0k2uy66jo4ie8ao1qo7z8m89z0dm6lt81h5d4bg', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n97mkl70isaxlnzbdgza9sz5qc0r9is7fmqtsgpzpzvi2vc2qv','LA INOCENTE','xgoqnt39coh6lsr','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('95zlx68wrysxjrucdtecdvzfrtfqysdseh4z87ubnl9u5zl1cb', 'n97mkl70isaxlnzbdgza9sz5qc0r9is7fmqtsgpzpzvi2vc2qv', '7');
-- Kordhell
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gcn5pgx0n4bxwxm', 'Kordhell', '256@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb15862815bf4d2446b8ecf55f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:256@artist.com', 'gcn5pgx0n4bxwxm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gcn5pgx0n4bxwxm', 'Crafting melodies that resonate with the soul.', 'Kordhell');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4kensw0hry4z0hwn0ma9rsgm3zf54mqdiqpbim72cta8rermyc','gcn5pgx0n4bxwxm', 'https://i.scdn.co/image/ab67616d0000b2731440ffaa43c53d65719e0150', 'Murder In My Mind','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('42nmc3kp6zo0mcrmvuhw6ll6yrw6pfbyjgwoopdpztgrx64pz3','Murder In My Mind','gcn5pgx0n4bxwxm','POP','6qyS9qBy0mEk3qYaH8mPss','https://p.scdn.co/mp3-preview/ec3b94db31d9fb9821cfea0f7a4cdc9d2a85e969?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4kensw0hry4z0hwn0ma9rsgm3zf54mqdiqpbim72cta8rermyc', '42nmc3kp6zo0mcrmvuhw6ll6yrw6pfbyjgwoopdpztgrx64pz3', '0');
-- J Balvin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2b229iqnizfsr9a', 'J Balvin', '257@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5edc80e125ca7b4e0e4cf1b0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:257@artist.com', '2b229iqnizfsr9a', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2b229iqnizfsr9a', 'A visionary in the world of music, redefining genres.', 'J Balvin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0nlef6dwegtz4vl50d2vfiz20re54f8svmibvmfrthd4by7rzf','2b229iqnizfsr9a', 'https://i.scdn.co/image/ab67616d0000b2734891d9b25d8919448388f3bb', 'OASIS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bwpks35k0qcdf4i51h0vek2lj1nb4mxu5egazsvuwztha8imfz','LA CANCI','2b229iqnizfsr9a','POP','0fea68AdmYNygeTGI4RC18',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0nlef6dwegtz4vl50d2vfiz20re54f8svmibvmfrthd4by7rzf', 'bwpks35k0qcdf4i51h0vek2lj1nb4mxu5egazsvuwztha8imfz', '0');
-- Shakira
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1lm235f3g48qzk5', 'Shakira', '258@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba94d903e52abf6c43bae28ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:258@artist.com', '1lm235f3g48qzk5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1lm235f3g48qzk5', 'Elevating the ordinary to extraordinary through music.', 'Shakira');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uxxaem0r8sp4k3nmnqovppnpv6rfv5x6wjdux1nw9devbtrmsv','1lm235f3g48qzk5', NULL, 'Te Felicito','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dfwj976sbc6vmcixln9e8jbcd08h5hy90bxqkpjqheo224zbs6','Shakira: Bzrp Music Sessions, Vol. 53','1lm235f3g48qzk5','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uxxaem0r8sp4k3nmnqovppnpv6rfv5x6wjdux1nw9devbtrmsv', 'dfwj976sbc6vmcixln9e8jbcd08h5hy90bxqkpjqheo224zbs6', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x71k3pkf8wsq46aqod1max4hsvhz8p8qk8qmhcubd5761c64bv','Acrs','1lm235f3g48qzk5','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uxxaem0r8sp4k3nmnqovppnpv6rfv5x6wjdux1nw9devbtrmsv', 'x71k3pkf8wsq46aqod1max4hsvhz8p8qk8qmhcubd5761c64bv', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w8cw1rblnfcn4hicz4pb7p0zg73gseqsiftpr0xux46n4fjzwg','Te Felicito','1lm235f3g48qzk5','POP','2rurDawMfoKP4uHyb2kJBt','https://p.scdn.co/mp3-preview/6b4b2be03b14bf758835c8f28f35834da35cc1c3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uxxaem0r8sp4k3nmnqovppnpv6rfv5x6wjdux1nw9devbtrmsv', 'w8cw1rblnfcn4hicz4pb7p0zg73gseqsiftpr0xux46n4fjzwg', '2');
-- Yahritza Y Su Esencia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('oxys14p31xmdpkg', 'Yahritza Y Su Esencia', '259@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68d4ccdc175f594122f1eee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:259@artist.com', 'oxys14p31xmdpkg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('oxys14p31xmdpkg', 'Infusing traditional melodies with youthful vigor.', 'Yahritza Y Su Esencia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('onmuu86tvanjlyr4nv07fc778t41bn57jyixat4349e7nlty7x','oxys14p31xmdpkg', NULL, 'Yahritza Y Su Esencia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bovt5l87j3fs07pa1rsvvp73hzq6dhcozbpub1vdia3bfm2a1b','Frgil (feat. Grupo Front','oxys14p31xmdpkg','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('onmuu86tvanjlyr4nv07fc778t41bn57jyixat4349e7nlty7x', 'bovt5l87j3fs07pa1rsvvp73hzq6dhcozbpub1vdia3bfm2a1b', '0');
-- Dave
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ddsyf0riu0v00go', 'Dave', '260@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd03e9ecf77419871b96daee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:260@artist.com', 'ddsyf0riu0v00go', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ddsyf0riu0v00go', 'A master of words, blending rap with social commentary and raw emotion.', 'Dave');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('10qt0qvjg89y880wslyah3eiq4tftpf8t8w3u0cxv5cfhy9fa9','ddsyf0riu0v00go', 'https://i.scdn.co/image/ab67616d0000b273e3a09a9ae3f1fa102c110e60', 'Sprinter','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j7gnku83onq7n3irdlw3x71s586364hdwvw3y7qhvjde3o23gy','Sprinter','ddsyf0riu0v00go','POP','2FDTHlrBguDzQkp7PVj16Q',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('10qt0qvjg89y880wslyah3eiq4tftpf8t8w3u0cxv5cfhy9fa9', 'j7gnku83onq7n3irdlw3x71s586364hdwvw3y7qhvjde3o23gy', '0');
-- Lil Durk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wvj39x6yqgthj9y', 'Lil Durk', '261@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba0461c1f2218374aa672ce4e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:261@artist.com', 'wvj39x6yqgthj9y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wvj39x6yqgthj9y', 'Weaving lyrical magic into every song.', 'Lil Durk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kcjt7yxn52mb7eym37pqbx5h5w08gwum26b24u70mnbdyyacm1','wvj39x6yqgthj9y', 'https://i.scdn.co/image/ab67616d0000b2736234c2c6d4bb935839ac4719', 'Almost Healed','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7ublx7lwszjfisi56h2k3yjjf7dcjyhwlcf64t6gjx7i4lafst','Stand By Me (feat. Morgan Wallen)','wvj39x6yqgthj9y','POP','1fXnu2HzxbDtoyvFPWG3Bw','https://p.scdn.co/mp3-preview/ed64766975b1f0b3aa57741935c3f20e833c47db?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kcjt7yxn52mb7eym37pqbx5h5w08gwum26b24u70mnbdyyacm1', '7ublx7lwszjfisi56h2k3yjjf7dcjyhwlcf64t6gjx7i4lafst', '0');
-- Nicky Jam
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('usnrzq1rn4q8t6c', 'Nicky Jam', '262@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb02bec146cac39466d3f8ee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:262@artist.com', 'usnrzq1rn4q8t6c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('usnrzq1rn4q8t6c', 'Redefining what it means to be an artist in the digital age.', 'Nicky Jam');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('q2b055og04sgoro364ljf61rzirfe3hgcr51czk30s71238rqt','usnrzq1rn4q8t6c', 'https://i.scdn.co/image/ab67616d0000b273ea97d86f1fa8532cd8c75188', '69','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t0ti792ielnj3fgsi5vsaxwjwbht61oogj72s047mmrvgvt5he','69','usnrzq1rn4q8t6c','POP','13Z5Q40pa1Ly7aQk1oW8Ce','https://p.scdn.co/mp3-preview/966457479d8cd723838150ddd1f3010f4383994d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q2b055og04sgoro364ljf61rzirfe3hgcr51czk30s71238rqt', 't0ti792ielnj3fgsi5vsaxwjwbht61oogj72s047mmrvgvt5he', '0');
-- Jimin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('97dwhod3szyisai', 'Jimin', '263@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb59f8cfc8e71dcaf8c6ec4bde','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:263@artist.com', '97dwhod3szyisai', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('97dwhod3szyisai', 'Known for his expressive voice and mesmerizing dance moves in BTS.', 'Jimin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('07qouolb1x1ridq3qfiy0pa7bj9lgro7zw5nmn4fs9v8l5k24f','97dwhod3szyisai', 'https://i.scdn.co/image/ab67616d0000b2732b46078245d0120690eb560d', 'FACE','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ydou8774u07jbwi9ylgb4ffkvcblv0l1v3dryz2y0mavlynbbv','Like Crazy','97dwhod3szyisai','POP','3Ua0m0YmEjrMi9XErKcNiR','https://p.scdn.co/mp3-preview/2db5f36096963d97afc870c50990d62d27858a43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('07qouolb1x1ridq3qfiy0pa7bj9lgro7zw5nmn4fs9v8l5k24f', 'ydou8774u07jbwi9ylgb4ffkvcblv0l1v3dryz2y0mavlynbbv', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mhoxty9b6nzips1mzv6zguo0ydlgqg9lrm4oe3hfbs6ou2i8po','Set Me Free Pt.2','97dwhod3szyisai','POP','59hBR0BCtJsfIbV9VzCVAp','https://p.scdn.co/mp3-preview/275a3a0843bb55c251cda45ef17a905dab31624c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('07qouolb1x1ridq3qfiy0pa7bj9lgro7zw5nmn4fs9v8l5k24f', 'mhoxty9b6nzips1mzv6zguo0ydlgqg9lrm4oe3hfbs6ou2i8po', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zh7suww5lpn9x72jq4jg4gjmh7tz713c31vqwjyjgqk3ax0goj','Like Crazy (English Version)','97dwhod3szyisai','POP','0u8rZGtXJrLtiSe34FPjGG','https://p.scdn.co/mp3-preview/3752bae14d7952abe6f93649d85d53bfe98f1165?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('07qouolb1x1ridq3qfiy0pa7bj9lgro7zw5nmn4fs9v8l5k24f', 'zh7suww5lpn9x72jq4jg4gjmh7tz713c31vqwjyjgqk3ax0goj', '2');
-- Brenda Lee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3wyggzr5pzpywem', 'Brenda Lee', '264@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4ea49bdca366a3baa5cbb006','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:264@artist.com', '3wyggzr5pzpywem', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3wyggzr5pzpywem', 'The architect of aural landscapes that inspire and captivate.', 'Brenda Lee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vke7gm1wch0ktlojqz54ybl4891k45gyfcjsqm0fx0ynuwyx4a','3wyggzr5pzpywem', 'https://i.scdn.co/image/ab67616d0000b2737845f74d6db14b400fa61cd3', 'Merry Christmas From Brenda Lee','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6uvqqzezb74p7crbtfccbh7rrfazdm9yet2zpzrl9f2scew3x2','Rockin Around The Christmas Tree','3wyggzr5pzpywem','POP','2EjXfH91m7f8HiJN1yQg97',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vke7gm1wch0ktlojqz54ybl4891k45gyfcjsqm0fx0ynuwyx4a', '6uvqqzezb74p7crbtfccbh7rrfazdm9yet2zpzrl9f2scew3x2', '0');
-- Mc Livinho
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xakngbzbpycduh2', 'Mc Livinho', '265@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd353ef9564cfbb5f2b3bffb2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:265@artist.com', 'xakngbzbpycduh2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xakngbzbpycduh2', 'Bringing Brazilian funk rhythms to the global music stage.', 'Mc Livinho');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('chcoc1wvcg8k98y7rxshpxjzt79vs3qpvfr2bomjax69jrsvas','xakngbzbpycduh2', 'https://i.scdn.co/image/ab67616d0000b273369c960fed23353176da1218', 'Novidade na Área','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('auxds5pk91r4t98sioqgnm0l0t0flicoqr2wt0b1tss08ccc5n','Novidade na ','xakngbzbpycduh2','POP','2uhw2oYbugGJbn10wipNX5','https://p.scdn.co/mp3-preview/6bff8c1079d87a672d6b9ee5c3c6ca5e7d9ff45b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('chcoc1wvcg8k98y7rxshpxjzt79vs3qpvfr2bomjax69jrsvas', 'auxds5pk91r4t98sioqgnm0l0t0flicoqr2wt0b1tss08ccc5n', '0');
-- JVKE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1ou00umvsuaqgdn', 'JVKE', '266@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebce33386a81a202e149934ec1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:266@artist.com', '1ou00umvsuaqgdn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1ou00umvsuaqgdn', 'A rising star, blending heartfelt lyrics with catchy pop melodies.', 'JVKE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gec1k6f28i0eyswjic1lrae2k270ml6cutshw77r9jngyw9p24','1ou00umvsuaqgdn', 'https://i.scdn.co/image/ab67616d0000b273c2504e80ba2f258697ab2954', 'this is what ____ feels like (Vol. 1-4)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a9jf1nnwp7u1099gj8y785w4lb716rlsbli0zzkeifvn41shmz','golden hour','1ou00umvsuaqgdn','POP','5odlY52u43F5BjByhxg7wg','https://p.scdn.co/mp3-preview/bcc17f30841d6fbf3cd7954c3e3cf669f11b6a21?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gec1k6f28i0eyswjic1lrae2k270ml6cutshw77r9jngyw9p24', 'a9jf1nnwp7u1099gj8y785w4lb716rlsbli0zzkeifvn41shmz', '0');
-- Tainy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1xcy6pxvu5e74qc', 'Tainy', '267@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb50d43598b9074f0d6146127','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:267@artist.com', '1xcy6pxvu5e74qc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1xcy6pxvu5e74qc', 'Revolutionizing reggaeton and Latin music with groundbreaking production.', 'Tainy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3tiszokdyrj4oh1uiaafux34qpwbonzu3ab3zumnthgk5spmaj','1xcy6pxvu5e74qc', 'https://i.scdn.co/image/ab67616d0000b273de7b9af78fbdda96c5a0635b', 'DATA','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('icjpt5xsmecfbn1yho2t80bgr3vdz1coibq8w2q1kc2a0sydpd','MOJABI GHOST','1xcy6pxvu5e74qc','POP','4eMKD8MRroxCqugpsxCCNb','https://p.scdn.co/mp3-preview/a6d8180d52b759c3e3db9aa78e841ffc06e26c17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3tiszokdyrj4oh1uiaafux34qpwbonzu3ab3zumnthgk5spmaj', 'icjpt5xsmecfbn1yho2t80bgr3vdz1coibq8w2q1kc2a0sydpd', '0');


-- File: insert_relationships.sql
-- Users
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5ii5huqrlq3s15v', 'Bob Martinez (0)', '0@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:0@g.com', '5ii5huqrlq3s15v', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('79b58fdql3wtxea', 'Ivan Martinez (1)', '1@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:1@g.com', '79b58fdql3wtxea', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('g4gvug5lhxstax6', 'Edward Smith (2)', '2@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:2@g.com', 'g4gvug5lhxstax6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yocz02fm1a079fo', 'Charlie Martinez (3)', '3@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:3@g.com', 'yocz02fm1a079fo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3qr122jiudidw3w', 'George Davis (4)', '4@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:4@g.com', '3qr122jiudidw3w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v257vydj7xn0nlh', 'Bob Garcia (5)', '5@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:5@g.com', 'v257vydj7xn0nlh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5ov38nso4d495p3', 'George Davis (6)', '6@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:6@g.com', '5ov38nso4d495p3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dt5rag4r50ufszn', 'Ivan Rodriguez (7)', '7@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:7@g.com', 'dt5rag4r50ufszn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9ln6wtyyg7t74yj', 'Ivan Brown (8)', '8@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:8@g.com', '9ln6wtyyg7t74yj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ngilninmjxbbaxf', 'Diana Smith (9)', '9@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:9@g.com', 'ngilninmjxbbaxf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
-- Playlists
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('s2yomp5n8p78h2yea5op4ltj4k3hzkbv4cbt9pos7w82pwlpaa', 'Playlist 0', '2023-11-17 17:00:08.000','5ii5huqrlq3s15v');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jgqo619wp1xgetfjspf7ugi13rml4i3vh6gmzcv2w0v12cfugl', 's2yomp5n8p78h2yea5op4ltj4k3hzkbv4cbt9pos7w82pwlpaa', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('kklef58bmbwu8lx63z4vgrdrvhl2u2zomktvhb6gv4haifefy4', 's2yomp5n8p78h2yea5op4ltj4k3hzkbv4cbt9pos7w82pwlpaa', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5nwvjxexhqwjfqp3qz8h552z1dydfu8yikb7lge79y5h0abn7j', 's2yomp5n8p78h2yea5op4ltj4k3hzkbv4cbt9pos7w82pwlpaa', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bo1bbpjab4te9okrkby6dy9c3jd8tt6nsg3oxwb5hngkaefrin', 's2yomp5n8p78h2yea5op4ltj4k3hzkbv4cbt9pos7w82pwlpaa', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('j7gnku83onq7n3irdlw3x71s586364hdwvw3y7qhvjde3o23gy', 's2yomp5n8p78h2yea5op4ltj4k3hzkbv4cbt9pos7w82pwlpaa', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hym8trqnpl50dn9qgq6s66qd8hoxxcbll83in8f0s6ioh38e78', 's2yomp5n8p78h2yea5op4ltj4k3hzkbv4cbt9pos7w82pwlpaa', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('72w1b86md4tu1fmsuy03jkjk1tgv46cke6z6wyw3887eppesuo', 's2yomp5n8p78h2yea5op4ltj4k3hzkbv4cbt9pos7w82pwlpaa', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zh7suww5lpn9x72jq4jg4gjmh7tz713c31vqwjyjgqk3ax0goj', 's2yomp5n8p78h2yea5op4ltj4k3hzkbv4cbt9pos7w82pwlpaa', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r9f0xpawdhrjvtnio8jbo8obm6tn3zczuw5omxmzxtd2liizdx', 's2yomp5n8p78h2yea5op4ltj4k3hzkbv4cbt9pos7w82pwlpaa', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2hhp96rsivgwpkqd709ho25err3dmw0qzgkpt5vy76u0hnn2ym', 's2yomp5n8p78h2yea5op4ltj4k3hzkbv4cbt9pos7w82pwlpaa', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('emquqb8osya10i6dcop2wpe4i29ccja28dc3kpj0h2ihxfgc5j', 'Playlist 1', '2023-11-17 17:00:08.000','5ii5huqrlq3s15v');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('02e72oymv0hbh84xlbex79aki44opaslzw1lryiibub29xep1f', 'emquqb8osya10i6dcop2wpe4i29ccja28dc3kpj0h2ihxfgc5j', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('iadpshn11f894ehfcf31o1xzcxxahxijv0dnkkmb1ffibdq30z', 'emquqb8osya10i6dcop2wpe4i29ccja28dc3kpj0h2ihxfgc5j', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('v30glqibrmww00xlefe1jtjkdni2zyeak9knyq6dh9i7q1z474', 'emquqb8osya10i6dcop2wpe4i29ccja28dc3kpj0h2ihxfgc5j', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('lq48tcm2k343edmyl2k6rsjff2ookvbo6d1aq2tuwnkn67d6sc', 'emquqb8osya10i6dcop2wpe4i29ccja28dc3kpj0h2ihxfgc5j', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3k1xpc9jillq1kix1odkiuk2xo8s6z7418owlksl8erfdca1pc', 'emquqb8osya10i6dcop2wpe4i29ccja28dc3kpj0h2ihxfgc5j', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tirrhpzzf0sdv4wy5pxb8cus9x2imkh8st06jqj6vcguh9rt29', 'emquqb8osya10i6dcop2wpe4i29ccja28dc3kpj0h2ihxfgc5j', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('liq2xhfu1bwfjky3zg6er94ippe3u3q8jfm37qsp8pwqxaea40', 'emquqb8osya10i6dcop2wpe4i29ccja28dc3kpj0h2ihxfgc5j', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7kfqj3lzua17qdrzno0abwfjj2e2zsotc8lvztgdfvlpm04c6z', 'emquqb8osya10i6dcop2wpe4i29ccja28dc3kpj0h2ihxfgc5j', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h1tq45d7retobhrgr9krvgv31gwp9pfppuw6d94pb97ai331l8', 'emquqb8osya10i6dcop2wpe4i29ccja28dc3kpj0h2ihxfgc5j', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xi0qzaweaqa9duwgbur67j5gfb1ojep9aiofw0qrj31qw9dpgz', 'emquqb8osya10i6dcop2wpe4i29ccja28dc3kpj0h2ihxfgc5j', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('3xkvfye1z6v7rciueeaqsh05x0iojz93h4k2tm5lyx3xkzm3br', 'Playlist 0', '2023-11-17 17:00:08.000','79b58fdql3wtxea');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5hio7seg1182j3fxhpriwt4ocnbyyx3ehf6ussutj7m9h9ns4w', '3xkvfye1z6v7rciueeaqsh05x0iojz93h4k2tm5lyx3xkzm3br', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xr6ul0zxp7ic6qmbrpkgwyqgwiwxb3xzaulqnv8h19j2q0mg94', '3xkvfye1z6v7rciueeaqsh05x0iojz93h4k2tm5lyx3xkzm3br', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gss6l4n43knfgeegi73p8v5xc4px251qs4nvvavki26yc0g2vz', '3xkvfye1z6v7rciueeaqsh05x0iojz93h4k2tm5lyx3xkzm3br', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7kfqj3lzua17qdrzno0abwfjj2e2zsotc8lvztgdfvlpm04c6z', '3xkvfye1z6v7rciueeaqsh05x0iojz93h4k2tm5lyx3xkzm3br', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ix5j3h0vwkgmgim0spvbdcks4r73xyfreq24qp2kpopceuf5bn', '3xkvfye1z6v7rciueeaqsh05x0iojz93h4k2tm5lyx3xkzm3br', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bovt5l87j3fs07pa1rsvvp73hzq6dhcozbpub1vdia3bfm2a1b', '3xkvfye1z6v7rciueeaqsh05x0iojz93h4k2tm5lyx3xkzm3br', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6xzk598jm6zks9yz7vr4psqy00ggos3o26ts0smzbgxs5aouf5', '3xkvfye1z6v7rciueeaqsh05x0iojz93h4k2tm5lyx3xkzm3br', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6vrxah50xakfknq12txvkngjzwxcfn43skohx6re8lays3i2jr', '3xkvfye1z6v7rciueeaqsh05x0iojz93h4k2tm5lyx3xkzm3br', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zb0adgflrhgf4bfacvw8e8ntlc13y3ojpc8yf8xhbpvjn568bs', '3xkvfye1z6v7rciueeaqsh05x0iojz93h4k2tm5lyx3xkzm3br', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t0ti792ielnj3fgsi5vsaxwjwbht61oogj72s047mmrvgvt5he', '3xkvfye1z6v7rciueeaqsh05x0iojz93h4k2tm5lyx3xkzm3br', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('x5ghb91b6iiafk1k94wsqdv94648ekkn0m7m93daiti6hdtac5', 'Playlist 1', '2023-11-17 17:00:08.000','79b58fdql3wtxea');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('em1a3qkl4r9u4ggdsz926pgcp8cl2nmtvaqbzdprxtpovxc5wa', 'x5ghb91b6iiafk1k94wsqdv94648ekkn0m7m93daiti6hdtac5', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tm6uy30s8kcjye70ech5xkabkoh4asjs2y3rexu5aceqd64eya', 'x5ghb91b6iiafk1k94wsqdv94648ekkn0m7m93daiti6hdtac5', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('45sydhdsxkdkbalp3xdczwg1lpmnsieo3s5k1n54ab6kacw2j2', 'x5ghb91b6iiafk1k94wsqdv94648ekkn0m7m93daiti6hdtac5', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4rphi63drvcnlgkl6edl6llk2fhz9pb5qfonj8dh078bd3ee0w', 'x5ghb91b6iiafk1k94wsqdv94648ekkn0m7m93daiti6hdtac5', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('auxds5pk91r4t98sioqgnm0l0t0flicoqr2wt0b1tss08ccc5n', 'x5ghb91b6iiafk1k94wsqdv94648ekkn0m7m93daiti6hdtac5', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3e4oq81ien4diygtu15uj8e883qrtlegznlej5r8vnuckye30s', 'x5ghb91b6iiafk1k94wsqdv94648ekkn0m7m93daiti6hdtac5', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pj02gluqh0zcdlxcte9gy2viyh15q3c76hp17ietmpdne6ey02', 'x5ghb91b6iiafk1k94wsqdv94648ekkn0m7m93daiti6hdtac5', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('u3ex3bu45ycgt5q8p2pz90sddl7fpvb5azaik2lqcblvw9l0ey', 'x5ghb91b6iiafk1k94wsqdv94648ekkn0m7m93daiti6hdtac5', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gvareg5mcks0k2uy66jo4ie8ao1qo7z8m89z0dm6lt81h5d4bg', 'x5ghb91b6iiafk1k94wsqdv94648ekkn0m7m93daiti6hdtac5', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('auujvofdy6wobhhqyh7m5fp8qgehoj9snj9yghyvgqn9l90zzf', 'x5ghb91b6iiafk1k94wsqdv94648ekkn0m7m93daiti6hdtac5', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('vcz528n4z5cn0l8elygroxr0u96lf4ardo0wpdkok8lxbgg6uo', 'Playlist 0', '2023-11-17 17:00:08.000','g4gvug5lhxstax6');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yglivicd8xwteg46a9bfevxu7iy8unhq3738e3b6bal1k4ejtk', 'vcz528n4z5cn0l8elygroxr0u96lf4ardo0wpdkok8lxbgg6uo', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('g5l5br3u1zca7xnmm4o6yq01nwtnwomh9lq6jy5zvkg9gmdt6j', 'vcz528n4z5cn0l8elygroxr0u96lf4ardo0wpdkok8lxbgg6uo', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7skhw48gtepy6qlbc7sjmveb7310zg8y9d5qsx9yva4rgmytqk', 'vcz528n4z5cn0l8elygroxr0u96lf4ardo0wpdkok8lxbgg6uo', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ms4aax2dgpqkp4ul03ag6qsf7l8ov8xafv4nt67cgtciqmwgn9', 'vcz528n4z5cn0l8elygroxr0u96lf4ardo0wpdkok8lxbgg6uo', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nwptpt1zhvu09u5v2u7tobiy5caopsx2ltn7tpjls4kku9f9y6', 'vcz528n4z5cn0l8elygroxr0u96lf4ardo0wpdkok8lxbgg6uo', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('s7xsbz925zx7mfn0xjyen0fy156mvohfbzin7l5h71i9bbcmzy', 'vcz528n4z5cn0l8elygroxr0u96lf4ardo0wpdkok8lxbgg6uo', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('y5c6op6cbxuab72h88tog2aliefni8pzcs9z6rawudbu199zmo', 'vcz528n4z5cn0l8elygroxr0u96lf4ardo0wpdkok8lxbgg6uo', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zwehlv44tejt3jpdf9ai9aznvgm79wpoog4ohtd4kg4p4vr387', 'vcz528n4z5cn0l8elygroxr0u96lf4ardo0wpdkok8lxbgg6uo', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z7o4ke43j5hpex1vx0q3fq5x0m71ixqyi0x4oparskqefqfldh', 'vcz528n4z5cn0l8elygroxr0u96lf4ardo0wpdkok8lxbgg6uo', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nq8jbjqesspf1qchzxbg3809esit64t5df5o2sr6xb2wywscd6', 'vcz528n4z5cn0l8elygroxr0u96lf4ardo0wpdkok8lxbgg6uo', 2);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('wnwv7bbq8rhg5rcromw6sdhb08lc7xx4vjp8op33wuiyuehkqp', 'Playlist 1', '2023-11-17 17:00:08.000','g4gvug5lhxstax6');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h1tq45d7retobhrgr9krvgv31gwp9pfppuw6d94pb97ai331l8', 'wnwv7bbq8rhg5rcromw6sdhb08lc7xx4vjp8op33wuiyuehkqp', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h7taqp889bxrr7z6hio0j3k26qyfg3xj5scmhq1i6fr281gel4', 'wnwv7bbq8rhg5rcromw6sdhb08lc7xx4vjp8op33wuiyuehkqp', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xqkbbbk8ys21fs0xnjwzqddvv711p7ennjqt1tt434z59us7tk', 'wnwv7bbq8rhg5rcromw6sdhb08lc7xx4vjp8op33wuiyuehkqp', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hhivqp46lgcap71wrzhdkvjy652qpzz4vva8mmo14svmuaqn37', 'wnwv7bbq8rhg5rcromw6sdhb08lc7xx4vjp8op33wuiyuehkqp', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gl72tkvv1vxut80c520l9ge953lt101ouhpr9ain0ewpu7hzr1', 'wnwv7bbq8rhg5rcromw6sdhb08lc7xx4vjp8op33wuiyuehkqp', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bt67f7lau76ig4ghdpt9wlubm59lc0595tz11cmvzp3za5i23e', 'wnwv7bbq8rhg5rcromw6sdhb08lc7xx4vjp8op33wuiyuehkqp', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('txevoxtz5mgh7axj2njeb9cwr6e8rwrwjyt5juknpaf98f128t', 'wnwv7bbq8rhg5rcromw6sdhb08lc7xx4vjp8op33wuiyuehkqp', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mpbhdelftnv99fhkng60rvygupmz24dbys4l1oyrddhlzvjihm', 'wnwv7bbq8rhg5rcromw6sdhb08lc7xx4vjp8op33wuiyuehkqp', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('y1gqgf8gf7tlsrsnoy8zoa5dnob4pnt07xj4lbn81rh6vd25vd', 'wnwv7bbq8rhg5rcromw6sdhb08lc7xx4vjp8op33wuiyuehkqp', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7skhw48gtepy6qlbc7sjmveb7310zg8y9d5qsx9yva4rgmytqk', 'wnwv7bbq8rhg5rcromw6sdhb08lc7xx4vjp8op33wuiyuehkqp', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('y2wruk127kahqn7vvdij87forl17taehkoc8tquyxmnszta0l5', 'Playlist 0', '2023-11-17 17:00:08.000','yocz02fm1a079fo');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cqqe6c2pt949r0ywqauyftbkt4zqffzub2l5fi7lg18tbpctvu', 'y2wruk127kahqn7vvdij87forl17taehkoc8tquyxmnszta0l5', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('w9m60qqzctg5lkefl4sui8eojsnvx8cycyak95uygor0zgtl2c', 'y2wruk127kahqn7vvdij87forl17taehkoc8tquyxmnszta0l5', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3ezi2a213167nfd7aybvmqhj62v3j5lm5wxd6tilxdzaoo4wo6', 'y2wruk127kahqn7vvdij87forl17taehkoc8tquyxmnszta0l5', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t0erpjo3hyxehrijzoq71go5xymfvwxphxn7qw5r7lnzt03pqh', 'y2wruk127kahqn7vvdij87forl17taehkoc8tquyxmnszta0l5', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('l419ch2u2jlfy4bv3erne3ran3fvri0iv9279ynjn6grl9ddwd', 'y2wruk127kahqn7vvdij87forl17taehkoc8tquyxmnszta0l5', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('csvif5fseh4l4z4hfahf90whlrwmlybsf15etbq90p7g3j3sij', 'y2wruk127kahqn7vvdij87forl17taehkoc8tquyxmnszta0l5', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('uqe9dwjovn8xozinxwb89a1m4kbthdpiehps015hoaee2oj6e7', 'y2wruk127kahqn7vvdij87forl17taehkoc8tquyxmnszta0l5', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1lip0h1jhgiavbza72zl61qkj3eg6fpua67yezm2quou6oqaxb', 'y2wruk127kahqn7vvdij87forl17taehkoc8tquyxmnszta0l5', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cchvigtanf654ancuxutzgq0zlw2mmxlr1x422a6q11wbfoll8', 'y2wruk127kahqn7vvdij87forl17taehkoc8tquyxmnszta0l5', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ojx5fdohgss4d9cyxtjv2oghpipanlnu8mjs7mlnmgb4av8ii3', 'y2wruk127kahqn7vvdij87forl17taehkoc8tquyxmnszta0l5', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('n73c24ynyew87j3cmvf5ix7kzm4rrp02yau0ufb3clhslco7os', 'Playlist 1', '2023-11-17 17:00:08.000','yocz02fm1a079fo');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gl72tkvv1vxut80c520l9ge953lt101ouhpr9ain0ewpu7hzr1', 'n73c24ynyew87j3cmvf5ix7kzm4rrp02yau0ufb3clhslco7os', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1eyy3xrg2jup5ws6l4kq60k9ru4s942plxr0m2apjplsmo74hd', 'n73c24ynyew87j3cmvf5ix7kzm4rrp02yau0ufb3clhslco7os', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('s7xsbz925zx7mfn0xjyen0fy156mvohfbzin7l5h71i9bbcmzy', 'n73c24ynyew87j3cmvf5ix7kzm4rrp02yau0ufb3clhslco7os', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ks0jjxvb6zsgsli645g6adp7ao0ihdzwhzbf5l9v0gsxl39pcp', 'n73c24ynyew87j3cmvf5ix7kzm4rrp02yau0ufb3clhslco7os', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('szqfxxfufh5nr79ziomq6dn7rq25drgc9uwd4wpruq5red5f1k', 'n73c24ynyew87j3cmvf5ix7kzm4rrp02yau0ufb3clhslco7os', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bt67f7lau76ig4ghdpt9wlubm59lc0595tz11cmvzp3za5i23e', 'n73c24ynyew87j3cmvf5ix7kzm4rrp02yau0ufb3clhslco7os', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('w9m60qqzctg5lkefl4sui8eojsnvx8cycyak95uygor0zgtl2c', 'n73c24ynyew87j3cmvf5ix7kzm4rrp02yau0ufb3clhslco7os', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fago9dkhyr15aq9n3i88ds143thct0n8g25n5cqcf457nk6vqy', 'n73c24ynyew87j3cmvf5ix7kzm4rrp02yau0ufb3clhslco7os', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h2zprkccipwg1jvwmmn2buoof8rgzz8hr5qp077g4qm3fdsqp1', 'n73c24ynyew87j3cmvf5ix7kzm4rrp02yau0ufb3clhslco7os', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('i03ml727c0pl3xqy0ae3zuzi76ae2x5oxmwjtttr3t9t2iwzjj', 'n73c24ynyew87j3cmvf5ix7kzm4rrp02yau0ufb3clhslco7os', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('0l659dumjrm69gcc3bxqo6261hda9cju8ishvu1i01ew9tumcd', 'Playlist 0', '2023-11-17 17:00:08.000','3qr122jiudidw3w');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jvuh4gykdyx3n0tew3flit5xlipbdi1phql1mjhrc9ciaj5xjl', '0l659dumjrm69gcc3bxqo6261hda9cju8ishvu1i01ew9tumcd', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z3xt05c4x2x4p5yhci7nhptk879ml42z5xldcl0pd60lezp144', '0l659dumjrm69gcc3bxqo6261hda9cju8ishvu1i01ew9tumcd', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8lsvporcbdwoda6b6xaev99cdeggl0n68gum33xqh10fb3ajyr', '0l659dumjrm69gcc3bxqo6261hda9cju8ishvu1i01ew9tumcd', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0bwptmnwcji8c2h6xqlj6fezw5abl452h0wjxrg3j3zy0fezpi', '0l659dumjrm69gcc3bxqo6261hda9cju8ishvu1i01ew9tumcd', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cggbxlbkafnsizzf6tdo0s1wo20p8mc817mgzqu810iq1t4okg', '0l659dumjrm69gcc3bxqo6261hda9cju8ishvu1i01ew9tumcd', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('v4rzqnnl80i4y0k7pkkl17ocyenp6n6r18wbuwnvknm68zpa2s', '0l659dumjrm69gcc3bxqo6261hda9cju8ishvu1i01ew9tumcd', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gfecftrropyypp9pkjyjae5wlho7s1eq9ewxove01igsjm5p8y', '0l659dumjrm69gcc3bxqo6261hda9cju8ishvu1i01ew9tumcd', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4u1ma8zswecmnno8nvjgtydjruibk2ac8slejm7zgvxa5opvrj', '0l659dumjrm69gcc3bxqo6261hda9cju8ishvu1i01ew9tumcd', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1lcc1p6o8l5qqvvp1n7qtsnuc34gaxtriwwhps64y0wma2zrbx', '0l659dumjrm69gcc3bxqo6261hda9cju8ishvu1i01ew9tumcd', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nlvbpnh5eemgy6rdvv4p8ac7wgfdchgzyud2abp7sc77vsq8n4', '0l659dumjrm69gcc3bxqo6261hda9cju8ishvu1i01ew9tumcd', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('0zw1gt3wr226g5qfezvfzcsqrk637ndll93aqqupwlj0t3z9fr', 'Playlist 1', '2023-11-17 17:00:08.000','3qr122jiudidw3w');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9qyrsm6a2zpimxgfmfuv1h6o0kcdmu5833ok77tijxasvo1oaf', '0zw1gt3wr226g5qfezvfzcsqrk637ndll93aqqupwlj0t3z9fr', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nbtej2xkzs372wdlc7kr2k13yriqmgzjqc3nkf5lyjafsgm1kf', '0zw1gt3wr226g5qfezvfzcsqrk637ndll93aqqupwlj0t3z9fr', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('k9wxa87ptuh3uieot3j0e0yglbi6mg7q58wmqbrsdkdluz6ubo', '0zw1gt3wr226g5qfezvfzcsqrk637ndll93aqqupwlj0t3z9fr', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8yeypude568menss46muanybxccacas08kse5go43hszj3y4tx', '0zw1gt3wr226g5qfezvfzcsqrk637ndll93aqqupwlj0t3z9fr', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mw1oo7ftxi9knt0zjns4js59m7lkol7i9nd7etnrzw3if7ikv9', '0zw1gt3wr226g5qfezvfzcsqrk637ndll93aqqupwlj0t3z9fr', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2c0y83khmi1hka4kbz3lbfx3ee3eegu9xu3gvtc0xlrke0sxx7', '0zw1gt3wr226g5qfezvfzcsqrk637ndll93aqqupwlj0t3z9fr', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2xu4sblqoub7sruvhztlfxj23wzaw8t7f0inovcf9jwoq9peeq', '0zw1gt3wr226g5qfezvfzcsqrk637ndll93aqqupwlj0t3z9fr', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7obhzb93qq4lwhndmyhbvhg8tj4ygexxm2dz852lhjakmt34h5', '0zw1gt3wr226g5qfezvfzcsqrk637ndll93aqqupwlj0t3z9fr', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vlqkptpa0o805lie7pe2l7jl7u2v5didvpiypd0htibdq15zim', '0zw1gt3wr226g5qfezvfzcsqrk637ndll93aqqupwlj0t3z9fr', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0zk1masxx73l2eve022vintx9wju1lv9ziz734tkot7qm9etzg', '0zw1gt3wr226g5qfezvfzcsqrk637ndll93aqqupwlj0t3z9fr', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('6lswx223hmzvk3wxfbbrh8ljruuxt2vebi7i8x9ju2qyjuxwbi', 'Playlist 0', '2023-11-17 17:00:08.000','v257vydj7xn0nlh');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('o1k8fei4zzecmv1xt8n1mdee2k1erz094038wixwmmwr3wxaxe', '6lswx223hmzvk3wxfbbrh8ljruuxt2vebi7i8x9ju2qyjuxwbi', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('k3p8yw6langkcrxj2qj9c0orrt6p05ukwr3hwvyvn3211cgdfd', '6lswx223hmzvk3wxfbbrh8ljruuxt2vebi7i8x9ju2qyjuxwbi', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('n97mkl70isaxlnzbdgza9sz5qc0r9is7fmqtsgpzpzvi2vc2qv', '6lswx223hmzvk3wxfbbrh8ljruuxt2vebi7i8x9ju2qyjuxwbi', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4kcxxq8r78cb73kars8tva93sw8sfaag3u9ohghsijbm4x9dyv', '6lswx223hmzvk3wxfbbrh8ljruuxt2vebi7i8x9ju2qyjuxwbi', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bv5wi6lisowme9jybr33wpqng6ke1u9pah4a96rumq97ch2xos', '6lswx223hmzvk3wxfbbrh8ljruuxt2vebi7i8x9ju2qyjuxwbi', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('k9wxa87ptuh3uieot3j0e0yglbi6mg7q58wmqbrsdkdluz6ubo', '6lswx223hmzvk3wxfbbrh8ljruuxt2vebi7i8x9ju2qyjuxwbi', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1213xa09yy31lf4nz8wg1ujdnpkd8rjewkuqqye1e0sk1kvbjm', '6lswx223hmzvk3wxfbbrh8ljruuxt2vebi7i8x9ju2qyjuxwbi', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0rovztu72c1w4qa4118udrpw90lr33i11vxelvboqiktsaaaml', '6lswx223hmzvk3wxfbbrh8ljruuxt2vebi7i8x9ju2qyjuxwbi', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('piykahgehe4orle0hepopbtzwg30e1ue3rvjqnqc021jg5dcss', '6lswx223hmzvk3wxfbbrh8ljruuxt2vebi7i8x9ju2qyjuxwbi', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('l419ch2u2jlfy4bv3erne3ran3fvri0iv9279ynjn6grl9ddwd', '6lswx223hmzvk3wxfbbrh8ljruuxt2vebi7i8x9ju2qyjuxwbi', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('4k189ylvle4vexs8glqagkk3ol04vufgr0je7ovbzapyrn3zho', 'Playlist 1', '2023-11-17 17:00:08.000','v257vydj7xn0nlh');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ob4sb91wwirashkj31in2v52aim1l2tzxgishypcj1fo21ni2h', '4k189ylvle4vexs8glqagkk3ol04vufgr0je7ovbzapyrn3zho', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nf5anmxxbv3wlwu0516bdg4mt9515mexc219uud7cvgskvdltp', '4k189ylvle4vexs8glqagkk3ol04vufgr0je7ovbzapyrn3zho', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('q98r4qqb7k2te0fum4rfsschtu9f6vrltvace2ixq81ulh4ucg', '4k189ylvle4vexs8glqagkk3ol04vufgr0je7ovbzapyrn3zho', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jvuh4gykdyx3n0tew3flit5xlipbdi1phql1mjhrc9ciaj5xjl', '4k189ylvle4vexs8glqagkk3ol04vufgr0je7ovbzapyrn3zho', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3e4oq81ien4diygtu15uj8e883qrtlegznlej5r8vnuckye30s', '4k189ylvle4vexs8glqagkk3ol04vufgr0je7ovbzapyrn3zho', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9jv4z2dubzpmnejiwjzg0vbe6igh462ryfbbj1ccnpeg392ste', '4k189ylvle4vexs8glqagkk3ol04vufgr0je7ovbzapyrn3zho', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z1e9vhu8fk6d7mifdb62lva6ql77hmv7uduit2nixbs4yeg3s4', '4k189ylvle4vexs8glqagkk3ol04vufgr0je7ovbzapyrn3zho', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h2zprkccipwg1jvwmmn2buoof8rgzz8hr5qp077g4qm3fdsqp1', '4k189ylvle4vexs8glqagkk3ol04vufgr0je7ovbzapyrn3zho', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9qyrsm6a2zpimxgfmfuv1h6o0kcdmu5833ok77tijxasvo1oaf', '4k189ylvle4vexs8glqagkk3ol04vufgr0je7ovbzapyrn3zho', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pqzvx41rsmfvwi3ezuql7kek2iusds4djy0wsxxtj1s97dh4hc', '4k189ylvle4vexs8glqagkk3ol04vufgr0je7ovbzapyrn3zho', 5);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('8fnqldwmnpva48mxi1rvnmem8cd1aa3hjimandqjotybz8f3mq', 'Playlist 0', '2023-11-17 17:00:08.000','5ov38nso4d495p3');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zlk8wbc902s7nd8sdrmv4384shg2rnjlrcmspstkbf9swwmbgc', '8fnqldwmnpva48mxi1rvnmem8cd1aa3hjimandqjotybz8f3mq', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6iepl8pdaw7xjyn1qe0f4ekkp0wnmx6c62x8wn1x31uzkvhcqu', '8fnqldwmnpva48mxi1rvnmem8cd1aa3hjimandqjotybz8f3mq', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3snxfly0v0r00wni7qfnfil67ooa8jurt6qxfxn598v3i5fkis', '8fnqldwmnpva48mxi1rvnmem8cd1aa3hjimandqjotybz8f3mq', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('f3y2bng2wqrh03qzb2np4hh5923gduoe34au73kdypoa26vp5c', '8fnqldwmnpva48mxi1rvnmem8cd1aa3hjimandqjotybz8f3mq', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('467no6tsztu9xj6raaczkd4jrkrgzd5fwtvtdxm77zogtqv9vj', '8fnqldwmnpva48mxi1rvnmem8cd1aa3hjimandqjotybz8f3mq', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xwxnitoch8b7xbevdv00n2p6h9sqcttxazzb14aofcf8muqmef', '8fnqldwmnpva48mxi1rvnmem8cd1aa3hjimandqjotybz8f3mq', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yu4iewlm4q349idabvhrums56hl0f8wxpzc3ymjhf8peh3pdps', '8fnqldwmnpva48mxi1rvnmem8cd1aa3hjimandqjotybz8f3mq', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z1e9vhu8fk6d7mifdb62lva6ql77hmv7uduit2nixbs4yeg3s4', '8fnqldwmnpva48mxi1rvnmem8cd1aa3hjimandqjotybz8f3mq', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8e3e20de8zdoo2tqz1hyqgmsqso6t4338kqzsllnlmafibmdpf', '8fnqldwmnpva48mxi1rvnmem8cd1aa3hjimandqjotybz8f3mq', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('lrahra5oicqu0fux3gsxeb99u71yag7st3pz1pcvwd7ymjz2sm', '8fnqldwmnpva48mxi1rvnmem8cd1aa3hjimandqjotybz8f3mq', 1);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('w3v0wdd230zsebyhmcrm14qrinkxj7ie1xt1fvagbca3l7n0gz', 'Playlist 1', '2023-11-17 17:00:08.000','5ov38nso4d495p3');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m4i0lan9f4c1ceda6w9gtpeeuwe5sdrsifrn9ry3samyikpcun', 'w3v0wdd230zsebyhmcrm14qrinkxj7ie1xt1fvagbca3l7n0gz', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hghb961ki99uwr3ot57h3cu3zy7m1rp1ysst1wste233uht11j', 'w3v0wdd230zsebyhmcrm14qrinkxj7ie1xt1fvagbca3l7n0gz', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d5q9qdg9ypku6xud6rpwjytb535qzxs334ogi380dc1cnl1wqz', 'w3v0wdd230zsebyhmcrm14qrinkxj7ie1xt1fvagbca3l7n0gz', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ukac6tnoicu7w40jl1rgq15qtdsg5nzq8e2z72igfyvepbne4r', 'w3v0wdd230zsebyhmcrm14qrinkxj7ie1xt1fvagbca3l7n0gz', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('oz2w4iqhnlmjjl3ue9zely4legn8ayqe74dexhuf4s3sdsq7xl', 'w3v0wdd230zsebyhmcrm14qrinkxj7ie1xt1fvagbca3l7n0gz', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7332ouigtglri0trp2ewaxx6z7tnhz95wt014cfls2e7ec5fm7', 'w3v0wdd230zsebyhmcrm14qrinkxj7ie1xt1fvagbca3l7n0gz', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3i0anx66gs5pfcxefspo2qkyq499hc3xzoqkz38smi12t2mabz', 'w3v0wdd230zsebyhmcrm14qrinkxj7ie1xt1fvagbca3l7n0gz', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dyd6dnf5e0gk52zfx2b97jghz4965pafk7dkj7lmmvyyhmyfrj', 'w3v0wdd230zsebyhmcrm14qrinkxj7ie1xt1fvagbca3l7n0gz', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('f00bo6nikvww6kddovgquyspx7h1mgwvug45ymsqlo8je945uj', 'w3v0wdd230zsebyhmcrm14qrinkxj7ie1xt1fvagbca3l7n0gz', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('x5yg0s15fiy54w0ipx1eoevzbyzm6joe1mrph9tfyxw02qraun', 'w3v0wdd230zsebyhmcrm14qrinkxj7ie1xt1fvagbca3l7n0gz', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('3qx3779fucie2kpbig3zpw3e316elcfu4jmuvjett8go6derxt', 'Playlist 0', '2023-11-17 17:00:08.000','dt5rag4r50ufszn');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gbv678g9gh9lle2r9x5k9jins3dtb9w0vo442qgtdn2pfm8drj', '3qx3779fucie2kpbig3zpw3e316elcfu4jmuvjett8go6derxt', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('go6v8hiprku8spcx8wvgf53vkymvypz8ge43l84skjjm59wmk8', '3qx3779fucie2kpbig3zpw3e316elcfu4jmuvjett8go6derxt', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e0ee4ddtj0xa40h3fxrrkem1o7dj4c93j45a3va0qs76aogvkc', '3qx3779fucie2kpbig3zpw3e316elcfu4jmuvjett8go6derxt', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ydou8774u07jbwi9ylgb4ffkvcblv0l1v3dryz2y0mavlynbbv', '3qx3779fucie2kpbig3zpw3e316elcfu4jmuvjett8go6derxt', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2720wsw2t58frrsd1w36xn5iqddgkvnq2ruhn32gi7p5crbvif', '3qx3779fucie2kpbig3zpw3e316elcfu4jmuvjett8go6derxt', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sg8liz0v79chrw5bm8jmy8na6x1jfb28nbpl62dmhrcpcdw03y', '3qx3779fucie2kpbig3zpw3e316elcfu4jmuvjett8go6derxt', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hyn8diuxxu1efk76r7ma8pqjpgyh6wjjuxuewhh02spx7f1lvx', '3qx3779fucie2kpbig3zpw3e316elcfu4jmuvjett8go6derxt', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8yeypude568menss46muanybxccacas08kse5go43hszj3y4tx', '3qx3779fucie2kpbig3zpw3e316elcfu4jmuvjett8go6derxt', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4uozw2nw3mb9xj282w45zhep78bswn103wc1axmalhp622llkp', '3qx3779fucie2kpbig3zpw3e316elcfu4jmuvjett8go6derxt', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pt7vlquc2qg9ddu33dnq91owfo0kzi1q67cr62t60yekkc4ehz', '3qx3779fucie2kpbig3zpw3e316elcfu4jmuvjett8go6derxt', 5);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('636d2kbfyiq83bysmflijisoklad3czyca6me80uakeeuuulf6', 'Playlist 1', '2023-11-17 17:00:08.000','dt5rag4r50ufszn');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xyouboj9zk6lwcxm8bnan2nrsdnupdvze6pz2b3gr4cc1vywb1', '636d2kbfyiq83bysmflijisoklad3czyca6me80uakeeuuulf6', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gfecftrropyypp9pkjyjae5wlho7s1eq9ewxove01igsjm5p8y', '636d2kbfyiq83bysmflijisoklad3czyca6me80uakeeuuulf6', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vxtouxm5yx63w81phgpkzhw5wlif5iqomt8ka3qe3iuxzfknt5', '636d2kbfyiq83bysmflijisoklad3czyca6me80uakeeuuulf6', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('p4hdkcv4eaz9n99bs1o0xkzgktx9vcjynyxondppja0h7mw46s', '636d2kbfyiq83bysmflijisoklad3czyca6me80uakeeuuulf6', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jwprubuqi8ugala49mtkhpp9ne64x3lwvb4tx871o2ii3y0u6a', '636d2kbfyiq83bysmflijisoklad3czyca6me80uakeeuuulf6', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z7o4ke43j5hpex1vx0q3fq5x0m71ixqyi0x4oparskqefqfldh', '636d2kbfyiq83bysmflijisoklad3czyca6me80uakeeuuulf6', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('y5c6op6cbxuab72h88tog2aliefni8pzcs9z6rawudbu199zmo', '636d2kbfyiq83bysmflijisoklad3czyca6me80uakeeuuulf6', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6r163yjwc6soylf6wuzfc40e5pzrdxld068qgkftx9cpzglv2a', '636d2kbfyiq83bysmflijisoklad3czyca6me80uakeeuuulf6', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9gc96hbdav6xq5di36y8vo647mvoaqzmzvu6x8rso051j2y8b8', '636d2kbfyiq83bysmflijisoklad3czyca6me80uakeeuuulf6', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6e0g7uc5k4f2ijw3h94z6uuinqk0o85ip2iqekh3lyb5a0kjc4', '636d2kbfyiq83bysmflijisoklad3czyca6me80uakeeuuulf6', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('u37g5qxll367vrlk76p9dg8xg4ki5h2o0requwvofm2kinnq0x', 'Playlist 0', '2023-11-17 17:00:08.000','9ln6wtyyg7t74yj');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3ezi2a213167nfd7aybvmqhj62v3j5lm5wxd6tilxdzaoo4wo6', 'u37g5qxll367vrlk76p9dg8xg4ki5h2o0requwvofm2kinnq0x', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('a1e2nk8b9h28yuzbm91wwojf1npnba5ibnpna4ta85m4o2xjmh', 'u37g5qxll367vrlk76p9dg8xg4ki5h2o0requwvofm2kinnq0x', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('o1k8fei4zzecmv1xt8n1mdee2k1erz094038wixwmmwr3wxaxe', 'u37g5qxll367vrlk76p9dg8xg4ki5h2o0requwvofm2kinnq0x', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('astts0995v1qwa1w498l2lq9xxfy05evb02tmsm8gez5arp19e', 'u37g5qxll367vrlk76p9dg8xg4ki5h2o0requwvofm2kinnq0x', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('afzbqq93426zxaboijngq22ao04eksf5m7hvduu1ws33zg37gl', 'u37g5qxll367vrlk76p9dg8xg4ki5h2o0requwvofm2kinnq0x', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('q4n0bzjhkihl8sqabt52l3khmzm5iuautqxhfv9hy1f14akon7', 'u37g5qxll367vrlk76p9dg8xg4ki5h2o0requwvofm2kinnq0x', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8yeypude568menss46muanybxccacas08kse5go43hszj3y4tx', 'u37g5qxll367vrlk76p9dg8xg4ki5h2o0requwvofm2kinnq0x', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('uroemw1aotlgq5eh1f8dx6c7f4w7to8mds7gzzqieq3vxtg8ho', 'u37g5qxll367vrlk76p9dg8xg4ki5h2o0requwvofm2kinnq0x', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t1g9ccyifkchrx3ilca2rp0cx5qjurhuwk96b920beis7vrng5', 'u37g5qxll367vrlk76p9dg8xg4ki5h2o0requwvofm2kinnq0x', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wvdeq98vscdebzysfzn4z2vjoup9jalkppscgd8msbt083ui3e', 'u37g5qxll367vrlk76p9dg8xg4ki5h2o0requwvofm2kinnq0x', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('jhez35a39tv9wk6j9qjz6wbmwl0nlyzsi9c74ephoo5dpddncp', 'Playlist 1', '2023-11-17 17:00:08.000','9ln6wtyyg7t74yj');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3e4oq81ien4diygtu15uj8e883qrtlegznlej5r8vnuckye30s', 'jhez35a39tv9wk6j9qjz6wbmwl0nlyzsi9c74ephoo5dpddncp', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t0erpjo3hyxehrijzoq71go5xymfvwxphxn7qw5r7lnzt03pqh', 'jhez35a39tv9wk6j9qjz6wbmwl0nlyzsi9c74ephoo5dpddncp', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('w78mf2zwv7sa924hq1wma1or2i7ms9aiajk90vt2zuvpyfhno6', 'jhez35a39tv9wk6j9qjz6wbmwl0nlyzsi9c74ephoo5dpddncp', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ukac6tnoicu7w40jl1rgq15qtdsg5nzq8e2z72igfyvepbne4r', 'jhez35a39tv9wk6j9qjz6wbmwl0nlyzsi9c74ephoo5dpddncp', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z1e9vhu8fk6d7mifdb62lva6ql77hmv7uduit2nixbs4yeg3s4', 'jhez35a39tv9wk6j9qjz6wbmwl0nlyzsi9c74ephoo5dpddncp', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qdj60cq463oppcohhk8svaabe66a87uza5d16vvsz6182r6y0l', 'jhez35a39tv9wk6j9qjz6wbmwl0nlyzsi9c74ephoo5dpddncp', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zwehlv44tejt3jpdf9ai9aznvgm79wpoog4ohtd4kg4p4vr387', 'jhez35a39tv9wk6j9qjz6wbmwl0nlyzsi9c74ephoo5dpddncp', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6iepl8pdaw7xjyn1qe0f4ekkp0wnmx6c62x8wn1x31uzkvhcqu', 'jhez35a39tv9wk6j9qjz6wbmwl0nlyzsi9c74ephoo5dpddncp', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6uvqqzezb74p7crbtfccbh7rrfazdm9yet2zpzrl9f2scew3x2', 'jhez35a39tv9wk6j9qjz6wbmwl0nlyzsi9c74ephoo5dpddncp', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nm62n7cirt9irz510eg2c9g7x6t5tp3v74zgay9tfrelfpksdo', 'jhez35a39tv9wk6j9qjz6wbmwl0nlyzsi9c74ephoo5dpddncp', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('rwq9zthe3acm40cd2bwckfpn566pm11gtniskq0m0zi55quya2', 'Playlist 0', '2023-11-17 17:00:08.000','ngilninmjxbbaxf');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('niyrkbhs9p4q7e5bt5356rlp84oj3s4cb568m797remx0txcix', 'rwq9zthe3acm40cd2bwckfpn566pm11gtniskq0m0zi55quya2', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gdh350l5ajct10xfzilpdwigj2mu2ansmhdwiwb4lbmp9p0z1t', 'rwq9zthe3acm40cd2bwckfpn566pm11gtniskq0m0zi55quya2', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('x30zqb73ddzdozm5b7577yy8ghnrebau72o62nb9gm7t4n5h9c', 'rwq9zthe3acm40cd2bwckfpn566pm11gtniskq0m0zi55quya2', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('malzuf7pt2sjljm36t0c2rv5iw2n8ctc2drhod18nwjb0riysv', 'rwq9zthe3acm40cd2bwckfpn566pm11gtniskq0m0zi55quya2', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bwiymvc73hu33o28xfzyy7tyvi3m10aqsh175vjwspf52iwmzx', 'rwq9zthe3acm40cd2bwckfpn566pm11gtniskq0m0zi55quya2', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0bll4odh3fvdhzaerbgdihm1rx0088x69ugz4ah2lr2s091dj0', 'rwq9zthe3acm40cd2bwckfpn566pm11gtniskq0m0zi55quya2', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vpaw9a42xngyxgknwksy87nqmcrzqa9gh1ub2gfaooawl0b7j8', 'rwq9zthe3acm40cd2bwckfpn566pm11gtniskq0m0zi55quya2', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9fp2yjerrg2llye29q8vghuojvzfni37zwnr3mseb354lz5z2f', 'rwq9zthe3acm40cd2bwckfpn566pm11gtniskq0m0zi55quya2', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cebfygr2ot3ix8ixfhhmlt70p6giia7w6pwgvag33ger01f8p2', 'rwq9zthe3acm40cd2bwckfpn566pm11gtniskq0m0zi55quya2', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fwmrydsi4jj2aaj3v8exschbluu5trf7dgnw3wgrkmonf890t4', 'rwq9zthe3acm40cd2bwckfpn566pm11gtniskq0m0zi55quya2', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('u6dviywraoks2pcep4k5uoadevd5a9wak9q7gp9xrhd53ya9vo', 'Playlist 1', '2023-11-17 17:00:08.000','ngilninmjxbbaxf');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d45ale4efqag572l18cxmh2aekzpgrl5ye9hhulsi8c93vtdy7', 'u6dviywraoks2pcep4k5uoadevd5a9wak9q7gp9xrhd53ya9vo', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('s1znquns0znjuqjprciq17vx285r4hf06rybwbehunmq7jcfr0', 'u6dviywraoks2pcep4k5uoadevd5a9wak9q7gp9xrhd53ya9vo', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('u6k004mohxzwfi2myw2rgq8dyio6osxf3nmmm3rztw4g9k9c1l', 'u6dviywraoks2pcep4k5uoadevd5a9wak9q7gp9xrhd53ya9vo', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('icjpt5xsmecfbn1yho2t80bgr3vdz1coibq8w2q1kc2a0sydpd', 'u6dviywraoks2pcep4k5uoadevd5a9wak9q7gp9xrhd53ya9vo', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cggbxlbkafnsizzf6tdo0s1wo20p8mc817mgzqu810iq1t4okg', 'u6dviywraoks2pcep4k5uoadevd5a9wak9q7gp9xrhd53ya9vo', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('89g0fqh4eis4hl88xjfj1bg2qqvdya1mmlgopbxa5i65irnsxy', 'u6dviywraoks2pcep4k5uoadevd5a9wak9q7gp9xrhd53ya9vo', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h7taqp889bxrr7z6hio0j3k26qyfg3xj5scmhq1i6fr281gel4', 'u6dviywraoks2pcep4k5uoadevd5a9wak9q7gp9xrhd53ya9vo', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e0ee4ddtj0xa40h3fxrrkem1o7dj4c93j45a3va0qs76aogvkc', 'u6dviywraoks2pcep4k5uoadevd5a9wak9q7gp9xrhd53ya9vo', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('js9y5020i7vxrrqogjd1z91xxzfl1jg84h03h02kpwksp9zpuc', 'u6dviywraoks2pcep4k5uoadevd5a9wak9q7gp9xrhd53ya9vo', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hhq3j70s30ajkwapyykakisgeewmzjmp7vws8hdwotks66qh17', 'u6dviywraoks2pcep4k5uoadevd5a9wak9q7gp9xrhd53ya9vo', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('wv4jv7vh7okyduoynx2jyoqv5tspziquj0mvoumtdculligw03', 'Playlist 0', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('16146jkt6j4nh8t24zigk9bcf0fnladhnofqzpe0tw7xl9o7k0', 'wv4jv7vh7okyduoynx2jyoqv5tspziquj0mvoumtdculligw03', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('x71k3pkf8wsq46aqod1max4hsvhz8p8qk8qmhcubd5761c64bv', 'wv4jv7vh7okyduoynx2jyoqv5tspziquj0mvoumtdculligw03', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('oebquvztz9i4lmewzw88ewj5t0s8vof568p1vo0mwgh517uea2', 'wv4jv7vh7okyduoynx2jyoqv5tspziquj0mvoumtdculligw03', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ob4sb91wwirashkj31in2v52aim1l2tzxgishypcj1fo21ni2h', 'wv4jv7vh7okyduoynx2jyoqv5tspziquj0mvoumtdculligw03', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ks0jjxvb6zsgsli645g6adp7ao0ihdzwhzbf5l9v0gsxl39pcp', 'wv4jv7vh7okyduoynx2jyoqv5tspziquj0mvoumtdculligw03', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cztx3dmqbjbejjynara63sr9ipqa2ct6n4rdcejij7pxant2ps', 'wv4jv7vh7okyduoynx2jyoqv5tspziquj0mvoumtdculligw03', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('498kofbfekotdr0893ytyqw3i7e5uo0qkumzr8qt8038vc0otr', 'wv4jv7vh7okyduoynx2jyoqv5tspziquj0mvoumtdculligw03', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m91ouex85yf7e029wfkzmg1ev6kt98dvwwrofyunujpchanqgt', 'wv4jv7vh7okyduoynx2jyoqv5tspziquj0mvoumtdculligw03', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6vrxah50xakfknq12txvkngjzwxcfn43skohx6re8lays3i2jr', 'wv4jv7vh7okyduoynx2jyoqv5tspziquj0mvoumtdculligw03', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wo1phqxan7vambvnj8ibhet3c719v7y5nz20us9tm8zsbyitak', 'wv4jv7vh7okyduoynx2jyoqv5tspziquj0mvoumtdculligw03', 1);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('v433x8yd0ig1c21uw9d4jhpz6x6bc6qcgvlqdio26cnfjfty9u', 'Playlist 1', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dqamd1pe0qhwoib99kqmw6lzvxylwp8y8bdo1zvr1m5hdflrqg', 'v433x8yd0ig1c21uw9d4jhpz6x6bc6qcgvlqdio26cnfjfty9u', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ks0jjxvb6zsgsli645g6adp7ao0ihdzwhzbf5l9v0gsxl39pcp', 'v433x8yd0ig1c21uw9d4jhpz6x6bc6qcgvlqdio26cnfjfty9u', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wpzsu0ehot8df3p99g4gknbd8uhr0d3s4dvu6gcqnecb2rosnk', 'v433x8yd0ig1c21uw9d4jhpz6x6bc6qcgvlqdio26cnfjfty9u', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('k3p8yw6langkcrxj2qj9c0orrt6p05ukwr3hwvyvn3211cgdfd', 'v433x8yd0ig1c21uw9d4jhpz6x6bc6qcgvlqdio26cnfjfty9u', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('auxds5pk91r4t98sioqgnm0l0t0flicoqr2wt0b1tss08ccc5n', 'v433x8yd0ig1c21uw9d4jhpz6x6bc6qcgvlqdio26cnfjfty9u', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nm62n7cirt9irz510eg2c9g7x6t5tp3v74zgay9tfrelfpksdo', 'v433x8yd0ig1c21uw9d4jhpz6x6bc6qcgvlqdio26cnfjfty9u', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('78t23ca320da5vs0dm7mxnsks5fkmorii1cnd827067edzw8gi', 'v433x8yd0ig1c21uw9d4jhpz6x6bc6qcgvlqdio26cnfjfty9u', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3f55axmxlixkigp2lnk9o6cf3u2q6nhtc9jlskj18vq441ppx5', 'v433x8yd0ig1c21uw9d4jhpz6x6bc6qcgvlqdio26cnfjfty9u', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9xlfl2pnreza9hz7nx6b1r8vgxx9agdoa7bq3464kufkbpisy6', 'v433x8yd0ig1c21uw9d4jhpz6x6bc6qcgvlqdio26cnfjfty9u', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sg8liz0v79chrw5bm8jmy8na6x1jfb28nbpl62dmhrcpcdw03y', 'v433x8yd0ig1c21uw9d4jhpz6x6bc6qcgvlqdio26cnfjfty9u', 6);
-- User Likes
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', 'nlvbpnh5eemgy6rdvv4p8ac7wgfdchgzyud2abp7sc77vsq8n4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', '96susgyradd3nxvksj5ggkthq9o7y94a4rhybmv97sfg4t2rq4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', 'h7taqp889bxrr7z6hio0j3k26qyfg3xj5scmhq1i6fr281gel4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', 'y3tn434ftr3vb573y3iy19k5y4gjc26cd1dq83hcjbj4zpy2q2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', 'rcl77b0ud3p82x56nwpbebweyuoybdelc9ljeovd8j4dinh5lt');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', '2720wsw2t58frrsd1w36xn5iqddgkvnq2ruhn32gi7p5crbvif');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', 'ud16ebokqjgzu7ezjwakdef05on2ksjfrexzewex1he9jasx6o');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', 'v4rzqnnl80i4y0k7pkkl17ocyenp6n6r18wbuwnvknm68zpa2s');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', 'oebquvztz9i4lmewzw88ewj5t0s8vof568p1vo0mwgh517uea2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', 'ty2x94i646d3ktwzs3h2nj5jv2uxxdtcx7au4iw9gm0ge2lwne');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', 'vlqkptpa0o805lie7pe2l7jl7u2v5didvpiypd0htibdq15zim');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', 'tl6v6u96iuct0b42ypxwlacf4ty35zvh32yq92st14ect3m95c');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', 'ncowl61c1xrurf6vfdc7goj5bcsx7ly37s2ux8dm7wzserhsi5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', 'ehw42w39v0fxkvyrpet75cs1bu0rousngh6f7rx16ivbk4dz8q');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ii5huqrlq3s15v', '2ljj2xkjiolb1hsfqbdv4wbbhrvrv6yx7r8qj1dekadjao8gda');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', 'rcl77b0ud3p82x56nwpbebweyuoybdelc9ljeovd8j4dinh5lt');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', 'v1od7w9knwbyoqwa0o76guqpjzd6tjnni7wsca8d5gdml6pc49');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', 'v9ua63o4009evydx785v8gyotj3dii76mxxisw801ts15wwgc1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', 'gazvx8pqxtjt9qa5g6q71blj3cyj182ofants0z5icz88ew7h3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', 'afzbqq93426zxaboijngq22ao04eksf5m7hvduu1ws33zg37gl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', 'l419ch2u2jlfy4bv3erne3ran3fvri0iv9279ynjn6grl9ddwd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', 'qdj60cq463oppcohhk8svaabe66a87uza5d16vvsz6182r6y0l');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', 'v9goq5vxou8c33mbq4hyu3ycls8s4jif6jlh6w6qa63y2s7qjy');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', '2bleso5j9cr57q0jmywiekjorhyow0ejavf9xtldcsfntqvng2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', '2xu4sblqoub7sruvhztlfxj23wzaw8t7f0inovcf9jwoq9peeq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', '5ccfvvppxdkd892rd7i1015v9pmbmozzzh143w1rllrkcwzdra');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', 'qbae8skw0191pu0dcnekcl6oarunc8jrxweaayhlug87aha4xe');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', '2c0y83khmi1hka4kbz3lbfx3ee3eegu9xu3gvtc0xlrke0sxx7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', 'oeyptrtwsqiuf7p2ys4spn7cnntvn1to800i1m6sphro11cmc0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('79b58fdql3wtxea', '7k1ett9fmn7n481g0a3tixn8a2mpp6aqz5fbjakqnyfwxh2o3p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', 'ip929156853xsowdrrwqgrom470ai4g40l0rztzjxtanqtmf7j');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', 'e6gvscinahha6ffk2wea2c0h9g1p1r0hgi38z8900st358ivaa');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', '2ytwlgo023lowpa01vkn60is8su210re4uy4tku1vif9ckvhwq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', 'go6v8hiprku8spcx8wvgf53vkymvypz8ge43l84skjjm59wmk8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', '89g0fqh4eis4hl88xjfj1bg2qqvdya1mmlgopbxa5i65irnsxy');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', '0bwptmnwcji8c2h6xqlj6fezw5abl452h0wjxrg3j3zy0fezpi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', 'hgi3nqz029egm2t6ihtcrefwvrhb2kbt2h15dz15z7zi9d0q5f');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', 'g5l5br3u1zca7xnmm4o6yq01nwtnwomh9lq6jy5zvkg9gmdt6j');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', 'i3ib4vi6mqo6zueryt4oqpel8nc1glfei0ppmcv3gf4ms58ut9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', 'mspt4lk8g96pz0kyqos9omkgp6ilox7kz2lgihcafglf2n8h25');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', '2u52nyjhchz5au4xdfxz94zn44cvbocj86ycxxy9vbyfleb6td');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', 'ic1pbl714s3kojg4tv4u64tia0naw0fg184gbjxvijysjhpy2o');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', 'zmutmjr451rg5y3nzbmmh6ln9gh809yu3j41qp2e0zcrd3esr2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', 'y1gqgf8gf7tlsrsnoy8zoa5dnob4pnt07xj4lbn81rh6vd25vd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('g4gvug5lhxstax6', 'pj02gluqh0zcdlxcte9gy2viyh15q3c76hp17ietmpdne6ey02');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', 'v1od7w9knwbyoqwa0o76guqpjzd6tjnni7wsca8d5gdml6pc49');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', 'sjn4s353fdccu72h985v1xuy1vrndhe49t9r7w74y4ychg3hyl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', 'cqfp7zk9xqhfwt18pb34x9o2at2bk1on2xb1z6i5fq4kxa16jc');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', 'wgu4erzqjj5cyfx6o30ot44wjaqglvpk69edxgra7z2pd5ovue');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', '3vumj6vr8xzsika50pozn8ca4hyyyfsqwxdjhvnru8fez1cl6e');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', 'dqamd1pe0qhwoib99kqmw6lzvxylwp8y8bdo1zvr1m5hdflrqg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', 'o1duc4t8l008oc28bbjpqv5m0506o9dbe0mrek5lsfnnhjyx0b');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', 'w8cw1rblnfcn4hicz4pb7p0zg73gseqsiftpr0xux46n4fjzwg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', '2u52nyjhchz5au4xdfxz94zn44cvbocj86ycxxy9vbyfleb6td');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', 'e6gvscinahha6ffk2wea2c0h9g1p1r0hgi38z8900st358ivaa');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', 'rpnvc98dfpy7vwgc0k6v0fxdaerb3oq78htf2kasuzbaqkcefd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', 'apvta40utwhgjoxkui10wrdwd98yy9lwufp94wsd7hvufplfz1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', 'wo1phqxan7vambvnj8ibhet3c719v7y5nz20us9tm8zsbyitak');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', 'y1gqgf8gf7tlsrsnoy8zoa5dnob4pnt07xj4lbn81rh6vd25vd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yocz02fm1a079fo', '8wefmujvlygkzvm2czwanunf9chmi6e0kyzubcqydhp5znequ4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', 'gbv678g9gh9lle2r9x5k9jins3dtb9w0vo442qgtdn2pfm8drj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', 'gazvx8pqxtjt9qa5g6q71blj3cyj182ofants0z5icz88ew7h3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', 'ahc8jaua3rgxo6drajycgqy3noa5iem7w613jm0nblwz757m6l');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', 'bv5wi6lisowme9jybr33wpqng6ke1u9pah4a96rumq97ch2xos');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', 'ic1pbl714s3kojg4tv4u64tia0naw0fg184gbjxvijysjhpy2o');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', 'ehw42w39v0fxkvyrpet75cs1bu0rousngh6f7rx16ivbk4dz8q');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', 'd45ale4efqag572l18cxmh2aekzpgrl5ye9hhulsi8c93vtdy7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', 'qdj60cq463oppcohhk8svaabe66a87uza5d16vvsz6182r6y0l');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', 'ttisb34av7wrc4b3fbhlne3b8youm0o4k0fekz64p2ludxjumo');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', 'v2o5z7u40y3es9m3or9vetgkculgiwyqqytwh7fz336wlorn4j');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', '1ew64srlr5wnyarem6s0aukszgk3808zy39qwb7juhlsj5hs74');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', 'uqe9dwjovn8xozinxwb89a1m4kbthdpiehps015hoaee2oj6e7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', 'wbmj6qeazrydjfy9m4c7r0eu4rj13dnmbwsghyq0k3xqip073k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', 'b398j5sigafjwtk82jj3meb1mfmuao6xp8fnqti956ouql335r');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3qr122jiudidw3w', '2e226eo0bsfpukgd7f11v6n2t2kinuxdgr23k9tv8uv66y3bam');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', 'y3tn434ftr3vb573y3iy19k5y4gjc26cd1dq83hcjbj4zpy2q2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', 'lyghj9psriq65vuoxb0p5ppc1lgs2vc9umgg8fkigw9gztwq4j');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', 'aa4ttw9i9udos8hew0nr3se48bvudqxq7je43nos6t8a2cl16i');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', 'ec1sholhl3q95x3lxyy23zd17k9ttvqjcbxg1u2qlkqq9wqi01');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', 'p15gbh3t6u0b8gxgzsksaiaa0hdmlucb80dl882sn89zsp02y6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', 'dmfb4jqeld6liq0hgqvf3511xs5e25cd63mfr2n7qssgs0tbvj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', 'e9mh37fodlq82nifuh7kwz9emyjvhxzfkoszkr0mh2psw3vfqn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', 'lygarft6wgpi3gybxs80bd5a6sj5741awlrpwkytqwcl2ocv7j');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', '9jb0ox6l3yva4o3kgcsvv9kpvjvxi2wpt5mi8ngqdwq0a6up5x');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', 'txevoxtz5mgh7axj2njeb9cwr6e8rwrwjyt5juknpaf98f128t');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', '3m9dgscc5gezlreemyqk2h1cqkhuy1f8aeyvzlcn03ccdolfk7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', 's7xsbz925zx7mfn0xjyen0fy156mvohfbzin7l5h71i9bbcmzy');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', 'jvuh4gykdyx3n0tew3flit5xlipbdi1phql1mjhrc9ciaj5xjl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', 't1ppafvv78iaqtt9mcux68et1rq9ov224mjhq6dfpdhbdfod7z');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('v257vydj7xn0nlh', 'lrahra5oicqu0fux3gsxeb99u71yag7st3pz1pcvwd7ymjz2sm');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', '3k1xpc9jillq1kix1odkiuk2xo8s6z7418owlksl8erfdca1pc');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', 'jgqo619wp1xgetfjspf7ugi13rml4i3vh6gmzcv2w0v12cfugl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', 'astts0995v1qwa1w498l2lq9xxfy05evb02tmsm8gez5arp19e');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', 'vlqkptpa0o805lie7pe2l7jl7u2v5didvpiypd0htibdq15zim');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', '4uozw2nw3mb9xj282w45zhep78bswn103wc1axmalhp622llkp');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', 'n97mkl70isaxlnzbdgza9sz5qc0r9is7fmqtsgpzpzvi2vc2qv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', 'ncowl61c1xrurf6vfdc7goj5bcsx7ly37s2ux8dm7wzserhsi5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', '05lr6b9s9jauocinozp40qki2me9143396oj2sbwcdh22m9i9y');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', 'tzap2xpoccfl6rc6ywk49ofqb01jgkgs3nj0hmvb5a1hvtp6jz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', '95vj72c3fucn0yjq91nxvaphw2r5m5tjyviq3l25exa2fcgd34');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', 'hghxi3lljowhqzqyasalfs3j1t7xm8t4099f9xrldf160vke9n');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', 'rzim8x8c5oekgpecgc0enc8n2kccb1j1d04loppoqf2ahze9tc');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', '2xu4sblqoub7sruvhztlfxj23wzaw8t7f0inovcf9jwoq9peeq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', 'jvuh4gykdyx3n0tew3flit5xlipbdi1phql1mjhrc9ciaj5xjl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('5ov38nso4d495p3', 'o1duc4t8l008oc28bbjpqv5m0506o9dbe0mrek5lsfnnhjyx0b');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', '4kcxxq8r78cb73kars8tva93sw8sfaag3u9ohghsijbm4x9dyv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', '95vj72c3fucn0yjq91nxvaphw2r5m5tjyviq3l25exa2fcgd34');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', 'zg5mhqgnx79enj6xpd80tcp2oq3reyfe92lonrhpz5n5w6s75e');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', 'xyouboj9zk6lwcxm8bnan2nrsdnupdvze6pz2b3gr4cc1vywb1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', 'zqa4af57ncylydpu17dp1aul5poys5rcyow2hqk8ck3in8tk1y');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', 'a7zrkuhvtan30scu5sek8ivub9lpwy52h2b074he3gwinjawy3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', 'zjdz9q2y8gwqqkt6kvyhhwruy12bmzfv3utfd5tdcpe1q8un0v');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', 'd46xolc647hsmqeapk4o1qriycfs2uw5rddi7275zl9z90y0ps');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', 'v9goq5vxou8c33mbq4hyu3ycls8s4jif6jlh6w6qa63y2s7qjy');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', 'x3r87c7b551v9cvcvk7roa1679lvy66u6gqoo5se5m66dn4uq1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', 'r9f0xpawdhrjvtnio8jbo8obm6tn3zczuw5omxmzxtd2liizdx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', 'gbv678g9gh9lle2r9x5k9jins3dtb9w0vo442qgtdn2pfm8drj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', 'ttisb34av7wrc4b3fbhlne3b8youm0o4k0fekz64p2ludxjumo');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', 'fago9dkhyr15aq9n3i88ds143thct0n8g25n5cqcf457nk6vqy');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dt5rag4r50ufszn', 'x71k3pkf8wsq46aqod1max4hsvhz8p8qk8qmhcubd5761c64bv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', 'wbmj6qeazrydjfy9m4c7r0eu4rj13dnmbwsghyq0k3xqip073k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', '6yubjx64r7234yodpjjpywq7tg979h51w9f7fz9el2q1yy49wh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', 'su25k8o11ce8pmf7gj2b5l7ta6wr41e3klncxje124o9qhkh9t');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', 'qdj60cq463oppcohhk8svaabe66a87uza5d16vvsz6182r6y0l');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', '0zk1masxx73l2eve022vintx9wju1lv9ziz734tkot7qm9etzg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', 'wff079sfc5bhqyb3twj50hr7glzack3nobwv5x497jinw08gvd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', 'y5c6op6cbxuab72h88tog2aliefni8pzcs9z6rawudbu199zmo');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', '6dkx9v8378qswyeshdzk0r25yqkvska8rvxac872dch6w4v7bb');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', 'lq48tcm2k343edmyl2k6rsjff2ookvbo6d1aq2tuwnkn67d6sc');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', 'hyn8diuxxu1efk76r7ma8pqjpgyh6wjjuxuewhh02spx7f1lvx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', 'd45ale4efqag572l18cxmh2aekzpgrl5ye9hhulsi8c93vtdy7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', '4k7zy3pm7rtuokqb7vdr13t62nkkmr997tc1drcecrjfgmy1t1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', 'i8fge2jlhuhre75cuu4m1h74x05hbyakchlpf4r8tzoc29513a');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', 'eviransr2mcsrtm3dpm781uiau3x84okejkopm5dyyr42f9de4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('9ln6wtyyg7t74yj', 'x30zqb73ddzdozm5b7577yy8ghnrebau72o62nb9gm7t4n5h9c');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', 'lcdgwtwh80fkza73g1pzc6kimngiup7p33ysk52dgfgceykr1q');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', 'bv5wi6lisowme9jybr33wpqng6ke1u9pah4a96rumq97ch2xos');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', '3ejxl0z9epqqv5zryyf0kc6cgef9djqfs0bayq4pq88sk7xc58');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', '2zjtcb3rl5aizkbjvrn8ce2u7n2xh3j3yv4hgjodan99sxzhly');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', 'z1fcpdfite5blqui3614lpylg5q0l43in5egdm206s4nsidix8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', 'e5hpn0zk9fq4rsa490u0aew8bmsck97kugm9pfp4sp4lssahqg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', 'rpnvc98dfpy7vwgc0k6v0fxdaerb3oq78htf2kasuzbaqkcefd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', '8lsvporcbdwoda6b6xaev99cdeggl0n68gum33xqh10fb3ajyr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', 'd11u0o6p75seqhe3jc6jr413l6j0ot224oiyewxcw97b90ok83');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', 'x5yg0s15fiy54w0ipx1eoevzbyzm6joe1mrph9tfyxw02qraun');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', '6vrxah50xakfknq12txvkngjzwxcfn43skohx6re8lays3i2jr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', 'q4cd3y0e2ufi31ufuihamef2nu4qf7n9o6mhdumy40pg07x19x');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', '31nz28gkfp1j5evaqka1u9vxxbqzsip8g6q5yfv9l3w364rrlj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', 'n97mkl70isaxlnzbdgza9sz5qc0r9is7fmqtsgpzpzvi2vc2qv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ngilninmjxbbaxf', '1ew64srlr5wnyarem6s0aukszgk3808zy39qwb7juhlsj5hs74');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'zg5mhqgnx79enj6xpd80tcp2oq3reyfe92lonrhpz5n5w6s75e');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '6xzk598jm6zks9yz7vr4psqy00ggos3o26ts0smzbgxs5aouf5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'k9p0gbozavrj6r1nc6290i5qf9rhjgq6zmnfjhstvylqaeaw5t');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'z1fcpdfite5blqui3614lpylg5q0l43in5egdm206s4nsidix8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '72w1b86md4tu1fmsuy03jkjk1tgv46cke6z6wyw3887eppesuo');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'sq34zl9m0tdikxy32flthrdjc9ow98ns75v6yv9uw8inoh7i90');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'vxtouxm5yx63w81phgpkzhw5wlif5iqomt8ka3qe3iuxzfknt5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'm6plkuhfguydp1mo23tl1woqpjnicdau4c2k9kxb4usq55sjwm');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'f3y2bng2wqrh03qzb2np4hh5923gduoe34au73kdypoa26vp5c');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '2bl2knghchqxnq1maw3upvkk3q6e5g52e7edn2m7einkxx0c4q');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'm4i0lan9f4c1ceda6w9gtpeeuwe5sdrsifrn9ry3samyikpcun');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'jg5st4jx2nhax6qxatwky468vm6fpg3d2vshtysa5pu897woed');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'p4hdkcv4eaz9n99bs1o0xkzgktx9vcjynyxondppja0h7mw46s');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'szqfxxfufh5nr79ziomq6dn7rq25drgc9uwd4wpruq5red5f1k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'vi7nj6l3yfpeimc0q0ik0g5x5yi1rjr731r2u06g3x30j21qii');
-- User Song Recommendations
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('hzl7zqc85lm8s3ndxlwfzs6hh4olvbds4kvgiequ7mql8az6s1', '5ii5huqrlq3s15v', 'nwptpt1zhvu09u5v2u7tobiy5caopsx2ltn7tpjls4kku9f9y6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('9syknslf9axizpkoifnk2egxugswq682lj5fgu7legmlgi5mos', '5ii5huqrlq3s15v', 'y3tn434ftr3vb573y3iy19k5y4gjc26cd1dq83hcjbj4zpy2q2', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('o25r00enh7uryqyfroo9gevkez9ueadelb1k8l17a6er8cz0kz', '5ii5huqrlq3s15v', 'rzim8x8c5oekgpecgc0enc8n2kccb1j1d04loppoqf2ahze9tc', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('681we0kvo8w4yzgdieegzvarbnyjkh7orst9p4jqs3pgqs7rwb', '5ii5huqrlq3s15v', 'kwwej20spj2wvi029kmze68sco124ocd642gy994hxfc40zn8a', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8lmym8aweijyswgefe22ggxvyyrztlvs2ferm4o7w63d1zje07', '5ii5huqrlq3s15v', 'nq8jbjqesspf1qchzxbg3809esit64t5df5o2sr6xb2wywscd6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('dpk1z8q8zbc5ekrghg8km7tuxntdr5hiaubxtgt7mnzeed81rk', '5ii5huqrlq3s15v', 'ursgtho05mrhq0gwqnrsaja9fwut2nc85f8m5v5xvqwmagrab1', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('3fmys1lqzrevuaujgm6tuzund275tk4114rnovfcmfhmpzyepy', '5ii5huqrlq3s15v', 'zlk8wbc902s7nd8sdrmv4384shg2rnjlrcmspstkbf9swwmbgc', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('fpiwkreip4nis5r9iiyllevsrmghsq68tqaxedvxydfuq6t59t', '5ii5huqrlq3s15v', 'txevoxtz5mgh7axj2njeb9cwr6e8rwrwjyt5juknpaf98f128t', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('tmxgsejglfu5soq4ht8dylvgaxi54oucgcbob4exasntw44atf', '79b58fdql3wtxea', 'ovi65a5cx764fqsn0vrpldxekycf3pqf56uubyfdsk9uiw7edq', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('xhvsd5z76j81pc63qaj0l3xsg3ays4frlool298y5jnojm5m4z', '79b58fdql3wtxea', 'vlqkptpa0o805lie7pe2l7jl7u2v5didvpiypd0htibdq15zim', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('303yszbjvssv40q2nwut7epuc3uc7bj0qcw1x0zhtm3cmrfdf1', '79b58fdql3wtxea', 'ty2x94i646d3ktwzs3h2nj5jv2uxxdtcx7au4iw9gm0ge2lwne', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wxr5fsb7ptsb1mqref9gk3j1cry9jbrn1q7n1kks0wgh9irtss', '79b58fdql3wtxea', 'g8zp11in6y1tvtnaggvecdh95zjevc846etga8fhsjxmcij0z8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('qoz35ak8llswx6mwelbadw4jlagpnqnrcd5u2al2gcju86z0uu', '79b58fdql3wtxea', 'wo1phqxan7vambvnj8ibhet3c719v7y5nz20us9tm8zsbyitak', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('d1zdrjpz2obypp5cnrk1j89y3st5g9b5c14ysrut7bqs8nzf4b', '79b58fdql3wtxea', 'wgu4erzqjj5cyfx6o30ot44wjaqglvpk69edxgra7z2pd5ovue', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8rhvm5zxv4y8hp65f9cg8j7gynx3h9g34awczlagljtwhyivsr', '79b58fdql3wtxea', '467no6tsztu9xj6raaczkd4jrkrgzd5fwtvtdxm77zogtqv9vj', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('w0o18193ftut7ga4nasw4a76v0wusuq81ixjrdptg6vp9wacjq', '79b58fdql3wtxea', 'zb0adgflrhgf4bfacvw8e8ntlc13y3ojpc8yf8xhbpvjn568bs', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('oye0s5d970khc6vo1o7fyoke8njzzyfnuvmidbe2t3qg8sjehj', 'g4gvug5lhxstax6', 'z4naw3b7h2lkyk85a209njrze8qz5dupkysl61lqa01mz286fr', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('p386ojq2ihz14b5p8ow7vnz8xcowwk5fu9f5bb7w7yf68e5oe3', 'g4gvug5lhxstax6', 'i7qzormljtlcsdh7p9tgo51xzhakrz1yg7pq3zj8bqg867uexe', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('h3699mchy5eulmwqsu7yjsc5p1fz0zix8g5brc9xwfi453ggff', 'g4gvug5lhxstax6', '50h5m7pq8eskdgw638piuptpzc2l22z0ujr2xrc3abnxfckdo8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ugocl6fm6cityu068iqfp1ly1xc6f9rho4kev5enoevdvxs2ur', 'g4gvug5lhxstax6', 'g8zp11in6y1tvtnaggvecdh95zjevc846etga8fhsjxmcij0z8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('fpzxcagfpp9er6dvkitn0kw5jta0e3l6junhkuv1knvdc392uh', 'g4gvug5lhxstax6', 'lqudaf2jfmwejtygsurfhk165wt65hctfw9ovhlod9opd2fpd9', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('6i127bvnela4hlk58opatye9csu6xzajg61lwwk58hvkak5syg', 'g4gvug5lhxstax6', 'mw1oo7ftxi9knt0zjns4js59m7lkol7i9nd7etnrzw3if7ikv9', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('y0wm160qsknvwhvsa4jdhre6y1wk9qcnhmdvf001dy5c4xsrhq', 'g4gvug5lhxstax6', 'icxla4zb0oytw63yvmt0zsxciafpumyz8vdnsthaxlr9kfwccj', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('w3ufhkzoucpsf10sl4088li3qh7wofxvyh4v6pj3x6rpr9vxcq', 'g4gvug5lhxstax6', '3vumj6vr8xzsika50pozn8ca4hyyyfsqwxdjhvnru8fez1cl6e', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('zgkhhu46fzreuhgz6na2dwkem2klmepd41930nw57bkyj6321d', 'yocz02fm1a079fo', 'lyghj9psriq65vuoxb0p5ppc1lgs2vc9umgg8fkigw9gztwq4j', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('fhds7ynucgzs459r52fe5f5i84v7eqnbj3drgwrm9nn1xln48t', 'yocz02fm1a079fo', 'g9epnmcvk2xpoaz64ikqx1hspjwjhm91b66e6suw9yy7gbhnlm', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('gxz4gdeijtlsdypji9sot916hno8893ik0yi6cjw7n7qccxty6', 'yocz02fm1a079fo', 'x4hnsgvl7yg39mq9kf38ay8tscrlsvugu9rlcu06eyf8sgm8ai', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('knslhp2q1vu9o45xnapappuzysxuc5lrvjr2268hedkcrkjmyn', 'yocz02fm1a079fo', 'tirrhpzzf0sdv4wy5pxb8cus9x2imkh8st06jqj6vcguh9rt29', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('hircu09a4y0r5uvn1e9unwej2j3upq6f6dqheq59usz6pqgw26', 'yocz02fm1a079fo', 'tm6uy30s8kcjye70ech5xkabkoh4asjs2y3rexu5aceqd64eya', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('4dx2n9klkg92yye8341gur3vm1dip8kcbllpn5zw6sjgun2jwp', 'yocz02fm1a079fo', 'z1e9vhu8fk6d7mifdb62lva6ql77hmv7uduit2nixbs4yeg3s4', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('drray2m8idfedq72bsrsfvur7gvq68uh97zdjixo5m8luy7rvj', 'yocz02fm1a079fo', 'ehw42w39v0fxkvyrpet75cs1bu0rousngh6f7rx16ivbk4dz8q', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('q8b34rxi6ool003sgj4t1f2haxk7gzifwmdy6g4y8uqkq0epv1', 'yocz02fm1a079fo', 'm1m82vbosu177pjcqiuwv9ezaid7s81iwq4iytuu1e3j6xq6dl', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('qqq6qim1z7iwx3ssnh7o5lxokqk19udy6ywu9w871508n4dd4v', '3qr122jiudidw3w', 'mf6vyl9znfsth62t0h6fgjjfmik17kxf1ddtaff48ayijl1ac4', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('rua8pg370bl4eq017nsi62pmk43opgcwtsu6att120796dlt6h', '3qr122jiudidw3w', 's1znquns0znjuqjprciq17vx285r4hf06rybwbehunmq7jcfr0', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('tnzmxr36hog7mceuonafasy328pa19lo1v3z1ek4zfnsug04t1', '3qr122jiudidw3w', 'vxtouxm5yx63w81phgpkzhw5wlif5iqomt8ka3qe3iuxzfknt5', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('6zaeadsebghd91at70fjtw0exneielwpc7n55hohqhvcii86wv', '3qr122jiudidw3w', '57y2hnk80wyqxq7sfhgcepfejws9mbg8305w77jamgzqtgtxe7', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('sae22pwnqn6ddi60wyjyokh0quhv59ic1s3cbpnfh35vmf4kaj', '3qr122jiudidw3w', 'geezk4aae9vzdr37w2jmla8xqlkqsdfxcejonrv9539d5979gm', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('57b9ebmdfi9wejl6l9h85d2x9z8xyypz0w2b2oj62kjaypzvit', '3qr122jiudidw3w', 'dmfb4jqeld6liq0hgqvf3511xs5e25cd63mfr2n7qssgs0tbvj', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('p86e6p8gfxnfoo9jasm7jf41clz6tlrfk1e6qgpg7kunrdo71d', '3qr122jiudidw3w', 'nf5anmxxbv3wlwu0516bdg4mt9515mexc219uud7cvgskvdltp', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('r1eglm5fic1ch5pbnctp1pwk2zs5oxlyl4bf4cxn3y4ch2mej8', '3qr122jiudidw3w', 'ncowl61c1xrurf6vfdc7goj5bcsx7ly37s2ux8dm7wzserhsi5', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ool71iv765b1kv4nkyt410g263ercgpeu5t0eg9quefwtxai8b', 'v257vydj7xn0nlh', 'ob4sb91wwirashkj31in2v52aim1l2tzxgishypcj1fo21ni2h', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('nrdlk63ibr4kevndzjmoged4r2898wk2greuzd7eer9gerwcey', 'v257vydj7xn0nlh', 'l419ch2u2jlfy4bv3erne3ran3fvri0iv9279ynjn6grl9ddwd', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wyjhs4rq6mh16zae02qd8895fuemzdsap0oqbpxa7t6eedx5uw', 'v257vydj7xn0nlh', '3vumj6vr8xzsika50pozn8ca4hyyyfsqwxdjhvnru8fez1cl6e', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('3gzixwau71h5y5zucrruim8s3tq252cpd9owo86pptw5qzepdx', 'v257vydj7xn0nlh', 'dqamd1pe0qhwoib99kqmw6lzvxylwp8y8bdo1zvr1m5hdflrqg', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('4vrysaqjdp763e31e22128orr2t0b0lppz8wbngynr30fcusgo', 'v257vydj7xn0nlh', 'pqzvx41rsmfvwi3ezuql7kek2iusds4djy0wsxxtj1s97dh4hc', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('mnru8g4hje18g8xvudzxtyvzek9ghyylay8hscbrsqmnya86s2', 'v257vydj7xn0nlh', 'fwmrydsi4jj2aaj3v8exschbluu5trf7dgnw3wgrkmonf890t4', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('vcqm8tsrwk9n879u2pxd0vbu56yxw237dauit4ufshs4rfeyay', 'v257vydj7xn0nlh', 'njhrk1qt647il1fjx4g5qk5fl525qsu049dhl3gwc078q2hzz1', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('zxxf3x5ir4ihxfxq64mqescxip4zeq5a3omsev5qm08oxiyo2n', 'v257vydj7xn0nlh', 'uq0saizd49jdwf9yi8h4rrws3xf16mjgtpgmni5tdvnqc9i8lz', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('t7tzaxrdsqfkc6jlu5m6c0hf0gbb5knqdp9hfi51x48xmy78ia', '5ov38nso4d495p3', 'jekfbim0uqfxpjyydqp8lm0pfeq3vxg36z6w70d8r3rqqvgltl', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wavr2jb3i35gifw2mif0sk8e3fsuvcggd8tcegz3jieneb3uzn', '5ov38nso4d495p3', '8wefmujvlygkzvm2czwanunf9chmi6e0kyzubcqydhp5znequ4', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('erzqsmn9to4zgk2wdnm2vm25x48m6penig3ivzo84378hjty24', '5ov38nso4d495p3', 'hhq3j70s30ajkwapyykakisgeewmzjmp7vws8hdwotks66qh17', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('lx0zbrdmwc6twktdsxy15s7jowrc3olf5f6l13mj5uxdnnqd9e', '5ov38nso4d495p3', 'ty2x94i646d3ktwzs3h2nj5jv2uxxdtcx7au4iw9gm0ge2lwne', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wdpnxnp12qj23908usjp6qdpb0rv1lsz75ei7e12dgtooerwgk', '5ov38nso4d495p3', '96susgyradd3nxvksj5ggkthq9o7y94a4rhybmv97sfg4t2rq4', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('x2397pdncjav47yl7kw1fiv7abcxp4ru34619iwjduoa4hbdrz', '5ov38nso4d495p3', 'pt7vlquc2qg9ddu33dnq91owfo0kzi1q67cr62t60yekkc4ehz', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('v6fboad8zsx4o9jqssvnz03emcf9dg15gsmihuyw67y08a1d9y', '5ov38nso4d495p3', 'h2zprkccipwg1jvwmmn2buoof8rgzz8hr5qp077g4qm3fdsqp1', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('gxlj16d64sox0z48husgaf1todl0jgxumfjbo347pvg4r4jip8', '5ov38nso4d495p3', 'jvuh4gykdyx3n0tew3flit5xlipbdi1phql1mjhrc9ciaj5xjl', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('n0a5vjtm6g6hk2x03qa2z08qz2u8v4c990mtc0z230yfzwz7cd', 'dt5rag4r50ufszn', 'f00bo6nikvww6kddovgquyspx7h1mgwvug45ymsqlo8je945uj', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ojamb3mlc4ffyxdyf6vnj3wjq2ies7apac1vxw7jxots6xh3sa', 'dt5rag4r50ufszn', '8htkhiwle4vqwzcy5cddpjr0uq0erlqcss9u0wbaevkqf53thx', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0vujpn8ka1t2w2siqgiy1bxcsjqpa6xug1ddlpgk2z2q5wb9rq', 'dt5rag4r50ufszn', 'ehw42w39v0fxkvyrpet75cs1bu0rousngh6f7rx16ivbk4dz8q', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('qznyzfhcm1fe0e80g81hbovt2ucoqcyqkiow96xlo9vwpoamz8', 'dt5rag4r50ufszn', 'd46xolc647hsmqeapk4o1qriycfs2uw5rddi7275zl9z90y0ps', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('nrcogcoqgibsqcy0loy1wn9o7cla24qznn0gs2f0u49827mmdo', 'dt5rag4r50ufszn', 'i3ib4vi6mqo6zueryt4oqpel8nc1glfei0ppmcv3gf4ms58ut9', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('xcprnk1ht9j31foxvtc9bz8nz9u67j5wfsjcwsb8lwnvcrt5zx', 'dt5rag4r50ufszn', 'uqfvp7y0e1y4ay9068bvg1cpj8cvn9huszh3ki4l6dj12b2jvd', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('pxu8k5h0x81c0u90kekobcoub7v9jtq44xk8ttp1st4853wv6p', 'dt5rag4r50ufszn', '2720wsw2t58frrsd1w36xn5iqddgkvnq2ruhn32gi7p5crbvif', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('70algocu2bxhpau4ybfki976wrqlp5etuqxfvcfljjg7uyboqw', 'dt5rag4r50ufszn', 'x1bcbftcnqybomjvcvga6cmx35mu5ugcrgeo5s0mubpm1et529', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('yo6znhpvoz3y4bjqqycyef63k1bp2ub2ov6lb1goq1cmldi9yo', '9ln6wtyyg7t74yj', 'y0ol5de4qevut0p2fgq4tz6ij4ijb9d2eihgqgwkvt2vpix02t', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ocyu60pws0j4maya9j7clwcq7oytoeh8v7omcp7chtev1cpk33', '9ln6wtyyg7t74yj', 'qkjpkzc81xztuzoxtqf3lf8xxn0bxsawesmnns5s1qo6yx4ly9', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('88j28cpssp5rjbpmlm9w26bar4g5fflkms1c6dmw62st23e0mk', '9ln6wtyyg7t74yj', '78t23ca320da5vs0dm7mxnsks5fkmorii1cnd827067edzw8gi', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wm3t1r8dxvwvz4qgmt8xe1zwvwygl9pllnissfq74yk6a7crkd', '9ln6wtyyg7t74yj', 'p0ok53glppgs0liave6aac6rar0hlv1bhcijg1lgrkvfgu62b0', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('jr4sbvbanb01x2iqwg457c72pt6hf6g6qmtc4xn7gqqi5omt55', '9ln6wtyyg7t74yj', '4rphi63drvcnlgkl6edl6llk2fhz9pb5qfonj8dh078bd3ee0w', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5k1ziu4l5ji77evqgghfvjf4zvxo9lec7osptb7a4umonglgzi', '9ln6wtyyg7t74yj', '6yubjx64r7234yodpjjpywq7tg979h51w9f7fz9el2q1yy49wh', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('iwqvgzal88qv8lp6js6nzcr99twe23aqr7lndtn478o1j5r0jh', '9ln6wtyyg7t74yj', 'd11u0o6p75seqhe3jc6jr413l6j0ot224oiyewxcw97b90ok83', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('jfvzbxeyb0pnrt2ufgk5ayskvmgyleyfzub9j5j9fx82sgjdfj', '9ln6wtyyg7t74yj', 'gfecftrropyypp9pkjyjae5wlho7s1eq9ewxove01igsjm5p8y', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('c02drhihzeopqoc7h8aueyc2iozd2rf2q9h742zhwlnrqxa1pk', 'ngilninmjxbbaxf', '9gc96hbdav6xq5di36y8vo647mvoaqzmzvu6x8rso051j2y8b8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('uft0kmstovomp6ximil8789uc9cz1kyaw9tn30umrtphdda0o1', 'ngilninmjxbbaxf', 'd11u0o6p75seqhe3jc6jr413l6j0ot224oiyewxcw97b90ok83', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('epiook5sh1hcg8deogtepux8zd6mzi557295atv5f788xjtp0j', 'ngilninmjxbbaxf', '0qawf1q6tcocm5nxrqpczhc3ppm9i0yvrndpf2nugzap80s7nb', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('mdx0nvl5d8hpuo53j0ok1epdmq7jbnrodf45tyxkks0qdn1uob', 'ngilninmjxbbaxf', 'udzg28hut04xq4zu243z3ft9m9cgjeuzo5472ev24hzafqfjo9', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('n4cxlgwplw3c885d76uyqi0j6tv6m600fg433t43hfidynknvs', 'ngilninmjxbbaxf', 'gfecftrropyypp9pkjyjae5wlho7s1eq9ewxove01igsjm5p8y', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('tclcnmth9wbpx04r2maghl1av2lqfhgxrxuovqbd7aee2ymsnq', 'ngilninmjxbbaxf', 'l419ch2u2jlfy4bv3erne3ran3fvri0iv9279ynjn6grl9ddwd', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('gg1xgc8k99ag08twklhhhnlpr6k88tkluoph46yto4j21fsrzl', 'ngilninmjxbbaxf', '341rdqf2uzwjc8wmcn1lzd6yi6zqe0e6aqloeychzazcz255pz', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ozil7bymw4agan6jav6q8w710fjpb258r5k8jwo9w8yayhtosb', 'ngilninmjxbbaxf', 'jekfbim0uqfxpjyydqp8lm0pfeq3vxg36z6w70d8r3rqqvgltl', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('7fde5756pafrv86skudat3e04h2fb0wo3gjjbrli8mi6ok3xy9', 'icqlt67n2fd7p34', '4uozw2nw3mb9xj282w45zhep78bswn103wc1axmalhp622llkp', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('rc9qhbfl8lbqtpkug8b9li8oxpnv6eddc2i9p0g6wjiz4m34ug', 'icqlt67n2fd7p34', 'jkijtrorbaww5i9odeigsvcmt0okiu0ip0zj9cxp3zc6qxrs9b', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wi0z477q4ujctfj9sb2se3qdx6z4kkj86rjwoaoytdnypw4dnq', 'icqlt67n2fd7p34', 'ob4sb91wwirashkj31in2v52aim1l2tzxgishypcj1fo21ni2h', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('c9t3576xizy2a2yp2bj7mesx8yc5bce5ubs2shb39m3vhnkdr3', 'icqlt67n2fd7p34', 'lyghj9psriq65vuoxb0p5ppc1lgs2vc9umgg8fkigw9gztwq4j', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('c54t9pfl18135ju4iwybahucmnrdlh3zqzfiobvy6d32dfr7kg', 'icqlt67n2fd7p34', '1wht1txb94hg21oaphdqzfliqse1w98tei3r3cxrnxkxx6wm7x', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('mradd66tgyotcmr0ux7m99dmjhpzrlpdhbj7z2kgvb4ahhbars', 'icqlt67n2fd7p34', 'tfhi7prfy7awjd3y87h42g8jeq1ouiyzkss77gdvzjhc4fzy7d', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5j8ln0g0khasxyu0k8gi38gq70p6uf8jr9nz9adokmot0p7vez', 'icqlt67n2fd7p34', 'v9ua63o4009evydx785v8gyotj3dii76mxxisw801ts15wwgc1', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('cdcefq3gw4fjtd0v9osh2prp9fd288pvzj0myf7l7zrpc9tn3y', 'icqlt67n2fd7p34', '9y5yqkm47e0jc8bosf317287y5s4pun429xakdhljt84jj43ap', '2023-11-17 17:00:08.000');


