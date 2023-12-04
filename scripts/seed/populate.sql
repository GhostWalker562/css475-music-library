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
-- ENHYPEN
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('no44ewxppf06te8', 'ENHYPEN', '0@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a48a236a01fa62db8c7a6f6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:0@artist.com', 'no44ewxppf06te8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('no44ewxppf06te8', 'Crafting soundscapes that transport listeners to another world.', 'ENHYPEN');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mylo349jbxewnxgsp6sz87329e7wgdril59j540t8z7tr2rczc','no44ewxppf06te8', 'https://i.scdn.co/image/ab67616d0000b2731d03b5e88cee6870778a4d27', 'ENHYPEN Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ptv9crgffyaev9siuh4ikgkcho7a0v4sfv3fakrityasc5p12r','Bite Me','no44ewxppf06te8','POP','7mpdNiaQvygj2rHoxkzMfa','https://p.scdn.co/mp3-preview/ff4e3c3d8464e572759ba2169332743c2889d97e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mylo349jbxewnxgsp6sz87329e7wgdril59j540t8z7tr2rczc', 'ptv9crgffyaev9siuh4ikgkcho7a0v4sfv3fakrityasc5p12r', '0');
-- Becky G
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h6kkdmth50y0yft', 'Becky G', '1@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd132bf0d4a9203404cd66f79','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:1@artist.com', 'h6kkdmth50y0yft', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h6kkdmth50y0yft', 'Harnessing the power of melody to tell compelling stories.', 'Becky G');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fjsprscs8dqo03l49q7e3vpwtwitzmewhta4cblg0yt22o39w8','h6kkdmth50y0yft', 'https://i.scdn.co/image/ab67616d0000b273c3bb167f0e78b15e5588c296', 'Becky G Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p717ynibmq79unltk62kg1jlvzetrzn0easpzolz8r4cbfzvvs','Chanel','h6kkdmth50y0yft','POP','5RcxRGvmYai7kpFSfxe5GY','https://p.scdn.co/mp3-preview/38dbb82dace64ea92e1dafe5989c1d1861656595?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fjsprscs8dqo03l49q7e3vpwtwitzmewhta4cblg0yt22o39w8', 'p717ynibmq79unltk62kg1jlvzetrzn0easpzolz8r4cbfzvvs', '0');
-- Kali Uchis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6f2jb5bowgwr8rv', 'Kali Uchis', '2@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:2@artist.com', '6f2jb5bowgwr8rv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6f2jb5bowgwr8rv', 'A fusion of soul, R&B, and Latin beats, creating a unique sound experience.', 'Kali Uchis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zwex1o90derlk3kn9aponfrbeolyww3bezmqpbvmm021758b7p','6f2jb5bowgwr8rv', 'https://i.scdn.co/image/ab67616d0000b27381fccd758776d16b87721b17', 'Kali Uchis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('doibieznq1bxjyyxh5603tzgygiww252b1jkz84q37jyq1djyo','Moonlight','6f2jb5bowgwr8rv','POP','0JmnkIqdlnUzPaf8sqBRs3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zwex1o90derlk3kn9aponfrbeolyww3bezmqpbvmm021758b7p', 'doibieznq1bxjyyxh5603tzgygiww252b1jkz84q37jyq1djyo', '0');
-- Radiohead
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jli65abht5q5pze', 'Radiohead', '3@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba03696716c9ee605006047fd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:3@artist.com', 'jli65abht5q5pze', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jli65abht5q5pze', 'A harmonious blend of passion and creativity.', 'Radiohead');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kav29k4ahrzkua66stl2ck3c5gt46480p9ytyumxgj48ry291k','jli65abht5q5pze', 'https://i.scdn.co/image/ab67616d0000b273df55e326ed144ab4f5cecf95', 'Radiohead Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3ufqsuypx1gognmw38yg3npxqx3v49tj10i1idbps3t0scgy25','Creep','jli65abht5q5pze','POP','70LcF31zb1H0PyJoS1Sx1r','https://p.scdn.co/mp3-preview/713b601d02641a850f2a3e6097aacaff52328d57?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kav29k4ahrzkua66stl2ck3c5gt46480p9ytyumxgj48ry291k', '3ufqsuypx1gognmw38yg3npxqx3v49tj10i1idbps3t0scgy25', '0');
-- Sachin-Jigar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ty5em8ezx157nuh', 'Sachin-Jigar', '4@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba038d7d87f8577bbb9686bd3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:4@artist.com', 'ty5em8ezx157nuh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ty5em8ezx157nuh', 'A symphony of emotions expressed through sound.', 'Sachin-Jigar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8jezpm0v10tw34611ike1jfonx19e07xcnj5g7knt57mnl69jp','ty5em8ezx157nuh', NULL, 'Sachin-Jigar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d98rdfquf5a4bsaj02fjt2hg8jkg0tzvsc1gyk3yd7kz1igu8h','Tere Vaaste (From "Zara Hatke Zara Bachke")','ty5em8ezx157nuh','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8jezpm0v10tw34611ike1jfonx19e07xcnj5g7knt57mnl69jp', 'd98rdfquf5a4bsaj02fjt2hg8jkg0tzvsc1gyk3yd7kz1igu8h', '0');
-- Cartel De Santa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3lxic6ff5a1hm7p', 'Cartel De Santa', '5@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb72d02b5f21c6364c3d1928d7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:5@artist.com', '3lxic6ff5a1hm7p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3lxic6ff5a1hm7p', 'A beacon of innovation in the world of sound.', 'Cartel De Santa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dfazea0ep1oogwmx87m9r9d6hhbiqk62flyzherxuuhqrgelgo','3lxic6ff5a1hm7p', 'https://i.scdn.co/image/ab67616d0000b273608e249e118a39e897f149ce', 'Cartel De Santa Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gdj8axkrffpg9eneeeq8yntznugt5g6g36qvpt5m1xnx774t5i','Shorty Party','3lxic6ff5a1hm7p','POP','55ZATsjPlTeSTNJOuW90pW','https://p.scdn.co/mp3-preview/861a31225cff10db2eedeb5c28bf6d0a4ecc4bc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dfazea0ep1oogwmx87m9r9d6hhbiqk62flyzherxuuhqrgelgo', 'gdj8axkrffpg9eneeeq8yntznugt5g6g36qvpt5m1xnx774t5i', '0');
-- Lil Nas X
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ry51313cby8itak', 'Lil Nas X', '6@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd66f1e0c883f319443d68c45','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:6@artist.com', 'ry51313cby8itak', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ry51313cby8itak', 'A voice that echoes the sentiments of a generation.', 'Lil Nas X');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l2b9gbiyjmzjhl0bi144k5b53l7tp7e3eq49pcjaa02rrxqq9z','ry51313cby8itak', 'https://i.scdn.co/image/ab67616d0000b27304cd9a1664fb4539a55643fe', 'Lil Nas X Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hzcj9zkj7fh79u12c6ttzg0fjv4qn9ahdtp80ci2x3t6sao6as','STAR WALKIN (League of Legends Worlds Anthem)','ry51313cby8itak','POP','38T0tPVZHcPZyhtOcCP7pF','https://p.scdn.co/mp3-preview/ffa9d53ff1f83a322ac0523d7a6ce13b231e4a3a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l2b9gbiyjmzjhl0bi144k5b53l7tp7e3eq49pcjaa02rrxqq9z', 'hzcj9zkj7fh79u12c6ttzg0fjv4qn9ahdtp80ci2x3t6sao6as', '0');
-- Dean Lewis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1v0ar7qu9nj4lkw', 'Dean Lewis', '7@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4fc14e184f9e05ba0676ddee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:7@artist.com', '1v0ar7qu9nj4lkw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1v0ar7qu9nj4lkw', 'Harnessing the power of melody to tell compelling stories.', 'Dean Lewis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bxodb56eun3ibhw5817hia3x758tsssebzpql6d4bs9r8taakr','1v0ar7qu9nj4lkw', 'https://i.scdn.co/image/ab67616d0000b273bfedccaca3c8425fdc0a7c73', 'Dean Lewis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kdwb8vh6z72m90d6lop9lgr132r2kyweeq228kq32wpz27f06k','How Do I Say Goodbye','1v0ar7qu9nj4lkw','POP','5hnGrTBaEsdukpDF6aZg8a',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bxodb56eun3ibhw5817hia3x758tsssebzpql6d4bs9r8taakr', 'kdwb8vh6z72m90d6lop9lgr132r2kyweeq228kq32wpz27f06k', '0');
-- Lana Del Rey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5wrouaozekc5dbu', 'Lana Del Rey', '8@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb99cacf8acd5378206767261','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:8@artist.com', '5wrouaozekc5dbu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5wrouaozekc5dbu', 'An ethereal presence in music, known for her cinematic and nostalgic sound.', 'Lana Del Rey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('c5cirfgtyf05hmpa86p27xdnsl2z0l1ffng0ybsq400lb9c62q','5wrouaozekc5dbu', 'https://i.scdn.co/image/ab67616d0000b273aa27708d07f49c82ff0d0dae', 'Lana Del Rey Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zioaasz05v564lusf9nex6s8rftu9zpuk9ytz3ffsl4p9m4cf3','Say Yes To Heaven','5wrouaozekc5dbu','POP','6GGtHZgBycCgGBUhZo81xe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c5cirfgtyf05hmpa86p27xdnsl2z0l1ffng0ybsq400lb9c62q', 'zioaasz05v564lusf9nex6s8rftu9zpuk9ytz3ffsl4p9m4cf3', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wsfepuswyvdzgj594je349hwzwyfl38w2p3o6u87wvfsh24n0t','Summertime Sadness','5wrouaozekc5dbu','POP','1Ist6PR2BZR3n2z2Y5R6S1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c5cirfgtyf05hmpa86p27xdnsl2z0l1ffng0ybsq400lb9c62q', 'wsfepuswyvdzgj594je349hwzwyfl38w2p3o6u87wvfsh24n0t', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x7758v4nshopn9fvb7nir6ck329ambhqwhrj6p9xfneatdwm0z','Radio','5wrouaozekc5dbu','POP','3QhfFRPkhPCR1RMJWV1gde',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c5cirfgtyf05hmpa86p27xdnsl2z0l1ffng0ybsq400lb9c62q', 'x7758v4nshopn9fvb7nir6ck329ambhqwhrj6p9xfneatdwm0z', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1sh5jof50u26378l49m9fcaihxe97psw4fw93gmm2t6uicqfmd','Snow On The Beach (feat. More Lana Del Rey)','5wrouaozekc5dbu','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c5cirfgtyf05hmpa86p27xdnsl2z0l1ffng0ybsq400lb9c62q', '1sh5jof50u26378l49m9fcaihxe97psw4fw93gmm2t6uicqfmd', '3');
-- Lizzo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7awwx5b7cefi4b8', 'Lizzo', '9@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0d66b3670294bf801847dae2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:9@artist.com', '7awwx5b7cefi4b8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7awwx5b7cefi4b8', 'Pushing the boundaries of sound with each note.', 'Lizzo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('z47bf7antb0zxl4f0hyzagsbfhn533g8qwqjb2f9kw6wpn2bow','7awwx5b7cefi4b8', 'https://i.scdn.co/image/ab67616d0000b273b817e721691aff3d67f26c04', 'Lizzo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xzf7fs1g7zk5zx4guqfgnk7oraawk23bedp6veqnlaeg82i7vg','About Damn Time','7awwx5b7cefi4b8','POP','1PckUlxKqWQs3RlWXVBLw3','https://p.scdn.co/mp3-preview/bbf8a26d38f7d8c7191dd64bd7c21a4cec8b61a0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z47bf7antb0zxl4f0hyzagsbfhn533g8qwqjb2f9kw6wpn2bow', 'xzf7fs1g7zk5zx4guqfgnk7oraawk23bedp6veqnlaeg82i7vg', '0');
-- Drake
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('phoq9xkwy2bcz1k', 'Drake', '10@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb35ca7d2181258b51c0f2cf9e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:10@artist.com', 'phoq9xkwy2bcz1k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('phoq9xkwy2bcz1k', 'A unique voice in the contemporary music scene.', 'Drake');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tcoxvh75y6e2wkxlp4w2l2upj0atoaydtpkshcx446e2vx9fgf','phoq9xkwy2bcz1k', 'https://i.scdn.co/image/ab67616d0000b2738dc0d801766a5aa6a33cbe37', 'Drake Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d70orau034l95hls2xmzp12uvvsxtkkmy77f07opuqu7v2hw5x','Jimmy Cooks (feat. 21 Savage)','phoq9xkwy2bcz1k','POP','3F5CgOj3wFlRv51JsHbxhe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tcoxvh75y6e2wkxlp4w2l2upj0atoaydtpkshcx446e2vx9fgf', 'd70orau034l95hls2xmzp12uvvsxtkkmy77f07opuqu7v2hw5x', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n4sklzrb0d8251icrv2tlnkscjchbjbdadhx9bw7svg4ki8pbl','One Dance','phoq9xkwy2bcz1k','POP','1zi7xx7UVEFkmKfv06H8x0',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tcoxvh75y6e2wkxlp4w2l2upj0atoaydtpkshcx446e2vx9fgf', 'n4sklzrb0d8251icrv2tlnkscjchbjbdadhx9bw7svg4ki8pbl', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gdxujvn7db85d2zke34hsxvpro0i4slusi0wcbg97cj3jusxnf','Search & Rescue','phoq9xkwy2bcz1k','POP','7aRCf5cLOFN1U7kvtChY1G',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tcoxvh75y6e2wkxlp4w2l2upj0atoaydtpkshcx446e2vx9fgf', 'gdxujvn7db85d2zke34hsxvpro0i4slusi0wcbg97cj3jusxnf', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l4uolq54vb6253ra648ex02ykjff0jj8ezd0yy5s8oj6piu8b4','Rich Flex','phoq9xkwy2bcz1k','POP','1bDbXMyjaUIooNwFE9wn0N',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tcoxvh75y6e2wkxlp4w2l2upj0atoaydtpkshcx446e2vx9fgf', 'l4uolq54vb6253ra648ex02ykjff0jj8ezd0yy5s8oj6piu8b4', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6p7sag6xw5nbtf2y2oajtsg4qiq1dvqfs3q0d6zpgouho2uukk','WAIT FOR U (feat. Drake & Tems)','phoq9xkwy2bcz1k','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tcoxvh75y6e2wkxlp4w2l2upj0atoaydtpkshcx446e2vx9fgf', '6p7sag6xw5nbtf2y2oajtsg4qiq1dvqfs3q0d6zpgouho2uukk', '4');
-- Gunna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('73hq0zi1uv56sca', 'Gunna', '11@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6501f8a7d50c56e86e46f920','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:11@artist.com', '73hq0zi1uv56sca', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('73hq0zi1uv56sca', 'A trailblazer in trap music, known for his smooth flow and catchy beats.', 'Gunna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('q2uiim8f2i9h96gsyaq50o912hisk64sj0pm1na739iml5b11d','73hq0zi1uv56sca', 'https://i.scdn.co/image/ab67616d0000b273017d5e26552345c4b1575b6c', 'Gunna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pf3815dvo0kgo0022bxrl6vu89cgpb8c4m3labl63eihauxmlx','fukumean','73hq0zi1uv56sca','POP','4rXLjWdF2ZZpXCVTfWcshS','https://p.scdn.co/mp3-preview/f237ab921af697ba9b49e12fa167c2ce1a82d6b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q2uiim8f2i9h96gsyaq50o912hisk64sj0pm1na739iml5b11d', 'pf3815dvo0kgo0022bxrl6vu89cgpb8c4m3labl63eihauxmlx', '0');
-- Natanael Cano
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nwd0ezkcrmvgbys', 'Natanael Cano', '12@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0819edd43096a2f0dde7cd44','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:12@artist.com', 'nwd0ezkcrmvgbys', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nwd0ezkcrmvgbys', 'Crafting soundscapes that transport listeners to another world.', 'Natanael Cano');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tuwptanvlai7gviumzhrv6a7duvkhc1m46aobakzyasn33akby','nwd0ezkcrmvgbys', 'https://i.scdn.co/image/ab67616d0000b273e2e093427065eaca9e2f2970', 'Natanael Cano Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ks124q4fbgzsb3r34c6yd74lv5c9dzbxt6r325hikxrs4fgab0','Mi Bello Angel','nwd0ezkcrmvgbys','POP','4t46soaqA758rbukTO5pp1','https://p.scdn.co/mp3-preview/07854d155311327027a073aeb36f0f61cdb07096?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tuwptanvlai7gviumzhrv6a7duvkhc1m46aobakzyasn33akby', 'ks124q4fbgzsb3r34c6yd74lv5c9dzbxt6r325hikxrs4fgab0', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('apuxqzncoeq2an3wideu6391prey2grk37qyrzxq84scureedr','PRC','nwd0ezkcrmvgbys','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tuwptanvlai7gviumzhrv6a7duvkhc1m46aobakzyasn33akby', 'apuxqzncoeq2an3wideu6391prey2grk37qyrzxq84scureedr', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fv6pnwxd9zh1re92oo0tfxpywvu7fmvr7lr98vgg08xzhvgvy5','AMG','nwd0ezkcrmvgbys','POP','1lRtH4FszTrwwlK5gTSbXO','https://p.scdn.co/mp3-preview/2a54eb02ee2a7e8c47c6107f16272a19a0e6362b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tuwptanvlai7gviumzhrv6a7duvkhc1m46aobakzyasn33akby', 'fv6pnwxd9zh1re92oo0tfxpywvu7fmvr7lr98vgg08xzhvgvy5', '2');
-- Gorillaz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wonsyc77g6g59xp', 'Gorillaz', '13@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb337d671a32b2f44d4a4e6cf2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:13@artist.com', 'wonsyc77g6g59xp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wonsyc77g6g59xp', 'A sonic adventurer, always seeking new horizons in music.', 'Gorillaz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xszgqmihbb3vub635hpd8tawhwffg3px7gpwdg4egs1vrca7t8','wonsyc77g6g59xp', 'https://i.scdn.co/image/ab67616d0000b2734b0ddebba0d5b34f2a2f07a4', 'Gorillaz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qp8wad28emot9zdpkndc1wkbg1o1m452m7eaknlch6f9w4ebyr','Tormenta (feat. Bad Bunny)','wonsyc77g6g59xp','POP','38UYeBLfvpnDSG9GznZdnL','https://p.scdn.co/mp3-preview/3f89a1c3ec527e23fdefdd03da7797b83eb6e14f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xszgqmihbb3vub635hpd8tawhwffg3px7gpwdg4egs1vrca7t8', 'qp8wad28emot9zdpkndc1wkbg1o1m452m7eaknlch6f9w4ebyr', '0');
-- Don Toliver
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7rui5p64we4e296', 'Don Toliver', '14@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:14@artist.com', '7rui5p64we4e296', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7rui5p64we4e296', 'Harnessing the power of melody to tell compelling stories.', 'Don Toliver');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xa6pjs3v5x96v4dkv1we531ioqkso04amgoz4i0oao9ap3e3d7','7rui5p64we4e296', 'https://i.scdn.co/image/ab67616d0000b273feeff698e6090e6b02f21ec0', 'Don Toliver Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ngfwr1b7vpx1qdtba3pjmnstbs9i9ob9tt6fmjag4ml8njbk9s','Private Landing (feat. Justin Bieber & Future)','7rui5p64we4e296','POP','52NGJPcLUzQq5w7uv4e5gf','https://p.scdn.co/mp3-preview/511bdf681359f3b57dfa25344f34c2b66ecc4326?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xa6pjs3v5x96v4dkv1we531ioqkso04amgoz4i0oao9ap3e3d7', 'ngfwr1b7vpx1qdtba3pjmnstbs9i9ob9tt6fmjag4ml8njbk9s', '0');
-- Bad Bunny
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3w4g6drnk5xp86p', 'Bad Bunny', '15@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9ad50e478a469448c6f369df','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:15@artist.com', '3w4g6drnk5xp86p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3w4g6drnk5xp86p', 'A trailblazer in Latin trap and reggaeton, known for his charismatic style and innovative music.', 'Bad Bunny');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wg4jcljvhv86ycq8pe9hxvsed94k3h3srlmfawr95ficmoviwr','3w4g6drnk5xp86p', 'https://i.scdn.co/image/ab67616d0000b273ab5c9cd818ad6ed3e9b79cd1', 'Bad Bunny Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9ew15byq46tg829972z0f4tp1in01sydyq90vq6h5kyyakhfmi','WHERE SHE GOES','3w4g6drnk5xp86p','POP','7ro0hRteUMfnOioTFI5TG1','https://p.scdn.co/mp3-preview/b9b7e4c982b33ee23c4867f7a3025e3598c35760?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wg4jcljvhv86ycq8pe9hxvsed94k3h3srlmfawr95ficmoviwr', '9ew15byq46tg829972z0f4tp1in01sydyq90vq6h5kyyakhfmi', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ydazyv1k51jnnf38gs9u0yvqldypy9zgpsp3400iqu5sns0eva','un x100to','3w4g6drnk5xp86p','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wg4jcljvhv86ycq8pe9hxvsed94k3h3srlmfawr95ficmoviwr', 'ydazyv1k51jnnf38gs9u0yvqldypy9zgpsp3400iqu5sns0eva', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xw0efwdtg264imggawedj2sf7ytr6wvisuf94kfacpmjtiykek','Coco Chanel','3w4g6drnk5xp86p','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wg4jcljvhv86ycq8pe9hxvsed94k3h3srlmfawr95ficmoviwr', 'xw0efwdtg264imggawedj2sf7ytr6wvisuf94kfacpmjtiykek', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tib8bghj1hrfu44qno0qc2k3c9ngbihujtiw363o8x4hd28fga','Titi Me Pregunt','3w4g6drnk5xp86p','POP','1IHWl5LamUGEuP4ozKQSXZ','https://p.scdn.co/mp3-preview/53a6217761f8fdfcff92189cafbbd1cc21fdb813?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wg4jcljvhv86ycq8pe9hxvsed94k3h3srlmfawr95ficmoviwr', 'tib8bghj1hrfu44qno0qc2k3c9ngbihujtiw363o8x4hd28fga', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o2xvmohxt44thv2ezv3hm81syk9l4t1ax49kvo3iasbnz7bton','Efecto','3w4g6drnk5xp86p','POP','5Eax0qFko2dh7Rl2lYs3bx','https://p.scdn.co/mp3-preview/a622a47c8df98ef72676608511c0b2e1d5d51268?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wg4jcljvhv86ycq8pe9hxvsed94k3h3srlmfawr95ficmoviwr', 'o2xvmohxt44thv2ezv3hm81syk9l4t1ax49kvo3iasbnz7bton', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tge9xuz7vo27upmvs5bspck4kx34d92o4lu1uqyhdot6blvcen','Neverita','3w4g6drnk5xp86p','POP','31i56LZnwE6uSu3exoHjtB','https://p.scdn.co/mp3-preview/b50a3cafa2eb688f811d4079812649bfba050417?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wg4jcljvhv86ycq8pe9hxvsed94k3h3srlmfawr95ficmoviwr', 'tge9xuz7vo27upmvs5bspck4kx34d92o4lu1uqyhdot6blvcen', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('usp6w6y23xfgps405op2qsxcyqn8cho84v5fxjekffvhsj4v8f','Moscow Mule','3w4g6drnk5xp86p','POP','6Xom58OOXk2SoU711L2IXO','https://p.scdn.co/mp3-preview/77b12f38abcff65705166d67b5657f70cd890635?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wg4jcljvhv86ycq8pe9hxvsed94k3h3srlmfawr95ficmoviwr', 'usp6w6y23xfgps405op2qsxcyqn8cho84v5fxjekffvhsj4v8f', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ckg7swoyl476hdcaw9l3c39qewofdimwjegujf6sb5bih7t4dn','Yonaguni','3w4g6drnk5xp86p','POP','2JPLbjOn0wPCngEot2STUS','https://p.scdn.co/mp3-preview/cbade9b0e669565ac8c7c07490f961e4c471b9ee?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wg4jcljvhv86ycq8pe9hxvsed94k3h3srlmfawr95ficmoviwr', 'ckg7swoyl476hdcaw9l3c39qewofdimwjegujf6sb5bih7t4dn', '7');
-- Travis Scott
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y701sgrf8migzxf', 'Travis Scott', '16@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:16@artist.com', 'y701sgrf8migzxf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y701sgrf8migzxf', 'Transcending language barriers through the universal language of music.', 'Travis Scott');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('on550fub1w2e3f2t2wju9018oh1vw55egzg9k259g25q3x3zkj','y701sgrf8migzxf', NULL, 'Travis Scott Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('znbf4pyo1xj0qukamnk2munluak9tj7p1wt5it802o6khem5np','Trance (with Travis Scott & Young Thug)','y701sgrf8migzxf','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('on550fub1w2e3f2t2wju9018oh1vw55egzg9k259g25q3x3zkj', 'znbf4pyo1xj0qukamnk2munluak9tj7p1wt5it802o6khem5np', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pjksq7ju95bpkj5h5qisv3oraijiatfgvn37xq2dseam2cirvr','Niagara Falls (Foot or 2) [with Travis Scott & 21 Savage]','y701sgrf8migzxf','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('on550fub1w2e3f2t2wju9018oh1vw55egzg9k259g25q3x3zkj', 'pjksq7ju95bpkj5h5qisv3oraijiatfgvn37xq2dseam2cirvr', '1');
-- Kanii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bm0rufqxh96n634', 'Kanii', '17@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb777f2bab9e5f1e343c3126d4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:17@artist.com', 'bm0rufqxh96n634', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bm0rufqxh96n634', 'The heartbeat of a new generation of music lovers.', 'Kanii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9697xs5zjw0okgomnu6x8f7sggkrltg4p48mx7fliggorq6595','bm0rufqxh96n634', 'https://i.scdn.co/image/ab67616d0000b273efae10889cd442784f3acd3d', 'Kanii Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6rkv6xdu3onez2f53mj01oro0zh0p2sdser04dica7at8bef4j','I Know - PR1SVX Edit','bm0rufqxh96n634','POP','3vcLw8QA3yCOkrj9oLSZNs','https://p.scdn.co/mp3-preview/146ad1bb65b8f9b097f356d2d5758657a06466dc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9697xs5zjw0okgomnu6x8f7sggkrltg4p48mx7fliggorq6595', '6rkv6xdu3onez2f53mj01oro0zh0p2sdser04dica7at8bef4j', '0');
-- Veigh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('o1ipoc2ohc8f062', 'Veigh', '18@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfe49a8f4b6b1a82a29f43112','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:18@artist.com', 'o1ipoc2ohc8f062', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('o1ipoc2ohc8f062', 'Harnessing the power of melody to tell compelling stories.', 'Veigh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e9kksvq9tr5y5s89h26z5w3tnd1uwueewhchpck27wozivmv73','o1ipoc2ohc8f062', 'https://i.scdn.co/image/ab67616d0000b273ce0947b85c30490447dbbd91', 'Veigh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x9t445wbmhs4g4vf9eglzcduvgurrn2bmhdz4pza2630lex2cn','Novo Balan','o1ipoc2ohc8f062','POP','4hKLzFvNwHF6dPosGT30ed','https://p.scdn.co/mp3-preview/af031ca41aac7b60676833187f323d94fc387bce?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e9kksvq9tr5y5s89h26z5w3tnd1uwueewhchpck27wozivmv73', 'x9t445wbmhs4g4vf9eglzcduvgurrn2bmhdz4pza2630lex2cn', '0');
-- Libianca
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j4kzlszsj0yrm0c', 'Libianca', '19@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a42e7c32ead029c0285c12f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:19@artist.com', 'j4kzlszsj0yrm0c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j4kzlszsj0yrm0c', 'A fresh talent, blending Afrobeat rhythms with soulful melodies.', 'Libianca');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('b8bx82dtr69hwbq2dzfgtaelehemrssqjnlhcnu4qtna9av14c','j4kzlszsj0yrm0c', 'https://i.scdn.co/image/ab67616d0000b273fc342f95f117d48dbdde9735', 'Libianca Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dyamjsbjxt94nfakdnhs9enka8uy1go03gizd7f671ppt5aznf','People','j4kzlszsj0yrm0c','POP','26b3oVLrRUaaybJulow9kz','https://p.scdn.co/mp3-preview/abcbc9adf10ae4901b40b80a30dc194d589c2d62?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('b8bx82dtr69hwbq2dzfgtaelehemrssqjnlhcnu4qtna9av14c', 'dyamjsbjxt94nfakdnhs9enka8uy1go03gizd7f671ppt5aznf', '0');
-- P!nk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hbcmvl0yd0w2qr3', 'P!nk', '20@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7bbad89a61061304ec842588','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:20@artist.com', 'hbcmvl0yd0w2qr3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hbcmvl0yd0w2qr3', 'Breathing new life into classic genres.', 'P!nk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d4xzfmh4s47bsyi0j8vyfl8o21u87dc8t8csrafeqa4qscxf3i','hbcmvl0yd0w2qr3', 'https://i.scdn.co/image/ab67616d0000b27302f93e92bdd5b3793eb688c0', 'P!nk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4atfu75fxfv3dk95e48akdhzfy2n5w8b1uog5fptr3h431eupm','TRUSTFALL','hbcmvl0yd0w2qr3','POP','4FWbsd91QSvgr1dSWwW51e','https://p.scdn.co/mp3-preview/4a8b78e434e2dda75bc679955c3fbd8b4dad372b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d4xzfmh4s47bsyi0j8vyfl8o21u87dc8t8csrafeqa4qscxf3i', '4atfu75fxfv3dk95e48akdhzfy2n5w8b1uog5fptr3h431eupm', '0');
-- Jack Harlow
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sdi4t95s4pr40pw', 'Jack Harlow', '21@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5ee4635b0775e342e064657','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:21@artist.com', 'sdi4t95s4pr40pw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sdi4t95s4pr40pw', 'A visionary in the world of music, redefining genres.', 'Jack Harlow');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7dpyrw3jsb8ki77qae1ctl33pqz36f2zrrrz7tewityczk7n1p','sdi4t95s4pr40pw', NULL, 'Jack Harlow Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6vdsfclow7417fwx8h61zgfo2d1kr9aixvbaegpjse6m7m25m1','INDUSTRY BABY (feat. Jack Harlow)','sdi4t95s4pr40pw','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7dpyrw3jsb8ki77qae1ctl33pqz36f2zrrrz7tewityczk7n1p', '6vdsfclow7417fwx8h61zgfo2d1kr9aixvbaegpjse6m7m25m1', '0');
-- a-ha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('50kab1fsd6zb9sr', 'a-ha', '22@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0168ba8148c07c2cdeb7d067','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:22@artist.com', '50kab1fsd6zb9sr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('50kab1fsd6zb9sr', 'Weaving lyrical magic into every song.', 'a-ha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cuy8vlpskksf83uhutn4fjx8kmj6dbozibh5b471yldelev0mz','50kab1fsd6zb9sr', 'https://i.scdn.co/image/ab67616d0000b273e8dd4db47e7177c63b0b7d53', 'a-ha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yw1c9r6t8mpln3cw8c6vk9k8f2ma3edfoag7m1r5e5ojq5l1no','Take On Me','50kab1fsd6zb9sr','POP','2WfaOiMkCvy7F5fcp2zZ8L','https://p.scdn.co/mp3-preview/ed66a8c444c35b2f5029c04ae8e18f69d952c2bb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cuy8vlpskksf83uhutn4fjx8kmj6dbozibh5b471yldelev0mz', 'yw1c9r6t8mpln3cw8c6vk9k8f2ma3edfoag7m1r5e5ojq5l1no', '0');
-- Robin Schulz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j7zaypab8sm258z', 'Robin Schulz', '23@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2615ef39cf9128c447b31619','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:23@artist.com', 'j7zaypab8sm258z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j7zaypab8sm258z', 'A journey through the spectrum of sound in every album.', 'Robin Schulz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('m6jv51w0og15gxsos579zhh6akpfcol0r5go3h9z0ilvxuiw3g','j7zaypab8sm258z', NULL, 'Robin Schulz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('leh3ewy0xxws6iyfftvp186djw3r6478gdmpimnpqsqeby052o','Miss You','j7zaypab8sm258z','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m6jv51w0og15gxsos579zhh6akpfcol0r5go3h9z0ilvxuiw3g', 'leh3ewy0xxws6iyfftvp186djw3r6478gdmpimnpqsqeby052o', '0');
-- IU
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tqgy7bgq7ddkbh8', 'IU', '24@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb006ff3c0136a71bfb9928d34','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:24@artist.com', 'tqgy7bgq7ddkbh8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tqgy7bgq7ddkbh8', 'Delivering soul-stirring tunes that linger in the mind.', 'IU');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2qzecstr70hv3ce4d3wfcbajqxtlth5his7bg1rvp03pipvnju','tqgy7bgq7ddkbh8', NULL, 'IU Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1ypojwovo01aic11k7naj3ipakbx541t9ynuz42k7uqvnvn74i','People Pt.2 (feat. IU)','tqgy7bgq7ddkbh8','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2qzecstr70hv3ce4d3wfcbajqxtlth5his7bg1rvp03pipvnju', '1ypojwovo01aic11k7naj3ipakbx541t9ynuz42k7uqvnvn74i', '0');
-- Beach House
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v8z9tgrhuf294hn', 'Beach House', '25@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb3e38a46a56a423d8f741c09','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:25@artist.com', 'v8z9tgrhuf294hn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v8z9tgrhuf294hn', 'Revolutionizing the music scene with innovative compositions.', 'Beach House');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vqqy7xjq51l7f034k87uiuv7on0lx9kb5i1sc2l6g692vgi5hf','v8z9tgrhuf294hn', 'https://i.scdn.co/image/ab67616d0000b2739b7190e673e46271b2754aab', 'Beach House Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('10g1yrn7341lbhuqflnlfo5973bdzstd4uddgddeub89vtztbp','Space Song','v8z9tgrhuf294hn','POP','7H0ya83CMmgFcOhw0UB6ow','https://p.scdn.co/mp3-preview/3d50d7331c2ef197699e796d08cf8d4009591be0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vqqy7xjq51l7f034k87uiuv7on0lx9kb5i1sc2l6g692vgi5hf', '10g1yrn7341lbhuqflnlfo5973bdzstd4uddgddeub89vtztbp', '0');
-- Doechii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0ultk2ymn5qdo7e', 'Doechii', '26@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5f9f729e1e5182fbf1030dbe','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:26@artist.com', '0ultk2ymn5qdo7e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0ultk2ymn5qdo7e', 'Breaking barriers with her unique sound and powerful lyrical storytelling.', 'Doechii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('id0jl66zqmg66y718d89cp47vv6a458t5x50ew4hjhlcodztnq','0ultk2ymn5qdo7e', 'https://i.scdn.co/image/ab67616d0000b2732ee85751f6f503fa9a533eba', 'Doechii Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2itmurzgz7kq7pfrqx1kz41d1sxz28l3o4o4qdmqazsh3tni5q','What It Is (Solo Version)','0ultk2ymn5qdo7e','POP','73RbfOTJIjHzi2pcVHjeHM',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('id0jl66zqmg66y718d89cp47vv6a458t5x50ew4hjhlcodztnq', '2itmurzgz7kq7pfrqx1kz41d1sxz28l3o4o4qdmqazsh3tni5q', '0');
-- DJ Escobar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('p9fkekmvkiy4nm0', 'DJ Escobar', '27@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb62fa9c7f56a64dc956ec2621','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:27@artist.com', 'p9fkekmvkiy4nm0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('p9fkekmvkiy4nm0', 'Transcending language barriers through the universal language of music.', 'DJ Escobar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('chchv0ux0ejrhj3wkzy60rtmifydwpgha27y7oa44894sclyh9','p9fkekmvkiy4nm0', 'https://i.scdn.co/image/ab67616d0000b273769f6572dfa10ee7827edbf2', 'DJ Escobar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('eluw7padfaq2sjm5c6rzyer8cx2p3rgilpqy1kmxm6zd032o58','Evoque Prata','p9fkekmvkiy4nm0','POP','4mQ2UZzSH3T4o4Gr9phTgL','https://p.scdn.co/mp3-preview/f2c69618853c528447f24f0102d0e5404fe31ed9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('chchv0ux0ejrhj3wkzy60rtmifydwpgha27y7oa44894sclyh9', 'eluw7padfaq2sjm5c6rzyer8cx2p3rgilpqy1kmxm6zd032o58', '0');
-- Mac DeMarco
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9ut4lmv8vwr0i8d', 'Mac DeMarco', '28@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3cef7752073cbbd2cc04c6f0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:28@artist.com', '9ut4lmv8vwr0i8d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9ut4lmv8vwr0i8d', 'A tapestry of rhythms that echo the pulse of life.', 'Mac DeMarco');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ys5cta358388is6ohpebpsw62m0ql6tf2er5mxhbkdx86odwav','9ut4lmv8vwr0i8d', 'https://i.scdn.co/image/ab67616d0000b273fa1323bb50728c7489980672', 'Mac DeMarco Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w0yrn6wbc8ki2iutd6h3is4utxhf1kyu60ibmg260qy475983d','Heart To Heart','9ut4lmv8vwr0i8d','POP','7EAMXbLcL0qXmciM5SwMh2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ys5cta358388is6ohpebpsw62m0ql6tf2er5mxhbkdx86odwav', 'w0yrn6wbc8ki2iutd6h3is4utxhf1kyu60ibmg260qy475983d', '0');
-- Luke Combs
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5p05ex0hzmqqnvk', 'Luke Combs', '29@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5db6179b28f7e3654898b279','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:29@artist.com', '5p05ex0hzmqqnvk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5p05ex0hzmqqnvk', 'Reigniting country music with his powerful voice and relatable songs.', 'Luke Combs');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gadbbnpweq3a26hm4s70rp7umz4qmvsnsnhzams2g9ldil9bj6','5p05ex0hzmqqnvk', 'https://i.scdn.co/image/ab67616d0000b273ca650d3a95022e0490434ba1', 'Luke Combs Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hcgw28zs8xynuq2waw0qrnu99kq466u6mztyemfcq80v8ah2ab','Fast Car','5p05ex0hzmqqnvk','POP','1Lo0QY9cvc8sUB2vnIOxDT','https://p.scdn.co/mp3-preview/1dc0426c95058783e0fe1d70c41583ca98317108?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gadbbnpweq3a26hm4s70rp7umz4qmvsnsnhzams2g9ldil9bj6', 'hcgw28zs8xynuq2waw0qrnu99kq466u6mztyemfcq80v8ah2ab', '0');
-- J Balvin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vnqbos2u97eaxaf', 'J Balvin', '30@artist.com', 'https://i.scdn.co/image/ab67616d0000b273498cf6571df9adf37e46b527','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:30@artist.com', 'vnqbos2u97eaxaf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vnqbos2u97eaxaf', 'A visionary in the world of music, redefining genres.', 'J Balvin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tql2edwu2opl5a5wk4xez6y0qub7plnk1fq2fsqe4f1guy7xdj','vnqbos2u97eaxaf', 'https://i.scdn.co/image/ab67616d0000b2734891d9b25d8919448388f3bb', 'J Balvin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9otdem521bbuzxk2kx10n4bpnrybtaewiem1ecar4jvt7ejuha','LA CANCI','vnqbos2u97eaxaf','POP','0fea68AdmYNygeTGI4RC18',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tql2edwu2opl5a5wk4xez6y0qub7plnk1fq2fsqe4f1guy7xdj', '9otdem521bbuzxk2kx10n4bpnrybtaewiem1ecar4jvt7ejuha', '0');
-- Ed Sheeran
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3gtqzaz3wk1ogn3', 'Ed Sheeran', '31@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3bcef85e105dfc42399ef0ba','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:31@artist.com', '3gtqzaz3wk1ogn3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3gtqzaz3wk1ogn3', 'A harmonious blend of passion and creativity.', 'Ed Sheeran');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yrf2ba0q58rx925uibyho529uuofxvuc9hg7j9aowao359k6w3','3gtqzaz3wk1ogn3', 'https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96', 'Ed Sheeran Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cj9xqxro05ob5opj2flw7ycdtm4jmnqxdk364ao6rx2g58yxi6','Perfect','3gtqzaz3wk1ogn3','POP','0tgVpDi06FyKpA1z0VMD4v','https://p.scdn.co/mp3-preview/4e30857a3c7da3f8891483643e310bb233afadd2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yrf2ba0q58rx925uibyho529uuofxvuc9hg7j9aowao359k6w3', 'cj9xqxro05ob5opj2flw7ycdtm4jmnqxdk364ao6rx2g58yxi6', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8h7natilkpvhow4tn8qw4isypi09vunm52ulxmdofxolrqq52i','Shape of You','3gtqzaz3wk1ogn3','POP','7qiZfU4dY1lWllzX7mPBI3','https://p.scdn.co/mp3-preview/7339548839a263fd721d01eb3364a848cad16fa7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yrf2ba0q58rx925uibyho529uuofxvuc9hg7j9aowao359k6w3', '8h7natilkpvhow4tn8qw4isypi09vunm52ulxmdofxolrqq52i', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dldo8mpwlp3qilha2fe578g1fya18ck6t7o5x1j1sq1kw99l04','Eyes Closed','3gtqzaz3wk1ogn3','POP','3p7XQpdt8Dr6oMXSvRZ9bg','https://p.scdn.co/mp3-preview/7cd2576f2d27799fe8c515c4e0fc880870a5cc88?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yrf2ba0q58rx925uibyho529uuofxvuc9hg7j9aowao359k6w3', 'dldo8mpwlp3qilha2fe578g1fya18ck6t7o5x1j1sq1kw99l04', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('guxjwhkqybzfwpwes26dw959jhs7wfdkmpkijyfbq6j5tho24l','Curtains','3gtqzaz3wk1ogn3','POP','6ZZf5a8oiInHDkBe9zXfLP','https://p.scdn.co/mp3-preview/5a519e5823df4fe468c8a45a7104a632553e09a5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yrf2ba0q58rx925uibyho529uuofxvuc9hg7j9aowao359k6w3', 'guxjwhkqybzfwpwes26dw959jhs7wfdkmpkijyfbq6j5tho24l', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6c0l88oqyrymzr7trizwmiqc4or4a02sa2oahel5omgsfjru41','Shivers','3gtqzaz3wk1ogn3','POP','50nfwKoDiSYg8zOCREWAm5','https://p.scdn.co/mp3-preview/08cec59d36ac30ae9ce1e2944f206251859844af?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yrf2ba0q58rx925uibyho529uuofxvuc9hg7j9aowao359k6w3', '6c0l88oqyrymzr7trizwmiqc4or4a02sa2oahel5omgsfjru41', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1h11pjinhdyusdqdxoabgankcd4t61xmtkd5vfqf9r4rd7u8tr','Bad Habits','3gtqzaz3wk1ogn3','POP','3rmo8F54jFF8OgYsqTxm5d','https://p.scdn.co/mp3-preview/22f3a86c8a83e364db595007f9ac1d666596a335?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yrf2ba0q58rx925uibyho529uuofxvuc9hg7j9aowao359k6w3', '1h11pjinhdyusdqdxoabgankcd4t61xmtkd5vfqf9r4rd7u8tr', '5');
-- Brenda Lee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4ceiopee5ttgptk', 'Brenda Lee', '32@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4ea49bdca366a3baa5cbb006','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:32@artist.com', '4ceiopee5ttgptk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4ceiopee5ttgptk', 'A voice that echoes the sentiments of a generation.', 'Brenda Lee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4by6hylh7eaa3cvtmjg37vmcrvqna7fvnds5e9y3dfgcxg8jlk','4ceiopee5ttgptk', 'https://i.scdn.co/image/ab67616d0000b2737845f74d6db14b400fa61cd3', 'Brenda Lee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4dbscxif2gotvqsfyfina4ao4ehqct08k5uxdep92erdr4l5nx','Rockin Around The Christmas Tree','4ceiopee5ttgptk','POP','2EjXfH91m7f8HiJN1yQg97',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4by6hylh7eaa3cvtmjg37vmcrvqna7fvnds5e9y3dfgcxg8jlk', '4dbscxif2gotvqsfyfina4ao4ehqct08k5uxdep92erdr4l5nx', '0');
-- Sean Paul
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('67vrb3aiwpz2oeh', 'Sean Paul', '33@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb60c3e9abe7327c0097738f22','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:33@artist.com', '67vrb3aiwpz2oeh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('67vrb3aiwpz2oeh', 'Uniting fans around the globe with universal rhythms.', 'Sean Paul');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8xgp6dafnn1k17k1x5shc7vmufihd4oce2pvy032tjyvg0kxoe','67vrb3aiwpz2oeh', NULL, 'Sean Paul Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('69jdk1vu66j9vpgh570i8stmpskj3mucckgg42qo5pkn9cs93o','Nia Bo','67vrb3aiwpz2oeh','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8xgp6dafnn1k17k1x5shc7vmufihd4oce2pvy032tjyvg0kxoe', '69jdk1vu66j9vpgh570i8stmpskj3mucckgg42qo5pkn9cs93o', '0');
-- WizKid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('iykyyrp62xndtgi', 'WizKid', '34@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9050b61368975fda051cdc06','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:34@artist.com', 'iykyyrp62xndtgi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('iykyyrp62xndtgi', 'Revolutionizing the music scene with innovative compositions.', 'WizKid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kgao0w4geff8q7wvns24ztq5z79x2zoeorfzs3lb6yghxf78vg','iykyyrp62xndtgi', NULL, 'WizKid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lobuulup730kkw3f27ydjwu2n3x24zmn6t0s3nvq4fcrxxbayg','Link Up (Metro Boomin & Don Toliver, Wizkid feat. BEAM & Toian) - Spider-Verse Remix (Spider-Man: Across the Spider-Verse )','iykyyrp62xndtgi','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kgao0w4geff8q7wvns24ztq5z79x2zoeorfzs3lb6yghxf78vg', 'lobuulup730kkw3f27ydjwu2n3x24zmn6t0s3nvq4fcrxxbayg', '0');
-- Manuel Turizo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ptu1v76hr2nfvm0', 'Manuel Turizo', '35@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebabd3e69b432d6187cf4e28c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:35@artist.com', 'ptu1v76hr2nfvm0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ptu1v76hr2nfvm0', 'A standout in reggaeton, known for his smooth voice and romantic lyrics.', 'Manuel Turizo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('v10rb882lzaxn6xbtzmnudez85y8wc9698e3xuij8uokfere67','ptu1v76hr2nfvm0', 'https://i.scdn.co/image/ab67616d0000b273c9f744b0d62da795bc21d04a', 'Manuel Turizo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('01mipf8xz85qtgbhv53nxf9wf7rkq7y8jtktg3de19bkjn4o07','La Bachata','ptu1v76hr2nfvm0','POP','5ww2BF9slyYgNOk37BlC4u','https://p.scdn.co/mp3-preview/0232b53fd7849e6696e1ab3099dd01dd00823f17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v10rb882lzaxn6xbtzmnudez85y8wc9698e3xuij8uokfere67', '01mipf8xz85qtgbhv53nxf9wf7rkq7y8jtktg3de19bkjn4o07', '0');
-- Don Omar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qkzcajtia95qt47', 'Don Omar', '36@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:36@artist.com', 'qkzcajtia95qt47', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qkzcajtia95qt47', 'A sonic adventurer, always seeking new horizons in music.', 'Don Omar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i40pz7hcl1fvpg2sj9z4p6u0uqb4iqq81mmhuvjype3hbsdjyt','qkzcajtia95qt47', 'https://i.scdn.co/image/ab67616d0000b2734640a26eb27649006be29a94', 'Don Omar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7x89uh4s1teom9julkh6e6r5ky6h7el6qams1l94nou3n1pl12','Danza Kuduro','qkzcajtia95qt47','POP','2a1o6ZejUi8U3wzzOtCOYw',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i40pz7hcl1fvpg2sj9z4p6u0uqb4iqq81mmhuvjype3hbsdjyt', '7x89uh4s1teom9julkh6e6r5ky6h7el6qams1l94nou3n1pl12', '0');
-- Leo Santana
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mc0kipcekkltc6d', 'Leo Santana', '37@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9c301d2486e33ad58c85db8e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:37@artist.com', 'mc0kipcekkltc6d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mc0kipcekkltc6d', 'Delivering soul-stirring tunes that linger in the mind.', 'Leo Santana');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zvdndx7vldcepsik68oa92y1tlktehgrm5dcez3o5dhzyrt77j','mc0kipcekkltc6d', 'https://i.scdn.co/image/ab67616d0000b273d5efcc40f158ae827c28eee9', 'Leo Santana Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j8zqixjw5tp71he69ekhvweyfj9o3gim1kngovimj5219918ra','Zona De Perigo','mc0kipcekkltc6d','POP','4lsQKByQ7m1o6oEKdrJycU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zvdndx7vldcepsik68oa92y1tlktehgrm5dcez3o5dhzyrt77j', 'j8zqixjw5tp71he69ekhvweyfj9o3gim1kngovimj5219918ra', '0');
-- Kordhell
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jh60cho6b8lv8mz', 'Kordhell', '38@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb15862815bf4d2446b8ecf55f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:38@artist.com', 'jh60cho6b8lv8mz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jh60cho6b8lv8mz', 'A tapestry of rhythms that echo the pulse of life.', 'Kordhell');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('md1ekdi64a23pyelh17sgsqa0zltg6h4mz6guag9lkjgz06kc3','jh60cho6b8lv8mz', 'https://i.scdn.co/image/ab67616d0000b2731440ffaa43c53d65719e0150', 'Kordhell Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z7zxzk1c2qjvnska2iy53eozqbo2wcr8u0a3wklid3ifo6kc9j','Murder In My Mind','jh60cho6b8lv8mz','POP','6qyS9qBy0mEk3qYaH8mPss','https://p.scdn.co/mp3-preview/ec3b94db31d9fb9821cfea0f7a4cdc9d2a85e969?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('md1ekdi64a23pyelh17sgsqa0zltg6h4mz6guag9lkjgz06kc3', 'z7zxzk1c2qjvnska2iy53eozqbo2wcr8u0a3wklid3ifo6kc9j', '0');
-- Loreen
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7xcnd5p7z5wetbl', 'Loreen', '39@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3ca2710f45c2993c415a1c5e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:39@artist.com', '7xcnd5p7z5wetbl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7xcnd5p7z5wetbl', 'Transcending language barriers through the universal language of music.', 'Loreen');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ogug6ua8sm71x0nfegwyr45m7aryub78d0ugob97junrgbzda1','7xcnd5p7z5wetbl', 'https://i.scdn.co/image/ab67616d0000b2732b0ba87db609976eee193bd6', 'Loreen Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jspw66hnvfxff58q4ow5pk8er3j06ivi2x2wl19j8gdlsizh1d','Tattoo','7xcnd5p7z5wetbl','POP','1DmW5Ep6ywYwxc2HMT5BG6',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ogug6ua8sm71x0nfegwyr45m7aryub78d0ugob97junrgbzda1', 'jspw66hnvfxff58q4ow5pk8er3j06ivi2x2wl19j8gdlsizh1d', '0');
-- Morgan Wallen
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ddwp47zueyi9tz6', 'Morgan Wallen', '40@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21ed0100a3a4e5aa3c57f6dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:40@artist.com', 'ddwp47zueyi9tz6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ddwp47zueyi9tz6', 'Blending country charm with rock energy to create memorable tunes.', 'Morgan Wallen');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bm9iey52l05qseq9ufa30mdrv8egmvjr5tb9j5glr741pehr0u','ddwp47zueyi9tz6', 'https://i.scdn.co/image/ab67616d0000b273705079df9a25a28b452c1fc9', 'Morgan Wallen Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zcw6vt6k6ze9864q4krwlgi1inaevkhdsje92vronxy2hohb6t','Last Night','ddwp47zueyi9tz6','POP','7K3BhSpAxZBznislvUMVtn',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bm9iey52l05qseq9ufa30mdrv8egmvjr5tb9j5glr741pehr0u', 'zcw6vt6k6ze9864q4krwlgi1inaevkhdsje92vronxy2hohb6t', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tlks3q66k29rtkticxiecwmgy4tn6wey8o0o620ybvkp0h0g25','You Proof','ddwp47zueyi9tz6','POP','5W4kiM2cUYBJXKRudNyxjW',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bm9iey52l05qseq9ufa30mdrv8egmvjr5tb9j5glr741pehr0u', 'tlks3q66k29rtkticxiecwmgy4tn6wey8o0o620ybvkp0h0g25', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c40067dv9zd9epsas1suj49nb6vql71ifndojgdi4bs6lbviil','One Thing At A Time','ddwp47zueyi9tz6','POP','1rXq0uoV4KTgRN64jXzIxo',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bm9iey52l05qseq9ufa30mdrv8egmvjr5tb9j5glr741pehr0u', 'c40067dv9zd9epsas1suj49nb6vql71ifndojgdi4bs6lbviil', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wdgny895aqyk7n5fdqnz7sfg48eu3um6jkxragifz58zrbhc5q','Aint Tha','ddwp47zueyi9tz6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bm9iey52l05qseq9ufa30mdrv8egmvjr5tb9j5glr741pehr0u', 'wdgny895aqyk7n5fdqnz7sfg48eu3um6jkxragifz58zrbhc5q', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rsnfo3todf9v0evmzzod6uzst0k2k7a0de1whsk60yr45vbphj','Thinkin B','ddwp47zueyi9tz6','POP','0PAcdVzhPO4gq1Iym9ESnK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bm9iey52l05qseq9ufa30mdrv8egmvjr5tb9j5glr741pehr0u', 'rsnfo3todf9v0evmzzod6uzst0k2k7a0de1whsk60yr45vbphj', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oah2aj6shx1a9mns9zy2gxpkxxuyiatw9ygaz737qxepnj1g59','Everything I Love','ddwp47zueyi9tz6','POP','03fs6oV5JAlbytRYf3371S',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bm9iey52l05qseq9ufa30mdrv8egmvjr5tb9j5glr741pehr0u', 'oah2aj6shx1a9mns9zy2gxpkxxuyiatw9ygaz737qxepnj1g59', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xpprkqgoffsfkl0cfdbzlrolk9f5bv5r9vhk89vap01r53zfsq','I Wrote The Book','ddwp47zueyi9tz6','POP','7phmBo7bB9I9YifAXqnlqV',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bm9iey52l05qseq9ufa30mdrv8egmvjr5tb9j5glr741pehr0u', 'xpprkqgoffsfkl0cfdbzlrolk9f5bv5r9vhk89vap01r53zfsq', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mq0jhz2umiij6tnrs4vipjil3h4bb5wf4hxc6glta8ty96mosd','Man Made A Bar (feat. Eric Church)','ddwp47zueyi9tz6','POP','73zawW1ttszLRgT9By826D',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bm9iey52l05qseq9ufa30mdrv8egmvjr5tb9j5glr741pehr0u', 'mq0jhz2umiij6tnrs4vipjil3h4bb5wf4hxc6glta8ty96mosd', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0tmq4i60wqfwjmtc2naxl4t7q7b41mqj7t20mrft1anv8f5eqs','98 Braves','ddwp47zueyi9tz6','POP','3oZ6dlSfCE9gZ55MGPJctc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bm9iey52l05qseq9ufa30mdrv8egmvjr5tb9j5glr741pehr0u', '0tmq4i60wqfwjmtc2naxl4t7q7b41mqj7t20mrft1anv8f5eqs', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('srfwe2oc4dsoij33vt619h61vhmxi4q8hei1ywkdj8e9etvhbo','Thought You Should Know','ddwp47zueyi9tz6','POP','3Qu3Zh4WTKhP9GEXo0aDnb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bm9iey52l05qseq9ufa30mdrv8egmvjr5tb9j5glr741pehr0u', 'srfwe2oc4dsoij33vt619h61vhmxi4q8hei1ywkdj8e9etvhbo', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4aby7lknr07f85dk4nzz1570mr3r9vsth1u9a95q2gcnhnha9w','Born With A Beer In My Hand','ddwp47zueyi9tz6','POP','1BAU6v0fuAV914qMUEESR1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bm9iey52l05qseq9ufa30mdrv8egmvjr5tb9j5glr741pehr0u', '4aby7lknr07f85dk4nzz1570mr3r9vsth1u9a95q2gcnhnha9w', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ucv5aicspdf05sqv9n99bw3zp49kc4k2l4mz3v63o076hwl6qr','Devil Don','ddwp47zueyi9tz6','POP','2PsbT927UanvyH9VprlNOu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bm9iey52l05qseq9ufa30mdrv8egmvjr5tb9j5glr741pehr0u', 'ucv5aicspdf05sqv9n99bw3zp49kc4k2l4mz3v63o076hwl6qr', '11');
-- Mc Livinho
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jdxqo5m67ep7bln', 'Mc Livinho', '41@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd353ef9564cfbb5f2b3bffb2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:41@artist.com', 'jdxqo5m67ep7bln', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jdxqo5m67ep7bln', 'Bringing Brazilian funk rhythms to the global music stage.', 'Mc Livinho');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5cfrbgwclgftx3wcwg1cb9k6kgn3rekm80ks1d32dpeio5b7w6','jdxqo5m67ep7bln', 'https://i.scdn.co/image/ab67616d0000b273369c960fed23353176da1218', 'Mc Livinho Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mhbojwfxqp43f39dw41m9wq8vxqqdkdjrjop066qk1b0ex3ttx','Novidade na ','jdxqo5m67ep7bln','POP','2uhw2oYbugGJbn10wipNX5','https://p.scdn.co/mp3-preview/6bff8c1079d87a672d6b9ee5c3c6ca5e7d9ff45b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5cfrbgwclgftx3wcwg1cb9k6kgn3rekm80ks1d32dpeio5b7w6', 'mhbojwfxqp43f39dw41m9wq8vxqqdkdjrjop066qk1b0ex3ttx', '0');
-- David Guetta
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j273c2iaw1pb1n3', 'David Guetta', '42@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:42@artist.com', 'j273c2iaw1pb1n3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j273c2iaw1pb1n3', 'A legend in the electronic music world, constantly innovating and entertaining.', 'David Guetta');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bfd3j5pfaessgfl5djtut1lcvpofdqigu1xqnw2mxvyb9ai983','j273c2iaw1pb1n3', 'https://i.scdn.co/image/ab67616d0000b2730b4ef75c3728599aa4104f7a', 'David Guetta Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jugimwmkfhiqh377qw6u7hbxonbaz9uezdhzt42z8jkwlxf14y','Baby Dont Hurt Me','j273c2iaw1pb1n3','POP','3BKD1PwArikchz2Zrlp1qi','https://p.scdn.co/mp3-preview/a8f2e176e17e0f6298b42ef8e96118318fdd2b89?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bfd3j5pfaessgfl5djtut1lcvpofdqigu1xqnw2mxvyb9ai983', 'jugimwmkfhiqh377qw6u7hbxonbaz9uezdhzt42z8jkwlxf14y', '0');
-- Peso Pluma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y2lw9wlh2ot43a1', 'Peso Pluma', '43@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:43@artist.com', 'y2lw9wlh2ot43a1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y2lw9wlh2ot43a1', 'Infusing music with energetic beats and captivating lyrics.', 'Peso Pluma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x8t35qk0m0z66wi6c5rclurb5jxk71pe0y7l15qx733rfhbh4o','y2lw9wlh2ot43a1', NULL, 'Peso Pluma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jylzha3h4v7t7p0tlvf462uns7n862wypelj82b8o7e517815j','La Bebe - Remix','y2lw9wlh2ot43a1','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x8t35qk0m0z66wi6c5rclurb5jxk71pe0y7l15qx733rfhbh4o', 'jylzha3h4v7t7p0tlvf462uns7n862wypelj82b8o7e517815j', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('50i1u5o6tvhd53z91w3wed0jorm4auencw5ez47kqovw023g3e','TULUM','y2lw9wlh2ot43a1','POP','7bPp2NmpmyhLJ7zWazAXMu','https://p.scdn.co/mp3-preview/164468e67b8da8053036c68533ffa473ab680c51?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x8t35qk0m0z66wi6c5rclurb5jxk71pe0y7l15qx733rfhbh4o', '50i1u5o6tvhd53z91w3wed0jorm4auencw5ez47kqovw023g3e', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lnn7zopu6qd4x2adan4z0ovuksygtmyl0xzsb8fp9q3flpkiyv','Por las Noches','y2lw9wlh2ot43a1','POP','2VzCjpKvPB1l1tqLndtAQa','https://p.scdn.co/mp3-preview/ba2f667c373e2d12343ac00b162886caca060c93?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x8t35qk0m0z66wi6c5rclurb5jxk71pe0y7l15qx733rfhbh4o', 'lnn7zopu6qd4x2adan4z0ovuksygtmyl0xzsb8fp9q3flpkiyv', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qgglzne052bhqdq5055dz3l4anbfje2mfxcevtle26yzc1xgz6','Bye','y2lw9wlh2ot43a1','POP','6n2P81rPk2RTzwnNNgFOdb','https://p.scdn.co/mp3-preview/94ef6a9f37e088fff4b37e098a46561e74dab95b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x8t35qk0m0z66wi6c5rclurb5jxk71pe0y7l15qx733rfhbh4o', 'qgglzne052bhqdq5055dz3l4anbfje2mfxcevtle26yzc1xgz6', '3');
-- Jasiel Nuez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mfhj0c5awqtolqn', 'Jasiel Nuez', '44@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:44@artist.com', 'mfhj0c5awqtolqn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mfhj0c5awqtolqn', 'A visionary in the world of music, redefining genres.', 'Jasiel Nuez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4fhn5ix0intgakib76bm8m0e5hgb4jiys5k4nd8vex5737p8vl','mfhj0c5awqtolqn', NULL, 'Jasiel Nuez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l6h6gaqzz2hm7hz8e6lt0590htsy4r9l7qozb61c4wv9oqk45l','LAGUNAS','mfhj0c5awqtolqn','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4fhn5ix0intgakib76bm8m0e5hgb4jiys5k4nd8vex5737p8vl', 'l6h6gaqzz2hm7hz8e6lt0590htsy4r9l7qozb61c4wv9oqk45l', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9hyjv7xuudbzy9z46s8jiv0ixyghl7f1gsr24anpvs15jczso1','Rosa Pastel','mfhj0c5awqtolqn','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4fhn5ix0intgakib76bm8m0e5hgb4jiys5k4nd8vex5737p8vl', '9hyjv7xuudbzy9z46s8jiv0ixyghl7f1gsr24anpvs15jczso1', '1');
-- Tears For Fears
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b4ls6x7ljzujmnt', 'Tears For Fears', '45@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb42ed2cb48c231f545a5a3dad','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:45@artist.com', 'b4ls6x7ljzujmnt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b4ls6x7ljzujmnt', 'A sonic adventurer, always seeking new horizons in music.', 'Tears For Fears');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gxitzzod338qrem52cy50p4skdhavkqxv2ucoobw0waxn548at','b4ls6x7ljzujmnt', 'https://i.scdn.co/image/ab67616d0000b27322463d6939fec9e17b2a6235', 'Tears For Fears Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xij2q5u2j1n43zuv0bvy72smlz6yxe08xzb2cbe91vi8u0s4ey','Everybody Wants To Rule The World','b4ls6x7ljzujmnt','POP','4RvWPyQ5RL0ao9LPZeSouE',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gxitzzod338qrem52cy50p4skdhavkqxv2ucoobw0waxn548at', 'xij2q5u2j1n43zuv0bvy72smlz6yxe08xzb2cbe91vi8u0s4ey', '0');
-- Marshmello
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wqu3yyoq7ws71n4', 'Marshmello', '46@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41e4a3b8c1d45a9e49b6de21','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:46@artist.com', 'wqu3yyoq7ws71n4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wqu3yyoq7ws71n4', 'An electronic music maestro known for his infectious beats.', 'Marshmello');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('p7yjjflzn0p1x6z8qtz3nerzcmvxo36ko10b78030pkftd9p6u','wqu3yyoq7ws71n4', 'https://i.scdn.co/image/ab67616d0000b273f404676577626a87d92cf33f', 'Marshmello Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dtcqvq6clw4xya1fgwem3gytrdx5v49ci5g2wjlldfokqdu0g1','El Merengue','wqu3yyoq7ws71n4','POP','51FvjPEGKq2zByeeEQ43V9','https://p.scdn.co/mp3-preview/a933b6e1d6a47e591c13192f2b5e58739d3d5a06?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p7yjjflzn0p1x6z8qtz3nerzcmvxo36ko10b78030pkftd9p6u', 'dtcqvq6clw4xya1fgwem3gytrdx5v49ci5g2wjlldfokqdu0g1', '0');
-- Rma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d9wefvm8dobfapt', 'Rma', '47@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3b8f6208d84e28f63841e43c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:47@artist.com', 'd9wefvm8dobfapt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('d9wefvm8dobfapt', 'Pioneering new sounds and delivering electrifying performances.', 'Rma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mlr2t6tibnj7o1h397etzo037tr9qf98ckturvuiaugydwndv4','d9wefvm8dobfapt', NULL, 'Rma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2x2tsm5od51drgcimlleppz9x9q08wkt1qt20t6gu4wknol8go','Calm Down (with Selena Gomez)','d9wefvm8dobfapt','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mlr2t6tibnj7o1h397etzo037tr9qf98ckturvuiaugydwndv4', '2x2tsm5od51drgcimlleppz9x9q08wkt1qt20t6gu4wknol8go', '0');
-- James Arthur
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u04u90whzwhlgyn', 'James Arthur', '48@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2a0c6d0343c82be9dd6fce0b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:48@artist.com', 'u04u90whzwhlgyn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u04u90whzwhlgyn', 'The architect of aural landscapes that inspire and captivate.', 'James Arthur');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qfvbtyejpwwor10yvk023br4i831j7udbbwp8uhqsjhezgc074','u04u90whzwhlgyn', 'https://i.scdn.co/image/ab67616d0000b273dc16d839ab77c64bdbeb3660', 'James Arthur Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('71jfori8mnn1c6rl60fhpnrmemftx3swrh5j1nk7p0t5d3jwwm','Cars Outside','u04u90whzwhlgyn','POP','0otRX6Z89qKkHkQ9OqJpKt','https://p.scdn.co/mp3-preview/cfaa30729da8d2d8965fae154b6e9d0964a2ea6b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qfvbtyejpwwor10yvk023br4i831j7udbbwp8uhqsjhezgc074', '71jfori8mnn1c6rl60fhpnrmemftx3swrh5j1nk7p0t5d3jwwm', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y25ka5hxoxv2bmjndu8b9y7tupalgd1oiskdf1c4krwioiuysn','Say You Wont Let Go','u04u90whzwhlgyn','POP','5uCax9HTNlzGybIStD3vDh','https://p.scdn.co/mp3-preview/2eed95a3c08cd10669768ce60d1140f85ba8b951?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qfvbtyejpwwor10yvk023br4i831j7udbbwp8uhqsjhezgc074', 'y25ka5hxoxv2bmjndu8b9y7tupalgd1oiskdf1c4krwioiuysn', '1');
-- Hozier
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x6h9fldjoyd1h2a', 'Hozier', '49@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad85a585103dfc2f3439119a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:49@artist.com', 'x6h9fldjoyd1h2a', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x6h9fldjoyd1h2a', 'Melodies that capture the essence of human emotion.', 'Hozier');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9kzn2oyqrbwmzub1yawnck5ctlggvdhpft6y1z68v8usu5d8sf','x6h9fldjoyd1h2a', 'https://i.scdn.co/image/ab67616d0000b2734ca68d59a4a29c856a4a39c2', 'Hozier Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('16sqp0yw9b49ltn77l6bw4snm2ma087hcbyf5uj2uj0fzleuvo','Take Me To Church','x6h9fldjoyd1h2a','POP','1CS7Sd1u5tWkstBhpssyjP','https://p.scdn.co/mp3-preview/d6170162e349338277c97d2fab42c386701a4089?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9kzn2oyqrbwmzub1yawnck5ctlggvdhpft6y1z68v8usu5d8sf', '16sqp0yw9b49ltn77l6bw4snm2ma087hcbyf5uj2uj0fzleuvo', '0');
-- Ozuna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ge5phe0mp1d3pco', 'Ozuna', '50@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd45efec1d439cfd8bd936421','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:50@artist.com', 'ge5phe0mp1d3pco', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ge5phe0mp1d3pco', 'Dominating reggaeton and Latin trap with catchy tunes and charismatic energy.', 'Ozuna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mdh9t3xrkgnr81dk4obcv5ctqwvzeqrmxho6mrtntmdkiybg7i','ge5phe0mp1d3pco', 'https://i.scdn.co/image/ab67616d0000b273125624f2e04f5a1ccb0dfb45', 'Ozuna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zigr4x5m2mi6ezd5e0c9l096il6azm3j8gg0ptee9j5gyjsr0v','Hey Mor','ge5phe0mp1d3pco','POP','1zsPaEkglFvxjAhrM8yhpr','https://p.scdn.co/mp3-preview/cd2d2242b748408da15c2b66f47d54b3f0793ae0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mdh9t3xrkgnr81dk4obcv5ctqwvzeqrmxho6mrtntmdkiybg7i', 'zigr4x5m2mi6ezd5e0c9l096il6azm3j8gg0ptee9j5gyjsr0v', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ut5pcs3kel3wonp6jhvc3i6i8nz235q7cvxu48ska1tfiiry3q','Monoton','ge5phe0mp1d3pco','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mdh9t3xrkgnr81dk4obcv5ctqwvzeqrmxho6mrtntmdkiybg7i', 'ut5pcs3kel3wonp6jhvc3i6i8nz235q7cvxu48ska1tfiiry3q', '1');
-- Sia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('iasmd3qlk7xujjy', 'Sia', '51@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb25a749000611559f1719cc5f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:51@artist.com', 'iasmd3qlk7xujjy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('iasmd3qlk7xujjy', 'Crafting a unique sonic identity in every track.', 'Sia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ioxkw8oactr8yuq93ygdv4ajtjelk9efhsv8nb2hkuxurvvd7b','iasmd3qlk7xujjy', 'https://i.scdn.co/image/ab67616d0000b273754b2fddebe7039fdb912837', 'Sia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('24kq2azz7qzuhj88mqi89pds1sjb67se82rc64auwpzntstr4m','Unstoppable','iasmd3qlk7xujjy','POP','1yvMUkIOTeUNtNWlWRgANS','https://p.scdn.co/mp3-preview/99a07d00531c0053f55a46e94ed92b1560396754?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ioxkw8oactr8yuq93ygdv4ajtjelk9efhsv8nb2hkuxurvvd7b', '24kq2azz7qzuhj88mqi89pds1sjb67se82rc64auwpzntstr4m', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hmewk4plbx4w43dtph927ramrdzq0wxm5pvy45ew3aovtg9ymc','Snowman','iasmd3qlk7xujjy','POP','7uoFMmxln0GPXQ0AcCBXRq','https://p.scdn.co/mp3-preview/a936030efc27a4fc52d8c42b20d03ca4cab30836?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ioxkw8oactr8yuq93ygdv4ajtjelk9efhsv8nb2hkuxurvvd7b', 'hmewk4plbx4w43dtph927ramrdzq0wxm5pvy45ew3aovtg9ymc', '1');
-- Post Malone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gmrjat02473i5or', 'Post Malone', '52@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:52@artist.com', 'gmrjat02473i5or', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gmrjat02473i5or', 'Blurring genre lines with his unique blend of hip-hop and pop.', 'Post Malone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ergzt7m3rxyy8f1dnbasa7a8yzb227ka6ht9o0qgdj5wpm5xbv','gmrjat02473i5or', 'https://i.scdn.co/image/ab67616d0000b2739478c87599550dd73bfa7e02', 'Post Malone Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('atkdip0ctrrztm1j81xz3rolhwurpt7dac6h4kd6ydq5tvp8l2','Sunflower - Spider-Man: Into the Spider-Verse','gmrjat02473i5or','POP','0RiRZpuVRbi7oqRdSMwhQY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ergzt7m3rxyy8f1dnbasa7a8yzb227ka6ht9o0qgdj5wpm5xbv', 'atkdip0ctrrztm1j81xz3rolhwurpt7dac6h4kd6ydq5tvp8l2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r4i0lkicshzkwl4tvjar7ueujsbhkvandaqghyxzj37q7j6qzz','Overdrive','gmrjat02473i5or','POP','3t0ic4mkhvhamrKDkulB8v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ergzt7m3rxyy8f1dnbasa7a8yzb227ka6ht9o0qgdj5wpm5xbv', 'r4i0lkicshzkwl4tvjar7ueujsbhkvandaqghyxzj37q7j6qzz', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zfxc1gwg9y1whgxfgacnqt1m1k8gdjoen6ul4m1vkx12ydor8m','Chemical','gmrjat02473i5or','POP','5w40ZYhbBMAlHYNDaVJIUu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ergzt7m3rxyy8f1dnbasa7a8yzb227ka6ht9o0qgdj5wpm5xbv', 'zfxc1gwg9y1whgxfgacnqt1m1k8gdjoen6ul4m1vkx12ydor8m', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uzyhf35s4cqkql06pnjidne3ikp8m8jalvjpo060m5a0rsw9c2','Circles','gmrjat02473i5or','POP','21jGcNKet2qwijlDFuPiPb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ergzt7m3rxyy8f1dnbasa7a8yzb227ka6ht9o0qgdj5wpm5xbv', 'uzyhf35s4cqkql06pnjidne3ikp8m8jalvjpo060m5a0rsw9c2', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cicq34rpu6fr79in0gqg872dplyya9i4pibyvqchf2ippl8fq8','I Like You (A Happier Song) (with Doja Cat)','gmrjat02473i5or','POP','0O6u0VJ46W86TxN9wgyqDj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ergzt7m3rxyy8f1dnbasa7a8yzb227ka6ht9o0qgdj5wpm5xbv', 'cicq34rpu6fr79in0gqg872dplyya9i4pibyvqchf2ippl8fq8', '4');
-- Calvin Harris
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1p8n5dyofsirlz7', 'Calvin Harris', '53@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb37bff6aa1d42bede9048750f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:53@artist.com', '1p8n5dyofsirlz7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1p8n5dyofsirlz7', 'A unique voice in the contemporary music scene.', 'Calvin Harris');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0bae8yoml9p0jw9nvr7mxd7t8ev5au2wmwzz1fe8q6yi8s3d8d','1p8n5dyofsirlz7', 'https://i.scdn.co/image/ab67616d0000b273c58e22815048f8dfb1aa8bd0', 'Calvin Harris Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0aq6ge8mjkbtt5c3b0m1yq6og3dq4m8z9phjpr8e1kl8krnewy','Miracle (with Ellie Goulding)','1p8n5dyofsirlz7','POP','5eTaQYBE1yrActixMAeLcZ','https://p.scdn.co/mp3-preview/48a88093bc85e735791115290125fc354f8ed068?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0bae8yoml9p0jw9nvr7mxd7t8ev5au2wmwzz1fe8q6yi8s3d8d', '0aq6ge8mjkbtt5c3b0m1yq6og3dq4m8z9phjpr8e1kl8krnewy', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4sdaggeb290k1jr95fewqtq399wvzs3voamjm430wyv37nere0','One Kiss (with Dua Lipa)','1p8n5dyofsirlz7','POP','7ef4DlsgrMEH11cDZd32M6','https://p.scdn.co/mp3-preview/0c09da1fe6f1da091c05057835e6be2312e2dc18?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0bae8yoml9p0jw9nvr7mxd7t8ev5au2wmwzz1fe8q6yi8s3d8d', '4sdaggeb290k1jr95fewqtq399wvzs3voamjm430wyv37nere0', '1');
-- Stray Kids
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('flqhp1awniibujf', 'Stray Kids', '54@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0610877c41cb9cc12ad39cc0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:54@artist.com', 'flqhp1awniibujf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('flqhp1awniibujf', 'Melodies that capture the essence of human emotion.', 'Stray Kids');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('k2xq1aau23hw9dclt3tjsrtyn1kvp7dseqmibl5th4wr9j7vin','flqhp1awniibujf', 'https://i.scdn.co/image/ab67616d0000b273e27ba26bc14a563bf3d09882', 'Stray Kids Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jiebc4z4e79rme3c6kpo9ldnxnav0yr8c88u40vr2lemgo154z','S-Class','flqhp1awniibujf','POP','3gTQwwDNJ42CCLo3Sf4JDd','https://p.scdn.co/mp3-preview/4ea586fdcc2c9aec34a18d2034d1dec78a3b5e25?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k2xq1aau23hw9dclt3tjsrtyn1kvp7dseqmibl5th4wr9j7vin', 'jiebc4z4e79rme3c6kpo9ldnxnav0yr8c88u40vr2lemgo154z', '0');
-- Baby Rasta
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9hvrq5aeo6zqqrb', 'Baby Rasta', '55@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb18f9c5cb23e65bd55af69f24','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:55@artist.com', '9hvrq5aeo6zqqrb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9hvrq5aeo6zqqrb', 'Revolutionizing the music scene with innovative compositions.', 'Baby Rasta');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kmvajeycn4xup2t7cgnc0jbg5edw05i5hpwhhlnj6zccd8um88','9hvrq5aeo6zqqrb', NULL, 'Baby Rasta Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aoyw2am57v2k4fpgtiu0c5vmi82utcs431yybmw7rf3qaaqdqs','PUNTO 40','9hvrq5aeo6zqqrb','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kmvajeycn4xup2t7cgnc0jbg5edw05i5hpwhhlnj6zccd8um88', 'aoyw2am57v2k4fpgtiu0c5vmi82utcs431yybmw7rf3qaaqdqs', '0');
-- Bizarrap
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uh9dj0io31g60tt', 'Bizarrap', '56@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:56@artist.com', 'uh9dj0io31g60tt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uh9dj0io31g60tt', 'Revolutionizing the music scene with his unique production style and collaborations.', 'Bizarrap');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g3of7577cjamdcydsjjxe9bcx41xgjru4171byopbrogke8022','uh9dj0io31g60tt', 'https://i.scdn.co/image/ab67616d0000b27315583045b2fdb7d7bab10e81', 'Bizarrap Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n1u8i4yvec1fljgnewcbj6tebcmrg17ay1hrer6qs20tnbg7dq','Peso Pluma: Bzrp Music Sessions, Vol. 55','uh9dj0io31g60tt','POP','5AqiaZwhmC6dIbgWrD5SzV','https://p.scdn.co/mp3-preview/9d61998a29c2e8b52a7d46885352f5507eb219e2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g3of7577cjamdcydsjjxe9bcx41xgjru4171byopbrogke8022', 'n1u8i4yvec1fljgnewcbj6tebcmrg17ay1hrer6qs20tnbg7dq', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zdthagrhsb9nan6tthnmglq067a5ookfh56mswg0d114ah3x7k','Quevedo: Bzrp Music Sessions, Vol. 52','uh9dj0io31g60tt','POP','2tTmW7RDtMQtBk7m2rYeSw','https://p.scdn.co/mp3-preview/e9c0ed735e611f6af45bc946bd4c31590df09ed6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g3of7577cjamdcydsjjxe9bcx41xgjru4171byopbrogke8022', 'zdthagrhsb9nan6tthnmglq067a5ookfh56mswg0d114ah3x7k', '1');
-- Future
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rg3h9su4ru3mwgm', 'Future', '57@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:57@artist.com', 'rg3h9su4ru3mwgm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rg3h9su4ru3mwgm', 'A confluence of cultural beats and contemporary tunes.', 'Future');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7vnay3hx5ewli9qlbnoesxbvk8rb79kfbol2urd88002zgdp9o','rg3h9su4ru3mwgm', NULL, 'Future Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z61nzfr2oqi22ie8jrduzep05kbsbdbrf0li4eakldki2i4b7v','Too Many Nights (feat. Don Toliver & with Future)','rg3h9su4ru3mwgm','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7vnay3hx5ewli9qlbnoesxbvk8rb79kfbol2urd88002zgdp9o', 'z61nzfr2oqi22ie8jrduzep05kbsbdbrf0li4eakldki2i4b7v', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ozw61oabfrles4c829j703wkkzha8g8ajungagon806u9cwe70','All The Way Live (Spider-Man: Across the Spider-Verse) (Metro Boomin & Future, Lil Uzi Vert)','rg3h9su4ru3mwgm','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7vnay3hx5ewli9qlbnoesxbvk8rb79kfbol2urd88002zgdp9o', 'ozw61oabfrles4c829j703wkkzha8g8ajungagon806u9cwe70', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fd41v85xqpnnm9eeehn7avswketycvm2hut6d2ttvmpeu5ys4p','Superhero (Heroes & Villains) [with Future & Chris Brown]','rg3h9su4ru3mwgm','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7vnay3hx5ewli9qlbnoesxbvk8rb79kfbol2urd88002zgdp9o', 'fd41v85xqpnnm9eeehn7avswketycvm2hut6d2ttvmpeu5ys4p', '2');
-- sped up nightcore
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('35nfaklz97s1c66', 'sped up nightcore', '58@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebbf73929f8c684fed7af7e767','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:58@artist.com', '35nfaklz97s1c66', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('35nfaklz97s1c66', 'Music is my canvas, and notes are my paint.', 'sped up nightcore');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('46l1w30lal65cczjmw95k2hi72t4yjp4hfkige0n20wpy7zly6','35nfaklz97s1c66', NULL, 'sped up nightcore Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rqdgu0ug6gbzpb3pzn8ykvv0ezw4xkyazm4fzg9l78d3n0wflo','Watch This - ARIZONATEARS Pluggnb Remix','35nfaklz97s1c66','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('46l1w30lal65cczjmw95k2hi72t4yjp4hfkige0n20wpy7zly6', 'rqdgu0ug6gbzpb3pzn8ykvv0ezw4xkyazm4fzg9l78d3n0wflo', '0');
-- Adele
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ryd8gevdv3tfzmn', 'Adele', '59@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68f6e5892075d7f22615bd17','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:59@artist.com', 'ryd8gevdv3tfzmn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ryd8gevdv3tfzmn', 'A maestro of melodies, orchestrating auditory bliss.', 'Adele');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g599hrlvamfyx4da4n894i23gzv8xema95e5ebquudyw0zjx5a','ryd8gevdv3tfzmn', 'https://i.scdn.co/image/ab67616d0000b2732118bf9b198b05a95ded6300', 'Adele Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vlyfje8xju7h76l9h330wslksrzb9b9cp6sftvf69nnpe3szog','Set Fire to the Rain','ryd8gevdv3tfzmn','POP','73CMRj62VK8nUS4ezD2wvi','https://p.scdn.co/mp3-preview/6fc68c105e091645376471727960d2ba3cd0ee01?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g599hrlvamfyx4da4n894i23gzv8xema95e5ebquudyw0zjx5a', 'vlyfje8xju7h76l9h330wslksrzb9b9cp6sftvf69nnpe3szog', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n56i7ee6guvqvt8ztyj0fquz1xlb57df1c0k2pzstmgbmhc6q5','Easy On Me','ryd8gevdv3tfzmn','POP','46IZ0fSY2mpAiktS3KOqds','https://p.scdn.co/mp3-preview/a0cd8077c79a4aa3dcaa68bbc5ecdeda46e8d13f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g599hrlvamfyx4da4n894i23gzv8xema95e5ebquudyw0zjx5a', 'n56i7ee6guvqvt8ztyj0fquz1xlb57df1c0k2pzstmgbmhc6q5', '1');
-- Sog
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s55td8vxf3f7vt2', 'Sog', '60@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:60@artist.com', 's55td8vxf3f7vt2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s55td8vxf3f7vt2', 'Sculpting soundwaves into masterpieces of auditory art.', 'Sog');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('f3901r9aq16eyjoaupliz1yym3gu3b2n9nhhfqtl6xhcs6hp3m','s55td8vxf3f7vt2', NULL, 'Sog Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lsq1lk7ciifpj8q3bttwsw1ly0e7sqkn1ycx670ymn52a2minc','QUEMA','s55td8vxf3f7vt2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f3901r9aq16eyjoaupliz1yym3gu3b2n9nhhfqtl6xhcs6hp3m', 'lsq1lk7ciifpj8q3bttwsw1ly0e7sqkn1ycx670ymn52a2minc', '0');
-- Kendrick Lamar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('35g6p1pl8rrfhuk', 'Kendrick Lamar', '61@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb52696416126917a827b514d2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:61@artist.com', '35g6p1pl8rrfhuk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('35g6p1pl8rrfhuk', 'The architect of aural landscapes that inspire and captivate.', 'Kendrick Lamar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('32ys8p1pmkprw4v3kodz4465xm4d27rg2q0miexz7jwtdq1y0d','35g6p1pl8rrfhuk', 'https://i.scdn.co/image/ab67616d0000b273d28d2ebdedb220e479743797', 'Kendrick Lamar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pgreemwv8od5a1oyhh1vhzzkw1k0vrss0l3toq2poo21g9l0c4','Money Trees','35g6p1pl8rrfhuk','POP','2HbKqm4o0w5wEeEFXm2sD4',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('32ys8p1pmkprw4v3kodz4465xm4d27rg2q0miexz7jwtdq1y0d', 'pgreemwv8od5a1oyhh1vhzzkw1k0vrss0l3toq2poo21g9l0c4', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2sn9jjav2xuojyzxt794y8o3q1i75ap4caf4n5ts5xr06jurdn','AMERICA HAS A PROBLEM (feat. Kendrick Lamar)','35g6p1pl8rrfhuk','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('32ys8p1pmkprw4v3kodz4465xm4d27rg2q0miexz7jwtdq1y0d', '2sn9jjav2xuojyzxt794y8o3q1i75ap4caf4n5ts5xr06jurdn', '1');
-- Nicki Minaj
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3uul068m0siur3j', 'Nicki Minaj', '62@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03578c92e15089c645b794f5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:62@artist.com', '3uul068m0siur3j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3uul068m0siur3j', 'A rap icon known for her versatile flow and bold personality.', 'Nicki Minaj');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('h3iqmc99kq56751a5kvsx7b8760kd5bnpe0pnwyewqokqwznz0','3uul068m0siur3j', 'https://i.scdn.co/image/ab67616d0000b2737e8f938c02fac3b564931116', 'Nicki Minaj Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pvmncwhzqzj48drprbifdqqjzo8j3wfomuymlks929nqhfdold','Barbie World (with Aqua) [From Barbie The Album]','3uul068m0siur3j','POP','741UUVE2kuITl0c6zuqqbO','https://p.scdn.co/mp3-preview/f654928ccaa4e6a9fb09a6eb3f208383eccc12a9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h3iqmc99kq56751a5kvsx7b8760kd5bnpe0pnwyewqokqwznz0', 'pvmncwhzqzj48drprbifdqqjzo8j3wfomuymlks929nqhfdold', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4ahxlayfza4r0qs290gqrzkq2kgoq892j83ce4gypupsdxp5w0','Princess Diana (with Nicki Minaj)','3uul068m0siur3j','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h3iqmc99kq56751a5kvsx7b8760kd5bnpe0pnwyewqokqwznz0', '4ahxlayfza4r0qs290gqrzkq2kgoq892j83ce4gypupsdxp5w0', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nyiq27y3fgmyan8poag54i4c2k1k9mamuno5jnrrv4chaqjpr5','Red Ruby Da Sleeze','3uul068m0siur3j','POP','4ZYAU4A2YBtlNdqOUtc7T2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h3iqmc99kq56751a5kvsx7b8760kd5bnpe0pnwyewqokqwznz0', 'nyiq27y3fgmyan8poag54i4c2k1k9mamuno5jnrrv4chaqjpr5', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xwxh8nijefwtsdyvkn57aw15q80eqexqndjox709on42g7j6j3','Super Freaky Girl','3uul068m0siur3j','POP','4C6Uex2ILwJi9sZXRdmqXp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h3iqmc99kq56751a5kvsx7b8760kd5bnpe0pnwyewqokqwznz0', 'xwxh8nijefwtsdyvkn57aw15q80eqexqndjox709on42g7j6j3', '3');
-- JISOO
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7b9eterkmen1k4m', 'JISOO', '63@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcb6017286dd64ca6b77c879f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:63@artist.com', '7b9eterkmen1k4m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7b9eterkmen1k4m', 'Transcending language barriers through the universal language of music.', 'JISOO');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g7y10s85e1ayhwmznkfvffjrtfgq7yiet3zcy3vceovsv9vcin','7b9eterkmen1k4m', 'https://i.scdn.co/image/ab67616d0000b273f35b8a6c03cc633f734bd8ac', 'JISOO Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mfhs4rdsu0y20s1ecjhhb202hvb3yfbrlm1rv4ub88rv3qgviz','FLOWER','7b9eterkmen1k4m','POP','69CrOS7vEHIrhC2ILyEi0s',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g7y10s85e1ayhwmznkfvffjrtfgq7yiet3zcy3vceovsv9vcin', 'mfhs4rdsu0y20s1ecjhhb202hvb3yfbrlm1rv4ub88rv3qgviz', '0');
-- Shubh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('a0wc67qtxn33raq', 'Shubh', '64@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3eac18e003a215ce96654ce1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:64@artist.com', 'a0wc67qtxn33raq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('a0wc67qtxn33raq', 'A sonic adventurer, always seeking new horizons in music.', 'Shubh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tc4wpx8gjta9y5i23n0wig8uu6rza6jhoivrr70m35x7nlaa8j','a0wc67qtxn33raq', 'https://i.scdn.co/image/ab67616d0000b2731a8c4618eda885a406958dd0', 'Shubh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nt7hhvf70l9p0cb4d3w87gmzyiu2q8tybpir8p3cfp6yfv4b32','Cheques','a0wc67qtxn33raq','POP','4eBvRhTJ2AcxCsbfTUjoRp','https://p.scdn.co/mp3-preview/c607b777f851d56dd524f845957e24901adbf1eb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tc4wpx8gjta9y5i23n0wig8uu6rza6jhoivrr70m35x7nlaa8j', 'nt7hhvf70l9p0cb4d3w87gmzyiu2q8tybpir8p3cfp6yfv4b32', '0');
-- Halsey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('iuv4wepqj1zypjs', 'Halsey', '65@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd707e1c5177614c4ec95a06c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:65@artist.com', 'iuv4wepqj1zypjs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('iuv4wepqj1zypjs', 'Igniting the stage with electrifying performances.', 'Halsey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('eqe5jp477vcc1yx7qncxo88bi70qxv78zk95p7lmfp5938khve','iuv4wepqj1zypjs', 'https://i.scdn.co/image/ab67616d0000b273f19310c007c0fad365b0542e', 'Halsey Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ft3na1hctkjl2zvlnr9yq6eidbhpe8msjevirg7g1titjazt6s','Lilith (feat. SUGA of BTS) (Diablo IV Anthem)','iuv4wepqj1zypjs','POP','3l6LBCOL9nPsSY29TUY2VE',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eqe5jp477vcc1yx7qncxo88bi70qxv78zk95p7lmfp5938khve', 'ft3na1hctkjl2zvlnr9yq6eidbhpe8msjevirg7g1titjazt6s', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xsrhj4e2t86eujvos8rmhsbrdru64e3cynel5ybiuh18a79nut','Boy With Luv (feat. Halsey)','iuv4wepqj1zypjs','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eqe5jp477vcc1yx7qncxo88bi70qxv78zk95p7lmfp5938khve', 'xsrhj4e2t86eujvos8rmhsbrdru64e3cynel5ybiuh18a79nut', '1');
-- Ayparia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sb1zisdoegws5l4', 'Ayparia', '66@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebff258a75f7364baaaf9ed011','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:66@artist.com', 'sb1zisdoegws5l4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sb1zisdoegws5l4', 'Delivering a unique blend of sounds, showcasing versatility and artistic depth.', 'Ayparia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4qqanj3q3xdkh4dn8nsq1q0g0qva07qihflmipxo8411xz2suw','sb1zisdoegws5l4', NULL, 'Ayparia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ycc0g2fgys9iiveuf5jka7jwd9min95zk0muashbqojbe29lhm','MONTAGEM - FR PUNK','sb1zisdoegws5l4','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4qqanj3q3xdkh4dn8nsq1q0g0qva07qihflmipxo8411xz2suw', 'ycc0g2fgys9iiveuf5jka7jwd9min95zk0muashbqojbe29lhm', '0');
-- Hotel Ugly
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3uocnmx2vjpnd3y', 'Hotel Ugly', '67@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb939033cc36c08ab68b33f760','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:67@artist.com', '3uocnmx2vjpnd3y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3uocnmx2vjpnd3y', 'Delivering soul-stirring tunes that linger in the mind.', 'Hotel Ugly');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('m3gnqgrn3gnb3y804pwp4bhs93ea9z16ahulysmwf5rp1a1dgj','3uocnmx2vjpnd3y', 'https://i.scdn.co/image/ab67616d0000b273350ab7a839c04bfd5225a9f5', 'Hotel Ugly Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('obty1cazf9zhbx4s1nkgi0623a4qcm06tohfd8tv6hm27ufmzp','Shut up My Moms Calling','3uocnmx2vjpnd3y','POP','3hxIUxnT27p5WcmjGUXNwx','https://p.scdn.co/mp3-preview/7642409265c74b714a2f0f0dd8663c031e253485?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m3gnqgrn3gnb3y804pwp4bhs93ea9z16ahulysmwf5rp1a1dgj', 'obty1cazf9zhbx4s1nkgi0623a4qcm06tohfd8tv6hm27ufmzp', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qphd10rcm849peequq3vrbpuf56i7xju8lv84f9fdfqb4q2bbm','Shut up My Moms Calling - (Sped Up)','3uocnmx2vjpnd3y','POP','31mzt4ZV8C0f52pIz1NSwd','https://p.scdn.co/mp3-preview/4417d6fbf78b2a96b067dc092f888178b155b6b7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m3gnqgrn3gnb3y804pwp4bhs93ea9z16ahulysmwf5rp1a1dgj', 'qphd10rcm849peequq3vrbpuf56i7xju8lv84f9fdfqb4q2bbm', '1');
-- Dua Lipa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('blubbn1rwsj5gtj', 'Dua Lipa', '68@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1bbee4a02f85ecc58d385c3e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:68@artist.com', 'blubbn1rwsj5gtj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('blubbn1rwsj5gtj', 'A pop phenomenon, known for her empowering anthems and dynamic presence.', 'Dua Lipa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('eb8rrnh1kofej8ngw0alis5fx4gpd3zcsm4dhu2bspsubfkg70','blubbn1rwsj5gtj', 'https://i.scdn.co/image/ab67616d0000b2737dd3ba455ee3390cb55b0192', 'Dua Lipa Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('04fv7ov3qzug59f2bnk4wv1u6e3go73z13qmc79z43mqvogqar','Dance The Night (From Barbie The Album)','blubbn1rwsj5gtj','POP','1vYXt7VSjH9JIM5oRRo7vA','https://p.scdn.co/mp3-preview/acaea048f50a3b30ca24b348c84a6047373baabb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eb8rrnh1kofej8ngw0alis5fx4gpd3zcsm4dhu2bspsubfkg70', '04fv7ov3qzug59f2bnk4wv1u6e3go73z13qmc79z43mqvogqar', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m6dcfs7476kywpb8b4ohroxfqxcg7gsza70ewnfkexgsylxutx','Cold Heart - PNAU Remix','blubbn1rwsj5gtj','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eb8rrnh1kofej8ngw0alis5fx4gpd3zcsm4dhu2bspsubfkg70', 'm6dcfs7476kywpb8b4ohroxfqxcg7gsza70ewnfkexgsylxutx', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p1to819iciqdy5xphshmz3y4lv78muxzyer5nee4zoc8lox1g3','Dont Start Now','blubbn1rwsj5gtj','POP','3li9IOaMFu8S56r9uP6wcO','https://p.scdn.co/mp3-preview/cfc6684fc467e40bb9c7e6da2ea1b22eeccb211c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eb8rrnh1kofej8ngw0alis5fx4gpd3zcsm4dhu2bspsubfkg70', 'p1to819iciqdy5xphshmz3y4lv78muxzyer5nee4zoc8lox1g3', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('19nkryrdb1lo03roov799irjhr0a19o0ndj9bmngri1e11vn2m','Levitating (feat. DaBaby)','blubbn1rwsj5gtj','POP','5nujrmhLynf4yMoMtj8AQF','https://p.scdn.co/mp3-preview/6af6db91dba9103cca41d6d5225f6fe120fcfcd3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eb8rrnh1kofej8ngw0alis5fx4gpd3zcsm4dhu2bspsubfkg70', '19nkryrdb1lo03roov799irjhr0a19o0ndj9bmngri1e11vn2m', '3');
-- David Kushner
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('88ukrjrcgmbdicr', 'David Kushner', '69@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12fd1bd22516e35ef8c2e591','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:69@artist.com', '88ukrjrcgmbdicr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('88ukrjrcgmbdicr', 'A rising talent, creating music that resonates with a generation.', 'David Kushner');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bp5w22e130d08hbnhbr2ohxipcymku2ggzyk59k86v8z6pwwcj','88ukrjrcgmbdicr', 'https://i.scdn.co/image/ab67616d0000b27395ca6a9b4083a86c149934ae', 'David Kushner Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fqrtwpl858mru5yn72c6k9ruxoxq4pi80h6av55g42msknbfob','Daylight','88ukrjrcgmbdicr','POP','1odExI7RdWc4BT515LTAwj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bp5w22e130d08hbnhbr2ohxipcymku2ggzyk59k86v8z6pwwcj', 'fqrtwpl858mru5yn72c6k9ruxoxq4pi80h6av55g42msknbfob', '0');
-- Olivia Rodrigo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m3hwkms49wbz7vs', 'Olivia Rodrigo', '70@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe03a98785f3658f0b6461ec4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:70@artist.com', 'm3hwkms49wbz7vs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m3hwkms49wbz7vs', 'A new voice in pop, channeling raw emotions into her songs.', 'Olivia Rodrigo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('by5phon8gr7jq3bk9nwnlja2jcxjc8awk8w21j60qjps6sxlp7','m3hwkms49wbz7vs', 'https://i.scdn.co/image/ab67616d0000b273e85259a1cae29a8d91f2093d', 'Olivia Rodrigo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pzw24b1ar0gftquj0szn2tx12cqs4ak11w7myw5p5qwe9elz12','vampire','m3hwkms49wbz7vs','POP','1kuGVB7EU95pJObxwvfwKS',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('by5phon8gr7jq3bk9nwnlja2jcxjc8awk8w21j60qjps6sxlp7', 'pzw24b1ar0gftquj0szn2tx12cqs4ak11w7myw5p5qwe9elz12', '0');
-- Daddy Yankee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0lptmb5emgcenbj', 'Daddy Yankee', '71@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf9ad208bbff79c1ce09c77c1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:71@artist.com', '0lptmb5emgcenbj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0lptmb5emgcenbj', 'Music is my canvas, and notes are my paint.', 'Daddy Yankee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cymrwba0s3cymb8qzryb7wz2wzx09irfxc1bpizemdpgto3asg','0lptmb5emgcenbj', 'https://i.scdn.co/image/ab67616d0000b2736bdcdf82ecce36bff808a40c', 'Daddy Yankee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('eqe4qtjxt63ii7uhpq4tdi4850zyr9xco90g504j0cfy94adm0','Gasolina','0lptmb5emgcenbj','POP','228BxWXUYQPJrJYHDLOHkj','https://p.scdn.co/mp3-preview/7c545be6847f3a6b13c4ad9c70d10a34f49a92d3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cymrwba0s3cymb8qzryb7wz2wzx09irfxc1bpizemdpgto3asg', 'eqe4qtjxt63ii7uhpq4tdi4850zyr9xco90g504j0cfy94adm0', '0');
-- Central Cee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h7ur6frzyhbfjuf', 'Central Cee', '72@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5fe7cabb8de1c0266cd2179c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:72@artist.com', 'h7ur6frzyhbfjuf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h7ur6frzyhbfjuf', 'Weaving lyrical magic into every song.', 'Central Cee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qy8guv1t1pbgl56bn0q1a044hqi7mvjusgd23nydm60r895kf8','h7ur6frzyhbfjuf', 'https://i.scdn.co/image/ab67616d0000b273cbb3701743a568e7f1c4e967', 'Central Cee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ejsrzjf0a9qor5d0c8jod39znddupdd4mg9c8r97fu2ppujggg','LET GO','h7ur6frzyhbfjuf','POP','3zkyus0njMCL6phZmNNEeN','https://p.scdn.co/mp3-preview/5391f8e7621898d3f5237e297e3fbcabe1fe3494?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qy8guv1t1pbgl56bn0q1a044hqi7mvjusgd23nydm60r895kf8', 'ejsrzjf0a9qor5d0c8jod39znddupdd4mg9c8r97fu2ppujggg', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6u6qcvg0u1k6ge590k1ml9pjqnv2xq22ngck2yg8xfyo5u1q36','Doja','h7ur6frzyhbfjuf','POP','3LtpKP5abr2qqjunvjlX5i','https://p.scdn.co/mp3-preview/41105628e270a026ac9aecacd44e3373fceb9f43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qy8guv1t1pbgl56bn0q1a044hqi7mvjusgd23nydm60r895kf8', '6u6qcvg0u1k6ge590k1ml9pjqnv2xq22ngck2yg8xfyo5u1q36', '1');
-- RM
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('33joc0s027goo8k', 'RM', '73@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3b8f6208d84e28f63841e43c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:73@artist.com', '33joc0s027goo8k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('33joc0s027goo8k', 'The architect of aural landscapes that inspire and captivate.', 'RM');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('87gws306u4g59gbqbt2tdnqzb6h3b65f50nb4mvd57l9ujdlf4','33joc0s027goo8k', NULL, 'RM Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8le3inymsqmqavnd772y3cb38l86nhm5igkrg9f2y6swdpmwni','Dont ever say love me (feat. RM of BTS)','33joc0s027goo8k','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('87gws306u4g59gbqbt2tdnqzb6h3b65f50nb4mvd57l9ujdlf4', '8le3inymsqmqavnd772y3cb38l86nhm5igkrg9f2y6swdpmwni', '0');
-- Troye Sivan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('txhkvdcn0rpisdz', 'Troye Sivan', '74@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26e8cb3ff6fc7744b312811b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:74@artist.com', 'txhkvdcn0rpisdz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('txhkvdcn0rpisdz', 'A voice that encapsulates the spirit of modern pop.', 'Troye Sivan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('riaavyf3a93bbclhxonr4hg50ajxqn07821iatj66lnlgtuv2a','txhkvdcn0rpisdz', 'https://i.scdn.co/image/ab67616d0000b27367103283a4eb57578a428252', 'Troye Sivan Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aso48px5q687lcqi7hwemtj7ti89ljgwiplfxb96inl9m18v9q','Rush','txhkvdcn0rpisdz','POP','4ZnkygoWLzcGbQYCm3lkae',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('riaavyf3a93bbclhxonr4hg50ajxqn07821iatj66lnlgtuv2a', 'aso48px5q687lcqi7hwemtj7ti89ljgwiplfxb96inl9m18v9q', '0');
-- Cigarettes After Sex
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hnm6z2ndhidpvr2', 'Cigarettes After Sex', '75@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb41a26ad71de86acf45dc886','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:75@artist.com', 'hnm6z2ndhidpvr2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hnm6z2ndhidpvr2', 'A journey through the spectrum of sound in every album.', 'Cigarettes After Sex');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('q7k9hr8uon2nw1blzldf4to929qw75yvweti7op5o6oskrcaai','hnm6z2ndhidpvr2', 'https://i.scdn.co/image/ab67616d0000b27312b69bf576f5e80291f75161', 'Cigarettes After Sex Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7de5t6s556nl737gwncjhih6fxpr5ksk4tqc7ol07ec2kjcx4k','Apocalypse','hnm6z2ndhidpvr2','POP','0yc6Gst2xkRu0eMLeRMGCX','https://p.scdn.co/mp3-preview/1f89f0156113dfb87572382b531459bb8cb711a1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q7k9hr8uon2nw1blzldf4to929qw75yvweti7op5o6oskrcaai', '7de5t6s556nl737gwncjhih6fxpr5ksk4tqc7ol07ec2kjcx4k', '0');
-- Yng Lvcas
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qccez1wv0s9f54e', 'Yng Lvcas', '76@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:76@artist.com', 'qccez1wv0s9f54e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qccez1wv0s9f54e', 'Transcending language barriers through the universal language of music.', 'Yng Lvcas');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qux5nlt3ah2gbwodcgixbicmoduec61uw0957mpavwm0xdrkam','qccez1wv0s9f54e', 'https://i.scdn.co/image/ab67616d0000b273a04be3ad7c8c67f4109111a9', 'Yng Lvcas Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xsy0bzkmwotlngfmqj05ynuo7ga5hlo2isfvsptwo0xzwpv6xz','La Bebe','qccez1wv0s9f54e','POP','2UW7JaomAMuX9pZrjVpHAU','https://p.scdn.co/mp3-preview/57c5d5266219b32d455ed22417155bbabde7170f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qux5nlt3ah2gbwodcgixbicmoduec61uw0957mpavwm0xdrkam', 'xsy0bzkmwotlngfmqj05ynuo7ga5hlo2isfvsptwo0xzwpv6xz', '0');
-- Rihanna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8g68xy1gq2ky70w', 'Rihanna', '77@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:77@artist.com', '8g68xy1gq2ky70w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8g68xy1gq2ky70w', 'An endless quest for musical perfection.', 'Rihanna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('29o44pt80jz750q4zcuz53g92ly2dh05mix2yr4gm198qcj82h','8g68xy1gq2ky70w', 'https://i.scdn.co/image/ab67616d0000b273bef074de9ca825bddaeb9f46', 'Rihanna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2h65s1p4yzcl6ozg87jh6bacsbbvnc6guxdjfd5d3uev6nhhul','We Found Love','8g68xy1gq2ky70w','POP','6qn9YLKt13AGvpq9jfO8py',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('29o44pt80jz750q4zcuz53g92ly2dh05mix2yr4gm198qcj82h', '2h65s1p4yzcl6ozg87jh6bacsbbvnc6guxdjfd5d3uev6nhhul', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i8aeh9wntcdgz6u6obhfmvma5jl9xhviaa2dax61lwm5uofdvi','Lift Me Up - From Black Panther: Wakanda Forever - Music From and Inspired By','8g68xy1gq2ky70w','POP','35ovElsgyAtQwYPYnZJECg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('29o44pt80jz750q4zcuz53g92ly2dh05mix2yr4gm198qcj82h', 'i8aeh9wntcdgz6u6obhfmvma5jl9xhviaa2dax61lwm5uofdvi', '1');
-- Simone Mendes
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6fsugruy38zsifd', 'Simone Mendes', '78@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb80e5acf09546a1fa2ca12a49','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:78@artist.com', '6fsugruy38zsifd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6fsugruy38zsifd', 'Igniting the stage with electrifying performances.', 'Simone Mendes');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('31sk52ff9ndmobms5uzntpk29dqkafjtmwo2qquq9kplhmzyud','6fsugruy38zsifd', 'https://i.scdn.co/image/ab67616d0000b27379dcbcbbc872003eea5fd10f', 'Simone Mendes Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yft2vgs6am98osxiz3f70hup4dur3jqml873tmdth7yb9r4e3j','Erro Gostoso - Ao Vivo','6fsugruy38zsifd','POP','4R1XAT4Ix7kad727aKh7Pj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('31sk52ff9ndmobms5uzntpk29dqkafjtmwo2qquq9kplhmzyud', 'yft2vgs6am98osxiz3f70hup4dur3jqml873tmdth7yb9r4e3j', '0');
-- RAYE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b0k8klxwiwp1hwa', 'RAYE', '79@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0550f0badff3ad04802b1e86','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:79@artist.com', 'b0k8klxwiwp1hwa', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b0k8klxwiwp1hwa', 'Blending genres for a fresh musical experience.', 'RAYE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xtrcfwigw9y2k8pu0n37pxkx196d6n2tqqvorhd7ntjcrcsv94','b0k8klxwiwp1hwa', 'https://i.scdn.co/image/ab67616d0000b27394e5237ce925531dbb38e75f', 'RAYE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kxqkabfvmt2lju9pe9my77djqjh0ctncshikai434yfxwsdkhh','Escapism.','b0k8klxwiwp1hwa','POP','5mHdCZtVyb4DcJw8799hZp','https://p.scdn.co/mp3-preview/8a8fcaf9ddf050562048d1632ddc880c9ce7c972?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xtrcfwigw9y2k8pu0n37pxkx196d6n2tqqvorhd7ntjcrcsv94', 'kxqkabfvmt2lju9pe9my77djqjh0ctncshikai434yfxwsdkhh', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cthv1gx807x8z1v8zlb32c7sy0p8hftzznnmgzl54693ocqgqs','Escapism. - Sped Up','b0k8klxwiwp1hwa','POP','3XCpS4k8WqNnCpcDOSRRuz','https://p.scdn.co/mp3-preview/22be59e4d5da403513e02e90c27bc1d0965b5f1f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xtrcfwigw9y2k8pu0n37pxkx196d6n2tqqvorhd7ntjcrcsv94', 'cthv1gx807x8z1v8zlb32c7sy0p8hftzznnmgzl54693ocqgqs', '1');
-- Grupo Frontera
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dx67x9foek4r8i2', 'Grupo Frontera', '80@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f1a7e9f510bf0501e209c58','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:80@artist.com', 'dx67x9foek4r8i2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dx67x9foek4r8i2', 'Breathing new life into classic genres.', 'Grupo Frontera');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9wh5mfq1wyz3w0kqofa4blb780s3cmuzc3aicd3qkccqt9sjkv','dx67x9foek4r8i2', 'https://i.scdn.co/image/ab67616d0000b27382ce4c7bbf861185252e82ae', 'Grupo Frontera Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('acbytqm7vi2cu905p0h6t8ijcsd8na0uygsgfbjgh4l41thd9x','No Se Va','dx67x9foek4r8i2','POP','76kelNDs1ojicx1s6Urvck','https://p.scdn.co/mp3-preview/1aa36481ad26b54ce635e7eb7d7360353c09d9ea?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9wh5mfq1wyz3w0kqofa4blb780s3cmuzc3aicd3qkccqt9sjkv', 'acbytqm7vi2cu905p0h6t8ijcsd8na0uygsgfbjgh4l41thd9x', '0');
-- New West
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kk3d415zvnmk3pu', 'New West', '81@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb32a5faa77c82348cf5d13590','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:81@artist.com', 'kk3d415zvnmk3pu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kk3d415zvnmk3pu', 'A symphony of emotions expressed through sound.', 'New West');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sknaj1xy7l876q4d169bii86rt3bj67ka22lqs3y296z14mk1m','kk3d415zvnmk3pu', 'https://i.scdn.co/image/ab67616d0000b2731bb5dc21200bfc56d8f7ef41', 'New West Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cx84hqwb5aygb3ue2robgu40t1m2w0ng9aod1iz3gmhj49kzld','Those Eyes','kk3d415zvnmk3pu','POP','50x1Ic8CaXkYNvjmxe3WXy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sknaj1xy7l876q4d169bii86rt3bj67ka22lqs3y296z14mk1m', 'cx84hqwb5aygb3ue2robgu40t1m2w0ng9aod1iz3gmhj49kzld', '0');
-- Sam Smith
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('64jkthcxpli26lh', 'Sam Smith', '82@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0aa135d864bdcf4eb112112','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:82@artist.com', '64jkthcxpli26lh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('64jkthcxpli26lh', 'A soulful voice delivering deep emotional resonance.', 'Sam Smith');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0r9jz92mo56o5czcfvkmxkroc7cdrgt28s4w9iovfd4fi5gbd9','64jkthcxpli26lh', 'https://i.scdn.co/image/ab67616d0000b273a935e4689f15953311772cc4', 'Sam Smith Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g4docryglitz3esdgokkmo5qf47qsx6ua1gbj3bfnmwfhi4bp7','Unholy (feat. Kim Petras)','64jkthcxpli26lh','POP','3nqQXoyQOWXiESFLlDF1hG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0r9jz92mo56o5czcfvkmxkroc7cdrgt28s4w9iovfd4fi5gbd9', 'g4docryglitz3esdgokkmo5qf47qsx6ua1gbj3bfnmwfhi4bp7', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ak21furlhfi01gnxcb7cqzyefn0wy3do6xaghou0hsjs40ki26','Im Not Here To Make Friends','64jkthcxpli26lh','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0r9jz92mo56o5czcfvkmxkroc7cdrgt28s4w9iovfd4fi5gbd9', 'ak21furlhfi01gnxcb7cqzyefn0wy3do6xaghou0hsjs40ki26', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5h93uolw8x144p70m8jjcbbbni1v2zvq8xrtyctmmtl4u9pm6b','Im Not The Only One','64jkthcxpli26lh','POP','5RYtz3cpYb28SV8f1FBtGc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0r9jz92mo56o5czcfvkmxkroc7cdrgt28s4w9iovfd4fi5gbd9', '5h93uolw8x144p70m8jjcbbbni1v2zvq8xrtyctmmtl4u9pm6b', '2');
-- Big One
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ve259003swyee80', 'Big One', '83@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcd00b46bac23bbfbcdcd10bc','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:83@artist.com', 've259003swyee80', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ve259003swyee80', 'Bringing a unique energy to every track, fusing various styles into a cohesive sound.', 'Big One');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uzeyp15kuz54tbr3zu7flu6omkw2dfvqd85tbabydw1v2zg8gq','ve259003swyee80', NULL, 'Big One Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5710rps6vkx4wuvx56zh4sjz1rzsm4xq6odzxcb1p64h9fgi60','Los del Espacio','ve259003swyee80','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uzeyp15kuz54tbr3zu7flu6omkw2dfvqd85tbabydw1v2zg8gq', '5710rps6vkx4wuvx56zh4sjz1rzsm4xq6odzxcb1p64h9fgi60', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lym4pjss984t7a9wt54nar2tzwnjmaubxoexbbbt2ai22agoe5','Un Finde | CROSSOVER #2','ve259003swyee80','POP','3tiJUOfAEqIrLFRQgGgdoY','https://p.scdn.co/mp3-preview/38b8f2c063a896c568b9741dcd6e194be0a0376b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uzeyp15kuz54tbr3zu7flu6omkw2dfvqd85tbabydw1v2zg8gq', 'lym4pjss984t7a9wt54nar2tzwnjmaubxoexbbbt2ai22agoe5', '1');
-- James Blake
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0c994pjx3on5inm', 'James Blake', '84@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb93fe5fc8fdb5a98248911a07','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:84@artist.com', '0c994pjx3on5inm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0c994pjx3on5inm', 'A maestro of melodies, orchestrating auditory bliss.', 'James Blake');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qlufdccnn8xebm5oh9aosrdro6zajgq5vno8msw8mz8eeqddch','0c994pjx3on5inm', NULL, 'James Blake Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k7gt6nkoaaccqg8xunwh5f2k15b3zqtk3w85eeyv600b0hjavj','Hummingbird (Metro Boomin & James Blake)','0c994pjx3on5inm','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qlufdccnn8xebm5oh9aosrdro6zajgq5vno8msw8mz8eeqddch', 'k7gt6nkoaaccqg8xunwh5f2k15b3zqtk3w85eeyv600b0hjavj', '0');
-- Lost Frequencies
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ytcss3vxh7hku13', 'Lost Frequencies', '85@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfd28880f1b1fa8f93d05eb76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:85@artist.com', 'ytcss3vxh7hku13', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ytcss3vxh7hku13', 'Crafting soundscapes that transport listeners to another world.', 'Lost Frequencies');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('40toa2eih1iu8nfzmfs4t24ivhm79a27tyyec6dgj35jq5mvn0','ytcss3vxh7hku13', 'https://i.scdn.co/image/ab67616d0000b2738d7a7f1855b04104ba59c18b', 'Lost Frequencies Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nvzqq2d9443cn0xsjwlkixxlor3re4djk4vrwggdxw7bp3wrv8','Where Are You Now','ytcss3vxh7hku13','POP','3uUuGVFu1V7jTQL60S1r8z','https://p.scdn.co/mp3-preview/e2646d5bc8c56e4a91582a03c089f8038772aecb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('40toa2eih1iu8nfzmfs4t24ivhm79a27tyyec6dgj35jq5mvn0', 'nvzqq2d9443cn0xsjwlkixxlor3re4djk4vrwggdxw7bp3wrv8', '0');
-- Kenshi Yonezu
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('aam89nzcahypk27', 'Kenshi Yonezu', '86@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc147e0888e83919d317c1103','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:86@artist.com', 'aam89nzcahypk27', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('aam89nzcahypk27', 'Pioneering new paths in the musical landscape.', 'Kenshi Yonezu');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('apmujdqo4t1j1d9x90olgstlhee0so0fxrlybawnjy2sf7qol2','aam89nzcahypk27', 'https://i.scdn.co/image/ab67616d0000b273303d8545fce8302841c39859', 'Kenshi Yonezu Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c4wkbpbuvacq77zqqihgjyn48bvu1nsv7oapjhm4ytrzf2n5ms','KICK BACK','aam89nzcahypk27','POP','3khEEPRyBeOUabbmOPJzAG','https://p.scdn.co/mp3-preview/003a7a062f469db238cf5206626f08f3263c68e6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('apmujdqo4t1j1d9x90olgstlhee0so0fxrlybawnjy2sf7qol2', 'c4wkbpbuvacq77zqqihgjyn48bvu1nsv7oapjhm4ytrzf2n5ms', '0');
-- El Chachito
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9adyjuj3yzewkp9', 'El Chachito', '87@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5ccab5d3dc10a08d89cbd76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:87@artist.com', '9adyjuj3yzewkp9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9adyjuj3yzewkp9', 'Revolutionizing the music scene with innovative compositions.', 'El Chachito');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('syajmp6fxni0k1c7p6haxvkxl1mxlyg80bbghfvhmkd5zqk17y','9adyjuj3yzewkp9', 'https://i.scdn.co/image/ab67616d0000b27354c372ef8e7b53bb3c932ac5', 'El Chachito Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tklvt0om9nlja5wxn4v601etsq56wx8wuhw1oa8a803onun7ur','En Paris','9adyjuj3yzewkp9','POP','1Fuc3pBiPFxAeSJoO8tDh5','https://p.scdn.co/mp3-preview/c57f1229ca237b01f9dbd839bc3ca97f22395a87?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('syajmp6fxni0k1c7p6haxvkxl1mxlyg80bbghfvhmkd5zqk17y', 'tklvt0om9nlja5wxn4v601etsq56wx8wuhw1oa8a803onun7ur', '0');
-- SEVENTEEN
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('anhypkpv07odtdo', 'SEVENTEEN', '88@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb61916bb9f5c6a1a9ba1c9ab6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:88@artist.com', 'anhypkpv07odtdo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('anhypkpv07odtdo', 'Uniting fans around the globe with universal rhythms.', 'SEVENTEEN');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('s43bctn6he8kvx4hcaw3eq3wygmpdbnz7sijgr6ttjsrafhud8','anhypkpv07odtdo', 'https://i.scdn.co/image/ab67616d0000b27380e31ba0c05187e6310ef264', 'SEVENTEEN Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0d8mm0kn0ry5qdw1ptq67gome8mnuzn3ojl61z2ovbsjzqxz7m','Super','anhypkpv07odtdo','POP','3AOf6YEpxQ894FmrwI9k96','https://p.scdn.co/mp3-preview/1dd31996959e603934dbe4c7d3ee377243a0f890?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s43bctn6he8kvx4hcaw3eq3wygmpdbnz7sijgr6ttjsrafhud8', '0d8mm0kn0ry5qdw1ptq67gome8mnuzn3ojl61z2ovbsjzqxz7m', '0');
-- The Weeknd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m0u0qsyp617rqh3', 'The Weeknd', '89@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:89@artist.com', 'm0u0qsyp617rqh3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m0u0qsyp617rqh3', 'A trailblazer in the world of R&B, constantly redefining the genre.', 'The Weeknd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp','m0u0qsyp617rqh3', NULL, 'The Weeknd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kluncy6d8zyipugs24ubdj7citdme33pabss7a7ymozwi8kj9h','Popular (with Playboi Carti & Madonna) - The Idol Vol. 1 (Music from the HBO Original Series)','m0u0qsyp617rqh3','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp', 'kluncy6d8zyipugs24ubdj7citdme33pabss7a7ymozwi8kj9h', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iijeb3nj7rjq565k8mbb24l30jbfr1ez34vflxha446ntv38w5','Creepin','m0u0qsyp617rqh3','POP','1zOf6IuM8HgaB4Jo6I8D11','https://p.scdn.co/mp3-preview/185d0909b7f2086f4cdd0af4b166df5676542343?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp', 'iijeb3nj7rjq565k8mbb24l30jbfr1ez34vflxha446ntv38w5', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v6f1he30y1s07mxsm6v58wnuir8x1fn9uaxjn51lv6qakt0ohc','Die For You','m0u0qsyp617rqh3','POP','2LBqCSwhJGcFQeTHMVGwy3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp', 'v6f1he30y1s07mxsm6v58wnuir8x1fn9uaxjn51lv6qakt0ohc', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lenz9gr96z77um2h851oltlxd2ij6vt3zvkkn5cufkb8j393oq','Starboy','m0u0qsyp617rqh3','POP','7MXVkk9YMctZqd1Srtv4MB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp', 'lenz9gr96z77um2h851oltlxd2ij6vt3zvkkn5cufkb8j393oq', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('by86y0rjaeo3w9j4jnza8hl10kpajd06z95eqp5fizcfvc1l34','Blinding Lights','m0u0qsyp617rqh3','POP','0VjIjW4GlUZAMYd2vXMi3b',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp', 'by86y0rjaeo3w9j4jnza8hl10kpajd06z95eqp5fizcfvc1l34', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n8fd54khjwlc8p4l0malg3ztucw3x2xmy9z1gl6ox4y2z7fzcl','Stargirl Interlude','m0u0qsyp617rqh3','POP','5gDWsRxpJ2lZAffh5p7K0w',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp', 'n8fd54khjwlc8p4l0malg3ztucw3x2xmy9z1gl6ox4y2z7fzcl', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cq07s10qk8ggiogp0wv2dqhtkav3vck7nim6l3mfr8rnjf4ba2','Save Your Tears','m0u0qsyp617rqh3','POP','5QO79kh1waicV47BqGRL3g',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp', 'cq07s10qk8ggiogp0wv2dqhtkav3vck7nim6l3mfr8rnjf4ba2', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jcwgx7w8og931m45wami7skrd8uglrol5vmcj2uw084iy4ldeg','Reminder','m0u0qsyp617rqh3','POP','37F0uwRSrdzkBiuj0D5UHI',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp', 'jcwgx7w8og931m45wami7skrd8uglrol5vmcj2uw084iy4ldeg', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('02gyhid3wn7x4mvjm303mpk6ko6xwf2r7aa248t5t8f42z9ijs','Double Fantasy (with Future)','m0u0qsyp617rqh3','POP','4VMRsbfZzd3SfQtaJ1Wpwi',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp', '02gyhid3wn7x4mvjm303mpk6ko6xwf2r7aa248t5t8f42z9ijs', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qer0mcnquepgdza793wcih79tizhbp5wrchs0fb215m2a0cjls','I Was Never There','m0u0qsyp617rqh3','POP','1cKHdTo9u0ZymJdPGSh6nq',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp', 'qer0mcnquepgdza793wcih79tizhbp5wrchs0fb215m2a0cjls', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q58b9dhmddabe08yvuyb18s12iy4aujy7q189qyelt6yj64wo1','Call Out My Name','m0u0qsyp617rqh3','POP','09mEdoA6zrmBPgTEN5qXmN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp', 'q58b9dhmddabe08yvuyb18s12iy4aujy7q189qyelt6yj64wo1', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('b5irfwmfcaqb2gc6f6b23yl03h44xum18dq1wwkfrzgua00wlu','The Hills','m0u0qsyp617rqh3','POP','7fBv7CLKzipRk6EC6TWHOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp', 'b5irfwmfcaqb2gc6f6b23yl03h44xum18dq1wwkfrzgua00wlu', '11');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kujrn4bhq3ac3aipgni7p8myikodv3cixqj09afk3rf4fmsnn2','After Hours','m0u0qsyp617rqh3','POP','2p8IUWQDrpjuFltbdgLOag',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2jaf7wpppgo2et0x9cgw8u4f90v7d0wniyctciv4gjlsx5jcp', 'kujrn4bhq3ac3aipgni7p8myikodv3cixqj09afk3rf4fmsnn2', '12');
-- Labrinth
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pczm06sbaiukdfp', 'Labrinth', '90@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7885d725841e0338092f5f6f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:90@artist.com', 'pczm06sbaiukdfp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pczm06sbaiukdfp', 'A sonic adventurer, always seeking new horizons in music.', 'Labrinth');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sfonokc1h8d8zudgkgp0fe4w121rzd48a1hbmxrkk3wks4ui9p','pczm06sbaiukdfp', 'https://i.scdn.co/image/ab67616d0000b2731df535f5089e544a3cc86069', 'Labrinth Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g84tv6s9x9v13yque77smf05q3fqieu8ukt9iuj79995onreyd','Never Felt So Alone','pczm06sbaiukdfp','POP','6unndO70DvZfnXYcYQMyQJ','https://p.scdn.co/mp3-preview/d33db796d822aa77728af0f4abb06ccd596d2920?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sfonokc1h8d8zudgkgp0fe4w121rzd48a1hbmxrkk3wks4ui9p', 'g84tv6s9x9v13yque77smf05q3fqieu8ukt9iuj79995onreyd', '0');
-- OneRepublic
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cf5hvwjc7e0ev80', 'OneRepublic', '91@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb57138b98e7ddd5a86ee97a9b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:91@artist.com', 'cf5hvwjc7e0ev80', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cf5hvwjc7e0ev80', 'Delivering anthemic pop-rock tracks that resonate globally.', 'OneRepublic');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1asdcd3ms7y8qtmu6vtfbdzrnf3y4644tq6uq5kv37ow3xx1wt','cf5hvwjc7e0ev80', 'https://i.scdn.co/image/ab67616d0000b273ec96e006b8bdfc582610ec13', 'OneRepublic Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z62ogej34ogr7j9j0awh0thl753ins3exg9dhjx98oszk9gc91','I Aint Worried','cf5hvwjc7e0ev80','POP','4h9wh7iOZ0GGn8QVp4RAOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1asdcd3ms7y8qtmu6vtfbdzrnf3y4644tq6uq5kv37ow3xx1wt', 'z62ogej34ogr7j9j0awh0thl753ins3exg9dhjx98oszk9gc91', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u5duhtcjoiusdk7ubci7tzdwpgy98h4wzp761y5r7ttvh17zsz','Counting Stars','cf5hvwjc7e0ev80','POP','2tpWsVSb9UEmDRxAl1zhX1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1asdcd3ms7y8qtmu6vtfbdzrnf3y4644tq6uq5kv37ow3xx1wt', 'u5duhtcjoiusdk7ubci7tzdwpgy98h4wzp761y5r7ttvh17zsz', '1');
-- Sebastian Yatra
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ya749k6loi1x7ok', 'Sebastian Yatra', '92@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb650a498358171e1990efeeff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:92@artist.com', 'ya749k6loi1x7ok', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ya749k6loi1x7ok', 'A voice that echoes the sentiments of a generation.', 'Sebastian Yatra');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cis8wwvvjwp0530jcwa3yu44wd8bztpytil667simgciqxrzbr','ya749k6loi1x7ok', 'https://i.scdn.co/image/ab67616d0000b2732d6016751b8ea5e66e83cd04', 'Sebastian Yatra Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0p6gxtabrnc0slz3868pyi66q1ypw984kk31epo9wto0f4drkq','VAGABUNDO','ya749k6loi1x7ok','POP','1MB8kTH7VKvAMfL9SHgJmG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cis8wwvvjwp0530jcwa3yu44wd8bztpytil667simgciqxrzbr', '0p6gxtabrnc0slz3868pyi66q1ypw984kk31epo9wto0f4drkq', '0');
-- Steve Lacy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h0kilqd3qojcotn', 'Steve Lacy', '93@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb09ac9d040c168d4e4f58eb42','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:93@artist.com', 'h0kilqd3qojcotn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h0kilqd3qojcotn', 'The architect of aural landscapes that inspire and captivate.', 'Steve Lacy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mw0k6hvpsvlqtcuzotr9v4xz6h09a1sjv43diph8pvy7rredef','h0kilqd3qojcotn', 'https://i.scdn.co/image/ab67616d0000b27368968350c2550e36d96344ee', 'Steve Lacy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ar6sdn9slso60bje0ai7520w7mdhph8b97335093mbab84ejh0','Bad Habit','h0kilqd3qojcotn','POP','4k6Uh1HXdhtusDW5y8Gbvy','https://p.scdn.co/mp3-preview/efe7c2fdd8fa727a108a1270b114ebedabfd766c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mw0k6hvpsvlqtcuzotr9v4xz6h09a1sjv43diph8pvy7rredef', 'ar6sdn9slso60bje0ai7520w7mdhph8b97335093mbab84ejh0', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('epd63p6vyaweo674wu30r3wwxmamvafyddqc11dupty6f68h6q','Dark Red','h0kilqd3qojcotn','POP','3EaJDYHA0KnX88JvDhL9oa','https://p.scdn.co/mp3-preview/90b3855fd50a4c4878a2d5117ebe73f658a97285?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mw0k6hvpsvlqtcuzotr9v4xz6h09a1sjv43diph8pvy7rredef', 'epd63p6vyaweo674wu30r3wwxmamvafyddqc11dupty6f68h6q', '1');
-- Jack Black
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2lquqq8ab17762x', 'Jack Black', '94@artist.com', 'https://i.scdn.co/image/ab6772690000c46ca156a562884cb76eeb0b75e9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:94@artist.com', '2lquqq8ab17762x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2lquqq8ab17762x', 'A sonic adventurer, always seeking new horizons in music.', 'Jack Black');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oyxuofai58mh3a20lqb4d43gn85l589ow8d8x5gt1cjzxkxaup','2lquqq8ab17762x', NULL, 'Jack Black Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p7tn8v76hnts2ig7ji13ltmpnd2xr3u3ssnoi400a0wy4eord5','Peaches (from The Super Mario Bros. Movie)','2lquqq8ab17762x','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oyxuofai58mh3a20lqb4d43gn85l589ow8d8x5gt1cjzxkxaup', 'p7tn8v76hnts2ig7ji13ltmpnd2xr3u3ssnoi400a0wy4eord5', '0');
-- Migrantes
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5tb3art4sro0o5n', 'Migrantes', '95@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb676e77ad14850536079e2ea8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:95@artist.com', '5tb3art4sro0o5n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5tb3art4sro0o5n', 'Crafting soundscapes that transport listeners to another world.', 'Migrantes');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('r4b7px53weofpfdtvoggn2z6elkzirwjf5std0amdb55a7nlxu','5tb3art4sro0o5n', NULL, 'Migrantes Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zhed2jpqah4becm1yq1kv86xeiiyit609dicjjrlajbg09vq59','MERCHO','5tb3art4sro0o5n','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r4b7px53weofpfdtvoggn2z6elkzirwjf5std0amdb55a7nlxu', 'zhed2jpqah4becm1yq1kv86xeiiyit609dicjjrlajbg09vq59', '0');
-- Glass Animals
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e80aoatxogcdg02', 'Glass Animals', '96@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb66b27eccb69756f8eceabc23','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:96@artist.com', 'e80aoatxogcdg02', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e80aoatxogcdg02', 'Crafting psychedelic pop with intricate melodies and immersive soundscapes.', 'Glass Animals');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tvudsz6dhgvd735ivcaxlz5m37v03j79unve72moy6dxm0fmsz','e80aoatxogcdg02', 'https://i.scdn.co/image/ab67616d0000b273712701c5e263efc8726b1464', 'Glass Animals Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yl00b2mlmvb6dpeoseyrat3ro0aeyfk00o0ifhnkt70zvv86b6','Heat Waves','e80aoatxogcdg02','POP','3USxtqRwSYz57Ewm6wWRMp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tvudsz6dhgvd735ivcaxlz5m37v03j79unve72moy6dxm0fmsz', 'yl00b2mlmvb6dpeoseyrat3ro0aeyfk00o0ifhnkt70zvv86b6', '0');
-- Duki
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ttlsmnxv6i15qdc', 'Duki', '97@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4293b81686e67e3041aec80c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:97@artist.com', 'ttlsmnxv6i15qdc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ttlsmnxv6i15qdc', 'A journey through the spectrum of sound in every album.', 'Duki');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9nrzr0sehx4mqniei3n2mhr17cf41olygvzyz2v727me4pkiy4','ttlsmnxv6i15qdc', NULL, 'Duki Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vdwl1yzep4bsfpb786c460kljr2xufjwmc0lxww3dls1tye5fv','Marisola - Remix','ttlsmnxv6i15qdc','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9nrzr0sehx4mqniei3n2mhr17cf41olygvzyz2v727me4pkiy4', 'vdwl1yzep4bsfpb786c460kljr2xufjwmc0lxww3dls1tye5fv', '0');
-- Plan B
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wvenbmy1jluy2b0', 'Plan B', '98@artist.com', 'https://i.scdn.co/image/eb21793908d1eabe0fba02659bdff4e4a4b3724a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:98@artist.com', 'wvenbmy1jluy2b0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wvenbmy1jluy2b0', 'Sculpting soundwaves into masterpieces of auditory art.', 'Plan B');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4x60160suuh6u7w0ieif5gbi42zwgcmg5iags3faqfnuxo0hd1','wvenbmy1jluy2b0', 'https://i.scdn.co/image/ab67616d0000b273913ef74e0272d688c512200b', 'Plan B Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mms7x23sfesvoau1lisjavam0mcyhb45nlze6rzgfrpm92bk1k','Es un Secreto','wvenbmy1jluy2b0','POP','7JwdbqIpiuWvGbRryKSuBz','https://p.scdn.co/mp3-preview/feeeb03d75e53b19bb2e67502a1b498e87cdfef8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4x60160suuh6u7w0ieif5gbi42zwgcmg5iags3faqfnuxo0hd1', 'mms7x23sfesvoau1lisjavam0mcyhb45nlze6rzgfrpm92bk1k', '0');
-- Conan Gray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('omcs5ff69wbh95s', 'Conan Gray', '99@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc1c8fa15e08cb31eeb03b771','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:99@artist.com', 'omcs5ff69wbh95s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('omcs5ff69wbh95s', 'Revolutionizing the music scene with innovative compositions.', 'Conan Gray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('agaqych0k80hnnirlfmfg72k4ynxhpir9rmt7nc6cx0m8z9jz0','omcs5ff69wbh95s', 'https://i.scdn.co/image/ab67616d0000b27388e3cda6d29b2552d4d6bc43', 'Conan Gray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bfeszm5vsw066ihf6609gpjs5fglw6c5f4os9v8f5f9r4w3ic3','Heather','omcs5ff69wbh95s','POP','4xqrdfXkTW4T0RauPLv3WA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('agaqych0k80hnnirlfmfg72k4ynxhpir9rmt7nc6cx0m8z9jz0', 'bfeszm5vsw066ihf6609gpjs5fglw6c5f4os9v8f5f9r4w3ic3', '0');
-- Nicky Jam
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('is8unvjfzbwqyun', 'Nicky Jam', '100@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb02bec146cac39466d3f8ee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:100@artist.com', 'is8unvjfzbwqyun', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('is8unvjfzbwqyun', 'An odyssey of sound that defies conventions.', 'Nicky Jam');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uzht15xkyl08n62991mlqi8ori6r7a3e7zplnkss1ifytbpei0','is8unvjfzbwqyun', 'https://i.scdn.co/image/ab67616d0000b273ea97d86f1fa8532cd8c75188', 'Nicky Jam Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9tacl2r07tyote15v7zcfou2bjasx1qlsct7ttmfxbwuuh4wpg','69','is8unvjfzbwqyun','POP','13Z5Q40pa1Ly7aQk1oW8Ce','https://p.scdn.co/mp3-preview/966457479d8cd723838150ddd1f3010f4383994d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uzht15xkyl08n62991mlqi8ori6r7a3e7zplnkss1ifytbpei0', '9tacl2r07tyote15v7zcfou2bjasx1qlsct7ttmfxbwuuh4wpg', '0');
-- LE SSERAFIM
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4my4dxtlz4m3wks', 'LE SSERAFIM', '101@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb99752c006407988976248679','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:101@artist.com', '4my4dxtlz4m3wks', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4my4dxtlz4m3wks', 'An odyssey of sound that defies conventions.', 'LE SSERAFIM');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e4aetz3vqin04m17hlfa4lj02kkymt051jovlzgsk4wo9z381y','4my4dxtlz4m3wks', 'https://i.scdn.co/image/ab67616d0000b273a991995542d50a691b9ae5be', 'LE SSERAFIM Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cwr8ysnhexv7pyv3z6ts9n924o7l5hsx6rs18q906tmz7el3nd','ANTIFRAGILE','4my4dxtlz4m3wks','POP','4fsQ0K37TOXa3hEQfjEic1','https://p.scdn.co/mp3-preview/97a1c7e470172e0993f8f65dc109ab9d017d7adc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e4aetz3vqin04m17hlfa4lj02kkymt051jovlzgsk4wo9z381y', 'cwr8ysnhexv7pyv3z6ts9n924o7l5hsx6rs18q906tmz7el3nd', '0');
-- Tainy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('33dtsrs6v3aa6lk', 'Tainy', '102@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb50d43598b9074f0d6146127','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:102@artist.com', '33dtsrs6v3aa6lk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('33dtsrs6v3aa6lk', 'Revolutionizing reggaeton and Latin music with groundbreaking production.', 'Tainy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('37sxowstc5zihweirm6nuqnoyvekb9inrjwe6ndp11y66bl9ik','33dtsrs6v3aa6lk', 'https://i.scdn.co/image/ab67616d0000b273de7b9af78fbdda96c5a0635b', 'Tainy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a5mugorunqfmjel0gw55u1s5mu9pkbljvpbj37opuogah4cpnh','MOJABI GHOST','33dtsrs6v3aa6lk','POP','4eMKD8MRroxCqugpsxCCNb','https://p.scdn.co/mp3-preview/a6d8180d52b759c3e3db9aa78e841ffc06e26c17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('37sxowstc5zihweirm6nuqnoyvekb9inrjwe6ndp11y66bl9ik', 'a5mugorunqfmjel0gw55u1s5mu9pkbljvpbj37opuogah4cpnh', '0');
-- ROSAL
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('241z2dy99muh3np', 'ROSAL', '103@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd7bb678bef6d2f26110cae49','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:103@artist.com', '241z2dy99muh3np', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('241z2dy99muh3np', 'A tapestry of rhythms that echo the pulse of life.', 'ROSAL');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6gom1clfe58ogmqnipz3x3l2f6alyc17036xypopbncqttoag3','241z2dy99muh3np', 'https://i.scdn.co/image/ab67616d0000b273efc0ef9dd996312ebaf0bf52', 'ROSAL Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w6e0vsdc4v0nb7fs8pn861kknxell3rnrsbusarrcm3vtl2x1m','DESPECH','241z2dy99muh3np','POP','53tfEupEzQRtVFOeZvk7xq','https://p.scdn.co/mp3-preview/304868e078d8f2c3209977997c47542181096b61?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6gom1clfe58ogmqnipz3x3l2f6alyc17036xypopbncqttoag3', 'w6e0vsdc4v0nb7fs8pn861kknxell3rnrsbusarrcm3vtl2x1m', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lgc9crxec39aub26xupm9ekllkxrdvb89h332ur7pxnbb0qt2z','LLYLM','241z2dy99muh3np','POP','2SiAcexM2p1yX6joESbehd','https://p.scdn.co/mp3-preview/6f41063b2e36fb31fbd08c39b6c56012e239365b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6gom1clfe58ogmqnipz3x3l2f6alyc17036xypopbncqttoag3', 'lgc9crxec39aub26xupm9ekllkxrdvb89h332ur7pxnbb0qt2z', '1');
-- MC Xenon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ersgkfckz6f9d9p', 'MC Xenon', '104@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb14b5fcee11164723953781ff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:104@artist.com', 'ersgkfckz6f9d9p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ersgkfckz6f9d9p', 'Where words fail, my music speaks.', 'MC Xenon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4dow4vtg6jnzpj6s4cmykxcsb2pj1t7ek2hzcjhe13ura0v51m','ersgkfckz6f9d9p', NULL, 'MC Xenon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ivb6v2hz6sjbbrxj8awa5mko5zvcp1q0988sxtx9hc42xbofpq','Sem Aliana no ','ersgkfckz6f9d9p','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4dow4vtg6jnzpj6s4cmykxcsb2pj1t7ek2hzcjhe13ura0v51m', 'ivb6v2hz6sjbbrxj8awa5mko5zvcp1q0988sxtx9hc42xbofpq', '0');
-- IVE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q2hw8eqae1fmovq', 'IVE', '105@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0e46f140189de1eba9ab6230','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:105@artist.com', 'q2hw8eqae1fmovq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q2hw8eqae1fmovq', 'Crafting a unique sonic identity in every track.', 'IVE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1jyrhhndqkhsvqdcup6lzizelngvhpw0v4vlccmd0wmjxz1kd2','q2hw8eqae1fmovq', 'https://i.scdn.co/image/ab67616d0000b27325ef3cec1eceefd4db2f91c8', 'IVE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gz9rv3t3755r4ho3rrs4cbulfly5dk4goxz14j4ex5tw6uts9f','I AM','q2hw8eqae1fmovq','POP','70t7Q6AYG6ZgTYmJWcnkUM','https://p.scdn.co/mp3-preview/8d1fa5354093e98745ccef77ecb60fac3c9d38d0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1jyrhhndqkhsvqdcup6lzizelngvhpw0v4vlccmd0wmjxz1kd2', 'gz9rv3t3755r4ho3rrs4cbulfly5dk4goxz14j4ex5tw6uts9f', '0');
-- Mae Stephens
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('epq333zu93mrw12', 'Mae Stephens', '106@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb743f68b46b3909d5f74da093','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:106@artist.com', 'epq333zu93mrw12', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('epq333zu93mrw12', 'A confluence of cultural beats and contemporary tunes.', 'Mae Stephens');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('29ysm6vcbqyzc1f0his9we89tzjjono64jm8nrepvm7v1p9jdp','epq333zu93mrw12', 'https://i.scdn.co/image/ab67616d0000b2731fc63c898797e3dbf04ad611', 'Mae Stephens Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8i2fbcubdkqyvl27881tyi058kvve1y20fy3fa9l9wvccgwfa0','If We Ever Broke Up','epq333zu93mrw12','POP','6maTPqynTmrkWIralgGaoP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('29ysm6vcbqyzc1f0his9we89tzjjono64jm8nrepvm7v1p9jdp', '8i2fbcubdkqyvl27881tyi058kvve1y20fy3fa9l9wvccgwfa0', '0');
-- j-hope
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hsz3gc88sktxl3y', 'j-hope', '107@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeb746063d1aafa2817ea11b5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:107@artist.com', 'hsz3gc88sktxl3y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hsz3gc88sktxl3y', 'Creating a tapestry of tunes that celebrates diversity.', 'j-hope');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x1jg5owniahlorbn5jwfwo2s1d5llwlefpayafzovv3br0b2to','hsz3gc88sktxl3y', 'https://i.scdn.co/image/ab67616d0000b2735e8286ff63f7efce1881a02b', 'j-hope Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xwsd60argom1sd9a3lzf82a3mmgbyzp0odw9eadrpp1qoy820h','on the street (with J. Cole)','hsz3gc88sktxl3y','POP','5wxYxygyHpbgv0EXZuqb9V','https://p.scdn.co/mp3-preview/c69cf6ed41027bd08a5953b556cca144ff8ed2bf?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x1jg5owniahlorbn5jwfwo2s1d5llwlefpayafzovv3br0b2to', 'xwsd60argom1sd9a3lzf82a3mmgbyzp0odw9eadrpp1qoy820h', '0');
-- Wham!
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9thqfifmunbc8wo', 'Wham!', '108@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03e73d13341a8419eea9fcfb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:108@artist.com', '9thqfifmunbc8wo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9thqfifmunbc8wo', 'Crafting melodies that resonate with the soul.', 'Wham!');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xlzg91v5tg9d3huki4l2pqlj4l4vtjti61mrs5aah3jjiygjpq','9thqfifmunbc8wo', 'https://i.scdn.co/image/ab67616d0000b273f2d2adaa21ad616df6241e7d', 'Wham! Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5eijpfftgl79m85rgcy52xpwcp0ttmt4o8ryvn4j3f2qrko9u2','Last Christmas','9thqfifmunbc8wo','POP','2FRnf9qhLbvw8fu4IBXx78','https://p.scdn.co/mp3-preview/5c6b42e86dba5ec9e8346a345b3a8822b2396d3f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xlzg91v5tg9d3huki4l2pqlj4l4vtjti61mrs5aah3jjiygjpq', '5eijpfftgl79m85rgcy52xpwcp0ttmt4o8ryvn4j3f2qrko9u2', '0');
-- Baby Tate
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nnv1itfjzuq1dl4', 'Baby Tate', '109@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe7b0d119183e74ec390d7aec','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:109@artist.com', 'nnv1itfjzuq1dl4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nnv1itfjzuq1dl4', 'Revolutionizing the music scene with innovative compositions.', 'Baby Tate');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gleh0a1e8rvs3km1vfuykcg4svt4umh2dpv081nwvqz9194q78','nnv1itfjzuq1dl4', 'https://i.scdn.co/image/ab67616d0000b2732571034f34b381958f8cc727', 'Baby Tate Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z2whyg00utf9eeuucf08akfwj3ph8bu8ui791gj2j4k20908q1','Hey, Mickey!','nnv1itfjzuq1dl4','POP','3RKjTYlQrtLXCq5ncswBPp','https://p.scdn.co/mp3-preview/2bfe39402bec233fbb5b2c06ffedbbf4d6fbc38a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gleh0a1e8rvs3km1vfuykcg4svt4umh2dpv081nwvqz9194q78', 'z2whyg00utf9eeuucf08akfwj3ph8bu8ui791gj2j4k20908q1', '0');
-- Tini
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1wuo1bcqr8xcv2u', 'Tini', '110@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd1ee0c41d3c79e916b910696','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:110@artist.com', '1wuo1bcqr8xcv2u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1wuo1bcqr8xcv2u', 'Revolutionizing the music scene with innovative compositions.', 'Tini');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oz9j7t30v6aa3vv2zo12258pycre418pdpezv17f8lfcxh3yoc','1wuo1bcqr8xcv2u', 'https://i.scdn.co/image/ab67616d0000b273f5409c637b9a7244e0c0d11d', 'Tini Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2faa0rtlek6yy0frdn8ieu6aok8cc05ikk2cw9tgkae3efffxo','Cupido','1wuo1bcqr8xcv2u','POP','04ndZkbKGthTgYSv3xS7en','https://p.scdn.co/mp3-preview/15bc4fa0d69ae03a045704bcc8731def7453458b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oz9j7t30v6aa3vv2zo12258pycre418pdpezv17f8lfcxh3yoc', '2faa0rtlek6yy0frdn8ieu6aok8cc05ikk2cw9tgkae3efffxo', '0');
-- Yahritza Y Su Esencia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w84fgtc683d194j', 'Yahritza Y Su Esencia', '111@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68d4ccdc175f594122f1eee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:111@artist.com', 'w84fgtc683d194j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w84fgtc683d194j', 'Infusing traditional melodies with youthful vigor.', 'Yahritza Y Su Esencia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('s2g35mq8tevkrk04ixou4o3jxyzp88fkfm20oeuwcuf38apu0e','w84fgtc683d194j', NULL, 'Yahritza Y Su Esencia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a3qnkvgpv0g3bjur30pe58cgk924zwsudgz0f16hpz3tuo7ekw','Frgil (feat. Grupo Front','w84fgtc683d194j','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s2g35mq8tevkrk04ixou4o3jxyzp88fkfm20oeuwcuf38apu0e', 'a3qnkvgpv0g3bjur30pe58cgk924zwsudgz0f16hpz3tuo7ekw', '0');
-- Taiu
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('czzpzdapwwbjwk1', 'Taiu', '112@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdb80abf52d59577d244b8019','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:112@artist.com', 'czzpzdapwwbjwk1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('czzpzdapwwbjwk1', 'The architect of aural landscapes that inspire and captivate.', 'Taiu');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x0ajklrnrulrg37xspiaqj22xrtj2xzt0itl2848aqyjsbo6dw','czzpzdapwwbjwk1', 'https://i.scdn.co/image/ab67616d0000b273d467bed4e6b2a01ea8569100', 'Taiu Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q2wj7fhg33yet89obeztaw6mdkqpq2l8slln52cjoalwp1m7j8','Rara Vez','czzpzdapwwbjwk1','POP','7MVIfkyzuUmQ716j8U7yGR',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x0ajklrnrulrg37xspiaqj22xrtj2xzt0itl2848aqyjsbo6dw', 'q2wj7fhg33yet89obeztaw6mdkqpq2l8slln52cjoalwp1m7j8', '0');
-- Abhijay Sharma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u452fj5r2cpppqh', 'Abhijay Sharma', '113@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf58e0bff09fc766a22cd3bdb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:113@artist.com', 'u452fj5r2cpppqh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u452fj5r2cpppqh', 'A confluence of cultural beats and contemporary tunes.', 'Abhijay Sharma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tsthpo2w2az46xfu6vym1pdam0yhdtg8yxqmkuv4jot2z5ukcc','u452fj5r2cpppqh', NULL, 'Abhijay Sharma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jixz7wim6ln1mv1w337fneq12czh4446vvq0cfoexvo05700sa','Obsessed','u452fj5r2cpppqh','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tsthpo2w2az46xfu6vym1pdam0yhdtg8yxqmkuv4jot2z5ukcc', 'jixz7wim6ln1mv1w337fneq12czh4446vvq0cfoexvo05700sa', '0');
-- Coldplay
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dkypn0hexwx19vv', 'Coldplay', '114@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb989ed05e1f0570cc4726c2d3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:114@artist.com', 'dkypn0hexwx19vv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dkypn0hexwx19vv', 'Global icons in rock, known for their anthemic songs and impactful lyrics.', 'Coldplay');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l4jps0um2onwkrs1fgtp63a13xb1c5nphm3ofld3w6qytgxnfp','dkypn0hexwx19vv', 'https://i.scdn.co/image/ab67616d0000b273e21cc1db05580b6f2d2a3b6e', 'Coldplay Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3a3r989q2iceq646vpmu0724plsnpl4sif8007ww36ayhmakd3','Viva La Vida','dkypn0hexwx19vv','POP','1mea3bSkSGXuIRvnydlB5b','https://p.scdn.co/mp3-preview/fb9f4a9b0887326776b4fb7c6d331acd167a7778?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l4jps0um2onwkrs1fgtp63a13xb1c5nphm3ofld3w6qytgxnfp', '3a3r989q2iceq646vpmu0724plsnpl4sif8007ww36ayhmakd3', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kz9ysq50m9tbtf9pysozhi3oakjnld35f8egnsw5t0awnocend','My Universe','dkypn0hexwx19vv','POP','3FeVmId7tL5YN8B7R3imoM','https://p.scdn.co/mp3-preview/e6b780d0df7927114477a786b6a638cf40d19579?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l4jps0um2onwkrs1fgtp63a13xb1c5nphm3ofld3w6qytgxnfp', 'kz9ysq50m9tbtf9pysozhi3oakjnld35f8egnsw5t0awnocend', '1');
-- Tory Lanez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('67eo2vrmmyeq2p2', 'Tory Lanez', '115@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebbd5d3e1b363c3e26710661c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:115@artist.com', '67eo2vrmmyeq2p2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('67eo2vrmmyeq2p2', 'Creating a tapestry of tunes that celebrates diversity.', 'Tory Lanez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jd5zpfypv40crmrvoj1f0mswh5xt1u04i1kh64zizfa6fbpid4','67eo2vrmmyeq2p2', 'https://i.scdn.co/image/ab67616d0000b2730c5f23cbf0b1ab7e37d0dc67', 'Tory Lanez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('56fdg6jyna6a4s74271oeqoi072ypug4gg3so1226nql6lbp9k','The Color Violet','67eo2vrmmyeq2p2','POP','3azJifCSqg9fRij2yKIbWz','https://p.scdn.co/mp3-preview/1d7c627bf549328110519c4bd21ac39d7ca50ea1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jd5zpfypv40crmrvoj1f0mswh5xt1u04i1kh64zizfa6fbpid4', '56fdg6jyna6a4s74271oeqoi072ypug4gg3so1226nql6lbp9k', '0');
-- Grupo Marca Registrada
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h9h44nfm7i7zqlb', 'Grupo Marca Registrada', '116@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8059103a66f9c25b91b375a9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:116@artist.com', 'h9h44nfm7i7zqlb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h9h44nfm7i7zqlb', 'A unique voice in the contemporary music scene.', 'Grupo Marca Registrada');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oc3x68bqjmdcbk82ph6p3ewdif9qwbh947c28e7db6vcp90ei5','h9h44nfm7i7zqlb', 'https://i.scdn.co/image/ab67616d0000b273bae22025cf282ad72b167e79', 'Grupo Marca Registrada Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tea3up12v5jztyhnzwnpdnxbpohlunwugyoa5z9fapvpf9kcw0','Di Que Si','h9h44nfm7i7zqlb','POP','0pliiCOWPN0IId8sXAqNJr','https://p.scdn.co/mp3-preview/622a816595469fdb54c42c88259f303266dc8aa7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oc3x68bqjmdcbk82ph6p3ewdif9qwbh947c28e7db6vcp90ei5', 'tea3up12v5jztyhnzwnpdnxbpohlunwugyoa5z9fapvpf9kcw0', '0');
-- Latto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mti0w9nphg997kb', 'Latto', '117@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:117@artist.com', 'mti0w9nphg997kb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mti0w9nphg997kb', 'A bold and dynamic rapper, making waves with her fiery lyrics.', 'Latto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jvj5epwucl9kx7x7v1w38wey50bs1ljkoagkk00k4divege1me','mti0w9nphg997kb', NULL, 'Latto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9niwhcde5sf4emhkiu3jlpkikwmwbyfq5v17qm2x4mc83uu4fx','Seven (feat. Latto) (Explicit Ver.)','mti0w9nphg997kb','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jvj5epwucl9kx7x7v1w38wey50bs1ljkoagkk00k4divege1me', '9niwhcde5sf4emhkiu3jlpkikwmwbyfq5v17qm2x4mc83uu4fx', '0');
-- Jung Kook
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jmuoix56igqqr1d', 'Jung Kook', '118@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:118@artist.com', 'jmuoix56igqqr1d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jmuoix56igqqr1d', 'A member of BTS, captivating fans with his powerful vocals and dynamic performances.', 'Jung Kook');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nvbycq46yqljpz4po36u7pvyhxnglbm750vktjtfdyb8r0fdbi','jmuoix56igqqr1d', 'https://i.scdn.co/image/ab67616d0000b273a7f42c375578df426b37638d', 'Jung Kook Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0gh939quogd1e735pacf97fv3r0nckxpqhnsnevhaagstch1iz','Still With You','jmuoix56igqqr1d','POP','0eFMbKCRw8KByXyWBw8WO7','https://p.scdn.co/mp3-preview/af2a740e10a6956dedd7e7f66fd65d7166e9187f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nvbycq46yqljpz4po36u7pvyhxnglbm750vktjtfdyb8r0fdbi', '0gh939quogd1e735pacf97fv3r0nckxpqhnsnevhaagstch1iz', '0');
-- BTS
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('84qfgo9yalpx833', 'BTS', '119@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd642648235ebf3460d2d1f6a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:119@artist.com', '84qfgo9yalpx833', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('84qfgo9yalpx833', 'A global phenomenon, setting new standards in K-pop with their music and performances.', 'BTS');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rg30b8crm1qpw004g5ugxj574gncq947u0pbir7jzxsdpw39ie','84qfgo9yalpx833', 'https://i.scdn.co/image/ab67616d0000b2738a701e76e8845928f6cd81c8', 'BTS Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('eh85yl3qfdjtoaj8s3sdfaxt1xkizaupe957yqufbuim6dap49','Take Two','84qfgo9yalpx833','POP','5IAESfJjmOYu7cHyX557kz','https://p.scdn.co/mp3-preview/ef43da30a06fcad16898e9fff1cadd0ccf953fc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rg30b8crm1qpw004g5ugxj574gncq947u0pbir7jzxsdpw39ie', 'eh85yl3qfdjtoaj8s3sdfaxt1xkizaupe957yqufbuim6dap49', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7af9bum3t5toxlfvwb0trzho7515pfr73rb6h9oy4flht51vwl','Dreamers [Music from the FIFA World Cup Qatar 2022 Official Soundtrack]','84qfgo9yalpx833','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rg30b8crm1qpw004g5ugxj574gncq947u0pbir7jzxsdpw39ie', '7af9bum3t5toxlfvwb0trzho7515pfr73rb6h9oy4flht51vwl', '1');
-- Mr.Kitty
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2d5q6anzi7cx8k0', 'Mr.Kitty', '120@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb78ed447c78f07632e82ec0d8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:120@artist.com', '2d5q6anzi7cx8k0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2d5q6anzi7cx8k0', 'The heartbeat of a new generation of music lovers.', 'Mr.Kitty');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rio3z8xudlewk9u4dr51cgtfbwrjxehhynjfkhrxpd041pd0t3','2d5q6anzi7cx8k0', 'https://i.scdn.co/image/ab67616d0000b273b492477206075438e0751176', 'Mr.Kitty Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hjl9jwdxdmkutk9zy6hxgr6j6qofn0jkejw4bhv07d6cdqnx51','After Dark','2d5q6anzi7cx8k0','POP','2LKOHdMsL0K9KwcPRlJK2v','https://p.scdn.co/mp3-preview/eb9de15a4465f504ee0eadba93e7d265ee0ee6ba?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rio3z8xudlewk9u4dr51cgtfbwrjxehhynjfkhrxpd041pd0t3', 'hjl9jwdxdmkutk9zy6hxgr6j6qofn0jkejw4bhv07d6cdqnx51', '0');
-- The Police
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xtreus97h1310i8', 'The Police', '121@artist.com', 'https://i.scdn.co/image/1f73a61faca2942cd5ea29c2143184db8645f0b3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:121@artist.com', 'xtreus97h1310i8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xtreus97h1310i8', 'Crafting a unique sonic identity in every track.', 'The Police');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nmny1i4ri9jk5mq6tdaxqsttvxep3cjbqewlw69bshae0fnb4y','xtreus97h1310i8', 'https://i.scdn.co/image/ab67616d0000b2730408dc279dd7c7354ff41014', 'The Police Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gbmjkl8vbzjpytdybuvs58jrjzmuk0vpm3taob8wm2dosmtdui','Every Breath You Take - Remastered 2003','xtreus97h1310i8','POP','0wF2zKJmgzjPTfircPJ2jg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nmny1i4ri9jk5mq6tdaxqsttvxep3cjbqewlw69bshae0fnb4y', 'gbmjkl8vbzjpytdybuvs58jrjzmuk0vpm3taob8wm2dosmtdui', '0');
-- Chino Pacas
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('krr10rrtr1z3pe2', 'Chino Pacas', '122@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8ff524b416384fe673ebf52e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:122@artist.com', 'krr10rrtr1z3pe2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('krr10rrtr1z3pe2', 'An odyssey of sound that defies conventions.', 'Chino Pacas');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j0c6jqhz45ptsmui5xkc9w53sin5srmtg2c6nujhsbi8z975ja','krr10rrtr1z3pe2', 'https://i.scdn.co/image/ab67616d0000b2736a6ab689151163a1e9f60f36', 'Chino Pacas Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ljrh5yha8czj4ef9ynfna38r1ebcnlo0dm9za94dx5dk4vjgap','El Gordo Trae El Mando','krr10rrtr1z3pe2','POP','3kf0WdFOalKWBkCCLJo4mA','https://p.scdn.co/mp3-preview/b7989992ce6651eea980627ad17b1f9a2fa2a224?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j0c6jqhz45ptsmui5xkc9w53sin5srmtg2c6nujhsbi8z975ja', 'ljrh5yha8czj4ef9ynfna38r1ebcnlo0dm9za94dx5dk4vjgap', '0');
-- Charlie Puth
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z7ncakwhqoase34', 'Charlie Puth', '123@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb63de91415970a2f5bc920fa8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:123@artist.com', 'z7ncakwhqoase34', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z7ncakwhqoase34', 'A pop maestro, combining catchy melodies with his exceptional musical talent.', 'Charlie Puth');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ycg39uw7liyp4j7cbyvtb6dym7cgev0qaqfl4iwnqi7ad5wk71','z7ncakwhqoase34', 'https://i.scdn.co/image/ab67616d0000b27335d2e0ed94a934f2cc46fa49', 'Charlie Puth Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('049nhuibyf4ygye2s1j39ytgdiraygq9jjrr0dew1r5sgv94g4','Left and Right (Feat. Jung Kook of BTS)','z7ncakwhqoase34','POP','5Odq8ohlgIbQKMZivbWkEo','https://p.scdn.co/mp3-preview/9e4342eefa4f33df4e9b199e60dbce0f59e46eff?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ycg39uw7liyp4j7cbyvtb6dym7cgev0qaqfl4iwnqi7ad5wk71', '049nhuibyf4ygye2s1j39ytgdiraygq9jjrr0dew1r5sgv94g4', '0');
-- Ariana Grande
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xxjc9uer6abqftk', 'Ariana Grande', '124@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb456c82553e0efcb7e13365b1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:124@artist.com', 'xxjc9uer6abqftk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xxjc9uer6abqftk', 'A powerhouse vocalist, dominating pop with her range and iconic style.', 'Ariana Grande');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wapz44dmw0hj38ffx16sgq6mhbtyfjv3961a1ifzfqp410hfly','xxjc9uer6abqftk', NULL, 'Ariana Grande Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xkclfnjxwouqqx9d9as9zndq7vbi01m2w4k2fq1e6q4dtghnu1','Die For You - Remix','xxjc9uer6abqftk','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wapz44dmw0hj38ffx16sgq6mhbtyfjv3961a1ifzfqp410hfly', 'xkclfnjxwouqqx9d9as9zndq7vbi01m2w4k2fq1e6q4dtghnu1', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u3shy4t0tg2y5h0adr80m3aqzflj2khzmc916gvzsfil0fz088','Save Your Tears (with Ariana Grande) (Remix)','xxjc9uer6abqftk','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wapz44dmw0hj38ffx16sgq6mhbtyfjv3961a1ifzfqp410hfly', 'u3shy4t0tg2y5h0adr80m3aqzflj2khzmc916gvzsfil0fz088', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wwy4vn7sqy51edb9ase5raqzb52qd748x8xmhl5uoed92v5ykw','Santa Tell Me','xxjc9uer6abqftk','POP','0lizgQ7Qw35od7CYaoMBZb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wapz44dmw0hj38ffx16sgq6mhbtyfjv3961a1ifzfqp410hfly', 'wwy4vn7sqy51edb9ase5raqzb52qd748x8xmhl5uoed92v5ykw', '2');
-- Em Beihold
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('80ebijrg2851bj2', 'Em Beihold', '125@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb23c885de4c81852c917608ac','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:125@artist.com', '80ebijrg2851bj2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('80ebijrg2851bj2', 'A voice that captivates, combining depth of lyrics with a melodic finesse.', 'Em Beihold');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4k4b9vq9r3jemi0hk4fm5rfdm85naorgew05ofby4x4vs0fkcw','80ebijrg2851bj2', NULL, 'Em Beihold Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2zsu2xtlmfe216w0yturj4i0hh5cl47v47r6s6w3rwoadqgcut','Until I Found You (with Em Beihold) - Em Beihold Version','80ebijrg2851bj2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4k4b9vq9r3jemi0hk4fm5rfdm85naorgew05ofby4x4vs0fkcw', '2zsu2xtlmfe216w0yturj4i0hh5cl47v47r6s6w3rwoadqgcut', '0');
-- Zach Bryan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('77skuudzykl0avr', 'Zach Bryan', '126@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4fd54df35bfcfa0fc9fc2da7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:126@artist.com', '77skuudzykl0avr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('77skuudzykl0avr', 'Delivering soul-stirring tunes that linger in the mind.', 'Zach Bryan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nya43quaqiihdgu5zh5zrq3gl75ywe6ugivod24b641s7396cj','77skuudzykl0avr', 'https://i.scdn.co/image/ab67616d0000b273b2b6670e3aca9bcd55fbabbb', 'Zach Bryan Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r31uu0j0pp3yhqxezuu9ovobqzu17pf81lmldjlxbpul6ukxw7','Something in the Orange','77skuudzykl0avr','POP','3WMj8moIAXJhHsyLaqIIHI','https://p.scdn.co/mp3-preview/d33dc9df586e24c9d8f640df08b776d94680f529?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nya43quaqiihdgu5zh5zrq3gl75ywe6ugivod24b641s7396cj', 'r31uu0j0pp3yhqxezuu9ovobqzu17pf81lmldjlxbpul6ukxw7', '0');
-- Niall Horan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fs001is4afic0a9', 'Niall Horan', '127@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeccc1cde8e9fdcf1c9289897','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:127@artist.com', 'fs001is4afic0a9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fs001is4afic0a9', 'An odyssey of sound that defies conventions.', 'Niall Horan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ybmfnle86sceo42dipd1uipt0cn4qtsfjashcljrso9v8eqby8','fs001is4afic0a9', 'https://i.scdn.co/image/ab67616d0000b2732a368fea49f5c489a9dc3949', 'Niall Horan Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lw6dyk6yf8unyrrx4k8dticlm3mighwtiufc77z8vsgu21uy98','Heaven','fs001is4afic0a9','POP','5FQ77Cl1ndljtwwImdtjMy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ybmfnle86sceo42dipd1uipt0cn4qtsfjashcljrso9v8eqby8', 'lw6dyk6yf8unyrrx4k8dticlm3mighwtiufc77z8vsgu21uy98', '0');
-- Kaliii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('quzqee8tlzs2n55', 'Kaliii', '128@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb749bcc7f4b8d1d60f5f13744','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:128@artist.com', 'quzqee8tlzs2n55', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('quzqee8tlzs2n55', 'Crafting melodies that resonate with the soul.', 'Kaliii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xuu4g9dcejgeecygtojdrwerj53bww52jfdcnbmsvzkbyz6v5w','quzqee8tlzs2n55', 'https://i.scdn.co/image/ab67616d0000b2733eecc265c134153c14794aab', 'Kaliii Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hfaqepuqf97rp0wbehcn7rxqtdkat0lxcglxvl4f1mo68pvs10','Area Codes','quzqee8tlzs2n55','POP','7sliFe6W30tPBPh6dvZsIH','https://p.scdn.co/mp3-preview/d1beed2734f948ec9c33164d3aa818e04f4afd30?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xuu4g9dcejgeecygtojdrwerj53bww52jfdcnbmsvzkbyz6v5w', 'hfaqepuqf97rp0wbehcn7rxqtdkat0lxcglxvl4f1mo68pvs10', '0');
-- Chris Molitor
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x3mbza3j9mt3c4p', 'Chris Molitor', '129@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03851b1c2471a8c0b57371c4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:129@artist.com', 'x3mbza3j9mt3c4p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x3mbza3j9mt3c4p', 'Delivering heartfelt music that speaks to the soul, blending folk and indie vibes.', 'Chris Molitor');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kqfd2euq5tlzkam19dn5m6dq38oobklvwd7unwotjlwel6x9mn','x3mbza3j9mt3c4p', 'https://i.scdn.co/image/ab67616d0000b273be011d16b9360a7dee109774', 'Chris Molitor Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9j50yxgvsstlobvp6ap2vrwga1eibrd3fege8ut2sl03fk7lsy','Yellow','x3mbza3j9mt3c4p','POP','6tvs7zEP8d1SBgSqZQ84OT','https://p.scdn.co/mp3-preview/ea93f9b43fc638111ad661719037bfb88cd9c05d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kqfd2euq5tlzkam19dn5m6dq38oobklvwd7unwotjlwel6x9mn', '9j50yxgvsstlobvp6ap2vrwga1eibrd3fege8ut2sl03fk7lsy', '0');
-- Twisted
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b0ycqgo0hpslpci', 'Twisted', '130@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2615ef39cf9128c447b31619','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:130@artist.com', 'b0ycqgo0hpslpci', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b0ycqgo0hpslpci', 'Sculpting soundwaves into masterpieces of auditory art.', 'Twisted');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zynk4fh4zg43qc0svcmf270tw8mzvrqz1e0ffkptcipye9grg7','b0ycqgo0hpslpci', 'https://i.scdn.co/image/ab67616d0000b273f5e2ffd88f07e55f34c361c8', 'Twisted Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kai5mos21h9059vuyj7j2hslo7m46l2g7wlhmfm4g2ki3yxvyd','WORTH NOTHING','b0ycqgo0hpslpci','POP','3PjbA0O5olhampPMdaB0V1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zynk4fh4zg43qc0svcmf270tw8mzvrqz1e0ffkptcipye9grg7', 'kai5mos21h9059vuyj7j2hslo7m46l2g7wlhmfm4g2ki3yxvyd', '0');
-- The Kid Laroi
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w3qn48zu6o0gash', 'The Kid Laroi', '131@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb393666951ab8b14e9c4ed386','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:131@artist.com', 'w3qn48zu6o0gash', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w3qn48zu6o0gash', 'Redefining what it means to be an artist in the digital age.', 'The Kid Laroi');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e25kess8ic10f4062wjx233k0l2o5b8fd8avff2daprm1ntyxn','w3qn48zu6o0gash', 'https://i.scdn.co/image/ab67616d0000b273a53643fc03785efb9926443d', 'The Kid Laroi Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yhlesj2h2gh1pw852yfr91ysv1et1q2fp6z0c3zlbehn37cxfm','Love Again','w3qn48zu6o0gash','POP','4sx6NRwL6Ol3V6m9exwGlQ','https://p.scdn.co/mp3-preview/4baae2685eaac7401ae183c54642c9ddf3b9e057?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e25kess8ic10f4062wjx233k0l2o5b8fd8avff2daprm1ntyxn', 'yhlesj2h2gh1pw852yfr91ysv1et1q2fp6z0c3zlbehn37cxfm', '0');
-- Linkin Park
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5om1qz7k4n12ylw', 'Linkin Park', '132@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb811da3b2e7c9e5a9c1a6c4f7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:132@artist.com', '5om1qz7k4n12ylw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5om1qz7k4n12ylw', 'Transcending language barriers through the universal language of music.', 'Linkin Park');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jxzs4fy0m9z3i6ur2qabushxmrrjf88iqdrlf4usq9cv2anu1h','5om1qz7k4n12ylw', 'https://i.scdn.co/image/ab67616d0000b273b4ad7ebaf4575f120eb3f193', 'Linkin Park Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hgysut6f3xmiapgng415qy9o9t1oj9ld5i69gtkm2p84mwfg60','Numb','5om1qz7k4n12ylw','POP','2nLtzopw4rPReszdYBJU6h','https://p.scdn.co/mp3-preview/15e1178c9eb7f626ac1112ad8f56eccbec2cd6e5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jxzs4fy0m9z3i6ur2qabushxmrrjf88iqdrlf4usq9cv2anu1h', 'hgysut6f3xmiapgng415qy9o9t1oj9ld5i69gtkm2p84mwfg60', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('20o2brewz4aqjclo08i7ui9ojbs20oy1ha8bi4y3xo9jb6im83','In The End','5om1qz7k4n12ylw','POP','60a0Rd6pjrkxjPbaKzXjfq','https://p.scdn.co/mp3-preview/b5ee275ca337899f762b1c1883c11e24a04075b0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jxzs4fy0m9z3i6ur2qabushxmrrjf88iqdrlf4usq9cv2anu1h', '20o2brewz4aqjclo08i7ui9ojbs20oy1ha8bi4y3xo9jb6im83', '1');
-- Tyler
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4p8xrov0esskrg4', 'Tyler', '133@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8278b782cbb5a3963db88ada','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:133@artist.com', '4p8xrov0esskrg4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4p8xrov0esskrg4', 'A sonic adventurer, always seeking new horizons in music.', 'Tyler');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ve17sso4khz36z3wmv2ud89h8icgndhbw333zci862wihijko8','4p8xrov0esskrg4', 'https://i.scdn.co/image/ab67616d0000b273aa95a399fd30fbb4f6f59fca', 'Tyler Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xmljt20fe02kkz6db20djc5mttko29zloiv25f1wflgbzzhap5','DOGTOOTH','4p8xrov0esskrg4','POP','6OfOzTitafSnsaunQLuNFw','https://p.scdn.co/mp3-preview/5de4c8c30108bc114f9f38a28ac0832936a852bf?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ve17sso4khz36z3wmv2ud89h8icgndhbw333zci862wihijko8', 'xmljt20fe02kkz6db20djc5mttko29zloiv25f1wflgbzzhap5', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8hrv0ruwfcvv5e2t7mbzjjehafybvop6b4xsbpjkvg9xpyr51u','SORRY NOT SORRY','4p8xrov0esskrg4','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ve17sso4khz36z3wmv2ud89h8icgndhbw333zci862wihijko8', '8hrv0ruwfcvv5e2t7mbzjjehafybvop6b4xsbpjkvg9xpyr51u', '1');
-- Lewis Capaldi
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gjdf8edgb54kkmr', 'Lewis Capaldi', '134@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebea7538654040e553a7b0fc28','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:134@artist.com', 'gjdf8edgb54kkmr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gjdf8edgb54kkmr', 'Delivering emotional ballads with his powerful, soul-stirring voice.', 'Lewis Capaldi');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('k97ed46cxg72o52136ekosj8mfqdou2jb0liapirkyu574ex3y','gjdf8edgb54kkmr', 'https://i.scdn.co/image/ab67616d0000b273fc2101e6889d6ce9025f85f2', 'Lewis Capaldi Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('572ru2b6ap3mz6kzlx0xinwk2ree8jpd887j7xwoxsn2fi67c3','Someone You Loved','gjdf8edgb54kkmr','POP','7qEHsqek33rTcFNT9PFqLf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k97ed46cxg72o52136ekosj8mfqdou2jb0liapirkyu574ex3y', '572ru2b6ap3mz6kzlx0xinwk2ree8jpd887j7xwoxsn2fi67c3', '0');
-- Fuerza Regida
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b1eqw3t9h5ztkmb', 'Fuerza Regida', '135@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1b85fbf9507041aab224336d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:135@artist.com', 'b1eqw3t9h5ztkmb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b1eqw3t9h5ztkmb', 'Revitalizing the regional music scene with their unique sound and powerful lyrics.', 'Fuerza Regida');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yhophwza2hhy9mlyv3ij1w5lh8x6fthyff4qax0onsnowilr3w','b1eqw3t9h5ztkmb', 'https://i.scdn.co/image/ab67616d0000b273cfe3eb72c48b93971e53efd9', 'Fuerza Regida Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f5lngzpowciddgzth6xjx0r4npsy724slvaakihms9yrn2a6v1','SABOR FRESA','b1eqw3t9h5ztkmb','POP','1UMm1Qs3u59Wvk53zBUE8r','https://p.scdn.co/mp3-preview/590ae0b69465339d97ef5db9f7e36fe0c452fbb4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yhophwza2hhy9mlyv3ij1w5lh8x6fthyff4qax0onsnowilr3w', 'f5lngzpowciddgzth6xjx0r4npsy724slvaakihms9yrn2a6v1', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fbaixe1v2554tkdr36y53oijbr0yoshaieb3k9autjmk9z79zn','TQM','b1eqw3t9h5ztkmb','POP','368eeEO3Y2uZUQ6S5oIjcu','https://p.scdn.co/mp3-preview/63f6b66cfcc3d7bd396dcbe18d6e3dee05fdb956?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yhophwza2hhy9mlyv3ij1w5lh8x6fthyff4qax0onsnowilr3w', 'fbaixe1v2554tkdr36y53oijbr0yoshaieb3k9autjmk9z79zn', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('low1zndqlir40h3szu7ajcklf110mozywfu4uxjl1t8ptut2bt','Bebe Dame','b1eqw3t9h5ztkmb','POP','0IKeDy5bT9G0bA7ZixRT4A','https://p.scdn.co/mp3-preview/408ffb4fffcd26cda82f2b3cda7726ea1f6ebd74?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yhophwza2hhy9mlyv3ij1w5lh8x6fthyff4qax0onsnowilr3w', 'low1zndqlir40h3szu7ajcklf110mozywfu4uxjl1t8ptut2bt', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uddahvu8vdi3zn8et6hhlg1zejdl9k1pzuxueb0uxjj3co9f7l','Ch y la Pizza','b1eqw3t9h5ztkmb','POP','0UbesRsX2TtiCeamOIVEkp','https://p.scdn.co/mp3-preview/212acba217ff0304f6cbb41eb8f43cd27d991c7b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yhophwza2hhy9mlyv3ij1w5lh8x6fthyff4qax0onsnowilr3w', 'uddahvu8vdi3zn8et6hhlg1zejdl9k1pzuxueb0uxjj3co9f7l', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mne5ikidiqe0blvhkebn9jh66fxurzjnmufiay4nxtcg45csgw','Igualito a Mi Ap','b1eqw3t9h5ztkmb','POP','17js0w8GTkTUFGFM6PYvBd','https://p.scdn.co/mp3-preview/f0f87682468e9baa92562cd4d797ce8af5337ca6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yhophwza2hhy9mlyv3ij1w5lh8x6fthyff4qax0onsnowilr3w', 'mne5ikidiqe0blvhkebn9jh66fxurzjnmufiay4nxtcg45csgw', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v0ldqt3ko14zmjf1ns5scgn90oen6ctr78oa1a4jmx0tcz6x6h','Dijeron Que No La Iba Lograr','b1eqw3t9h5ztkmb','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yhophwza2hhy9mlyv3ij1w5lh8x6fthyff4qax0onsnowilr3w', 'v0ldqt3ko14zmjf1ns5scgn90oen6ctr78oa1a4jmx0tcz6x6h', '5');
-- MC Caverinha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h9upwgmu9xx2skn', 'MC Caverinha', '136@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb48d62acd2e6408096141a088','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:136@artist.com', 'h9upwgmu9xx2skn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h9upwgmu9xx2skn', 'Pioneering new paths in the musical landscape.', 'MC Caverinha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ihsksy6h9g25i698e1r6mtixkain8ltpdjise91y3e5in7o22y','h9upwgmu9xx2skn', NULL, 'MC Caverinha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yhxthqc6kmxyp9hf9rfz4cizt9mdmc6npimjsj9bplfso7x00d','Carto B','h9upwgmu9xx2skn','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ihsksy6h9g25i698e1r6mtixkain8ltpdjise91y3e5in7o22y', 'yhxthqc6kmxyp9hf9rfz4cizt9mdmc6npimjsj9bplfso7x00d', '0');
-- TAEYANG
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('et8kz2x455sxo14', 'TAEYANG', '137@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb496189630cd3cb0c7b593fee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:137@artist.com', 'et8kz2x455sxo14', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('et8kz2x455sxo14', 'Sculpting soundwaves into masterpieces of auditory art.', 'TAEYANG');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('twuj907x5jl32kdwodzhngil2l7c6blnmnqnfaqyv3shbnmmtj','et8kz2x455sxo14', 'https://i.scdn.co/image/ab67616d0000b27346313223adf2b6d726388328', 'TAEYANG Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6wgripjxmsfee9nw9epm4ipcr2oww3s47pprb8ijos6dr9nfw7','Shoong! (feat. LISA of BLACKPINK)','et8kz2x455sxo14','POP','5HrIcZOo1DysX53qDRlRnt',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('twuj907x5jl32kdwodzhngil2l7c6blnmnqnfaqyv3shbnmmtj', '6wgripjxmsfee9nw9epm4ipcr2oww3s47pprb8ijos6dr9nfw7', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h6f0g6zv4efi6gmlhci3qp9d3lclr64mxxbej1cnf8zzkmgtyf','VIBE (feat. Jimin of BTS)','et8kz2x455sxo14','POP','4NIe9Is7bN5JWyTeCW2ahK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('twuj907x5jl32kdwodzhngil2l7c6blnmnqnfaqyv3shbnmmtj', 'h6f0g6zv4efi6gmlhci3qp9d3lclr64mxxbej1cnf8zzkmgtyf', '1');
-- Dave
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tq2c5c74w38u0fk', 'Dave', '138@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:138@artist.com', 'tq2c5c74w38u0fk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tq2c5c74w38u0fk', 'A master of words, blending rap with social commentary and raw emotion.', 'Dave');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('itv6v1l96vqggqa0g2t4hlbqa0cmnxmzkpkudmc5j3qc72rxwe','tq2c5c74w38u0fk', 'https://i.scdn.co/image/ab67616d0000b273e3a09a9ae3f1fa102c110e60', 'Dave Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w30sbs0awylgmisnrqpaqpdpisdx5unr1du70u8v8av0bn77wz','Sprinter','tq2c5c74w38u0fk','POP','2FDTHlrBguDzQkp7PVj16Q',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('itv6v1l96vqggqa0g2t4hlbqa0cmnxmzkpkudmc5j3qc72rxwe', 'w30sbs0awylgmisnrqpaqpdpisdx5unr1du70u8v8av0bn77wz', '0');
-- Maroon 5
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fm0rqjueerd4n30', 'Maroon 5', '139@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:139@artist.com', 'fm0rqjueerd4n30', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fm0rqjueerd4n30', 'Revolutionizing the music scene with innovative compositions.', 'Maroon 5');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x5fmwf67dv2mzcrjy7xrdqg6mww808djpvardjuo95jtyknfxu','fm0rqjueerd4n30', 'https://i.scdn.co/image/ab67616d0000b273ce7d499847da02a9cbd1c084', 'Maroon 5 Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cavtij876wdfpzq21f8rg51u4rvmhahkamvc392o6e2zbgqbqc','Payphone','fm0rqjueerd4n30','POP','4P0osvTXoSYZZC2n8IFH3c',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x5fmwf67dv2mzcrjy7xrdqg6mww808djpvardjuo95jtyknfxu', 'cavtij876wdfpzq21f8rg51u4rvmhahkamvc392o6e2zbgqbqc', '0');
-- Kate Bush
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6jo4vhia432umm2', 'Kate Bush', '140@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb187017724e58e78ee1f5a8e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:140@artist.com', '6jo4vhia432umm2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6jo4vhia432umm2', 'A unique voice in the contemporary music scene.', 'Kate Bush');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('othz8xgotsqma0hms86khmne2uhxy7wt9qvwb8krvvld7gy6oa','6jo4vhia432umm2', 'https://i.scdn.co/image/ab67616d0000b273ad08f4b38efbff0c0da0f252', 'Kate Bush Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iietkyt06nl1n7l15phxc5xevgzvx2oxisptr64tcfipkdiqrf','Running Up That Hill (A Deal With God)','6jo4vhia432umm2','POP','1PtQJZVZIdWIYdARpZRDFO','https://p.scdn.co/mp3-preview/861d26b52ece3e3ad72a7dc3463daece3478801a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('othz8xgotsqma0hms86khmne2uhxy7wt9qvwb8krvvld7gy6oa', 'iietkyt06nl1n7l15phxc5xevgzvx2oxisptr64tcfipkdiqrf', '0');
-- Meghan Trainor
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mkyowg4omy5jxuw', 'Meghan Trainor', '141@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4d8f97058ff993df0f4eb9ee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:141@artist.com', 'mkyowg4omy5jxuw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mkyowg4omy5jxuw', 'Delivering soul-stirring tunes that linger in the mind.', 'Meghan Trainor');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mxcjgxtq4jpil3k0r0dyns4kziswrzc2vgaws46az9vzizx3kk','mkyowg4omy5jxuw', 'https://i.scdn.co/image/ab67616d0000b2731a4f1ada93881da4ca8060ff', 'Meghan Trainor Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ff40kse0nh78867t8w7pwln16jk49eiwf74smjrknadvh1vz9w','Made You Look','mkyowg4omy5jxuw','POP','0QHEIqNKsMoOY5urbzN48u','https://p.scdn.co/mp3-preview/f0eb89945aa820c0f30b5e97f8e2cab42d9f0a99?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mxcjgxtq4jpil3k0r0dyns4kziswrzc2vgaws46az9vzizx3kk', 'ff40kse0nh78867t8w7pwln16jk49eiwf74smjrknadvh1vz9w', '0');
-- Nicky Youre
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ywn6cswp8w7fq0m', 'Nicky Youre', '142@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe726c8549d387a241f979acd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:142@artist.com', 'ywn6cswp8w7fq0m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ywn6cswp8w7fq0m', 'A journey through the spectrum of sound in every album.', 'Nicky Youre');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3pkvt136fav1q4fwhbcuc7ccbbiovkadoo5wotn247d1dn871e','ywn6cswp8w7fq0m', 'https://i.scdn.co/image/ab67616d0000b273ecd970d1d2623b6c7fc6080c', 'Nicky Youre Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lt1fv1i7r130fk8u5yuyam6mms4wwa3qga4exjrkzzll6j2c96','Sunroof','ywn6cswp8w7fq0m','POP','5YqEzk3C5c3UZ1D5fJUlXA','https://p.scdn.co/mp3-preview/605058558fd8d10c420b56c41555e567645d5b60?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3pkvt136fav1q4fwhbcuc7ccbbiovkadoo5wotn247d1dn871e', 'lt1fv1i7r130fk8u5yuyam6mms4wwa3qga4exjrkzzll6j2c96', '0');
-- Ruth B.
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6sk8rkuroxnqxhf', 'Ruth B.', '143@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1da7ba1c178ab9f68d065197','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:143@artist.com', '6sk8rkuroxnqxhf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6sk8rkuroxnqxhf', 'An endless quest for musical perfection.', 'Ruth B.');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('s9dtgsyvrf69mpguvgw06ikcxga83ukjtm8mw5b2r9yexaopbp','6sk8rkuroxnqxhf', 'https://i.scdn.co/image/ab67616d0000b27397e971f3e53475091dc8d707', 'Ruth B. Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tpn68v2aflnu3r7gcswyigoy5c1nxw4norwz8lliwogqkzsqn4','Dandelions','6sk8rkuroxnqxhf','POP','2eAvDnpXP5W0cVtiI0PUxV','https://p.scdn.co/mp3-preview/3e55602bc286bc1fad9347931327e649ff9adfa1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s9dtgsyvrf69mpguvgw06ikcxga83ukjtm8mw5b2r9yexaopbp', 'tpn68v2aflnu3r7gcswyigoy5c1nxw4norwz8lliwogqkzsqn4', '0');
-- Mc Pedrinho
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gyh5vy5kugb7gri', 'Mc Pedrinho', '144@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba19ab278a7a01b077bb17e75','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:144@artist.com', 'gyh5vy5kugb7gri', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gyh5vy5kugb7gri', 'Pioneering new paths in the musical landscape.', 'Mc Pedrinho');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t6vtsr73y94lb2r4ct45mwu9ffrizr9am42sorpxnr7nxumd0m','gyh5vy5kugb7gri', 'https://i.scdn.co/image/ab67616d0000b27319d60821e80a801506061776', 'Mc Pedrinho Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x5s5qkefyqnb39dlfnu5kuvq1abhznfrbt49ont0hu5v74198s','Gol Bolinha, Gol Quadrado 2','gyh5vy5kugb7gri','POP','0U9CZWq6umZsN432nh3WWT','https://p.scdn.co/mp3-preview/385a48d0a130895b2b0ec2f731cc744207d0a745?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t6vtsr73y94lb2r4ct45mwu9ffrizr9am42sorpxnr7nxumd0m', 'x5s5qkefyqnb39dlfnu5kuvq1abhznfrbt49ont0hu5v74198s', '0');
-- Arcangel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qkw6to0uaddqqpp', 'Arcangel', '145@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebafdf17286a0d7a23ad388587','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:145@artist.com', 'qkw6to0uaddqqpp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qkw6to0uaddqqpp', 'A beacon of innovation in the world of sound.', 'Arcangel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3iio1c4qqk1h9r0tsmhua0qgk0c7rihgq8oy1pov07ui4w32l5','qkw6to0uaddqqpp', 'https://i.scdn.co/image/ab67616d0000b27330326b23e30ae93d4d48165b', 'Arcangel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u0fgs6bp5il7gkl2ufy25sjir6wburw16fx6qtzjhs4p2hehbn','La Jumpa','qkw6to0uaddqqpp','POP','2mnXxnrX5vCGolNkaFvVeM','https://p.scdn.co/mp3-preview/8bcdff4719a7a4211128ec93da03892e46c4bc6a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3iio1c4qqk1h9r0tsmhua0qgk0c7rihgq8oy1pov07ui4w32l5', 'u0fgs6bp5il7gkl2ufy25sjir6wburw16fx6qtzjhs4p2hehbn', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t7zk3ftk1mewdw3579t8qmcpqr3u4yttv8i204sdulgp6xb8k6','Arcngel: Bzrp Music Sessions, Vol','qkw6to0uaddqqpp','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3iio1c4qqk1h9r0tsmhua0qgk0c7rihgq8oy1pov07ui4w32l5', 't7zk3ftk1mewdw3579t8qmcpqr3u4yttv8i204sdulgp6xb8k6', '1');
-- Billie Eilish
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3ckukcmonke0ygd', 'Billie Eilish', '146@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd8b9980db67272cb4d2c3daf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:146@artist.com', '3ckukcmonke0ygd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3ckukcmonke0ygd', 'An icon in modern pop, known for her haunting vocals and introspective lyrics.', 'Billie Eilish');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('70kluc842pdtnrgmd81n0nzw6p4fd515f41dy4a1tm5mj2r9fj','3ckukcmonke0ygd', NULL, 'Billie Eilish Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ivysjw5tatpsut34gbxr2mamjzipl7guufzunhwqx45hl365i8','What Was I Made For? [From The Motion Picture "Barbie"]','3ckukcmonke0ygd','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('70kluc842pdtnrgmd81n0nzw6p4fd515f41dy4a1tm5mj2r9fj', 'ivysjw5tatpsut34gbxr2mamjzipl7guufzunhwqx45hl365i8', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0wiked3hah17pphps4gdjf543rt4m5pz8b5tx75encko29imb4','lovely - Bonus Track','3ckukcmonke0ygd','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('70kluc842pdtnrgmd81n0nzw6p4fd515f41dy4a1tm5mj2r9fj', '0wiked3hah17pphps4gdjf543rt4m5pz8b5tx75encko29imb4', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jx9d0e04ynq3xydkxig7i956a077kxs26jhvfiym4fqrt60qc3','TV','3ckukcmonke0ygd','POP','3GYlZ7tbxLOxe6ewMNVTkw',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('70kluc842pdtnrgmd81n0nzw6p4fd515f41dy4a1tm5mj2r9fj', 'jx9d0e04ynq3xydkxig7i956a077kxs26jhvfiym4fqrt60qc3', '2');
-- Gabito Ballesteros
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('g3jyq1h3i7q1dg6', 'Gabito Ballesteros', '147@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:147@artist.com', 'g3jyq1h3i7q1dg6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('g3jyq1h3i7q1dg6', 'A vibrant force in the music scene, infusing every performance with passion.', 'Gabito Ballesteros');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mhwofac55ti2lqy93f85lbvz9r9iwz763b2rvuv94qayaqgzpi','g3jyq1h3i7q1dg6', NULL, 'Gabito Ballesteros Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a80orxejw909o3hfwl3ka428fdtmq0f8iq0zusfjao4b718q7t','LADY GAGA','g3jyq1h3i7q1dg6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mhwofac55ti2lqy93f85lbvz9r9iwz763b2rvuv94qayaqgzpi', 'a80orxejw909o3hfwl3ka428fdtmq0f8iq0zusfjao4b718q7t', '0');
-- JVKE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vg3c2dbkvze0nmw', 'JVKE', '148@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebce33386a81a202e149934ec1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:148@artist.com', 'vg3c2dbkvze0nmw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vg3c2dbkvze0nmw', 'A rising star, blending heartfelt lyrics with catchy pop melodies.', 'JVKE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('p8i21g7zz5idwbwnblcn0htw6dddubxi81ktvggbrw1rpah8ld','vg3c2dbkvze0nmw', 'https://i.scdn.co/image/ab67616d0000b273c2504e80ba2f258697ab2954', 'JVKE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ditlap71ze0xcqgzimt9qdezat2wpp83tjdh16csp9lss37bqo','golden hour','vg3c2dbkvze0nmw','POP','5odlY52u43F5BjByhxg7wg','https://p.scdn.co/mp3-preview/bcc17f30841d6fbf3cd7954c3e3cf669f11b6a21?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p8i21g7zz5idwbwnblcn0htw6dddubxi81ktvggbrw1rpah8ld', 'ditlap71ze0xcqgzimt9qdezat2wpp83tjdh16csp9lss37bqo', '0');
-- Pritam
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5ldjbqquphgbuw6', 'Pritam', '149@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcb6926f44f620555ba444fca','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:149@artist.com', '5ldjbqquphgbuw6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5ldjbqquphgbuw6', 'Revolutionizing the music scene with innovative compositions.', 'Pritam');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7f67hlxh2m4udhcue82zq0z12nc1elo637g2r48mk9be397rw1','5ldjbqquphgbuw6', NULL, 'Pritam Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0c5t3shjsq4hfcxzl1tnsw37mz2inl3f63561jbmxdyolo12ll','Kesariya (From "Brahmastra")','5ldjbqquphgbuw6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7f67hlxh2m4udhcue82zq0z12nc1elo637g2r48mk9be397rw1', '0c5t3shjsq4hfcxzl1tnsw37mz2inl3f63561jbmxdyolo12ll', '0');
-- Chris Brown
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6lyo4rcdj2ngct2', 'Chris Brown', '150@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba48397e590a1c70e2cda7728','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:150@artist.com', '6lyo4rcdj2ngct2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6lyo4rcdj2ngct2', 'A voice that echoes the sentiments of a generation.', 'Chris Brown');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pckf46ytsuq3mzqn3q44nghaiynnyukav8qa2hxpooat48131o','6lyo4rcdj2ngct2', 'https://i.scdn.co/image/ab67616d0000b2739a494f7d8909a6cc4ceb74ac', 'Chris Brown Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ouojlg9gz6mn4kdudb1pbfzzrj8jolecdqpz8lbazvsy93pexi','Under The Influence','6lyo4rcdj2ngct2','POP','5IgjP7X4th6nMNDh4akUHb','https://p.scdn.co/mp3-preview/52295df71df20e33e1510e3983975cd59f6664a4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pckf46ytsuq3mzqn3q44nghaiynnyukav8qa2hxpooat48131o', 'ouojlg9gz6mn4kdudb1pbfzzrj8jolecdqpz8lbazvsy93pexi', '0');
-- SZA
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('023vsg24gfspw4w', 'SZA', '151@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7eb7f6371aad8e67e01f0a03','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:151@artist.com', '023vsg24gfspw4w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('023vsg24gfspw4w', 'An avant-garde R&B artist painting vivid stories through her music.', 'SZA');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('p1eo5v6djag44z056tjx2mig4idk3gx43hdbxweifre3hu05c6','023vsg24gfspw4w', 'https://i.scdn.co/image/ab67616d0000b2730c471c36970b9406233842a5', 'SZA Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bnith3h9rgpix5v7dc72czmwd9ifyqcl800bta5ly9z8b1yk8g','Kill Bill','023vsg24gfspw4w','POP','1Qrg8KqiBpW07V7PNxwwwL','https://p.scdn.co/mp3-preview/4bd2dc84016f3743add7eea8b988407b1b900672?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p1eo5v6djag44z056tjx2mig4idk3gx43hdbxweifre3hu05c6', 'bnith3h9rgpix5v7dc72czmwd9ifyqcl800bta5ly9z8b1yk8g', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g5re122rm30q6pu1q7qpkcnpdqzg2nw1r3to8u5efveqxffs3b','Snooze','023vsg24gfspw4w','POP','4iZ4pt7kvcaH6Yo8UoZ4s2','https://p.scdn.co/mp3-preview/8c53920b5fd2c3178afa36cac9eec68b5ee9204a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p1eo5v6djag44z056tjx2mig4idk3gx43hdbxweifre3hu05c6', 'g5re122rm30q6pu1q7qpkcnpdqzg2nw1r3to8u5efveqxffs3b', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v0bz15rw23us60luge0gg1rhcqpwmfpxg8i3cy986y2edxj0ye','Low','023vsg24gfspw4w','POP','2GAhgAjOhEmItWLfgisyOn','https://p.scdn.co/mp3-preview/5b6dd5a1d06d0bdfd57382a584cbf0227b4d9a4b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p1eo5v6djag44z056tjx2mig4idk3gx43hdbxweifre3hu05c6', 'v0bz15rw23us60luge0gg1rhcqpwmfpxg8i3cy986y2edxj0ye', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('amwa2v81ec27yxaoxpxyi5hstsj4ll8341i3hm4xrdtnpwifr4','Nobody Gets Me','023vsg24gfspw4w','POP','5Y35SjAfXjjG0sFQ3KOxmm','https://p.scdn.co/mp3-preview/36cfe8fbfb78aa38ca3b222c4b9fc88cda992841?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p1eo5v6djag44z056tjx2mig4idk3gx43hdbxweifre3hu05c6', 'amwa2v81ec27yxaoxpxyi5hstsj4ll8341i3hm4xrdtnpwifr4', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8nhmf276y1wg82lukhl9wkr2xfkm2gqfpqnbdlgc73hlypdlg9','Shirt','023vsg24gfspw4w','POP','2wSTnntOPRi7aQneobFtU4','https://p.scdn.co/mp3-preview/8819fb0dc127d1d777a776f4d1186be783334ae5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p1eo5v6djag44z056tjx2mig4idk3gx43hdbxweifre3hu05c6', '8nhmf276y1wg82lukhl9wkr2xfkm2gqfpqnbdlgc73hlypdlg9', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h63cf4g87utoy9fd0hfwxwfmmv8oiwli8ac9eysjcl2247lcm2','Blind','023vsg24gfspw4w','POP','2CSRrnOEELmhpq8iaAi9cd','https://p.scdn.co/mp3-preview/56cd00fd7aa857bd25e4ed25aebc0e41a24bfd4f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p1eo5v6djag44z056tjx2mig4idk3gx43hdbxweifre3hu05c6', 'h63cf4g87utoy9fd0hfwxwfmmv8oiwli8ac9eysjcl2247lcm2', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rjbl6481fpbwml7o0v9m3q2p5hjjpbgupq7hd78w0w9fnz9e38','Good Days','023vsg24gfspw4w','POP','4PMqSO5qyjpvzhlLI5GnID','https://p.scdn.co/mp3-preview/d7fd97c8190baa298af9b4e778d2ba940fcd13a4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p1eo5v6djag44z056tjx2mig4idk3gx43hdbxweifre3hu05c6', 'rjbl6481fpbwml7o0v9m3q2p5hjjpbgupq7hd78w0w9fnz9e38', '6');
-- Sabrina Carpenter
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qfoho0uwepe6ye0', 'Sabrina Carpenter', '152@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb00e540b760b56d02cc415c47','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:152@artist.com', 'qfoho0uwepe6ye0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qfoho0uwepe6ye0', 'Creating a tapestry of tunes that celebrates diversity.', 'Sabrina Carpenter');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d57mjoi18e3mt1150xqlz6ea642ju5ciuphr3j2ltxajws1a0r','qfoho0uwepe6ye0', 'https://i.scdn.co/image/ab67616d0000b273700f7bf79c9f063ad0362bdf', 'Sabrina Carpenter Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('98r7ifivwep2bncz9706a2r2eo0rxdh1ek2lhp6dql5eamf8o1','Nonsense','qfoho0uwepe6ye0','POP','6dgUya35uo964z7GZXM07g',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d57mjoi18e3mt1150xqlz6ea642ju5ciuphr3j2ltxajws1a0r', '98r7ifivwep2bncz9706a2r2eo0rxdh1ek2lhp6dql5eamf8o1', '0');
-- Marlia Mendo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j9nhbudlw909af6', 'Marlia Mendo', '153@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebffaebdbc972967729f688e25','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:153@artist.com', 'j9nhbudlw909af6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j9nhbudlw909af6', 'Weaving lyrical magic into every song.', 'Marlia Mendo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xrfwsm8js29nlmejf63rby1otaf9ykown9o044uojca6unxphu','j9nhbudlw909af6', NULL, 'Marlia Mendo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('42x7ek2r1nif791rhpvxon2hpp36l0b3sf5ca5vld6xayal7r2','Le','j9nhbudlw909af6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xrfwsm8js29nlmejf63rby1otaf9ykown9o044uojca6unxphu', '42x7ek2r1nif791rhpvxon2hpp36l0b3sf5ca5vld6xayal7r2', '0');
-- Swae Lee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tgvrqng2q0mquwg', 'Swae Lee', '154@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:154@artist.com', 'tgvrqng2q0mquwg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tgvrqng2q0mquwg', 'Pushing the boundaries of sound with each note.', 'Swae Lee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e3snvu0hrmhncsmoojf7fkat4w4wjo9wbtag5csz6lyys34ncn','tgvrqng2q0mquwg', NULL, 'Swae Lee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ehg3n0ov40t6epgepfsvnxn4ngfo077w69qpwr5vvgddct0b2g','Calling (Spider-Man: Across the Spider-Verse) (Metro Boomin & Swae Lee, NAV, feat. A Boogie Wit da Hoodie)','tgvrqng2q0mquwg','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e3snvu0hrmhncsmoojf7fkat4w4wjo9wbtag5csz6lyys34ncn', 'ehg3n0ov40t6epgepfsvnxn4ngfo077w69qpwr5vvgddct0b2g', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('11sb1wdgffem8o171royzx9yosopbt0ew8jb24jgtsf5s9fzfl','Annihilate (Spider-Man: Across the Spider-Verse) (Metro Boomin & Swae Lee, Lil Wayne, Offset)','tgvrqng2q0mquwg','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e3snvu0hrmhncsmoojf7fkat4w4wjo9wbtag5csz6lyys34ncn', '11sb1wdgffem8o171royzx9yosopbt0ew8jb24jgtsf5s9fzfl', '1');
-- James Hype
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nwwgxpsr6db1dkj', 'James Hype', '155@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3735de17f641144240511000','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:155@artist.com', 'nwwgxpsr6db1dkj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nwwgxpsr6db1dkj', 'A visionary in the world of music, redefining genres.', 'James Hype');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('14t0bgh2dg5234cydpowrj5qvieza4zmiali8kfox8u6sk4663','nwwgxpsr6db1dkj', 'https://i.scdn.co/image/ab67616d0000b2736cc861b5c9c7cdef61b010b4', 'James Hype Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('odw2oa11szdiyd3zmwvuhcdmxvpxgdkeijzep367us7gimkqma','Ferrari','nwwgxpsr6db1dkj','POP','4zN21mbAuaD0WqtmaTZZeP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('14t0bgh2dg5234cydpowrj5qvieza4zmiali8kfox8u6sk4663', 'odw2oa11szdiyd3zmwvuhcdmxvpxgdkeijzep367us7gimkqma', '0');
-- Mariah Carey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kqxxw4sfb9pv7cn', 'Mariah Carey', '156@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21b66418f7f3b86967f85bce','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:156@artist.com', 'kqxxw4sfb9pv7cn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kqxxw4sfb9pv7cn', 'A maestro of melodies, orchestrating auditory bliss.', 'Mariah Carey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7g8omcco1tuvmd3z7tucz3r36h00x9nnqq0chagsruagahycya','kqxxw4sfb9pv7cn', 'https://i.scdn.co/image/ab67616d0000b2734246e3158421f5abb75abc4f', 'Mariah Carey Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t8y86asvfgea51wsdze7qusk7d9eyl8tjl3i01nns1rvpqadqe','All I Want for Christmas Is You','kqxxw4sfb9pv7cn','POP','0bYg9bo50gSsH3LtXe2SQn','https://p.scdn.co/mp3-preview/6b1557cd25d543940a3decd85a7bf2bc136c51f8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7g8omcco1tuvmd3z7tucz3r36h00x9nnqq0chagsruagahycya', 't8y86asvfgea51wsdze7qusk7d9eyl8tjl3i01nns1rvpqadqe', '0');
-- (G)I-DLE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0z5twxwhokhzom6', '(G)I-DLE', '157@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8abd5f97fc52561939ebbc89','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:157@artist.com', '0z5twxwhokhzom6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0z5twxwhokhzom6', 'Harnessing the power of melody to tell compelling stories.', '(G)I-DLE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y5lkvtry6z7u9e745vys9qe4fswm9lrt3nyyi2r7e3k08svjwf','0z5twxwhokhzom6', 'https://i.scdn.co/image/ab67616d0000b27382dd2427e6d302711b1b9616', '(G)I-DLE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c81yq31bom94lwsmjefxht5gv08z2oqs72hzfxhbqdiro6fiq2','Queencard','0z5twxwhokhzom6','POP','4uOBL4DDWWVx4RhYKlPbPC','https://p.scdn.co/mp3-preview/9f36e86bca0911d3f849197e8f531b9d0c34f002?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y5lkvtry6z7u9e745vys9qe4fswm9lrt3nyyi2r7e3k08svjwf', 'c81yq31bom94lwsmjefxht5gv08z2oqs72hzfxhbqdiro6fiq2', '0');
-- d4vd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lyecasu3d3j9af1', 'd4vd', '158@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad447187a35f422307e88ad3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:158@artist.com', 'lyecasu3d3j9af1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lyecasu3d3j9af1', 'Breathing new life into classic genres.', 'd4vd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('spmktvb78su3exr3d6cg2809u5px2q61x39stw414g6uj1uo6q','lyecasu3d3j9af1', 'https://i.scdn.co/image/ab67616d0000b27364fa1bda999f4fbd2b7c4bb7', 'd4vd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tivpdokoeb2j0rqqiwb75iueeoeofwsss4mqqwpyxlyu68ftn7','Here With Me','lyecasu3d3j9af1','POP','5LrN7yUQAzvthd4QujgPFr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('spmktvb78su3exr3d6cg2809u5px2q61x39stw414g6uj1uo6q', 'tivpdokoeb2j0rqqiwb75iueeoeofwsss4mqqwpyxlyu68ftn7', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x9fd2zhybu2m3vuvjimhzqopphbbxqbc2v79b2cb72vf9yy7tk','Romantic Homicide','lyecasu3d3j9af1','POP','1xK59OXxi2TAAAbmZK0kBL',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('spmktvb78su3exr3d6cg2809u5px2q61x39stw414g6uj1uo6q', 'x9fd2zhybu2m3vuvjimhzqopphbbxqbc2v79b2cb72vf9yy7tk', '1');
-- Kaifi Khalil
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hyyraab7u73oycv', 'Kaifi Khalil', '159@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8b3d777345ecd2f25f408586','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:159@artist.com', 'hyyraab7u73oycv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hyyraab7u73oycv', 'An odyssey of sound that defies conventions.', 'Kaifi Khalil');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2yd5e34fo23s2cnbrrde76bp8tb0a946u4qte0n4lkpsgy0l1p','hyyraab7u73oycv', 'https://i.scdn.co/image/ab67616d0000b2734697d4ee22b3f63c17a3b9ec', 'Kaifi Khalil Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('eqpk4rmo21aob40gyhoaujjmqjq6cbf2npa0d3c3a1l9kurn31','Kahani Suno 2.0','hyyraab7u73oycv','POP','4VsP4Dm8gsibRxB5I2hEkw','https://p.scdn.co/mp3-preview/2c644e9345d1a0ab97e4541d26b6b8ccb2c889f9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2yd5e34fo23s2cnbrrde76bp8tb0a946u4qte0n4lkpsgy0l1p', 'eqpk4rmo21aob40gyhoaujjmqjq6cbf2npa0d3c3a1l9kurn31', '0');
-- Beach Weather
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('a3y79jz24un2y91', 'Beach Weather', '160@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebed9ce2779a99efc01b4f918c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:160@artist.com', 'a3y79jz24un2y91', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('a3y79jz24un2y91', 'Uniting fans around the globe with universal rhythms.', 'Beach Weather');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mfmnsgxe8vst8v38gg22weu1su6b4bpzcyk8sqsxj64ueaar4m','a3y79jz24un2y91', 'https://i.scdn.co/image/ab67616d0000b273a03e3d24ccee1c370899c342', 'Beach Weather Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u2krdc9tbdu05blpa8ooz8qeyhov723gk7c7hfn5rdq7szs5uc','Sex, Drugs, Etc.','a3y79jz24un2y91','POP','7MlDNspYwfqnHxORufupwq','https://p.scdn.co/mp3-preview/a423aecddb590788a61f2a7b4d325bf461f88dc8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mfmnsgxe8vst8v38gg22weu1su6b4bpzcyk8sqsxj64ueaar4m', 'u2krdc9tbdu05blpa8ooz8qeyhov723gk7c7hfn5rdq7szs5uc', '0');
-- Stephen Sanchez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z84wktbgquek8dj', 'Stephen Sanchez', '161@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1e97fce6fa6fc4ebc3ebda25','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:161@artist.com', 'z84wktbgquek8dj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z84wktbgquek8dj', 'Redefining what it means to be an artist in the digital age.', 'Stephen Sanchez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1osuqjm0q9gwadfpanieqz3vy25pterdddcyk23b3glp9b76o9','z84wktbgquek8dj', 'https://i.scdn.co/image/ab67616d0000b2732bf0876d42b90a8852ad6244', 'Stephen Sanchez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('42r7bb4si4rm8eb8ir3jpanhycnzkci03gx8zvl94y9a0dvwkx','Until I Found You','z84wktbgquek8dj','POP','1Y3LN4zO1Edc2EluIoSPJN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1osuqjm0q9gwadfpanieqz3vy25pterdddcyk23b3glp9b76o9', '42r7bb4si4rm8eb8ir3jpanhycnzkci03gx8zvl94y9a0dvwkx', '0');
-- Omar Apollo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h539t07bc2a13be', 'Omar Apollo', '162@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0e2a3a2c664a4bbb14e44f8e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:162@artist.com', 'h539t07bc2a13be', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h539t07bc2a13be', 'The heartbeat of a new generation of music lovers.', 'Omar Apollo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9q3vgll6znc82fzp5onlg73basrzulmwttbh1h4tths14mh2vn','h539t07bc2a13be', 'https://i.scdn.co/image/ab67616d0000b27390cf5d1ccfca2beb86149a19', 'Omar Apollo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q3pqutpbur9x0tnkahgtvm13onnsj24brfi0luqvh8ba5txzd8','Evergreen (You Didnt Deserve Me A','h539t07bc2a13be','POP','2TktkzfozZifbQhXjT6I33','https://p.scdn.co/mp3-preview/f9db43c10cfab231d9448792464a23f6e6d607e7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9q3vgll6znc82fzp5onlg73basrzulmwttbh1h4tths14mh2vn', 'q3pqutpbur9x0tnkahgtvm13onnsj24brfi0luqvh8ba5txzd8', '0');
-- Melanie Martinez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ikap1v33werq5pw', 'Melanie Martinez', '163@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb77ecd63aaebe2225b07c89f0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:163@artist.com', 'ikap1v33werq5pw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ikap1v33werq5pw', 'A visionary in the world of music, redefining genres.', 'Melanie Martinez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rwrrab7790isj89zklvqm3phl0kohtw9o11ma6vh3d1rhc6f8x','ikap1v33werq5pw', 'https://i.scdn.co/image/ab67616d0000b2733c6c534cdacc9cf53e6d2977', 'Melanie Martinez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nku0q2eqagy50l4ij5kjfxivjm8nv8lmcuqo4fe359119svteu','VOID','ikap1v33werq5pw','POP','6wmKvtSmyTqHNo44OBXVN1','https://p.scdn.co/mp3-preview/9a2ae9278ecfe2ed8d628dfe05699bf24395d6a0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rwrrab7790isj89zklvqm3phl0kohtw9o11ma6vh3d1rhc6f8x', 'nku0q2eqagy50l4ij5kjfxivjm8nv8lmcuqo4fe359119svteu', '0');
-- Shakira
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v07sevkj12uqvvc', 'Shakira', '164@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb284894d68fe2f80cad555110','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:164@artist.com', 'v07sevkj12uqvvc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v07sevkj12uqvvc', 'Revolutionizing the music scene with innovative compositions.', 'Shakira');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lppjszu11sxtvenymh2ymby0u54d46ougwa4u13o1xx03khvp1','v07sevkj12uqvvc', NULL, 'Shakira Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('eprylrl53rp864yotkwfyciklo3kvygz5i5d4ny7yyyk2mnesv','Shakira: Bzrp Music Sessions, Vol. 53','v07sevkj12uqvvc','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lppjszu11sxtvenymh2ymby0u54d46ougwa4u13o1xx03khvp1', 'eprylrl53rp864yotkwfyciklo3kvygz5i5d4ny7yyyk2mnesv', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vik1ofb4qqxuav0ni92gs0x8pcdipzqdhfzjuqiwxvqml1beht','Acrs','v07sevkj12uqvvc','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lppjszu11sxtvenymh2ymby0u54d46ougwa4u13o1xx03khvp1', 'vik1ofb4qqxuav0ni92gs0x8pcdipzqdhfzjuqiwxvqml1beht', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iyz3tel853ilh7tb8ty7dj5z6e7p1duhzbgkpxi9t9k5zbuduh','Te Felicito','v07sevkj12uqvvc','POP','2rurDawMfoKP4uHyb2kJBt','https://p.scdn.co/mp3-preview/6b4b2be03b14bf758835c8f28f35834da35cc1c3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lppjszu11sxtvenymh2ymby0u54d46ougwa4u13o1xx03khvp1', 'iyz3tel853ilh7tb8ty7dj5z6e7p1duhzbgkpxi9t9k5zbuduh', '2');
-- Maria Becerra
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('761ef34zv2dsb3l', 'Maria Becerra', '165@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb6cfa517b8f5a152d63c4ffb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:165@artist.com', '761ef34zv2dsb3l', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('761ef34zv2dsb3l', 'A vibrant new voice in Latin pop, fusing catchy melodies with urban sounds.', 'Maria Becerra');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lwmfg8jtwb22sqhresxd2w9zortxh7si5bhy1yk4cslbawubjt','761ef34zv2dsb3l', NULL, 'Maria Becerra Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0i89tg9qy28qpao69dh6q6sh4ymvcmm2b5d8evvet5acba8o6y','CORAZN VA','761ef34zv2dsb3l','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lwmfg8jtwb22sqhresxd2w9zortxh7si5bhy1yk4cslbawubjt', '0i89tg9qy28qpao69dh6q6sh4ymvcmm2b5d8evvet5acba8o6y', '0');
-- Jimin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('olkda83wkarm260', 'Jimin', '166@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb59f8cfc8e71dcaf8c6ec4bde','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:166@artist.com', 'olkda83wkarm260', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('olkda83wkarm260', 'Known for his expressive voice and mesmerizing dance moves in BTS.', 'Jimin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ns57ucjgo2qh54uioy2ncnyzqi9ugy1aaondozb3811k5sofmx','olkda83wkarm260', 'https://i.scdn.co/image/ab67616d0000b2732b46078245d0120690eb560d', 'Jimin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zd5tesffyvxu1fj3jsf7kagb9i5ruupfgjo73d9noz4b1k3zap','Like Crazy','olkda83wkarm260','POP','3Ua0m0YmEjrMi9XErKcNiR','https://p.scdn.co/mp3-preview/2db5f36096963d97afc870c50990d62d27858a43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ns57ucjgo2qh54uioy2ncnyzqi9ugy1aaondozb3811k5sofmx', 'zd5tesffyvxu1fj3jsf7kagb9i5ruupfgjo73d9noz4b1k3zap', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vee0m1dhwyes04ikmcg2bc46q41wtsahe6wdvlno1vfbtiab7e','Set Me Free Pt.2','olkda83wkarm260','POP','59hBR0BCtJsfIbV9VzCVAp','https://p.scdn.co/mp3-preview/275a3a0843bb55c251cda45ef17a905dab31624c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ns57ucjgo2qh54uioy2ncnyzqi9ugy1aaondozb3811k5sofmx', 'vee0m1dhwyes04ikmcg2bc46q41wtsahe6wdvlno1vfbtiab7e', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p6mcxun1tonhf8q0q7jyz0qd9a35hjhbdj98v8n8svuq7615hj','Like Crazy (English Version)','olkda83wkarm260','POP','0u8rZGtXJrLtiSe34FPjGG','https://p.scdn.co/mp3-preview/3752bae14d7952abe6f93649d85d53bfe98f1165?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ns57ucjgo2qh54uioy2ncnyzqi9ugy1aaondozb3811k5sofmx', 'p6mcxun1tonhf8q0q7jyz0qd9a35hjhbdj98v8n8svuq7615hj', '2');
-- Oscar Maydon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wkgsmmbv16k44my', 'Oscar Maydon', '167@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8920adf64930d6f26e34b7c4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:167@artist.com', 'wkgsmmbv16k44my', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wkgsmmbv16k44my', 'Melodies that capture the essence of human emotion.', 'Oscar Maydon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wwo2ha55mog2jqrdnbmp0xmd2nbuuvskox3j019ppew2zlpwiz','wkgsmmbv16k44my', 'https://i.scdn.co/image/ab67616d0000b2739b7e1ea3815a172019bc5e56', 'Oscar Maydon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r0v8oxgwrjdgj5u0khstj67i211ueucg3qvuobrazmuv389t5y','Fin de Semana','wkgsmmbv16k44my','POP','6TBzRwnX2oYd8aOrOuyK1p','https://p.scdn.co/mp3-preview/71ee8bdc0a34790ad549ba750665808f08f5e46b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wwo2ha55mog2jqrdnbmp0xmd2nbuuvskox3j019ppew2zlpwiz', 'r0v8oxgwrjdgj5u0khstj67i211ueucg3qvuobrazmuv389t5y', '0');
-- Beyonc
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zfgyeg58eflj18b', 'Beyonc', '168@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12e3f20d05a8d6cfde988715','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:168@artist.com', 'zfgyeg58eflj18b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zfgyeg58eflj18b', 'Transcending language barriers through the universal language of music.', 'Beyonc');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5q74rfwjew4ae6gfh55i9pc1gpa0l1pprqam8s48y0iygqo27b','zfgyeg58eflj18b', 'https://i.scdn.co/image/ab67616d0000b2730e58a0f8308c1ad403d105e7', 'Beyonc Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6bhwxtq98oezoq60id15mgmms85fx44lbj9n1a48ye2af1ux0p','CUFF IT','zfgyeg58eflj18b','POP','1xzi1Jcr7mEi9K2RfzLOqS','https://p.scdn.co/mp3-preview/1799de9ff42644af9773b6353358e54615696f19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5q74rfwjew4ae6gfh55i9pc1gpa0l1pprqam8s48y0iygqo27b', '6bhwxtq98oezoq60id15mgmms85fx44lbj9n1a48ye2af1ux0p', '0');
-- Coi Leray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ppom0fhhlfodnp0', 'Coi Leray', '169@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:169@artist.com', 'ppom0fhhlfodnp0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ppom0fhhlfodnp0', 'A journey through the spectrum of sound in every album.', 'Coi Leray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ajcwzrbbegscbzusg97mxazr7vgq4vtypfi7wji1vb6s6x2a7y','ppom0fhhlfodnp0', 'https://i.scdn.co/image/ab67616d0000b2735626453d29a0124dea22fb1b', 'Coi Leray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sz28cobmq6sfm70dmbxc4iu5xwji0qgtad0xbw6gb1indna7aq','Players','ppom0fhhlfodnp0','POP','6UN73IYd0hZxLi8wFPMQij',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ajcwzrbbegscbzusg97mxazr7vgq4vtypfi7wji1vb6s6x2a7y', 'sz28cobmq6sfm70dmbxc4iu5xwji0qgtad0xbw6gb1indna7aq', '0');
-- Lil Durk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hyzl6wv3ffvgj3n', 'Lil Durk', '170@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3513370298ee50e52dfc7326','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:170@artist.com', 'hyzl6wv3ffvgj3n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hyzl6wv3ffvgj3n', 'Elevating the ordinary to extraordinary through music.', 'Lil Durk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j6iepf0lzy5c7sx0mz633jv1l2d2z2suaaij7vby03d7j8m9dw','hyzl6wv3ffvgj3n', 'https://i.scdn.co/image/ab67616d0000b2736234c2c6d4bb935839ac4719', 'Lil Durk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7pddsl4re1djbnvm8d1yghzss7g65whn16a6fc5v2klkgj4s8h','Stand By Me (feat. Morgan Wallen)','hyzl6wv3ffvgj3n','POP','1fXnu2HzxbDtoyvFPWG3Bw','https://p.scdn.co/mp3-preview/ed64766975b1f0b3aa57741935c3f20e833c47db?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j6iepf0lzy5c7sx0mz633jv1l2d2z2suaaij7vby03d7j8m9dw', '7pddsl4re1djbnvm8d1yghzss7g65whn16a6fc5v2klkgj4s8h', '0');
-- Alec Benjamin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h83yxb908jie8un', 'Alec Benjamin', '171@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc7e8521887c99b10c8bbfbac','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:171@artist.com', 'h83yxb908jie8un', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h83yxb908jie8un', 'A harmonious blend of passion and creativity.', 'Alec Benjamin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0lon269elecdzsmj0xk27f41yjhmx9996w25bjz4j12ko6kmba','h83yxb908jie8un', 'https://i.scdn.co/image/ab67616d0000b273459d675aa0b6f3b211357370', 'Alec Benjamin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6no1p48p7a10w3x57ubm4hdupuqsyhzg5p19uv36uytwj6srbq','Let Me Down Slowly','h83yxb908jie8un','POP','2qxmye6gAegTMjLKEBoR3d','https://p.scdn.co/mp3-preview/19007111a4e21096bcefef77842d7179f0cdf12a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0lon269elecdzsmj0xk27f41yjhmx9996w25bjz4j12ko6kmba', '6no1p48p7a10w3x57ubm4hdupuqsyhzg5p19uv36uytwj6srbq', '0');
-- Kenia OS
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('upyljpxgbrtdx78', 'Kenia OS', '172@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7cee297b5eaaa121f9558d7e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:172@artist.com', 'upyljpxgbrtdx78', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('upyljpxgbrtdx78', 'A symphony of emotions expressed through sound.', 'Kenia OS');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('a975hymp0t40q9182rqsnqnamvsr4tuixkbsjjc6g8p7yxpy0k','upyljpxgbrtdx78', 'https://i.scdn.co/image/ab67616d0000b2739afe5698b0a9559dabc44ac8', 'Kenia OS Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sa0cuzgi2fx8tmw7v97x0s6ajcgt21vdy8voxk6t5srb2tr85c','Malas Decisiones','upyljpxgbrtdx78','POP','6Xj014IHwbLVjiVT6H89on','https://p.scdn.co/mp3-preview/9a71f09b224a9e6f521743423bd53e99c7c4793c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a975hymp0t40q9182rqsnqnamvsr4tuixkbsjjc6g8p7yxpy0k', 'sa0cuzgi2fx8tmw7v97x0s6ajcgt21vdy8voxk6t5srb2tr85c', '0');
-- XXXTENTACION
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('br9vj1udu1zfky7', 'XXXTENTACION', '173@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf0c20db5ef6c6fbe5135d2e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:173@artist.com', 'br9vj1udu1zfky7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('br9vj1udu1zfky7', 'Harnessing the power of melody to tell compelling stories.', 'XXXTENTACION');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qoj0jf7m8ne73rv6euvfi698nkiyzhh8lvrbw6ljt1dd15umrq','br9vj1udu1zfky7', 'https://i.scdn.co/image/ab67616d0000b273203c89bd4391468eea4cc3f5', 'XXXTENTACION Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ki2hw9hu28hl4pg1jn0scfvppc6f12o677qnz7ee7adwqx0vam','Revenge','br9vj1udu1zfky7','POP','5TXDeTFVRVY7Cvt0Dw4vWW','https://p.scdn.co/mp3-preview/8f5fe8bb510463b2da20325c8600200bf2984d83?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qoj0jf7m8ne73rv6euvfi698nkiyzhh8lvrbw6ljt1dd15umrq', 'ki2hw9hu28hl4pg1jn0scfvppc6f12o677qnz7ee7adwqx0vam', '0');
-- Yandel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2wa8kc0gyst5o4c', 'Yandel', '174@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7dbaf2fabcbd4b37168397fd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:174@artist.com', '2wa8kc0gyst5o4c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2wa8kc0gyst5o4c', 'A powerhouse of reggaeton, blending rhythms that move the soul.', 'Yandel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pb3yl8dvr2s04s22ro8ng5jwfirbjwmj8sszf50suuz919n1l2','2wa8kc0gyst5o4c', 'https://i.scdn.co/image/ab67616d0000b273b2aec01b56eeb74610532700', 'Yandel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('udni80u6bc18he81nosr73ge216ffhmbnt785d6au4ljo0v26p','Yandel 150','2wa8kc0gyst5o4c','POP','4FAKtPVycI4DxoOHC01YqD','https://p.scdn.co/mp3-preview/338ed053ce26ccc3313b00b5e6153e60ffd2eb19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pb3yl8dvr2s04s22ro8ng5jwfirbjwmj8sszf50suuz919n1l2', 'udni80u6bc18he81nosr73ge216ffhmbnt785d6au4ljo0v26p', '0');
-- Tom Odell
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uvz4x35rem5daqu', 'Tom Odell', '175@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb532e8dd8ba9fbd5e78105a78','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:175@artist.com', 'uvz4x35rem5daqu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uvz4x35rem5daqu', 'Stirring emotions with piano-driven melodies and poetic lyrics.', 'Tom Odell');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('19nr285zmptw6mhxvsq75ub2aqt94d7r1qljvyg6kis24d0oo6','uvz4x35rem5daqu', 'https://i.scdn.co/image/ab67616d0000b2731917a0f3f4152622a040913f', 'Tom Odell Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l2fqnvm0mlb9mxc069ys6s7mbjx8ketw861mvpguuzfbf5vv7b','Another Love','uvz4x35rem5daqu','POP','3JvKfv6T31zO0ini8iNItO','https://p.scdn.co/mp3-preview/0369cb748bc968ffd34fb4ac60f5403f2aad032f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('19nr285zmptw6mhxvsq75ub2aqt94d7r1qljvyg6kis24d0oo6', 'l2fqnvm0mlb9mxc069ys6s7mbjx8ketw861mvpguuzfbf5vv7b', '0');
-- TV Girl
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h4338mnf5t0i97b', 'TV Girl', '176@artist.com', 'https://i.scdn.co/image/ab67616d0000b27332f5fec7a879ed6ef28f0dfd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:176@artist.com', 'h4338mnf5t0i97b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h4338mnf5t0i97b', 'An endless quest for musical perfection.', 'TV Girl');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zcp9tzzhlutc3o57x0cybik7k1ofdjissyau4gnnb5as24d4cp','h4338mnf5t0i97b', 'https://i.scdn.co/image/ab67616d0000b273e1bc1af856b42dd7fdba9f84', 'TV Girl Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gx22kdkrm215bmzfjfxku4qx6mo14px6znxcvh5nxx7ci42r1t','Lovers Rock','h4338mnf5t0i97b','POP','6dBUzqjtbnIa1TwYbyw5CM','https://p.scdn.co/mp3-preview/922a42db5aa8f8d335725697b7d7a12af6808f3a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zcp9tzzhlutc3o57x0cybik7k1ofdjissyau4gnnb5as24d4cp', 'gx22kdkrm215bmzfjfxku4qx6mo14px6znxcvh5nxx7ci42r1t', '0');
-- dennis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gq1edn3yqd7yyk8', 'dennis', '177@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8a1ec9781a1542458b3b961b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:177@artist.com', 'gq1edn3yqd7yyk8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gq1edn3yqd7yyk8', 'Transcending language barriers through the universal language of music.', 'dennis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sjcrys9eq1jrjq5s6bdmbuhnhe5qprle9czb08qece8eeu8i2r','gq1edn3yqd7yyk8', 'https://i.scdn.co/image/ab67616d0000b273ddfc406de0d7dbc2e339f016', 'dennis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5rhe6t0ngc311zeh143pkhg4v6ilx22o9g2zfs1d3s0wx7tbek','T','gq1edn3yqd7yyk8','POP','35FW5OEe4p38LdjK1KqT2X','https://p.scdn.co/mp3-preview/eaa522f48564e43e33e00c011aef0489526d1072?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sjcrys9eq1jrjq5s6bdmbuhnhe5qprle9czb08qece8eeu8i2r', '5rhe6t0ngc311zeh143pkhg4v6ilx22o9g2zfs1d3s0wx7tbek', '0');
-- BLESSD
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6fffqij61famtsa', 'BLESSD', '178@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:178@artist.com', '6fffqij61famtsa', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6fffqij61famtsa', 'Weaving lyrical magic into every song.', 'BLESSD');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('99lwps3b6r9p33miny05hjc2oneowgr0k20z7gh7xvoe1r2w3c','6fffqij61famtsa', NULL, 'BLESSD Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('np0atz1fe0i4h49jxn9fohk8ml27kyycv1ikaynz67fbran204','Las Morras','6fffqij61famtsa','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('99lwps3b6r9p33miny05hjc2oneowgr0k20z7gh7xvoe1r2w3c', 'np0atz1fe0i4h49jxn9fohk8ml27kyycv1ikaynz67fbran204', '0');
-- NewJeans
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5ikuy51cd9b5lj7', 'NewJeans', '179@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5da361915b1fa48895d4f23f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:179@artist.com', '5ikuy51cd9b5lj7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5ikuy51cd9b5lj7', 'Redefining K-pop with their fresh style and energetic performances.', 'NewJeans');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4n6diowc02hkpokts53bkfx63u6y3kwkyti998e3j8jyf7awb4','5ikuy51cd9b5lj7', 'https://i.scdn.co/image/ab67616d0000b2733d98a0ae7c78a3a9babaf8af', 'NewJeans Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ffki5qs433o2ay3o8xuwel6ocx0smkx227huqba5n5l05y3prr','Super Shy','5ikuy51cd9b5lj7','POP','5sdQOyqq2IDhvmx2lHOpwd','https://p.scdn.co/mp3-preview/dab062e2cc708a2680ce84953a3581c5a679a230?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4n6diowc02hkpokts53bkfx63u6y3kwkyti998e3j8jyf7awb4', 'ffki5qs433o2ay3o8xuwel6ocx0smkx227huqba5n5l05y3prr', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4734w45briykngcuaxzcdxkyewervitvxgm2r78radp02tcmd6','New Jeans','5ikuy51cd9b5lj7','POP','6rdkCkjk6D12xRpdMXy0I2','https://p.scdn.co/mp3-preview/a37b4269b0dc5e952826d8c43d1b7c072ac39b4c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4n6diowc02hkpokts53bkfx63u6y3kwkyti998e3j8jyf7awb4', '4734w45briykngcuaxzcdxkyewervitvxgm2r78radp02tcmd6', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y5vadq9xzajc5bo3q12wlvk1wv11pjy94zouh34ahjzltaqgil','OMG','5ikuy51cd9b5lj7','POP','65FftemJ1DbbZ45DUfHJXE','https://p.scdn.co/mp3-preview/b9e344aa96afc45a56df77ca63c78786bdaa0047?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4n6diowc02hkpokts53bkfx63u6y3kwkyti998e3j8jyf7awb4', 'y5vadq9xzajc5bo3q12wlvk1wv11pjy94zouh34ahjzltaqgil', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6sfkfnhjx0cf19ibnf9w3svbzaltmezm1wzlbiqtorlps5uy1t','Ditto','5ikuy51cd9b5lj7','POP','3r8RuvgbX9s7ammBn07D3W','https://p.scdn.co/mp3-preview/4f048713ddfa434539dec7c3cb689f3393353edd?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4n6diowc02hkpokts53bkfx63u6y3kwkyti998e3j8jyf7awb4', '6sfkfnhjx0cf19ibnf9w3svbzaltmezm1wzlbiqtorlps5uy1t', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j73zk7gxg3lk6ec6j8ed2dx060s7oyetk5cvdit85tha7ajq6g','Hype Boy','5ikuy51cd9b5lj7','POP','0a4MMyCrzT0En247IhqZbD','https://p.scdn.co/mp3-preview/7c55950057fc446dc2ce59671dff4fa6b3ef52a7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4n6diowc02hkpokts53bkfx63u6y3kwkyti998e3j8jyf7awb4', 'j73zk7gxg3lk6ec6j8ed2dx060s7oyetk5cvdit85tha7ajq6g', '4');
-- One Direction
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vfwbj56fp7162cg', 'One Direction', '180@artist.com', 'https://i.scdn.co/image/5bb443424a1ad71603c43d67f5af1a04da6bb3c8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:180@artist.com', 'vfwbj56fp7162cg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vfwbj56fp7162cg', 'Blending traditional rhythms with modern beats.', 'One Direction');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('v6mcmlllh11lyex1tdzvqasfwhis9lp8myp19j1gkimqn1c0en','vfwbj56fp7162cg', 'https://i.scdn.co/image/ab67616d0000b273d304ba2d71de306812eebaf4', 'One Direction Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5t8tf9qjflu65dpnubji7vaxg676con30hu4o5ar6ckb7zv3ag','Night Changes','vfwbj56fp7162cg','POP','5O2P9iiztwhomNh8xkR9lJ','https://p.scdn.co/mp3-preview/359be833b46b250c696bbb64caa5dc91f2a38c6a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v6mcmlllh11lyex1tdzvqasfwhis9lp8myp19j1gkimqn1c0en', '5t8tf9qjflu65dpnubji7vaxg676con30hu4o5ar6ckb7zv3ag', '0');
-- Raim Laode
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('l7vdmlu5nk5spcr', 'Raim Laode', '181@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f5fe38a2d25be089bf281e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:181@artist.com', 'l7vdmlu5nk5spcr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('l7vdmlu5nk5spcr', 'Weaving lyrical magic into every song.', 'Raim Laode');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('29pcxwtemm469llqzlekewnub5g9c9y0nwuvj19tzqs5q1y0oq','l7vdmlu5nk5spcr', 'https://i.scdn.co/image/ab67616d0000b273f20ec6ba1f431a90dbf2e8b6', 'Raim Laode Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f2yz4uxlz4ww443yoswikvxhuafgarmhi73hb87mrbuqenglxz','Komang','l7vdmlu5nk5spcr','POP','2AaaE0qvFWtyT8srKNfRhH','https://p.scdn.co/mp3-preview/47575d13a133216ab684c5211af483a7524e89db?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('29pcxwtemm469llqzlekewnub5g9c9y0nwuvj19tzqs5q1y0oq', 'f2yz4uxlz4ww443yoswikvxhuafgarmhi73hb87mrbuqenglxz', '0');
-- Jain
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('26zdnm3zsa2xnwv', 'Jain', '182@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb673f287fead1f6c83b9b68ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:182@artist.com', '26zdnm3zsa2xnwv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('26zdnm3zsa2xnwv', 'Mixing electronic beats with multicultural influences to create a unique sound.', 'Jain');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('15e5sll2gwqza1o5adcxa80cmfnsxqewg6eh8zs3hy3iz9mxjs','26zdnm3zsa2xnwv', 'https://i.scdn.co/image/ab67616d0000b27364ba66f8a81c52364e55db50', 'Jain Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('030fshng3pldbnkpmlq0tdvv2uyzsy8ym8pn1cm0d8tx7qpl0i','Makeba','26zdnm3zsa2xnwv','POP','4TNFLwe6DhtR3Wn1JKMqMJ','https://p.scdn.co/mp3-preview/41db29480f9d12734adf491d3b5dd4da1005047c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('15e5sll2gwqza1o5adcxa80cmfnsxqewg6eh8zs3hy3iz9mxjs', '030fshng3pldbnkpmlq0tdvv2uyzsy8ym8pn1cm0d8tx7qpl0i', '0');
-- Joji
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4jbbue4aausbc25', 'Joji', '183@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4111c95b5f430c3265c7304b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:183@artist.com', '4jbbue4aausbc25', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4jbbue4aausbc25', 'Striking chords that resonate across generations.', 'Joji');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('80tdiig0rx62bteejvawmmptfoskwbxo7w0udn30a5omn2pfo7','4jbbue4aausbc25', 'https://i.scdn.co/image/ab67616d0000b27308596cc28b9f5b00bfe08ae7', 'Joji Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('87bgyqtwvaiesrroe466lsd2z23kxysfzuw2jvinamw6gqcpjj','Glimpse of Us','4jbbue4aausbc25','POP','6xGruZOHLs39ZbVccQTuPZ','https://p.scdn.co/mp3-preview/12e4a7ef3f1051424e6e282dfba83fe8448e122f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('80tdiig0rx62bteejvawmmptfoskwbxo7w0udn30a5omn2pfo7', '87bgyqtwvaiesrroe466lsd2z23kxysfzuw2jvinamw6gqcpjj', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('21lmm8d7tlkkrfqv3aq64ykw6ovssmb4jf9hs4rb5n6ghe6ssc','Die For You','4jbbue4aausbc25','POP','26hOm7dTtBi0TdpDGl141t','https://p.scdn.co/mp3-preview/85d19ba2d8274ab29f474b3baf07b6ac6ba6d35a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('80tdiig0rx62bteejvawmmptfoskwbxo7w0udn30a5omn2pfo7', '21lmm8d7tlkkrfqv3aq64ykw6ovssmb4jf9hs4rb5n6ghe6ssc', '1');
-- Tyler The Creator
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s74rr24i3hq6xhv', 'Tyler The Creator', '184@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:184@artist.com', 's74rr24i3hq6xhv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s74rr24i3hq6xhv', 'Pushing the boundaries of music with unique style and bold lyrics.', 'Tyler The Creator');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pcr5ue6wfhdlec4a91h6a2t7dnplfzkvicyi3n25ds6i9esgtx','s74rr24i3hq6xhv', 'https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3', 'Tyler The Creator Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sbgfcv9x25i6g73rszhsmzoe67k9utz8672cttudsetfah22h9','See You Again','s74rr24i3hq6xhv','POP','7KA4W4McWYRpgf0fWsJZWB','https://p.scdn.co/mp3-preview/c703198293891e3b276800ea6b187cf7951d3d7d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pcr5ue6wfhdlec4a91h6a2t7dnplfzkvicyi3n25ds6i9esgtx', 'sbgfcv9x25i6g73rszhsmzoe67k9utz8672cttudsetfah22h9', '0');
-- Ray Dalton
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('166628fb5g6rp2w', 'Ray Dalton', '185@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb761f04a794923fde50fcb9fb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:185@artist.com', '166628fb5g6rp2w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('166628fb5g6rp2w', 'A harmonious blend of passion and creativity.', 'Ray Dalton');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ues4teb3ri753o4eud9kprjjmfz8rvobcfrmgd7r5npnh5gxzj','166628fb5g6rp2w', NULL, 'Ray Dalton Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mlyaz1q1y2g9vw30gqnhqzbja5m3m3mrdjatz1oklkm0s6q2eh','Cant Hold Us (feat. Ray Dalton)','166628fb5g6rp2w','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ues4teb3ri753o4eud9kprjjmfz8rvobcfrmgd7r5npnh5gxzj', 'mlyaz1q1y2g9vw30gqnhqzbja5m3m3mrdjatz1oklkm0s6q2eh', '0');
-- Miley Cyrus
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('a77i5um8hzihyjg', 'Miley Cyrus', '186@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5af3b38f053486ab0784dee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:186@artist.com', 'a77i5um8hzihyjg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('a77i5um8hzihyjg', 'Constantly evolving, from pop sensation to rock powerhouse.', 'Miley Cyrus');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e1g46215pryyegq0f203c58o74rp2qv44h5l4v1p4vzr9a3va3','a77i5um8hzihyjg', 'https://i.scdn.co/image/ab67616d0000b273cd222052a2594be29a6616b5', 'Miley Cyrus Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wzoi0d4ksbguis34b3que77sk4d2zpnsfdy1jx7kohe94ewpj0','Flowers','a77i5um8hzihyjg','POP','7DSAEUvxU8FajXtRloy8M0','https://p.scdn.co/mp3-preview/5184d19d1b7fcc3e7c067e38af45a7cc80851440?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e1g46215pryyegq0f203c58o74rp2qv44h5l4v1p4vzr9a3va3', 'wzoi0d4ksbguis34b3que77sk4d2zpnsfdy1jx7kohe94ewpj0', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('90gr9px5uz2iozh5pyc8f0qh6e51d7arbhgbh90u8qa69ca2v6','Angels Like You','a77i5um8hzihyjg','POP','1daDRI9ahBonbWD8YcxOIB','https://p.scdn.co/mp3-preview/4db8314199c0d49e95c786792ecd06eadae9f510?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e1g46215pryyegq0f203c58o74rp2qv44h5l4v1p4vzr9a3va3', '90gr9px5uz2iozh5pyc8f0qh6e51d7arbhgbh90u8qa69ca2v6', '1');
-- INTERWORLD
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5tbxclauordrbqh', 'INTERWORLD', '187@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4ba846e4a963c8558471e3af','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:187@artist.com', '5tbxclauordrbqh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5tbxclauordrbqh', 'Blending genres for a fresh musical experience.', 'INTERWORLD');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('q9tmjtup2w6fwds3c5xq8r8txx87h9fp8xhadbyqhl4tlvud3k','5tbxclauordrbqh', 'https://i.scdn.co/image/ab67616d0000b273b852a616ae3a49a1f6b0f16e', 'INTERWORLD Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mw9t57xrq1gh8y8u2uv90t755xgv5y3ee80t65blgwply6evux','METAMORPHOSIS','5tbxclauordrbqh','POP','2ksyzVfU0WJoBpu8otr4pz','https://p.scdn.co/mp3-preview/61baac6cfee58ae57f9f767a86fa5e99f9797664?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q9tmjtup2w6fwds3c5xq8r8txx87h9fp8xhadbyqhl4tlvud3k', 'mw9t57xrq1gh8y8u2uv90t755xgv5y3ee80t65blgwply6evux', '0');
-- Bobby Helms
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wujmpsp54smfpab', 'Bobby Helms', '188@artist.com', 'https://i.scdn.co/image/1dcd3f5d64a65f19d085b8e78746e457bd2d2e05','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:188@artist.com', 'wujmpsp54smfpab', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wujmpsp54smfpab', 'Delivering soul-stirring tunes that linger in the mind.', 'Bobby Helms');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ac8f7hwis7wz2zodvl3f3nzjs691d4hj8fopiywr503jljwxek','wujmpsp54smfpab', 'https://i.scdn.co/image/ab67616d0000b273fd56f3c7a294f5cfe51c7b17', 'Bobby Helms Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sy42ubzmyl5x70exx2wo7kjeozyb87q79kgdoc8hane3wuo9jj','Jingle Bell Rock','wujmpsp54smfpab','POP','7vQbuQcyTflfCIOu3Uzzya',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ac8f7hwis7wz2zodvl3f3nzjs691d4hj8fopiywr503jljwxek', 'sy42ubzmyl5x70exx2wo7kjeozyb87q79kgdoc8hane3wuo9jj', '0');
-- Seafret
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('weov8imuclw3287', 'Seafret', '189@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7f753324eacfbe0db36d64e5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:189@artist.com', 'weov8imuclw3287', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('weov8imuclw3287', 'Pushing the boundaries of sound with each note.', 'Seafret');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bwihnwak0m3cotbkm2v8oji8koj1iulh9yj8v60yv0az51d5e5','weov8imuclw3287', 'https://i.scdn.co/image/ab67616d0000b2738c33272a7c77042f5eb39d75', 'Seafret Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('96v9ii3odpthtgq6e90wrb73s3sa8beyfk2dpbtwsezk8519ag','Atlantis','weov8imuclw3287','POP','1Fid2jjqsHViMX6xNH70hE','https://p.scdn.co/mp3-preview/2097364ff6c9f41d658ea1b00a5e2153dc61144b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bwihnwak0m3cotbkm2v8oji8koj1iulh9yj8v60yv0az51d5e5', '96v9ii3odpthtgq6e90wrb73s3sa8beyfk2dpbtwsezk8519ag', '0');
-- Treyce
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5p1dajvsen10t7o', 'Treyce', '190@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7b48fa6e2c8280e205c5ea7b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:190@artist.com', '5p1dajvsen10t7o', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5p1dajvsen10t7o', 'Crafting soundscapes that transport listeners to another world.', 'Treyce');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('de8n9dhomq3fk9suimrlc5tpiv0nuklqiioeydhdgksseethcn','5p1dajvsen10t7o', NULL, 'Treyce Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('68ftfcgqbq66crl24yrnd5mobcw9fui8jf2wmtsdptogpv9xfv','Lovezinho','5p1dajvsen10t7o','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('de8n9dhomq3fk9suimrlc5tpiv0nuklqiioeydhdgksseethcn', '68ftfcgqbq66crl24yrnd5mobcw9fui8jf2wmtsdptogpv9xfv', '0');
-- Mambo Kingz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nnw2xqegupazufe', 'Mambo Kingz', '191@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb881ed0aa97cc8420685dc90e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:191@artist.com', 'nnw2xqegupazufe', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nnw2xqegupazufe', 'Breathing new life into classic genres.', 'Mambo Kingz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pzh0h9vl8mykhx4pg5ef90duubudf4h1wcwkjn2cg2phow30pe','nnw2xqegupazufe', NULL, 'Mambo Kingz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('axptvn6rawfbr8q7hf36lf5fmo31aqgnhli0gkcr6j8aoers5h','Mejor Que Yo','nnw2xqegupazufe','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pzh0h9vl8mykhx4pg5ef90duubudf4h1wcwkjn2cg2phow30pe', 'axptvn6rawfbr8q7hf36lf5fmo31aqgnhli0gkcr6j8aoers5h', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('japchheriv543qiz6uokyb6ktsmp7lywrcsdsczvrwnoz765bn','Mas Rica Que Ayer','nnw2xqegupazufe','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pzh0h9vl8mykhx4pg5ef90duubudf4h1wcwkjn2cg2phow30pe', 'japchheriv543qiz6uokyb6ktsmp7lywrcsdsczvrwnoz765bn', '1');
-- Karol G
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('umj3gisqstrlhvi', 'Karol G', '192@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb284894d68fe2f80cad555110','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:192@artist.com', 'umj3gisqstrlhvi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('umj3gisqstrlhvi', 'A queen of reggaeton, known for her empowering anthems and vibrant performances.', 'Karol G');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gkfs8s6xfn97ny6xc3b8rf1j53p24py95ep5z3glgny63zy1i8','umj3gisqstrlhvi', 'https://i.scdn.co/image/ab67616d0000b27382de1ca074ae63cb18fce335', 'Karol G Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ubxrsbo11ix1dikkapo5zi1xwp1nnyc3y1z71btlj96o2awfq3','TQG','umj3gisqstrlhvi','POP','0DWdj2oZMBFSzRsi2Cvfzf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gkfs8s6xfn97ny6xc3b8rf1j53p24py95ep5z3glgny63zy1i8', 'ubxrsbo11ix1dikkapo5zi1xwp1nnyc3y1z71btlj96o2awfq3', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7ztut2s5kymvyrhma4x9uvtcnihk8nu852g39vkr2q7l2vbo8r','AMARGURA','umj3gisqstrlhvi','POP','505v13epFXodT9fVAJ6h8k',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gkfs8s6xfn97ny6xc3b8rf1j53p24py95ep5z3glgny63zy1i8', '7ztut2s5kymvyrhma4x9uvtcnihk8nu852g39vkr2q7l2vbo8r', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ujvkjw0o56lemtapqg3cug632usmqbedmc0x399ykvmhfudi7m','S91','umj3gisqstrlhvi','POP','7EpOXgSRgnglRWr86pZfGU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gkfs8s6xfn97ny6xc3b8rf1j53p24py95ep5z3glgny63zy1i8', 'ujvkjw0o56lemtapqg3cug632usmqbedmc0x399ykvmhfudi7m', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vys768gxtbbp1961essapzsxwsu15msxtwu91btse9urxwxvo4','MIENTRAS ME CURO DEL CORA','umj3gisqstrlhvi','POP','6otePxalBK8AVa20xhZYVQ',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gkfs8s6xfn97ny6xc3b8rf1j53p24py95ep5z3glgny63zy1i8', 'vys768gxtbbp1961essapzsxwsu15msxtwu91btse9urxwxvo4', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x9a0r8sr2nva6uu8vvlgn84gh6wdhv53f29k14c8hh0lujii2d','X SI VOLVEMOS','umj3gisqstrlhvi','POP','4NoOME4Dhf4xgxbHDT7VGe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gkfs8s6xfn97ny6xc3b8rf1j53p24py95ep5z3glgny63zy1i8', 'x9a0r8sr2nva6uu8vvlgn84gh6wdhv53f29k14c8hh0lujii2d', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k65ibbsh4jnc1q0y6v845d1vydy6mu6vzua2f1rz306ksa9n8t','PROVENZA','umj3gisqstrlhvi','POP','3HqcNJdZ2seoGxhn0wVNDK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gkfs8s6xfn97ny6xc3b8rf1j53p24py95ep5z3glgny63zy1i8', 'k65ibbsh4jnc1q0y6v845d1vydy6mu6vzua2f1rz306ksa9n8t', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xp1qdaz3baibppo754cnuchwhk6u5u37exa9yc6bqory29q0cd','CAIRO','umj3gisqstrlhvi','POP','16dUQ4quIHDe4ZZ0wF1EMN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gkfs8s6xfn97ny6xc3b8rf1j53p24py95ep5z3glgny63zy1i8', 'xp1qdaz3baibppo754cnuchwhk6u5u37exa9yc6bqory29q0cd', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qrenxdzjztp9bs6kmirzezvblk8edaunwnkr3z2c35mqp6odux','PERO T','umj3gisqstrlhvi','POP','1dw7qShk971xMD6r6mA4VN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gkfs8s6xfn97ny6xc3b8rf1j53p24py95ep5z3glgny63zy1i8', 'qrenxdzjztp9bs6kmirzezvblk8edaunwnkr3z2c35mqp6odux', '7');
-- The Walters
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z63jtysq89y7kqk', 'The Walters', '193@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6c4366f40ea49c1318707f97','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:193@artist.com', 'z63jtysq89y7kqk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z63jtysq89y7kqk', 'Exploring the depths of sound and rhythm.', 'The Walters');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fboqiy0rykckl9cbfkx6lb7oypy5qi2d7p154r2lfo2z1lthwv','z63jtysq89y7kqk', 'https://i.scdn.co/image/ab67616d0000b2739214ff0109a0e062f8a6cf0f', 'The Walters Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1469lajp4hdk7d4vrpzsmsk01pud9avpn8sy50b2elvbg13tuq','I Love You So','z63jtysq89y7kqk','POP','4SqWKzw0CbA05TGszDgMlc','https://p.scdn.co/mp3-preview/83919b3d62a4ae352229c0a779e8aa0c1b2f4f40?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fboqiy0rykckl9cbfkx6lb7oypy5qi2d7p154r2lfo2z1lthwv', '1469lajp4hdk7d4vrpzsmsk01pud9avpn8sy50b2elvbg13tuq', '0');
-- Lord Huron
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('evs8hcqujc5evdk', 'Lord Huron', '194@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1d4e4e7e3c5d8fa494fc5f10','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:194@artist.com', 'evs8hcqujc5evdk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('evs8hcqujc5evdk', 'An odyssey of sound that defies conventions.', 'Lord Huron');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l9m7smjkc6ufzg7stvj23bcdgof3x4q5e8v3ts1u69xd1u0v1y','evs8hcqujc5evdk', 'https://i.scdn.co/image/ab67616d0000b2739d2efe43d5b7ebc7cb60ca81', 'Lord Huron Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vot29nzci5e8ypvya1typkq8p7xxi3epggmc0qxciwjslcekb6','The Night We Met','evs8hcqujc5evdk','POP','0QZ5yyl6B6utIWkxeBDxQN','https://p.scdn.co/mp3-preview/f10f271b165ee07e3d49d9f961d08b7ad74ebd5b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l9m7smjkc6ufzg7stvj23bcdgof3x4q5e8v3ts1u69xd1u0v1y', 'vot29nzci5e8ypvya1typkq8p7xxi3epggmc0qxciwjslcekb6', '0');
-- Junior H
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fg4lmt2zehr7wlj', 'Junior H', '195@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:195@artist.com', 'fg4lmt2zehr7wlj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fg4lmt2zehr7wlj', 'A fresh voice in regional Mexican music, blending tradition with modernity.', 'Junior H');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('defu7gq7na2tzuc3lx14b0qxh0kcd6a9i9su6nx24dh4yz8v04','fg4lmt2zehr7wlj', 'https://i.scdn.co/image/ab67616d0000b27333ed356efed99b158c4267c6', 'Junior H Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vfqszy14mggm9ut6a9igmgu1lc7126gm5g8ky4l9htumwwpuwo','El Azul','fg4lmt2zehr7wlj','POP','1haJsMtoBhHfvuM7XWuT3W','https://p.scdn.co/mp3-preview/f9df136c3a2d3c0c5424e2c4b75a303f35c08af5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('defu7gq7na2tzuc3lx14b0qxh0kcd6a9i9su6nx24dh4yz8v04', 'vfqszy14mggm9ut6a9igmgu1lc7126gm5g8ky4l9htumwwpuwo', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r7syzwt0uthfhjcue5dn4mv3amr9uscraz9t6ajiz72rw28ow0','LUNA','fg4lmt2zehr7wlj','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('defu7gq7na2tzuc3lx14b0qxh0kcd6a9i9su6nx24dh4yz8v04', 'r7syzwt0uthfhjcue5dn4mv3amr9uscraz9t6ajiz72rw28ow0', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kzlri9j8qr2ka21byp2212t8ijeijweflcuk1kuagkdjdkcljy','Abcdario','fg4lmt2zehr7wlj','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('defu7gq7na2tzuc3lx14b0qxh0kcd6a9i9su6nx24dh4yz8v04', 'kzlri9j8qr2ka21byp2212t8ijeijweflcuk1kuagkdjdkcljy', '2');
-- Harry Styles
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pv38fsdyvdv2p15', 'Harry Styles', '196@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf7db7c8ede90a019c54590bb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:196@artist.com', 'pv38fsdyvdv2p15', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pv38fsdyvdv2p15', 'Defining modern pop-rock with his charismatic presence and bold choices.', 'Harry Styles');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('flq0dohs2vym3bkxe64rr4n3c1w95fj91h6u7easinjnh9imr4','pv38fsdyvdv2p15', 'https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0', 'Harry Styles Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('atkximlqlt8ka6gwuqe7qw2kqk6qcz4ooayqld9dgmpo6slx3t','As It Was','pv38fsdyvdv2p15','POP','4Dvkj6JhhA12EX05fT7y2e','https://p.scdn.co/mp3-preview/c43dd07043b29e800c1a65b3a0102861fa3cf418?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('flq0dohs2vym3bkxe64rr4n3c1w95fj91h6u7easinjnh9imr4', 'atkximlqlt8ka6gwuqe7qw2kqk6qcz4ooayqld9dgmpo6slx3t', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xr7p2l3dl6p3jp9hoi4vmqco825fjk3sq4l1aj0hae2i3n7xih','Watermelon Sugar','pv38fsdyvdv2p15','POP','6UelLqGlWMcVH1E5c4H7lY','https://p.scdn.co/mp3-preview/824cd58da2e9a15eeaaa6746becc09093547a09b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('flq0dohs2vym3bkxe64rr4n3c1w95fj91h6u7easinjnh9imr4', 'xr7p2l3dl6p3jp9hoi4vmqco825fjk3sq4l1aj0hae2i3n7xih', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cz8a655kz4dfmpmn8x2ml3m0dwmimx2p2dmkcqw1rdnwgxgysr','Late Night Talking','pv38fsdyvdv2p15','POP','1qEmFfgcLObUfQm0j1W2CK','https://p.scdn.co/mp3-preview/50f056e2ab4a1bef762661dbbf2da751beeffe39?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('flq0dohs2vym3bkxe64rr4n3c1w95fj91h6u7easinjnh9imr4', 'cz8a655kz4dfmpmn8x2ml3m0dwmimx2p2dmkcqw1rdnwgxgysr', '2');
-- Fifty Fifty
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jb3sbjre0o7ax0s', 'Fifty Fifty', '197@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5a60b0f886b5deb8518e4a41','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:197@artist.com', 'jb3sbjre0o7ax0s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jb3sbjre0o7ax0s', 'Blending a rich array of genres to create a unique musical experience.', 'Fifty Fifty');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fpfjvwmb13wsjq2fsmjj8re0o52ossld6s4gtp6g7lsdvuidv8','jb3sbjre0o7ax0s', 'https://i.scdn.co/image/ab67616d0000b27337c0b3670236c067c8e8bbcb', 'Fifty Fifty Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bxcc08mnul04vj5du217k0trluihmru1rb2cfc3gm6f9kw4f0c','Cupid - Twin Ver.','jb3sbjre0o7ax0s','POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fpfjvwmb13wsjq2fsmjj8re0o52ossld6s4gtp6g7lsdvuidv8', 'bxcc08mnul04vj5du217k0trluihmru1rb2cfc3gm6f9kw4f0c', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ptqoiaxxjopc7yicapk3xs1wk89yb0413v4ns2ctkoq8nmtuap','Cupid','jb3sbjre0o7ax0s','POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fpfjvwmb13wsjq2fsmjj8re0o52ossld6s4gtp6g7lsdvuidv8', 'ptqoiaxxjopc7yicapk3xs1wk89yb0413v4ns2ctkoq8nmtuap', '1');
-- Elley Duh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('62ln8ztjz9oquqb', 'Elley Duh', '198@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb44efd91d240d9853049612b4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:198@artist.com', '62ln8ztjz9oquqb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('62ln8ztjz9oquqb', 'A voice that echoes the sentiments of a generation.', 'Elley Duh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g4n2zg00794i5r6t4j6j6xnww6gunbi2ukrkmenda63tyt9ubz','62ln8ztjz9oquqb', 'https://i.scdn.co/image/ab67616d0000b27353a2e11c1bde700722fecd2e', 'Elley Duh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g3ybg0npxfyftp25q2bpdwj2e9pr6vwfy9jp8rgv9e2w0mrz8d','MIDDLE OF THE NIGHT','62ln8ztjz9oquqb','POP','58HvfVOeJY7lUuCqF0m3ly','https://p.scdn.co/mp3-preview/e7c2441dcf8e321237c35085e4aa05bd0dcfa2c4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g4n2zg00794i5r6t4j6j6xnww6gunbi2ukrkmenda63tyt9ubz', 'g3ybg0npxfyftp25q2bpdwj2e9pr6vwfy9jp8rgv9e2w0mrz8d', '0');
-- Miguel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kl3gzx5xzuy6q23', 'Miguel', '199@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4669166b571594eade778990','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:199@artist.com', 'kl3gzx5xzuy6q23', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kl3gzx5xzuy6q23', 'Crafting soundscapes that transport listeners to another world.', 'Miguel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e45gl0izgjzr6vmavja6l6cuqjxrv03o8ldr4nqo21f2kk8b05','kl3gzx5xzuy6q23', 'https://i.scdn.co/image/ab67616d0000b273d5a8395b0d80b8c48a5d851c', 'Miguel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pa3y40irfzpiss960c1hkkew1i3m9zral0kstsg2m3vd4jni2r','Sure Thing','kl3gzx5xzuy6q23','POP','0JXXNGljqupsJaZsgSbMZV','https://p.scdn.co/mp3-preview/d337faa4bb71c8ac9a13998be64fbb0d7d8b8463?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e45gl0izgjzr6vmavja6l6cuqjxrv03o8ldr4nqo21f2kk8b05', 'pa3y40irfzpiss960c1hkkew1i3m9zral0kstsg2m3vd4jni2r', '0');
-- Justin Bieber
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yh186o7ghnsgpxh', 'Justin Bieber', '200@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:200@artist.com', 'yh186o7ghnsgpxh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yh186o7ghnsgpxh', 'From teen idol to global pop star, constantly evolving his sound.', 'Justin Bieber');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uav2rj6tyh3pmqqqd0owh21aaozc1fzm7uhv0en9ojwyn0owtp','yh186o7ghnsgpxh', NULL, 'Justin Bieber Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('adfgsp4y66hy4kptjw6zphef0mx7enx2izgblaohltzcfown29','STAY (with Justin Bieber)','yh186o7ghnsgpxh','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uav2rj6tyh3pmqqqd0owh21aaozc1fzm7uhv0en9ojwyn0owtp', 'adfgsp4y66hy4kptjw6zphef0mx7enx2izgblaohltzcfown29', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3k9tczh4c90prmyuovap3vbsgpbwrbf5a31kkwle09ev8t5oy2','Ghost','yh186o7ghnsgpxh','POP','6I3mqTwhRpn34SLVafSH7G',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uav2rj6tyh3pmqqqd0owh21aaozc1fzm7uhv0en9ojwyn0owtp', '3k9tczh4c90prmyuovap3vbsgpbwrbf5a31kkwle09ev8t5oy2', '1');
-- Bebe Rexha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('267mjzf0i18g0jk', 'Bebe Rexha', '201@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41c4dd328bbea2f0a19c7522','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:201@artist.com', '267mjzf0i18g0jk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('267mjzf0i18g0jk', 'A dynamic voice in pop music, known for her powerful vocals and catchy tunes.', 'Bebe Rexha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('f5r2ga0z7b94e8bxfhwxiaavp5vg3lu2kmimk31vw8pfe53i5v','267mjzf0i18g0jk', NULL, 'Bebe Rexha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1qq4yck9odepc5gae2rcjy9slxkrbzy2ltme783qn1pvpp23zd','Im Good (Blue)','267mjzf0i18g0jk','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f5r2ga0z7b94e8bxfhwxiaavp5vg3lu2kmimk31vw8pfe53i5v', '1qq4yck9odepc5gae2rcjy9slxkrbzy2ltme783qn1pvpp23zd', '0');
-- Lizzy McAlpine
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z0f2wcthllyx3he', 'Lizzy McAlpine', '202@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb10e2b618880f429a3967185','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:202@artist.com', 'z0f2wcthllyx3he', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z0f2wcthllyx3he', 'Harnessing the power of melody to tell compelling stories.', 'Lizzy McAlpine');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('urzqsdf3bkp7vm88z20ny20hwjnku2em9mbgr2z45rmj46f0qy','z0f2wcthllyx3he', 'https://i.scdn.co/image/ab67616d0000b273d370fdc4dbc47778b9b667c3', 'Lizzy McAlpine Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8s98fnrjdf8wgzrhrj6jk68ew1tbfn372eyxepst0qhcel8egp','ceilings','z0f2wcthllyx3he','POP','2L9N0zZnd37dwF0clgxMGI','https://p.scdn.co/mp3-preview/580782ffb17d468fe5d000bdf86cc07926ff9a5a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('urzqsdf3bkp7vm88z20ny20hwjnku2em9mbgr2z45rmj46f0qy', '8s98fnrjdf8wgzrhrj6jk68ew1tbfn372eyxepst0qhcel8egp', '0');
-- NF
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2pm0wones7qrzxl', 'NF', '203@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1cf142a710a2f3d9b7a62da1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:203@artist.com', '2pm0wones7qrzxl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2pm0wones7qrzxl', 'A unique voice in the contemporary music scene.', 'NF');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('grgn2efor91ayisfzdy4e1ivuvdbco7cyeqd21470eukmyofd0','2pm0wones7qrzxl', 'https://i.scdn.co/image/ab67616d0000b273ff8a4276b3be31c839557439', 'NF Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('74itendvgd8lm5iesgu8cdfilkl42c6ued2lo4pk9412eylh5s','HAPPY','2pm0wones7qrzxl','POP','3ZEno9fORwMA1HPecdLi0R',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('grgn2efor91ayisfzdy4e1ivuvdbco7cyeqd21470eukmyofd0', '74itendvgd8lm5iesgu8cdfilkl42c6ued2lo4pk9412eylh5s', '0');
-- NLE Choppa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('95t2coch3xxyc7w', 'NLE Choppa', '204@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcc5865053e7177aeb0c26b62','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:204@artist.com', '95t2coch3xxyc7w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('95t2coch3xxyc7w', 'Exploring the depths of sound and rhythm.', 'NLE Choppa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bhn6ff90vyxmdlx3vzo2c93qk27uuzivk7i4wlc5mpv34845o1','95t2coch3xxyc7w', 'https://i.scdn.co/image/ab67616d0000b27349a4f6c9a637e02252a0076d', 'NLE Choppa Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u3tyvcofzbj4imoja3y9j6sunqi2uz5f2f2qgckiwgo9hxixai','Slut Me Out','95t2coch3xxyc7w','POP','5BmB3OaQyYXCqRyN8iR2Yi','https://p.scdn.co/mp3-preview/84ef49a1e71bdac04b7dfb1dea3a56d1ffc50357?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bhn6ff90vyxmdlx3vzo2c93qk27uuzivk7i4wlc5mpv34845o1', 'u3tyvcofzbj4imoja3y9j6sunqi2uz5f2f2qgckiwgo9hxixai', '0');
-- Gustavo Mioto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1lp3b84czyeyh3v', 'Gustavo Mioto', '205@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcec51a9ef6fe19159cb0452f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:205@artist.com', '1lp3b84czyeyh3v', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1lp3b84czyeyh3v', 'A confluence of cultural beats and contemporary tunes.', 'Gustavo Mioto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nioi6rcgqh14fh02z1y7yku2ll0v395js3tjz2cl4uceobe1t1','1lp3b84czyeyh3v', 'https://i.scdn.co/image/ab67616d0000b27319bb2fb697a42c1084d71f6c', 'Gustavo Mioto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3ayy1mbp2fxtvy6g0531e94pozmrirobertbjjyh357pt1as1c','Eu Gosto Assim - Ao Vivo','1lp3b84czyeyh3v','POP','4ASA1PZyWGbuc4d9N8OAcF',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nioi6rcgqh14fh02z1y7yku2ll0v395js3tjz2cl4uceobe1t1', '3ayy1mbp2fxtvy6g0531e94pozmrirobertbjjyh357pt1as1c', '0');
-- Kodak Black
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u481mnaldgxkh9w', 'Kodak Black', '206@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb70c05cf4dc9a7d3ffd02ba19','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:206@artist.com', 'u481mnaldgxkh9w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u481mnaldgxkh9w', 'Crafting melodies that resonate with the soul.', 'Kodak Black');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kxiae0g2f0ay2u3tqldxiq74a9jhr9f9n2l52fwsld3d1zg91s','u481mnaldgxkh9w', 'https://i.scdn.co/image/ab67616d0000b273445afb6341d2685b959251cc', 'Kodak Black Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m9ao9irrmvv8tb8b3sf04h9pfmefw8w482kxo8vv6ktn1g1zu8','Angel Pt 1 (feat. Jimin of BTS, JVKE & Muni Long)','u481mnaldgxkh9w','POP','1vvcEHQdaUTvWt0EIUYcFK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kxiae0g2f0ay2u3tqldxiq74a9jhr9f9n2l52fwsld3d1zg91s', 'm9ao9irrmvv8tb8b3sf04h9pfmefw8w482kxo8vv6ktn1g1zu8', '0');
-- Styrx
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f4jz7kmffl4v6qn', 'Styrx', '207@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfef3008e708e59efaa5667ed','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:207@artist.com', 'f4jz7kmffl4v6qn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('f4jz7kmffl4v6qn', 'Blending traditional rhythms with modern beats.', 'Styrx');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('v45pdecq6l793y1onffu5ymhm4pz3ybmwqtf3vzmaqaucma36e','f4jz7kmffl4v6qn', NULL, 'Styrx Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ua173lcxi3n5tlulns9myadqozyudhhd3khl47b41fm89yc8z2','Agudo Mgi','f4jz7kmffl4v6qn','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v45pdecq6l793y1onffu5ymhm4pz3ybmwqtf3vzmaqaucma36e', 'ua173lcxi3n5tlulns9myadqozyudhhd3khl47b41fm89yc8z2', '0');
-- Arctic Monkeys
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ubiuiq8061mxxza', 'Arctic Monkeys', '208@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:208@artist.com', 'ubiuiq8061mxxza', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ubiuiq8061mxxza', 'Rock innovators, known for their sharp lyrics and compelling sound.', 'Arctic Monkeys');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wjelskisygfaze6xbnbrrhbkvjblu2svawha8iyd01zxes51xf','ubiuiq8061mxxza', 'https://i.scdn.co/image/ab67616d0000b2734ae1c4c5c45aabe565499163', 'Arctic Monkeys Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('b4uqzfk8h8mvlym8exa95ddgbftqqo9qza5123ub3x2n0mg5r8','I Wanna Be Yours','ubiuiq8061mxxza','POP','5XeFesFbtLpXzIVDNQP22n','https://p.scdn.co/mp3-preview/07de30bde8363d9ff78b72339245c151f67af451?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wjelskisygfaze6xbnbrrhbkvjblu2svawha8iyd01zxes51xf', 'b4uqzfk8h8mvlym8exa95ddgbftqqo9qza5123ub3x2n0mg5r8', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d0wxk9mz2ad65g99o8b5re5wsqe21wuhgjvejh0pvqznn4r5aj','505','ubiuiq8061mxxza','POP','58ge6dfP91o9oXMzq3XkIS','https://p.scdn.co/mp3-preview/1b23606bada6aacb339535944c1fe505898195e1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wjelskisygfaze6xbnbrrhbkvjblu2svawha8iyd01zxes51xf', 'd0wxk9mz2ad65g99o8b5re5wsqe21wuhgjvejh0pvqznn4r5aj', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7n4kmznshkg066kditercd4mcmrk67ble8jm2d6pxycohw067c','Do I Wanna Know?','ubiuiq8061mxxza','POP','5FVd6KXrgO9B3JPmC8OPst','https://p.scdn.co/mp3-preview/006bc465fe3d1c04dae93a050eca9d402a7322b8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wjelskisygfaze6xbnbrrhbkvjblu2svawha8iyd01zxes51xf', '7n4kmznshkg066kditercd4mcmrk67ble8jm2d6pxycohw067c', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qkgpfn7msrmhx3hzts7mw7w9iednihoioz93kr6h5xcue6okna','Whyd You Only Call Me When Youre High?','ubiuiq8061mxxza','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wjelskisygfaze6xbnbrrhbkvjblu2svawha8iyd01zxes51xf', 'qkgpfn7msrmhx3hzts7mw7w9iednihoioz93kr6h5xcue6okna', '3');
-- sped up 8282
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3tweitilk48iqm1', 'sped up 8282', '209@artist.com', 'https://i.scdn.co/image/ab67616d0000b2730a0ba228b5be4ffb7c7c59fb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:209@artist.com', '3tweitilk48iqm1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3tweitilk48iqm1', 'The architect of aural landscapes that inspire and captivate.', 'sped up 8282');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o8w0rk8ukqmn7fg4gc1kar6ca997e2h4a8xyh9cp9kj50wfs3b','3tweitilk48iqm1', 'https://i.scdn.co/image/ab67616d0000b2730a0ba228b5be4ffb7c7c59fb', 'sped up 8282 Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h5mwxrbi18dfxpszq2u5wks648ij2nptrtln4ydzs9a40bcynu','Cupid  Twin Ver. (FIFTY FIFTY)  Spe','3tweitilk48iqm1','POP','3B228N0GxfUCwPyfNcJxps','https://p.scdn.co/mp3-preview/29e8870f55c261ec995edfe4a3e9f30e4d4527e0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o8w0rk8ukqmn7fg4gc1kar6ca997e2h4a8xyh9cp9kj50wfs3b', 'h5mwxrbi18dfxpszq2u5wks648ij2nptrtln4ydzs9a40bcynu', '0');
-- Anggi Marito
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nf1xh8lm8yl69y4', 'Anggi Marito', '210@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb604493f4d58b7d152a2d5f79','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:210@artist.com', 'nf1xh8lm8yl69y4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nf1xh8lm8yl69y4', 'An endless quest for musical perfection.', 'Anggi Marito');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t0bq63015jsvouw8u7osl1dbp8bjk9twd0rvf2jqhp0x1n60qh','nf1xh8lm8yl69y4', 'https://i.scdn.co/image/ab67616d0000b2732844c4e4e984ea408ab7fd6f', 'Anggi Marito Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z0gk6f9oks2zlgnb27ro1vqmievxh9yo287kqmiua9j3kfjd27','Tak Segampang Itu','nf1xh8lm8yl69y4','POP','26cvTWJq2E1QqN4jyH2OTU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t0bq63015jsvouw8u7osl1dbp8bjk9twd0rvf2jqhp0x1n60qh', 'z0gk6f9oks2zlgnb27ro1vqmievxh9yo287kqmiua9j3kfjd27', '0');
-- Coolio
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0ggyfz0ijq4s80i', 'Coolio', '211@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5ea53fc78df8f7e7559e228d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:211@artist.com', '0ggyfz0ijq4s80i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0ggyfz0ijq4s80i', 'Crafting melodies that resonate with the soul.', 'Coolio');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5if5v01p8rg4ae2m54em4iiu1483kpzml23f0qhyscr1mhgr2x','0ggyfz0ijq4s80i', 'https://i.scdn.co/image/ab67616d0000b273c31d3c870a3dbaf7b53186cc', 'Coolio Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0ozw4nl95fkog3xu29fw78b3qxhpurtuhlcouponu3svcvtrqy','Gangstas Paradise','0ggyfz0ijq4s80i','POP','1DIXPcTDzTj8ZMHt3PDt8p','https://p.scdn.co/mp3-preview/1454c63a66c27ac745f874d6c113270a9c62d28e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5if5v01p8rg4ae2m54em4iiu1483kpzml23f0qhyscr1mhgr2x', '0ozw4nl95fkog3xu29fw78b3qxhpurtuhlcouponu3svcvtrqy', '0');
-- Kelly Clarkson
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tuad0zfq3sw27dv', 'Kelly Clarkson', '212@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb305a7cc6760b53a67aaae19d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:212@artist.com', 'tuad0zfq3sw27dv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tuad0zfq3sw27dv', 'An endless quest for musical perfection.', 'Kelly Clarkson');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3lrogzdcgo6vg80gzw72qoqo75glds0mis62ypjbh42xpjwtlf','tuad0zfq3sw27dv', 'https://i.scdn.co/image/ab67616d0000b273f54a315f1d2445791fe601a7', 'Kelly Clarkson Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2yqae8lshsxr8ufli5ikj489lc082jhnfopkur84x4334l8loh','Underneath the Tree','tuad0zfq3sw27dv','POP','3YZE5qDV7u1ZD1gZc47ZeR','https://p.scdn.co/mp3-preview/9d6040eda6551e1746409ca2c8cf04d95475019a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3lrogzdcgo6vg80gzw72qoqo75glds0mis62ypjbh42xpjwtlf', '2yqae8lshsxr8ufli5ikj489lc082jhnfopkur84x4334l8loh', '0');
-- J. Cole
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('t12llr8pbv6r3ob', 'J. Cole', '213@artist.com', 'https://i.scdn.co/image/ab67616d0000b273d092fc596478080bb0e06aea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:213@artist.com', 't12llr8pbv6r3ob', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('t12llr8pbv6r3ob', 'A profound lyricist and rapper, known for his thought-provoking music.', 'J. Cole');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('41gdj66h2d6pgp6epkp1y5m3y5cs7qh75bacaaf8n3342d92xm','t12llr8pbv6r3ob', NULL, 'J. Cole Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hva90pm3y1z9zohkdl6tqiiq3v88h6p26kbh0n40m0q0pg3lms','All My Life (feat. J. Cole)','t12llr8pbv6r3ob','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('41gdj66h2d6pgp6epkp1y5m3y5cs7qh75bacaaf8n3342d92xm', 'hva90pm3y1z9zohkdl6tqiiq3v88h6p26kbh0n40m0q0pg3lms', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lfm8vyxipfeuu5s3c0m6lpb0p8xjmotmzswuf2eq75b8qprcaz','No Role Modelz','t12llr8pbv6r3ob','POP','68Dni7IE4VyPkTOH9mRWHr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('41gdj66h2d6pgp6epkp1y5m3y5cs7qh75bacaaf8n3342d92xm', 'lfm8vyxipfeuu5s3c0m6lpb0p8xjmotmzswuf2eq75b8qprcaz', '1');
-- Rauw Alejandro
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qckmv3cul047q2p', 'Rauw Alejandro', '214@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9047f938310ea16b68a5bdeb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:214@artist.com', 'qckmv3cul047q2p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qckmv3cul047q2p', 'A fusion of Latin trap and reggaeton, setting the stage on fire.', 'Rauw Alejandro');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6fl0r6sk20zhdlbn1u8cm7wc2z52sj0r1pl3fmjld44j69ish1','qckmv3cul047q2p', NULL, 'Rauw Alejandro Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wipr39g0inbkb4t0s7ri5y89yezfco2sfxjn4wklowdbbq5ism','BESO','qckmv3cul047q2p','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6fl0r6sk20zhdlbn1u8cm7wc2z52sj0r1pl3fmjld44j69ish1', 'wipr39g0inbkb4t0s7ri5y89yezfco2sfxjn4wklowdbbq5ism', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d9kqm74r6o7ehitumdhqgsxha3nh2qgq3xs1egueuum4wej775','BABY HELLO','qckmv3cul047q2p','POP','2SOvWt6igzXViIjIiWNWEP','https://p.scdn.co/mp3-preview/8a9ca6c81e6e6ad48758f02017456405fd7a476d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6fl0r6sk20zhdlbn1u8cm7wc2z52sj0r1pl3fmjld44j69ish1', 'd9kqm74r6o7ehitumdhqgsxha3nh2qgq3xs1egueuum4wej775', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jvfj9wzrrdhkwuwfxh6oaqhqiyqielihocvyhf9ca7wzjjg5qd','Rauw Alejandro: Bzrp Music Sessions, Vol. 56','qckmv3cul047q2p','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6fl0r6sk20zhdlbn1u8cm7wc2z52sj0r1pl3fmjld44j69ish1', 'jvfj9wzrrdhkwuwfxh6oaqhqiyqielihocvyhf9ca7wzjjg5qd', '2');
-- Nengo Flow
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nmnfvwkran9dams', 'Nengo Flow', '215@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebda3f48cf2309aacaab0edce2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:215@artist.com', 'nmnfvwkran9dams', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nmnfvwkran9dams', 'Striking chords that resonate across generations.', 'Nengo Flow');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('em12qeshra55vcxyf70tvgy0xrlwm0y0kvxx0bpwqo7zoutiuc','nmnfvwkran9dams', 'https://i.scdn.co/image/ab67616d0000b273ed132404686f567c8f793058', 'Nengo Flow Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uhn0g2iyh0obpwary6unh8royt80p3h2xy3q2etco9bx1m1guo','Gato de Noche','nmnfvwkran9dams','POP','54ELExv56KCAB4UP9cOCzC','https://p.scdn.co/mp3-preview/7d6a9dab2f3779eef37ef52603d20607a1390d91?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('em12qeshra55vcxyf70tvgy0xrlwm0y0kvxx0bpwqo7zoutiuc', 'uhn0g2iyh0obpwary6unh8royt80p3h2xy3q2etco9bx1m1guo', '0');
-- Eminem
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f2xyx7j0d3673g6', 'Eminem', '216@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba00b11c129b27a88fc72f36b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:216@artist.com', 'f2xyx7j0d3673g6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('f2xyx7j0d3673g6', 'Igniting the stage with electrifying performances.', 'Eminem');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('071vyksc7o3lqigo60hhmf1tlt6tibsee487cul4ox8u0ylhhu','f2xyx7j0d3673g6', 'https://i.scdn.co/image/ab67616d0000b273726d48d93d02e1271774f023', 'Eminem Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hrtqgf3ws2lc5u4w5da36rr8f4e8juqp4hl03bbogrervkx4m5','Mockingbird','f2xyx7j0d3673g6','POP','561jH07mF1jHuk7KlaeF0s',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('071vyksc7o3lqigo60hhmf1tlt6tibsee487cul4ox8u0ylhhu', 'hrtqgf3ws2lc5u4w5da36rr8f4e8juqp4hl03bbogrervkx4m5', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w1aiaxtpytx9ctdlsrdga4w0nwsqbzyeynifqmwlc4tbca85kf','Without Me','f2xyx7j0d3673g6','POP','7lQ8MOhq6IN2w8EYcFNSUk',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('071vyksc7o3lqigo60hhmf1tlt6tibsee487cul4ox8u0ylhhu', 'w1aiaxtpytx9ctdlsrdga4w0nwsqbzyeynifqmwlc4tbca85kf', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m9birgazr8ajw3l1m9o2aihpj4kdrxjdl0c2vt85preld90jew','The Real Slim Shady','f2xyx7j0d3673g6','POP','3yfqSUWxFvZELEM4PmlwIR',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('071vyksc7o3lqigo60hhmf1tlt6tibsee487cul4ox8u0ylhhu', 'm9birgazr8ajw3l1m9o2aihpj4kdrxjdl0c2vt85preld90jew', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4j45ssa5at0s2i7run3bst2zum7wv8smttfsp40cvtn7es4wdy','Lose Yourself - Soundtrack Version','f2xyx7j0d3673g6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('071vyksc7o3lqigo60hhmf1tlt6tibsee487cul4ox8u0ylhhu', '4j45ssa5at0s2i7run3bst2zum7wv8smttfsp40cvtn7es4wdy', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jce6ek9rf5hhgiw4p7pauqsaus3mifeczlgqfssywkseojcosg','Superman','f2xyx7j0d3673g6','POP','4woTEX1wYOTGDqNXuavlRC',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('071vyksc7o3lqigo60hhmf1tlt6tibsee487cul4ox8u0ylhhu', 'jce6ek9rf5hhgiw4p7pauqsaus3mifeczlgqfssywkseojcosg', '4');
-- Frank Ocean
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hryevv72ia9esvp', 'Frank Ocean', '217@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebee3123e593174208f9754fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:217@artist.com', 'hryevv72ia9esvp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hryevv72ia9esvp', 'Creating a tapestry of tunes that celebrates diversity.', 'Frank Ocean');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('26jir9m1kn50ek0xwds4vnqcsx9sg6f231ewbhn9bpwa28ty8u','hryevv72ia9esvp', 'https://i.scdn.co/image/ab67616d0000b273c5649add07ed3720be9d5526', 'Frank Ocean Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('roh0ha8zm7z43fdd3po2lzww9relpu93bhxm1y3tftepo1xyp7','Pink + White','hryevv72ia9esvp','POP','3xKsf9qdS1CyvXSMEid6g8','https://p.scdn.co/mp3-preview/0e3ca894e19c37cbbbd511d9eb682d8bee030126?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('26jir9m1kn50ek0xwds4vnqcsx9sg6f231ewbhn9bpwa28ty8u', 'roh0ha8zm7z43fdd3po2lzww9relpu93bhxm1y3tftepo1xyp7', '0');
-- Vance Joy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fnfzvuo4rvvgxa2', 'Vance Joy', '218@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f074ec8c25406680bf26422','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:218@artist.com', 'fnfzvuo4rvvgxa2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fnfzvuo4rvvgxa2', 'Crafting folk-pop anthems that resonate with heartfelt sincerity.', 'Vance Joy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ag18snkh1wwn4qfd2v3wsc4lkhnvm7228ol08d45s0lq14500y','fnfzvuo4rvvgxa2', 'https://i.scdn.co/image/ab67616d0000b273a9929deb093a6617d2493b03', 'Vance Joy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dafzvx82lfh632vshhacyznb9ob773ghkcg8mhuh7ssqno2wft','Riptide','fnfzvuo4rvvgxa2','POP','3JvrhDOgAt6p7K8mDyZwRd','https://p.scdn.co/mp3-preview/74698d907d114f4ba0b2c129bbf260724be80b64?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ag18snkh1wwn4qfd2v3wsc4lkhnvm7228ol08d45s0lq14500y', 'dafzvx82lfh632vshhacyznb9ob773ghkcg8mhuh7ssqno2wft', '0');
-- Aerosmith
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4hexhhcmr1nd2jv', 'Aerosmith', '219@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5733401b4689b2064458e7d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:219@artist.com', '4hexhhcmr1nd2jv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4hexhhcmr1nd2jv', 'Music is my canvas, and notes are my paint.', 'Aerosmith');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3ua4z2dhhaxf8i0r0str92nr5x80wl7domiquughmj6y7m5k8o','4hexhhcmr1nd2jv', 'https://i.scdn.co/image/ab67616d0000b273bbf0146981704a073405b6c2', 'Aerosmith Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fh2r8d6ghmu9bm1zeg3k0ftckdw3dapkcsvf250l4r5nevir1i','Dream On','4hexhhcmr1nd2jv','POP','1xsYj84j7hUDDnTTerGWlH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3ua4z2dhhaxf8i0r0str92nr5x80wl7domiquughmj6y7m5k8o', 'fh2r8d6ghmu9bm1zeg3k0ftckdw3dapkcsvf250l4r5nevir1i', '0');
-- Israel & Rodolffo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7svrba7izlilota', 'Israel & Rodolffo', '220@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb697f5ad0867793de624bbb5f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:220@artist.com', '7svrba7izlilota', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7svrba7izlilota', 'Elevating the ordinary to extraordinary through music.', 'Israel & Rodolffo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('c9mi66y0jgmchvj1iytfcoi5v9inwfpgt1od2t5f3v9ty3jwak','7svrba7izlilota', 'https://i.scdn.co/image/ab67616d0000b2736ccbcc3358d31dcba6e7c035', 'Israel & Rodolffo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('usq2bkhlv4wwoala7xpdnp0rtzoccwvauf1ovffezb2n97n87h','Seu Brilho Sumiu - Ao Vivo','7svrba7izlilota','POP','3PH1nUysW7ybo3Yu8sqlPN','https://p.scdn.co/mp3-preview/125d70024c88bb1bf45666f6396dc21a181c416e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c9mi66y0jgmchvj1iytfcoi5v9inwfpgt1od2t5f3v9ty3jwak', 'usq2bkhlv4wwoala7xpdnp0rtzoccwvauf1ovffezb2n97n87h', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vtxk7lgfkap0pofmgfotsrn8w7kydslyd9tg348gvuowbsx6ia','Bombonzinho - Ao Vivo','7svrba7izlilota','POP','0SCMVUZ21uYYB8cc0ScfbV','https://p.scdn.co/mp3-preview/b7d7cfb08d5384a52deb562a3e496881c978a9f1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c9mi66y0jgmchvj1iytfcoi5v9inwfpgt1od2t5f3v9ty3jwak', 'vtxk7lgfkap0pofmgfotsrn8w7kydslyd9tg348gvuowbsx6ia', '1');
-- Doja Cat
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qe744iep40qukvy', 'Doja Cat', '221@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7f6d6cac38d494e87692af99','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:221@artist.com', 'qe744iep40qukvy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qe744iep40qukvy', 'Where words fail, my music speaks.', 'Doja Cat');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('imeqezwxnvhg1baivflywgsglclp1zqv26o7uit3ulyp2j4ca6','qe744iep40qukvy', 'https://i.scdn.co/image/ab67616d0000b273be841ba4bc24340152e3a79a', 'Doja Cat Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kxrfal4jzq0qji4oeegf0u1vzxt9nidz12g1x0x5hselfu2f0z','Woman','qe744iep40qukvy','POP','6Uj1ctrBOjOas8xZXGqKk4','https://p.scdn.co/mp3-preview/2ae0b61e45d9a5d6454a3e5ab75f8628dd89aa85?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('imeqezwxnvhg1baivflywgsglclp1zqv26o7uit3ulyp2j4ca6', 'kxrfal4jzq0qji4oeegf0u1vzxt9nidz12g1x0x5hselfu2f0z', '0');
-- Quevedo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1uk23f4y4nf0106', 'Quevedo', '222@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2394e996716534bc2c937a1a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:222@artist.com', '1uk23f4y4nf0106', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1uk23f4y4nf0106', 'Merging lyrical depth with compelling urban beats.', 'Quevedo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vmam1ef11vbixkfxwkc4onabnny1h3l7bxjyszs3phq1booqg2','1uk23f4y4nf0106', 'https://i.scdn.co/image/ab67616d0000b273a00a817b017c6f6bf8460be9', 'Quevedo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yjci91r9buk8ibgezze5wpdwfecaw850y0s70rwv3cautc3v04','Columbia','1uk23f4y4nf0106','POP','6XbtvPmIpyCbjuT0e8cQtp','https://p.scdn.co/mp3-preview/e3d6df66fe67f618166a2cab858580ac8a96486a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vmam1ef11vbixkfxwkc4onabnny1h3l7bxjyszs3phq1booqg2', 'yjci91r9buk8ibgezze5wpdwfecaw850y0s70rwv3cautc3v04', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('69nzh2c3xads44922wcgc8o00ee2i80rd45jw5lcsxsogz8xii','Punto G','1uk23f4y4nf0106','POP','4WiQA1AGWHFvaxBU6bHghs','https://p.scdn.co/mp3-preview/a1275d1dcfb4c25bc48821b19b81ff853386c148?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vmam1ef11vbixkfxwkc4onabnny1h3l7bxjyszs3phq1booqg2', '69nzh2c3xads44922wcgc8o00ee2i80rd45jw5lcsxsogz8xii', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ph372qadjfywjeg751j66c0b93suktmudm11m27hw182uronl4','Mami Chula','1uk23f4y4nf0106','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vmam1ef11vbixkfxwkc4onabnny1h3l7bxjyszs3phq1booqg2', 'ph372qadjfywjeg751j66c0b93suktmudm11m27hw182uronl4', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('90xpwctkjujdfv2t924fxjemh1x7y472ygrzm1jhpgwsh3mrwt','WANDA','1uk23f4y4nf0106','POP','0Iozrbed8spxoBnmtBMshO','https://p.scdn.co/mp3-preview/a6de4c6031032d886d67e88ec6db1a1c521ed023?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vmam1ef11vbixkfxwkc4onabnny1h3l7bxjyszs3phq1booqg2', '90xpwctkjujdfv2t924fxjemh1x7y472ygrzm1jhpgwsh3mrwt', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fougq1lkklfkiv3550bhe5dt6q1356rl4dlj52trg0x27hcz9p','Vista Al Mar','1uk23f4y4nf0106','POP','5q86iSKkBtOoNkdgEDY5WV','https://p.scdn.co/mp3-preview/6896535fbb6690492102bdb7ca181f33de63ef4e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vmam1ef11vbixkfxwkc4onabnny1h3l7bxjyszs3phq1booqg2', 'fougq1lkklfkiv3550bhe5dt6q1356rl4dlj52trg0x27hcz9p', '4');
-- Keane
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w41thzz9546ygtd', 'Keane', '223@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41222a45dc0b10f65cbe8160','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:223@artist.com', 'w41thzz9546ygtd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w41thzz9546ygtd', 'Sculpting soundwaves into masterpieces of auditory art.', 'Keane');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rr7mzgkyg9aio3vdxmp770i3yeewexpfn5ckz9zsoie95xzinx','w41thzz9546ygtd', 'https://i.scdn.co/image/ab67616d0000b273045d0a38105fbe7bde43c490', 'Keane Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vm66lok7j59yr0unr9mg26ph5ovoz30hlqkatb5wzcubzxufg1','Somewhere Only We Know','w41thzz9546ygtd','POP','0ll8uFnc0nANY35E0Lfxvg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rr7mzgkyg9aio3vdxmp770i3yeewexpfn5ckz9zsoie95xzinx', 'vm66lok7j59yr0unr9mg26ph5ovoz30hlqkatb5wzcubzxufg1', '0');
-- The Neighbourhood
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qn1rv6am74tycre', 'The Neighbourhood', '224@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf0b5ac84376a0a4b2166816','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:224@artist.com', 'qn1rv6am74tycre', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qn1rv6am74tycre', 'Melding alternative rock with introspective lyrics.', 'The Neighbourhood');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wp0sq73cnxq437uykjv7g0s832f9fqfmqp6u8cgvtllf39g5lj','qn1rv6am74tycre', 'https://i.scdn.co/image/ab67616d0000b2738265a736a1eb838ad5a0b921', 'The Neighbourhood Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i1gqe7yp4ebwnqq2l5kv29s4hum5dz9bekb7nzrld3s95ashcm','Sweater Weather','qn1rv6am74tycre','POP','2QjOHCTQ1Jl3zawyYOpxh6','https://p.scdn.co/mp3-preview/877602f424a9dea277b13301ffc516f9fd1fbe7e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wp0sq73cnxq437uykjv7g0s832f9fqfmqp6u8cgvtllf39g5lj', 'i1gqe7yp4ebwnqq2l5kv29s4hum5dz9bekb7nzrld3s95ashcm', '0');
-- Freddie Dredd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ppvfun7y4sr7p08', 'Freddie Dredd', '225@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9d100e5a9cf34beab8e75750','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:225@artist.com', 'ppvfun7y4sr7p08', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ppvfun7y4sr7p08', 'A visionary in the world of music, redefining genres.', 'Freddie Dredd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('v5f0hrtoojpwpvu3c69b6gwl51u6v5xzkjzw64mw8bk1hutpxa','ppvfun7y4sr7p08', 'https://i.scdn.co/image/ab67616d0000b27369b381d574b329409bd806e6', 'Freddie Dredd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wf201e0p2g6scnvw2hkw0gl1ouwho1kxzidreakg4q5m24rysp','Limbo','ppvfun7y4sr7p08','POP','37F7E7BKEw2E4O2L7u0IEp','https://p.scdn.co/mp3-preview/1715e2acb52d6fdd0e4b11ea8792688c12987ff7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v5f0hrtoojpwpvu3c69b6gwl51u6v5xzkjzw64mw8bk1hutpxa', 'wf201e0p2g6scnvw2hkw0gl1ouwho1kxzidreakg4q5m24rysp', '0');
-- Nile Rodgers
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wwk9mc90g06im3z', 'Nile Rodgers', '226@artist.com', 'https://i.scdn.co/image/6511b1fe261da3b6c6b69ae2aa771cfd307a18ae','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:226@artist.com', 'wwk9mc90g06im3z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wwk9mc90g06im3z', 'A harmonious blend of passion and creativity.', 'Nile Rodgers');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3fck6yuccke0ocuva3s6pyowmiyfthe2skuxp5fz3xfj30cm9l','wwk9mc90g06im3z', NULL, 'Nile Rodgers Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fauwqlp5yzkqc2xmvng1lkaxc45o2crre92cx6pyhwww5q5t8e','UNFORGIVEN (feat. Nile Rodgers)','wwk9mc90g06im3z','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3fck6yuccke0ocuva3s6pyowmiyfthe2skuxp5fz3xfj30cm9l', 'fauwqlp5yzkqc2xmvng1lkaxc45o2crre92cx6pyhwww5q5t8e', '0');
-- Bomba Estreo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('92b2eceobjlilor', 'Bomba Estreo', '227@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcc4d7c642f167846d8aa743b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:227@artist.com', '92b2eceobjlilor', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('92b2eceobjlilor', 'Pushing the boundaries of sound with each note.', 'Bomba Estreo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('23w1patlbgr21fm6mjzb1zluyyhstow09v5o8vkepv824ut6eb','92b2eceobjlilor', NULL, 'Bomba Estreo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('970e7gl8vwljgmt47ntdmp26bnuo050zv4t5p84qg2ijz2r5ky','Ojitos Lindos','92b2eceobjlilor','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('23w1patlbgr21fm6mjzb1zluyyhstow09v5o8vkepv824ut6eb', '970e7gl8vwljgmt47ntdmp26bnuo050zv4t5p84qg2ijz2r5ky', '0');
-- Brray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jkeey4n395pd4kr', 'Brray', '228@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2c7fe2c8895d2cd41e25aed6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:228@artist.com', 'jkeey4n395pd4kr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jkeey4n395pd4kr', 'Delivering soul-stirring tunes that linger in the mind.', 'Brray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wcjnlh73gdcjbb4gjmqymo4m8bic8m3m8brq0za0bqxah71p08','jkeey4n395pd4kr', NULL, 'Brray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dvfn9xuommbgo5yk5k7ywsjklss6wh94tverlo874x4xpz49lv','LOKERA','jkeey4n395pd4kr','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wcjnlh73gdcjbb4gjmqymo4m8bic8m3m8brq0za0bqxah71p08', 'dvfn9xuommbgo5yk5k7ywsjklss6wh94tverlo874x4xpz49lv', '0');
-- BLACKPINK
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ej5r80fvuuzom4r', 'BLACKPINK', '229@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc9690bc711d04b3d4fd4b87c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:229@artist.com', 'ej5r80fvuuzom4r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ej5r80fvuuzom4r', 'Sculpting soundwaves into masterpieces of auditory art.', 'BLACKPINK');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7p6phnabo1dwlrvp1x30b2du2kw4uwbexthm60kh1d31vmks7m','ej5r80fvuuzom4r', 'https://i.scdn.co/image/ab67616d0000b273002ef53878df1b4e91c15406', 'BLACKPINK Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t88idrer9gnnppted1l8qimnxg4xxtnxn4g9858xmzu2i1nyy1','Shut Down','ej5r80fvuuzom4r','POP','7gRFDGEzF9UkBV233yv2dc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7p6phnabo1dwlrvp1x30b2du2kw4uwbexthm60kh1d31vmks7m', 't88idrer9gnnppted1l8qimnxg4xxtnxn4g9858xmzu2i1nyy1', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5zw45vzmptxr598cclrawgr1znpqkg9cgyq2ijbom8hbpisuea','Pink Venom','ej5r80fvuuzom4r','POP','5zwwW9Oq7ubSxoCGyW1nbY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7p6phnabo1dwlrvp1x30b2du2kw4uwbexthm60kh1d31vmks7m', '5zw45vzmptxr598cclrawgr1znpqkg9cgyq2ijbom8hbpisuea', '1');
-- King
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0r8q2frzae412wl', 'King', '230@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5c0b2129a88c7d6ed0704556','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:230@artist.com', '0r8q2frzae412wl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0r8q2frzae412wl', 'A unique voice in the contemporary music scene.', 'King');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5vdc6cqx9untanz7itpn2d16wsxgvonyabj97swutuv9npjk0b','0r8q2frzae412wl', 'https://i.scdn.co/image/ab67616d0000b27337f65266754703fd20d29854', 'King Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6h5al4v0p1i3bpljp33ekn1alfpvcn24pxzvdcu3zbdzpakjqj','Maan Meri Jaan','0r8q2frzae412wl','POP','1418IuVKQPTYqt7QNJ9RXN','https://p.scdn.co/mp3-preview/cf886ec5f6a46c234bcfdd043ab5db03db0015b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5vdc6cqx9untanz7itpn2d16wsxgvonyabj97swutuv9npjk0b', '6h5al4v0p1i3bpljp33ekn1alfpvcn24pxzvdcu3zbdzpakjqj', '0');
-- Bruno Mars
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zkhjym7kbolq4z6', 'Bruno Mars', '231@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc36dd9eb55fb0db4911f25dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:231@artist.com', 'zkhjym7kbolq4z6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zkhjym7kbolq4z6', 'A voice that echoes the sentiments of a generation.', 'Bruno Mars');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wmhk1d620v75a1eehndgjf115lcagxrg1b4dhrc3a1st1s62xf','zkhjym7kbolq4z6', 'https://i.scdn.co/image/ab67616d0000b273926f43e7cce571e62720fd46', 'Bruno Mars Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hrq1dcao9dw882rsjqi1axnq6lmyui8nof43dmr9czlol7a1qa','Locked Out Of Heaven','zkhjym7kbolq4z6','POP','3w3y8KPTfNeOKPiqUTakBh','https://p.scdn.co/mp3-preview/5a0318e6c43964786d22b9431af35490e96cff3d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wmhk1d620v75a1eehndgjf115lcagxrg1b4dhrc3a1st1s62xf', 'hrq1dcao9dw882rsjqi1axnq6lmyui8nof43dmr9czlol7a1qa', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wqzneak21oy5t1z8u2ccqapv7wqb5kp82y4irw0f7wgfy2xmwd','When I Was Your Man','zkhjym7kbolq4z6','POP','0nJW01T7XtvILxQgC5J7Wh','https://p.scdn.co/mp3-preview/159fc05584217baa99581c4821f52d04670db6b2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wmhk1d620v75a1eehndgjf115lcagxrg1b4dhrc3a1st1s62xf', 'wqzneak21oy5t1z8u2ccqapv7wqb5kp82y4irw0f7wgfy2xmwd', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('efbdr35yc0fute664i1br96mvt8psoom53hs3qo6dsro91zuq4','Just The Way You Are','zkhjym7kbolq4z6','POP','7BqBn9nzAq8spo5e7cZ0dJ','https://p.scdn.co/mp3-preview/6d1a901b10c7dc609d4c8628006b04bc6e672be8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wmhk1d620v75a1eehndgjf115lcagxrg1b4dhrc3a1st1s62xf', 'efbdr35yc0fute664i1br96mvt8psoom53hs3qo6dsro91zuq4', '2');
-- Mahalini
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8z6w07kx2mu868h', 'Mahalini', '232@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb8333468abeb2e461d1ab5ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:232@artist.com', '8z6w07kx2mu868h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8z6w07kx2mu868h', 'A confluence of cultural beats and contemporary tunes.', 'Mahalini');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9allu117xpj09uxo9nk6nciqtcydejzl4i4t8wx6j34sqlmtyz','8z6w07kx2mu868h', 'https://i.scdn.co/image/ab67616d0000b2736f713eb92ebf7ca05a562542', 'Mahalini Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pz40uo0w02hc8zpsydaraqvqqdazjnbbx94o4yry7grfrecwv7','Sial','8z6w07kx2mu868h','POP','6O0WEM0QNEhqpU50BKui7o','https://p.scdn.co/mp3-preview/1285e7f97156037b5c1c958513ff3f8176a68a33?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9allu117xpj09uxo9nk6nciqtcydejzl4i4t8wx6j34sqlmtyz', 'pz40uo0w02hc8zpsydaraqvqqdazjnbbx94o4yry7grfrecwv7', '0');
-- Ana Castela
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k76tniiu2gizo1j', 'Ana Castela', '233@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26abde7ba3cfdfb8c1900baf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:233@artist.com', 'k76tniiu2gizo1j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k76tniiu2gizo1j', 'Delivering soul-stirring tunes that linger in the mind.', 'Ana Castela');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sqb1rxz3k15vvh3ci8qn1p9anqnzzfirk0flhaec4ylkfcl0so','k76tniiu2gizo1j', NULL, 'Ana Castela Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4guzneos5oeva55rb2ywbp6x2ox6uia5vko1goghtmwuuncae8','Nosso Quadro','k76tniiu2gizo1j','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sqb1rxz3k15vvh3ci8qn1p9anqnzzfirk0flhaec4ylkfcl0so', '4guzneos5oeva55rb2ywbp6x2ox6uia5vko1goghtmwuuncae8', '0');
-- Lil Uzi Vert
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5tg8p7i8u3qla9r', 'Lil Uzi Vert', '234@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1234d2f516796badbdf16a89','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:234@artist.com', '5tg8p7i8u3qla9r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5tg8p7i8u3qla9r', 'The architect of aural landscapes that inspire and captivate.', 'Lil Uzi Vert');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2i6av0jladb3v63nbipfa1vopzvhhghlqyikwyv8dbacmbgwzw','5tg8p7i8u3qla9r', 'https://i.scdn.co/image/ab67616d0000b273438799bc344744c12028bb0f', 'Lil Uzi Vert Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oyl3qokmb95q6y484wyrb43ea7jk2o7uanw70iqp4sjhwl9kf3','Just Wanna Rock','5tg8p7i8u3qla9r','POP','4FyesJzVpA39hbYvcseO2d','https://p.scdn.co/mp3-preview/72dce26448e87be36c3776ded36b75a9fd01359e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2i6av0jladb3v63nbipfa1vopzvhhghlqyikwyv8dbacmbgwzw', 'oyl3qokmb95q6y484wyrb43ea7jk2o7uanw70iqp4sjhwl9kf3', '0');
-- A$AP Rocky
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('n5e9brkpl4ijm09', 'A$AP Rocky', '235@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:235@artist.com', 'n5e9brkpl4ijm09', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('n5e9brkpl4ijm09', 'A voice that echoes the sentiments of a generation.', 'A$AP Rocky');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x4tdpzhbsvijdq1qdobpu9z8midiohyshhic5p8qc2mstfbgge','n5e9brkpl4ijm09', NULL, 'A$AP Rocky Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5pdhu68gkitiqfm40mrjg4320crl5jzggdd7qnz3zpn8jmlvq8','Am I Dreaming (Metro Boomin & A$AP Rocky, Roisee)','n5e9brkpl4ijm09','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x4tdpzhbsvijdq1qdobpu9z8midiohyshhic5p8qc2mstfbgge', '5pdhu68gkitiqfm40mrjg4320crl5jzggdd7qnz3zpn8jmlvq8', '0');
-- Metro Boomin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('75o4in7ypc59tho', 'Metro Boomin', '236@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:236@artist.com', '75o4in7ypc59tho', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('75o4in7ypc59tho', 'Igniting the stage with electrifying performances.', 'Metro Boomin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9nciyh9oshws27fjabiwxxm51q4x7ggilhqtyxd2na8wf97cdi','75o4in7ypc59tho', 'https://i.scdn.co/image/ab67616d0000b2736ed9aef791159496b286179f', 'Metro Boomin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('th9umajtrbrb8mpnpy2qbru7l75w0pt18gbpbrw8q0obzvjnkj','Self Love (Spider-Man: Across the Spider-Verse) (Metro Boomin & Coi Leray)','75o4in7ypc59tho','POP','0AAMnNeIc6CdnfNU85GwCH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9nciyh9oshws27fjabiwxxm51q4x7ggilhqtyxd2na8wf97cdi', 'th9umajtrbrb8mpnpy2qbru7l75w0pt18gbpbrw8q0obzvjnkj', '0');
-- Feid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7hsuxnxkarwlcmp', 'Feid', '237@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0a248d29f8faa91f971e5cae','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:237@artist.com', '7hsuxnxkarwlcmp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7hsuxnxkarwlcmp', 'A standout artist in urban Latin music, known for his catchy melodies and smooth vocals.', 'Feid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0oran74osb5ou24ee80wibq7k960ywjea7sxge4s1t80y394x2','7hsuxnxkarwlcmp', 'https://i.scdn.co/image/ab67616d0000b27329ebee2b5fb008871fcd201a', 'Feid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f0jarl4m72zni5kcyfd6xlxo3kz1occas0fxvfv2asd4x6tzbv','Classy 101','7hsuxnxkarwlcmp','POP','6XSqqQIy7Lm7SnwxS4NrGx',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0oran74osb5ou24ee80wibq7k960ywjea7sxge4s1t80y394x2', 'f0jarl4m72zni5kcyfd6xlxo3kz1occas0fxvfv2asd4x6tzbv', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v6phd83ki2necvrbzqs5o5x1xf9zn04nvsnn0t7vps6tttd505','El Cielo','7hsuxnxkarwlcmp','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0oran74osb5ou24ee80wibq7k960ywjea7sxge4s1t80y394x2', 'v6phd83ki2necvrbzqs5o5x1xf9zn04nvsnn0t7vps6tttd505', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7d4eeymgthhxbw5s973v8v9chv5iq8j8rmb8q8m2ilak4om7kv','Feliz Cumpleaos Fe','7hsuxnxkarwlcmp','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0oran74osb5ou24ee80wibq7k960ywjea7sxge4s1t80y394x2', '7d4eeymgthhxbw5s973v8v9chv5iq8j8rmb8q8m2ilak4om7kv', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cbvcwcdvvsetng1bbm6cz317auqpw9eqwes94ju59u52eiwwm9','POLARIS - Remix','7hsuxnxkarwlcmp','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0oran74osb5ou24ee80wibq7k960ywjea7sxge4s1t80y394x2', 'cbvcwcdvvsetng1bbm6cz317auqpw9eqwes94ju59u52eiwwm9', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x2t4fvaa4gr0cu1hwi3aqifu55n7a69opaspmztvkkkwmicpzg','CHORRITO PA LAS ANIMAS','7hsuxnxkarwlcmp','POP','0CYTGMBYkwUxrj1MWDLrC5',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0oran74osb5ou24ee80wibq7k960ywjea7sxge4s1t80y394x2', 'x2t4fvaa4gr0cu1hwi3aqifu55n7a69opaspmztvkkkwmicpzg', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hr13bd27p0zu2l5xsvcmqba69bd4xy5wmo8wmcggopmdkljb8y','Normal','7hsuxnxkarwlcmp','POP','0T2pB7P1VdXPhLdQZ488uH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0oran74osb5ou24ee80wibq7k960ywjea7sxge4s1t80y394x2', 'hr13bd27p0zu2l5xsvcmqba69bd4xy5wmo8wmcggopmdkljb8y', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dnibu9q4p9tdpfhn5pvkk6732yyoy4ni61o6znuyr8o216x7vb','REMIX EXCLUSIVO','7hsuxnxkarwlcmp','POP','3eqCJfgJJs8iKx49KO12s3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0oran74osb5ou24ee80wibq7k960ywjea7sxge4s1t80y394x2', 'dnibu9q4p9tdpfhn5pvkk6732yyoy4ni61o6znuyr8o216x7vb', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gsma76o1dkvn4a8nx4tlw49up0bcyeretm6c9rns1yqaywlk4p','LA INOCENTE','7hsuxnxkarwlcmp','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0oran74osb5ou24ee80wibq7k960ywjea7sxge4s1t80y394x2', 'gsma76o1dkvn4a8nx4tlw49up0bcyeretm6c9rns1yqaywlk4p', '7');
-- Rich The Kid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mhwjjy8khxheirl', 'Rich The Kid', '238@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb10379ac1a13fa06e703bf421','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:238@artist.com', 'mhwjjy8khxheirl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mhwjjy8khxheirl', 'Blending genres for a fresh musical experience.', 'Rich The Kid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nydh61l5u969e90m9t4wng5q4dgof6ewmh670ccr1lxz1sfzl0','mhwjjy8khxheirl', NULL, 'Rich The Kid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fwa9ta4ls2q7vach3ps6sdyuubzj2f1c99y796athsivlyxhr7','Conexes de Mfia (feat. Rich ','mhwjjy8khxheirl','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nydh61l5u969e90m9t4wng5q4dgof6ewmh670ccr1lxz1sfzl0', 'fwa9ta4ls2q7vach3ps6sdyuubzj2f1c99y796athsivlyxhr7', '0');
-- Yuridia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('202xp2s3jomyfhg', 'Yuridia', '239@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb238b537cb702308e59f709bf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:239@artist.com', '202xp2s3jomyfhg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('202xp2s3jomyfhg', 'Transcending language barriers through the universal language of music.', 'Yuridia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kjbkli9ao4pc14ix4g1d8cc40leabq6bqp5u1nl0qjowkur9zs','202xp2s3jomyfhg', 'https://i.scdn.co/image/ab67616d0000b2732e9425d8413217cc2942cacf', 'Yuridia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ohfz8zgp56q6jcgyrkp52yhaecz33tcjrg6fuvyojihtse3fav','Qu Ago','202xp2s3jomyfhg','POP','4H6o1bxKRGzmsE0vzo968m','https://p.scdn.co/mp3-preview/5576fde4795672bfa292bbf58adf0f9159af0be3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kjbkli9ao4pc14ix4g1d8cc40leabq6bqp5u1nl0qjowkur9zs', 'ohfz8zgp56q6jcgyrkp52yhaecz33tcjrg6fuvyojihtse3fav', '0');
-- TOMORROW X TOGETHER
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ix38e1165uq7zbz', 'TOMORROW X TOGETHER', '240@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8b446e5bd3820ac772155b31','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:240@artist.com', 'ix38e1165uq7zbz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ix38e1165uq7zbz', 'Creating a tapestry of tunes that celebrates diversity.', 'TOMORROW X TOGETHER');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ok903qzr0ppdk74g9cdmgwtyjy5vlj8rwyd7i1ywsvp8kpkaq0','ix38e1165uq7zbz', 'https://i.scdn.co/image/ab67616d0000b2733bb056e3160b85ee86c1194d', 'TOMORROW X TOGETHER Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4r7o2ls7vgwcj62cdzdb8o2t7c5sy4v2e8wuk39omrlboox1q4','Sugar Rush Ride','ix38e1165uq7zbz','POP','0rhI6gvOeCKA502RdJAbfs','https://p.scdn.co/mp3-preview/691f502777012a09541b5265cfddaa4401470759?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ok903qzr0ppdk74g9cdmgwtyjy5vlj8rwyd7i1ywsvp8kpkaq0', '4r7o2ls7vgwcj62cdzdb8o2t7c5sy4v2e8wuk39omrlboox1q4', '0');
-- Z Neto & Crist
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w0lpqb5qcadyx1k', 'Z Neto & Crist', '241@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1bb9201db3ff149830f0139a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:241@artist.com', 'w0lpqb5qcadyx1k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w0lpqb5qcadyx1k', 'Redefining what it means to be an artist in the digital age.', 'Z Neto & Crist');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xigr20kmkhvgfdrlui3chxjkc49p714nkyjl3bf50xu7tferal','w0lpqb5qcadyx1k', 'https://i.scdn.co/image/ab67616d0000b27339833b5940945cf013e8406c', 'Z Neto & Crist Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7xktczffygthbpx9l2hxpvm2q24rh9s6wss5rb9q45fsei5izj','Oi Balde - Ao Vivo','w0lpqb5qcadyx1k','POP','4xAGuRRKOgoaZbMGdmTD3N','https://p.scdn.co/mp3-preview/a6318531e5f8243a9d1df067570b50210b2729cc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xigr20kmkhvgfdrlui3chxjkc49p714nkyjl3bf50xu7tferal', '7xktczffygthbpx9l2hxpvm2q24rh9s6wss5rb9q45fsei5izj', '0');
-- Steve Aoki
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h44fx05p0amm86x', 'Steve Aoki', '242@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:242@artist.com', 'h44fx05p0amm86x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h44fx05p0amm86x', 'Pushing the boundaries of sound with each note.', 'Steve Aoki');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('405z0xooitepzjlet7yrhjacfkov4d08y1doiuup4g2iij9s73','h44fx05p0amm86x', NULL, 'Steve Aoki Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('eompfbyiot7ioyrlv535he4j1ff0upgrahjht00hs62vz7mtjb','Mu','h44fx05p0amm86x','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('405z0xooitepzjlet7yrhjacfkov4d08y1doiuup4g2iij9s73', 'eompfbyiot7ioyrlv535he4j1ff0upgrahjht00hs62vz7mtjb', '0');
-- Eslabon Armado
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u02clovi95llndk', 'Eslabon Armado', '243@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5ccab5d3dc10a08d89cbd76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:243@artist.com', 'u02clovi95llndk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u02clovi95llndk', 'Bringing a fresh take to traditional music, weaving in modern influences.', 'Eslabon Armado');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i4sia8thuvyzxth70tnh23f8faiz15gh1fyeo873uyrlooih88','u02clovi95llndk', 'https://i.scdn.co/image/ab67616d0000b2732071a0c79802d9375a53bfef', 'Eslabon Armado Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q8g5q4jtlckcpwf6r2jiyodtixxb8d2ik9m2f7yjw0voak8twp','Ella Baila Sola','u02clovi95llndk','POP','3dnP0JxCgygwQH9Gm7q7nb','https://p.scdn.co/mp3-preview/5d39f3e17f1e20e2711d033001e48b8d4249b992?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i4sia8thuvyzxth70tnh23f8faiz15gh1fyeo873uyrlooih88', 'q8g5q4jtlckcpwf6r2jiyodtixxb8d2ik9m2f7yjw0voak8twp', '0');
-- Imagine Dragons
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mt53cjizifu5mmz', 'Imagine Dragons', '244@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb920dc1f617550de8388f368e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:244@artist.com', 'mt53cjizifu5mmz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mt53cjizifu5mmz', 'An alchemist of harmonies, transforming notes into gold.', 'Imagine Dragons');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('w0cuwmvyxpghtcaspmjic61zadnstjfndx1fgw184fpteswuit','mt53cjizifu5mmz', 'https://i.scdn.co/image/ab67616d0000b273fc915b69600dce2991a61f13', 'Imagine Dragons Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c3ltl6qh5h2k76rqrdpq14j4tg7swvpqhl74bzoo17dzuwuhu8','Bones','mt53cjizifu5mmz','POP','54ipXppHLA8U4yqpOFTUhr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w0cuwmvyxpghtcaspmjic61zadnstjfndx1fgw184fpteswuit', 'c3ltl6qh5h2k76rqrdpq14j4tg7swvpqhl74bzoo17dzuwuhu8', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3amzh014tiik49a41ohsxmv6w5cpg4oaok6hofr2zc7w8dma4o','Believer','mt53cjizifu5mmz','POP','0pqnGHJpmpxLKifKRmU6WP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w0cuwmvyxpghtcaspmjic61zadnstjfndx1fgw184fpteswuit', '3amzh014tiik49a41ohsxmv6w5cpg4oaok6hofr2zc7w8dma4o', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0zpjfjbts4u5fj9r41jb4zpjkpo9gvqocicu2uyy14l5yfy1u9','Demons','mt53cjizifu5mmz','POP','3LlAyCYU26dvFZBDUIMb7a',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w0cuwmvyxpghtcaspmjic61zadnstjfndx1fgw184fpteswuit', '0zpjfjbts4u5fj9r41jb4zpjkpo9gvqocicu2uyy14l5yfy1u9', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0o95ru4pcsxxxnq1171cxlwffse84btsro6px7rsw3yasnzmig','Enemy (with JID) - from the series Arcane League of Legends','mt53cjizifu5mmz','POP','3CIyK1V4JEJkg02E4EJnDl',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w0cuwmvyxpghtcaspmjic61zadnstjfndx1fgw184fpteswuit', '0o95ru4pcsxxxnq1171cxlwffse84btsro6px7rsw3yasnzmig', '3');
-- R
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1juc00k4v2udadn', 'R', '245@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6334ab6a83196f36475ada7f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:245@artist.com', '1juc00k4v2udadn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1juc00k4v2udadn', 'Pushing the boundaries of sound with each note.', 'R');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ah97bsljzywfghtulivs0wxcbvpltyy3illcfwyfla9lk8x5sd','1juc00k4v2udadn', 'https://i.scdn.co/image/ab67616d0000b273a3a7f38ea2033aa501afd4cf', 'R Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ylx7yrku3a8chw3ar6k0a9r48qsome7a50t9vq4oxwxm4dxva5','Calm Down','1juc00k4v2udadn','POP','0WtM2NBVQNNJLh6scP13H8',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ah97bsljzywfghtulivs0wxcbvpltyy3illcfwyfla9lk8x5sd', 'ylx7yrku3a8chw3ar6k0a9r48qsome7a50t9vq4oxwxm4dxva5', '0');
-- ThxSoMch
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cg07n9nkin53no2', 'ThxSoMch', '246@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcce84671d294b0cefb8fe1c0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:246@artist.com', 'cg07n9nkin53no2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cg07n9nkin53no2', 'A beacon of innovation in the world of sound.', 'ThxSoMch');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('v8m0g1vnk4cb84t83e6ji8063aq3kvbfkcirh36jzc4p0x2ce5','cg07n9nkin53no2', 'https://i.scdn.co/image/ab67616d0000b27360ddc59c8d590a37cf2348f3', 'ThxSoMch Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gw6ewk9m1p7gvhg83f527hy4nxaks1stxjz2r98zmkuaevwhj3','SPIT IN MY FACE!','cg07n9nkin53no2','POP','1N8TTK1Uoy7UvQNUazfUt5','https://p.scdn.co/mp3-preview/a4146e5dd430d70eda83e57506ba5ed402935200?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v8m0g1vnk4cb84t83e6ji8063aq3kvbfkcirh36jzc4p0x2ce5', 'gw6ewk9m1p7gvhg83f527hy4nxaks1stxjz2r98zmkuaevwhj3', '0');
-- Bellakath
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('alipzgr1nx971g2', 'Bellakath', '247@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb008a12ca09c3acec7c536d53','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:247@artist.com', 'alipzgr1nx971g2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('alipzgr1nx971g2', 'Transcending language barriers through the universal language of music.', 'Bellakath');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j6hrzi2d482spyuee02in4iv3gosmj4clqdftjgrarbau6tf4m','alipzgr1nx971g2', 'https://i.scdn.co/image/ab67616d0000b273584e78471da03acbc05dde0b', 'Bellakath Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2qujvt447nfe5hfct1r6i9xtsf17gdl46yrv3yhamnjvg42lqa','Gatita','alipzgr1nx971g2','POP','4ilZV1WNjL7IxwE81OnaRY','https://p.scdn.co/mp3-preview/ed363508374055584f0a42a003473c065fbe4f61?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j6hrzi2d482spyuee02in4iv3gosmj4clqdftjgrarbau6tf4m', '2qujvt447nfe5hfct1r6i9xtsf17gdl46yrv3yhamnjvg42lqa', '0');
-- Myke Towers
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('chrz0m1b2m39zhq', 'Myke Towers', '248@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9e35c3c5de877f99a8f6192f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:248@artist.com', 'chrz0m1b2m39zhq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('chrz0m1b2m39zhq', 'A rising star in Latin music, known for his distinctive flow.', 'Myke Towers');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('167gb1p5yai7trg26v7vr9fw8o1nfa2ogna2yrq85t1ok7z1wr','chrz0m1b2m39zhq', 'https://i.scdn.co/image/ab67616d0000b2730656d5ce813ca3cc4b677e05', 'Myke Towers Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ulau7wcn0nx704p409oklxwe5h6ibm3yeq58q31wbhu5qja88q','LALA','chrz0m1b2m39zhq','POP','7ABLbnD53cQK00mhcaOUVG','https://p.scdn.co/mp3-preview/42772b16b4e575d1b15b0ec7f94e335539390d2d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('167gb1p5yai7trg26v7vr9fw8o1nfa2ogna2yrq85t1ok7z1wr', 'ulau7wcn0nx704p409oklxwe5h6ibm3yeq58q31wbhu5qja88q', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j3r55wojjh2n2yba4s1jt5nsw9tplidziiwl2bwbu10ghjs0q7','PLAYA DEL INGL','chrz0m1b2m39zhq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('167gb1p5yai7trg26v7vr9fw8o1nfa2ogna2yrq85t1ok7z1wr', 'j3r55wojjh2n2yba4s1jt5nsw9tplidziiwl2bwbu10ghjs0q7', '1');
-- Rosa Linn
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pjaqa3f07shv6ut', 'Rosa Linn', '249@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5fe9684ed75d00000b63791','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:249@artist.com', 'pjaqa3f07shv6ut', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pjaqa3f07shv6ut', 'Harnessing the power of melody to tell compelling stories.', 'Rosa Linn');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('taei0e76fgcdi3jozixei0aowjybgbqkq8ykdbbnr43opjlz9m','pjaqa3f07shv6ut', 'https://i.scdn.co/image/ab67616d0000b2731391b1fdb63da53e5b112224', 'Rosa Linn Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nd36mdcgl7nliksmwmzkv3qiezg2uqye7q7cqiiorglhvklbg0','SNAP','pjaqa3f07shv6ut','POP','76OGwb5RA9h4FxQPT33ekc','https://p.scdn.co/mp3-preview/0a41500662a6b6223dcb026b20ef1437985574b8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('taei0e76fgcdi3jozixei0aowjybgbqkq8ykdbbnr43opjlz9m', 'nd36mdcgl7nliksmwmzkv3qiezg2uqye7q7cqiiorglhvklbg0', '0');
-- Vishal-Shekhar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3wm45mhostrgkvn', 'Vishal-Shekhar', '250@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb90b6c3d093f9b02aad628eaf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:250@artist.com', '3wm45mhostrgkvn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3wm45mhostrgkvn', 'Crafting soundscapes that transport listeners to another world.', 'Vishal-Shekhar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o6hul5sztb59hk3lj4skhxhq5rusps7klgc97vffrso6qn72j6','3wm45mhostrgkvn', NULL, 'Vishal-Shekhar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i252ogpp5bsk7kq2v8m4pzuue8kxi8y9bzp4ec7rsf0r5ceerl','Besharam Rang (From "Pathaan")','3wm45mhostrgkvn','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o6hul5sztb59hk3lj4skhxhq5rusps7klgc97vffrso6qn72j6', 'i252ogpp5bsk7kq2v8m4pzuue8kxi8y9bzp4ec7rsf0r5ceerl', '0');
-- PinkPantheress
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z34dpnqfc7uca1n', 'PinkPantheress', '251@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03578c92e15089c645b794f5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:251@artist.com', 'z34dpnqfc7uca1n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z34dpnqfc7uca1n', 'Redefining pop music with her distinct sound and style.', 'PinkPantheress');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('q09m7x8gxv62k07p2u74cc49joiggfm4zsgnd2lq0949bkshxi','z34dpnqfc7uca1n', 'https://i.scdn.co/image/ab67616d0000b2739567e1aa41657425d046733b', 'PinkPantheress Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('djdjtulu485zqd4c7fvc9gvqv1jzl47dfkdm8gqatqtx44cqc2','Boys a liar Pt. 2','z34dpnqfc7uca1n','POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q09m7x8gxv62k07p2u74cc49joiggfm4zsgnd2lq0949bkshxi', 'djdjtulu485zqd4c7fvc9gvqv1jzl47dfkdm8gqatqtx44cqc2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vuri8fc4jivwnu0zus3ufme01bo621y1pnfgpva1ot28dus5jj','Boys a liar','z34dpnqfc7uca1n','POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q09m7x8gxv62k07p2u74cc49joiggfm4zsgnd2lq0949bkshxi', 'vuri8fc4jivwnu0zus3ufme01bo621y1pnfgpva1ot28dus5jj', '1');
-- Lady Gaga
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ws1x320398y8td4', 'Lady Gaga', '252@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc8d3d98a1bccbe71393dbfbf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:252@artist.com', 'ws1x320398y8td4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ws1x320398y8td4', 'A beacon of innovation in the world of sound.', 'Lady Gaga');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9iij6x3n38ajhvosw9t0r86ag5vwps1wb8w38vt7h6v2fahuye','ws1x320398y8td4', 'https://i.scdn.co/image/ab67616d0000b273a47c0e156ea3cebe37fdcab8', 'Lady Gaga Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ipfpclmy823rqxt4zxe4ma89qquob9cz8eekmatlv9tliubex8','Bloody Mary','ws1x320398y8td4','POP','11BKm0j4eYoCPPpCONAVwA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9iij6x3n38ajhvosw9t0r86ag5vwps1wb8w38vt7h6v2fahuye', 'ipfpclmy823rqxt4zxe4ma89qquob9cz8eekmatlv9tliubex8', '0');
-- Offset
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('32fjnzl3pmfo1gr', 'Offset', '253@artist.com', 'https://i.scdn.co/image/ab67616d0000b2736edd8e309824c6f3fd3f3466','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:253@artist.com', '32fjnzl3pmfo1gr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('32fjnzl3pmfo1gr', 'Where words fail, my music speaks.', 'Offset');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('quxtr04n07e8orenjvz46ee50r06yqzv68ws8tganeyi75uol6','32fjnzl3pmfo1gr', 'https://i.scdn.co/image/ab67616d0000b2736ed9aef791159496b286179f', 'Offset Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lz9gz7c0blxncqpgdp42cl6wm7hmzu4pmb9hm2hwrf2xdwwbh2','Danger (Spider) (Offset & JID)','32fjnzl3pmfo1gr','POP','3X6qK1LdMkSOhklwRa2ZfG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('quxtr04n07e8orenjvz46ee50r06yqzv68ws8tganeyi75uol6', 'lz9gz7c0blxncqpgdp42cl6wm7hmzu4pmb9hm2hwrf2xdwwbh2', '0');
-- Tisto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v0pzf123cb59bf1', 'Tisto', '254@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7afd1dcf8bc34612f16ee39c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:254@artist.com', 'v0pzf123cb59bf1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v0pzf123cb59bf1', 'Revolutionizing the music scene with innovative compositions.', 'Tisto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l3h513wpv5y6xb4buimz9pnv3xl4ov8k0nusvb0s4ggc21293y','v0pzf123cb59bf1', NULL, 'Tisto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u3dfv55ac6rfxnccgvar3y7u7l8rabyl654csk5rpsz76aacb8','10:35','v0pzf123cb59bf1','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l3h513wpv5y6xb4buimz9pnv3xl4ov8k0nusvb0s4ggc21293y', 'u3dfv55ac6rfxnccgvar3y7u7l8rabyl654csk5rpsz76aacb8', '0');
-- Agust D
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qdfocrm592mkgi8', 'Agust D', '255@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb191d43dca6f2f5a126e43e4b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:255@artist.com', 'qdfocrm592mkgi8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qdfocrm592mkgi8', 'Blending traditional rhythms with modern beats.', 'Agust D');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('12khzk9m40np0h54yfl3rk467bags6ipnmpxtmiru0g3uggutk','qdfocrm592mkgi8', 'https://i.scdn.co/image/ab67616d0000b273fa9247b68471b82d2125651e', 'Agust D Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hrixznkb5lro49xcrzdfwn5ylsaqgyqlrkpzy79tzy3tmaoa1g','Haegeum','qdfocrm592mkgi8','POP','4bjN59DRXFRxBE1g5ne6B1','https://p.scdn.co/mp3-preview/3c2f1894de0f6a51f557131c3eb275cb8bc80831?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('12khzk9m40np0h54yfl3rk467bags6ipnmpxtmiru0g3uggutk', 'hrixznkb5lro49xcrzdfwn5ylsaqgyqlrkpzy79tzy3tmaoa1g', '0');
-- Skrillex
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6gtstbqi1b20nqy', 'Skrillex', '256@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb61f92702ca14484aa263a931','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:256@artist.com', '6gtstbqi1b20nqy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6gtstbqi1b20nqy', 'Igniting the stage with electrifying performances.', 'Skrillex');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y7oe9yb9d88lsnzq0qq87a6coldv7nsxuffj6twryio0946zj2','6gtstbqi1b20nqy', 'https://i.scdn.co/image/ab67616d0000b273352f154c54727bc8024629bc', 'Skrillex Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cm5lzazo6lp6x1vd4ch5dyjj00hupvcv8pvhn40029qwn4nu0b','Rumble','6gtstbqi1b20nqy','POP','1GfBLbAhZUWdseuDqhocmn','https://p.scdn.co/mp3-preview/eb79af9f809883de0632f02388ec354478612754?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y7oe9yb9d88lsnzq0qq87a6coldv7nsxuffj6twryio0946zj2', 'cm5lzazo6lp6x1vd4ch5dyjj00hupvcv8pvhn40029qwn4nu0b', '0');
-- Carin Leon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('odcjcj5eowegluj', 'Carin Leon', '257@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb7cc22fee89df015c6ba2636','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:257@artist.com', 'odcjcj5eowegluj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('odcjcj5eowegluj', 'Transcending language barriers through the universal language of music.', 'Carin Leon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('flhjaqj8m1cwi70zdwi4tssvog63u3pih7gmsw9ilb3x7tqgvx','odcjcj5eowegluj', 'https://i.scdn.co/image/ab67616d0000b273dc0bb68a08c069cf8467f1bd', 'Carin Leon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lqettnxt2tv9867d2p1wby1nv3pillfnsenqyxjv6sv6netad1','Primera Cita','odcjcj5eowegluj','POP','4mGrWfDISjNjgeQnH1B8IE','https://p.scdn.co/mp3-preview/7eea768397c9ad0989a55f26f4cffbe6f334874a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('flhjaqj8m1cwi70zdwi4tssvog63u3pih7gmsw9ilb3x7tqgvx', 'lqettnxt2tv9867d2p1wby1nv3pillfnsenqyxjv6sv6netad1', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aqvyonx93i1llb8g3hm62vlcl2je2v38qhfzpk3q9dj3qfputb','Que Vuelvas','odcjcj5eowegluj','POP','6Um358vY92UBv5DloTRX9L','https://p.scdn.co/mp3-preview/19a1e58ae965c24e3ca4d0637857456887e31cd1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('flhjaqj8m1cwi70zdwi4tssvog63u3pih7gmsw9ilb3x7tqgvx', 'aqvyonx93i1llb8g3hm62vlcl2je2v38qhfzpk3q9dj3qfputb', '1');
-- Wisin & Yandel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c86i234mfok5sq7', 'Wisin & Yandel', '258@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5496c4b788e181679069ee8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:258@artist.com', 'c86i234mfok5sq7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c86i234mfok5sq7', 'Elevating the ordinary to extraordinary through music.', 'Wisin & Yandel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ntudb5z0pn70jilaq13qpw7dpebw9qhihsrsjawi9i2uayn8k8','c86i234mfok5sq7', 'https://i.scdn.co/image/ab67616d0000b2739f05bb270f81880fd844aae8', 'Wisin & Yandel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('006h7mdhjodzgupbetuobv3aeebqk1kzpj8lvkss0eccpi18wn','Besos Moja2','c86i234mfok5sq7','POP','6OzUIp8KjuwxJnCWkXp1uL','https://p.scdn.co/mp3-preview/8b17c9ae5706f7f2e41a6ec3470631b3094017b6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ntudb5z0pn70jilaq13qpw7dpebw9qhihsrsjawi9i2uayn8k8', '006h7mdhjodzgupbetuobv3aeebqk1kzpj8lvkss0eccpi18wn', '0');
-- Semicenk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vch6gw2btjei4rj', 'Semicenk', '259@artist.com', 'https://i.scdn.co/image/ab67616d0000b2730b8da935d3ba07f14f01eb32','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:259@artist.com', 'vch6gw2btjei4rj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vch6gw2btjei4rj', 'An endless quest for musical perfection.', 'Semicenk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('iebbbny9j2wbpqbiw1quvk3fwwipwejib9ivs6cppeq0rjfp6v','vch6gw2btjei4rj', NULL, 'Semicenk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l1xc02xhso9wdieyn422wynyqk8y3hc3gqggpywy99s93ozktl','Piman De','vch6gw2btjei4rj','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('iebbbny9j2wbpqbiw1quvk3fwwipwejib9ivs6cppeq0rjfp6v', 'l1xc02xhso9wdieyn422wynyqk8y3hc3gqggpywy99s93ozktl', '0');
-- Creedence Clearwater Revival
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vf1q427mfk63b28', 'Creedence Clearwater Revival', '260@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd2e2b04b7ba5d60b72f54506','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:260@artist.com', 'vf1q427mfk63b28', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vf1q427mfk63b28', 'Creating a tapestry of tunes that celebrates diversity.', 'Creedence Clearwater Revival');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('njfgvqd3w8najab2yet71vizu2kgogl9b79i8jq4k6kr7tivtz','vf1q427mfk63b28', 'https://i.scdn.co/image/ab67616d0000b27351f311c2fb06ad2789e3ff91', 'Creedence Clearwater Revival Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v7xj078r1tcpzrgl5n7pwfxbwvprcm3ttvslm9iind28akvwqb','Have You Ever Seen The Rain?','vf1q427mfk63b28','POP','2LawezPeJhN4AWuSB0GtAU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('njfgvqd3w8najab2yet71vizu2kgogl9b79i8jq4k6kr7tivtz', 'v7xj078r1tcpzrgl5n7pwfxbwvprcm3ttvslm9iind28akvwqb', '0');
-- Andy Williams
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m5ffc54z0wqyosg', 'Andy Williams', '261@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5888acdca5e748e796b4e69b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:261@artist.com', 'm5ffc54z0wqyosg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m5ffc54z0wqyosg', 'A confluence of cultural beats and contemporary tunes.', 'Andy Williams');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9a0z6i1wtxw62we4597p98gw8rgli77ldpxbuc8por2z1mejpo','m5ffc54z0wqyosg', 'https://i.scdn.co/image/ab67616d0000b27398073965947f92f1641b8356', 'Andy Williams Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rtzkw878m88t7f6yfrlxbzxwp4ebnmwydbbghnz6bz5z77yuzh','Its the Most Wonderful Time of the Year','m5ffc54z0wqyosg','POP','5hslUAKq9I9CG2bAulFkHN','https://p.scdn.co/mp3-preview/853f441c5fc1b25ba88bb300c17119cde36da675?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9a0z6i1wtxw62we4597p98gw8rgli77ldpxbuc8por2z1mejpo', 'rtzkw878m88t7f6yfrlxbzxwp4ebnmwydbbghnz6bz5z77yuzh', '0');
-- Taylor Swift
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qewqo33wzcop1sw', 'Taylor Swift', '262@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb859e4c14fa59296c8649e0e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:262@artist.com', 'qewqo33wzcop1sw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qewqo33wzcop1sw', 'A storytelling icon, weaving life experiences into musical masterpieces.', 'Taylor Swift');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d','qewqo33wzcop1sw', 'https://i.scdn.co/image/ab67616d0000b273e787cffec20aa2a396a61647', 'Taylor Swift Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('phjf850tw3vfu3vqrxv6s8zcxhywnf07uv9uati82mad6ksiz7','Cruel Summer','qewqo33wzcop1sw','POP','1BxfuPKGuaTgP7aM0Bbdwr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'phjf850tw3vfu3vqrxv6s8zcxhywnf07uv9uati82mad6ksiz7', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ypelmvtnyltocto7nyohdzn84knoodhhq9zrb9gs32phri8qqu','I Can See You (Taylors Version) (From The ','qewqo33wzcop1sw','POP','5kHMfzgLZP95O9NBy0ku4v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'ypelmvtnyltocto7nyohdzn84knoodhhq9zrb9gs32phri8qqu', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jd6qrx1nrdha5uprcz43hjdh92ihgici1vgh96ga8yhqt12nqh','Anti-Hero','qewqo33wzcop1sw','POP','0V3wPSX9ygBnCm8psDIegu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'jd6qrx1nrdha5uprcz43hjdh92ihgici1vgh96ga8yhqt12nqh', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jbe1shduoa702fuisci9l2kr03ue7sja90nmakzsee4mfxqkif','Blank Space','qewqo33wzcop1sw','POP','1p80LdxRV74UKvL8gnD7ky',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'jbe1shduoa702fuisci9l2kr03ue7sja90nmakzsee4mfxqkif', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m6nwrdvzijob3gxnvddveth9r9k0hu11vzd8qqlj7ye3j3bcoq','Style','qewqo33wzcop1sw','POP','1hjRhYpWyqDpPahmSlUTlc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'm6nwrdvzijob3gxnvddveth9r9k0hu11vzd8qqlj7ye3j3bcoq', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3lh78q0c1tqvpykt4bdi4o1pbruov3iiy1s9f0b23syn159hq7','cardigan','qewqo33wzcop1sw','POP','4R2kfaDFhslZEMJqAFNpdd',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', '3lh78q0c1tqvpykt4bdi4o1pbruov3iiy1s9f0b23syn159hq7', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9dek51xqjcknmq1raky5o9r5bh7rp20v6cywlfe1ocywft0fjm','Karma','qewqo33wzcop1sw','POP','7KokYm8cMIXCsGVmUvKtqf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', '9dek51xqjcknmq1raky5o9r5bh7rp20v6cywlfe1ocywft0fjm', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('edijp4mii9soju9m3vuwmqq6hui829qno8f7ys0m8sv6lc0hbd','Enchanted (Taylors Version)','qewqo33wzcop1sw','POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'edijp4mii9soju9m3vuwmqq6hui829qno8f7ys0m8sv6lc0hbd', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8aiidpon29y6mbuwke5k4qacgt8gl6b6b1itzgf57dbitunh6l','Back To December (Taylors Version)','qewqo33wzcop1sw','POP','79uDOz0zuuWS7HWxzMmTa2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', '8aiidpon29y6mbuwke5k4qacgt8gl6b6b1itzgf57dbitunh6l', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m06evee87pwqyqkp4d7hswyzn90iyl1bcq9p8h0df1elh1p4i8','Dont Bl','qewqo33wzcop1sw','POP','59ZmeIz57cGU5Gp9omjlYB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'm06evee87pwqyqkp4d7hswyzn90iyl1bcq9p8h0df1elh1p4i8', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iug1s64tce7jqyil2km2yaym6kf723m6rmak42xtd5v6ydcgm5','Mine (Taylors Version)','qewqo33wzcop1sw','POP','7G0gBu6nLdhFDPRLc0HdDG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'iug1s64tce7jqyil2km2yaym6kf723m6rmak42xtd5v6ydcgm5', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kqw1ecfc6wutzljzqbiyi0klqzj94tet8jwu1bq9nrd7eh8mq2','august','qewqo33wzcop1sw','POP','3hUxzQpSfdDqwM3ZTFQY0K',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'kqw1ecfc6wutzljzqbiyi0klqzj94tet8jwu1bq9nrd7eh8mq2', '11');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zbcl5kcd1m3bgr5v06mpcn6q5b7bgoaz8f59ii52we1h73ekjr','Enchanted','qewqo33wzcop1sw','POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'zbcl5kcd1m3bgr5v06mpcn6q5b7bgoaz8f59ii52we1h73ekjr', '12');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('auob239uxx9umemsnw5y5zb13tlykzumemmdvtrhsng4k0p724','Shake It Off','qewqo33wzcop1sw','POP','3pv7Q5v2dpdefwdWIvE7yH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'auob239uxx9umemsnw5y5zb13tlykzumemmdvtrhsng4k0p724', '13');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xu5332dicr41q9mxlhom2hue6mjyjy3uk328xvnl5a9j7uxijg','You Belong With Me (Taylors Ve','qewqo33wzcop1sw','POP','1qrpoAMXodY6895hGKoUpA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'xu5332dicr41q9mxlhom2hue6mjyjy3uk328xvnl5a9j7uxijg', '14');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('za2u5bd4fhl9u2snx8p9ak92ypod68afkbrs9mmma6wmz50w7t','Better Than Revenge (Taylors Version)','qewqo33wzcop1sw','POP','0NwGC0v03ysCYINtg6ns58',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'za2u5bd4fhl9u2snx8p9ak92ypod68afkbrs9mmma6wmz50w7t', '15');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yakturmstvk954ahsolky3uq47zhnxlpg22mpdxo8qarigiem9','Hits Different','qewqo33wzcop1sw','POP','3xYJScVfxByb61dYHTwiby',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'yakturmstvk954ahsolky3uq47zhnxlpg22mpdxo8qarigiem9', '16');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y9rlipqgb6ckcpt42gqc7y4j36pd5bvlcisr50z9fibzjfez26','Karma (feat. Ice Spice)','qewqo33wzcop1sw','POP','4i6cwNY6oIUU2XZxPIw82Y',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'y9rlipqgb6ckcpt42gqc7y4j36pd5bvlcisr50z9fibzjfez26', '17');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1ko1l9qu1tcgavj3kjnmmp3kjeqbnueowbzgkd8oabn3t3ww9n','Lavender Haze','qewqo33wzcop1sw','POP','5jQI2r1RdgtuT8S3iG8zFC',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', '1ko1l9qu1tcgavj3kjnmmp3kjeqbnueowbzgkd8oabn3t3ww9n', '18');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ywy7i9xfojahuimp90vaaqbtakb9h06btsv7si4xb7igiz0a98','All Of The Girls You Loved Before','qewqo33wzcop1sw','POP','4P9Q0GojKVXpRTJCaL3kyy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'ywy7i9xfojahuimp90vaaqbtakb9h06btsv7si4xb7igiz0a98', '19');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dh5rrtc14x6dvjmolq9h7x2ksbw76oh2tnk8tkbnh2nsljkuyj','Midnight Rain','qewqo33wzcop1sw','POP','3rWDp9tBPQR9z6U5YyRSK4',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 'dh5rrtc14x6dvjmolq9h7x2ksbw76oh2tnk8tkbnh2nsljkuyj', '20');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s7kxdz5nnfa80wzkgjahju26yc3e9wgs1yem00e0r1jw4gbvsy','Youre On Your Own, Kid','qewqo33wzcop1sw','POP','1yMjWvw0LRwW5EZBPh9UyF','https://p.scdn.co/mp3-preview/cb8981007d0606f43b3051b3633f890d0a70de8c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8m6vb95m9t0ed9yl34uzkbwb3k2ibj3wk0vv6zn03rkqfuti4d', 's7kxdz5nnfa80wzkgjahju26yc3e9wgs1yem00e0r1jw4gbvsy', '21');
-- Chencho Corleone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zysafbxmkcvry18', 'Chencho Corleone', '263@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2e862710857d2b3e1b5fb4f4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:263@artist.com', 'zysafbxmkcvry18', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zysafbxmkcvry18', 'A dynamic presence in reggaeton, known for his catchy beats and vibrant performances.', 'Chencho Corleone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('st2g5gopvsai4iqclk6ifevkekp75kvuonclvli7c8kba4zxcu','zysafbxmkcvry18', NULL, 'Chencho Corleone Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('04418uxddzco6p0nzxfsmusyojbegxndtgmny7m4xrpzyy4ltc','Me Porto Bonito','zysafbxmkcvry18','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('st2g5gopvsai4iqclk6ifevkekp75kvuonclvli7c8kba4zxcu', '04418uxddzco6p0nzxfsmusyojbegxndtgmny7m4xrpzyy4ltc', '0');
-- Peggy Gou
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w4wk3hydj57dvcu', 'Peggy Gou', '264@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf5c17aa075c03c5c4d2c693','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:264@artist.com', 'w4wk3hydj57dvcu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w4wk3hydj57dvcu', 'A dynamic force in the electronic music scene, known for her eclectic mixes.', 'Peggy Gou');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wjrxuegg5srdxtg0fz2gpb4mmmj3420x6vhxbelmdr46pxaymw','w4wk3hydj57dvcu', 'https://i.scdn.co/image/ab67616d0000b27388d71aadd009fe1a83df88f2', 'Peggy Gou Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pj5lr57761293nis80kxyq4put4xfpwlqmufoacgcfneq3khr2','(It Goes Like) Nanana - Edit','w4wk3hydj57dvcu','POP','23RoR84KodL5HWvUTneQ1w','https://p.scdn.co/mp3-preview/e36e0bd4714844f1f9d992398b41a3e333f15cc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wjrxuegg5srdxtg0fz2gpb4mmmj3420x6vhxbelmdr46pxaymw', 'pj5lr57761293nis80kxyq4put4xfpwlqmufoacgcfneq3khr2', '0');
-- Arijit Singh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rsjjppehbnlpbp6', 'Arijit Singh', '265@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0261696c5df3be99da6ed3f3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:265@artist.com', 'rsjjppehbnlpbp6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rsjjppehbnlpbp6', 'Igniting the stage with electrifying performances.', 'Arijit Singh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('luns5xo7ydlys7nknaak4qb8o11r84l8f51rrtpvb45r6v7grn','rsjjppehbnlpbp6', NULL, 'Arijit Singh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e7a4i3pqp4t61lijp31ir1yjj96o9b3sqehuv2coxai9nfo4qx','Phir Aur Kya Chahiye (From "Zara Hatke Zara Bachke")','rsjjppehbnlpbp6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('luns5xo7ydlys7nknaak4qb8o11r84l8f51rrtpvb45r6v7grn', 'e7a4i3pqp4t61lijp31ir1yjj96o9b3sqehuv2coxai9nfo4qx', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3l6tzr5eyl4vcq5yujp0xtz1raw9afeaj6zs7wz6rnext3pi50','Apna Bana Le (From "Bhediya")','rsjjppehbnlpbp6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('luns5xo7ydlys7nknaak4qb8o11r84l8f51rrtpvb45r6v7grn', '3l6tzr5eyl4vcq5yujp0xtz1raw9afeaj6zs7wz6rnext3pi50', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6xlpy3rlirbfnnfgrypa8luzwxgsu3r3m25xfi9dev6c13s389','Jhoome Jo Pathaan','rsjjppehbnlpbp6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('luns5xo7ydlys7nknaak4qb8o11r84l8f51rrtpvb45r6v7grn', '6xlpy3rlirbfnnfgrypa8luzwxgsu3r3m25xfi9dev6c13s389', '2');
-- Dean Martin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qyawkz89ddechpn', 'Dean Martin', '266@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdc6d54b08006b8896cb199e5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:266@artist.com', 'qyawkz89ddechpn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qyawkz89ddechpn', 'A harmonious blend of passion and creativity.', 'Dean Martin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cupty7wr6ksaesjuayqxbqap8i7fqcwq1ymvr2n8wzdd50fhno','qyawkz89ddechpn', 'https://i.scdn.co/image/ab67616d0000b2736d88028a85c771f37374c8ea', 'Dean Martin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yrulz060544q0xfu1dxu7yxzu8f8enee31gdnz195kbyvj87ri','Let It Snow! Let It Snow! Let It Snow!','qyawkz89ddechpn','POP','2uFaJJtFpPDc5Pa95XzTvg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cupty7wr6ksaesjuayqxbqap8i7fqcwq1ymvr2n8wzdd50fhno', 'yrulz060544q0xfu1dxu7yxzu8f8enee31gdnz195kbyvj87ri', '0');
-- Michael Bubl
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k3ef47u6h2wll3e', 'Michael Bubl', '267@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebef8cf61fea4923d2bde68200','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:267@artist.com', 'k3ef47u6h2wll3e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k3ef47u6h2wll3e', 'A maestro of melodies, orchestrating auditory bliss.', 'Michael Bubl');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qktee2cphv4bbei3a1vc4pqm2b914c6nawlmsb0zzatsx9ndes','k3ef47u6h2wll3e', 'https://i.scdn.co/image/ab67616d0000b273119e4094f07a8123b471ac1d', 'Michael Bubl Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h1wx093xk2dh1y5deolcoe80210e9wey1r2obj243hl6j7j0p6','Its Beginning To Look A Lot Like Christmas','k3ef47u6h2wll3e','POP','5a1iz510sv2W9Dt1MvFd5R','https://p.scdn.co/mp3-preview/51f36d7e04069ef4869ea575fb21e5404710b1c4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qktee2cphv4bbei3a1vc4pqm2b914c6nawlmsb0zzatsx9ndes', 'h1wx093xk2dh1y5deolcoe80210e9wey1r2obj243hl6j7j0p6', '0');


-- File: insert_relationships.sql
-- Users
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dfsrr0py2sgq4to', 'Edward Johnson (0)', '0@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:0@g.com', 'dfsrr0py2sgq4to', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8d0rx3nvr3nwlqp', 'Charlie Martinez (1)', '1@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:1@g.com', '8d0rx3nvr3nwlqp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f1gvjzbk6lwmqn4', 'Hannah Brown (2)', '2@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:2@g.com', 'f1gvjzbk6lwmqn4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('a6d7c4f919os7zo', 'Charlie Smith (3)', '3@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:3@g.com', 'a6d7c4f919os7zo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wswnd71f751io1o', 'Hannah Davis (4)', '4@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:4@g.com', 'wswnd71f751io1o', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yjdjyvny7lk8wzl', 'Diana Miller (5)', '5@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:5@g.com', 'yjdjyvny7lk8wzl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xiobm7toessywvu', 'Julia Williams (6)', '6@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:6@g.com', 'xiobm7toessywvu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('19skjpxffj12xnx', 'Alice Miller (7)', '7@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:7@g.com', '19skjpxffj12xnx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m8mp2g1poa3k4yd', 'George Johnson (8)', '8@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:8@g.com', 'm8mp2g1poa3k4yd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('l5ypcg4m55octfk', 'Diana Miller (9)', '9@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:9@g.com', 'l5ypcg4m55octfk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
-- Playlists
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('f1kpbletpws77amj270zxt9boptz4ghl84d380g3v2nmiwvn7j', 'Playlist 0', '2023-11-17 17:00:08.000','dfsrr0py2sgq4to');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9dek51xqjcknmq1raky5o9r5bh7rp20v6cywlfe1ocywft0fjm', 'f1kpbletpws77amj270zxt9boptz4ghl84d380g3v2nmiwvn7j', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('iyz3tel853ilh7tb8ty7dj5z6e7p1duhzbgkpxi9t9k5zbuduh', 'f1kpbletpws77amj270zxt9boptz4ghl84d380g3v2nmiwvn7j', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z0gk6f9oks2zlgnb27ro1vqmievxh9yo287kqmiua9j3kfjd27', 'f1kpbletpws77amj270zxt9boptz4ghl84d380g3v2nmiwvn7j', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('n4sklzrb0d8251icrv2tlnkscjchbjbdadhx9bw7svg4ki8pbl', 'f1kpbletpws77amj270zxt9boptz4ghl84d380g3v2nmiwvn7j', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r31uu0j0pp3yhqxezuu9ovobqzu17pf81lmldjlxbpul6ukxw7', 'f1kpbletpws77amj270zxt9boptz4ghl84d380g3v2nmiwvn7j', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tlks3q66k29rtkticxiecwmgy4tn6wey8o0o620ybvkp0h0g25', 'f1kpbletpws77amj270zxt9boptz4ghl84d380g3v2nmiwvn7j', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cq07s10qk8ggiogp0wv2dqhtkav3vck7nim6l3mfr8rnjf4ba2', 'f1kpbletpws77amj270zxt9boptz4ghl84d380g3v2nmiwvn7j', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('v0ldqt3ko14zmjf1ns5scgn90oen6ctr78oa1a4jmx0tcz6x6h', 'f1kpbletpws77amj270zxt9boptz4ghl84d380g3v2nmiwvn7j', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ujvkjw0o56lemtapqg3cug632usmqbedmc0x399ykvmhfudi7m', 'f1kpbletpws77amj270zxt9boptz4ghl84d380g3v2nmiwvn7j', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6u6qcvg0u1k6ge590k1ml9pjqnv2xq22ngck2yg8xfyo5u1q36', 'f1kpbletpws77amj270zxt9boptz4ghl84d380g3v2nmiwvn7j', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('9bdpplhs6nxbxai9ha9np2n8t3rsiv2fxzildlrbore782n2ck', 'Playlist 1', '2023-11-17 17:00:08.000','dfsrr0py2sgq4to');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('udni80u6bc18he81nosr73ge216ffhmbnt785d6au4ljo0v26p', '9bdpplhs6nxbxai9ha9np2n8t3rsiv2fxzildlrbore782n2ck', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m6nwrdvzijob3gxnvddveth9r9k0hu11vzd8qqlj7ye3j3bcoq', '9bdpplhs6nxbxai9ha9np2n8t3rsiv2fxzildlrbore782n2ck', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sbgfcv9x25i6g73rszhsmzoe67k9utz8672cttudsetfah22h9', '9bdpplhs6nxbxai9ha9np2n8t3rsiv2fxzildlrbore782n2ck', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qgglzne052bhqdq5055dz3l4anbfje2mfxcevtle26yzc1xgz6', '9bdpplhs6nxbxai9ha9np2n8t3rsiv2fxzildlrbore782n2ck', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z7zxzk1c2qjvnska2iy53eozqbo2wcr8u0a3wklid3ifo6kc9j', '9bdpplhs6nxbxai9ha9np2n8t3rsiv2fxzildlrbore782n2ck', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7d4eeymgthhxbw5s973v8v9chv5iq8j8rmb8q8m2ilak4om7kv', '9bdpplhs6nxbxai9ha9np2n8t3rsiv2fxzildlrbore782n2ck', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vfqszy14mggm9ut6a9igmgu1lc7126gm5g8ky4l9htumwwpuwo', '9bdpplhs6nxbxai9ha9np2n8t3rsiv2fxzildlrbore782n2ck', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dldo8mpwlp3qilha2fe578g1fya18ck6t7o5x1j1sq1kw99l04', '9bdpplhs6nxbxai9ha9np2n8t3rsiv2fxzildlrbore782n2ck', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vlyfje8xju7h76l9h330wslksrzb9b9cp6sftvf69nnpe3szog', '9bdpplhs6nxbxai9ha9np2n8t3rsiv2fxzildlrbore782n2ck', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pz40uo0w02hc8zpsydaraqvqqdazjnbbx94o4yry7grfrecwv7', '9bdpplhs6nxbxai9ha9np2n8t3rsiv2fxzildlrbore782n2ck', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('7ma5whz7uul52eeewwi6o7yhvwu3eyk5bm5mo37yoh5l110dyt', 'Playlist 0', '2023-11-17 17:00:08.000','8d0rx3nvr3nwlqp');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vot29nzci5e8ypvya1typkq8p7xxi3epggmc0qxciwjslcekb6', '7ma5whz7uul52eeewwi6o7yhvwu3eyk5bm5mo37yoh5l110dyt', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('srfwe2oc4dsoij33vt619h61vhmxi4q8hei1ywkdj8e9etvhbo', '7ma5whz7uul52eeewwi6o7yhvwu3eyk5bm5mo37yoh5l110dyt', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cavtij876wdfpzq21f8rg51u4rvmhahkamvc392o6e2zbgqbqc', '7ma5whz7uul52eeewwi6o7yhvwu3eyk5bm5mo37yoh5l110dyt', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0zpjfjbts4u5fj9r41jb4zpjkpo9gvqocicu2uyy14l5yfy1u9', '7ma5whz7uul52eeewwi6o7yhvwu3eyk5bm5mo37yoh5l110dyt', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('edijp4mii9soju9m3vuwmqq6hui829qno8f7ys0m8sv6lc0hbd', '7ma5whz7uul52eeewwi6o7yhvwu3eyk5bm5mo37yoh5l110dyt', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('p717ynibmq79unltk62kg1jlvzetrzn0easpzolz8r4cbfzvvs', '7ma5whz7uul52eeewwi6o7yhvwu3eyk5bm5mo37yoh5l110dyt', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ydazyv1k51jnnf38gs9u0yvqldypy9zgpsp3400iqu5sns0eva', '7ma5whz7uul52eeewwi6o7yhvwu3eyk5bm5mo37yoh5l110dyt', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ejsrzjf0a9qor5d0c8jod39znddupdd4mg9c8r97fu2ppujggg', '7ma5whz7uul52eeewwi6o7yhvwu3eyk5bm5mo37yoh5l110dyt', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2qujvt447nfe5hfct1r6i9xtsf17gdl46yrv3yhamnjvg42lqa', '7ma5whz7uul52eeewwi6o7yhvwu3eyk5bm5mo37yoh5l110dyt', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gdxujvn7db85d2zke34hsxvpro0i4slusi0wcbg97cj3jusxnf', '7ma5whz7uul52eeewwi6o7yhvwu3eyk5bm5mo37yoh5l110dyt', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('zs1rl03uhgal4c853vmu8qcb54ck57a5utmer6lw9iw7xl3m0h', 'Playlist 1', '2023-11-17 17:00:08.000','8d0rx3nvr3nwlqp');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('kxqkabfvmt2lju9pe9my77djqjh0ctncshikai434yfxwsdkhh', 'zs1rl03uhgal4c853vmu8qcb54ck57a5utmer6lw9iw7xl3m0h', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xu5332dicr41q9mxlhom2hue6mjyjy3uk328xvnl5a9j7uxijg', 'zs1rl03uhgal4c853vmu8qcb54ck57a5utmer6lw9iw7xl3m0h', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('p6mcxun1tonhf8q0q7jyz0qd9a35hjhbdj98v8n8svuq7615hj', 'zs1rl03uhgal4c853vmu8qcb54ck57a5utmer6lw9iw7xl3m0h', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ft3na1hctkjl2zvlnr9yq6eidbhpe8msjevirg7g1titjazt6s', 'zs1rl03uhgal4c853vmu8qcb54ck57a5utmer6lw9iw7xl3m0h', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gbmjkl8vbzjpytdybuvs58jrjzmuk0vpm3taob8wm2dosmtdui', 'zs1rl03uhgal4c853vmu8qcb54ck57a5utmer6lw9iw7xl3m0h', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('lym4pjss984t7a9wt54nar2tzwnjmaubxoexbbbt2ai22agoe5', 'zs1rl03uhgal4c853vmu8qcb54ck57a5utmer6lw9iw7xl3m0h', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qp8wad28emot9zdpkndc1wkbg1o1m452m7eaknlch6f9w4ebyr', 'zs1rl03uhgal4c853vmu8qcb54ck57a5utmer6lw9iw7xl3m0h', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('n8fd54khjwlc8p4l0malg3ztucw3x2xmy9z1gl6ox4y2z7fzcl', 'zs1rl03uhgal4c853vmu8qcb54ck57a5utmer6lw9iw7xl3m0h', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1ko1l9qu1tcgavj3kjnmmp3kjeqbnueowbzgkd8oabn3t3ww9n', 'zs1rl03uhgal4c853vmu8qcb54ck57a5utmer6lw9iw7xl3m0h', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3a3r989q2iceq646vpmu0724plsnpl4sif8007ww36ayhmakd3', 'zs1rl03uhgal4c853vmu8qcb54ck57a5utmer6lw9iw7xl3m0h', 5);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('brq4fj13qltivbbeihoas1betqyf4csg5zc5lzqpy6ua934fls', 'Playlist 0', '2023-11-17 17:00:08.000','f1gvjzbk6lwmqn4');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jce6ek9rf5hhgiw4p7pauqsaus3mifeczlgqfssywkseojcosg', 'brq4fj13qltivbbeihoas1betqyf4csg5zc5lzqpy6ua934fls', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qer0mcnquepgdza793wcih79tizhbp5wrchs0fb215m2a0cjls', 'brq4fj13qltivbbeihoas1betqyf4csg5zc5lzqpy6ua934fls', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('24kq2azz7qzuhj88mqi89pds1sjb67se82rc64auwpzntstr4m', 'brq4fj13qltivbbeihoas1betqyf4csg5zc5lzqpy6ua934fls', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('j73zk7gxg3lk6ec6j8ed2dx060s7oyetk5cvdit85tha7ajq6g', 'brq4fj13qltivbbeihoas1betqyf4csg5zc5lzqpy6ua934fls', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('lw6dyk6yf8unyrrx4k8dticlm3mighwtiufc77z8vsgu21uy98', 'brq4fj13qltivbbeihoas1betqyf4csg5zc5lzqpy6ua934fls', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h63cf4g87utoy9fd0hfwxwfmmv8oiwli8ac9eysjcl2247lcm2', 'brq4fj13qltivbbeihoas1betqyf4csg5zc5lzqpy6ua934fls', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('epd63p6vyaweo674wu30r3wwxmamvafyddqc11dupty6f68h6q', 'brq4fj13qltivbbeihoas1betqyf4csg5zc5lzqpy6ua934fls', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gz9rv3t3755r4ho3rrs4cbulfly5dk4goxz14j4ex5tw6uts9f', 'brq4fj13qltivbbeihoas1betqyf4csg5zc5lzqpy6ua934fls', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z61nzfr2oqi22ie8jrduzep05kbsbdbrf0li4eakldki2i4b7v', 'brq4fj13qltivbbeihoas1betqyf4csg5zc5lzqpy6ua934fls', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('low1zndqlir40h3szu7ajcklf110mozywfu4uxjl1t8ptut2bt', 'brq4fj13qltivbbeihoas1betqyf4csg5zc5lzqpy6ua934fls', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('swnjo50ioc34rws3fas9trllit3g2tv6khmkao2e12tfiancgg', 'Playlist 1', '2023-11-17 17:00:08.000','f1gvjzbk6lwmqn4');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('f5lngzpowciddgzth6xjx0r4npsy724slvaakihms9yrn2a6v1', 'swnjo50ioc34rws3fas9trllit3g2tv6khmkao2e12tfiancgg', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d70orau034l95hls2xmzp12uvvsxtkkmy77f07opuqu7v2hw5x', 'swnjo50ioc34rws3fas9trllit3g2tv6khmkao2e12tfiancgg', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('x9a0r8sr2nva6uu8vvlgn84gh6wdhv53f29k14c8hh0lujii2d', 'swnjo50ioc34rws3fas9trllit3g2tv6khmkao2e12tfiancgg', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('p1to819iciqdy5xphshmz3y4lv78muxzyer5nee4zoc8lox1g3', 'swnjo50ioc34rws3fas9trllit3g2tv6khmkao2e12tfiancgg', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hva90pm3y1z9zohkdl6tqiiq3v88h6p26kbh0n40m0q0pg3lms', 'swnjo50ioc34rws3fas9trllit3g2tv6khmkao2e12tfiancgg', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('87bgyqtwvaiesrroe466lsd2z23kxysfzuw2jvinamw6gqcpjj', 'swnjo50ioc34rws3fas9trllit3g2tv6khmkao2e12tfiancgg', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('970e7gl8vwljgmt47ntdmp26bnuo050zv4t5p84qg2ijz2r5ky', 'swnjo50ioc34rws3fas9trllit3g2tv6khmkao2e12tfiancgg', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jugimwmkfhiqh377qw6u7hbxonbaz9uezdhzt42z8jkwlxf14y', 'swnjo50ioc34rws3fas9trllit3g2tv6khmkao2e12tfiancgg', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('v0bz15rw23us60luge0gg1rhcqpwmfpxg8i3cy986y2edxj0ye', 'swnjo50ioc34rws3fas9trllit3g2tv6khmkao2e12tfiancgg', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0i89tg9qy28qpao69dh6q6sh4ymvcmm2b5d8evvet5acba8o6y', 'swnjo50ioc34rws3fas9trllit3g2tv6khmkao2e12tfiancgg', 1);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('tdeo1zbz4ifi030950tjypfo6ljb7cgo0df6kly9ixs2w2pe74', 'Playlist 0', '2023-11-17 17:00:08.000','a6d7c4f919os7zo');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dh5rrtc14x6dvjmolq9h7x2ksbw76oh2tnk8tkbnh2nsljkuyj', 'tdeo1zbz4ifi030950tjypfo6ljb7cgo0df6kly9ixs2w2pe74', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zioaasz05v564lusf9nex6s8rftu9zpuk9ytz3ffsl4p9m4cf3', 'tdeo1zbz4ifi030950tjypfo6ljb7cgo0df6kly9ixs2w2pe74', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h6f0g6zv4efi6gmlhci3qp9d3lclr64mxxbej1cnf8zzkmgtyf', 'tdeo1zbz4ifi030950tjypfo6ljb7cgo0df6kly9ixs2w2pe74', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pj5lr57761293nis80kxyq4put4xfpwlqmufoacgcfneq3khr2', 'tdeo1zbz4ifi030950tjypfo6ljb7cgo0df6kly9ixs2w2pe74', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ehg3n0ov40t6epgepfsvnxn4ngfo077w69qpwr5vvgddct0b2g', 'tdeo1zbz4ifi030950tjypfo6ljb7cgo0df6kly9ixs2w2pe74', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('p717ynibmq79unltk62kg1jlvzetrzn0easpzolz8r4cbfzvvs', 'tdeo1zbz4ifi030950tjypfo6ljb7cgo0df6kly9ixs2w2pe74', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0wiked3hah17pphps4gdjf543rt4m5pz8b5tx75encko29imb4', 'tdeo1zbz4ifi030950tjypfo6ljb7cgo0df6kly9ixs2w2pe74', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pvmncwhzqzj48drprbifdqqjzo8j3wfomuymlks929nqhfdold', 'tdeo1zbz4ifi030950tjypfo6ljb7cgo0df6kly9ixs2w2pe74', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('uzyhf35s4cqkql06pnjidne3ikp8m8jalvjpo060m5a0rsw9c2', 'tdeo1zbz4ifi030950tjypfo6ljb7cgo0df6kly9ixs2w2pe74', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('za2u5bd4fhl9u2snx8p9ak92ypod68afkbrs9mmma6wmz50w7t', 'tdeo1zbz4ifi030950tjypfo6ljb7cgo0df6kly9ixs2w2pe74', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('01teqy4ma2lztex0bawm1omvr71zhdo748v15zeqmxw5bkzevy', 'Playlist 1', '2023-11-17 17:00:08.000','a6d7c4f919os7zo');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('apuxqzncoeq2an3wideu6391prey2grk37qyrzxq84scureedr', '01teqy4ma2lztex0bawm1omvr71zhdo748v15zeqmxw5bkzevy', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ff40kse0nh78867t8w7pwln16jk49eiwf74smjrknadvh1vz9w', '01teqy4ma2lztex0bawm1omvr71zhdo748v15zeqmxw5bkzevy', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hfaqepuqf97rp0wbehcn7rxqtdkat0lxcglxvl4f1mo68pvs10', '01teqy4ma2lztex0bawm1omvr71zhdo748v15zeqmxw5bkzevy', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z62ogej34ogr7j9j0awh0thl753ins3exg9dhjx98oszk9gc91', '01teqy4ma2lztex0bawm1omvr71zhdo748v15zeqmxw5bkzevy', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('c40067dv9zd9epsas1suj49nb6vql71ifndojgdi4bs6lbviil', '01teqy4ma2lztex0bawm1omvr71zhdo748v15zeqmxw5bkzevy', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hrtqgf3ws2lc5u4w5da36rr8f4e8juqp4hl03bbogrervkx4m5', '01teqy4ma2lztex0bawm1omvr71zhdo748v15zeqmxw5bkzevy', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('eh85yl3qfdjtoaj8s3sdfaxt1xkizaupe957yqufbuim6dap49', '01teqy4ma2lztex0bawm1omvr71zhdo748v15zeqmxw5bkzevy', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9ew15byq46tg829972z0f4tp1in01sydyq90vq6h5kyyakhfmi', '01teqy4ma2lztex0bawm1omvr71zhdo748v15zeqmxw5bkzevy', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('l1xc02xhso9wdieyn422wynyqk8y3hc3gqggpywy99s93ozktl', '01teqy4ma2lztex0bawm1omvr71zhdo748v15zeqmxw5bkzevy', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('c4wkbpbuvacq77zqqihgjyn48bvu1nsv7oapjhm4ytrzf2n5ms', '01teqy4ma2lztex0bawm1omvr71zhdo748v15zeqmxw5bkzevy', 1);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('xrm2798brwjghvhaf2z2g2zok0fx2tn4yzg8fere55wg5w6hff', 'Playlist 0', '2023-11-17 17:00:08.000','wswnd71f751io1o');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4aby7lknr07f85dk4nzz1570mr3r9vsth1u9a95q2gcnhnha9w', 'xrm2798brwjghvhaf2z2g2zok0fx2tn4yzg8fere55wg5w6hff', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hrtqgf3ws2lc5u4w5da36rr8f4e8juqp4hl03bbogrervkx4m5', 'xrm2798brwjghvhaf2z2g2zok0fx2tn4yzg8fere55wg5w6hff', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dldo8mpwlp3qilha2fe578g1fya18ck6t7o5x1j1sq1kw99l04', 'xrm2798brwjghvhaf2z2g2zok0fx2tn4yzg8fere55wg5w6hff', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jylzha3h4v7t7p0tlvf462uns7n862wypelj82b8o7e517815j', 'xrm2798brwjghvhaf2z2g2zok0fx2tn4yzg8fere55wg5w6hff', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('l1xc02xhso9wdieyn422wynyqk8y3hc3gqggpywy99s93ozktl', 'xrm2798brwjghvhaf2z2g2zok0fx2tn4yzg8fere55wg5w6hff', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cwr8ysnhexv7pyv3z6ts9n924o7l5hsx6rs18q906tmz7el3nd', 'xrm2798brwjghvhaf2z2g2zok0fx2tn4yzg8fere55wg5w6hff', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sa0cuzgi2fx8tmw7v97x0s6ajcgt21vdy8voxk6t5srb2tr85c', 'xrm2798brwjghvhaf2z2g2zok0fx2tn4yzg8fere55wg5w6hff', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('atkximlqlt8ka6gwuqe7qw2kqk6qcz4ooayqld9dgmpo6slx3t', 'xrm2798brwjghvhaf2z2g2zok0fx2tn4yzg8fere55wg5w6hff', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jiebc4z4e79rme3c6kpo9ldnxnav0yr8c88u40vr2lemgo154z', 'xrm2798brwjghvhaf2z2g2zok0fx2tn4yzg8fere55wg5w6hff', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('f2yz4uxlz4ww443yoswikvxhuafgarmhi73hb87mrbuqenglxz', 'xrm2798brwjghvhaf2z2g2zok0fx2tn4yzg8fere55wg5w6hff', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('hmylexfa472392zjok20igay37vcx116z2evzv93muh1q634k4', 'Playlist 1', '2023-11-17 17:00:08.000','wswnd71f751io1o');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('g5re122rm30q6pu1q7qpkcnpdqzg2nw1r3to8u5efveqxffs3b', 'hmylexfa472392zjok20igay37vcx116z2evzv93muh1q634k4', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mw9t57xrq1gh8y8u2uv90t755xgv5y3ee80t65blgwply6evux', 'hmylexfa472392zjok20igay37vcx116z2evzv93muh1q634k4', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('i8aeh9wntcdgz6u6obhfmvma5jl9xhviaa2dax61lwm5uofdvi', 'hmylexfa472392zjok20igay37vcx116z2evzv93muh1q634k4', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5710rps6vkx4wuvx56zh4sjz1rzsm4xq6odzxcb1p64h9fgi60', 'hmylexfa472392zjok20igay37vcx116z2evzv93muh1q634k4', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r31uu0j0pp3yhqxezuu9ovobqzu17pf81lmldjlxbpul6ukxw7', 'hmylexfa472392zjok20igay37vcx116z2evzv93muh1q634k4', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ivysjw5tatpsut34gbxr2mamjzipl7guufzunhwqx45hl365i8', 'hmylexfa472392zjok20igay37vcx116z2evzv93muh1q634k4', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('x9a0r8sr2nva6uu8vvlgn84gh6wdhv53f29k14c8hh0lujii2d', 'hmylexfa472392zjok20igay37vcx116z2evzv93muh1q634k4', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ylx7yrku3a8chw3ar6k0a9r48qsome7a50t9vq4oxwxm4dxva5', 'hmylexfa472392zjok20igay37vcx116z2evzv93muh1q634k4', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wqzneak21oy5t1z8u2ccqapv7wqb5kp82y4irw0f7wgfy2xmwd', 'hmylexfa472392zjok20igay37vcx116z2evzv93muh1q634k4', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zfxc1gwg9y1whgxfgacnqt1m1k8gdjoen6ul4m1vkx12ydor8m', 'hmylexfa472392zjok20igay37vcx116z2evzv93muh1q634k4', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('iwetqm9tpg8ep20mw6g0mwjbofg7fkzetpqv9s5vrsvl6o2fkb', 'Playlist 0', '2023-11-17 17:00:08.000','yjdjyvny7lk8wzl');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sbgfcv9x25i6g73rszhsmzoe67k9utz8672cttudsetfah22h9', 'iwetqm9tpg8ep20mw6g0mwjbofg7fkzetpqv9s5vrsvl6o2fkb', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('epd63p6vyaweo674wu30r3wwxmamvafyddqc11dupty6f68h6q', 'iwetqm9tpg8ep20mw6g0mwjbofg7fkzetpqv9s5vrsvl6o2fkb', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('oyl3qokmb95q6y484wyrb43ea7jk2o7uanw70iqp4sjhwl9kf3', 'iwetqm9tpg8ep20mw6g0mwjbofg7fkzetpqv9s5vrsvl6o2fkb', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('b5irfwmfcaqb2gc6f6b23yl03h44xum18dq1wwkfrzgua00wlu', 'iwetqm9tpg8ep20mw6g0mwjbofg7fkzetpqv9s5vrsvl6o2fkb', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('970e7gl8vwljgmt47ntdmp26bnuo050zv4t5p84qg2ijz2r5ky', 'iwetqm9tpg8ep20mw6g0mwjbofg7fkzetpqv9s5vrsvl6o2fkb', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4r7o2ls7vgwcj62cdzdb8o2t7c5sy4v2e8wuk39omrlboox1q4', 'iwetqm9tpg8ep20mw6g0mwjbofg7fkzetpqv9s5vrsvl6o2fkb', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6vdsfclow7417fwx8h61zgfo2d1kr9aixvbaegpjse6m7m25m1', 'iwetqm9tpg8ep20mw6g0mwjbofg7fkzetpqv9s5vrsvl6o2fkb', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yhxthqc6kmxyp9hf9rfz4cizt9mdmc6npimjsj9bplfso7x00d', 'iwetqm9tpg8ep20mw6g0mwjbofg7fkzetpqv9s5vrsvl6o2fkb', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('n8fd54khjwlc8p4l0malg3ztucw3x2xmy9z1gl6ox4y2z7fzcl', 'iwetqm9tpg8ep20mw6g0mwjbofg7fkzetpqv9s5vrsvl6o2fkb', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('y9rlipqgb6ckcpt42gqc7y4j36pd5bvlcisr50z9fibzjfez26', 'iwetqm9tpg8ep20mw6g0mwjbofg7fkzetpqv9s5vrsvl6o2fkb', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('3qzghls7wbezeou90ewlntnmrpjbgdhkgbcdbwsdevtiy999wd', 'Playlist 1', '2023-11-17 17:00:08.000','yjdjyvny7lk8wzl');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fbaixe1v2554tkdr36y53oijbr0yoshaieb3k9autjmk9z79zn', '3qzghls7wbezeou90ewlntnmrpjbgdhkgbcdbwsdevtiy999wd', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qp8wad28emot9zdpkndc1wkbg1o1m452m7eaknlch6f9w4ebyr', '3qzghls7wbezeou90ewlntnmrpjbgdhkgbcdbwsdevtiy999wd', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yl00b2mlmvb6dpeoseyrat3ro0aeyfk00o0ifhnkt70zvv86b6', '3qzghls7wbezeou90ewlntnmrpjbgdhkgbcdbwsdevtiy999wd', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jiebc4z4e79rme3c6kpo9ldnxnav0yr8c88u40vr2lemgo154z', '3qzghls7wbezeou90ewlntnmrpjbgdhkgbcdbwsdevtiy999wd', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ubxrsbo11ix1dikkapo5zi1xwp1nnyc3y1z71btlj96o2awfq3', '3qzghls7wbezeou90ewlntnmrpjbgdhkgbcdbwsdevtiy999wd', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4guzneos5oeva55rb2ywbp6x2ox6uia5vko1goghtmwuuncae8', '3qzghls7wbezeou90ewlntnmrpjbgdhkgbcdbwsdevtiy999wd', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('g84tv6s9x9v13yque77smf05q3fqieu8ukt9iuj79995onreyd', '3qzghls7wbezeou90ewlntnmrpjbgdhkgbcdbwsdevtiy999wd', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('edijp4mii9soju9m3vuwmqq6hui829qno8f7ys0m8sv6lc0hbd', '3qzghls7wbezeou90ewlntnmrpjbgdhkgbcdbwsdevtiy999wd', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r0v8oxgwrjdgj5u0khstj67i211ueucg3qvuobrazmuv389t5y', '3qzghls7wbezeou90ewlntnmrpjbgdhkgbcdbwsdevtiy999wd', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d98rdfquf5a4bsaj02fjt2hg8jkg0tzvsc1gyk3yd7kz1igu8h', '3qzghls7wbezeou90ewlntnmrpjbgdhkgbcdbwsdevtiy999wd', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('wcy83hp6expcth62y2mjbyybamp7kniz5w8woz2e6vs1v3af8n', 'Playlist 0', '2023-11-17 17:00:08.000','xiobm7toessywvu');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('02gyhid3wn7x4mvjm303mpk6ko6xwf2r7aa248t5t8f42z9ijs', 'wcy83hp6expcth62y2mjbyybamp7kniz5w8woz2e6vs1v3af8n', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hrixznkb5lro49xcrzdfwn5ylsaqgyqlrkpzy79tzy3tmaoa1g', 'wcy83hp6expcth62y2mjbyybamp7kniz5w8woz2e6vs1v3af8n', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vot29nzci5e8ypvya1typkq8p7xxi3epggmc0qxciwjslcekb6', 'wcy83hp6expcth62y2mjbyybamp7kniz5w8woz2e6vs1v3af8n', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4guzneos5oeva55rb2ywbp6x2ox6uia5vko1goghtmwuuncae8', 'wcy83hp6expcth62y2mjbyybamp7kniz5w8woz2e6vs1v3af8n', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ua173lcxi3n5tlulns9myadqozyudhhd3khl47b41fm89yc8z2', 'wcy83hp6expcth62y2mjbyybamp7kniz5w8woz2e6vs1v3af8n', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cj9xqxro05ob5opj2flw7ycdtm4jmnqxdk364ao6rx2g58yxi6', 'wcy83hp6expcth62y2mjbyybamp7kniz5w8woz2e6vs1v3af8n', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xu5332dicr41q9mxlhom2hue6mjyjy3uk328xvnl5a9j7uxijg', 'wcy83hp6expcth62y2mjbyybamp7kniz5w8woz2e6vs1v3af8n', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('l4uolq54vb6253ra648ex02ykjff0jj8ezd0yy5s8oj6piu8b4', 'wcy83hp6expcth62y2mjbyybamp7kniz5w8woz2e6vs1v3af8n', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zfxc1gwg9y1whgxfgacnqt1m1k8gdjoen6ul4m1vkx12ydor8m', 'wcy83hp6expcth62y2mjbyybamp7kniz5w8woz2e6vs1v3af8n', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9dek51xqjcknmq1raky5o9r5bh7rp20v6cywlfe1ocywft0fjm', 'wcy83hp6expcth62y2mjbyybamp7kniz5w8woz2e6vs1v3af8n', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('46aupy5uw77nzy83eqx0cswtca7o32x73lr4tkw4bxc6h7ilqj', 'Playlist 1', '2023-11-17 17:00:08.000','xiobm7toessywvu');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('20o2brewz4aqjclo08i7ui9ojbs20oy1ha8bi4y3xo9jb6im83', '46aupy5uw77nzy83eqx0cswtca7o32x73lr4tkw4bxc6h7ilqj', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xwsd60argom1sd9a3lzf82a3mmgbyzp0odw9eadrpp1qoy820h', '46aupy5uw77nzy83eqx0cswtca7o32x73lr4tkw4bxc6h7ilqj', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('i8aeh9wntcdgz6u6obhfmvma5jl9xhviaa2dax61lwm5uofdvi', '46aupy5uw77nzy83eqx0cswtca7o32x73lr4tkw4bxc6h7ilqj', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zdthagrhsb9nan6tthnmglq067a5ookfh56mswg0d114ah3x7k', '46aupy5uw77nzy83eqx0cswtca7o32x73lr4tkw4bxc6h7ilqj', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0i89tg9qy28qpao69dh6q6sh4ymvcmm2b5d8evvet5acba8o6y', '46aupy5uw77nzy83eqx0cswtca7o32x73lr4tkw4bxc6h7ilqj', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xsy0bzkmwotlngfmqj05ynuo7ga5hlo2isfvsptwo0xzwpv6xz', '46aupy5uw77nzy83eqx0cswtca7o32x73lr4tkw4bxc6h7ilqj', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('030fshng3pldbnkpmlq0tdvv2uyzsy8ym8pn1cm0d8tx7qpl0i', '46aupy5uw77nzy83eqx0cswtca7o32x73lr4tkw4bxc6h7ilqj', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8s98fnrjdf8wgzrhrj6jk68ew1tbfn372eyxepst0qhcel8egp', '46aupy5uw77nzy83eqx0cswtca7o32x73lr4tkw4bxc6h7ilqj', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0gh939quogd1e735pacf97fv3r0nckxpqhnsnevhaagstch1iz', '46aupy5uw77nzy83eqx0cswtca7o32x73lr4tkw4bxc6h7ilqj', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hrq1dcao9dw882rsjqi1axnq6lmyui8nof43dmr9czlol7a1qa', '46aupy5uw77nzy83eqx0cswtca7o32x73lr4tkw4bxc6h7ilqj', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('7izm61pam1523ixwuygtqqhiqr4nua7bpbnin5ifm8vpgti8q4', 'Playlist 0', '2023-11-17 17:00:08.000','19skjpxffj12xnx');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('lsq1lk7ciifpj8q3bttwsw1ly0e7sqkn1ycx670ymn52a2minc', '7izm61pam1523ixwuygtqqhiqr4nua7bpbnin5ifm8vpgti8q4', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0gh939quogd1e735pacf97fv3r0nckxpqhnsnevhaagstch1iz', '7izm61pam1523ixwuygtqqhiqr4nua7bpbnin5ifm8vpgti8q4', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('98r7ifivwep2bncz9706a2r2eo0rxdh1ek2lhp6dql5eamf8o1', '7izm61pam1523ixwuygtqqhiqr4nua7bpbnin5ifm8vpgti8q4', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gw6ewk9m1p7gvhg83f527hy4nxaks1stxjz2r98zmkuaevwhj3', '7izm61pam1523ixwuygtqqhiqr4nua7bpbnin5ifm8vpgti8q4', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jylzha3h4v7t7p0tlvf462uns7n862wypelj82b8o7e517815j', '7izm61pam1523ixwuygtqqhiqr4nua7bpbnin5ifm8vpgti8q4', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8le3inymsqmqavnd772y3cb38l86nhm5igkrg9f2y6swdpmwni', '7izm61pam1523ixwuygtqqhiqr4nua7bpbnin5ifm8vpgti8q4', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pgreemwv8od5a1oyhh1vhzzkw1k0vrss0l3toq2poo21g9l0c4', '7izm61pam1523ixwuygtqqhiqr4nua7bpbnin5ifm8vpgti8q4', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('p1to819iciqdy5xphshmz3y4lv78muxzyer5nee4zoc8lox1g3', '7izm61pam1523ixwuygtqqhiqr4nua7bpbnin5ifm8vpgti8q4', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m06evee87pwqyqkp4d7hswyzn90iyl1bcq9p8h0df1elh1p4i8', '7izm61pam1523ixwuygtqqhiqr4nua7bpbnin5ifm8vpgti8q4', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fwa9ta4ls2q7vach3ps6sdyuubzj2f1c99y796athsivlyxhr7', '7izm61pam1523ixwuygtqqhiqr4nua7bpbnin5ifm8vpgti8q4', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('0s7wxlmkqre5i1nq1sfsktnh1ymv74hoazpjnxf6x4fum0yc2e', 'Playlist 1', '2023-11-17 17:00:08.000','19skjpxffj12xnx');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('90xpwctkjujdfv2t924fxjemh1x7y472ygrzm1jhpgwsh3mrwt', '0s7wxlmkqre5i1nq1sfsktnh1ymv74hoazpjnxf6x4fum0yc2e', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5710rps6vkx4wuvx56zh4sjz1rzsm4xq6odzxcb1p64h9fgi60', '0s7wxlmkqre5i1nq1sfsktnh1ymv74hoazpjnxf6x4fum0yc2e', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('by86y0rjaeo3w9j4jnza8hl10kpajd06z95eqp5fizcfvc1l34', '0s7wxlmkqre5i1nq1sfsktnh1ymv74hoazpjnxf6x4fum0yc2e', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('572ru2b6ap3mz6kzlx0xinwk2ree8jpd887j7xwoxsn2fi67c3', '0s7wxlmkqre5i1nq1sfsktnh1ymv74hoazpjnxf6x4fum0yc2e', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fougq1lkklfkiv3550bhe5dt6q1356rl4dlj52trg0x27hcz9p', '0s7wxlmkqre5i1nq1sfsktnh1ymv74hoazpjnxf6x4fum0yc2e', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('98r7ifivwep2bncz9706a2r2eo0rxdh1ek2lhp6dql5eamf8o1', '0s7wxlmkqre5i1nq1sfsktnh1ymv74hoazpjnxf6x4fum0yc2e', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6no1p48p7a10w3x57ubm4hdupuqsyhzg5p19uv36uytwj6srbq', '0s7wxlmkqre5i1nq1sfsktnh1ymv74hoazpjnxf6x4fum0yc2e', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h1wx093xk2dh1y5deolcoe80210e9wey1r2obj243hl6j7j0p6', '0s7wxlmkqre5i1nq1sfsktnh1ymv74hoazpjnxf6x4fum0yc2e', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qrenxdzjztp9bs6kmirzezvblk8edaunwnkr3z2c35mqp6odux', '0s7wxlmkqre5i1nq1sfsktnh1ymv74hoazpjnxf6x4fum0yc2e', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('k7gt6nkoaaccqg8xunwh5f2k15b3zqtk3w85eeyv600b0hjavj', '0s7wxlmkqre5i1nq1sfsktnh1ymv74hoazpjnxf6x4fum0yc2e', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('1zw80rwtbvw06e79ol36v1o7uyckay64flwk0ivlrwrxw6ivbo', 'Playlist 0', '2023-11-17 17:00:08.000','m8mp2g1poa3k4yd');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ohfz8zgp56q6jcgyrkp52yhaecz33tcjrg6fuvyojihtse3fav', '1zw80rwtbvw06e79ol36v1o7uyckay64flwk0ivlrwrxw6ivbo', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8h7natilkpvhow4tn8qw4isypi09vunm52ulxmdofxolrqq52i', '1zw80rwtbvw06e79ol36v1o7uyckay64flwk0ivlrwrxw6ivbo', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xsrhj4e2t86eujvos8rmhsbrdru64e3cynel5ybiuh18a79nut', '1zw80rwtbvw06e79ol36v1o7uyckay64flwk0ivlrwrxw6ivbo', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zbcl5kcd1m3bgr5v06mpcn6q5b7bgoaz8f59ii52we1h73ekjr', '1zw80rwtbvw06e79ol36v1o7uyckay64flwk0ivlrwrxw6ivbo', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4j45ssa5at0s2i7run3bst2zum7wv8smttfsp40cvtn7es4wdy', '1zw80rwtbvw06e79ol36v1o7uyckay64flwk0ivlrwrxw6ivbo', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mlyaz1q1y2g9vw30gqnhqzbja5m3m3mrdjatz1oklkm0s6q2eh', '1zw80rwtbvw06e79ol36v1o7uyckay64flwk0ivlrwrxw6ivbo', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0o95ru4pcsxxxnq1171cxlwffse84btsro6px7rsw3yasnzmig', '1zw80rwtbvw06e79ol36v1o7uyckay64flwk0ivlrwrxw6ivbo', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('s7kxdz5nnfa80wzkgjahju26yc3e9wgs1yem00e0r1jw4gbvsy', '1zw80rwtbvw06e79ol36v1o7uyckay64flwk0ivlrwrxw6ivbo', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ckg7swoyl476hdcaw9l3c39qewofdimwjegujf6sb5bih7t4dn', '1zw80rwtbvw06e79ol36v1o7uyckay64flwk0ivlrwrxw6ivbo', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vlyfje8xju7h76l9h330wslksrzb9b9cp6sftvf69nnpe3szog', '1zw80rwtbvw06e79ol36v1o7uyckay64flwk0ivlrwrxw6ivbo', 5);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('ojzx29imvusk7yti8gcvs99n34jf00hvl2srsmkspdtvjdn7uh', 'Playlist 1', '2023-11-17 17:00:08.000','m8mp2g1poa3k4yd');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r31uu0j0pp3yhqxezuu9ovobqzu17pf81lmldjlxbpul6ukxw7', 'ojzx29imvusk7yti8gcvs99n34jf00hvl2srsmkspdtvjdn7uh', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('w30sbs0awylgmisnrqpaqpdpisdx5unr1du70u8v8av0bn77wz', 'ojzx29imvusk7yti8gcvs99n34jf00hvl2srsmkspdtvjdn7uh', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('69jdk1vu66j9vpgh570i8stmpskj3mucckgg42qo5pkn9cs93o', 'ojzx29imvusk7yti8gcvs99n34jf00hvl2srsmkspdtvjdn7uh', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yrulz060544q0xfu1dxu7yxzu8f8enee31gdnz195kbyvj87ri', 'ojzx29imvusk7yti8gcvs99n34jf00hvl2srsmkspdtvjdn7uh', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vm66lok7j59yr0unr9mg26ph5ovoz30hlqkatb5wzcubzxufg1', 'ojzx29imvusk7yti8gcvs99n34jf00hvl2srsmkspdtvjdn7uh', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qkgpfn7msrmhx3hzts7mw7w9iednihoioz93kr6h5xcue6okna', 'ojzx29imvusk7yti8gcvs99n34jf00hvl2srsmkspdtvjdn7uh', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('19nkryrdb1lo03roov799irjhr0a19o0ndj9bmngri1e11vn2m', 'ojzx29imvusk7yti8gcvs99n34jf00hvl2srsmkspdtvjdn7uh', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('v7xj078r1tcpzrgl5n7pwfxbwvprcm3ttvslm9iind28akvwqb', 'ojzx29imvusk7yti8gcvs99n34jf00hvl2srsmkspdtvjdn7uh', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qrenxdzjztp9bs6kmirzezvblk8edaunwnkr3z2c35mqp6odux', 'ojzx29imvusk7yti8gcvs99n34jf00hvl2srsmkspdtvjdn7uh', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fbaixe1v2554tkdr36y53oijbr0yoshaieb3k9autjmk9z79zn', 'ojzx29imvusk7yti8gcvs99n34jf00hvl2srsmkspdtvjdn7uh', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('iezuo0ikcypr6ra8op098eaext90ng4befbbtvmamvih3362uk', 'Playlist 0', '2023-11-17 17:00:08.000','l5ypcg4m55octfk');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('kqw1ecfc6wutzljzqbiyi0klqzj94tet8jwu1bq9nrd7eh8mq2', 'iezuo0ikcypr6ra8op098eaext90ng4befbbtvmamvih3362uk', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('j73zk7gxg3lk6ec6j8ed2dx060s7oyetk5cvdit85tha7ajq6g', 'iezuo0ikcypr6ra8op098eaext90ng4befbbtvmamvih3362uk', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('japchheriv543qiz6uokyb6ktsmp7lywrcsdsczvrwnoz765bn', 'iezuo0ikcypr6ra8op098eaext90ng4befbbtvmamvih3362uk', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ptv9crgffyaev9siuh4ikgkcho7a0v4sfv3fakrityasc5p12r', 'iezuo0ikcypr6ra8op098eaext90ng4befbbtvmamvih3362uk', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vot29nzci5e8ypvya1typkq8p7xxi3epggmc0qxciwjslcekb6', 'iezuo0ikcypr6ra8op098eaext90ng4befbbtvmamvih3362uk', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h63cf4g87utoy9fd0hfwxwfmmv8oiwli8ac9eysjcl2247lcm2', 'iezuo0ikcypr6ra8op098eaext90ng4befbbtvmamvih3362uk', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('djdjtulu485zqd4c7fvc9gvqv1jzl47dfkdm8gqatqtx44cqc2', 'iezuo0ikcypr6ra8op098eaext90ng4befbbtvmamvih3362uk', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nd36mdcgl7nliksmwmzkv3qiezg2uqye7q7cqiiorglhvklbg0', 'iezuo0ikcypr6ra8op098eaext90ng4befbbtvmamvih3362uk', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('guxjwhkqybzfwpwes26dw959jhs7wfdkmpkijyfbq6j5tho24l', 'iezuo0ikcypr6ra8op098eaext90ng4befbbtvmamvih3362uk', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hva90pm3y1z9zohkdl6tqiiq3v88h6p26kbh0n40m0q0pg3lms', 'iezuo0ikcypr6ra8op098eaext90ng4befbbtvmamvih3362uk', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('ylwm2azvokhjj5yf5bo1rjdpgrjm4chpm3b8xkummfrel28dzb', 'Playlist 1', '2023-11-17 17:00:08.000','l5ypcg4m55octfk');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pgreemwv8od5a1oyhh1vhzzkw1k0vrss0l3toq2poo21g9l0c4', 'ylwm2azvokhjj5yf5bo1rjdpgrjm4chpm3b8xkummfrel28dzb', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tge9xuz7vo27upmvs5bspck4kx34d92o4lu1uqyhdot6blvcen', 'ylwm2azvokhjj5yf5bo1rjdpgrjm4chpm3b8xkummfrel28dzb', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wzoi0d4ksbguis34b3que77sk4d2zpnsfdy1jx7kohe94ewpj0', 'ylwm2azvokhjj5yf5bo1rjdpgrjm4chpm3b8xkummfrel28dzb', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5eijpfftgl79m85rgcy52xpwcp0ttmt4o8ryvn4j3f2qrko9u2', 'ylwm2azvokhjj5yf5bo1rjdpgrjm4chpm3b8xkummfrel28dzb', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('g5re122rm30q6pu1q7qpkcnpdqzg2nw1r3to8u5efveqxffs3b', 'ylwm2azvokhjj5yf5bo1rjdpgrjm4chpm3b8xkummfrel28dzb', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('p6mcxun1tonhf8q0q7jyz0qd9a35hjhbdj98v8n8svuq7615hj', 'ylwm2azvokhjj5yf5bo1rjdpgrjm4chpm3b8xkummfrel28dzb', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('g4docryglitz3esdgokkmo5qf47qsx6ua1gbj3bfnmwfhi4bp7', 'ylwm2azvokhjj5yf5bo1rjdpgrjm4chpm3b8xkummfrel28dzb', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9tacl2r07tyote15v7zcfou2bjasx1qlsct7ttmfxbwuuh4wpg', 'ylwm2azvokhjj5yf5bo1rjdpgrjm4chpm3b8xkummfrel28dzb', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('l1xc02xhso9wdieyn422wynyqk8y3hc3gqggpywy99s93ozktl', 'ylwm2azvokhjj5yf5bo1rjdpgrjm4chpm3b8xkummfrel28dzb', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('rsnfo3todf9v0evmzzod6uzst0k2k7a0de1whsk60yr45vbphj', 'ylwm2azvokhjj5yf5bo1rjdpgrjm4chpm3b8xkummfrel28dzb', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('4mjnv2093baimcgedyhgb70f5oomhav9fi1rco82yydx861zpq', 'Playlist 0', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vuri8fc4jivwnu0zus3ufme01bo621y1pnfgpva1ot28dus5jj', '4mjnv2093baimcgedyhgb70f5oomhav9fi1rco82yydx861zpq', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nvzqq2d9443cn0xsjwlkixxlor3re4djk4vrwggdxw7bp3wrv8', '4mjnv2093baimcgedyhgb70f5oomhav9fi1rco82yydx861zpq', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m6dcfs7476kywpb8b4ohroxfqxcg7gsza70ewnfkexgsylxutx', '4mjnv2093baimcgedyhgb70f5oomhav9fi1rco82yydx861zpq', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('i252ogpp5bsk7kq2v8m4pzuue8kxi8y9bzp4ec7rsf0r5ceerl', '4mjnv2093baimcgedyhgb70f5oomhav9fi1rco82yydx861zpq', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('lfm8vyxipfeuu5s3c0m6lpb0p8xjmotmzswuf2eq75b8qprcaz', '4mjnv2093baimcgedyhgb70f5oomhav9fi1rco82yydx861zpq', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('c3ltl6qh5h2k76rqrdpq14j4tg7swvpqhl74bzoo17dzuwuhu8', '4mjnv2093baimcgedyhgb70f5oomhav9fi1rco82yydx861zpq', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4dbscxif2gotvqsfyfina4ao4ehqct08k5uxdep92erdr4l5nx', '4mjnv2093baimcgedyhgb70f5oomhav9fi1rco82yydx861zpq', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bxcc08mnul04vj5du217k0trluihmru1rb2cfc3gm6f9kw4f0c', '4mjnv2093baimcgedyhgb70f5oomhav9fi1rco82yydx861zpq', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qp8wad28emot9zdpkndc1wkbg1o1m452m7eaknlch6f9w4ebyr', '4mjnv2093baimcgedyhgb70f5oomhav9fi1rco82yydx861zpq', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t8y86asvfgea51wsdze7qusk7d9eyl8tjl3i01nns1rvpqadqe', '4mjnv2093baimcgedyhgb70f5oomhav9fi1rco82yydx861zpq', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('y97zjxo4ywel2q9cbj3d87mod6jcnesgp5pn7sx4k96819xj3m', 'Playlist 1', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('96v9ii3odpthtgq6e90wrb73s3sa8beyfk2dpbtwsezk8519ag', 'y97zjxo4ywel2q9cbj3d87mod6jcnesgp5pn7sx4k96819xj3m', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4ahxlayfza4r0qs290gqrzkq2kgoq892j83ce4gypupsdxp5w0', 'y97zjxo4ywel2q9cbj3d87mod6jcnesgp5pn7sx4k96819xj3m', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0ozw4nl95fkog3xu29fw78b3qxhpurtuhlcouponu3svcvtrqy', 'y97zjxo4ywel2q9cbj3d87mod6jcnesgp5pn7sx4k96819xj3m', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('w0yrn6wbc8ki2iutd6h3is4utxhf1kyu60ibmg260qy475983d', 'y97zjxo4ywel2q9cbj3d87mod6jcnesgp5pn7sx4k96819xj3m', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xsy0bzkmwotlngfmqj05ynuo7ga5hlo2isfvsptwo0xzwpv6xz', 'y97zjxo4ywel2q9cbj3d87mod6jcnesgp5pn7sx4k96819xj3m', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tpn68v2aflnu3r7gcswyigoy5c1nxw4norwz8lliwogqkzsqn4', 'y97zjxo4ywel2q9cbj3d87mod6jcnesgp5pn7sx4k96819xj3m', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ut5pcs3kel3wonp6jhvc3i6i8nz235q7cvxu48ska1tfiiry3q', 'y97zjxo4ywel2q9cbj3d87mod6jcnesgp5pn7sx4k96819xj3m', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vee0m1dhwyes04ikmcg2bc46q41wtsahe6wdvlno1vfbtiab7e', 'y97zjxo4ywel2q9cbj3d87mod6jcnesgp5pn7sx4k96819xj3m', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('i8aeh9wntcdgz6u6obhfmvma5jl9xhviaa2dax61lwm5uofdvi', 'y97zjxo4ywel2q9cbj3d87mod6jcnesgp5pn7sx4k96819xj3m', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r4i0lkicshzkwl4tvjar7ueujsbhkvandaqghyxzj37q7j6qzz', 'y97zjxo4ywel2q9cbj3d87mod6jcnesgp5pn7sx4k96819xj3m', 2);
-- User Likes
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', 'ejsrzjf0a9qor5d0c8jod39znddupdd4mg9c8r97fu2ppujggg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', 'vee0m1dhwyes04ikmcg2bc46q41wtsahe6wdvlno1vfbtiab7e');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', 'ouojlg9gz6mn4kdudb1pbfzzrj8jolecdqpz8lbazvsy93pexi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', '6wgripjxmsfee9nw9epm4ipcr2oww3s47pprb8ijos6dr9nfw7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', 'm06evee87pwqyqkp4d7hswyzn90iyl1bcq9p8h0df1elh1p4i8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', 'ut5pcs3kel3wonp6jhvc3i6i8nz235q7cvxu48ska1tfiiry3q');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', 'r7syzwt0uthfhjcue5dn4mv3amr9uscraz9t6ajiz72rw28ow0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', 'bxcc08mnul04vj5du217k0trluihmru1rb2cfc3gm6f9kw4f0c');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', 'yrulz060544q0xfu1dxu7yxzu8f8enee31gdnz195kbyvj87ri');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', 'xw0efwdtg264imggawedj2sf7ytr6wvisuf94kfacpmjtiykek');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', 'l1xc02xhso9wdieyn422wynyqk8y3hc3gqggpywy99s93ozktl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', 'udni80u6bc18he81nosr73ge216ffhmbnt785d6au4ljo0v26p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', 'jvfj9wzrrdhkwuwfxh6oaqhqiyqielihocvyhf9ca7wzjjg5qd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', 'a5mugorunqfmjel0gw55u1s5mu9pkbljvpbj37opuogah4cpnh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('dfsrr0py2sgq4to', '42x7ek2r1nif791rhpvxon2hpp36l0b3sf5ca5vld6xayal7r2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', '19nkryrdb1lo03roov799irjhr0a19o0ndj9bmngri1e11vn2m');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', 'fh2r8d6ghmu9bm1zeg3k0ftckdw3dapkcsvf250l4r5nevir1i');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', '0c5t3shjsq4hfcxzl1tnsw37mz2inl3f63561jbmxdyolo12ll');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', '0gh939quogd1e735pacf97fv3r0nckxpqhnsnevhaagstch1iz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', '4ahxlayfza4r0qs290gqrzkq2kgoq892j83ce4gypupsdxp5w0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', 'mfhs4rdsu0y20s1ecjhhb202hvb3yfbrlm1rv4ub88rv3qgviz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', 'hzcj9zkj7fh79u12c6ttzg0fjv4qn9ahdtp80ci2x3t6sao6as');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', 'gw6ewk9m1p7gvhg83f527hy4nxaks1stxjz2r98zmkuaevwhj3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', 'bnith3h9rgpix5v7dc72czmwd9ifyqcl800bta5ly9z8b1yk8g');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', 'xsrhj4e2t86eujvos8rmhsbrdru64e3cynel5ybiuh18a79nut');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', 'hrtqgf3ws2lc5u4w5da36rr8f4e8juqp4hl03bbogrervkx4m5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', 'yl00b2mlmvb6dpeoseyrat3ro0aeyfk00o0ifhnkt70zvv86b6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', 'z7zxzk1c2qjvnska2iy53eozqbo2wcr8u0a3wklid3ifo6kc9j');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', 'ubxrsbo11ix1dikkapo5zi1xwp1nnyc3y1z71btlj96o2awfq3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('8d0rx3nvr3nwlqp', 'm6nwrdvzijob3gxnvddveth9r9k0hu11vzd8qqlj7ye3j3bcoq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', '6wgripjxmsfee9nw9epm4ipcr2oww3s47pprb8ijos6dr9nfw7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', 'mms7x23sfesvoau1lisjavam0mcyhb45nlze6rzgfrpm92bk1k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', 'jspw66hnvfxff58q4ow5pk8er3j06ivi2x2wl19j8gdlsizh1d');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', '9niwhcde5sf4emhkiu3jlpkikwmwbyfq5v17qm2x4mc83uu4fx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', '6u6qcvg0u1k6ge590k1ml9pjqnv2xq22ngck2yg8xfyo5u1q36');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', 'usq2bkhlv4wwoala7xpdnp0rtzoccwvauf1ovffezb2n97n87h');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', 'gx22kdkrm215bmzfjfxku4qx6mo14px6znxcvh5nxx7ci42r1t');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', 'k65ibbsh4jnc1q0y6v845d1vydy6mu6vzua2f1rz306ksa9n8t');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', 'cz8a655kz4dfmpmn8x2ml3m0dwmimx2p2dmkcqw1rdnwgxgysr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', 'tge9xuz7vo27upmvs5bspck4kx34d92o4lu1uqyhdot6blvcen');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', '9ew15byq46tg829972z0f4tp1in01sydyq90vq6h5kyyakhfmi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', 'iyz3tel853ilh7tb8ty7dj5z6e7p1duhzbgkpxi9t9k5zbuduh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', 'wqzneak21oy5t1z8u2ccqapv7wqb5kp82y4irw0f7wgfy2xmwd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', 'rtzkw878m88t7f6yfrlxbzxwp4ebnmwydbbghnz6bz5z77yuzh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('f1gvjzbk6lwmqn4', '030fshng3pldbnkpmlq0tdvv2uyzsy8ym8pn1cm0d8tx7qpl0i');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', 'yhxthqc6kmxyp9hf9rfz4cizt9mdmc6npimjsj9bplfso7x00d');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', 'lqettnxt2tv9867d2p1wby1nv3pillfnsenqyxjv6sv6netad1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', '98r7ifivwep2bncz9706a2r2eo0rxdh1ek2lhp6dql5eamf8o1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', 'g84tv6s9x9v13yque77smf05q3fqieu8ukt9iuj79995onreyd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', '9ew15byq46tg829972z0f4tp1in01sydyq90vq6h5kyyakhfmi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', 'zhed2jpqah4becm1yq1kv86xeiiyit609dicjjrlajbg09vq59');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', 'zd5tesffyvxu1fj3jsf7kagb9i5ruupfgjo73d9noz4b1k3zap');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', '0d8mm0kn0ry5qdw1ptq67gome8mnuzn3ojl61z2ovbsjzqxz7m');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', 'w1aiaxtpytx9ctdlsrdga4w0nwsqbzyeynifqmwlc4tbca85kf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', '6bhwxtq98oezoq60id15mgmms85fx44lbj9n1a48ye2af1ux0p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', 'ywy7i9xfojahuimp90vaaqbtakb9h06btsv7si4xb7igiz0a98');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', 'zigr4x5m2mi6ezd5e0c9l096il6azm3j8gg0ptee9j5gyjsr0v');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', 'u2krdc9tbdu05blpa8ooz8qeyhov723gk7c7hfn5rdq7szs5uc');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', '69jdk1vu66j9vpgh570i8stmpskj3mucckgg42qo5pkn9cs93o');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('a6d7c4f919os7zo', 'qphd10rcm849peequq3vrbpuf56i7xju8lv84f9fdfqb4q2bbm');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', 'hfaqepuqf97rp0wbehcn7rxqtdkat0lxcglxvl4f1mo68pvs10');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', '20o2brewz4aqjclo08i7ui9ojbs20oy1ha8bi4y3xo9jb6im83');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', '50i1u5o6tvhd53z91w3wed0jorm4auencw5ez47kqovw023g3e');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', 'axptvn6rawfbr8q7hf36lf5fmo31aqgnhli0gkcr6j8aoers5h');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', 'uddahvu8vdi3zn8et6hhlg1zejdl9k1pzuxueb0uxjj3co9f7l');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', 'fbaixe1v2554tkdr36y53oijbr0yoshaieb3k9autjmk9z79zn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', 'o2xvmohxt44thv2ezv3hm81syk9l4t1ax49kvo3iasbnz7bton');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', 'atkdip0ctrrztm1j81xz3rolhwurpt7dac6h4kd6ydq5tvp8l2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', 'ypelmvtnyltocto7nyohdzn84knoodhhq9zrb9gs32phri8qqu');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', 'vfqszy14mggm9ut6a9igmgu1lc7126gm5g8ky4l9htumwwpuwo');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', 'tpn68v2aflnu3r7gcswyigoy5c1nxw4norwz8lliwogqkzsqn4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', 'm9birgazr8ajw3l1m9o2aihpj4kdrxjdl0c2vt85preld90jew');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', 'n4sklzrb0d8251icrv2tlnkscjchbjbdadhx9bw7svg4ki8pbl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', 'jugimwmkfhiqh377qw6u7hbxonbaz9uezdhzt42z8jkwlxf14y');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wswnd71f751io1o', 'cbvcwcdvvsetng1bbm6cz317auqpw9eqwes94ju59u52eiwwm9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'fv6pnwxd9zh1re92oo0tfxpywvu7fmvr7lr98vgg08xzhvgvy5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'ks124q4fbgzsb3r34c6yd74lv5c9dzbxt6r325hikxrs4fgab0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'hfaqepuqf97rp0wbehcn7rxqtdkat0lxcglxvl4f1mo68pvs10');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'w30sbs0awylgmisnrqpaqpdpisdx5unr1du70u8v8av0bn77wz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'b4uqzfk8h8mvlym8exa95ddgbftqqo9qza5123ub3x2n0mg5r8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'doibieznq1bxjyyxh5603tzgygiww252b1jkz84q37jyq1djyo');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'amwa2v81ec27yxaoxpxyi5hstsj4ll8341i3hm4xrdtnpwifr4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', '006h7mdhjodzgupbetuobv3aeebqk1kzpj8lvkss0eccpi18wn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'rjbl6481fpbwml7o0v9m3q2p5hjjpbgupq7hd78w0w9fnz9e38');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'nt7hhvf70l9p0cb4d3w87gmzyiu2q8tybpir8p3cfp6yfv4b32');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'hrtqgf3ws2lc5u4w5da36rr8f4e8juqp4hl03bbogrervkx4m5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'm9ao9irrmvv8tb8b3sf04h9pfmefw8w482kxo8vv6ktn1g1zu8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'qp8wad28emot9zdpkndc1wkbg1o1m452m7eaknlch6f9w4ebyr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'pj5lr57761293nis80kxyq4put4xfpwlqmufoacgcfneq3khr2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('yjdjyvny7lk8wzl', 'ipfpclmy823rqxt4zxe4ma89qquob9cz8eekmatlv9tliubex8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', '1h11pjinhdyusdqdxoabgankcd4t61xmtkd5vfqf9r4rd7u8tr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', 'r4i0lkicshzkwl4tvjar7ueujsbhkvandaqghyxzj37q7j6qzz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', 'z0gk6f9oks2zlgnb27ro1vqmievxh9yo287kqmiua9j3kfjd27');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', 'q2wj7fhg33yet89obeztaw6mdkqpq2l8slln52cjoalwp1m7j8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', 'zfxc1gwg9y1whgxfgacnqt1m1k8gdjoen6ul4m1vkx12ydor8m');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', '6c0l88oqyrymzr7trizwmiqc4or4a02sa2oahel5omgsfjru41');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', 'm9birgazr8ajw3l1m9o2aihpj4kdrxjdl0c2vt85preld90jew');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', '56fdg6jyna6a4s74271oeqoi072ypug4gg3so1226nql6lbp9k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', 'iietkyt06nl1n7l15phxc5xevgzvx2oxisptr64tcfipkdiqrf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', 'xp1qdaz3baibppo754cnuchwhk6u5u37exa9yc6bqory29q0cd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', '2qujvt447nfe5hfct1r6i9xtsf17gdl46yrv3yhamnjvg42lqa');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', 'wwy4vn7sqy51edb9ase5raqzb52qd748x8xmhl5uoed92v5ykw');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', 'mne5ikidiqe0blvhkebn9jh66fxurzjnmufiay4nxtcg45csgw');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', 'j8zqixjw5tp71he69ekhvweyfj9o3gim1kngovimj5219918ra');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('xiobm7toessywvu', '1sh5jof50u26378l49m9fcaihxe97psw4fw93gmm2t6uicqfmd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', '04418uxddzco6p0nzxfsmusyojbegxndtgmny7m4xrpzyy4ltc');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', '5t8tf9qjflu65dpnubji7vaxg676con30hu4o5ar6ckb7zv3ag');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', 'n8fd54khjwlc8p4l0malg3ztucw3x2xmy9z1gl6ox4y2z7fzcl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', 'yhxthqc6kmxyp9hf9rfz4cizt9mdmc6npimjsj9bplfso7x00d');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', '6p7sag6xw5nbtf2y2oajtsg4qiq1dvqfs3q0d6zpgouho2uukk');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', 'n56i7ee6guvqvt8ztyj0fquz1xlb57df1c0k2pzstmgbmhc6q5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', 'aoyw2am57v2k4fpgtiu0c5vmi82utcs431yybmw7rf3qaaqdqs');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', 'ujvkjw0o56lemtapqg3cug632usmqbedmc0x399ykvmhfudi7m');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', 'ywy7i9xfojahuimp90vaaqbtakb9h06btsv7si4xb7igiz0a98');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', 'pa3y40irfzpiss960c1hkkew1i3m9zral0kstsg2m3vd4jni2r');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', 'fh2r8d6ghmu9bm1zeg3k0ftckdw3dapkcsvf250l4r5nevir1i');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', '6xlpy3rlirbfnnfgrypa8luzwxgsu3r3m25xfi9dev6c13s389');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', 'q8g5q4jtlckcpwf6r2jiyodtixxb8d2ik9m2f7yjw0voak8twp');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', 'm9ao9irrmvv8tb8b3sf04h9pfmefw8w482kxo8vv6ktn1g1zu8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('19skjpxffj12xnx', 'z61nzfr2oqi22ie8jrduzep05kbsbdbrf0li4eakldki2i4b7v');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', '1469lajp4hdk7d4vrpzsmsk01pud9avpn8sy50b2elvbg13tuq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', 'xsrhj4e2t86eujvos8rmhsbrdru64e3cynel5ybiuh18a79nut');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', 'pvmncwhzqzj48drprbifdqqjzo8j3wfomuymlks929nqhfdold');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', '8i2fbcubdkqyvl27881tyi058kvve1y20fy3fa9l9wvccgwfa0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', 'i1gqe7yp4ebwnqq2l5kv29s4hum5dz9bekb7nzrld3s95ashcm');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', 'k65ibbsh4jnc1q0y6v845d1vydy6mu6vzua2f1rz306ksa9n8t');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', 'hfaqepuqf97rp0wbehcn7rxqtdkat0lxcglxvl4f1mo68pvs10');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', 'yakturmstvk954ahsolky3uq47zhnxlpg22mpdxo8qarigiem9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', 'gsma76o1dkvn4a8nx4tlw49up0bcyeretm6c9rns1yqaywlk4p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', '3lh78q0c1tqvpykt4bdi4o1pbruov3iiy1s9f0b23syn159hq7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', 'c4wkbpbuvacq77zqqihgjyn48bvu1nsv7oapjhm4ytrzf2n5ms');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', 'jx9d0e04ynq3xydkxig7i956a077kxs26jhvfiym4fqrt60qc3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', 'mms7x23sfesvoau1lisjavam0mcyhb45nlze6rzgfrpm92bk1k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', 'iyz3tel853ilh7tb8ty7dj5z6e7p1duhzbgkpxi9t9k5zbuduh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('m8mp2g1poa3k4yd', 'cz8a655kz4dfmpmn8x2ml3m0dwmimx2p2dmkcqw1rdnwgxgysr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', '7d4eeymgthhxbw5s973v8v9chv5iq8j8rmb8q8m2ilak4om7kv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', 'ks124q4fbgzsb3r34c6yd74lv5c9dzbxt6r325hikxrs4fgab0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', 'r4i0lkicshzkwl4tvjar7ueujsbhkvandaqghyxzj37q7j6qzz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', '8hrv0ruwfcvv5e2t7mbzjjehafybvop6b4xsbpjkvg9xpyr51u');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', 'jixz7wim6ln1mv1w337fneq12czh4446vvq0cfoexvo05700sa');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', 'qp8wad28emot9zdpkndc1wkbg1o1m452m7eaknlch6f9w4ebyr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', 'ydazyv1k51jnnf38gs9u0yvqldypy9zgpsp3400iqu5sns0eva');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', 'rtzkw878m88t7f6yfrlxbzxwp4ebnmwydbbghnz6bz5z77yuzh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', 'c40067dv9zd9epsas1suj49nb6vql71ifndojgdi4bs6lbviil');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', 'zd5tesffyvxu1fj3jsf7kagb9i5ruupfgjo73d9noz4b1k3zap');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', 'wzoi0d4ksbguis34b3que77sk4d2zpnsfdy1jx7kohe94ewpj0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', 'kzlri9j8qr2ka21byp2212t8ijeijweflcuk1kuagkdjdkcljy');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', '5rhe6t0ngc311zeh143pkhg4v6ilx22o9g2zfs1d3s0wx7tbek');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', 'lgc9crxec39aub26xupm9ekllkxrdvb89h332ur7pxnbb0qt2z');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('l5ypcg4m55octfk', 'obty1cazf9zhbx4s1nkgi0623a4qcm06tohfd8tv6hm27ufmzp');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'm6dcfs7476kywpb8b4ohroxfqxcg7gsza70ewnfkexgsylxutx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'jixz7wim6ln1mv1w337fneq12czh4446vvq0cfoexvo05700sa');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'fougq1lkklfkiv3550bhe5dt6q1356rl4dlj52trg0x27hcz9p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'yhxthqc6kmxyp9hf9rfz4cizt9mdmc6npimjsj9bplfso7x00d');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'edijp4mii9soju9m3vuwmqq6hui829qno8f7ys0m8sv6lc0hbd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '0c5t3shjsq4hfcxzl1tnsw37mz2inl3f63561jbmxdyolo12ll');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'lt1fv1i7r130fk8u5yuyam6mms4wwa3qga4exjrkzzll6j2c96');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '2itmurzgz7kq7pfrqx1kz41d1sxz28l3o4o4qdmqazsh3tni5q');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'eluw7padfaq2sjm5c6rzyer8cx2p3rgilpqy1kmxm6zd032o58');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'jylzha3h4v7t7p0tlvf462uns7n862wypelj82b8o7e517815j');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'h5mwxrbi18dfxpszq2u5wks648ij2nptrtln4ydzs9a40bcynu');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'rqdgu0ug6gbzpb3pzn8ykvv0ezw4xkyazm4fzg9l78d3n0wflo');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'mne5ikidiqe0blvhkebn9jh66fxurzjnmufiay4nxtcg45csgw');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '90gr9px5uz2iozh5pyc8f0qh6e51d7arbhgbh90u8qa69ca2v6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'qphd10rcm849peequq3vrbpuf56i7xju8lv84f9fdfqb4q2bbm');
-- User Song Recommendations
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('hz20g8mq8kh5umxbnmmeqyve5tmihgyvcam40ep0y1c9pz58uh', 'dfsrr0py2sgq4to', 'gbmjkl8vbzjpytdybuvs58jrjzmuk0vpm3taob8wm2dosmtdui', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0x922hjepolqe7sefwdarxrut52u840fm1o2bcdm7i9iceq4zw', 'dfsrr0py2sgq4to', 'zhed2jpqah4becm1yq1kv86xeiiyit609dicjjrlajbg09vq59', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('6wgw8clx99qu2fnesy66gvdc6w58qye161652r3ft5onzwwp05', 'dfsrr0py2sgq4to', '0p6gxtabrnc0slz3868pyi66q1ypw984kk31epo9wto0f4drkq', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('szuuy3w3bpo34k17trlxyci8hndwos6rthb8gt5r2eaq1xpbcv', 'dfsrr0py2sgq4to', 'nd36mdcgl7nliksmwmzkv3qiezg2uqye7q7cqiiorglhvklbg0', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('yv640wz6ndqytvxj9wmykuuc0p5cigo8mtrqb9cni1wcep2gib', 'dfsrr0py2sgq4to', 'yhxthqc6kmxyp9hf9rfz4cizt9mdmc6npimjsj9bplfso7x00d', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('mk0gid2d0r7mjby9xbuqmqpfkphr6e88kp073ptkodkeebl3es', 'dfsrr0py2sgq4to', 'o2xvmohxt44thv2ezv3hm81syk9l4t1ax49kvo3iasbnz7bton', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('c84rllkpzxwl8pr4m1bprwhzzaj1jkmrcp17b7m061r9965f2o', 'dfsrr0py2sgq4to', 'v7xj078r1tcpzrgl5n7pwfxbwvprcm3ttvslm9iind28akvwqb', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('zglnckjnvcbitjsrjtjqvqbdrboe2m2skys5r0hmnfql7tt2jo', 'dfsrr0py2sgq4to', 'tlks3q66k29rtkticxiecwmgy4tn6wey8o0o620ybvkp0h0g25', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('297khgyi4z18987uoh549i67y1y420rjx9ssu3eg3phmx99gp8', '8d0rx3nvr3nwlqp', 'amwa2v81ec27yxaoxpxyi5hstsj4ll8341i3hm4xrdtnpwifr4', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('o6r7cw1tzqybhbozl9a446uxpwb2aj8rp9u076uu25ed7xogdw', '8d0rx3nvr3nwlqp', 'yft2vgs6am98osxiz3f70hup4dur3jqml873tmdth7yb9r4e3j', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('04f9dxt4sat3ltn4zq4j28m90jt103juxhhu5luc8c47gx8pgu', '8d0rx3nvr3nwlqp', '90xpwctkjujdfv2t924fxjemh1x7y472ygrzm1jhpgwsh3mrwt', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('84d6djbcmywluz151ybsq333y60xx49vtxdlc4ixpsdtvrr502', '8d0rx3nvr3nwlqp', 'lw6dyk6yf8unyrrx4k8dticlm3mighwtiufc77z8vsgu21uy98', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('pnbraxfmze1vxvxagdh1f6kbj6ovdisvmej2p95whs7yy7flq2', '8d0rx3nvr3nwlqp', 'tge9xuz7vo27upmvs5bspck4kx34d92o4lu1uqyhdot6blvcen', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('3n98fj7vark4g1lv9bwnfzgt00g0uyrr9dmlw1hcioor4r038y', '8d0rx3nvr3nwlqp', 'gsma76o1dkvn4a8nx4tlw49up0bcyeretm6c9rns1yqaywlk4p', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('het3ocbcggcngzunx0840q5sdkgk4nzfeg60nx8tzxsrpzn26p', '8d0rx3nvr3nwlqp', 'z7zxzk1c2qjvnska2iy53eozqbo2wcr8u0a3wklid3ifo6kc9j', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('m2dyzmy978z3nasw8zkb3cie6u4x57g7tyvfgutryrfskt8ime', '8d0rx3nvr3nwlqp', 'lsq1lk7ciifpj8q3bttwsw1ly0e7sqkn1ycx670ymn52a2minc', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('59eisgguklq77gmpi41g765q7xehcqk3ehvvrvslnrmrr8akso', 'f1gvjzbk6lwmqn4', 'axptvn6rawfbr8q7hf36lf5fmo31aqgnhli0gkcr6j8aoers5h', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0t44puxsga3fnh44z1kh5n5zz1flwrxc0xlytztaw16ww0h4bl', 'f1gvjzbk6lwmqn4', 'v7xj078r1tcpzrgl5n7pwfxbwvprcm3ttvslm9iind28akvwqb', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('oe7dwj2sjrbhucg48pmaphlhc929vo7rn5yfwf8vrypoebqpbu', 'f1gvjzbk6lwmqn4', 'lnn7zopu6qd4x2adan4z0ovuksygtmyl0xzsb8fp9q3flpkiyv', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('xdcmfhpdxo2ey5lt0g8hz2uw7bfe8xe2lv2bx2etlb2k7ullbe', 'f1gvjzbk6lwmqn4', '1469lajp4hdk7d4vrpzsmsk01pud9avpn8sy50b2elvbg13tuq', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('67kyk594h9yeje5s7bthtctmzxdac6a2t2sz4jkk55jvefl8e5', 'f1gvjzbk6lwmqn4', '4ahxlayfza4r0qs290gqrzkq2kgoq892j83ce4gypupsdxp5w0', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ppq2kj9jhurxo9tmnolfb65ft2x8cq5s9xd91viyf2w0n93lau', 'f1gvjzbk6lwmqn4', 'jugimwmkfhiqh377qw6u7hbxonbaz9uezdhzt42z8jkwlxf14y', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('raxpvvb4r91l58pedbbsaoe5phfqgw0muw7l52yv9qvhm5skv3', 'f1gvjzbk6lwmqn4', '4734w45briykngcuaxzcdxkyewervitvxgm2r78radp02tcmd6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('jbrgkzibdfxetaqhorhfek0y8rnmny0qa6e27gm4fokchy63gg', 'f1gvjzbk6lwmqn4', 'y9rlipqgb6ckcpt42gqc7y4j36pd5bvlcisr50z9fibzjfez26', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('bs1xhwatat3hwso98efkw282j44hn4lsws31g6bzcqvagpvjpn', 'a6d7c4f919os7zo', 'ohfz8zgp56q6jcgyrkp52yhaecz33tcjrg6fuvyojihtse3fav', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('j3uc53l1ntc03otnelbg339gm4bn76ilsf4wgdo2142hn6sexg', 'a6d7c4f919os7zo', 'lym4pjss984t7a9wt54nar2tzwnjmaubxoexbbbt2ai22agoe5', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('7zv0464svwe7qoyb9rkvk1jcwrxtb595iv673dn589r9gmgkfb', 'a6d7c4f919os7zo', 'u3dfv55ac6rfxnccgvar3y7u7l8rabyl654csk5rpsz76aacb8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('evug131fpcop49p5bgjusm333g3q3ekw25cv39qq5zrr3r0w4m', 'a6d7c4f919os7zo', 'hva90pm3y1z9zohkdl6tqiiq3v88h6p26kbh0n40m0q0pg3lms', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('zeu0ir4rptq4dt42sh5hm72wn3lzgdt7p3dzil5iu1z2imnsnn', 'a6d7c4f919os7zo', 'odw2oa11szdiyd3zmwvuhcdmxvpxgdkeijzep367us7gimkqma', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('j269401lftnbv58qz61d186lm8fy54rz7lkvc6volq2f1ywn41', 'a6d7c4f919os7zo', '5h93uolw8x144p70m8jjcbbbni1v2zvq8xrtyctmmtl4u9pm6b', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8vvf1csmxjei4vt2bkw1qbl5xojkyrafeapltj53n42s27z8ko', 'a6d7c4f919os7zo', 'pgreemwv8od5a1oyhh1vhzzkw1k0vrss0l3toq2poo21g9l0c4', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ngfupauuwsgk5s0l1sssvp8f2nqceby37nrw7wmthcql9xcdpk', 'a6d7c4f919os7zo', 'tge9xuz7vo27upmvs5bspck4kx34d92o4lu1uqyhdot6blvcen', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('s9pphdz4naqbacj43lq5f8x3smnrnm4foroq41z5j2s96kz375', 'wswnd71f751io1o', '030fshng3pldbnkpmlq0tdvv2uyzsy8ym8pn1cm0d8tx7qpl0i', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('9c0gu3327f8r4eoo59xqkke4uy5gk5f9xblsxwt7alnihc0mfz', 'wswnd71f751io1o', 'cicq34rpu6fr79in0gqg872dplyya9i4pibyvqchf2ippl8fq8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('h2txrw0mav2d8da7155w4wdrtgjbub9b51skmzmgxzdbf421lo', 'wswnd71f751io1o', '6sfkfnhjx0cf19ibnf9w3svbzaltmezm1wzlbiqtorlps5uy1t', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('dyq6gqb1s4ki3uxcjts9hllz2fpl42n42gdjdp9blh0uzi1y29', 'wswnd71f751io1o', 'l6h6gaqzz2hm7hz8e6lt0590htsy4r9l7qozb61c4wv9oqk45l', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('2p9p7byi5k3qjqsm01po1qtxitwnw6pq7fqoiuthh7hlucbqb2', 'wswnd71f751io1o', 's7kxdz5nnfa80wzkgjahju26yc3e9wgs1yem00e0r1jw4gbvsy', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('cdndgvshnwkz8ve3nsewund3br3k7hmmo1bgiko6036uoqt3zq', 'wswnd71f751io1o', 'cm5lzazo6lp6x1vd4ch5dyjj00hupvcv8pvhn40029qwn4nu0b', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('old1m996wzzye456wkxgh4euzj5dpyfcax6xwdrgflusaur9rw', 'wswnd71f751io1o', '1ko1l9qu1tcgavj3kjnmmp3kjeqbnueowbzgkd8oabn3t3ww9n', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('vzueyxxad2axrcm11obvbrkz91kzvmzq4xl79jp4ngl21adv2z', 'wswnd71f751io1o', 'w30sbs0awylgmisnrqpaqpdpisdx5unr1du70u8v8av0bn77wz', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('h0pp5xblmesd4cq7ic7rqma58ticfygihets5bxbnhv3uj6nji', 'yjdjyvny7lk8wzl', '0o95ru4pcsxxxnq1171cxlwffse84btsro6px7rsw3yasnzmig', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('9w1xx653cgrv0inqhvwmvcfe3e9rgi3pt9mhj67egqvrfdgb8x', 'yjdjyvny7lk8wzl', 'yakturmstvk954ahsolky3uq47zhnxlpg22mpdxo8qarigiem9', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('7gdv2ny04cdu34f72zy7w6swi12lq06ovn9g6732rv75pv1i7t', 'yjdjyvny7lk8wzl', 'hrixznkb5lro49xcrzdfwn5ylsaqgyqlrkpzy79tzy3tmaoa1g', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('hderwuhdhs0or4o7m8sjrgcqz50tsxb5xtbehtg1b34x8am04u', 'yjdjyvny7lk8wzl', 'rjbl6481fpbwml7o0v9m3q2p5hjjpbgupq7hd78w0w9fnz9e38', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('h27veocr8c49l5cwj1bsxdks7j13v4qir0r2bhroi5xkt96leq', 'yjdjyvny7lk8wzl', '2sn9jjav2xuojyzxt794y8o3q1i75ap4caf4n5ts5xr06jurdn', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('zw739gwt2c7x80zkana8ajz5r27wn3dd9rteldm4w7oqfvwk5d', 'yjdjyvny7lk8wzl', 'n1u8i4yvec1fljgnewcbj6tebcmrg17ay1hrer6qs20tnbg7dq', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('g7ltde4vu6hrod1bk2bo52gdwvew0t9mwspxxvvg228s79u20q', 'yjdjyvny7lk8wzl', '0p6gxtabrnc0slz3868pyi66q1ypw984kk31epo9wto0f4drkq', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('6div7v9qhbiqsgk5jpf2x1sh7mpvv1jlsm3xwszz83i5yi3oeu', 'yjdjyvny7lk8wzl', 'ptv9crgffyaev9siuh4ikgkcho7a0v4sfv3fakrityasc5p12r', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('qhhd51lpvah29voroaubqbmt6btynv5vqx48wtp5yme6f1w9eo', 'xiobm7toessywvu', 'v0ldqt3ko14zmjf1ns5scgn90oen6ctr78oa1a4jmx0tcz6x6h', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('uxegeas5gcpmflfehovbir55zmhylhkmzictjj5r236dcd0g3c', 'xiobm7toessywvu', 'kz9ysq50m9tbtf9pysozhi3oakjnld35f8egnsw5t0awnocend', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8csz00soay74tplndy7vbou7pzno7zy3v9nklrs5yemzt60o4i', 'xiobm7toessywvu', 'fd41v85xqpnnm9eeehn7avswketycvm2hut6d2ttvmpeu5ys4p', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('blsz3x0lb91b337xeye9tl7zufya0oxz2qp6wngasm07fih7hu', 'xiobm7toessywvu', 'c40067dv9zd9epsas1suj49nb6vql71ifndojgdi4bs6lbviil', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('vjj2zl7sndj7b1qlpcpar5364vuaiv99xqascg4au17snrniti', 'xiobm7toessywvu', 'ks124q4fbgzsb3r34c6yd74lv5c9dzbxt6r325hikxrs4fgab0', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wojruzcjl8zlwzdbpnbei2v76w5nz43tg38xe3ytfwjrzgvlsf', 'xiobm7toessywvu', 'japchheriv543qiz6uokyb6ktsmp7lywrcsdsczvrwnoz765bn', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('xi6dr5blhl20uhkr13lgwr6wqbyhn8fzh8811mhnqvr3pxs6g9', 'xiobm7toessywvu', 'u5duhtcjoiusdk7ubci7tzdwpgy98h4wzp761y5r7ttvh17zsz', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('4n34lemneot02bv2sceoaud1g5bqt5bx2gc8bw7glkmm8aqwhl', 'xiobm7toessywvu', 'gz9rv3t3755r4ho3rrs4cbulfly5dk4goxz14j4ex5tw6uts9f', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('eb2cduigrj1jr6uooi4lnh5b9xx6akg3qjq8k1a57i91z92t28', '19skjpxffj12xnx', 'jspw66hnvfxff58q4ow5pk8er3j06ivi2x2wl19j8gdlsizh1d', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('7oxeq7c83ntvjgxfx3e7yuyb82xb0v45c6qlk7jh4zanvdq7fz', '19skjpxffj12xnx', 'y9rlipqgb6ckcpt42gqc7y4j36pd5bvlcisr50z9fibzjfez26', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('zqnty3y3wjjwq0myubg2nzhv1e7owl6q26tk3zwe4d9ajvfj2i', '19skjpxffj12xnx', 'japchheriv543qiz6uokyb6ktsmp7lywrcsdsczvrwnoz765bn', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('to69a0yxueps8daq2olsfqgj3c2etqlh6xrxmwlsixe7d4z4wm', '19skjpxffj12xnx', 'hrtqgf3ws2lc5u4w5da36rr8f4e8juqp4hl03bbogrervkx4m5', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ci91kcnacjqq5xj74251jd54u4g8dqzzk73cqw4lhf2oxxstwt', '19skjpxffj12xnx', 'kxrfal4jzq0qji4oeegf0u1vzxt9nidz12g1x0x5hselfu2f0z', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('36glfqs67ony6d4j76ejh0bxc4clj2ce7603j5jqx1tmvjgs81', '19skjpxffj12xnx', 'ljrh5yha8czj4ef9ynfna38r1ebcnlo0dm9za94dx5dk4vjgap', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('605c4kqazzgf86x7lx4kbql5qtyclxoi1v3nccigedcuv8tpx3', '19skjpxffj12xnx', 'z2whyg00utf9eeuucf08akfwj3ph8bu8ui791gj2j4k20908q1', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('b6z5vc554w3zj2yluuzpdm6k8bo7vzwitx4s5a4mkrtnf0f21l', '19skjpxffj12xnx', 'lqettnxt2tv9867d2p1wby1nv3pillfnsenqyxjv6sv6netad1', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ojj7e8p93yvstavtbg3uyuo449mhb27jafeya770mpr6yaimrp', 'm8mp2g1poa3k4yd', '6bhwxtq98oezoq60id15mgmms85fx44lbj9n1a48ye2af1ux0p', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('c6vj5e55e8e4za848ngv7tzwfi9gplabexsyrwukl9m2sg5lzc', 'm8mp2g1poa3k4yd', 'fbaixe1v2554tkdr36y53oijbr0yoshaieb3k9autjmk9z79zn', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ph5mcay66ivf3ojyab8pjrf41yc66ur65uv7rn554telvx0qf3', 'm8mp2g1poa3k4yd', 'ubxrsbo11ix1dikkapo5zi1xwp1nnyc3y1z71btlj96o2awfq3', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ep18kl7rq4lcwq0g7ti0ruzuh0d6hw07026j5uairzlkqvmlbl', 'm8mp2g1poa3k4yd', 'r31uu0j0pp3yhqxezuu9ovobqzu17pf81lmldjlxbpul6ukxw7', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5n5hy1meyu3b7raotbls8xhfz7p3rk7nv8gi853tlijjtdz3fi', 'm8mp2g1poa3k4yd', 'fqrtwpl858mru5yn72c6k9ruxoxq4pi80h6av55g42msknbfob', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('jg202o3co4rids3l3inuz5ozoky4l3bcjp9gzq7uy7vrj2lmak', 'm8mp2g1poa3k4yd', 't7zk3ftk1mewdw3579t8qmcpqr3u4yttv8i204sdulgp6xb8k6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('bnjmt2z1yxv0zs90chgacb39da17zuffcmrunyxex04zk9cyyk', 'm8mp2g1poa3k4yd', 'znbf4pyo1xj0qukamnk2munluak9tj7p1wt5it802o6khem5np', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0awkcaolllh1bg5s3ab67n0prb2l08s9zypsvob18wyjjs842c', 'm8mp2g1poa3k4yd', '50i1u5o6tvhd53z91w3wed0jorm4auencw5ez47kqovw023g3e', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('zmc15lsd8neia6xrii8h1it8wazgmn8kfezwzino3jr3l6bohs', 'l5ypcg4m55octfk', 'atkximlqlt8ka6gwuqe7qw2kqk6qcz4ooayqld9dgmpo6slx3t', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('62wqi0bbfd8tw4ppdwoo3hy11x3x3n5jv2t945pxkci4uvqig1', 'l5ypcg4m55octfk', '04418uxddzco6p0nzxfsmusyojbegxndtgmny7m4xrpzyy4ltc', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('jaleq26mfx4l9dg2018wpzfj1u3831my0y5z4rnqyqr9cl7xy4', 'l5ypcg4m55octfk', 'd0wxk9mz2ad65g99o8b5re5wsqe21wuhgjvejh0pvqznn4r5aj', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('qaz82yp99ecuiij292r897cumi8lhhyyc5a7cdtu2380fo5fvk', 'l5ypcg4m55octfk', 'qgglzne052bhqdq5055dz3l4anbfje2mfxcevtle26yzc1xgz6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('yvjirxki1j6hjwixcenf54kpxs5kk3vaycb0lwqhhgb8ch53mt', 'l5ypcg4m55octfk', 'xp1qdaz3baibppo754cnuchwhk6u5u37exa9yc6bqory29q0cd', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('pb9sl7c4xumgj3dbmdzabnybifd9smi0g082bvcpdqtoyiv3em', 'l5ypcg4m55octfk', 'znbf4pyo1xj0qukamnk2munluak9tj7p1wt5it802o6khem5np', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('6yxeu3s9c9nww9ylbdwpmqhlopm4da7cgn2edcpqf2rjx6a9m9', 'l5ypcg4m55octfk', 'jylzha3h4v7t7p0tlvf462uns7n862wypelj82b8o7e517815j', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5u1a5auhc1t32qtj4oyv6tn0bsixaicxcxunirtnnyweyv6441', 'l5ypcg4m55octfk', '2qujvt447nfe5hfct1r6i9xtsf17gdl46yrv3yhamnjvg42lqa', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('llcgtuzlmspe1hx81zeqg8ft40v64pwpw9exvkk51j5bejp1jn', 'icqlt67n2fd7p34', '0wiked3hah17pphps4gdjf543rt4m5pz8b5tx75encko29imb4', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('9s00xv1biwdarc75jiwp76wundtr7zzy60kknuzp0zszl8hauc', 'icqlt67n2fd7p34', 'gdxujvn7db85d2zke34hsxvpro0i4slusi0wcbg97cj3jusxnf', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('59t29oqs4tdrthq8u5ha0uak786r9xshfm3v0jgwwmuu5l1f14', 'icqlt67n2fd7p34', '3k9tczh4c90prmyuovap3vbsgpbwrbf5a31kkwle09ev8t5oy2', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('xuw5iicwkc7k63o1mhlsj75cx028uizi0dw4e9hkzouhslrwct', 'icqlt67n2fd7p34', 'nyiq27y3fgmyan8poag54i4c2k1k9mamuno5jnrrv4chaqjpr5', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('j4b8myf0se3d8vqp8olwsadqkg9tfodq3ok9piclq23h73hgek', 'icqlt67n2fd7p34', 'ouojlg9gz6mn4kdudb1pbfzzrj8jolecdqpz8lbazvsy93pexi', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('gnw0nbuod72owu2ag102jm09danp0mvhcaj858szlyvim91zfm', 'icqlt67n2fd7p34', 'c4wkbpbuvacq77zqqihgjyn48bvu1nsv7oapjhm4ytrzf2n5ms', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('52s68mt8kk46hpyoxkdua7o5p7gm2gply6z7xp0i3jobrg1rqw', 'icqlt67n2fd7p34', 'bxcc08mnul04vj5du217k0trluihmru1rb2cfc3gm6f9kw4f0c', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('rm66wztonjuin1ry5xs8kdzgtt5uep0r5pybw7qaxrer4lqvi5', 'icqlt67n2fd7p34', 'vot29nzci5e8ypvya1typkq8p7xxi3epggmc0qxciwjslcekb6', '2023-11-17 17:00:08.000');


