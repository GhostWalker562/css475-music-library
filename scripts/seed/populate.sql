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
-- J. Cole
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4cmmvue4cc689k7', 'J. Cole', '0@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb080d11275f15655a11b2610d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:0@artist.com', '4cmmvue4cc689k7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4cmmvue4cc689k7', 'A profound lyricist and rapper, known for his thought-provoking music.', 'J. Cole');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xj10at4st2a1qqypdj4j4kap5j6jk408memruf3izfav63s6y4','4cmmvue4cc689k7', NULL, '2014 Forest Hills Drive','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bw9g8t6vlictka21wrt70g8vfy3yr3n46y3yw8d7ly6pat0kjy','All My Life (feat. J. Cole)','4cmmvue4cc689k7','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xj10at4st2a1qqypdj4j4kap5j6jk408memruf3izfav63s6y4', 'bw9g8t6vlictka21wrt70g8vfy3yr3n46y3yw8d7ly6pat0kjy', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vjywdn3sj7n0a9fsjar8qi2marravz67es3nc06ekvdzxjifyq','No Role Modelz','4cmmvue4cc689k7','POP','68Dni7IE4VyPkTOH9mRWHr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xj10at4st2a1qqypdj4j4kap5j6jk408memruf3izfav63s6y4', 'vjywdn3sj7n0a9fsjar8qi2marravz67es3nc06ekvdzxjifyq', '1');
-- Plan B
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uvlt67iljp9mqg3', 'Plan B', '1@artist.com', 'https://i.scdn.co/image/eb21793908d1eabe0fba02659bdff4e4a4b3724a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:1@artist.com', 'uvlt67iljp9mqg3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uvlt67iljp9mqg3', 'Crafting soundscapes that transport listeners to another world.', 'Plan B');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hx6v5tl9a5jnya8mdmp6vhc38mpjszik4jhcqtmqlqkqbu47u6','uvlt67iljp9mqg3', 'https://i.scdn.co/image/ab67616d0000b273913ef74e0272d688c512200b', 'House Of Pleasure','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ptdoygtwt1udzenl031wrs0khbequ3y5r8s5ma3ju0a7t7hrn3','Es un Secreto','uvlt67iljp9mqg3','POP','7JwdbqIpiuWvGbRryKSuBz','https://p.scdn.co/mp3-preview/feeeb03d75e53b19bb2e67502a1b498e87cdfef8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hx6v5tl9a5jnya8mdmp6vhc38mpjszik4jhcqtmqlqkqbu47u6', 'ptdoygtwt1udzenl031wrs0khbequ3y5r8s5ma3ju0a7t7hrn3', '0');
-- Cigarettes After Sex
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('38zns0w7ef68yfk', 'Cigarettes After Sex', '2@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7004f7b65ad1bb1e4e4582bc','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:2@artist.com', '38zns0w7ef68yfk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('38zns0w7ef68yfk', 'An odyssey of sound that defies conventions.', 'Cigarettes After Sex');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9zlgdkvf6a2fp9vi48kopv5ufr4qvjnj46h2khwou2c4j17z0v','38zns0w7ef68yfk', 'https://i.scdn.co/image/ab67616d0000b27312b69bf576f5e80291f75161', 'Cigarettes After Sex','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('36wmbi23vaow81cjg565h2strh0zluuq9xu49savz36jaybfxp','Apocalypse','38zns0w7ef68yfk','POP','0yc6Gst2xkRu0eMLeRMGCX','https://p.scdn.co/mp3-preview/1f89f0156113dfb87572382b531459bb8cb711a1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9zlgdkvf6a2fp9vi48kopv5ufr4qvjnj46h2khwou2c4j17z0v', '36wmbi23vaow81cjg565h2strh0zluuq9xu49savz36jaybfxp', '0');
-- Bruno Mars
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0ky40bmjb8buxqm', 'Bruno Mars', '3@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc36dd9eb55fb0db4911f25dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:3@artist.com', '0ky40bmjb8buxqm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0ky40bmjb8buxqm', 'Striking chords that resonate across generations.', 'Bruno Mars');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hd9k5ini5xhrqtzdkt9a9rkrgclxvjqvwemkzvkax4qyfyvybm','0ky40bmjb8buxqm', 'https://i.scdn.co/image/ab67616d0000b273926f43e7cce571e62720fd46', 'Unorthodox Jukebox','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s1sp4wrt2i8qh0zoqlfegabmrqglux6p91mcu072x5tbevz79t','Locked Out Of Heaven','0ky40bmjb8buxqm','POP','3w3y8KPTfNeOKPiqUTakBh','https://p.scdn.co/mp3-preview/5a0318e6c43964786d22b9431af35490e96cff3d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hd9k5ini5xhrqtzdkt9a9rkrgclxvjqvwemkzvkax4qyfyvybm', 's1sp4wrt2i8qh0zoqlfegabmrqglux6p91mcu072x5tbevz79t', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('65p36432fiwizot6ayzou8eik0zvgen9pai10sotn37aptpolz','When I Was Your Man','0ky40bmjb8buxqm','POP','0nJW01T7XtvILxQgC5J7Wh','https://p.scdn.co/mp3-preview/159fc05584217baa99581c4821f52d04670db6b2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hd9k5ini5xhrqtzdkt9a9rkrgclxvjqvwemkzvkax4qyfyvybm', '65p36432fiwizot6ayzou8eik0zvgen9pai10sotn37aptpolz', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7ls77h7uceu5832jipou6ogjxi557xrd79nl784adxk760cmwu','Just The Way You Are','0ky40bmjb8buxqm','POP','7BqBn9nzAq8spo5e7cZ0dJ','https://p.scdn.co/mp3-preview/6d1a901b10c7dc609d4c8628006b04bc6e672be8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hd9k5ini5xhrqtzdkt9a9rkrgclxvjqvwemkzvkax4qyfyvybm', '7ls77h7uceu5832jipou6ogjxi557xrd79nl784adxk760cmwu', '2');
-- Glass Animals
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9fevrogpzzdkzmo', 'Glass Animals', '4@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb66b27eccb69756f8eceabc23','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:4@artist.com', '9fevrogpzzdkzmo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9fevrogpzzdkzmo', 'Crafting psychedelic pop with intricate melodies and immersive soundscapes.', 'Glass Animals');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2mls42frfo0ealkbu0mqz55vyv3zotxxz7kkufshvgdc2kbksf','9fevrogpzzdkzmo', 'https://i.scdn.co/image/ab67616d0000b273712701c5e263efc8726b1464', 'Dreamland','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c3lzwy0lffhr9yrhghrm0pidxgtopptqx171s9zogc4iur18au','Heat Waves','9fevrogpzzdkzmo','POP','3USxtqRwSYz57Ewm6wWRMp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2mls42frfo0ealkbu0mqz55vyv3zotxxz7kkufshvgdc2kbksf', 'c3lzwy0lffhr9yrhghrm0pidxgtopptqx171s9zogc4iur18au', '0');
-- Morgan Wallen
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u4oc039v4svy5m3', 'Morgan Wallen', '5@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21ed0100a3a4e5aa3c57f6dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:5@artist.com', 'u4oc039v4svy5m3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u4oc039v4svy5m3', 'Blending country charm with rock energy to create memorable tunes.', 'Morgan Wallen');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kf2gqf4rx4d782curiedrvgw9lqhjj5t6o59h7jx956iubcmpl','u4oc039v4svy5m3', 'https://i.scdn.co/image/ab67616d0000b273705079df9a25a28b452c1fc9', 'One Thing At A Time','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bj63rlwnro1ut2uh6m2yk2wkj9hbd8h7p5ipagjox4bsqpdord','Last Night','u4oc039v4svy5m3','POP','7K3BhSpAxZBznislvUMVtn',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kf2gqf4rx4d782curiedrvgw9lqhjj5t6o59h7jx956iubcmpl', 'bj63rlwnro1ut2uh6m2yk2wkj9hbd8h7p5ipagjox4bsqpdord', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yg46a28tl8mbyo73ihlr9l67yf5dt22kej7d79mutqu86ephqr','You Proof','u4oc039v4svy5m3','POP','5W4kiM2cUYBJXKRudNyxjW',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kf2gqf4rx4d782curiedrvgw9lqhjj5t6o59h7jx956iubcmpl', 'yg46a28tl8mbyo73ihlr9l67yf5dt22kej7d79mutqu86ephqr', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('07y00l0ajcdm793ibr2kz27aspyzd1ftfm0v0v6d4en5yke41b','One Thing At A Time','u4oc039v4svy5m3','POP','1rXq0uoV4KTgRN64jXzIxo',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kf2gqf4rx4d782curiedrvgw9lqhjj5t6o59h7jx956iubcmpl', '07y00l0ajcdm793ibr2kz27aspyzd1ftfm0v0v6d4en5yke41b', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('quc5fjevoktjop13wv8z6kclgnnawb2agt7djrup9zt73ime8d','Aint Tha','u4oc039v4svy5m3','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kf2gqf4rx4d782curiedrvgw9lqhjj5t6o59h7jx956iubcmpl', 'quc5fjevoktjop13wv8z6kclgnnawb2agt7djrup9zt73ime8d', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gdf3hh31de1zrn4e23c40p2zlje7d2a0lujkwv4q19sw8gexrv','Thinkin B','u4oc039v4svy5m3','POP','0PAcdVzhPO4gq1Iym9ESnK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kf2gqf4rx4d782curiedrvgw9lqhjj5t6o59h7jx956iubcmpl', 'gdf3hh31de1zrn4e23c40p2zlje7d2a0lujkwv4q19sw8gexrv', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s3r7y82ch0ovvxvriqno1dj1sdnm8hrqhddutt9yg8mpnsckg4','Everything I Love','u4oc039v4svy5m3','POP','03fs6oV5JAlbytRYf3371S',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kf2gqf4rx4d782curiedrvgw9lqhjj5t6o59h7jx956iubcmpl', 's3r7y82ch0ovvxvriqno1dj1sdnm8hrqhddutt9yg8mpnsckg4', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0gaeibsee0b008jfjndnnlrbqgu7cuua0nps81h1ldudzryc0j','I Wrote The Book','u4oc039v4svy5m3','POP','7phmBo7bB9I9YifAXqnlqV',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kf2gqf4rx4d782curiedrvgw9lqhjj5t6o59h7jx956iubcmpl', '0gaeibsee0b008jfjndnnlrbqgu7cuua0nps81h1ldudzryc0j', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oiyaeknpmtezctp6jq362254ygmzz38x2j1eu6zd1pbkw7r514','Man Made A Bar (feat. Eric Church)','u4oc039v4svy5m3','POP','73zawW1ttszLRgT9By826D',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kf2gqf4rx4d782curiedrvgw9lqhjj5t6o59h7jx956iubcmpl', 'oiyaeknpmtezctp6jq362254ygmzz38x2j1eu6zd1pbkw7r514', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i8zko5c1ouipgblccdaa8x9daifnxedy28zyd829kmx1k6wr5p','98 Braves','u4oc039v4svy5m3','POP','3oZ6dlSfCE9gZ55MGPJctc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kf2gqf4rx4d782curiedrvgw9lqhjj5t6o59h7jx956iubcmpl', 'i8zko5c1ouipgblccdaa8x9daifnxedy28zyd829kmx1k6wr5p', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f04txytbz2utmyixwd35hzs2u9om26wgj21krddw45jj0wgdce','Thought You Should Know','u4oc039v4svy5m3','POP','3Qu3Zh4WTKhP9GEXo0aDnb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kf2gqf4rx4d782curiedrvgw9lqhjj5t6o59h7jx956iubcmpl', 'f04txytbz2utmyixwd35hzs2u9om26wgj21krddw45jj0wgdce', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('02fbmvabcikagbb0uqte3cod3dxen73fd93jo5il9xkifw1x87','Born With A Beer In My Hand','u4oc039v4svy5m3','POP','1BAU6v0fuAV914qMUEESR1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kf2gqf4rx4d782curiedrvgw9lqhjj5t6o59h7jx956iubcmpl', '02fbmvabcikagbb0uqte3cod3dxen73fd93jo5il9xkifw1x87', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cvv51xssmj6zg15nxetkux2z24iusuzfen369a95g0l6n7trx7','Devil Don','u4oc039v4svy5m3','POP','2PsbT927UanvyH9VprlNOu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kf2gqf4rx4d782curiedrvgw9lqhjj5t6o59h7jx956iubcmpl', 'cvv51xssmj6zg15nxetkux2z24iusuzfen369a95g0l6n7trx7', '11');
-- WizKid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zpnw1nyx59tikoc', 'WizKid', '6@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9050b61368975fda051cdc06','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:6@artist.com', 'zpnw1nyx59tikoc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zpnw1nyx59tikoc', 'Transcending language barriers through the universal language of music.', 'WizKid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ma4724zfhfgq82sz7ws06dwz0hrz4ognlp4cwvqqq5t7tp163h','zpnw1nyx59tikoc', NULL, 'WizKid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3117mc4dfgsdowrpm1ob3cqwint6m1z8ajql9p07faka4n19w7','Link Up (Metro Boomin & Don Toliver, Wizkid feat. BEAM & Toian) - Spider-Verse Remix (Spider-Man: Across the Spider-Verse )','zpnw1nyx59tikoc','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ma4724zfhfgq82sz7ws06dwz0hrz4ognlp4cwvqqq5t7tp163h', '3117mc4dfgsdowrpm1ob3cqwint6m1z8ajql9p07faka4n19w7', '0');
-- Steve Aoki
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('epdyddl9e9gsq63', 'Steve Aoki', '7@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5fb007a707c0ec3a7c1726af','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:7@artist.com', 'epdyddl9e9gsq63', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('epdyddl9e9gsq63', 'An endless quest for musical perfection.', 'Steve Aoki');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hbrzqwvzn5l4336cypcelnngp0mj3opnfli04m8ce3401cr31x','epdyddl9e9gsq63', NULL, 'Steve Aoki Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s9qgzydn1e9mb1ctr9s7vl75qxupajqqivpgp4yzu043k4fui4','Mu','epdyddl9e9gsq63','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hbrzqwvzn5l4336cypcelnngp0mj3opnfli04m8ce3401cr31x', 's9qgzydn1e9mb1ctr9s7vl75qxupajqqivpgp4yzu043k4fui4', '0');
-- Becky G
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jhtgwsa1lcxojyp', 'Becky G', '8@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd132bf0d4a9203404cd66f79','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:8@artist.com', 'jhtgwsa1lcxojyp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jhtgwsa1lcxojyp', 'Melodies that capture the essence of human emotion.', 'Becky G');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i9w0b2s2eg2a9iweq4g6951xdwx2he3pblpeljt5y6o972yify','jhtgwsa1lcxojyp', 'https://i.scdn.co/image/ab67616d0000b273c3bb167f0e78b15e5588c296', 'CHANEL','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j0tfq5lbeykifimgv7sksytwql3mzgtrgu4w1q9qlgh8yfec4g','Chanel','jhtgwsa1lcxojyp','POP','5RcxRGvmYai7kpFSfxe5GY','https://p.scdn.co/mp3-preview/38dbb82dace64ea92e1dafe5989c1d1861656595?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i9w0b2s2eg2a9iweq4g6951xdwx2he3pblpeljt5y6o972yify', 'j0tfq5lbeykifimgv7sksytwql3mzgtrgu4w1q9qlgh8yfec4g', '0');
-- Mambo Kingz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0i026wumzrx23j2', 'Mambo Kingz', '9@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb881ed0aa97cc8420685dc90e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:9@artist.com', '0i026wumzrx23j2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0i026wumzrx23j2', 'Redefining what it means to be an artist in the digital age.', 'Mambo Kingz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rfe3300c5ryha9ghbnguwtcp56zoodgfo0xfc32xp8rjmj9bfc','0i026wumzrx23j2', NULL, 'Mambo Kingz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2buwn6uisl1oi6mo2lqut36nru6of8vrg52xgmvksb97r0x3p6','Mejor Que Yo','0i026wumzrx23j2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rfe3300c5ryha9ghbnguwtcp56zoodgfo0xfc32xp8rjmj9bfc', '2buwn6uisl1oi6mo2lqut36nru6of8vrg52xgmvksb97r0x3p6', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s3nx6xzi1m8oskwtjo4p310bz6bas8zcfkbpfmke35xvkrjq8l','Mas Rica Que Ayer','0i026wumzrx23j2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rfe3300c5ryha9ghbnguwtcp56zoodgfo0xfc32xp8rjmj9bfc', 's3nx6xzi1m8oskwtjo4p310bz6bas8zcfkbpfmke35xvkrjq8l', '1');
-- NF
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('08vlycx2qe886l3', 'NF', '10@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1cf142a710a2f3d9b7a62da1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:10@artist.com', '08vlycx2qe886l3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('08vlycx2qe886l3', 'An odyssey of sound that defies conventions.', 'NF');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6j1o37duhydtmzw7ft0bkxuylv74ynmvteh277wk3ii2x70e44','08vlycx2qe886l3', 'https://i.scdn.co/image/ab67616d0000b273ff8a4276b3be31c839557439', 'HOPE','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('upv9gv5hybw4wqwbq8nhohsqys5v8njpwcepsxdpjjor5f53t6','HAPPY','08vlycx2qe886l3','POP','3ZEno9fORwMA1HPecdLi0R',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6j1o37duhydtmzw7ft0bkxuylv74ynmvteh277wk3ii2x70e44', 'upv9gv5hybw4wqwbq8nhohsqys5v8njpwcepsxdpjjor5f53t6', '0');
-- Kate Bush
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ognox5ypjoygu9n', 'Kate Bush', '11@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb187017724e58e78ee1f5a8e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:11@artist.com', 'ognox5ypjoygu9n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ognox5ypjoygu9n', 'Crafting a unique sonic identity in every track.', 'Kate Bush');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7bkwt4dlv26lxmhe2r0ylj3vii8tgbus8j6apwr2ws6bqy3ydl','ognox5ypjoygu9n', 'https://i.scdn.co/image/ab67616d0000b273ad08f4b38efbff0c0da0f252', 'Hounds Of Love','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9rigt32jbk59blrd48qmrfto1qqovk1i2jicciqkcwbcjmmrta','Running Up That Hill (A Deal With God)','ognox5ypjoygu9n','POP','1PtQJZVZIdWIYdARpZRDFO','https://p.scdn.co/mp3-preview/861d26b52ece3e3ad72a7dc3463daece3478801a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7bkwt4dlv26lxmhe2r0ylj3vii8tgbus8j6apwr2ws6bqy3ydl', '9rigt32jbk59blrd48qmrfto1qqovk1i2jicciqkcwbcjmmrta', '0');
-- Pritam
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rvcpcgrbh1pmlem', 'Pritam', '12@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcb6926f44f620555ba444fca','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:12@artist.com', 'rvcpcgrbh1pmlem', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rvcpcgrbh1pmlem', 'Striking chords that resonate across generations.', 'Pritam');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6selyuy84k7zwjv2frjxqmclppnio1c5ash177e3rbzyenjup4','rvcpcgrbh1pmlem', NULL, 'Pritam Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('utkljjzhl6nl0xcp9gpgwdoi9f8ynkajz5zi4w34y74ooxhhyf','Kesariya (From "Brahmastra")','rvcpcgrbh1pmlem','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6selyuy84k7zwjv2frjxqmclppnio1c5ash177e3rbzyenjup4', 'utkljjzhl6nl0xcp9gpgwdoi9f8ynkajz5zi4w34y74ooxhhyf', '0');
-- Michael Bubl
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w13zqip3vlaygdg', 'Michael Bubl', '13@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebef8cf61fea4923d2bde68200','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:13@artist.com', 'w13zqip3vlaygdg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w13zqip3vlaygdg', 'Melodies that capture the essence of human emotion.', 'Michael Bubl');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('de20uc9avb6iovxjwoyoyavhd7jvhksnf8u0ojdxydqbq2t71i','w13zqip3vlaygdg', 'https://i.scdn.co/image/ab67616d0000b273119e4094f07a8123b471ac1d', 'Christmas (Deluxe Special Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('05t7dp3nn77pkznbepc3kbmg28lvjypezl5um5fhg4p0vhnf6l','Its Beginning To Look A Lot Like Christmas','w13zqip3vlaygdg','POP','5a1iz510sv2W9Dt1MvFd5R','https://p.scdn.co/mp3-preview/51f36d7e04069ef4869ea575fb21e5404710b1c4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('de20uc9avb6iovxjwoyoyavhd7jvhksnf8u0ojdxydqbq2t71i', '05t7dp3nn77pkznbepc3kbmg28lvjypezl5um5fhg4p0vhnf6l', '0');
-- Joji
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tva9p83ohlx11rm', 'Joji', '14@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4111c95b5f430c3265c7304b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:14@artist.com', 'tva9p83ohlx11rm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tva9p83ohlx11rm', 'A maestro of melodies, orchestrating auditory bliss.', 'Joji');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0avmpy379o4i28pnoxerwr3n7nsjjwxr6tmyf44vi5xmw9kqqb','tva9p83ohlx11rm', 'https://i.scdn.co/image/ab67616d0000b27308596cc28b9f5b00bfe08ae7', 'Glimpse of Us','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c7acc45xzt3g3qgnc2vlu3z1fe77dj7k434kr54ff9y0n9itu5','Glimpse of Us','tva9p83ohlx11rm','POP','6xGruZOHLs39ZbVccQTuPZ','https://p.scdn.co/mp3-preview/12e4a7ef3f1051424e6e282dfba83fe8448e122f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0avmpy379o4i28pnoxerwr3n7nsjjwxr6tmyf44vi5xmw9kqqb', 'c7acc45xzt3g3qgnc2vlu3z1fe77dj7k434kr54ff9y0n9itu5', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nssigwmg9bptj3p0ax7sd17o8zggeoaxic8x5qxasgpwt2vvdw','Die For You','tva9p83ohlx11rm','POP','26hOm7dTtBi0TdpDGl141t','https://p.scdn.co/mp3-preview/85d19ba2d8274ab29f474b3baf07b6ac6ba6d35a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0avmpy379o4i28pnoxerwr3n7nsjjwxr6tmyf44vi5xmw9kqqb', 'nssigwmg9bptj3p0ax7sd17o8zggeoaxic8x5qxasgpwt2vvdw', '1');
-- Abhijay Sharma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('oqcliikxa1u2ed0', 'Abhijay Sharma', '15@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb27c847b083cba83db3b7574c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:15@artist.com', 'oqcliikxa1u2ed0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('oqcliikxa1u2ed0', 'A symphony of emotions expressed through sound.', 'Abhijay Sharma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cak5843mj01obdv77njlzcfq27fdgursvtkdkomgl6xwwrg2ec','oqcliikxa1u2ed0', NULL, 'Abhijay Sharma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q03vwgl7dw151d0wvf17ujtbgri5ael8cljxltvfyfllcwmi49','Obsessed','oqcliikxa1u2ed0','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cak5843mj01obdv77njlzcfq27fdgursvtkdkomgl6xwwrg2ec', 'q03vwgl7dw151d0wvf17ujtbgri5ael8cljxltvfyfllcwmi49', '0');
-- SZA
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hr6svcptyhrlddw', 'SZA', '16@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0895066d172e1f51f520bc65','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:16@artist.com', 'hr6svcptyhrlddw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hr6svcptyhrlddw', 'An avant-garde R&B artist painting vivid stories through her music.', 'SZA');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4jwdammgg9t7qmxmrn15q7gphbgshul3mo7lrfoaeozuo7g630','hr6svcptyhrlddw', 'https://i.scdn.co/image/ab67616d0000b2730c471c36970b9406233842a5', 'SOS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1urhdjkkcbjl7e91ef8o6q5pci05ey556ngeqtrmj6zto2hv6p','Kill Bill','hr6svcptyhrlddw','POP','1Qrg8KqiBpW07V7PNxwwwL','https://p.scdn.co/mp3-preview/4bd2dc84016f3743add7eea8b988407b1b900672?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4jwdammgg9t7qmxmrn15q7gphbgshul3mo7lrfoaeozuo7g630', '1urhdjkkcbjl7e91ef8o6q5pci05ey556ngeqtrmj6zto2hv6p', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o157laauq98fsuuk13wkiclsdgrgp4n0go015az3uy65cgq32p','Snooze','hr6svcptyhrlddw','POP','4iZ4pt7kvcaH6Yo8UoZ4s2','https://p.scdn.co/mp3-preview/8c53920b5fd2c3178afa36cac9eec68b5ee9204a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4jwdammgg9t7qmxmrn15q7gphbgshul3mo7lrfoaeozuo7g630', 'o157laauq98fsuuk13wkiclsdgrgp4n0go015az3uy65cgq32p', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8koz8dr66ldafs476c1g7gg5f0aax3lvyjo8wedjfkv9wrilse','Low','hr6svcptyhrlddw','POP','2GAhgAjOhEmItWLfgisyOn','https://p.scdn.co/mp3-preview/5b6dd5a1d06d0bdfd57382a584cbf0227b4d9a4b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4jwdammgg9t7qmxmrn15q7gphbgshul3mo7lrfoaeozuo7g630', '8koz8dr66ldafs476c1g7gg5f0aax3lvyjo8wedjfkv9wrilse', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gc5c3w4vyr7egba584qdyqepoa81bqlwcxpmni4z4030ierf67','Nobody Gets Me','hr6svcptyhrlddw','POP','5Y35SjAfXjjG0sFQ3KOxmm','https://p.scdn.co/mp3-preview/36cfe8fbfb78aa38ca3b222c4b9fc88cda992841?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4jwdammgg9t7qmxmrn15q7gphbgshul3mo7lrfoaeozuo7g630', 'gc5c3w4vyr7egba584qdyqepoa81bqlwcxpmni4z4030ierf67', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ei8609t1lc6g59wji8wgltxgs74i202xa4wjafwt8u0zkp9dx7','Shirt','hr6svcptyhrlddw','POP','2wSTnntOPRi7aQneobFtU4','https://p.scdn.co/mp3-preview/8819fb0dc127d1d777a776f4d1186be783334ae5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4jwdammgg9t7qmxmrn15q7gphbgshul3mo7lrfoaeozuo7g630', 'ei8609t1lc6g59wji8wgltxgs74i202xa4wjafwt8u0zkp9dx7', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dk5rl6v995qubfiss3wetn5a7fkoay99yquqkavgp0tlu4q9zi','Blind','hr6svcptyhrlddw','POP','2CSRrnOEELmhpq8iaAi9cd','https://p.scdn.co/mp3-preview/56cd00fd7aa857bd25e4ed25aebc0e41a24bfd4f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4jwdammgg9t7qmxmrn15q7gphbgshul3mo7lrfoaeozuo7g630', 'dk5rl6v995qubfiss3wetn5a7fkoay99yquqkavgp0tlu4q9zi', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('02zgcfmpbip4c6tr36lwat05mh3cv6x074800inlb52p6x17jp','Good Days','hr6svcptyhrlddw','POP','4PMqSO5qyjpvzhlLI5GnID','https://p.scdn.co/mp3-preview/d7fd97c8190baa298af9b4e778d2ba940fcd13a4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4jwdammgg9t7qmxmrn15q7gphbgshul3mo7lrfoaeozuo7g630', '02zgcfmpbip4c6tr36lwat05mh3cv6x074800inlb52p6x17jp', '6');
-- Shakira
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('n46mrb0ff86nva2', 'Shakira', '17@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba94d903e52abf6c43bae28ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:17@artist.com', 'n46mrb0ff86nva2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('n46mrb0ff86nva2', 'Redefining what it means to be an artist in the digital age.', 'Shakira');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t71yxc79mpu1idlv5exatntfzxpvtoh33vpyqovrv7ogcum8b7','n46mrb0ff86nva2', NULL, 'Te Felicito','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y3m3f7f8wcur19zy6mzxcirbgcdbpa2tse8co9f9xbwhhtyczg','Shakira: Bzrp Music Sessions, Vol. 53','n46mrb0ff86nva2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t71yxc79mpu1idlv5exatntfzxpvtoh33vpyqovrv7ogcum8b7', 'y3m3f7f8wcur19zy6mzxcirbgcdbpa2tse8co9f9xbwhhtyczg', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8zuftrc5jc6ak40kf6fp8xnr8qqtpkz98l1x8va9qaatxi1crh','Acrs','n46mrb0ff86nva2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t71yxc79mpu1idlv5exatntfzxpvtoh33vpyqovrv7ogcum8b7', '8zuftrc5jc6ak40kf6fp8xnr8qqtpkz98l1x8va9qaatxi1crh', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('62cpdk3c7k3nw803t2criczzguhc4l5bfwu8crfzxgecm7y3cl','Te Felicito','n46mrb0ff86nva2','POP','2rurDawMfoKP4uHyb2kJBt','https://p.scdn.co/mp3-preview/6b4b2be03b14bf758835c8f28f35834da35cc1c3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t71yxc79mpu1idlv5exatntfzxpvtoh33vpyqovrv7ogcum8b7', '62cpdk3c7k3nw803t2criczzguhc4l5bfwu8crfzxgecm7y3cl', '2');
-- NewJeans
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ftpsrbqu7dstzxo', 'NewJeans', '18@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5da361915b1fa48895d4f23f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:18@artist.com', 'ftpsrbqu7dstzxo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ftpsrbqu7dstzxo', 'Redefining K-pop with their fresh style and energetic performances.', 'NewJeans');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('c1xaicsv15nuol0fghuy08fz2tgr58rwnwh4spjwgsr5kldmca','ftpsrbqu7dstzxo', 'https://i.scdn.co/image/ab67616d0000b2733d98a0ae7c78a3a9babaf8af', 'NewJeans Super Shy','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t0aw88l59ly4d3yybe011na72uq4anm2zffw0eas9lekhaeeo6','Super Shy','ftpsrbqu7dstzxo','POP','5sdQOyqq2IDhvmx2lHOpwd','https://p.scdn.co/mp3-preview/dab062e2cc708a2680ce84953a3581c5a679a230?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c1xaicsv15nuol0fghuy08fz2tgr58rwnwh4spjwgsr5kldmca', 't0aw88l59ly4d3yybe011na72uq4anm2zffw0eas9lekhaeeo6', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ke2jybzmh0jhaj4nxg4grlsww9ypouvttzd6wc1hul15zgm3m1','New Jeans','ftpsrbqu7dstzxo','POP','6rdkCkjk6D12xRpdMXy0I2','https://p.scdn.co/mp3-preview/a37b4269b0dc5e952826d8c43d1b7c072ac39b4c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c1xaicsv15nuol0fghuy08fz2tgr58rwnwh4spjwgsr5kldmca', 'ke2jybzmh0jhaj4nxg4grlsww9ypouvttzd6wc1hul15zgm3m1', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l8b1jh49g8g83x78vjh07owe2tzhzpo06773u641ku41lur03r','OMG','ftpsrbqu7dstzxo','POP','65FftemJ1DbbZ45DUfHJXE','https://p.scdn.co/mp3-preview/b9e344aa96afc45a56df77ca63c78786bdaa0047?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c1xaicsv15nuol0fghuy08fz2tgr58rwnwh4spjwgsr5kldmca', 'l8b1jh49g8g83x78vjh07owe2tzhzpo06773u641ku41lur03r', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('855qe8tasrb9rdtpuw4pwqfl5vrmfpwxqsuihs9kd5b01h8l7n','Ditto','ftpsrbqu7dstzxo','POP','3r8RuvgbX9s7ammBn07D3W','https://p.scdn.co/mp3-preview/4f048713ddfa434539dec7c3cb689f3393353edd?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c1xaicsv15nuol0fghuy08fz2tgr58rwnwh4spjwgsr5kldmca', '855qe8tasrb9rdtpuw4pwqfl5vrmfpwxqsuihs9kd5b01h8l7n', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('evezq0klzms8l2dgtvlg8kw5iqf2vz4d0dnnsb79dbvx5pez2k','Hype Boy','ftpsrbqu7dstzxo','POP','0a4MMyCrzT0En247IhqZbD','https://p.scdn.co/mp3-preview/7c55950057fc446dc2ce59671dff4fa6b3ef52a7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c1xaicsv15nuol0fghuy08fz2tgr58rwnwh4spjwgsr5kldmca', 'evezq0klzms8l2dgtvlg8kw5iqf2vz4d0dnnsb79dbvx5pez2k', '4');
-- Tom Odell
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6sfd43j8i0zoux6', 'Tom Odell', '19@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb532e8dd8ba9fbd5e78105a78','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:19@artist.com', '6sfd43j8i0zoux6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6sfd43j8i0zoux6', 'Stirring emotions with piano-driven melodies and poetic lyrics.', 'Tom Odell');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2dxtki4q5c46lqojbsl9cq083xoi9vrn4pelb8yixn9p6qwlcq','6sfd43j8i0zoux6', 'https://i.scdn.co/image/ab67616d0000b2731917a0f3f4152622a040913f', 'Long Way Down (Deluxe)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uxtvwup0wxgq3w741fwq3dj8rhhrw8fu1pzidc8lg8p7mlskve','Another Love','6sfd43j8i0zoux6','POP','3JvKfv6T31zO0ini8iNItO','https://p.scdn.co/mp3-preview/0369cb748bc968ffd34fb4ac60f5403f2aad032f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2dxtki4q5c46lqojbsl9cq083xoi9vrn4pelb8yixn9p6qwlcq', 'uxtvwup0wxgq3w741fwq3dj8rhhrw8fu1pzidc8lg8p7mlskve', '0');
-- Lil Uzi Vert
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('77scq5kwgd31l7b', 'Lil Uzi Vert', '20@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1234d2f516796badbdf16a89','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:20@artist.com', '77scq5kwgd31l7b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('77scq5kwgd31l7b', 'Revolutionizing the music scene with innovative compositions.', 'Lil Uzi Vert');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3r05f2ja347730n7aaea4ip66nxuergtcnjmcdg8kf9nbmy6zy','77scq5kwgd31l7b', 'https://i.scdn.co/image/ab67616d0000b273438799bc344744c12028bb0f', 'Just Wanna Rock','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x2do25wlgs7fyo6xogahdvmbpf4bnxxoruo6lng1p5rq7sf9v5','Just Wanna Rock','77scq5kwgd31l7b','POP','4FyesJzVpA39hbYvcseO2d','https://p.scdn.co/mp3-preview/72dce26448e87be36c3776ded36b75a9fd01359e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3r05f2ja347730n7aaea4ip66nxuergtcnjmcdg8kf9nbmy6zy', 'x2do25wlgs7fyo6xogahdvmbpf4bnxxoruo6lng1p5rq7sf9v5', '0');
-- Rich The Kid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7g6xolu1ah8bodz', 'Rich The Kid', '21@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb10379ac1a13fa06e703bf421','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:21@artist.com', '7g6xolu1ah8bodz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7g6xolu1ah8bodz', 'Blending traditional rhythms with modern beats.', 'Rich The Kid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vkaf1tyftw7smxf3gv2t7uhhkxtmu8snvgd6de3chly6qc9fd4','7g6xolu1ah8bodz', NULL, 'Rich The Kid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('moq4ix0f6ir2vnq52ocaq599ygfyjmjzdvf30hte7bihq4syfc','Conexes de Mfia (feat. Rich ','7g6xolu1ah8bodz','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vkaf1tyftw7smxf3gv2t7uhhkxtmu8snvgd6de3chly6qc9fd4', 'moq4ix0f6ir2vnq52ocaq599ygfyjmjzdvf30hte7bihq4syfc', '0');
-- DJ Escobar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tqtyd62osq80veq', 'DJ Escobar', '22@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb62fa9c7f56a64dc956ec2621','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:22@artist.com', 'tqtyd62osq80veq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tqtyd62osq80veq', 'Transcending language barriers through the universal language of music.', 'DJ Escobar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('z1s1snut541y6ion61i1e50c2g356465wu4wkugrntea7h67lf','tqtyd62osq80veq', 'https://i.scdn.co/image/ab67616d0000b273769f6572dfa10ee7827edbf2', 'Evoque Prata - Remix Funk','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f260r64mmp8x5yz6yszruz63jky8gqbs8rf11wv8lzi5cljjr6','Evoque Prata','tqtyd62osq80veq','POP','4mQ2UZzSH3T4o4Gr9phTgL','https://p.scdn.co/mp3-preview/f2c69618853c528447f24f0102d0e5404fe31ed9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z1s1snut541y6ion61i1e50c2g356465wu4wkugrntea7h67lf', 'f260r64mmp8x5yz6yszruz63jky8gqbs8rf11wv8lzi5cljjr6', '0');
-- Grupo Frontera
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('migrgp6fq5v5mhw', 'Grupo Frontera', '23@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f1a7e9f510bf0501e209c58','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:23@artist.com', 'migrgp6fq5v5mhw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('migrgp6fq5v5mhw', 'Crafting soundscapes that transport listeners to another world.', 'Grupo Frontera');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uopb46i3yzz0jzbf00ad7djwlzvyrwzg1itt6heiyas2s095ov','migrgp6fq5v5mhw', 'https://i.scdn.co/image/ab67616d0000b27382ce4c7bbf861185252e82ae', 'El Comienzo','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1285pzodpgdp1tgjakoidhtjkgwy806akxx145yw5hfecethkx','No Se Va','migrgp6fq5v5mhw','POP','76kelNDs1ojicx1s6Urvck','https://p.scdn.co/mp3-preview/1aa36481ad26b54ce635e7eb7d7360353c09d9ea?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uopb46i3yzz0jzbf00ad7djwlzvyrwzg1itt6heiyas2s095ov', '1285pzodpgdp1tgjakoidhtjkgwy806akxx145yw5hfecethkx', '0');
-- Eminem
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ec8ah3stm18xdkb', 'Eminem', '24@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba00b11c129b27a88fc72f36b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:24@artist.com', 'ec8ah3stm18xdkb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ec8ah3stm18xdkb', 'Harnessing the power of melody to tell compelling stories.', 'Eminem');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('w52nmw49vzzjz1iuaukpani0ltukiu77u4k1k1bcgn19mj2svd','ec8ah3stm18xdkb', 'https://i.scdn.co/image/ab67616d0000b273726d48d93d02e1271774f023', 'Encore (Deluxe Version)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7acijj2icd3xbal180bzmxb8hzemd74wkn2qd0nz7f44iq94ln','Mockingbird','ec8ah3stm18xdkb','POP','561jH07mF1jHuk7KlaeF0s',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w52nmw49vzzjz1iuaukpani0ltukiu77u4k1k1bcgn19mj2svd', '7acijj2icd3xbal180bzmxb8hzemd74wkn2qd0nz7f44iq94ln', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kj73wd2hneebyq7dflwy1dba3ivybgszjuat3kfz5vkgku342k','Without Me','ec8ah3stm18xdkb','POP','7lQ8MOhq6IN2w8EYcFNSUk',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w52nmw49vzzjz1iuaukpani0ltukiu77u4k1k1bcgn19mj2svd', 'kj73wd2hneebyq7dflwy1dba3ivybgszjuat3kfz5vkgku342k', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5h0fe19qhtngz9fpgx8qa1186cqo02i0eutaf0d6nndzucstjm','The Real Slim Shady','ec8ah3stm18xdkb','POP','3yfqSUWxFvZELEM4PmlwIR',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w52nmw49vzzjz1iuaukpani0ltukiu77u4k1k1bcgn19mj2svd', '5h0fe19qhtngz9fpgx8qa1186cqo02i0eutaf0d6nndzucstjm', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('usjthzf6eamojts96gk0gfzs5b8lqxyzvc990pfckf4hmwr51c','Lose Yourself - Soundtrack Version','ec8ah3stm18xdkb','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w52nmw49vzzjz1iuaukpani0ltukiu77u4k1k1bcgn19mj2svd', 'usjthzf6eamojts96gk0gfzs5b8lqxyzvc990pfckf4hmwr51c', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ojsilu0e86il19xkdexw79cmczhhcl300vr3vdjhr23ww6oy6q','Superman','ec8ah3stm18xdkb','POP','4woTEX1wYOTGDqNXuavlRC',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w52nmw49vzzjz1iuaukpani0ltukiu77u4k1k1bcgn19mj2svd', 'ojsilu0e86il19xkdexw79cmczhhcl300vr3vdjhr23ww6oy6q', '4');
-- Keane
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h1lkdsc54cizgiy', 'Keane', '25@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41222a45dc0b10f65cbe8160','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:25@artist.com', 'h1lkdsc54cizgiy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h1lkdsc54cizgiy', 'Crafting soundscapes that transport listeners to another world.', 'Keane');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4w52mfed3chznyazi9di815clnxe69ufnto4rkhd0ag8dkz1f3','h1lkdsc54cizgiy', 'https://i.scdn.co/image/ab67616d0000b273045d0a38105fbe7bde43c490', 'Hopes And Fears','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3vsm6qj56p9g76ritw3es6s6wbeomnjl701z7r4sx50amw2fez','Somewhere Only We Know','h1lkdsc54cizgiy','POP','0ll8uFnc0nANY35E0Lfxvg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4w52mfed3chznyazi9di815clnxe69ufnto4rkhd0ag8dkz1f3', '3vsm6qj56p9g76ritw3es6s6wbeomnjl701z7r4sx50amw2fez', '0');
-- Wisin & Yandel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('896gzkvevuimxlh', 'Wisin & Yandel', '26@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5496c4b788e181679069ee8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:26@artist.com', '896gzkvevuimxlh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('896gzkvevuimxlh', 'Redefining what it means to be an artist in the digital age.', 'Wisin & Yandel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ga5pjrqx956zhpaxos17j2vzp1c7agkpiqge07ruprstp3kso9','896gzkvevuimxlh', 'https://i.scdn.co/image/ab67616d0000b2739f05bb270f81880fd844aae8', 'La Última Misión','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('509fg305rwnrxj272iq2co8yeqouwoetcb5hp4dispc6wd524x','Besos Moja2','896gzkvevuimxlh','POP','6OzUIp8KjuwxJnCWkXp1uL','https://p.scdn.co/mp3-preview/8b17c9ae5706f7f2e41a6ec3470631b3094017b6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ga5pjrqx956zhpaxos17j2vzp1c7agkpiqge07ruprstp3kso9', '509fg305rwnrxj272iq2co8yeqouwoetcb5hp4dispc6wd524x', '0');
-- Raim Laode
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4a5xs6amo1waini', 'Raim Laode', '27@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f5fe38a2d25be089bf281e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:27@artist.com', '4a5xs6amo1waini', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4a5xs6amo1waini', 'Melodies that capture the essence of human emotion.', 'Raim Laode');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('s93dg8r1ek11gwk8buu9dac176qoa21ytcbbts2b31swcoezd0','4a5xs6amo1waini', 'https://i.scdn.co/image/ab67616d0000b2735733fcb8f308e4bca3d3a1c9', 'Komang','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7d9z4cgfk5kdmkeoyb9ons381zxa9ac9t6she78xx4rlhfgvqi','Komang','4a5xs6amo1waini','POP','654ZF6YNWjQS2NhwR3QnX7','https://p.scdn.co/mp3-preview/de2ec1a10faf62ec1c6af15bd45b3d93b2c9ee67?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s93dg8r1ek11gwk8buu9dac176qoa21ytcbbts2b31swcoezd0', '7d9z4cgfk5kdmkeoyb9ons381zxa9ac9t6she78xx4rlhfgvqi', '0');
-- Steve Lacy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j7ydo5cv617240i', 'Steve Lacy', '28@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb09ac9d040c168d4e4f58eb42','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:28@artist.com', 'j7ydo5cv617240i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j7ydo5cv617240i', 'Crafting a unique sonic identity in every track.', 'Steve Lacy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('beyvmcq7coi6j76dzp3wzenibhljdwfnjof4aoy2pfj2l9qozn','j7ydo5cv617240i', 'https://i.scdn.co/image/ab67616d0000b27368968350c2550e36d96344ee', 'Gemini Rights','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0xcsmcxe5mepqsezrytgkjef4k6or4ggcols0h3164xerigxcs','Bad Habit','j7ydo5cv617240i','POP','4k6Uh1HXdhtusDW5y8Gbvy','https://p.scdn.co/mp3-preview/efe7c2fdd8fa727a108a1270b114ebedabfd766c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('beyvmcq7coi6j76dzp3wzenibhljdwfnjof4aoy2pfj2l9qozn', '0xcsmcxe5mepqsezrytgkjef4k6or4ggcols0h3164xerigxcs', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w3ldbn09tdp5ozah98qfnyi2e2qnx8tr18ouqeq3ddvy08gacd','Dark Red','j7ydo5cv617240i','POP','3EaJDYHA0KnX88JvDhL9oa','https://p.scdn.co/mp3-preview/90b3855fd50a4c4878a2d5117ebe73f658a97285?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('beyvmcq7coi6j76dzp3wzenibhljdwfnjof4aoy2pfj2l9qozn', 'w3ldbn09tdp5ozah98qfnyi2e2qnx8tr18ouqeq3ddvy08gacd', '1');
-- Yahritza Y Su Esencia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('iv4pticm1hz6uof', 'Yahritza Y Su Esencia', '29@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68d4ccdc175f594122f1eee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:29@artist.com', 'iv4pticm1hz6uof', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('iv4pticm1hz6uof', 'Infusing traditional melodies with youthful vigor.', 'Yahritza Y Su Esencia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('20wba1kfsjnwzz6i61rut16vaac8ra2mhqezrfkmvv949go0mn','iv4pticm1hz6uof', NULL, 'Yahritza Y Su Esencia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1v4pg1ojvpfuu3eqbyxz8qqss1jvqzshrk0byi8xvxkko79z1n','Frgil (feat. Grupo Front','iv4pticm1hz6uof','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('20wba1kfsjnwzz6i61rut16vaac8ra2mhqezrfkmvv949go0mn', '1v4pg1ojvpfuu3eqbyxz8qqss1jvqzshrk0byi8xvxkko79z1n', '0');
-- The Weeknd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sss1j4y5lhy9xcs', 'The Weeknd', '30@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:30@artist.com', 'sss1j4y5lhy9xcs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sss1j4y5lhy9xcs', 'A trailblazer in the world of R&B, constantly redefining the genre.', 'The Weeknd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2','sss1j4y5lhy9xcs', NULL, 'Karaoke Picks Vol. 130','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r6g1a1i8dod2wloxmkpy6301f4sfmtnxr35ryrnd79gmsv5ca5','Popular (with Playboi Carti & Madonna) - The Idol Vol. 1 (Music from the HBO Original Series)','sss1j4y5lhy9xcs','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2', 'r6g1a1i8dod2wloxmkpy6301f4sfmtnxr35ryrnd79gmsv5ca5', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7se7vrk91k2ph8jd64imzqkn8dwuw5bnv5c7zi1agaug5d7khj','Creepin','sss1j4y5lhy9xcs','POP','0GVaOXDGwtnH8gCURYyEaK','https://p.scdn.co/mp3-preview/a2b11e2f0cb8ef4a0316a686e73da9ec2b203e6e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2', '7se7vrk91k2ph8jd64imzqkn8dwuw5bnv5c7zi1agaug5d7khj', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9vn41d52qpkzt0wj8ldk8bj5wxkr0qycxeuqrqojxeasmh2x1s','Die For You','sss1j4y5lhy9xcs','POP','2LBqCSwhJGcFQeTHMVGwy3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2', '9vn41d52qpkzt0wj8ldk8bj5wxkr0qycxeuqrqojxeasmh2x1s', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mnhqm6cfjk9rrwnm86ol80wzuw1oft11wclbd0xac6r1giiahl','Starboy','sss1j4y5lhy9xcs','POP','7MXVkk9YMctZqd1Srtv4MB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2', 'mnhqm6cfjk9rrwnm86ol80wzuw1oft11wclbd0xac6r1giiahl', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4cfvsxdjfvg7birovp544uwk7i0tgx7a7ogr0j8kwhqd4odlcr','Blinding Lights','sss1j4y5lhy9xcs','POP','0VjIjW4GlUZAMYd2vXMi3b',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2', '4cfvsxdjfvg7birovp544uwk7i0tgx7a7ogr0j8kwhqd4odlcr', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('unm7xcvs0zqe388r1nusaotsi6i67z1oz9q8y531rl6e9698jx','Stargirl Interlude','sss1j4y5lhy9xcs','POP','5gDWsRxpJ2lZAffh5p7K0w',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2', 'unm7xcvs0zqe388r1nusaotsi6i67z1oz9q8y531rl6e9698jx', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2mv3yssooiboqpiqs14tqkjkc1s5aarb8oqv416q6rgr8k0ag6','Save Your Tears','sss1j4y5lhy9xcs','POP','5QO79kh1waicV47BqGRL3g',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2', '2mv3yssooiboqpiqs14tqkjkc1s5aarb8oqv416q6rgr8k0ag6', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7nykaf3g32qx66h0b2gf6bngrod4ejj2fne1608rvi3fl3zx4h','Reminder','sss1j4y5lhy9xcs','POP','37F0uwRSrdzkBiuj0D5UHI',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2', '7nykaf3g32qx66h0b2gf6bngrod4ejj2fne1608rvi3fl3zx4h', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lmv5y7b8gdfvhtaqbqsupi2ksbzpccu9kpmv5xsz7bewjxetth','Double Fantasy (with Future)','sss1j4y5lhy9xcs','POP','4VMRsbfZzd3SfQtaJ1Wpwi',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2', 'lmv5y7b8gdfvhtaqbqsupi2ksbzpccu9kpmv5xsz7bewjxetth', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vsurr2f4m4cxnsbjsmori4ztavht74suue254a200eetvl7kop','I Was Never There','sss1j4y5lhy9xcs','POP','1cKHdTo9u0ZymJdPGSh6nq',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2', 'vsurr2f4m4cxnsbjsmori4ztavht74suue254a200eetvl7kop', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('huxkabojq5znmky5modn2qg94py4x97bhk15sz990nqsj37fm6','Call Out My Name','sss1j4y5lhy9xcs','POP','09mEdoA6zrmBPgTEN5qXmN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2', 'huxkabojq5znmky5modn2qg94py4x97bhk15sz990nqsj37fm6', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u71hzs878vg21qo6ve508oubi0m0wmmusof2zjm6zjhsm9y57b','The Hills','sss1j4y5lhy9xcs','POP','7fBv7CLKzipRk6EC6TWHOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2', 'u71hzs878vg21qo6ve508oubi0m0wmmusof2zjm6zjhsm9y57b', '11');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g7fxd9yi0v4n550o224rml7i59edf5a1nj639ua9yfgx9r6n6b','After Hours','sss1j4y5lhy9xcs','POP','2p8IUWQDrpjuFltbdgLOag',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfkwqtietvjzkvu7d35pf3z6eetkhix207wvugsvj6xvh9ejq2', 'g7fxd9yi0v4n550o224rml7i59edf5a1nj639ua9yfgx9r6n6b', '12');
-- Arijit Singh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('awbys2z3j79mblu', 'Arijit Singh', '31@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0261696c5df3be99da6ed3f3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:31@artist.com', 'awbys2z3j79mblu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('awbys2z3j79mblu', 'A visionary in the world of music, redefining genres.', 'Arijit Singh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jcumjzteuc9ydakg1ybrl2vl6sp55yi1h84vf2x18ymjutd5zv','awbys2z3j79mblu', NULL, 'Arijit Singh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tb6heuuvaox5ki6bqd165ch1idjlu8lx710984kis84cryv889','Phir Aur Kya Chahiye (From "Zara Hatke Zara Bachke")','awbys2z3j79mblu','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jcumjzteuc9ydakg1ybrl2vl6sp55yi1h84vf2x18ymjutd5zv', 'tb6heuuvaox5ki6bqd165ch1idjlu8lx710984kis84cryv889', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6lafcij9bza8phdap90ny0p54d8531gzbsu6wor8ybphvsch1q','Apna Bana Le (From "Bhediya")','awbys2z3j79mblu','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jcumjzteuc9ydakg1ybrl2vl6sp55yi1h84vf2x18ymjutd5zv', '6lafcij9bza8phdap90ny0p54d8531gzbsu6wor8ybphvsch1q', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sqnb57iwrylo733lq3yxcvbbfevprjf9rkwjri9lza5de3y0ml','Jhoome Jo Pathaan','awbys2z3j79mblu','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jcumjzteuc9ydakg1ybrl2vl6sp55yi1h84vf2x18ymjutd5zv', 'sqnb57iwrylo733lq3yxcvbbfevprjf9rkwjri9lza5de3y0ml', '2');
-- MC Caverinha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v5joznkqso7m9bj', 'MC Caverinha', '32@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb48d62acd2e6408096141a088','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:32@artist.com', 'v5joznkqso7m9bj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v5joznkqso7m9bj', 'The heartbeat of a new generation of music lovers.', 'MC Caverinha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6tsv5vxhskfs8o2tfzn250tgku9ng96nmrzq2u3wr909yxdmca','v5joznkqso7m9bj', NULL, 'MC Caverinha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qychc6bvgnyhlbjfczqse0q588ybjmnzyyzjpq5l61okgb1dsj','Carto B','v5joznkqso7m9bj','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6tsv5vxhskfs8o2tfzn250tgku9ng96nmrzq2u3wr909yxdmca', 'qychc6bvgnyhlbjfczqse0q588ybjmnzyyzjpq5l61okgb1dsj', '0');
-- sped up nightcore
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ygx748b1i73xe63', 'sped up nightcore', '33@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb54f60615e528d62665ef1d14','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:33@artist.com', 'ygx748b1i73xe63', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ygx748b1i73xe63', 'Igniting the stage with electrifying performances.', 'sped up nightcore');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('p3m2wh7nb6p2f8w7goh1b4yfxlguiqiy18qzroerrvm18g98ta','ygx748b1i73xe63', NULL, 'sped up nightcore Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('30bzkmq49b95cntn5k6em1fmonkjfi2rgq580bx1meoatnvjwh','Watch This - ARIZONATEARS Pluggnb Remix','ygx748b1i73xe63','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p3m2wh7nb6p2f8w7goh1b4yfxlguiqiy18qzroerrvm18g98ta', '30bzkmq49b95cntn5k6em1fmonkjfi2rgq580bx1meoatnvjwh', '0');
-- Lost Frequencies
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('okfjpt4c1sppo52', 'Lost Frequencies', '34@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a77aaa2cde6783b1ca727e9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:34@artist.com', 'okfjpt4c1sppo52', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('okfjpt4c1sppo52', 'Igniting the stage with electrifying performances.', 'Lost Frequencies');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('39r9qgnmeo2ooo7uvgvpl1govlu1a98hmxhpu0gdddm66v99lz','okfjpt4c1sppo52', 'https://i.scdn.co/image/ab67616d0000b2738d7a7f1855b04104ba59c18b', 'Where Are You Now','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d4vpey68mupdj2fsefknc0kzc5ivfm7oe4xoq0uyqhobibd474','Where Are You Now','okfjpt4c1sppo52','POP','3uUuGVFu1V7jTQL60S1r8z','https://p.scdn.co/mp3-preview/e2646d5bc8c56e4a91582a03c089f8038772aecb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('39r9qgnmeo2ooo7uvgvpl1govlu1a98hmxhpu0gdddm66v99lz', 'd4vpey68mupdj2fsefknc0kzc5ivfm7oe4xoq0uyqhobibd474', '0');
-- Gustavo Mioto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('09938htmlsvoybg', 'Gustavo Mioto', '35@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcec51a9ef6fe19159cb0452f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:35@artist.com', '09938htmlsvoybg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('09938htmlsvoybg', 'Where words fail, my music speaks.', 'Gustavo Mioto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('aheg9nin4g8wwf6ed93nt29m4oiqppr72mpez0xxpfz5smn1vq','09938htmlsvoybg', 'https://i.scdn.co/image/ab67616d0000b27319bb2fb697a42c1084d71f6c', 'Eu Gosto Assim (Ao Vivo)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xd10pzyeru63arof6mhp7g23ioquiq8524nrdrci2ln9iw42ge','Eu Gosto Assim - Ao Vivo','09938htmlsvoybg','POP','4ASA1PZyWGbuc4d9N8OAcF',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('aheg9nin4g8wwf6ed93nt29m4oiqppr72mpez0xxpfz5smn1vq', 'xd10pzyeru63arof6mhp7g23ioquiq8524nrdrci2ln9iw42ge', '0');
-- Libianca
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wj79z09mmbpzfja', 'Libianca', '36@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a42e7c32ead029c0285c12f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:36@artist.com', 'wj79z09mmbpzfja', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wj79z09mmbpzfja', 'A fresh talent, blending Afrobeat rhythms with soulful melodies.', 'Libianca');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5fp4wqxhln12srucjsw99a9cshx982oqap5fr4ubkumflm16lh','wj79z09mmbpzfja', 'https://i.scdn.co/image/ab67616d0000b273fc342f95f117d48dbdde9735', 'People','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hgrqy865b7viwsj88zyc1h5n3qaflyxsck61wfptaevt523c7e','People','wj79z09mmbpzfja','POP','26b3oVLrRUaaybJulow9kz','https://p.scdn.co/mp3-preview/abcbc9adf10ae4901b40b80a30dc194d589c2d62?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5fp4wqxhln12srucjsw99a9cshx982oqap5fr4ubkumflm16lh', 'hgrqy865b7viwsj88zyc1h5n3qaflyxsck61wfptaevt523c7e', '0');
-- Ana Castela
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jf2l2tufzf4e7eg', 'Ana Castela', '37@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26abde7ba3cfdfb8c1900baf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:37@artist.com', 'jf2l2tufzf4e7eg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jf2l2tufzf4e7eg', 'A unique voice in the contemporary music scene.', 'Ana Castela');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u2spo2lcztzu565z3p01clba0i8xlmdbxgwofx8bvnsgb36x77','jf2l2tufzf4e7eg', NULL, 'Ana Castela Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vgmx4562lpjye6a9vd4q33nmyaxh3tfu73hxnrm9gn18860xw6','Nosso Quadro','jf2l2tufzf4e7eg','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u2spo2lcztzu565z3p01clba0i8xlmdbxgwofx8bvnsgb36x77', 'vgmx4562lpjye6a9vd4q33nmyaxh3tfu73hxnrm9gn18860xw6', '0');
-- Maria Becerra
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kdvy5o4v6al1ct1', 'Maria Becerra', '38@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb6cfa517b8f5a152d63c4ffb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:38@artist.com', 'kdvy5o4v6al1ct1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kdvy5o4v6al1ct1', 'A vibrant new voice in Latin pop, fusing catchy melodies with urban sounds.', 'Maria Becerra');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dqsda8xchvspicg1nbohfwng0k2pcjof43t5om2veptrf8cmrk','kdvy5o4v6al1ct1', NULL, 'Maria Becerra Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qy6ucisnuxaq1l5imsufpmpex44ewk4p9gd5kypjko67w75arh','CORAZN VA','kdvy5o4v6al1ct1','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dqsda8xchvspicg1nbohfwng0k2pcjof43t5om2veptrf8cmrk', 'qy6ucisnuxaq1l5imsufpmpex44ewk4p9gd5kypjko67w75arh', '0');
-- Grupo Marca Registrada
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('96ldtsx0jbxqdwd', 'Grupo Marca Registrada', '39@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8059103a66f9c25b91b375a9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:39@artist.com', '96ldtsx0jbxqdwd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('96ldtsx0jbxqdwd', 'Creating a tapestry of tunes that celebrates diversity.', 'Grupo Marca Registrada');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('scfmtes32fu8eqcjtmvlht4uryexstbobc71s9npmnr8qxr4qf','96ldtsx0jbxqdwd', 'https://i.scdn.co/image/ab67616d0000b273bae22025cf282ad72b167e79', 'Dont Stop The Magic','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7hobjdmwhs3vgnry9a96jw4elx7xnv0bp6s735qmq0s89a75r6','Di Que Si','96ldtsx0jbxqdwd','POP','0pliiCOWPN0IId8sXAqNJr','https://p.scdn.co/mp3-preview/622a816595469fdb54c42c88259f303266dc8aa7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('scfmtes32fu8eqcjtmvlht4uryexstbobc71s9npmnr8qxr4qf', '7hobjdmwhs3vgnry9a96jw4elx7xnv0bp6s735qmq0s89a75r6', '0');
-- Post Malone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1gvusppqa47mlqc', 'Post Malone', '40@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:40@artist.com', '1gvusppqa47mlqc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1gvusppqa47mlqc', 'Blurring genre lines with his unique blend of hip-hop and pop.', 'Post Malone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('eiblxvx000n7kxe2cvo0rzu5ebe7ki6r5fdbnoovr2inm6tfab','1gvusppqa47mlqc', 'https://i.scdn.co/image/ab67616d0000b2739478c87599550dd73bfa7e02', 'Hollywoods Bleeding','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('06141hl2hu8afayerhgkvjk37vmefzg1jk220zmghrrbba7fqa','Sunflower - Spider-Man: Into the Spider-Verse','1gvusppqa47mlqc','POP','0RiRZpuVRbi7oqRdSMwhQY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eiblxvx000n7kxe2cvo0rzu5ebe7ki6r5fdbnoovr2inm6tfab', '06141hl2hu8afayerhgkvjk37vmefzg1jk220zmghrrbba7fqa', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xcgo15poz8xlvgavukcr73g9tukzzxe6hbea0plexyn4v598yl','Overdrive','1gvusppqa47mlqc','POP','3t0ic4mkhvhamrKDkulB8v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eiblxvx000n7kxe2cvo0rzu5ebe7ki6r5fdbnoovr2inm6tfab', 'xcgo15poz8xlvgavukcr73g9tukzzxe6hbea0plexyn4v598yl', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c87iufqa199zusuhb9oc8zi8yhy2ojq58fxufvuiepu71gw078','Chemical','1gvusppqa47mlqc','POP','5w40ZYhbBMAlHYNDaVJIUu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eiblxvx000n7kxe2cvo0rzu5ebe7ki6r5fdbnoovr2inm6tfab', 'c87iufqa199zusuhb9oc8zi8yhy2ojq58fxufvuiepu71gw078', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0ar6hf705vkuyu6x5i537xckubw431cptytq9n4cvb2fjmmc6h','Circles','1gvusppqa47mlqc','POP','21jGcNKet2qwijlDFuPiPb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eiblxvx000n7kxe2cvo0rzu5ebe7ki6r5fdbnoovr2inm6tfab', '0ar6hf705vkuyu6x5i537xckubw431cptytq9n4cvb2fjmmc6h', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h1zwfnbsp25ui9c6up8xze8k0qeon54bzi2654supsnx7lhmxe','I Like You (A Happier Song) (with Doja Cat)','1gvusppqa47mlqc','POP','0O6u0VJ46W86TxN9wgyqDj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eiblxvx000n7kxe2cvo0rzu5ebe7ki6r5fdbnoovr2inm6tfab', 'h1zwfnbsp25ui9c6up8xze8k0qeon54bzi2654supsnx7lhmxe', '4');
-- James Blake
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nt0cj01085hn2x3', 'James Blake', '41@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb93fe5fc8fdb5a98248911a07','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:41@artist.com', 'nt0cj01085hn2x3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nt0cj01085hn2x3', 'Creating a tapestry of tunes that celebrates diversity.', 'James Blake');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('v0gx2irf95shsye43i4bp9le7gv1o8hiolo67p1kuqec5d7use','nt0cj01085hn2x3', NULL, 'James Blake Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yoou84h8w0qkqxhnjcadjepm8e2t4rjm2zhuaqcfi407la4tpb','Hummingbird (Metro Boomin & James Blake)','nt0cj01085hn2x3','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v0gx2irf95shsye43i4bp9le7gv1o8hiolo67p1kuqec5d7use', 'yoou84h8w0qkqxhnjcadjepm8e2t4rjm2zhuaqcfi407la4tpb', '0');
-- Tears For Fears
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('55pthsroovv1243', 'Tears For Fears', '42@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb42ed2cb48c231f545a5a3dad','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:42@artist.com', '55pthsroovv1243', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('55pthsroovv1243', 'Blending traditional rhythms with modern beats.', 'Tears For Fears');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('de7lt9cpmkt8s1ydyx7coc4zaesbbzpqp3d49mfkelk3fzjugk','55pthsroovv1243', 'https://i.scdn.co/image/ab67616d0000b27322463d6939fec9e17b2a6235', 'Songs From The Big Chair (Super Deluxe Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s0rgdpq4pqp1uw719tl7ncd9atawcy1cyq1vr7m9iv95xp54rf','Everybody Wants To Rule The World','55pthsroovv1243','POP','4RvWPyQ5RL0ao9LPZeSouE',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('de7lt9cpmkt8s1ydyx7coc4zaesbbzpqp3d49mfkelk3fzjugk', 's0rgdpq4pqp1uw719tl7ncd9atawcy1cyq1vr7m9iv95xp54rf', '0');
-- TAEYANG
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tmhxzggcxa95hp6', 'TAEYANG', '43@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb496189630cd3cb0c7b593fee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:43@artist.com', 'tmhxzggcxa95hp6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tmhxzggcxa95hp6', 'Delivering soul-stirring tunes that linger in the mind.', 'TAEYANG');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6iwut46rf7paqbohtsv0l9aacw9nixcvp59rzvdv2j1zcykum7','tmhxzggcxa95hp6', 'https://i.scdn.co/image/ab67616d0000b27346313223adf2b6d726388328', 'Down to Earth','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hm6ofst9zoertlpd66u7gdp0fioa1fa1xt7vqb26nqj21m8yoq','Shoong! (feat. LISA of BLACKPINK)','tmhxzggcxa95hp6','POP','5HrIcZOo1DysX53qDRlRnt',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6iwut46rf7paqbohtsv0l9aacw9nixcvp59rzvdv2j1zcykum7', 'hm6ofst9zoertlpd66u7gdp0fioa1fa1xt7vqb26nqj21m8yoq', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('omos29qm9tlw8ueux4ty98vg1tsp1r80ovk6b85xof7tfiunj6','VIBE (feat. Jimin of BTS)','tmhxzggcxa95hp6','POP','4NIe9Is7bN5JWyTeCW2ahK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6iwut46rf7paqbohtsv0l9aacw9nixcvp59rzvdv2j1zcykum7', 'omos29qm9tlw8ueux4ty98vg1tsp1r80ovk6b85xof7tfiunj6', '1');
-- RAYE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0w7907yeo05990a', 'RAYE', '44@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6338990250f5d5a447650ba9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:44@artist.com', '0w7907yeo05990a', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0w7907yeo05990a', 'A beacon of innovation in the world of sound.', 'RAYE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dsloayzs3tqwkgc2dilr60tc1cj6mu6p1l3j8huw8z50iz4dxs','0w7907yeo05990a', 'https://i.scdn.co/image/ab67616d0000b27394e5237ce925531dbb38e75f', 'My 21st Century Blues','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e18lpkshe1v2d0ycj5g7caeuwmapn97bup6fhvgiif5gops73l','Escapism.','0w7907yeo05990a','POP','5mHdCZtVyb4DcJw8799hZp','https://p.scdn.co/mp3-preview/8a8fcaf9ddf050562048d1632ddc880c9ce7c972?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dsloayzs3tqwkgc2dilr60tc1cj6mu6p1l3j8huw8z50iz4dxs', 'e18lpkshe1v2d0ycj5g7caeuwmapn97bup6fhvgiif5gops73l', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mx262a3l8ug9hmt7bsxyijfgxu8255lhxi3tvftuzvhx9y46t3','Escapism. - Sped Up','0w7907yeo05990a','POP','3XCpS4k8WqNnCpcDOSRRuz','https://p.scdn.co/mp3-preview/22be59e4d5da403513e02e90c27bc1d0965b5f1f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dsloayzs3tqwkgc2dilr60tc1cj6mu6p1l3j8huw8z50iz4dxs', 'mx262a3l8ug9hmt7bsxyijfgxu8255lhxi3tvftuzvhx9y46t3', '1');
-- Mae Stephens
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xz4vmwy6nuoo44t', 'Mae Stephens', '45@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb743f68b46b3909d5f74da093','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:45@artist.com', 'xz4vmwy6nuoo44t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xz4vmwy6nuoo44t', 'A tapestry of rhythms that echo the pulse of life.', 'Mae Stephens');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3jt68zjuofw05mic40v6zp97z30yu7kkj34o6zuxyidivryv6r','xz4vmwy6nuoo44t', 'https://i.scdn.co/image/ab67616d0000b2731fc63c898797e3dbf04ad611', 'If We Ever Broke Up','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kmarfsdo4lxukav05989g8svnzbip37itjh06gg5ju9nopzua0','If We Ever Broke Up','xz4vmwy6nuoo44t','POP','6maTPqynTmrkWIralgGaoP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3jt68zjuofw05mic40v6zp97z30yu7kkj34o6zuxyidivryv6r', 'kmarfsdo4lxukav05989g8svnzbip37itjh06gg5ju9nopzua0', '0');
-- Yuridia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xi1o1owu08n78ll', 'Yuridia', '46@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb238b537cb702308e59f709bf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:46@artist.com', 'xi1o1owu08n78ll', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xi1o1owu08n78ll', 'Weaving lyrical magic into every song.', 'Yuridia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8tgv7b3m1f9109sz885r5yuaagbr35n7v3ql497xviu9do3qur','xi1o1owu08n78ll', 'https://i.scdn.co/image/ab67616d0000b2732e9425d8413217cc2942cacf', 'Pa Luego Es Tarde','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zrfn7j5mz32i7o9tf21whvdkoleenvmlf868m6yl91u3n8lytj','Qu Ago','xi1o1owu08n78ll','POP','4H6o1bxKRGzmsE0vzo968m','https://p.scdn.co/mp3-preview/5576fde4795672bfa292bbf58adf0f9159af0be3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8tgv7b3m1f9109sz885r5yuaagbr35n7v3ql497xviu9do3qur', 'zrfn7j5mz32i7o9tf21whvdkoleenvmlf868m6yl91u3n8lytj', '0');
-- Doja Cat
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tex9dhdapqawal6', 'Doja Cat', '47@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7f6d6cac38d494e87692af99','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:47@artist.com', 'tex9dhdapqawal6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tex9dhdapqawal6', 'Creating a tapestry of tunes that celebrates diversity.', 'Doja Cat');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xt9d7cfom38n3ls980la69nxiunofppr7dwyhceeompkzy6ign','tex9dhdapqawal6', 'https://i.scdn.co/image/ab67616d0000b273be841ba4bc24340152e3a79a', 'Planet Her','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ssy11qg4djoxbhvs1l7huudebc4iokf6mir0xp512yepxfyo8y','Woman','tex9dhdapqawal6','POP','6Uj1ctrBOjOas8xZXGqKk4','https://p.scdn.co/mp3-preview/2ae0b61e45d9a5d6454a3e5ab75f8628dd89aa85?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xt9d7cfom38n3ls980la69nxiunofppr7dwyhceeompkzy6ign', 'ssy11qg4djoxbhvs1l7huudebc4iokf6mir0xp512yepxfyo8y', '0');
-- Luke Combs
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0sx6uy2c8qxnsy6', 'Luke Combs', '48@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5db6179b28f7e3654898b279','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:48@artist.com', '0sx6uy2c8qxnsy6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0sx6uy2c8qxnsy6', 'Reigniting country music with his powerful voice and relatable songs.', 'Luke Combs');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vg6cvjzl2ye7nq4oj91xturb7v4sq28fnz4uxsjgvdtvkj6rag','0sx6uy2c8qxnsy6', 'https://i.scdn.co/image/ab67616d0000b273ca650d3a95022e0490434ba1', 'Gettin Old','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i5f3b91uprz80jkgxz0uiptlz9prz1r01g5kkb0s8q52meekns','Fast Car','0sx6uy2c8qxnsy6','POP','1Lo0QY9cvc8sUB2vnIOxDT','https://p.scdn.co/mp3-preview/1dc0426c95058783e0fe1d70c41583ca98317108?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vg6cvjzl2ye7nq4oj91xturb7v4sq28fnz4uxsjgvdtvkj6rag', 'i5f3b91uprz80jkgxz0uiptlz9prz1r01g5kkb0s8q52meekns', '0');
-- Peso Pluma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zaons9mpantb8aa', 'Peso Pluma', '49@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:49@artist.com', 'zaons9mpantb8aa', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zaons9mpantb8aa', 'Infusing music with energetic beats and captivating lyrics.', 'Peso Pluma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0c38fcak3j17o0xint7blnanmdkt8oxzajf8gvlnb871mcknez','zaons9mpantb8aa', NULL, 'GÉNESIS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qxfmuumvoamvhd3fvpra0fogjk17xj23aes2zi062b32h8wojh','La Bebe - Remix','zaons9mpantb8aa','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0c38fcak3j17o0xint7blnanmdkt8oxzajf8gvlnb871mcknez', 'qxfmuumvoamvhd3fvpra0fogjk17xj23aes2zi062b32h8wojh', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5x3do6anl5teefe5z6zii3z2tgqzv6bj7a5gbfbxjue1c78ew8','TULUM','zaons9mpantb8aa','POP','7bPp2NmpmyhLJ7zWazAXMu','https://p.scdn.co/mp3-preview/164468e67b8da8053036c68533ffa473ab680c51?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0c38fcak3j17o0xint7blnanmdkt8oxzajf8gvlnb871mcknez', '5x3do6anl5teefe5z6zii3z2tgqzv6bj7a5gbfbxjue1c78ew8', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gd9ktxsgfwom8627h1rl0dsrk2dc8xiloa3v676dqg285fzhin','Por las Noches','zaons9mpantb8aa','POP','2VzCjpKvPB1l1tqLndtAQa','https://p.scdn.co/mp3-preview/ba2f667c373e2d12343ac00b162886caca060c93?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0c38fcak3j17o0xint7blnanmdkt8oxzajf8gvlnb871mcknez', 'gd9ktxsgfwom8627h1rl0dsrk2dc8xiloa3v676dqg285fzhin', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mzm2v92e5p3mth3qhnv60jjabjdonvaz0xq6p8m8l9zbysfceg','Bye','zaons9mpantb8aa','POP','6n2P81rPk2RTzwnNNgFOdb','https://p.scdn.co/mp3-preview/94ef6a9f37e088fff4b37e098a46561e74dab95b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0c38fcak3j17o0xint7blnanmdkt8oxzajf8gvlnb871mcknez', 'mzm2v92e5p3mth3qhnv60jjabjdonvaz0xq6p8m8l9zbysfceg', '3');
-- Sog
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0yhtcc7o0ky3zaf', 'Sog', '50@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe898d69306ccb5bc978ded3a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:50@artist.com', '0yhtcc7o0ky3zaf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0yhtcc7o0ky3zaf', 'Harnessing the power of melody to tell compelling stories.', 'Sog');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fv398n1ucvgufsl0gz3ay0cs3ch4thv1mr9pkjg7bv3v1jxymf','0yhtcc7o0ky3zaf', NULL, 'Sog Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wlw0bqxyhkgkufz8b1ukkc27abtmj0qt3t7dts9s24uj6ars9t','QUEMA','0yhtcc7o0ky3zaf','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fv398n1ucvgufsl0gz3ay0cs3ch4thv1mr9pkjg7bv3v1jxymf', 'wlw0bqxyhkgkufz8b1ukkc27abtmj0qt3t7dts9s24uj6ars9t', '0');
-- TOMORROW X TOGETHER
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('asw5hv1r1hey4ez', 'TOMORROW X TOGETHER', '51@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8b446e5bd3820ac772155b31','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:51@artist.com', 'asw5hv1r1hey4ez', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('asw5hv1r1hey4ez', 'A voice that echoes the sentiments of a generation.', 'TOMORROW X TOGETHER');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('es9kc9z1td4zfpxvzyatp47ccvnwqk6u6oa1z2rym4kyrz3t85','asw5hv1r1hey4ez', 'https://i.scdn.co/image/ab67616d0000b2733bb056e3160b85ee86c1194d', 'The Name Chapter: TEMPTATION','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kwid3qqfnfbcq1npa4w9muyd194nabricybzgu38alzwhuhv93','Sugar Rush Ride','asw5hv1r1hey4ez','POP','0rhI6gvOeCKA502RdJAbfs','https://p.scdn.co/mp3-preview/691f502777012a09541b5265cfddaa4401470759?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('es9kc9z1td4zfpxvzyatp47ccvnwqk6u6oa1z2rym4kyrz3t85', 'kwid3qqfnfbcq1npa4w9muyd194nabricybzgu38alzwhuhv93', '0');
-- Latto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7jgxmhic2rc8xcw', 'Latto', '52@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb149677e9b0d9ef7b229499d9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:52@artist.com', '7jgxmhic2rc8xcw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7jgxmhic2rc8xcw', 'A bold and dynamic rapper, making waves with her fiery lyrics.', 'Latto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x953ma426w9e44q2s3kreciwxp35pqm5dcduzk1a9fieef7wib','7jgxmhic2rc8xcw', NULL, 'Latto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xq8w2wtxqgqigxzyde6b8riv3z5ljtkms97d9w90gvggr8lwsb','Seven (feat. Latto) (Explicit Ver.)','7jgxmhic2rc8xcw','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x953ma426w9e44q2s3kreciwxp35pqm5dcduzk1a9fieef7wib', 'xq8w2wtxqgqigxzyde6b8riv3z5ljtkms97d9w90gvggr8lwsb', '0');
-- IU
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6ky8t23e2r1fd4z', 'IU', '53@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb191d43dca6f2f5a126e43e4b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:53@artist.com', '6ky8t23e2r1fd4z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6ky8t23e2r1fd4z', 'Striking chords that resonate across generations.', 'IU');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('30zdubpqgolafstovyfs1lh9fagtr0r3hesvp9tjxchjyfzk17','6ky8t23e2r1fd4z', NULL, 'IU Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rufyi8uoygh4ovw4kmxmxtqx4czwfhwezcdsy91zeth6hoy2jq','People Pt.2 (feat. IU)','6ky8t23e2r1fd4z','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('30zdubpqgolafstovyfs1lh9fagtr0r3hesvp9tjxchjyfzk17', 'rufyi8uoygh4ovw4kmxmxtqx4czwfhwezcdsy91zeth6hoy2jq', '0');
-- Alec Benjamin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4sfqpp8kenvvyh6', 'Alec Benjamin', '54@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6cab9e007b77913d63f12835','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:54@artist.com', '4sfqpp8kenvvyh6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4sfqpp8kenvvyh6', 'A journey through the spectrum of sound in every album.', 'Alec Benjamin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5uvygsnc6bsk9k3daq8rz5vi1ruae56nly0rvtg18xljw277i3','4sfqpp8kenvvyh6', 'https://i.scdn.co/image/ab67616d0000b273459d675aa0b6f3b211357370', 'Narrated For You','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('um5yls7yde292mqmm4cd8jovg5cljce2jlfcbziimis0vqpmp6','Let Me Down Slowly','4sfqpp8kenvvyh6','POP','2qxmye6gAegTMjLKEBoR3d','https://p.scdn.co/mp3-preview/19007111a4e21096bcefef77842d7179f0cdf12a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5uvygsnc6bsk9k3daq8rz5vi1ruae56nly0rvtg18xljw277i3', 'um5yls7yde292mqmm4cd8jovg5cljce2jlfcbziimis0vqpmp6', '0');
-- Chino Pacas
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('eq3mxvived2s3w0', 'Chino Pacas', '55@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8ff524b416384fe673ebf52e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:55@artist.com', 'eq3mxvived2s3w0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('eq3mxvived2s3w0', 'The heartbeat of a new generation of music lovers.', 'Chino Pacas');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pl7jjmlorcjoe7h7ophg2koppxibq49r3wlb05ijqp7kppnlxj','eq3mxvived2s3w0', 'https://i.scdn.co/image/ab67616d0000b2736a6ab689151163a1e9f60f36', 'El Gordo Trae El Mando','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vscge1xgsrs7jp9nqstc9e3sbq4mlwr5brq4bvz8ms6vuadutj','El Gordo Trae El Mando','eq3mxvived2s3w0','POP','3kf0WdFOalKWBkCCLJo4mA','https://p.scdn.co/mp3-preview/b7989992ce6651eea980627ad17b1f9a2fa2a224?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pl7jjmlorcjoe7h7ophg2koppxibq49r3wlb05ijqp7kppnlxj', 'vscge1xgsrs7jp9nqstc9e3sbq4mlwr5brq4bvz8ms6vuadutj', '0');
-- King
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gi9get93txaoslw', 'King', '56@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5c0b2129a88c7d6ed0704556','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:56@artist.com', 'gi9get93txaoslw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gi9get93txaoslw', 'Harnessing the power of melody to tell compelling stories.', 'King');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ub5oqqpbsaauikzfplqg15qphmtm08z2ckafc5rnaagz49jhh9','gi9get93txaoslw', 'https://i.scdn.co/image/ab67616d0000b27337f65266754703fd20d29854', 'Champagne Talk','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('by2g4vi12191csxyd6w25qjhbdk5ncvu3wdh1yswloc5doltzk','Maan Meri Jaan','gi9get93txaoslw','POP','1418IuVKQPTYqt7QNJ9RXN','https://p.scdn.co/mp3-preview/cf886ec5f6a46c234bcfdd043ab5db03db0015b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ub5oqqpbsaauikzfplqg15qphmtm08z2ckafc5rnaagz49jhh9', 'by2g4vi12191csxyd6w25qjhbdk5ncvu3wdh1yswloc5doltzk', '0');
-- Harry Styles
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gw0at8qlsy5pizo', 'Harry Styles', '57@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf7db7c8ede90a019c54590bb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:57@artist.com', 'gw0at8qlsy5pizo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gw0at8qlsy5pizo', 'Defining modern pop-rock with his charismatic presence and bold choices.', 'Harry Styles');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('q5j5xt92pqx28n0mlm8gma125zxjclphlvdfqkan6s9oq4rlrk','gw0at8qlsy5pizo', 'https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0', 'Harrys House','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2crhnrypoi0jqna6lz0un30oq0qqrl1cvr1sezzrd6863qx08u','As It Was','gw0at8qlsy5pizo','POP','4Dvkj6JhhA12EX05fT7y2e','https://p.scdn.co/mp3-preview/c43dd07043b29e800c1a65b3a0102861fa3cf418?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q5j5xt92pqx28n0mlm8gma125zxjclphlvdfqkan6s9oq4rlrk', '2crhnrypoi0jqna6lz0un30oq0qqrl1cvr1sezzrd6863qx08u', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u9m60l9hlpwvub6k1sml43sflk93op0fvx35ghpp2avh4kg4bl','Watermelon Sugar','gw0at8qlsy5pizo','POP','6UelLqGlWMcVH1E5c4H7lY','https://p.scdn.co/mp3-preview/824cd58da2e9a15eeaaa6746becc09093547a09b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q5j5xt92pqx28n0mlm8gma125zxjclphlvdfqkan6s9oq4rlrk', 'u9m60l9hlpwvub6k1sml43sflk93op0fvx35ghpp2avh4kg4bl', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d0m61qvsqgq6fztpqz9ae3rvlml284lx2r5dbgafpshp26td2q','Late Night Talking','gw0at8qlsy5pizo','POP','1qEmFfgcLObUfQm0j1W2CK','https://p.scdn.co/mp3-preview/50f056e2ab4a1bef762661dbbf2da751beeffe39?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q5j5xt92pqx28n0mlm8gma125zxjclphlvdfqkan6s9oq4rlrk', 'd0m61qvsqgq6fztpqz9ae3rvlml284lx2r5dbgafpshp26td2q', '2');
-- Tyler The Creator
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tslz1o6i4a3v5p0', 'Tyler The Creator', '58@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:58@artist.com', 'tslz1o6i4a3v5p0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tslz1o6i4a3v5p0', 'Pushing the boundaries of music with unique style and bold lyrics.', 'Tyler The Creator');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4uhfez7jpcy75t4t36xl1jtp4nhwvfmd08e250m9zi40cculnz','tslz1o6i4a3v5p0', 'https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3', 'Flower Boy','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zokolx82djcj4n9k18b3jdffv2hwbrchrmr4aq80njuk6y2i4l','See You Again','tslz1o6i4a3v5p0','POP','7KA4W4McWYRpgf0fWsJZWB','https://p.scdn.co/mp3-preview/c703198293891e3b276800ea6b187cf7951d3d7d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4uhfez7jpcy75t4t36xl1jtp4nhwvfmd08e250m9zi40cculnz', 'zokolx82djcj4n9k18b3jdffv2hwbrchrmr4aq80njuk6y2i4l', '0');
-- Jung Kook
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3rnmr259bkw65yk', 'Jung Kook', '59@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:59@artist.com', '3rnmr259bkw65yk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3rnmr259bkw65yk', 'A member of BTS, captivating fans with his powerful vocals and dynamic performances.', 'Jung Kook');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6ne7p1r1mb3x97kng6n3rn0jtlaqkffhewc70u8rrc1kzko3a3','3rnmr259bkw65yk', 'https://i.scdn.co/image/ab67616d0000b273a7f42c375578df426b37638d', 'Still With You','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2n5jznjb67rw5xoyt1l8cl5k6y9tl8ivdk2np99icb5zatz1uy','Still With You','3rnmr259bkw65yk','POP','0eFMbKCRw8KByXyWBw8WO7','https://p.scdn.co/mp3-preview/af2a740e10a6956dedd7e7f66fd65d7166e9187f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6ne7p1r1mb3x97kng6n3rn0jtlaqkffhewc70u8rrc1kzko3a3', '2n5jznjb67rw5xoyt1l8cl5k6y9tl8ivdk2np99icb5zatz1uy', '0');
-- Chris Brown
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e8c7glchg2ru3hg', 'Chris Brown', '60@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba48397e590a1c70e2cda7728','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:60@artist.com', 'e8c7glchg2ru3hg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e8c7glchg2ru3hg', 'Where words fail, my music speaks.', 'Chris Brown');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2nszzx0qx45mngd9d6vl70o9yi5lko3frsh1axlg7xkj49jllp','e8c7glchg2ru3hg', 'https://i.scdn.co/image/ab67616d0000b2739a494f7d8909a6cc4ceb74ac', 'Indigo (Extended)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uw3n05g3bhtxpozo6e37vt8q6n45okfoohoaf8pzcnaz6b4twq','Under The Influence','e8c7glchg2ru3hg','POP','5IgjP7X4th6nMNDh4akUHb','https://p.scdn.co/mp3-preview/52295df71df20e33e1510e3983975cd59f6664a4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2nszzx0qx45mngd9d6vl70o9yi5lko3frsh1axlg7xkj49jllp', 'uw3n05g3bhtxpozo6e37vt8q6n45okfoohoaf8pzcnaz6b4twq', '0');
-- Kelly Clarkson
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hepfn9zo4upmwqr', 'Kelly Clarkson', '61@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb305a7cc6760b53a67aaae19d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:61@artist.com', 'hepfn9zo4upmwqr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hepfn9zo4upmwqr', 'Where words fail, my music speaks.', 'Kelly Clarkson');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hv39oibj4dq33og8snkogx9tkt39l04np0fsruqahvhu07xbz9','hepfn9zo4upmwqr', 'https://i.scdn.co/image/ab67616d0000b273f54a315f1d2445791fe601a7', 'Wrapped In Red','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tgtsn5j4kk99nsxset49vrixdy4x6hdjjczbstgabgkuw9kx42','Underneath the Tree','hepfn9zo4upmwqr','POP','3YZE5qDV7u1ZD1gZc47ZeR','https://p.scdn.co/mp3-preview/9d6040eda6551e1746409ca2c8cf04d95475019a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hv39oibj4dq33og8snkogx9tkt39l04np0fsruqahvhu07xbz9', 'tgtsn5j4kk99nsxset49vrixdy4x6hdjjczbstgabgkuw9kx42', '0');
-- Ozuna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w9aw4dr1cmzyu7y', 'Ozuna', '62@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc80f303b208a480f52e8180b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:62@artist.com', 'w9aw4dr1cmzyu7y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w9aw4dr1cmzyu7y', 'Dominating reggaeton and Latin trap with catchy tunes and charismatic energy.', 'Ozuna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ki99f1tw62beuaqlzcqz5urpezr6e7cv0t6uxehnmd9orrc6no','w9aw4dr1cmzyu7y', 'https://i.scdn.co/image/ab67616d0000b273125624f2e04f5a1ccb0dfb45', 'OzuTochi','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lb0ngat3swayyvb6ldni65jl8olqwjawb0qaooo1x08qkljfkp','Hey Mor','w9aw4dr1cmzyu7y','POP','1zsPaEkglFvxjAhrM8yhpr','https://p.scdn.co/mp3-preview/cd2d2242b748408da15c2b66f47d54b3f0793ae0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ki99f1tw62beuaqlzcqz5urpezr6e7cv0t6uxehnmd9orrc6no', 'lb0ngat3swayyvb6ldni65jl8olqwjawb0qaooo1x08qkljfkp', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t0f24m3noercyiv49no6ivbdfand8t9s5ikjaihrgtam8zu7nd','Monoton','w9aw4dr1cmzyu7y','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ki99f1tw62beuaqlzcqz5urpezr6e7cv0t6uxehnmd9orrc6no', 't0f24m3noercyiv49no6ivbdfand8t9s5ikjaihrgtam8zu7nd', '1');
-- ROSAL
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4milsnezr1uknzg', 'ROSAL', '63@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd7bb678bef6d2f26110cae49','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:63@artist.com', '4milsnezr1uknzg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4milsnezr1uknzg', 'A confluence of cultural beats and contemporary tunes.', 'ROSAL');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('24aidelgnissoovrb7emu1mvlbcnnkzde0ux64vqjazkq8wppt','4milsnezr1uknzg', 'https://i.scdn.co/image/ab67616d0000b273efc0ef9dd996312ebaf0bf52', 'MOTOMAMI +','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ggtvj87g61tfkj4ztvdznjbc9wjtxnd7lco67j8cxxe4pfqncj','DESPECH','4milsnezr1uknzg','POP','53tfEupEzQRtVFOeZvk7xq','https://p.scdn.co/mp3-preview/304868e078d8f2c3209977997c47542181096b61?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('24aidelgnissoovrb7emu1mvlbcnnkzde0ux64vqjazkq8wppt', 'ggtvj87g61tfkj4ztvdznjbc9wjtxnd7lco67j8cxxe4pfqncj', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3sgmgbserjlxltkrxjwnt1j38heg8jt45br3pcombbhzwrft6e','LLYLM','4milsnezr1uknzg','POP','2SiAcexM2p1yX6joESbehd','https://p.scdn.co/mp3-preview/6f41063b2e36fb31fbd08c39b6c56012e239365b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('24aidelgnissoovrb7emu1mvlbcnnkzde0ux64vqjazkq8wppt', '3sgmgbserjlxltkrxjwnt1j38heg8jt45br3pcombbhzwrft6e', '1');
-- Mariah Carey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8mxxsh1anh3tmsq', 'Mariah Carey', '64@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21b66418f7f3b86967f85bce','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:64@artist.com', '8mxxsh1anh3tmsq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8mxxsh1anh3tmsq', 'An odyssey of sound that defies conventions.', 'Mariah Carey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g4971vx1gzmf494atruqu236lpac47igts78khijfk3pmeyytd','8mxxsh1anh3tmsq', 'https://i.scdn.co/image/ab67616d0000b2734246e3158421f5abb75abc4f', 'Merry Christmas','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3l06q0nwd7ycbv0vpsle571bkg2ljkl6zvakf7u99rq72bz04w','All I Want for Christmas Is You','8mxxsh1anh3tmsq','POP','0bYg9bo50gSsH3LtXe2SQn','https://p.scdn.co/mp3-preview/6b1557cd25d543940a3decd85a7bf2bc136c51f8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g4971vx1gzmf494atruqu236lpac47igts78khijfk3pmeyytd', '3l06q0nwd7ycbv0vpsle571bkg2ljkl6zvakf7u99rq72bz04w', '0');
-- Kaifi Khalil
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x2t12qw26bjjfiu', 'Kaifi Khalil', '65@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8b3d777345ecd2f25f408586','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:65@artist.com', 'x2t12qw26bjjfiu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x2t12qw26bjjfiu', 'Exploring the depths of sound and rhythm.', 'Kaifi Khalil');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wzfhc04bbctm4o4jcqczfufpyhf2bp2cdgcu4hmf00o03xvvo2','x2t12qw26bjjfiu', 'https://i.scdn.co/image/ab67616d0000b2734697d4ee22b3f63c17a3b9ec', 'Kahani Suno 2.0','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tteq8j2c3b00hlqs02sz0t4ntnjx6pfrk20s15nsxcohsitckx','Kahani Suno 2.0','x2t12qw26bjjfiu','POP','4VsP4Dm8gsibRxB5I2hEkw','https://p.scdn.co/mp3-preview/2c644e9345d1a0ab97e4541d26b6b8ccb2c889f9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wzfhc04bbctm4o4jcqczfufpyhf2bp2cdgcu4hmf00o03xvvo2', 'tteq8j2c3b00hlqs02sz0t4ntnjx6pfrk20s15nsxcohsitckx', '0');
-- dennis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6cqsaed6pcxmqwd', 'dennis', '66@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8a1ec9781a1542458b3b961b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:66@artist.com', '6cqsaed6pcxmqwd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6cqsaed6pcxmqwd', 'Blending traditional rhythms with modern beats.', 'dennis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('09edxjjfhs5r05wnbm5rw12x9117k9j0jcigftgb036ctuzdra','6cqsaed6pcxmqwd', 'https://i.scdn.co/image/ab67616d0000b273ddfc406de0d7dbc2e339f016', 'Tá OK (Remix)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2dbgt5j0ob17emkn2pv7i4o2bhgkqznjp61vfx77epoe0grycb','T','6cqsaed6pcxmqwd','POP','35FW5OEe4p38LdjK1KqT2X','https://p.scdn.co/mp3-preview/eaa522f48564e43e33e00c011aef0489526d1072?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('09edxjjfhs5r05wnbm5rw12x9117k9j0jcigftgb036ctuzdra', '2dbgt5j0ob17emkn2pv7i4o2bhgkqznjp61vfx77epoe0grycb', '0');
-- Sachin-Jigar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rd3sp7ocoywln81', 'Sachin-Jigar', '67@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba038d7d87f8577bbb9686bd3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:67@artist.com', 'rd3sp7ocoywln81', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rd3sp7ocoywln81', 'Uniting fans around the globe with universal rhythms.', 'Sachin-Jigar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fc8piif5zw81003ep6neai09mip9m9wci68qa22xbx79dptpiw','rd3sp7ocoywln81', NULL, 'Sachin-Jigar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('topk7datjytarwnl6pgxg6u3hab0qzlx78l9wnubo2x0lhwfj8','Tere Vaaste (From "Zara Hatke Zara Bachke")','rd3sp7ocoywln81','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fc8piif5zw81003ep6neai09mip9m9wci68qa22xbx79dptpiw', 'topk7datjytarwnl6pgxg6u3hab0qzlx78l9wnubo2x0lhwfj8', '0');
-- Lewis Capaldi
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h2ry9w0hqkixsl7', 'Lewis Capaldi', '68@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebea7538654040e553a7b0fc28','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:68@artist.com', 'h2ry9w0hqkixsl7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h2ry9w0hqkixsl7', 'Delivering emotional ballads with his powerful, soul-stirring voice.', 'Lewis Capaldi');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2hy4nzac6ly4j7eel7t5pt2uxtnx2bw6nkb8mtcjuuq8qrpfz1','h2ry9w0hqkixsl7', 'https://i.scdn.co/image/ab67616d0000b273fc2101e6889d6ce9025f85f2', 'Divinely Uninspired To A Hellish Extent','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0h013kyict2ti4sk41r1y39fxn933o4sobl910h42tflqn3do0','Someone You Loved','h2ry9w0hqkixsl7','POP','7qEHsqek33rTcFNT9PFqLf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2hy4nzac6ly4j7eel7t5pt2uxtnx2bw6nkb8mtcjuuq8qrpfz1', '0h013kyict2ti4sk41r1y39fxn933o4sobl910h42tflqn3do0', '0');
-- BTS
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4pawlflm3w8onn6', 'BTS', '69@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd642648235ebf3460d2d1f6a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:69@artist.com', '4pawlflm3w8onn6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4pawlflm3w8onn6', 'A global phenomenon, setting new standards in K-pop with their music and performances.', 'BTS');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xx0nu08pm9roi5kvgdj45p6hf7nq9pzc1y3nwsx4t5y8fsisoc','4pawlflm3w8onn6', 'https://i.scdn.co/image/ab67616d0000b2738a701e76e8845928f6cd81c8', 'Take Two','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('juuhyjgd2llq12vyj8kfv8g7hpu116p70k5cqgnzqmvxpx6ix0','Take Two','4pawlflm3w8onn6','POP','5IAESfJjmOYu7cHyX557kz','https://p.scdn.co/mp3-preview/ef43da30a06fcad16898e9fff1cadd0ccf953fc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xx0nu08pm9roi5kvgdj45p6hf7nq9pzc1y3nwsx4t5y8fsisoc', 'juuhyjgd2llq12vyj8kfv8g7hpu116p70k5cqgnzqmvxpx6ix0', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wtbckxokywodsk04dj6njxivqdb6n22p17jrf8qj79ov2r9jzi','Dreamers [Music from the FIFA World Cup Qatar 2022 Official Soundtrack]','4pawlflm3w8onn6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xx0nu08pm9roi5kvgdj45p6hf7nq9pzc1y3nwsx4t5y8fsisoc', 'wtbckxokywodsk04dj6njxivqdb6n22p17jrf8qj79ov2r9jzi', '1');
-- Sia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jueha8e6f793ffk', 'Sia', '70@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb25a749000611559f1719cc5f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:70@artist.com', 'jueha8e6f793ffk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jueha8e6f793ffk', 'Blending genres for a fresh musical experience.', 'Sia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mq4yenvzhhj7f81xp6lyntnznkdfuobolzrxl6w3fug2hdx6ie','jueha8e6f793ffk', 'https://i.scdn.co/image/ab67616d0000b273754b2fddebe7039fdb912837', 'This Is Acting (Deluxe Version)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zbqk6d6sdxeb5qvpikwp80sztm7lfrwk0e8d9kxvk2blxwzjhk','Unstoppable','jueha8e6f793ffk','POP','1yvMUkIOTeUNtNWlWRgANS','https://p.scdn.co/mp3-preview/99a07d00531c0053f55a46e94ed92b1560396754?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mq4yenvzhhj7f81xp6lyntnznkdfuobolzrxl6w3fug2hdx6ie', 'zbqk6d6sdxeb5qvpikwp80sztm7lfrwk0e8d9kxvk2blxwzjhk', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h1cv8km2p6vc2ori4wkmuugnuxmp2lwl6r6iqwqt38zlzexzsm','Snowman','jueha8e6f793ffk','POP','7uoFMmxln0GPXQ0AcCBXRq','https://p.scdn.co/mp3-preview/a936030efc27a4fc52d8c42b20d03ca4cab30836?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mq4yenvzhhj7f81xp6lyntnznkdfuobolzrxl6w3fug2hdx6ie', 'h1cv8km2p6vc2ori4wkmuugnuxmp2lwl6r6iqwqt38zlzexzsm', '1');
-- Skrillex
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3zo76k350lr6bz5', 'Skrillex', '71@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb61f92702ca14484aa263a931','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:71@artist.com', '3zo76k350lr6bz5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3zo76k350lr6bz5', 'Where words fail, my music speaks.', 'Skrillex');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vcq5mdcpmpdt9ph5i43dom7zs67h16xipwefs5t3mrpceg8ogm','3zo76k350lr6bz5', 'https://i.scdn.co/image/ab67616d0000b2736382f06498259682f91cf981', 'Quest For Fire','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q7walm29a9esfqm8xg8exw8iupvh52gttwgyf15fjgj0n9hjky','Rumble','3zo76k350lr6bz5','POP','74fmYjFwt9CqEFAh8ybeBD','https://p.scdn.co/mp3-preview/eb79af9f809883de0632f02388ec354478612754?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vcq5mdcpmpdt9ph5i43dom7zs67h16xipwefs5t3mrpceg8ogm', 'q7walm29a9esfqm8xg8exw8iupvh52gttwgyf15fjgj0n9hjky', '0');
-- Marshmello
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bncy9aukp2e4kuz', 'Marshmello', '72@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebabd3e69b432d6187cf4e28c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:72@artist.com', 'bncy9aukp2e4kuz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bncy9aukp2e4kuz', 'An electronic music maestro known for his infectious beats.', 'Marshmello');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mr3tx6ss57tsfgvj6zsnbr7zrwqkccagp0fs94bkqmjz0kedcw','bncy9aukp2e4kuz', 'https://i.scdn.co/image/ab67616d0000b273f404676577626a87d92cf33f', 'El Merengue','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1ph5nykbaewhttzojtpxvilkzcru34x3ncohpursy950u4tt1y','El Merengue','bncy9aukp2e4kuz','POP','51FvjPEGKq2zByeeEQ43V9','https://p.scdn.co/mp3-preview/a933b6e1d6a47e591c13192f2b5e58739d3d5a06?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mr3tx6ss57tsfgvj6zsnbr7zrwqkccagp0fs94bkqmjz0kedcw', '1ph5nykbaewhttzojtpxvilkzcru34x3ncohpursy950u4tt1y', '0');
-- Rihanna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ma2p4lmt9v5vbcg', 'Rihanna', '73@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb99e4fca7c0b7cb166d915789','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:73@artist.com', 'ma2p4lmt9v5vbcg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ma2p4lmt9v5vbcg', 'Igniting the stage with electrifying performances.', 'Rihanna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3x93l2165pf96y95unvu4ebe1tkfem7z91evsohx9zcj565f6n','ma2p4lmt9v5vbcg', 'https://i.scdn.co/image/ab67616d0000b273bef074de9ca825bddaeb9f46', 'Talk That Talk','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d65xwfubtad1tlibnhqiw2urmbjxpucplr5xzdwvf7vz7fct1k','We Found Love','ma2p4lmt9v5vbcg','POP','6qn9YLKt13AGvpq9jfO8py',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3x93l2165pf96y95unvu4ebe1tkfem7z91evsohx9zcj565f6n', 'd65xwfubtad1tlibnhqiw2urmbjxpucplr5xzdwvf7vz7fct1k', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rhagt0m3kpmochx0kbgs6o3j6v8p1qhc0a5ng3cw8cfab0x15l','Lift Me Up - From Black Panther: Wakanda Forever - Music From and Inspired By','ma2p4lmt9v5vbcg','POP','35ovElsgyAtQwYPYnZJECg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3x93l2165pf96y95unvu4ebe1tkfem7z91evsohx9zcj565f6n', 'rhagt0m3kpmochx0kbgs6o3j6v8p1qhc0a5ng3cw8cfab0x15l', '1');
-- Treyce
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wwpjf9he39mhktm', 'Treyce', '74@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7b48fa6e2c8280e205c5ea7b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:74@artist.com', 'wwpjf9he39mhktm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wwpjf9he39mhktm', 'Crafting soundscapes that transport listeners to another world.', 'Treyce');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qlr2yhcfkw6wxqf97uu1pvf6gmisc390a4ns3nqlnodu6mujbm','wwpjf9he39mhktm', NULL, 'Treyce Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l580c2c7009q1v1dss7891otwujuzrzktibcny0gs7xc5a2i0y','Lovezinho','wwpjf9he39mhktm','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qlr2yhcfkw6wxqf97uu1pvf6gmisc390a4ns3nqlnodu6mujbm', 'l580c2c7009q1v1dss7891otwujuzrzktibcny0gs7xc5a2i0y', '0');
-- Coi Leray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5eh3h9loklbhj94', 'Coi Leray', '75@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:75@artist.com', '5eh3h9loklbhj94', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5eh3h9loklbhj94', 'The architect of aural landscapes that inspire and captivate.', 'Coi Leray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4q0s9t8tmkzki7ols8rl3axezvpgrc6r7oqie9786wk7hc0jaa','5eh3h9loklbhj94', 'https://i.scdn.co/image/ab67616d0000b2735626453d29a0124dea22fb1b', 'Players','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rpj4pj9vrt95w7j8wub2ow0wrw5gn80g57q3g2e7uvkjwv9azs','Players','5eh3h9loklbhj94','POP','6UN73IYd0hZxLi8wFPMQij',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4q0s9t8tmkzki7ols8rl3axezvpgrc6r7oqie9786wk7hc0jaa', 'rpj4pj9vrt95w7j8wub2ow0wrw5gn80g57q3g2e7uvkjwv9azs', '0');
-- Loreen
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4dlivwajd8zuci7', 'Loreen', '76@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3ca2710f45c2993c415a1c5e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:76@artist.com', '4dlivwajd8zuci7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4dlivwajd8zuci7', 'A sonic adventurer, always seeking new horizons in music.', 'Loreen');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mha8kpz408u0c7paedkzjolmerey8fakt95scoy28a5qhf6pgg','4dlivwajd8zuci7', 'https://i.scdn.co/image/ab67616d0000b2732b0ba87db609976eee193bd6', 'Tattoo','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1e95ppkusix7z3uyagsolygb9h0cy2ycvpohjhio913ivy0md6','Tattoo','4dlivwajd8zuci7','POP','1DmW5Ep6ywYwxc2HMT5BG6',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mha8kpz408u0c7paedkzjolmerey8fakt95scoy28a5qhf6pgg', '1e95ppkusix7z3uyagsolygb9h0cy2ycvpohjhio913ivy0md6', '0');
-- Chencho Corleone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('my7ookwmm0w8jc9', 'Chencho Corleone', '77@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2e862710857d2b3e1b5fb4f4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:77@artist.com', 'my7ookwmm0w8jc9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('my7ookwmm0w8jc9', 'A dynamic presence in reggaeton, known for his catchy beats and vibrant performances.', 'Chencho Corleone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jcdi1woc9ygz5kcarln885ik4l67nn4fc8z3xue6tipy2z977g','my7ookwmm0w8jc9', NULL, 'Chencho Corleone Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7cav3nkannhofay5nkbej0bmysganw2gx5u52i84uqk8oxcwj1','Me Porto Bonito','my7ookwmm0w8jc9','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jcdi1woc9ygz5kcarln885ik4l67nn4fc8z3xue6tipy2z977g', '7cav3nkannhofay5nkbej0bmysganw2gx5u52i84uqk8oxcwj1', '0');
-- Swae Lee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9qbvgwnbmdcdxsb', 'Swae Lee', '78@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:78@artist.com', '9qbvgwnbmdcdxsb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9qbvgwnbmdcdxsb', 'Music is my canvas, and notes are my paint.', 'Swae Lee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pgs9t82pzitdfwe2cu6mpzoli2osieyvihvfpbcpefjgs2vdbz','9qbvgwnbmdcdxsb', NULL, 'Swae Lee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('98ye7m1yu62jos2hxtxm6eufkncgcqeo6go9kyifcznmrhxu2w','Calling (Spider-Man: Across the Spider-Verse) (Metro Boomin & Swae Lee, NAV, feat. A Boogie Wit da Hoodie)','9qbvgwnbmdcdxsb','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pgs9t82pzitdfwe2cu6mpzoli2osieyvihvfpbcpefjgs2vdbz', '98ye7m1yu62jos2hxtxm6eufkncgcqeo6go9kyifcznmrhxu2w', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d1cps508a6hst36nb7atb98jm6xk77jv3imgtwpicxuezn5v43','Annihilate (Spider-Man: Across the Spider-Verse) (Metro Boomin & Swae Lee, Lil Wayne, Offset)','9qbvgwnbmdcdxsb','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pgs9t82pzitdfwe2cu6mpzoli2osieyvihvfpbcpefjgs2vdbz', 'd1cps508a6hst36nb7atb98jm6xk77jv3imgtwpicxuezn5v43', '1');
-- IVE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('l26js5zblwhdqy2', 'IVE', '79@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0e46f140189de1eba9ab6230','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:79@artist.com', 'l26js5zblwhdqy2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('l26js5zblwhdqy2', 'The heartbeat of a new generation of music lovers.', 'IVE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('z6hp0jdgx860osehwzjfdbzr464bq2d7afowdwi7o3qjvngnk8','l26js5zblwhdqy2', 'https://i.scdn.co/image/ab67616d0000b27325ef3cec1eceefd4db2f91c8', 'Ive IVE','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3cmddexm2jyd4m7zxpya6k9wzhv9k9g37pp7jjr6gef09ega72','I AM','l26js5zblwhdqy2','POP','70t7Q6AYG6ZgTYmJWcnkUM','https://p.scdn.co/mp3-preview/8d1fa5354093e98745ccef77ecb60fac3c9d38d0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z6hp0jdgx860osehwzjfdbzr464bq2d7afowdwi7o3qjvngnk8', '3cmddexm2jyd4m7zxpya6k9wzhv9k9g37pp7jjr6gef09ega72', '0');
-- Baby Rasta
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('063lc4daush398r', 'Baby Rasta', '80@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb18f9c5cb23e65bd55af69f24','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:80@artist.com', '063lc4daush398r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('063lc4daush398r', 'Harnessing the power of melody to tell compelling stories.', 'Baby Rasta');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bchv17novtj7bpmkvgojorupv0k3tipknifjtkq6nfy5jhknsj','063lc4daush398r', NULL, 'Baby Rasta Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pzi6rvp6hvr7vdyf1xk3xrhbm29mmg2qv9495iba92821fa2i9','PUNTO 40','063lc4daush398r','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bchv17novtj7bpmkvgojorupv0k3tipknifjtkq6nfy5jhknsj', 'pzi6rvp6hvr7vdyf1xk3xrhbm29mmg2qv9495iba92821fa2i9', '0');
-- Junior H
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1snpuq49pwu4wku', 'Junior H', '81@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5ccab5d3dc10a08d89cbd76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:81@artist.com', '1snpuq49pwu4wku', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1snpuq49pwu4wku', 'A fresh voice in regional Mexican music, blending tradition with modernity.', 'Junior H');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qnkzfrsrjobxg2hyh898z1ofgd2cx9wtdxc6fp6ra8yrd13712','1snpuq49pwu4wku', 'https://i.scdn.co/image/ab67616d0000b27333ed356efed99b158c4267c6', 'El Azul','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x4doop38fm3g6rti54emb68jocypzowbjhfpc8cwgvdoyiejo9','El Azul','1snpuq49pwu4wku','POP','1haJsMtoBhHfvuM7XWuT3W','https://p.scdn.co/mp3-preview/f9df136c3a2d3c0c5424e2c4b75a303f35c08af5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qnkzfrsrjobxg2hyh898z1ofgd2cx9wtdxc6fp6ra8yrd13712', 'x4doop38fm3g6rti54emb68jocypzowbjhfpc8cwgvdoyiejo9', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j9m6glknugri5d9u7ep9xlgey25q3tezh40uzhicm73opdb6a4','LUNA','1snpuq49pwu4wku','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qnkzfrsrjobxg2hyh898z1ofgd2cx9wtdxc6fp6ra8yrd13712', 'j9m6glknugri5d9u7ep9xlgey25q3tezh40uzhicm73opdb6a4', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bfmgl3hxb7wwmoecydevruwhzqvw4jdvb7uxdn6bzq7npz9pb3','Abcdario','1snpuq49pwu4wku','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qnkzfrsrjobxg2hyh898z1ofgd2cx9wtdxc6fp6ra8yrd13712', 'bfmgl3hxb7wwmoecydevruwhzqvw4jdvb7uxdn6bzq7npz9pb3', '2');
-- Jimin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e3kxfsvpvb5yiji', 'Jimin', '82@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb59f8cfc8e71dcaf8c6ec4bde','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:82@artist.com', 'e3kxfsvpvb5yiji', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e3kxfsvpvb5yiji', 'Known for his expressive voice and mesmerizing dance moves in BTS.', 'Jimin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i78j42ldpvocakol0v71ol5f2we7pvook9ll5xj53xa2v3i186','e3kxfsvpvb5yiji', 'https://i.scdn.co/image/ab67616d0000b2732b46078245d0120690eb560d', 'FACE','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y3npsnm5jwcpnlyl2762odbbn7tbzabwt8okyz73h6z1iqbkny','Like Crazy','e3kxfsvpvb5yiji','POP','3Ua0m0YmEjrMi9XErKcNiR','https://p.scdn.co/mp3-preview/2db5f36096963d97afc870c50990d62d27858a43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i78j42ldpvocakol0v71ol5f2we7pvook9ll5xj53xa2v3i186', 'y3npsnm5jwcpnlyl2762odbbn7tbzabwt8okyz73h6z1iqbkny', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kcxde6thsy8rxfs47luvpms72jwvn9pp33f88jxqpwu979zayw','Set Me Free Pt.2','e3kxfsvpvb5yiji','POP','59hBR0BCtJsfIbV9VzCVAp','https://p.scdn.co/mp3-preview/275a3a0843bb55c251cda45ef17a905dab31624c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i78j42ldpvocakol0v71ol5f2we7pvook9ll5xj53xa2v3i186', 'kcxde6thsy8rxfs47luvpms72jwvn9pp33f88jxqpwu979zayw', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m81y789zaluxirozv46rb9bceto9indm21hdrl2lkw5xvikik7','Like Crazy (English Version)','e3kxfsvpvb5yiji','POP','0u8rZGtXJrLtiSe34FPjGG','https://p.scdn.co/mp3-preview/3752bae14d7952abe6f93649d85d53bfe98f1165?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i78j42ldpvocakol0v71ol5f2we7pvook9ll5xj53xa2v3i186', 'm81y789zaluxirozv46rb9bceto9indm21hdrl2lkw5xvikik7', '2');
-- Sabrina Carpenter
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4ycqjxzfjqt3c9u', 'Sabrina Carpenter', '83@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb00e540b760b56d02cc415c47','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:83@artist.com', '4ycqjxzfjqt3c9u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4ycqjxzfjqt3c9u', 'A tapestry of rhythms that echo the pulse of life.', 'Sabrina Carpenter');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qys31ok99tutn58yqzcapc5ou9k9jtoeed3m1v5najvtd22imt','4ycqjxzfjqt3c9u', 'https://i.scdn.co/image/ab67616d0000b273700f7bf79c9f063ad0362bdf', 'emails i cant send','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('frv2mk1ioqatdr2qkqhkt3ltre7vg6oo0jhntg0taz9in9nzs1','Nonsense','4ycqjxzfjqt3c9u','POP','6dgUya35uo964z7GZXM07g',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qys31ok99tutn58yqzcapc5ou9k9jtoeed3m1v5najvtd22imt', 'frv2mk1ioqatdr2qkqhkt3ltre7vg6oo0jhntg0taz9in9nzs1', '0');
-- Simone Mendes
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hgmcooxr9etct1u', 'Simone Mendes', '84@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb80e5acf09546a1fa2ca12a49','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:84@artist.com', 'hgmcooxr9etct1u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hgmcooxr9etct1u', 'A visionary in the world of music, redefining genres.', 'Simone Mendes');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t73ygequlncdxjt3zv1u9pgen72wt3kp91papoh0f5e5goce26','hgmcooxr9etct1u', 'https://i.scdn.co/image/ab67616d0000b27379dcbcbbc872003eea5fd10f', 'Churrasco','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qrpn86i00fvi7s5ezbcxe0lu5sqzm9wa2b3kver11iv0gws59a','Erro Gostoso - Ao Vivo','hgmcooxr9etct1u','POP','4R1XAT4Ix7kad727aKh7Pj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t73ygequlncdxjt3zv1u9pgen72wt3kp91papoh0f5e5goce26', 'qrpn86i00fvi7s5ezbcxe0lu5sqzm9wa2b3kver11iv0gws59a', '0');
-- Future
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nrb1lzddx9c06di', 'Future', '85@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:85@artist.com', 'nrb1lzddx9c06di', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nrb1lzddx9c06di', 'Blending traditional rhythms with modern beats.', 'Future');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uoebujzvzk45okq7d8rd1qcd3710bxe4suexcxhaax1v3w5zjp','nrb1lzddx9c06di', NULL, 'Future Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9s1r0y5haoc38x0feo3nf92l13k6g2kh2qxccq2d2jx3erxrk2','Too Many Nights (feat. Don Toliver & with Future)','nrb1lzddx9c06di','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uoebujzvzk45okq7d8rd1qcd3710bxe4suexcxhaax1v3w5zjp', '9s1r0y5haoc38x0feo3nf92l13k6g2kh2qxccq2d2jx3erxrk2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uzd3c5c9ixkix3bp8w50z820nzo9rukv8nu23i6rdzerhspmxt','All The Way Live (Spider-Man: Across the Spider-Verse) (Metro Boomin & Future, Lil Uzi Vert)','nrb1lzddx9c06di','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uoebujzvzk45okq7d8rd1qcd3710bxe4suexcxhaax1v3w5zjp', 'uzd3c5c9ixkix3bp8w50z820nzo9rukv8nu23i6rdzerhspmxt', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m864kaaijungc73qnpqbgbjm17d2zjmip695hmy7jpvmfhq1cz','Superhero (Heroes & Villains) [with Future & Chris Brown]','nrb1lzddx9c06di','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uoebujzvzk45okq7d8rd1qcd3710bxe4suexcxhaax1v3w5zjp', 'm864kaaijungc73qnpqbgbjm17d2zjmip695hmy7jpvmfhq1cz', '2');
-- Freddie Dredd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sdri6bnuyk25ble', 'Freddie Dredd', '86@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9d100e5a9cf34beab8e75750','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:86@artist.com', 'sdri6bnuyk25ble', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sdri6bnuyk25ble', 'An alchemist of harmonies, transforming notes into gold.', 'Freddie Dredd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cka5fvw69e5waqix140kknjdpsz51avvhcmq0l6os4w2tw0lm6','sdri6bnuyk25ble', 'https://i.scdn.co/image/ab67616d0000b27369b381d574b329409bd806e6', 'Freddies Inferno','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6dalr30uz2swmqqt9ye2f5n2lgmjidz6rjup96bu80ua7y3gyo','Limbo','sdri6bnuyk25ble','POP','37F7E7BKEw2E4O2L7u0IEp','https://p.scdn.co/mp3-preview/1715e2acb52d6fdd0e4b11ea8792688c12987ff7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cka5fvw69e5waqix140kknjdpsz51avvhcmq0l6os4w2tw0lm6', '6dalr30uz2swmqqt9ye2f5n2lgmjidz6rjup96bu80ua7y3gyo', '0');
-- Eslabon Armado
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sk5jrculliyfp9l', 'Eslabon Armado', '87@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb114fc6846b9f0e0746baa6a7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:87@artist.com', 'sk5jrculliyfp9l', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sk5jrculliyfp9l', 'Bringing a fresh take to traditional music, weaving in modern influences.', 'Eslabon Armado');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sj3h6sabzmajdjsxs38jqtzsdkscevx4cgy8bnu7soz27bxzak','sk5jrculliyfp9l', 'https://i.scdn.co/image/ab67616d0000b2732071a0c79802d9375a53bfef', 'Ella Baila Sola','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ktictbwtdfaztzfkbofvecdz49wggfl0sg4ds21v4pds0afhhr','Ella Baila Sola','sk5jrculliyfp9l','POP','3dnP0JxCgygwQH9Gm7q7nb','https://p.scdn.co/mp3-preview/5d39f3e17f1e20e2711d033001e48b8d4249b992?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sj3h6sabzmajdjsxs38jqtzsdkscevx4cgy8bnu7soz27bxzak', 'ktictbwtdfaztzfkbofvecdz49wggfl0sg4ds21v4pds0afhhr', '0');
-- Yandel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sxt3ltbdynb8bf5', 'Yandel', '88@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7dbaf2fabcbd4b37168397fd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:88@artist.com', 'sxt3ltbdynb8bf5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sxt3ltbdynb8bf5', 'A powerhouse of reggaeton, blending rhythms that move the soul.', 'Yandel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uz72i6vwbw01gyddg8qkldv3u8zzs40zy3ahpc325opmxk2fxa','sxt3ltbdynb8bf5', 'https://i.scdn.co/image/ab67616d0000b273b2aec01b56eeb74610532700', 'Resistencia','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m8tubaxxl7g5gk38x9774f2ljncaf1ednxl3qnhtlvcum4do42','Yandel 150','sxt3ltbdynb8bf5','POP','4FAKtPVycI4DxoOHC01YqD','https://p.scdn.co/mp3-preview/338ed053ce26ccc3313b00b5e6153e60ffd2eb19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uz72i6vwbw01gyddg8qkldv3u8zzs40zy3ahpc325opmxk2fxa', 'm8tubaxxl7g5gk38x9774f2ljncaf1ednxl3qnhtlvcum4do42', '0');
-- Miguel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('owo2jijh2ccp7fc', 'Miguel', '89@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4669166b571594eade778990','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:89@artist.com', 'owo2jijh2ccp7fc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('owo2jijh2ccp7fc', 'A visionary in the world of music, redefining genres.', 'Miguel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('c0l4n6rwfmhu89r4itsp0p24fd2gjxvg7w235d9khegrlj02l2','owo2jijh2ccp7fc', 'https://i.scdn.co/image/ab67616d0000b273d5a8395b0d80b8c48a5d851c', 'All I Want Is You','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i9z7biae53l9rsl1an7z4988a12a4vmhvsd424abac2mwef2hs','Sure Thing','owo2jijh2ccp7fc','POP','0JXXNGljqupsJaZsgSbMZV','https://p.scdn.co/mp3-preview/d337faa4bb71c8ac9a13998be64fbb0d7d8b8463?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c0l4n6rwfmhu89r4itsp0p24fd2gjxvg7w235d9khegrlj02l2', 'i9z7biae53l9rsl1an7z4988a12a4vmhvsd424abac2mwef2hs', '0');
-- Dave
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lgps5vqggoykxb4', 'Dave', '90@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd03e9ecf77419871b96daee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:90@artist.com', 'lgps5vqggoykxb4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lgps5vqggoykxb4', 'A master of words, blending rap with social commentary and raw emotion.', 'Dave');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o2ybg00zj8eepe72wx4xpd60y67k7uaz42nxwcdfl837s1dbw2','lgps5vqggoykxb4', 'https://i.scdn.co/image/ab67616d0000b273e3a09a9ae3f1fa102c110e60', 'Sprinter','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aiw7ls76sw2qxu461269b36ydovikmywdou62ml6f9fftqwzcw','Sprinter','lgps5vqggoykxb4','POP','2FDTHlrBguDzQkp7PVj16Q',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o2ybg00zj8eepe72wx4xpd60y67k7uaz42nxwcdfl837s1dbw2', 'aiw7ls76sw2qxu461269b36ydovikmywdou62ml6f9fftqwzcw', '0');
-- Kaliii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6wnamndjpp20wcc', 'Kaliii', '91@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb749bcc7f4b8d1d60f5f13744','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:91@artist.com', '6wnamndjpp20wcc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6wnamndjpp20wcc', 'Weaving lyrical magic into every song.', 'Kaliii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('615q5hep0ouuesjfq3ci111eh71c1f4y4mak4ju36f6occ43i6','6wnamndjpp20wcc', 'https://i.scdn.co/image/ab67616d0000b2733eecc265c134153c14794aab', 'Area Codes','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('69o6evs4appmeejrj4mmzc8r02fgrqbx8if4l3vvkqdk7ne3ey','Area Codes','6wnamndjpp20wcc','POP','7sliFe6W30tPBPh6dvZsIH','https://p.scdn.co/mp3-preview/d1beed2734f948ec9c33164d3aa818e04f4afd30?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('615q5hep0ouuesjfq3ci111eh71c1f4y4mak4ju36f6occ43i6', '69o6evs4appmeejrj4mmzc8r02fgrqbx8if4l3vvkqdk7ne3ey', '0');
-- Fifty Fifty
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ugcyqhfv22383g9', 'Fifty Fifty', '92@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5a60b0f886b5deb8518e4a41','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:92@artist.com', 'ugcyqhfv22383g9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ugcyqhfv22383g9', 'Blending a rich array of genres to create a unique musical experience.', 'Fifty Fifty');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5xkqiuihjldj7y0inua9m3u15p2giqpz7z9nfp8ykz08bhus28','ugcyqhfv22383g9', 'https://i.scdn.co/image/ab67616d0000b27337c0b3670236c067c8e8bbcb', 'The Beginning: Cupid','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1xdyv2j5g6054jz5w3jdc3ycutdnu4tf3cpksyoyoi2wgogxp1','Cupid - Twin Ver.','ugcyqhfv22383g9','POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5xkqiuihjldj7y0inua9m3u15p2giqpz7z9nfp8ykz08bhus28', '1xdyv2j5g6054jz5w3jdc3ycutdnu4tf3cpksyoyoi2wgogxp1', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xlwzsbho0czql67hfiywmzrxbqnr31nfheupkcgl8ic4422qoc','Cupid','ugcyqhfv22383g9','POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5xkqiuihjldj7y0inua9m3u15p2giqpz7z9nfp8ykz08bhus28', 'xlwzsbho0czql67hfiywmzrxbqnr31nfheupkcgl8ic4422qoc', '1');
-- Andy Williams
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c9ao2f0316xx0bw', 'Andy Williams', '93@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5888acdca5e748e796b4e69b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:93@artist.com', 'c9ao2f0316xx0bw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c9ao2f0316xx0bw', 'The heartbeat of a new generation of music lovers.', 'Andy Williams');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ygz836t9x4snpwo1fajv4i9ptt7wbui50lz9fac0etyeo508m6','c9ao2f0316xx0bw', 'https://i.scdn.co/image/ab67616d0000b27398073965947f92f1641b8356', 'The Andy Williams Christmas Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7mvom9edpcb7jbhwdpxgpjmartxt66ec7quuj2wlxmivuu1u2i','Its the Most Wonderful Time of the Year','c9ao2f0316xx0bw','POP','5hslUAKq9I9CG2bAulFkHN','https://p.scdn.co/mp3-preview/853f441c5fc1b25ba88bb300c17119cde36da675?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ygz836t9x4snpwo1fajv4i9ptt7wbui50lz9fac0etyeo508m6', '7mvom9edpcb7jbhwdpxgpjmartxt66ec7quuj2wlxmivuu1u2i', '0');
-- Mahalini
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pt1i1sgr5soemdu', 'Mahalini', '94@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb8333468abeb2e461d1ab5ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:94@artist.com', 'pt1i1sgr5soemdu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pt1i1sgr5soemdu', 'Delivering soul-stirring tunes that linger in the mind.', 'Mahalini');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('aqw93v9yid4v1g7cwenukhy71zqi7t4gcfrpmueeumnll50isq','pt1i1sgr5soemdu', 'https://i.scdn.co/image/ab67616d0000b2736f713eb92ebf7ca05a562542', 'fábula','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('65nhz9sujwyk8vpygacagqobodjpbud0aehaek0gnobty78aud','Sial','pt1i1sgr5soemdu','POP','6O0WEM0QNEhqpU50BKui7o','https://p.scdn.co/mp3-preview/1285e7f97156037b5c1c958513ff3f8176a68a33?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('aqw93v9yid4v1g7cwenukhy71zqi7t4gcfrpmueeumnll50isq', '65nhz9sujwyk8vpygacagqobodjpbud0aehaek0gnobty78aud', '0');
-- Migrantes
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('finmzxh1ooh7b4o', 'Migrantes', '95@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb676e77ad14850536079e2ea8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:95@artist.com', 'finmzxh1ooh7b4o', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('finmzxh1ooh7b4o', 'Blending genres for a fresh musical experience.', 'Migrantes');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ct1kgf2w7u4pnmxdm43s6zsqbm3dqd9ysr3rkttxvbf67axs2y','finmzxh1ooh7b4o', NULL, 'Migrantes Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wxi955jbevgdwifninybygu4lyjfuuumuisswcv3nlwh3psu18','MERCHO','finmzxh1ooh7b4o','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ct1kgf2w7u4pnmxdm43s6zsqbm3dqd9ysr3rkttxvbf67axs2y', 'wxi955jbevgdwifninybygu4lyjfuuumuisswcv3nlwh3psu18', '0');
-- Marlia Mendo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yr5hv8mqy0xtzro', 'Marlia Mendo', '96@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebffaebdbc972967729f688e25','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:96@artist.com', 'yr5hv8mqy0xtzro', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yr5hv8mqy0xtzro', 'Creating a tapestry of tunes that celebrates diversity.', 'Marlia Mendo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6atr745u7xk0p2w1ym227nsick1yigt6pmy346xlkcglhh0lhh','yr5hv8mqy0xtzro', NULL, 'Marlia Mendo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h90gasji4jodhgfunyw9w8g5xguvaf04h7qt2nmujeuzawsuwe','Le','yr5hv8mqy0xtzro','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6atr745u7xk0p2w1ym227nsick1yigt6pmy346xlkcglhh0lhh', 'h90gasji4jodhgfunyw9w8g5xguvaf04h7qt2nmujeuzawsuwe', '0');
-- Arcangel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m6sf3lpgtnkxe31', 'Arcangel', '97@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebafdf17286a0d7a23ad388587','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:97@artist.com', 'm6sf3lpgtnkxe31', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m6sf3lpgtnkxe31', 'Revolutionizing the music scene with innovative compositions.', 'Arcangel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mns22l5czojzm4tqcuowaw5e1ky7szx4l2a0rgzxqcox84jjrg','m6sf3lpgtnkxe31', 'https://i.scdn.co/image/ab67616d0000b27330326b23e30ae93d4d48165b', 'Sr. Santos','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cwajxa28awbkkwv5ha7u5h62jsy083jew6bcx2dikn7k328sr4','La Jumpa','m6sf3lpgtnkxe31','POP','2mnXxnrX5vCGolNkaFvVeM','https://p.scdn.co/mp3-preview/8bcdff4719a7a4211128ec93da03892e46c4bc6a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mns22l5czojzm4tqcuowaw5e1ky7szx4l2a0rgzxqcox84jjrg', 'cwajxa28awbkkwv5ha7u5h62jsy083jew6bcx2dikn7k328sr4', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zrmku8alrpxqqxks22bhe9oxxbre7l5l0hw1566wqrq3th153m','Arcngel: Bzrp Music Sessions, Vol','m6sf3lpgtnkxe31','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mns22l5czojzm4tqcuowaw5e1ky7szx4l2a0rgzxqcox84jjrg', 'zrmku8alrpxqqxks22bhe9oxxbre7l5l0hw1566wqrq3th153m', '1');
-- Stephen Sanchez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d5fok5pg6pyllp2', 'Stephen Sanchez', '98@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1e97fce6fa6fc4ebc3ebda25','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:98@artist.com', 'd5fok5pg6pyllp2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('d5fok5pg6pyllp2', 'A harmonious blend of passion and creativity.', 'Stephen Sanchez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('72f48r692sdmmrpd1it7h197unb089lglpu8qufqgjkd7lg1c9','d5fok5pg6pyllp2', 'https://i.scdn.co/image/ab67616d0000b2732bf0876d42b90a8852ad6244', 'Until I Found You (Em Beihold Version)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ahj68rwqxfzx3i72n1tyv5o0go1oc9w3ak28o953alj50f2a3i','Until I Found You','d5fok5pg6pyllp2','POP','1Y3LN4zO1Edc2EluIoSPJN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('72f48r692sdmmrpd1it7h197unb089lglpu8qufqgjkd7lg1c9', 'ahj68rwqxfzx3i72n1tyv5o0go1oc9w3ak28o953alj50f2a3i', '0');
-- SEVENTEEN
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('awtch5tsrh9men8', 'SEVENTEEN', '99@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb61916bb9f5c6a1a9ba1c9ab6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:99@artist.com', 'awtch5tsrh9men8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('awtch5tsrh9men8', 'Redefining what it means to be an artist in the digital age.', 'SEVENTEEN');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6ppqxauxlptu0ttwwvot3aiooj36cqll7etgftt9s5vi926qwc','awtch5tsrh9men8', 'https://i.scdn.co/image/ab67616d0000b27380e31ba0c05187e6310ef264', 'SEVENTEEN 10th Mini Album FML','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wce32o6vvl29dzlhjnqt32kvzt7ln3qn8e6gbxofwrplmpxm8h','Super','awtch5tsrh9men8','POP','3AOf6YEpxQ894FmrwI9k96','https://p.scdn.co/mp3-preview/1dd31996959e603934dbe4c7d3ee377243a0f890?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6ppqxauxlptu0ttwwvot3aiooj36cqll7etgftt9s5vi926qwc', 'wce32o6vvl29dzlhjnqt32kvzt7ln3qn8e6gbxofwrplmpxm8h', '0');
-- Creedence Clearwater Revival
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5q98j01fw3m1qh2', 'Creedence Clearwater Revival', '100@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd2e2b04b7ba5d60b72f54506','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:100@artist.com', '5q98j01fw3m1qh2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5q98j01fw3m1qh2', 'Elevating the ordinary to extraordinary through music.', 'Creedence Clearwater Revival');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tumrtwhy3ue65103738zcylj1jmhw8f1awlyp3ot5p021pdd0y','5q98j01fw3m1qh2', 'https://i.scdn.co/image/ab67616d0000b27351f311c2fb06ad2789e3ff91', 'Pendulum (Expanded Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6xms0l5im55vegtdlmbpno4u713vbzx0b4dknhs8o2z5cqwsce','Have You Ever Seen The Rain?','5q98j01fw3m1qh2','POP','2LawezPeJhN4AWuSB0GtAU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tumrtwhy3ue65103738zcylj1jmhw8f1awlyp3ot5p021pdd0y', '6xms0l5im55vegtdlmbpno4u713vbzx0b4dknhs8o2z5cqwsce', '0');
-- Tainy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6l62vkez82i9xjs', 'Tainy', '101@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb50d43598b9074f0d6146127','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:101@artist.com', '6l62vkez82i9xjs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6l62vkez82i9xjs', 'Revolutionizing reggaeton and Latin music with groundbreaking production.', 'Tainy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fzx5rdrya09ps9kecmw8rxfgdhahquhoay9myf3puor53u9c2q','6l62vkez82i9xjs', 'https://i.scdn.co/image/ab67616d0000b273de7b9af78fbdda96c5a0635b', 'DATA','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nqo221cmoskgm452588xz6dmw79gyafadshqwrul8510aitx10','MOJABI GHOST','6l62vkez82i9xjs','POP','4eMKD8MRroxCqugpsxCCNb','https://p.scdn.co/mp3-preview/a6d8180d52b759c3e3db9aa78e841ffc06e26c17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fzx5rdrya09ps9kecmw8rxfgdhahquhoay9myf3puor53u9c2q', 'nqo221cmoskgm452588xz6dmw79gyafadshqwrul8510aitx10', '0');
-- Em Beihold
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qt6ai6puk2ze99v', 'Em Beihold', '102@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb23c885de4c81852c917608ac','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:102@artist.com', 'qt6ai6puk2ze99v', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qt6ai6puk2ze99v', 'A voice that captivates, combining depth of lyrics with a melodic finesse.', 'Em Beihold');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('su167vm9mfenfbv23a8qha12ul1tcrlp97r5arbgsputkd3d58','qt6ai6puk2ze99v', NULL, 'Em Beihold Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tdsmpyjgyce0r0p0cpwn4ugyab082gdwlpfmytig42apxdslya','Until I Found You (with Em Beihold) - Em Beihold Version','qt6ai6puk2ze99v','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('su167vm9mfenfbv23a8qha12ul1tcrlp97r5arbgsputkd3d58', 'tdsmpyjgyce0r0p0cpwn4ugyab082gdwlpfmytig42apxdslya', '0');
-- Niall Horan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5qcoj5yw0frfmn5', 'Niall Horan', '103@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeccc1cde8e9fdcf1c9289897','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:103@artist.com', '5qcoj5yw0frfmn5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5qcoj5yw0frfmn5', 'A journey through the spectrum of sound in every album.', 'Niall Horan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3rcqolb6xwssql60053nsektpdvx7ltdejlpv9nn4ixmqnvl5j','5qcoj5yw0frfmn5', 'https://i.scdn.co/image/ab67616d0000b2732a368fea49f5c489a9dc3949', 'The Show','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sovilkvnxud7f5cmhrzk3nqs8z9zee8q2t0pybrsm9boten17e','Heaven','5qcoj5yw0frfmn5','POP','5FQ77Cl1ndljtwwImdtjMy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3rcqolb6xwssql60053nsektpdvx7ltdejlpv9nn4ixmqnvl5j', 'sovilkvnxud7f5cmhrzk3nqs8z9zee8q2t0pybrsm9boten17e', '0');
-- Bobby Helms
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gn9xmogj81d5749', 'Bobby Helms', '104@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebbec4ae689dc30a2b59a19038','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:104@artist.com', 'gn9xmogj81d5749', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gn9xmogj81d5749', 'A voice that echoes the sentiments of a generation.', 'Bobby Helms');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e89o793yrro5yru6ouiiodbjjg5xc44d3rnyl6mfh6qr5uqh13','gn9xmogj81d5749', 'https://i.scdn.co/image/ab67616d0000b273fd56f3c7a294f5cfe51c7b17', 'Jingle Bell Rock/Captain Santa Claus (And His Reindeer Space Patrol)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t7crko8557t0c8ebminpcn32jggsizrcfw390l950i85jyih1z','Jingle Bell Rock','gn9xmogj81d5749','POP','7vQbuQcyTflfCIOu3Uzzya',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e89o793yrro5yru6ouiiodbjjg5xc44d3rnyl6mfh6qr5uqh13', 't7crko8557t0c8ebminpcn32jggsizrcfw390l950i85jyih1z', '0');
-- BLACKPINK
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('34fn98vfxn43xd0', 'BLACKPINK', '105@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc9690bc711d04b3d4fd4b87c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:105@artist.com', '34fn98vfxn43xd0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('34fn98vfxn43xd0', 'Breathing new life into classic genres.', 'BLACKPINK');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8fpmu3pr0yr8rfhnyn6p7egew0249cw2nmch1ydxguvlu7mrr4','34fn98vfxn43xd0', 'https://i.scdn.co/image/ab67616d0000b273002ef53878df1b4e91c15406', 'BORN PINK','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1kmsj8zy43zcrasbxmxdpxk780kgnniel02apj3he0j7lao4uz','Shut Down','34fn98vfxn43xd0','POP','7gRFDGEzF9UkBV233yv2dc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8fpmu3pr0yr8rfhnyn6p7egew0249cw2nmch1ydxguvlu7mrr4', '1kmsj8zy43zcrasbxmxdpxk780kgnniel02apj3he0j7lao4uz', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v17n507uac3c6m8a4w9jqsi70hzddwwctgxegmaweq5pbzny2v','Pink Venom','34fn98vfxn43xd0','POP','5zwwW9Oq7ubSxoCGyW1nbY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8fpmu3pr0yr8rfhnyn6p7egew0249cw2nmch1ydxguvlu7mrr4', 'v17n507uac3c6m8a4w9jqsi70hzddwwctgxegmaweq5pbzny2v', '1');
-- R
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d65j6eo554hyjbr', 'R', '106@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6334ab6a83196f36475ada7f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:106@artist.com', 'd65j6eo554hyjbr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('d65j6eo554hyjbr', 'Blending genres for a fresh musical experience.', 'R');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l7uf8gtpsps17qh4vtohh9abf0g5bo29ezpdcdqsv2mxsi7ed5','d65j6eo554hyjbr', 'https://i.scdn.co/image/ab67616d0000b273a3a7f38ea2033aa501afd4cf', 'Calm Down (with Selena Gomez)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ffqmak6adc775wm3po5hmanik3x1a8f15yuhwzxpacw2rcuuo7','Calm Down','d65j6eo554hyjbr','POP','0WtM2NBVQNNJLh6scP13H8',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l7uf8gtpsps17qh4vtohh9abf0g5bo29ezpdcdqsv2mxsi7ed5', 'ffqmak6adc775wm3po5hmanik3x1a8f15yuhwzxpacw2rcuuo7', '0');
-- Melanie Martinez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uni506ygugkhnss', 'Melanie Martinez', '107@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb77ecd63aaebe2225b07c89f0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:107@artist.com', 'uni506ygugkhnss', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uni506ygugkhnss', 'A visionary in the world of music, redefining genres.', 'Melanie Martinez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('97qufzo5gzzm3es9yyiizv7f6f15wfcy9i0vvuwf66lmn2uwak','uni506ygugkhnss', 'https://i.scdn.co/image/ab67616d0000b2733c6c534cdacc9cf53e6d2977', 'PORTALS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ht51igwj7lnqujrnm7z2a0enxcx28ns9q6rvdx72d76gxym92s','VOID','uni506ygugkhnss','POP','6wmKvtSmyTqHNo44OBXVN1','https://p.scdn.co/mp3-preview/9a2ae9278ecfe2ed8d628dfe05699bf24395d6a0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('97qufzo5gzzm3es9yyiizv7f6f15wfcy9i0vvuwf66lmn2uwak', 'ht51igwj7lnqujrnm7z2a0enxcx28ns9q6rvdx72d76gxym92s', '0');
-- Arctic Monkeys
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('drke73kul3866pc', 'Arctic Monkeys', '108@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:108@artist.com', 'drke73kul3866pc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('drke73kul3866pc', 'Rock innovators, known for their sharp lyrics and compelling sound.', 'Arctic Monkeys');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e0g0lm3fscbln8twhbygiy2pya6mrp566k27k4x7qmi6bx05c7','drke73kul3866pc', 'https://i.scdn.co/image/ab67616d0000b2734ae1c4c5c45aabe565499163', 'AM','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5i0i3o98tut9lrkro77isnosxpwqltfzyyinb0axt21nfghhpu','I Wanna Be Yours','drke73kul3866pc','POP','5XeFesFbtLpXzIVDNQP22n','https://p.scdn.co/mp3-preview/07de30bde8363d9ff78b72339245c151f67af451?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e0g0lm3fscbln8twhbygiy2pya6mrp566k27k4x7qmi6bx05c7', '5i0i3o98tut9lrkro77isnosxpwqltfzyyinb0axt21nfghhpu', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vmnrhdt7tgwormmbono3h1ajew5vis4nhlvcv4kwev8m04epkf','505','drke73kul3866pc','POP','58ge6dfP91o9oXMzq3XkIS','https://p.scdn.co/mp3-preview/1b23606bada6aacb339535944c1fe505898195e1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e0g0lm3fscbln8twhbygiy2pya6mrp566k27k4x7qmi6bx05c7', 'vmnrhdt7tgwormmbono3h1ajew5vis4nhlvcv4kwev8m04epkf', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ohwkoi7e46c6kig4zwctlw6d8lqw27g4e7jahr7c2kf70ye34p','Do I Wanna Know?','drke73kul3866pc','POP','5FVd6KXrgO9B3JPmC8OPst','https://p.scdn.co/mp3-preview/006bc465fe3d1c04dae93a050eca9d402a7322b8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e0g0lm3fscbln8twhbygiy2pya6mrp566k27k4x7qmi6bx05c7', 'ohwkoi7e46c6kig4zwctlw6d8lqw27g4e7jahr7c2kf70ye34p', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gkzd5xzvdasu0fb368piyctfmkfy17pobekr79jfib281i9l46','Whyd You Only Call Me When Youre High?','drke73kul3866pc','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e0g0lm3fscbln8twhbygiy2pya6mrp566k27k4x7qmi6bx05c7', 'gkzd5xzvdasu0fb368piyctfmkfy17pobekr79jfib281i9l46', '3');
-- Ayparia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qmv64fvum0zpy2t', 'Ayparia', '109@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebff258a75f7364baaaf9ed011','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:109@artist.com', 'qmv64fvum0zpy2t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qmv64fvum0zpy2t', 'Delivering a unique blend of sounds, showcasing versatility and artistic depth.', 'Ayparia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('syfbwdgvz3d1wr64l6gbrx6bwq1awiq5uityv6xbhxx6prj6va','qmv64fvum0zpy2t', NULL, 'Ayparia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fjc5uqc9acynrhtxet3s5khe76wrv6v5tm4sn0qmcyxv3o07dw','MONTAGEM - FR PUNK','qmv64fvum0zpy2t','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('syfbwdgvz3d1wr64l6gbrx6bwq1awiq5uityv6xbhxx6prj6va', 'fjc5uqc9acynrhtxet3s5khe76wrv6v5tm4sn0qmcyxv3o07dw', '0');
-- Tisto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h5i7wlv64z1wisf', 'Tisto', '110@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7afd1dcf8bc34612f16ee39c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:110@artist.com', 'h5i7wlv64z1wisf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h5i7wlv64z1wisf', 'Creating a tapestry of tunes that celebrates diversity.', 'Tisto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cfh5cws08zgld8izfo3k9iiklkpc1qptgftnls3cv7p7mg360m','h5i7wlv64z1wisf', NULL, 'Tisto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9pc3y9xg8lc53gj3ckjs3rnpu3rnrcfxsmc4y0flszrr2in0vi','10:35','h5i7wlv64z1wisf','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cfh5cws08zgld8izfo3k9iiklkpc1qptgftnls3cv7p7mg360m', '9pc3y9xg8lc53gj3ckjs3rnpu3rnrcfxsmc4y0flszrr2in0vi', '0');
-- David Kushner
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z1nyieg6udws9se', 'David Kushner', '111@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12fd1bd22516e35ef8c2e591','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:111@artist.com', 'z1nyieg6udws9se', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z1nyieg6udws9se', 'A rising talent, creating music that resonates with a generation.', 'David Kushner');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ljcb0f1u06rqqp0x5bk0wdy9y0ipzglqph01x3rwn8eihaxoy0','z1nyieg6udws9se', 'https://i.scdn.co/image/ab67616d0000b27395ca6a9b4083a86c149934ae', 'Daylight','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mtcivz8wprfucr9zo7x7xe34awsnpc1wn4e0eo2gnk0qmyeaw5','Daylight','z1nyieg6udws9se','POP','1odExI7RdWc4BT515LTAwj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ljcb0f1u06rqqp0x5bk0wdy9y0ipzglqph01x3rwn8eihaxoy0', 'mtcivz8wprfucr9zo7x7xe34awsnpc1wn4e0eo2gnk0qmyeaw5', '0');
-- Shubh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9go1hq2bsgytkhl', 'Shubh', '112@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3eac18e003a215ce96654ce1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:112@artist.com', '9go1hq2bsgytkhl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9go1hq2bsgytkhl', 'Sculpting soundwaves into masterpieces of auditory art.', 'Shubh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bcv5jlkjrdbw0oahwsr8rfh2soiwiaojdw9kcvk9rste7x9fui','9go1hq2bsgytkhl', 'https://i.scdn.co/image/ab67616d0000b2731a8c4618eda885a406958dd0', 'Still Rollin','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k9g4als9z6pl0403c1nodn8wbn21q12lug5bv6h5ppbw2c1tmp','Cheques','9go1hq2bsgytkhl','POP','4eBvRhTJ2AcxCsbfTUjoRp','https://p.scdn.co/mp3-preview/c607b777f851d56dd524f845957e24901adbf1eb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bcv5jlkjrdbw0oahwsr8rfh2soiwiaojdw9kcvk9rste7x9fui', 'k9g4als9z6pl0403c1nodn8wbn21q12lug5bv6h5ppbw2c1tmp', '0');
-- Wham!
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1vfr8kw35u0hwrn', 'Wham!', '113@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03e73d13341a8419eea9fcfb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:113@artist.com', '1vfr8kw35u0hwrn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1vfr8kw35u0hwrn', 'A sonic adventurer, always seeking new horizons in music.', 'Wham!');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('clhc2rfatu5ftf1sq1lgctbhon6pwtlv3ul5v8kfo04siystwa','1vfr8kw35u0hwrn', 'https://i.scdn.co/image/ab67616d0000b273f2d2adaa21ad616df6241e7d', 'LAST CHRISTMAS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ellpbot81n0b9c0zwaudc5x7x6bmlhhdt0rnpoe845tb2mb6uh','Last Christmas','1vfr8kw35u0hwrn','POP','2FRnf9qhLbvw8fu4IBXx78','https://p.scdn.co/mp3-preview/5c6b42e86dba5ec9e8346a345b3a8822b2396d3f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('clhc2rfatu5ftf1sq1lgctbhon6pwtlv3ul5v8kfo04siystwa', 'ellpbot81n0b9c0zwaudc5x7x6bmlhhdt0rnpoe845tb2mb6uh', '0');
-- Labrinth
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('svf6avneskl9ia3', 'Labrinth', '114@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7885d725841e0338092f5f6f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:114@artist.com', 'svf6avneskl9ia3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('svf6avneskl9ia3', 'Where words fail, my music speaks.', 'Labrinth');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qeea53pq0l0c71pxnqucpj8mfccmf2v1kox42mdcgw8qmuihle','svf6avneskl9ia3', 'https://i.scdn.co/image/ab67616d0000b2731df535f5089e544a3cc86069', 'Ends & Begins','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5osna3suv1nmv9ovl3m7q1xs3i0xihqsj5qixsqm5uvl9p1c7u','Never Felt So Alone','svf6avneskl9ia3','POP','6unndO70DvZfnXYcYQMyQJ','https://p.scdn.co/mp3-preview/d33db796d822aa77728af0f4abb06ccd596d2920?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qeea53pq0l0c71pxnqucpj8mfccmf2v1kox42mdcgw8qmuihle', '5osna3suv1nmv9ovl3m7q1xs3i0xihqsj5qixsqm5uvl9p1c7u', '0');
-- Daddy Yankee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('p6jd5btwv7ixb2k', 'Daddy Yankee', '115@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf9ad208bbff79c1ce09c77c1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:115@artist.com', 'p6jd5btwv7ixb2k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('p6jd5btwv7ixb2k', 'Harnessing the power of melody to tell compelling stories.', 'Daddy Yankee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9pfjm8v5odxiud0uocj3kkyru52hf4ej438f7ewmlvchlemi63','p6jd5btwv7ixb2k', 'https://i.scdn.co/image/ab67616d0000b2736bdcdf82ecce36bff808a40c', 'Barrio Fino (Bonus Track Version)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5ct4jyp7sep8df4s881hu4e69cbq0u6ol4zbewxfice2r3ufo2','Gasolina','p6jd5btwv7ixb2k','POP','228BxWXUYQPJrJYHDLOHkj','https://p.scdn.co/mp3-preview/7c545be6847f3a6b13c4ad9c70d10a34f49a92d3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9pfjm8v5odxiud0uocj3kkyru52hf4ej438f7ewmlvchlemi63', '5ct4jyp7sep8df4s881hu4e69cbq0u6ol4zbewxfice2r3ufo2', '0');
-- Vishal-Shekhar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ukypuakx63vly3m', 'Vishal-Shekhar', '116@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb90b6c3d093f9b02aad628eaf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:116@artist.com', 'ukypuakx63vly3m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ukypuakx63vly3m', 'Blending traditional rhythms with modern beats.', 'Vishal-Shekhar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ecx5ki4a02mdslyrqzj0fyr5qc4e427hasdzox0mk55i8tplst','ukypuakx63vly3m', NULL, 'Vishal-Shekhar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ijv39nu386f6tn3b5kj8imu0vqrf995ulinjh7oaa80ud400tv','Besharam Rang (From "Pathaan")','ukypuakx63vly3m','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ecx5ki4a02mdslyrqzj0fyr5qc4e427hasdzox0mk55i8tplst', 'ijv39nu386f6tn3b5kj8imu0vqrf995ulinjh7oaa80ud400tv', '0');
-- Bad Bunny
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ryeegnpf2y2iyz4', 'Bad Bunny', '117@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9ad50e478a469448c6f369df','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:117@artist.com', 'ryeegnpf2y2iyz4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ryeegnpf2y2iyz4', 'A trailblazer in Latin trap and reggaeton, known for his charismatic style and innovative music.', 'Bad Bunny');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ym8soe0cvizxykgjrfwp5ma2pxj69a2s8jl0v8ta6y8tmcx0l7','ryeegnpf2y2iyz4', 'https://i.scdn.co/image/ab67616d0000b273ab5c9cd818ad6ed3e9b79cd1', 'WHERE SHE GOES','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uahkhdbv2t9cgj0gb1361z54epbcwm96b8dt0nqufjgr5r8dea','WHERE SHE GOES','ryeegnpf2y2iyz4','POP','7ro0hRteUMfnOioTFI5TG1','https://p.scdn.co/mp3-preview/b9b7e4c982b33ee23c4867f7a3025e3598c35760?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ym8soe0cvizxykgjrfwp5ma2pxj69a2s8jl0v8ta6y8tmcx0l7', 'uahkhdbv2t9cgj0gb1361z54epbcwm96b8dt0nqufjgr5r8dea', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i79ddcue2c2y5n8ymymvsbakqvrzzzsncrgtnz1n771pwtcccu','un x100to','ryeegnpf2y2iyz4','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ym8soe0cvizxykgjrfwp5ma2pxj69a2s8jl0v8ta6y8tmcx0l7', 'i79ddcue2c2y5n8ymymvsbakqvrzzzsncrgtnz1n771pwtcccu', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kb04imr7f5hhyeyudh6ei1lazhbq937u92kjl8dgowiw319c0l','Coco Chanel','ryeegnpf2y2iyz4','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ym8soe0cvizxykgjrfwp5ma2pxj69a2s8jl0v8ta6y8tmcx0l7', 'kb04imr7f5hhyeyudh6ei1lazhbq937u92kjl8dgowiw319c0l', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a0ib9cp86vjfz422a3n7lt6g7ti8ot815nav3axnftolfb1lsn','Titi Me Pregunt','ryeegnpf2y2iyz4','POP','1IHWl5LamUGEuP4ozKQSXZ','https://p.scdn.co/mp3-preview/53a6217761f8fdfcff92189cafbbd1cc21fdb813?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ym8soe0cvizxykgjrfwp5ma2pxj69a2s8jl0v8ta6y8tmcx0l7', 'a0ib9cp86vjfz422a3n7lt6g7ti8ot815nav3axnftolfb1lsn', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('87lltchad3gbdc7zbikabajf6xv2ar6r34kn2bd5qotq61mio7','Efecto','ryeegnpf2y2iyz4','POP','5Eax0qFko2dh7Rl2lYs3bx','https://p.scdn.co/mp3-preview/a622a47c8df98ef72676608511c0b2e1d5d51268?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ym8soe0cvizxykgjrfwp5ma2pxj69a2s8jl0v8ta6y8tmcx0l7', '87lltchad3gbdc7zbikabajf6xv2ar6r34kn2bd5qotq61mio7', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0x59xvndyimq3dddk9lsipl8p0vg81jy4qbt6zq4uslbj7huwg','Neverita','ryeegnpf2y2iyz4','POP','31i56LZnwE6uSu3exoHjtB','https://p.scdn.co/mp3-preview/b50a3cafa2eb688f811d4079812649bfba050417?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ym8soe0cvizxykgjrfwp5ma2pxj69a2s8jl0v8ta6y8tmcx0l7', '0x59xvndyimq3dddk9lsipl8p0vg81jy4qbt6zq4uslbj7huwg', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sfw8qfy5ef3ku8fvzbanv80zcg5lpjbz54f4zkka34el72kjyi','Moscow Mule','ryeegnpf2y2iyz4','POP','6Xom58OOXk2SoU711L2IXO','https://p.scdn.co/mp3-preview/77b12f38abcff65705166d67b5657f70cd890635?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ym8soe0cvizxykgjrfwp5ma2pxj69a2s8jl0v8ta6y8tmcx0l7', 'sfw8qfy5ef3ku8fvzbanv80zcg5lpjbz54f4zkka34el72kjyi', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gqg8z3rj05tyasu5uwksvgxi3w24pmrwlkjthplmbw63qlzq2h','Yonaguni','ryeegnpf2y2iyz4','POP','2JPLbjOn0wPCngEot2STUS','https://p.scdn.co/mp3-preview/cbade9b0e669565ac8c7c07490f961e4c471b9ee?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ym8soe0cvizxykgjrfwp5ma2pxj69a2s8jl0v8ta6y8tmcx0l7', 'gqg8z3rj05tyasu5uwksvgxi3w24pmrwlkjthplmbw63qlzq2h', '7');
-- Jain
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sca0xl9g8d5kqrf', 'Jain', '118@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb673f287fead1f6c83b9b68ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:118@artist.com', 'sca0xl9g8d5kqrf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sca0xl9g8d5kqrf', 'Mixing electronic beats with multicultural influences to create a unique sound.', 'Jain');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oyglm12ezlu4atnxe05h7x7i2sf7p44j1qlx2tld4ctoygeljz','sca0xl9g8d5kqrf', 'https://i.scdn.co/image/ab67616d0000b27364ba66f8a81c52364e55db50', 'Zanaka (Deluxe)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0tj44su08h1imb0swbcttesvh8r0oc1kw6siwyi97yyrj2ezj1','Makeba','sca0xl9g8d5kqrf','POP','4TNFLwe6DhtR3Wn1JKMqMJ','https://p.scdn.co/mp3-preview/41db29480f9d12734adf491d3b5dd4da1005047c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oyglm12ezlu4atnxe05h7x7i2sf7p44j1qlx2tld4ctoygeljz', '0tj44su08h1imb0swbcttesvh8r0oc1kw6siwyi97yyrj2ezj1', '0');
-- Kenshi Yonezu
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ovgtlbdq68ueugl', 'Kenshi Yonezu', '119@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc147e0888e83919d317c1103','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:119@artist.com', 'ovgtlbdq68ueugl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ovgtlbdq68ueugl', 'Igniting the stage with electrifying performances.', 'Kenshi Yonezu');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hsx4u4o7m3pgg78may8lfn8p4fgf56x6r180p9yri9y49lzu8u','ovgtlbdq68ueugl', 'https://i.scdn.co/image/ab67616d0000b273303d8545fce8302841c39859', 'KICK BACK','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d9casytexzctjlwu3uag2oks0h6tu0on4ltrgxoy09dk4pwtix','KICK BACK','ovgtlbdq68ueugl','POP','3khEEPRyBeOUabbmOPJzAG','https://p.scdn.co/mp3-preview/003a7a062f469db238cf5206626f08f3263c68e6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hsx4u4o7m3pgg78may8lfn8p4fgf56x6r180p9yri9y49lzu8u', 'd9casytexzctjlwu3uag2oks0h6tu0on4ltrgxoy09dk4pwtix', '0');
-- Elley Duh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lo2zdkxw9lkdlsi', 'Elley Duh', '120@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb44efd91d240d9853049612b4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:120@artist.com', 'lo2zdkxw9lkdlsi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lo2zdkxw9lkdlsi', 'Sculpting soundwaves into masterpieces of auditory art.', 'Elley Duh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('go9siy6mwo9plcrmz9gj741jqqbxi0kuz396i0j5xpprmznm7j','lo2zdkxw9lkdlsi', 'https://i.scdn.co/image/ab67616d0000b27353a2e11c1bde700722fecd2e', 'MIDDLE OF THE NIGHT','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bq7vfiynq9k19l75zatmm23i3m6aqx9a6mpapqei5afv71gqeg','MIDDLE OF THE NIGHT','lo2zdkxw9lkdlsi','POP','58HvfVOeJY7lUuCqF0m3ly','https://p.scdn.co/mp3-preview/e7c2441dcf8e321237c35085e4aa05bd0dcfa2c4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('go9siy6mwo9plcrmz9gj741jqqbxi0kuz396i0j5xpprmznm7j', 'bq7vfiynq9k19l75zatmm23i3m6aqx9a6mpapqei5afv71gqeg', '0');
-- Anggi Marito
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rahd0lnydt1bsis', 'Anggi Marito', '121@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb604493f4d58b7d152a2d5f79','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:121@artist.com', 'rahd0lnydt1bsis', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rahd0lnydt1bsis', 'Where words fail, my music speaks.', 'Anggi Marito');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dlnq8299obb9nhrcdssrupvuacqhmky27y8q8atwm6qhkprmpr','rahd0lnydt1bsis', 'https://i.scdn.co/image/ab67616d0000b2732844c4e4e984ea408ab7fd6f', 'Tak Segampang Itu','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('izzqcf97t25cufa4xkk5495exubl58rnggd6z2asn5utblt7ui','Tak Segampang Itu','rahd0lnydt1bsis','POP','26cvTWJq2E1QqN4jyH2OTU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dlnq8299obb9nhrcdssrupvuacqhmky27y8q8atwm6qhkprmpr', 'izzqcf97t25cufa4xkk5495exubl58rnggd6z2asn5utblt7ui', '0');
-- OneRepublic
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('p2b7qgg0f8p45td', 'OneRepublic', '122@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb57138b98e7ddd5a86ee97a9b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:122@artist.com', 'p2b7qgg0f8p45td', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('p2b7qgg0f8p45td', 'Delivering anthemic pop-rock tracks that resonate globally.', 'OneRepublic');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dk47mt600iencz9rdhd28oxc4byh1g7pf2dvhfx8g5zm6sp81e','p2b7qgg0f8p45td', 'https://i.scdn.co/image/ab67616d0000b273ec96e006b8bdfc582610ec13', 'I Ain’t Worried (Music From The Motion Picture "Top Gun: Maverick")','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xb951a1eo7hiw2oto7os9ov10jjfgr60dq5ek5m9be6qgydo1g','I Aint Worried','p2b7qgg0f8p45td','POP','4h9wh7iOZ0GGn8QVp4RAOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dk47mt600iencz9rdhd28oxc4byh1g7pf2dvhfx8g5zm6sp81e', 'xb951a1eo7hiw2oto7os9ov10jjfgr60dq5ek5m9be6qgydo1g', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5h21fp8f3fwfhwdhmfy9icib3b4806vwtlbyefwmnemiuyubgh','Counting Stars','p2b7qgg0f8p45td','POP','2tpWsVSb9UEmDRxAl1zhX1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dk47mt600iencz9rdhd28oxc4byh1g7pf2dvhfx8g5zm6sp81e', '5h21fp8f3fwfhwdhmfy9icib3b4806vwtlbyefwmnemiuyubgh', '1');
-- Justin Bieber
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yiiunrxdls4x2et', 'Justin Bieber', '123@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb393666951ab8b14e9c4ed386','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:123@artist.com', 'yiiunrxdls4x2et', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yiiunrxdls4x2et', 'From teen idol to global pop star, constantly evolving his sound.', 'Justin Bieber');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kpcznl6d0vort787zae92am3ngucvdjerf948fjj1lol7wll0l','yiiunrxdls4x2et', NULL, 'Justice','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('88s0ppb9z242iag9v6t3odskgutg141tq4c3ntrcnbjmmm5b2a','STAY (with Justin Bieber)','yiiunrxdls4x2et','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kpcznl6d0vort787zae92am3ngucvdjerf948fjj1lol7wll0l', '88s0ppb9z242iag9v6t3odskgutg141tq4c3ntrcnbjmmm5b2a', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sahr32imhiqzdw6eu2aiod6ht8etuta8o6zxrzsmcoq7pipopx','Ghost','yiiunrxdls4x2et','POP','6I3mqTwhRpn34SLVafSH7G',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kpcznl6d0vort787zae92am3ngucvdjerf948fjj1lol7wll0l', 'sahr32imhiqzdw6eu2aiod6ht8etuta8o6zxrzsmcoq7pipopx', '1');
-- RM
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d8ec5pmy7p6xgfl', 'RM', '124@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3b8f6208d84e28f63841e43c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:124@artist.com', 'd8ec5pmy7p6xgfl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('d8ec5pmy7p6xgfl', 'A visionary in the world of music, redefining genres.', 'RM');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y10ivk23th5k3asy93ef120w2srk82t27ct1y2qsg9l5hslzo8','d8ec5pmy7p6xgfl', NULL, 'RM Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('doo3pzapd9c35xpfhxh1rpsx667ti74eumwlpt5lr5p654vit0','Dont ever say love me (feat. RM of BTS)','d8ec5pmy7p6xgfl','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y10ivk23th5k3asy93ef120w2srk82t27ct1y2qsg9l5hslzo8', 'doo3pzapd9c35xpfhxh1rpsx667ti74eumwlpt5lr5p654vit0', '0');
-- Miley Cyrus
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('we55qmip2ol1czg', 'Miley Cyrus', '125@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5af3b38f053486ab0784dee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:125@artist.com', 'we55qmip2ol1czg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('we55qmip2ol1czg', 'Constantly evolving, from pop sensation to rock powerhouse.', 'Miley Cyrus');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ipcjrh7hga4do0cgngi69belnlpafil1cb6yvh0n1gm3tsjh41','we55qmip2ol1czg', 'https://i.scdn.co/image/ab67616d0000b273cd222052a2594be29a6616b5', 'Endless Summer Vacation','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ye713mjerovsukabuw8ipv3erkec5ul545hafjjo6kp02ucua4','Flowers','we55qmip2ol1czg','POP','7DSAEUvxU8FajXtRloy8M0','https://p.scdn.co/mp3-preview/5184d19d1b7fcc3e7c067e38af45a7cc80851440?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ipcjrh7hga4do0cgngi69belnlpafil1cb6yvh0n1gm3tsjh41', 'ye713mjerovsukabuw8ipv3erkec5ul545hafjjo6kp02ucua4', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yazyobq2qxi7o6rqbc2lwn56qmdjox9h0jcn7rl9wvleidaucq','Angels Like You','we55qmip2ol1czg','POP','1daDRI9ahBonbWD8YcxOIB','https://p.scdn.co/mp3-preview/4db8314199c0d49e95c786792ecd06eadae9f510?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ipcjrh7hga4do0cgngi69belnlpafil1cb6yvh0n1gm3tsjh41', 'yazyobq2qxi7o6rqbc2lwn56qmdjox9h0jcn7rl9wvleidaucq', '1');
-- Rauw Alejandro
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nluj6d1bey2yi6h', 'Rauw Alejandro', '126@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9047f938310ea16b68a5bdeb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:126@artist.com', 'nluj6d1bey2yi6h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nluj6d1bey2yi6h', 'A fusion of Latin trap and reggaeton, setting the stage on fire.', 'Rauw Alejandro');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('s83q80tm8ffmxamvczza7n6qxscq8nl961f6jeflbdo929zz2x','nluj6d1bey2yi6h', NULL, 'PLAYA SATURNO','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vy6ez97bi1lr098ca4x3s5lvbbm2tzwg39mn2xqnkajgygs9mf','BESO','nluj6d1bey2yi6h','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s83q80tm8ffmxamvczza7n6qxscq8nl961f6jeflbdo929zz2x', 'vy6ez97bi1lr098ca4x3s5lvbbm2tzwg39mn2xqnkajgygs9mf', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m2lt5iwck7l0nqi33w55jxl69ztom92do0xpb6ossuy98ytpjj','BABY HELLO','nluj6d1bey2yi6h','POP','21N77gfWYoQDvrLvaeiQgi','https://p.scdn.co/mp3-preview/561b48e3a4ed3c4c4d9fc3d12425198d31e98809?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s83q80tm8ffmxamvczza7n6qxscq8nl961f6jeflbdo929zz2x', 'm2lt5iwck7l0nqi33w55jxl69ztom92do0xpb6ossuy98ytpjj', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jlbfp66xvacfd7du9rap3777oyxj8kap5evv6hzyvkcv7sivux','Rauw Alejandro: Bzrp Music Sessions, Vol. 56','nluj6d1bey2yi6h','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s83q80tm8ffmxamvczza7n6qxscq8nl961f6jeflbdo929zz2x', 'jlbfp66xvacfd7du9rap3777oyxj8kap5evv6hzyvkcv7sivux', '2');
-- Jack Black
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('icfxavh6vmqciyi', 'Jack Black', '127@artist.com', 'https://i.scdn.co/image/ab6772690000c46ca156a562884cb76eeb0b75e9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:127@artist.com', 'icfxavh6vmqciyi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('icfxavh6vmqciyi', 'A beacon of innovation in the world of sound.', 'Jack Black');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6fsva2uarx5lj1dztksixypjwe0gi617rp54jgin7poadwjffu','icfxavh6vmqciyi', NULL, 'Jack Black Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bowyklirhn6foioep3h5e6zassyd9i1usn4jogt69dee362wzf','Peaches (from The Super Mario Bros. Movie)','icfxavh6vmqciyi','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6fsva2uarx5lj1dztksixypjwe0gi617rp54jgin7poadwjffu', 'bowyklirhn6foioep3h5e6zassyd9i1usn4jogt69dee362wzf', '0');
-- Lil Nas X
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ncwt1zmzltzgwto', 'Lil Nas X', '128@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd66f1e0c883f319443d68c45','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:128@artist.com', 'ncwt1zmzltzgwto', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ncwt1zmzltzgwto', 'A visionary in the world of music, redefining genres.', 'Lil Nas X');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6xleb5bvqgg3xfbopi7ykv9jns7c2ajptsw9lczab45gh6qbrm','ncwt1zmzltzgwto', 'https://i.scdn.co/image/ab67616d0000b27304cd9a1664fb4539a55643fe', 'STAR WALKIN (League of Legends Worlds Anthem)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1e0k10t7d6b9p15zwji369portcbh0qm3jrmxflrcodjiwpag8','STAR WALKIN (League of Legends Worlds Anthem)','ncwt1zmzltzgwto','POP','38T0tPVZHcPZyhtOcCP7pF','https://p.scdn.co/mp3-preview/ffa9d53ff1f83a322ac0523d7a6ce13b231e4a3a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6xleb5bvqgg3xfbopi7ykv9jns7c2ajptsw9lczab45gh6qbrm', '1e0k10t7d6b9p15zwji369portcbh0qm3jrmxflrcodjiwpag8', '0');
-- The Neighbourhood
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('czxrx65lg3v70x3', 'The Neighbourhood', '129@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf0b5ac84376a0a4b2166816','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:129@artist.com', 'czxrx65lg3v70x3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('czxrx65lg3v70x3', 'Melding alternative rock with introspective lyrics.', 'The Neighbourhood');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('604wdjdbr9jiglc4jnsic1c5l9gw1prbdx58743smo95fzp6sr','czxrx65lg3v70x3', 'https://i.scdn.co/image/ab67616d0000b2738265a736a1eb838ad5a0b921', 'I Love You.','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6ogxs19fbpajf2wu27ubot9ql9oj8s6fwuty6dv4mwy8ys9nej','Sweater Weather','czxrx65lg3v70x3','POP','2QjOHCTQ1Jl3zawyYOpxh6','https://p.scdn.co/mp3-preview/877602f424a9dea277b13301ffc516f9fd1fbe7e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('604wdjdbr9jiglc4jnsic1c5l9gw1prbdx58743smo95fzp6sr', '6ogxs19fbpajf2wu27ubot9ql9oj8s6fwuty6dv4mwy8ys9nej', '0');
-- JVKE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7scebejf3e7lnfa', 'JVKE', '130@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebce33386a81a202e149934ec1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:130@artist.com', '7scebejf3e7lnfa', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7scebejf3e7lnfa', 'A rising star, blending heartfelt lyrics with catchy pop melodies.', 'JVKE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('z31ypuza017hz5gml6gqvo5albl7l2tjqfb6wvg8wsehxo1xqj','7scebejf3e7lnfa', 'https://i.scdn.co/image/ab67616d0000b273c2504e80ba2f258697ab2954', 'this is what ____ feels like (Vol. 1-4)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xahljh2o0c9tieq0x2krwgy95ijn8tcwip7b1syy665nk88ud9','golden hour','7scebejf3e7lnfa','POP','5odlY52u43F5BjByhxg7wg','https://p.scdn.co/mp3-preview/bcc17f30841d6fbf3cd7954c3e3cf669f11b6a21?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z31ypuza017hz5gml6gqvo5albl7l2tjqfb6wvg8wsehxo1xqj', 'xahljh2o0c9tieq0x2krwgy95ijn8tcwip7b1syy665nk88ud9', '0');
-- Baby Tate
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('grmn7odur9dyv0m', 'Baby Tate', '131@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe7b0d119183e74ec390d7aec','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:131@artist.com', 'grmn7odur9dyv0m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('grmn7odur9dyv0m', 'A voice that echoes the sentiments of a generation.', 'Baby Tate');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('07mty22begveqo10zkbsc5xx0agwg59sgn26y10uqhybtrqt88','grmn7odur9dyv0m', 'https://i.scdn.co/image/ab67616d0000b2732571034f34b381958f8cc727', 'Hey, Mickey!','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xhyfvcbypjmo0gu107yasy8e7nypn1gukfw7fnb53kzywp0c8z','Hey, Mickey!','grmn7odur9dyv0m','POP','3RKjTYlQrtLXCq5ncswBPp','https://p.scdn.co/mp3-preview/2bfe39402bec233fbb5b2c06ffedbbf4d6fbc38a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('07mty22begveqo10zkbsc5xx0agwg59sgn26y10uqhybtrqt88', 'xhyfvcbypjmo0gu107yasy8e7nypn1gukfw7fnb53kzywp0c8z', '0');
-- Adele
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ukl0j4fwrzllsos', 'Adele', '132@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68f6e5892075d7f22615bd17','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:132@artist.com', 'ukl0j4fwrzllsos', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ukl0j4fwrzllsos', 'Delivering soul-stirring tunes that linger in the mind.', 'Adele');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ktve1ypqp7f5tprulcz1o620o86dvfz78hybdm0yq1p57tjo5o','ukl0j4fwrzllsos', 'https://i.scdn.co/image/ab67616d0000b2732118bf9b198b05a95ded6300', '21','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6hpye01uk6e63ruvv1u40ttvdb288s20a9gchvdcvjw0vemdo7','Set Fire to the Rain','ukl0j4fwrzllsos','POP','73CMRj62VK8nUS4ezD2wvi','https://p.scdn.co/mp3-preview/6fc68c105e091645376471727960d2ba3cd0ee01?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ktve1ypqp7f5tprulcz1o620o86dvfz78hybdm0yq1p57tjo5o', '6hpye01uk6e63ruvv1u40ttvdb288s20a9gchvdcvjw0vemdo7', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uz0fbuvp6m8f9thhkth9uvawst0yyckk33rxk26xfqlxlgvnlf','Easy On Me','ukl0j4fwrzllsos','POP','46IZ0fSY2mpAiktS3KOqds','https://p.scdn.co/mp3-preview/a0cd8077c79a4aa3dcaa68bbc5ecdeda46e8d13f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ktve1ypqp7f5tprulcz1o620o86dvfz78hybdm0yq1p57tjo5o', 'uz0fbuvp6m8f9thhkth9uvawst0yyckk33rxk26xfqlxlgvnlf', '1');
-- Bomba Estreo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5m46kuwsumj0i6n', 'Bomba Estreo', '133@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcc4d7c642f167846d8aa743b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:133@artist.com', '5m46kuwsumj0i6n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5m46kuwsumj0i6n', 'Pushing the boundaries of sound with each note.', 'Bomba Estreo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fv7r0aodhv7caxfv55z0idpw8bbpz34l9m1gc4rt0lxzmoys82','5m46kuwsumj0i6n', NULL, 'Bomba Estreo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lggyggukkfu6l6k17isaz0ckx2g48dugr2pmwpffteo6jpx4nw','Ojitos Lindos','5m46kuwsumj0i6n','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fv7r0aodhv7caxfv55z0idpw8bbpz34l9m1gc4rt0lxzmoys82', 'lggyggukkfu6l6k17isaz0ckx2g48dugr2pmwpffteo6jpx4nw', '0');
-- James Arthur
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c8rwfjy374kj0bk', 'James Arthur', '134@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2a0c6d0343c82be9dd6fce0b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:134@artist.com', 'c8rwfjy374kj0bk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c8rwfjy374kj0bk', 'Crafting melodies that resonate with the soul.', 'James Arthur');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g3ewevdqtqlfd18bbduwfn2bzo4rh8182warsk96s4u8b5yf4g','c8rwfjy374kj0bk', 'https://i.scdn.co/image/ab67616d0000b273dc16d839ab77c64bdbeb3660', 'YOU','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gpxuil42v3ws5mn02nkwsymz56a7btyo0dw40ee0tbxj91sd20','Cars Outside','c8rwfjy374kj0bk','POP','0otRX6Z89qKkHkQ9OqJpKt','https://p.scdn.co/mp3-preview/cfaa30729da8d2d8965fae154b6e9d0964a2ea6b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g3ewevdqtqlfd18bbduwfn2bzo4rh8182warsk96s4u8b5yf4g', 'gpxuil42v3ws5mn02nkwsymz56a7btyo0dw40ee0tbxj91sd20', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xjq0fgo5w0919whjg7k8dj5q2r16yauqk67zn4u3p4so08zp7z','Say You Wont Let Go','c8rwfjy374kj0bk','POP','5uCax9HTNlzGybIStD3vDh','https://p.scdn.co/mp3-preview/2eed95a3c08cd10669768ce60d1140f85ba8b951?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g3ewevdqtqlfd18bbduwfn2bzo4rh8182warsk96s4u8b5yf4g', 'xjq0fgo5w0919whjg7k8dj5q2r16yauqk67zn4u3p4so08zp7z', '1');
-- Ruth B.
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ga8odvkxuf92kpm', 'Ruth B.', '135@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1da7ba1c178ab9f68d065197','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:135@artist.com', 'ga8odvkxuf92kpm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ga8odvkxuf92kpm', 'A visionary in the world of music, redefining genres.', 'Ruth B.');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5jrv8o44ixdlgxpw6uxxi9ecywtzyi7oii0ew9mggu0byrogde','ga8odvkxuf92kpm', 'https://i.scdn.co/image/ab67616d0000b27397e971f3e53475091dc8d707', 'Safe Haven','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8qfg35pmk7kj715z05iuurfx5siwess0c43rbt8xj88i07ym3a','Dandelions','ga8odvkxuf92kpm','POP','2eAvDnpXP5W0cVtiI0PUxV','https://p.scdn.co/mp3-preview/3e55602bc286bc1fad9347931327e649ff9adfa1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5jrv8o44ixdlgxpw6uxxi9ecywtzyi7oii0ew9mggu0byrogde', '8qfg35pmk7kj715z05iuurfx5siwess0c43rbt8xj88i07ym3a', '0');
-- Vance Joy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h55g2xtpftunzip', 'Vance Joy', '136@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f074ec8c25406680bf26422','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:136@artist.com', 'h55g2xtpftunzip', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h55g2xtpftunzip', 'Crafting folk-pop anthems that resonate with heartfelt sincerity.', 'Vance Joy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('obe6bl50y05wjrg7awf0wb689r2ajm9qmm6wq3wc67robl7967','h55g2xtpftunzip', 'https://i.scdn.co/image/ab67616d0000b273a9929deb093a6617d2493b03', 'Dream Your Life Away (Special Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fpfir1jobru2ah0d9fik4toq9witifssftqtntvbnm84gyexpn','Riptide','h55g2xtpftunzip','POP','3JvrhDOgAt6p7K8mDyZwRd','https://p.scdn.co/mp3-preview/74698d907d114f4ba0b2c129bbf260724be80b64?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('obe6bl50y05wjrg7awf0wb689r2ajm9qmm6wq3wc67robl7967', 'fpfir1jobru2ah0d9fik4toq9witifssftqtntvbnm84gyexpn', '0');
-- Don Omar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('29z4yrjf2r6pj5e', 'Don Omar', '137@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:137@artist.com', '29z4yrjf2r6pj5e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('29z4yrjf2r6pj5e', 'Crafting a unique sonic identity in every track.', 'Don Omar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5bnoekjrs4zpx49d65cnei5w0irlq8gyt3nr5bhwi4r28a3q8n','29z4yrjf2r6pj5e', 'https://i.scdn.co/image/ab67616d0000b2734640a26eb27649006be29a94', 'Meet The Orphans','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ma3wpnd5eko5js51uiyocn3p26eyb0ywgxhc6984mcjlt6nmpp','Danza Kuduro','29z4yrjf2r6pj5e','POP','2a1o6ZejUi8U3wzzOtCOYw',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5bnoekjrs4zpx49d65cnei5w0irlq8gyt3nr5bhwi4r28a3q8n', 'ma3wpnd5eko5js51uiyocn3p26eyb0ywgxhc6984mcjlt6nmpp', '0');
-- Dua Lipa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5nre7seq37a19mn', 'Dua Lipa', '138@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb6fff4b133bd150337490935','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:138@artist.com', '5nre7seq37a19mn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5nre7seq37a19mn', 'A pop phenomenon, known for her empowering anthems and dynamic presence.', 'Dua Lipa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kiyzy1ey1coqskqrjd77bsvofiuspnaxx3wo9q9tz2jbbmgnan','5nre7seq37a19mn', 'https://i.scdn.co/image/ab67616d0000b2737dd3ba455ee3390cb55b0192', 'Dance The Night (From Barbie The Album)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7shs0hyqa9s22nnk67m6yii03ezvt8w5wjhgzjgw99ya0dv8c3','Dance The Night (From Barbie The Album)','5nre7seq37a19mn','POP','1vYXt7VSjH9JIM5oRRo7vA','https://p.scdn.co/mp3-preview/acaea048f50a3b30ca24b348c84a6047373baabb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kiyzy1ey1coqskqrjd77bsvofiuspnaxx3wo9q9tz2jbbmgnan', '7shs0hyqa9s22nnk67m6yii03ezvt8w5wjhgzjgw99ya0dv8c3', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('32wg8iz6fn5g9zwrbv3g36ocn29ri4xakrlajn7clb2i3lqhh0','Cold Heart - PNAU Remix','5nre7seq37a19mn','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kiyzy1ey1coqskqrjd77bsvofiuspnaxx3wo9q9tz2jbbmgnan', '32wg8iz6fn5g9zwrbv3g36ocn29ri4xakrlajn7clb2i3lqhh0', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('613iw3xsdsbqgj843lzxc08l929gml06rw20bq3wnvrhgxrgku','Dont Start Now','5nre7seq37a19mn','POP','5OTdAwTZqmHfmate5zPJ1E','https://p.scdn.co/mp3-preview/cfc6684fc467e40bb9c7e6da2ea1b22eeccb211c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kiyzy1ey1coqskqrjd77bsvofiuspnaxx3wo9q9tz2jbbmgnan', '613iw3xsdsbqgj843lzxc08l929gml06rw20bq3wnvrhgxrgku', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8csg61d7itqo996nf5p8pfeep2rrld6rw7hbwnps8rlu4k1kkq','Levitating (feat. DaBaby)','5nre7seq37a19mn','POP','5nujrmhLynf4yMoMtj8AQF','https://p.scdn.co/mp3-preview/6af6db91dba9103cca41d6d5225f6fe120fcfcd3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kiyzy1ey1coqskqrjd77bsvofiuspnaxx3wo9q9tz2jbbmgnan', '8csg61d7itqo996nf5p8pfeep2rrld6rw7hbwnps8rlu4k1kkq', '3');
-- Zach Bryan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wi9wtrnmn2hrxho', 'Zach Bryan', '139@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4fd54df35bfcfa0fc9fc2da7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:139@artist.com', 'wi9wtrnmn2hrxho', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wi9wtrnmn2hrxho', 'A journey through the spectrum of sound in every album.', 'Zach Bryan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ieqohm1oy697sdn9hjasjab28quoxbqtf268vzcxp2agt2fm8p','wi9wtrnmn2hrxho', 'https://i.scdn.co/image/ab67616d0000b273b2b6670e3aca9bcd55fbabbb', 'Something in the Orange','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m3wezlwozuogq9i6sub1ex1oe6ka1r7ppmrfw3sre4jd2k7ff7','Something in the Orange','wi9wtrnmn2hrxho','POP','3WMj8moIAXJhHsyLaqIIHI','https://p.scdn.co/mp3-preview/d33dc9df586e24c9d8f640df08b776d94680f529?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ieqohm1oy697sdn9hjasjab28quoxbqtf268vzcxp2agt2fm8p', 'm3wezlwozuogq9i6sub1ex1oe6ka1r7ppmrfw3sre4jd2k7ff7', '0');
-- Gabito Ballesteros
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9g31tq86afrvsnr', 'Gabito Ballesteros', '140@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1f256a76f868b8f595f729d5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:140@artist.com', '9g31tq86afrvsnr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9g31tq86afrvsnr', 'A vibrant force in the music scene, infusing every performance with passion.', 'Gabito Ballesteros');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t7y3x9wt9awcyx2ov8bwkoqrj6xvcq2vturouc6zimq98lw9wx','9g31tq86afrvsnr', NULL, 'Gabito Ballesteros Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ivr3bpzexg3mtsqbrrpetpr4rqjmnpp8htcixn9wsgejw0yfdm','LADY GAGA','9g31tq86afrvsnr','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t7y3x9wt9awcyx2ov8bwkoqrj6xvcq2vturouc6zimq98lw9wx', 'ivr3bpzexg3mtsqbrrpetpr4rqjmnpp8htcixn9wsgejw0yfdm', '0');
-- Hotel Ugly
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s30fcni8wlohtmo', 'Hotel Ugly', '141@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb939033cc36c08ab68b33f760','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:141@artist.com', 's30fcni8wlohtmo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s30fcni8wlohtmo', 'Pushing the boundaries of sound with each note.', 'Hotel Ugly');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wy21uck20eqpf8zm3vxnmeioagscgszqqfiuvn0nzl5m28i1q8','s30fcni8wlohtmo', 'https://i.scdn.co/image/ab67616d0000b273350ab7a839c04bfd5225a9f5', 'Shut up My Moms Calling','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nzp0ucrd8yi8mrt41xyv9elpbikemqz1yuzprdvfyylr6h9ony','Shut up My Moms Calling','s30fcni8wlohtmo','POP','3hxIUxnT27p5WcmjGUXNwx','https://p.scdn.co/mp3-preview/7642409265c74b714a2f0f0dd8663c031e253485?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wy21uck20eqpf8zm3vxnmeioagscgszqqfiuvn0nzl5m28i1q8', 'nzp0ucrd8yi8mrt41xyv9elpbikemqz1yuzprdvfyylr6h9ony', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7jss8ilxg4r9lemzzqq56pyex52xywf14sjqoagz78wizfvltu','Shut up My Moms Calling - (Sped Up)','s30fcni8wlohtmo','POP','31mzt4ZV8C0f52pIz1NSwd','https://p.scdn.co/mp3-preview/4417d6fbf78b2a96b067dc092f888178b155b6b7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wy21uck20eqpf8zm3vxnmeioagscgszqqfiuvn0nzl5m28i1q8', '7jss8ilxg4r9lemzzqq56pyex52xywf14sjqoagz78wizfvltu', '1');
-- Oscar Maydon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vn70a68s8ahs4ig', 'Oscar Maydon', '142@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8920adf64930d6f26e34b7c4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:142@artist.com', 'vn70a68s8ahs4ig', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vn70a68s8ahs4ig', 'Crafting soundscapes that transport listeners to another world.', 'Oscar Maydon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('r39rl7cek1tc5ewpb751jfo3mdm1w60jt55kfe8vsbhdt9q97y','vn70a68s8ahs4ig', 'https://i.scdn.co/image/ab67616d0000b2739b7e1ea3815a172019bc5e56', 'Fin de Semana','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('be6ijatxnlnml934xrxm0x4plr8w0a1s9qctbhhazrhgipgw9e','Fin de Semana','vn70a68s8ahs4ig','POP','6TBzRwnX2oYd8aOrOuyK1p','https://p.scdn.co/mp3-preview/71ee8bdc0a34790ad549ba750665808f08f5e46b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r39rl7cek1tc5ewpb751jfo3mdm1w60jt55kfe8vsbhdt9q97y', 'be6ijatxnlnml934xrxm0x4plr8w0a1s9qctbhhazrhgipgw9e', '0');
-- PinkPantheress
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6f0m8bd3xtrs9ch', 'PinkPantheress', '143@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb90ddbcd825c7b6142d269e26','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:143@artist.com', '6f0m8bd3xtrs9ch', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6f0m8bd3xtrs9ch', 'Redefining pop music with her distinct sound and style.', 'PinkPantheress');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6r2bki5e0tpwqxva38wd4uaa3exihpyy9m6yc68it1uwzzh74g','6f0m8bd3xtrs9ch', 'https://i.scdn.co/image/ab67616d0000b2739567e1aa41657425d046733b', 'Boys a liar Pt. 2','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kik0v1zm4gek1hhzluu06pvh2i0wk0hx944ipckntkbh56qk6n','Boys a liar Pt. 2','6f0m8bd3xtrs9ch','POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6r2bki5e0tpwqxva38wd4uaa3exihpyy9m6yc68it1uwzzh74g', 'kik0v1zm4gek1hhzluu06pvh2i0wk0hx944ipckntkbh56qk6n', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7xo91ulb27qmdoc7n2nt2l32qzqcvtmd4qs6aojebmpfv2v5y0','Boys a liar','6f0m8bd3xtrs9ch','POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6r2bki5e0tpwqxva38wd4uaa3exihpyy9m6yc68it1uwzzh74g', '7xo91ulb27qmdoc7n2nt2l32qzqcvtmd4qs6aojebmpfv2v5y0', '1');
-- Rma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ogwtufnzon354e4', 'Rma', '144@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7952358e33599027ae3c7f37','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:144@artist.com', 'ogwtufnzon354e4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ogwtufnzon354e4', 'Pioneering new sounds and delivering electrifying performances.', 'Rma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jb3sc0xtwo2nfjq5jrrkoz30tbfs0i1d6i1uevlxz8ugstri3i','ogwtufnzon354e4', NULL, 'Rma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ke8pwfsldpih98qsxwlvepk7yuur7bstqi0uihv1phkc35v8q7','Calm Down (with Selena Gomez)','ogwtufnzon354e4','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jb3sc0xtwo2nfjq5jrrkoz30tbfs0i1d6i1uevlxz8ugstri3i', 'ke8pwfsldpih98qsxwlvepk7yuur7bstqi0uihv1phkc35v8q7', '0');
-- Gorillaz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('unyxn65zxdujz9b', 'Gorillaz', '145@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb337d671a32b2f44d4a4e6cf2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:145@artist.com', 'unyxn65zxdujz9b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('unyxn65zxdujz9b', 'A journey through the spectrum of sound in every album.', 'Gorillaz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jmkvkbdb70l8qyrre81pv05u0ei0bfk9duypqoa25yka33wud4','unyxn65zxdujz9b', 'https://i.scdn.co/image/ab67616d0000b2734b0ddebba0d5b34f2a2f07a4', 'Cracker Island','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hs5hz3cc58c5w7czoo2nwbs8ydas3oebdx7ws4zf3eljrw0gtx','Tormenta (feat. Bad Bunny)','unyxn65zxdujz9b','POP','38UYeBLfvpnDSG9GznZdnL','https://p.scdn.co/mp3-preview/3f89a1c3ec527e23fdefdd03da7797b83eb6e14f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jmkvkbdb70l8qyrre81pv05u0ei0bfk9duypqoa25yka33wud4', 'hs5hz3cc58c5w7czoo2nwbs8ydas3oebdx7ws4zf3eljrw0gtx', '0');
-- Feid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gym8zkzu55yefni', 'Feid', '146@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9e7c05016af970bb9bf76cc1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:146@artist.com', 'gym8zkzu55yefni', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gym8zkzu55yefni', 'A standout artist in urban Latin music, known for his catchy melodies and smooth vocals.', 'Feid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g9lhkcb61fft5u58luaq0s7jiyrwl9cwrzbx4jb5ojp90w8vvt','gym8zkzu55yefni', 'https://i.scdn.co/image/ab67616d0000b27329ebee2b5fb008871fcd201a', 'CLASSY 101','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('40vqzb0n5imu8221n7u3v3g4qitppm3f3kr60hdwcb87j4xgjr','Classy 101','gym8zkzu55yefni','POP','6XSqqQIy7Lm7SnwxS4NrGx',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g9lhkcb61fft5u58luaq0s7jiyrwl9cwrzbx4jb5ojp90w8vvt', '40vqzb0n5imu8221n7u3v3g4qitppm3f3kr60hdwcb87j4xgjr', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1c5e2ggicjjrgfa4bje2e773xjbx9e7hdi8l3vjx0jenhfsh37','El Cielo','gym8zkzu55yefni','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g9lhkcb61fft5u58luaq0s7jiyrwl9cwrzbx4jb5ojp90w8vvt', '1c5e2ggicjjrgfa4bje2e773xjbx9e7hdi8l3vjx0jenhfsh37', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('opxna33wo1o7jc1k6h705eoihlpketh54k4uzwu6uca23wdlvb','Feliz Cumpleaos Fe','gym8zkzu55yefni','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g9lhkcb61fft5u58luaq0s7jiyrwl9cwrzbx4jb5ojp90w8vvt', 'opxna33wo1o7jc1k6h705eoihlpketh54k4uzwu6uca23wdlvb', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uzjaxfbck3uwwok1slvi01plthxq5momkz4qvdk8nme52goknl','POLARIS - Remix','gym8zkzu55yefni','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g9lhkcb61fft5u58luaq0s7jiyrwl9cwrzbx4jb5ojp90w8vvt', 'uzjaxfbck3uwwok1slvi01plthxq5momkz4qvdk8nme52goknl', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('arxzti8thqs3tpxahv7sbst7t7pkfcv84bqde2fq8zrduxnkjo','CHORRITO PA LAS ANIMAS','gym8zkzu55yefni','POP','0CYTGMBYkwUxrj1MWDLrC5',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g9lhkcb61fft5u58luaq0s7jiyrwl9cwrzbx4jb5ojp90w8vvt', 'arxzti8thqs3tpxahv7sbst7t7pkfcv84bqde2fq8zrduxnkjo', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ms2v5jdeybyfqilihst9i3q3r2c2t4chw9drkvu6uzglwd249y','Normal','gym8zkzu55yefni','POP','0T2pB7P1VdXPhLdQZ488uH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g9lhkcb61fft5u58luaq0s7jiyrwl9cwrzbx4jb5ojp90w8vvt', 'ms2v5jdeybyfqilihst9i3q3r2c2t4chw9drkvu6uzglwd249y', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yjntgxrzfvzw9pip46vj0w71y3ynqrymcy881ax0sbots457m6','REMIX EXCLUSIVO','gym8zkzu55yefni','POP','3eqCJfgJJs8iKx49KO12s3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g9lhkcb61fft5u58luaq0s7jiyrwl9cwrzbx4jb5ojp90w8vvt', 'yjntgxrzfvzw9pip46vj0w71y3ynqrymcy881ax0sbots457m6', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z8tfb22mgykmkrkxn5v6au6lc3is0wapl834r1rqrv4xipryuj','LA INOCENTE','gym8zkzu55yefni','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g9lhkcb61fft5u58luaq0s7jiyrwl9cwrzbx4jb5ojp90w8vvt', 'z8tfb22mgykmkrkxn5v6au6lc3is0wapl834r1rqrv4xipryuj', '7');
-- Gunna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fzfbokzt3ar7hf9', 'Gunna', '147@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6501f8a7d50c56e86e46f920','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:147@artist.com', 'fzfbokzt3ar7hf9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fzfbokzt3ar7hf9', 'A trailblazer in trap music, known for his smooth flow and catchy beats.', 'Gunna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x5qzfo1m8e2tozgmvdp8b86iei745oplkctxz69g8r8nr2asvz','fzfbokzt3ar7hf9', 'https://i.scdn.co/image/ab67616d0000b273017d5e26552345c4b1575b6c', 'a Gift & a Curse','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6coqepqzlylh6eruosdkub6otzskhym6842rq1zitorcx88xrm','fukumean','fzfbokzt3ar7hf9','POP','4rXLjWdF2ZZpXCVTfWcshS','https://p.scdn.co/mp3-preview/f237ab921af697ba9b49e12fa167c2ce1a82d6b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x5qzfo1m8e2tozgmvdp8b86iei745oplkctxz69g8r8nr2asvz', '6coqepqzlylh6eruosdkub6otzskhym6842rq1zitorcx88xrm', '0');
-- Lizzy McAlpine
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9o34rtb5ga820xl', 'Lizzy McAlpine', '148@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb10e2b618880f429a3967185','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:148@artist.com', '9o34rtb5ga820xl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9o34rtb5ga820xl', 'A symphony of emotions expressed through sound.', 'Lizzy McAlpine');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mkp4lrqagjjgln5stdx7rl76oygdq1y3jy86a2mbtqcgtlkgsn','9o34rtb5ga820xl', 'https://i.scdn.co/image/ab67616d0000b273d370fdc4dbc47778b9b667c3', 'five seconds flat','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n5os43nzcy0oc26831fxznlr81uy1y80j8kyl3e3ifw2536m09','ceilings','9o34rtb5ga820xl','POP','2L9N0zZnd37dwF0clgxMGI','https://p.scdn.co/mp3-preview/580782ffb17d468fe5d000bdf86cc07926ff9a5a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mkp4lrqagjjgln5stdx7rl76oygdq1y3jy86a2mbtqcgtlkgsn', 'n5os43nzcy0oc26831fxznlr81uy1y80j8kyl3e3ifw2536m09', '0');
-- Myke Towers
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6wkeeh910mgw7t8', 'Myke Towers', '149@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9e35c3c5de877f99a8f6192f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:149@artist.com', '6wkeeh910mgw7t8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6wkeeh910mgw7t8', 'A rising star in Latin music, known for his distinctive flow.', 'Myke Towers');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dn1z437g9okpijmgqi40tas5c2liq2gkin5qdgvgdn63e9zxk1','6wkeeh910mgw7t8', 'https://i.scdn.co/image/ab67616d0000b2730656d5ce813ca3cc4b677e05', 'LA VIDA ES UNA','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u7hi3w1ajizbl7gbtkacznqvaw1xxjrpv04yv1kf4prlzgteho','LALA','6wkeeh910mgw7t8','POP','7ABLbnD53cQK00mhcaOUVG','https://p.scdn.co/mp3-preview/42772b16b4e575d1b15b0ec7f94e335539390d2d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dn1z437g9okpijmgqi40tas5c2liq2gkin5qdgvgdn63e9zxk1', 'u7hi3w1ajizbl7gbtkacznqvaw1xxjrpv04yv1kf4prlzgteho', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nqexfp0abld4hozzjaeksaf7zb28ynwc1q5yxnfvzukdtz9xwl','PLAYA DEL INGL','6wkeeh910mgw7t8','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dn1z437g9okpijmgqi40tas5c2liq2gkin5qdgvgdn63e9zxk1', 'nqexfp0abld4hozzjaeksaf7zb28ynwc1q5yxnfvzukdtz9xwl', '1');
-- Bizarrap
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bszohgptmu45r3h', 'Bizarrap', '150@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb14add0d3419426b84158b913','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:150@artist.com', 'bszohgptmu45r3h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bszohgptmu45r3h', 'Revolutionizing the music scene with his unique production style and collaborations.', 'Bizarrap');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dlgoad7ofcl6h4zx349dx5m2anpfbackejaj2yf4xk59jdy11z','bszohgptmu45r3h', 'https://i.scdn.co/image/ab67616d0000b27315583045b2fdb7d7bab10e81', 'Peso Pluma: Bzrp Music Sessions, Vol. 55','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gpik5z6a3q3m1b1l7kzg2ye7lzcesvc5y1woprb9d0tezdcqpz','Peso Pluma: Bzrp Music Sessions, Vol. 55','bszohgptmu45r3h','POP','5AqiaZwhmC6dIbgWrD5SzV','https://p.scdn.co/mp3-preview/9d61998a29c2e8b52a7d46885352f5507eb219e2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dlgoad7ofcl6h4zx349dx5m2anpfbackejaj2yf4xk59jdy11z', 'gpik5z6a3q3m1b1l7kzg2ye7lzcesvc5y1woprb9d0tezdcqpz', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t5p1bdqwrtpp7eo0pwjyuuzd77ql6bamo9t1h7zm7ujou2h3xw','Quevedo: Bzrp Music Sessions, Vol. 52','bszohgptmu45r3h','POP','2tTmW7RDtMQtBk7m2rYeSw','https://p.scdn.co/mp3-preview/e9c0ed735e611f6af45bc946bd4c31590df09ed6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dlgoad7ofcl6h4zx349dx5m2anpfbackejaj2yf4xk59jdy11z', 't5p1bdqwrtpp7eo0pwjyuuzd77ql6bamo9t1h7zm7ujou2h3xw', '1');
-- a-ha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9ysjr4bpvn19e9w', 'a-ha', '151@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0168ba8148c07c2cdeb7d067','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:151@artist.com', '9ysjr4bpvn19e9w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9ysjr4bpvn19e9w', 'Music is my canvas, and notes are my paint.', 'a-ha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d0o8zza3r8rxf4e9xmpunzg03tz36rthd8n6llzxw24fhw03wq','9ysjr4bpvn19e9w', 'https://i.scdn.co/image/ab67616d0000b273e8dd4db47e7177c63b0b7d53', 'Hunting High and Low','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oxxipvicyj7iryve4ufv8iqmycv6wvs6twpc6rb33hoyqv9agx','Take On Me','9ysjr4bpvn19e9w','POP','2WfaOiMkCvy7F5fcp2zZ8L','https://p.scdn.co/mp3-preview/ed66a8c444c35b2f5029c04ae8e18f69d952c2bb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d0o8zza3r8rxf4e9xmpunzg03tz36rthd8n6llzxw24fhw03wq', 'oxxipvicyj7iryve4ufv8iqmycv6wvs6twpc6rb33hoyqv9agx', '0');
-- Bebe Rexha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zxblkz9drvrc9q2', 'Bebe Rexha', '152@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc692afc666512dc946a7358f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:152@artist.com', 'zxblkz9drvrc9q2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zxblkz9drvrc9q2', 'A dynamic voice in pop music, known for her powerful vocals and catchy tunes.', 'Bebe Rexha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dfbb8sjgzaezcdj1nggxz07cwdz160dj65mf7l6mhqp4bxgvht','zxblkz9drvrc9q2', NULL, 'Bebe Rexha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yjbvsc8rx30fthgy3n85hbfjqkj5ydml3lb3q1wicxjj87mnaj','Im Good (Blue)','zxblkz9drvrc9q2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dfbb8sjgzaezcdj1nggxz07cwdz160dj65mf7l6mhqp4bxgvht', 'yjbvsc8rx30fthgy3n85hbfjqkj5ydml3lb3q1wicxjj87mnaj', '0');
-- BLESSD
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('67d0iccglbwdeib', 'BLESSD', '153@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb261b09aa72e689605bb96758','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:153@artist.com', '67d0iccglbwdeib', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('67d0iccglbwdeib', 'A harmonious blend of passion and creativity.', 'BLESSD');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3i44shypp206e4c3twkbjbdkbt1ccd9qzzhpmty14xhqrz2n6d','67d0iccglbwdeib', NULL, 'BLESSD Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7i6ftzooiclja2cn0focim7egv62rfd2jpib3betbv7v45mz1j','Las Morras','67d0iccglbwdeib','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3i44shypp206e4c3twkbjbdkbt1ccd9qzzhpmty14xhqrz2n6d', '7i6ftzooiclja2cn0focim7egv62rfd2jpib3betbv7v45mz1j', '0');
-- NLE Choppa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4xom9gb6k2vt6t4', 'NLE Choppa', '154@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcc5865053e7177aeb0c26b62','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:154@artist.com', '4xom9gb6k2vt6t4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4xom9gb6k2vt6t4', 'A unique voice in the contemporary music scene.', 'NLE Choppa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fiab929ju3o3vw4c5c9kqhd5a5kqe5wxbhbum1g8vacv4pyjxq','4xom9gb6k2vt6t4', 'https://i.scdn.co/image/ab67616d0000b27349a4f6c9a637e02252a0076d', 'SLUT ME OUT','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pshcufoapzlt4fua6s4wzclmkke5jblax3xxseeyh1mnbyunug','Slut Me Out','4xom9gb6k2vt6t4','POP','5BmB3OaQyYXCqRyN8iR2Yi','https://p.scdn.co/mp3-preview/84ef49a1e71bdac04b7dfb1dea3a56d1ffc50357?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fiab929ju3o3vw4c5c9kqhd5a5kqe5wxbhbum1g8vacv4pyjxq', 'pshcufoapzlt4fua6s4wzclmkke5jblax3xxseeyh1mnbyunug', '0');
-- Lana Del Rey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ajfi6w20ya4s1tq', 'Lana Del Rey', '155@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb99cacf8acd5378206767261','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:155@artist.com', 'ajfi6w20ya4s1tq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ajfi6w20ya4s1tq', 'An ethereal presence in music, known for her cinematic and nostalgic sound.', 'Lana Del Rey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('py7gmtf0rt7y82sod740rnvx7l9vzgwz47ohgi3ot3vfd7538v','ajfi6w20ya4s1tq', 'https://i.scdn.co/image/ab67616d0000b273aa27708d07f49c82ff0d0dae', 'Say Yes To Heaven','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zgypty2k2irhfnzpuloypdn2w512ebi98rouzyeqwugpyv17gl','Say Yes To Heaven','ajfi6w20ya4s1tq','POP','6GGtHZgBycCgGBUhZo81xe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('py7gmtf0rt7y82sod740rnvx7l9vzgwz47ohgi3ot3vfd7538v', 'zgypty2k2irhfnzpuloypdn2w512ebi98rouzyeqwugpyv17gl', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3uwtmzb9dfzbgm0jflqrx92wxthnoq96sy7nnv4b3gy2i5guhd','Summertime Sadness','ajfi6w20ya4s1tq','POP','1Ist6PR2BZR3n2z2Y5R6S1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('py7gmtf0rt7y82sod740rnvx7l9vzgwz47ohgi3ot3vfd7538v', '3uwtmzb9dfzbgm0jflqrx92wxthnoq96sy7nnv4b3gy2i5guhd', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zy8ce5rsm6scbg17j84eghyyj1e4l41bxp5cegxhzq4juvnaqb','Radio','ajfi6w20ya4s1tq','POP','3QhfFRPkhPCR1RMJWV1gde',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('py7gmtf0rt7y82sod740rnvx7l9vzgwz47ohgi3ot3vfd7538v', 'zy8ce5rsm6scbg17j84eghyyj1e4l41bxp5cegxhzq4juvnaqb', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d2oi42lkfw0tala4bdr4ffojru4xom3607lqr12h3l7hml37jb','Snow On The Beach (feat. More Lana Del Rey)','ajfi6w20ya4s1tq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('py7gmtf0rt7y82sod740rnvx7l9vzgwz47ohgi3ot3vfd7538v', 'd2oi42lkfw0tala4bdr4ffojru4xom3607lqr12h3l7hml37jb', '3');
-- J Balvin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bqaaotveqp485pc', 'J Balvin', '156@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5edc80e125ca7b4e0e4cf1b0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:156@artist.com', 'bqaaotveqp485pc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bqaaotveqp485pc', 'Blending traditional rhythms with modern beats.', 'J Balvin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yidrdiii0xiqt9im34g7nfr8crcxmv9noa68xff7lz50qp169m','bqaaotveqp485pc', 'https://i.scdn.co/image/ab67616d0000b2734891d9b25d8919448388f3bb', 'OASIS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cijp7d16q92cetmqzsa0ytppemyxmq63lb4jkwkjk4t2dtkskk','LA CANCI','bqaaotveqp485pc','POP','0fea68AdmYNygeTGI4RC18',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yidrdiii0xiqt9im34g7nfr8crcxmv9noa68xff7lz50qp169m', 'cijp7d16q92cetmqzsa0ytppemyxmq63lb4jkwkjk4t2dtkskk', '0');
-- Hozier
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9zaqu5bzv85088j', 'Hozier', '157@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad85a585103dfc2f3439119a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:157@artist.com', '9zaqu5bzv85088j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9zaqu5bzv85088j', 'A sonic adventurer, always seeking new horizons in music.', 'Hozier');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('izhp1px87q0i7uipd6laj1d1b3jjqcpbaz0p43r34voagzzd8y','9zaqu5bzv85088j', 'https://i.scdn.co/image/ab67616d0000b2734ca68d59a4a29c856a4a39c2', 'Hozier (Expanded Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hfc4qmg38wtyol9c3uyvh6mvxqyqccqzyn5llswgvmh8ubq3mx','Take Me To Church','9zaqu5bzv85088j','POP','1CS7Sd1u5tWkstBhpssyjP','https://p.scdn.co/mp3-preview/d6170162e349338277c97d2fab42c386701a4089?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('izhp1px87q0i7uipd6laj1d1b3jjqcpbaz0p43r34voagzzd8y', 'hfc4qmg38wtyol9c3uyvh6mvxqyqccqzyn5llswgvmh8ubq3mx', '0');
-- Yng Lvcas
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zzsfa1pfira8hh2', 'Yng Lvcas', '158@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:158@artist.com', 'zzsfa1pfira8hh2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zzsfa1pfira8hh2', 'Igniting the stage with electrifying performances.', 'Yng Lvcas');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('37jok7iv4wl3y3g4xg0159uo63nhe447htqgw0vsdm7k2su60g','zzsfa1pfira8hh2', 'https://i.scdn.co/image/ab67616d0000b273a04be3ad7c8c67f4109111a9', 'La Bebe (Remix)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qu77g8sg72jlftl86px5s2hj9eganz4kypkhdanot3d0ql56mv','La Bebe','zzsfa1pfira8hh2','POP','2UW7JaomAMuX9pZrjVpHAU','https://p.scdn.co/mp3-preview/57c5d5266219b32d455ed22417155bbabde7170f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('37jok7iv4wl3y3g4xg0159uo63nhe447htqgw0vsdm7k2su60g', 'qu77g8sg72jlftl86px5s2hj9eganz4kypkhdanot3d0ql56mv', '0');
-- (G)I-DLE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3hjf8ojai2c7c62', '(G)I-DLE', '159@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8abd5f97fc52561939ebbc89','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:159@artist.com', '3hjf8ojai2c7c62', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3hjf8ojai2c7c62', 'Pushing the boundaries of sound with each note.', '(G)I-DLE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bggazp5fy1ea8ta0vw3vkf7agraj2kmwmdu8ik937scxbjtywg','3hjf8ojai2c7c62', 'https://i.scdn.co/image/ab67616d0000b27382dd2427e6d302711b1b9616', 'I feel','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e6bjuzifnhtu368wzg33btpf74muuvrgesnesmmb0hk35u3nvp','Queencard','3hjf8ojai2c7c62','POP','4uOBL4DDWWVx4RhYKlPbPC','https://p.scdn.co/mp3-preview/9f36e86bca0911d3f849197e8f531b9d0c34f002?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bggazp5fy1ea8ta0vw3vkf7agraj2kmwmdu8ik937scxbjtywg', 'e6bjuzifnhtu368wzg33btpf74muuvrgesnesmmb0hk35u3nvp', '0');
-- Ariana Grande
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9dkxl9jv60s48n0', 'Ariana Grande', '160@artist.com', 'https://i.scdn.co/image/ab67616d0000b273a40e82a624fd71db16151256','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:160@artist.com', '9dkxl9jv60s48n0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9dkxl9jv60s48n0', 'A powerhouse vocalist, dominating pop with her range and iconic style.', 'Ariana Grande');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y59thv4ayi5odykt1zlmeyz0eiftliatib75wo3s7knvlaxetk','9dkxl9jv60s48n0', NULL, 'Santa Tell Me','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('litxgo6zaie59cy27azfg9w93bf6wwztjvss7jnx7olkf7wwf2','Die For You - Remix','9dkxl9jv60s48n0','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y59thv4ayi5odykt1zlmeyz0eiftliatib75wo3s7knvlaxetk', 'litxgo6zaie59cy27azfg9w93bf6wwztjvss7jnx7olkf7wwf2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y2c327fbdl55b4qs6utrz6sah5av10q9ayqfcwtdk44rqonk1z','Save Your Tears (with Ariana Grande) (Remix)','9dkxl9jv60s48n0','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y59thv4ayi5odykt1zlmeyz0eiftliatib75wo3s7knvlaxetk', 'y2c327fbdl55b4qs6utrz6sah5av10q9ayqfcwtdk44rqonk1z', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1pf93vjriss1i3gozrnfh1ijph67udgux46g2gc94kxioxpkhg','Santa Tell Me','9dkxl9jv60s48n0','POP','0lizgQ7Qw35od7CYaoMBZb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y59thv4ayi5odykt1zlmeyz0eiftliatib75wo3s7knvlaxetk', '1pf93vjriss1i3gozrnfh1ijph67udgux46g2gc94kxioxpkhg', '2');
-- Tory Lanez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('781w8e1l441cbzh', 'Tory Lanez', '161@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebbd5d3e1b363c3e26710661c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:161@artist.com', '781w8e1l441cbzh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('781w8e1l441cbzh', 'Revolutionizing the music scene with innovative compositions.', 'Tory Lanez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('r2ik5628zixuz5y9d85dg3vbtok2ci22uo7ql1q49bfx8l55av','781w8e1l441cbzh', 'https://i.scdn.co/image/ab67616d0000b2730c5f23cbf0b1ab7e37d0dc67', 'Alone At Prom','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7uwqg636e5jtg8mpxqnxtcg4jm467h0rctki61u8t4j7ogm5n2','The Color Violet','781w8e1l441cbzh','POP','3azJifCSqg9fRij2yKIbWz','https://p.scdn.co/mp3-preview/1d7c627bf549328110519c4bd21ac39d7ca50ea1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r2ik5628zixuz5y9d85dg3vbtok2ci22uo7ql1q49bfx8l55av', '7uwqg636e5jtg8mpxqnxtcg4jm467h0rctki61u8t4j7ogm5n2', '0');
-- Dean Martin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u3jlbhshi6xyhoi', 'Dean Martin', '162@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdc6d54b08006b8896cb199e5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:162@artist.com', 'u3jlbhshi6xyhoi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u3jlbhshi6xyhoi', 'Transcending language barriers through the universal language of music.', 'Dean Martin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xs6l4lltyp7ygcac32qc1tw6pmij9thxc8vl3pr8f4p4b3kmzy','u3jlbhshi6xyhoi', 'https://i.scdn.co/image/ab67616d0000b2736d88028a85c771f37374c8ea', 'A Winter Romance','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n2kloteatnhle55jt3s15zwcymdssuzm7mgr4t23mp4uxrznrz','Let It Snow! Let It Snow! Let It Snow!','u3jlbhshi6xyhoi','POP','2uFaJJtFpPDc5Pa95XzTvg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xs6l4lltyp7ygcac32qc1tw6pmij9thxc8vl3pr8f4p4b3kmzy', 'n2kloteatnhle55jt3s15zwcymdssuzm7mgr4t23mp4uxrznrz', '0');
-- Taylor Swift
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j7wsmm5n0murt8f', 'Taylor Swift', '163@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb859e4c14fa59296c8649e0e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:163@artist.com', 'j7wsmm5n0murt8f', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j7wsmm5n0murt8f', 'A storytelling icon, weaving life experiences into musical masterpieces.', 'Taylor Swift');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz','j7wsmm5n0murt8f', 'https://i.scdn.co/image/ab67616d0000b273e787cffec20aa2a396a61647', 'Lover','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z7heug7vmry24r3k57hhdu1z11pktvju5z906xfo2yb684l119','Cruel Summer','j7wsmm5n0murt8f','POP','1BxfuPKGuaTgP7aM0Bbdwr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'z7heug7vmry24r3k57hhdu1z11pktvju5z906xfo2yb684l119', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('12sk0xu2oaga7cp6gqcqlsuogmae98mm8a2gg6r650b43l9p32','I Can See You (Taylors Version) (From The ','j7wsmm5n0murt8f','POP','5kHMfzgLZP95O9NBy0ku4v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', '12sk0xu2oaga7cp6gqcqlsuogmae98mm8a2gg6r650b43l9p32', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('33xfyqt1rogz8970va0ppu34ejieuhpnlbiru5z0wcvrkr6g47','Anti-Hero','j7wsmm5n0murt8f','POP','0V3wPSX9ygBnCm8psDIegu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', '33xfyqt1rogz8970va0ppu34ejieuhpnlbiru5z0wcvrkr6g47', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lkrib2s3zvav7di1o4v0wkbp8m8j6k3whnv9jzjhi3ecl54c8p','Blank Space','j7wsmm5n0murt8f','POP','1p80LdxRV74UKvL8gnD7ky',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'lkrib2s3zvav7di1o4v0wkbp8m8j6k3whnv9jzjhi3ecl54c8p', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p7ek5axyz120vxuv7prjeen2xc8oza71sz37yqiv6xa9edzzdy','Style','j7wsmm5n0murt8f','POP','1hjRhYpWyqDpPahmSlUTlc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'p7ek5axyz120vxuv7prjeen2xc8oza71sz37yqiv6xa9edzzdy', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2t6o5lsq6rn74r4lgjtw5mwme1062igm4utkwffgfs55jrrbqk','cardigan','j7wsmm5n0murt8f','POP','4R2kfaDFhslZEMJqAFNpdd',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', '2t6o5lsq6rn74r4lgjtw5mwme1062igm4utkwffgfs55jrrbqk', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('irq1ofm6w0zhyu2kfo3rdfku2z9s3aimd0y2rd3jo3nhqklm7a','Karma','j7wsmm5n0murt8f','POP','7KokYm8cMIXCsGVmUvKtqf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'irq1ofm6w0zhyu2kfo3rdfku2z9s3aimd0y2rd3jo3nhqklm7a', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0i80liopk9e6710u8vubg1my5fmr9t9imilrkdm84f5h7m6xqi','Enchanted (Taylors Version)','j7wsmm5n0murt8f','POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', '0i80liopk9e6710u8vubg1my5fmr9t9imilrkdm84f5h7m6xqi', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dq0jfmtxhwymoavwgesuaw7ivj54qjk8ekoghwsgrfx0ecufna','Back To December (Taylors Version)','j7wsmm5n0murt8f','POP','79uDOz0zuuWS7HWxzMmTa2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'dq0jfmtxhwymoavwgesuaw7ivj54qjk8ekoghwsgrfx0ecufna', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d8dp8ktvjxvnaz5cpleihqp2w2hfnaulfqiz7xw16ksywt2x6k','Dont Bl','j7wsmm5n0murt8f','POP','59ZmeIz57cGU5Gp9omjlYB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'd8dp8ktvjxvnaz5cpleihqp2w2hfnaulfqiz7xw16ksywt2x6k', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vpc8ktyzazoln9tb6udhak3fgxlogkhajg6l2ljmicc7kfhz0h','Mine (Taylors Version)','j7wsmm5n0murt8f','POP','7G0gBu6nLdhFDPRLc0HdDG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'vpc8ktyzazoln9tb6udhak3fgxlogkhajg6l2ljmicc7kfhz0h', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bdad3ljei4exvfkho4u85sjaena07o0alsps003dojauv2o64y','august','j7wsmm5n0murt8f','POP','3hUxzQpSfdDqwM3ZTFQY0K',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'bdad3ljei4exvfkho4u85sjaena07o0alsps003dojauv2o64y', '11');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6yemw7wxyw5xq56h8r6qo98q5dsie9qvr42f5r3fpbaxp3nt1r','Enchanted','j7wsmm5n0murt8f','POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', '6yemw7wxyw5xq56h8r6qo98q5dsie9qvr42f5r3fpbaxp3nt1r', '12');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d69cy052iz9c4swkane8ymd6jyw5xpqfcd9a8ez60w498it6ah','Shake It Off','j7wsmm5n0murt8f','POP','3pv7Q5v2dpdefwdWIvE7yH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'd69cy052iz9c4swkane8ymd6jyw5xpqfcd9a8ez60w498it6ah', '13');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vg8fcsmnvdp4uc3geonywmol2j59u0ridcfz7i9x8abnjawxdh','You Belong With Me (Taylors Ve','j7wsmm5n0murt8f','POP','1qrpoAMXodY6895hGKoUpA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'vg8fcsmnvdp4uc3geonywmol2j59u0ridcfz7i9x8abnjawxdh', '14');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lcqtyj80sm58ook174o53q1nkwkadh1qq9idc9q2l869xuark0','Better Than Revenge (Taylors Version)','j7wsmm5n0murt8f','POP','0NwGC0v03ysCYINtg6ns58',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'lcqtyj80sm58ook174o53q1nkwkadh1qq9idc9q2l869xuark0', '15');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('47h5rbzlplunhnlh3g2wjgc5uw1r4x1dxjeq3qea9dzf595gzr','Hits Different','j7wsmm5n0murt8f','POP','3xYJScVfxByb61dYHTwiby',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', '47h5rbzlplunhnlh3g2wjgc5uw1r4x1dxjeq3qea9dzf595gzr', '16');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x9mkc3t3gbac36cicktsuuskx3gp3pn7bkla9wtnfud8fgtu7g','Karma (feat. Ice Spice)','j7wsmm5n0murt8f','POP','4i6cwNY6oIUU2XZxPIw82Y',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'x9mkc3t3gbac36cicktsuuskx3gp3pn7bkla9wtnfud8fgtu7g', '17');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v3zl7oqjzpcprg7d3i60hqg50o3mcnjpj1jkj0ht54g0023l0w','Lavender Haze','j7wsmm5n0murt8f','POP','5jQI2r1RdgtuT8S3iG8zFC',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'v3zl7oqjzpcprg7d3i60hqg50o3mcnjpj1jkj0ht54g0023l0w', '18');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5omdmmxl6cbjg13w6sx23el4clglokl82h0l25n7drplcb13q8','All Of The Girls You Loved Before','j7wsmm5n0murt8f','POP','4P9Q0GojKVXpRTJCaL3kyy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', '5omdmmxl6cbjg13w6sx23el4clglokl82h0l25n7drplcb13q8', '19');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bpoqwhlanhga4imt0azypr5pxywy9p69qypq9o2o7w83ocsfjv','Midnight Rain','j7wsmm5n0murt8f','POP','3rWDp9tBPQR9z6U5YyRSK4',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'bpoqwhlanhga4imt0azypr5pxywy9p69qypq9o2o7w83ocsfjv', '20');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p9ilfw9g8j5mh1tp0n6zz2z9hhxeit8sel1al2eobczvuntu4y','Youre On Your Own, Kid','j7wsmm5n0murt8f','POP','1yMjWvw0LRwW5EZBPh9UyF','https://p.scdn.co/mp3-preview/cb8981007d0606f43b3051b3633f890d0a70de8c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2itg8drrg83funo8jjipapt8jgo8z7q9feljtsqoxs7ggjs4dz', 'p9ilfw9g8j5mh1tp0n6zz2z9hhxeit8sel1al2eobczvuntu4y', '21');
-- Chris Molitor
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v7p3uzqu2n4rd7q', 'Chris Molitor', '164@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03851b1c2471a8c0b57371c4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:164@artist.com', 'v7p3uzqu2n4rd7q', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v7p3uzqu2n4rd7q', 'Delivering heartfelt music that speaks to the soul, blending folk and indie vibes.', 'Chris Molitor');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jabulic7i177wto5iqkecoy5enizm5e7ou3vbqqyniys3fm7b9','v7p3uzqu2n4rd7q', 'https://i.scdn.co/image/ab67616d0000b273be011d16b9360a7dee109774', 'Yellow','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g48ca5xztv02bfxd2tr53r6wb27w2okropepdz063ysxzlo5xc','Yellow','v7p3uzqu2n4rd7q','POP','6tvs7zEP8d1SBgSqZQ84OT','https://p.scdn.co/mp3-preview/ea93f9b43fc638111ad661719037bfb88cd9c05d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jabulic7i177wto5iqkecoy5enizm5e7ou3vbqqyniys3fm7b9', 'g48ca5xztv02bfxd2tr53r6wb27w2okropepdz063ysxzlo5xc', '0');
-- Israel & Rodolffo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w7nugw45grjyguq', 'Israel & Rodolffo', '165@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9600f2bcc76e77811c90f518','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:165@artist.com', 'w7nugw45grjyguq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w7nugw45grjyguq', 'Pioneering new paths in the musical landscape.', 'Israel & Rodolffo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('20gmiyo5m8ttin28ghwn5mbpn7c0dz22d6kqi98etfn301c56v','w7nugw45grjyguq', 'https://i.scdn.co/image/ab67616d0000b2736ccbcc3358d31dcba6e7c035', 'Lets Bora, Vol. 2 (Ao Vivo)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r5ghhi36pxvh5l7rnn4fmunta57gmxkb1t6wdeph5oprc99wt9','Seu Brilho Sumiu - Ao Vivo','w7nugw45grjyguq','POP','3PH1nUysW7ybo3Yu8sqlPN','https://p.scdn.co/mp3-preview/125d70024c88bb1bf45666f6396dc21a181c416e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('20gmiyo5m8ttin28ghwn5mbpn7c0dz22d6kqi98etfn301c56v', 'r5ghhi36pxvh5l7rnn4fmunta57gmxkb1t6wdeph5oprc99wt9', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6te7iuruvhjtnbra6zle4hlur6fylmy20hv8du7h9yt2r7zdev','Bombonzinho - Ao Vivo','w7nugw45grjyguq','POP','0SCMVUZ21uYYB8cc0ScfbV','https://p.scdn.co/mp3-preview/b7d7cfb08d5384a52deb562a3e496881c978a9f1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('20gmiyo5m8ttin28ghwn5mbpn7c0dz22d6kqi98etfn301c56v', '6te7iuruvhjtnbra6zle4hlur6fylmy20hv8du7h9yt2r7zdev', '1');
-- Carin Leon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('agpupqjb7mhivsf', 'Carin Leon', '166@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb7cc22fee89df015c6ba2636','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:166@artist.com', 'agpupqjb7mhivsf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('agpupqjb7mhivsf', 'Transcending language barriers through the universal language of music.', 'Carin Leon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('65isfayh8zhl9fk9uki30lyt109cjg480q5ow12nfon85sahfd','agpupqjb7mhivsf', 'https://i.scdn.co/image/ab67616d0000b273dc0bb68a08c069cf8467f1bd', 'Primera Cita','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ahp9ocvly9q93x1kwgix3cakbatie03pis8k4suuaonuzl571j','Primera Cita','agpupqjb7mhivsf','POP','4mGrWfDISjNjgeQnH1B8IE','https://p.scdn.co/mp3-preview/7eea768397c9ad0989a55f26f4cffbe6f334874a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('65isfayh8zhl9fk9uki30lyt109cjg480q5ow12nfon85sahfd', 'ahp9ocvly9q93x1kwgix3cakbatie03pis8k4suuaonuzl571j', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1t6epaatqnpu14p67z1l0wdb5dv71mymi9z9kk52dc1qyxl6ay','Que Vuelvas','agpupqjb7mhivsf','POP','6Um358vY92UBv5DloTRX9L','https://p.scdn.co/mp3-preview/19a1e58ae965c24e3ca4d0637857456887e31cd1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('65isfayh8zhl9fk9uki30lyt109cjg480q5ow12nfon85sahfd', '1t6epaatqnpu14p67z1l0wdb5dv71mymi9z9kk52dc1qyxl6ay', '1');
-- Beach House
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('di0louasp6tnx9e', 'Beach House', '167@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb3e38a46a56a423d8f741c09','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:167@artist.com', 'di0louasp6tnx9e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('di0louasp6tnx9e', 'Pushing the boundaries of sound with each note.', 'Beach House');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o86l2t9rn8av3er9twjy5uoyggeexzqdk51wquozprqlg06loo','di0louasp6tnx9e', 'https://i.scdn.co/image/ab67616d0000b2739b7190e673e46271b2754aab', 'Depression Cherry','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3iyafkgn3gzqssrruw6a7z1jzd8f9rn5i0jtyfghf0xoblfzom','Space Song','di0louasp6tnx9e','POP','7H0ya83CMmgFcOhw0UB6ow','https://p.scdn.co/mp3-preview/3d50d7331c2ef197699e796d08cf8d4009591be0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o86l2t9rn8av3er9twjy5uoyggeexzqdk51wquozprqlg06loo', '3iyafkgn3gzqssrruw6a7z1jzd8f9rn5i0jtyfghf0xoblfzom', '0');
-- Brray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k7bcrfe1agcb9pr', 'Brray', '168@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9047f938310ea16b68a5bdeb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:168@artist.com', 'k7bcrfe1agcb9pr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k7bcrfe1agcb9pr', 'Delivering soul-stirring tunes that linger in the mind.', 'Brray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x9kf0ph2fho54kn6fn5vhpkfxwhrj2eut0sykx31te8uu5stg4','k7bcrfe1agcb9pr', NULL, 'Brray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('he1vz4y3nj4y4x1mn57fhpg12zwd7dkl8c46etj6z46mtlxxk4','LOKERA','k7bcrfe1agcb9pr','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x9kf0ph2fho54kn6fn5vhpkfxwhrj2eut0sykx31te8uu5stg4', 'he1vz4y3nj4y4x1mn57fhpg12zwd7dkl8c46etj6z46mtlxxk4', '0');
-- Charlie Puth
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3wb2k4hg2y9old3', 'Charlie Puth', '169@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:169@artist.com', '3wb2k4hg2y9old3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3wb2k4hg2y9old3', 'A pop maestro, combining catchy melodies with his exceptional musical talent.', 'Charlie Puth');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1ded8yn4h5k2abi02iqim1bt13r1baebgzrleq37dycmf50k1f','3wb2k4hg2y9old3', 'https://i.scdn.co/image/ab67616d0000b27335d2e0ed94a934f2cc46fa49', 'CHARLIE','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ny518qjfytd6ufjm7gki8nouhb2zu9dh1ptcvt8poz83vr3rb9','Left and Right (Feat. Jung Kook of BTS)','3wb2k4hg2y9old3','POP','5Odq8ohlgIbQKMZivbWkEo','https://p.scdn.co/mp3-preview/9e4342eefa4f33df4e9b199e60dbce0f59e46eff?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1ded8yn4h5k2abi02iqim1bt13r1baebgzrleq37dycmf50k1f', 'ny518qjfytd6ufjm7gki8nouhb2zu9dh1ptcvt8poz83vr3rb9', '0');
-- Z Neto & Crist
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('348m306a8nx8n6a', 'Z Neto & Crist', '170@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1bb9201db3ff149830f0139a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:170@artist.com', '348m306a8nx8n6a', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('348m306a8nx8n6a', 'Delivering soul-stirring tunes that linger in the mind.', 'Z Neto & Crist');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yzr2t7bx1quqengzgx9ot4fvc4gm58snajkz4z1jxw93uwoz1x','348m306a8nx8n6a', 'https://i.scdn.co/image/ab67616d0000b27339833b5940945cf013e8406c', 'Escolhas, Vol. 2 (Ao Vivo)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0jsbanye2jaqytvwayrtqo02bxfc8j2cw2y75ttir6pbz0n0wd','Oi Balde - Ao Vivo','348m306a8nx8n6a','POP','4xAGuRRKOgoaZbMGdmTD3N','https://p.scdn.co/mp3-preview/a6318531e5f8243a9d1df067570b50210b2729cc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yzr2t7bx1quqengzgx9ot4fvc4gm58snajkz4z1jxw93uwoz1x', '0jsbanye2jaqytvwayrtqo02bxfc8j2cw2y75ttir6pbz0n0wd', '0');
-- Imagine Dragons
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9rqbgb1nrt7rfwb', 'Imagine Dragons', '171@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb920dc1f617550de8388f368e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:171@artist.com', '9rqbgb1nrt7rfwb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9rqbgb1nrt7rfwb', 'The heartbeat of a new generation of music lovers.', 'Imagine Dragons');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6mb1wbuwfk8ea8wr9w29pyvsf5oin4wlshlesxhiucpg9f373v','9rqbgb1nrt7rfwb', 'https://i.scdn.co/image/ab67616d0000b273fc915b69600dce2991a61f13', 'Mercury - Acts 1 & 2','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hxh9mw79ssereyngjo1kdeuxkb3bbb7ibeff7ya46kyzop3q2v','Bones','9rqbgb1nrt7rfwb','POP','54ipXppHLA8U4yqpOFTUhr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6mb1wbuwfk8ea8wr9w29pyvsf5oin4wlshlesxhiucpg9f373v', 'hxh9mw79ssereyngjo1kdeuxkb3bbb7ibeff7ya46kyzop3q2v', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('beanji0m6rxpw8vubu61oyr0si4fuu6gr1lixt0fxytax6mlw2','Believer','9rqbgb1nrt7rfwb','POP','0pqnGHJpmpxLKifKRmU6WP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6mb1wbuwfk8ea8wr9w29pyvsf5oin4wlshlesxhiucpg9f373v', 'beanji0m6rxpw8vubu61oyr0si4fuu6gr1lixt0fxytax6mlw2', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uzr1c67i61cb7kecgjkn7fkd9yudabqnlxdkhjptx6gkhtu5vh','Demons','9rqbgb1nrt7rfwb','POP','3LlAyCYU26dvFZBDUIMb7a',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6mb1wbuwfk8ea8wr9w29pyvsf5oin4wlshlesxhiucpg9f373v', 'uzr1c67i61cb7kecgjkn7fkd9yudabqnlxdkhjptx6gkhtu5vh', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ffm51iomgieti8mxckj7vw76wxdzej3dxviszdc63k43fhvf54','Enemy (with JID) - from the series Arcane League of Legends','9rqbgb1nrt7rfwb','POP','3CIyK1V4JEJkg02E4EJnDl',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6mb1wbuwfk8ea8wr9w29pyvsf5oin4wlshlesxhiucpg9f373v', 'ffm51iomgieti8mxckj7vw76wxdzej3dxviszdc63k43fhvf54', '3');
-- Kodak Black
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('669y0oiigr1s2tc', 'Kodak Black', '172@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb70c05cf4dc9a7d3ffd02ba19','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:172@artist.com', '669y0oiigr1s2tc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('669y0oiigr1s2tc', 'The heartbeat of a new generation of music lovers.', 'Kodak Black');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hbe46ztq5muqqecu8y6gay0u593zg6txzfot3p2fbxgizdsuq8','669y0oiigr1s2tc', 'https://i.scdn.co/image/ab67616d0000b273445afb6341d2685b959251cc', 'Angel Pt. 1 (feat. Jimin of BTS, JVKE & Muni Long) [Trailer Version]','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u4q0cwq18ugmo47lwhft5tnklyyyptsnlxya6vohz0r58gmkiq','Angel Pt 1 (feat. Jimin of BTS, JVKE & Muni Long)','669y0oiigr1s2tc','POP','1vvcEHQdaUTvWt0EIUYcFK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hbe46ztq5muqqecu8y6gay0u593zg6txzfot3p2fbxgizdsuq8', 'u4q0cwq18ugmo47lwhft5tnklyyyptsnlxya6vohz0r58gmkiq', '0');
-- David Guetta
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c9hni5h4y3kk9h2', 'David Guetta', '173@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf150017ca69c8793503c2d4f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:173@artist.com', 'c9hni5h4y3kk9h2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c9hni5h4y3kk9h2', 'A legend in the electronic music world, constantly innovating and entertaining.', 'David Guetta');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xqswjbfv5mfwgmbxir2yh55md2wy0czgfgn3t4hgwfodzikjuv','c9hni5h4y3kk9h2', 'https://i.scdn.co/image/ab67616d0000b2730b4ef75c3728599aa4104f7a', 'Baby Dont Hurt Me','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gsyi306zara7w3c964lydow9lqgeut9shydscpmc9kykr1xpsn','Baby Dont Hurt Me','c9hni5h4y3kk9h2','POP','3BKD1PwArikchz2Zrlp1qi','https://p.scdn.co/mp3-preview/a8f2e176e17e0f6298b42ef8e96118318fdd2b89?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xqswjbfv5mfwgmbxir2yh55md2wy0czgfgn3t4hgwfodzikjuv', 'gsyi306zara7w3c964lydow9lqgeut9shydscpmc9kykr1xpsn', '0');
-- Jasiel Nuez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('342qu26z069vt37', 'Jasiel Nuez', '174@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb94f3bfc067e8ba0293adb30a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:174@artist.com', '342qu26z069vt37', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('342qu26z069vt37', 'An alchemist of harmonies, transforming notes into gold.', 'Jasiel Nuez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('himl65gnb067jqhjqseg5dy6ot4lawt4tdnimgmst0grx6emcp','342qu26z069vt37', NULL, 'Jasiel Nuez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8bx409xktlbtchve4d71j6n4xdopj6m5do88b4yvuuorstpuws','LAGUNAS','342qu26z069vt37','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('himl65gnb067jqhjqseg5dy6ot4lawt4tdnimgmst0grx6emcp', '8bx409xktlbtchve4d71j6n4xdopj6m5do88b4yvuuorstpuws', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a9qwjx2gdp0kz08gjwtwic27vlwef51tzmda1cr30dqkzdjlgp','Rosa Pastel','342qu26z069vt37','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('himl65gnb067jqhjqseg5dy6ot4lawt4tdnimgmst0grx6emcp', 'a9qwjx2gdp0kz08gjwtwic27vlwef51tzmda1cr30dqkzdjlgp', '1');
-- XXXTENTACION
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('siq9qgx8uqhes4z', 'XXXTENTACION', '175@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf0c20db5ef6c6fbe5135d2e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:175@artist.com', 'siq9qgx8uqhes4z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('siq9qgx8uqhes4z', 'Weaving lyrical magic into every song.', 'XXXTENTACION');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7zucprr45j7a4g4cysiv6w5grl800dpc3p5i25pw1hsc400su8','siq9qgx8uqhes4z', 'https://i.scdn.co/image/ab67616d0000b273203c89bd4391468eea4cc3f5', '17','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gfu5jczvdkunftb50n3ieo775jos7a7e757bpu3n6u5s8hwp14','Revenge','siq9qgx8uqhes4z','POP','5TXDeTFVRVY7Cvt0Dw4vWW','https://p.scdn.co/mp3-preview/8f5fe8bb510463b2da20325c8600200bf2984d83?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7zucprr45j7a4g4cysiv6w5grl800dpc3p5i25pw1hsc400su8', 'gfu5jczvdkunftb50n3ieo775jos7a7e757bpu3n6u5s8hwp14', '0');
-- Rosa Linn
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x1dcvhc6b9e5mmy', 'Rosa Linn', '176@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5fe9684ed75d00000b63791','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:176@artist.com', 'x1dcvhc6b9e5mmy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x1dcvhc6b9e5mmy', 'A voice that echoes the sentiments of a generation.', 'Rosa Linn');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('z2ar9402he3d9nwpwp48172lccr5tny74zlismv6k8isjcavm4','x1dcvhc6b9e5mmy', 'https://i.scdn.co/image/ab67616d0000b2731391b1fdb63da53e5b112224', 'SNAP','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hru0ffbo7295mbrzzorktyrzzzrg6z3sx7n84iwayri2hkk849','SNAP','x1dcvhc6b9e5mmy','POP','76OGwb5RA9h4FxQPT33ekc','https://p.scdn.co/mp3-preview/0a41500662a6b6223dcb026b20ef1437985574b8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z2ar9402he3d9nwpwp48172lccr5tny74zlismv6k8isjcavm4', 'hru0ffbo7295mbrzzorktyrzzzrg6z3sx7n84iwayri2hkk849', '0');
-- Brenda Lee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('84z0o1g8np75ss4', 'Brenda Lee', '177@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4ea49bdca366a3baa5cbb006','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:177@artist.com', '84z0o1g8np75ss4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('84z0o1g8np75ss4', 'An alchemist of harmonies, transforming notes into gold.', 'Brenda Lee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('h3fp6z5flx9z7hicemgdqeyw4apjx2tn2lkag06u0qduqzikdq','84z0o1g8np75ss4', 'https://i.scdn.co/image/ab67616d0000b2737845f74d6db14b400fa61cd3', 'Merry Christmas From Brenda Lee','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xx09zebwbc709kx70hpp9b1vitka8xt9t6pzectg2fjmj0m97d','Rockin Around The Christmas Tree','84z0o1g8np75ss4','POP','2EjXfH91m7f8HiJN1yQg97',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h3fp6z5flx9z7hicemgdqeyw4apjx2tn2lkag06u0qduqzikdq', 'xx09zebwbc709kx70hpp9b1vitka8xt9t6pzectg2fjmj0m97d', '0');
-- Natanael Cano
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k6klz3ya6q4rmgx', 'Natanael Cano', '178@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0819edd43096a2f0dde7cd44','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:178@artist.com', 'k6klz3ya6q4rmgx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k6klz3ya6q4rmgx', 'Blending traditional rhythms with modern beats.', 'Natanael Cano');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('84banx5gr12h6rid1zepmhvi24tc4t9867yc140n272s51fhhj','k6klz3ya6q4rmgx', 'https://i.scdn.co/image/ab67616d0000b273e2e093427065eaca9e2f2970', 'Nata Montana','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6wyyr4ojj2aqetjbjirszyc53yt2wt5wmf70pcnef99yeons1q','Mi Bello Angel','k6klz3ya6q4rmgx','POP','4t46soaqA758rbukTO5pp1','https://p.scdn.co/mp3-preview/07854d155311327027a073aeb36f0f61cdb07096?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('84banx5gr12h6rid1zepmhvi24tc4t9867yc140n272s51fhhj', '6wyyr4ojj2aqetjbjirszyc53yt2wt5wmf70pcnef99yeons1q', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hboisaccg0lsjfa4689eha353jt67jnn9plcxoa7wufkxyue27','PRC','k6klz3ya6q4rmgx','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('84banx5gr12h6rid1zepmhvi24tc4t9867yc140n272s51fhhj', 'hboisaccg0lsjfa4689eha353jt67jnn9plcxoa7wufkxyue27', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n6agiq4uvmtoffucq9j8ncufi7cxan7b9g917wc7060xf4okt7','AMG','k6klz3ya6q4rmgx','POP','1lRtH4FszTrwwlK5gTSbXO','https://p.scdn.co/mp3-preview/2a54eb02ee2a7e8c47c6107f16272a19a0e6362b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('84banx5gr12h6rid1zepmhvi24tc4t9867yc140n272s51fhhj', 'n6agiq4uvmtoffucq9j8ncufi7cxan7b9g917wc7060xf4okt7', '2');
-- Linkin Park
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d7ny6p4i1inb3ws', 'Linkin Park', '179@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb811da3b2e7c9e5a9c1a6c4f7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:179@artist.com', 'd7ny6p4i1inb3ws', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('d7ny6p4i1inb3ws', 'A confluence of cultural beats and contemporary tunes.', 'Linkin Park');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('szbta9p83arqd0g98i6cw20v0fn9c9fy7cbo7omf5t7kr4czea','d7ny6p4i1inb3ws', 'https://i.scdn.co/image/ab67616d0000b273b4ad7ebaf4575f120eb3f193', 'Meteora','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('krp1ew85nc8p8jhbykal3zel015x1klxib3jkkjlpi77kq3p75','Numb','d7ny6p4i1inb3ws','POP','2nLtzopw4rPReszdYBJU6h','https://p.scdn.co/mp3-preview/15e1178c9eb7f626ac1112ad8f56eccbec2cd6e5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('szbta9p83arqd0g98i6cw20v0fn9c9fy7cbo7omf5t7kr4czea', 'krp1ew85nc8p8jhbykal3zel015x1klxib3jkkjlpi77kq3p75', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('90n4baretyob741userugi5ijpim6zadh3jisusbs5p2xwfmbk','In The End','d7ny6p4i1inb3ws','POP','60a0Rd6pjrkxjPbaKzXjfq','https://p.scdn.co/mp3-preview/b5ee275ca337899f762b1c1883c11e24a04075b0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('szbta9p83arqd0g98i6cw20v0fn9c9fy7cbo7omf5t7kr4czea', '90n4baretyob741userugi5ijpim6zadh3jisusbs5p2xwfmbk', '1');
-- Olivia Rodrigo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('r7n9v5a3wdu5t56', 'Olivia Rodrigo', '180@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe03a98785f3658f0b6461ec4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:180@artist.com', 'r7n9v5a3wdu5t56', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('r7n9v5a3wdu5t56', 'A new voice in pop, channeling raw emotions into her songs.', 'Olivia Rodrigo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yaxij73bppv7hfstevkvrncyr3o3uu53duzmzuxleomdaswa3j','r7n9v5a3wdu5t56', 'https://i.scdn.co/image/ab67616d0000b273e85259a1cae29a8d91f2093d', 'GUTS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yhh8nl09p801xgrvo3ksal20cj5wznugd24kkwg1z9raykpxzz','vampire','r7n9v5a3wdu5t56','POP','1kuGVB7EU95pJObxwvfwKS',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yaxij73bppv7hfstevkvrncyr3o3uu53duzmzuxleomdaswa3j', 'yhh8nl09p801xgrvo3ksal20cj5wznugd24kkwg1z9raykpxzz', '0');
-- Kanii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('malm3brdk5gksi0', 'Kanii', '181@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb777f2bab9e5f1e343c3126d4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:181@artist.com', 'malm3brdk5gksi0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('malm3brdk5gksi0', 'A beacon of innovation in the world of sound.', 'Kanii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zj47wc5ac5y59lxbtdad0qqpoj40fau1j305xg3ugey9n2ov3n','malm3brdk5gksi0', 'https://i.scdn.co/image/ab67616d0000b273efae10889cd442784f3acd3d', 'I Know (PR1SVX Edit)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z0l4bfmq9asth043lgahrva4jwjknnzrunzpewcupnho13mylm','I Know - PR1SVX Edit','malm3brdk5gksi0','POP','3vcLw8QA3yCOkrj9oLSZNs','https://p.scdn.co/mp3-preview/146ad1bb65b8f9b097f356d2d5758657a06466dc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zj47wc5ac5y59lxbtdad0qqpoj40fau1j305xg3ugey9n2ov3n', 'z0l4bfmq9asth043lgahrva4jwjknnzrunzpewcupnho13mylm', '0');
-- The Walters
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7cpt55x9zlgsr9x', 'The Walters', '182@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6c4366f40ea49c1318707f97','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:182@artist.com', '7cpt55x9zlgsr9x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7cpt55x9zlgsr9x', 'A tapestry of rhythms that echo the pulse of life.', 'The Walters');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uv1x0hsrh16lqlty6rfct8whvjmro7qsz5kad1hm06x43n1b8g','7cpt55x9zlgsr9x', 'https://i.scdn.co/image/ab67616d0000b2739214ff0109a0e062f8a6cf0f', 'I Love You So','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('491fg7169c69goyum6c43q6ybmrtoe2ar9vs9jegit7p4nmd31','I Love You So','7cpt55x9zlgsr9x','POP','4SqWKzw0CbA05TGszDgMlc','https://p.scdn.co/mp3-preview/83919b3d62a4ae352229c0a779e8aa0c1b2f4f40?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uv1x0hsrh16lqlty6rfct8whvjmro7qsz5kad1hm06x43n1b8g', '491fg7169c69goyum6c43q6ybmrtoe2ar9vs9jegit7p4nmd31', '0');
-- Maroon 5
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('g8p1ahpycpsk4rr', 'Maroon 5', '183@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf8349dfb619a7f842242de77','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:183@artist.com', 'g8p1ahpycpsk4rr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('g8p1ahpycpsk4rr', 'Creating a tapestry of tunes that celebrates diversity.', 'Maroon 5');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tpah5p8y3xjj9nt4i7o2s58ljo0qc4cy2lhisb7m9vjyr4jxpb','g8p1ahpycpsk4rr', 'https://i.scdn.co/image/ab67616d0000b273ce7d499847da02a9cbd1c084', 'Overexposed (Deluxe)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iqckgys9khb3ngm3l4tjeumfx9a8lcwahc51r8og4eh564r3it','Payphone','g8p1ahpycpsk4rr','POP','4P0osvTXoSYZZC2n8IFH3c',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tpah5p8y3xjj9nt4i7o2s58ljo0qc4cy2lhisb7m9vjyr4jxpb', 'iqckgys9khb3ngm3l4tjeumfx9a8lcwahc51r8og4eh564r3it', '0');
-- Nicki Minaj
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('se9fy9vmefhlfe3', 'Nicki Minaj', '184@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb54cd560d17307a51f3dc278a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:184@artist.com', 'se9fy9vmefhlfe3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('se9fy9vmefhlfe3', 'A rap icon known for her versatile flow and bold personality.', 'Nicki Minaj');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tmiau0a4bt99ydvih0d8a1jylamb1x1wy1xourgszk5kqk5rqr','se9fy9vmefhlfe3', 'https://i.scdn.co/image/ab67616d0000b2737e8f938c02fac3b564931116', 'Barbie World (with Aqua) [From Barbie The Album]','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7dlkr6joggslrxyxpguabx3s19zg26wal8f50empkai7yu0j34','Barbie World (with Aqua) [From Barbie The Album]','se9fy9vmefhlfe3','POP','741UUVE2kuITl0c6zuqqbO','https://p.scdn.co/mp3-preview/f654928ccaa4e6a9fb09a6eb3f208383eccc12a9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tmiau0a4bt99ydvih0d8a1jylamb1x1wy1xourgszk5kqk5rqr', '7dlkr6joggslrxyxpguabx3s19zg26wal8f50empkai7yu0j34', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t3purij7ajciiik6153t8vdghottf6fed4ky3jt58ftfaalqnv','Princess Diana (with Nicki Minaj)','se9fy9vmefhlfe3','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tmiau0a4bt99ydvih0d8a1jylamb1x1wy1xourgszk5kqk5rqr', 't3purij7ajciiik6153t8vdghottf6fed4ky3jt58ftfaalqnv', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9z7vqnclxg6yluf55r3v8piegwg8tpzpfiktiiwtsu6ab6ub53','Red Ruby Da Sleeze','se9fy9vmefhlfe3','POP','4ZYAU4A2YBtlNdqOUtc7T2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tmiau0a4bt99ydvih0d8a1jylamb1x1wy1xourgszk5kqk5rqr', '9z7vqnclxg6yluf55r3v8piegwg8tpzpfiktiiwtsu6ab6ub53', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i2qwbd8t1mn3592wcumyapg75aje5v1wcbbt12wxmdpp1mc4fq','Super Freaky Girl','se9fy9vmefhlfe3','POP','4C6Uex2ILwJi9sZXRdmqXp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tmiau0a4bt99ydvih0d8a1jylamb1x1wy1xourgszk5kqk5rqr', 'i2qwbd8t1mn3592wcumyapg75aje5v1wcbbt12wxmdpp1mc4fq', '3');
-- Seafret
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hs31lul8h74peys', 'Seafret', '185@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7f753324eacfbe0db36d64e5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:185@artist.com', 'hs31lul8h74peys', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hs31lul8h74peys', 'Blending traditional rhythms with modern beats.', 'Seafret');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yoo3edd23aiihx7sxq9yzxeilem1dkcr9dtfj5lxbgytizmgzh','hs31lul8h74peys', 'https://i.scdn.co/image/ab67616d0000b2738c33272a7c77042f5eb39d75', 'Tell Me Its Real (Expanded Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3gpalk4heac6lgrq6jz32x33iynmn5q3ktmbejy0gsdw64a5p5','Atlantis','hs31lul8h74peys','POP','1Fid2jjqsHViMX6xNH70hE','https://p.scdn.co/mp3-preview/2097364ff6c9f41d658ea1b00a5e2153dc61144b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yoo3edd23aiihx7sxq9yzxeilem1dkcr9dtfj5lxbgytizmgzh', '3gpalk4heac6lgrq6jz32x33iynmn5q3ktmbejy0gsdw64a5p5', '0');
-- Halsey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7f61ikdrjnh5tt5', 'Halsey', '186@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0fad315ccb6b38517152d2cc','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:186@artist.com', '7f61ikdrjnh5tt5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7f61ikdrjnh5tt5', 'A tapestry of rhythms that echo the pulse of life.', 'Halsey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y0xjd8ucw1s8zhipyourryj9mbre6auxxaaarhac9dph54zbw3','7f61ikdrjnh5tt5', 'https://i.scdn.co/image/ab67616d0000b273f19310c007c0fad365b0542e', 'Lilith (feat. SUGA of BTS) (Diablo IV Anthem)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vohz4aq99qk3vov2esndzjdnjtijghsvsfssyilpr4x5x573tz','Lilith (feat. SUGA of BTS) (Diablo IV Anthem)','7f61ikdrjnh5tt5','POP','3l6LBCOL9nPsSY29TUY2VE',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y0xjd8ucw1s8zhipyourryj9mbre6auxxaaarhac9dph54zbw3', 'vohz4aq99qk3vov2esndzjdnjtijghsvsfssyilpr4x5x573tz', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iomzzk05qcyzfqoj361d4p9lvv123m2h7notqvs2r6gq7jw1jz','Boy With Luv (feat. Halsey)','7f61ikdrjnh5tt5','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y0xjd8ucw1s8zhipyourryj9mbre6auxxaaarhac9dph54zbw3', 'iomzzk05qcyzfqoj361d4p9lvv123m2h7notqvs2r6gq7jw1jz', '1');
-- One Direction
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fuqse4zbob8jifp', 'One Direction', '187@artist.com', 'https://i.scdn.co/image/5bb443424a1ad71603c43d67f5af1a04da6bb3c8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:187@artist.com', 'fuqse4zbob8jifp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fuqse4zbob8jifp', 'An odyssey of sound that defies conventions.', 'One Direction');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('z1fwe0c0xc7e4tzylrfu9esdc5y4qgvwtquxdvxcimd4vkbgnd','fuqse4zbob8jifp', 'https://i.scdn.co/image/ab67616d0000b273d304ba2d71de306812eebaf4', 'FOUR (Deluxe)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ws5bpm6zbbipwo0l9nv3paypv75nyl0kqlwtl9wqp0cn2m8e4r','Night Changes','fuqse4zbob8jifp','POP','5O2P9iiztwhomNh8xkR9lJ','https://p.scdn.co/mp3-preview/359be833b46b250c696bbb64caa5dc91f2a38c6a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z1fwe0c0xc7e4tzylrfu9esdc5y4qgvwtquxdvxcimd4vkbgnd', 'ws5bpm6zbbipwo0l9nv3paypv75nyl0kqlwtl9wqp0cn2m8e4r', '0');
-- P!nk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k0uxtcwvaec7xqp', 'P!nk', '188@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7bbad89a61061304ec842588','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:188@artist.com', 'k0uxtcwvaec7xqp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k0uxtcwvaec7xqp', 'Where words fail, my music speaks.', 'P!nk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kl8a0slv7ben5ywlt3a1gfnp8m1tyyooqt6n9dqpb47reu56hq','k0uxtcwvaec7xqp', 'https://i.scdn.co/image/ab67616d0000b27302f93e92bdd5b3793eb688c0', 'TRUSTFALL','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fhyhqnzio2mofui78doe3qh3hemwe0xnpqpjtdlblhzpn8wocp','TRUSTFALL','k0uxtcwvaec7xqp','POP','4FWbsd91QSvgr1dSWwW51e','https://p.scdn.co/mp3-preview/4a8b78e434e2dda75bc679955c3fbd8b4dad372b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kl8a0slv7ben5ywlt3a1gfnp8m1tyyooqt6n9dqpb47reu56hq', 'fhyhqnzio2mofui78doe3qh3hemwe0xnpqpjtdlblhzpn8wocp', '0');
-- Big One
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pa069jyxeel8dqq', 'Big One', '189@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba4bdcd4a70e31bb4cba3ad34','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:189@artist.com', 'pa069jyxeel8dqq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pa069jyxeel8dqq', 'Bringing a unique energy to every track, fusing various styles into a cohesive sound.', 'Big One');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bknjf5zhvdb4tvxid5u3sx8861xbqh7bijqbl4ikv4rhpci1rl','pa069jyxeel8dqq', NULL, 'Un Finde | CROSSOVER #2','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wvfh41js4pvxwno0nu72qgiu83rz4147ka0cn0tuzl0bqgp9bk','Los del Espacio','pa069jyxeel8dqq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bknjf5zhvdb4tvxid5u3sx8861xbqh7bijqbl4ikv4rhpci1rl', 'wvfh41js4pvxwno0nu72qgiu83rz4147ka0cn0tuzl0bqgp9bk', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c3ftup224e24uejrzx1yiu04d1k9p7eobqxyuto4feeeg8mzj4','Un Finde | CROSSOVER #2','pa069jyxeel8dqq','POP','3tiJUOfAEqIrLFRQgGgdoY','https://p.scdn.co/mp3-preview/38b8f2c063a896c568b9741dcd6e194be0a0376b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bknjf5zhvdb4tvxid5u3sx8861xbqh7bijqbl4ikv4rhpci1rl', 'c3ftup224e24uejrzx1yiu04d1k9p7eobqxyuto4feeeg8mzj4', '1');
-- Kordhell
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('t5noo6n0wldrk26', 'Kordhell', '190@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb15862815bf4d2446b8ecf55f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:190@artist.com', 't5noo6n0wldrk26', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('t5noo6n0wldrk26', 'Where words fail, my music speaks.', 'Kordhell');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('prrvdv7rx5lzyoa0781jl01an2jd5m1byq3ku9pt8kf9ihv0to','t5noo6n0wldrk26', 'https://i.scdn.co/image/ab67616d0000b2731440ffaa43c53d65719e0150', 'Murder In My Mind','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('96a53qd6903xg920h8b8d8mfwfs7jgqoqoaopbsmn348q1lvwq','Murder In My Mind','t5noo6n0wldrk26','POP','6qyS9qBy0mEk3qYaH8mPss','https://p.scdn.co/mp3-preview/ec3b94db31d9fb9821cfea0f7a4cdc9d2a85e969?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('prrvdv7rx5lzyoa0781jl01an2jd5m1byq3ku9pt8kf9ihv0to', '96a53qd6903xg920h8b8d8mfwfs7jgqoqoaopbsmn348q1lvwq', '0');
-- Veigh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pjrstpu4tsmzg0u', 'Veigh', '191@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfe49a8f4b6b1a82a29f43112','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:191@artist.com', 'pjrstpu4tsmzg0u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pjrstpu4tsmzg0u', 'Transcending language barriers through the universal language of music.', 'Veigh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('a5aagpwuexovvn6s2cg8wilk4muvkmjefyyrn78jnxaw0deofw','pjrstpu4tsmzg0u', 'https://i.scdn.co/image/ab67616d0000b273ce0947b85c30490447dbbd91', 'Dos Prédios Deluxe','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p21vzqav6nvaicbowkk75kkem0sh61dxjaovph7gpg66g5toj3','Novo Balan','pjrstpu4tsmzg0u','POP','4hKLzFvNwHF6dPosGT30ed','https://p.scdn.co/mp3-preview/af031ca41aac7b60676833187f323d94fc387bce?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a5aagpwuexovvn6s2cg8wilk4muvkmjefyyrn78jnxaw0deofw', 'p21vzqav6nvaicbowkk75kkem0sh61dxjaovph7gpg66g5toj3', '0');
-- Styrx
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bwwechjkjw15sox', 'Styrx', '192@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb963fa55b3903ca75e781348b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:192@artist.com', 'bwwechjkjw15sox', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bwwechjkjw15sox', 'A sonic adventurer, always seeking new horizons in music.', 'Styrx');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tqauuvc5djv339jhhiqvo2jckwn9ask02wnpxnuedj1rqxdqpo','bwwechjkjw15sox', NULL, 'Styrx Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hl6adjt3dhmpxfubhuxyaoi8fmnybtyp4u575dbo7jlccqkl0v','Agudo Mgi','bwwechjkjw15sox','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tqauuvc5djv339jhhiqvo2jckwn9ask02wnpxnuedj1rqxdqpo', 'hl6adjt3dhmpxfubhuxyaoi8fmnybtyp4u575dbo7jlccqkl0v', '0');
-- sped up 8282
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7iqirwxl3n63r1d', 'sped up 8282', '193@artist.com', 'https://i.scdn.co/image/ab67616d0000b2730a0ba228b5be4ffb7c7c59fb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:193@artist.com', '7iqirwxl3n63r1d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7iqirwxl3n63r1d', 'Music is my canvas, and notes are my paint.', 'sped up 8282');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vp1dkhrclv1g7zwefuh8iftm42y7mtdqej6d1dih68e6wi3dwx','7iqirwxl3n63r1d', 'https://i.scdn.co/image/ab67616d0000b2730a0ba228b5be4ffb7c7c59fb', 'Cupid – Twin Ver. (FIFTY FIFTY) – Sped Up Version','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bc2kp5edfvxaqvw9yosjag4f2zv72xv567jmawmtzozdgbqmij','Cupid  Twin Ver. (FIFTY FIFTY)  Spe','7iqirwxl3n63r1d','POP','3B228N0GxfUCwPyfNcJxps','https://p.scdn.co/mp3-preview/29e8870f55c261ec995edfe4a3e9f30e4d4527e0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vp1dkhrclv1g7zwefuh8iftm42y7mtdqej6d1dih68e6wi3dwx', 'bc2kp5edfvxaqvw9yosjag4f2zv72xv567jmawmtzozdgbqmij', '0');
-- Taiu
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('025ldt9whqnm7t6', 'Taiu', '194@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4d66eec26b41815aa6fcf297','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:194@artist.com', '025ldt9whqnm7t6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('025ldt9whqnm7t6', 'Crafting a unique sonic identity in every track.', 'Taiu');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mz08a1af5ozsba9mqpewz7gephbryjs22raru5aco1vol6wzgy','025ldt9whqnm7t6', 'https://i.scdn.co/image/ab67616d0000b273d467bed4e6b2a01ea8569100', 'Rara Vez','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vxg2lq20jmjxgwl1feiv63hzx4qhv1yxavnzx0k6i1d7qmmqac','Rara Vez','025ldt9whqnm7t6','POP','7MVIfkyzuUmQ716j8U7yGR',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mz08a1af5ozsba9mqpewz7gephbryjs22raru5aco1vol6wzgy', 'vxg2lq20jmjxgwl1feiv63hzx4qhv1yxavnzx0k6i1d7qmmqac', '0');
-- Mac DeMarco
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('o7j8u4y9auz0v8b', 'Mac DeMarco', '195@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3cef7752073cbbd2cc04c6f0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:195@artist.com', 'o7j8u4y9auz0v8b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('o7j8u4y9auz0v8b', 'Music is my canvas, and notes are my paint.', 'Mac DeMarco');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bokdc3yplz1hq2gs258vmjx1ygx6yjdmtzqwk88fbgsaixhvsu','o7j8u4y9auz0v8b', 'https://i.scdn.co/image/ab67616d0000b273fa1323bb50728c7489980672', 'Here Comes The Cowboy','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('llducbibr6r2lwdbm8m6ai268cf6xz1faorn8zbhu7l3v8zu83','Heart To Heart','o7j8u4y9auz0v8b','POP','7EAMXbLcL0qXmciM5SwMh2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bokdc3yplz1hq2gs258vmjx1ygx6yjdmtzqwk88fbgsaixhvsu', 'llducbibr6r2lwdbm8m6ai268cf6xz1faorn8zbhu7l3v8zu83', '0');
-- Mr.Kitty
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('arbi40008uwwf10', 'Mr.Kitty', '196@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb78ed447c78f07632e82ec0d8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:196@artist.com', 'arbi40008uwwf10', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('arbi40008uwwf10', 'Weaving lyrical magic into every song.', 'Mr.Kitty');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2bjssi9b0tfup0uj4ntxs73yym099fsxffv9tykv8bszqnhhb8','arbi40008uwwf10', 'https://i.scdn.co/image/ab67616d0000b273b492477206075438e0751176', 'Time','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e9a00ilsrdzrnaqc1q7q9t1fcskti9sbsfc4wv0bgbi20p3jgs','After Dark','arbi40008uwwf10','POP','2LKOHdMsL0K9KwcPRlJK2v','https://p.scdn.co/mp3-preview/eb9de15a4465f504ee0eadba93e7d265ee0ee6ba?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2bjssi9b0tfup0uj4ntxs73yym099fsxffv9tykv8bszqnhhb8', 'e9a00ilsrdzrnaqc1q7q9t1fcskti9sbsfc4wv0bgbi20p3jgs', '0');
-- d4vd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ovagv90il1nhghd', 'd4vd', '197@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad447187a35f422307e88ad3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:197@artist.com', 'ovagv90il1nhghd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ovagv90il1nhghd', 'Igniting the stage with electrifying performances.', 'd4vd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('40neqigrae98fvbyq9l23orgpbjsizd4xdcpmu19rlwb6i4lv9','ovagv90il1nhghd', 'https://i.scdn.co/image/ab67616d0000b27364fa1bda999f4fbd2b7c4bb7', 'Petals to Thorns','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0vp5f8pz1x2137yuwhaloyitpua6ocbtr20dznrucvffui2rat','Here With Me','ovagv90il1nhghd','POP','5LrN7yUQAzvthd4QujgPFr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('40neqigrae98fvbyq9l23orgpbjsizd4xdcpmu19rlwb6i4lv9', '0vp5f8pz1x2137yuwhaloyitpua6ocbtr20dznrucvffui2rat', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kvdo2qg1bad1gencp1bwz8awy1ugz9h68d84n5429u1jnh1b8w','Romantic Homicide','ovagv90il1nhghd','POP','1xK59OXxi2TAAAbmZK0kBL',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('40neqigrae98fvbyq9l23orgpbjsizd4xdcpmu19rlwb6i4lv9', 'kvdo2qg1bad1gencp1bwz8awy1ugz9h68d84n5429u1jnh1b8w', '1');
-- The Kid Laroi
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jqr2594zx5vqte0', 'The Kid Laroi', '198@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb393666951ab8b14e9c4ed386','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:198@artist.com', 'jqr2594zx5vqte0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jqr2594zx5vqte0', 'The architect of aural landscapes that inspire and captivate.', 'The Kid Laroi');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('filwcd4dzkvichytvfjf2y45f9j32rdpwf9ei7x1syu6ddzbbv','jqr2594zx5vqte0', 'https://i.scdn.co/image/ab67616d0000b273a53643fc03785efb9926443d', 'LOVE AGAIN','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kzl3lb0h9uh7gen2jejsmm1pxtmdibjk31bk2bkm4seyox598z','Love Again','jqr2594zx5vqte0','POP','4sx6NRwL6Ol3V6m9exwGlQ','https://p.scdn.co/mp3-preview/4baae2685eaac7401ae183c54642c9ddf3b9e057?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('filwcd4dzkvichytvfjf2y45f9j32rdpwf9ei7x1syu6ddzbbv', 'kzl3lb0h9uh7gen2jejsmm1pxtmdibjk31bk2bkm4seyox598z', '0');
-- Conan Gray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kk1llsxjjz69zcx', 'Conan Gray', '199@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc1c8fa15e08cb31eeb03b771','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:199@artist.com', 'kk1llsxjjz69zcx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kk1llsxjjz69zcx', 'Harnessing the power of melody to tell compelling stories.', 'Conan Gray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7d70a7vfa2bn6wpftw9f1egl8ji2z3lpjm5lryav5wqr3xouid','kk1llsxjjz69zcx', 'https://i.scdn.co/image/ab67616d0000b27388e3cda6d29b2552d4d6bc43', 'Kid Krow','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zxszilljh46zeeg0c4v9y86e07901f6124md8n51avjmvvod3w','Heather','kk1llsxjjz69zcx','POP','4xqrdfXkTW4T0RauPLv3WA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7d70a7vfa2bn6wpftw9f1egl8ji2z3lpjm5lryav5wqr3xouid', 'zxszilljh46zeeg0c4v9y86e07901f6124md8n51avjmvvod3w', '0');
-- Sebastian Yatra
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xb105o4y8zpug64', 'Sebastian Yatra', '200@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb650a498358171e1990efeeff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:200@artist.com', 'xb105o4y8zpug64', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xb105o4y8zpug64', 'A journey through the spectrum of sound in every album.', 'Sebastian Yatra');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vacdpe36ixfw4n3ekgkz94rlewhuvhnqkp3a61h8yx89utvrq0','xb105o4y8zpug64', 'https://i.scdn.co/image/ab67616d0000b2732d6016751b8ea5e66e83cd04', 'VAGABUNDO','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('typq2eo8qpqepu6ik249x90cu7p7vngyql7aensfqj1ra8eszh','VAGABUNDO','xb105o4y8zpug64','POP','1MB8kTH7VKvAMfL9SHgJmG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vacdpe36ixfw4n3ekgkz94rlewhuvhnqkp3a61h8yx89utvrq0', 'typq2eo8qpqepu6ik249x90cu7p7vngyql7aensfqj1ra8eszh', '0');
-- Kendrick Lamar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wkq073dy80bw7qi', 'Kendrick Lamar', '201@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9c48431caf52a2d0f38433ff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:201@artist.com', 'wkq073dy80bw7qi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wkq073dy80bw7qi', 'The architect of aural landscapes that inspire and captivate.', 'Kendrick Lamar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ahisyf3ava41re8nu5qqadfdfb4dvxi5n8wb5rrz2hy4ktc0h0','wkq073dy80bw7qi', 'https://i.scdn.co/image/ab67616d0000b273d28d2ebdedb220e479743797', 'good kid, m.A.A.d city','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lon1oe73xd2s6rz8xu77lqaaqhhxhe3nlnyaulqpqyu3xma0py','Money Trees','wkq073dy80bw7qi','POP','2HbKqm4o0w5wEeEFXm2sD4',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ahisyf3ava41re8nu5qqadfdfb4dvxi5n8wb5rrz2hy4ktc0h0', 'lon1oe73xd2s6rz8xu77lqaaqhhxhe3nlnyaulqpqyu3xma0py', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w4js8yjrtli4yzd0584f5b87j2fl49fh9i6mlt47opg3byuo74','AMERICA HAS A PROBLEM (feat. Kendrick Lamar)','wkq073dy80bw7qi','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ahisyf3ava41re8nu5qqadfdfb4dvxi5n8wb5rrz2hy4ktc0h0', 'w4js8yjrtli4yzd0584f5b87j2fl49fh9i6mlt47opg3byuo74', '1');
-- Lord Huron
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('95zoyh11dh8kdo9', 'Lord Huron', '202@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1d4e4e7e3c5d8fa494fc5f10','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:202@artist.com', '95zoyh11dh8kdo9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('95zoyh11dh8kdo9', 'A unique voice in the contemporary music scene.', 'Lord Huron');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tey7b6w4fp0j5gy214yzmkxwqeqz6s6518nqr3fojzi1vys6e3','95zoyh11dh8kdo9', 'https://i.scdn.co/image/ab67616d0000b2739d2efe43d5b7ebc7cb60ca81', 'Strange Trails','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d5z17hvjajnhvgb66sxsbzetbxzdxtpaaedjauacqmzva6br6g','The Night We Met','95zoyh11dh8kdo9','POP','0QZ5yyl6B6utIWkxeBDxQN','https://p.scdn.co/mp3-preview/f10f271b165ee07e3d49d9f961d08b7ad74ebd5b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tey7b6w4fp0j5gy214yzmkxwqeqz6s6518nqr3fojzi1vys6e3', 'd5z17hvjajnhvgb66sxsbzetbxzdxtpaaedjauacqmzva6br6g', '0');
-- ENHYPEN
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('167h5hqn1g400za', 'ENHYPEN', '203@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a48a236a01fa62db8c7a6f6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:203@artist.com', '167h5hqn1g400za', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('167h5hqn1g400za', 'Revolutionizing the music scene with innovative compositions.', 'ENHYPEN');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('b1j895csvs55v2a6d65ee729a2kn29gp0rgv0x2qsitw4n6b79','167h5hqn1g400za', 'https://i.scdn.co/image/ab67616d0000b2731d03b5e88cee6870778a4d27', 'DARK BLOOD','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y2746hf9t4z98u0gns6fulssxjxmilltfj5fjlbytdpekwze6c','Bite Me','167h5hqn1g400za','POP','7mpdNiaQvygj2rHoxkzMfa','https://p.scdn.co/mp3-preview/ff4e3c3d8464e572759ba2169332743c2889d97e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('b1j895csvs55v2a6d65ee729a2kn29gp0rgv0x2qsitw4n6b79', 'y2746hf9t4z98u0gns6fulssxjxmilltfj5fjlbytdpekwze6c', '0');
-- Coldplay
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ph37prhrq2yc5gx', 'Coldplay', '204@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb989ed05e1f0570cc4726c2d3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:204@artist.com', 'ph37prhrq2yc5gx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ph37prhrq2yc5gx', 'Global icons in rock, known for their anthemic songs and impactful lyrics.', 'Coldplay');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ba1xbopar6gcgjjpf68xd6l4sxbjq6fax72ap1x3h4drnt3hmn','ph37prhrq2yc5gx', 'https://i.scdn.co/image/ab67616d0000b273e21cc1db05580b6f2d2a3b6e', 'Viva La Vida or Death and All His Friends','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p6buvr0al4bhahx6oi88qrk2aeusf8ep3wrc4hcc504kpiw070','Viva La Vida','ph37prhrq2yc5gx','POP','1mea3bSkSGXuIRvnydlB5b','https://p.scdn.co/mp3-preview/fb9f4a9b0887326776b4fb7c6d331acd167a7778?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ba1xbopar6gcgjjpf68xd6l4sxbjq6fax72ap1x3h4drnt3hmn', 'p6buvr0al4bhahx6oi88qrk2aeusf8ep3wrc4hcc504kpiw070', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sj15r5nn9ozclqocv9j1ymlpqu2qkh6y9rclif3bscw9m9pqt4','My Universe','ph37prhrq2yc5gx','POP','3FeVmId7tL5YN8B7R3imoM','https://p.scdn.co/mp3-preview/e6b780d0df7927114477a786b6a638cf40d19579?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ba1xbopar6gcgjjpf68xd6l4sxbjq6fax72ap1x3h4drnt3hmn', 'sj15r5nn9ozclqocv9j1ymlpqu2qkh6y9rclif3bscw9m9pqt4', '1');
-- Radiohead
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lkke6o0z0u3g9ep', 'Radiohead', '205@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba03696716c9ee605006047fd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:205@artist.com', 'lkke6o0z0u3g9ep', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lkke6o0z0u3g9ep', 'Striking chords that resonate across generations.', 'Radiohead');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2g4iggjc63snbq84aeyyd5g6nhj8gnhz61wxtnjxz1ge2yfwol','lkke6o0z0u3g9ep', 'https://i.scdn.co/image/ab67616d0000b273df55e326ed144ab4f5cecf95', 'Pablo Honey','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sihb67i3rnqeh0knp2i8vx0wa13mw2qekj3bj0fp8xlr24atfv','Creep','lkke6o0z0u3g9ep','POP','70LcF31zb1H0PyJoS1Sx1r','https://p.scdn.co/mp3-preview/713b601d02641a850f2a3e6097aacaff52328d57?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2g4iggjc63snbq84aeyyd5g6nhj8gnhz61wxtnjxz1ge2yfwol', 'sihb67i3rnqeh0knp2i8vx0wa13mw2qekj3bj0fp8xlr24atfv', '0');
-- Lil Durk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('19sq9fdm9ubpt8h', 'Lil Durk', '206@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba0461c1f2218374aa672ce4e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:206@artist.com', '19sq9fdm9ubpt8h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('19sq9fdm9ubpt8h', 'An endless quest for musical perfection.', 'Lil Durk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5rrttqehjgtlj3bu8thxrsuygmfxv4sju8cmx9xwtoxosnithx','19sq9fdm9ubpt8h', 'https://i.scdn.co/image/ab67616d0000b2736234c2c6d4bb935839ac4719', 'Almost Healed','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tzgmn5fh9iqkyfmmt7ikt8f994zileqpk2hwpx9p6socab0mci','Stand By Me (feat. Morgan Wallen)','19sq9fdm9ubpt8h','POP','1fXnu2HzxbDtoyvFPWG3Bw','https://p.scdn.co/mp3-preview/ed64766975b1f0b3aa57741935c3f20e833c47db?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5rrttqehjgtlj3bu8thxrsuygmfxv4sju8cmx9xwtoxosnithx', 'tzgmn5fh9iqkyfmmt7ikt8f994zileqpk2hwpx9p6socab0mci', '0');
-- Doechii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('glk3t6prfu5gtmh', 'Doechii', '207@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5f9f729e1e5182fbf1030dbe','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:207@artist.com', 'glk3t6prfu5gtmh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('glk3t6prfu5gtmh', 'Breaking barriers with her unique sound and powerful lyrical storytelling.', 'Doechii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('h7k93zhbi2mbm489fcwzrhdf310ru6aa0erqeel1zhsctirq5y','glk3t6prfu5gtmh', 'https://i.scdn.co/image/ab67616d0000b2732ee85751f6f503fa9a533eba', 'What It Is (Versions)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2nzugfcttpci0etdprux153ipzgsfhsdkcel9kepgf96jsc9iw','What It Is (Solo Version)','glk3t6prfu5gtmh','POP','73RbfOTJIjHzi2pcVHjeHM',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h7k93zhbi2mbm489fcwzrhdf310ru6aa0erqeel1zhsctirq5y', '2nzugfcttpci0etdprux153ipzgsfhsdkcel9kepgf96jsc9iw', '0');
-- JISOO
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ngdplad2vsrq3g6', 'JISOO', '208@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcb6017286dd64ca6b77c879f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:208@artist.com', 'ngdplad2vsrq3g6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ngdplad2vsrq3g6', 'Uniting fans around the globe with universal rhythms.', 'JISOO');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l6k5y06au8myq8humm6dajxn7wizc4ok08mb998pd2mq1xfrw8','ngdplad2vsrq3g6', 'https://i.scdn.co/image/ab67616d0000b273f35b8a6c03cc633f734bd8ac', 'ME','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qciwefrc203scw3fxv06xonm4fpef28e5tfg1pzzfux0p1hrc4','FLOWER','ngdplad2vsrq3g6','POP','69CrOS7vEHIrhC2ILyEi0s',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l6k5y06au8myq8humm6dajxn7wizc4ok08mb998pd2mq1xfrw8', 'qciwefrc203scw3fxv06xonm4fpef28e5tfg1pzzfux0p1hrc4', '0');
-- Jack Harlow
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('babfq36p2iszuaq', 'Jack Harlow', '209@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5ee4635b0775e342e064657','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:209@artist.com', 'babfq36p2iszuaq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('babfq36p2iszuaq', 'A journey through the spectrum of sound in every album.', 'Jack Harlow');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ljnpvqzuss0qwpw1opu4dz5imbhwinq7josc7m0iyi3xeqmmhd','babfq36p2iszuaq', NULL, 'Jack Harlow Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s3tw7awkllbyfxhc021jx0hqrk3root7743x04ynai2eum4o0v','INDUSTRY BABY (feat. Jack Harlow)','babfq36p2iszuaq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ljnpvqzuss0qwpw1opu4dz5imbhwinq7josc7m0iyi3xeqmmhd', 's3tw7awkllbyfxhc021jx0hqrk3root7743x04ynai2eum4o0v', '0');
-- Calvin Harris
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kqlqhenxnlvso4r', 'Calvin Harris', '210@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb37bff6aa1d42bede9048750f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:210@artist.com', 'kqlqhenxnlvso4r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kqlqhenxnlvso4r', 'An endless quest for musical perfection.', 'Calvin Harris');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zul5tgjslxct4pk0fa28e54yafps6xhozo76lnftth1dk1ms4z','kqlqhenxnlvso4r', 'https://i.scdn.co/image/ab67616d0000b273c58e22815048f8dfb1aa8bd0', 'Miracle (with Ellie Goulding)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6i4d4z6al3f6iphta1x9lvbsbkr6zymb7uq6ejnd408m74x296','Miracle (with Ellie Goulding)','kqlqhenxnlvso4r','POP','5eTaQYBE1yrActixMAeLcZ','https://p.scdn.co/mp3-preview/48a88093bc85e735791115290125fc354f8ed068?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zul5tgjslxct4pk0fa28e54yafps6xhozo76lnftth1dk1ms4z', '6i4d4z6al3f6iphta1x9lvbsbkr6zymb7uq6ejnd408m74x296', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2bbiqmscjhw2tme07y74qpqb3d1ry2s37x5itc09g73039ffpl','One Kiss (with Dua Lipa)','kqlqhenxnlvso4r','POP','7ef4DlsgrMEH11cDZd32M6','https://p.scdn.co/mp3-preview/0c09da1fe6f1da091c05057835e6be2312e2dc18?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zul5tgjslxct4pk0fa28e54yafps6xhozo76lnftth1dk1ms4z', '2bbiqmscjhw2tme07y74qpqb3d1ry2s37x5itc09g73039ffpl', '1');
-- El Chachito
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qpnfn3r9zsv3zxx', 'El Chachito', '211@artist.com', 'https://i.scdn.co/image/ab67616d0000b27354c372ef8e7b53bb3c932ac5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:211@artist.com', 'qpnfn3r9zsv3zxx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qpnfn3r9zsv3zxx', 'Breathing new life into classic genres.', 'El Chachito');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ef2ej5sbhvoodj1a8kr767pj6zzvjyp2ajnxo7mbag0r1xh1rt','qpnfn3r9zsv3zxx', 'https://i.scdn.co/image/ab67616d0000b27354c372ef8e7b53bb3c932ac5', 'En Paris','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jev7moro1lmf3vtvaqb7tjiv9csmceftjzbws0qj0us72jhlim','En Paris','qpnfn3r9zsv3zxx','POP','1Fuc3pBiPFxAeSJoO8tDh5','https://p.scdn.co/mp3-preview/c57f1229ca237b01f9dbd839bc3ca97f22395a87?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ef2ej5sbhvoodj1a8kr767pj6zzvjyp2ajnxo7mbag0r1xh1rt', 'jev7moro1lmf3vtvaqb7tjiv9csmceftjzbws0qj0us72jhlim', '0');
-- Tini
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5abdondt99i0bge', 'Tini', '212@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd1ee0c41d3c79e916b910696','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:212@artist.com', '5abdondt99i0bge', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5abdondt99i0bge', 'A confluence of cultural beats and contemporary tunes.', 'Tini');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ow1nijydtzyze4jhyibhhyf7rryplzcf6eenkikk1c7g16gbez','5abdondt99i0bge', 'https://i.scdn.co/image/ab67616d0000b273f5409c637b9a7244e0c0d11d', 'Cupido','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d5k7fuxye48mi9gsk15qlrwdx09o2buntaxqjzgvew5glxl74r','Cupido','5abdondt99i0bge','POP','04ndZkbKGthTgYSv3xS7en','https://p.scdn.co/mp3-preview/15bc4fa0d69ae03a045704bcc8731def7453458b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ow1nijydtzyze4jhyibhhyf7rryplzcf6eenkikk1c7g16gbez', 'd5k7fuxye48mi9gsk15qlrwdx09o2buntaxqjzgvew5glxl74r', '0');
-- LE SSERAFIM
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('79c17otlshg6n55', 'LE SSERAFIM', '213@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb99752c006407988976248679','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:213@artist.com', '79c17otlshg6n55', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('79c17otlshg6n55', 'Blending traditional rhythms with modern beats.', 'LE SSERAFIM');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d6liv6d4fdz85trkpa8zeco94qrpyzz22hvvecfa6dj3am0nx7','79c17otlshg6n55', 'https://i.scdn.co/image/ab67616d0000b273d71fd77b89d08bc1bda219c7', 'UNFORGIVEN','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ftaxbexwcmfulqbh4rd6hjyij2nrqf7ap0clng9ofmbjtwzuk2','ANTIFRAGILE','79c17otlshg6n55','POP','0bMoNdAnxNR0OuQbGDovrr','https://p.scdn.co/mp3-preview/c34779ecfb7b14b69518e8489df2227b02272772?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d6liv6d4fdz85trkpa8zeco94qrpyzz22hvvecfa6dj3am0nx7', 'ftaxbexwcmfulqbh4rd6hjyij2nrqf7ap0clng9ofmbjtwzuk2', '0');
-- Travis Scott
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('buvgc2oue9w7zmv', 'Travis Scott', '214@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb19c2790744c792d05570bb71','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:214@artist.com', 'buvgc2oue9w7zmv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('buvgc2oue9w7zmv', 'Where words fail, my music speaks.', 'Travis Scott');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g8rslqmt9plxmxuw2xnma1yfhtkpu6vf83lckvjr0k0okyn862','buvgc2oue9w7zmv', NULL, 'Travis Scott Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('25mp65tpy930vpb2ub8si95fgjauualcp402i43z5c71rnsg08','Trance (with Travis Scott & Young Thug)','buvgc2oue9w7zmv','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g8rslqmt9plxmxuw2xnma1yfhtkpu6vf83lckvjr0k0okyn862', '25mp65tpy930vpb2ub8si95fgjauualcp402i43z5c71rnsg08', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jh7x84qcn1m1eawxcuyhw1sdwfrhy0kg8pig27c58r5waros9y','Niagara Falls (Foot or 2) [with Travis Scott & 21 Savage]','buvgc2oue9w7zmv','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g8rslqmt9plxmxuw2xnma1yfhtkpu6vf83lckvjr0k0okyn862', 'jh7x84qcn1m1eawxcuyhw1sdwfrhy0kg8pig27c58r5waros9y', '1');
-- Peggy Gou
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pw2uom25ohv56uf', 'Peggy Gou', '215@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf5c17aa075c03c5c4d2c693','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:215@artist.com', 'pw2uom25ohv56uf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pw2uom25ohv56uf', 'A dynamic force in the electronic music scene, known for her eclectic mixes.', 'Peggy Gou');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rrbbvu12vr3sz5vn54sfi4tl8s07bd81t5m4omud2k03nu5eeb','pw2uom25ohv56uf', 'https://i.scdn.co/image/ab67616d0000b27388d71aadd009fe1a83df88f2', '(It Goes Like) Nanana [Edit]','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z4m3f9onl0w1efd6ywv02vb1x2esh0co7iykalepnw3z93i1z6','(It Goes Like) Nanana - Edit','pw2uom25ohv56uf','POP','23RoR84KodL5HWvUTneQ1w','https://p.scdn.co/mp3-preview/e36e0bd4714844f1f9d992398b41a3e333f15cc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rrbbvu12vr3sz5vn54sfi4tl8s07bd81t5m4omud2k03nu5eeb', 'z4m3f9onl0w1efd6ywv02vb1x2esh0co7iykalepnw3z93i1z6', '0');
-- Bellakath
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s428bxw6dab837u', 'Bellakath', '216@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb008a12ca09c3acec7c536d53','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:216@artist.com', 's428bxw6dab837u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s428bxw6dab837u', 'Blending genres for a fresh musical experience.', 'Bellakath');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cppaefohfwoq94sfot3b2hnnbnfyrma5fjrx5spy33dohpkfhv','s428bxw6dab837u', 'https://i.scdn.co/image/ab67616d0000b273584e78471da03acbc05dde0b', 'Gatita','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vexjg6i0tujmnff33onqx17yc6o4em6i3exugs7z39gxr44e3k','Gatita','s428bxw6dab837u','POP','4ilZV1WNjL7IxwE81OnaRY','https://p.scdn.co/mp3-preview/ed363508374055584f0a42a003473c065fbe4f61?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cppaefohfwoq94sfot3b2hnnbnfyrma5fjrx5spy33dohpkfhv', 'vexjg6i0tujmnff33onqx17yc6o4em6i3exugs7z39gxr44e3k', '0');
-- Leo Santana
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u9ytpjsv4j9x6g6', 'Leo Santana', '217@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9c301d2486e33ad58c85db8e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:217@artist.com', 'u9ytpjsv4j9x6g6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u9ytpjsv4j9x6g6', 'Uniting fans around the globe with universal rhythms.', 'Leo Santana');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hwwgrb2m0f7jlke88krl3lpwbv85dhcqzj61t8tgkhixohrsyv','u9ytpjsv4j9x6g6', 'https://i.scdn.co/image/ab67616d0000b273799dcbf5dcd77cea4549cbca', 'Confraternização da Firma 2023','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rsrbaxc8kgjm6ucgv4zbakqmloa5oxbvj5i83czk5a33so3kqy','Zona De Perigo','u9ytpjsv4j9x6g6','POP','04I2t1UTcXUNk0mWy1dRGd',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hwwgrb2m0f7jlke88krl3lpwbv85dhcqzj61t8tgkhixohrsyv', 'rsrbaxc8kgjm6ucgv4zbakqmloa5oxbvj5i83czk5a33so3kqy', '0');
-- Cartel De Santa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s6jin807y4eztmc', 'Cartel De Santa', '218@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:218@artist.com', 's6jin807y4eztmc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s6jin807y4eztmc', 'Elevating the ordinary to extraordinary through music.', 'Cartel De Santa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j6x7aqrza1wzimtpy4icn3dtswo6nf767ajv14dywdsfvdlt20','s6jin807y4eztmc', 'https://i.scdn.co/image/ab67616d0000b273608e249e118a39e897f149ce', 'Shorty Party','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g41l3yywaavxd587wh0ntlynz9axl6fk4ckdvgn8z9g2ymxnlo','Shorty Party','s6jin807y4eztmc','POP','55ZATsjPlTeSTNJOuW90pW','https://p.scdn.co/mp3-preview/861a31225cff10db2eedeb5c28bf6d0a4ecc4bc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j6x7aqrza1wzimtpy4icn3dtswo6nf767ajv14dywdsfvdlt20', 'g41l3yywaavxd587wh0ntlynz9axl6fk4ckdvgn8z9g2ymxnlo', '0');
-- Lizzo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qies3kngt84o3cs', 'Lizzo', '219@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0d66b3670294bf801847dae2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:219@artist.com', 'qies3kngt84o3cs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qies3kngt84o3cs', 'Elevating the ordinary to extraordinary through music.', 'Lizzo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qm6ipmuabx0coki4zssz0bh89y9oxf1sgugq0krygzhmxv2sa4','qies3kngt84o3cs', 'https://i.scdn.co/image/ab67616d0000b273b817e721691aff3d67f26c04', 'About Damn Time','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s3mvl93lzxczojvi2o9vk0eoy29ujnroidh1ixzn2n435d4sb2','About Damn Time','qies3kngt84o3cs','POP','1PckUlxKqWQs3RlWXVBLw3','https://p.scdn.co/mp3-preview/bbf8a26d38f7d8c7191dd64bd7c21a4cec8b61a0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qm6ipmuabx0coki4zssz0bh89y9oxf1sgugq0krygzhmxv2sa4', 's3mvl93lzxczojvi2o9vk0eoy29ujnroidh1ixzn2n435d4sb2', '0');
-- Sean Paul
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('eolv6cjc575466a', 'Sean Paul', '220@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb60c3e9abe7327c0097738f22','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:220@artist.com', 'eolv6cjc575466a', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('eolv6cjc575466a', 'A unique voice in the contemporary music scene.', 'Sean Paul');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8i036uc6zx9l1x9c068tffxlpase8eeb4maki2qp68ct3jot7p','eolv6cjc575466a', NULL, 'Sean Paul Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zit5dg0ul9f6psbhj40j77twa655su35nc00uhwrgjqg49psvl','Nia Bo','eolv6cjc575466a','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8i036uc6zx9l1x9c068tffxlpase8eeb4maki2qp68ct3jot7p', 'zit5dg0ul9f6psbhj40j77twa655su35nc00uhwrgjqg49psvl', '0');
-- Nengo Flow
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ghcv217nmog5qit', 'Nengo Flow', '221@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebda3f48cf2309aacaab0edce2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:221@artist.com', 'ghcv217nmog5qit', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ghcv217nmog5qit', 'Creating a tapestry of tunes that celebrates diversity.', 'Nengo Flow');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1stcspoq2kfeemtf66mn5liigkd1d9ywjp17zyd1t3pwjr9x98','ghcv217nmog5qit', 'https://i.scdn.co/image/ab67616d0000b273ed132404686f567c8f793058', 'Gato de Noche','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8ujpgybipx8sw14vwdx97a7gbxhgnpwky2vj20a94i0veicruj','Gato de Noche','ghcv217nmog5qit','POP','54ELExv56KCAB4UP9cOCzC','https://p.scdn.co/mp3-preview/7d6a9dab2f3779eef37ef52603d20607a1390d91?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1stcspoq2kfeemtf66mn5liigkd1d9ywjp17zyd1t3pwjr9x98', '8ujpgybipx8sw14vwdx97a7gbxhgnpwky2vj20a94i0veicruj', '0');
-- ThxSoMch
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yzfa3x0m3z9qyam', 'ThxSoMch', '222@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcce84671d294b0cefb8fe1c0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:222@artist.com', 'yzfa3x0m3z9qyam', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yzfa3x0m3z9qyam', 'A unique voice in the contemporary music scene.', 'ThxSoMch');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pxcr2n0zeyhyoioq30cfuygk6nm9l3c2pvx5hyvd7a3qhsp38w','yzfa3x0m3z9qyam', 'https://i.scdn.co/image/ab67616d0000b27360ddc59c8d590a37cf2348f3', 'SPIT IN MY FACE!','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6z8zc4bhle3ve1e2qagjjambezqi46xxe2ryauakb3cvswd8hr','SPIT IN MY FACE!','yzfa3x0m3z9qyam','POP','1N8TTK1Uoy7UvQNUazfUt5','https://p.scdn.co/mp3-preview/a4146e5dd430d70eda83e57506ba5ed402935200?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pxcr2n0zeyhyoioq30cfuygk6nm9l3c2pvx5hyvd7a3qhsp38w', '6z8zc4bhle3ve1e2qagjjambezqi46xxe2ryauakb3cvswd8hr', '0');
-- Troye Sivan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pscqypzeel4a6p7', 'Troye Sivan', '223@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26e8cb3ff6fc7744b312811b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:223@artist.com', 'pscqypzeel4a6p7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pscqypzeel4a6p7', 'A voice that encapsulates the spirit of modern pop.', 'Troye Sivan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gvwaxxpflulfqpdf9k4tb11fnvq5r6rxg3gcltly37gok8pgp6','pscqypzeel4a6p7', 'https://i.scdn.co/image/ab67616d0000b27367103283a4eb57578a428252', 'Something To Give Each Other','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hv34s5qrxm9vjy13ydk9oyv6swml8nucqrxy00f03wlsb8xtw8','Rush','pscqypzeel4a6p7','POP','4ZnkygoWLzcGbQYCm3lkae',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gvwaxxpflulfqpdf9k4tb11fnvq5r6rxg3gcltly37gok8pgp6', 'hv34s5qrxm9vjy13ydk9oyv6swml8nucqrxy00f03wlsb8xtw8', '0');
-- j-hope
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tug3j9qyo8dtckc', 'j-hope', '224@artist.com', 'https://i.scdn.co/image/e8a48dd66904570087b66f1196b900554aef78a0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:224@artist.com', 'tug3j9qyo8dtckc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tug3j9qyo8dtckc', 'A harmonious blend of passion and creativity.', 'j-hope');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4bij2wt71lid1q3vh41w2h2uj1v06rwwa09oqc74o64cm6max1','tug3j9qyo8dtckc', 'https://i.scdn.co/image/ab67616d0000b2735e8286ff63f7efce1881a02b', 'on the street (with J. Cole)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a1g36yl3xnfrocpj16s1c52w6ku3je39yly8xtz37oej11clw0','on the street (with J. Cole)','tug3j9qyo8dtckc','POP','5wxYxygyHpbgv0EXZuqb9V','https://p.scdn.co/mp3-preview/c69cf6ed41027bd08a5953b556cca144ff8ed2bf?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4bij2wt71lid1q3vh41w2h2uj1v06rwwa09oqc74o64cm6max1', 'a1g36yl3xnfrocpj16s1c52w6ku3je39yly8xtz37oej11clw0', '0');
-- Frank Ocean
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xcmihkn4ty25znr', 'Frank Ocean', '225@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebee3123e593174208f9754fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:225@artist.com', 'xcmihkn4ty25znr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xcmihkn4ty25znr', 'Redefining what it means to be an artist in the digital age.', 'Frank Ocean');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2h2err63ur446ylc55z3jp8li8wer1eg6kf9xo2akrpqdvteq7','xcmihkn4ty25znr', 'https://i.scdn.co/image/ab67616d0000b273c5649add07ed3720be9d5526', 'Blonde','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j1kf4b9ope0xctf49kkn14rvl1o80v4aqmgj10uwtauh8j7mw2','Pink + White','xcmihkn4ty25znr','POP','3xKsf9qdS1CyvXSMEid6g8','https://p.scdn.co/mp3-preview/0e3ca894e19c37cbbbd511d9eb682d8bee030126?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2h2err63ur446ylc55z3jp8li8wer1eg6kf9xo2akrpqdvteq7', 'j1kf4b9ope0xctf49kkn14rvl1o80v4aqmgj10uwtauh8j7mw2', '0');
-- Drake
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dp8o65lo79vkcb2', 'Drake', '226@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4293385d324db8558179afd9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:226@artist.com', 'dp8o65lo79vkcb2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dp8o65lo79vkcb2', 'Crafting melodies that resonate with the soul.', 'Drake');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sem1au2atwabr13hw35uu10h3hks6igr1l6qt4mu9vjn1agdop','dp8o65lo79vkcb2', 'https://i.scdn.co/image/ab67616d0000b2738dc0d801766a5aa6a33cbe37', 'Honestly, Nevermind','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zpqqy1pzs7cd4ayncwuqg2ffm7z8wzdb8azu15xkuyenq55v5e','Jimmy Cooks (feat. 21 Savage)','dp8o65lo79vkcb2','POP','3F5CgOj3wFlRv51JsHbxhe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sem1au2atwabr13hw35uu10h3hks6igr1l6qt4mu9vjn1agdop', 'zpqqy1pzs7cd4ayncwuqg2ffm7z8wzdb8azu15xkuyenq55v5e', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('or89h6stg7q9u047b56xhnkobb1rjhdp6fnrobxq4j2wfo6g62','One Dance','dp8o65lo79vkcb2','POP','1zi7xx7UVEFkmKfv06H8x0',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sem1au2atwabr13hw35uu10h3hks6igr1l6qt4mu9vjn1agdop', 'or89h6stg7q9u047b56xhnkobb1rjhdp6fnrobxq4j2wfo6g62', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7j5wz8lftyj9e8h82c3eu8pob68tjpgboogm7b8yqx8m3cbyfm','Search & Rescue','dp8o65lo79vkcb2','POP','7aRCf5cLOFN1U7kvtChY1G',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sem1au2atwabr13hw35uu10h3hks6igr1l6qt4mu9vjn1agdop', '7j5wz8lftyj9e8h82c3eu8pob68tjpgboogm7b8yqx8m3cbyfm', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n8qr7hs3km9m49bfcujyueh9zhbn6bgfcx0ofqn1cvfmmfiij9','Rich Flex','dp8o65lo79vkcb2','POP','1bDbXMyjaUIooNwFE9wn0N',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sem1au2atwabr13hw35uu10h3hks6igr1l6qt4mu9vjn1agdop', 'n8qr7hs3km9m49bfcujyueh9zhbn6bgfcx0ofqn1cvfmmfiij9', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('60m438p4gz7blq0uffzjv6l0l6gu7gtkrnkw1cndkc2oqpnnb3','WAIT FOR U (feat. Drake & Tems)','dp8o65lo79vkcb2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sem1au2atwabr13hw35uu10h3hks6igr1l6qt4mu9vjn1agdop', '60m438p4gz7blq0uffzjv6l0l6gu7gtkrnkw1cndkc2oqpnnb3', '4');
-- New West
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hx0hncuyxt7uhli', 'New West', '227@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb32a5faa77c82348cf5d13590','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:227@artist.com', 'hx0hncuyxt7uhli', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hx0hncuyxt7uhli', 'A maestro of melodies, orchestrating auditory bliss.', 'New West');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i41kp89ewnjhf499wnuowglxhyp3jdt1910ffkouty4qltf4ct','hx0hncuyxt7uhli', 'https://i.scdn.co/image/ab67616d0000b2731bb5dc21200bfc56d8f7ef41', 'Those Eyes','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j3u2bu12u7kt5yhf5cq15xb78pytwxf4m1yh03oyssym60xchx','Those Eyes','hx0hncuyxt7uhli','POP','50x1Ic8CaXkYNvjmxe3WXy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i41kp89ewnjhf499wnuowglxhyp3jdt1910ffkouty4qltf4ct', 'j3u2bu12u7kt5yhf5cq15xb78pytwxf4m1yh03oyssym60xchx', '0');
-- Quevedo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z5oo6o8rlybvqb1', 'Quevedo', '228@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2394e996716534bc2c937a1a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:228@artist.com', 'z5oo6o8rlybvqb1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z5oo6o8rlybvqb1', 'Merging lyrical depth with compelling urban beats.', 'Quevedo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3v9zyedm8bee6rptqtsap9nsq342e04e31wycx5diidtefi7sj','z5oo6o8rlybvqb1', 'https://i.scdn.co/image/ab67616d0000b273a00a817b017c6f6bf8460be9', 'Columbia','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('78dxyn629uom0wuuwhs27mqp3abrnrn9x47yr7elqrkakockc2','Columbia','z5oo6o8rlybvqb1','POP','6XbtvPmIpyCbjuT0e8cQtp','https://p.scdn.co/mp3-preview/e3d6df66fe67f618166a2cab858580ac8a96486a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3v9zyedm8bee6rptqtsap9nsq342e04e31wycx5diidtefi7sj', '78dxyn629uom0wuuwhs27mqp3abrnrn9x47yr7elqrkakockc2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e7thp358q1ov03lhs3xp7rzu5ehx662tyra3a6oxpbd8botrar','Punto G','z5oo6o8rlybvqb1','POP','4WiQA1AGWHFvaxBU6bHghs','https://p.scdn.co/mp3-preview/a1275d1dcfb4c25bc48821b19b81ff853386c148?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3v9zyedm8bee6rptqtsap9nsq342e04e31wycx5diidtefi7sj', 'e7thp358q1ov03lhs3xp7rzu5ehx662tyra3a6oxpbd8botrar', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bsziyxrshjvccqrui51wzz2kkbvig8swsor7pokfhpzwsbuf7g','Mami Chula','z5oo6o8rlybvqb1','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3v9zyedm8bee6rptqtsap9nsq342e04e31wycx5diidtefi7sj', 'bsziyxrshjvccqrui51wzz2kkbvig8swsor7pokfhpzwsbuf7g', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vqibkbpfdietxkitns3pehf4xijdlvl4lgugbnisq8tyyy4jqa','WANDA','z5oo6o8rlybvqb1','POP','0Iozrbed8spxoBnmtBMshO','https://p.scdn.co/mp3-preview/a6de4c6031032d886d67e88ec6db1a1c521ed023?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3v9zyedm8bee6rptqtsap9nsq342e04e31wycx5diidtefi7sj', 'vqibkbpfdietxkitns3pehf4xijdlvl4lgugbnisq8tyyy4jqa', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5uxb6dtx500wj6bfuws6j4217xbfiwd8ajjvd4a2j3zyz3slfh','Vista Al Mar','z5oo6o8rlybvqb1','POP','5q86iSKkBtOoNkdgEDY5WV','https://p.scdn.co/mp3-preview/6896535fbb6690492102bdb7ca181f33de63ef4e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3v9zyedm8bee6rptqtsap9nsq342e04e31wycx5diidtefi7sj', '5uxb6dtx500wj6bfuws6j4217xbfiwd8ajjvd4a2j3zyz3slfh', '4');
-- Lady Gaga
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('04r1fjd1o1acnkw', 'Lady Gaga', '229@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc8d3d98a1bccbe71393dbfbf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:229@artist.com', '04r1fjd1o1acnkw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('04r1fjd1o1acnkw', 'A journey through the spectrum of sound in every album.', 'Lady Gaga');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nsqryin7ec1tq3x8uf60euk4qy5qh0hy0qndemyuiutkqem0f4','04r1fjd1o1acnkw', 'https://i.scdn.co/image/ab67616d0000b273a47c0e156ea3cebe37fdcab8', 'Born This Way (Special Edition)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8ca7epjzb7r1xhtqu3sjir3fsidklbaspe9tlh8sb05y375ixg','Bloody Mary','04r1fjd1o1acnkw','POP','11BKm0j4eYoCPPpCONAVwA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nsqryin7ec1tq3x8uf60euk4qy5qh0hy0qndemyuiutkqem0f4', '8ca7epjzb7r1xhtqu3sjir3fsidklbaspe9tlh8sb05y375ixg', '0');
-- Kenia OS
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0anaxjrg3a45xu9', 'Kenia OS', '230@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7cee297b5eaaa121f9558d7e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:230@artist.com', '0anaxjrg3a45xu9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0anaxjrg3a45xu9', 'Exploring the depths of sound and rhythm.', 'Kenia OS');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('siwe7y950puxc3f7zk2jn0la9ydrksccc1ha24tz1p9bf8n1ow','0anaxjrg3a45xu9', 'https://i.scdn.co/image/ab67616d0000b2739afe5698b0a9559dabc44ac8', 'K23','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ykcek331g7sw5zbqdwtszt9se41d81ci253l076ayl2mcoozfg','Malas Decisiones','0anaxjrg3a45xu9','POP','6Xj014IHwbLVjiVT6H89on','https://p.scdn.co/mp3-preview/9a71f09b224a9e6f521743423bd53e99c7c4793c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('siwe7y950puxc3f7zk2jn0la9ydrksccc1ha24tz1p9bf8n1ow', 'ykcek331g7sw5zbqdwtszt9se41d81ci253l076ayl2mcoozfg', '0');
-- Ray Dalton
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d1fl8wels7rdzdb', 'Ray Dalton', '231@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb761f04a794923fde50fcb9fb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:231@artist.com', 'd1fl8wels7rdzdb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('d1fl8wels7rdzdb', 'A maestro of melodies, orchestrating auditory bliss.', 'Ray Dalton');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7tqavp01q4djgxttsw95hz28fneop3g48w1qmoer013o94ns0r','d1fl8wels7rdzdb', NULL, 'Ray Dalton Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s63pumtmm9v4xowdzw6wlybixw5ygwkfeto0tza44wy6qv9j08','Cant Hold Us (feat. Ray Dalton)','d1fl8wels7rdzdb','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7tqavp01q4djgxttsw95hz28fneop3g48w1qmoer013o94ns0r', 's63pumtmm9v4xowdzw6wlybixw5ygwkfeto0tza44wy6qv9j08', '0');
-- Nicky Youre
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b9waexjchukoiw7', 'Nicky Youre', '232@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe726c8549d387a241f979acd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:232@artist.com', 'b9waexjchukoiw7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b9waexjchukoiw7', 'A visionary in the world of music, redefining genres.', 'Nicky Youre');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qcdpnrss3wqdrm4n47s0u3qkrp035nck2jes0bht3hwnosmiat','b9waexjchukoiw7', 'https://i.scdn.co/image/ab67616d0000b273ecd970d1d2623b6c7fc6080c', 'Good Times Go','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('op8hpfrx8h5ffojgi0qm14tqwnxgt9rikhlrgfnwa3il7soekq','Sunroof','b9waexjchukoiw7','POP','5YqEzk3C5c3UZ1D5fJUlXA','https://p.scdn.co/mp3-preview/605058558fd8d10c420b56c41555e567645d5b60?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qcdpnrss3wqdrm4n47s0u3qkrp035nck2jes0bht3hwnosmiat', 'op8hpfrx8h5ffojgi0qm14tqwnxgt9rikhlrgfnwa3il7soekq', '0');
-- Fuerza Regida
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9ht8pmg1mff9n4p', 'Fuerza Regida', '233@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1b85fbf9507041aab224336d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:233@artist.com', '9ht8pmg1mff9n4p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9ht8pmg1mff9n4p', 'Revitalizing the regional music scene with their unique sound and powerful lyrics.', 'Fuerza Regida');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e0zbppuqcc9tcuexasy52m2thr35f0sed107579iu3btjsmiyb','9ht8pmg1mff9n4p', 'https://i.scdn.co/image/ab67616d0000b273cfe3eb72c48b93971e53efd9', 'SABOR FRESA','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5wsvta4ehxdzeh1nipm18hjzacfa9x25s5c42372uvligzeii2','SABOR FRESA','9ht8pmg1mff9n4p','POP','1UMm1Qs3u59Wvk53zBUE8r','https://p.scdn.co/mp3-preview/590ae0b69465339d97ef5db9f7e36fe0c452fbb4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e0zbppuqcc9tcuexasy52m2thr35f0sed107579iu3btjsmiyb', '5wsvta4ehxdzeh1nipm18hjzacfa9x25s5c42372uvligzeii2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5vd125yh0ahdvdvb2nlwh1qmu0mej3iw2fwog0bvxl1uuo7td8','TQM','9ht8pmg1mff9n4p','POP','368eeEO3Y2uZUQ6S5oIjcu','https://p.scdn.co/mp3-preview/63f6b66cfcc3d7bd396dcbe18d6e3dee05fdb956?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e0zbppuqcc9tcuexasy52m2thr35f0sed107579iu3btjsmiyb', '5vd125yh0ahdvdvb2nlwh1qmu0mej3iw2fwog0bvxl1uuo7td8', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('owzex26u8ary2s5mkjux3gvdsv0ny9z5x7atrxna8jqw1lmsts','Bebe Dame','9ht8pmg1mff9n4p','POP','0IKeDy5bT9G0bA7ZixRT4A','https://p.scdn.co/mp3-preview/408ffb4fffcd26cda82f2b3cda7726ea1f6ebd74?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e0zbppuqcc9tcuexasy52m2thr35f0sed107579iu3btjsmiyb', 'owzex26u8ary2s5mkjux3gvdsv0ny9z5x7atrxna8jqw1lmsts', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('77qcrq1gr6l86mfhx9uxaa28b72cbirsa0w2mhn349c7dbgkyy','Ch y la Pizza','9ht8pmg1mff9n4p','POP','0UbesRsX2TtiCeamOIVEkp','https://p.scdn.co/mp3-preview/212acba217ff0304f6cbb41eb8f43cd27d991c7b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e0zbppuqcc9tcuexasy52m2thr35f0sed107579iu3btjsmiyb', '77qcrq1gr6l86mfhx9uxaa28b72cbirsa0w2mhn349c7dbgkyy', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('whioktsx1m59ti7xc3vreqogdlt5fuj12bo5w6l09xpovg4nhh','Igualito a Mi Ap','9ht8pmg1mff9n4p','POP','17js0w8GTkTUFGFM6PYvBd','https://p.scdn.co/mp3-preview/f0f87682468e9baa92562cd4d797ce8af5337ca6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e0zbppuqcc9tcuexasy52m2thr35f0sed107579iu3btjsmiyb', 'whioktsx1m59ti7xc3vreqogdlt5fuj12bo5w6l09xpovg4nhh', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('znolzhmg737k9i59sig5qozixlmqvg8udyzq7phimry6abu9bx','Dijeron Que No La Iba Lograr','9ht8pmg1mff9n4p','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e0zbppuqcc9tcuexasy52m2thr35f0sed107579iu3btjsmiyb', 'znolzhmg737k9i59sig5qozixlmqvg8udyzq7phimry6abu9bx', '5');
-- Coolio
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6rrbka24p74obiv', 'Coolio', '234@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebff14146ae33324af5427131f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:234@artist.com', '6rrbka24p74obiv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6rrbka24p74obiv', 'Music is my canvas, and notes are my paint.', 'Coolio');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0faenkhguo4m7eong0535nw9h98ualtjdx8sucq8anzxl4pwrb','6rrbka24p74obiv', 'https://i.scdn.co/image/ab67616d0000b273c31d3c870a3dbaf7b53186cc', 'Gangstas Paradise','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u08nomdbfyrr4czhjbl8mkvftvstscboo0y4vmw1e21zyf32zz','Gangstas Paradise','6rrbka24p74obiv','POP','1DIXPcTDzTj8ZMHt3PDt8p','https://p.scdn.co/mp3-preview/1454c63a66c27ac745f874d6c113270a9c62d28e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0faenkhguo4m7eong0535nw9h98ualtjdx8sucq8anzxl4pwrb', 'u08nomdbfyrr4czhjbl8mkvftvstscboo0y4vmw1e21zyf32zz', '0');
-- Beach Weather
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qx6xg1w36e4xqp1', 'Beach Weather', '235@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebed9ce2779a99efc01b4f918c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:235@artist.com', 'qx6xg1w36e4xqp1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qx6xg1w36e4xqp1', 'Igniting the stage with electrifying performances.', 'Beach Weather');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y2wzheobtl9p1ottvdjb65626flg4w7aagy52c4jpimedk8fpl','qx6xg1w36e4xqp1', 'https://i.scdn.co/image/ab67616d0000b273a03e3d24ccee1c370899c342', 'Pineapple Sunrise','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k5nzca33yul944q4h0l0n2517i0ig8bmlu9a94jctzuzckt8ry','Sex, Drugs, Etc.','qx6xg1w36e4xqp1','POP','7MlDNspYwfqnHxORufupwq','https://p.scdn.co/mp3-preview/a423aecddb590788a61f2a7b4d325bf461f88dc8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y2wzheobtl9p1ottvdjb65626flg4w7aagy52c4jpimedk8fpl', 'k5nzca33yul944q4h0l0n2517i0ig8bmlu9a94jctzuzckt8ry', '0');
-- Central Cee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x867mxfzqvxxh5k', 'Central Cee', '236@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5fe7cabb8de1c0266cd2179c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:236@artist.com', 'x867mxfzqvxxh5k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x867mxfzqvxxh5k', 'Weaving lyrical magic into every song.', 'Central Cee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('imblcsm6fld49y3wl53caku1pz4hpfneuigl0wj81fnaqw0glc','x867mxfzqvxxh5k', 'https://i.scdn.co/image/ab67616d0000b273cbb3701743a568e7f1c4e967', 'LET GO','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w4tfw3vnxyykovdy4n07ture4nf5lccb2aq888fnzc6m06c08h','LET GO','x867mxfzqvxxh5k','POP','3zkyus0njMCL6phZmNNEeN','https://p.scdn.co/mp3-preview/5391f8e7621898d3f5237e297e3fbcabe1fe3494?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('imblcsm6fld49y3wl53caku1pz4hpfneuigl0wj81fnaqw0glc', 'w4tfw3vnxyykovdy4n07ture4nf5lccb2aq888fnzc6m06c08h', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d0e9x425t0zycvqwe2r1nwdac7f344whrd79jtivdpggz6jynv','Doja','x867mxfzqvxxh5k','POP','3LtpKP5abr2qqjunvjlX5i','https://p.scdn.co/mp3-preview/41105628e270a026ac9aecacd44e3373fceb9f43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('imblcsm6fld49y3wl53caku1pz4hpfneuigl0wj81fnaqw0glc', 'd0e9x425t0zycvqwe2r1nwdac7f344whrd79jtivdpggz6jynv', '1');
-- Duki
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2vksotgsyu5ng9q', 'Duki', '237@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdc25969093ccc4655316c9b9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:237@artist.com', '2vksotgsyu5ng9q', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2vksotgsyu5ng9q', 'Sculpting soundwaves into masterpieces of auditory art.', 'Duki');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('v2u00934hcecu0h12ifo382p4iqxzwekq9ijq0a52qpxpqoman','2vksotgsyu5ng9q', NULL, 'Duki Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rh3oryvv8axr0aqpqdxs9ipm08v9803p5fe3ujdumijotixoh3','Marisola - Remix','2vksotgsyu5ng9q','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v2u00934hcecu0h12ifo382p4iqxzwekq9ijq0a52qpxpqoman', 'rh3oryvv8axr0aqpqdxs9ipm08v9803p5fe3ujdumijotixoh3', '0');
-- James Hype
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ancc3rnf3vmq1ts', 'James Hype', '238@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3735de17f641144240511000','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:238@artist.com', 'ancc3rnf3vmq1ts', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ancc3rnf3vmq1ts', 'Redefining what it means to be an artist in the digital age.', 'James Hype');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('r5pknbepghqcg22qb0sldc85fwgm8ilctakruwae9f2pq8ko24','ancc3rnf3vmq1ts', 'https://i.scdn.co/image/ab67616d0000b2736cc861b5c9c7cdef61b010b4', 'Ferrari','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j900eayzhdpm6p4921pcpouven6wozl9pn1thb2fark45yzpcm','Ferrari','ancc3rnf3vmq1ts','POP','4zN21mbAuaD0WqtmaTZZeP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r5pknbepghqcg22qb0sldc85fwgm8ilctakruwae9f2pq8ko24', 'j900eayzhdpm6p4921pcpouven6wozl9pn1thb2fark45yzpcm', '0');
-- Omar Apollo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2d662litvlr6ij3', 'Omar Apollo', '239@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0e2a3a2c664a4bbb14e44f8e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:239@artist.com', '2d662litvlr6ij3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2d662litvlr6ij3', 'Exploring the depths of sound and rhythm.', 'Omar Apollo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('all42zsfy94ggz515qx5isboufac1y7v700povzyedlzn1c97d','2d662litvlr6ij3', 'https://i.scdn.co/image/ab67616d0000b27390cf5d1ccfca2beb86149a19', 'Ivory','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o928s2ha1r53941ul38n5zjotqlzbylgivenm2jc2h4ksi8fiw','Evergreen (You Didnt Deserve Me A','2d662litvlr6ij3','POP','2TktkzfozZifbQhXjT6I33','https://p.scdn.co/mp3-preview/f9db43c10cfab231d9448792464a23f6e6d607e7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('all42zsfy94ggz515qx5isboufac1y7v700povzyedlzn1c97d', 'o928s2ha1r53941ul38n5zjotqlzbylgivenm2jc2h4ksi8fiw', '0');
-- Tyler
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rybch5ms1gq0kxf', 'Tyler', '240@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8278b782cbb5a3963db88ada','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:240@artist.com', 'rybch5ms1gq0kxf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rybch5ms1gq0kxf', 'A symphony of emotions expressed through sound.', 'Tyler');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('b2sd1qft38kksr7wdelx6mg1ngklhof5k63mc9rqfk8rxb2ir2','rybch5ms1gq0kxf', 'https://i.scdn.co/image/ab67616d0000b273aa95a399fd30fbb4f6f59fca', 'CALL ME IF YOU GET LOST: The Estate Sale','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ldegz9otfypfx0bp9jbzfmo1q6jjo4m33dzrqxj04xr7gowmzu','DOGTOOTH','rybch5ms1gq0kxf','POP','6OfOzTitafSnsaunQLuNFw','https://p.scdn.co/mp3-preview/5de4c8c30108bc114f9f38a28ac0832936a852bf?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('b2sd1qft38kksr7wdelx6mg1ngklhof5k63mc9rqfk8rxb2ir2', 'ldegz9otfypfx0bp9jbzfmo1q6jjo4m33dzrqxj04xr7gowmzu', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zmadm6h8yh8u6xbnxdhsbksmfgkn272nlawwjhvba1org6bcvc','SORRY NOT SORRY','rybch5ms1gq0kxf','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('b2sd1qft38kksr7wdelx6mg1ngklhof5k63mc9rqfk8rxb2ir2', 'zmadm6h8yh8u6xbnxdhsbksmfgkn272nlawwjhvba1org6bcvc', '1');
-- TV Girl
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3k7e86imbfyxqcb', 'TV Girl', '241@artist.com', 'https://i.scdn.co/image/ab67616d0000b27332f5fec7a879ed6ef28f0dfd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:241@artist.com', '3k7e86imbfyxqcb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3k7e86imbfyxqcb', 'Crafting melodies that resonate with the soul.', 'TV Girl');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t1hq4aje5xy9zvwo5fwk560m0d6pfguxzjx88gifosbk0gx216','3k7e86imbfyxqcb', 'https://i.scdn.co/image/ab67616d0000b273e1bc1af856b42dd7fdba9f84', 'French Exit','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6e6ul3z4rzeudz6gmhtezerouxpch47r56gi5pgpeexy8ukmoi','Lovers Rock','3k7e86imbfyxqcb','POP','6dBUzqjtbnIa1TwYbyw5CM','https://p.scdn.co/mp3-preview/922a42db5aa8f8d335725697b7d7a12af6808f3a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t1hq4aje5xy9zvwo5fwk560m0d6pfguxzjx88gifosbk0gx216', '6e6ul3z4rzeudz6gmhtezerouxpch47r56gi5pgpeexy8ukmoi', '0');
-- Meghan Trainor
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y7adfgrvqlk32o6', 'Meghan Trainor', '242@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4d8f97058ff993df0f4eb9ee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:242@artist.com', 'y7adfgrvqlk32o6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y7adfgrvqlk32o6', 'An endless quest for musical perfection.', 'Meghan Trainor');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gfdp2vbao8y4snk61gbmsx0ij9vr55l3s7iwk7a0bbwfmxhg5a','y7adfgrvqlk32o6', 'https://i.scdn.co/image/ab67616d0000b2731a4f1ada93881da4ca8060ff', 'Takin It Back','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('my0ys52gtie1bij6bnxzt6iu8dr1u1g0tmg02ce760qb0pkeg2','Made You Look','y7adfgrvqlk32o6','POP','0QHEIqNKsMoOY5urbzN48u','https://p.scdn.co/mp3-preview/f0eb89945aa820c0f30b5e97f8e2cab42d9f0a99?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gfdp2vbao8y4snk61gbmsx0ij9vr55l3s7iwk7a0bbwfmxhg5a', 'my0ys52gtie1bij6bnxzt6iu8dr1u1g0tmg02ce760qb0pkeg2', '0');
-- A$AP Rocky
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gtilfhqcmkyfrce', 'A$AP Rocky', '243@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5c58c41a506a0d6b32cc6cad','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:243@artist.com', 'gtilfhqcmkyfrce', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gtilfhqcmkyfrce', 'Elevating the ordinary to extraordinary through music.', 'A$AP Rocky');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rmut66elrdc9pi5ubcmi30frhp872zmxu9ysgmfnozkl3tuess','gtilfhqcmkyfrce', NULL, 'A$AP Rocky Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gja5y61axnpavai96r06k832b1h3zdhvlbvgxsp8w4w5ygkhtp','Am I Dreaming (Metro Boomin & A$AP Rocky, Roisee)','gtilfhqcmkyfrce','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rmut66elrdc9pi5ubcmi30frhp872zmxu9ysgmfnozkl3tuess', 'gja5y61axnpavai96r06k832b1h3zdhvlbvgxsp8w4w5ygkhtp', '0');
-- Robin Schulz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6v84v4ztj6lrpjl', 'Robin Schulz', '244@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb82c0d0d4ef6742997f03d678','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:244@artist.com', '6v84v4ztj6lrpjl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6v84v4ztj6lrpjl', 'Music is my canvas, and notes are my paint.', 'Robin Schulz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('69hs00a6oc06j8pomcwletvpfzitez4gis1h7va3p2m5bxk7dw','6v84v4ztj6lrpjl', NULL, 'Robin Schulz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zlace69qkxrdtvyzdve6xzi3mtscw5q3iqk3yrp5evxh8z1g8c','Miss You','6v84v4ztj6lrpjl','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('69hs00a6oc06j8pomcwletvpfzitez4gis1h7va3p2m5bxk7dw', 'zlace69qkxrdtvyzdve6xzi3mtscw5q3iqk3yrp5evxh8z1g8c', '0');
-- Nile Rodgers
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k9wk1fbj4xt6yk0', 'Nile Rodgers', '245@artist.com', 'https://i.scdn.co/image/6511b1fe261da3b6c6b69ae2aa771cfd307a18ae','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:245@artist.com', 'k9wk1fbj4xt6yk0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k9wk1fbj4xt6yk0', 'Igniting the stage with electrifying performances.', 'Nile Rodgers');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('olh7oj8gzpybal9lke6j0ee9ghsdqm4ucfhb3aeakb5tnrtpsj','k9wk1fbj4xt6yk0', NULL, 'Nile Rodgers Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fuhyv0le8hox4wwzci6afv4kem5m3nh2btkbfrslnboqzc4m7z','UNFORGIVEN (feat. Nile Rodgers)','k9wk1fbj4xt6yk0','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('olh7oj8gzpybal9lke6j0ee9ghsdqm4ucfhb3aeakb5tnrtpsj', 'fuhyv0le8hox4wwzci6afv4kem5m3nh2btkbfrslnboqzc4m7z', '0');
-- Kali Uchis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nztaonmi0w76cvb', 'Kali Uchis', '246@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:246@artist.com', 'nztaonmi0w76cvb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nztaonmi0w76cvb', 'A fusion of soul, R&B, and Latin beats, creating a unique sound experience.', 'Kali Uchis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('s4n602kj799z9k40n7pffmpa71zx6467wzw4c77xcw241eegmc','nztaonmi0w76cvb', 'https://i.scdn.co/image/ab67616d0000b27381fccd758776d16b87721b17', 'Red Moon In Venus','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2l9vrdf0if4vgvizbhs09mo2b8vgw9tfjg8ufjyre7n8soo5dp','Moonlight','nztaonmi0w76cvb','POP','0JmnkIqdlnUzPaf8sqBRs3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s4n602kj799z9k40n7pffmpa71zx6467wzw4c77xcw241eegmc', '2l9vrdf0if4vgvizbhs09mo2b8vgw9tfjg8ufjyre7n8soo5dp', '0');
-- MC Xenon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kg56co44n9g5c53', 'MC Xenon', '247@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb14b5fcee11164723953781ff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:247@artist.com', 'kg56co44n9g5c53', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kg56co44n9g5c53', 'An odyssey of sound that defies conventions.', 'MC Xenon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rcqbjmtjf0me90mfgkyacw81lvair7bigbqpf99amkr7e1oe0x','kg56co44n9g5c53', NULL, 'MC Xenon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tvugscmqf5j9hlc7f1c0wsxwe7hrzz8ehpntkm6r2vy3ge0rc2','Sem Aliana no ','kg56co44n9g5c53','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rcqbjmtjf0me90mfgkyacw81lvair7bigbqpf99amkr7e1oe0x', 'tvugscmqf5j9hlc7f1c0wsxwe7hrzz8ehpntkm6r2vy3ge0rc2', '0');
-- Mc Pedrinho
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0osx77xrpmt5qm9', 'Mc Pedrinho', '248@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd704ce4a93060fee76e59beb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:248@artist.com', '0osx77xrpmt5qm9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0osx77xrpmt5qm9', 'An endless quest for musical perfection.', 'Mc Pedrinho');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('478a9h3xm2lfz6nxje4l81ihljo0q12fmt2o7icjwg7kmy66zn','0osx77xrpmt5qm9', 'https://i.scdn.co/image/ab67616d0000b27319d60821e80a801506061776', 'Gol Bolinha, Gol Quadrado 2','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6yy0qf1mscium8w2z4g1c7t3fw1e0uaovo7v1tbse6dl3rj1iw','Gol Bolinha, Gol Quadrado 2','0osx77xrpmt5qm9','POP','0U9CZWq6umZsN432nh3WWT','https://p.scdn.co/mp3-preview/385a48d0a130895b2b0ec2f731cc744207d0a745?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('478a9h3xm2lfz6nxje4l81ihljo0q12fmt2o7icjwg7kmy66zn', '6yy0qf1mscium8w2z4g1c7t3fw1e0uaovo7v1tbse6dl3rj1iw', '0');
-- Agust D
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('88v6mm0l0aythrt', 'Agust D', '249@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb191d43dca6f2f5a126e43e4b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:249@artist.com', '88v6mm0l0aythrt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('88v6mm0l0aythrt', 'Weaving lyrical magic into every song.', 'Agust D');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lopjvdqcy6463ouhvmvq62papy7j22fumb2p1lgd3olwandi78','88v6mm0l0aythrt', 'https://i.scdn.co/image/ab67616d0000b273fa9247b68471b82d2125651e', 'D-DAY','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3ds5huxbhb1thv9x5umty23aq0px2o7s5sf31pk0d6tkp49i61','Haegeum','88v6mm0l0aythrt','POP','4bjN59DRXFRxBE1g5ne6B1','https://p.scdn.co/mp3-preview/3c2f1894de0f6a51f557131c3eb275cb8bc80831?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lopjvdqcy6463ouhvmvq62papy7j22fumb2p1lgd3olwandi78', '3ds5huxbhb1thv9x5umty23aq0px2o7s5sf31pk0d6tkp49i61', '0');
-- Dean Lewis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yfi4nnhtjvpidu1', 'Dean Lewis', '250@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4fc14e184f9e05ba0676ddee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:250@artist.com', 'yfi4nnhtjvpidu1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yfi4nnhtjvpidu1', 'Uniting fans around the globe with universal rhythms.', 'Dean Lewis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oqeomxnf64mlptpt5xcjlncxh2wcn8jkmr3tgv3myhz99wjbcw','yfi4nnhtjvpidu1', 'https://i.scdn.co/image/ab67616d0000b273991f6658282ef028f93b11e0', 'The Hardest Love','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wthmxozivqc7ogt5vzcy6r1flizegzhpfedwx6l77dawo2mc5h','How Do I Say Goodbye','yfi4nnhtjvpidu1','POP','1aOl53hkZGHkl2Snhr7opL',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oqeomxnf64mlptpt5xcjlncxh2wcn8jkmr3tgv3myhz99wjbcw', 'wthmxozivqc7ogt5vzcy6r1flizegzhpfedwx6l77dawo2mc5h', '0');
-- INTERWORLD
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('isczzz6qetsl01j', 'INTERWORLD', '251@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4ba846e4a963c8558471e3af','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:251@artist.com', 'isczzz6qetsl01j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('isczzz6qetsl01j', 'An alchemist of harmonies, transforming notes into gold.', 'INTERWORLD');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4rf4sel9grs2jyet39i50oqwqith2lcd7ion39s28kx52czme3','isczzz6qetsl01j', 'https://i.scdn.co/image/ab67616d0000b273b852a616ae3a49a1f6b0f16e', 'METAMORPHOSIS','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9tvzdswa4faktxeo6euphinn3skpkegq9j2q49ipmm89myh4rw','METAMORPHOSIS','isczzz6qetsl01j','POP','2ksyzVfU0WJoBpu8otr4pz','https://p.scdn.co/mp3-preview/61baac6cfee58ae57f9f767a86fa5e99f9797664?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4rf4sel9grs2jyet39i50oqwqith2lcd7ion39s28kx52czme3', '9tvzdswa4faktxeo6euphinn3skpkegq9j2q49ipmm89myh4rw', '0');
-- Nicky Jam
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4etaxkue9wof74k', 'Nicky Jam', '252@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb02bec146cac39466d3f8ee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:252@artist.com', '4etaxkue9wof74k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4etaxkue9wof74k', 'A beacon of innovation in the world of sound.', 'Nicky Jam');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wo971nbi1bawcdtue5sesq45gljswc9vinwtrk72cntdrmu7zl','4etaxkue9wof74k', 'https://i.scdn.co/image/ab67616d0000b273ea97d86f1fa8532cd8c75188', '69','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zgxxk90kpqfhitangv6vbalfejqr9i5v68snrq7kp8gu9l3vmq','69','4etaxkue9wof74k','POP','13Z5Q40pa1Ly7aQk1oW8Ce','https://p.scdn.co/mp3-preview/966457479d8cd723838150ddd1f3010f4383994d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wo971nbi1bawcdtue5sesq45gljswc9vinwtrk72cntdrmu7zl', 'zgxxk90kpqfhitangv6vbalfejqr9i5v68snrq7kp8gu9l3vmq', '0');
-- Aerosmith
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xjf5f3ddy4x0aj1', 'Aerosmith', '253@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5733401b4689b2064458e7d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:253@artist.com', 'xjf5f3ddy4x0aj1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xjf5f3ddy4x0aj1', 'Harnessing the power of melody to tell compelling stories.', 'Aerosmith');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1w5f1xak28lyf3g9cviypatvg9ujfesivxs3270epou4ldjbv3','xjf5f3ddy4x0aj1', 'https://i.scdn.co/image/ab67616d0000b273bbf0146981704a073405b6c2', 'Aerosmith','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zs2o3gf8ryxhkk48xk9ebcf22su9nhhpzouq7t9lhpj7t8d7y8','Dream On','xjf5f3ddy4x0aj1','POP','1xsYj84j7hUDDnTTerGWlH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1w5f1xak28lyf3g9cviypatvg9ujfesivxs3270epou4ldjbv3', 'zs2o3gf8ryxhkk48xk9ebcf22su9nhhpzouq7t9lhpj7t8d7y8', '0');
-- Offset
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('al6lz6qvrrgznft', 'Offset', '254@artist.com', 'https://i.scdn.co/image/ab67616d0000b2736edd8e309824c6f3fd3f3466','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:254@artist.com', 'al6lz6qvrrgznft', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('al6lz6qvrrgznft', 'Igniting the stage with electrifying performances.', 'Offset');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ue0o4f3u5f6kikwr4tj98mwkk50u8d31kec1sfb6p929pocwj9','al6lz6qvrrgznft', 'https://i.scdn.co/image/ab67616d0000b2736ed9aef791159496b286179f', 'METRO BOOMIN PRESENTS SPIDER-MAN: ACROSS THE SPIDER-VERSE (SOUNDTRACK FROM AND INSPIRED BY THE MOTION PICTURE)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rg4ej3yszhxcksf1gxdxrgms56tmrt32zq3mpw8rh1pef9850s','Danger (Spider) (Offset & JID)','al6lz6qvrrgznft','POP','3X6qK1LdMkSOhklwRa2ZfG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ue0o4f3u5f6kikwr4tj98mwkk50u8d31kec1sfb6p929pocwj9', 'rg4ej3yszhxcksf1gxdxrgms56tmrt32zq3mpw8rh1pef9850s', '0');
-- Ed Sheeran
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cvl3i703pyf2136', 'Ed Sheeran', '255@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3bcef85e105dfc42399ef0ba','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:255@artist.com', 'cvl3i703pyf2136', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cvl3i703pyf2136', 'An alchemist of harmonies, transforming notes into gold.', 'Ed Sheeran');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7jit5pwxwqdujjedzhz8j4ca0f9j5jgs8b6zqfca1lz3rw04zr','cvl3i703pyf2136', 'https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96', '÷ (Deluxe)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('acik43muqjzm2mb22gpj1d8s5c65qqe7v2zek8289gu17v73ql','Perfect','cvl3i703pyf2136','POP','0tgVpDi06FyKpA1z0VMD4v','https://p.scdn.co/mp3-preview/4e30857a3c7da3f8891483643e310bb233afadd2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7jit5pwxwqdujjedzhz8j4ca0f9j5jgs8b6zqfca1lz3rw04zr', 'acik43muqjzm2mb22gpj1d8s5c65qqe7v2zek8289gu17v73ql', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('379tq03zoa7v9o22pi48wpbqwrb3v0nmqa9mtap9r0cc3fpq1q','Shape of You','cvl3i703pyf2136','POP','7qiZfU4dY1lWllzX7mPBI3','https://p.scdn.co/mp3-preview/7339548839a263fd721d01eb3364a848cad16fa7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7jit5pwxwqdujjedzhz8j4ca0f9j5jgs8b6zqfca1lz3rw04zr', '379tq03zoa7v9o22pi48wpbqwrb3v0nmqa9mtap9r0cc3fpq1q', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yr1cjthecnzi8ahsmjnbmzaox0nyihe2a93nlib76wmzr9iglt','Eyes Closed','cvl3i703pyf2136','POP','3p7XQpdt8Dr6oMXSvRZ9bg','https://p.scdn.co/mp3-preview/7cd2576f2d27799fe8c515c4e0fc880870a5cc88?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7jit5pwxwqdujjedzhz8j4ca0f9j5jgs8b6zqfca1lz3rw04zr', 'yr1cjthecnzi8ahsmjnbmzaox0nyihe2a93nlib76wmzr9iglt', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lwblnj6xxf6cu7qpovn7r7bfm5w7ymtlghcnis67q4o83l7w0l','Curtains','cvl3i703pyf2136','POP','6ZZf5a8oiInHDkBe9zXfLP','https://p.scdn.co/mp3-preview/5a519e5823df4fe468c8a45a7104a632553e09a5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7jit5pwxwqdujjedzhz8j4ca0f9j5jgs8b6zqfca1lz3rw04zr', 'lwblnj6xxf6cu7qpovn7r7bfm5w7ymtlghcnis67q4o83l7w0l', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nk3ph91z3plasoyawe7xp9o86y43tjr8zqsrdht4milmvdor5g','Shivers','cvl3i703pyf2136','POP','50nfwKoDiSYg8zOCREWAm5','https://p.scdn.co/mp3-preview/08cec59d36ac30ae9ce1e2944f206251859844af?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7jit5pwxwqdujjedzhz8j4ca0f9j5jgs8b6zqfca1lz3rw04zr', 'nk3ph91z3plasoyawe7xp9o86y43tjr8zqsrdht4milmvdor5g', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o0tkdkhveksg2d91eczvpvmnb0xaxar814px82pu5x2yar12vg','Bad Habits','cvl3i703pyf2136','POP','3rmo8F54jFF8OgYsqTxm5d','https://p.scdn.co/mp3-preview/22f3a86c8a83e364db595007f9ac1d666596a335?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7jit5pwxwqdujjedzhz8j4ca0f9j5jgs8b6zqfca1lz3rw04zr', 'o0tkdkhveksg2d91eczvpvmnb0xaxar814px82pu5x2yar12vg', '5');
-- Stray Kids
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0arc6gqjc61c4qo', 'Stray Kids', '256@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0610877c41cb9cc12ad39cc0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:256@artist.com', '0arc6gqjc61c4qo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0arc6gqjc61c4qo', 'Pioneering new paths in the musical landscape.', 'Stray Kids');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('utrzdppl6yw3hatimyoe78uhxajmyd10sx21oglw5lbrpybdku','0arc6gqjc61c4qo', 'https://i.scdn.co/image/ab67616d0000b273e27ba26bc14a563bf3d09882', '5-STAR','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p66dfrzmte86iyyjzd65297jcqp9flab32zckfzaamv3eebrcm','S-Class','0arc6gqjc61c4qo','POP','3gTQwwDNJ42CCLo3Sf4JDd','https://p.scdn.co/mp3-preview/4ea586fdcc2c9aec34a18d2034d1dec78a3b5e25?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('utrzdppl6yw3hatimyoe78uhxajmyd10sx21oglw5lbrpybdku', 'p66dfrzmte86iyyjzd65297jcqp9flab32zckfzaamv3eebrcm', '0');
-- Twisted
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('87tn4xv3g45fzfo', 'Twisted', '257@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2615ef39cf9128c447b31619','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:257@artist.com', '87tn4xv3g45fzfo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('87tn4xv3g45fzfo', 'A harmonious blend of passion and creativity.', 'Twisted');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yqc9lewe6rdmsfdi6q61qx9nmxzd35two9vzmrxjsjgj9bj72y','87tn4xv3g45fzfo', 'https://i.scdn.co/image/ab67616d0000b273f5e2ffd88f07e55f34c361c8', 'WORTH NOTHING (feat. Oliver Tree) [Fast & Furious: Drift Tape/Phonk Vol 1]','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9x16snf2v549tssg4ey1x04g87pbbfhpp9am0o3wnuq1vyy0po','WORTH NOTHING','87tn4xv3g45fzfo','POP','3PjbA0O5olhampPMdaB0V1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yqc9lewe6rdmsfdi6q61qx9nmxzd35two9vzmrxjsjgj9bj72y', '9x16snf2v549tssg4ey1x04g87pbbfhpp9am0o3wnuq1vyy0po', '0');
-- The Police
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('03ddx0powko45er', 'The Police', '258@artist.com', 'https://i.scdn.co/image/1f73a61faca2942cd5ea29c2143184db8645f0b3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:258@artist.com', '03ddx0powko45er', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('03ddx0powko45er', 'The heartbeat of a new generation of music lovers.', 'The Police');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dd7kzuy3xw69aseuc9o81dlb4jiqcpduk6zci4p0yqjcv3oo64','03ddx0powko45er', 'https://i.scdn.co/image/ab67616d0000b2730408dc279dd7c7354ff41014', 'Every Breath You Take The Classics','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nwy1gwsrxauuwj6lsw9ef7xjfq2iljkeyonz47q4fa706f9vy4','Every Breath You Take - Remastered 2003','03ddx0powko45er','POP','0wF2zKJmgzjPTfircPJ2jg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dd7kzuy3xw69aseuc9o81dlb4jiqcpduk6zci4p0yqjcv3oo64', 'nwy1gwsrxauuwj6lsw9ef7xjfq2iljkeyonz47q4fa706f9vy4', '0');
-- Sam Smith
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y7d3iz1d968yd3g', 'Sam Smith', '259@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba8eef8322e55fc49ab436eea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:259@artist.com', 'y7d3iz1d968yd3g', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y7d3iz1d968yd3g', 'A soulful voice delivering deep emotional resonance.', 'Sam Smith');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3rbow8xwiff5lofmvdq3hmnua913d134lfx0mtdhf6fitgzk5x','y7d3iz1d968yd3g', 'https://i.scdn.co/image/ab67616d0000b273a935e4689f15953311772cc4', 'Unholy (feat. Kim Petras)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('58q2plwi0w717iqjct0fggffe8pell2yf7gwoce883e5arayee','Unholy (feat. Kim Petras)','y7d3iz1d968yd3g','POP','3nqQXoyQOWXiESFLlDF1hG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3rbow8xwiff5lofmvdq3hmnua913d134lfx0mtdhf6fitgzk5x', '58q2plwi0w717iqjct0fggffe8pell2yf7gwoce883e5arayee', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('76mrtl4nqo76xkqdg25jjb9kwvwviwj43pwlsgek8jf5mxdetg','Im Not Here To Make Friends','y7d3iz1d968yd3g','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3rbow8xwiff5lofmvdq3hmnua913d134lfx0mtdhf6fitgzk5x', '76mrtl4nqo76xkqdg25jjb9kwvwviwj43pwlsgek8jf5mxdetg', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p5xyngzw6qjsoho93mlidh0jo8f3qdied2w8obovmb0cvc1dgz','Im Not The Only One','y7d3iz1d968yd3g','POP','5RYtz3cpYb28SV8f1FBtGc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3rbow8xwiff5lofmvdq3hmnua913d134lfx0mtdhf6fitgzk5x', 'p5xyngzw6qjsoho93mlidh0jo8f3qdied2w8obovmb0cvc1dgz', '2');
-- Semicenk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qx8jxxbhucavtli', 'Semicenk', '260@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf35dea329601372a4d84652e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:260@artist.com', 'qx8jxxbhucavtli', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qx8jxxbhucavtli', 'Harnessing the power of melody to tell compelling stories.', 'Semicenk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('80qfxp4ussqnlg8x5phoiacn3ckb9cz2yrlre98dq7tajeztgn','qx8jxxbhucavtli', NULL, 'Semicenk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ywg6kx2qe5biguqcf9rg3g37x8xc392yezyy89w2m0m2km4qzi','Piman De','qx8jxxbhucavtli','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('80qfxp4ussqnlg8x5phoiacn3ckb9cz2yrlre98dq7tajeztgn', 'ywg6kx2qe5biguqcf9rg3g37x8xc392yezyy89w2m0m2km4qzi', '0');
-- Don Toliver
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rr51wcujiz3mvej', 'Don Toliver', '261@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeb63bf6379a9ea8453a30020','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:261@artist.com', 'rr51wcujiz3mvej', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rr51wcujiz3mvej', 'The architect of aural landscapes that inspire and captivate.', 'Don Toliver');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hhvhspxp011xx73koxercf83bjv035zpc3sa9tcoyocavdqrqd','rr51wcujiz3mvej', 'https://i.scdn.co/image/ab67616d0000b273feeff698e6090e6b02f21ec0', 'Love Sick','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('70j75r80yf1h4n91rc8jx500z7r10yl95ukg51dij6330trmnr','Private Landing (feat. Justin Bieber & Future)','rr51wcujiz3mvej','POP','52NGJPcLUzQq5w7uv4e5gf','https://p.scdn.co/mp3-preview/511bdf681359f3b57dfa25344f34c2b66ecc4326?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hhvhspxp011xx73koxercf83bjv035zpc3sa9tcoyocavdqrqd', '70j75r80yf1h4n91rc8jx500z7r10yl95ukg51dij6330trmnr', '0');
-- Beyonc
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nb3mydsw22nna0k', 'Beyonc', '262@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12e3f20d05a8d6cfde988715','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:262@artist.com', 'nb3mydsw22nna0k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nb3mydsw22nna0k', 'The heartbeat of a new generation of music lovers.', 'Beyonc');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('s81u6d539ktk7dknawq0uzz0hitdnf1hnt94kysvm0jyacilui','nb3mydsw22nna0k', 'https://i.scdn.co/image/ab67616d0000b2730e58a0f8308c1ad403d105e7', 'RENAISSANCE','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9fsg1svmb6iow1rgeuhwqmvt3xh8j3ft02mhjld3bc2nzt6s8h','CUFF IT','nb3mydsw22nna0k','POP','1xzi1Jcr7mEi9K2RfzLOqS','https://p.scdn.co/mp3-preview/1799de9ff42644af9773b6353358e54615696f19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s81u6d539ktk7dknawq0uzz0hitdnf1hnt94kysvm0jyacilui', '9fsg1svmb6iow1rgeuhwqmvt3xh8j3ft02mhjld3bc2nzt6s8h', '0');
-- Mc Livinho
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jvqjdp6cpw692zz', 'Mc Livinho', '263@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd353ef9564cfbb5f2b3bffb2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:263@artist.com', 'jvqjdp6cpw692zz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jvqjdp6cpw692zz', 'Bringing Brazilian funk rhythms to the global music stage.', 'Mc Livinho');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0o4n6hu00qrrtkx852k1p8gftq4iebcazqlntx9nb9m9m824ir','jvqjdp6cpw692zz', 'https://i.scdn.co/image/ab67616d0000b273369c960fed23353176da1218', 'Novidade na Área','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('88ofplw3hdf2m7hmyxgmf4wovq60dopaopadfnb911qitbkzzg','Novidade na ','jvqjdp6cpw692zz','POP','2uhw2oYbugGJbn10wipNX5','https://p.scdn.co/mp3-preview/6bff8c1079d87a672d6b9ee5c3c6ca5e7d9ff45b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0o4n6hu00qrrtkx852k1p8gftq4iebcazqlntx9nb9m9m824ir', '88ofplw3hdf2m7hmyxgmf4wovq60dopaopadfnb911qitbkzzg', '0');
-- Billie Eilish
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y6rfq5pa90kndt5', 'Billie Eilish', '264@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd8b9980db67272cb4d2c3daf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:264@artist.com', 'y6rfq5pa90kndt5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y6rfq5pa90kndt5', 'An icon in modern pop, known for her haunting vocals and introspective lyrics.', 'Billie Eilish');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lx3s3tvpa7ipqbvh3kg3uofkkqenlzbfhyfqf8iuahxbvng56p','y6rfq5pa90kndt5', NULL, 'Guitar Songs','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f34erdl4aix8c7zpu0fi8d1hw24j0vgou5wx8lg4s0plimku2v','What Was I Made For? [From The Motion Picture "Barbie"]','y6rfq5pa90kndt5','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lx3s3tvpa7ipqbvh3kg3uofkkqenlzbfhyfqf8iuahxbvng56p', 'f34erdl4aix8c7zpu0fi8d1hw24j0vgou5wx8lg4s0plimku2v', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xsdod2g1hu4ttkxztqrafwpnmp7m1thgjbzvjpo0lp53bl863u','lovely - Bonus Track','y6rfq5pa90kndt5','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lx3s3tvpa7ipqbvh3kg3uofkkqenlzbfhyfqf8iuahxbvng56p', 'xsdod2g1hu4ttkxztqrafwpnmp7m1thgjbzvjpo0lp53bl863u', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tmn9hdiokn5ctbc57e7fn6omw6vf07a8akedq1btnzv79ojmm1','TV','y6rfq5pa90kndt5','POP','3GYlZ7tbxLOxe6ewMNVTkw',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lx3s3tvpa7ipqbvh3kg3uofkkqenlzbfhyfqf8iuahxbvng56p', 'tmn9hdiokn5ctbc57e7fn6omw6vf07a8akedq1btnzv79ojmm1', '2');
-- Metro Boomin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gpe0f12pt22zd9y', 'Metro Boomin', '265@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:265@artist.com', 'gpe0f12pt22zd9y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gpe0f12pt22zd9y', 'An odyssey of sound that defies conventions.', 'Metro Boomin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('m8few5vjgwxfgterr20pqxt6lorvck3iwklm8cznvi7vnl9a9y','gpe0f12pt22zd9y', 'https://i.scdn.co/image/ab67616d0000b2736ed9aef791159496b286179f', 'METRO BOOMIN PRESENTS SPIDER-MAN: ACROSS THE SPIDER-VERSE (SOUNDTRACK FROM AND INSPIRED BY THE MOTION PICTURE)','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2u0uw6r62iejqbnlu01v5cgl8qbqa9pweqo35mvjt7aekj5slc','Self Love (Spider-Man: Across the Spider-Verse) (Metro Boomin & Coi Leray)','gpe0f12pt22zd9y','POP','0AAMnNeIc6CdnfNU85GwCH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m8few5vjgwxfgterr20pqxt6lorvck3iwklm8cznvi7vnl9a9y', '2u0uw6r62iejqbnlu01v5cgl8qbqa9pweqo35mvjt7aekj5slc', '0');
-- Manuel Turizo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('414pwsf6j0qmknq', 'Manuel Turizo', '266@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebabd3e69b432d6187cf4e28c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:266@artist.com', '414pwsf6j0qmknq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('414pwsf6j0qmknq', 'A standout in reggaeton, known for his smooth voice and romantic lyrics.', 'Manuel Turizo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3h2s72nwifr7jtbxj036qzg60q3xqlhklbtjoz0togab75aumo','414pwsf6j0qmknq', 'https://i.scdn.co/image/ab67616d0000b2734dd99565ae6453deab7c26e1', '2000','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i3vvr7biw6j3n1yl7scfm81s17333r17pxadwmedybh6oli8im','La Bachata','414pwsf6j0qmknq','POP','3tt9i3Hhzq84dPS8H7iSiJ','https://p.scdn.co/mp3-preview/0232b53fd7849e6696e1ab3099dd01dd00823f17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3h2s72nwifr7jtbxj036qzg60q3xqlhklbtjoz0togab75aumo', 'i3vvr7biw6j3n1yl7scfm81s17333r17pxadwmedybh6oli8im', '0');
-- Karol G
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mbau5oytbiqeffe', 'Karol G', '267@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeb97a2403d7b9a631ce0f59c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:267@artist.com', 'mbau5oytbiqeffe', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mbau5oytbiqeffe', 'A queen of reggaeton, known for her empowering anthems and vibrant performances.', 'Karol G');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lbrv74nbe6nghp6y10xz0b0sjgg683qje527yemvkoagjsei3v','mbau5oytbiqeffe', 'https://i.scdn.co/image/ab67616d0000b27382de1ca074ae63cb18fce335', 'MAÑANA SERÁ BONITO','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('b0d7ih86aybw6k2r508r3bwjw3fl27h6wuytou9cw5hglvcume','TQG','mbau5oytbiqeffe','POP','0DWdj2oZMBFSzRsi2Cvfzf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbrv74nbe6nghp6y10xz0b0sjgg683qje527yemvkoagjsei3v', 'b0d7ih86aybw6k2r508r3bwjw3fl27h6wuytou9cw5hglvcume', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3m0qin3gdcbkqho8dw2dvnnn47cbe5rfbfz6y5le6nu1k5g4nt','AMARGURA','mbau5oytbiqeffe','POP','505v13epFXodT9fVAJ6h8k',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbrv74nbe6nghp6y10xz0b0sjgg683qje527yemvkoagjsei3v', '3m0qin3gdcbkqho8dw2dvnnn47cbe5rfbfz6y5le6nu1k5g4nt', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ky29rya6b9a0er0jrjaraay1tivrgxibb7mwqgmxlqws9ptt0g','S91','mbau5oytbiqeffe','POP','7EpOXgSRgnglRWr86pZfGU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbrv74nbe6nghp6y10xz0b0sjgg683qje527yemvkoagjsei3v', 'ky29rya6b9a0er0jrjaraay1tivrgxibb7mwqgmxlqws9ptt0g', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h4qjpw2ywlosrjz0dj8c48hyvb9j1zmya11lyompufbg9ltbrx','MIENTRAS ME CURO DEL CORA','mbau5oytbiqeffe','POP','6otePxalBK8AVa20xhZYVQ',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbrv74nbe6nghp6y10xz0b0sjgg683qje527yemvkoagjsei3v', 'h4qjpw2ywlosrjz0dj8c48hyvb9j1zmya11lyompufbg9ltbrx', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2h3c56l8yaxxg5zp7t18r4yfhow4bkhmm7yxlv5jpjttjykyq9','X SI VOLVEMOS','mbau5oytbiqeffe','POP','4NoOME4Dhf4xgxbHDT7VGe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbrv74nbe6nghp6y10xz0b0sjgg683qje527yemvkoagjsei3v', '2h3c56l8yaxxg5zp7t18r4yfhow4bkhmm7yxlv5jpjttjykyq9', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('44wyxxr9in1fj9u5n05ewqm3mz2yxshlc5i2oqx3z8krvvxhqh','PROVENZA','mbau5oytbiqeffe','POP','3HqcNJdZ2seoGxhn0wVNDK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbrv74nbe6nghp6y10xz0b0sjgg683qje527yemvkoagjsei3v', '44wyxxr9in1fj9u5n05ewqm3mz2yxshlc5i2oqx3z8krvvxhqh', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p7kmkl2879fvrvf22dcq04q3j13pwzi3c501v5xs90qmzx9ueo','CAIRO','mbau5oytbiqeffe','POP','16dUQ4quIHDe4ZZ0wF1EMN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbrv74nbe6nghp6y10xz0b0sjgg683qje527yemvkoagjsei3v', 'p7kmkl2879fvrvf22dcq04q3j13pwzi3c501v5xs90qmzx9ueo', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('syvi6ztfyqfsomqfoq7foshwa4kxqjp4f9jp516m2cq7tob81a','PERO T','mbau5oytbiqeffe','POP','1dw7qShk971xMD6r6mA4VN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbrv74nbe6nghp6y10xz0b0sjgg683qje527yemvkoagjsei3v', 'syvi6ztfyqfsomqfoq7foshwa4kxqjp4f9jp516m2cq7tob81a', '7');


-- File: insert_relationships.sql
-- Users
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fygaat19wgbv908', 'Alice Johnson (0)', '0@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:0@g.com', 'fygaat19wgbv908', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3nlidq313d8ztl0', 'Diana Smith (1)', '1@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:1@g.com', '3nlidq313d8ztl0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hvnibsldmuyqlj6', 'Fiona Rodriguez (2)', '2@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:2@g.com', 'hvnibsldmuyqlj6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s6a76i6dmvpw3q3', 'George Rodriguez (3)', '3@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:3@g.com', 's6a76i6dmvpw3q3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('suk3j8xg44nshl9', 'Fiona Smith (4)', '4@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:4@g.com', 'suk3j8xg44nshl9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('aeayzzdcsr3z8np', 'Alice Garcia (5)', '5@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:5@g.com', 'aeayzzdcsr3z8np', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vlqxtgrgwwiu3lj', 'Charlie Jones (6)', '6@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:6@g.com', 'vlqxtgrgwwiu3lj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('45p9mm3xyx6hp2h', 'Edward Martinez (7)', '7@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:7@g.com', '45p9mm3xyx6hp2h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('itterl5zs2amzb8', 'Bob Davis (8)', '8@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:8@g.com', 'itterl5zs2amzb8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sv1aoe191pgq7qb', 'Julia Jones (9)', '9@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:9@g.com', 'sv1aoe191pgq7qb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
-- Playlists
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('zxdk5up9i0movo0fgt0dm7rml7gahlwq16jp42kmfcub8vhf6v', 'Playlist 0', '2023-11-17 17:00:08.000','fygaat19wgbv908');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('77qcrq1gr6l86mfhx9uxaa28b72cbirsa0w2mhn349c7dbgkyy', 'zxdk5up9i0movo0fgt0dm7rml7gahlwq16jp42kmfcub8vhf6v', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3l06q0nwd7ycbv0vpsle571bkg2ljkl6zvakf7u99rq72bz04w', 'zxdk5up9i0movo0fgt0dm7rml7gahlwq16jp42kmfcub8vhf6v', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mx262a3l8ug9hmt7bsxyijfgxu8255lhxi3tvftuzvhx9y46t3', 'zxdk5up9i0movo0fgt0dm7rml7gahlwq16jp42kmfcub8vhf6v', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('kj73wd2hneebyq7dflwy1dba3ivybgszjuat3kfz5vkgku342k', 'zxdk5up9i0movo0fgt0dm7rml7gahlwq16jp42kmfcub8vhf6v', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('rg4ej3yszhxcksf1gxdxrgms56tmrt32zq3mpw8rh1pef9850s', 'zxdk5up9i0movo0fgt0dm7rml7gahlwq16jp42kmfcub8vhf6v', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('x4doop38fm3g6rti54emb68jocypzowbjhfpc8cwgvdoyiejo9', 'zxdk5up9i0movo0fgt0dm7rml7gahlwq16jp42kmfcub8vhf6v', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7se7vrk91k2ph8jd64imzqkn8dwuw5bnv5c7zi1agaug5d7khj', 'zxdk5up9i0movo0fgt0dm7rml7gahlwq16jp42kmfcub8vhf6v', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6z8zc4bhle3ve1e2qagjjambezqi46xxe2ryauakb3cvswd8hr', 'zxdk5up9i0movo0fgt0dm7rml7gahlwq16jp42kmfcub8vhf6v', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tzgmn5fh9iqkyfmmt7ikt8f994zileqpk2hwpx9p6socab0mci', 'zxdk5up9i0movo0fgt0dm7rml7gahlwq16jp42kmfcub8vhf6v', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4cfvsxdjfvg7birovp544uwk7i0tgx7a7ogr0j8kwhqd4odlcr', 'zxdk5up9i0movo0fgt0dm7rml7gahlwq16jp42kmfcub8vhf6v', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('aljpl97pnzhcbn2qfpxq3zkibg18s017jgv31cuk0swkudc3ht', 'Playlist 1', '2023-11-17 17:00:08.000','fygaat19wgbv908');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bpoqwhlanhga4imt0azypr5pxywy9p69qypq9o2o7w83ocsfjv', 'aljpl97pnzhcbn2qfpxq3zkibg18s017jgv31cuk0swkudc3ht', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wvfh41js4pvxwno0nu72qgiu83rz4147ka0cn0tuzl0bqgp9bk', 'aljpl97pnzhcbn2qfpxq3zkibg18s017jgv31cuk0swkudc3ht', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e6bjuzifnhtu368wzg33btpf74muuvrgesnesmmb0hk35u3nvp', 'aljpl97pnzhcbn2qfpxq3zkibg18s017jgv31cuk0swkudc3ht', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('j0tfq5lbeykifimgv7sksytwql3mzgtrgu4w1q9qlgh8yfec4g', 'aljpl97pnzhcbn2qfpxq3zkibg18s017jgv31cuk0swkudc3ht', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yg46a28tl8mbyo73ihlr9l67yf5dt22kej7d79mutqu86ephqr', 'aljpl97pnzhcbn2qfpxq3zkibg18s017jgv31cuk0swkudc3ht', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t0f24m3noercyiv49no6ivbdfand8t9s5ikjaihrgtam8zu7nd', 'aljpl97pnzhcbn2qfpxq3zkibg18s017jgv31cuk0swkudc3ht', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h90gasji4jodhgfunyw9w8g5xguvaf04h7qt2nmujeuzawsuwe', 'aljpl97pnzhcbn2qfpxq3zkibg18s017jgv31cuk0swkudc3ht', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('p9ilfw9g8j5mh1tp0n6zz2z9hhxeit8sel1al2eobczvuntu4y', 'aljpl97pnzhcbn2qfpxq3zkibg18s017jgv31cuk0swkudc3ht', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('n6agiq4uvmtoffucq9j8ncufi7cxan7b9g917wc7060xf4okt7', 'aljpl97pnzhcbn2qfpxq3zkibg18s017jgv31cuk0swkudc3ht', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ny518qjfytd6ufjm7gki8nouhb2zu9dh1ptcvt8poz83vr3rb9', 'aljpl97pnzhcbn2qfpxq3zkibg18s017jgv31cuk0swkudc3ht', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('jjqc6y3jxxvu3r8vqd16m3vzvahak3zvlc07mec7hgcl61hvhr', 'Playlist 0', '2023-11-17 17:00:08.000','3nlidq313d8ztl0');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zs2o3gf8ryxhkk48xk9ebcf22su9nhhpzouq7t9lhpj7t8d7y8', 'jjqc6y3jxxvu3r8vqd16m3vzvahak3zvlc07mec7hgcl61hvhr', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('usjthzf6eamojts96gk0gfzs5b8lqxyzvc990pfckf4hmwr51c', 'jjqc6y3jxxvu3r8vqd16m3vzvahak3zvlc07mec7hgcl61hvhr', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('y3m3f7f8wcur19zy6mzxcirbgcdbpa2tse8co9f9xbwhhtyczg', 'jjqc6y3jxxvu3r8vqd16m3vzvahak3zvlc07mec7hgcl61hvhr', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7se7vrk91k2ph8jd64imzqkn8dwuw5bnv5c7zi1agaug5d7khj', 'jjqc6y3jxxvu3r8vqd16m3vzvahak3zvlc07mec7hgcl61hvhr', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m2lt5iwck7l0nqi33w55jxl69ztom92do0xpb6ossuy98ytpjj', 'jjqc6y3jxxvu3r8vqd16m3vzvahak3zvlc07mec7hgcl61hvhr', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sahr32imhiqzdw6eu2aiod6ht8etuta8o6zxrzsmcoq7pipopx', 'jjqc6y3jxxvu3r8vqd16m3vzvahak3zvlc07mec7hgcl61hvhr', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xsdod2g1hu4ttkxztqrafwpnmp7m1thgjbzvjpo0lp53bl863u', 'jjqc6y3jxxvu3r8vqd16m3vzvahak3zvlc07mec7hgcl61hvhr', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7i6ftzooiclja2cn0focim7egv62rfd2jpib3betbv7v45mz1j', 'jjqc6y3jxxvu3r8vqd16m3vzvahak3zvlc07mec7hgcl61hvhr', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3m0qin3gdcbkqho8dw2dvnnn47cbe5rfbfz6y5le6nu1k5g4nt', 'jjqc6y3jxxvu3r8vqd16m3vzvahak3zvlc07mec7hgcl61hvhr', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0tj44su08h1imb0swbcttesvh8r0oc1kw6siwyi97yyrj2ezj1', 'jjqc6y3jxxvu3r8vqd16m3vzvahak3zvlc07mec7hgcl61hvhr', 1);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('j0n6uo4l0rh611k8h8oh6kq5dxczjsfm62vvqjmn43vd4ycrwi', 'Playlist 1', '2023-11-17 17:00:08.000','3nlidq313d8ztl0');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('doo3pzapd9c35xpfhxh1rpsx667ti74eumwlpt5lr5p654vit0', 'j0n6uo4l0rh611k8h8oh6kq5dxczjsfm62vvqjmn43vd4ycrwi', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xq8w2wtxqgqigxzyde6b8riv3z5ljtkms97d9w90gvggr8lwsb', 'j0n6uo4l0rh611k8h8oh6kq5dxczjsfm62vvqjmn43vd4ycrwi', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('uzd3c5c9ixkix3bp8w50z820nzo9rukv8nu23i6rdzerhspmxt', 'j0n6uo4l0rh611k8h8oh6kq5dxczjsfm62vvqjmn43vd4ycrwi', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('uxtvwup0wxgq3w741fwq3dj8rhhrw8fu1pzidc8lg8p7mlskve', 'j0n6uo4l0rh611k8h8oh6kq5dxczjsfm62vvqjmn43vd4ycrwi', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tdsmpyjgyce0r0p0cpwn4ugyab082gdwlpfmytig42apxdslya', 'j0n6uo4l0rh611k8h8oh6kq5dxczjsfm62vvqjmn43vd4ycrwi', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6wyyr4ojj2aqetjbjirszyc53yt2wt5wmf70pcnef99yeons1q', 'j0n6uo4l0rh611k8h8oh6kq5dxczjsfm62vvqjmn43vd4ycrwi', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('c87iufqa199zusuhb9oc8zi8yhy2ojq58fxufvuiepu71gw078', 'j0n6uo4l0rh611k8h8oh6kq5dxczjsfm62vvqjmn43vd4ycrwi', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fjc5uqc9acynrhtxet3s5khe76wrv6v5tm4sn0qmcyxv3o07dw', 'j0n6uo4l0rh611k8h8oh6kq5dxczjsfm62vvqjmn43vd4ycrwi', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e9a00ilsrdzrnaqc1q7q9t1fcskti9sbsfc4wv0bgbi20p3jgs', 'j0n6uo4l0rh611k8h8oh6kq5dxczjsfm62vvqjmn43vd4ycrwi', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('q7walm29a9esfqm8xg8exw8iupvh52gttwgyf15fjgj0n9hjky', 'j0n6uo4l0rh611k8h8oh6kq5dxczjsfm62vvqjmn43vd4ycrwi', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('ikg78gbbj0svl2kw8883oiha1femp0szklo3teyvpuf4h5y4u9', 'Playlist 0', '2023-11-17 17:00:08.000','hvnibsldmuyqlj6');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('irq1ofm6w0zhyu2kfo3rdfku2z9s3aimd0y2rd3jo3nhqklm7a', 'ikg78gbbj0svl2kw8883oiha1femp0szklo3teyvpuf4h5y4u9', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('um5yls7yde292mqmm4cd8jovg5cljce2jlfcbziimis0vqpmp6', 'ikg78gbbj0svl2kw8883oiha1femp0szklo3teyvpuf4h5y4u9', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wtbckxokywodsk04dj6njxivqdb6n22p17jrf8qj79ov2r9jzi', 'ikg78gbbj0svl2kw8883oiha1femp0szklo3teyvpuf4h5y4u9', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('owzex26u8ary2s5mkjux3gvdsv0ny9z5x7atrxna8jqw1lmsts', 'ikg78gbbj0svl2kw8883oiha1femp0szklo3teyvpuf4h5y4u9', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('65p36432fiwizot6ayzou8eik0zvgen9pai10sotn37aptpolz', 'ikg78gbbj0svl2kw8883oiha1femp0szklo3teyvpuf4h5y4u9', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0jsbanye2jaqytvwayrtqo02bxfc8j2cw2y75ttir6pbz0n0wd', 'ikg78gbbj0svl2kw8883oiha1femp0szklo3teyvpuf4h5y4u9', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2t6o5lsq6rn74r4lgjtw5mwme1062igm4utkwffgfs55jrrbqk', 'ikg78gbbj0svl2kw8883oiha1femp0szklo3teyvpuf4h5y4u9', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1285pzodpgdp1tgjakoidhtjkgwy806akxx145yw5hfecethkx', 'ikg78gbbj0svl2kw8883oiha1femp0szklo3teyvpuf4h5y4u9', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('moq4ix0f6ir2vnq52ocaq599ygfyjmjzdvf30hte7bihq4syfc', 'ikg78gbbj0svl2kw8883oiha1femp0szklo3teyvpuf4h5y4u9', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('iomzzk05qcyzfqoj361d4p9lvv123m2h7notqvs2r6gq7jw1jz', 'ikg78gbbj0svl2kw8883oiha1femp0szklo3teyvpuf4h5y4u9', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('3owvvtvxg13d731mihzu3bb3uggcxq7yhvpznxcehoq6ene0f2', 'Playlist 1', '2023-11-17 17:00:08.000','hvnibsldmuyqlj6');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('rsrbaxc8kgjm6ucgv4zbakqmloa5oxbvj5i83czk5a33so3kqy', '3owvvtvxg13d731mihzu3bb3uggcxq7yhvpznxcehoq6ene0f2', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('x4doop38fm3g6rti54emb68jocypzowbjhfpc8cwgvdoyiejo9', '3owvvtvxg13d731mihzu3bb3uggcxq7yhvpznxcehoq6ene0f2', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t0f24m3noercyiv49no6ivbdfand8t9s5ikjaihrgtam8zu7nd', '3owvvtvxg13d731mihzu3bb3uggcxq7yhvpznxcehoq6ene0f2', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('q03vwgl7dw151d0wvf17ujtbgri5ael8cljxltvfyfllcwmi49', '3owvvtvxg13d731mihzu3bb3uggcxq7yhvpznxcehoq6ene0f2', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6dalr30uz2swmqqt9ye2f5n2lgmjidz6rjup96bu80ua7y3gyo', '3owvvtvxg13d731mihzu3bb3uggcxq7yhvpznxcehoq6ene0f2', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8bx409xktlbtchve4d71j6n4xdopj6m5do88b4yvuuorstpuws', '3owvvtvxg13d731mihzu3bb3uggcxq7yhvpznxcehoq6ene0f2', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('iomzzk05qcyzfqoj361d4p9lvv123m2h7notqvs2r6gq7jw1jz', '3owvvtvxg13d731mihzu3bb3uggcxq7yhvpznxcehoq6ene0f2', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5uxb6dtx500wj6bfuws6j4217xbfiwd8ajjvd4a2j3zyz3slfh', '3owvvtvxg13d731mihzu3bb3uggcxq7yhvpznxcehoq6ene0f2', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hs5hz3cc58c5w7czoo2nwbs8ydas3oebdx7ws4zf3eljrw0gtx', '3owvvtvxg13d731mihzu3bb3uggcxq7yhvpznxcehoq6ene0f2', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('topk7datjytarwnl6pgxg6u3hab0qzlx78l9wnubo2x0lhwfj8', '3owvvtvxg13d731mihzu3bb3uggcxq7yhvpznxcehoq6ene0f2', 5);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('dw2blibn3zf06akt2g13zhzxxtd374sqskaij6q5mrux8cij0c', 'Playlist 0', '2023-11-17 17:00:08.000','s6a76i6dmvpw3q3');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hru0ffbo7295mbrzzorktyrzzzrg6z3sx7n84iwayri2hkk849', 'dw2blibn3zf06akt2g13zhzxxtd374sqskaij6q5mrux8cij0c', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wtbckxokywodsk04dj6njxivqdb6n22p17jrf8qj79ov2r9jzi', 'dw2blibn3zf06akt2g13zhzxxtd374sqskaij6q5mrux8cij0c', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m8tubaxxl7g5gk38x9774f2ljncaf1ednxl3qnhtlvcum4do42', 'dw2blibn3zf06akt2g13zhzxxtd374sqskaij6q5mrux8cij0c', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('or89h6stg7q9u047b56xhnkobb1rjhdp6fnrobxq4j2wfo6g62', 'dw2blibn3zf06akt2g13zhzxxtd374sqskaij6q5mrux8cij0c', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vqibkbpfdietxkitns3pehf4xijdlvl4lgugbnisq8tyyy4jqa', 'dw2blibn3zf06akt2g13zhzxxtd374sqskaij6q5mrux8cij0c', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('62cpdk3c7k3nw803t2criczzguhc4l5bfwu8crfzxgecm7y3cl', 'dw2blibn3zf06akt2g13zhzxxtd374sqskaij6q5mrux8cij0c', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0gaeibsee0b008jfjndnnlrbqgu7cuua0nps81h1ldudzryc0j', 'dw2blibn3zf06akt2g13zhzxxtd374sqskaij6q5mrux8cij0c', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m81y789zaluxirozv46rb9bceto9indm21hdrl2lkw5xvikik7', 'dw2blibn3zf06akt2g13zhzxxtd374sqskaij6q5mrux8cij0c', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gsyi306zara7w3c964lydow9lqgeut9shydscpmc9kykr1xpsn', 'dw2blibn3zf06akt2g13zhzxxtd374sqskaij6q5mrux8cij0c', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wxi955jbevgdwifninybygu4lyjfuuumuisswcv3nlwh3psu18', 'dw2blibn3zf06akt2g13zhzxxtd374sqskaij6q5mrux8cij0c', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('k7lgor5456hjv5m2juwq10yeemx51l5rhxutj1xgmwjg17ch4z', 'Playlist 1', '2023-11-17 17:00:08.000','s6a76i6dmvpw3q3');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vxg2lq20jmjxgwl1feiv63hzx4qhv1yxavnzx0k6i1d7qmmqac', 'k7lgor5456hjv5m2juwq10yeemx51l5rhxutj1xgmwjg17ch4z', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('77qcrq1gr6l86mfhx9uxaa28b72cbirsa0w2mhn349c7dbgkyy', 'k7lgor5456hjv5m2juwq10yeemx51l5rhxutj1xgmwjg17ch4z', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4cfvsxdjfvg7birovp544uwk7i0tgx7a7ogr0j8kwhqd4odlcr', 'k7lgor5456hjv5m2juwq10yeemx51l5rhxutj1xgmwjg17ch4z', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('s1sp4wrt2i8qh0zoqlfegabmrqglux6p91mcu072x5tbevz79t', 'k7lgor5456hjv5m2juwq10yeemx51l5rhxutj1xgmwjg17ch4z', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('25mp65tpy930vpb2ub8si95fgjauualcp402i43z5c71rnsg08', 'k7lgor5456hjv5m2juwq10yeemx51l5rhxutj1xgmwjg17ch4z', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('u7hi3w1ajizbl7gbtkacznqvaw1xxjrpv04yv1kf4prlzgteho', 'k7lgor5456hjv5m2juwq10yeemx51l5rhxutj1xgmwjg17ch4z', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6hpye01uk6e63ruvv1u40ttvdb288s20a9gchvdcvjw0vemdo7', 'k7lgor5456hjv5m2juwq10yeemx51l5rhxutj1xgmwjg17ch4z', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qciwefrc203scw3fxv06xonm4fpef28e5tfg1pzzfux0p1hrc4', 'k7lgor5456hjv5m2juwq10yeemx51l5rhxutj1xgmwjg17ch4z', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e9a00ilsrdzrnaqc1q7q9t1fcskti9sbsfc4wv0bgbi20p3jgs', 'k7lgor5456hjv5m2juwq10yeemx51l5rhxutj1xgmwjg17ch4z', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('arxzti8thqs3tpxahv7sbst7t7pkfcv84bqde2fq8zrduxnkjo', 'k7lgor5456hjv5m2juwq10yeemx51l5rhxutj1xgmwjg17ch4z', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('a1x1as444po4cu95nwqke9wy30rys4fzglq21na0si4vyatz35', 'Playlist 0', '2023-11-17 17:00:08.000','suk3j8xg44nshl9');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0xcsmcxe5mepqsezrytgkjef4k6or4ggcols0h3164xerigxcs', 'a1x1as444po4cu95nwqke9wy30rys4fzglq21na0si4vyatz35', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d65xwfubtad1tlibnhqiw2urmbjxpucplr5xzdwvf7vz7fct1k', 'a1x1as444po4cu95nwqke9wy30rys4fzglq21na0si4vyatz35', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fuhyv0le8hox4wwzci6afv4kem5m3nh2btkbfrslnboqzc4m7z', 'a1x1as444po4cu95nwqke9wy30rys4fzglq21na0si4vyatz35', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6e6ul3z4rzeudz6gmhtezerouxpch47r56gi5pgpeexy8ukmoi', 'a1x1as444po4cu95nwqke9wy30rys4fzglq21na0si4vyatz35', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('uzr1c67i61cb7kecgjkn7fkd9yudabqnlxdkhjptx6gkhtu5vh', 'a1x1as444po4cu95nwqke9wy30rys4fzglq21na0si4vyatz35', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6lafcij9bza8phdap90ny0p54d8531gzbsu6wor8ybphvsch1q', 'a1x1as444po4cu95nwqke9wy30rys4fzglq21na0si4vyatz35', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qciwefrc203scw3fxv06xonm4fpef28e5tfg1pzzfux0p1hrc4', 'a1x1as444po4cu95nwqke9wy30rys4fzglq21na0si4vyatz35', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wlw0bqxyhkgkufz8b1ukkc27abtmj0qt3t7dts9s24uj6ars9t', 'a1x1as444po4cu95nwqke9wy30rys4fzglq21na0si4vyatz35', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4cfvsxdjfvg7birovp544uwk7i0tgx7a7ogr0j8kwhqd4odlcr', 'a1x1as444po4cu95nwqke9wy30rys4fzglq21na0si4vyatz35', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d1cps508a6hst36nb7atb98jm6xk77jv3imgtwpicxuezn5v43', 'a1x1as444po4cu95nwqke9wy30rys4fzglq21na0si4vyatz35', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('t8mopq2qdgy3rtcqzgihb7zk6cbm1pew60ab4a5x3vet03svo6', 'Playlist 1', '2023-11-17 17:00:08.000','suk3j8xg44nshl9');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('c7acc45xzt3g3qgnc2vlu3z1fe77dj7k434kr54ff9y0n9itu5', 't8mopq2qdgy3rtcqzgihb7zk6cbm1pew60ab4a5x3vet03svo6', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('40vqzb0n5imu8221n7u3v3g4qitppm3f3kr60hdwcb87j4xgjr', 't8mopq2qdgy3rtcqzgihb7zk6cbm1pew60ab4a5x3vet03svo6', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('kzl3lb0h9uh7gen2jejsmm1pxtmdibjk31bk2bkm4seyox598z', 't8mopq2qdgy3rtcqzgihb7zk6cbm1pew60ab4a5x3vet03svo6', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('oxxipvicyj7iryve4ufv8iqmycv6wvs6twpc6rb33hoyqv9agx', 't8mopq2qdgy3rtcqzgihb7zk6cbm1pew60ab4a5x3vet03svo6', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('j3u2bu12u7kt5yhf5cq15xb78pytwxf4m1yh03oyssym60xchx', 't8mopq2qdgy3rtcqzgihb7zk6cbm1pew60ab4a5x3vet03svo6', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vy6ez97bi1lr098ca4x3s5lvbbm2tzwg39mn2xqnkajgygs9mf', 't8mopq2qdgy3rtcqzgihb7zk6cbm1pew60ab4a5x3vet03svo6', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cwajxa28awbkkwv5ha7u5h62jsy083jew6bcx2dikn7k328sr4', 't8mopq2qdgy3rtcqzgihb7zk6cbm1pew60ab4a5x3vet03svo6', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nzp0ucrd8yi8mrt41xyv9elpbikemqz1yuzprdvfyylr6h9ony', 't8mopq2qdgy3rtcqzgihb7zk6cbm1pew60ab4a5x3vet03svo6', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('44wyxxr9in1fj9u5n05ewqm3mz2yxshlc5i2oqx3z8krvvxhqh', 't8mopq2qdgy3rtcqzgihb7zk6cbm1pew60ab4a5x3vet03svo6', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qxfmuumvoamvhd3fvpra0fogjk17xj23aes2zi062b32h8wojh', 't8mopq2qdgy3rtcqzgihb7zk6cbm1pew60ab4a5x3vet03svo6', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('bc5d99tejrejion4g40gorkurydkwtfnmcguzgb4loq0qovwww', 'Playlist 0', '2023-11-17 17:00:08.000','aeayzzdcsr3z8np');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('aiw7ls76sw2qxu461269b36ydovikmywdou62ml6f9fftqwzcw', 'bc5d99tejrejion4g40gorkurydkwtfnmcguzgb4loq0qovwww', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8zuftrc5jc6ak40kf6fp8xnr8qqtpkz98l1x8va9qaatxi1crh', 'bc5d99tejrejion4g40gorkurydkwtfnmcguzgb4loq0qovwww', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yhh8nl09p801xgrvo3ksal20cj5wznugd24kkwg1z9raykpxzz', 'bc5d99tejrejion4g40gorkurydkwtfnmcguzgb4loq0qovwww', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4cfvsxdjfvg7birovp544uwk7i0tgx7a7ogr0j8kwhqd4odlcr', 'bc5d99tejrejion4g40gorkurydkwtfnmcguzgb4loq0qovwww', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7jss8ilxg4r9lemzzqq56pyex52xywf14sjqoagz78wizfvltu', 'bc5d99tejrejion4g40gorkurydkwtfnmcguzgb4loq0qovwww', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e9a00ilsrdzrnaqc1q7q9t1fcskti9sbsfc4wv0bgbi20p3jgs', 'bc5d99tejrejion4g40gorkurydkwtfnmcguzgb4loq0qovwww', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z7heug7vmry24r3k57hhdu1z11pktvju5z906xfo2yb684l119', 'bc5d99tejrejion4g40gorkurydkwtfnmcguzgb4loq0qovwww', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vy6ez97bi1lr098ca4x3s5lvbbm2tzwg39mn2xqnkajgygs9mf', 'bc5d99tejrejion4g40gorkurydkwtfnmcguzgb4loq0qovwww', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gfu5jczvdkunftb50n3ieo775jos7a7e757bpu3n6u5s8hwp14', 'bc5d99tejrejion4g40gorkurydkwtfnmcguzgb4loq0qovwww', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('o157laauq98fsuuk13wkiclsdgrgp4n0go015az3uy65cgq32p', 'bc5d99tejrejion4g40gorkurydkwtfnmcguzgb4loq0qovwww', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('qva5bx7wjr90eqn3jmuaikusyofd1842e6an0m99fxsgcufd0c', 'Playlist 1', '2023-11-17 17:00:08.000','aeayzzdcsr3z8np');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('my0ys52gtie1bij6bnxzt6iu8dr1u1g0tmg02ce760qb0pkeg2', 'qva5bx7wjr90eqn3jmuaikusyofd1842e6an0m99fxsgcufd0c', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1pf93vjriss1i3gozrnfh1ijph67udgux46g2gc94kxioxpkhg', 'qva5bx7wjr90eqn3jmuaikusyofd1842e6an0m99fxsgcufd0c', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ahp9ocvly9q93x1kwgix3cakbatie03pis8k4suuaonuzl571j', 'qva5bx7wjr90eqn3jmuaikusyofd1842e6an0m99fxsgcufd0c', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('p9ilfw9g8j5mh1tp0n6zz2z9hhxeit8sel1al2eobczvuntu4y', 'qva5bx7wjr90eqn3jmuaikusyofd1842e6an0m99fxsgcufd0c', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('c3lzwy0lffhr9yrhghrm0pidxgtopptqx171s9zogc4iur18au', 'qva5bx7wjr90eqn3jmuaikusyofd1842e6an0m99fxsgcufd0c', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2l9vrdf0if4vgvizbhs09mo2b8vgw9tfjg8ufjyre7n8soo5dp', 'qva5bx7wjr90eqn3jmuaikusyofd1842e6an0m99fxsgcufd0c', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7jss8ilxg4r9lemzzqq56pyex52xywf14sjqoagz78wizfvltu', 'qva5bx7wjr90eqn3jmuaikusyofd1842e6an0m99fxsgcufd0c', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gpik5z6a3q3m1b1l7kzg2ye7lzcesvc5y1woprb9d0tezdcqpz', 'qva5bx7wjr90eqn3jmuaikusyofd1842e6an0m99fxsgcufd0c', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8koz8dr66ldafs476c1g7gg5f0aax3lvyjo8wedjfkv9wrilse', 'qva5bx7wjr90eqn3jmuaikusyofd1842e6an0m99fxsgcufd0c', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9s1r0y5haoc38x0feo3nf92l13k6g2kh2qxccq2d2jx3erxrk2', 'qva5bx7wjr90eqn3jmuaikusyofd1842e6an0m99fxsgcufd0c', 2);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('n23tcuujonh0j7zt901w91lhgyjxthstz7iocbrf8vya36bl9n', 'Playlist 0', '2023-11-17 17:00:08.000','vlqxtgrgwwiu3lj');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t5p1bdqwrtpp7eo0pwjyuuzd77ql6bamo9t1h7zm7ujou2h3xw', 'n23tcuujonh0j7zt901w91lhgyjxthstz7iocbrf8vya36bl9n', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7xo91ulb27qmdoc7n2nt2l32qzqcvtmd4qs6aojebmpfv2v5y0', 'n23tcuujonh0j7zt901w91lhgyjxthstz7iocbrf8vya36bl9n', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sovilkvnxud7f5cmhrzk3nqs8z9zee8q2t0pybrsm9boten17e', 'n23tcuujonh0j7zt901w91lhgyjxthstz7iocbrf8vya36bl9n', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ye713mjerovsukabuw8ipv3erkec5ul545hafjjo6kp02ucua4', 'n23tcuujonh0j7zt901w91lhgyjxthstz7iocbrf8vya36bl9n', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0x59xvndyimq3dddk9lsipl8p0vg81jy4qbt6zq4uslbj7huwg', 'n23tcuujonh0j7zt901w91lhgyjxthstz7iocbrf8vya36bl9n', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ny518qjfytd6ufjm7gki8nouhb2zu9dh1ptcvt8poz83vr3rb9', 'n23tcuujonh0j7zt901w91lhgyjxthstz7iocbrf8vya36bl9n', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('kj73wd2hneebyq7dflwy1dba3ivybgszjuat3kfz5vkgku342k', 'n23tcuujonh0j7zt901w91lhgyjxthstz7iocbrf8vya36bl9n', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('33xfyqt1rogz8970va0ppu34ejieuhpnlbiru5z0wcvrkr6g47', 'n23tcuujonh0j7zt901w91lhgyjxthstz7iocbrf8vya36bl9n', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('moq4ix0f6ir2vnq52ocaq599ygfyjmjzdvf30hte7bihq4syfc', 'n23tcuujonh0j7zt901w91lhgyjxthstz7iocbrf8vya36bl9n', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gja5y61axnpavai96r06k832b1h3zdhvlbvgxsp8w4w5ygkhtp', 'n23tcuujonh0j7zt901w91lhgyjxthstz7iocbrf8vya36bl9n', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('ma0ztum9rcf76t8dwthgowhc9q2pbxmn399zwdn7dqtk3s10l3', 'Playlist 1', '2023-11-17 17:00:08.000','vlqxtgrgwwiu3lj');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('uxtvwup0wxgq3w741fwq3dj8rhhrw8fu1pzidc8lg8p7mlskve', 'ma0ztum9rcf76t8dwthgowhc9q2pbxmn399zwdn7dqtk3s10l3', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m3wezlwozuogq9i6sub1ex1oe6ka1r7ppmrfw3sre4jd2k7ff7', 'ma0ztum9rcf76t8dwthgowhc9q2pbxmn399zwdn7dqtk3s10l3', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z0l4bfmq9asth043lgahrva4jwjknnzrunzpewcupnho13mylm', 'ma0ztum9rcf76t8dwthgowhc9q2pbxmn399zwdn7dqtk3s10l3', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vjywdn3sj7n0a9fsjar8qi2marravz67es3nc06ekvdzxjifyq', 'ma0ztum9rcf76t8dwthgowhc9q2pbxmn399zwdn7dqtk3s10l3', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('02zgcfmpbip4c6tr36lwat05mh3cv6x074800inlb52p6x17jp', 'ma0ztum9rcf76t8dwthgowhc9q2pbxmn399zwdn7dqtk3s10l3', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0jsbanye2jaqytvwayrtqo02bxfc8j2cw2y75ttir6pbz0n0wd', 'ma0ztum9rcf76t8dwthgowhc9q2pbxmn399zwdn7dqtk3s10l3', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2crhnrypoi0jqna6lz0un30oq0qqrl1cvr1sezzrd6863qx08u', 'ma0ztum9rcf76t8dwthgowhc9q2pbxmn399zwdn7dqtk3s10l3', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('65nhz9sujwyk8vpygacagqobodjpbud0aehaek0gnobty78aud', 'ma0ztum9rcf76t8dwthgowhc9q2pbxmn399zwdn7dqtk3s10l3', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1ph5nykbaewhttzojtpxvilkzcru34x3ncohpursy950u4tt1y', 'ma0ztum9rcf76t8dwthgowhc9q2pbxmn399zwdn7dqtk3s10l3', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('owzex26u8ary2s5mkjux3gvdsv0ny9z5x7atrxna8jqw1lmsts', 'ma0ztum9rcf76t8dwthgowhc9q2pbxmn399zwdn7dqtk3s10l3', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('6p24fiwi1h7kqxeqwhoo4tvdvlu5bsyeo9gqnov9jgkoubzrsa', 'Playlist 0', '2023-11-17 17:00:08.000','45p9mm3xyx6hp2h');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t5p1bdqwrtpp7eo0pwjyuuzd77ql6bamo9t1h7zm7ujou2h3xw', '6p24fiwi1h7kqxeqwhoo4tvdvlu5bsyeo9gqnov9jgkoubzrsa', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tteq8j2c3b00hlqs02sz0t4ntnjx6pfrk20s15nsxcohsitckx', '6p24fiwi1h7kqxeqwhoo4tvdvlu5bsyeo9gqnov9jgkoubzrsa', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fuhyv0le8hox4wwzci6afv4kem5m3nh2btkbfrslnboqzc4m7z', '6p24fiwi1h7kqxeqwhoo4tvdvlu5bsyeo9gqnov9jgkoubzrsa', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1xdyv2j5g6054jz5w3jdc3ycutdnu4tf3cpksyoyoi2wgogxp1', '6p24fiwi1h7kqxeqwhoo4tvdvlu5bsyeo9gqnov9jgkoubzrsa', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('k5nzca33yul944q4h0l0n2517i0ig8bmlu9a94jctzuzckt8ry', '6p24fiwi1h7kqxeqwhoo4tvdvlu5bsyeo9gqnov9jgkoubzrsa', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('aiw7ls76sw2qxu461269b36ydovikmywdou62ml6f9fftqwzcw', '6p24fiwi1h7kqxeqwhoo4tvdvlu5bsyeo9gqnov9jgkoubzrsa', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('rhagt0m3kpmochx0kbgs6o3j6v8p1qhc0a5ng3cw8cfab0x15l', '6p24fiwi1h7kqxeqwhoo4tvdvlu5bsyeo9gqnov9jgkoubzrsa', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tdsmpyjgyce0r0p0cpwn4ugyab082gdwlpfmytig42apxdslya', '6p24fiwi1h7kqxeqwhoo4tvdvlu5bsyeo9gqnov9jgkoubzrsa', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1c5e2ggicjjrgfa4bje2e773xjbx9e7hdi8l3vjx0jenhfsh37', '6p24fiwi1h7kqxeqwhoo4tvdvlu5bsyeo9gqnov9jgkoubzrsa', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('f260r64mmp8x5yz6yszruz63jky8gqbs8rf11wv8lzi5cljjr6', '6p24fiwi1h7kqxeqwhoo4tvdvlu5bsyeo9gqnov9jgkoubzrsa', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('jgqr8wig373qrpen54wt39kiri8qmbdey9crp7wwmstoai4w86', 'Playlist 1', '2023-11-17 17:00:08.000','45p9mm3xyx6hp2h');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pshcufoapzlt4fua6s4wzclmkke5jblax3xxseeyh1mnbyunug', 'jgqr8wig373qrpen54wt39kiri8qmbdey9crp7wwmstoai4w86', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('beanji0m6rxpw8vubu61oyr0si4fuu6gr1lixt0fxytax6mlw2', 'jgqr8wig373qrpen54wt39kiri8qmbdey9crp7wwmstoai4w86', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('oxxipvicyj7iryve4ufv8iqmycv6wvs6twpc6rb33hoyqv9agx', 'jgqr8wig373qrpen54wt39kiri8qmbdey9crp7wwmstoai4w86', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2u0uw6r62iejqbnlu01v5cgl8qbqa9pweqo35mvjt7aekj5slc', 'jgqr8wig373qrpen54wt39kiri8qmbdey9crp7wwmstoai4w86', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9pc3y9xg8lc53gj3ckjs3rnpu3rnrcfxsmc4y0flszrr2in0vi', 'jgqr8wig373qrpen54wt39kiri8qmbdey9crp7wwmstoai4w86', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2nzugfcttpci0etdprux153ipzgsfhsdkcel9kepgf96jsc9iw', 'jgqr8wig373qrpen54wt39kiri8qmbdey9crp7wwmstoai4w86', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('n8qr7hs3km9m49bfcujyueh9zhbn6bgfcx0ofqn1cvfmmfiij9', 'jgqr8wig373qrpen54wt39kiri8qmbdey9crp7wwmstoai4w86', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('p7ek5axyz120vxuv7prjeen2xc8oza71sz37yqiv6xa9edzzdy', 'jgqr8wig373qrpen54wt39kiri8qmbdey9crp7wwmstoai4w86', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zmadm6h8yh8u6xbnxdhsbksmfgkn272nlawwjhvba1org6bcvc', 'jgqr8wig373qrpen54wt39kiri8qmbdey9crp7wwmstoai4w86', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('by2g4vi12191csxyd6w25qjhbdk5ncvu3wdh1yswloc5doltzk', 'jgqr8wig373qrpen54wt39kiri8qmbdey9crp7wwmstoai4w86', 0);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('mlkzs7tcr5mi9oy0dg8o367pnofqa3229kvddnzp3jus5nkhfw', 'Playlist 0', '2023-11-17 17:00:08.000','itterl5zs2amzb8');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hgrqy865b7viwsj88zyc1h5n3qaflyxsck61wfptaevt523c7e', 'mlkzs7tcr5mi9oy0dg8o367pnofqa3229kvddnzp3jus5nkhfw', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7j5wz8lftyj9e8h82c3eu8pob68tjpgboogm7b8yqx8m3cbyfm', 'mlkzs7tcr5mi9oy0dg8o367pnofqa3229kvddnzp3jus5nkhfw', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ny518qjfytd6ufjm7gki8nouhb2zu9dh1ptcvt8poz83vr3rb9', 'mlkzs7tcr5mi9oy0dg8o367pnofqa3229kvddnzp3jus5nkhfw', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('beanji0m6rxpw8vubu61oyr0si4fuu6gr1lixt0fxytax6mlw2', 'mlkzs7tcr5mi9oy0dg8o367pnofqa3229kvddnzp3jus5nkhfw', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tmn9hdiokn5ctbc57e7fn6omw6vf07a8akedq1btnzv79ojmm1', 'mlkzs7tcr5mi9oy0dg8o367pnofqa3229kvddnzp3jus5nkhfw', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vxg2lq20jmjxgwl1feiv63hzx4qhv1yxavnzx0k6i1d7qmmqac', 'mlkzs7tcr5mi9oy0dg8o367pnofqa3229kvddnzp3jus5nkhfw', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7ls77h7uceu5832jipou6ogjxi557xrd79nl784adxk760cmwu', 'mlkzs7tcr5mi9oy0dg8o367pnofqa3229kvddnzp3jus5nkhfw', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('doo3pzapd9c35xpfhxh1rpsx667ti74eumwlpt5lr5p654vit0', 'mlkzs7tcr5mi9oy0dg8o367pnofqa3229kvddnzp3jus5nkhfw', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cvv51xssmj6zg15nxetkux2z24iusuzfen369a95g0l6n7trx7', 'mlkzs7tcr5mi9oy0dg8o367pnofqa3229kvddnzp3jus5nkhfw', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e7thp358q1ov03lhs3xp7rzu5ehx662tyra3a6oxpbd8botrar', 'mlkzs7tcr5mi9oy0dg8o367pnofqa3229kvddnzp3jus5nkhfw', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('1zdm7ugd8nkstv8eda94rl6y90y1dvpg6n70kjm7zh6ihlkmb2', 'Playlist 1', '2023-11-17 17:00:08.000','itterl5zs2amzb8');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z4m3f9onl0w1efd6ywv02vb1x2esh0co7iykalepnw3z93i1z6', '1zdm7ugd8nkstv8eda94rl6y90y1dvpg6n70kjm7zh6ihlkmb2', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('q7walm29a9esfqm8xg8exw8iupvh52gttwgyf15fjgj0n9hjky', '1zdm7ugd8nkstv8eda94rl6y90y1dvpg6n70kjm7zh6ihlkmb2', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('491fg7169c69goyum6c43q6ybmrtoe2ar9vs9jegit7p4nmd31', '1zdm7ugd8nkstv8eda94rl6y90y1dvpg6n70kjm7zh6ihlkmb2', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7j5wz8lftyj9e8h82c3eu8pob68tjpgboogm7b8yqx8m3cbyfm', '1zdm7ugd8nkstv8eda94rl6y90y1dvpg6n70kjm7zh6ihlkmb2', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('06141hl2hu8afayerhgkvjk37vmefzg1jk220zmghrrbba7fqa', '1zdm7ugd8nkstv8eda94rl6y90y1dvpg6n70kjm7zh6ihlkmb2', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('j0tfq5lbeykifimgv7sksytwql3mzgtrgu4w1q9qlgh8yfec4g', '1zdm7ugd8nkstv8eda94rl6y90y1dvpg6n70kjm7zh6ihlkmb2', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1pf93vjriss1i3gozrnfh1ijph67udgux46g2gc94kxioxpkhg', '1zdm7ugd8nkstv8eda94rl6y90y1dvpg6n70kjm7zh6ihlkmb2', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('02fbmvabcikagbb0uqte3cod3dxen73fd93jo5il9xkifw1x87', '1zdm7ugd8nkstv8eda94rl6y90y1dvpg6n70kjm7zh6ihlkmb2', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1t6epaatqnpu14p67z1l0wdb5dv71mymi9z9kk52dc1qyxl6ay', '1zdm7ugd8nkstv8eda94rl6y90y1dvpg6n70kjm7zh6ihlkmb2', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8koz8dr66ldafs476c1g7gg5f0aax3lvyjo8wedjfkv9wrilse', '1zdm7ugd8nkstv8eda94rl6y90y1dvpg6n70kjm7zh6ihlkmb2', 1);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('zou4yqoxgbeqosjpgq7zumr4sh26hh861j60w3oqun5a4rj5q0', 'Playlist 0', '2023-11-17 17:00:08.000','sv1aoe191pgq7qb');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('77qcrq1gr6l86mfhx9uxaa28b72cbirsa0w2mhn349c7dbgkyy', 'zou4yqoxgbeqosjpgq7zumr4sh26hh861j60w3oqun5a4rj5q0', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wce32o6vvl29dzlhjnqt32kvzt7ln3qn8e6gbxofwrplmpxm8h', 'zou4yqoxgbeqosjpgq7zumr4sh26hh861j60w3oqun5a4rj5q0', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9z7vqnclxg6yluf55r3v8piegwg8tpzpfiktiiwtsu6ab6ub53', 'zou4yqoxgbeqosjpgq7zumr4sh26hh861j60w3oqun5a4rj5q0', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ojsilu0e86il19xkdexw79cmczhhcl300vr3vdjhr23ww6oy6q', 'zou4yqoxgbeqosjpgq7zumr4sh26hh861j60w3oqun5a4rj5q0', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vg8fcsmnvdp4uc3geonywmol2j59u0ridcfz7i9x8abnjawxdh', 'zou4yqoxgbeqosjpgq7zumr4sh26hh861j60w3oqun5a4rj5q0', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h1zwfnbsp25ui9c6up8xze8k0qeon54bzi2654supsnx7lhmxe', 'zou4yqoxgbeqosjpgq7zumr4sh26hh861j60w3oqun5a4rj5q0', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qu77g8sg72jlftl86px5s2hj9eganz4kypkhdanot3d0ql56mv', 'zou4yqoxgbeqosjpgq7zumr4sh26hh861j60w3oqun5a4rj5q0', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ht51igwj7lnqujrnm7z2a0enxcx28ns9q6rvdx72d76gxym92s', 'zou4yqoxgbeqosjpgq7zumr4sh26hh861j60w3oqun5a4rj5q0', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d5k7fuxye48mi9gsk15qlrwdx09o2buntaxqjzgvew5glxl74r', 'zou4yqoxgbeqosjpgq7zumr4sh26hh861j60w3oqun5a4rj5q0', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('q7walm29a9esfqm8xg8exw8iupvh52gttwgyf15fjgj0n9hjky', 'zou4yqoxgbeqosjpgq7zumr4sh26hh861j60w3oqun5a4rj5q0', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('5vao0ea37m1fa16l5fs5sqp26byhqggigwuu5orx4e5ys1vqo0', 'Playlist 1', '2023-11-17 17:00:08.000','sv1aoe191pgq7qb');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nzp0ucrd8yi8mrt41xyv9elpbikemqz1yuzprdvfyylr6h9ony', '5vao0ea37m1fa16l5fs5sqp26byhqggigwuu5orx4e5ys1vqo0', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('i79ddcue2c2y5n8ymymvsbakqvrzzzsncrgtnz1n771pwtcccu', '5vao0ea37m1fa16l5fs5sqp26byhqggigwuu5orx4e5ys1vqo0', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ye713mjerovsukabuw8ipv3erkec5ul545hafjjo6kp02ucua4', '5vao0ea37m1fa16l5fs5sqp26byhqggigwuu5orx4e5ys1vqo0', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vgmx4562lpjye6a9vd4q33nmyaxh3tfu73hxnrm9gn18860xw6', '5vao0ea37m1fa16l5fs5sqp26byhqggigwuu5orx4e5ys1vqo0', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ffm51iomgieti8mxckj7vw76wxdzej3dxviszdc63k43fhvf54', '5vao0ea37m1fa16l5fs5sqp26byhqggigwuu5orx4e5ys1vqo0', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e9a00ilsrdzrnaqc1q7q9t1fcskti9sbsfc4wv0bgbi20p3jgs', '5vao0ea37m1fa16l5fs5sqp26byhqggigwuu5orx4e5ys1vqo0', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('v17n507uac3c6m8a4w9jqsi70hzddwwctgxegmaweq5pbzny2v', '5vao0ea37m1fa16l5fs5sqp26byhqggigwuu5orx4e5ys1vqo0', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ktictbwtdfaztzfkbofvecdz49wggfl0sg4ds21v4pds0afhhr', '5vao0ea37m1fa16l5fs5sqp26byhqggigwuu5orx4e5ys1vqo0', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('f260r64mmp8x5yz6yszruz63jky8gqbs8rf11wv8lzi5cljjr6', '5vao0ea37m1fa16l5fs5sqp26byhqggigwuu5orx4e5ys1vqo0', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('topk7datjytarwnl6pgxg6u3hab0qzlx78l9wnubo2x0lhwfj8', '5vao0ea37m1fa16l5fs5sqp26byhqggigwuu5orx4e5ys1vqo0', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('c2ggapmq7x6t2urfv9ohbd4aiiwp6aukd739nd8v5o4i5j1jwh', 'Playlist 0', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vexjg6i0tujmnff33onqx17yc6o4em6i3exugs7z39gxr44e3k', 'c2ggapmq7x6t2urfv9ohbd4aiiwp6aukd739nd8v5o4i5j1jwh', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7jss8ilxg4r9lemzzqq56pyex52xywf14sjqoagz78wizfvltu', 'c2ggapmq7x6t2urfv9ohbd4aiiwp6aukd739nd8v5o4i5j1jwh', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('36wmbi23vaow81cjg565h2strh0zluuq9xu49savz36jaybfxp', 'c2ggapmq7x6t2urfv9ohbd4aiiwp6aukd739nd8v5o4i5j1jwh', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bdad3ljei4exvfkho4u85sjaena07o0alsps003dojauv2o64y', 'c2ggapmq7x6t2urfv9ohbd4aiiwp6aukd739nd8v5o4i5j1jwh', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3l06q0nwd7ycbv0vpsle571bkg2ljkl6zvakf7u99rq72bz04w', 'c2ggapmq7x6t2urfv9ohbd4aiiwp6aukd739nd8v5o4i5j1jwh', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ldegz9otfypfx0bp9jbzfmo1q6jjo4m33dzrqxj04xr7gowmzu', 'c2ggapmq7x6t2urfv9ohbd4aiiwp6aukd739nd8v5o4i5j1jwh', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3m0qin3gdcbkqho8dw2dvnnn47cbe5rfbfz6y5le6nu1k5g4nt', 'c2ggapmq7x6t2urfv9ohbd4aiiwp6aukd739nd8v5o4i5j1jwh', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('topk7datjytarwnl6pgxg6u3hab0qzlx78l9wnubo2x0lhwfj8', 'c2ggapmq7x6t2urfv9ohbd4aiiwp6aukd739nd8v5o4i5j1jwh', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4cfvsxdjfvg7birovp544uwk7i0tgx7a7ogr0j8kwhqd4odlcr', 'c2ggapmq7x6t2urfv9ohbd4aiiwp6aukd739nd8v5o4i5j1jwh', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t0f24m3noercyiv49no6ivbdfand8t9s5ikjaihrgtam8zu7nd', 'c2ggapmq7x6t2urfv9ohbd4aiiwp6aukd739nd8v5o4i5j1jwh', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('oq7oinzhesx3f54vkpcdexd6y1q1ysa1d2t79wpq4pj1ygxt6v', 'Playlist 1', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8csg61d7itqo996nf5p8pfeep2rrld6rw7hbwnps8rlu4k1kkq', 'oq7oinzhesx3f54vkpcdexd6y1q1ysa1d2t79wpq4pj1ygxt6v', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yazyobq2qxi7o6rqbc2lwn56qmdjox9h0jcn7rl9wvleidaucq', 'oq7oinzhesx3f54vkpcdexd6y1q1ysa1d2t79wpq4pj1ygxt6v', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7acijj2icd3xbal180bzmxb8hzemd74wkn2qd0nz7f44iq94ln', 'oq7oinzhesx3f54vkpcdexd6y1q1ysa1d2t79wpq4pj1ygxt6v', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('by2g4vi12191csxyd6w25qjhbdk5ncvu3wdh1yswloc5doltzk', 'oq7oinzhesx3f54vkpcdexd6y1q1ysa1d2t79wpq4pj1ygxt6v', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('beanji0m6rxpw8vubu61oyr0si4fuu6gr1lixt0fxytax6mlw2', 'oq7oinzhesx3f54vkpcdexd6y1q1ysa1d2t79wpq4pj1ygxt6v', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('q7walm29a9esfqm8xg8exw8iupvh52gttwgyf15fjgj0n9hjky', 'oq7oinzhesx3f54vkpcdexd6y1q1ysa1d2t79wpq4pj1ygxt6v', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ldegz9otfypfx0bp9jbzfmo1q6jjo4m33dzrqxj04xr7gowmzu', 'oq7oinzhesx3f54vkpcdexd6y1q1ysa1d2t79wpq4pj1ygxt6v', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5wsvta4ehxdzeh1nipm18hjzacfa9x25s5c42372uvligzeii2', 'oq7oinzhesx3f54vkpcdexd6y1q1ysa1d2t79wpq4pj1ygxt6v', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6lafcij9bza8phdap90ny0p54d8531gzbsu6wor8ybphvsch1q', 'oq7oinzhesx3f54vkpcdexd6y1q1ysa1d2t79wpq4pj1ygxt6v', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ms2v5jdeybyfqilihst9i3q3r2c2t4chw9drkvu6uzglwd249y', 'oq7oinzhesx3f54vkpcdexd6y1q1ysa1d2t79wpq4pj1ygxt6v', 5);
-- User Likes
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', '0h013kyict2ti4sk41r1y39fxn933o4sobl910h42tflqn3do0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', 'sihb67i3rnqeh0knp2i8vx0wa13mw2qekj3bj0fp8xlr24atfv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', 'litxgo6zaie59cy27azfg9w93bf6wwztjvss7jnx7olkf7wwf2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', '88s0ppb9z242iag9v6t3odskgutg141tq4c3ntrcnbjmmm5b2a');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', '47h5rbzlplunhnlh3g2wjgc5uw1r4x1dxjeq3qea9dzf595gzr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', 'zit5dg0ul9f6psbhj40j77twa655su35nc00uhwrgjqg49psvl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', '6i4d4z6al3f6iphta1x9lvbsbkr6zymb7uq6ejnd408m74x296');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', 'wce32o6vvl29dzlhjnqt32kvzt7ln3qn8e6gbxofwrplmpxm8h');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', 'o928s2ha1r53941ul38n5zjotqlzbylgivenm2jc2h4ksi8fiw');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', 'h1cv8km2p6vc2ori4wkmuugnuxmp2lwl6r6iqwqt38zlzexzsm');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', '8csg61d7itqo996nf5p8pfeep2rrld6rw7hbwnps8rlu4k1kkq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', 'i79ddcue2c2y5n8ymymvsbakqvrzzzsncrgtnz1n771pwtcccu');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', 'j3u2bu12u7kt5yhf5cq15xb78pytwxf4m1yh03oyssym60xchx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', 'hru0ffbo7295mbrzzorktyrzzzrg6z3sx7n84iwayri2hkk849');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fygaat19wgbv908', 'bfmgl3hxb7wwmoecydevruwhzqvw4jdvb7uxdn6bzq7npz9pb3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', 'zgxxk90kpqfhitangv6vbalfejqr9i5v68snrq7kp8gu9l3vmq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', 'zs2o3gf8ryxhkk48xk9ebcf22su9nhhpzouq7t9lhpj7t8d7y8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', 's3r7y82ch0ovvxvriqno1dj1sdnm8hrqhddutt9yg8mpnsckg4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', 'vpc8ktyzazoln9tb6udhak3fgxlogkhajg6l2ljmicc7kfhz0h');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', '0xcsmcxe5mepqsezrytgkjef4k6or4ggcols0h3164xerigxcs');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', 'vxg2lq20jmjxgwl1feiv63hzx4qhv1yxavnzx0k6i1d7qmmqac');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', 'gkzd5xzvdasu0fb368piyctfmkfy17pobekr79jfib281i9l46');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', 'ws5bpm6zbbipwo0l9nv3paypv75nyl0kqlwtl9wqp0cn2m8e4r');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', '65p36432fiwizot6ayzou8eik0zvgen9pai10sotn37aptpolz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', 'tvugscmqf5j9hlc7f1c0wsxwe7hrzz8ehpntkm6r2vy3ge0rc2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', '7j5wz8lftyj9e8h82c3eu8pob68tjpgboogm7b8yqx8m3cbyfm');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', '3l06q0nwd7ycbv0vpsle571bkg2ljkl6zvakf7u99rq72bz04w');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', 'd4vpey68mupdj2fsefknc0kzc5ivfm7oe4xoq0uyqhobibd474');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', 'gdf3hh31de1zrn4e23c40p2zlje7d2a0lujkwv4q19sw8gexrv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3nlidq313d8ztl0', 'r6g1a1i8dod2wloxmkpy6301f4sfmtnxr35ryrnd79gmsv5ca5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', 'tteq8j2c3b00hlqs02sz0t4ntnjx6pfrk20s15nsxcohsitckx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', 'gqg8z3rj05tyasu5uwksvgxi3w24pmrwlkjthplmbw63qlzq2h');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', 'hs5hz3cc58c5w7czoo2nwbs8ydas3oebdx7ws4zf3eljrw0gtx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', 'ktictbwtdfaztzfkbofvecdz49wggfl0sg4ds21v4pds0afhhr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', 'uw3n05g3bhtxpozo6e37vt8q6n45okfoohoaf8pzcnaz6b4twq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', 'd8dp8ktvjxvnaz5cpleihqp2w2hfnaulfqiz7xw16ksywt2x6k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', '6i4d4z6al3f6iphta1x9lvbsbkr6zymb7uq6ejnd408m74x296');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', 'f260r64mmp8x5yz6yszruz63jky8gqbs8rf11wv8lzi5cljjr6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', 'zgypty2k2irhfnzpuloypdn2w512ebi98rouzyeqwugpyv17gl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', 'uzjaxfbck3uwwok1slvi01plthxq5momkz4qvdk8nme52goknl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', 'n8qr7hs3km9m49bfcujyueh9zhbn6bgfcx0ofqn1cvfmmfiij9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', '5osna3suv1nmv9ovl3m7q1xs3i0xihqsj5qixsqm5uvl9p1c7u');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', 'oiyaeknpmtezctp6jq362254ygmzz38x2j1eu6zd1pbkw7r514');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', 'fuhyv0le8hox4wwzci6afv4kem5m3nh2btkbfrslnboqzc4m7z');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('hvnibsldmuyqlj6', 'xlwzsbho0czql67hfiywmzrxbqnr31nfheupkcgl8ic4422qoc');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', 'ggtvj87g61tfkj4ztvdznjbc9wjtxnd7lco67j8cxxe4pfqncj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', 'krp1ew85nc8p8jhbykal3zel015x1klxib3jkkjlpi77kq3p75');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', 'ojsilu0e86il19xkdexw79cmczhhcl300vr3vdjhr23ww6oy6q');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', 'vgmx4562lpjye6a9vd4q33nmyaxh3tfu73hxnrm9gn18860xw6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', '6wyyr4ojj2aqetjbjirszyc53yt2wt5wmf70pcnef99yeons1q');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', 'i3vvr7biw6j3n1yl7scfm81s17333r17pxadwmedybh6oli8im');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', 'i9z7biae53l9rsl1an7z4988a12a4vmhvsd424abac2mwef2hs');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', 'a1g36yl3xnfrocpj16s1c52w6ku3je39yly8xtz37oej11clw0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', 'ahj68rwqxfzx3i72n1tyv5o0go1oc9w3ak28o953alj50f2a3i');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', 'j0tfq5lbeykifimgv7sksytwql3mzgtrgu4w1q9qlgh8yfec4g');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', '9rigt32jbk59blrd48qmrfto1qqovk1i2jicciqkcwbcjmmrta');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', 'c87iufqa199zusuhb9oc8zi8yhy2ojq58fxufvuiepu71gw078');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', '855qe8tasrb9rdtpuw4pwqfl5vrmfpwxqsuihs9kd5b01h8l7n');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', 'vsurr2f4m4cxnsbjsmori4ztavht74suue254a200eetvl7kop');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('s6a76i6dmvpw3q3', 'p5xyngzw6qjsoho93mlidh0jo8f3qdied2w8obovmb0cvc1dgz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', 'pzi6rvp6hvr7vdyf1xk3xrhbm29mmg2qv9495iba92821fa2i9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', '1xdyv2j5g6054jz5w3jdc3ycutdnu4tf3cpksyoyoi2wgogxp1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', 'lkrib2s3zvav7di1o4v0wkbp8m8j6k3whnv9jzjhi3ecl54c8p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', 'lmv5y7b8gdfvhtaqbqsupi2ksbzpccu9kpmv5xsz7bewjxetth');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', 'vy6ez97bi1lr098ca4x3s5lvbbm2tzwg39mn2xqnkajgygs9mf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', 'tteq8j2c3b00hlqs02sz0t4ntnjx6pfrk20s15nsxcohsitckx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', 'owzex26u8ary2s5mkjux3gvdsv0ny9z5x7atrxna8jqw1lmsts');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', 'vgmx4562lpjye6a9vd4q33nmyaxh3tfu73hxnrm9gn18860xw6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', 'op8hpfrx8h5ffojgi0qm14tqwnxgt9rikhlrgfnwa3il7soekq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', 'zy8ce5rsm6scbg17j84eghyyj1e4l41bxp5cegxhzq4juvnaqb');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', 'a1g36yl3xnfrocpj16s1c52w6ku3je39yly8xtz37oej11clw0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', '3gpalk4heac6lgrq6jz32x33iynmn5q3ktmbejy0gsdw64a5p5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', 'zmadm6h8yh8u6xbnxdhsbksmfgkn272nlawwjhvba1org6bcvc');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', 'ffm51iomgieti8mxckj7vw76wxdzej3dxviszdc63k43fhvf54');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('suk3j8xg44nshl9', 'y2c327fbdl55b4qs6utrz6sah5av10q9ayqfcwtdk44rqonk1z');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', 'tgtsn5j4kk99nsxset49vrixdy4x6hdjjczbstgabgkuw9kx42');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', '07y00l0ajcdm793ibr2kz27aspyzd1ftfm0v0v6d4en5yke41b');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', 'x4doop38fm3g6rti54emb68jocypzowbjhfpc8cwgvdoyiejo9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', '5ct4jyp7sep8df4s881hu4e69cbq0u6ol4zbewxfice2r3ufo2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', 'llducbibr6r2lwdbm8m6ai268cf6xz1faorn8zbhu7l3v8zu83');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', 'whioktsx1m59ti7xc3vreqogdlt5fuj12bo5w6l09xpovg4nhh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', 'yjntgxrzfvzw9pip46vj0w71y3ynqrymcy881ax0sbots457m6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', 'p9ilfw9g8j5mh1tp0n6zz2z9hhxeit8sel1al2eobczvuntu4y');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', 'qu77g8sg72jlftl86px5s2hj9eganz4kypkhdanot3d0ql56mv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', 'r5ghhi36pxvh5l7rnn4fmunta57gmxkb1t6wdeph5oprc99wt9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', 'lon1oe73xd2s6rz8xu77lqaaqhhxhe3nlnyaulqpqyu3xma0py');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', 'nssigwmg9bptj3p0ax7sd17o8zggeoaxic8x5qxasgpwt2vvdw');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', '90n4baretyob741userugi5ijpim6zadh3jisusbs5p2xwfmbk');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', 'beanji0m6rxpw8vubu61oyr0si4fuu6gr1lixt0fxytax6mlw2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('aeayzzdcsr3z8np', 'ivr3bpzexg3mtsqbrrpetpr4rqjmnpp8htcixn9wsgejw0yfdm');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', 'ggtvj87g61tfkj4ztvdznjbc9wjtxnd7lco67j8cxxe4pfqncj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', 'kzl3lb0h9uh7gen2jejsmm1pxtmdibjk31bk2bkm4seyox598z');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', 'huxkabojq5znmky5modn2qg94py4x97bhk15sz990nqsj37fm6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', '7jss8ilxg4r9lemzzqq56pyex52xywf14sjqoagz78wizfvltu');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', 'ws5bpm6zbbipwo0l9nv3paypv75nyl0kqlwtl9wqp0cn2m8e4r');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', 'gpik5z6a3q3m1b1l7kzg2ye7lzcesvc5y1woprb9d0tezdcqpz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', 'sfw8qfy5ef3ku8fvzbanv80zcg5lpjbz54f4zkka34el72kjyi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', 'tzgmn5fh9iqkyfmmt7ikt8f994zileqpk2hwpx9p6socab0mci');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', '0tj44su08h1imb0swbcttesvh8r0oc1kw6siwyi97yyrj2ezj1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', 'z8tfb22mgykmkrkxn5v6au6lc3is0wapl834r1rqrv4xipryuj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', '5uxb6dtx500wj6bfuws6j4217xbfiwd8ajjvd4a2j3zyz3slfh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', 'vmnrhdt7tgwormmbono3h1ajew5vis4nhlvcv4kwev8m04epkf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', 'izzqcf97t25cufa4xkk5495exubl58rnggd6z2asn5utblt7ui');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', 'vy6ez97bi1lr098ca4x3s5lvbbm2tzwg39mn2xqnkajgygs9mf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('vlqxtgrgwwiu3lj', '98ye7m1yu62jos2hxtxm6eufkncgcqeo6go9kyifcznmrhxu2w');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', '8csg61d7itqo996nf5p8pfeep2rrld6rw7hbwnps8rlu4k1kkq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', 'ny518qjfytd6ufjm7gki8nouhb2zu9dh1ptcvt8poz83vr3rb9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', '1285pzodpgdp1tgjakoidhtjkgwy806akxx145yw5hfecethkx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', 'llducbibr6r2lwdbm8m6ai268cf6xz1faorn8zbhu7l3v8zu83');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', 'h1zwfnbsp25ui9c6up8xze8k0qeon54bzi2654supsnx7lhmxe');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', '6yemw7wxyw5xq56h8r6qo98q5dsie9qvr42f5r3fpbaxp3nt1r');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', 'i79ddcue2c2y5n8ymymvsbakqvrzzzsncrgtnz1n771pwtcccu');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', '3gpalk4heac6lgrq6jz32x33iynmn5q3ktmbejy0gsdw64a5p5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', 'ohwkoi7e46c6kig4zwctlw6d8lqw27g4e7jahr7c2kf70ye34p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', 'g48ca5xztv02bfxd2tr53r6wb27w2okropepdz063ysxzlo5xc');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', 'znolzhmg737k9i59sig5qozixlmqvg8udyzq7phimry6abu9bx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', 'vgmx4562lpjye6a9vd4q33nmyaxh3tfu73hxnrm9gn18860xw6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', 'cijp7d16q92cetmqzsa0ytppemyxmq63lb4jkwkjk4t2dtkskk');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', '6e6ul3z4rzeudz6gmhtezerouxpch47r56gi5pgpeexy8ukmoi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('45p9mm3xyx6hp2h', '47h5rbzlplunhnlh3g2wjgc5uw1r4x1dxjeq3qea9dzf595gzr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', '855qe8tasrb9rdtpuw4pwqfl5vrmfpwxqsuihs9kd5b01h8l7n');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', 's9qgzydn1e9mb1ctr9s7vl75qxupajqqivpgp4yzu043k4fui4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', 'uw3n05g3bhtxpozo6e37vt8q6n45okfoohoaf8pzcnaz6b4twq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', 'hs5hz3cc58c5w7czoo2nwbs8ydas3oebdx7ws4zf3eljrw0gtx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', 'uahkhdbv2t9cgj0gb1361z54epbcwm96b8dt0nqufjgr5r8dea');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', 'bc2kp5edfvxaqvw9yosjag4f2zv72xv567jmawmtzozdgbqmij');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', 'lcqtyj80sm58ook174o53q1nkwkadh1qq9idc9q2l869xuark0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', 'f04txytbz2utmyixwd35hzs2u9om26wgj21krddw45jj0wgdce');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', 'jlbfp66xvacfd7du9rap3777oyxj8kap5evv6hzyvkcv7sivux');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', 'o0tkdkhveksg2d91eczvpvmnb0xaxar814px82pu5x2yar12vg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', 'lkrib2s3zvav7di1o4v0wkbp8m8j6k3whnv9jzjhi3ecl54c8p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', '60m438p4gz7blq0uffzjv6l0l6gu7gtkrnkw1cndkc2oqpnnb3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', 'vmnrhdt7tgwormmbono3h1ajew5vis4nhlvcv4kwev8m04epkf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', '0ar6hf705vkuyu6x5i537xckubw431cptytq9n4cvb2fjmmc6h');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('itterl5zs2amzb8', '07y00l0ajcdm793ibr2kz27aspyzd1ftfm0v0v6d4en5yke41b');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', 'lwblnj6xxf6cu7qpovn7r7bfm5w7ymtlghcnis67q4o83l7w0l');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', '3117mc4dfgsdowrpm1ob3cqwint6m1z8ajql9p07faka4n19w7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', '2n5jznjb67rw5xoyt1l8cl5k6y9tl8ivdk2np99icb5zatz1uy');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', 'mtcivz8wprfucr9zo7x7xe34awsnpc1wn4e0eo2gnk0qmyeaw5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', '8ca7epjzb7r1xhtqu3sjir3fsidklbaspe9tlh8sb05y375ixg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', 'jh7x84qcn1m1eawxcuyhw1sdwfrhy0kg8pig27c58r5waros9y');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', 'u08nomdbfyrr4czhjbl8mkvftvstscboo0y4vmw1e21zyf32zz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', 'by2g4vi12191csxyd6w25qjhbdk5ncvu3wdh1yswloc5doltzk');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', 'y2c327fbdl55b4qs6utrz6sah5av10q9ayqfcwtdk44rqonk1z');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', 'u9m60l9hlpwvub6k1sml43sflk93op0fvx35ghpp2avh4kg4bl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', 'arxzti8thqs3tpxahv7sbst7t7pkfcv84bqde2fq8zrduxnkjo');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', 'hm6ofst9zoertlpd66u7gdp0fioa1fa1xt7vqb26nqj21m8yoq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', 's0rgdpq4pqp1uw719tl7ncd9atawcy1cyq1vr7m9iv95xp54rf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', 'zgypty2k2irhfnzpuloypdn2w512ebi98rouzyeqwugpyv17gl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('sv1aoe191pgq7qb', 'kik0v1zm4gek1hhzluu06pvh2i0wk0hx944ipckntkbh56qk6n');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '8ujpgybipx8sw14vwdx97a7gbxhgnpwky2vj20a94i0veicruj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '12sk0xu2oaga7cp6gqcqlsuogmae98mm8a2gg6r650b43l9p32');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'ivr3bpzexg3mtsqbrrpetpr4rqjmnpp8htcixn9wsgejw0yfdm');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'lmv5y7b8gdfvhtaqbqsupi2ksbzpccu9kpmv5xsz7bewjxetth');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '02zgcfmpbip4c6tr36lwat05mh3cv6x074800inlb52p6x17jp');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'o928s2ha1r53941ul38n5zjotqlzbylgivenm2jc2h4ksi8fiw');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'owzex26u8ary2s5mkjux3gvdsv0ny9z5x7atrxna8jqw1lmsts');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'yg46a28tl8mbyo73ihlr9l67yf5dt22kej7d79mutqu86ephqr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '2h3c56l8yaxxg5zp7t18r4yfhow4bkhmm7yxlv5jpjttjykyq9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '7d9z4cgfk5kdmkeoyb9ons381zxa9ac9t6she78xx4rlhfgvqi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'w4tfw3vnxyykovdy4n07ture4nf5lccb2aq888fnzc6m06c08h');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'evezq0klzms8l2dgtvlg8kw5iqf2vz4d0dnnsb79dbvx5pez2k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'tvugscmqf5j9hlc7f1c0wsxwe7hrzz8ehpntkm6r2vy3ge0rc2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'p21vzqav6nvaicbowkk75kkem0sh61dxjaovph7gpg66g5toj3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'zrmku8alrpxqqxks22bhe9oxxbre7l5l0hw1566wqrq3th153m');
-- User Song Recommendations
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('s8otb3b3e0fq6oub4s3sn3mdn7dkm1f9r738nw5xav9xhuklvd', 'fygaat19wgbv908', 't0aw88l59ly4d3yybe011na72uq4anm2zffw0eas9lekhaeeo6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ltuckginifopqiqxj8sz8timbkmczthf295sdi4brcgcgrg2l3', 'fygaat19wgbv908', 'vmnrhdt7tgwormmbono3h1ajew5vis4nhlvcv4kwev8m04epkf', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('38xhu4oinh5zlbnfx00mopoxwcu2xzqps0qx3ijbt758v6obod', 'fygaat19wgbv908', 'uw3n05g3bhtxpozo6e37vt8q6n45okfoohoaf8pzcnaz6b4twq', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('yu6diidi0kykmcptnibnmvblevqzw6m6itkx6ecdsordwppo2i', 'fygaat19wgbv908', 'lmv5y7b8gdfvhtaqbqsupi2ksbzpccu9kpmv5xsz7bewjxetth', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ga1ponwwrvzzkcnki38y87ioukcauzp9ohbt9nntsodg3j8pvr', 'fygaat19wgbv908', 'zmadm6h8yh8u6xbnxdhsbksmfgkn272nlawwjhvba1org6bcvc', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('cypz6hdknpcsimm2bp18vmmg8odwid00l4d9azlpag1avxjg4u', 'fygaat19wgbv908', '1xdyv2j5g6054jz5w3jdc3ycutdnu4tf3cpksyoyoi2wgogxp1', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('prhk8g3o9holap0env1383qjatakwbsfnl7nxhg5bcqi5zt9hz', 'fygaat19wgbv908', '0h013kyict2ti4sk41r1y39fxn933o4sobl910h42tflqn3do0', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('n3knqie4iuwkn25ewtht0ra8rsrer1jy6g1pa51ycpyl5u7q1m', 'fygaat19wgbv908', 'd65xwfubtad1tlibnhqiw2urmbjxpucplr5xzdwvf7vz7fct1k', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('k98kapai9x6qfud22tcc0m7lbazn3tf2rdfzst2ko0u4qh8vud', '3nlidq313d8ztl0', 'g48ca5xztv02bfxd2tr53r6wb27w2okropepdz063ysxzlo5xc', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5qqmud8f9q99nh75ky1l7600t70mq3cemw9pqzjixuw7dm2vvp', '3nlidq313d8ztl0', '30bzkmq49b95cntn5k6em1fmonkjfi2rgq580bx1meoatnvjwh', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('vo5tvb1ou0u1g8r1cegkmmv2735gqtz44xbm05t7xru6yh55ok', '3nlidq313d8ztl0', 'uz0fbuvp6m8f9thhkth9uvawst0yyckk33rxk26xfqlxlgvnlf', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('y5rfrqy1muw77r7k49f0jdsexshqfrnb23y9a6j6jqmy6tx6j1', '3nlidq313d8ztl0', 'znolzhmg737k9i59sig5qozixlmqvg8udyzq7phimry6abu9bx', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('dzmc2379mh3pq05vutzu189ggdyo6mgnbqk1u9bh6es2se7y7w', '3nlidq313d8ztl0', 'ohwkoi7e46c6kig4zwctlw6d8lqw27g4e7jahr7c2kf70ye34p', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('1aeime6ycpzq0t24o5ruha6rk4tsks7nbfhctcepzt5goksjav', '3nlidq313d8ztl0', 'rhagt0m3kpmochx0kbgs6o3j6v8p1qhc0a5ng3cw8cfab0x15l', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('q16rd1i3zd44kf90vim5g93untd7vcdyld0u6bgp5oxcnez1wb', '3nlidq313d8ztl0', 'zmadm6h8yh8u6xbnxdhsbksmfgkn272nlawwjhvba1org6bcvc', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('k4l784n3e9e31t5ba1g49xfpsrqflhvny4hvpvmdqx8buz0ut2', '3nlidq313d8ztl0', 'gc5c3w4vyr7egba584qdyqepoa81bqlwcxpmni4z4030ierf67', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ojc3qu15i7g7g4cmjtisy4r6ilzsf86o7ysxu4vefqffm4ij7n', 'hvnibsldmuyqlj6', '1pf93vjriss1i3gozrnfh1ijph67udgux46g2gc94kxioxpkhg', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('fkysi9ex7xodaiqshlx6nb78t57cna5u51ntjb0dvp5m9etgiy', 'hvnibsldmuyqlj6', '36wmbi23vaow81cjg565h2strh0zluuq9xu49savz36jaybfxp', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('v9377owgs35ade0vafmou5d1puv4f1h0d5mvtlxl20grq30cm6', 'hvnibsldmuyqlj6', 'n6agiq4uvmtoffucq9j8ncufi7cxan7b9g917wc7060xf4okt7', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('nvwp1ndl9vawgu6zut13sso7wh5prtk98wfry5yfejjt75ks6a', 'hvnibsldmuyqlj6', 't0aw88l59ly4d3yybe011na72uq4anm2zffw0eas9lekhaeeo6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('vp8mecqv2rb5whup35pzd2pb10b76mi3gz7016nu3bwz6vefau', 'hvnibsldmuyqlj6', 'ky29rya6b9a0er0jrjaraay1tivrgxibb7mwqgmxlqws9ptt0g', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('zf32wdhgc5t2fwyq7qeml26eil28x99xw6ddov8obl7jwpf5bq', 'hvnibsldmuyqlj6', 'c7acc45xzt3g3qgnc2vlu3z1fe77dj7k434kr54ff9y0n9itu5', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('roo7dq14rltm2n4k90dffzlgcycunrei3sovrfz9unv0rx3y7y', 'hvnibsldmuyqlj6', 'uahkhdbv2t9cgj0gb1361z54epbcwm96b8dt0nqufjgr5r8dea', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('pfitmd1wbb7i2jmfgbz83ehgiihca3vhf4mr9k9oix1pntsidn', 'hvnibsldmuyqlj6', 'yg46a28tl8mbyo73ihlr9l67yf5dt22kej7d79mutqu86ephqr', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('u872md3ts337175qy2npms39yh4v4eb0asyyg0fnri3olbxvbg', 's6a76i6dmvpw3q3', '1t6epaatqnpu14p67z1l0wdb5dv71mymi9z9kk52dc1qyxl6ay', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ml9un1dxp6qmm9uyedl55exdyve9yskgel4akc5kpravirnr1d', 's6a76i6dmvpw3q3', '1urhdjkkcbjl7e91ef8o6q5pci05ey556ngeqtrmj6zto2hv6p', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ugcx482mbylg5vk76e2dbvk421kwsckshg59bpemfapcwsyab5', 's6a76i6dmvpw3q3', '0xcsmcxe5mepqsezrytgkjef4k6or4ggcols0h3164xerigxcs', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('sue9dr3tdpbls0tqhqzxd20va6vc6flfdvkhluz4egnaqlae8b', 's6a76i6dmvpw3q3', 'tvugscmqf5j9hlc7f1c0wsxwe7hrzz8ehpntkm6r2vy3ge0rc2', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('jsufv56jwblmolwbaeqqkg3vhxxgvqjb1vuv1791hujscxjl54', 's6a76i6dmvpw3q3', 'q03vwgl7dw151d0wvf17ujtbgri5ael8cljxltvfyfllcwmi49', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ebpn64gbkqdadvpg34sd9o0qruca9875whe5m1nzw9rgakbx3r', 's6a76i6dmvpw3q3', 'wxi955jbevgdwifninybygu4lyjfuuumuisswcv3nlwh3psu18', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ylspd8kz26p1hcjeqi26pbtw80hr4im1qi6a0r49czkynm75og', 's6a76i6dmvpw3q3', 'arxzti8thqs3tpxahv7sbst7t7pkfcv84bqde2fq8zrduxnkjo', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('6zcbrkfx9enc14shzksur1jq8myzyd2yjg3fguhczz6152k95m', 's6a76i6dmvpw3q3', '87lltchad3gbdc7zbikabajf6xv2ar6r34kn2bd5qotq61mio7', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('t4yy1v05r9661lwh8wtyr8af9zy0mkrlrcnvp4jgual4jm22q9', 'suk3j8xg44nshl9', 'kwid3qqfnfbcq1npa4w9muyd194nabricybzgu38alzwhuhv93', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('n2b7wqjt5p4zjpap4jydjyhfly7t0ugdik9pe0ri444hfddwlx', 'suk3j8xg44nshl9', 'yoou84h8w0qkqxhnjcadjepm8e2t4rjm2zhuaqcfi407la4tpb', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ffjlybaxrxwlpahbhydu3e6mnu9w9rtoq0ipx7wpflongth86u', 'suk3j8xg44nshl9', 'p9ilfw9g8j5mh1tp0n6zz2z9hhxeit8sel1al2eobczvuntu4y', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('f4p6k6s6aqowd6o120nwfpgzitxu3z2uldixmx8osigtqsujkt', 'suk3j8xg44nshl9', 'zpqqy1pzs7cd4ayncwuqg2ffm7z8wzdb8azu15xkuyenq55v5e', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('yjd49boh6dd1hn54z58q59p0fj94prohvlw5lzfhb1pfpe3mnb', 'suk3j8xg44nshl9', 'p6buvr0al4bhahx6oi88qrk2aeusf8ep3wrc4hcc504kpiw070', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('30zh90r5kz3xt5il0o3k14osfgjd4rav1xoi38eds2rx70eby2', 'suk3j8xg44nshl9', 'gpik5z6a3q3m1b1l7kzg2ye7lzcesvc5y1woprb9d0tezdcqpz', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ao3tj53b1yruwqw0h1oze1kp0ep6teglk87av26d06w8na41pb', 'suk3j8xg44nshl9', 'bj63rlwnro1ut2uh6m2yk2wkj9hbd8h7p5ipagjox4bsqpdord', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('g8ouv7of8ikkrkqz7rneqdqv4d0uy27j40lqf1n4tj5v4jgpmn', 'suk3j8xg44nshl9', 'mzm2v92e5p3mth3qhnv60jjabjdonvaz0xq6p8m8l9zbysfceg', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0c6m6cgiu366blhs9kwbr5o6qzpsrho96qwxu4nd1vvr23vax3', 'aeayzzdcsr3z8np', 'ws5bpm6zbbipwo0l9nv3paypv75nyl0kqlwtl9wqp0cn2m8e4r', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('tg9bs7a5eli4ikz33oz7219feig9u8oa694ook3j22tgfws2bb', 'aeayzzdcsr3z8np', 'gfu5jczvdkunftb50n3ieo775jos7a7e757bpu3n6u5s8hwp14', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('nxjo638hbrz3s60vcahn6jv5h8v0e8byuytkv27neksvcyjrpw', 'aeayzzdcsr3z8np', 'o157laauq98fsuuk13wkiclsdgrgp4n0go015az3uy65cgq32p', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0kvb57a915mdl7ai5tpix77ake2vcclgbswzfxgltx52uhhzj7', 'aeayzzdcsr3z8np', 'kzl3lb0h9uh7gen2jejsmm1pxtmdibjk31bk2bkm4seyox598z', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('y2rgrvfj71gslwxgbe8ns1tjlgu2nsx2blypzeragb56rmhas5', 'aeayzzdcsr3z8np', 'lmv5y7b8gdfvhtaqbqsupi2ksbzpccu9kpmv5xsz7bewjxetth', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('k72jifb2tr55bq817hg347le089uobgq5ytk1tpy7w2echdkb9', 'aeayzzdcsr3z8np', 'sovilkvnxud7f5cmhrzk3nqs8z9zee8q2t0pybrsm9boten17e', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('sxln8z8pvzrj2zkj7jmgmxixbd4ptueacfrkacg7pcgk8fd84c', 'aeayzzdcsr3z8np', 'nwy1gwsrxauuwj6lsw9ef7xjfq2iljkeyonz47q4fa706f9vy4', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('f71pnr9f14kp1ea2154zczwsbzx7lv8dsebkkff41xzq8bc6vo', 'aeayzzdcsr3z8np', 'uxtvwup0wxgq3w741fwq3dj8rhhrw8fu1pzidc8lg8p7mlskve', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('w4bpb5q4o892c4xgafackpif084ay4u0m80oyjcdxbjxyz4br6', 'vlqxtgrgwwiu3lj', 'syvi6ztfyqfsomqfoq7foshwa4kxqjp4f9jp516m2cq7tob81a', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('mn0m12ijgczb785bcod8xgukf5gmiwvjrtw76i9afl2cec4z8b', 'vlqxtgrgwwiu3lj', 'xhyfvcbypjmo0gu107yasy8e7nypn1gukfw7fnb53kzywp0c8z', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ku09q8ds3ob8magi0szub4p44kp7oi6b8c5h23uld3cupeypkw', 'vlqxtgrgwwiu3lj', 'ldegz9otfypfx0bp9jbzfmo1q6jjo4m33dzrqxj04xr7gowmzu', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8yz6ef4kbnrxqar6pugfdi37y7sn24atjq6y2n1u8dn229zb1v', 'vlqxtgrgwwiu3lj', 'xcgo15poz8xlvgavukcr73g9tukzzxe6hbea0plexyn4v598yl', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('via7k0wc75z56o0yku5ehy46uncdkk67778t316qlkha8kklhn', 'vlqxtgrgwwiu3lj', '2h3c56l8yaxxg5zp7t18r4yfhow4bkhmm7yxlv5jpjttjykyq9', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('juxqjnmfbscn0b68y2ynqr0jq3fo2aael26ws9jspnadx9632i', 'vlqxtgrgwwiu3lj', '7i6ftzooiclja2cn0focim7egv62rfd2jpib3betbv7v45mz1j', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('efu4t2aktvluskjfm7ovsn2sltqvqrrturbgpuad2qt8inuvpl', 'vlqxtgrgwwiu3lj', 'kb04imr7f5hhyeyudh6ei1lazhbq937u92kjl8dgowiw319c0l', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('7yl1owy2rgfqy1elnuk0q0u3stikxqls04okgs378hwrja11vp', 'vlqxtgrgwwiu3lj', '0vp5f8pz1x2137yuwhaloyitpua6ocbtr20dznrucvffui2rat', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('50ekbre0ifr939s88loxs438li09zsp7lp2zbcwl4y72v9is6j', '45p9mm3xyx6hp2h', '7shs0hyqa9s22nnk67m6yii03ezvt8w5wjhgzjgw99ya0dv8c3', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('w40wnftvjaa9dgtm5911yjnxq10qitv2v90a1rrpb7ud7p6ozz', '45p9mm3xyx6hp2h', '1ph5nykbaewhttzojtpxvilkzcru34x3ncohpursy950u4tt1y', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('xqhyq51fcpqudd4plifjetzqxuy2sfj7ewdodqnvei7oc7hf4r', '45p9mm3xyx6hp2h', 'n5os43nzcy0oc26831fxznlr81uy1y80j8kyl3e3ifw2536m09', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('lcry9r1h6omzgr7vvq6u41k4pdzuvqlkttkwqzacmhi5c44igw', '45p9mm3xyx6hp2h', 'vexjg6i0tujmnff33onqx17yc6o4em6i3exugs7z39gxr44e3k', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('11oqq6r0br0zqy98245l8p8l69coqr0dkgx6k32kk139ecofpn', '45p9mm3xyx6hp2h', 'w4tfw3vnxyykovdy4n07ture4nf5lccb2aq888fnzc6m06c08h', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('56lnjv5t5cpawavfmzsijsi8p7tzbsieujjur67265m4nuy254', '45p9mm3xyx6hp2h', '58q2plwi0w717iqjct0fggffe8pell2yf7gwoce883e5arayee', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('q4y685fkxbq22fharw34s51cpb343fwviz6sh2x58kw1lv212r', '45p9mm3xyx6hp2h', '02fbmvabcikagbb0uqte3cod3dxen73fd93jo5il9xkifw1x87', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('gxrfypu78kji3xcnghlzzx4m03i85mgt60rshci4gsals0ee66', '45p9mm3xyx6hp2h', 'rpj4pj9vrt95w7j8wub2ow0wrw5gn80g57q3g2e7uvkjwv9azs', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('y3dda2mm4vjtfstkqxfpckcdzee19lnne4zjkslhugdatyt6yr', 'itterl5zs2amzb8', 'fpfir1jobru2ah0d9fik4toq9witifssftqtntvbnm84gyexpn', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('qyfioeko3q8mxncovp837gf7onulawm5bt303le443eo62wwdi', 'itterl5zs2amzb8', '5vd125yh0ahdvdvb2nlwh1qmu0mej3iw2fwog0bvxl1uuo7td8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('lp1jp5z7xkgvitt2ce4w6ae8vhoiscdirp09guc2njrfff59rd', 'itterl5zs2amzb8', 'kik0v1zm4gek1hhzluu06pvh2i0wk0hx944ipckntkbh56qk6n', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('zuldmyb77zhmm99vjeo28ubx3894isz3hq3cfigxj8d9t73q5a', 'itterl5zs2amzb8', 'xlwzsbho0czql67hfiywmzrxbqnr31nfheupkcgl8ic4422qoc', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('o9jlegwrphl007qilefznrxr0r9ron82plo39l7cllofx6ddnl', 'itterl5zs2amzb8', '6yemw7wxyw5xq56h8r6qo98q5dsie9qvr42f5r3fpbaxp3nt1r', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('sf15d053k187jnz23703oml46c27ciu2i08rxz0h21lrs563t6', 'itterl5zs2amzb8', 'ffm51iomgieti8mxckj7vw76wxdzej3dxviszdc63k43fhvf54', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('y47y8pq2nco8eh0smqvod32hio5ywcxhm8ziwfelte13duaozu', 'itterl5zs2amzb8', 'bw9g8t6vlictka21wrt70g8vfy3yr3n46y3yw8d7ly6pat0kjy', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('jtkdt49nbi15u3jwljjgu0j4vo2vmz121rsdx650onifefehvm', 'itterl5zs2amzb8', 'd69cy052iz9c4swkane8ymd6jyw5xpqfcd9a8ez60w498it6ah', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('mpyxrj71i6srs6ufdwmkbvl8u35bletd3h15e0sj71jcoaarki', 'sv1aoe191pgq7qb', 'p6buvr0al4bhahx6oi88qrk2aeusf8ep3wrc4hcc504kpiw070', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wv13j063mz287kjrop1asimj104ivo6yoykvct4vqdy6cp7qds', 'sv1aoe191pgq7qb', '6dalr30uz2swmqqt9ye2f5n2lgmjidz6rjup96bu80ua7y3gyo', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('n0j11jdzt1qf4mbjj81v906s7cq14vv5cf6gv1g05rpscekrx1', 'sv1aoe191pgq7qb', 'ma3wpnd5eko5js51uiyocn3p26eyb0ywgxhc6984mcjlt6nmpp', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0ltt1rnr5vkwpfvq3f0ecdz71fsukhwe52kc33c98zvofyygjw', 'sv1aoe191pgq7qb', 'p66dfrzmte86iyyjzd65297jcqp9flab32zckfzaamv3eebrcm', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('hmz90rz3x93wz162yfdra51alhiype8fjt8hjcgg43jeab6osl', 'sv1aoe191pgq7qb', '0ar6hf705vkuyu6x5i537xckubw431cptytq9n4cvb2fjmmc6h', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('giaya9hkaeupf0oz4d0n94o8jl7ukivf25n2twkq3rqckpegdd', 'sv1aoe191pgq7qb', 'gfu5jczvdkunftb50n3ieo775jos7a7e757bpu3n6u5s8hwp14', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0q4c6p7n8gyscbqs691ol0pxwtegvxttw5k5jedtoomvfg1tj6', 'sv1aoe191pgq7qb', 'g7fxd9yi0v4n550o224rml7i59edf5a1nj639ua9yfgx9r6n6b', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('lir4pfygwhpgdy2mhcwss9qi9k0tdsf5zqk5d2h4nmrxdj4jc9', 'sv1aoe191pgq7qb', '5i0i3o98tut9lrkro77isnosxpwqltfzyyinb0axt21nfghhpu', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('t2a0pciavpjwdgoiuecjpwo83fokx29s9ff7etsyi6vovldftg', 'icqlt67n2fd7p34', 'pshcufoapzlt4fua6s4wzclmkke5jblax3xxseeyh1mnbyunug', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5qu5t8a4lt9e2acmxyrfosmjuamakcm65ic1ktr0pgwtpb3rtd', 'icqlt67n2fd7p34', 'gc5c3w4vyr7egba584qdyqepoa81bqlwcxpmni4z4030ierf67', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('twbx1to5ocfv48t2gm0vjlq57kmhpmvxaxzwuls24wn2rduvem', 'icqlt67n2fd7p34', 'm3wezlwozuogq9i6sub1ex1oe6ka1r7ppmrfw3sre4jd2k7ff7', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('fvyu7b14v20qd1d9g13tml6qhsy4byljdbqqsk25d8k3x9k095', 'icqlt67n2fd7p34', 'i79ddcue2c2y5n8ymymvsbakqvrzzzsncrgtnz1n771pwtcccu', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wfoludx5r8iw45bxx33j1mrodvh1s1eeutuf6h8lznq89i7bl3', 'icqlt67n2fd7p34', 'hfc4qmg38wtyol9c3uyvh6mvxqyqccqzyn5llswgvmh8ubq3mx', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('7bhfp5aa6vcu04dx67jmqpa5b2zxb63v59rzl7yxzmbqc5dz4p', 'icqlt67n2fd7p34', 'z4m3f9onl0w1efd6ywv02vb1x2esh0co7iykalepnw3z93i1z6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('qlaw0cvkyypjuc55p1br17w41fncir9ayd7cm0tmfe7258urru', 'icqlt67n2fd7p34', 'hboisaccg0lsjfa4689eha353jt67jnn9plcxoa7wufkxyue27', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ll0imh942858judivf1262syrhtvczr6wryk3antxt2zhdml7k', 'icqlt67n2fd7p34', 'ffqmak6adc775wm3po5hmanik3x1a8f15yuhwzxpacw2rcuuo7', '2023-11-17 17:00:08.000');


