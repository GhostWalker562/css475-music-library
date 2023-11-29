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
-- Abhijay Sharma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ahsullji8ebny31', 'Abhijay Sharma', '0@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf58e0bff09fc766a22cd3bdb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:0@artist.com', 'ahsullji8ebny31', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ahsullji8ebny31', 'Where words fail, my music speaks.', 'Abhijay Sharma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xp2dzpg70bgozc5a5apr2kqg25vd1aefp23qalgez19i5ble2b','ahsullji8ebny31', NULL, 'Abhijay Sharma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8cs9e9t89c50mp58zwyza04n5t4hbdk3o1axpzy8xwplxic2c9','Obsessed','ahsullji8ebny31',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xp2dzpg70bgozc5a5apr2kqg25vd1aefp23qalgez19i5ble2b', '8cs9e9t89c50mp58zwyza04n5t4hbdk3o1axpzy8xwplxic2c9', '0');
-- Beyonc
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('23djeqpx3gpv6zk', 'Beyonc', '1@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12e3f20d05a8d6cfde988715','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:1@artist.com', '23djeqpx3gpv6zk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('23djeqpx3gpv6zk', 'An endless quest for musical perfection.', 'Beyonc');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('td60m9yf4es0vbegzpgsygpw8ewska39djdha3nbq40cycfoll','23djeqpx3gpv6zk', 'https://i.scdn.co/image/ab67616d0000b2730e58a0f8308c1ad403d105e7', 'Beyonc Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j7m56v61a832fcdn55o8j3u4qk76owiqq9gmxhg3q1c80bspxo','CUFF IT','23djeqpx3gpv6zk',100,'POP','1xzi1Jcr7mEi9K2RfzLOqS','https://p.scdn.co/mp3-preview/1799de9ff42644af9773b6353358e54615696f19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('td60m9yf4es0vbegzpgsygpw8ewska39djdha3nbq40cycfoll', 'j7m56v61a832fcdn55o8j3u4qk76owiqq9gmxhg3q1c80bspxo', '0');
-- Peggy Gou
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x56tca2yi69870c', 'Peggy Gou', '2@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf5c17aa075c03c5c4d2c693','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:2@artist.com', 'x56tca2yi69870c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x56tca2yi69870c', 'A dynamic force in the electronic music scene, known for her eclectic mixes.', 'Peggy Gou');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vl9hhiodhyvpfd1asy6wnondptz1yuajjwaaival6fnbsp2e0z','x56tca2yi69870c', 'https://i.scdn.co/image/ab67616d0000b27388d71aadd009fe1a83df88f2', 'Peggy Gou Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a8uyg4z9sa8gkze9j5l1pwe4xiuv5y7ka5s0m52vjvq17us2hf','(It Goes Like) Nanana - Edit','x56tca2yi69870c',100,'POP','23RoR84KodL5HWvUTneQ1w','https://p.scdn.co/mp3-preview/e36e0bd4714844f1f9d992398b41a3e333f15cc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vl9hhiodhyvpfd1asy6wnondptz1yuajjwaaival6fnbsp2e0z', 'a8uyg4z9sa8gkze9j5l1pwe4xiuv5y7ka5s0m52vjvq17us2hf', '0');
-- Karol G
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ktdbjmo013melvk', 'Karol G', '3@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb284894d68fe2f80cad555110','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:3@artist.com', 'ktdbjmo013melvk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ktdbjmo013melvk', 'A queen of reggaeton, known for her empowering anthems and vibrant performances.', 'Karol G');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lbv8y80ho7lw433wvx9ys2kvkylm7r2ffgyai0oh0pozjx2l5v','ktdbjmo013melvk', 'https://i.scdn.co/image/ab67616d0000b27382de1ca074ae63cb18fce335', 'Karol G Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n6tvw8cljpyo82pd1lk0yn56rubcisl5jinv6fdzfym7ex9and','TQG','ktdbjmo013melvk',100,'POP','0DWdj2oZMBFSzRsi2Cvfzf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbv8y80ho7lw433wvx9ys2kvkylm7r2ffgyai0oh0pozjx2l5v', 'n6tvw8cljpyo82pd1lk0yn56rubcisl5jinv6fdzfym7ex9and', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('thn2ddsyzxqhe4f41p5ailas7zq347mjoq4uu9i5yul68x0838','AMARGURA','ktdbjmo013melvk',100,'POP','505v13epFXodT9fVAJ6h8k',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbv8y80ho7lw433wvx9ys2kvkylm7r2ffgyai0oh0pozjx2l5v', 'thn2ddsyzxqhe4f41p5ailas7zq347mjoq4uu9i5yul68x0838', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qrkj2855wna5334fg9rx8tvnccn635gbv0mn049snsrbq5vl4i','S91','ktdbjmo013melvk',100,'POP','7EpOXgSRgnglRWr86pZfGU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbv8y80ho7lw433wvx9ys2kvkylm7r2ffgyai0oh0pozjx2l5v', 'qrkj2855wna5334fg9rx8tvnccn635gbv0mn049snsrbq5vl4i', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gf80ekmzuh8hzsl3v9c39zv08mijkenef3y97x3djuorkc6urt','MIENTRAS ME CURO DEL CORA','ktdbjmo013melvk',100,'POP','6otePxalBK8AVa20xhZYVQ',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbv8y80ho7lw433wvx9ys2kvkylm7r2ffgyai0oh0pozjx2l5v', 'gf80ekmzuh8hzsl3v9c39zv08mijkenef3y97x3djuorkc6urt', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lq763e0cys0o37tu1r3lnti6kme18zap4nkv250qqp00gedzzo','X SI VOLVEMOS','ktdbjmo013melvk',100,'POP','4NoOME4Dhf4xgxbHDT7VGe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbv8y80ho7lw433wvx9ys2kvkylm7r2ffgyai0oh0pozjx2l5v', 'lq763e0cys0o37tu1r3lnti6kme18zap4nkv250qqp00gedzzo', '4');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rqnii27986x5q93kh3d1vx2var0zz7uc6gda6cmtbr1qf8xzyq','PROVENZA','ktdbjmo013melvk',100,'POP','3HqcNJdZ2seoGxhn0wVNDK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbv8y80ho7lw433wvx9ys2kvkylm7r2ffgyai0oh0pozjx2l5v', 'rqnii27986x5q93kh3d1vx2var0zz7uc6gda6cmtbr1qf8xzyq', '5');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1iwdtao3rgfvq0pc54hl732r8jo99x0fodpbk4jl97jhc3vo59','CAIRO','ktdbjmo013melvk',100,'POP','16dUQ4quIHDe4ZZ0wF1EMN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbv8y80ho7lw433wvx9ys2kvkylm7r2ffgyai0oh0pozjx2l5v', '1iwdtao3rgfvq0pc54hl732r8jo99x0fodpbk4jl97jhc3vo59', '6');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qzb6mnrj9eslft884ch8r9yr3kyg5wdrxc0d1yplk4pb6b24of','PERO T','ktdbjmo013melvk',100,'POP','1dw7qShk971xMD6r6mA4VN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lbv8y80ho7lw433wvx9ys2kvkylm7r2ffgyai0oh0pozjx2l5v', 'qzb6mnrj9eslft884ch8r9yr3kyg5wdrxc0d1yplk4pb6b24of', '7');
-- El Chachito
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f5crrjc1x74mz1d', 'El Chachito', '4@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5ccab5d3dc10a08d89cbd76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:4@artist.com', 'f5crrjc1x74mz1d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('f5crrjc1x74mz1d', 'Pioneering new paths in the musical landscape.', 'El Chachito');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kqkb4y8bijnk5jd9ghxj2g43uipey78d3q1w8b4iog6itgkipm','f5crrjc1x74mz1d', 'https://i.scdn.co/image/ab67616d0000b27354c372ef8e7b53bb3c932ac5', 'El Chachito Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rcle0a9vsf8cpr2j6238t3i94niuwugiknt2v9gn4ah4gcea1i','En Paris','f5crrjc1x74mz1d',100,'POP','1Fuc3pBiPFxAeSJoO8tDh5','https://p.scdn.co/mp3-preview/c57f1229ca237b01f9dbd839bc3ca97f22395a87?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kqkb4y8bijnk5jd9ghxj2g43uipey78d3q1w8b4iog6itgkipm', 'rcle0a9vsf8cpr2j6238t3i94niuwugiknt2v9gn4ah4gcea1i', '0');
-- Baby Tate
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j94rtn5wm78h9l9', 'Baby Tate', '5@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe7b0d119183e74ec390d7aec','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:5@artist.com', 'j94rtn5wm78h9l9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j94rtn5wm78h9l9', 'Igniting the stage with electrifying performances.', 'Baby Tate');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i2z7a5ahtqyik1z6cqi1hsi55w8z815u4ksprvmzh49rayqmjr','j94rtn5wm78h9l9', 'https://i.scdn.co/image/ab67616d0000b2732571034f34b381958f8cc727', 'Baby Tate Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rnqdpxun73990bmoge9qoltmos0ck6vya8vz5h9sov9gv55waz','Hey, Mickey!','j94rtn5wm78h9l9',100,'POP','3RKjTYlQrtLXCq5ncswBPp','https://p.scdn.co/mp3-preview/2bfe39402bec233fbb5b2c06ffedbbf4d6fbc38a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i2z7a5ahtqyik1z6cqi1hsi55w8z815u4ksprvmzh49rayqmjr', 'rnqdpxun73990bmoge9qoltmos0ck6vya8vz5h9sov9gv55waz', '0');
-- Gustavo Mioto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tww83eimekmjiza', 'Gustavo Mioto', '6@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcec51a9ef6fe19159cb0452f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:6@artist.com', 'tww83eimekmjiza', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tww83eimekmjiza', 'Elevating the ordinary to extraordinary through music.', 'Gustavo Mioto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('b4lkr3ilmg4l4sv7l4mak36m5fc86fsdvte4ug74zv1exf5v3c','tww83eimekmjiza', 'https://i.scdn.co/image/ab67616d0000b27319bb2fb697a42c1084d71f6c', 'Gustavo Mioto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('734fldn4e4irgcosqvnbud9lxl915yhyo803ex4ib0xqpgn90e','Eu Gosto Assim - Ao Vivo','tww83eimekmjiza',100,'POP','4ASA1PZyWGbuc4d9N8OAcF',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('b4lkr3ilmg4l4sv7l4mak36m5fc86fsdvte4ug74zv1exf5v3c', '734fldn4e4irgcosqvnbud9lxl915yhyo803ex4ib0xqpgn90e', '0');
-- Pritam
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gl7mms4n9btm54x', 'Pritam', '7@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcb6926f44f620555ba444fca','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:7@artist.com', 'gl7mms4n9btm54x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gl7mms4n9btm54x', 'The architect of aural landscapes that inspire and captivate.', 'Pritam');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1rqwbz6vkniq2c7bi6zg8omutm7ic2sm7l8ul4rbu4zx1bqr9t','gl7mms4n9btm54x', NULL, 'Pritam Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p3dgb35do2n3wto2hp2llvxd4cbwko8p0cd5u3wgpz30r1v6t8','Kesariya (From "Brahmastra")','gl7mms4n9btm54x',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1rqwbz6vkniq2c7bi6zg8omutm7ic2sm7l8ul4rbu4zx1bqr9t', 'p3dgb35do2n3wto2hp2llvxd4cbwko8p0cd5u3wgpz30r1v6t8', '0');
-- Yahritza Y Su Esencia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dqqkn2fra5kzlcz', 'Yahritza Y Su Esencia', '8@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68d4ccdc175f594122f1eee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:8@artist.com', 'dqqkn2fra5kzlcz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dqqkn2fra5kzlcz', 'Infusing traditional melodies with youthful vigor.', 'Yahritza Y Su Esencia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hmn5hc3dc15aif8zijf6o1zkpuw1gz3f61x84cbcyszt86td7n','dqqkn2fra5kzlcz', NULL, 'Yahritza Y Su Esencia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w2cjfrjiq4nn730h1d2fsuczl19djacx06pfp7w17ofchvsssv','Frgil (feat. Grupo Front','dqqkn2fra5kzlcz',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hmn5hc3dc15aif8zijf6o1zkpuw1gz3f61x84cbcyszt86td7n', 'w2cjfrjiq4nn730h1d2fsuczl19djacx06pfp7w17ofchvsssv', '0');
-- Mambo Kingz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9hl9w898x5fqhfd', 'Mambo Kingz', '9@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb881ed0aa97cc8420685dc90e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:9@artist.com', '9hl9w898x5fqhfd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9hl9w898x5fqhfd', 'Revolutionizing the music scene with innovative compositions.', 'Mambo Kingz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('h0fxm52mlvte68snelxu2o68sd65l72j7ah7310q4dq6o27e9a','9hl9w898x5fqhfd', NULL, 'Mambo Kingz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('58drw2imi6rtjgwugl3w2fobhn7qm71muvp58m0yhzfb3akqii','Mejor Que Yo','9hl9w898x5fqhfd',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h0fxm52mlvte68snelxu2o68sd65l72j7ah7310q4dq6o27e9a', '58drw2imi6rtjgwugl3w2fobhn7qm71muvp58m0yhzfb3akqii', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7bb8fhvbhbd36bk97nb8y0orxt5k2e3pnwvu1rusj2k6i9ojq2','Mas Rica Que Ayer','9hl9w898x5fqhfd',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h0fxm52mlvte68snelxu2o68sd65l72j7ah7310q4dq6o27e9a', '7bb8fhvbhbd36bk97nb8y0orxt5k2e3pnwvu1rusj2k6i9ojq2', '1');
-- Central Cee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gex8jxg3si16wk0', 'Central Cee', '10@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5fe7cabb8de1c0266cd2179c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:10@artist.com', 'gex8jxg3si16wk0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gex8jxg3si16wk0', 'Pushing the boundaries of sound with each note.', 'Central Cee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wptdghzwkppk9ybfclg2esjovbvb8ilatbib0wt5p8p4pfdgtr','gex8jxg3si16wk0', 'https://i.scdn.co/image/ab67616d0000b273cbb3701743a568e7f1c4e967', 'Central Cee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7rppdo77rxww27y01r70tgr4m5ak54xneaffd0s0mjpjphxsn0','LET GO','gex8jxg3si16wk0',100,'POP','3zkyus0njMCL6phZmNNEeN','https://p.scdn.co/mp3-preview/5391f8e7621898d3f5237e297e3fbcabe1fe3494?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wptdghzwkppk9ybfclg2esjovbvb8ilatbib0wt5p8p4pfdgtr', '7rppdo77rxww27y01r70tgr4m5ak54xneaffd0s0mjpjphxsn0', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r1oa1yvo6uofvmer7z9j2jvwf0391y8o9qmvtt3fct766i8be0','Doja','gex8jxg3si16wk0',100,'POP','3LtpKP5abr2qqjunvjlX5i','https://p.scdn.co/mp3-preview/41105628e270a026ac9aecacd44e3373fceb9f43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wptdghzwkppk9ybfclg2esjovbvb8ilatbib0wt5p8p4pfdgtr', 'r1oa1yvo6uofvmer7z9j2jvwf0391y8o9qmvtt3fct766i8be0', '1');
-- Tyler The Creator
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('las32qojmt45ogr', 'Tyler The Creator', '11@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:11@artist.com', 'las32qojmt45ogr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('las32qojmt45ogr', 'Pushing the boundaries of music with unique style and bold lyrics.', 'Tyler The Creator');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('eqe4k22ny0x3lfn0mbatjhyyuthbmh1ouzdcybbsma7lyjqxs6','las32qojmt45ogr', 'https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3', 'Tyler The Creator Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sxoihd91y8jll6zwathn4k2otkek4tzxyn0yic3hvbg2dcpkz7','See You Again','las32qojmt45ogr',100,'POP','7KA4W4McWYRpgf0fWsJZWB','https://p.scdn.co/mp3-preview/c703198293891e3b276800ea6b187cf7951d3d7d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eqe4k22ny0x3lfn0mbatjhyyuthbmh1ouzdcybbsma7lyjqxs6', 'sxoihd91y8jll6zwathn4k2otkek4tzxyn0yic3hvbg2dcpkz7', '0');
-- Olivia Rodrigo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('it5dd2fygw5b22z', 'Olivia Rodrigo', '12@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe03a98785f3658f0b6461ec4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:12@artist.com', 'it5dd2fygw5b22z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('it5dd2fygw5b22z', 'A new voice in pop, channeling raw emotions into her songs.', 'Olivia Rodrigo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('io4h6w0w6ncq8xqhbs6osthn6nixe8juu37syf3lf5ix5y3in7','it5dd2fygw5b22z', 'https://i.scdn.co/image/ab67616d0000b273e85259a1cae29a8d91f2093d', 'Olivia Rodrigo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o3onyhi414lzk7uvkuif12we5kx7y1kk6fdgsvw2mx5vts54qy','vampire','it5dd2fygw5b22z',100,'POP','1kuGVB7EU95pJObxwvfwKS',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('io4h6w0w6ncq8xqhbs6osthn6nixe8juu37syf3lf5ix5y3in7', 'o3onyhi414lzk7uvkuif12we5kx7y1kk6fdgsvw2mx5vts54qy', '0');
-- J. Cole
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0d8aqwdcrxwpygn', 'J. Cole', '13@artist.com', 'https://i.scdn.co/image/ab67616d0000b273d092fc596478080bb0e06aea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:13@artist.com', '0d8aqwdcrxwpygn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0d8aqwdcrxwpygn', 'A profound lyricist and rapper, known for his thought-provoking music.', 'J. Cole');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dfcskprcmvjwa1m2niwmewrztl764ro8jab76dmzr2cpjdod73','0d8aqwdcrxwpygn', NULL, 'J. Cole Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gvhlkk65cmt686j8xmg7dgewbj22jd9laavoze2ddehou8e1om','All My Life (feat. J. Cole)','0d8aqwdcrxwpygn',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dfcskprcmvjwa1m2niwmewrztl764ro8jab76dmzr2cpjdod73', 'gvhlkk65cmt686j8xmg7dgewbj22jd9laavoze2ddehou8e1om', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j8yrdt14x2hgxqwxjaadkw5onlpy8zrr3mqtqoqnhv04jb7f0n','No Role Modelz','0d8aqwdcrxwpygn',100,'POP','68Dni7IE4VyPkTOH9mRWHr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dfcskprcmvjwa1m2niwmewrztl764ro8jab76dmzr2cpjdod73', 'j8yrdt14x2hgxqwxjaadkw5onlpy8zrr3mqtqoqnhv04jb7f0n', '1');
-- Mc Livinho
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('i6acurz35lvy3t2', 'Mc Livinho', '14@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd353ef9564cfbb5f2b3bffb2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:14@artist.com', 'i6acurz35lvy3t2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('i6acurz35lvy3t2', 'Bringing Brazilian funk rhythms to the global music stage.', 'Mc Livinho');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('k4vmbegnp4475rqpgufckrurqblvhr62spb25f2sdbx1fkn85k','i6acurz35lvy3t2', 'https://i.scdn.co/image/ab67616d0000b273369c960fed23353176da1218', 'Mc Livinho Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tei3biod3oz43yxsd8p7ldcouanyx9n2pgz4pummj98vzyakne','Novidade na ','i6acurz35lvy3t2',100,'POP','2uhw2oYbugGJbn10wipNX5','https://p.scdn.co/mp3-preview/6bff8c1079d87a672d6b9ee5c3c6ca5e7d9ff45b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k4vmbegnp4475rqpgufckrurqblvhr62spb25f2sdbx1fkn85k', 'tei3biod3oz43yxsd8p7ldcouanyx9n2pgz4pummj98vzyakne', '0');
-- One Direction
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v1dwmnidr95tccl', 'One Direction', '15@artist.com', 'https://i.scdn.co/image/5bb443424a1ad71603c43d67f5af1a04da6bb3c8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:15@artist.com', 'v1dwmnidr95tccl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v1dwmnidr95tccl', 'Sculpting soundwaves into masterpieces of auditory art.', 'One Direction');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7ah0gqnw0y4fopc1kkesr46gkuryi609ri9oczcmilk234w03i','v1dwmnidr95tccl', 'https://i.scdn.co/image/ab67616d0000b273d304ba2d71de306812eebaf4', 'One Direction Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7uawvdth7x41pdztnaa2dy8rbunme94xiqv8wetypd3lw3bmlr','Night Changes','v1dwmnidr95tccl',100,'POP','5O2P9iiztwhomNh8xkR9lJ','https://p.scdn.co/mp3-preview/359be833b46b250c696bbb64caa5dc91f2a38c6a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7ah0gqnw0y4fopc1kkesr46gkuryi609ri9oczcmilk234w03i', '7uawvdth7x41pdztnaa2dy8rbunme94xiqv8wetypd3lw3bmlr', '0');
-- Omar Apollo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bbsn94opxfpznu5', 'Omar Apollo', '16@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0e2a3a2c664a4bbb14e44f8e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:16@artist.com', 'bbsn94opxfpznu5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bbsn94opxfpznu5', 'Uniting fans around the globe with universal rhythms.', 'Omar Apollo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wevctysdpvvtu1qdacgsiyzyyxl53u5blm54akr5jbi0yahfyg','bbsn94opxfpznu5', 'https://i.scdn.co/image/ab67616d0000b27390cf5d1ccfca2beb86149a19', 'Omar Apollo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2cetur68jufyehm8m4yml4pygk62sl8kvusktn4ccj1lk56y4z','Evergreen (You Didnt Deserve Me A','bbsn94opxfpznu5',100,'POP','2TktkzfozZifbQhXjT6I33','https://p.scdn.co/mp3-preview/f9db43c10cfab231d9448792464a23f6e6d607e7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wevctysdpvvtu1qdacgsiyzyyxl53u5blm54akr5jbi0yahfyg', '2cetur68jufyehm8m4yml4pygk62sl8kvusktn4ccj1lk56y4z', '0');
-- Ozuna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nan5ws2sbwjukud', 'Ozuna', '17@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd45efec1d439cfd8bd936421','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:17@artist.com', 'nan5ws2sbwjukud', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nan5ws2sbwjukud', 'Dominating reggaeton and Latin trap with catchy tunes and charismatic energy.', 'Ozuna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qhve1nsciuvuf72a6lrkqrcttaxbs318xpus1qgeoetm1dmr7r','nan5ws2sbwjukud', 'https://i.scdn.co/image/ab67616d0000b273125624f2e04f5a1ccb0dfb45', 'Ozuna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('alkjit6lqgk9p8zyuzrdmmfnoi1etpam2iqpawy7tpxvan8xmw','Hey Mor','nan5ws2sbwjukud',100,'POP','1zsPaEkglFvxjAhrM8yhpr','https://p.scdn.co/mp3-preview/cd2d2242b748408da15c2b66f47d54b3f0793ae0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qhve1nsciuvuf72a6lrkqrcttaxbs318xpus1qgeoetm1dmr7r', 'alkjit6lqgk9p8zyuzrdmmfnoi1etpam2iqpawy7tpxvan8xmw', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uuyapyku2odk9bvhrgfguqi97kw3do1wovwjkcqwr9xfe60ldy','Monoton','nan5ws2sbwjukud',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qhve1nsciuvuf72a6lrkqrcttaxbs318xpus1qgeoetm1dmr7r', 'uuyapyku2odk9bvhrgfguqi97kw3do1wovwjkcqwr9xfe60ldy', '1');
-- Kanii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ibpr8145ljzkh2t', 'Kanii', '18@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb777f2bab9e5f1e343c3126d4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:18@artist.com', 'ibpr8145ljzkh2t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ibpr8145ljzkh2t', 'Crafting a unique sonic identity in every track.', 'Kanii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('je1or295rlj3w6hn4b9dw5jd56quj7dwrq6dl2iwkdu94r7el4','ibpr8145ljzkh2t', 'https://i.scdn.co/image/ab67616d0000b273efae10889cd442784f3acd3d', 'Kanii Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('207pcdefryfed5ptgxgwbpdo462rzl4nw6i8i96ttmearholed','I Know - PR1SVX Edit','ibpr8145ljzkh2t',100,'POP','3vcLw8QA3yCOkrj9oLSZNs','https://p.scdn.co/mp3-preview/146ad1bb65b8f9b097f356d2d5758657a06466dc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('je1or295rlj3w6hn4b9dw5jd56quj7dwrq6dl2iwkdu94r7el4', '207pcdefryfed5ptgxgwbpdo462rzl4nw6i8i96ttmearholed', '0');
-- Lady Gaga
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j9t8sinpjgc58ud', 'Lady Gaga', '19@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc8d3d98a1bccbe71393dbfbf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:19@artist.com', 'j9t8sinpjgc58ud', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j9t8sinpjgc58ud', 'A symphony of emotions expressed through sound.', 'Lady Gaga');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ne4gknscq4m48zg5etkyen9se18eh451u73atqwvpoke03ke32','j9t8sinpjgc58ud', 'https://i.scdn.co/image/ab67616d0000b273a47c0e156ea3cebe37fdcab8', 'Lady Gaga Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vojhxr5qt267av5hpyznt2xupk5wk9axm2e4vl6uwsiu1g4mzr','Bloody Mary','j9t8sinpjgc58ud',100,'POP','11BKm0j4eYoCPPpCONAVwA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ne4gknscq4m48zg5etkyen9se18eh451u73atqwvpoke03ke32', 'vojhxr5qt267av5hpyznt2xupk5wk9axm2e4vl6uwsiu1g4mzr', '0');
-- Natanael Cano
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ze8fborhtazagus', 'Natanael Cano', '20@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0819edd43096a2f0dde7cd44','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:20@artist.com', 'ze8fborhtazagus', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ze8fborhtazagus', 'A symphony of emotions expressed through sound.', 'Natanael Cano');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('liut2mbcip93clqd0f0k2sae6ydv3ganq5ww5vbbwq6ztgkyps','ze8fborhtazagus', 'https://i.scdn.co/image/ab67616d0000b273e2e093427065eaca9e2f2970', 'Natanael Cano Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('id35t860e0bws5rl2kg18u4366v50cynbrkii1n0rucj0pzx9f','Mi Bello Angel','ze8fborhtazagus',100,'POP','4t46soaqA758rbukTO5pp1','https://p.scdn.co/mp3-preview/07854d155311327027a073aeb36f0f61cdb07096?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('liut2mbcip93clqd0f0k2sae6ydv3ganq5ww5vbbwq6ztgkyps', 'id35t860e0bws5rl2kg18u4366v50cynbrkii1n0rucj0pzx9f', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2y03zdjbjhc6ll58nz33jr0r5wlmtfw81ucyaoyevbzdb5698c','PRC','ze8fborhtazagus',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('liut2mbcip93clqd0f0k2sae6ydv3ganq5ww5vbbwq6ztgkyps', '2y03zdjbjhc6ll58nz33jr0r5wlmtfw81ucyaoyevbzdb5698c', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ooolb9585c4283qj0q8nouy6sejxa476zfcbj9j5z0t16k8z5x','AMG','ze8fborhtazagus',100,'POP','1lRtH4FszTrwwlK5gTSbXO','https://p.scdn.co/mp3-preview/2a54eb02ee2a7e8c47c6107f16272a19a0e6362b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('liut2mbcip93clqd0f0k2sae6ydv3ganq5ww5vbbwq6ztgkyps', 'ooolb9585c4283qj0q8nouy6sejxa476zfcbj9j5z0t16k8z5x', '2');
-- Luke Combs
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bwxg68yzzjvl4lh', 'Luke Combs', '21@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5db6179b28f7e3654898b279','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:21@artist.com', 'bwxg68yzzjvl4lh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bwxg68yzzjvl4lh', 'Reigniting country music with his powerful voice and relatable songs.', 'Luke Combs');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o72d0zdmcs4mjnqhi0sdbluk7tlmdl2grgsgz47rlzurays23v','bwxg68yzzjvl4lh', 'https://i.scdn.co/image/ab67616d0000b273ca650d3a95022e0490434ba1', 'Luke Combs Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fw166l985xk0t7bk8wqtk5t96bzuv4t22hunt0dz1qlbdayuex','Fast Car','bwxg68yzzjvl4lh',100,'POP','1Lo0QY9cvc8sUB2vnIOxDT','https://p.scdn.co/mp3-preview/1dc0426c95058783e0fe1d70c41583ca98317108?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o72d0zdmcs4mjnqhi0sdbluk7tlmdl2grgsgz47rlzurays23v', 'fw166l985xk0t7bk8wqtk5t96bzuv4t22hunt0dz1qlbdayuex', '0');
-- Jain
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('g8f6lk5bhqge8h9', 'Jain', '22@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb673f287fead1f6c83b9b68ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:22@artist.com', 'g8f6lk5bhqge8h9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('g8f6lk5bhqge8h9', 'Mixing electronic beats with multicultural influences to create a unique sound.', 'Jain');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xl43m61ymhw368hac4bo2ma9yloqublosmxmxak0flk3gy82dh','g8f6lk5bhqge8h9', 'https://i.scdn.co/image/ab67616d0000b27364ba66f8a81c52364e55db50', 'Jain Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jpwwd86xbrljnipqrm45n45nl3w0q3odrlbpzrgryf05f93bl5','Makeba','g8f6lk5bhqge8h9',100,'POP','4TNFLwe6DhtR3Wn1JKMqMJ','https://p.scdn.co/mp3-preview/41db29480f9d12734adf491d3b5dd4da1005047c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xl43m61ymhw368hac4bo2ma9yloqublosmxmxak0flk3gy82dh', 'jpwwd86xbrljnipqrm45n45nl3w0q3odrlbpzrgryf05f93bl5', '0');
-- Leo Santana
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lgfr8aan89ouu8e', 'Leo Santana', '23@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9c301d2486e33ad58c85db8e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:23@artist.com', 'lgfr8aan89ouu8e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lgfr8aan89ouu8e', 'A confluence of cultural beats and contemporary tunes.', 'Leo Santana');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ymplhc071aemkvstzg0l18o8nm2inr05lbnxh2kppfc07jbdke','lgfr8aan89ouu8e', 'https://i.scdn.co/image/ab67616d0000b273d5efcc40f158ae827c28eee9', 'Leo Santana Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9x46yelvymtoruby6zgiixhts9pfgeo5xgmylmgaqz6xiinwlg','Zona De Perigo','lgfr8aan89ouu8e',100,'POP','4lsQKByQ7m1o6oEKdrJycU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ymplhc071aemkvstzg0l18o8nm2inr05lbnxh2kppfc07jbdke', '9x46yelvymtoruby6zgiixhts9pfgeo5xgmylmgaqz6xiinwlg', '0');
-- Mc Pedrinho
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('skyn3wq87hg8f1f', 'Mc Pedrinho', '24@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba19ab278a7a01b077bb17e75','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:24@artist.com', 'skyn3wq87hg8f1f', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('skyn3wq87hg8f1f', 'Striking chords that resonate across generations.', 'Mc Pedrinho');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('b21qaenmx2xipx9jcejtfm5mtnjtrd5ah7hm7i1bcqvsbqbpj7','skyn3wq87hg8f1f', 'https://i.scdn.co/image/ab67616d0000b27319d60821e80a801506061776', 'Mc Pedrinho Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('53qnj42nwirhsrwfapqgnoioz84izyw9f4sj3r74liteb9ff8a','Gol Bolinha, Gol Quadrado 2','skyn3wq87hg8f1f',100,'POP','0U9CZWq6umZsN432nh3WWT','https://p.scdn.co/mp3-preview/385a48d0a130895b2b0ec2f731cc744207d0a745?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('b21qaenmx2xipx9jcejtfm5mtnjtrd5ah7hm7i1bcqvsbqbpj7', '53qnj42nwirhsrwfapqgnoioz84izyw9f4sj3r74liteb9ff8a', '0');
-- Z Neto & Crist
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k7zkfsvm8f4k7np', 'Z Neto & Crist', '25@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1bb9201db3ff149830f0139a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:25@artist.com', 'k7zkfsvm8f4k7np', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k7zkfsvm8f4k7np', 'A sonic adventurer, always seeking new horizons in music.', 'Z Neto & Crist');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4w6umexrcg5iung2vp9jgndqkduz33iehshvzuts5ayc8z0kzq','k7zkfsvm8f4k7np', 'https://i.scdn.co/image/ab67616d0000b27339833b5940945cf013e8406c', 'Z Neto & Crist Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2nt3zgwx8xpkmc7jxslta2ryfp2gyq3c4ai1lfge9n2ei0spwg','Oi Balde - Ao Vivo','k7zkfsvm8f4k7np',100,'POP','4xAGuRRKOgoaZbMGdmTD3N','https://p.scdn.co/mp3-preview/a6318531e5f8243a9d1df067570b50210b2729cc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4w6umexrcg5iung2vp9jgndqkduz33iehshvzuts5ayc8z0kzq', '2nt3zgwx8xpkmc7jxslta2ryfp2gyq3c4ai1lfge9n2ei0spwg', '0');
-- Hozier
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('l5fwczlhpuq7u0h', 'Hozier', '26@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad85a585103dfc2f3439119a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:26@artist.com', 'l5fwczlhpuq7u0h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('l5fwczlhpuq7u0h', 'Blending genres for a fresh musical experience.', 'Hozier');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lvyeyxljtyk7qv4mslh1gx1xdg2xiq1pt5srbbm9j5vzvnolzd','l5fwczlhpuq7u0h', 'https://i.scdn.co/image/ab67616d0000b2734ca68d59a4a29c856a4a39c2', 'Hozier Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aj642xnirsg79wjrm9bt5zogl77iior8sxhpoch3ajs6u76s38','Take Me To Church','l5fwczlhpuq7u0h',100,'POP','1CS7Sd1u5tWkstBhpssyjP','https://p.scdn.co/mp3-preview/d6170162e349338277c97d2fab42c386701a4089?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lvyeyxljtyk7qv4mslh1gx1xdg2xiq1pt5srbbm9j5vzvnolzd', 'aj642xnirsg79wjrm9bt5zogl77iior8sxhpoch3ajs6u76s38', '0');
-- Latto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0jaw8hu9zj3fay3', 'Latto', '27@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:27@artist.com', '0jaw8hu9zj3fay3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0jaw8hu9zj3fay3', 'A bold and dynamic rapper, making waves with her fiery lyrics.', 'Latto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i6iqptegnruei5ir88yyalr4iudf3jahv4y9bj3usbbzkya7cq','0jaw8hu9zj3fay3', NULL, 'Latto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3womvthi7okqagonk2yedsgigxsucuf59k6vhfxwnva352ugco','Seven (feat. Latto) (Explicit Ver.)','0jaw8hu9zj3fay3',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i6iqptegnruei5ir88yyalr4iudf3jahv4y9bj3usbbzkya7cq', '3womvthi7okqagonk2yedsgigxsucuf59k6vhfxwnva352ugco', '0');
-- Maria Becerra
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ef9l938cyh6aycw', 'Maria Becerra', '28@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb6cfa517b8f5a152d63c4ffb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:28@artist.com', 'ef9l938cyh6aycw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ef9l938cyh6aycw', 'A vibrant new voice in Latin pop, fusing catchy melodies with urban sounds.', 'Maria Becerra');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hejfriabivbev54cmc8fc8tw7am1c4og404jai95fdo7au90py','ef9l938cyh6aycw', NULL, 'Maria Becerra Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1mva5p8oz0e2u0zae7n8glt4ltfmufhlll8oxy4v2axwcz530c','CORAZN VA','ef9l938cyh6aycw',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hejfriabivbev54cmc8fc8tw7am1c4og404jai95fdo7au90py', '1mva5p8oz0e2u0zae7n8glt4ltfmufhlll8oxy4v2axwcz530c', '0');
-- Grupo Marca Registrada
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wtyfy3ticsodsrn', 'Grupo Marca Registrada', '29@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8059103a66f9c25b91b375a9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:29@artist.com', 'wtyfy3ticsodsrn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wtyfy3ticsodsrn', 'An endless quest for musical perfection.', 'Grupo Marca Registrada');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0rl75o8vq6oclmuuytuxs85unos36jmkatsv699nqk07raidnh','wtyfy3ticsodsrn', 'https://i.scdn.co/image/ab67616d0000b273bae22025cf282ad72b167e79', 'Grupo Marca Registrada Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ltsntgm5yh29wf82hefiju4qaj4ztaxq8jiobnj83d578s2o9h','Di Que Si','wtyfy3ticsodsrn',100,'POP','0pliiCOWPN0IId8sXAqNJr','https://p.scdn.co/mp3-preview/622a816595469fdb54c42c88259f303266dc8aa7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0rl75o8vq6oclmuuytuxs85unos36jmkatsv699nqk07raidnh', 'ltsntgm5yh29wf82hefiju4qaj4ztaxq8jiobnj83d578s2o9h', '0');
-- Kelly Clarkson
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fv6447h4h24gvi1', 'Kelly Clarkson', '30@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb305a7cc6760b53a67aaae19d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:30@artist.com', 'fv6447h4h24gvi1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fv6447h4h24gvi1', 'Harnessing the power of melody to tell compelling stories.', 'Kelly Clarkson');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('57rwvpxbplq3qxdpbd9rx5whvb2slczxid1nfxcpej4nwicvzm','fv6447h4h24gvi1', 'https://i.scdn.co/image/ab67616d0000b273f54a315f1d2445791fe601a7', 'Kelly Clarkson Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rdvhv1o428thpslsn5u89g8agor98umj3qcvdr58iat0mzzty3','Underneath the Tree','fv6447h4h24gvi1',100,'POP','3YZE5qDV7u1ZD1gZc47ZeR','https://p.scdn.co/mp3-preview/9d6040eda6551e1746409ca2c8cf04d95475019a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('57rwvpxbplq3qxdpbd9rx5whvb2slczxid1nfxcpej4nwicvzm', 'rdvhv1o428thpslsn5u89g8agor98umj3qcvdr58iat0mzzty3', '0');
-- Tom Odell
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0hmc43bk54fiigu', 'Tom Odell', '31@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb532e8dd8ba9fbd5e78105a78','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:31@artist.com', '0hmc43bk54fiigu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0hmc43bk54fiigu', 'Stirring emotions with piano-driven melodies and poetic lyrics.', 'Tom Odell');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1yye6rqnw9hvbjtfog2ozmqgag27rfhxevi8fkn5pqlb3q03g6','0hmc43bk54fiigu', 'https://i.scdn.co/image/ab67616d0000b2731917a0f3f4152622a040913f', 'Tom Odell Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nayxnvhsncq083416h8gyx4pvewtcp3tjc499c8it3frz5ei6s','Another Love','0hmc43bk54fiigu',100,'POP','3JvKfv6T31zO0ini8iNItO','https://p.scdn.co/mp3-preview/0369cb748bc968ffd34fb4ac60f5403f2aad032f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1yye6rqnw9hvbjtfog2ozmqgag27rfhxevi8fkn5pqlb3q03g6', 'nayxnvhsncq083416h8gyx4pvewtcp3tjc499c8it3frz5ei6s', '0');
-- TAEYANG
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ygm0olve0csgs4y', 'TAEYANG', '32@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb496189630cd3cb0c7b593fee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:32@artist.com', 'ygm0olve0csgs4y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ygm0olve0csgs4y', 'Revolutionizing the music scene with innovative compositions.', 'TAEYANG');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6se8lykoqa2hpd5zhe2ko8nn04vmts5qfki9ts9zmdy7kbcdg9','ygm0olve0csgs4y', 'https://i.scdn.co/image/ab67616d0000b27346313223adf2b6d726388328', 'TAEYANG Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aypz3ee7pdwmo7cukgq6pey4gm36hmj80xq4o2caepygr0d7lj','Shoong! (feat. LISA of BLACKPINK)','ygm0olve0csgs4y',100,'POP','5HrIcZOo1DysX53qDRlRnt',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6se8lykoqa2hpd5zhe2ko8nn04vmts5qfki9ts9zmdy7kbcdg9', 'aypz3ee7pdwmo7cukgq6pey4gm36hmj80xq4o2caepygr0d7lj', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nqs6eknahiim6s0i88jagxtea50o4txtd679b1i36nvvxduhiq','VIBE (feat. Jimin of BTS)','ygm0olve0csgs4y',100,'POP','4NIe9Is7bN5JWyTeCW2ahK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6se8lykoqa2hpd5zhe2ko8nn04vmts5qfki9ts9zmdy7kbcdg9', 'nqs6eknahiim6s0i88jagxtea50o4txtd679b1i36nvvxduhiq', '1');
-- a-ha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cjz4h5nnka2ev2h', 'a-ha', '33@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0168ba8148c07c2cdeb7d067','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:33@artist.com', 'cjz4h5nnka2ev2h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cjz4h5nnka2ev2h', 'Igniting the stage with electrifying performances.', 'a-ha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('befsnf4lr00f8qwynb3nwtw7d2dad1al0o6zml2dnly49lq6k2','cjz4h5nnka2ev2h', 'https://i.scdn.co/image/ab67616d0000b273e8dd4db47e7177c63b0b7d53', 'a-ha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qkrs7wsjse8gjaj10td0bjqirz5d9g9486m4idnzi1fn8h66dh','Take On Me','cjz4h5nnka2ev2h',100,'POP','2WfaOiMkCvy7F5fcp2zZ8L','https://p.scdn.co/mp3-preview/ed66a8c444c35b2f5029c04ae8e18f69d952c2bb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('befsnf4lr00f8qwynb3nwtw7d2dad1al0o6zml2dnly49lq6k2', 'qkrs7wsjse8gjaj10td0bjqirz5d9g9486m4idnzi1fn8h66dh', '0');
-- Kenshi Yonezu
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pqmw66u5owyv0hx', 'Kenshi Yonezu', '34@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc147e0888e83919d317c1103','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:34@artist.com', 'pqmw66u5owyv0hx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pqmw66u5owyv0hx', 'Pushing the boundaries of sound with each note.', 'Kenshi Yonezu');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rzar5chmarwhzc9jizt9r3sxdn4eiyxa9zmngxtbvg478rocop','pqmw66u5owyv0hx', 'https://i.scdn.co/image/ab67616d0000b273303d8545fce8302841c39859', 'Kenshi Yonezu Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h3kas15whyx6r403xbfyobe0e5lwx4bmgmn38lc1boqw5kbe9b','KICK BACK','pqmw66u5owyv0hx',100,'POP','3khEEPRyBeOUabbmOPJzAG','https://p.scdn.co/mp3-preview/003a7a062f469db238cf5206626f08f3263c68e6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rzar5chmarwhzc9jizt9r3sxdn4eiyxa9zmngxtbvg478rocop', 'h3kas15whyx6r403xbfyobe0e5lwx4bmgmn38lc1boqw5kbe9b', '0');
-- Lil Uzi Vert
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e7uyb1pd2fbcq4g', 'Lil Uzi Vert', '35@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1234d2f516796badbdf16a89','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:35@artist.com', 'e7uyb1pd2fbcq4g', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e7uyb1pd2fbcq4g', 'A visionary in the world of music, redefining genres.', 'Lil Uzi Vert');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d80nvxfu6n8zh0r1herlcvtzqgywzsziyx3rbb6ttrjcqt66v7','e7uyb1pd2fbcq4g', 'https://i.scdn.co/image/ab67616d0000b273438799bc344744c12028bb0f', 'Lil Uzi Vert Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7scayrujefgsjoz5j9kaiqlj7an1r6h52ehcv4edn7t4cpnog4','Just Wanna Rock','e7uyb1pd2fbcq4g',100,'POP','4FyesJzVpA39hbYvcseO2d','https://p.scdn.co/mp3-preview/72dce26448e87be36c3776ded36b75a9fd01359e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d80nvxfu6n8zh0r1herlcvtzqgywzsziyx3rbb6ttrjcqt66v7', '7scayrujefgsjoz5j9kaiqlj7an1r6h52ehcv4edn7t4cpnog4', '0');
-- JISOO
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zaq9n3godwj3bpc', 'JISOO', '36@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcb6017286dd64ca6b77c879f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:36@artist.com', 'zaq9n3godwj3bpc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zaq9n3godwj3bpc', 'Pushing the boundaries of sound with each note.', 'JISOO');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ejwg1mdlh6312ji0rhbh3uk2rxcrkf778lhwtseonsxmm477hy','zaq9n3godwj3bpc', 'https://i.scdn.co/image/ab67616d0000b273f35b8a6c03cc633f734bd8ac', 'JISOO Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i71ivz8kas2lmo0afx4i6mqg863zphf40v176r7gv7x9vtlehs','FLOWER','zaq9n3godwj3bpc',100,'POP','69CrOS7vEHIrhC2ILyEi0s',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ejwg1mdlh6312ji0rhbh3uk2rxcrkf778lhwtseonsxmm477hy', 'i71ivz8kas2lmo0afx4i6mqg863zphf40v176r7gv7x9vtlehs', '0');
-- Rauw Alejandro
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fh3nuoap3j39uif', 'Rauw Alejandro', '37@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9047f938310ea16b68a5bdeb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:37@artist.com', 'fh3nuoap3j39uif', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fh3nuoap3j39uif', 'A fusion of Latin trap and reggaeton, setting the stage on fire.', 'Rauw Alejandro');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fycj5mmado4p1hhhf4w65ptzxei6i53hstm7h4q5birpzq1ag2','fh3nuoap3j39uif', NULL, 'Rauw Alejandro Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('up7795tdmik7emh06l9xgkpetbqfnrxhcq9sia3u83mmvnbxy4','BESO','fh3nuoap3j39uif',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fycj5mmado4p1hhhf4w65ptzxei6i53hstm7h4q5birpzq1ag2', 'up7795tdmik7emh06l9xgkpetbqfnrxhcq9sia3u83mmvnbxy4', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pcbd26ihu4mv0jz5p2fo124thfoxpcajarkgno3w3qj286ugfe','BABY HELLO','fh3nuoap3j39uif',100,'POP','2SOvWt6igzXViIjIiWNWEP','https://p.scdn.co/mp3-preview/8a9ca6c81e6e6ad48758f02017456405fd7a476d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fycj5mmado4p1hhhf4w65ptzxei6i53hstm7h4q5birpzq1ag2', 'pcbd26ihu4mv0jz5p2fo124thfoxpcajarkgno3w3qj286ugfe', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4xcot7739fdwhnizmhth1ag6o2q5myrsvlspbnomd2ii0smpw2','Rauw Alejandro: Bzrp Music Sessions, Vol. 56','fh3nuoap3j39uif',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fycj5mmado4p1hhhf4w65ptzxei6i53hstm7h4q5birpzq1ag2', '4xcot7739fdwhnizmhth1ag6o2q5myrsvlspbnomd2ii0smpw2', '2');
-- Nicky Jam
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x124fuy7dvjp8gb', 'Nicky Jam', '38@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb02bec146cac39466d3f8ee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:38@artist.com', 'x124fuy7dvjp8gb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x124fuy7dvjp8gb', 'An endless quest for musical perfection.', 'Nicky Jam');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('04tp0sjp3afknifoaepxjysfsut2zlr7602ii0tlthwwsox6wn','x124fuy7dvjp8gb', 'https://i.scdn.co/image/ab67616d0000b273ea97d86f1fa8532cd8c75188', 'Nicky Jam Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('539285v5r7zon5s8g7w2jnk1pdk17u1nh7ryi1fxonnp875zj8','69','x124fuy7dvjp8gb',100,'POP','13Z5Q40pa1Ly7aQk1oW8Ce','https://p.scdn.co/mp3-preview/966457479d8cd723838150ddd1f3010f4383994d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('04tp0sjp3afknifoaepxjysfsut2zlr7602ii0tlthwwsox6wn', '539285v5r7zon5s8g7w2jnk1pdk17u1nh7ryi1fxonnp875zj8', '0');
-- Big One
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fsohpaahs5b14iz', 'Big One', '39@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcd00b46bac23bbfbcdcd10bc','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:39@artist.com', 'fsohpaahs5b14iz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fsohpaahs5b14iz', 'Bringing a unique energy to every track, fusing various styles into a cohesive sound.', 'Big One');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xkipjo1n8si4d1wcb6jz2yo4ocwrgkr9l4nnz6yovxb87ff26r','fsohpaahs5b14iz', NULL, 'Big One Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5iuhr67w4bcpff2h13n0d8fflcaayvt61os58a1zcnce4nm0vr','Los del Espacio','fsohpaahs5b14iz',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xkipjo1n8si4d1wcb6jz2yo4ocwrgkr9l4nnz6yovxb87ff26r', '5iuhr67w4bcpff2h13n0d8fflcaayvt61os58a1zcnce4nm0vr', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z631zkkyuufs5eibcm0orataptn125eik9qvlaz3ek599eqthu','Un Finde | CROSSOVER #2','fsohpaahs5b14iz',100,'POP','3tiJUOfAEqIrLFRQgGgdoY','https://p.scdn.co/mp3-preview/38b8f2c063a896c568b9741dcd6e194be0a0376b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xkipjo1n8si4d1wcb6jz2yo4ocwrgkr9l4nnz6yovxb87ff26r', 'z631zkkyuufs5eibcm0orataptn125eik9qvlaz3ek599eqthu', '1');
-- Tory Lanez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4ivo0f9x72laidw', 'Tory Lanez', '40@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebbd5d3e1b363c3e26710661c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:40@artist.com', '4ivo0f9x72laidw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4ivo0f9x72laidw', 'Weaving lyrical magic into every song.', 'Tory Lanez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hmou6fqjpzjxcvrv2tlgpc695yx2lbwwv8v4wwzi4iwrbejd84','4ivo0f9x72laidw', 'https://i.scdn.co/image/ab67616d0000b2730c5f23cbf0b1ab7e37d0dc67', 'Tory Lanez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rbffwqltf330ggyn9420yfglyllsnxwvz15xwft5dgzlw3i6w3','The Color Violet','4ivo0f9x72laidw',100,'POP','3azJifCSqg9fRij2yKIbWz','https://p.scdn.co/mp3-preview/1d7c627bf549328110519c4bd21ac39d7ca50ea1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hmou6fqjpzjxcvrv2tlgpc695yx2lbwwv8v4wwzi4iwrbejd84', 'rbffwqltf330ggyn9420yfglyllsnxwvz15xwft5dgzlw3i6w3', '0');
-- Nile Rodgers
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8l41w9ih1jfd5rq', 'Nile Rodgers', '41@artist.com', 'https://i.scdn.co/image/6511b1fe261da3b6c6b69ae2aa771cfd307a18ae','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:41@artist.com', '8l41w9ih1jfd5rq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8l41w9ih1jfd5rq', 'Where words fail, my music speaks.', 'Nile Rodgers');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ntc3k1vkycquuogzzkgyknw2kqog987pxh9pdcmkn6tnxaftvk','8l41w9ih1jfd5rq', NULL, 'Nile Rodgers Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dhr6dxkh9nwouw0p7rx5gh5xwlivnzqebi288sf4hvtwo7pebc','UNFORGIVEN (feat. Nile Rodgers)','8l41w9ih1jfd5rq',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ntc3k1vkycquuogzzkgyknw2kqog987pxh9pdcmkn6tnxaftvk', 'dhr6dxkh9nwouw0p7rx5gh5xwlivnzqebi288sf4hvtwo7pebc', '0');
-- Rma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5yvro6sx87xzies', 'Rma', '42@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3b8f6208d84e28f63841e43c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:42@artist.com', '5yvro6sx87xzies', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5yvro6sx87xzies', 'Pioneering new sounds and delivering electrifying performances.', 'Rma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8imm1moi1caygv1cc4rxdx42fv7hqppy2md4dcduo9lfwacrm4','5yvro6sx87xzies', NULL, 'Rma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e0negssy91wuu4q50clr1q42cjzarv51n6wbrrbh8o4o2sab2h','Calm Down (with Selena Gomez)','5yvro6sx87xzies',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8imm1moi1caygv1cc4rxdx42fv7hqppy2md4dcduo9lfwacrm4', 'e0negssy91wuu4q50clr1q42cjzarv51n6wbrrbh8o4o2sab2h', '0');
-- Miley Cyrus
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hwioxwjyd5cuukd', 'Miley Cyrus', '43@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5af3b38f053486ab0784dee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:43@artist.com', 'hwioxwjyd5cuukd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hwioxwjyd5cuukd', 'Constantly evolving, from pop sensation to rock powerhouse.', 'Miley Cyrus');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9guhowqt84eyyb8q9y9qmw01h1alwlcjnvi6fevgsb39ojhp29','hwioxwjyd5cuukd', 'https://i.scdn.co/image/ab67616d0000b273cd222052a2594be29a6616b5', 'Miley Cyrus Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ymhwiez0n2zvwr7vayqwpxkt1uhfu8dm4ghjv4k1ysrbh66ppg','Flowers','hwioxwjyd5cuukd',100,'POP','7DSAEUvxU8FajXtRloy8M0','https://p.scdn.co/mp3-preview/5184d19d1b7fcc3e7c067e38af45a7cc80851440?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9guhowqt84eyyb8q9y9qmw01h1alwlcjnvi6fevgsb39ojhp29', 'ymhwiez0n2zvwr7vayqwpxkt1uhfu8dm4ghjv4k1ysrbh66ppg', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5586cvdtr09fspjuzfeiv4i21it9nm8rznmllmz73r40s3tvgs','Angels Like You','hwioxwjyd5cuukd',100,'POP','1daDRI9ahBonbWD8YcxOIB','https://p.scdn.co/mp3-preview/4db8314199c0d49e95c786792ecd06eadae9f510?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9guhowqt84eyyb8q9y9qmw01h1alwlcjnvi6fevgsb39ojhp29', '5586cvdtr09fspjuzfeiv4i21it9nm8rznmllmz73r40s3tvgs', '1');
-- Yng Lvcas
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zv611xmd2ckaxrv', 'Yng Lvcas', '44@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:44@artist.com', 'zv611xmd2ckaxrv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zv611xmd2ckaxrv', 'A beacon of innovation in the world of sound.', 'Yng Lvcas');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vroiwys06rp2phyryi1yv58jpi53jjrot9ytj4zzis0rikmych','zv611xmd2ckaxrv', 'https://i.scdn.co/image/ab67616d0000b273a04be3ad7c8c67f4109111a9', 'Yng Lvcas Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hadmxjdyobb8r7rjoulyirjklvttqly9rk6tr1xl3m8g6ytkrm','La Bebe','zv611xmd2ckaxrv',100,'POP','2UW7JaomAMuX9pZrjVpHAU','https://p.scdn.co/mp3-preview/57c5d5266219b32d455ed22417155bbabde7170f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vroiwys06rp2phyryi1yv58jpi53jjrot9ytj4zzis0rikmych', 'hadmxjdyobb8r7rjoulyirjklvttqly9rk6tr1xl3m8g6ytkrm', '0');
-- Sean Paul
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rguy1lv4dzsv9ff', 'Sean Paul', '45@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb60c3e9abe7327c0097738f22','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:45@artist.com', 'rguy1lv4dzsv9ff', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rguy1lv4dzsv9ff', 'A maestro of melodies, orchestrating auditory bliss.', 'Sean Paul');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('utzvx4p1vn2uosdwms8cwl4glazfzenjp7g3fyur4md5192cag','rguy1lv4dzsv9ff', NULL, 'Sean Paul Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1ybzqqwgccwfy7xpwd3bjpso1d0ldtvgwkxf4m9hgry2w8l91v','Nia Bo','rguy1lv4dzsv9ff',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('utzvx4p1vn2uosdwms8cwl4glazfzenjp7g3fyur4md5192cag', '1ybzqqwgccwfy7xpwd3bjpso1d0ldtvgwkxf4m9hgry2w8l91v', '0');
-- Wisin & Yandel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bzm8erw6773etaj', 'Wisin & Yandel', '46@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5496c4b788e181679069ee8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:46@artist.com', 'bzm8erw6773etaj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bzm8erw6773etaj', 'Breathing new life into classic genres.', 'Wisin & Yandel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g025zj0olm0h7v2gbv4zxxli310dhoz12s8esxvr4yz2pkjt2i','bzm8erw6773etaj', 'https://i.scdn.co/image/ab67616d0000b2739f05bb270f81880fd844aae8', 'Wisin & Yandel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('740gs437idf69jw4j5pysdm2ydugm7gwhie0zu2wfbp93w241i','Besos Moja2','bzm8erw6773etaj',100,'POP','6OzUIp8KjuwxJnCWkXp1uL','https://p.scdn.co/mp3-preview/8b17c9ae5706f7f2e41a6ec3470631b3094017b6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g025zj0olm0h7v2gbv4zxxli310dhoz12s8esxvr4yz2pkjt2i', '740gs437idf69jw4j5pysdm2ydugm7gwhie0zu2wfbp93w241i', '0');
-- Tini
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0s5l9teyn4ojajf', 'Tini', '47@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd1ee0c41d3c79e916b910696','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:47@artist.com', '0s5l9teyn4ojajf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0s5l9teyn4ojajf', 'Revolutionizing the music scene with innovative compositions.', 'Tini');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('brwf0qjvqi53jm9d66t0fnrdbv75g7kwcp3up94huyl3vlwrx0','0s5l9teyn4ojajf', 'https://i.scdn.co/image/ab67616d0000b273f5409c637b9a7244e0c0d11d', 'Tini Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('26gvcfl7lp0mjunq0c5tvt3dvsk7tavxgu8rh7b7sxlgknhhzb','Cupido','0s5l9teyn4ojajf',100,'POP','04ndZkbKGthTgYSv3xS7en','https://p.scdn.co/mp3-preview/15bc4fa0d69ae03a045704bcc8731def7453458b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('brwf0qjvqi53jm9d66t0fnrdbv75g7kwcp3up94huyl3vlwrx0', '26gvcfl7lp0mjunq0c5tvt3dvsk7tavxgu8rh7b7sxlgknhhzb', '0');
-- Skrillex
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9ud0xon304nzyia', 'Skrillex', '48@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb61f92702ca14484aa263a931','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:48@artist.com', '9ud0xon304nzyia', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9ud0xon304nzyia', 'Crafting soundscapes that transport listeners to another world.', 'Skrillex');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hrj92exevwu5wp845qb0h86uq9v1peug3las1eqnlc5u2uvh6l','9ud0xon304nzyia', 'https://i.scdn.co/image/ab67616d0000b273352f154c54727bc8024629bc', 'Skrillex Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2upd1osptayhyiqh856k477wd3tcjk5hoo57f31oqzb35easlg','Rumble','9ud0xon304nzyia',100,'POP','1GfBLbAhZUWdseuDqhocmn','https://p.scdn.co/mp3-preview/eb79af9f809883de0632f02388ec354478612754?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hrj92exevwu5wp845qb0h86uq9v1peug3las1eqnlc5u2uvh6l', '2upd1osptayhyiqh856k477wd3tcjk5hoo57f31oqzb35easlg', '0');
-- Ray Dalton
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('15vtfix8ndctcup', 'Ray Dalton', '49@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb761f04a794923fde50fcb9fb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:49@artist.com', '15vtfix8ndctcup', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('15vtfix8ndctcup', 'Elevating the ordinary to extraordinary through music.', 'Ray Dalton');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9lgv6o2ah7cx7uh3vl539byfh01wgp2s75q8kpllksuedd2ary','15vtfix8ndctcup', NULL, 'Ray Dalton Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hl60nzqgrujjoh2yd6sqaekmykhln6lhwmbd48dnq2dfu48f54','Cant Hold Us (feat. Ray Dalton)','15vtfix8ndctcup',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9lgv6o2ah7cx7uh3vl539byfh01wgp2s75q8kpllksuedd2ary', 'hl60nzqgrujjoh2yd6sqaekmykhln6lhwmbd48dnq2dfu48f54', '0');
-- Andy Williams
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jrelde2ft9tlgbe', 'Andy Williams', '50@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5888acdca5e748e796b4e69b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:50@artist.com', 'jrelde2ft9tlgbe', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jrelde2ft9tlgbe', 'An alchemist of harmonies, transforming notes into gold.', 'Andy Williams');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gcvjsmvxm3upoe6pe1zea76nx8fboo1tobe44vei3wp53lbthc','jrelde2ft9tlgbe', 'https://i.scdn.co/image/ab67616d0000b27398073965947f92f1641b8356', 'Andy Williams Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oxuk02cob0ostcncdojhr5drfvu7sytdbsur83hg7yfncl2x5k','Its the Most Wonderful Time of the Year','jrelde2ft9tlgbe',100,'POP','5hslUAKq9I9CG2bAulFkHN','https://p.scdn.co/mp3-preview/853f441c5fc1b25ba88bb300c17119cde36da675?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gcvjsmvxm3upoe6pe1zea76nx8fboo1tobe44vei3wp53lbthc', 'oxuk02cob0ostcncdojhr5drfvu7sytdbsur83hg7yfncl2x5k', '0');
-- Bruno Mars
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('o2pss3hw4d6vdhr', 'Bruno Mars', '51@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc36dd9eb55fb0db4911f25dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:51@artist.com', 'o2pss3hw4d6vdhr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('o2pss3hw4d6vdhr', 'A journey through the spectrum of sound in every album.', 'Bruno Mars');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('275nu6qze4qlg0tfizwgjk7l5lwm2jhor9phuv2c8238wjk0ht','o2pss3hw4d6vdhr', 'https://i.scdn.co/image/ab67616d0000b273926f43e7cce571e62720fd46', 'Bruno Mars Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2t90stydot4l4l72w9gec0ltvrs292sdb1f0av1r0emrk71wlb','Locked Out Of Heaven','o2pss3hw4d6vdhr',100,'POP','3w3y8KPTfNeOKPiqUTakBh','https://p.scdn.co/mp3-preview/5a0318e6c43964786d22b9431af35490e96cff3d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('275nu6qze4qlg0tfizwgjk7l5lwm2jhor9phuv2c8238wjk0ht', '2t90stydot4l4l72w9gec0ltvrs292sdb1f0av1r0emrk71wlb', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gtv31x53dc93i8ubt5o9ujm2ii8fedm87q0vejnjxjynoat6ui','When I Was Your Man','o2pss3hw4d6vdhr',100,'POP','0nJW01T7XtvILxQgC5J7Wh','https://p.scdn.co/mp3-preview/159fc05584217baa99581c4821f52d04670db6b2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('275nu6qze4qlg0tfizwgjk7l5lwm2jhor9phuv2c8238wjk0ht', 'gtv31x53dc93i8ubt5o9ujm2ii8fedm87q0vejnjxjynoat6ui', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jr5i869sam9gndwyx373adr1cy5kk0puagif2lx0nzx5jo1h3l','Just The Way You Are','o2pss3hw4d6vdhr',100,'POP','7BqBn9nzAq8spo5e7cZ0dJ','https://p.scdn.co/mp3-preview/6d1a901b10c7dc609d4c8628006b04bc6e672be8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('275nu6qze4qlg0tfizwgjk7l5lwm2jhor9phuv2c8238wjk0ht', 'jr5i869sam9gndwyx373adr1cy5kk0puagif2lx0nzx5jo1h3l', '2');
-- Zach Bryan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k73ital82ch7bxq', 'Zach Bryan', '52@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4fd54df35bfcfa0fc9fc2da7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:52@artist.com', 'k73ital82ch7bxq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k73ital82ch7bxq', 'An alchemist of harmonies, transforming notes into gold.', 'Zach Bryan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l2greszmvnnxejsyq5b2avubinh60ltzuu0ixxu0906f36y89l','k73ital82ch7bxq', 'https://i.scdn.co/image/ab67616d0000b273b2b6670e3aca9bcd55fbabbb', 'Zach Bryan Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('grvn57rm81nzwyjowaqn4spz52pzmltaptf2tpgce3amyi48gr','Something in the Orange','k73ital82ch7bxq',100,'POP','3WMj8moIAXJhHsyLaqIIHI','https://p.scdn.co/mp3-preview/d33dc9df586e24c9d8f640df08b776d94680f529?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l2greszmvnnxejsyq5b2avubinh60ltzuu0ixxu0906f36y89l', 'grvn57rm81nzwyjowaqn4spz52pzmltaptf2tpgce3amyi48gr', '0');
-- Agust D
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7j0ncxhqdnop30y', 'Agust D', '53@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb191d43dca6f2f5a126e43e4b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:53@artist.com', '7j0ncxhqdnop30y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7j0ncxhqdnop30y', 'Revolutionizing the music scene with innovative compositions.', 'Agust D');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xqqakf82706oajbf2i24tahkckioh2cwvlekm52i91sz885vxa','7j0ncxhqdnop30y', 'https://i.scdn.co/image/ab67616d0000b273fa9247b68471b82d2125651e', 'Agust D Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wvv7jpjx1nrmzm6ufhvquxtpojsc1iaq1bdfssjk07v7po7zmv','Haegeum','7j0ncxhqdnop30y',100,'POP','4bjN59DRXFRxBE1g5ne6B1','https://p.scdn.co/mp3-preview/3c2f1894de0f6a51f557131c3eb275cb8bc80831?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xqqakf82706oajbf2i24tahkckioh2cwvlekm52i91sz885vxa', 'wvv7jpjx1nrmzm6ufhvquxtpojsc1iaq1bdfssjk07v7po7zmv', '0');
-- Fuerza Regida
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('phflf6xzfqbuav2', 'Fuerza Regida', '54@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1b85fbf9507041aab224336d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:54@artist.com', 'phflf6xzfqbuav2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('phflf6xzfqbuav2', 'Revitalizing the regional music scene with their unique sound and powerful lyrics.', 'Fuerza Regida');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('k79e83bs4wzlpyrefuk7gmszcliizm6ubcqe93s4pft9wg2wxr','phflf6xzfqbuav2', 'https://i.scdn.co/image/ab67616d0000b273cfe3eb72c48b93971e53efd9', 'Fuerza Regida Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('si7ssjwf8vim9xfmhykc7svy81b6aa6yrqccg4ijmtgypd1c97','SABOR FRESA','phflf6xzfqbuav2',100,'POP','1UMm1Qs3u59Wvk53zBUE8r','https://p.scdn.co/mp3-preview/590ae0b69465339d97ef5db9f7e36fe0c452fbb4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k79e83bs4wzlpyrefuk7gmszcliizm6ubcqe93s4pft9wg2wxr', 'si7ssjwf8vim9xfmhykc7svy81b6aa6yrqccg4ijmtgypd1c97', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p472acvlnv1renku9rtn1jmbmoh75m89q2sm859zj4cuytcwha','TQM','phflf6xzfqbuav2',100,'POP','368eeEO3Y2uZUQ6S5oIjcu','https://p.scdn.co/mp3-preview/63f6b66cfcc3d7bd396dcbe18d6e3dee05fdb956?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k79e83bs4wzlpyrefuk7gmszcliizm6ubcqe93s4pft9wg2wxr', 'p472acvlnv1renku9rtn1jmbmoh75m89q2sm859zj4cuytcwha', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gm5citjhz07wzh54xphcpvo4exh113a0mlobi5rzeh9tizqdof','Bebe Dame','phflf6xzfqbuav2',100,'POP','0IKeDy5bT9G0bA7ZixRT4A','https://p.scdn.co/mp3-preview/408ffb4fffcd26cda82f2b3cda7726ea1f6ebd74?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k79e83bs4wzlpyrefuk7gmszcliizm6ubcqe93s4pft9wg2wxr', 'gm5citjhz07wzh54xphcpvo4exh113a0mlobi5rzeh9tizqdof', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bl6b7rbzywg1hkhice9ol0hbcxkb0b8lkop64zxog2ty4k4kvx','Ch y la Pizza','phflf6xzfqbuav2',100,'POP','0UbesRsX2TtiCeamOIVEkp','https://p.scdn.co/mp3-preview/212acba217ff0304f6cbb41eb8f43cd27d991c7b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k79e83bs4wzlpyrefuk7gmszcliizm6ubcqe93s4pft9wg2wxr', 'bl6b7rbzywg1hkhice9ol0hbcxkb0b8lkop64zxog2ty4k4kvx', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('95d6gfutzpady81wvx3dh86psyjg59bvv1rudw9ootj7btixtv','Igualito a Mi Ap','phflf6xzfqbuav2',100,'POP','17js0w8GTkTUFGFM6PYvBd','https://p.scdn.co/mp3-preview/f0f87682468e9baa92562cd4d797ce8af5337ca6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k79e83bs4wzlpyrefuk7gmszcliizm6ubcqe93s4pft9wg2wxr', '95d6gfutzpady81wvx3dh86psyjg59bvv1rudw9ootj7btixtv', '4');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vvw5wp4q5ytj8kqjooe96px22l67nx2zwr4cqqztmp3yaemm76','Dijeron Que No La Iba Lograr','phflf6xzfqbuav2',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k79e83bs4wzlpyrefuk7gmszcliizm6ubcqe93s4pft9wg2wxr', 'vvw5wp4q5ytj8kqjooe96px22l67nx2zwr4cqqztmp3yaemm76', '5');
-- Hotel Ugly
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uka6xhvfokr8pv4', 'Hotel Ugly', '55@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb939033cc36c08ab68b33f760','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:55@artist.com', 'uka6xhvfokr8pv4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uka6xhvfokr8pv4', 'Pushing the boundaries of sound with each note.', 'Hotel Ugly');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vvrzgf06opugebp6zw17ca0tujnds5v450syk6u61wkiqw5vey','uka6xhvfokr8pv4', 'https://i.scdn.co/image/ab67616d0000b273350ab7a839c04bfd5225a9f5', 'Hotel Ugly Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('smuoe9mjvhyg8ljgcgidr3qd2lgw1v1f3j2wezxjnigs54lob6','Shut up My Moms Calling','uka6xhvfokr8pv4',100,'POP','3hxIUxnT27p5WcmjGUXNwx','https://p.scdn.co/mp3-preview/7642409265c74b714a2f0f0dd8663c031e253485?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vvrzgf06opugebp6zw17ca0tujnds5v450syk6u61wkiqw5vey', 'smuoe9mjvhyg8ljgcgidr3qd2lgw1v1f3j2wezxjnigs54lob6', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g2gyk843jggmdc339fbcjca8mb6co0rn1v7sqiuigjvhj23qdm','Shut up My Moms Calling - (Sped Up)','uka6xhvfokr8pv4',100,'POP','31mzt4ZV8C0f52pIz1NSwd','https://p.scdn.co/mp3-preview/4417d6fbf78b2a96b067dc092f888178b155b6b7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vvrzgf06opugebp6zw17ca0tujnds5v450syk6u61wkiqw5vey', 'g2gyk843jggmdc339fbcjca8mb6co0rn1v7sqiuigjvhj23qdm', '1');
-- INTERWORLD
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tmo02kjbp92z168', 'INTERWORLD', '56@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4ba846e4a963c8558471e3af','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:56@artist.com', 'tmo02kjbp92z168', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tmo02kjbp92z168', 'Sculpting soundwaves into masterpieces of auditory art.', 'INTERWORLD');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kg31h0rwa9laatrto3xud96eijlfjatw6plu37c2cdpeapxk1r','tmo02kjbp92z168', 'https://i.scdn.co/image/ab67616d0000b273b852a616ae3a49a1f6b0f16e', 'INTERWORLD Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6arw0mepoq5ok64ypwdv9nwhjhjy97rgyu04l8nc5szo0o6115','METAMORPHOSIS','tmo02kjbp92z168',100,'POP','2ksyzVfU0WJoBpu8otr4pz','https://p.scdn.co/mp3-preview/61baac6cfee58ae57f9f767a86fa5e99f9797664?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kg31h0rwa9laatrto3xud96eijlfjatw6plu37c2cdpeapxk1r', '6arw0mepoq5ok64ypwdv9nwhjhjy97rgyu04l8nc5szo0o6115', '0');
-- Manuel Turizo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('617wv8svbw93buy', 'Manuel Turizo', '57@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebabd3e69b432d6187cf4e28c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:57@artist.com', '617wv8svbw93buy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('617wv8svbw93buy', 'A standout in reggaeton, known for his smooth voice and romantic lyrics.', 'Manuel Turizo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nv0ca5yw845xwc6e7mixqzwor38br34202k1y1wb6vpzowuve3','617wv8svbw93buy', 'https://i.scdn.co/image/ab67616d0000b273c9f744b0d62da795bc21d04a', 'Manuel Turizo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('isx7dqgqv4erffxlzgdflg3jjjk5amogatdissld59dpo3avis','La Bachata','617wv8svbw93buy',100,'POP','5ww2BF9slyYgNOk37BlC4u','https://p.scdn.co/mp3-preview/0232b53fd7849e6696e1ab3099dd01dd00823f17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nv0ca5yw845xwc6e7mixqzwor38br34202k1y1wb6vpzowuve3', 'isx7dqgqv4erffxlzgdflg3jjjk5amogatdissld59dpo3avis', '0');
-- Jimin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4a88enryejun8yj', 'Jimin', '58@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb59f8cfc8e71dcaf8c6ec4bde','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:58@artist.com', '4a88enryejun8yj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4a88enryejun8yj', 'Known for his expressive voice and mesmerizing dance moves in BTS.', 'Jimin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yhqcj34x2adsnlsjylmbc5ni0sgwuyz2cspewey6rgqlt8s9jq','4a88enryejun8yj', 'https://i.scdn.co/image/ab67616d0000b2732b46078245d0120690eb560d', 'Jimin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5qu3xa4rauft3t5zhannnlg34xak5tx6yiu1t8z99wgujngd6m','Like Crazy','4a88enryejun8yj',100,'POP','3Ua0m0YmEjrMi9XErKcNiR','https://p.scdn.co/mp3-preview/2db5f36096963d97afc870c50990d62d27858a43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yhqcj34x2adsnlsjylmbc5ni0sgwuyz2cspewey6rgqlt8s9jq', '5qu3xa4rauft3t5zhannnlg34xak5tx6yiu1t8z99wgujngd6m', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qrdkt6cuwwbshgnipwyvat386696vrtpuxus9k4cun6jns41r2','Set Me Free Pt.2','4a88enryejun8yj',100,'POP','59hBR0BCtJsfIbV9VzCVAp','https://p.scdn.co/mp3-preview/275a3a0843bb55c251cda45ef17a905dab31624c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yhqcj34x2adsnlsjylmbc5ni0sgwuyz2cspewey6rgqlt8s9jq', 'qrdkt6cuwwbshgnipwyvat386696vrtpuxus9k4cun6jns41r2', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v19v0x1tsh7ymq2o8j59w1fzu8any727di39i2ot1mzrjuvvev','Like Crazy (English Version)','4a88enryejun8yj',100,'POP','0u8rZGtXJrLtiSe34FPjGG','https://p.scdn.co/mp3-preview/3752bae14d7952abe6f93649d85d53bfe98f1165?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yhqcj34x2adsnlsjylmbc5ni0sgwuyz2cspewey6rgqlt8s9jq', 'v19v0x1tsh7ymq2o8j59w1fzu8any727di39i2ot1mzrjuvvev', '2');
-- Lil Durk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lkctjm59u4kvc9a', 'Lil Durk', '59@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3513370298ee50e52dfc7326','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:59@artist.com', 'lkctjm59u4kvc9a', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lkctjm59u4kvc9a', 'An odyssey of sound that defies conventions.', 'Lil Durk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4e6zgxwehvtvlif3kxj911o37o6hsxdjnhhygidfd14zxcjet1','lkctjm59u4kvc9a', 'https://i.scdn.co/image/ab67616d0000b2736234c2c6d4bb935839ac4719', 'Lil Durk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jpzcyywzym9upouhyns8cwgcqbeefyddsfbg1uzlluzzphldzr','Stand By Me (feat. Morgan Wallen)','lkctjm59u4kvc9a',100,'POP','1fXnu2HzxbDtoyvFPWG3Bw','https://p.scdn.co/mp3-preview/ed64766975b1f0b3aa57741935c3f20e833c47db?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4e6zgxwehvtvlif3kxj911o37o6hsxdjnhhygidfd14zxcjet1', 'jpzcyywzym9upouhyns8cwgcqbeefyddsfbg1uzlluzzphldzr', '0');
-- Grupo Frontera
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q4seru2d7hajn8b', 'Grupo Frontera', '60@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f1a7e9f510bf0501e209c58','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:60@artist.com', 'q4seru2d7hajn8b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q4seru2d7hajn8b', 'Igniting the stage with electrifying performances.', 'Grupo Frontera');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('f2jk4pag10inh2z0bymbw54lh3f0jem1qg6ky0c45veax97yv5','q4seru2d7hajn8b', 'https://i.scdn.co/image/ab67616d0000b27382ce4c7bbf861185252e82ae', 'Grupo Frontera Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a21pr7h20hlsm28mjqzzss172hargrpnswdlx3xd1ayq07zv3i','No Se Va','q4seru2d7hajn8b',100,'POP','76kelNDs1ojicx1s6Urvck','https://p.scdn.co/mp3-preview/1aa36481ad26b54ce635e7eb7d7360353c09d9ea?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f2jk4pag10inh2z0bymbw54lh3f0jem1qg6ky0c45veax97yv5', 'a21pr7h20hlsm28mjqzzss172hargrpnswdlx3xd1ayq07zv3i', '0');
-- DJ Escobar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vydcj94iym1lj5d', 'DJ Escobar', '61@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb62fa9c7f56a64dc956ec2621','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:61@artist.com', 'vydcj94iym1lj5d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vydcj94iym1lj5d', 'Weaving lyrical magic into every song.', 'DJ Escobar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8iy8azkcdfn4w5z5ua4lx5enqjnr1wp1fymw3wqej616kyqy4r','vydcj94iym1lj5d', 'https://i.scdn.co/image/ab67616d0000b273769f6572dfa10ee7827edbf2', 'DJ Escobar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yxumcou1s36gw0hd6uvnrft41lzg4doh4f0l9qfzt8qrfda1ct','Evoque Prata','vydcj94iym1lj5d',100,'POP','4mQ2UZzSH3T4o4Gr9phTgL','https://p.scdn.co/mp3-preview/f2c69618853c528447f24f0102d0e5404fe31ed9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8iy8azkcdfn4w5z5ua4lx5enqjnr1wp1fymw3wqej616kyqy4r', 'yxumcou1s36gw0hd6uvnrft41lzg4doh4f0l9qfzt8qrfda1ct', '0');
-- Chris Molitor
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c8u0ta0na301fed', 'Chris Molitor', '62@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03851b1c2471a8c0b57371c4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:62@artist.com', 'c8u0ta0na301fed', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c8u0ta0na301fed', 'Delivering heartfelt music that speaks to the soul, blending folk and indie vibes.', 'Chris Molitor');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jww3n7ziveznvua81cudau2709cgvu6xs1m9s0w8gewwn6ic8z','c8u0ta0na301fed', 'https://i.scdn.co/image/ab67616d0000b273be011d16b9360a7dee109774', 'Chris Molitor Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ypcwubwpf8bz5vib4zfj8n911s1bzjvh3gjr5krwefnuuprmax','Yellow','c8u0ta0na301fed',100,'POP','6tvs7zEP8d1SBgSqZQ84OT','https://p.scdn.co/mp3-preview/ea93f9b43fc638111ad661719037bfb88cd9c05d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jww3n7ziveznvua81cudau2709cgvu6xs1m9s0w8gewwn6ic8z', 'ypcwubwpf8bz5vib4zfj8n911s1bzjvh3gjr5krwefnuuprmax', '0');
-- j-hope
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('46xkbty0gmmoweq', 'j-hope', '63@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeb746063d1aafa2817ea11b5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:63@artist.com', '46xkbty0gmmoweq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('46xkbty0gmmoweq', 'Creating a tapestry of tunes that celebrates diversity.', 'j-hope');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lkfi1axkor57icjwg1a53u7ejmdxrn6jji3z47ombqcbd9ooff','46xkbty0gmmoweq', 'https://i.scdn.co/image/ab67616d0000b2735e8286ff63f7efce1881a02b', 'j-hope Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3h6pyh655fd0nh3javtk434vctbwbaz40bek19t6csq272np44','on the street (with J. Cole)','46xkbty0gmmoweq',100,'POP','5wxYxygyHpbgv0EXZuqb9V','https://p.scdn.co/mp3-preview/c69cf6ed41027bd08a5953b556cca144ff8ed2bf?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lkfi1axkor57icjwg1a53u7ejmdxrn6jji3z47ombqcbd9ooff', '3h6pyh655fd0nh3javtk434vctbwbaz40bek19t6csq272np44', '0');
-- Gunna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ztlf1f2olk9uh46', 'Gunna', '64@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6501f8a7d50c56e86e46f920','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:64@artist.com', 'ztlf1f2olk9uh46', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ztlf1f2olk9uh46', 'A trailblazer in trap music, known for his smooth flow and catchy beats.', 'Gunna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3msfz9mnqndj48v79csk9q64588g7g83worf3yav521o12e8sv','ztlf1f2olk9uh46', 'https://i.scdn.co/image/ab67616d0000b273017d5e26552345c4b1575b6c', 'Gunna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ulw0dsl2sx5wwml3pqnrnq1dxrkrr7lz72r7xbhydxlxff5gtb','fukumean','ztlf1f2olk9uh46',100,'POP','4rXLjWdF2ZZpXCVTfWcshS','https://p.scdn.co/mp3-preview/f237ab921af697ba9b49e12fa167c2ce1a82d6b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3msfz9mnqndj48v79csk9q64588g7g83worf3yav521o12e8sv', 'ulw0dsl2sx5wwml3pqnrnq1dxrkrr7lz72r7xbhydxlxff5gtb', '0');
-- Ana Castela
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('abxq569yi0y52fh', 'Ana Castela', '65@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26abde7ba3cfdfb8c1900baf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:65@artist.com', 'abxq569yi0y52fh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('abxq569yi0y52fh', 'A journey through the spectrum of sound in every album.', 'Ana Castela');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yl1c0ssg3zyoxn6iotu119m5efgjzujwsbr2eap41ve0rg4re4','abxq569yi0y52fh', NULL, 'Ana Castela Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f91r8534ccwca7hsl0qzmz7ng1nxmwjhsu7unqngzqvpwmryv8','Nosso Quadro','abxq569yi0y52fh',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yl1c0ssg3zyoxn6iotu119m5efgjzujwsbr2eap41ve0rg4re4', 'f91r8534ccwca7hsl0qzmz7ng1nxmwjhsu7unqngzqvpwmryv8', '0');
-- Styrx
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q49ijw5u4cat66h', 'Styrx', '66@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfef3008e708e59efaa5667ed','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:66@artist.com', 'q49ijw5u4cat66h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q49ijw5u4cat66h', 'Blending genres for a fresh musical experience.', 'Styrx');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('okkb5i51m15slw927yiu7af3rqv9g8z7krbi5oe8pir92awmwc','q49ijw5u4cat66h', NULL, 'Styrx Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('14rgbrq69h3n6bfgxy3ntwugqv1ndfuthtrpgs8o8ppis4lkj7','Agudo Mgi','q49ijw5u4cat66h',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('okkb5i51m15slw927yiu7af3rqv9g8z7krbi5oe8pir92awmwc', '14rgbrq69h3n6bfgxy3ntwugqv1ndfuthtrpgs8o8ppis4lkj7', '0');
-- Kenia OS
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u5dgh54oc0s8pem', 'Kenia OS', '67@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7cee297b5eaaa121f9558d7e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:67@artist.com', 'u5dgh54oc0s8pem', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u5dgh54oc0s8pem', 'Crafting soundscapes that transport listeners to another world.', 'Kenia OS');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ngn6sgdj7667nbsfp3h4rklcxlqwky8mnfsawsgj6kj4t67juk','u5dgh54oc0s8pem', 'https://i.scdn.co/image/ab67616d0000b2739afe5698b0a9559dabc44ac8', 'Kenia OS Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y43x83tek0djyp3y8cbceo9dguqyp3qaeznccmglys63dcrqmv','Malas Decisiones','u5dgh54oc0s8pem',100,'POP','6Xj014IHwbLVjiVT6H89on','https://p.scdn.co/mp3-preview/9a71f09b224a9e6f521743423bd53e99c7c4793c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ngn6sgdj7667nbsfp3h4rklcxlqwky8mnfsawsgj6kj4t67juk', 'y43x83tek0djyp3y8cbceo9dguqyp3qaeznccmglys63dcrqmv', '0');
-- Jack Harlow
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('eiu15sz10b1239i', 'Jack Harlow', '68@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5ee4635b0775e342e064657','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:68@artist.com', 'eiu15sz10b1239i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('eiu15sz10b1239i', 'Crafting melodies that resonate with the soul.', 'Jack Harlow');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cxaobfuvrwnnpq3egeegez4tedpcnq7x35317yhsqg1on26e2v','eiu15sz10b1239i', NULL, 'Jack Harlow Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jqrs4oi9w55j5v5t76vkvnqbh9it8g7lm1itpxk12zzezuvta9','INDUSTRY BABY (feat. Jack Harlow)','eiu15sz10b1239i',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cxaobfuvrwnnpq3egeegez4tedpcnq7x35317yhsqg1on26e2v', 'jqrs4oi9w55j5v5t76vkvnqbh9it8g7lm1itpxk12zzezuvta9', '0');
-- Justin Bieber
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hyj32bdm7acb684', 'Justin Bieber', '69@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:69@artist.com', 'hyj32bdm7acb684', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hyj32bdm7acb684', 'From teen idol to global pop star, constantly evolving his sound.', 'Justin Bieber');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e9zf7epm9nk5za08sexsvm44ghph0hwnb34y05xt1e0jbhm0to','hyj32bdm7acb684', NULL, 'Justin Bieber Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xv91mb96lbrwuezfzfheqw2oqv8tr2hnq28uffbxp2ea0xe2tn','STAY (with Justin Bieber)','hyj32bdm7acb684',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e9zf7epm9nk5za08sexsvm44ghph0hwnb34y05xt1e0jbhm0to', 'xv91mb96lbrwuezfzfheqw2oqv8tr2hnq28uffbxp2ea0xe2tn', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6vnlcm9spyg7ej67mqi07566mfrff82vxe6rwbvali3x971uu6','Ghost','hyj32bdm7acb684',100,'POP','6I3mqTwhRpn34SLVafSH7G',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e9zf7epm9nk5za08sexsvm44ghph0hwnb34y05xt1e0jbhm0to', '6vnlcm9spyg7ej67mqi07566mfrff82vxe6rwbvali3x971uu6', '1');
-- WizKid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9g1qqtrg85dhpns', 'WizKid', '70@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9050b61368975fda051cdc06','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:70@artist.com', '9g1qqtrg85dhpns', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9g1qqtrg85dhpns', 'An odyssey of sound that defies conventions.', 'WizKid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1qizyhdffwb9ebzj0ujwra4aiilydzpgof8f77phq2w89a9rp8','9g1qqtrg85dhpns', NULL, 'WizKid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qthkidczxwljts4f031rb6u16v15wkzw8h2mm3wqiw4agrkilg','Link Up (Metro Boomin & Don Toliver, Wizkid feat. BEAM & Toian) - Spider-Verse Remix (Spider-Man: Across the Spider-Verse )','9g1qqtrg85dhpns',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1qizyhdffwb9ebzj0ujwra4aiilydzpgof8f77phq2w89a9rp8', 'qthkidczxwljts4f031rb6u16v15wkzw8h2mm3wqiw4agrkilg', '0');
-- New West
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0cr292xiicsc9wm', 'New West', '71@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb32a5faa77c82348cf5d13590','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:71@artist.com', '0cr292xiicsc9wm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0cr292xiicsc9wm', 'Revolutionizing the music scene with innovative compositions.', 'New West');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7dc8443k8inazdqonzqzksc1vpd4dmfmsgdn5tbgte5l19o022','0cr292xiicsc9wm', 'https://i.scdn.co/image/ab67616d0000b2731bb5dc21200bfc56d8f7ef41', 'New West Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4cs0px0pjz4lnkfjadkada77mqax5hod3v9lzg729c9iin30oq','Those Eyes','0cr292xiicsc9wm',100,'POP','50x1Ic8CaXkYNvjmxe3WXy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7dc8443k8inazdqonzqzksc1vpd4dmfmsgdn5tbgte5l19o022', '4cs0px0pjz4lnkfjadkada77mqax5hod3v9lzg729c9iin30oq', '0');
-- Future
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bfrusk6ldi3fwe8', 'Future', '72@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:72@artist.com', 'bfrusk6ldi3fwe8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bfrusk6ldi3fwe8', 'Creating a tapestry of tunes that celebrates diversity.', 'Future');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0bfnh5petp2lqqe88s7975hqo5ooicbec9vwnxfqozthh7jtq5','bfrusk6ldi3fwe8', NULL, 'Future Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e61sfokixzhneii0ezbyeu6hfr8mwgx3sdnmsyjiv71dpqf2gu','Too Many Nights (feat. Don Toliver & with Future)','bfrusk6ldi3fwe8',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0bfnh5petp2lqqe88s7975hqo5ooicbec9vwnxfqozthh7jtq5', 'e61sfokixzhneii0ezbyeu6hfr8mwgx3sdnmsyjiv71dpqf2gu', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('crfvvo5w0lf8qymtkigcpridv0g5p6i0w5ggl60a3z5yvkna2p','All The Way Live (Spider-Man: Across the Spider-Verse) (Metro Boomin & Future, Lil Uzi Vert)','bfrusk6ldi3fwe8',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0bfnh5petp2lqqe88s7975hqo5ooicbec9vwnxfqozthh7jtq5', 'crfvvo5w0lf8qymtkigcpridv0g5p6i0w5ggl60a3z5yvkna2p', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('639zdlxl0spjwjoihvjxz06zlr7tnphxq7gb6vm1detsgcjtk8','Superhero (Heroes & Villains) [with Future & Chris Brown]','bfrusk6ldi3fwe8',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0bfnh5petp2lqqe88s7975hqo5ooicbec9vwnxfqozthh7jtq5', '639zdlxl0spjwjoihvjxz06zlr7tnphxq7gb6vm1detsgcjtk8', '2');
-- Kali Uchis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8ttl4w2u2z096zs', 'Kali Uchis', '73@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:73@artist.com', '8ttl4w2u2z096zs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8ttl4w2u2z096zs', 'A fusion of soul, R&B, and Latin beats, creating a unique sound experience.', 'Kali Uchis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('w9xwludm5idruvzse5ihb56906912c33p6nxz9u6vz1lrtvj6o','8ttl4w2u2z096zs', 'https://i.scdn.co/image/ab67616d0000b27381fccd758776d16b87721b17', 'Kali Uchis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f6er57vozfl8mw7y3ysk4szjyp5e4ygpuwz5kwji14pzsr4b2w','Moonlight','8ttl4w2u2z096zs',100,'POP','0JmnkIqdlnUzPaf8sqBRs3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w9xwludm5idruvzse5ihb56906912c33p6nxz9u6vz1lrtvj6o', 'f6er57vozfl8mw7y3ysk4szjyp5e4ygpuwz5kwji14pzsr4b2w', '0');
-- Libianca
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3h436kyukd8uy1u', 'Libianca', '74@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a42e7c32ead029c0285c12f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:74@artist.com', '3h436kyukd8uy1u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3h436kyukd8uy1u', 'A fresh talent, blending Afrobeat rhythms with soulful melodies.', 'Libianca');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qn05i3o47znftnnt8zcbd1dvny6c27s5hp0b9i2eoiwcd2dmjb','3h436kyukd8uy1u', 'https://i.scdn.co/image/ab67616d0000b273fc342f95f117d48dbdde9735', 'Libianca Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6954zgpq2fx5pkkwrz7dv6hevst8pw66wvq5tbjht3xis7yavu','People','3h436kyukd8uy1u',100,'POP','26b3oVLrRUaaybJulow9kz','https://p.scdn.co/mp3-preview/abcbc9adf10ae4901b40b80a30dc194d589c2d62?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qn05i3o47znftnnt8zcbd1dvny6c27s5hp0b9i2eoiwcd2dmjb', '6954zgpq2fx5pkkwrz7dv6hevst8pw66wvq5tbjht3xis7yavu', '0');
-- Calvin Harris
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vpoucuf19zozsa4', 'Calvin Harris', '75@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb37bff6aa1d42bede9048750f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:75@artist.com', 'vpoucuf19zozsa4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vpoucuf19zozsa4', 'A symphony of emotions expressed through sound.', 'Calvin Harris');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t71uuiroc6h7r1232tq57nxuekwwbvb66k8vuwkarl25kn61k0','vpoucuf19zozsa4', 'https://i.scdn.co/image/ab67616d0000b273c58e22815048f8dfb1aa8bd0', 'Calvin Harris Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f3q3rxe56f09xa3mtic52h6ietfdqqxjc4oo80vksjj4ukgkul','Miracle (with Ellie Goulding)','vpoucuf19zozsa4',100,'POP','5eTaQYBE1yrActixMAeLcZ','https://p.scdn.co/mp3-preview/48a88093bc85e735791115290125fc354f8ed068?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t71uuiroc6h7r1232tq57nxuekwwbvb66k8vuwkarl25kn61k0', 'f3q3rxe56f09xa3mtic52h6ietfdqqxjc4oo80vksjj4ukgkul', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bhukuzjuuq7vlx9su6utygp8umkqcvxwul6q4ihpbvmytemyxl','One Kiss (with Dua Lipa)','vpoucuf19zozsa4',100,'POP','7ef4DlsgrMEH11cDZd32M6','https://p.scdn.co/mp3-preview/0c09da1fe6f1da091c05057835e6be2312e2dc18?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t71uuiroc6h7r1232tq57nxuekwwbvb66k8vuwkarl25kn61k0', 'bhukuzjuuq7vlx9su6utygp8umkqcvxwul6q4ihpbvmytemyxl', '1');
-- Beach House
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fkn5ysasih8tuy1', 'Beach House', '76@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb3e38a46a56a423d8f741c09','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:76@artist.com', 'fkn5ysasih8tuy1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fkn5ysasih8tuy1', 'Pioneering new paths in the musical landscape.', 'Beach House');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e1pfpjf710k6qb0nf1uzazlzb9nt2ci1ihfuptzi1v38czvs12','fkn5ysasih8tuy1', 'https://i.scdn.co/image/ab67616d0000b2739b7190e673e46271b2754aab', 'Beach House Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e1vyiyt5g9px9x9xr6za76jkof0exli95ypx6abunspqb95qmn','Space Song','fkn5ysasih8tuy1',100,'POP','7H0ya83CMmgFcOhw0UB6ow','https://p.scdn.co/mp3-preview/3d50d7331c2ef197699e796d08cf8d4009591be0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e1pfpjf710k6qb0nf1uzazlzb9nt2ci1ihfuptzi1v38czvs12', 'e1vyiyt5g9px9x9xr6za76jkof0exli95ypx6abunspqb95qmn', '0');
-- Kaliii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j5jyqk3yf09xtel', 'Kaliii', '77@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb749bcc7f4b8d1d60f5f13744','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:77@artist.com', 'j5jyqk3yf09xtel', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j5jyqk3yf09xtel', 'A confluence of cultural beats and contemporary tunes.', 'Kaliii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lo9165ivltj57m2k9fxwkzj39jwxt9z6m6elr3595h3ioj3izn','j5jyqk3yf09xtel', 'https://i.scdn.co/image/ab67616d0000b2733eecc265c134153c14794aab', 'Kaliii Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1zcggl9197v4rjam5crawzm5krkj8vzuyr4l2n57c7b7cv4hul','Area Codes','j5jyqk3yf09xtel',100,'POP','7sliFe6W30tPBPh6dvZsIH','https://p.scdn.co/mp3-preview/d1beed2734f948ec9c33164d3aa818e04f4afd30?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lo9165ivltj57m2k9fxwkzj39jwxt9z6m6elr3595h3ioj3izn', '1zcggl9197v4rjam5crawzm5krkj8vzuyr4l2n57c7b7cv4hul', '0');
-- Robin Schulz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2p6nx794qv2tuhn', 'Robin Schulz', '78@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2615ef39cf9128c447b31619','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:78@artist.com', '2p6nx794qv2tuhn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2p6nx794qv2tuhn', 'Weaving lyrical magic into every song.', 'Robin Schulz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1ffs9zb2vk9xjr0djbo4bo5bacxqxwo28ji72kbpoycdkj6dmf','2p6nx794qv2tuhn', NULL, 'Robin Schulz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d0gu708e97gemrvld32padaau3rkur8kz3yxif8quxgieepnz7','Miss You','2p6nx794qv2tuhn',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1ffs9zb2vk9xjr0djbo4bo5bacxqxwo28ji72kbpoycdkj6dmf', 'd0gu708e97gemrvld32padaau3rkur8kz3yxif8quxgieepnz7', '0');
-- Gorillaz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('66c2r083bs0hnb1', 'Gorillaz', '79@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb337d671a32b2f44d4a4e6cf2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:79@artist.com', '66c2r083bs0hnb1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('66c2r083bs0hnb1', 'Transcending language barriers through the universal language of music.', 'Gorillaz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hpy6xcm6mzphcr826l36a464jdemb6s6flr5lm6bqcv9r8kbjd','66c2r083bs0hnb1', 'https://i.scdn.co/image/ab67616d0000b2734b0ddebba0d5b34f2a2f07a4', 'Gorillaz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sypkfqjgyb1ssowh4zlq3vadklmlmr6e78bwfx64l9gv4khur3','Tormenta (feat. Bad Bunny)','66c2r083bs0hnb1',100,'POP','38UYeBLfvpnDSG9GznZdnL','https://p.scdn.co/mp3-preview/3f89a1c3ec527e23fdefdd03da7797b83eb6e14f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hpy6xcm6mzphcr826l36a464jdemb6s6flr5lm6bqcv9r8kbjd', 'sypkfqjgyb1ssowh4zlq3vadklmlmr6e78bwfx64l9gv4khur3', '0');
-- XXXTENTACION
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1cnplz4rkgjtitp', 'XXXTENTACION', '80@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf0c20db5ef6c6fbe5135d2e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:80@artist.com', '1cnplz4rkgjtitp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1cnplz4rkgjtitp', 'A symphony of emotions expressed through sound.', 'XXXTENTACION');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kw44lrsv8vomzb2oisuru8pqjbvpxno2bsknddd5hiv17e5vbu','1cnplz4rkgjtitp', 'https://i.scdn.co/image/ab67616d0000b273203c89bd4391468eea4cc3f5', 'XXXTENTACION Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0slqhag1rksleo9rgbjouv8qa454f9q3p029jay1hnhujl7i30','Revenge','1cnplz4rkgjtitp',100,'POP','5TXDeTFVRVY7Cvt0Dw4vWW','https://p.scdn.co/mp3-preview/8f5fe8bb510463b2da20325c8600200bf2984d83?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kw44lrsv8vomzb2oisuru8pqjbvpxno2bsknddd5hiv17e5vbu', '0slqhag1rksleo9rgbjouv8qa454f9q3p029jay1hnhujl7i30', '0');
-- Jung Kook
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uozxue4ah6ij6ob', 'Jung Kook', '81@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:81@artist.com', 'uozxue4ah6ij6ob', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uozxue4ah6ij6ob', 'A member of BTS, captivating fans with his powerful vocals and dynamic performances.', 'Jung Kook');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gbp2qxur2k641oxdvifmvbg6fchnup13m98aq7g93lfw9i7krd','uozxue4ah6ij6ob', 'https://i.scdn.co/image/ab67616d0000b273a7f42c375578df426b37638d', 'Jung Kook Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('chbmrpcyqxt7qcmmk6p24m4qgun5g57nsm8551rcu2hwq91rf8','Still With You','uozxue4ah6ij6ob',100,'POP','0eFMbKCRw8KByXyWBw8WO7','https://p.scdn.co/mp3-preview/af2a740e10a6956dedd7e7f66fd65d7166e9187f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gbp2qxur2k641oxdvifmvbg6fchnup13m98aq7g93lfw9i7krd', 'chbmrpcyqxt7qcmmk6p24m4qgun5g57nsm8551rcu2hwq91rf8', '0');
-- Tainy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gl8p9tj77u74dqh', 'Tainy', '82@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb50d43598b9074f0d6146127','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:82@artist.com', 'gl8p9tj77u74dqh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gl8p9tj77u74dqh', 'Revolutionizing reggaeton and Latin music with groundbreaking production.', 'Tainy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mzcm0c8kiy437q84l3d5nyg8t637h8x6thmw2us9tyv0g7zpcj','gl8p9tj77u74dqh', 'https://i.scdn.co/image/ab67616d0000b273de7b9af78fbdda96c5a0635b', 'Tainy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n7wt7bvz5l73xfeumwdguxmk961xe8ym2jde9r0l414j16rqhc','MOJABI GHOST','gl8p9tj77u74dqh',100,'POP','4eMKD8MRroxCqugpsxCCNb','https://p.scdn.co/mp3-preview/a6d8180d52b759c3e3db9aa78e841ffc06e26c17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mzcm0c8kiy437q84l3d5nyg8t637h8x6thmw2us9tyv0g7zpcj', 'n7wt7bvz5l73xfeumwdguxmk961xe8ym2jde9r0l414j16rqhc', '0');
-- Aerosmith
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nc7hrtzhh5g0hnp', 'Aerosmith', '83@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5733401b4689b2064458e7d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:83@artist.com', 'nc7hrtzhh5g0hnp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nc7hrtzhh5g0hnp', 'Striking chords that resonate across generations.', 'Aerosmith');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ide49hii6lfvkji0x5nua8qxlovtejxzw82miqqbgb4u1eyuhv','nc7hrtzhh5g0hnp', 'https://i.scdn.co/image/ab67616d0000b273bbf0146981704a073405b6c2', 'Aerosmith Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fblqcp9a2c5ecc6gkwdvuyw8zs7tly47oui6m520c7srajbgxs','Dream On','nc7hrtzhh5g0hnp',100,'POP','1xsYj84j7hUDDnTTerGWlH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ide49hii6lfvkji0x5nua8qxlovtejxzw82miqqbgb4u1eyuhv', 'fblqcp9a2c5ecc6gkwdvuyw8zs7tly47oui6m520c7srajbgxs', '0');
-- Meghan Trainor
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f5r5yn7qo2mz4tp', 'Meghan Trainor', '84@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4d8f97058ff993df0f4eb9ee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:84@artist.com', 'f5r5yn7qo2mz4tp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('f5r5yn7qo2mz4tp', 'Blending traditional rhythms with modern beats.', 'Meghan Trainor');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j3oovmfflaxc2nzhc37xv5ldfuyomg2gr1jf2ovya1bgcsao3j','f5r5yn7qo2mz4tp', 'https://i.scdn.co/image/ab67616d0000b2731a4f1ada93881da4ca8060ff', 'Meghan Trainor Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bwb7she6pbcomktxhti4nd7f3903tqvvcsvytw10e2ftc2aq43','Made You Look','f5r5yn7qo2mz4tp',100,'POP','0QHEIqNKsMoOY5urbzN48u','https://p.scdn.co/mp3-preview/f0eb89945aa820c0f30b5e97f8e2cab42d9f0a99?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j3oovmfflaxc2nzhc37xv5ldfuyomg2gr1jf2ovya1bgcsao3j', 'bwb7she6pbcomktxhti4nd7f3903tqvvcsvytw10e2ftc2aq43', '0');
-- ThxSoMch
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vxagt3q4n8nruhr', 'ThxSoMch', '85@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcce84671d294b0cefb8fe1c0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:85@artist.com', 'vxagt3q4n8nruhr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vxagt3q4n8nruhr', 'An alchemist of harmonies, transforming notes into gold.', 'ThxSoMch');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('git9249gtwqk9lxm781hku7xo1gf3belg2vrrem49ry4lkpamk','vxagt3q4n8nruhr', 'https://i.scdn.co/image/ab67616d0000b27360ddc59c8d590a37cf2348f3', 'ThxSoMch Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jwyzfvbcme0v7m4frss6h4ilryhfnmmga7n8kh6tkvpgiimg8g','SPIT IN MY FACE!','vxagt3q4n8nruhr',100,'POP','1N8TTK1Uoy7UvQNUazfUt5','https://p.scdn.co/mp3-preview/a4146e5dd430d70eda83e57506ba5ed402935200?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('git9249gtwqk9lxm781hku7xo1gf3belg2vrrem49ry4lkpamk', 'jwyzfvbcme0v7m4frss6h4ilryhfnmmga7n8kh6tkvpgiimg8g', '0');
-- Nengo Flow
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q2jvcwv3evm98eo', 'Nengo Flow', '86@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebda3f48cf2309aacaab0edce2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:86@artist.com', 'q2jvcwv3evm98eo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q2jvcwv3evm98eo', 'Uniting fans around the globe with universal rhythms.', 'Nengo Flow');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jsqmlfnz02jmg8tnclfepw86v8w9iejatmxer70rvoy795sa69','q2jvcwv3evm98eo', 'https://i.scdn.co/image/ab67616d0000b273ed132404686f567c8f793058', 'Nengo Flow Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bzfq5eqhtfrnn0gbt22aw4ju8bysvl4jhupzcixr2ef3gkf11s','Gato de Noche','q2jvcwv3evm98eo',100,'POP','54ELExv56KCAB4UP9cOCzC','https://p.scdn.co/mp3-preview/7d6a9dab2f3779eef37ef52603d20607a1390d91?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jsqmlfnz02jmg8tnclfepw86v8w9iejatmxer70rvoy795sa69', 'bzfq5eqhtfrnn0gbt22aw4ju8bysvl4jhupzcixr2ef3gkf11s', '0');
-- Treyce
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('54u9sd2uzw568ln', 'Treyce', '87@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7b48fa6e2c8280e205c5ea7b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:87@artist.com', '54u9sd2uzw568ln', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('54u9sd2uzw568ln', 'A symphony of emotions expressed through sound.', 'Treyce');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pc1mvz8c55ut3itt5d22yyqndcw08ud67q3sagaszmtkdfurpy','54u9sd2uzw568ln', NULL, 'Treyce Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nr7ef3xdb37uesc452p45jpowd610i41ere66sskk231qqiwwf','Lovezinho','54u9sd2uzw568ln',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pc1mvz8c55ut3itt5d22yyqndcw08ud67q3sagaszmtkdfurpy', 'nr7ef3xdb37uesc452p45jpowd610i41ere66sskk231qqiwwf', '0');
-- Raim Laode
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ofh9wd1yoyzjzg5', 'Raim Laode', '88@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f5fe38a2d25be089bf281e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:88@artist.com', 'ofh9wd1yoyzjzg5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ofh9wd1yoyzjzg5', 'A sonic adventurer, always seeking new horizons in music.', 'Raim Laode');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dyc3jkiuzadqnf6kbyqf3of09bkx9v19qdlsdccaj1253fxvmn','ofh9wd1yoyzjzg5', 'https://i.scdn.co/image/ab67616d0000b273f20ec6ba1f431a90dbf2e8b6', 'Raim Laode Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('54w7t1iuyr0sh8sk2pr3klt7g8h5btf9y22dby1ppe7tgmfw3n','Komang','ofh9wd1yoyzjzg5',100,'POP','2AaaE0qvFWtyT8srKNfRhH','https://p.scdn.co/mp3-preview/47575d13a133216ab684c5211af483a7524e89db?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dyc3jkiuzadqnf6kbyqf3of09bkx9v19qdlsdccaj1253fxvmn', '54w7t1iuyr0sh8sk2pr3klt7g8h5btf9y22dby1ppe7tgmfw3n', '0');
-- Halsey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7fmwpdbiptrilc0', 'Halsey', '89@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd707e1c5177614c4ec95a06c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:89@artist.com', '7fmwpdbiptrilc0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7fmwpdbiptrilc0', 'Pioneering new paths in the musical landscape.', 'Halsey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ngbwtpntlo4rqtsho1gldkjgltqd3k9e0lo3amqg1rjrqegrwk','7fmwpdbiptrilc0', 'https://i.scdn.co/image/ab67616d0000b273f19310c007c0fad365b0542e', 'Halsey Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ihr81fbn0zoa0l0fdu7r5zu36gngz4vvckoxbvoq6wt73x8ccz','Lilith (feat. SUGA of BTS) (Diablo IV Anthem)','7fmwpdbiptrilc0',100,'POP','3l6LBCOL9nPsSY29TUY2VE',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ngbwtpntlo4rqtsho1gldkjgltqd3k9e0lo3amqg1rjrqegrwk', 'ihr81fbn0zoa0l0fdu7r5zu36gngz4vvckoxbvoq6wt73x8ccz', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nk4pjf12l24vsbvj1j8zw2mzgld5gg9f11z9xj1wxrknvju7j5','Boy With Luv (feat. Halsey)','7fmwpdbiptrilc0',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ngbwtpntlo4rqtsho1gldkjgltqd3k9e0lo3amqg1rjrqegrwk', 'nk4pjf12l24vsbvj1j8zw2mzgld5gg9f11z9xj1wxrknvju7j5', '1');
-- IU
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yptmwy1931mad6y', 'IU', '90@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb006ff3c0136a71bfb9928d34','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:90@artist.com', 'yptmwy1931mad6y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yptmwy1931mad6y', 'Melodies that capture the essence of human emotion.', 'IU');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1c8wkc2d7uc5fl24wt3wjbfsifluyveujr7vxv4b9wzb5w6e2l','yptmwy1931mad6y', NULL, 'IU Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bkbvjjetwhdb9s8jfkh87gp8wr1posq96z5c8nwln556qtbqv0','People Pt.2 (feat. IU)','yptmwy1931mad6y',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1c8wkc2d7uc5fl24wt3wjbfsifluyveujr7vxv4b9wzb5w6e2l', 'bkbvjjetwhdb9s8jfkh87gp8wr1posq96z5c8nwln556qtbqv0', '0');
-- BLACKPINK
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1en24k7cdrkolrf', 'BLACKPINK', '91@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc9690bc711d04b3d4fd4b87c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:91@artist.com', '1en24k7cdrkolrf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1en24k7cdrkolrf', 'Creating a tapestry of tunes that celebrates diversity.', 'BLACKPINK');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8uvzg5ucv5g1ecvxvpo4172hucyxakq8ggj9ve2uep17ud5078','1en24k7cdrkolrf', 'https://i.scdn.co/image/ab67616d0000b273002ef53878df1b4e91c15406', 'BLACKPINK Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('22eup1sckullo35wjaaiv71b9y0mf1ubajl5m9czb26r6lz17m','Shut Down','1en24k7cdrkolrf',100,'POP','7gRFDGEzF9UkBV233yv2dc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8uvzg5ucv5g1ecvxvpo4172hucyxakq8ggj9ve2uep17ud5078', '22eup1sckullo35wjaaiv71b9y0mf1ubajl5m9czb26r6lz17m', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cueyiz3joy0pcbjo3jl669vl4ku6ed4wetjatrntv74aaudjw1','Pink Venom','1en24k7cdrkolrf',100,'POP','5zwwW9Oq7ubSxoCGyW1nbY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8uvzg5ucv5g1ecvxvpo4172hucyxakq8ggj9ve2uep17ud5078', 'cueyiz3joy0pcbjo3jl669vl4ku6ed4wetjatrntv74aaudjw1', '1');
-- Freddie Dredd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y7rig941mo097pd', 'Freddie Dredd', '92@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9d100e5a9cf34beab8e75750','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:92@artist.com', 'y7rig941mo097pd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y7rig941mo097pd', 'Delivering soul-stirring tunes that linger in the mind.', 'Freddie Dredd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l8hhrf5om2i34u0wejcsuk8glv560u1vs7aaqy1y7cr6kvs46i','y7rig941mo097pd', 'https://i.scdn.co/image/ab67616d0000b27369b381d574b329409bd806e6', 'Freddie Dredd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dln3c8mmerriaortduzr753r9vbi595b2ytvgpwml1zy5hakah','Limbo','y7rig941mo097pd',100,'POP','37F7E7BKEw2E4O2L7u0IEp','https://p.scdn.co/mp3-preview/1715e2acb52d6fdd0e4b11ea8792688c12987ff7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l8hhrf5om2i34u0wejcsuk8glv560u1vs7aaqy1y7cr6kvs46i', 'dln3c8mmerriaortduzr753r9vbi595b2ytvgpwml1zy5hakah', '0');
-- Billie Eilish
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9d5f56v9azg3k01', 'Billie Eilish', '93@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd8b9980db67272cb4d2c3daf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:93@artist.com', '9d5f56v9azg3k01', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9d5f56v9azg3k01', 'An icon in modern pop, known for her haunting vocals and introspective lyrics.', 'Billie Eilish');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u5tzf5aphksrfaohso7ex3ekpr0tiaq1qufjqm7z5kh8nlgjes','9d5f56v9azg3k01', NULL, 'Billie Eilish Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bpquq4ebxg70hdk3r0gdabwychyfholj79pta74t191xffyi9w','What Was I Made For? [From The Motion Picture "Barbie"]','9d5f56v9azg3k01',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u5tzf5aphksrfaohso7ex3ekpr0tiaq1qufjqm7z5kh8nlgjes', 'bpquq4ebxg70hdk3r0gdabwychyfholj79pta74t191xffyi9w', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bvm6qepz3411fw2ssktq5btjwocgqf4eowv0rzkge6gn1xql95','lovely - Bonus Track','9d5f56v9azg3k01',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u5tzf5aphksrfaohso7ex3ekpr0tiaq1qufjqm7z5kh8nlgjes', 'bvm6qepz3411fw2ssktq5btjwocgqf4eowv0rzkge6gn1xql95', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('b4r0kf9skzq6ogkjbjwji0ikzadqmc0ifrxpdut4rc4k8je8op','TV','9d5f56v9azg3k01',100,'POP','3GYlZ7tbxLOxe6ewMNVTkw',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u5tzf5aphksrfaohso7ex3ekpr0tiaq1qufjqm7z5kh8nlgjes', 'b4r0kf9skzq6ogkjbjwji0ikzadqmc0ifrxpdut4rc4k8je8op', '2');
-- Elley Duh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cn8vaksbb30z4ri', 'Elley Duh', '94@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb44efd91d240d9853049612b4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:94@artist.com', 'cn8vaksbb30z4ri', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cn8vaksbb30z4ri', 'Elevating the ordinary to extraordinary through music.', 'Elley Duh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('txfn7vv6o3yhihioq1i0yj9l09h9kea34py4rfi5oq023ze1u3','cn8vaksbb30z4ri', 'https://i.scdn.co/image/ab67616d0000b27353a2e11c1bde700722fecd2e', 'Elley Duh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8mq2zzh6yxn687ofoci2mc22pmtgc7jhlf3t5upsgtxlpcpojy','MIDDLE OF THE NIGHT','cn8vaksbb30z4ri',100,'POP','58HvfVOeJY7lUuCqF0m3ly','https://p.scdn.co/mp3-preview/e7c2441dcf8e321237c35085e4aa05bd0dcfa2c4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('txfn7vv6o3yhihioq1i0yj9l09h9kea34py4rfi5oq023ze1u3', '8mq2zzh6yxn687ofoci2mc22pmtgc7jhlf3t5upsgtxlpcpojy', '0');
-- David Kushner
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0q10ghetb3qt0kv', 'David Kushner', '95@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12fd1bd22516e35ef8c2e591','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:95@artist.com', '0q10ghetb3qt0kv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0q10ghetb3qt0kv', 'A rising talent, creating music that resonates with a generation.', 'David Kushner');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qd47qzg629rv6kftnkfrueo6l3a45jkxbxafum3137rd098rnj','0q10ghetb3qt0kv', 'https://i.scdn.co/image/ab67616d0000b27395ca6a9b4083a86c149934ae', 'David Kushner Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m4538scnugprtzjwlogd2rd3jgpd2nfpphnh5twksu05x6alu3','Daylight','0q10ghetb3qt0kv',100,'POP','1odExI7RdWc4BT515LTAwj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qd47qzg629rv6kftnkfrueo6l3a45jkxbxafum3137rd098rnj', 'm4538scnugprtzjwlogd2rd3jgpd2nfpphnh5twksu05x6alu3', '0');
-- NewJeans
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ip7omwbzk15nmet', 'NewJeans', '96@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5da361915b1fa48895d4f23f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:96@artist.com', 'ip7omwbzk15nmet', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ip7omwbzk15nmet', 'Redefining K-pop with their fresh style and energetic performances.', 'NewJeans');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('39t2nohd6ctpkh83mwcdupmrcuou0d6its4lykdrb45r7oeeaf','ip7omwbzk15nmet', 'https://i.scdn.co/image/ab67616d0000b2733d98a0ae7c78a3a9babaf8af', 'NewJeans Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kx7nv49hqypsdupz3ef1jq6e2ihzjiyjg50leoh70dg1ybcgsa','Super Shy','ip7omwbzk15nmet',100,'POP','5sdQOyqq2IDhvmx2lHOpwd','https://p.scdn.co/mp3-preview/dab062e2cc708a2680ce84953a3581c5a679a230?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('39t2nohd6ctpkh83mwcdupmrcuou0d6its4lykdrb45r7oeeaf', 'kx7nv49hqypsdupz3ef1jq6e2ihzjiyjg50leoh70dg1ybcgsa', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mjmyi1zslpczq2r09a0wbzvqp30wccxqb2elepr3ngmsdcfkve','New Jeans','ip7omwbzk15nmet',100,'POP','6rdkCkjk6D12xRpdMXy0I2','https://p.scdn.co/mp3-preview/a37b4269b0dc5e952826d8c43d1b7c072ac39b4c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('39t2nohd6ctpkh83mwcdupmrcuou0d6its4lykdrb45r7oeeaf', 'mjmyi1zslpczq2r09a0wbzvqp30wccxqb2elepr3ngmsdcfkve', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('27m05z1cysbe6gqb3en13s9swlv4l8x02q7ggeku26q0yv0v2p','OMG','ip7omwbzk15nmet',100,'POP','65FftemJ1DbbZ45DUfHJXE','https://p.scdn.co/mp3-preview/b9e344aa96afc45a56df77ca63c78786bdaa0047?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('39t2nohd6ctpkh83mwcdupmrcuou0d6its4lykdrb45r7oeeaf', '27m05z1cysbe6gqb3en13s9swlv4l8x02q7ggeku26q0yv0v2p', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gj4etn9d120ne3qcvrjzegh5k2zab3h6wgbdnj0xaejbrg3z8e','Ditto','ip7omwbzk15nmet',100,'POP','3r8RuvgbX9s7ammBn07D3W','https://p.scdn.co/mp3-preview/4f048713ddfa434539dec7c3cb689f3393353edd?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('39t2nohd6ctpkh83mwcdupmrcuou0d6its4lykdrb45r7oeeaf', 'gj4etn9d120ne3qcvrjzegh5k2zab3h6wgbdnj0xaejbrg3z8e', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('llj5u3xw7i6jymyzorvu3ow11ckd2ishuga7s3wrmbpp5jm0wr','Hype Boy','ip7omwbzk15nmet',100,'POP','0a4MMyCrzT0En247IhqZbD','https://p.scdn.co/mp3-preview/7c55950057fc446dc2ce59671dff4fa6b3ef52a7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('39t2nohd6ctpkh83mwcdupmrcuou0d6its4lykdrb45r7oeeaf', 'llj5u3xw7i6jymyzorvu3ow11ckd2ishuga7s3wrmbpp5jm0wr', '4');
-- Bobby Helms
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2axpvq3d2e7ek7m', 'Bobby Helms', '97@artist.com', 'https://i.scdn.co/image/1dcd3f5d64a65f19d085b8e78746e457bd2d2e05','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:97@artist.com', '2axpvq3d2e7ek7m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2axpvq3d2e7ek7m', 'A symphony of emotions expressed through sound.', 'Bobby Helms');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4xwj80klk3qor2wz7s7ams1re46xfd3vnftuqwlpkiqzoop1qs','2axpvq3d2e7ek7m', 'https://i.scdn.co/image/ab67616d0000b273fd56f3c7a294f5cfe51c7b17', 'Bobby Helms Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y1i6nnl59kqij5hpzeqseovgwsfdoxlrolq1094eki174q5abf','Jingle Bell Rock','2axpvq3d2e7ek7m',100,'POP','7vQbuQcyTflfCIOu3Uzzya',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4xwj80klk3qor2wz7s7ams1re46xfd3vnftuqwlpkiqzoop1qs', 'y1i6nnl59kqij5hpzeqseovgwsfdoxlrolq1094eki174q5abf', '0');
-- Daddy Yankee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('r9ugyo74yb7q42t', 'Daddy Yankee', '98@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf9ad208bbff79c1ce09c77c1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:98@artist.com', 'r9ugyo74yb7q42t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('r9ugyo74yb7q42t', 'Crafting melodies that resonate with the soul.', 'Daddy Yankee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tmfoitcjvyw048hqne5xkzi34qpju8k1g4w151usicctfcg0ep','r9ugyo74yb7q42t', 'https://i.scdn.co/image/ab67616d0000b2736bdcdf82ecce36bff808a40c', 'Daddy Yankee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mj2xmynrlyutvycl7iddam4sc4ai8mxtmfxv380ornpy6k7rpf','Gasolina','r9ugyo74yb7q42t',100,'POP','228BxWXUYQPJrJYHDLOHkj','https://p.scdn.co/mp3-preview/7c545be6847f3a6b13c4ad9c70d10a34f49a92d3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tmfoitcjvyw048hqne5xkzi34qpju8k1g4w151usicctfcg0ep', 'mj2xmynrlyutvycl7iddam4sc4ai8mxtmfxv380ornpy6k7rpf', '0');
-- Quevedo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xkcf6ps3vpo9e1z', 'Quevedo', '99@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2394e996716534bc2c937a1a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:99@artist.com', 'xkcf6ps3vpo9e1z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xkcf6ps3vpo9e1z', 'Merging lyrical depth with compelling urban beats.', 'Quevedo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ij74s84gb5vd94a1r643xh4wiub2fwcg49vu1mby47lhlxozt0','xkcf6ps3vpo9e1z', 'https://i.scdn.co/image/ab67616d0000b273a00a817b017c6f6bf8460be9', 'Quevedo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('obhoptphp1z939dt7bsdvksq60ped64qax9q9a2n1ze99ns3e3','Columbia','xkcf6ps3vpo9e1z',100,'POP','6XbtvPmIpyCbjuT0e8cQtp','https://p.scdn.co/mp3-preview/e3d6df66fe67f618166a2cab858580ac8a96486a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ij74s84gb5vd94a1r643xh4wiub2fwcg49vu1mby47lhlxozt0', 'obhoptphp1z939dt7bsdvksq60ped64qax9q9a2n1ze99ns3e3', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ob4gnq3mffm33yfv9tgjnx35uapj01qubjbiuyfjbb4ycyzs3j','Punto G','xkcf6ps3vpo9e1z',100,'POP','4WiQA1AGWHFvaxBU6bHghs','https://p.scdn.co/mp3-preview/a1275d1dcfb4c25bc48821b19b81ff853386c148?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ij74s84gb5vd94a1r643xh4wiub2fwcg49vu1mby47lhlxozt0', 'ob4gnq3mffm33yfv9tgjnx35uapj01qubjbiuyfjbb4ycyzs3j', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6gmwqxwerx6b243y5y0pjuyixmf297g2t8lcs42kgk2k0bfriv','Mami Chula','xkcf6ps3vpo9e1z',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ij74s84gb5vd94a1r643xh4wiub2fwcg49vu1mby47lhlxozt0', '6gmwqxwerx6b243y5y0pjuyixmf297g2t8lcs42kgk2k0bfriv', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uulifs0bkmqbsobmmv57ivdqjcdom20ykrk1q62vqwmsfumwaq','WANDA','xkcf6ps3vpo9e1z',100,'POP','0Iozrbed8spxoBnmtBMshO','https://p.scdn.co/mp3-preview/a6de4c6031032d886d67e88ec6db1a1c521ed023?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ij74s84gb5vd94a1r643xh4wiub2fwcg49vu1mby47lhlxozt0', 'uulifs0bkmqbsobmmv57ivdqjcdom20ykrk1q62vqwmsfumwaq', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zqu5z2rsguqg1is65jbmpgqytcrdddej7leqvuth333kpz3kbb','Vista Al Mar','xkcf6ps3vpo9e1z',100,'POP','5q86iSKkBtOoNkdgEDY5WV','https://p.scdn.co/mp3-preview/6896535fbb6690492102bdb7ca181f33de63ef4e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ij74s84gb5vd94a1r643xh4wiub2fwcg49vu1mby47lhlxozt0', 'zqu5z2rsguqg1is65jbmpgqytcrdddej7leqvuth333kpz3kbb', '4');
-- Rich The Kid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h0skyxdzwzkxi8r', 'Rich The Kid', '100@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb10379ac1a13fa06e703bf421','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:100@artist.com', 'h0skyxdzwzkxi8r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h0skyxdzwzkxi8r', 'A harmonious blend of passion and creativity.', 'Rich The Kid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jujre0lcs1m9o6ay5tzd1bevilwf6qo6h9sotj8o75kvbmym7m','h0skyxdzwzkxi8r', NULL, 'Rich The Kid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3sdaw1oekjsq5altj47ja83ngcxxqhs9zwvm30nsr06v6lnnsu','Conexes de Mfia (feat. Rich ','h0skyxdzwzkxi8r',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jujre0lcs1m9o6ay5tzd1bevilwf6qo6h9sotj8o75kvbmym7m', '3sdaw1oekjsq5altj47ja83ngcxxqhs9zwvm30nsr06v6lnnsu', '0');
-- Harry Styles
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4wfo5miwp40wq09', 'Harry Styles', '101@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf7db7c8ede90a019c54590bb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:101@artist.com', '4wfo5miwp40wq09', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4wfo5miwp40wq09', 'Defining modern pop-rock with his charismatic presence and bold choices.', 'Harry Styles');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9f240ecb8ses0iowyjibthmaie68bpw794jxgy1wenmctq4q2g','4wfo5miwp40wq09', 'https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0', 'Harry Styles Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tbj5h3dhtr4aj8jxsys2o56jtid3nu6au7m0d8u80zzcrv5in5','As It Was','4wfo5miwp40wq09',100,'POP','4Dvkj6JhhA12EX05fT7y2e','https://p.scdn.co/mp3-preview/c43dd07043b29e800c1a65b3a0102861fa3cf418?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9f240ecb8ses0iowyjibthmaie68bpw794jxgy1wenmctq4q2g', 'tbj5h3dhtr4aj8jxsys2o56jtid3nu6au7m0d8u80zzcrv5in5', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('96t3zmjy8wjte0cc4du1c75neczhj5fuydbizo6ihm4mry1hot','Watermelon Sugar','4wfo5miwp40wq09',100,'POP','6UelLqGlWMcVH1E5c4H7lY','https://p.scdn.co/mp3-preview/824cd58da2e9a15eeaaa6746becc09093547a09b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9f240ecb8ses0iowyjibthmaie68bpw794jxgy1wenmctq4q2g', '96t3zmjy8wjte0cc4du1c75neczhj5fuydbizo6ihm4mry1hot', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fz7p5ot49w2p33b35h1s0fp2qmholkb3y0ydadetdhnk4yzjp8','Late Night Talking','4wfo5miwp40wq09',100,'POP','1qEmFfgcLObUfQm0j1W2CK','https://p.scdn.co/mp3-preview/50f056e2ab4a1bef762661dbbf2da751beeffe39?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9f240ecb8ses0iowyjibthmaie68bpw794jxgy1wenmctq4q2g', 'fz7p5ot49w2p33b35h1s0fp2qmholkb3y0ydadetdhnk4yzjp8', '2');
-- Brenda Lee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('loospn3bc24ulli', 'Brenda Lee', '102@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4ea49bdca366a3baa5cbb006','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:102@artist.com', 'loospn3bc24ulli', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('loospn3bc24ulli', 'Striking chords that resonate across generations.', 'Brenda Lee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l9kkh4vifbdftheyw4008utfwd0d00hhe98u3c913nx11dv699','loospn3bc24ulli', 'https://i.scdn.co/image/ab67616d0000b2737845f74d6db14b400fa61cd3', 'Brenda Lee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('041n8gy4umf7kvo1hefyemaoibdyf043za5expth9heo8dn2ii','Rockin Around The Christmas Tree','loospn3bc24ulli',100,'POP','2EjXfH91m7f8HiJN1yQg97',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l9kkh4vifbdftheyw4008utfwd0d00hhe98u3c913nx11dv699', '041n8gy4umf7kvo1hefyemaoibdyf043za5expth9heo8dn2ii', '0');
-- Chino Pacas
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dojevby58w5h1gu', 'Chino Pacas', '103@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8ff524b416384fe673ebf52e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:103@artist.com', 'dojevby58w5h1gu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dojevby58w5h1gu', 'Sculpting soundwaves into masterpieces of auditory art.', 'Chino Pacas');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gab9y147hjbm10lnxsiijph4hr9wgs8pkehkdpws6nk3cf6e6g','dojevby58w5h1gu', 'https://i.scdn.co/image/ab67616d0000b2736a6ab689151163a1e9f60f36', 'Chino Pacas Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zprfp8nt3avntco1aiih1s62jehpze05gcrec9ev5gai6ng5u0','El Gordo Trae El Mando','dojevby58w5h1gu',100,'POP','3kf0WdFOalKWBkCCLJo4mA','https://p.scdn.co/mp3-preview/b7989992ce6651eea980627ad17b1f9a2fa2a224?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gab9y147hjbm10lnxsiijph4hr9wgs8pkehkdpws6nk3cf6e6g', 'zprfp8nt3avntco1aiih1s62jehpze05gcrec9ev5gai6ng5u0', '0');
-- Coi Leray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nzi1ns61b5yig8d', 'Coi Leray', '104@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:104@artist.com', 'nzi1ns61b5yig8d', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nzi1ns61b5yig8d', 'Redefining what it means to be an artist in the digital age.', 'Coi Leray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('a3u8wqvkx18gyqb8amtctdgy05ktdaey978o3wgnmn18i9cfad','nzi1ns61b5yig8d', 'https://i.scdn.co/image/ab67616d0000b2735626453d29a0124dea22fb1b', 'Coi Leray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ots8bxwst9a0wxh5tg7pnk51w1ev1xd80lmbnku20muxx1v3w1','Players','nzi1ns61b5yig8d',100,'POP','6UN73IYd0hZxLi8wFPMQij',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a3u8wqvkx18gyqb8amtctdgy05ktdaey978o3wgnmn18i9cfad', 'ots8bxwst9a0wxh5tg7pnk51w1ev1xd80lmbnku20muxx1v3w1', '0');
-- Niall Horan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3ibzyb8w3f7rb2h', 'Niall Horan', '105@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeccc1cde8e9fdcf1c9289897','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:105@artist.com', '3ibzyb8w3f7rb2h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3ibzyb8w3f7rb2h', 'Breathing new life into classic genres.', 'Niall Horan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4m5oc44uojc6klb4k1klgyrnlgwsqpzsbl9fhqjukds86rtjok','3ibzyb8w3f7rb2h', 'https://i.scdn.co/image/ab67616d0000b2732a368fea49f5c489a9dc3949', 'Niall Horan Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('swdxtaq5boh3uxm0dc92bafv5qu6gzgo7x0k919gek3dtn468b','Heaven','3ibzyb8w3f7rb2h',100,'POP','5FQ77Cl1ndljtwwImdtjMy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4m5oc44uojc6klb4k1klgyrnlgwsqpzsbl9fhqjukds86rtjok', 'swdxtaq5boh3uxm0dc92bafv5qu6gzgo7x0k919gek3dtn468b', '0');
-- Ariana Grande
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xq0py4r47f8fq17', 'Ariana Grande', '106@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb456c82553e0efcb7e13365b1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:106@artist.com', 'xq0py4r47f8fq17', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xq0py4r47f8fq17', 'A powerhouse vocalist, dominating pop with her range and iconic style.', 'Ariana Grande');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9qme5vmmclvtexsm9tigxowgi215ua5cfk7yr65954ggmy1aip','xq0py4r47f8fq17', NULL, 'Ariana Grande Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wl1gqk803nl8akblxeayuz6awofaj59lr83g5ivh43qq48h33w','Die For You - Remix','xq0py4r47f8fq17',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9qme5vmmclvtexsm9tigxowgi215ua5cfk7yr65954ggmy1aip', 'wl1gqk803nl8akblxeayuz6awofaj59lr83g5ivh43qq48h33w', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f79bpclaz6e2jyjfmjs8aecbjbtgbr0ccdtce0uwxmy9aksegn','Save Your Tears (with Ariana Grande) (Remix)','xq0py4r47f8fq17',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9qme5vmmclvtexsm9tigxowgi215ua5cfk7yr65954ggmy1aip', 'f79bpclaz6e2jyjfmjs8aecbjbtgbr0ccdtce0uwxmy9aksegn', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1rvbwyzn8sgi8mvl9volg0p9szi11twr0t9r8ssvjxbwfo4j2z','Santa Tell Me','xq0py4r47f8fq17',100,'POP','0lizgQ7Qw35od7CYaoMBZb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9qme5vmmclvtexsm9tigxowgi215ua5cfk7yr65954ggmy1aip', '1rvbwyzn8sgi8mvl9volg0p9szi11twr0t9r8ssvjxbwfo4j2z', '2');
-- Sia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kn3ft6o41fknuar', 'Sia', '107@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb25a749000611559f1719cc5f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:107@artist.com', 'kn3ft6o41fknuar', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kn3ft6o41fknuar', 'Blending traditional rhythms with modern beats.', 'Sia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('s0dak4hvvetidvfd9vppkal0lxlyp2kfgq6mo2dssa189f00uz','kn3ft6o41fknuar', 'https://i.scdn.co/image/ab67616d0000b273754b2fddebe7039fdb912837', 'Sia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ywixacs6udyyvfmckyak9a2w38v8ucpmbpka1nf13t90xk345k','Unstoppable','kn3ft6o41fknuar',100,'POP','1yvMUkIOTeUNtNWlWRgANS','https://p.scdn.co/mp3-preview/99a07d00531c0053f55a46e94ed92b1560396754?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s0dak4hvvetidvfd9vppkal0lxlyp2kfgq6mo2dssa189f00uz', 'ywixacs6udyyvfmckyak9a2w38v8ucpmbpka1nf13t90xk345k', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('17dclptz5gvfzveyo5elxbyew72jd840dp6lf64gr1wzehtl3q','Snowman','kn3ft6o41fknuar',100,'POP','7uoFMmxln0GPXQ0AcCBXRq','https://p.scdn.co/mp3-preview/a936030efc27a4fc52d8c42b20d03ca4cab30836?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s0dak4hvvetidvfd9vppkal0lxlyp2kfgq6mo2dssa189f00uz', '17dclptz5gvfzveyo5elxbyew72jd840dp6lf64gr1wzehtl3q', '1');
-- Gabito Ballesteros
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jl7i97qmnp7u94c', 'Gabito Ballesteros', '108@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:108@artist.com', 'jl7i97qmnp7u94c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jl7i97qmnp7u94c', 'A vibrant force in the music scene, infusing every performance with passion.', 'Gabito Ballesteros');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('q4vf0047pq3ebjyw8v4gh7ccjsregsgl1y09vxmjlpufp729nf','jl7i97qmnp7u94c', NULL, 'Gabito Ballesteros Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('65prt0rvx2j2dc5dyxrdxwo1tju882a7ur1gkftkekyhdtpyzt','LADY GAGA','jl7i97qmnp7u94c',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q4vf0047pq3ebjyw8v4gh7ccjsregsgl1y09vxmjlpufp729nf', '65prt0rvx2j2dc5dyxrdxwo1tju882a7ur1gkftkekyhdtpyzt', '0');
-- The Walters
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w0jfcxw3ayc6yv2', 'The Walters', '109@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6c4366f40ea49c1318707f97','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:109@artist.com', 'w0jfcxw3ayc6yv2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w0jfcxw3ayc6yv2', 'Weaving lyrical magic into every song.', 'The Walters');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ye30n4oqymqpd17tcmupgiivnhovky79cw8u1t8xfoiqlnr9dl','w0jfcxw3ayc6yv2', 'https://i.scdn.co/image/ab67616d0000b2739214ff0109a0e062f8a6cf0f', 'The Walters Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nojjuubfeg9c6jwnd34v7gazggg9yzguanhgg518ereij5fp6w','I Love You So','w0jfcxw3ayc6yv2',100,'POP','4SqWKzw0CbA05TGszDgMlc','https://p.scdn.co/mp3-preview/83919b3d62a4ae352229c0a779e8aa0c1b2f4f40?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ye30n4oqymqpd17tcmupgiivnhovky79cw8u1t8xfoiqlnr9dl', 'nojjuubfeg9c6jwnd34v7gazggg9yzguanhgg518ereij5fp6w', '0');
-- Arijit Singh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xdf1pe4v5qxdnzd', 'Arijit Singh', '110@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0261696c5df3be99da6ed3f3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:110@artist.com', 'xdf1pe4v5qxdnzd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xdf1pe4v5qxdnzd', 'A journey through the spectrum of sound in every album.', 'Arijit Singh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vwranr5rbri3597z8qhn099c1rujzerei9anl54pxe85p10gwc','xdf1pe4v5qxdnzd', NULL, 'Arijit Singh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q3w3qanom8yww3mic0uvuqx1bay36ftm25mzhkxf0179qk17cr','Phir Aur Kya Chahiye (From "Zara Hatke Zara Bachke")','xdf1pe4v5qxdnzd',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vwranr5rbri3597z8qhn099c1rujzerei9anl54pxe85p10gwc', 'q3w3qanom8yww3mic0uvuqx1bay36ftm25mzhkxf0179qk17cr', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8f0316t8hmle8hy0jb4sakrirtu09z8pbtel47xoankb93sipi','Apna Bana Le (From "Bhediya")','xdf1pe4v5qxdnzd',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vwranr5rbri3597z8qhn099c1rujzerei9anl54pxe85p10gwc', '8f0316t8hmle8hy0jb4sakrirtu09z8pbtel47xoankb93sipi', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8at3c5z51p24zum3g5jjsz50iws7fqg0f7mfwdwey54ltlmnk8','Jhoome Jo Pathaan','xdf1pe4v5qxdnzd',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vwranr5rbri3597z8qhn099c1rujzerei9anl54pxe85p10gwc', '8at3c5z51p24zum3g5jjsz50iws7fqg0f7mfwdwey54ltlmnk8', '2');
-- The Weeknd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jhpdhtrbzxuzta5', 'The Weeknd', '111@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:111@artist.com', 'jhpdhtrbzxuzta5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jhpdhtrbzxuzta5', 'A trailblazer in the world of R&B, constantly redefining the genre.', 'The Weeknd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9','jhpdhtrbzxuzta5', NULL, 'The Weeknd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0hgirrv0y6j83yq6lnglvlll4ndyz3kz9gd62kik2lxvwe9t1b','Popular (with Playboi Carti & Madonna) - The Idol Vol. 1 (Music from the HBO Original Series)','jhpdhtrbzxuzta5',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9', '0hgirrv0y6j83yq6lnglvlll4ndyz3kz9gd62kik2lxvwe9t1b', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l1ubrip2bsecltz9edupmhpuh2w2vnxnr94858bbbp6s8vb2wd','Creepin','jhpdhtrbzxuzta5',100,'POP','1zOf6IuM8HgaB4Jo6I8D11','https://p.scdn.co/mp3-preview/185d0909b7f2086f4cdd0af4b166df5676542343?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9', 'l1ubrip2bsecltz9edupmhpuh2w2vnxnr94858bbbp6s8vb2wd', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('85linkqyigo0bz5i5qmxr72qkv489y960mte7mpggrna1fbb3r','Die For You','jhpdhtrbzxuzta5',100,'POP','2LBqCSwhJGcFQeTHMVGwy3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9', '85linkqyigo0bz5i5qmxr72qkv489y960mte7mpggrna1fbb3r', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7q2u8mu4faucurvbhkoubqrkgmbf1jhda53k6elccj090ss2jq','Starboy','jhpdhtrbzxuzta5',100,'POP','7MXVkk9YMctZqd1Srtv4MB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9', '7q2u8mu4faucurvbhkoubqrkgmbf1jhda53k6elccj090ss2jq', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ua3h997qltambid4z3z7netdlr3xbmgkmjxohydv2959mr13kf','Blinding Lights','jhpdhtrbzxuzta5',100,'POP','0VjIjW4GlUZAMYd2vXMi3b',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9', 'ua3h997qltambid4z3z7netdlr3xbmgkmjxohydv2959mr13kf', '4');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e2j8wewsb792p9iz3ijpter5d01yqla3nuayn0ttfq6x5xypmk','Stargirl Interlude','jhpdhtrbzxuzta5',100,'POP','5gDWsRxpJ2lZAffh5p7K0w',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9', 'e2j8wewsb792p9iz3ijpter5d01yqla3nuayn0ttfq6x5xypmk', '5');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('twabf477youf5d3wdohx943xtvfc07gwq2w7zb16hw5anyzd7r','Save Your Tears','jhpdhtrbzxuzta5',100,'POP','5QO79kh1waicV47BqGRL3g',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9', 'twabf477youf5d3wdohx943xtvfc07gwq2w7zb16hw5anyzd7r', '6');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sl5e9xdxb9vfd3sjfj4ev87a6ifcmgqs933ltqbbkk7oaxgl1u','Reminder','jhpdhtrbzxuzta5',100,'POP','37F0uwRSrdzkBiuj0D5UHI',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9', 'sl5e9xdxb9vfd3sjfj4ev87a6ifcmgqs933ltqbbkk7oaxgl1u', '7');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('flewynip4l57l65co6q52bxue3h5hs759qate6z5zw6k1ttt4w','Double Fantasy (with Future)','jhpdhtrbzxuzta5',100,'POP','4VMRsbfZzd3SfQtaJ1Wpwi',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9', 'flewynip4l57l65co6q52bxue3h5hs759qate6z5zw6k1ttt4w', '8');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('66h2antf2l90rhqf15in6cayfgw0gquauaczn87wn9fxg3zg7w','I Was Never There','jhpdhtrbzxuzta5',100,'POP','1cKHdTo9u0ZymJdPGSh6nq',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9', '66h2antf2l90rhqf15in6cayfgw0gquauaczn87wn9fxg3zg7w', '9');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cqqp7r32dncx0mg6aztzhoorzrzqq0est21c2escwuwf62boyb','Call Out My Name','jhpdhtrbzxuzta5',100,'POP','09mEdoA6zrmBPgTEN5qXmN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9', 'cqqp7r32dncx0mg6aztzhoorzrzqq0est21c2escwuwf62boyb', '10');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j5954h3d0aaxxiqcur2ajvo2rd5oml84jps9kkf8ngr4x0a0pf','The Hills','jhpdhtrbzxuzta5',100,'POP','7fBv7CLKzipRk6EC6TWHOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9', 'j5954h3d0aaxxiqcur2ajvo2rd5oml84jps9kkf8ngr4x0a0pf', '11');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vufxzfu1ufkppjqd3z5murhzcgtrf5wgllviln03tgwg5c4alt','After Hours','jhpdhtrbzxuzta5',100,'POP','2p8IUWQDrpjuFltbdgLOag',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6mtbr337pdc4plmgq45gafjh3ad1otyikaim1xbhsjgj4wwd9', 'vufxzfu1ufkppjqd3z5murhzcgtrf5wgllviln03tgwg5c4alt', '12');
-- The Neighbourhood
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f4vsngpcysusckg', 'The Neighbourhood', '112@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf0b5ac84376a0a4b2166816','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:112@artist.com', 'f4vsngpcysusckg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('f4vsngpcysusckg', 'Melding alternative rock with introspective lyrics.', 'The Neighbourhood');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lcs3qcs9mkhdwkgxpwa1fpkklfmahe46jq343gviexohd853ie','f4vsngpcysusckg', 'https://i.scdn.co/image/ab67616d0000b2738265a736a1eb838ad5a0b921', 'The Neighbourhood Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f5ayv7b9vjvjrrho5iehokp51tdjtqztdblcd1ky14n6er3kfv','Sweater Weather','f4vsngpcysusckg',100,'POP','2QjOHCTQ1Jl3zawyYOpxh6','https://p.scdn.co/mp3-preview/877602f424a9dea277b13301ffc516f9fd1fbe7e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lcs3qcs9mkhdwkgxpwa1fpkklfmahe46jq343gviexohd853ie', 'f5ayv7b9vjvjrrho5iehokp51tdjtqztdblcd1ky14n6er3kfv', '0');
-- Lewis Capaldi
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('62xipaj4o95m109', 'Lewis Capaldi', '113@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebea7538654040e553a7b0fc28','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:113@artist.com', '62xipaj4o95m109', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('62xipaj4o95m109', 'Delivering emotional ballads with his powerful, soul-stirring voice.', 'Lewis Capaldi');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g3hbx7sduye0igqec3wx3q0gewklilq2ljzb41f8tgjc8eq77i','62xipaj4o95m109', 'https://i.scdn.co/image/ab67616d0000b273fc2101e6889d6ce9025f85f2', 'Lewis Capaldi Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fluvqofp6a1czc68pr2h058l930m1vo0zbskogxhx0y8y2lmow','Someone You Loved','62xipaj4o95m109',100,'POP','7qEHsqek33rTcFNT9PFqLf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g3hbx7sduye0igqec3wx3q0gewklilq2ljzb41f8tgjc8eq77i', 'fluvqofp6a1czc68pr2h058l930m1vo0zbskogxhx0y8y2lmow', '0');
-- BLESSD
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('o1rzo4jc6d7kvtg', 'BLESSD', '114@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:114@artist.com', 'o1rzo4jc6d7kvtg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('o1rzo4jc6d7kvtg', 'Crafting soundscapes that transport listeners to another world.', 'BLESSD');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g1z5m7ulhkjxdcviwkto7m0k78soq76g2kgx325ohsn4ok59x0','o1rzo4jc6d7kvtg', NULL, 'BLESSD Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('apvdbepblgyj8woyvumsqoe01kmqs8tvoxvou78508igib3692','Las Morras','o1rzo4jc6d7kvtg',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g1z5m7ulhkjxdcviwkto7m0k78soq76g2kgx325ohsn4ok59x0', 'apvdbepblgyj8woyvumsqoe01kmqs8tvoxvou78508igib3692', '0');
-- Junior H
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gh0mgztfn4pgbrz', 'Junior H', '115@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:115@artist.com', 'gh0mgztfn4pgbrz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gh0mgztfn4pgbrz', 'A fresh voice in regional Mexican music, blending tradition with modernity.', 'Junior H');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('29v0uzi78q143l2gf6ne4v92r9jhjk2e9megfceydhv8gx1qqj','gh0mgztfn4pgbrz', 'https://i.scdn.co/image/ab67616d0000b27333ed356efed99b158c4267c6', 'Junior H Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qz7b1cw8pnwz67529bzdx82y4d35s5un0vk9j9srze4tz2ldna','El Azul','gh0mgztfn4pgbrz',100,'POP','1haJsMtoBhHfvuM7XWuT3W','https://p.scdn.co/mp3-preview/f9df136c3a2d3c0c5424e2c4b75a303f35c08af5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('29v0uzi78q143l2gf6ne4v92r9jhjk2e9megfceydhv8gx1qqj', 'qz7b1cw8pnwz67529bzdx82y4d35s5un0vk9j9srze4tz2ldna', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n45dgzbo2lqbzw0qxfn8x06kjjox48xp1sjrwt4njexk6kemlt','LUNA','gh0mgztfn4pgbrz',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('29v0uzi78q143l2gf6ne4v92r9jhjk2e9megfceydhv8gx1qqj', 'n45dgzbo2lqbzw0qxfn8x06kjjox48xp1sjrwt4njexk6kemlt', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o2tl9yfaxy808vxbad7b2gzbt7wbmxlv7ue5lqzxn4jhrd8s0g','Abcdario','gh0mgztfn4pgbrz',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('29v0uzi78q143l2gf6ne4v92r9jhjk2e9megfceydhv8gx1qqj', 'o2tl9yfaxy808vxbad7b2gzbt7wbmxlv7ue5lqzxn4jhrd8s0g', '2');
-- Shubh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cqwc8mbl79zxba8', 'Shubh', '116@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3eac18e003a215ce96654ce1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:116@artist.com', 'cqwc8mbl79zxba8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cqwc8mbl79zxba8', 'Music is my canvas, and notes are my paint.', 'Shubh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t25yvzic2152vh92ib94vek1sju3dbsh1cz1c4xnwa3prys4f6','cqwc8mbl79zxba8', 'https://i.scdn.co/image/ab67616d0000b2731a8c4618eda885a406958dd0', 'Shubh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('seljyaokfkp801ksbr3js546jctjebzwv4fwf1palfb2m7ilzs','Cheques','cqwc8mbl79zxba8',100,'POP','4eBvRhTJ2AcxCsbfTUjoRp','https://p.scdn.co/mp3-preview/c607b777f851d56dd524f845957e24901adbf1eb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t25yvzic2152vh92ib94vek1sju3dbsh1cz1c4xnwa3prys4f6', 'seljyaokfkp801ksbr3js546jctjebzwv4fwf1palfb2m7ilzs', '0');
-- Tyler
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qgrykvbh9ezlgk1', 'Tyler', '117@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8278b782cbb5a3963db88ada','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:117@artist.com', 'qgrykvbh9ezlgk1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qgrykvbh9ezlgk1', 'Sculpting soundwaves into masterpieces of auditory art.', 'Tyler');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i9cr2w861dzl3xduzdqjzs6ut5x7c84vdam119rs136fea3s7p','qgrykvbh9ezlgk1', 'https://i.scdn.co/image/ab67616d0000b273aa95a399fd30fbb4f6f59fca', 'Tyler Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('600yp6t1isvg5dideszhm1mejlwzlpubmtfcwid5cnvtc3gh5f','DOGTOOTH','qgrykvbh9ezlgk1',100,'POP','6OfOzTitafSnsaunQLuNFw','https://p.scdn.co/mp3-preview/5de4c8c30108bc114f9f38a28ac0832936a852bf?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i9cr2w861dzl3xduzdqjzs6ut5x7c84vdam119rs136fea3s7p', '600yp6t1isvg5dideszhm1mejlwzlpubmtfcwid5cnvtc3gh5f', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dcwq9lto3gs5mn2hb4wrdw2hvicvivycel92zjb5mtozke8pi8','SORRY NOT SORRY','qgrykvbh9ezlgk1',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i9cr2w861dzl3xduzdqjzs6ut5x7c84vdam119rs136fea3s7p', 'dcwq9lto3gs5mn2hb4wrdw2hvicvivycel92zjb5mtozke8pi8', '1');
-- (G)I-DLE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hzvf45mdm6iim0f', '(G)I-DLE', '118@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8abd5f97fc52561939ebbc89','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:118@artist.com', 'hzvf45mdm6iim0f', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hzvf45mdm6iim0f', 'Harnessing the power of melody to tell compelling stories.', '(G)I-DLE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dis8um4qi9cuqb7cqrzj1jbwsft8n5w1hpj6ac04xffdjgenjm','hzvf45mdm6iim0f', 'https://i.scdn.co/image/ab67616d0000b27382dd2427e6d302711b1b9616', '(G)I-DLE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pha5qz69j9maa69x338kfw921wvcw54ah2g96ieftg6v3o1ro2','Queencard','hzvf45mdm6iim0f',100,'POP','4uOBL4DDWWVx4RhYKlPbPC','https://p.scdn.co/mp3-preview/9f36e86bca0911d3f849197e8f531b9d0c34f002?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dis8um4qi9cuqb7cqrzj1jbwsft8n5w1hpj6ac04xffdjgenjm', 'pha5qz69j9maa69x338kfw921wvcw54ah2g96ieftg6v3o1ro2', '0');
-- Beach Weather
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('n4notx7bwkd2dv4', 'Beach Weather', '119@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebed9ce2779a99efc01b4f918c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:119@artist.com', 'n4notx7bwkd2dv4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('n4notx7bwkd2dv4', 'An alchemist of harmonies, transforming notes into gold.', 'Beach Weather');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8vk16gte0beh4k2usspka0yn7im1mjpms2jnvc6za0zxx9h29i','n4notx7bwkd2dv4', 'https://i.scdn.co/image/ab67616d0000b273a03e3d24ccee1c370899c342', 'Beach Weather Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7ful4a18i9a09uaq6s477ejhgoh8ty9xlcrraedrcxbna5qbi6','Sex, Drugs, Etc.','n4notx7bwkd2dv4',100,'POP','7MlDNspYwfqnHxORufupwq','https://p.scdn.co/mp3-preview/a423aecddb590788a61f2a7b4d325bf461f88dc8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8vk16gte0beh4k2usspka0yn7im1mjpms2jnvc6za0zxx9h29i', '7ful4a18i9a09uaq6s477ejhgoh8ty9xlcrraedrcxbna5qbi6', '0');
-- Sachin-Jigar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jdfbf0p0ljgsqv8', 'Sachin-Jigar', '120@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba038d7d87f8577bbb9686bd3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:120@artist.com', 'jdfbf0p0ljgsqv8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jdfbf0p0ljgsqv8', 'Sculpting soundwaves into masterpieces of auditory art.', 'Sachin-Jigar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lqndikurl91w4lmp9mhcg1vgqptrzq8w2e5kc5dhem16vya1ow','jdfbf0p0ljgsqv8', NULL, 'Sachin-Jigar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d0o47esrzkizcu7d0sjpd7rf318hjooi3tlj4mmgxfihwjc0r0','Tere Vaaste (From "Zara Hatke Zara Bachke")','jdfbf0p0ljgsqv8',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lqndikurl91w4lmp9mhcg1vgqptrzq8w2e5kc5dhem16vya1ow', 'd0o47esrzkizcu7d0sjpd7rf318hjooi3tlj4mmgxfihwjc0r0', '0');
-- Rosa Linn
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8r3dtf2d5r7wskn', 'Rosa Linn', '121@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5fe9684ed75d00000b63791','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:121@artist.com', '8r3dtf2d5r7wskn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8r3dtf2d5r7wskn', 'Breathing new life into classic genres.', 'Rosa Linn');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0omhen3s4elvzedwu8xdjqb54lwqfjwcmo5eknnbr6k25quupc','8r3dtf2d5r7wskn', 'https://i.scdn.co/image/ab67616d0000b2731391b1fdb63da53e5b112224', 'Rosa Linn Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('38c0su67zz6582exkjeoqw1kgpyr2r9rde983jzphvb1x6ve8d','SNAP','8r3dtf2d5r7wskn',100,'POP','76OGwb5RA9h4FxQPT33ekc','https://p.scdn.co/mp3-preview/0a41500662a6b6223dcb026b20ef1437985574b8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0omhen3s4elvzedwu8xdjqb54lwqfjwcmo5eknnbr6k25quupc', '38c0su67zz6582exkjeoqw1kgpyr2r9rde983jzphvb1x6ve8d', '0');
-- SEVENTEEN
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mtj8dnhrh1oiv6v', 'SEVENTEEN', '122@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb61916bb9f5c6a1a9ba1c9ab6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:122@artist.com', 'mtj8dnhrh1oiv6v', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mtj8dnhrh1oiv6v', 'Where words fail, my music speaks.', 'SEVENTEEN');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6zh0gu31cckor1n1py5y9vff3l5q1w68mbvxylfmnnlf9tzjqj','mtj8dnhrh1oiv6v', 'https://i.scdn.co/image/ab67616d0000b27380e31ba0c05187e6310ef264', 'SEVENTEEN Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('487gxy27846gjd94f5rivpfrs4oiwln6gsu5p439x7bkcgucbv','Super','mtj8dnhrh1oiv6v',100,'POP','3AOf6YEpxQ894FmrwI9k96','https://p.scdn.co/mp3-preview/1dd31996959e603934dbe4c7d3ee377243a0f890?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6zh0gu31cckor1n1py5y9vff3l5q1w68mbvxylfmnnlf9tzjqj', '487gxy27846gjd94f5rivpfrs4oiwln6gsu5p439x7bkcgucbv', '0');
-- Arcangel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d46gkcguhumdgab', 'Arcangel', '123@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebafdf17286a0d7a23ad388587','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:123@artist.com', 'd46gkcguhumdgab', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('d46gkcguhumdgab', 'Blending traditional rhythms with modern beats.', 'Arcangel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ztud2khju7323fvvatydqbe4qbbo281x0j7hrbjxz8wly3otik','d46gkcguhumdgab', 'https://i.scdn.co/image/ab67616d0000b27330326b23e30ae93d4d48165b', 'Arcangel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dotiskv9v3337avg1zttesjkq8akwsae90igprsugh1nf05ta8','La Jumpa','d46gkcguhumdgab',100,'POP','2mnXxnrX5vCGolNkaFvVeM','https://p.scdn.co/mp3-preview/8bcdff4719a7a4211128ec93da03892e46c4bc6a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ztud2khju7323fvvatydqbe4qbbo281x0j7hrbjxz8wly3otik', 'dotiskv9v3337avg1zttesjkq8akwsae90igprsugh1nf05ta8', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9tj3d5qs2f9iopaithizagxtxgx419xks5442rbzymsf11vzpf','Arcngel: Bzrp Music Sessions, Vol','d46gkcguhumdgab',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ztud2khju7323fvvatydqbe4qbbo281x0j7hrbjxz8wly3otik', '9tj3d5qs2f9iopaithizagxtxgx419xks5442rbzymsf11vzpf', '1');
-- Jack Black
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('a6xuxck9s8pzgfp', 'Jack Black', '124@artist.com', 'https://i.scdn.co/image/ab6772690000c46ca156a562884cb76eeb0b75e9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:124@artist.com', 'a6xuxck9s8pzgfp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('a6xuxck9s8pzgfp', 'Transcending language barriers through the universal language of music.', 'Jack Black');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2gz1hlv1ndl0jbnok1nl7d4p7vf0a9gqve08pfeczrf7eyu6vo','a6xuxck9s8pzgfp', NULL, 'Jack Black Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('22y7jd3iif6rf9belgt40ctfnaru41dij5koks89eek9774rbl','Peaches (from The Super Mario Bros. Movie)','a6xuxck9s8pzgfp',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2gz1hlv1ndl0jbnok1nl7d4p7vf0a9gqve08pfeczrf7eyu6vo', '22y7jd3iif6rf9belgt40ctfnaru41dij5koks89eek9774rbl', '0');
-- Travis Scott
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qraaquhurcym5m7', 'Travis Scott', '125@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:125@artist.com', 'qraaquhurcym5m7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qraaquhurcym5m7', 'Uniting fans around the globe with universal rhythms.', 'Travis Scott');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d26cakoib55h4es7qncushvffnk33i2fx2vtsy2pe3sfxi7d6e','qraaquhurcym5m7', NULL, 'Travis Scott Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j6o5iu4setw1nx79uhg33298kx5594ebg4pamzd61m4757ufoq','Trance (with Travis Scott & Young Thug)','qraaquhurcym5m7',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d26cakoib55h4es7qncushvffnk33i2fx2vtsy2pe3sfxi7d6e', 'j6o5iu4setw1nx79uhg33298kx5594ebg4pamzd61m4757ufoq', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xtruqnoyox0elje83gbkiwl1gklrxti6gkee79h5oq1qiyaws6','Niagara Falls (Foot or 2) [with Travis Scott & 21 Savage]','qraaquhurcym5m7',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d26cakoib55h4es7qncushvffnk33i2fx2vtsy2pe3sfxi7d6e', 'xtruqnoyox0elje83gbkiwl1gklrxti6gkee79h5oq1qiyaws6', '1');
-- Carin Leon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('68iyrz8zd83g3ko', 'Carin Leon', '126@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb7cc22fee89df015c6ba2636','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:126@artist.com', '68iyrz8zd83g3ko', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('68iyrz8zd83g3ko', 'Pioneering new paths in the musical landscape.', 'Carin Leon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7b495pz5h9j6zwzh9oepqim2ogd5rwllthico4dy3pkn2kg8co','68iyrz8zd83g3ko', 'https://i.scdn.co/image/ab67616d0000b273dc0bb68a08c069cf8467f1bd', 'Carin Leon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wx895vdokm2ihafj4rtodiat1ezvunwlhc9rlq5ho5nf70wb2t','Primera Cita','68iyrz8zd83g3ko',100,'POP','4mGrWfDISjNjgeQnH1B8IE','https://p.scdn.co/mp3-preview/7eea768397c9ad0989a55f26f4cffbe6f334874a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7b495pz5h9j6zwzh9oepqim2ogd5rwllthico4dy3pkn2kg8co', 'wx895vdokm2ihafj4rtodiat1ezvunwlhc9rlq5ho5nf70wb2t', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oskrc0jgol56ubgmaov97o245dy9getl8dcdjqqm149thhji5n','Que Vuelvas','68iyrz8zd83g3ko',100,'POP','6Um358vY92UBv5DloTRX9L','https://p.scdn.co/mp3-preview/19a1e58ae965c24e3ca4d0637857456887e31cd1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7b495pz5h9j6zwzh9oepqim2ogd5rwllthico4dy3pkn2kg8co', 'oskrc0jgol56ubgmaov97o245dy9getl8dcdjqqm149thhji5n', '1');
-- Chencho Corleone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ebr2rbm3w6gdb8w', 'Chencho Corleone', '127@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2e862710857d2b3e1b5fb4f4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:127@artist.com', 'ebr2rbm3w6gdb8w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ebr2rbm3w6gdb8w', 'A dynamic presence in reggaeton, known for his catchy beats and vibrant performances.', 'Chencho Corleone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('piyomd43mtd5pjhy1jut8snygx4w4g9ko4c27lf88aztjqt713','ebr2rbm3w6gdb8w', NULL, 'Chencho Corleone Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('19mqt1zlk1cekk2tznh266d6rol8dg9ona2qof6r5eoeq3yg3r','Me Porto Bonito','ebr2rbm3w6gdb8w',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('piyomd43mtd5pjhy1jut8snygx4w4g9ko4c27lf88aztjqt713', '19mqt1zlk1cekk2tznh266d6rol8dg9ona2qof6r5eoeq3yg3r', '0');
-- The Kid Laroi
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vvtruombb110wat', 'The Kid Laroi', '128@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb393666951ab8b14e9c4ed386','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:128@artist.com', 'vvtruombb110wat', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vvtruombb110wat', 'Blending genres for a fresh musical experience.', 'The Kid Laroi');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6x2rkkxbw7p9ohaueazbsxnqo1pcq9wkb24kecs94o79ae26ge','vvtruombb110wat', 'https://i.scdn.co/image/ab67616d0000b273a53643fc03785efb9926443d', 'The Kid Laroi Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4qugwqknyv03joviqzd8k4pd64iwb6f24rkkmkyy5nnlilup9q','Love Again','vvtruombb110wat',100,'POP','4sx6NRwL6Ol3V6m9exwGlQ','https://p.scdn.co/mp3-preview/4baae2685eaac7401ae183c54642c9ddf3b9e057?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6x2rkkxbw7p9ohaueazbsxnqo1pcq9wkb24kecs94o79ae26ge', '4qugwqknyv03joviqzd8k4pd64iwb6f24rkkmkyy5nnlilup9q', '0');
-- Metro Boomin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5y558hfrlnf27us', 'Metro Boomin', '129@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:129@artist.com', '5y558hfrlnf27us', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5y558hfrlnf27us', 'Blending genres for a fresh musical experience.', 'Metro Boomin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ycucedkn1z2gi8i20s7zjzrqzqm9377qtpc5xmh843kpk4ezty','5y558hfrlnf27us', 'https://i.scdn.co/image/ab67616d0000b2736ed9aef791159496b286179f', 'Metro Boomin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hu1j5lyp4xui1pg4mtpnmi0kbmnn91dz5nuf9fus69bbxlu0qr','Self Love (Spider-Man: Across the Spider-Verse) (Metro Boomin & Coi Leray)','5y558hfrlnf27us',100,'POP','0AAMnNeIc6CdnfNU85GwCH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ycucedkn1z2gi8i20s7zjzrqzqm9377qtpc5xmh843kpk4ezty', 'hu1j5lyp4xui1pg4mtpnmi0kbmnn91dz5nuf9fus69bbxlu0qr', '0');
-- Simone Mendes
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qrdkmddsobhm3oq', 'Simone Mendes', '130@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb80e5acf09546a1fa2ca12a49','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:130@artist.com', 'qrdkmddsobhm3oq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qrdkmddsobhm3oq', 'Pushing the boundaries of sound with each note.', 'Simone Mendes');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j1iwsq8vsyrnebhz5lxqqszex468u2w7hh7twp7iyvwg8m2z96','qrdkmddsobhm3oq', 'https://i.scdn.co/image/ab67616d0000b27379dcbcbbc872003eea5fd10f', 'Simone Mendes Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fihx7o0a6xfl3powdue7zb30dggax59q9xkoevsbjr9k8qhw1u','Erro Gostoso - Ao Vivo','qrdkmddsobhm3oq',100,'POP','4R1XAT4Ix7kad727aKh7Pj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j1iwsq8vsyrnebhz5lxqqszex468u2w7hh7twp7iyvwg8m2z96', 'fihx7o0a6xfl3powdue7zb30dggax59q9xkoevsbjr9k8qhw1u', '0');
-- Troye Sivan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yov6ihk3nrbbf0i', 'Troye Sivan', '131@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26e8cb3ff6fc7744b312811b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:131@artist.com', 'yov6ihk3nrbbf0i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yov6ihk3nrbbf0i', 'A voice that encapsulates the spirit of modern pop.', 'Troye Sivan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3t6ve61g7vdf35mccphasavyrnffloijg89hvkpimfouv2iats','yov6ihk3nrbbf0i', 'https://i.scdn.co/image/ab67616d0000b27367103283a4eb57578a428252', 'Troye Sivan Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('erl03cc8vyjma8cuauf3gfslwsl5kmm3jqhzu66nul9r8wy2js','Rush','yov6ihk3nrbbf0i',100,'POP','4ZnkygoWLzcGbQYCm3lkae',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3t6ve61g7vdf35mccphasavyrnffloijg89hvkpimfouv2iats', 'erl03cc8vyjma8cuauf3gfslwsl5kmm3jqhzu66nul9r8wy2js', '0');
-- Vance Joy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jx8hr6lyd4e8e6f', 'Vance Joy', '132@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f074ec8c25406680bf26422','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:132@artist.com', 'jx8hr6lyd4e8e6f', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jx8hr6lyd4e8e6f', 'Crafting folk-pop anthems that resonate with heartfelt sincerity.', 'Vance Joy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ta4gvwx6euc6rqposuqsj1kwmee7233fkn0cy5x2y7buy7wdbr','jx8hr6lyd4e8e6f', 'https://i.scdn.co/image/ab67616d0000b273a9929deb093a6617d2493b03', 'Vance Joy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('eqdbuu94bzs8cllkkja83rvt66rkzhyyehy567zzol8gwehs34','Riptide','jx8hr6lyd4e8e6f',100,'POP','3JvrhDOgAt6p7K8mDyZwRd','https://p.scdn.co/mp3-preview/74698d907d114f4ba0b2c129bbf260724be80b64?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ta4gvwx6euc6rqposuqsj1kwmee7233fkn0cy5x2y7buy7wdbr', 'eqdbuu94bzs8cllkkja83rvt66rkzhyyehy567zzol8gwehs34', '0');
-- Mae Stephens
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('33dny2dzzddjjhn', 'Mae Stephens', '133@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb743f68b46b3909d5f74da093','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:133@artist.com', '33dny2dzzddjjhn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('33dny2dzzddjjhn', 'A sonic adventurer, always seeking new horizons in music.', 'Mae Stephens');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wzo5an3dpkij78m45ira0nvsazar3fxjoyawj8deevfxmzyj3h','33dny2dzzddjjhn', 'https://i.scdn.co/image/ab67616d0000b2731fc63c898797e3dbf04ad611', 'Mae Stephens Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l5z6dz00vmnhpce52779xf9aid0lyjzunu812am749fqp4ph4u','If We Ever Broke Up','33dny2dzzddjjhn',100,'POP','6maTPqynTmrkWIralgGaoP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wzo5an3dpkij78m45ira0nvsazar3fxjoyawj8deevfxmzyj3h', 'l5z6dz00vmnhpce52779xf9aid0lyjzunu812am749fqp4ph4u', '0');
-- Don Omar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qzig38wgow35wl4', 'Don Omar', '134@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:134@artist.com', 'qzig38wgow35wl4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qzig38wgow35wl4', 'A confluence of cultural beats and contemporary tunes.', 'Don Omar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('f3azvu87gehg80l9jplsrvq0ogyp3oy0a7aagt0djfp0vu6erv','qzig38wgow35wl4', 'https://i.scdn.co/image/ab67616d0000b2734640a26eb27649006be29a94', 'Don Omar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mbs10njl57sk35mswp7jt5niht9b3u7sdfs9x84glnx0sghw7u','Danza Kuduro','qzig38wgow35wl4',100,'POP','2a1o6ZejUi8U3wzzOtCOYw',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f3azvu87gehg80l9jplsrvq0ogyp3oy0a7aagt0djfp0vu6erv', 'mbs10njl57sk35mswp7jt5niht9b3u7sdfs9x84glnx0sghw7u', '0');
-- Maroon 5
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6qz31wx8b2de19i', 'Maroon 5', '135@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:135@artist.com', '6qz31wx8b2de19i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6qz31wx8b2de19i', 'Uniting fans around the globe with universal rhythms.', 'Maroon 5');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3g49ivjhwam1rzz6otmha0qp7mpuwh6yqgntqu3np02lflrdii','6qz31wx8b2de19i', 'https://i.scdn.co/image/ab67616d0000b273ce7d499847da02a9cbd1c084', 'Maroon 5 Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('efu5y2r5vfez8ayxwevtkwupbd87slvi0pwvbmgdepi9go4xjn','Payphone','6qz31wx8b2de19i',100,'POP','4P0osvTXoSYZZC2n8IFH3c',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3g49ivjhwam1rzz6otmha0qp7mpuwh6yqgntqu3np02lflrdii', 'efu5y2r5vfez8ayxwevtkwupbd87slvi0pwvbmgdepi9go4xjn', '0');
-- P!nk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hl6nu2dqle75urt', 'P!nk', '136@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7bbad89a61061304ec842588','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:136@artist.com', 'hl6nu2dqle75urt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hl6nu2dqle75urt', 'Sculpting soundwaves into masterpieces of auditory art.', 'P!nk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9z9ny1uthwb28c807pexgcxii7w4id3v0m18ud8dxuycncj880','hl6nu2dqle75urt', 'https://i.scdn.co/image/ab67616d0000b27302f93e92bdd5b3793eb688c0', 'P!nk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hazpbx0q2mh2l3c74euo1xinyqwdrwberj2i4ragtnwgk295d9','TRUSTFALL','hl6nu2dqle75urt',100,'POP','4FWbsd91QSvgr1dSWwW51e','https://p.scdn.co/mp3-preview/4a8b78e434e2dda75bc679955c3fbd8b4dad372b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9z9ny1uthwb28c807pexgcxii7w4id3v0m18ud8dxuycncj880', 'hazpbx0q2mh2l3c74euo1xinyqwdrwberj2i4ragtnwgk295d9', '0');
-- Doja Cat
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qnrkcayi5wyhtgf', 'Doja Cat', '137@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7f6d6cac38d494e87692af99','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:137@artist.com', 'qnrkcayi5wyhtgf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qnrkcayi5wyhtgf', 'Blending genres for a fresh musical experience.', 'Doja Cat');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4pad0gwhi0zivroq46e8hf7ed3mpte34g172gbrhaq3ltbcyc5','qnrkcayi5wyhtgf', 'https://i.scdn.co/image/ab67616d0000b273be841ba4bc24340152e3a79a', 'Doja Cat Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bby8lazn8fyhb0pqz31mw6j9rk59atfpv3fp861g5xn20n1q4w','Woman','qnrkcayi5wyhtgf',100,'POP','6Uj1ctrBOjOas8xZXGqKk4','https://p.scdn.co/mp3-preview/2ae0b61e45d9a5d6454a3e5ab75f8628dd89aa85?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4pad0gwhi0zivroq46e8hf7ed3mpte34g172gbrhaq3ltbcyc5', 'bby8lazn8fyhb0pqz31mw6j9rk59atfpv3fp861g5xn20n1q4w', '0');
-- Migrantes
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ab1dc8jna8hcmrr', 'Migrantes', '138@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb676e77ad14850536079e2ea8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:138@artist.com', 'ab1dc8jna8hcmrr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ab1dc8jna8hcmrr', 'Uniting fans around the globe with universal rhythms.', 'Migrantes');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('obmilz0s0fj5uve90grijf7c88wuih5dv2ydhvq3lga8g7pvyt','ab1dc8jna8hcmrr', NULL, 'Migrantes Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ekzofjul099aa5u1oj7edpi3z1pdlhzs61t67vgg7mioxl6020','MERCHO','ab1dc8jna8hcmrr',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('obmilz0s0fj5uve90grijf7c88wuih5dv2ydhvq3lga8g7pvyt', 'ekzofjul099aa5u1oj7edpi3z1pdlhzs61t67vgg7mioxl6020', '0');
-- Keane
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b7tqd05o9ne4jqr', 'Keane', '139@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41222a45dc0b10f65cbe8160','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:139@artist.com', 'b7tqd05o9ne4jqr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b7tqd05o9ne4jqr', 'A visionary in the world of music, redefining genres.', 'Keane');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kxocejpjsmyhs6magoc5qxjdwsaozkbburo5zxn9lysv6390b3','b7tqd05o9ne4jqr', 'https://i.scdn.co/image/ab67616d0000b273045d0a38105fbe7bde43c490', 'Keane Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cy7hdj7ab4mrtj1x3majdkioexhl0tmr5b02c3jmgi08c6ejqs','Somewhere Only We Know','b7tqd05o9ne4jqr',100,'POP','0ll8uFnc0nANY35E0Lfxvg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kxocejpjsmyhs6magoc5qxjdwsaozkbburo5zxn9lysv6390b3', 'cy7hdj7ab4mrtj1x3majdkioexhl0tmr5b02c3jmgi08c6ejqs', '0');
-- sped up 8282
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m795djv1kthrf6b', 'sped up 8282', '140@artist.com', 'https://i.scdn.co/image/ab67616d0000b2730a0ba228b5be4ffb7c7c59fb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:140@artist.com', 'm795djv1kthrf6b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m795djv1kthrf6b', 'Exploring the depths of sound and rhythm.', 'sped up 8282');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sgemqilm3jmbyzh8ic6r4flkk0jqsexs6i8taiv82hlzq5evp5','m795djv1kthrf6b', 'https://i.scdn.co/image/ab67616d0000b2730a0ba228b5be4ffb7c7c59fb', 'sped up 8282 Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yz0bacxfv71t0v5881il90u28hyic8pj49sketn5edhda7w2oi','Cupid  Twin Ver. (FIFTY FIFTY)  Spe','m795djv1kthrf6b',100,'POP','3B228N0GxfUCwPyfNcJxps','https://p.scdn.co/mp3-preview/29e8870f55c261ec995edfe4a3e9f30e4d4527e0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sgemqilm3jmbyzh8ic6r4flkk0jqsexs6i8taiv82hlzq5evp5', 'yz0bacxfv71t0v5881il90u28hyic8pj49sketn5edhda7w2oi', '0');
-- Sam Smith
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b24z8m3yr8r3qfa', 'Sam Smith', '141@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0aa135d864bdcf4eb112112','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:141@artist.com', 'b24z8m3yr8r3qfa', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b24z8m3yr8r3qfa', 'A soulful voice delivering deep emotional resonance.', 'Sam Smith');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('79ws9sgoxczqwcttrzq8hinxli0hm84hds8caawg83j50suf9t','b24z8m3yr8r3qfa', 'https://i.scdn.co/image/ab67616d0000b273a935e4689f15953311772cc4', 'Sam Smith Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3tsl1aw2ymm9qtpp7ve8dslv41dhd5yx2vdgx89pe3mavv5msi','Unholy (feat. Kim Petras)','b24z8m3yr8r3qfa',100,'POP','3nqQXoyQOWXiESFLlDF1hG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('79ws9sgoxczqwcttrzq8hinxli0hm84hds8caawg83j50suf9t', '3tsl1aw2ymm9qtpp7ve8dslv41dhd5yx2vdgx89pe3mavv5msi', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('es5yja2unoqf2spmpghp4794rkgvxsrf5zwbq52he84plett7v','Im Not Here To Make Friends','b24z8m3yr8r3qfa',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('79ws9sgoxczqwcttrzq8hinxli0hm84hds8caawg83j50suf9t', 'es5yja2unoqf2spmpghp4794rkgvxsrf5zwbq52he84plett7v', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rfnovptrx8xnyi66uxk1s97gua2kcchq4icl99ma6d9b0je1jg','Im Not The Only One','b24z8m3yr8r3qfa',100,'POP','5RYtz3cpYb28SV8f1FBtGc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('79ws9sgoxczqwcttrzq8hinxli0hm84hds8caawg83j50suf9t', 'rfnovptrx8xnyi66uxk1s97gua2kcchq4icl99ma6d9b0je1jg', '2');
-- Labrinth
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z8nnd1wr860ebc3', 'Labrinth', '142@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7885d725841e0338092f5f6f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:142@artist.com', 'z8nnd1wr860ebc3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z8nnd1wr860ebc3', 'Striking chords that resonate across generations.', 'Labrinth');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('iwdez7esph9foxssfqr8p21fwmseh91l0n783hls3uiwk62kv4','z8nnd1wr860ebc3', 'https://i.scdn.co/image/ab67616d0000b2731df535f5089e544a3cc86069', 'Labrinth Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k9bskekezzfh93sfrt2i522wvf226jy1697n0t1ck7ybhmulho','Never Felt So Alone','z8nnd1wr860ebc3',100,'POP','6unndO70DvZfnXYcYQMyQJ','https://p.scdn.co/mp3-preview/d33db796d822aa77728af0f4abb06ccd596d2920?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('iwdez7esph9foxssfqr8p21fwmseh91l0n783hls3uiwk62kv4', 'k9bskekezzfh93sfrt2i522wvf226jy1697n0t1ck7ybhmulho', '0');
-- Rihanna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e8pgb1tax7qssji', 'Rihanna', '143@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:143@artist.com', 'e8pgb1tax7qssji', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e8pgb1tax7qssji', 'Sculpting soundwaves into masterpieces of auditory art.', 'Rihanna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0ncipwcuqlf1gns77kvielorh0qtvm1lzcs6z8ex2gujwvj6is','e8pgb1tax7qssji', 'https://i.scdn.co/image/ab67616d0000b273bef074de9ca825bddaeb9f46', 'Rihanna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('62b9k3o65hlvzf721ehdrirwnnrl5we0ekwgwst88plgvwdf8n','We Found Love','e8pgb1tax7qssji',100,'POP','6qn9YLKt13AGvpq9jfO8py',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0ncipwcuqlf1gns77kvielorh0qtvm1lzcs6z8ex2gujwvj6is', '62b9k3o65hlvzf721ehdrirwnnrl5we0ekwgwst88plgvwdf8n', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5117sesq99uou96rsvjmrijqzrax9nmp7dg89zymss2vl9cmav','Lift Me Up - From Black Panther: Wakanda Forever - Music From and Inspired By','e8pgb1tax7qssji',100,'POP','35ovElsgyAtQwYPYnZJECg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0ncipwcuqlf1gns77kvielorh0qtvm1lzcs6z8ex2gujwvj6is', '5117sesq99uou96rsvjmrijqzrax9nmp7dg89zymss2vl9cmav', '1');
-- MC Xenon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hmlfvvbdys072m4', 'MC Xenon', '144@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb14b5fcee11164723953781ff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:144@artist.com', 'hmlfvvbdys072m4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hmlfvvbdys072m4', 'Delivering soul-stirring tunes that linger in the mind.', 'MC Xenon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i6ci3840p5kyu0dsnyawyge9ry4c1ryr6y5s74z16wtt2uw26r','hmlfvvbdys072m4', NULL, 'MC Xenon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1dvbhhfmuqq4cnergknxcujx9dsvz9qpo40j39xzvt93m0xnt5','Sem Aliana no ','hmlfvvbdys072m4',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i6ci3840p5kyu0dsnyawyge9ry4c1ryr6y5s74z16wtt2uw26r', '1dvbhhfmuqq4cnergknxcujx9dsvz9qpo40j39xzvt93m0xnt5', '0');
-- Joji
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zdve4ungfvfcwhg', 'Joji', '145@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4111c95b5f430c3265c7304b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:145@artist.com', 'zdve4ungfvfcwhg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zdve4ungfvfcwhg', 'Creating a tapestry of tunes that celebrates diversity.', 'Joji');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('c80z8ohq8t06f0gn9e1oyflmszplc7l0bzi70k5zovmk1a4xy3','zdve4ungfvfcwhg', 'https://i.scdn.co/image/ab67616d0000b27308596cc28b9f5b00bfe08ae7', 'Joji Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('61fy6yywb94t6l3b0yqjmroow3axudvk78dqqoqlpuk91bqh4n','Glimpse of Us','zdve4ungfvfcwhg',100,'POP','6xGruZOHLs39ZbVccQTuPZ','https://p.scdn.co/mp3-preview/12e4a7ef3f1051424e6e282dfba83fe8448e122f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c80z8ohq8t06f0gn9e1oyflmszplc7l0bzi70k5zovmk1a4xy3', '61fy6yywb94t6l3b0yqjmroow3axudvk78dqqoqlpuk91bqh4n', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('73lrb38gzkk6g1gghm1rhvym6zh8qsyqf5lcstmxo3jp43c7j3','Die For You','zdve4ungfvfcwhg',100,'POP','26hOm7dTtBi0TdpDGl141t','https://p.scdn.co/mp3-preview/85d19ba2d8274ab29f474b3baf07b6ac6ba6d35a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c80z8ohq8t06f0gn9e1oyflmszplc7l0bzi70k5zovmk1a4xy3', '73lrb38gzkk6g1gghm1rhvym6zh8qsyqf5lcstmxo3jp43c7j3', '1');
-- King
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nbcjm5k96raqr5q', 'King', '146@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5c0b2129a88c7d6ed0704556','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:146@artist.com', 'nbcjm5k96raqr5q', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nbcjm5k96raqr5q', 'Melodies that capture the essence of human emotion.', 'King');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sknkvzvcktsxev6u3wparl4xbi6zi8dvpkqnx4rt91kmd6muz5','nbcjm5k96raqr5q', 'https://i.scdn.co/image/ab67616d0000b27337f65266754703fd20d29854', 'King Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('203g0mzfyr5ebvsf3hyqxxz908jfpdx7ebf2h17uvliibzr65v','Maan Meri Jaan','nbcjm5k96raqr5q',100,'POP','1418IuVKQPTYqt7QNJ9RXN','https://p.scdn.co/mp3-preview/cf886ec5f6a46c234bcfdd043ab5db03db0015b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sknkvzvcktsxev6u3wparl4xbi6zi8dvpkqnx4rt91kmd6muz5', '203g0mzfyr5ebvsf3hyqxxz908jfpdx7ebf2h17uvliibzr65v', '0');
-- Chris Brown
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yrcwo0k9163emkx', 'Chris Brown', '147@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba48397e590a1c70e2cda7728','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:147@artist.com', 'yrcwo0k9163emkx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yrcwo0k9163emkx', 'Crafting soundscapes that transport listeners to another world.', 'Chris Brown');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ek8zy3qwwed7nw3e3qwnx25e9a43rh19mr1te6v6lq4mja8ilh','yrcwo0k9163emkx', 'https://i.scdn.co/image/ab67616d0000b2739a494f7d8909a6cc4ceb74ac', 'Chris Brown Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3kgwq4qf6yp9cefacegrhmsx4f7cf0rk2s3f8izxf7uyq58xou','Under The Influence','yrcwo0k9163emkx',100,'POP','5IgjP7X4th6nMNDh4akUHb','https://p.scdn.co/mp3-preview/52295df71df20e33e1510e3983975cd59f6664a4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ek8zy3qwwed7nw3e3qwnx25e9a43rh19mr1te6v6lq4mja8ilh', '3kgwq4qf6yp9cefacegrhmsx4f7cf0rk2s3f8izxf7uyq58xou', '0');
-- Sebastian Yatra
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yfzz7r833eejk86', 'Sebastian Yatra', '148@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb650a498358171e1990efeeff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:148@artist.com', 'yfzz7r833eejk86', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yfzz7r833eejk86', 'Elevating the ordinary to extraordinary through music.', 'Sebastian Yatra');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ykxf9lhozrb7lyhgpg6u4nzagkn487zks705tqru7kyqhtqvv6','yfzz7r833eejk86', 'https://i.scdn.co/image/ab67616d0000b2732d6016751b8ea5e66e83cd04', 'Sebastian Yatra Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3wdwflxunp29e4e1vuy1odz3ghn01f7mw1ctojjz6wu5dkbeb5','VAGABUNDO','yfzz7r833eejk86',100,'POP','1MB8kTH7VKvAMfL9SHgJmG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ykxf9lhozrb7lyhgpg6u4nzagkn487zks705tqru7kyqhtqvv6', '3wdwflxunp29e4e1vuy1odz3ghn01f7mw1ctojjz6wu5dkbeb5', '0');
-- Frank Ocean
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gvx66gdee7uk2yh', 'Frank Ocean', '149@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebee3123e593174208f9754fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:149@artist.com', 'gvx66gdee7uk2yh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gvx66gdee7uk2yh', 'A voice that echoes the sentiments of a generation.', 'Frank Ocean');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wk9c6a38ovutorwnc0agseqhq0o35jendnvj3pquccn8752lkn','gvx66gdee7uk2yh', 'https://i.scdn.co/image/ab67616d0000b273c5649add07ed3720be9d5526', 'Frank Ocean Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('755f7miuz7r2cimix975kzzegy8fzrp2d1zlu53ebcky8v32rj','Pink + White','gvx66gdee7uk2yh',100,'POP','3xKsf9qdS1CyvXSMEid6g8','https://p.scdn.co/mp3-preview/0e3ca894e19c37cbbbd511d9eb682d8bee030126?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wk9c6a38ovutorwnc0agseqhq0o35jendnvj3pquccn8752lkn', '755f7miuz7r2cimix975kzzegy8fzrp2d1zlu53ebcky8v32rj', '0');
-- Arctic Monkeys
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1hiybksj3zkuqkv', 'Arctic Monkeys', '150@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:150@artist.com', '1hiybksj3zkuqkv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1hiybksj3zkuqkv', 'Rock innovators, known for their sharp lyrics and compelling sound.', 'Arctic Monkeys');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('foddrpsdvy3ata56eghiearzts2uuehw03gcb2ep0abzyl3no3','1hiybksj3zkuqkv', 'https://i.scdn.co/image/ab67616d0000b2734ae1c4c5c45aabe565499163', 'Arctic Monkeys Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hzzq7fjsb3f4gcy0vk08xjizsbfknzl7863uqlx82wyo4v6y8e','I Wanna Be Yours','1hiybksj3zkuqkv',100,'POP','5XeFesFbtLpXzIVDNQP22n','https://p.scdn.co/mp3-preview/07de30bde8363d9ff78b72339245c151f67af451?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('foddrpsdvy3ata56eghiearzts2uuehw03gcb2ep0abzyl3no3', 'hzzq7fjsb3f4gcy0vk08xjizsbfknzl7863uqlx82wyo4v6y8e', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dgj46k43v36qafyj0z9sk0uwvh6ecq6cyljatvzaklxqrkgjoo','505','1hiybksj3zkuqkv',100,'POP','58ge6dfP91o9oXMzq3XkIS','https://p.scdn.co/mp3-preview/1b23606bada6aacb339535944c1fe505898195e1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('foddrpsdvy3ata56eghiearzts2uuehw03gcb2ep0abzyl3no3', 'dgj46k43v36qafyj0z9sk0uwvh6ecq6cyljatvzaklxqrkgjoo', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q5u9466gzc103stlhov78f3cgk7r10b9mpipxwuu4tw0qiy3me','Do I Wanna Know?','1hiybksj3zkuqkv',100,'POP','5FVd6KXrgO9B3JPmC8OPst','https://p.scdn.co/mp3-preview/006bc465fe3d1c04dae93a050eca9d402a7322b8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('foddrpsdvy3ata56eghiearzts2uuehw03gcb2ep0abzyl3no3', 'q5u9466gzc103stlhov78f3cgk7r10b9mpipxwuu4tw0qiy3me', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9t55b3b9x1jcm27aa832nrccm5bzwi4h9p4vxoplckb2tiff9k','Whyd You Only Call Me When Youre High?','1hiybksj3zkuqkv',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('foddrpsdvy3ata56eghiearzts2uuehw03gcb2ep0abzyl3no3', '9t55b3b9x1jcm27aa832nrccm5bzwi4h9p4vxoplckb2tiff9k', '3');
-- Anggi Marito
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1cd6d1e0u3s8trg', 'Anggi Marito', '151@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb604493f4d58b7d152a2d5f79','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:151@artist.com', '1cd6d1e0u3s8trg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1cd6d1e0u3s8trg', 'The architect of aural landscapes that inspire and captivate.', 'Anggi Marito');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g3ghxitr9nza1de4xdcamdu0rhvi5lv1bp86w9233rsgq22ah4','1cd6d1e0u3s8trg', 'https://i.scdn.co/image/ab67616d0000b2732844c4e4e984ea408ab7fd6f', 'Anggi Marito Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h0yh5pgyi9rftd4q8uyh1xeqdyjjbucmf9gk057ef2kescrs2u','Tak Segampang Itu','1cd6d1e0u3s8trg',100,'POP','26cvTWJq2E1QqN4jyH2OTU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g3ghxitr9nza1de4xdcamdu0rhvi5lv1bp86w9233rsgq22ah4', 'h0yh5pgyi9rftd4q8uyh1xeqdyjjbucmf9gk057ef2kescrs2u', '0');
-- Glass Animals
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ztlq7p5unexuhmq', 'Glass Animals', '152@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb66b27eccb69756f8eceabc23','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:152@artist.com', 'ztlq7p5unexuhmq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ztlq7p5unexuhmq', 'Crafting psychedelic pop with intricate melodies and immersive soundscapes.', 'Glass Animals');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bw551exil0cb5dh1nf72tkymoqg96rqg66ctq8u63o9neirkw8','ztlq7p5unexuhmq', 'https://i.scdn.co/image/ab67616d0000b273712701c5e263efc8726b1464', 'Glass Animals Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('38vgnjemk5m1jcvw1vipzbywbfdclb3rnra0wy8k9sywg95zie','Heat Waves','ztlq7p5unexuhmq',100,'POP','3USxtqRwSYz57Ewm6wWRMp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bw551exil0cb5dh1nf72tkymoqg96rqg66ctq8u63o9neirkw8', '38vgnjemk5m1jcvw1vipzbywbfdclb3rnra0wy8k9sywg95zie', '0');
-- Dean Lewis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('87x97y6fne7g8sm', 'Dean Lewis', '153@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4fc14e184f9e05ba0676ddee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:153@artist.com', '87x97y6fne7g8sm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('87x97y6fne7g8sm', 'Pushing the boundaries of sound with each note.', 'Dean Lewis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0ur77gy8dn6pk956ev87r4nexpzrkrieiyj0d1a5kgrxyxon3r','87x97y6fne7g8sm', 'https://i.scdn.co/image/ab67616d0000b273bfedccaca3c8425fdc0a7c73', 'Dean Lewis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x1umgigue6296b2xa8v5thtevzvue529kmhvw494ylp73twnv9','How Do I Say Goodbye','87x97y6fne7g8sm',100,'POP','5hnGrTBaEsdukpDF6aZg8a',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0ur77gy8dn6pk956ev87r4nexpzrkrieiyj0d1a5kgrxyxon3r', 'x1umgigue6296b2xa8v5thtevzvue529kmhvw494ylp73twnv9', '0');
-- Bad Bunny
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hybg2a4rboxwjda', 'Bad Bunny', '154@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9ad50e478a469448c6f369df','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:154@artist.com', 'hybg2a4rboxwjda', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hybg2a4rboxwjda', 'A trailblazer in Latin trap and reggaeton, known for his charismatic style and innovative music.', 'Bad Bunny');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('a0aptarmv7fmfd0sukm77wt5qofltrq62faqtx1y1x3nlqcick','hybg2a4rboxwjda', 'https://i.scdn.co/image/ab67616d0000b273ab5c9cd818ad6ed3e9b79cd1', 'Bad Bunny Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fd03ht4lu2gez66aagea5qta0b4mycvptjw68h5hzy5h6fv3nf','WHERE SHE GOES','hybg2a4rboxwjda',100,'POP','7ro0hRteUMfnOioTFI5TG1','https://p.scdn.co/mp3-preview/b9b7e4c982b33ee23c4867f7a3025e3598c35760?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a0aptarmv7fmfd0sukm77wt5qofltrq62faqtx1y1x3nlqcick', 'fd03ht4lu2gez66aagea5qta0b4mycvptjw68h5hzy5h6fv3nf', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wpd3wy6k2dxenvrdljtxo9afsh48m4ii6a2o2ty7p3j0w31l96','un x100to','hybg2a4rboxwjda',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a0aptarmv7fmfd0sukm77wt5qofltrq62faqtx1y1x3nlqcick', 'wpd3wy6k2dxenvrdljtxo9afsh48m4ii6a2o2ty7p3j0w31l96', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ldsu2bbdsk4qm5kdkodydm5qbtt8k8zfcvopzjcc9nbvoej3aj','Coco Chanel','hybg2a4rboxwjda',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a0aptarmv7fmfd0sukm77wt5qofltrq62faqtx1y1x3nlqcick', 'ldsu2bbdsk4qm5kdkodydm5qbtt8k8zfcvopzjcc9nbvoej3aj', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gqyvjngdi6a432p7yfev0dxdyx2sldxw1mvd53tufaufvit8k5','Titi Me Pregunt','hybg2a4rboxwjda',100,'POP','1IHWl5LamUGEuP4ozKQSXZ','https://p.scdn.co/mp3-preview/53a6217761f8fdfcff92189cafbbd1cc21fdb813?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a0aptarmv7fmfd0sukm77wt5qofltrq62faqtx1y1x3nlqcick', 'gqyvjngdi6a432p7yfev0dxdyx2sldxw1mvd53tufaufvit8k5', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2kwe4ote6c7kaqfrzl48r76jda3fsyd0ethg0kxyh05x9wxsef','Efecto','hybg2a4rboxwjda',100,'POP','5Eax0qFko2dh7Rl2lYs3bx','https://p.scdn.co/mp3-preview/a622a47c8df98ef72676608511c0b2e1d5d51268?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a0aptarmv7fmfd0sukm77wt5qofltrq62faqtx1y1x3nlqcick', '2kwe4ote6c7kaqfrzl48r76jda3fsyd0ethg0kxyh05x9wxsef', '4');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oepfm51t0fmtbi5diswgx0inwbesyvg8nxqy9rg6m7z90ub82p','Neverita','hybg2a4rboxwjda',100,'POP','31i56LZnwE6uSu3exoHjtB','https://p.scdn.co/mp3-preview/b50a3cafa2eb688f811d4079812649bfba050417?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a0aptarmv7fmfd0sukm77wt5qofltrq62faqtx1y1x3nlqcick', 'oepfm51t0fmtbi5diswgx0inwbesyvg8nxqy9rg6m7z90ub82p', '5');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kdmf0o5qf1pocp3m90or4m5g5tw3kkvgeeozksuh527huqm6z1','Moscow Mule','hybg2a4rboxwjda',100,'POP','6Xom58OOXk2SoU711L2IXO','https://p.scdn.co/mp3-preview/77b12f38abcff65705166d67b5657f70cd890635?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a0aptarmv7fmfd0sukm77wt5qofltrq62faqtx1y1x3nlqcick', 'kdmf0o5qf1pocp3m90or4m5g5tw3kkvgeeozksuh527huqm6z1', '6');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hpz74el1gv716fd2vlksge8cvp1cmicx6de7hwy7gxtorzn48y','Yonaguni','hybg2a4rboxwjda',100,'POP','2JPLbjOn0wPCngEot2STUS','https://p.scdn.co/mp3-preview/cbade9b0e669565ac8c7c07490f961e4c471b9ee?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a0aptarmv7fmfd0sukm77wt5qofltrq62faqtx1y1x3nlqcick', 'hpz74el1gv716fd2vlksge8cvp1cmicx6de7hwy7gxtorzn48y', '7');
-- Feid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sfn6aek9l32xm2s', 'Feid', '155@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0a248d29f8faa91f971e5cae','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:155@artist.com', 'sfn6aek9l32xm2s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sfn6aek9l32xm2s', 'A standout artist in urban Latin music, known for his catchy melodies and smooth vocals.', 'Feid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('alwyjk61p0te0tmx46e5n7nwpweqy2dy6ehqi3p9uae49eg0e9','sfn6aek9l32xm2s', 'https://i.scdn.co/image/ab67616d0000b27329ebee2b5fb008871fcd201a', 'Feid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8i3y3sss2pfrh90lwgh5qa8vg1lpvnlwgdlfd2zgi031vx38wv','Classy 101','sfn6aek9l32xm2s',100,'POP','6XSqqQIy7Lm7SnwxS4NrGx',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('alwyjk61p0te0tmx46e5n7nwpweqy2dy6ehqi3p9uae49eg0e9', '8i3y3sss2pfrh90lwgh5qa8vg1lpvnlwgdlfd2zgi031vx38wv', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3tmu73d70iclbyqv9xb95vajz3u7ybzjdcox4ecqkbvbo6ymr7','El Cielo','sfn6aek9l32xm2s',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('alwyjk61p0te0tmx46e5n7nwpweqy2dy6ehqi3p9uae49eg0e9', '3tmu73d70iclbyqv9xb95vajz3u7ybzjdcox4ecqkbvbo6ymr7', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dgd907d6ccvrticnx5rcfo62r5lsyfa025cb8z56q1li3csqne','Feliz Cumpleaos Fe','sfn6aek9l32xm2s',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('alwyjk61p0te0tmx46e5n7nwpweqy2dy6ehqi3p9uae49eg0e9', 'dgd907d6ccvrticnx5rcfo62r5lsyfa025cb8z56q1li3csqne', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1jy5tilsg618zranmtb4tld0wurdyfex491r7mpkgug2rdb3ug','POLARIS - Remix','sfn6aek9l32xm2s',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('alwyjk61p0te0tmx46e5n7nwpweqy2dy6ehqi3p9uae49eg0e9', '1jy5tilsg618zranmtb4tld0wurdyfex491r7mpkgug2rdb3ug', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4w0ns2ssacekekempismudw7tzza8ra0x7iyvjssc3tyrfhfka','CHORRITO PA LAS ANIMAS','sfn6aek9l32xm2s',100,'POP','0CYTGMBYkwUxrj1MWDLrC5',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('alwyjk61p0te0tmx46e5n7nwpweqy2dy6ehqi3p9uae49eg0e9', '4w0ns2ssacekekempismudw7tzza8ra0x7iyvjssc3tyrfhfka', '4');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w1c9lkvqbukjevu25kyfvxxmny1iatn51ph1j9zxyq9j3eenbl','Normal','sfn6aek9l32xm2s',100,'POP','0T2pB7P1VdXPhLdQZ488uH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('alwyjk61p0te0tmx46e5n7nwpweqy2dy6ehqi3p9uae49eg0e9', 'w1c9lkvqbukjevu25kyfvxxmny1iatn51ph1j9zxyq9j3eenbl', '5');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9no0b6weoji6gzha3j00dhlwyrd4fdbaadr0w6aoqnnykbu98h','REMIX EXCLUSIVO','sfn6aek9l32xm2s',100,'POP','3eqCJfgJJs8iKx49KO12s3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('alwyjk61p0te0tmx46e5n7nwpweqy2dy6ehqi3p9uae49eg0e9', '9no0b6weoji6gzha3j00dhlwyrd4fdbaadr0w6aoqnnykbu98h', '6');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5a98fo0h9an4pixp05rvwcaigl5nujty5em2n488smtaq5hxjp','LA INOCENTE','sfn6aek9l32xm2s',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('alwyjk61p0te0tmx46e5n7nwpweqy2dy6ehqi3p9uae49eg0e9', '5a98fo0h9an4pixp05rvwcaigl5nujty5em2n488smtaq5hxjp', '7');
-- J Balvin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zi9nv3edgzs6mml', 'J Balvin', '156@artist.com', 'https://i.scdn.co/image/ab67616d0000b273498cf6571df9adf37e46b527','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:156@artist.com', 'zi9nv3edgzs6mml', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zi9nv3edgzs6mml', 'A symphony of emotions expressed through sound.', 'J Balvin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i8a0d1j0dxst8nr0mtael9gmyyr54afza2pdxuyuy1rnosj5vf','zi9nv3edgzs6mml', 'https://i.scdn.co/image/ab67616d0000b2734891d9b25d8919448388f3bb', 'J Balvin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('amnv09qhr6ga132kkpgfwug72uai2mlcxihdgv4rnehhwvo2cy','LA CANCI','zi9nv3edgzs6mml',100,'POP','0fea68AdmYNygeTGI4RC18',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i8a0d1j0dxst8nr0mtael9gmyyr54afza2pdxuyuy1rnosj5vf', 'amnv09qhr6ga132kkpgfwug72uai2mlcxihdgv4rnehhwvo2cy', '0');
-- The Police
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9kybmvzvsgot4zp', 'The Police', '157@artist.com', 'https://i.scdn.co/image/1f73a61faca2942cd5ea29c2143184db8645f0b3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:157@artist.com', '9kybmvzvsgot4zp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9kybmvzvsgot4zp', 'Melodies that capture the essence of human emotion.', 'The Police');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ozgg5a7s625l2r3e4pxll4lhgubzjoffpodk5c3owmaivcw8fz','9kybmvzvsgot4zp', 'https://i.scdn.co/image/ab67616d0000b2730408dc279dd7c7354ff41014', 'The Police Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6hajelcle6sd5e9886dklzny2j3zr15wvk6x5pdxkx3h5wtunt','Every Breath You Take - Remastered 2003','9kybmvzvsgot4zp',100,'POP','0wF2zKJmgzjPTfircPJ2jg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ozgg5a7s625l2r3e4pxll4lhgubzjoffpodk5c3owmaivcw8fz', '6hajelcle6sd5e9886dklzny2j3zr15wvk6x5pdxkx3h5wtunt', '0');
-- Plan B
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nq18hnhk8unq8sc', 'Plan B', '158@artist.com', 'https://i.scdn.co/image/eb21793908d1eabe0fba02659bdff4e4a4b3724a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:158@artist.com', 'nq18hnhk8unq8sc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nq18hnhk8unq8sc', 'Breathing new life into classic genres.', 'Plan B');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nbcf2c181q9byl287i5kn6vrqzbiaa7loai9tt2hvp3t7lphei','nq18hnhk8unq8sc', 'https://i.scdn.co/image/ab67616d0000b273913ef74e0272d688c512200b', 'Plan B Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5dwnu01tbig37vimaslx5mvl8blbzh4ib0yi3nfkszaytd4f6p','Es un Secreto','nq18hnhk8unq8sc',100,'POP','7JwdbqIpiuWvGbRryKSuBz','https://p.scdn.co/mp3-preview/feeeb03d75e53b19bb2e67502a1b498e87cdfef8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbcf2c181q9byl287i5kn6vrqzbiaa7loai9tt2hvp3t7lphei', '5dwnu01tbig37vimaslx5mvl8blbzh4ib0yi3nfkszaytd4f6p', '0');
-- Twisted
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wqp0rv8fnji5cys', 'Twisted', '159@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2615ef39cf9128c447b31619','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:159@artist.com', 'wqp0rv8fnji5cys', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wqp0rv8fnji5cys', 'A unique voice in the contemporary music scene.', 'Twisted');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('maeu51sspe6ehko23up6mtykp9wvy3ux3px8zibg3nwc4siteb','wqp0rv8fnji5cys', 'https://i.scdn.co/image/ab67616d0000b273f5e2ffd88f07e55f34c361c8', 'Twisted Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lo66yze5achzqq2vcvuxgtb1monok2vbt7hlc9p105k4ptfa0j','WORTH NOTHING','wqp0rv8fnji5cys',100,'POP','3PjbA0O5olhampPMdaB0V1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('maeu51sspe6ehko23up6mtykp9wvy3ux3px8zibg3nwc4siteb', 'lo66yze5achzqq2vcvuxgtb1monok2vbt7hlc9p105k4ptfa0j', '0');
-- Melanie Martinez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x69sglljm6fhosv', 'Melanie Martinez', '160@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb77ecd63aaebe2225b07c89f0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:160@artist.com', 'x69sglljm6fhosv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x69sglljm6fhosv', 'A sonic adventurer, always seeking new horizons in music.', 'Melanie Martinez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2jtb7cold5y9f4qshsefyz4l9ema7cnz7wsp6rzwdj9tt4h6db','x69sglljm6fhosv', 'https://i.scdn.co/image/ab67616d0000b2733c6c534cdacc9cf53e6d2977', 'Melanie Martinez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aybajf4n0h31l3zt49ews7a5ncx23evjujws1045xhim206iuz','VOID','x69sglljm6fhosv',100,'POP','6wmKvtSmyTqHNo44OBXVN1','https://p.scdn.co/mp3-preview/9a2ae9278ecfe2ed8d628dfe05699bf24395d6a0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2jtb7cold5y9f4qshsefyz4l9ema7cnz7wsp6rzwdj9tt4h6db', 'aybajf4n0h31l3zt49ews7a5ncx23evjujws1045xhim206iuz', '0');
-- Lizzy McAlpine
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('btsb1duyv9d02wh', 'Lizzy McAlpine', '161@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb10e2b618880f429a3967185','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:161@artist.com', 'btsb1duyv9d02wh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('btsb1duyv9d02wh', 'A beacon of innovation in the world of sound.', 'Lizzy McAlpine');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6xz6313df1vmrrho6yrkkr8l8k1bimqdqwd84s1bg9qvspzu0p','btsb1duyv9d02wh', 'https://i.scdn.co/image/ab67616d0000b273d370fdc4dbc47778b9b667c3', 'Lizzy McAlpine Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rfqa66e7pd38pddqwrpz2e1qa0zcnntvg857yo3p107xl80wbq','ceilings','btsb1duyv9d02wh',100,'POP','2L9N0zZnd37dwF0clgxMGI','https://p.scdn.co/mp3-preview/580782ffb17d468fe5d000bdf86cc07926ff9a5a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6xz6313df1vmrrho6yrkkr8l8k1bimqdqwd84s1bg9qvspzu0p', 'rfqa66e7pd38pddqwrpz2e1qa0zcnntvg857yo3p107xl80wbq', '0');
-- Imagine Dragons
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('murl4y92qayns7r', 'Imagine Dragons', '162@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb920dc1f617550de8388f368e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:162@artist.com', 'murl4y92qayns7r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('murl4y92qayns7r', 'Sculpting soundwaves into masterpieces of auditory art.', 'Imagine Dragons');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vtm7myz6h1xre2irtbpsvndo3ee86nx8vnevxk7lgr0i5c6lpx','murl4y92qayns7r', 'https://i.scdn.co/image/ab67616d0000b273fc915b69600dce2991a61f13', 'Imagine Dragons Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0fgfp2adz49stj2mtp0bsfiipym954xmatzuialyrv9fz1zkr5','Bones','murl4y92qayns7r',100,'POP','54ipXppHLA8U4yqpOFTUhr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vtm7myz6h1xre2irtbpsvndo3ee86nx8vnevxk7lgr0i5c6lpx', '0fgfp2adz49stj2mtp0bsfiipym954xmatzuialyrv9fz1zkr5', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g70idetgakz9ye7238os7xo7oy409tizt59s5ir0stqfsrtn1m','Believer','murl4y92qayns7r',100,'POP','0pqnGHJpmpxLKifKRmU6WP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vtm7myz6h1xre2irtbpsvndo3ee86nx8vnevxk7lgr0i5c6lpx', 'g70idetgakz9ye7238os7xo7oy409tizt59s5ir0stqfsrtn1m', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('717qfeoqmfnd2xxoivsnky04t16pzanwl5qbbg0zkbp94vkqgo','Demons','murl4y92qayns7r',100,'POP','3LlAyCYU26dvFZBDUIMb7a',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vtm7myz6h1xre2irtbpsvndo3ee86nx8vnevxk7lgr0i5c6lpx', '717qfeoqmfnd2xxoivsnky04t16pzanwl5qbbg0zkbp94vkqgo', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('di705rfr5hro8az22zrylu2q9kwxlxf3z90n39rzpjvxjww4i8','Enemy (with JID) - from the series Arcane League of Legends','murl4y92qayns7r',100,'POP','3CIyK1V4JEJkg02E4EJnDl',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vtm7myz6h1xre2irtbpsvndo3ee86nx8vnevxk7lgr0i5c6lpx', 'di705rfr5hro8az22zrylu2q9kwxlxf3z90n39rzpjvxjww4i8', '3');
-- OneRepublic
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vc8hynqbwhqdczc', 'OneRepublic', '163@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb57138b98e7ddd5a86ee97a9b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:163@artist.com', 'vc8hynqbwhqdczc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vc8hynqbwhqdczc', 'Delivering anthemic pop-rock tracks that resonate globally.', 'OneRepublic');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2gn60tvckpgjog7bla887gqc1qh5k4f9zfyj86hvzad8iiey6l','vc8hynqbwhqdczc', 'https://i.scdn.co/image/ab67616d0000b273ec96e006b8bdfc582610ec13', 'OneRepublic Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('924hs4kib0ci4e57c1zw446sa5ib3ea65j2lu11txqvub8vjc5','I Aint Worried','vc8hynqbwhqdczc',100,'POP','4h9wh7iOZ0GGn8QVp4RAOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2gn60tvckpgjog7bla887gqc1qh5k4f9zfyj86hvzad8iiey6l', '924hs4kib0ci4e57c1zw446sa5ib3ea65j2lu11txqvub8vjc5', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4riprxgb3iyyo9k9r4dgh6occcv1ztanxf94zng82rvxzb990j','Counting Stars','vc8hynqbwhqdczc',100,'POP','2tpWsVSb9UEmDRxAl1zhX1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2gn60tvckpgjog7bla887gqc1qh5k4f9zfyj86hvzad8iiey6l', '4riprxgb3iyyo9k9r4dgh6occcv1ztanxf94zng82rvxzb990j', '1');
-- Taiu
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('we76f97keb1e20e', 'Taiu', '164@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdb80abf52d59577d244b8019','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:164@artist.com', 'we76f97keb1e20e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('we76f97keb1e20e', 'Redefining what it means to be an artist in the digital age.', 'Taiu');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vtbh237rq08jqnf27e139r1mxvxhka2g5pfhvwrtkem0lqtzz2','we76f97keb1e20e', 'https://i.scdn.co/image/ab67616d0000b273d467bed4e6b2a01ea8569100', 'Taiu Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tl3qvdebduzp53ku3k9eg85sr7yr4li25k55lnjr115v99o52w','Rara Vez','we76f97keb1e20e',100,'POP','7MVIfkyzuUmQ716j8U7yGR',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vtbh237rq08jqnf27e139r1mxvxhka2g5pfhvwrtkem0lqtzz2', 'tl3qvdebduzp53ku3k9eg85sr7yr4li25k55lnjr115v99o52w', '0');
-- Eslabon Armado
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m31e36degc5feos', 'Eslabon Armado', '165@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5ccab5d3dc10a08d89cbd76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:165@artist.com', 'm31e36degc5feos', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m31e36degc5feos', 'Bringing a fresh take to traditional music, weaving in modern influences.', 'Eslabon Armado');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7c31krs9ir6qr4extoju1earmgpe6vxsa5ki2gd5vq9ho09upi','m31e36degc5feos', 'https://i.scdn.co/image/ab67616d0000b2732071a0c79802d9375a53bfef', 'Eslabon Armado Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('po1ntpn1qg0myy3mtvltkdmevlnr8ieebz7ory6xfepc54a46j','Ella Baila Sola','m31e36degc5feos',100,'POP','3dnP0JxCgygwQH9Gm7q7nb','https://p.scdn.co/mp3-preview/5d39f3e17f1e20e2711d033001e48b8d4249b992?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7c31krs9ir6qr4extoju1earmgpe6vxsa5ki2gd5vq9ho09upi', 'po1ntpn1qg0myy3mtvltkdmevlnr8ieebz7ory6xfepc54a46j', '0');
-- Radiohead
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2vshzvxi4pfhe2i', 'Radiohead', '166@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba03696716c9ee605006047fd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:166@artist.com', '2vshzvxi4pfhe2i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2vshzvxi4pfhe2i', 'Transcending language barriers through the universal language of music.', 'Radiohead');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wvl478ar7hc27sbynuoqmgzm4ei70vdgf5yhjgng0tslez0rtu','2vshzvxi4pfhe2i', 'https://i.scdn.co/image/ab67616d0000b273df55e326ed144ab4f5cecf95', 'Radiohead Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d2z26m38vtg1kwphl8r3du9z4zfv7pybpme3u5evf47e11i02x','Creep','2vshzvxi4pfhe2i',100,'POP','70LcF31zb1H0PyJoS1Sx1r','https://p.scdn.co/mp3-preview/713b601d02641a850f2a3e6097aacaff52328d57?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wvl478ar7hc27sbynuoqmgzm4ei70vdgf5yhjgng0tslez0rtu', 'd2z26m38vtg1kwphl8r3du9z4zfv7pybpme3u5evf47e11i02x', '0');
-- Drake
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hollpugjkm7kuqr', 'Drake', '167@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb35ca7d2181258b51c0f2cf9e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:167@artist.com', 'hollpugjkm7kuqr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hollpugjkm7kuqr', 'A symphony of emotions expressed through sound.', 'Drake');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tpfk3i3r1dcj9jmp25r6r0sx9dmj1h5fyuelq88pza19zgy595','hollpugjkm7kuqr', 'https://i.scdn.co/image/ab67616d0000b2738dc0d801766a5aa6a33cbe37', 'Drake Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i6nbjzsrwz2bf2htl29l3x1r1bhmsulzpqxx2xlcg9aiire5yt','Jimmy Cooks (feat. 21 Savage)','hollpugjkm7kuqr',100,'POP','3F5CgOj3wFlRv51JsHbxhe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tpfk3i3r1dcj9jmp25r6r0sx9dmj1h5fyuelq88pza19zgy595', 'i6nbjzsrwz2bf2htl29l3x1r1bhmsulzpqxx2xlcg9aiire5yt', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lbcfrh9s8mccwj4evs9w4oeuf6eh3t15bns1tk268r63bdxoj6','One Dance','hollpugjkm7kuqr',100,'POP','1zi7xx7UVEFkmKfv06H8x0',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tpfk3i3r1dcj9jmp25r6r0sx9dmj1h5fyuelq88pza19zgy595', 'lbcfrh9s8mccwj4evs9w4oeuf6eh3t15bns1tk268r63bdxoj6', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cegirfxxg7qpkhe6jukvjfqi8cc183fc1c6bdzpwed3fjvm241','Search & Rescue','hollpugjkm7kuqr',100,'POP','7aRCf5cLOFN1U7kvtChY1G',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tpfk3i3r1dcj9jmp25r6r0sx9dmj1h5fyuelq88pza19zgy595', 'cegirfxxg7qpkhe6jukvjfqi8cc183fc1c6bdzpwed3fjvm241', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7scf53mvwxx49ub0l3x5mv1nho63yg3ltzfq4unjoj8p8l0e4n','Rich Flex','hollpugjkm7kuqr',100,'POP','1bDbXMyjaUIooNwFE9wn0N',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tpfk3i3r1dcj9jmp25r6r0sx9dmj1h5fyuelq88pza19zgy595', '7scf53mvwxx49ub0l3x5mv1nho63yg3ltzfq4unjoj8p8l0e4n', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4i9kdpyxjifckywvcexj8gvbursga4v7l0u1xkqopmtyrkp3og','WAIT FOR U (feat. Drake & Tems)','hollpugjkm7kuqr',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tpfk3i3r1dcj9jmp25r6r0sx9dmj1h5fyuelq88pza19zgy595', '4i9kdpyxjifckywvcexj8gvbursga4v7l0u1xkqopmtyrkp3og', '4');
-- Marshmello
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6x6d76tnss1sill', 'Marshmello', '168@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41e4a3b8c1d45a9e49b6de21','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:168@artist.com', '6x6d76tnss1sill', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6x6d76tnss1sill', 'An electronic music maestro known for his infectious beats.', 'Marshmello');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dky9qxh8wujh09odpaqzlsqmxzvlw6w1apo8dpfxc9u7n1z53j','6x6d76tnss1sill', 'https://i.scdn.co/image/ab67616d0000b273f404676577626a87d92cf33f', 'Marshmello Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t4ierh0d8jtbjkkeabpsre1sdns0n7jb9udrtfm0zj3y0z5aqz','El Merengue','6x6d76tnss1sill',100,'POP','51FvjPEGKq2zByeeEQ43V9','https://p.scdn.co/mp3-preview/a933b6e1d6a47e591c13192f2b5e58739d3d5a06?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dky9qxh8wujh09odpaqzlsqmxzvlw6w1apo8dpfxc9u7n1z53j', 't4ierh0d8jtbjkkeabpsre1sdns0n7jb9udrtfm0zj3y0z5aqz', '0');
-- Fifty Fifty
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('r6nn0vn0cyi5ihd', 'Fifty Fifty', '169@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5a60b0f886b5deb8518e4a41','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:169@artist.com', 'r6nn0vn0cyi5ihd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('r6nn0vn0cyi5ihd', 'Blending a rich array of genres to create a unique musical experience.', 'Fifty Fifty');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x6w57vl4qkey0n2tonhr9injie713m1nm7sa1i8wlyzlp9klbn','r6nn0vn0cyi5ihd', 'https://i.scdn.co/image/ab67616d0000b27337c0b3670236c067c8e8bbcb', 'Fifty Fifty Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1m3fw47btej14hhz5yh44a3e6fu2io3vy8fk67oejehmgc516w','Cupid - Twin Ver.','r6nn0vn0cyi5ihd',100,'POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x6w57vl4qkey0n2tonhr9injie713m1nm7sa1i8wlyzlp9klbn', '1m3fw47btej14hhz5yh44a3e6fu2io3vy8fk67oejehmgc516w', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1cd6svxhemmovg5eyl6zx0qk47hx89na3rjbuntqom8kxqdjld','Cupid','r6nn0vn0cyi5ihd',100,'POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x6w57vl4qkey0n2tonhr9injie713m1nm7sa1i8wlyzlp9klbn', '1cd6svxhemmovg5eyl6zx0qk47hx89na3rjbuntqom8kxqdjld', '1');
-- Dave
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5gtlxkqqctbmi7h', 'Dave', '170@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:170@artist.com', '5gtlxkqqctbmi7h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5gtlxkqqctbmi7h', 'A master of words, blending rap with social commentary and raw emotion.', 'Dave');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cnrh2vvd8lxygtbvopb452adtksne7c73ssvha8w9sclmxo2td','5gtlxkqqctbmi7h', 'https://i.scdn.co/image/ab67616d0000b273e3a09a9ae3f1fa102c110e60', 'Dave Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qw1o9me6zcd14nu66reg0cy6idsdv79739u1ghhy6bwcbsq9gf','Sprinter','5gtlxkqqctbmi7h',100,'POP','2FDTHlrBguDzQkp7PVj16Q',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cnrh2vvd8lxygtbvopb452adtksne7c73ssvha8w9sclmxo2td', 'qw1o9me6zcd14nu66reg0cy6idsdv79739u1ghhy6bwcbsq9gf', '0');
-- Miguel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3zc3jnuy4ttwhk0', 'Miguel', '171@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4669166b571594eade778990','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:171@artist.com', '3zc3jnuy4ttwhk0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3zc3jnuy4ttwhk0', 'Breathing new life into classic genres.', 'Miguel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qxlizgkarzuu1vrvs2a46xbosabeeq984hob43wsjbxl3wmq7f','3zc3jnuy4ttwhk0', 'https://i.scdn.co/image/ab67616d0000b273d5a8395b0d80b8c48a5d851c', 'Miguel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1k41vniucs57emb0rrfyzdfznp5obaeo4sj7ce1yh5ya44e7v7','Sure Thing','3zc3jnuy4ttwhk0',100,'POP','0JXXNGljqupsJaZsgSbMZV','https://p.scdn.co/mp3-preview/d337faa4bb71c8ac9a13998be64fbb0d7d8b8463?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qxlizgkarzuu1vrvs2a46xbosabeeq984hob43wsjbxl3wmq7f', '1k41vniucs57emb0rrfyzdfznp5obaeo4sj7ce1yh5ya44e7v7', '0');
-- Dean Martin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e4g6aihfz1elzo9', 'Dean Martin', '172@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdc6d54b08006b8896cb199e5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:172@artist.com', 'e4g6aihfz1elzo9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e4g6aihfz1elzo9', 'Melodies that capture the essence of human emotion.', 'Dean Martin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ttowmje529353737chtwanhsexqx5otdnjkpewcec9hz4koymo','e4g6aihfz1elzo9', 'https://i.scdn.co/image/ab67616d0000b2736d88028a85c771f37374c8ea', 'Dean Martin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('828c4ieza49y93b16v9cxfcm95sl78ucbq5ckadv6eq71vuk7i','Let It Snow! Let It Snow! Let It Snow!','e4g6aihfz1elzo9',100,'POP','2uFaJJtFpPDc5Pa95XzTvg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ttowmje529353737chtwanhsexqx5otdnjkpewcec9hz4koymo', '828c4ieza49y93b16v9cxfcm95sl78ucbq5ckadv6eq71vuk7i', '0');
-- Kaifi Khalil
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jgrg58ofyjm0irv', 'Kaifi Khalil', '173@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8b3d777345ecd2f25f408586','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:173@artist.com', 'jgrg58ofyjm0irv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jgrg58ofyjm0irv', 'An endless quest for musical perfection.', 'Kaifi Khalil');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sngr6ma6e5ql72a4klaewbs0c51y5knfjnl0boim4g71oh35s2','jgrg58ofyjm0irv', 'https://i.scdn.co/image/ab67616d0000b2734697d4ee22b3f63c17a3b9ec', 'Kaifi Khalil Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0gtrdunjfbbdjcqzz0zc69cku2h4ddue7o66xvby30b8d6qp3t','Kahani Suno 2.0','jgrg58ofyjm0irv',100,'POP','4VsP4Dm8gsibRxB5I2hEkw','https://p.scdn.co/mp3-preview/2c644e9345d1a0ab97e4541d26b6b8ccb2c889f9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sngr6ma6e5ql72a4klaewbs0c51y5knfjnl0boim4g71oh35s2', '0gtrdunjfbbdjcqzz0zc69cku2h4ddue7o66xvby30b8d6qp3t', '0');
-- Shakira
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3t3qfn85megxlez', 'Shakira', '174@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb284894d68fe2f80cad555110','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:174@artist.com', '3t3qfn85megxlez', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3t3qfn85megxlez', 'Igniting the stage with electrifying performances.', 'Shakira');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ci2dra0ctrz63sqqte0hgj5xp11vpdj26xrqyvgdmitl95aw7i','3t3qfn85megxlez', NULL, 'Shakira Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zd887x8uq0zjb6i1513wbs2z2uyiqvvhx0oqcp1i3146ftuesq','Shakira: Bzrp Music Sessions, Vol. 53','3t3qfn85megxlez',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ci2dra0ctrz63sqqte0hgj5xp11vpdj26xrqyvgdmitl95aw7i', 'zd887x8uq0zjb6i1513wbs2z2uyiqvvhx0oqcp1i3146ftuesq', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ynixjq055vhpof1i1x4knjhqdmhbc2i1vwiiamfd32au4mvnes','Acrs','3t3qfn85megxlez',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ci2dra0ctrz63sqqte0hgj5xp11vpdj26xrqyvgdmitl95aw7i', 'ynixjq055vhpof1i1x4knjhqdmhbc2i1vwiiamfd32au4mvnes', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9t5psoduy2hervpca249vkduwjbtj7yqshif7zp2cnxz1a3fxd','Te Felicito','3t3qfn85megxlez',100,'POP','2rurDawMfoKP4uHyb2kJBt','https://p.scdn.co/mp3-preview/6b4b2be03b14bf758835c8f28f35834da35cc1c3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ci2dra0ctrz63sqqte0hgj5xp11vpdj26xrqyvgdmitl95aw7i', '9t5psoduy2hervpca249vkduwjbtj7yqshif7zp2cnxz1a3fxd', '2');
-- NLE Choppa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jg74bhwg8cs6tm9', 'NLE Choppa', '175@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcc5865053e7177aeb0c26b62','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:175@artist.com', 'jg74bhwg8cs6tm9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jg74bhwg8cs6tm9', 'Revolutionizing the music scene with innovative compositions.', 'NLE Choppa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wit9oj6zrr1n2kjmrpqg3odhn22i7pm21kx0l4eormch7czhzi','jg74bhwg8cs6tm9', 'https://i.scdn.co/image/ab67616d0000b27349a4f6c9a637e02252a0076d', 'NLE Choppa Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r4vusasi9ahhuqvxrrcd3o8ff43ij590cll6rm5angjkx8tqut','Slut Me Out','jg74bhwg8cs6tm9',100,'POP','5BmB3OaQyYXCqRyN8iR2Yi','https://p.scdn.co/mp3-preview/84ef49a1e71bdac04b7dfb1dea3a56d1ffc50357?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wit9oj6zrr1n2kjmrpqg3odhn22i7pm21kx0l4eormch7czhzi', 'r4vusasi9ahhuqvxrrcd3o8ff43ij590cll6rm5angjkx8tqut', '0');
-- Becky G
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('v3ot3kcdlj7jvyk', 'Becky G', '176@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd132bf0d4a9203404cd66f79','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:176@artist.com', 'v3ot3kcdlj7jvyk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('v3ot3kcdlj7jvyk', 'A sonic adventurer, always seeking new horizons in music.', 'Becky G');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tw0rpcryx4qqbinyvpieobb7yfq1uz2nj3ohpi5bs33nof9xxw','v3ot3kcdlj7jvyk', 'https://i.scdn.co/image/ab67616d0000b273c3bb167f0e78b15e5588c296', 'Becky G Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4ern9q39yzd7p0zt174qfua3wmp0u3qbpore7ba2pwxs7cbvcg','Chanel','v3ot3kcdlj7jvyk',100,'POP','5RcxRGvmYai7kpFSfxe5GY','https://p.scdn.co/mp3-preview/38dbb82dace64ea92e1dafe5989c1d1861656595?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tw0rpcryx4qqbinyvpieobb7yfq1uz2nj3ohpi5bs33nof9xxw', '4ern9q39yzd7p0zt174qfua3wmp0u3qbpore7ba2pwxs7cbvcg', '0');
-- Bizarrap
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3f9gqbtwiltunop', 'Bizarrap', '177@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:177@artist.com', '3f9gqbtwiltunop', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3f9gqbtwiltunop', 'Revolutionizing the music scene with his unique production style and collaborations.', 'Bizarrap');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2wambaejxxhi9crvuxk1lg66zgfrhogplebt657kxs9yrhl7im','3f9gqbtwiltunop', 'https://i.scdn.co/image/ab67616d0000b27315583045b2fdb7d7bab10e81', 'Bizarrap Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('inembywhegi23nb81x2xxea2vmaivuy814okfkg9xhu36y2wp2','Peso Pluma: Bzrp Music Sessions, Vol. 55','3f9gqbtwiltunop',100,'POP','5AqiaZwhmC6dIbgWrD5SzV','https://p.scdn.co/mp3-preview/9d61998a29c2e8b52a7d46885352f5507eb219e2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2wambaejxxhi9crvuxk1lg66zgfrhogplebt657kxs9yrhl7im', 'inembywhegi23nb81x2xxea2vmaivuy814okfkg9xhu36y2wp2', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7y0h1u7tooagov8dm6xlybxwzv1npy1o8fm5zmr4w8mryutbau','Quevedo: Bzrp Music Sessions, Vol. 52','3f9gqbtwiltunop',100,'POP','2tTmW7RDtMQtBk7m2rYeSw','https://p.scdn.co/mp3-preview/e9c0ed735e611f6af45bc946bd4c31590df09ed6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2wambaejxxhi9crvuxk1lg66zgfrhogplebt657kxs9yrhl7im', '7y0h1u7tooagov8dm6xlybxwzv1npy1o8fm5zmr4w8mryutbau', '1');
-- Lord Huron
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u7ng4qzsd0rakxu', 'Lord Huron', '178@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1d4e4e7e3c5d8fa494fc5f10','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:178@artist.com', 'u7ng4qzsd0rakxu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u7ng4qzsd0rakxu', 'Harnessing the power of melody to tell compelling stories.', 'Lord Huron');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bdndetocrwbivxnu38wq3fgfqas9kws07jieoo4yaxnmrj3q4w','u7ng4qzsd0rakxu', 'https://i.scdn.co/image/ab67616d0000b2739d2efe43d5b7ebc7cb60ca81', 'Lord Huron Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('51wahwtyxg74sdcic1rdhwvezlb5kwl5o0z6c1lk0ho6o933mi','The Night We Met','u7ng4qzsd0rakxu',100,'POP','0QZ5yyl6B6utIWkxeBDxQN','https://p.scdn.co/mp3-preview/f10f271b165ee07e3d49d9f961d08b7ad74ebd5b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdndetocrwbivxnu38wq3fgfqas9kws07jieoo4yaxnmrj3q4w', '51wahwtyxg74sdcic1rdhwvezlb5kwl5o0z6c1lk0ho6o933mi', '0');
-- Lana Del Rey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4pucdfpilcdtkp2', 'Lana Del Rey', '179@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb99cacf8acd5378206767261','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:179@artist.com', '4pucdfpilcdtkp2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4pucdfpilcdtkp2', 'An ethereal presence in music, known for her cinematic and nostalgic sound.', 'Lana Del Rey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2kf4ufc8cib9ylcnc9j0wzhj8hkw3euofotq517gharxlenw1t','4pucdfpilcdtkp2', 'https://i.scdn.co/image/ab67616d0000b273aa27708d07f49c82ff0d0dae', 'Lana Del Rey Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wy7ij3b9t0toz9rjponkrdes55wex6cp6ns077cdmm2epeeb3a','Say Yes To Heaven','4pucdfpilcdtkp2',100,'POP','6GGtHZgBycCgGBUhZo81xe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2kf4ufc8cib9ylcnc9j0wzhj8hkw3euofotq517gharxlenw1t', 'wy7ij3b9t0toz9rjponkrdes55wex6cp6ns077cdmm2epeeb3a', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mrgo2ztebnhge1c7ggqoatoffm80au19zlsa259rzork6zcf2t','Summertime Sadness','4pucdfpilcdtkp2',100,'POP','1Ist6PR2BZR3n2z2Y5R6S1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2kf4ufc8cib9ylcnc9j0wzhj8hkw3euofotq517gharxlenw1t', 'mrgo2ztebnhge1c7ggqoatoffm80au19zlsa259rzork6zcf2t', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zzio0pu9ef0pr2mx8fefg6d7pl3qdrcg9u7leyyy54fvttwxyl','Radio','4pucdfpilcdtkp2',100,'POP','3QhfFRPkhPCR1RMJWV1gde',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2kf4ufc8cib9ylcnc9j0wzhj8hkw3euofotq517gharxlenw1t', 'zzio0pu9ef0pr2mx8fefg6d7pl3qdrcg9u7leyyy54fvttwxyl', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('apylgy8q53btvq1gfervyfoikbxvmcw8d30omdgwl91tyv322a','Snow On The Beach (feat. More Lana Del Rey)','4pucdfpilcdtkp2',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2kf4ufc8cib9ylcnc9j0wzhj8hkw3euofotq517gharxlenw1t', 'apylgy8q53btvq1gfervyfoikbxvmcw8d30omdgwl91tyv322a', '3');
-- Oscar Maydon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rpy2uialnrbp2km', 'Oscar Maydon', '180@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8920adf64930d6f26e34b7c4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:180@artist.com', 'rpy2uialnrbp2km', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rpy2uialnrbp2km', 'A beacon of innovation in the world of sound.', 'Oscar Maydon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gek33y21cith32yiv5svo0hvdbr1z1ipnlqk6difofo9g1d979','rpy2uialnrbp2km', 'https://i.scdn.co/image/ab67616d0000b2739b7e1ea3815a172019bc5e56', 'Oscar Maydon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dgojcrxxvitxodp869sbsgyulstkf0fkous8b6ovf93716ql5i','Fin de Semana','rpy2uialnrbp2km',100,'POP','6TBzRwnX2oYd8aOrOuyK1p','https://p.scdn.co/mp3-preview/71ee8bdc0a34790ad549ba750665808f08f5e46b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gek33y21cith32yiv5svo0hvdbr1z1ipnlqk6difofo9g1d979', 'dgojcrxxvitxodp869sbsgyulstkf0fkous8b6ovf93716ql5i', '0');
-- d4vd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8yqbegawoiq9bzt', 'd4vd', '181@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad447187a35f422307e88ad3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:181@artist.com', '8yqbegawoiq9bzt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8yqbegawoiq9bzt', 'Crafting soundscapes that transport listeners to another world.', 'd4vd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fbisggwt9yj4ulbjwbyfqc6zdovxjoy2ltji8kmjsh8r3jin6m','8yqbegawoiq9bzt', 'https://i.scdn.co/image/ab67616d0000b27364fa1bda999f4fbd2b7c4bb7', 'd4vd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v2wbbj54ifmmhze0msh3yt6bsgf57p8705psplcm18888x6zsd','Here With Me','8yqbegawoiq9bzt',100,'POP','5LrN7yUQAzvthd4QujgPFr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fbisggwt9yj4ulbjwbyfqc6zdovxjoy2ltji8kmjsh8r3jin6m', 'v2wbbj54ifmmhze0msh3yt6bsgf57p8705psplcm18888x6zsd', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kpg9vggfh7kb5l7k3fq97rrfi0bcda1s92axparsrqqyg9nluq','Romantic Homicide','8yqbegawoiq9bzt',100,'POP','1xK59OXxi2TAAAbmZK0kBL',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fbisggwt9yj4ulbjwbyfqc6zdovxjoy2ltji8kmjsh8r3jin6m', 'kpg9vggfh7kb5l7k3fq97rrfi0bcda1s92axparsrqqyg9nluq', '1');
-- Ruth B.
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dmr1tikkuidcily', 'Ruth B.', '182@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1da7ba1c178ab9f68d065197','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:182@artist.com', 'dmr1tikkuidcily', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dmr1tikkuidcily', 'An endless quest for musical perfection.', 'Ruth B.');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qb9wn74qhpvlwj8d2rlnqbtaf7rk6ob5krqhlh58q0a4ttiphk','dmr1tikkuidcily', 'https://i.scdn.co/image/ab67616d0000b27397e971f3e53475091dc8d707', 'Ruth B. Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e5tbmvyrf26ztxwdtnnz734fmbzi8xfpenxp1oxhdv9ttrplyj','Dandelions','dmr1tikkuidcily',100,'POP','2eAvDnpXP5W0cVtiI0PUxV','https://p.scdn.co/mp3-preview/3e55602bc286bc1fad9347931327e649ff9adfa1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qb9wn74qhpvlwj8d2rlnqbtaf7rk6ob5krqhlh58q0a4ttiphk', 'e5tbmvyrf26ztxwdtnnz734fmbzi8xfpenxp1oxhdv9ttrplyj', '0');
-- BTS
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('359o6pstokoq47k', 'BTS', '183@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd642648235ebf3460d2d1f6a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:183@artist.com', '359o6pstokoq47k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('359o6pstokoq47k', 'A global phenomenon, setting new standards in K-pop with their music and performances.', 'BTS');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8sd66rp8a34o97nrzk0f5ws3waz54i10eyco4xrwm9iwzy3t4u','359o6pstokoq47k', 'https://i.scdn.co/image/ab67616d0000b2738a701e76e8845928f6cd81c8', 'BTS Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fbz754hq5ipz95ds7wpqp8ljvef8ydyuehjcn4n7k9k7muiznv','Take Two','359o6pstokoq47k',100,'POP','5IAESfJjmOYu7cHyX557kz','https://p.scdn.co/mp3-preview/ef43da30a06fcad16898e9fff1cadd0ccf953fc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8sd66rp8a34o97nrzk0f5ws3waz54i10eyco4xrwm9iwzy3t4u', 'fbz754hq5ipz95ds7wpqp8ljvef8ydyuehjcn4n7k9k7muiznv', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i0iz9fu0e7y5mr0a0b716v470f19jq71v92ke83fk6n32lysn0','Dreamers [Music from the FIFA World Cup Qatar 2022 Official Soundtrack]','359o6pstokoq47k',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8sd66rp8a34o97nrzk0f5ws3waz54i10eyco4xrwm9iwzy3t4u', 'i0iz9fu0e7y5mr0a0b716v470f19jq71v92ke83fk6n32lysn0', '1');
-- NF
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2ty4f121ldzakq8', 'NF', '184@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1cf142a710a2f3d9b7a62da1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:184@artist.com', '2ty4f121ldzakq8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2ty4f121ldzakq8', 'A symphony of emotions expressed through sound.', 'NF');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ambzupw5wus6yae0tno8u66js6s9ufzg2bq9lcav9hxiq8f3yd','2ty4f121ldzakq8', 'https://i.scdn.co/image/ab67616d0000b273ff8a4276b3be31c839557439', 'NF Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('76glh79bs7ek5y5whoa6gdi11isr5wuuhrndnx2r38x0ozcotm','HAPPY','2ty4f121ldzakq8',100,'POP','3ZEno9fORwMA1HPecdLi0R',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ambzupw5wus6yae0tno8u66js6s9ufzg2bq9lcav9hxiq8f3yd', '76glh79bs7ek5y5whoa6gdi11isr5wuuhrndnx2r38x0ozcotm', '0');
-- Mariah Carey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hvb9mf1l5rk0np6', 'Mariah Carey', '185@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21b66418f7f3b86967f85bce','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:185@artist.com', 'hvb9mf1l5rk0np6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hvb9mf1l5rk0np6', 'Breathing new life into classic genres.', 'Mariah Carey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lk2xnk10fqkhygtir5p9za873mrman8148qf3d1pxes1jh0gmi','hvb9mf1l5rk0np6', 'https://i.scdn.co/image/ab67616d0000b2734246e3158421f5abb75abc4f', 'Mariah Carey Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('udshapslhw2qzz4zad7ykbfckitjkwq36fxzlnjvojqrjit9iz','All I Want for Christmas Is You','hvb9mf1l5rk0np6',100,'POP','0bYg9bo50gSsH3LtXe2SQn','https://p.scdn.co/mp3-preview/6b1557cd25d543940a3decd85a7bf2bc136c51f8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lk2xnk10fqkhygtir5p9za873mrman8148qf3d1pxes1jh0gmi', 'udshapslhw2qzz4zad7ykbfckitjkwq36fxzlnjvojqrjit9iz', '0');
-- Sog
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3lfbo3dx88iyzrs', 'Sog', '186@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:186@artist.com', '3lfbo3dx88iyzrs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3lfbo3dx88iyzrs', 'Blending genres for a fresh musical experience.', 'Sog');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mnk4swq1jmzorc53bzvmftmlch0yce1x7i1ait5120j8tnn7z6','3lfbo3dx88iyzrs', NULL, 'Sog Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('59n50oz18plx9etmzz9q9jk91m18hyx2zevnlssqtxpfptairp','QUEMA','3lfbo3dx88iyzrs',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mnk4swq1jmzorc53bzvmftmlch0yce1x7i1ait5120j8tnn7z6', '59n50oz18plx9etmzz9q9jk91m18hyx2zevnlssqtxpfptairp', '0');
-- Conan Gray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gyeut82tp43vibt', 'Conan Gray', '187@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc1c8fa15e08cb31eeb03b771','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:187@artist.com', 'gyeut82tp43vibt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gyeut82tp43vibt', 'A journey through the spectrum of sound in every album.', 'Conan Gray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o6bv4v1u28wp2sm3l4vvhwdbzkh5hv5cyo7ax5dphfv55cdtab','gyeut82tp43vibt', 'https://i.scdn.co/image/ab67616d0000b27388e3cda6d29b2552d4d6bc43', 'Conan Gray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('99l8ez3tp9zznuhcv800zqv1tgfcbdh7bikygu90l0cfdp65p2','Heather','gyeut82tp43vibt',100,'POP','4xqrdfXkTW4T0RauPLv3WA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o6bv4v1u28wp2sm3l4vvhwdbzkh5hv5cyo7ax5dphfv55cdtab', '99l8ez3tp9zznuhcv800zqv1tgfcbdh7bikygu90l0cfdp65p2', '0');
-- Offset
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8koigf6wua3y63i', 'Offset', '188@artist.com', 'https://i.scdn.co/image/ab67616d0000b2736edd8e309824c6f3fd3f3466','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:188@artist.com', '8koigf6wua3y63i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8koigf6wua3y63i', 'A sonic adventurer, always seeking new horizons in music.', 'Offset');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8247ymv0e6pcfif9q0m8lb0vksf85jdt4qnfjyzvchmqkqo8oc','8koigf6wua3y63i', 'https://i.scdn.co/image/ab67616d0000b2736ed9aef791159496b286179f', 'Offset Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c1sjyyntsiinozslcriozbwdqnwavky2iy7mjlel0npa4ifnmo','Danger (Spider) (Offset & JID)','8koigf6wua3y63i',100,'POP','3X6qK1LdMkSOhklwRa2ZfG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8247ymv0e6pcfif9q0m8lb0vksf85jdt4qnfjyzvchmqkqo8oc', 'c1sjyyntsiinozslcriozbwdqnwavky2iy7mjlel0npa4ifnmo', '0');
-- Linkin Park
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('opc9pi0dve3tolr', 'Linkin Park', '189@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb811da3b2e7c9e5a9c1a6c4f7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:189@artist.com', 'opc9pi0dve3tolr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('opc9pi0dve3tolr', 'Transcending language barriers through the universal language of music.', 'Linkin Park');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('leldod65py6i1rrsyi5a1bejawesvx24v07xbv2y43q2fni37s','opc9pi0dve3tolr', 'https://i.scdn.co/image/ab67616d0000b273b4ad7ebaf4575f120eb3f193', 'Linkin Park Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0q9j0doqapawe5ta906bg6ehy4zlh1bn19ew0bzguvj1mljmnt','Numb','opc9pi0dve3tolr',100,'POP','2nLtzopw4rPReszdYBJU6h','https://p.scdn.co/mp3-preview/15e1178c9eb7f626ac1112ad8f56eccbec2cd6e5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('leldod65py6i1rrsyi5a1bejawesvx24v07xbv2y43q2fni37s', '0q9j0doqapawe5ta906bg6ehy4zlh1bn19ew0bzguvj1mljmnt', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yutflec8rvcp2xzyubqp6t52q9v1gj7bev9q4y2jbhld6cpaow','In The End','opc9pi0dve3tolr',100,'POP','60a0Rd6pjrkxjPbaKzXjfq','https://p.scdn.co/mp3-preview/b5ee275ca337899f762b1c1883c11e24a04075b0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('leldod65py6i1rrsyi5a1bejawesvx24v07xbv2y43q2fni37s', 'yutflec8rvcp2xzyubqp6t52q9v1gj7bev9q4y2jbhld6cpaow', '1');
-- Duki
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9gfxct9je85ts4s', 'Duki', '190@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4293b81686e67e3041aec80c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:190@artist.com', '9gfxct9je85ts4s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9gfxct9je85ts4s', 'The heartbeat of a new generation of music lovers.', 'Duki');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('34xxrv92cirihs0zsmtx0opmg57gzsht12kymajtshpd4kk29x','9gfxct9je85ts4s', NULL, 'Duki Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ssrcqrv27np7vn05799bm086ovnnb4n2yz6tkvbnrpcivnhqnb','Marisola - Remix','9gfxct9je85ts4s',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('34xxrv92cirihs0zsmtx0opmg57gzsht12kymajtshpd4kk29x', 'ssrcqrv27np7vn05799bm086ovnnb4n2yz6tkvbnrpcivnhqnb', '0');
-- Israel & Rodolffo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7wzwjvmxvaircbs', 'Israel & Rodolffo', '191@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb697f5ad0867793de624bbb5f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:191@artist.com', '7wzwjvmxvaircbs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7wzwjvmxvaircbs', 'An alchemist of harmonies, transforming notes into gold.', 'Israel & Rodolffo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pqwjqum5kgwi8fqei2y0xgm0cfkn0h3163vevznk3fssxmjw3c','7wzwjvmxvaircbs', 'https://i.scdn.co/image/ab67616d0000b2736ccbcc3358d31dcba6e7c035', 'Israel & Rodolffo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ctt58pqt6fivf8dg6ywr0k5xwqmlfnrsxe7rubzuaa1uwhccui','Seu Brilho Sumiu - Ao Vivo','7wzwjvmxvaircbs',100,'POP','3PH1nUysW7ybo3Yu8sqlPN','https://p.scdn.co/mp3-preview/125d70024c88bb1bf45666f6396dc21a181c416e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pqwjqum5kgwi8fqei2y0xgm0cfkn0h3163vevznk3fssxmjw3c', 'ctt58pqt6fivf8dg6ywr0k5xwqmlfnrsxe7rubzuaa1uwhccui', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('syp03zc3itogv3huhe1i5mx24qqs3yfjdxygs6df38bkx530su','Bombonzinho - Ao Vivo','7wzwjvmxvaircbs',100,'POP','0SCMVUZ21uYYB8cc0ScfbV','https://p.scdn.co/mp3-preview/b7d7cfb08d5384a52deb562a3e496881c978a9f1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pqwjqum5kgwi8fqei2y0xgm0cfkn0h3163vevznk3fssxmjw3c', 'syp03zc3itogv3huhe1i5mx24qqs3yfjdxygs6df38bkx530su', '1');
-- RM
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tj79ppod64i5982', 'RM', '192@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3b8f6208d84e28f63841e43c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:192@artist.com', 'tj79ppod64i5982', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tj79ppod64i5982', 'Music is my canvas, and notes are my paint.', 'RM');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i8srv7wlb3hus7fdqetx06cwigqss4tbmo1vlblwhpq5yoww7p','tj79ppod64i5982', NULL, 'RM Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4n5r6gt7af6hbuf61d5kouty5bmuh4xjv9g76zaep071wpqqfg','Dont ever say love me (feat. RM of BTS)','tj79ppod64i5982',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i8srv7wlb3hus7fdqetx06cwigqss4tbmo1vlblwhpq5yoww7p', '4n5r6gt7af6hbuf61d5kouty5bmuh4xjv9g76zaep071wpqqfg', '0');
-- Coldplay
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5dhkw9oksbwadl9', 'Coldplay', '193@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb989ed05e1f0570cc4726c2d3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:193@artist.com', '5dhkw9oksbwadl9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5dhkw9oksbwadl9', 'Global icons in rock, known for their anthemic songs and impactful lyrics.', 'Coldplay');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lvecje0xv5ndhaysg5rbckli06k5ejtmj3y9knnuj9g0k7ywo8','5dhkw9oksbwadl9', 'https://i.scdn.co/image/ab67616d0000b273e21cc1db05580b6f2d2a3b6e', 'Coldplay Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f38pb4ves1wv0zi2rrei8sh3pwueeg8n0xm3kc05jl5888n2go','Viva La Vida','5dhkw9oksbwadl9',100,'POP','1mea3bSkSGXuIRvnydlB5b','https://p.scdn.co/mp3-preview/fb9f4a9b0887326776b4fb7c6d331acd167a7778?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lvecje0xv5ndhaysg5rbckli06k5ejtmj3y9knnuj9g0k7ywo8', 'f38pb4ves1wv0zi2rrei8sh3pwueeg8n0xm3kc05jl5888n2go', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('77sf3zsrhd61hfsbiw4uazwrnwahukn6r5b4gg4c5vk0amkwi3','My Universe','5dhkw9oksbwadl9',100,'POP','3FeVmId7tL5YN8B7R3imoM','https://p.scdn.co/mp3-preview/e6b780d0df7927114477a786b6a638cf40d19579?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lvecje0xv5ndhaysg5rbckli06k5ejtmj3y9knnuj9g0k7ywo8', '77sf3zsrhd61hfsbiw4uazwrnwahukn6r5b4gg4c5vk0amkwi3', '1');
-- JVKE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x1cv61o07du7ggh', 'JVKE', '194@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebce33386a81a202e149934ec1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:194@artist.com', 'x1cv61o07du7ggh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x1cv61o07du7ggh', 'A rising star, blending heartfelt lyrics with catchy pop melodies.', 'JVKE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7e16rg6x4w7559ns6gnc4rlkvtvgamqqlu4a74qgnrlsggi4ky','x1cv61o07du7ggh', 'https://i.scdn.co/image/ab67616d0000b273c2504e80ba2f258697ab2954', 'JVKE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d7u75kgmqbcm3laozoamkizl8t3jxmmrrkwd8f1sry4m2u5atx','golden hour','x1cv61o07du7ggh',100,'POP','5odlY52u43F5BjByhxg7wg','https://p.scdn.co/mp3-preview/bcc17f30841d6fbf3cd7954c3e3cf669f11b6a21?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7e16rg6x4w7559ns6gnc4rlkvtvgamqqlu4a74qgnrlsggi4ky', 'd7u75kgmqbcm3laozoamkizl8t3jxmmrrkwd8f1sry4m2u5atx', '0');
-- PinkPantheress
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xnowas3ow0tat99', 'PinkPantheress', '195@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03578c92e15089c645b794f5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:195@artist.com', 'xnowas3ow0tat99', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xnowas3ow0tat99', 'Redefining pop music with her distinct sound and style.', 'PinkPantheress');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uj1zw34j89tpeuw1quij3dvwddrc6ab5vxe5in7mipwa045wq8','xnowas3ow0tat99', 'https://i.scdn.co/image/ab67616d0000b2739567e1aa41657425d046733b', 'PinkPantheress Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ayf31oxbecg5mjorp3e98yrmda5avhcodjyq67xx92m23ox4xn','Boys a liar Pt. 2','xnowas3ow0tat99',100,'POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uj1zw34j89tpeuw1quij3dvwddrc6ab5vxe5in7mipwa045wq8', 'ayf31oxbecg5mjorp3e98yrmda5avhcodjyq67xx92m23ox4xn', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4i6akyxftbhz7jqppvh1va0zmnjqcrzu4psxcmetpz6qicukwt','Boys a liar','xnowas3ow0tat99',100,'POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uj1zw34j89tpeuw1quij3dvwddrc6ab5vxe5in7mipwa045wq8', '4i6akyxftbhz7jqppvh1va0zmnjqcrzu4psxcmetpz6qicukwt', '1');
-- Vishal-Shekhar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('svgs5cd9651gekk', 'Vishal-Shekhar', '196@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb90b6c3d093f9b02aad628eaf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:196@artist.com', 'svgs5cd9651gekk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('svgs5cd9651gekk', 'Crafting a unique sonic identity in every track.', 'Vishal-Shekhar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rrfl9bgqgr6vjeq4koznlpgd8m9fmh9cs47ri9k9gsiw78ge70','svgs5cd9651gekk', NULL, 'Vishal-Shekhar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8k7ew27s60ka1ky7mxneqef5wh1leg8xesath66zmq0gufbcms','Besharam Rang (From "Pathaan")','svgs5cd9651gekk',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rrfl9bgqgr6vjeq4koznlpgd8m9fmh9cs47ri9k9gsiw78ge70', '8k7ew27s60ka1ky7mxneqef5wh1leg8xesath66zmq0gufbcms', '0');
-- Brray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kku0wzpckwbz9kv', 'Brray', '197@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2c7fe2c8895d2cd41e25aed6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:197@artist.com', 'kku0wzpckwbz9kv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kku0wzpckwbz9kv', 'Breathing new life into classic genres.', 'Brray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('io4glfxs8msha14jsel03pnpyng7q6jkvehmnypfu4xr126mk7','kku0wzpckwbz9kv', NULL, 'Brray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pgmp2k1mr3ekjr13w2sbanzdgv4phxii963ds53s4is8fxr887','LOKERA','kku0wzpckwbz9kv',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('io4glfxs8msha14jsel03pnpyng7q6jkvehmnypfu4xr126mk7', 'pgmp2k1mr3ekjr13w2sbanzdgv4phxii963ds53s4is8fxr887', '0');
-- Stephen Sanchez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xkppmdwoxdlb24u', 'Stephen Sanchez', '198@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1e97fce6fa6fc4ebc3ebda25','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:198@artist.com', 'xkppmdwoxdlb24u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xkppmdwoxdlb24u', 'Breathing new life into classic genres.', 'Stephen Sanchez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4ux5ezul4cj3u73v4l0ghfc3rlr4s4lz7o7qgq2t0qh9y0vh82','xkppmdwoxdlb24u', 'https://i.scdn.co/image/ab67616d0000b2732bf0876d42b90a8852ad6244', 'Stephen Sanchez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1hsxxiv60t0s1rikmhryfvbzqrj19csi7obiq9j696se60mhto','Until I Found You','xkppmdwoxdlb24u',100,'POP','1Y3LN4zO1Edc2EluIoSPJN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4ux5ezul4cj3u73v4l0ghfc3rlr4s4lz7o7qgq2t0qh9y0vh82', '1hsxxiv60t0s1rikmhryfvbzqrj19csi7obiq9j696se60mhto', '0');
-- Baby Rasta
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('w41046xe94kz8i3', 'Baby Rasta', '199@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb18f9c5cb23e65bd55af69f24','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:199@artist.com', 'w41046xe94kz8i3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('w41046xe94kz8i3', 'A confluence of cultural beats and contemporary tunes.', 'Baby Rasta');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9yf5h8nq462634koa7tvcqditywp1axpjli627csk3cqgcu59j','w41046xe94kz8i3', NULL, 'Baby Rasta Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j816t5r0roo4rkigkdl3nz4sm32wx98ui52bpotvgjqky9b4qj','PUNTO 40','w41046xe94kz8i3',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9yf5h8nq462634koa7tvcqditywp1axpjli627csk3cqgcu59j', 'j816t5r0roo4rkigkdl3nz4sm32wx98ui52bpotvgjqky9b4qj', '0');
-- Coolio
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qsmanxf0ghckouk', 'Coolio', '200@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5ea53fc78df8f7e7559e228d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:200@artist.com', 'qsmanxf0ghckouk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qsmanxf0ghckouk', 'A maestro of melodies, orchestrating auditory bliss.', 'Coolio');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kfdsp2g4jubn9ftnwvekh0k2qfp1xgj1k52dynf3ujce1bnjp2','qsmanxf0ghckouk', 'https://i.scdn.co/image/ab67616d0000b273c31d3c870a3dbaf7b53186cc', 'Coolio Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m5a5pnmc24wdblfb7mf22sossxvnn5yxo87egn1e09t4ur2beb','Gangstas Paradise','qsmanxf0ghckouk',100,'POP','1DIXPcTDzTj8ZMHt3PDt8p','https://p.scdn.co/mp3-preview/1454c63a66c27ac745f874d6c113270a9c62d28e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kfdsp2g4jubn9ftnwvekh0k2qfp1xgj1k52dynf3ujce1bnjp2', 'm5a5pnmc24wdblfb7mf22sossxvnn5yxo87egn1e09t4ur2beb', '0');
-- A$AP Rocky
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rcoxfwwkxt7b31h', 'A$AP Rocky', '201@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:201@artist.com', 'rcoxfwwkxt7b31h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rcoxfwwkxt7b31h', 'Igniting the stage with electrifying performances.', 'A$AP Rocky');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lmrgkd0tvd19w5n03uj9adrno7fzd2iucv9x8cul2xmsha7l53','rcoxfwwkxt7b31h', NULL, 'A$AP Rocky Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ea40widyqfr9n0hld2kof7ddpw4yj1dy5lrjm2hfsqwqbk2itg','Am I Dreaming (Metro Boomin & A$AP Rocky, Roisee)','rcoxfwwkxt7b31h',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lmrgkd0tvd19w5n03uj9adrno7fzd2iucv9x8cul2xmsha7l53', 'ea40widyqfr9n0hld2kof7ddpw4yj1dy5lrjm2hfsqwqbk2itg', '0');
-- Mac DeMarco
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rbnwzt1q2vsw9d0', 'Mac DeMarco', '202@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3cef7752073cbbd2cc04c6f0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:202@artist.com', 'rbnwzt1q2vsw9d0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rbnwzt1q2vsw9d0', 'Blending traditional rhythms with modern beats.', 'Mac DeMarco');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cv59o7ijuniicrjyc4sbqvi5a6ifbi0wppljzxoz8hjfyxcqp1','rbnwzt1q2vsw9d0', 'https://i.scdn.co/image/ab67616d0000b273fa1323bb50728c7489980672', 'Mac DeMarco Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('97amvayjriwzx6567fmiosnib0tsfp278c0623g6on54bkfks1','Heart To Heart','rbnwzt1q2vsw9d0',100,'POP','7EAMXbLcL0qXmciM5SwMh2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cv59o7ijuniicrjyc4sbqvi5a6ifbi0wppljzxoz8hjfyxcqp1', '97amvayjriwzx6567fmiosnib0tsfp278c0623g6on54bkfks1', '0');
-- Charlie Puth
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nt20kon4mj56gsg', 'Charlie Puth', '203@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb63de91415970a2f5bc920fa8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:203@artist.com', 'nt20kon4mj56gsg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nt20kon4mj56gsg', 'A pop maestro, combining catchy melodies with his exceptional musical talent.', 'Charlie Puth');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('03x5inr9wsyxd1wpj23g7dgb8fce98ribmw0hhehybhoyrm0nz','nt20kon4mj56gsg', 'https://i.scdn.co/image/ab67616d0000b27335d2e0ed94a934f2cc46fa49', 'Charlie Puth Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jc61bmm3bp1yvv75i5i4z501qv59olbjcjppiavgahnegn06mo','Left and Right (Feat. Jung Kook of BTS)','nt20kon4mj56gsg',100,'POP','5Odq8ohlgIbQKMZivbWkEo','https://p.scdn.co/mp3-preview/9e4342eefa4f33df4e9b199e60dbce0f59e46eff?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('03x5inr9wsyxd1wpj23g7dgb8fce98ribmw0hhehybhoyrm0nz', 'jc61bmm3bp1yvv75i5i4z501qv59olbjcjppiavgahnegn06mo', '0');
-- MC Caverinha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kexdpm7754xyx34', 'MC Caverinha', '204@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb48d62acd2e6408096141a088','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:204@artist.com', 'kexdpm7754xyx34', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kexdpm7754xyx34', 'An odyssey of sound that defies conventions.', 'MC Caverinha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x6iwg9ozkoamd7suhw8r0n9c6x7g6pqg3809y5egn23s4tq4hq','kexdpm7754xyx34', NULL, 'MC Caverinha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e3cg7k3bxczi0l0f217sqq8u3zbf45cmb3sjt6hzg1q38fuz3f','Carto B','kexdpm7754xyx34',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x6iwg9ozkoamd7suhw8r0n9c6x7g6pqg3809y5egn23s4tq4hq', 'e3cg7k3bxczi0l0f217sqq8u3zbf45cmb3sjt6hzg1q38fuz3f', '0');
-- Eminem
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('shxqxkn3v8zqsix', 'Eminem', '205@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba00b11c129b27a88fc72f36b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:205@artist.com', 'shxqxkn3v8zqsix', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('shxqxkn3v8zqsix', 'Pushing the boundaries of sound with each note.', 'Eminem');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('r0v592i14vm6gwm0nwx2rabwgtpgqh61fdpprzxiaowvpaysbr','shxqxkn3v8zqsix', 'https://i.scdn.co/image/ab67616d0000b273726d48d93d02e1271774f023', 'Eminem Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j02xwqyxndftfxmklp2yp486rdyorpkz8eyp9o2kok1zwx6qih','Mockingbird','shxqxkn3v8zqsix',100,'POP','561jH07mF1jHuk7KlaeF0s',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r0v592i14vm6gwm0nwx2rabwgtpgqh61fdpprzxiaowvpaysbr', 'j02xwqyxndftfxmklp2yp486rdyorpkz8eyp9o2kok1zwx6qih', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e59hw4e78qw9gbh8yafza8n0dt1i16ksx4skiucmp3mqnyl8zj','Without Me','shxqxkn3v8zqsix',100,'POP','7lQ8MOhq6IN2w8EYcFNSUk',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r0v592i14vm6gwm0nwx2rabwgtpgqh61fdpprzxiaowvpaysbr', 'e59hw4e78qw9gbh8yafza8n0dt1i16ksx4skiucmp3mqnyl8zj', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hm6tv5rjdloky3ke7zb8nmzky7d9i6fa83b3m42eb2vgywbcg0','The Real Slim Shady','shxqxkn3v8zqsix',100,'POP','3yfqSUWxFvZELEM4PmlwIR',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r0v592i14vm6gwm0nwx2rabwgtpgqh61fdpprzxiaowvpaysbr', 'hm6tv5rjdloky3ke7zb8nmzky7d9i6fa83b3m42eb2vgywbcg0', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jw4pr622qd3lmx1oraddjfb9d3ftpe3cg8fxz341w1xag6pp18','Lose Yourself - Soundtrack Version','shxqxkn3v8zqsix',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r0v592i14vm6gwm0nwx2rabwgtpgqh61fdpprzxiaowvpaysbr', 'jw4pr622qd3lmx1oraddjfb9d3ftpe3cg8fxz341w1xag6pp18', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dlbe109s07ch31mv0z6c85d3070ywqmwimce906iuag75o6f8g','Superman','shxqxkn3v8zqsix',100,'POP','4woTEX1wYOTGDqNXuavlRC',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r0v592i14vm6gwm0nwx2rabwgtpgqh61fdpprzxiaowvpaysbr', 'dlbe109s07ch31mv0z6c85d3070ywqmwimce906iuag75o6f8g', '4');
-- Seafret
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sk888l442p1un6r', 'Seafret', '206@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7f753324eacfbe0db36d64e5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:206@artist.com', 'sk888l442p1un6r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sk888l442p1un6r', 'A symphony of emotions expressed through sound.', 'Seafret');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('42bddjx980205jqqsamkox3wtd64zvdqsmfymi66kdkbwcaw7i','sk888l442p1un6r', 'https://i.scdn.co/image/ab67616d0000b2738c33272a7c77042f5eb39d75', 'Seafret Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bejvpntd4o097qzi5paukidqsi4fi0dh8dp6vbd22vntyuxorg','Atlantis','sk888l442p1un6r',100,'POP','1Fid2jjqsHViMX6xNH70hE','https://p.scdn.co/mp3-preview/2097364ff6c9f41d658ea1b00a5e2153dc61144b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('42bddjx980205jqqsamkox3wtd64zvdqsmfymi66kdkbwcaw7i', 'bejvpntd4o097qzi5paukidqsi4fi0dh8dp6vbd22vntyuxorg', '0');
-- Steve Lacy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tbudf68hdjcfzke', 'Steve Lacy', '207@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb09ac9d040c168d4e4f58eb42','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:207@artist.com', 'tbudf68hdjcfzke', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tbudf68hdjcfzke', 'A confluence of cultural beats and contemporary tunes.', 'Steve Lacy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ysc5z6o5rbjtoolg8g3qy5ead9hy89xit9weaue6wyzb64x7u9','tbudf68hdjcfzke', 'https://i.scdn.co/image/ab67616d0000b27368968350c2550e36d96344ee', 'Steve Lacy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z1goowchy9k8u5hatdk7w9haycpwppogrkc7b1q3u228bbtdas','Bad Habit','tbudf68hdjcfzke',100,'POP','4k6Uh1HXdhtusDW5y8Gbvy','https://p.scdn.co/mp3-preview/efe7c2fdd8fa727a108a1270b114ebedabfd766c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ysc5z6o5rbjtoolg8g3qy5ead9hy89xit9weaue6wyzb64x7u9', 'z1goowchy9k8u5hatdk7w9haycpwppogrkc7b1q3u228bbtdas', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h2ldqzpn5q3tbvdwp6kiemyyw965rrv4tog4ux5wfuoncxxt3j','Dark Red','tbudf68hdjcfzke',100,'POP','3EaJDYHA0KnX88JvDhL9oa','https://p.scdn.co/mp3-preview/90b3855fd50a4c4878a2d5117ebe73f658a97285?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ysc5z6o5rbjtoolg8g3qy5ead9hy89xit9weaue6wyzb64x7u9', 'h2ldqzpn5q3tbvdwp6kiemyyw965rrv4tog4ux5wfuoncxxt3j', '1');
-- Yuridia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gy0s3x7ihzeg05x', 'Yuridia', '208@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb238b537cb702308e59f709bf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:208@artist.com', 'gy0s3x7ihzeg05x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gy0s3x7ihzeg05x', 'A voice that echoes the sentiments of a generation.', 'Yuridia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3r2rdkcx0zpljynvbzee0xid8pd3iw0c9hmk5na7nlndf3a923','gy0s3x7ihzeg05x', 'https://i.scdn.co/image/ab67616d0000b2732e9425d8413217cc2942cacf', 'Yuridia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9xfejuopoczduvu22lvb0sp9s80fud5fzmtpjelsdp0v0d3djn','Qu Ago','gy0s3x7ihzeg05x',100,'POP','4H6o1bxKRGzmsE0vzo968m','https://p.scdn.co/mp3-preview/5576fde4795672bfa292bbf58adf0f9159af0be3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3r2rdkcx0zpljynvbzee0xid8pd3iw0c9hmk5na7nlndf3a923', '9xfejuopoczduvu22lvb0sp9s80fud5fzmtpjelsdp0v0d3djn', '0');
-- David Guetta
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6tgo3f1s199fkf5', 'David Guetta', '209@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:209@artist.com', '6tgo3f1s199fkf5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6tgo3f1s199fkf5', 'A legend in the electronic music world, constantly innovating and entertaining.', 'David Guetta');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('c83jbg2pa5cbncw5hjf7d1rafso2b89zui5neuc3xhcrvx72pq','6tgo3f1s199fkf5', 'https://i.scdn.co/image/ab67616d0000b2730b4ef75c3728599aa4104f7a', 'David Guetta Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bl7ym13fectxh8kq5n46gi9spv18lifrec2xsnndkr7c8zqi29','Baby Dont Hurt Me','6tgo3f1s199fkf5',100,'POP','3BKD1PwArikchz2Zrlp1qi','https://p.scdn.co/mp3-preview/a8f2e176e17e0f6298b42ef8e96118318fdd2b89?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c83jbg2pa5cbncw5hjf7d1rafso2b89zui5neuc3xhcrvx72pq', 'bl7ym13fectxh8kq5n46gi9spv18lifrec2xsnndkr7c8zqi29', '0');
-- TOMORROW X TOGETHER
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q23v18prvvez0hu', 'TOMORROW X TOGETHER', '210@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8b446e5bd3820ac772155b31','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:210@artist.com', 'q23v18prvvez0hu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q23v18prvvez0hu', 'A tapestry of rhythms that echo the pulse of life.', 'TOMORROW X TOGETHER');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yh684jq10sqy12pinqm3lt6e0uixmjhwa6ofsorhkiuaa0au9v','q23v18prvvez0hu', 'https://i.scdn.co/image/ab67616d0000b2733bb056e3160b85ee86c1194d', 'TOMORROW X TOGETHER Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dv2sbbj9zb9wj6atbm019dlhx70hnlpyxemu9dlz50q5zl2dn8','Sugar Rush Ride','q23v18prvvez0hu',100,'POP','0rhI6gvOeCKA502RdJAbfs','https://p.scdn.co/mp3-preview/691f502777012a09541b5265cfddaa4401470759?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yh684jq10sqy12pinqm3lt6e0uixmjhwa6ofsorhkiuaa0au9v', 'dv2sbbj9zb9wj6atbm019dlhx70hnlpyxemu9dlz50q5zl2dn8', '0');
-- Nicki Minaj
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sei0ax7dupeq7pt', 'Nicki Minaj', '211@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03578c92e15089c645b794f5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:211@artist.com', 'sei0ax7dupeq7pt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sei0ax7dupeq7pt', 'A rap icon known for her versatile flow and bold personality.', 'Nicki Minaj');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mfzxysw364mu9ab2t147jgpm6zavyb69v1b5mj3vw1nzkl08sd','sei0ax7dupeq7pt', 'https://i.scdn.co/image/ab67616d0000b2737e8f938c02fac3b564931116', 'Nicki Minaj Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fsgd79ktu56v1yu746pf6cpj69d813i4669cgv87uzj9kubo35','Barbie World (with Aqua) [From Barbie The Album]','sei0ax7dupeq7pt',100,'POP','741UUVE2kuITl0c6zuqqbO','https://p.scdn.co/mp3-preview/f654928ccaa4e6a9fb09a6eb3f208383eccc12a9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mfzxysw364mu9ab2t147jgpm6zavyb69v1b5mj3vw1nzkl08sd', 'fsgd79ktu56v1yu746pf6cpj69d813i4669cgv87uzj9kubo35', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('buhk7chz6slfn870mlfcpi9ygipmp5xtfi4kdrdtufvx9iwjv5','Princess Diana (with Nicki Minaj)','sei0ax7dupeq7pt',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mfzxysw364mu9ab2t147jgpm6zavyb69v1b5mj3vw1nzkl08sd', 'buhk7chz6slfn870mlfcpi9ygipmp5xtfi4kdrdtufvx9iwjv5', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('12iqqw778uju49vdbcbyi3mfm4vih67xtv9nvwxokzpm1ykgqz','Red Ruby Da Sleeze','sei0ax7dupeq7pt',100,'POP','4ZYAU4A2YBtlNdqOUtc7T2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mfzxysw364mu9ab2t147jgpm6zavyb69v1b5mj3vw1nzkl08sd', '12iqqw778uju49vdbcbyi3mfm4vih67xtv9nvwxokzpm1ykgqz', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rd7fy1e5b3p68vvcjy9yzohbpecjdsatz4sbfn6d51r8qa0vro','Super Freaky Girl','sei0ax7dupeq7pt',100,'POP','4C6Uex2ILwJi9sZXRdmqXp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mfzxysw364mu9ab2t147jgpm6zavyb69v1b5mj3vw1nzkl08sd', 'rd7fy1e5b3p68vvcjy9yzohbpecjdsatz4sbfn6d51r8qa0vro', '3');
-- TV Girl
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cnqhuc8fpkbreqs', 'TV Girl', '212@artist.com', 'https://i.scdn.co/image/ab67616d0000b27332f5fec7a879ed6ef28f0dfd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:212@artist.com', 'cnqhuc8fpkbreqs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cnqhuc8fpkbreqs', 'A journey through the spectrum of sound in every album.', 'TV Girl');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mg3xmsizqkt0j1i0zq00fv1fu5iz9228csoxvt69f67uu8v6vk','cnqhuc8fpkbreqs', 'https://i.scdn.co/image/ab67616d0000b273e1bc1af856b42dd7fdba9f84', 'TV Girl Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kr0jdclchmny7cy6u46sh5ed3mvz5utnb0e9dxw8l8atm5xqvs','Lovers Rock','cnqhuc8fpkbreqs',100,'POP','6dBUzqjtbnIa1TwYbyw5CM','https://p.scdn.co/mp3-preview/922a42db5aa8f8d335725697b7d7a12af6808f3a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mg3xmsizqkt0j1i0zq00fv1fu5iz9228csoxvt69f67uu8v6vk', 'kr0jdclchmny7cy6u46sh5ed3mvz5utnb0e9dxw8l8atm5xqvs', '0');
-- Tisto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0vdio78grh0vu5c', 'Tisto', '213@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7afd1dcf8bc34612f16ee39c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:213@artist.com', '0vdio78grh0vu5c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0vdio78grh0vu5c', 'A voice that echoes the sentiments of a generation.', 'Tisto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u1vvisjkdhoq3wa0a5q7vwdd516kp18ofeb0wcgh499cao40jh','0vdio78grh0vu5c', NULL, 'Tisto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w25yu60yqgaorhspwn7kffr5xlrs7hrvvu8xihkthfkpdnc65z','10:35','0vdio78grh0vu5c',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u1vvisjkdhoq3wa0a5q7vwdd516kp18ofeb0wcgh499cao40jh', 'w25yu60yqgaorhspwn7kffr5xlrs7hrvvu8xihkthfkpdnc65z', '0');
-- Semicenk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e60a70rr7ojusr9', 'Semicenk', '214@artist.com', 'https://i.scdn.co/image/ab67616d0000b2730b8da935d3ba07f14f01eb32','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:214@artist.com', 'e60a70rr7ojusr9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e60a70rr7ojusr9', 'Blending genres for a fresh musical experience.', 'Semicenk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6kb7qilcmv7eigzu3ims8gs7vleh8gx47lgqo4tr8sbu1hlml4','e60a70rr7ojusr9', NULL, 'Semicenk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oda2mm2sg9t5wb5anxcv2tp0522zpvw33hdekiiyq7iixi1n1v','Piman De','e60a70rr7ojusr9',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6kb7qilcmv7eigzu3ims8gs7vleh8gx47lgqo4tr8sbu1hlml4', 'oda2mm2sg9t5wb5anxcv2tp0522zpvw33hdekiiyq7iixi1n1v', '0');
-- Mahalini
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ip7u4cuo9x39plu', 'Mahalini', '215@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb8333468abeb2e461d1ab5ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:215@artist.com', 'ip7u4cuo9x39plu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ip7u4cuo9x39plu', 'A confluence of cultural beats and contemporary tunes.', 'Mahalini');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('15420u1m28r8un19ujtux9vfugm2iybt8if0vg7z810i7kta9d','ip7u4cuo9x39plu', 'https://i.scdn.co/image/ab67616d0000b2736f713eb92ebf7ca05a562542', 'Mahalini Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ntpe8h2oxpuc7ht07ntthplo4a6qhqcxiofklz3cydsti1w2a0','Sial','ip7u4cuo9x39plu',100,'POP','6O0WEM0QNEhqpU50BKui7o','https://p.scdn.co/mp3-preview/1285e7f97156037b5c1c958513ff3f8176a68a33?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('15420u1m28r8un19ujtux9vfugm2iybt8if0vg7z810i7kta9d', 'ntpe8h2oxpuc7ht07ntthplo4a6qhqcxiofklz3cydsti1w2a0', '0');
-- ENHYPEN
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2a8juev6vbbuau0', 'ENHYPEN', '216@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a48a236a01fa62db8c7a6f6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:216@artist.com', '2a8juev6vbbuau0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2a8juev6vbbuau0', 'Uniting fans around the globe with universal rhythms.', 'ENHYPEN');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9594gh4pq3x4zhjcb7btnwakkf0a90xjn4yqla902wvn2uwmdg','2a8juev6vbbuau0', 'https://i.scdn.co/image/ab67616d0000b2731d03b5e88cee6870778a4d27', 'ENHYPEN Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8eyf4e2ow9gibwm0urspnui3s71ohdgxn2p55m70ku693ldq04','Bite Me','2a8juev6vbbuau0',100,'POP','7mpdNiaQvygj2rHoxkzMfa','https://p.scdn.co/mp3-preview/ff4e3c3d8464e572759ba2169332743c2889d97e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9594gh4pq3x4zhjcb7btnwakkf0a90xjn4yqla902wvn2uwmdg', '8eyf4e2ow9gibwm0urspnui3s71ohdgxn2p55m70ku693ldq04', '0');
-- Tears For Fears
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ds2er3nky5cilki', 'Tears For Fears', '217@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb42ed2cb48c231f545a5a3dad','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:217@artist.com', 'ds2er3nky5cilki', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ds2er3nky5cilki', 'Pioneering new paths in the musical landscape.', 'Tears For Fears');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('f2djh46k6hhovf4nrhbpsspchtqg5klh6nx1wzwk5s8symtmjc','ds2er3nky5cilki', 'https://i.scdn.co/image/ab67616d0000b27322463d6939fec9e17b2a6235', 'Tears For Fears Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nmqycq32fa2c1dvjscx2jacqd1fb51in0g9q3uemb8bfi5ku1o','Everybody Wants To Rule The World','ds2er3nky5cilki',100,'POP','4RvWPyQ5RL0ao9LPZeSouE',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f2djh46k6hhovf4nrhbpsspchtqg5klh6nx1wzwk5s8symtmjc', 'nmqycq32fa2c1dvjscx2jacqd1fb51in0g9q3uemb8bfi5ku1o', '0');
-- Yandel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('be2aegz32qzg5ut', 'Yandel', '218@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7dbaf2fabcbd4b37168397fd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:218@artist.com', 'be2aegz32qzg5ut', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('be2aegz32qzg5ut', 'A powerhouse of reggaeton, blending rhythms that move the soul.', 'Yandel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('58rrqrpaj25aabczhymhc8qba4kncsvocxmjwmltusl0st2neq','be2aegz32qzg5ut', 'https://i.scdn.co/image/ab67616d0000b273b2aec01b56eeb74610532700', 'Yandel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('b2gphldjti83dx13jlozufs5hbafvk6eviyhmw4o71s5cr9koz','Yandel 150','be2aegz32qzg5ut',100,'POP','4FAKtPVycI4DxoOHC01YqD','https://p.scdn.co/mp3-preview/338ed053ce26ccc3313b00b5e6153e60ffd2eb19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('58rrqrpaj25aabczhymhc8qba4kncsvocxmjwmltusl0st2neq', 'b2gphldjti83dx13jlozufs5hbafvk6eviyhmw4o71s5cr9koz', '0');
-- IVE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6davovb43lcuyiu', 'IVE', '219@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0e46f140189de1eba9ab6230','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:219@artist.com', '6davovb43lcuyiu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6davovb43lcuyiu', 'A voice that echoes the sentiments of a generation.', 'IVE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3rthuxuqaam4bgoymwpxjm8bo6vg2nma4421ejmi3q100wr4zp','6davovb43lcuyiu', 'https://i.scdn.co/image/ab67616d0000b27325ef3cec1eceefd4db2f91c8', 'IVE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fnyth914ycvw45galfu5c7r4xmnb8tnz6xf8vt4hn4a4c0ne5n','I AM','6davovb43lcuyiu',100,'POP','70t7Q6AYG6ZgTYmJWcnkUM','https://p.scdn.co/mp3-preview/8d1fa5354093e98745ccef77ecb60fac3c9d38d0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3rthuxuqaam4bgoymwpxjm8bo6vg2nma4421ejmi3q100wr4zp', 'fnyth914ycvw45galfu5c7r4xmnb8tnz6xf8vt4hn4a4c0ne5n', '0');
-- Mr.Kitty
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('na8t23psi0ih17g', 'Mr.Kitty', '220@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb78ed447c78f07632e82ec0d8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:220@artist.com', 'na8t23psi0ih17g', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('na8t23psi0ih17g', 'Crafting a unique sonic identity in every track.', 'Mr.Kitty');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1dddigwsbk8k35mfpeg40avq31277m7kj6ezjo285981mqc3xt','na8t23psi0ih17g', 'https://i.scdn.co/image/ab67616d0000b273b492477206075438e0751176', 'Mr.Kitty Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hnllyya3rw3rus1978lnpj8dsbhawfxjqjctqawzkzc604kyw4','After Dark','na8t23psi0ih17g',100,'POP','2LKOHdMsL0K9KwcPRlJK2v','https://p.scdn.co/mp3-preview/eb9de15a4465f504ee0eadba93e7d265ee0ee6ba?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1dddigwsbk8k35mfpeg40avq31277m7kj6ezjo285981mqc3xt', 'hnllyya3rw3rus1978lnpj8dsbhawfxjqjctqawzkzc604kyw4', '0');
-- Bellakath
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('488ie37sr8ija64', 'Bellakath', '221@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb008a12ca09c3acec7c536d53','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:221@artist.com', '488ie37sr8ija64', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('488ie37sr8ija64', 'Revolutionizing the music scene with innovative compositions.', 'Bellakath');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('n1iw6wp2uocxundeur0mvk401r24tzzweegqkpc60gmwwpispx','488ie37sr8ija64', 'https://i.scdn.co/image/ab67616d0000b273584e78471da03acbc05dde0b', 'Bellakath Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6iecmn0pa2ybb4tmuvxkyp77pwugm12vf87im4cfzeu41k2b8r','Gatita','488ie37sr8ija64',100,'POP','4ilZV1WNjL7IxwE81OnaRY','https://p.scdn.co/mp3-preview/ed363508374055584f0a42a003473c065fbe4f61?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n1iw6wp2uocxundeur0mvk401r24tzzweegqkpc60gmwwpispx', '6iecmn0pa2ybb4tmuvxkyp77pwugm12vf87im4cfzeu41k2b8r', '0');
-- LE SSERAFIM
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('p3oi2y5h2pk2p03', 'LE SSERAFIM', '222@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb99752c006407988976248679','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:222@artist.com', 'p3oi2y5h2pk2p03', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('p3oi2y5h2pk2p03', 'Music is my canvas, and notes are my paint.', 'LE SSERAFIM');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dvbvu4q4tmohm8bovhlahmimj8qqng1siip3qi3wm8oyb41977','p3oi2y5h2pk2p03', 'https://i.scdn.co/image/ab67616d0000b273a991995542d50a691b9ae5be', 'LE SSERAFIM Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jgt1zxuzqlmezt3lk0bi76ivk0bbep5wxcyu26fnui6ogclsj0','ANTIFRAGILE','p3oi2y5h2pk2p03',100,'POP','4fsQ0K37TOXa3hEQfjEic1','https://p.scdn.co/mp3-preview/97a1c7e470172e0993f8f65dc109ab9d017d7adc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dvbvu4q4tmohm8bovhlahmimj8qqng1siip3qi3wm8oyb41977', 'jgt1zxuzqlmezt3lk0bi76ivk0bbep5wxcyu26fnui6ogclsj0', '0');
-- Stray Kids
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9x30f6p8uv0n64r', 'Stray Kids', '223@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0610877c41cb9cc12ad39cc0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:223@artist.com', '9x30f6p8uv0n64r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9x30f6p8uv0n64r', 'Blending traditional rhythms with modern beats.', 'Stray Kids');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gpikr9i2etxefrjm67cmeiye27epb76fyhp01ui7hjzyb0ugdk','9x30f6p8uv0n64r', 'https://i.scdn.co/image/ab67616d0000b273e27ba26bc14a563bf3d09882', 'Stray Kids Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('916tg383filkhsfpnewdtk5jwgwmaoc4qcuz21fl0melymvi2p','S-Class','9x30f6p8uv0n64r',100,'POP','3gTQwwDNJ42CCLo3Sf4JDd','https://p.scdn.co/mp3-preview/4ea586fdcc2c9aec34a18d2034d1dec78a3b5e25?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gpikr9i2etxefrjm67cmeiye27epb76fyhp01ui7hjzyb0ugdk', '916tg383filkhsfpnewdtk5jwgwmaoc4qcuz21fl0melymvi2p', '0');
-- Lizzo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x5ricp2ogrlawly', 'Lizzo', '224@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0d66b3670294bf801847dae2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:224@artist.com', 'x5ricp2ogrlawly', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x5ricp2ogrlawly', 'An endless quest for musical perfection.', 'Lizzo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('75erzjqmb9z8ott8hvcvvcm3spn6srfdolymg0a9wd2or7dh6w','x5ricp2ogrlawly', 'https://i.scdn.co/image/ab67616d0000b273b817e721691aff3d67f26c04', 'Lizzo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xe0vf1yo67f1ulsg6agat81nh20zud6iq1fqfu7hgft991chwg','About Damn Time','x5ricp2ogrlawly',100,'POP','1PckUlxKqWQs3RlWXVBLw3','https://p.scdn.co/mp3-preview/bbf8a26d38f7d8c7191dd64bd7c21a4cec8b61a0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('75erzjqmb9z8ott8hvcvvcm3spn6srfdolymg0a9wd2or7dh6w', 'xe0vf1yo67f1ulsg6agat81nh20zud6iq1fqfu7hgft991chwg', '0');
-- Steve Aoki
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uob643gdxter7qp', 'Steve Aoki', '225@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:225@artist.com', 'uob643gdxter7qp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uob643gdxter7qp', 'An endless quest for musical perfection.', 'Steve Aoki');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('krro02ifd99fnzcmx38h335l64c7ifntr93hw8urnzeap0g9qk','uob643gdxter7qp', NULL, 'Steve Aoki Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xs9bzesr6l6qg5teuhvfsu4ujjezsjnlm0vsnuhscucfogsrlu','Mu','uob643gdxter7qp',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('krro02ifd99fnzcmx38h335l64c7ifntr93hw8urnzeap0g9qk', 'xs9bzesr6l6qg5teuhvfsu4ujjezsjnlm0vsnuhscucfogsrlu', '0');
-- Swae Lee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dvkhr8sx07yr8du', 'Swae Lee', '226@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:226@artist.com', 'dvkhr8sx07yr8du', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dvkhr8sx07yr8du', 'A harmonious blend of passion and creativity.', 'Swae Lee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('svidbcr0eb7ak4wolx4wzvtb78dxy2u5bj08cltkyhlkfyvlo7','dvkhr8sx07yr8du', NULL, 'Swae Lee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aravmemwy8cwa2a9f7sg7vuptwjtqolgxglowyxvcycv2vgld4','Calling (Spider-Man: Across the Spider-Verse) (Metro Boomin & Swae Lee, NAV, feat. A Boogie Wit da Hoodie)','dvkhr8sx07yr8du',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('svidbcr0eb7ak4wolx4wzvtb78dxy2u5bj08cltkyhlkfyvlo7', 'aravmemwy8cwa2a9f7sg7vuptwjtqolgxglowyxvcycv2vgld4', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7o7j1kfhm82rmoy69372s0h8kruups1qwqs42dso4n2gpqz8au','Annihilate (Spider-Man: Across the Spider-Verse) (Metro Boomin & Swae Lee, Lil Wayne, Offset)','dvkhr8sx07yr8du',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('svidbcr0eb7ak4wolx4wzvtb78dxy2u5bj08cltkyhlkfyvlo7', '7o7j1kfhm82rmoy69372s0h8kruups1qwqs42dso4n2gpqz8au', '1');
-- Ayparia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('o3qh0mtd9y1n06o', 'Ayparia', '227@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebff258a75f7364baaaf9ed011','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:227@artist.com', 'o3qh0mtd9y1n06o', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('o3qh0mtd9y1n06o', 'Delivering a unique blend of sounds, showcasing versatility and artistic depth.', 'Ayparia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ed8qku2mcz49s1fz5gfzsjlfstgezf0drq4byykeyk2hes2un1','o3qh0mtd9y1n06o', NULL, 'Ayparia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wbsf12rxkx9yobszbr90umqwfzz2ozb8m2bdkpuwecgqxhess1','MONTAGEM - FR PUNK','o3qh0mtd9y1n06o',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ed8qku2mcz49s1fz5gfzsjlfstgezf0drq4byykeyk2hes2un1', 'wbsf12rxkx9yobszbr90umqwfzz2ozb8m2bdkpuwecgqxhess1', '0');
-- Myke Towers
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uu026mjtowymb1m', 'Myke Towers', '228@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9e35c3c5de877f99a8f6192f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:228@artist.com', 'uu026mjtowymb1m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uu026mjtowymb1m', 'A rising star in Latin music, known for his distinctive flow.', 'Myke Towers');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('e8o4q7ei70ttsnlbqhnyu7k45ucn511tajrs1lxuo1452fvf6z','uu026mjtowymb1m', 'https://i.scdn.co/image/ab67616d0000b2730656d5ce813ca3cc4b677e05', 'Myke Towers Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('934u1nacnepe0w1natplwknfl18koxpa4ohtvti565q7u7nj8u','LALA','uu026mjtowymb1m',100,'POP','7ABLbnD53cQK00mhcaOUVG','https://p.scdn.co/mp3-preview/42772b16b4e575d1b15b0ec7f94e335539390d2d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e8o4q7ei70ttsnlbqhnyu7k45ucn511tajrs1lxuo1452fvf6z', '934u1nacnepe0w1natplwknfl18koxpa4ohtvti565q7u7nj8u', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kfqhq90zx9p7kuacwsykbfbtfekjp59f6yecqd3nrl3orubhx7','PLAYA DEL INGL','uu026mjtowymb1m',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('e8o4q7ei70ttsnlbqhnyu7k45ucn511tajrs1lxuo1452fvf6z', 'kfqhq90zx9p7kuacwsykbfbtfekjp59f6yecqd3nrl3orubhx7', '1');
-- Creedence Clearwater Revival
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3q5x3apqb4b5gec', 'Creedence Clearwater Revival', '229@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd2e2b04b7ba5d60b72f54506','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:229@artist.com', '3q5x3apqb4b5gec', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3q5x3apqb4b5gec', 'Sculpting soundwaves into masterpieces of auditory art.', 'Creedence Clearwater Revival');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nkgn10wpwxq6hd32ztmrawt3irwbdzv9cg9ezfd5qcgucrnvmw','3q5x3apqb4b5gec', 'https://i.scdn.co/image/ab67616d0000b27351f311c2fb06ad2789e3ff91', 'Creedence Clearwater Revival Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qfvngehqr0n71z772gfovxlprzheksexjny17k7lga0yy5tiz3','Have You Ever Seen The Rain?','3q5x3apqb4b5gec',100,'POP','2LawezPeJhN4AWuSB0GtAU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nkgn10wpwxq6hd32ztmrawt3irwbdzv9cg9ezfd5qcgucrnvmw', 'qfvngehqr0n71z772gfovxlprzheksexjny17k7lga0yy5tiz3', '0');
-- Kendrick Lamar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pb3s1v416j8ce6g', 'Kendrick Lamar', '230@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb52696416126917a827b514d2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:230@artist.com', 'pb3s1v416j8ce6g', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pb3s1v416j8ce6g', 'Igniting the stage with electrifying performances.', 'Kendrick Lamar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('baz9cuckolk68xrg5qz6ja0007ma0bvw6t8gzu91vy7xkcqtjl','pb3s1v416j8ce6g', 'https://i.scdn.co/image/ab67616d0000b273d28d2ebdedb220e479743797', 'Kendrick Lamar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r9zup6db3rp4eb2478r4vmekk695ddf10gun1sakluyxocfyv1','Money Trees','pb3s1v416j8ce6g',100,'POP','2HbKqm4o0w5wEeEFXm2sD4',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('baz9cuckolk68xrg5qz6ja0007ma0bvw6t8gzu91vy7xkcqtjl', 'r9zup6db3rp4eb2478r4vmekk695ddf10gun1sakluyxocfyv1', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1p9ktvi5xx2o816mimwhoqgwf34f3kefqwhblvg0407vob6tax','AMERICA HAS A PROBLEM (feat. Kendrick Lamar)','pb3s1v416j8ce6g',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('baz9cuckolk68xrg5qz6ja0007ma0bvw6t8gzu91vy7xkcqtjl', '1p9ktvi5xx2o816mimwhoqgwf34f3kefqwhblvg0407vob6tax', '1');
-- RAYE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pa8y2ia83l99nnx', 'RAYE', '231@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0550f0badff3ad04802b1e86','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:231@artist.com', 'pa8y2ia83l99nnx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pa8y2ia83l99nnx', 'Transcending language barriers through the universal language of music.', 'RAYE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3hw1vb9uwo6a3mhz8hqd8uvv5pfxbzf6yvn75o3rrzzeu77n4q','pa8y2ia83l99nnx', 'https://i.scdn.co/image/ab67616d0000b27394e5237ce925531dbb38e75f', 'RAYE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dad3nkjivlvvoytjr4oouel0ar4u16914b2vkuw8y5nb39t63z','Escapism.','pa8y2ia83l99nnx',100,'POP','5mHdCZtVyb4DcJw8799hZp','https://p.scdn.co/mp3-preview/8a8fcaf9ddf050562048d1632ddc880c9ce7c972?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3hw1vb9uwo6a3mhz8hqd8uvv5pfxbzf6yvn75o3rrzzeu77n4q', 'dad3nkjivlvvoytjr4oouel0ar4u16914b2vkuw8y5nb39t63z', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l5jona3b2wdm48w9un4mqz28lfzepi016b4qvhugn3681ab3wz','Escapism. - Sped Up','pa8y2ia83l99nnx',100,'POP','3XCpS4k8WqNnCpcDOSRRuz','https://p.scdn.co/mp3-preview/22be59e4d5da403513e02e90c27bc1d0965b5f1f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3hw1vb9uwo6a3mhz8hqd8uvv5pfxbzf6yvn75o3rrzzeu77n4q', 'l5jona3b2wdm48w9un4mqz28lfzepi016b4qvhugn3681ab3wz', '1');
-- James Arthur
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bqnlc1w6r8y1g2t', 'James Arthur', '232@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2a0c6d0343c82be9dd6fce0b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:232@artist.com', 'bqnlc1w6r8y1g2t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bqnlc1w6r8y1g2t', 'Blending traditional rhythms with modern beats.', 'James Arthur');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8k1w3cj801xjxnbj1k1z3kq00u3qf1pkn0o823gsyed7yg6tqi','bqnlc1w6r8y1g2t', 'https://i.scdn.co/image/ab67616d0000b273dc16d839ab77c64bdbeb3660', 'James Arthur Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yjg7mtxidc5c07ha1s2ey7kari2xzwoudvcf5jo8dmjmw5cs17','Cars Outside','bqnlc1w6r8y1g2t',100,'POP','0otRX6Z89qKkHkQ9OqJpKt','https://p.scdn.co/mp3-preview/cfaa30729da8d2d8965fae154b6e9d0964a2ea6b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8k1w3cj801xjxnbj1k1z3kq00u3qf1pkn0o823gsyed7yg6tqi', 'yjg7mtxidc5c07ha1s2ey7kari2xzwoudvcf5jo8dmjmw5cs17', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zi8o1lq0glyquoic5b60he0jf19mjziyso2ousf0pv60scilsq','Say You Wont Let Go','bqnlc1w6r8y1g2t',100,'POP','5uCax9HTNlzGybIStD3vDh','https://p.scdn.co/mp3-preview/2eed95a3c08cd10669768ce60d1140f85ba8b951?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8k1w3cj801xjxnbj1k1z3kq00u3qf1pkn0o823gsyed7yg6tqi', 'zi8o1lq0glyquoic5b60he0jf19mjziyso2ousf0pv60scilsq', '1');
-- Alec Benjamin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x43m0l2r7m2eaw7', 'Alec Benjamin', '233@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc7e8521887c99b10c8bbfbac','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:233@artist.com', 'x43m0l2r7m2eaw7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x43m0l2r7m2eaw7', 'Pioneering new paths in the musical landscape.', 'Alec Benjamin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6tixqqfy51rzthiemjvtjf8tj1zf3ih84fe6orxvcuwfxgfg02','x43m0l2r7m2eaw7', 'https://i.scdn.co/image/ab67616d0000b273459d675aa0b6f3b211357370', 'Alec Benjamin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9d9xn7ihdcceeluhlnwba7occ69plq1l3nxsii4f7gjjgxe3fo','Let Me Down Slowly','x43m0l2r7m2eaw7',100,'POP','2qxmye6gAegTMjLKEBoR3d','https://p.scdn.co/mp3-preview/19007111a4e21096bcefef77842d7179f0cdf12a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6tixqqfy51rzthiemjvtjf8tj1zf3ih84fe6orxvcuwfxgfg02', '9d9xn7ihdcceeluhlnwba7occ69plq1l3nxsii4f7gjjgxe3fo', '0');
-- R
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('di5f1sok6dsuj8e', 'R', '234@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6334ab6a83196f36475ada7f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:234@artist.com', 'di5f1sok6dsuj8e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('di5f1sok6dsuj8e', 'A symphony of emotions expressed through sound.', 'R');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u7l2co0m0sg8hwm99m63q5y1cvu4pqzjzlf5x6qu1hv9ht8mit','di5f1sok6dsuj8e', 'https://i.scdn.co/image/ab67616d0000b273a3a7f38ea2033aa501afd4cf', 'R Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d02z4msmigr1qulxqkj1j7su3le97kzybxdh847bcsqardk923','Calm Down','di5f1sok6dsuj8e',100,'POP','0WtM2NBVQNNJLh6scP13H8',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u7l2co0m0sg8hwm99m63q5y1cvu4pqzjzlf5x6qu1hv9ht8mit', 'd02z4msmigr1qulxqkj1j7su3le97kzybxdh847bcsqardk923', '0');
-- Taylor Swift
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9hyilxzi3j3lbko', 'Taylor Swift', '235@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb859e4c14fa59296c8649e0e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:235@artist.com', '9hyilxzi3j3lbko', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9hyilxzi3j3lbko', 'A storytelling icon, weaving life experiences into musical masterpieces.', 'Taylor Swift');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe','9hyilxzi3j3lbko', 'https://i.scdn.co/image/ab67616d0000b273e787cffec20aa2a396a61647', 'Taylor Swift Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d0tr07s93mnithlmgtwpgwbrime3yyp3rk07pcqdtf7yysuh8l','Cruel Summer','9hyilxzi3j3lbko',100,'POP','1BxfuPKGuaTgP7aM0Bbdwr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'd0tr07s93mnithlmgtwpgwbrime3yyp3rk07pcqdtf7yysuh8l', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wyprc07wf131y12a4b1lxyhagi9ssbg8h0o0gjpfpi7d9whfzr','I Can See You (Taylors Version) (From The ','9hyilxzi3j3lbko',100,'POP','5kHMfzgLZP95O9NBy0ku4v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'wyprc07wf131y12a4b1lxyhagi9ssbg8h0o0gjpfpi7d9whfzr', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j0qkgb135nfd1dx8bblubd6dflqjs0f0kxig3xui5b2y0e0ee6','Anti-Hero','9hyilxzi3j3lbko',100,'POP','0V3wPSX9ygBnCm8psDIegu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'j0qkgb135nfd1dx8bblubd6dflqjs0f0kxig3xui5b2y0e0ee6', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kqmfx5kmvbbar6okbi4w62n1efnupnwoyf17757jo3chih8asx','Blank Space','9hyilxzi3j3lbko',100,'POP','1p80LdxRV74UKvL8gnD7ky',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'kqmfx5kmvbbar6okbi4w62n1efnupnwoyf17757jo3chih8asx', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jl9khefzjs2lsfv186szzrpu5gwgc89c0791yk31u277vi4m7q','Style','9hyilxzi3j3lbko',100,'POP','1hjRhYpWyqDpPahmSlUTlc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'jl9khefzjs2lsfv186szzrpu5gwgc89c0791yk31u277vi4m7q', '4');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ohcyz5y76ojwj39juo49w0e2f05q12zkk1l89tgtenofkktr3p','cardigan','9hyilxzi3j3lbko',100,'POP','4R2kfaDFhslZEMJqAFNpdd',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'ohcyz5y76ojwj39juo49w0e2f05q12zkk1l89tgtenofkktr3p', '5');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pgmahfs82ctzb2kdgiuqs6x0smypxsqqpgzdyc18tcmp9gnjvn','Karma','9hyilxzi3j3lbko',100,'POP','7KokYm8cMIXCsGVmUvKtqf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'pgmahfs82ctzb2kdgiuqs6x0smypxsqqpgzdyc18tcmp9gnjvn', '6');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('byrdhwmhs9k42ftvh5cwuj68jq3vxh6p90gqhq95lz4os2p1cn','Enchanted (Taylors Version)','9hyilxzi3j3lbko',100,'POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'byrdhwmhs9k42ftvh5cwuj68jq3vxh6p90gqhq95lz4os2p1cn', '7');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tg8xi4mspr3mtt6gm85dnk0x8iq7vj7mzsituuqehi8enbci0k','Back To December (Taylors Version)','9hyilxzi3j3lbko',100,'POP','79uDOz0zuuWS7HWxzMmTa2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'tg8xi4mspr3mtt6gm85dnk0x8iq7vj7mzsituuqehi8enbci0k', '8');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hwp3sjqtegoln1g0xz3tzan01u6gl0zc9nykfelle1uzofox20','Dont Bl','9hyilxzi3j3lbko',100,'POP','59ZmeIz57cGU5Gp9omjlYB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'hwp3sjqtegoln1g0xz3tzan01u6gl0zc9nykfelle1uzofox20', '9');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3og5l1rst7shd89wopffsd51rnmile13eijti7r3f6hkycc2js','Mine (Taylors Version)','9hyilxzi3j3lbko',100,'POP','7G0gBu6nLdhFDPRLc0HdDG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', '3og5l1rst7shd89wopffsd51rnmile13eijti7r3f6hkycc2js', '10');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('42vduv8bt5x1izbz1yw8e16yb2t1aa39nfuo7cp7zduefeaxhf','august','9hyilxzi3j3lbko',100,'POP','3hUxzQpSfdDqwM3ZTFQY0K',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', '42vduv8bt5x1izbz1yw8e16yb2t1aa39nfuo7cp7zduefeaxhf', '11');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v6r7spvs7pm37nqslue1og4sore3ko1px9vvh109ehsqok8dnb','Enchanted','9hyilxzi3j3lbko',100,'POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'v6r7spvs7pm37nqslue1og4sore3ko1px9vvh109ehsqok8dnb', '12');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4oir2ffcbd9joocpu0b0mv6qjhkc4s6k16a4fh2rmypyx7grq5','Shake It Off','9hyilxzi3j3lbko',100,'POP','3pv7Q5v2dpdefwdWIvE7yH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', '4oir2ffcbd9joocpu0b0mv6qjhkc4s6k16a4fh2rmypyx7grq5', '13');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qujn2l3dhv4lnarydymnxn5n999d61cfmyte00nrxkxmrfejrb','You Belong With Me (Taylors Ve','9hyilxzi3j3lbko',100,'POP','1qrpoAMXodY6895hGKoUpA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'qujn2l3dhv4lnarydymnxn5n999d61cfmyte00nrxkxmrfejrb', '14');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yw0kysq8fccsxj7h0rtao8w87ht13b254kwaar33nf2aow7f2p','Better Than Revenge (Taylors Version)','9hyilxzi3j3lbko',100,'POP','0NwGC0v03ysCYINtg6ns58',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'yw0kysq8fccsxj7h0rtao8w87ht13b254kwaar33nf2aow7f2p', '15');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l6spr39rrokqi4byfhanp5rpjlbcx1atfjkfgs1ue1kszctypj','Hits Different','9hyilxzi3j3lbko',100,'POP','3xYJScVfxByb61dYHTwiby',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'l6spr39rrokqi4byfhanp5rpjlbcx1atfjkfgs1ue1kszctypj', '16');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g1cjbl94l4n1lu43zu489icj1v9om6vjt7whfv5v8u6143qcbw','Karma (feat. Ice Spice)','9hyilxzi3j3lbko',100,'POP','4i6cwNY6oIUU2XZxPIw82Y',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'g1cjbl94l4n1lu43zu489icj1v9om6vjt7whfv5v8u6143qcbw', '17');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('syf862q5yv32l0utvpjgcru0qzhuykgttxmzx3dsvkbjwmgn28','Lavender Haze','9hyilxzi3j3lbko',100,'POP','5jQI2r1RdgtuT8S3iG8zFC',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'syf862q5yv32l0utvpjgcru0qzhuykgttxmzx3dsvkbjwmgn28', '18');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6ol5ljsdx7hozi83haaas0k0daaicbktdkrwfaojgkv38x5n6r','All Of The Girls You Loved Before','9hyilxzi3j3lbko',100,'POP','4P9Q0GojKVXpRTJCaL3kyy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', '6ol5ljsdx7hozi83haaas0k0daaicbktdkrwfaojgkv38x5n6r', '19');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s8y7jro9trklhl4jsb4u2dus0qe30b8e7w9y49mamvbfkstjou','Midnight Rain','9hyilxzi3j3lbko',100,'POP','3rWDp9tBPQR9z6U5YyRSK4',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 's8y7jro9trklhl4jsb4u2dus0qe30b8e7w9y49mamvbfkstjou', '20');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iaj48rixwbmc1qh3edtbekcouucsyb7rdii8s469wytmyscv55','Youre On Your Own, Kid','9hyilxzi3j3lbko',100,'POP','1yMjWvw0LRwW5EZBPh9UyF','https://p.scdn.co/mp3-preview/cb8981007d0606f43b3051b3633f890d0a70de8c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bdxuf50be8ht8yso102vz5d1zgph7cwv7viq1sbi2t3kbintqe', 'iaj48rixwbmc1qh3edtbekcouucsyb7rdii8s469wytmyscv55', '21');
-- Sabrina Carpenter
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xi2lmtu3zsut0b7', 'Sabrina Carpenter', '236@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb00e540b760b56d02cc415c47','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:236@artist.com', 'xi2lmtu3zsut0b7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xi2lmtu3zsut0b7', 'Delivering soul-stirring tunes that linger in the mind.', 'Sabrina Carpenter');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('018fwpgvihko1q7phmrlip32jtek5mlx0gwt9of6i1qi3qbxmh','xi2lmtu3zsut0b7', 'https://i.scdn.co/image/ab67616d0000b273700f7bf79c9f063ad0362bdf', 'Sabrina Carpenter Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wgx21m7cjp37p4njn6x61e0vf2jaeopwx7lvgwlbza20k5oezl','Nonsense','xi2lmtu3zsut0b7',100,'POP','6dgUya35uo964z7GZXM07g',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('018fwpgvihko1q7phmrlip32jtek5mlx0gwt9of6i1qi3qbxmh', 'wgx21m7cjp37p4njn6x61e0vf2jaeopwx7lvgwlbza20k5oezl', '0');
-- Cartel De Santa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mb5dygq709abrkg', 'Cartel De Santa', '237@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb72d02b5f21c6364c3d1928d7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:237@artist.com', 'mb5dygq709abrkg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mb5dygq709abrkg', 'A confluence of cultural beats and contemporary tunes.', 'Cartel De Santa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bt4n8ta2so6zfulgfe7yu852o325w5d4kksxkt7jzw4e34gle7','mb5dygq709abrkg', 'https://i.scdn.co/image/ab67616d0000b273608e249e118a39e897f149ce', 'Cartel De Santa Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('86xk68rnp1pgguedjjji6g7l965wahns7bnvdbh3j13le9z54v','Shorty Party','mb5dygq709abrkg',100,'POP','55ZATsjPlTeSTNJOuW90pW','https://p.scdn.co/mp3-preview/861a31225cff10db2eedeb5c28bf6d0a4ecc4bc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bt4n8ta2so6zfulgfe7yu852o325w5d4kksxkt7jzw4e34gle7', '86xk68rnp1pgguedjjji6g7l965wahns7bnvdbh3j13le9z54v', '0');
-- Nicky Youre
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6qa5d2pkdnkv62w', 'Nicky Youre', '238@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe726c8549d387a241f979acd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:238@artist.com', '6qa5d2pkdnkv62w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6qa5d2pkdnkv62w', 'Exploring the depths of sound and rhythm.', 'Nicky Youre');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vemf610nic7hkr2ljg2pk14huj4vb22sv6jpgg0a5qglkuihcc','6qa5d2pkdnkv62w', 'https://i.scdn.co/image/ab67616d0000b273ecd970d1d2623b6c7fc6080c', 'Nicky Youre Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('libwb5byklupjzbujbw8oovfhmy3bd7pvxse82d9nx6pt41jlo','Sunroof','6qa5d2pkdnkv62w',100,'POP','5YqEzk3C5c3UZ1D5fJUlXA','https://p.scdn.co/mp3-preview/605058558fd8d10c420b56c41555e567645d5b60?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vemf610nic7hkr2ljg2pk14huj4vb22sv6jpgg0a5qglkuihcc', 'libwb5byklupjzbujbw8oovfhmy3bd7pvxse82d9nx6pt41jlo', '0');
-- Ed Sheeran
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('oh1elbn6o4i6vez', 'Ed Sheeran', '239@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3bcef85e105dfc42399ef0ba','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:239@artist.com', 'oh1elbn6o4i6vez', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('oh1elbn6o4i6vez', 'A confluence of cultural beats and contemporary tunes.', 'Ed Sheeran');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zhtvf3po6oymwuyt2dvzy7kfd32gtl6luo6kjljja7kbbkvk15','oh1elbn6o4i6vez', 'https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96', 'Ed Sheeran Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uzu6ax672e33cpayqpl1a2wz5e3z59k1trqraejzlbtqs2hyni','Perfect','oh1elbn6o4i6vez',100,'POP','0tgVpDi06FyKpA1z0VMD4v','https://p.scdn.co/mp3-preview/4e30857a3c7da3f8891483643e310bb233afadd2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zhtvf3po6oymwuyt2dvzy7kfd32gtl6luo6kjljja7kbbkvk15', 'uzu6ax672e33cpayqpl1a2wz5e3z59k1trqraejzlbtqs2hyni', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mvbdgxgzvc4wjnbhvob8d376d4qkukvg6sv2nyjapx7e4bn7zc','Shape of You','oh1elbn6o4i6vez',100,'POP','7qiZfU4dY1lWllzX7mPBI3','https://p.scdn.co/mp3-preview/7339548839a263fd721d01eb3364a848cad16fa7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zhtvf3po6oymwuyt2dvzy7kfd32gtl6luo6kjljja7kbbkvk15', 'mvbdgxgzvc4wjnbhvob8d376d4qkukvg6sv2nyjapx7e4bn7zc', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0ze7pkxinj1qsh0ee2lqqsi5fcoxnzig9hzzgjsftvg3ob7fwy','Eyes Closed','oh1elbn6o4i6vez',100,'POP','3p7XQpdt8Dr6oMXSvRZ9bg','https://p.scdn.co/mp3-preview/7cd2576f2d27799fe8c515c4e0fc880870a5cc88?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zhtvf3po6oymwuyt2dvzy7kfd32gtl6luo6kjljja7kbbkvk15', '0ze7pkxinj1qsh0ee2lqqsi5fcoxnzig9hzzgjsftvg3ob7fwy', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d118xaucgml9bcjftu84yamqqkosjlj2n72z90kj2gct347g4v','Curtains','oh1elbn6o4i6vez',100,'POP','6ZZf5a8oiInHDkBe9zXfLP','https://p.scdn.co/mp3-preview/5a519e5823df4fe468c8a45a7104a632553e09a5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zhtvf3po6oymwuyt2dvzy7kfd32gtl6luo6kjljja7kbbkvk15', 'd118xaucgml9bcjftu84yamqqkosjlj2n72z90kj2gct347g4v', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dxwdflnftnzw79paqsgv1jqy8at07ph5s99ypb8lsz3qjzuewf','Shivers','oh1elbn6o4i6vez',100,'POP','50nfwKoDiSYg8zOCREWAm5','https://p.scdn.co/mp3-preview/08cec59d36ac30ae9ce1e2944f206251859844af?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zhtvf3po6oymwuyt2dvzy7kfd32gtl6luo6kjljja7kbbkvk15', 'dxwdflnftnzw79paqsgv1jqy8at07ph5s99ypb8lsz3qjzuewf', '4');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y25usfo81ffw2cew8l03r270tt2rgy9h6rmuq54gkx206vz8dt','Bad Habits','oh1elbn6o4i6vez',100,'POP','3rmo8F54jFF8OgYsqTxm5d','https://p.scdn.co/mp3-preview/22f3a86c8a83e364db595007f9ac1d666596a335?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zhtvf3po6oymwuyt2dvzy7kfd32gtl6luo6kjljja7kbbkvk15', 'y25usfo81ffw2cew8l03r270tt2rgy9h6rmuq54gkx206vz8dt', '5');
-- James Blake
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('eqzvs5ye9xhc2f8', 'James Blake', '240@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb93fe5fc8fdb5a98248911a07','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:240@artist.com', 'eqzvs5ye9xhc2f8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('eqzvs5ye9xhc2f8', 'Revolutionizing the music scene with innovative compositions.', 'James Blake');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i9y95z871qzx1dhddldqm4ayzsdqyqwbf9737ygh1ju1fslxij','eqzvs5ye9xhc2f8', NULL, 'James Blake Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lt4ciaszn3rk50l0ir5m4r8m6vtku44hebwwgmqlzrbhrct1vv','Hummingbird (Metro Boomin & James Blake)','eqzvs5ye9xhc2f8',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i9y95z871qzx1dhddldqm4ayzsdqyqwbf9737ygh1ju1fslxij', 'lt4ciaszn3rk50l0ir5m4r8m6vtku44hebwwgmqlzrbhrct1vv', '0');
-- Post Malone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sfu6tkqdynz5xcd', 'Post Malone', '241@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:241@artist.com', 'sfu6tkqdynz5xcd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sfu6tkqdynz5xcd', 'Blurring genre lines with his unique blend of hip-hop and pop.', 'Post Malone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('cc9rqy7xuu4r32gycv9qor39xj60rciabqjee8fbgqqt4elwph','sfu6tkqdynz5xcd', 'https://i.scdn.co/image/ab67616d0000b2739478c87599550dd73bfa7e02', 'Post Malone Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qenv0e4rxrjtbofpaob5tghci6jwtf6w458f26k2r2ci5cyd9b','Sunflower - Spider-Man: Into the Spider-Verse','sfu6tkqdynz5xcd',100,'POP','0RiRZpuVRbi7oqRdSMwhQY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cc9rqy7xuu4r32gycv9qor39xj60rciabqjee8fbgqqt4elwph', 'qenv0e4rxrjtbofpaob5tghci6jwtf6w458f26k2r2ci5cyd9b', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vasthm9t5vchiycppb16mvov3csx270p8ulq90bmeqgaaw67u9','Overdrive','sfu6tkqdynz5xcd',100,'POP','3t0ic4mkhvhamrKDkulB8v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cc9rqy7xuu4r32gycv9qor39xj60rciabqjee8fbgqqt4elwph', 'vasthm9t5vchiycppb16mvov3csx270p8ulq90bmeqgaaw67u9', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('b81iioidh5p19etqs7mhi942c2gl4k6s3tdt1nz2kwtogw7rwi','Chemical','sfu6tkqdynz5xcd',100,'POP','5w40ZYhbBMAlHYNDaVJIUu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cc9rqy7xuu4r32gycv9qor39xj60rciabqjee8fbgqqt4elwph', 'b81iioidh5p19etqs7mhi942c2gl4k6s3tdt1nz2kwtogw7rwi', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('78auz7owrdk29ugjekghs80ba40ongz24cmgfkndoq8m81t1t7','Circles','sfu6tkqdynz5xcd',100,'POP','21jGcNKet2qwijlDFuPiPb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cc9rqy7xuu4r32gycv9qor39xj60rciabqjee8fbgqqt4elwph', '78auz7owrdk29ugjekghs80ba40ongz24cmgfkndoq8m81t1t7', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zth6iodv9uih2h9j0ln55a7k84wz4eq4lobtiofb7zzekq3b76','I Like You (A Happier Song) (with Doja Cat)','sfu6tkqdynz5xcd',100,'POP','0O6u0VJ46W86TxN9wgyqDj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('cc9rqy7xuu4r32gycv9qor39xj60rciabqjee8fbgqqt4elwph', 'zth6iodv9uih2h9j0ln55a7k84wz4eq4lobtiofb7zzekq3b76', '4');
-- Bomba Estreo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cuw3jjjjovsl0p7', 'Bomba Estreo', '242@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcc4d7c642f167846d8aa743b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:242@artist.com', 'cuw3jjjjovsl0p7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cuw3jjjjovsl0p7', 'A voice that echoes the sentiments of a generation.', 'Bomba Estreo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('mn32rf6o8umr9n7pjd0qkm1em2lhwwy8b5qhurp2mss6bea8a4','cuw3jjjjovsl0p7', NULL, 'Bomba Estreo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ejgbxvwa504la3kbs0ll9ofiu4kca5tjim150jp6tlf078mik7','Ojitos Lindos','cuw3jjjjovsl0p7',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('mn32rf6o8umr9n7pjd0qkm1em2lhwwy8b5qhurp2mss6bea8a4', 'ejgbxvwa504la3kbs0ll9ofiu4kca5tjim150jp6tlf078mik7', '0');
-- Michael Bubl
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cbw6bjz98sf9u0s', 'Michael Bubl', '243@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebef8cf61fea4923d2bde68200','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:243@artist.com', 'cbw6bjz98sf9u0s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cbw6bjz98sf9u0s', 'Crafting soundscapes that transport listeners to another world.', 'Michael Bubl');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('raoknfnesurfg49xig0d1nywij0ab590a1lyhk3xk27egnrhb4','cbw6bjz98sf9u0s', 'https://i.scdn.co/image/ab67616d0000b273119e4094f07a8123b471ac1d', 'Michael Bubl Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pcwexhr21s8ccfj2iumk9ug5chw5kxs3v5skklvl0cywd9rjno','Its Beginning To Look A Lot Like Christmas','cbw6bjz98sf9u0s',100,'POP','5a1iz510sv2W9Dt1MvFd5R','https://p.scdn.co/mp3-preview/51f36d7e04069ef4869ea575fb21e5404710b1c4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('raoknfnesurfg49xig0d1nywij0ab590a1lyhk3xk27egnrhb4', 'pcwexhr21s8ccfj2iumk9ug5chw5kxs3v5skklvl0cywd9rjno', '0');
-- Wham!
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zj8deqg6k7u8rva', 'Wham!', '244@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03e73d13341a8419eea9fcfb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:244@artist.com', 'zj8deqg6k7u8rva', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zj8deqg6k7u8rva', 'Crafting a unique sonic identity in every track.', 'Wham!');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4p056pmu0drnw9y7qercb0t6rsqkogwshvzjrpwiqnfmyfpv8q','zj8deqg6k7u8rva', 'https://i.scdn.co/image/ab67616d0000b273f2d2adaa21ad616df6241e7d', 'Wham! Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dgwtq7btu5esb6ejsik4k4clf7i6657h9ac7t1q23kfb81a5hq','Last Christmas','zj8deqg6k7u8rva',100,'POP','2FRnf9qhLbvw8fu4IBXx78','https://p.scdn.co/mp3-preview/5c6b42e86dba5ec9e8346a345b3a8822b2396d3f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4p056pmu0drnw9y7qercb0t6rsqkogwshvzjrpwiqnfmyfpv8q', 'dgwtq7btu5esb6ejsik4k4clf7i6657h9ac7t1q23kfb81a5hq', '0');
-- Lil Nas X
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('23vig7n634op8wx', 'Lil Nas X', '245@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd66f1e0c883f319443d68c45','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:245@artist.com', '23vig7n634op8wx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('23vig7n634op8wx', 'The heartbeat of a new generation of music lovers.', 'Lil Nas X');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1fhd12wfuq8sk5b26o5u9if6cvjmzsiooudq66aw3uwfvrcchy','23vig7n634op8wx', 'https://i.scdn.co/image/ab67616d0000b27304cd9a1664fb4539a55643fe', 'Lil Nas X Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2u3qc7r8c6nnyfi8cjzpeykau039pucgmyuygmuw05ycvclx7b','STAR WALKIN (League of Legends Worlds Anthem)','23vig7n634op8wx',100,'POP','38T0tPVZHcPZyhtOcCP7pF','https://p.scdn.co/mp3-preview/ffa9d53ff1f83a322ac0523d7a6ce13b231e4a3a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1fhd12wfuq8sk5b26o5u9if6cvjmzsiooudq66aw3uwfvrcchy', '2u3qc7r8c6nnyfi8cjzpeykau039pucgmyuygmuw05ycvclx7b', '0');
-- Bebe Rexha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j3vkyjx9fxju1bn', 'Bebe Rexha', '246@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41c4dd328bbea2f0a19c7522','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:246@artist.com', 'j3vkyjx9fxju1bn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j3vkyjx9fxju1bn', 'A dynamic voice in pop music, known for her powerful vocals and catchy tunes.', 'Bebe Rexha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2xqhhbnoo4rk8va3ty761mblvi9yjjhgkxswh9zl13dm9txtvr','j3vkyjx9fxju1bn', NULL, 'Bebe Rexha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('if0k9rg28r4mivrx6wfpoirkiukpv2i7lp2vol77mxha5zcusu','Im Good (Blue)','j3vkyjx9fxju1bn',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2xqhhbnoo4rk8va3ty761mblvi9yjjhgkxswh9zl13dm9txtvr', 'if0k9rg28r4mivrx6wfpoirkiukpv2i7lp2vol77mxha5zcusu', '0');
-- SZA
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('obw4nua5sixummp', 'SZA', '247@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7eb7f6371aad8e67e01f0a03','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:247@artist.com', 'obw4nua5sixummp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('obw4nua5sixummp', 'An avant-garde R&B artist painting vivid stories through her music.', 'SZA');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sldl27n4lxgad0j8wku2uzuhr3ndp4cencs6q4k3vcmjpgmvn8','obw4nua5sixummp', 'https://i.scdn.co/image/ab67616d0000b2730c471c36970b9406233842a5', 'SZA Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('by1thi8m0pqji19kvkhhuoerq4klgsr25apnj2wgvbj2eey6jk','Kill Bill','obw4nua5sixummp',100,'POP','1Qrg8KqiBpW07V7PNxwwwL','https://p.scdn.co/mp3-preview/4bd2dc84016f3743add7eea8b988407b1b900672?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sldl27n4lxgad0j8wku2uzuhr3ndp4cencs6q4k3vcmjpgmvn8', 'by1thi8m0pqji19kvkhhuoerq4klgsr25apnj2wgvbj2eey6jk', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('scf76hxug604a1foo203xh0q3al8ctzl2vmgc28up184v4r0r0','Snooze','obw4nua5sixummp',100,'POP','4iZ4pt7kvcaH6Yo8UoZ4s2','https://p.scdn.co/mp3-preview/8c53920b5fd2c3178afa36cac9eec68b5ee9204a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sldl27n4lxgad0j8wku2uzuhr3ndp4cencs6q4k3vcmjpgmvn8', 'scf76hxug604a1foo203xh0q3al8ctzl2vmgc28up184v4r0r0', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r7aunhyxhqdjc1d318r0y08i6ib20r37u1xsk6eq2kdvk6uye1','Low','obw4nua5sixummp',100,'POP','2GAhgAjOhEmItWLfgisyOn','https://p.scdn.co/mp3-preview/5b6dd5a1d06d0bdfd57382a584cbf0227b4d9a4b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sldl27n4lxgad0j8wku2uzuhr3ndp4cencs6q4k3vcmjpgmvn8', 'r7aunhyxhqdjc1d318r0y08i6ib20r37u1xsk6eq2kdvk6uye1', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('svpyl0z9d7l01miyu102upe02dlmqprenybzupaub28bq3fyng','Nobody Gets Me','obw4nua5sixummp',100,'POP','5Y35SjAfXjjG0sFQ3KOxmm','https://p.scdn.co/mp3-preview/36cfe8fbfb78aa38ca3b222c4b9fc88cda992841?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sldl27n4lxgad0j8wku2uzuhr3ndp4cencs6q4k3vcmjpgmvn8', 'svpyl0z9d7l01miyu102upe02dlmqprenybzupaub28bq3fyng', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('eeqh1llglepcafk7md06dk4hi0xjx2qgdc4osxcunerpgsmla7','Shirt','obw4nua5sixummp',100,'POP','2wSTnntOPRi7aQneobFtU4','https://p.scdn.co/mp3-preview/8819fb0dc127d1d777a776f4d1186be783334ae5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sldl27n4lxgad0j8wku2uzuhr3ndp4cencs6q4k3vcmjpgmvn8', 'eeqh1llglepcafk7md06dk4hi0xjx2qgdc4osxcunerpgsmla7', '4');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s36i4dlp8mrevpox7w4a0y3almx4r6zrdb42c0sgipze44zr26','Blind','obw4nua5sixummp',100,'POP','2CSRrnOEELmhpq8iaAi9cd','https://p.scdn.co/mp3-preview/56cd00fd7aa857bd25e4ed25aebc0e41a24bfd4f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sldl27n4lxgad0j8wku2uzuhr3ndp4cencs6q4k3vcmjpgmvn8', 's36i4dlp8mrevpox7w4a0y3almx4r6zrdb42c0sgipze44zr26', '5');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w8ktgy05v36wi4adqsslhcaaa2c8meodgl6e3u3icqb18ttppr','Good Days','obw4nua5sixummp',100,'POP','4PMqSO5qyjpvzhlLI5GnID','https://p.scdn.co/mp3-preview/d7fd97c8190baa298af9b4e778d2ba940fcd13a4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sldl27n4lxgad0j8wku2uzuhr3ndp4cencs6q4k3vcmjpgmvn8', 'w8ktgy05v36wi4adqsslhcaaa2c8meodgl6e3u3icqb18ttppr', '6');
-- Lost Frequencies
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e4rgkg8j6iniucv', 'Lost Frequencies', '248@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfd28880f1b1fa8f93d05eb76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:248@artist.com', 'e4rgkg8j6iniucv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e4rgkg8j6iniucv', 'Striking chords that resonate across generations.', 'Lost Frequencies');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0iczmi2gxrwwn89cu0q7141mzjlxb9sl3grynfrvyq6yjot7i5','e4rgkg8j6iniucv', 'https://i.scdn.co/image/ab67616d0000b2738d7a7f1855b04104ba59c18b', 'Lost Frequencies Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4bk1ibs191da0pf40txj2cgybk44nbu7o7gn8ipomaymqww0or','Where Are You Now','e4rgkg8j6iniucv',100,'POP','3uUuGVFu1V7jTQL60S1r8z','https://p.scdn.co/mp3-preview/e2646d5bc8c56e4a91582a03c089f8038772aecb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0iczmi2gxrwwn89cu0q7141mzjlxb9sl3grynfrvyq6yjot7i5', '4bk1ibs191da0pf40txj2cgybk44nbu7o7gn8ipomaymqww0or', '0');
-- Em Beihold
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z5cpdsx644tvhu1', 'Em Beihold', '249@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb23c885de4c81852c917608ac','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:249@artist.com', 'z5cpdsx644tvhu1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z5cpdsx644tvhu1', 'A voice that captivates, combining depth of lyrics with a melodic finesse.', 'Em Beihold');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rf5a5uupn7xmw7tmkkt6g7jmkxr4zytfp6zko61b7lfemrdqme','z5cpdsx644tvhu1', NULL, 'Em Beihold Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j5ey1x4le8iy7u7v0n1ss3zasagpofmu1k4e7to9lxn7qb83h7','Until I Found You (with Em Beihold) - Em Beihold Version','z5cpdsx644tvhu1',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rf5a5uupn7xmw7tmkkt6g7jmkxr4zytfp6zko61b7lfemrdqme', 'j5ey1x4le8iy7u7v0n1ss3zasagpofmu1k4e7to9lxn7qb83h7', '0');
-- Kordhell
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('49sklo3eoralbxr', 'Kordhell', '250@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb15862815bf4d2446b8ecf55f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:250@artist.com', '49sklo3eoralbxr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('49sklo3eoralbxr', 'Melodies that capture the essence of human emotion.', 'Kordhell');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i4m6t9fbmg0stytkol1kghbo1j7dibb8nmqj58phygpvnrb8bj','49sklo3eoralbxr', 'https://i.scdn.co/image/ab67616d0000b2731440ffaa43c53d65719e0150', 'Kordhell Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9f60ezqnhj1jx6q54rvivpfp41r4hipzyqu2ib7qah0fllaybv','Murder In My Mind','49sklo3eoralbxr',100,'POP','6qyS9qBy0mEk3qYaH8mPss','https://p.scdn.co/mp3-preview/ec3b94db31d9fb9821cfea0f7a4cdc9d2a85e969?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i4m6t9fbmg0stytkol1kghbo1j7dibb8nmqj58phygpvnrb8bj', '9f60ezqnhj1jx6q54rvivpfp41r4hipzyqu2ib7qah0fllaybv', '0');
-- Veigh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0ykxasq9e94eexg', 'Veigh', '251@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfe49a8f4b6b1a82a29f43112','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:251@artist.com', '0ykxasq9e94eexg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0ykxasq9e94eexg', 'A unique voice in the contemporary music scene.', 'Veigh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('p4wmeswd9d3oxspx1x6nbf0fgr6ernfgnfrmunhrdn0h3076rv','0ykxasq9e94eexg', 'https://i.scdn.co/image/ab67616d0000b273ce0947b85c30490447dbbd91', 'Veigh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sjjgvjwtia4t95kfxbf42uah2to8yst99f896ds31ib279wq53','Novo Balan','0ykxasq9e94eexg',100,'POP','4hKLzFvNwHF6dPosGT30ed','https://p.scdn.co/mp3-preview/af031ca41aac7b60676833187f323d94fc387bce?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p4wmeswd9d3oxspx1x6nbf0fgr6ernfgnfrmunhrdn0h3076rv', 'sjjgvjwtia4t95kfxbf42uah2to8yst99f896ds31ib279wq53', '0');
-- sped up nightcore
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z8mdic1pd6emub7', 'sped up nightcore', '252@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebbf73929f8c684fed7af7e767','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:252@artist.com', 'z8mdic1pd6emub7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z8mdic1pd6emub7', 'A confluence of cultural beats and contemporary tunes.', 'sped up nightcore');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('02wuhgol1sd4yi8jcxd5zzcxfquu07j61uz2n4y9r6h6y0rtoh','z8mdic1pd6emub7', NULL, 'sped up nightcore Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p9el6aznx0rcpq79p8pqxh26jmk1wuom7crbt9c478f8vss9rg','Watch This - ARIZONATEARS Pluggnb Remix','z8mdic1pd6emub7',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('02wuhgol1sd4yi8jcxd5zzcxfquu07j61uz2n4y9r6h6y0rtoh', 'p9el6aznx0rcpq79p8pqxh26jmk1wuom7crbt9c478f8vss9rg', '0');
-- ROSAL
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mfx8lyj3m52ws2p', 'ROSAL', '253@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd7bb678bef6d2f26110cae49','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:253@artist.com', 'mfx8lyj3m52ws2p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mfx8lyj3m52ws2p', 'Breathing new life into classic genres.', 'ROSAL');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zyogairm3h53k9y9wiu2rzn4tqza0ma955t3nwl9tt8xnem1gp','mfx8lyj3m52ws2p', 'https://i.scdn.co/image/ab67616d0000b273efc0ef9dd996312ebaf0bf52', 'ROSAL Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zizwrm2qqvh9r15ie6e6nf2jb79ctqh2fuh4mpl7vsn51ebkil','DESPECH','mfx8lyj3m52ws2p',100,'POP','53tfEupEzQRtVFOeZvk7xq','https://p.scdn.co/mp3-preview/304868e078d8f2c3209977997c47542181096b61?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zyogairm3h53k9y9wiu2rzn4tqza0ma955t3nwl9tt8xnem1gp', 'zizwrm2qqvh9r15ie6e6nf2jb79ctqh2fuh4mpl7vsn51ebkil', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('76h09rvk2bd6eso4dsxxszi2seh25nv63mq16q64cbab8ikfez','LLYLM','mfx8lyj3m52ws2p',100,'POP','2SiAcexM2p1yX6joESbehd','https://p.scdn.co/mp3-preview/6f41063b2e36fb31fbd08c39b6c56012e239365b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zyogairm3h53k9y9wiu2rzn4tqza0ma955t3nwl9tt8xnem1gp', '76h09rvk2bd6eso4dsxxszi2seh25nv63mq16q64cbab8ikfez', '1');
-- Don Toliver
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('i6pi6u3udpfkxzv', 'Don Toliver', '254@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:254@artist.com', 'i6pi6u3udpfkxzv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('i6pi6u3udpfkxzv', 'A tapestry of rhythms that echo the pulse of life.', 'Don Toliver');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4w9bcjfz8doa8uj2h3mp5tjm9xt71ismc7hv10oze5ya97bty2','i6pi6u3udpfkxzv', 'https://i.scdn.co/image/ab67616d0000b273feeff698e6090e6b02f21ec0', 'Don Toliver Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8uuoxoyglwtvtm5y9v85qatpliv1p7hrw5hyuf296isu51im0m','Private Landing (feat. Justin Bieber & Future)','i6pi6u3udpfkxzv',100,'POP','52NGJPcLUzQq5w7uv4e5gf','https://p.scdn.co/mp3-preview/511bdf681359f3b57dfa25344f34c2b66ecc4326?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4w9bcjfz8doa8uj2h3mp5tjm9xt71ismc7hv10oze5ya97bty2', '8uuoxoyglwtvtm5y9v85qatpliv1p7hrw5hyuf296isu51im0m', '0');
-- Adele
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nb24upbk7lg1f7t', 'Adele', '255@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68f6e5892075d7f22615bd17','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:255@artist.com', 'nb24upbk7lg1f7t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nb24upbk7lg1f7t', 'Transcending language barriers through the universal language of music.', 'Adele');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8quvx95291t5npn4udo3henh0djz9thmpih8vj2ms1t0svm0u4','nb24upbk7lg1f7t', 'https://i.scdn.co/image/ab67616d0000b2732118bf9b198b05a95ded6300', 'Adele Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7a3d2e8ul5uy5shdmvfstakw57wkycmp5ev2678ubx2hd4gyxe','Set Fire to the Rain','nb24upbk7lg1f7t',100,'POP','73CMRj62VK8nUS4ezD2wvi','https://p.scdn.co/mp3-preview/6fc68c105e091645376471727960d2ba3cd0ee01?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8quvx95291t5npn4udo3henh0djz9thmpih8vj2ms1t0svm0u4', '7a3d2e8ul5uy5shdmvfstakw57wkycmp5ev2678ubx2hd4gyxe', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k90auvcub1ne7jenibdkxw08q5sluyu4xhq3x3tendx9m6xvit','Easy On Me','nb24upbk7lg1f7t',100,'POP','46IZ0fSY2mpAiktS3KOqds','https://p.scdn.co/mp3-preview/a0cd8077c79a4aa3dcaa68bbc5ecdeda46e8d13f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8quvx95291t5npn4udo3henh0djz9thmpih8vj2ms1t0svm0u4', 'k90auvcub1ne7jenibdkxw08q5sluyu4xhq3x3tendx9m6xvit', '1');
-- Doechii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('n9a9tg7vr0623t7', 'Doechii', '256@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5f9f729e1e5182fbf1030dbe','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:256@artist.com', 'n9a9tg7vr0623t7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('n9a9tg7vr0623t7', 'Breaking barriers with her unique sound and powerful lyrical storytelling.', 'Doechii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('iiu0cohpnbva1wf3oxm7px8slgggx4e856d6k6ut6g2cr3hvva','n9a9tg7vr0623t7', 'https://i.scdn.co/image/ab67616d0000b2732ee85751f6f503fa9a533eba', 'Doechii Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('twdm1nnfx4t4izw48srjmxvlvxd509sllnd26g7w313guxnnlb','What It Is (Solo Version)','n9a9tg7vr0623t7',100,'POP','73RbfOTJIjHzi2pcVHjeHM',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('iiu0cohpnbva1wf3oxm7px8slgggx4e856d6k6ut6g2cr3hvva', 'twdm1nnfx4t4izw48srjmxvlvxd509sllnd26g7w313guxnnlb', '0');
-- Dua Lipa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5urzusnbiynlx6i', 'Dua Lipa', '257@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1bbee4a02f85ecc58d385c3e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:257@artist.com', '5urzusnbiynlx6i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5urzusnbiynlx6i', 'A pop phenomenon, known for her empowering anthems and dynamic presence.', 'Dua Lipa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rmcd48b407j3o7ushttrnw0udlhinu80b69vodse8h8ngog34h','5urzusnbiynlx6i', 'https://i.scdn.co/image/ab67616d0000b2737dd3ba455ee3390cb55b0192', 'Dua Lipa Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e2wuzoics3zr5dvrhdgp7uklkltuldar642d2eq45fkiwxzxu0','Dance The Night (From Barbie The Album)','5urzusnbiynlx6i',100,'POP','1vYXt7VSjH9JIM5oRRo7vA','https://p.scdn.co/mp3-preview/acaea048f50a3b30ca24b348c84a6047373baabb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rmcd48b407j3o7ushttrnw0udlhinu80b69vodse8h8ngog34h', 'e2wuzoics3zr5dvrhdgp7uklkltuldar642d2eq45fkiwxzxu0', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l04rh3l8se9vhtpawptztn2uubv8csi8pvb4t26uhy3wczqvn7','Cold Heart - PNAU Remix','5urzusnbiynlx6i',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rmcd48b407j3o7ushttrnw0udlhinu80b69vodse8h8ngog34h', 'l04rh3l8se9vhtpawptztn2uubv8csi8pvb4t26uhy3wczqvn7', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kqrw1254ox5de66g8d78phe5wl0r6uzvflimh75vviaduexvpc','Dont Start Now','5urzusnbiynlx6i',100,'POP','3li9IOaMFu8S56r9uP6wcO','https://p.scdn.co/mp3-preview/cfc6684fc467e40bb9c7e6da2ea1b22eeccb211c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rmcd48b407j3o7ushttrnw0udlhinu80b69vodse8h8ngog34h', 'kqrw1254ox5de66g8d78phe5wl0r6uzvflimh75vviaduexvpc', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dyyg7bq5u8x4vxubjpn4oplu71xq95u1o1maceuxme58fa2vzl','Levitating (feat. DaBaby)','5urzusnbiynlx6i',100,'POP','5nujrmhLynf4yMoMtj8AQF','https://p.scdn.co/mp3-preview/6af6db91dba9103cca41d6d5225f6fe120fcfcd3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rmcd48b407j3o7ushttrnw0udlhinu80b69vodse8h8ngog34h', 'dyyg7bq5u8x4vxubjpn4oplu71xq95u1o1maceuxme58fa2vzl', '3');
-- Kate Bush
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1ppg3c6ck0ahyh0', 'Kate Bush', '258@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb187017724e58e78ee1f5a8e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:258@artist.com', '1ppg3c6ck0ahyh0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1ppg3c6ck0ahyh0', 'Where words fail, my music speaks.', 'Kate Bush');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0p9vjsoqhifod851wjbee3cwebh6l42in97ohok76dfeia7ayn','1ppg3c6ck0ahyh0', 'https://i.scdn.co/image/ab67616d0000b273ad08f4b38efbff0c0da0f252', 'Kate Bush Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gpzf4g8f9jseq6c0pevp86s6slb3vaav5oa70hazmsa4b6kkmo','Running Up That Hill (A Deal With God)','1ppg3c6ck0ahyh0',100,'POP','1PtQJZVZIdWIYdARpZRDFO','https://p.scdn.co/mp3-preview/861d26b52ece3e3ad72a7dc3463daece3478801a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0p9vjsoqhifod851wjbee3cwebh6l42in97ohok76dfeia7ayn', 'gpzf4g8f9jseq6c0pevp86s6slb3vaav5oa70hazmsa4b6kkmo', '0');
-- Marlia Mendo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qzrt9zmlaat0fv3', 'Marlia Mendo', '259@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebffaebdbc972967729f688e25','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:259@artist.com', 'qzrt9zmlaat0fv3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qzrt9zmlaat0fv3', 'The heartbeat of a new generation of music lovers.', 'Marlia Mendo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3y2j6mnbgy7slcqgjys1phyaw2e8tthgcsm089d5wqnbdtrj1o','qzrt9zmlaat0fv3', NULL, 'Marlia Mendo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0yp3blhfztbon3u0eejgv2wq426kh014ak2stna7lzmqnkk6ay','Le','qzrt9zmlaat0fv3',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3y2j6mnbgy7slcqgjys1phyaw2e8tthgcsm089d5wqnbdtrj1o', '0yp3blhfztbon3u0eejgv2wq426kh014ak2stna7lzmqnkk6ay', '0');
-- Peso Pluma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ukhdpzrfbv688g8', 'Peso Pluma', '260@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:260@artist.com', 'ukhdpzrfbv688g8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ukhdpzrfbv688g8', 'Infusing music with energetic beats and captivating lyrics.', 'Peso Pluma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g4xligwn5ia9shxvj29ca9u7cshfxrcxwdxlj5povqepjhu60q','ukhdpzrfbv688g8', NULL, 'Peso Pluma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('srhnzpogzrnwwur9w1oxf9qskvj6e2n8nmlvc1rmm1f811a3bp','La Bebe - Remix','ukhdpzrfbv688g8',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g4xligwn5ia9shxvj29ca9u7cshfxrcxwdxlj5povqepjhu60q', 'srhnzpogzrnwwur9w1oxf9qskvj6e2n8nmlvc1rmm1f811a3bp', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xl1om16agjdwfuigpdblhuri6aklxueu075i60idgwxv4bzzr6','TULUM','ukhdpzrfbv688g8',100,'POP','7bPp2NmpmyhLJ7zWazAXMu','https://p.scdn.co/mp3-preview/164468e67b8da8053036c68533ffa473ab680c51?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g4xligwn5ia9shxvj29ca9u7cshfxrcxwdxlj5povqepjhu60q', 'xl1om16agjdwfuigpdblhuri6aklxueu075i60idgwxv4bzzr6', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r29fa1rvwb0m1e2r4o0vbhp3t5b9jgaeccopsboysvldd12igb','Por las Noches','ukhdpzrfbv688g8',100,'POP','2VzCjpKvPB1l1tqLndtAQa','https://p.scdn.co/mp3-preview/ba2f667c373e2d12343ac00b162886caca060c93?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g4xligwn5ia9shxvj29ca9u7cshfxrcxwdxlj5povqepjhu60q', 'r29fa1rvwb0m1e2r4o0vbhp3t5b9jgaeccopsboysvldd12igb', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t5cndu4b61iu9p1xgsqqjfqetr1mowzv0izrp7gq17i5kklkyd','Bye','ukhdpzrfbv688g8',100,'POP','6n2P81rPk2RTzwnNNgFOdb','https://p.scdn.co/mp3-preview/94ef6a9f37e088fff4b37e098a46561e74dab95b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g4xligwn5ia9shxvj29ca9u7cshfxrcxwdxlj5povqepjhu60q', 't5cndu4b61iu9p1xgsqqjfqetr1mowzv0izrp7gq17i5kklkyd', '3');
-- Jasiel Nuez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('by0893t04kg55v7', 'Jasiel Nuez', '261@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:261@artist.com', 'by0893t04kg55v7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('by0893t04kg55v7', 'Melodies that capture the essence of human emotion.', 'Jasiel Nuez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j51cnkgwipfb3ujiiq97zb4ypk7h8wn17kaak9ktvzkqyhd0w5','by0893t04kg55v7', NULL, 'Jasiel Nuez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kfe5x3pwmm5onayipuo3p1g08x922wkdx18fwls9kxxu0ajlk5','LAGUNAS','by0893t04kg55v7',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j51cnkgwipfb3ujiiq97zb4ypk7h8wn17kaak9ktvzkqyhd0w5', 'kfe5x3pwmm5onayipuo3p1g08x922wkdx18fwls9kxxu0ajlk5', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nysz493q20l138w5wuimm607ydhvuki3kn6f7t80velfl2yewz','Rosa Pastel','by0893t04kg55v7',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j51cnkgwipfb3ujiiq97zb4ypk7h8wn17kaak9ktvzkqyhd0w5', 'nysz493q20l138w5wuimm607ydhvuki3kn6f7t80velfl2yewz', '1');
-- dennis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('71d88pbharemxxi', 'dennis', '262@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8a1ec9781a1542458b3b961b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:262@artist.com', '71d88pbharemxxi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('71d88pbharemxxi', 'A voice that echoes the sentiments of a generation.', 'dennis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3bnxjmvkg30rqwek5pl6eq0fv5eohoczo12fdevfprewsteh89','71d88pbharemxxi', 'https://i.scdn.co/image/ab67616d0000b273ddfc406de0d7dbc2e339f016', 'dennis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('09f9xxgz783b8161jt11t00t3qenwvnerq9ew8q2rx54d0c5ip','T','71d88pbharemxxi',100,'POP','35FW5OEe4p38LdjK1KqT2X','https://p.scdn.co/mp3-preview/eaa522f48564e43e33e00c011aef0489526d1072?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3bnxjmvkg30rqwek5pl6eq0fv5eohoczo12fdevfprewsteh89', '09f9xxgz783b8161jt11t00t3qenwvnerq9ew8q2rx54d0c5ip', '0');
-- Cigarettes After Sex
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yj3d5fofjcojjfl', 'Cigarettes After Sex', '263@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb41a26ad71de86acf45dc886','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:263@artist.com', 'yj3d5fofjcojjfl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yj3d5fofjcojjfl', 'Elevating the ordinary to extraordinary through music.', 'Cigarettes After Sex');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pxipeki8o8fstl0uyjskt9ub27faw734hmsbvzjjyqc805hu7d','yj3d5fofjcojjfl', 'https://i.scdn.co/image/ab67616d0000b27312b69bf576f5e80291f75161', 'Cigarettes After Sex Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ltv2a60m7v2r8ojkjkx6k722qc64vkr9fqqcp5a5sy1fcv6wvs','Apocalypse','yj3d5fofjcojjfl',100,'POP','0yc6Gst2xkRu0eMLeRMGCX','https://p.scdn.co/mp3-preview/1f89f0156113dfb87572382b531459bb8cb711a1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pxipeki8o8fstl0uyjskt9ub27faw734hmsbvzjjyqc805hu7d', 'ltv2a60m7v2r8ojkjkx6k722qc64vkr9fqqcp5a5sy1fcv6wvs', '0');
-- James Hype
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c6fdvw1y9zk8urw', 'James Hype', '264@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3735de17f641144240511000','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:264@artist.com', 'c6fdvw1y9zk8urw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c6fdvw1y9zk8urw', 'Elevating the ordinary to extraordinary through music.', 'James Hype');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7pgawqwv9pkq3dsko4vhu9ocjachxpbeg4eq5ezcg9op6ho8ui','c6fdvw1y9zk8urw', 'https://i.scdn.co/image/ab67616d0000b2736cc861b5c9c7cdef61b010b4', 'James Hype Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jcmmpfu5ne94pupmtanv2p1nuikzczjtyyr3aul2gmom6ieuct','Ferrari','c6fdvw1y9zk8urw',100,'POP','4zN21mbAuaD0WqtmaTZZeP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7pgawqwv9pkq3dsko4vhu9ocjachxpbeg4eq5ezcg9op6ho8ui', 'jcmmpfu5ne94pupmtanv2p1nuikzczjtyyr3aul2gmom6ieuct', '0');
-- Kodak Black
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wovgzzk66nw8wdo', 'Kodak Black', '265@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb70c05cf4dc9a7d3ffd02ba19','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:265@artist.com', 'wovgzzk66nw8wdo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wovgzzk66nw8wdo', 'A unique voice in the contemporary music scene.', 'Kodak Black');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nafljaqo55155nx7gsh208zrtkavumm89hl18p0l951b5pf2dq','wovgzzk66nw8wdo', 'https://i.scdn.co/image/ab67616d0000b273445afb6341d2685b959251cc', 'Kodak Black Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vmovsslaqe3vq84xaoqi4595filj79n8yrd1xfox985qy5lc4l','Angel Pt 1 (feat. Jimin of BTS, JVKE & Muni Long)','wovgzzk66nw8wdo',100,'POP','1vvcEHQdaUTvWt0EIUYcFK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nafljaqo55155nx7gsh208zrtkavumm89hl18p0l951b5pf2dq', 'vmovsslaqe3vq84xaoqi4595filj79n8yrd1xfox985qy5lc4l', '0');
-- Loreen
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1nl5gkib80qfa1h', 'Loreen', '266@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3ca2710f45c2993c415a1c5e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:266@artist.com', '1nl5gkib80qfa1h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1nl5gkib80qfa1h', 'Delivering soul-stirring tunes that linger in the mind.', 'Loreen');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6ko3akta4tju23fjdyx9ko777rz0j39o9duddqa80x245hvtt0','1nl5gkib80qfa1h', 'https://i.scdn.co/image/ab67616d0000b2732b0ba87db609976eee193bd6', 'Loreen Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k3qrzqun5vamv70i7rx5m0hgng0cjwmzpcnsgau4ga5ouno30y','Tattoo','1nl5gkib80qfa1h',100,'POP','1DmW5Ep6ywYwxc2HMT5BG6',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6ko3akta4tju23fjdyx9ko777rz0j39o9duddqa80x245hvtt0', 'k3qrzqun5vamv70i7rx5m0hgng0cjwmzpcnsgau4ga5ouno30y', '0');
-- Morgan Wallen
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ye6kefszrduhgbp', 'Morgan Wallen', '267@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21ed0100a3a4e5aa3c57f6dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:267@artist.com', 'ye6kefszrduhgbp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ye6kefszrduhgbp', 'Blending country charm with rock energy to create memorable tunes.', 'Morgan Wallen');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ocmtuc7lavci4a4shnmc20964kmb1sdcvt7w4ciq4zdkmsygid','ye6kefszrduhgbp', 'https://i.scdn.co/image/ab67616d0000b273705079df9a25a28b452c1fc9', 'Morgan Wallen Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2janrnd2318mmdcz5gtjzrcbidr40s82vsuxwgzm9ww1ux1uvv','Last Night','ye6kefszrduhgbp',100,'POP','7K3BhSpAxZBznislvUMVtn',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocmtuc7lavci4a4shnmc20964kmb1sdcvt7w4ciq4zdkmsygid', '2janrnd2318mmdcz5gtjzrcbidr40s82vsuxwgzm9ww1ux1uvv', '0');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6qw6vg9tvkkng23lkysntndw29npblajqcv314aqbxov9jad7g','You Proof','ye6kefszrduhgbp',100,'POP','5W4kiM2cUYBJXKRudNyxjW',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocmtuc7lavci4a4shnmc20964kmb1sdcvt7w4ciq4zdkmsygid', '6qw6vg9tvkkng23lkysntndw29npblajqcv314aqbxov9jad7g', '1');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('csfesfvk3phyw9n8wbpnmiyz3k6d55zb46zv4k08b9qbgmu84u','One Thing At A Time','ye6kefszrduhgbp',100,'POP','1rXq0uoV4KTgRN64jXzIxo',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocmtuc7lavci4a4shnmc20964kmb1sdcvt7w4ciq4zdkmsygid', 'csfesfvk3phyw9n8wbpnmiyz3k6d55zb46zv4k08b9qbgmu84u', '2');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z4up2xj3gjslzp63btvn5p7jrzisc3le7ov6w161k9dpadd0q2','Aint Tha','ye6kefszrduhgbp',100,'POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocmtuc7lavci4a4shnmc20964kmb1sdcvt7w4ciq4zdkmsygid', 'z4up2xj3gjslzp63btvn5p7jrzisc3le7ov6w161k9dpadd0q2', '3');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8fh9dc8quom2koo6z2wfp5s3sq7zxb9hq77hno6dewcaedwyu5','Thinkin B','ye6kefszrduhgbp',100,'POP','0PAcdVzhPO4gq1Iym9ESnK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocmtuc7lavci4a4shnmc20964kmb1sdcvt7w4ciq4zdkmsygid', '8fh9dc8quom2koo6z2wfp5s3sq7zxb9hq77hno6dewcaedwyu5', '4');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9qpfnet210bc64mt259xm8v7y68wbq60nj3s1zpl09yn6umnks','Everything I Love','ye6kefszrduhgbp',100,'POP','03fs6oV5JAlbytRYf3371S',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocmtuc7lavci4a4shnmc20964kmb1sdcvt7w4ciq4zdkmsygid', '9qpfnet210bc64mt259xm8v7y68wbq60nj3s1zpl09yn6umnks', '5');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('volguuxk3o5sqirsbhbug2s2j8o2ag9yzb3be8rntdpyup8s59','I Wrote The Book','ye6kefszrduhgbp',100,'POP','7phmBo7bB9I9YifAXqnlqV',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocmtuc7lavci4a4shnmc20964kmb1sdcvt7w4ciq4zdkmsygid', 'volguuxk3o5sqirsbhbug2s2j8o2ag9yzb3be8rntdpyup8s59', '6');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lm7fhqtixq41lw41rgqbyyl1iaou0u93l2203g84r8rerg1bep','Man Made A Bar (feat. Eric Church)','ye6kefszrduhgbp',100,'POP','73zawW1ttszLRgT9By826D',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocmtuc7lavci4a4shnmc20964kmb1sdcvt7w4ciq4zdkmsygid', 'lm7fhqtixq41lw41rgqbyyl1iaou0u93l2203g84r8rerg1bep', '7');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hy3tuiy70m32e4bxkw7pi5i1rqryznu6eprl9s0r2rskn9r2ul','98 Braves','ye6kefszrduhgbp',100,'POP','3oZ6dlSfCE9gZ55MGPJctc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocmtuc7lavci4a4shnmc20964kmb1sdcvt7w4ciq4zdkmsygid', 'hy3tuiy70m32e4bxkw7pi5i1rqryznu6eprl9s0r2rskn9r2ul', '8');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('thlt7i6epckbni8cm3rv8p6ytfwbyxhryhd8imgyub599x60qf','Thought You Should Know','ye6kefszrduhgbp',100,'POP','3Qu3Zh4WTKhP9GEXo0aDnb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocmtuc7lavci4a4shnmc20964kmb1sdcvt7w4ciq4zdkmsygid', 'thlt7i6epckbni8cm3rv8p6ytfwbyxhryhd8imgyub599x60qf', '9');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tx8d5fsy2z6cv9o1f3auip3na53l0rpcrjuqpy7u8enqvtl09x','Born With A Beer In My Hand','ye6kefszrduhgbp',100,'POP','1BAU6v0fuAV914qMUEESR1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocmtuc7lavci4a4shnmc20964kmb1sdcvt7w4ciq4zdkmsygid', 'tx8d5fsy2z6cv9o1f3auip3na53l0rpcrjuqpy7u8enqvtl09x', '10');
INSERT INTO "song" ("id", "name", "artist_id","duration", "genre", "spotify_id", "preview_url", "created_at") VALUES ('si5ueo79azb98jlb6rgqc4pojxbqvptqskqb9pjy1jm4p31v3q','Devil Don','ye6kefszrduhgbp',100,'POP','2PsbT927UanvyH9VprlNOu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ocmtuc7lavci4a4shnmc20964kmb1sdcvt7w4ciq4zdkmsygid', 'si5ueo79azb98jlb6rgqc4pojxbqvptqskqb9pjy1jm4p31v3q', '11');


-- File: insert_relationships.sql
-- Users
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mld5rxkd2j73m1q', 'George Williams (0)', '0@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:0@g.com', 'mld5rxkd2j73m1q', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jqoril33u6f9uhl', 'Charlie Johnson (1)', '1@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:1@g.com', 'jqoril33u6f9uhl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d27m312nasvba0x', 'Julia Brown (2)', '2@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:2@g.com', 'd27m312nasvba0x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wz3cozcoswqffgg', 'Ivan Williams (3)', '3@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:3@g.com', 'wz3cozcoswqffgg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('i030nuhilwui5lg', 'George Rodriguez (4)', '4@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:4@g.com', 'i030nuhilwui5lg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z7yl86xj1oco37b', 'Edward Garcia (5)', '5@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:5@g.com', 'z7yl86xj1oco37b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2bj3cst7q9mzemf', 'Julia Rodriguez (6)', '6@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:6@g.com', '2bj3cst7q9mzemf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3txkonm6fne60in', 'Ivan Brown (7)', '7@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:7@g.com', '3txkonm6fne60in', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('77yfufw765qzng0', 'Bob Jones (8)', '8@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:8@g.com', '77yfufw765qzng0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('36sbvefc6n81dl1', 'Alice Martinez (9)', '9@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:9@g.com', '36sbvefc6n81dl1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
-- Playlists
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('597xgcad6e0h34keryvcmyjhm6u2c80phqfaco94im0sxv4uxr', 'Playlist 0', '2023-11-17 17:00:08.000','mld5rxkd2j73m1q');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('s36i4dlp8mrevpox7w4a0y3almx4r6zrdb42c0sgipze44zr26', '597xgcad6e0h34keryvcmyjhm6u2c80phqfaco94im0sxv4uxr', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cegirfxxg7qpkhe6jukvjfqi8cc183fc1c6bdzpwed3fjvm241', '597xgcad6e0h34keryvcmyjhm6u2c80phqfaco94im0sxv4uxr', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('639zdlxl0spjwjoihvjxz06zlr7tnphxq7gb6vm1detsgcjtk8', '597xgcad6e0h34keryvcmyjhm6u2c80phqfaco94im0sxv4uxr', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jc61bmm3bp1yvv75i5i4z501qv59olbjcjppiavgahnegn06mo', '597xgcad6e0h34keryvcmyjhm6u2c80phqfaco94im0sxv4uxr', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0slqhag1rksleo9rgbjouv8qa454f9q3p029jay1hnhujl7i30', '597xgcad6e0h34keryvcmyjhm6u2c80phqfaco94im0sxv4uxr', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1ybzqqwgccwfy7xpwd3bjpso1d0ldtvgwkxf4m9hgry2w8l91v', '597xgcad6e0h34keryvcmyjhm6u2c80phqfaco94im0sxv4uxr', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('l5z6dz00vmnhpce52779xf9aid0lyjzunu812am749fqp4ph4u', '597xgcad6e0h34keryvcmyjhm6u2c80phqfaco94im0sxv4uxr', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('aravmemwy8cwa2a9f7sg7vuptwjtqolgxglowyxvcycv2vgld4', '597xgcad6e0h34keryvcmyjhm6u2c80phqfaco94im0sxv4uxr', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('q5u9466gzc103stlhov78f3cgk7r10b9mpipxwuu4tw0qiy3me', '597xgcad6e0h34keryvcmyjhm6u2c80phqfaco94im0sxv4uxr', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('l04rh3l8se9vhtpawptztn2uubv8csi8pvb4t26uhy3wczqvn7', '597xgcad6e0h34keryvcmyjhm6u2c80phqfaco94im0sxv4uxr', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('2u9tize4i42uopzt7g0t9jc1bvnh4izxyswl8qyfyvznm39fq5', 'Playlist 1', '2023-11-17 17:00:08.000','mld5rxkd2j73m1q');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bl7ym13fectxh8kq5n46gi9spv18lifrec2xsnndkr7c8zqi29', '2u9tize4i42uopzt7g0t9jc1bvnh4izxyswl8qyfyvznm39fq5', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qz7b1cw8pnwz67529bzdx82y4d35s5un0vk9j9srze4tz2ldna', '2u9tize4i42uopzt7g0t9jc1bvnh4izxyswl8qyfyvznm39fq5', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3sdaw1oekjsq5altj47ja83ngcxxqhs9zwvm30nsr06v6lnnsu', '2u9tize4i42uopzt7g0t9jc1bvnh4izxyswl8qyfyvznm39fq5', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zth6iodv9uih2h9j0ln55a7k84wz4eq4lobtiofb7zzekq3b76', '2u9tize4i42uopzt7g0t9jc1bvnh4izxyswl8qyfyvznm39fq5', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('916tg383filkhsfpnewdtk5jwgwmaoc4qcuz21fl0melymvi2p', '2u9tize4i42uopzt7g0t9jc1bvnh4izxyswl8qyfyvznm39fq5', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7o7j1kfhm82rmoy69372s0h8kruups1qwqs42dso4n2gpqz8au', '2u9tize4i42uopzt7g0t9jc1bvnh4izxyswl8qyfyvznm39fq5', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('77sf3zsrhd61hfsbiw4uazwrnwahukn6r5b4gg4c5vk0amkwi3', '2u9tize4i42uopzt7g0t9jc1bvnh4izxyswl8qyfyvznm39fq5', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d118xaucgml9bcjftu84yamqqkosjlj2n72z90kj2gct347g4v', '2u9tize4i42uopzt7g0t9jc1bvnh4izxyswl8qyfyvznm39fq5', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wpd3wy6k2dxenvrdljtxo9afsh48m4ii6a2o2ty7p3j0w31l96', '2u9tize4i42uopzt7g0t9jc1bvnh4izxyswl8qyfyvznm39fq5', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cegirfxxg7qpkhe6jukvjfqi8cc183fc1c6bdzpwed3fjvm241', '2u9tize4i42uopzt7g0t9jc1bvnh4izxyswl8qyfyvznm39fq5', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('fe32xjxx26wpbgvac7bb70kkyryn3zvyey4arwrbre22snmgo1', 'Playlist 0', '2023-11-17 17:00:08.000','jqoril33u6f9uhl');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('14rgbrq69h3n6bfgxy3ntwugqv1ndfuthtrpgs8o8ppis4lkj7', 'fe32xjxx26wpbgvac7bb70kkyryn3zvyey4arwrbre22snmgo1', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bkbvjjetwhdb9s8jfkh87gp8wr1posq96z5c8nwln556qtbqv0', 'fe32xjxx26wpbgvac7bb70kkyryn3zvyey4arwrbre22snmgo1', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2y03zdjbjhc6ll58nz33jr0r5wlmtfw81ucyaoyevbzdb5698c', 'fe32xjxx26wpbgvac7bb70kkyryn3zvyey4arwrbre22snmgo1', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1jy5tilsg618zranmtb4tld0wurdyfex491r7mpkgug2rdb3ug', 'fe32xjxx26wpbgvac7bb70kkyryn3zvyey4arwrbre22snmgo1', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6hajelcle6sd5e9886dklzny2j3zr15wvk6x5pdxkx3h5wtunt', 'fe32xjxx26wpbgvac7bb70kkyryn3zvyey4arwrbre22snmgo1', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6gmwqxwerx6b243y5y0pjuyixmf297g2t8lcs42kgk2k0bfriv', 'fe32xjxx26wpbgvac7bb70kkyryn3zvyey4arwrbre22snmgo1', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('rcle0a9vsf8cpr2j6238t3i94niuwugiknt2v9gn4ah4gcea1i', 'fe32xjxx26wpbgvac7bb70kkyryn3zvyey4arwrbre22snmgo1', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vmovsslaqe3vq84xaoqi4595filj79n8yrd1xfox985qy5lc4l', 'fe32xjxx26wpbgvac7bb70kkyryn3zvyey4arwrbre22snmgo1', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7ful4a18i9a09uaq6s477ejhgoh8ty9xlcrraedrcxbna5qbi6', 'fe32xjxx26wpbgvac7bb70kkyryn3zvyey4arwrbre22snmgo1', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xv91mb96lbrwuezfzfheqw2oqv8tr2hnq28uffbxp2ea0xe2tn', 'fe32xjxx26wpbgvac7bb70kkyryn3zvyey4arwrbre22snmgo1', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('k5msi9ucs3wp99n7n4z8gw1zki2ydijcgo20vtbxma1pgxqsyn', 'Playlist 1', '2023-11-17 17:00:08.000','jqoril33u6f9uhl');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jpwwd86xbrljnipqrm45n45nl3w0q3odrlbpzrgryf05f93bl5', 'k5msi9ucs3wp99n7n4z8gw1zki2ydijcgo20vtbxma1pgxqsyn', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9xfejuopoczduvu22lvb0sp9s80fud5fzmtpjelsdp0v0d3djn', 'k5msi9ucs3wp99n7n4z8gw1zki2ydijcgo20vtbxma1pgxqsyn', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('si7ssjwf8vim9xfmhykc7svy81b6aa6yrqccg4ijmtgypd1c97', 'k5msi9ucs3wp99n7n4z8gw1zki2ydijcgo20vtbxma1pgxqsyn', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('96t3zmjy8wjte0cc4du1c75neczhj5fuydbizo6ihm4mry1hot', 'k5msi9ucs3wp99n7n4z8gw1zki2ydijcgo20vtbxma1pgxqsyn', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('s36i4dlp8mrevpox7w4a0y3almx4r6zrdb42c0sgipze44zr26', 'k5msi9ucs3wp99n7n4z8gw1zki2ydijcgo20vtbxma1pgxqsyn', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m5a5pnmc24wdblfb7mf22sossxvnn5yxo87egn1e09t4ur2beb', 'k5msi9ucs3wp99n7n4z8gw1zki2ydijcgo20vtbxma1pgxqsyn', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('rfnovptrx8xnyi66uxk1s97gua2kcchq4icl99ma6d9b0je1jg', 'k5msi9ucs3wp99n7n4z8gw1zki2ydijcgo20vtbxma1pgxqsyn', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('924hs4kib0ci4e57c1zw446sa5ib3ea65j2lu11txqvub8vjc5', 'k5msi9ucs3wp99n7n4z8gw1zki2ydijcgo20vtbxma1pgxqsyn', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tx8d5fsy2z6cv9o1f3auip3na53l0rpcrjuqpy7u8enqvtl09x', 'k5msi9ucs3wp99n7n4z8gw1zki2ydijcgo20vtbxma1pgxqsyn', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('crfvvo5w0lf8qymtkigcpridv0g5p6i0w5ggl60a3z5yvkna2p', 'k5msi9ucs3wp99n7n4z8gw1zki2ydijcgo20vtbxma1pgxqsyn', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('tcysfdcumetiq2phl7xw18mlzy3sdhuzks5sxy32rchdxie2k9', 'Playlist 0', '2023-11-17 17:00:08.000','d27m312nasvba0x');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('86xk68rnp1pgguedjjji6g7l965wahns7bnvdbh3j13le9z54v', 'tcysfdcumetiq2phl7xw18mlzy3sdhuzks5sxy32rchdxie2k9', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xs9bzesr6l6qg5teuhvfsu4ujjezsjnlm0vsnuhscucfogsrlu', 'tcysfdcumetiq2phl7xw18mlzy3sdhuzks5sxy32rchdxie2k9', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mjmyi1zslpczq2r09a0wbzvqp30wccxqb2elepr3ngmsdcfkve', 'tcysfdcumetiq2phl7xw18mlzy3sdhuzks5sxy32rchdxie2k9', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t4ierh0d8jtbjkkeabpsre1sdns0n7jb9udrtfm0zj3y0z5aqz', 'tcysfdcumetiq2phl7xw18mlzy3sdhuzks5sxy32rchdxie2k9', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d7u75kgmqbcm3laozoamkizl8t3jxmmrrkwd8f1sry4m2u5atx', 'tcysfdcumetiq2phl7xw18mlzy3sdhuzks5sxy32rchdxie2k9', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8uuoxoyglwtvtm5y9v85qatpliv1p7hrw5hyuf296isu51im0m', 'tcysfdcumetiq2phl7xw18mlzy3sdhuzks5sxy32rchdxie2k9', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4bk1ibs191da0pf40txj2cgybk44nbu7o7gn8ipomaymqww0or', 'tcysfdcumetiq2phl7xw18mlzy3sdhuzks5sxy32rchdxie2k9', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('96t3zmjy8wjte0cc4du1c75neczhj5fuydbizo6ihm4mry1hot', 'tcysfdcumetiq2phl7xw18mlzy3sdhuzks5sxy32rchdxie2k9', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cueyiz3joy0pcbjo3jl669vl4ku6ed4wetjatrntv74aaudjw1', 'tcysfdcumetiq2phl7xw18mlzy3sdhuzks5sxy32rchdxie2k9', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('grvn57rm81nzwyjowaqn4spz52pzmltaptf2tpgce3amyi48gr', 'tcysfdcumetiq2phl7xw18mlzy3sdhuzks5sxy32rchdxie2k9', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('qu3wj13fea7n2zq61i8yn2ieobgn5g3irdys2i0qgo6k30aj3h', 'Playlist 1', '2023-11-17 17:00:08.000','d27m312nasvba0x');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dln3c8mmerriaortduzr753r9vbi595b2ytvgpwml1zy5hakah', 'qu3wj13fea7n2zq61i8yn2ieobgn5g3irdys2i0qgo6k30aj3h', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xtruqnoyox0elje83gbkiwl1gklrxti6gkee79h5oq1qiyaws6', 'qu3wj13fea7n2zq61i8yn2ieobgn5g3irdys2i0qgo6k30aj3h', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qz7b1cw8pnwz67529bzdx82y4d35s5un0vk9j9srze4tz2ldna', 'qu3wj13fea7n2zq61i8yn2ieobgn5g3irdys2i0qgo6k30aj3h', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0hgirrv0y6j83yq6lnglvlll4ndyz3kz9gd62kik2lxvwe9t1b', 'qu3wj13fea7n2zq61i8yn2ieobgn5g3irdys2i0qgo6k30aj3h', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('by1thi8m0pqji19kvkhhuoerq4klgsr25apnj2wgvbj2eey6jk', 'qu3wj13fea7n2zq61i8yn2ieobgn5g3irdys2i0qgo6k30aj3h', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r7aunhyxhqdjc1d318r0y08i6ib20r37u1xsk6eq2kdvk6uye1', 'qu3wj13fea7n2zq61i8yn2ieobgn5g3irdys2i0qgo6k30aj3h', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('14rgbrq69h3n6bfgxy3ntwugqv1ndfuthtrpgs8o8ppis4lkj7', 'qu3wj13fea7n2zq61i8yn2ieobgn5g3irdys2i0qgo6k30aj3h', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gpzf4g8f9jseq6c0pevp86s6slb3vaav5oa70hazmsa4b6kkmo', 'qu3wj13fea7n2zq61i8yn2ieobgn5g3irdys2i0qgo6k30aj3h', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3tmu73d70iclbyqv9xb95vajz3u7ybzjdcox4ecqkbvbo6ymr7', 'qu3wj13fea7n2zq61i8yn2ieobgn5g3irdys2i0qgo6k30aj3h', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dhr6dxkh9nwouw0p7rx5gh5xwlivnzqebi288sf4hvtwo7pebc', 'qu3wj13fea7n2zq61i8yn2ieobgn5g3irdys2i0qgo6k30aj3h', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('k8eh3sd4lzpgopnmaucro5gvrlh6o25u10qyi05zcw8uap07ed', 'Playlist 0', '2023-11-17 17:00:08.000','wz3cozcoswqffgg');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wvv7jpjx1nrmzm6ufhvquxtpojsc1iaq1bdfssjk07v7po7zmv', 'k8eh3sd4lzpgopnmaucro5gvrlh6o25u10qyi05zcw8uap07ed', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('llj5u3xw7i6jymyzorvu3ow11ckd2ishuga7s3wrmbpp5jm0wr', 'k8eh3sd4lzpgopnmaucro5gvrlh6o25u10qyi05zcw8uap07ed', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('27m05z1cysbe6gqb3en13s9swlv4l8x02q7ggeku26q0yv0v2p', 'k8eh3sd4lzpgopnmaucro5gvrlh6o25u10qyi05zcw8uap07ed', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wl1gqk803nl8akblxeayuz6awofaj59lr83g5ivh43qq48h33w', 'k8eh3sd4lzpgopnmaucro5gvrlh6o25u10qyi05zcw8uap07ed', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ekzofjul099aa5u1oj7edpi3z1pdlhzs61t67vgg7mioxl6020', 'k8eh3sd4lzpgopnmaucro5gvrlh6o25u10qyi05zcw8uap07ed', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mbs10njl57sk35mswp7jt5niht9b3u7sdfs9x84glnx0sghw7u', 'k8eh3sd4lzpgopnmaucro5gvrlh6o25u10qyi05zcw8uap07ed', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wpd3wy6k2dxenvrdljtxo9afsh48m4ii6a2o2ty7p3j0w31l96', 'k8eh3sd4lzpgopnmaucro5gvrlh6o25u10qyi05zcw8uap07ed', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ooolb9585c4283qj0q8nouy6sejxa476zfcbj9j5z0t16k8z5x', 'k8eh3sd4lzpgopnmaucro5gvrlh6o25u10qyi05zcw8uap07ed', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4n5r6gt7af6hbuf61d5kouty5bmuh4xjv9g76zaep071wpqqfg', 'k8eh3sd4lzpgopnmaucro5gvrlh6o25u10qyi05zcw8uap07ed', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jl9khefzjs2lsfv186szzrpu5gwgc89c0791yk31u277vi4m7q', 'k8eh3sd4lzpgopnmaucro5gvrlh6o25u10qyi05zcw8uap07ed', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('w9a9cexioqkuqnhy0l3wtve02w10g4hriy0g1dzs6ai6jkog58', 'Playlist 1', '2023-11-17 17:00:08.000','wz3cozcoswqffgg');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('12iqqw778uju49vdbcbyi3mfm4vih67xtv9nvwxokzpm1ykgqz', 'w9a9cexioqkuqnhy0l3wtve02w10g4hriy0g1dzs6ai6jkog58', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('tei3biod3oz43yxsd8p7ldcouanyx9n2pgz4pummj98vzyakne', 'w9a9cexioqkuqnhy0l3wtve02w10g4hriy0g1dzs6ai6jkog58', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7uawvdth7x41pdztnaa2dy8rbunme94xiqv8wetypd3lw3bmlr', 'w9a9cexioqkuqnhy0l3wtve02w10g4hriy0g1dzs6ai6jkog58', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pcbd26ihu4mv0jz5p2fo124thfoxpcajarkgno3w3qj286ugfe', 'w9a9cexioqkuqnhy0l3wtve02w10g4hriy0g1dzs6ai6jkog58', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('grvn57rm81nzwyjowaqn4spz52pzmltaptf2tpgce3amyi48gr', 'w9a9cexioqkuqnhy0l3wtve02w10g4hriy0g1dzs6ai6jkog58', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('g2gyk843jggmdc339fbcjca8mb6co0rn1v7sqiuigjvhj23qdm', 'w9a9cexioqkuqnhy0l3wtve02w10g4hriy0g1dzs6ai6jkog58', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dyyg7bq5u8x4vxubjpn4oplu71xq95u1o1maceuxme58fa2vzl', 'w9a9cexioqkuqnhy0l3wtve02w10g4hriy0g1dzs6ai6jkog58', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1m3fw47btej14hhz5yh44a3e6fu2io3vy8fk67oejehmgc516w', 'w9a9cexioqkuqnhy0l3wtve02w10g4hriy0g1dzs6ai6jkog58', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6vnlcm9spyg7ej67mqi07566mfrff82vxe6rwbvali3x971uu6', 'w9a9cexioqkuqnhy0l3wtve02w10g4hriy0g1dzs6ai6jkog58', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0gtrdunjfbbdjcqzz0zc69cku2h4ddue7o66xvby30b8d6qp3t', 'w9a9cexioqkuqnhy0l3wtve02w10g4hriy0g1dzs6ai6jkog58', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('dcf27keselz2i05yrn56yo92kp1y3kwqummpygncm1dgy71uor', 'Playlist 0', '2023-11-17 17:00:08.000','i030nuhilwui5lg');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('66h2antf2l90rhqf15in6cayfgw0gquauaczn87wn9fxg3zg7w', 'dcf27keselz2i05yrn56yo92kp1y3kwqummpygncm1dgy71uor', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('syp03zc3itogv3huhe1i5mx24qqs3yfjdxygs6df38bkx530su', 'dcf27keselz2i05yrn56yo92kp1y3kwqummpygncm1dgy71uor', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zizwrm2qqvh9r15ie6e6nf2jb79ctqh2fuh4mpl7vsn51ebkil', 'dcf27keselz2i05yrn56yo92kp1y3kwqummpygncm1dgy71uor', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('54w7t1iuyr0sh8sk2pr3klt7g8h5btf9y22dby1ppe7tgmfw3n', 'dcf27keselz2i05yrn56yo92kp1y3kwqummpygncm1dgy71uor', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('syf862q5yv32l0utvpjgcru0qzhuykgttxmzx3dsvkbjwmgn28', 'dcf27keselz2i05yrn56yo92kp1y3kwqummpygncm1dgy71uor', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('487gxy27846gjd94f5rivpfrs4oiwln6gsu5p439x7bkcgucbv', 'dcf27keselz2i05yrn56yo92kp1y3kwqummpygncm1dgy71uor', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('j6o5iu4setw1nx79uhg33298kx5594ebg4pamzd61m4757ufoq', 'dcf27keselz2i05yrn56yo92kp1y3kwqummpygncm1dgy71uor', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('639zdlxl0spjwjoihvjxz06zlr7tnphxq7gb6vm1detsgcjtk8', 'dcf27keselz2i05yrn56yo92kp1y3kwqummpygncm1dgy71uor', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4bk1ibs191da0pf40txj2cgybk44nbu7o7gn8ipomaymqww0or', 'dcf27keselz2i05yrn56yo92kp1y3kwqummpygncm1dgy71uor', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t4ierh0d8jtbjkkeabpsre1sdns0n7jb9udrtfm0zj3y0z5aqz', 'dcf27keselz2i05yrn56yo92kp1y3kwqummpygncm1dgy71uor', 8);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('cmhah1j8xvrop5eh53z6p8hvj4jpp0x4cwlr311jsxu6pg4i38', 'Playlist 1', '2023-11-17 17:00:08.000','i030nuhilwui5lg');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('erl03cc8vyjma8cuauf3gfslwsl5kmm3jqhzu66nul9r8wy2js', 'cmhah1j8xvrop5eh53z6p8hvj4jpp0x4cwlr311jsxu6pg4i38', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7uawvdth7x41pdztnaa2dy8rbunme94xiqv8wetypd3lw3bmlr', 'cmhah1j8xvrop5eh53z6p8hvj4jpp0x4cwlr311jsxu6pg4i38', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nojjuubfeg9c6jwnd34v7gazggg9yzguanhgg518ereij5fp6w', 'cmhah1j8xvrop5eh53z6p8hvj4jpp0x4cwlr311jsxu6pg4i38', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6qw6vg9tvkkng23lkysntndw29npblajqcv314aqbxov9jad7g', 'cmhah1j8xvrop5eh53z6p8hvj4jpp0x4cwlr311jsxu6pg4i38', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('p472acvlnv1renku9rtn1jmbmoh75m89q2sm859zj4cuytcwha', 'cmhah1j8xvrop5eh53z6p8hvj4jpp0x4cwlr311jsxu6pg4i38', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1jy5tilsg618zranmtb4tld0wurdyfex491r7mpkgug2rdb3ug', 'cmhah1j8xvrop5eh53z6p8hvj4jpp0x4cwlr311jsxu6pg4i38', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vmovsslaqe3vq84xaoqi4595filj79n8yrd1xfox985qy5lc4l', 'cmhah1j8xvrop5eh53z6p8hvj4jpp0x4cwlr311jsxu6pg4i38', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('csfesfvk3phyw9n8wbpnmiyz3k6d55zb46zv4k08b9qbgmu84u', 'cmhah1j8xvrop5eh53z6p8hvj4jpp0x4cwlr311jsxu6pg4i38', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1ybzqqwgccwfy7xpwd3bjpso1d0ldtvgwkxf4m9hgry2w8l91v', 'cmhah1j8xvrop5eh53z6p8hvj4jpp0x4cwlr311jsxu6pg4i38', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8f0316t8hmle8hy0jb4sakrirtu09z8pbtel47xoankb93sipi', 'cmhah1j8xvrop5eh53z6p8hvj4jpp0x4cwlr311jsxu6pg4i38', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('bizbr1711bsdp96o2d3r2bgkzkvejqen616f2043i2wyzf9gjw', 'Playlist 0', '2023-11-17 17:00:08.000','z7yl86xj1oco37b');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fw166l985xk0t7bk8wqtk5t96bzuv4t22hunt0dz1qlbdayuex', 'bizbr1711bsdp96o2d3r2bgkzkvejqen616f2043i2wyzf9gjw', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('w1c9lkvqbukjevu25kyfvxxmny1iatn51ph1j9zxyq9j3eenbl', 'bizbr1711bsdp96o2d3r2bgkzkvejqen616f2043i2wyzf9gjw', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jr5i869sam9gndwyx373adr1cy5kk0puagif2lx0nzx5jo1h3l', 'bizbr1711bsdp96o2d3r2bgkzkvejqen616f2043i2wyzf9gjw', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('76glh79bs7ek5y5whoa6gdi11isr5wuuhrndnx2r38x0ozcotm', 'bizbr1711bsdp96o2d3r2bgkzkvejqen616f2043i2wyzf9gjw', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('by1thi8m0pqji19kvkhhuoerq4klgsr25apnj2wgvbj2eey6jk', 'bizbr1711bsdp96o2d3r2bgkzkvejqen616f2043i2wyzf9gjw', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4oir2ffcbd9joocpu0b0mv6qjhkc4s6k16a4fh2rmypyx7grq5', 'bizbr1711bsdp96o2d3r2bgkzkvejqen616f2043i2wyzf9gjw', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hu1j5lyp4xui1pg4mtpnmi0kbmnn91dz5nuf9fus69bbxlu0qr', 'bizbr1711bsdp96o2d3r2bgkzkvejqen616f2043i2wyzf9gjw', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d118xaucgml9bcjftu84yamqqkosjlj2n72z90kj2gct347g4v', 'bizbr1711bsdp96o2d3r2bgkzkvejqen616f2043i2wyzf9gjw', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wl1gqk803nl8akblxeayuz6awofaj59lr83g5ivh43qq48h33w', 'bizbr1711bsdp96o2d3r2bgkzkvejqen616f2043i2wyzf9gjw', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('f91r8534ccwca7hsl0qzmz7ng1nxmwjhsu7unqngzqvpwmryv8', 'bizbr1711bsdp96o2d3r2bgkzkvejqen616f2043i2wyzf9gjw', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('3sxihi7qlbdl14m0wjiwdn7cjhxp612q56b4ze1i6cev1qtlfb', 'Playlist 1', '2023-11-17 17:00:08.000','z7yl86xj1oco37b');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('v2wbbj54ifmmhze0msh3yt6bsgf57p8705psplcm18888x6zsd', '3sxihi7qlbdl14m0wjiwdn7cjhxp612q56b4ze1i6cev1qtlfb', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qenv0e4rxrjtbofpaob5tghci6jwtf6w458f26k2r2ci5cyd9b', '3sxihi7qlbdl14m0wjiwdn7cjhxp612q56b4ze1i6cev1qtlfb', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hy3tuiy70m32e4bxkw7pi5i1rqryznu6eprl9s0r2rskn9r2ul', '3sxihi7qlbdl14m0wjiwdn7cjhxp612q56b4ze1i6cev1qtlfb', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1jy5tilsg618zranmtb4tld0wurdyfex491r7mpkgug2rdb3ug', '3sxihi7qlbdl14m0wjiwdn7cjhxp612q56b4ze1i6cev1qtlfb', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('uzu6ax672e33cpayqpl1a2wz5e3z59k1trqraejzlbtqs2hyni', '3sxihi7qlbdl14m0wjiwdn7cjhxp612q56b4ze1i6cev1qtlfb', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8i3y3sss2pfrh90lwgh5qa8vg1lpvnlwgdlfd2zgi031vx38wv', '3sxihi7qlbdl14m0wjiwdn7cjhxp612q56b4ze1i6cev1qtlfb', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3og5l1rst7shd89wopffsd51rnmile13eijti7r3f6hkycc2js', '3sxihi7qlbdl14m0wjiwdn7cjhxp612q56b4ze1i6cev1qtlfb', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('76h09rvk2bd6eso4dsxxszi2seh25nv63mq16q64cbab8ikfez', '3sxihi7qlbdl14m0wjiwdn7cjhxp612q56b4ze1i6cev1qtlfb', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e61sfokixzhneii0ezbyeu6hfr8mwgx3sdnmsyjiv71dpqf2gu', '3sxihi7qlbdl14m0wjiwdn7cjhxp612q56b4ze1i6cev1qtlfb', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dgd907d6ccvrticnx5rcfo62r5lsyfa025cb8z56q1li3csqne', '3sxihi7qlbdl14m0wjiwdn7cjhxp612q56b4ze1i6cev1qtlfb', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('3e2od9d1axkjrtme4ozejdau9965py6l41v4o7gs14rixrczws', 'Playlist 0', '2023-11-17 17:00:08.000','2bj3cst7q9mzemf');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fihx7o0a6xfl3powdue7zb30dggax59q9xkoevsbjr9k8qhw1u', '3e2od9d1axkjrtme4ozejdau9965py6l41v4o7gs14rixrczws', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('twabf477youf5d3wdohx943xtvfc07gwq2w7zb16hw5anyzd7r', '3e2od9d1axkjrtme4ozejdau9965py6l41v4o7gs14rixrczws', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('n7wt7bvz5l73xfeumwdguxmk961xe8ym2jde9r0l414j16rqhc', '3e2od9d1axkjrtme4ozejdau9965py6l41v4o7gs14rixrczws', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h2ldqzpn5q3tbvdwp6kiemyyw965rrv4tog4ux5wfuoncxxt3j', '3e2od9d1axkjrtme4ozejdau9965py6l41v4o7gs14rixrczws', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mvbdgxgzvc4wjnbhvob8d376d4qkukvg6sv2nyjapx7e4bn7zc', '3e2od9d1axkjrtme4ozejdau9965py6l41v4o7gs14rixrczws', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('up7795tdmik7emh06l9xgkpetbqfnrxhcq9sia3u83mmvnbxy4', '3e2od9d1axkjrtme4ozejdau9965py6l41v4o7gs14rixrczws', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('llj5u3xw7i6jymyzorvu3ow11ckd2ishuga7s3wrmbpp5jm0wr', '3e2od9d1axkjrtme4ozejdau9965py6l41v4o7gs14rixrczws', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('a21pr7h20hlsm28mjqzzss172hargrpnswdlx3xd1ayq07zv3i', '3e2od9d1axkjrtme4ozejdau9965py6l41v4o7gs14rixrczws', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4riprxgb3iyyo9k9r4dgh6occcv1ztanxf94zng82rvxzb990j', '3e2od9d1axkjrtme4ozejdau9965py6l41v4o7gs14rixrczws', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('w2cjfrjiq4nn730h1d2fsuczl19djacx06pfp7w17ofchvsssv', '3e2od9d1axkjrtme4ozejdau9965py6l41v4o7gs14rixrczws', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('qjq5td1ixqlqsdg8y17103ozn1vvo9swy018xli992un5z44q8', 'Playlist 1', '2023-11-17 17:00:08.000','2bj3cst7q9mzemf');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9no0b6weoji6gzha3j00dhlwyrd4fdbaadr0w6aoqnnykbu98h', 'qjq5td1ixqlqsdg8y17103ozn1vvo9swy018xli992un5z44q8', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dgwtq7btu5esb6ejsik4k4clf7i6657h9ac7t1q23kfb81a5hq', 'qjq5td1ixqlqsdg8y17103ozn1vvo9swy018xli992un5z44q8', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('twdm1nnfx4t4izw48srjmxvlvxd509sllnd26g7w313guxnnlb', 'qjq5td1ixqlqsdg8y17103ozn1vvo9swy018xli992un5z44q8', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bby8lazn8fyhb0pqz31mw6j9rk59atfpv3fp861g5xn20n1q4w', 'qjq5td1ixqlqsdg8y17103ozn1vvo9swy018xli992un5z44q8', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4qugwqknyv03joviqzd8k4pd64iwb6f24rkkmkyy5nnlilup9q', 'qjq5td1ixqlqsdg8y17103ozn1vvo9swy018xli992un5z44q8', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('539285v5r7zon5s8g7w2jnk1pdk17u1nh7ryi1fxonnp875zj8', 'qjq5td1ixqlqsdg8y17103ozn1vvo9swy018xli992un5z44q8', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z631zkkyuufs5eibcm0orataptn125eik9qvlaz3ek599eqthu', 'qjq5td1ixqlqsdg8y17103ozn1vvo9swy018xli992un5z44q8', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3tsl1aw2ymm9qtpp7ve8dslv41dhd5yx2vdgx89pe3mavv5msi', 'qjq5td1ixqlqsdg8y17103ozn1vvo9swy018xli992un5z44q8', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('f38pb4ves1wv0zi2rrei8sh3pwueeg8n0xm3kc05jl5888n2go', 'qjq5td1ixqlqsdg8y17103ozn1vvo9swy018xli992un5z44q8', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('g1cjbl94l4n1lu43zu489icj1v9om6vjt7whfv5v8u6143qcbw', 'qjq5td1ixqlqsdg8y17103ozn1vvo9swy018xli992un5z44q8', 0);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('dvnntkdgbp4h1flkou6ditfhjphmlpd6sl1vk6rk2kk0h2ee7u', 'Playlist 0', '2023-11-17 17:00:08.000','3txkonm6fne60in');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d0gu708e97gemrvld32padaau3rkur8kz3yxif8quxgieepnz7', 'dvnntkdgbp4h1flkou6ditfhjphmlpd6sl1vk6rk2kk0h2ee7u', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('up7795tdmik7emh06l9xgkpetbqfnrxhcq9sia3u83mmvnbxy4', 'dvnntkdgbp4h1flkou6ditfhjphmlpd6sl1vk6rk2kk0h2ee7u', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('udshapslhw2qzz4zad7ykbfckitjkwq36fxzlnjvojqrjit9iz', 'dvnntkdgbp4h1flkou6ditfhjphmlpd6sl1vk6rk2kk0h2ee7u', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('38c0su67zz6582exkjeoqw1kgpyr2r9rde983jzphvb1x6ve8d', 'dvnntkdgbp4h1flkou6ditfhjphmlpd6sl1vk6rk2kk0h2ee7u', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vmovsslaqe3vq84xaoqi4595filj79n8yrd1xfox985qy5lc4l', 'dvnntkdgbp4h1flkou6ditfhjphmlpd6sl1vk6rk2kk0h2ee7u', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('755f7miuz7r2cimix975kzzegy8fzrp2d1zlu53ebcky8v32rj', 'dvnntkdgbp4h1flkou6ditfhjphmlpd6sl1vk6rk2kk0h2ee7u', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('l04rh3l8se9vhtpawptztn2uubv8csi8pvb4t26uhy3wczqvn7', 'dvnntkdgbp4h1flkou6ditfhjphmlpd6sl1vk6rk2kk0h2ee7u', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4bk1ibs191da0pf40txj2cgybk44nbu7o7gn8ipomaymqww0or', 'dvnntkdgbp4h1flkou6ditfhjphmlpd6sl1vk6rk2kk0h2ee7u', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ynixjq055vhpof1i1x4knjhqdmhbc2i1vwiiamfd32au4mvnes', 'dvnntkdgbp4h1flkou6ditfhjphmlpd6sl1vk6rk2kk0h2ee7u', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('66h2antf2l90rhqf15in6cayfgw0gquauaczn87wn9fxg3zg7w', 'dvnntkdgbp4h1flkou6ditfhjphmlpd6sl1vk6rk2kk0h2ee7u', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('h6g7a5mobsrq1uxri07a9uvhymo150p4ddhmi77hp74g1as67k', 'Playlist 1', '2023-11-17 17:00:08.000','3txkonm6fne60in');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('b4r0kf9skzq6ogkjbjwji0ikzadqmc0ifrxpdut4rc4k8je8op', 'h6g7a5mobsrq1uxri07a9uvhymo150p4ddhmi77hp74g1as67k', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('if0k9rg28r4mivrx6wfpoirkiukpv2i7lp2vol77mxha5zcusu', 'h6g7a5mobsrq1uxri07a9uvhymo150p4ddhmi77hp74g1as67k', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bl6b7rbzywg1hkhice9ol0hbcxkb0b8lkop64zxog2ty4k4kvx', 'h6g7a5mobsrq1uxri07a9uvhymo150p4ddhmi77hp74g1as67k', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('j02xwqyxndftfxmklp2yp486rdyorpkz8eyp9o2kok1zwx6qih', 'h6g7a5mobsrq1uxri07a9uvhymo150p4ddhmi77hp74g1as67k', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cueyiz3joy0pcbjo3jl669vl4ku6ed4wetjatrntv74aaudjw1', 'h6g7a5mobsrq1uxri07a9uvhymo150p4ddhmi77hp74g1as67k', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qrdkt6cuwwbshgnipwyvat386696vrtpuxus9k4cun6jns41r2', 'h6g7a5mobsrq1uxri07a9uvhymo150p4ddhmi77hp74g1as67k', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r4vusasi9ahhuqvxrrcd3o8ff43ij590cll6rm5angjkx8tqut', 'h6g7a5mobsrq1uxri07a9uvhymo150p4ddhmi77hp74g1as67k', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('f5ayv7b9vjvjrrho5iehokp51tdjtqztdblcd1ky14n6er3kfv', 'h6g7a5mobsrq1uxri07a9uvhymo150p4ddhmi77hp74g1as67k', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('f79bpclaz6e2jyjfmjs8aecbjbtgbr0ccdtce0uwxmy9aksegn', 'h6g7a5mobsrq1uxri07a9uvhymo150p4ddhmi77hp74g1as67k', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7ful4a18i9a09uaq6s477ejhgoh8ty9xlcrraedrcxbna5qbi6', 'h6g7a5mobsrq1uxri07a9uvhymo150p4ddhmi77hp74g1as67k', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('gp8c58o8zxcjl1ah71m74w97me49lhlwc3kf4kb9g3grxujwwz', 'Playlist 0', '2023-11-17 17:00:08.000','77yfufw765qzng0');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('x1umgigue6296b2xa8v5thtevzvue529kmhvw494ylp73twnv9', 'gp8c58o8zxcjl1ah71m74w97me49lhlwc3kf4kb9g3grxujwwz', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qz7b1cw8pnwz67529bzdx82y4d35s5un0vk9j9srze4tz2ldna', 'gp8c58o8zxcjl1ah71m74w97me49lhlwc3kf4kb9g3grxujwwz', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wy7ij3b9t0toz9rjponkrdes55wex6cp6ns077cdmm2epeeb3a', 'gp8c58o8zxcjl1ah71m74w97me49lhlwc3kf4kb9g3grxujwwz', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gm5citjhz07wzh54xphcpvo4exh113a0mlobi5rzeh9tizqdof', 'gp8c58o8zxcjl1ah71m74w97me49lhlwc3kf4kb9g3grxujwwz', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bpquq4ebxg70hdk3r0gdabwychyfholj79pta74t191xffyi9w', 'gp8c58o8zxcjl1ah71m74w97me49lhlwc3kf4kb9g3grxujwwz', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('sl5e9xdxb9vfd3sjfj4ev87a6ifcmgqs933ltqbbkk7oaxgl1u', 'gp8c58o8zxcjl1ah71m74w97me49lhlwc3kf4kb9g3grxujwwz', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bzfq5eqhtfrnn0gbt22aw4ju8bysvl4jhupzcixr2ef3gkf11s', 'gp8c58o8zxcjl1ah71m74w97me49lhlwc3kf4kb9g3grxujwwz', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('kqmfx5kmvbbar6okbi4w62n1efnupnwoyf17757jo3chih8asx', 'gp8c58o8zxcjl1ah71m74w97me49lhlwc3kf4kb9g3grxujwwz', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6gmwqxwerx6b243y5y0pjuyixmf297g2t8lcs42kgk2k0bfriv', 'gp8c58o8zxcjl1ah71m74w97me49lhlwc3kf4kb9g3grxujwwz', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nysz493q20l138w5wuimm607ydhvuki3kn6f7t80velfl2yewz', 'gp8c58o8zxcjl1ah71m74w97me49lhlwc3kf4kb9g3grxujwwz', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('vb58ic7xf1j7kqtmmmhutiyisas7rhi9lag4l9fwu548zxl0k2', 'Playlist 1', '2023-11-17 17:00:08.000','77yfufw765qzng0');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d0o47esrzkizcu7d0sjpd7rf318hjooi3tlj4mmgxfihwjc0r0', 'vb58ic7xf1j7kqtmmmhutiyisas7rhi9lag4l9fwu548zxl0k2', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('es5yja2unoqf2spmpghp4794rkgvxsrf5zwbq52he84plett7v', 'vb58ic7xf1j7kqtmmmhutiyisas7rhi9lag4l9fwu548zxl0k2', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gqyvjngdi6a432p7yfev0dxdyx2sldxw1mvd53tufaufvit8k5', 'vb58ic7xf1j7kqtmmmhutiyisas7rhi9lag4l9fwu548zxl0k2', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0slqhag1rksleo9rgbjouv8qa454f9q3p029jay1hnhujl7i30', 'vb58ic7xf1j7kqtmmmhutiyisas7rhi9lag4l9fwu548zxl0k2', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9d9xn7ihdcceeluhlnwba7occ69plq1l3nxsii4f7gjjgxe3fo', 'vb58ic7xf1j7kqtmmmhutiyisas7rhi9lag4l9fwu548zxl0k2', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('eeqh1llglepcafk7md06dk4hi0xjx2qgdc4osxcunerpgsmla7', 'vb58ic7xf1j7kqtmmmhutiyisas7rhi9lag4l9fwu548zxl0k2', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ypcwubwpf8bz5vib4zfj8n911s1bzjvh3gjr5krwefnuuprmax', 'vb58ic7xf1j7kqtmmmhutiyisas7rhi9lag4l9fwu548zxl0k2', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nr7ef3xdb37uesc452p45jpowd610i41ere66sskk231qqiwwf', 'vb58ic7xf1j7kqtmmmhutiyisas7rhi9lag4l9fwu548zxl0k2', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8f0316t8hmle8hy0jb4sakrirtu09z8pbtel47xoankb93sipi', 'vb58ic7xf1j7kqtmmmhutiyisas7rhi9lag4l9fwu548zxl0k2', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('a8uyg4z9sa8gkze9j5l1pwe4xiuv5y7ka5s0m52vjvq17us2hf', 'vb58ic7xf1j7kqtmmmhutiyisas7rhi9lag4l9fwu548zxl0k2', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('ntrfz5m6zfvm1m98z1j2u901wvwca3nvxd1vsc3rzq2plvv095', 'Playlist 0', '2023-11-17 17:00:08.000','36sbvefc6n81dl1');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4n5r6gt7af6hbuf61d5kouty5bmuh4xjv9g76zaep071wpqqfg', 'ntrfz5m6zfvm1m98z1j2u901wvwca3nvxd1vsc3rzq2plvv095', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ayf31oxbecg5mjorp3e98yrmda5avhcodjyq67xx92m23ox4xn', 'ntrfz5m6zfvm1m98z1j2u901wvwca3nvxd1vsc3rzq2plvv095', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('c1sjyyntsiinozslcriozbwdqnwavky2iy7mjlel0npa4ifnmo', 'ntrfz5m6zfvm1m98z1j2u901wvwca3nvxd1vsc3rzq2plvv095', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5iuhr67w4bcpff2h13n0d8fflcaayvt61os58a1zcnce4nm0vr', 'ntrfz5m6zfvm1m98z1j2u901wvwca3nvxd1vsc3rzq2plvv095', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fz7p5ot49w2p33b35h1s0fp2qmholkb3y0ydadetdhnk4yzjp8', 'ntrfz5m6zfvm1m98z1j2u901wvwca3nvxd1vsc3rzq2plvv095', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gm5citjhz07wzh54xphcpvo4exh113a0mlobi5rzeh9tizqdof', 'ntrfz5m6zfvm1m98z1j2u901wvwca3nvxd1vsc3rzq2plvv095', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2y03zdjbjhc6ll58nz33jr0r5wlmtfw81ucyaoyevbzdb5698c', 'ntrfz5m6zfvm1m98z1j2u901wvwca3nvxd1vsc3rzq2plvv095', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bzfq5eqhtfrnn0gbt22aw4ju8bysvl4jhupzcixr2ef3gkf11s', 'ntrfz5m6zfvm1m98z1j2u901wvwca3nvxd1vsc3rzq2plvv095', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hadmxjdyobb8r7rjoulyirjklvttqly9rk6tr1xl3m8g6ytkrm', 'ntrfz5m6zfvm1m98z1j2u901wvwca3nvxd1vsc3rzq2plvv095', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7rppdo77rxww27y01r70tgr4m5ak54xneaffd0s0mjpjphxsn0', 'ntrfz5m6zfvm1m98z1j2u901wvwca3nvxd1vsc3rzq2plvv095', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('vooemjbpglwhbvdziuj3eym8aejsi8ws3z6zvihoivqggkcezp', 'Playlist 1', '2023-11-17 17:00:08.000','36sbvefc6n81dl1');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3tmu73d70iclbyqv9xb95vajz3u7ybzjdcox4ecqkbvbo6ymr7', 'vooemjbpglwhbvdziuj3eym8aejsi8ws3z6zvihoivqggkcezp', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('libwb5byklupjzbujbw8oovfhmy3bd7pvxse82d9nx6pt41jlo', 'vooemjbpglwhbvdziuj3eym8aejsi8ws3z6zvihoivqggkcezp', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('syp03zc3itogv3huhe1i5mx24qqs3yfjdxygs6df38bkx530su', 'vooemjbpglwhbvdziuj3eym8aejsi8ws3z6zvihoivqggkcezp', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('fluvqofp6a1czc68pr2h058l930m1vo0zbskogxhx0y8y2lmow', 'vooemjbpglwhbvdziuj3eym8aejsi8ws3z6zvihoivqggkcezp', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2janrnd2318mmdcz5gtjzrcbidr40s82vsuxwgzm9ww1ux1uvv', 'vooemjbpglwhbvdziuj3eym8aejsi8ws3z6zvihoivqggkcezp', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hwp3sjqtegoln1g0xz3tzan01u6gl0zc9nykfelle1uzofox20', 'vooemjbpglwhbvdziuj3eym8aejsi8ws3z6zvihoivqggkcezp', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pgmahfs82ctzb2kdgiuqs6x0smypxsqqpgzdyc18tcmp9gnjvn', 'vooemjbpglwhbvdziuj3eym8aejsi8ws3z6zvihoivqggkcezp', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('740gs437idf69jw4j5pysdm2ydugm7gwhie0zu2wfbp93w241i', 'vooemjbpglwhbvdziuj3eym8aejsi8ws3z6zvihoivqggkcezp', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wpd3wy6k2dxenvrdljtxo9afsh48m4ii6a2o2ty7p3j0w31l96', 'vooemjbpglwhbvdziuj3eym8aejsi8ws3z6zvihoivqggkcezp', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zth6iodv9uih2h9j0ln55a7k84wz4eq4lobtiofb7zzekq3b76', 'vooemjbpglwhbvdziuj3eym8aejsi8ws3z6zvihoivqggkcezp', 1);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('lueukul8twsvv9vp121txhtgp7mpcakn900yza1xtawrmnuvr8', 'Playlist 0', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hm6tv5rjdloky3ke7zb8nmzky7d9i6fa83b3m42eb2vgywbcg0', 'lueukul8twsvv9vp121txhtgp7mpcakn900yza1xtawrmnuvr8', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dcwq9lto3gs5mn2hb4wrdw2hvicvivycel92zjb5mtozke8pi8', 'lueukul8twsvv9vp121txhtgp7mpcakn900yza1xtawrmnuvr8', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('n7wt7bvz5l73xfeumwdguxmk961xe8ym2jde9r0l414j16rqhc', 'lueukul8twsvv9vp121txhtgp7mpcakn900yza1xtawrmnuvr8', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3womvthi7okqagonk2yedsgigxsucuf59k6vhfxwnva352ugco', 'lueukul8twsvv9vp121txhtgp7mpcakn900yza1xtawrmnuvr8', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7rppdo77rxww27y01r70tgr4m5ak54xneaffd0s0mjpjphxsn0', 'lueukul8twsvv9vp121txhtgp7mpcakn900yza1xtawrmnuvr8', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('efu5y2r5vfez8ayxwevtkwupbd87slvi0pwvbmgdepi9go4xjn', 'lueukul8twsvv9vp121txhtgp7mpcakn900yza1xtawrmnuvr8', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('zqu5z2rsguqg1is65jbmpgqytcrdddej7leqvuth333kpz3kbb', 'lueukul8twsvv9vp121txhtgp7mpcakn900yza1xtawrmnuvr8', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9x46yelvymtoruby6zgiixhts9pfgeo5xgmylmgaqz6xiinwlg', 'lueukul8twsvv9vp121txhtgp7mpcakn900yza1xtawrmnuvr8', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6gmwqxwerx6b243y5y0pjuyixmf297g2t8lcs42kgk2k0bfriv', 'lueukul8twsvv9vp121txhtgp7mpcakn900yza1xtawrmnuvr8', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yw0kysq8fccsxj7h0rtao8w87ht13b254kwaar33nf2aow7f2p', 'lueukul8twsvv9vp121txhtgp7mpcakn900yza1xtawrmnuvr8', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('r8kmal0o4qr7swepg3ne5kwiadyexcd402uk14zdxvszhw1jiv', 'Playlist 1', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5586cvdtr09fspjuzfeiv4i21it9nm8rznmllmz73r40s3tvgs', 'r8kmal0o4qr7swepg3ne5kwiadyexcd402uk14zdxvszhw1jiv', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('22eup1sckullo35wjaaiv71b9y0mf1ubajl5m9czb26r6lz17m', 'r8kmal0o4qr7swepg3ne5kwiadyexcd402uk14zdxvszhw1jiv', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ltv2a60m7v2r8ojkjkx6k722qc64vkr9fqqcp5a5sy1fcv6wvs', 'r8kmal0o4qr7swepg3ne5kwiadyexcd402uk14zdxvszhw1jiv', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('62b9k3o65hlvzf721ehdrirwnnrl5we0ekwgwst88plgvwdf8n', 'r8kmal0o4qr7swepg3ne5kwiadyexcd402uk14zdxvszhw1jiv', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4i6akyxftbhz7jqppvh1va0zmnjqcrzu4psxcmetpz6qicukwt', 'r8kmal0o4qr7swepg3ne5kwiadyexcd402uk14zdxvszhw1jiv', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2kwe4ote6c7kaqfrzl48r76jda3fsyd0ethg0kxyh05x9wxsef', 'r8kmal0o4qr7swepg3ne5kwiadyexcd402uk14zdxvszhw1jiv', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6iecmn0pa2ybb4tmuvxkyp77pwugm12vf87im4cfzeu41k2b8r', 'r8kmal0o4qr7swepg3ne5kwiadyexcd402uk14zdxvszhw1jiv', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dv2sbbj9zb9wj6atbm019dlhx70hnlpyxemu9dlz50q5zl2dn8', 'r8kmal0o4qr7swepg3ne5kwiadyexcd402uk14zdxvszhw1jiv', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5dwnu01tbig37vimaslx5mvl8blbzh4ib0yi3nfkszaytd4f6p', 'r8kmal0o4qr7swepg3ne5kwiadyexcd402uk14zdxvszhw1jiv', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xe0vf1yo67f1ulsg6agat81nh20zud6iq1fqfu7hgft991chwg', 'r8kmal0o4qr7swepg3ne5kwiadyexcd402uk14zdxvszhw1jiv', 8);
-- User Likes
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', '0slqhag1rksleo9rgbjouv8qa454f9q3p029jay1hnhujl7i30');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', 'e1vyiyt5g9px9x9xr6za76jkof0exli95ypx6abunspqb95qmn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', 'n6tvw8cljpyo82pd1lk0yn56rubcisl5jinv6fdzfym7ex9and');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', '8k7ew27s60ka1ky7mxneqef5wh1leg8xesath66zmq0gufbcms');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', 'ooolb9585c4283qj0q8nouy6sejxa476zfcbj9j5z0t16k8z5x');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', 'isx7dqgqv4erffxlzgdflg3jjjk5amogatdissld59dpo3avis');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', 'a8uyg4z9sa8gkze9j5l1pwe4xiuv5y7ka5s0m52vjvq17us2hf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', 'udshapslhw2qzz4zad7ykbfckitjkwq36fxzlnjvojqrjit9iz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', 'rdvhv1o428thpslsn5u89g8agor98umj3qcvdr58iat0mzzty3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', 'v6r7spvs7pm37nqslue1og4sore3ko1px9vvh109ehsqok8dnb');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', 'yjg7mtxidc5c07ha1s2ey7kari2xzwoudvcf5jo8dmjmw5cs17');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', '38c0su67zz6582exkjeoqw1kgpyr2r9rde983jzphvb1x6ve8d');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', '5586cvdtr09fspjuzfeiv4i21it9nm8rznmllmz73r40s3tvgs');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', '2kwe4ote6c7kaqfrzl48r76jda3fsyd0ethg0kxyh05x9wxsef');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mld5rxkd2j73m1q', 'dgwtq7btu5esb6ejsik4k4clf7i6657h9ac7t1q23kfb81a5hq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', 'mbs10njl57sk35mswp7jt5niht9b3u7sdfs9x84glnx0sghw7u');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', 'p9el6aznx0rcpq79p8pqxh26jmk1wuom7crbt9c478f8vss9rg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', 'crfvvo5w0lf8qymtkigcpridv0g5p6i0w5ggl60a3z5yvkna2p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', 'qz7b1cw8pnwz67529bzdx82y4d35s5un0vk9j9srze4tz2ldna');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', '6954zgpq2fx5pkkwrz7dv6hevst8pw66wvq5tbjht3xis7yavu');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', 'x1umgigue6296b2xa8v5thtevzvue529kmhvw494ylp73twnv9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', 'dyyg7bq5u8x4vxubjpn4oplu71xq95u1o1maceuxme58fa2vzl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', 'rnqdpxun73990bmoge9qoltmos0ck6vya8vz5h9sov9gv55waz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', '6iecmn0pa2ybb4tmuvxkyp77pwugm12vf87im4cfzeu41k2b8r');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', '8i3y3sss2pfrh90lwgh5qa8vg1lpvnlwgdlfd2zgi031vx38wv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', '7a3d2e8ul5uy5shdmvfstakw57wkycmp5ev2678ubx2hd4gyxe');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', 'dxwdflnftnzw79paqsgv1jqy8at07ph5s99ypb8lsz3qjzuewf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', '2nt3zgwx8xpkmc7jxslta2ryfp2gyq3c4ai1lfge9n2ei0spwg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', 'y25usfo81ffw2cew8l03r270tt2rgy9h6rmuq54gkx206vz8dt');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('jqoril33u6f9uhl', '59n50oz18plx9etmzz9q9jk91m18hyx2zevnlssqtxpfptairp');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', 'b4r0kf9skzq6ogkjbjwji0ikzadqmc0ifrxpdut4rc4k8je8op');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', 'svpyl0z9d7l01miyu102upe02dlmqprenybzupaub28bq3fyng');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', 'i71ivz8kas2lmo0afx4i6mqg863zphf40v176r7gv7x9vtlehs');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', '53qnj42nwirhsrwfapqgnoioz84izyw9f4sj3r74liteb9ff8a');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', 'nysz493q20l138w5wuimm607ydhvuki3kn6f7t80velfl2yewz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', 'j8yrdt14x2hgxqwxjaadkw5onlpy8zrr3mqtqoqnhv04jb7f0n');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', '62b9k3o65hlvzf721ehdrirwnnrl5we0ekwgwst88plgvwdf8n');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', '76glh79bs7ek5y5whoa6gdi11isr5wuuhrndnx2r38x0ozcotm');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', 'dgwtq7btu5esb6ejsik4k4clf7i6657h9ac7t1q23kfb81a5hq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', 'thn2ddsyzxqhe4f41p5ailas7zq347mjoq4uu9i5yul68x0838');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', 'l1ubrip2bsecltz9edupmhpuh2w2vnxnr94858bbbp6s8vb2wd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', 'llj5u3xw7i6jymyzorvu3ow11ckd2ishuga7s3wrmbpp5jm0wr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', '58drw2imi6rtjgwugl3w2fobhn7qm71muvp58m0yhzfb3akqii');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', 'rqnii27986x5q93kh3d1vx2var0zz7uc6gda6cmtbr1qf8xzyq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('d27m312nasvba0x', 'm5a5pnmc24wdblfb7mf22sossxvnn5yxo87egn1e09t4ur2beb');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', 'e2wuzoics3zr5dvrhdgp7uklkltuldar642d2eq45fkiwxzxu0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', 'dxwdflnftnzw79paqsgv1jqy8at07ph5s99ypb8lsz3qjzuewf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', 'oskrc0jgol56ubgmaov97o245dy9getl8dcdjqqm149thhji5n');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', 'p9el6aznx0rcpq79p8pqxh26jmk1wuom7crbt9c478f8vss9rg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', '51wahwtyxg74sdcic1rdhwvezlb5kwl5o0z6c1lk0ho6o933mi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', 'z631zkkyuufs5eibcm0orataptn125eik9qvlaz3ek599eqthu');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', 'dad3nkjivlvvoytjr4oouel0ar4u16914b2vkuw8y5nb39t63z');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', '1rvbwyzn8sgi8mvl9volg0p9szi11twr0t9r8ssvjxbwfo4j2z');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', 'yw0kysq8fccsxj7h0rtao8w87ht13b254kwaar33nf2aow7f2p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', 'b4r0kf9skzq6ogkjbjwji0ikzadqmc0ifrxpdut4rc4k8je8op');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', '916tg383filkhsfpnewdtk5jwgwmaoc4qcuz21fl0melymvi2p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', '3kgwq4qf6yp9cefacegrhmsx4f7cf0rk2s3f8izxf7uyq58xou');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', 'n6tvw8cljpyo82pd1lk0yn56rubcisl5jinv6fdzfym7ex9and');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', 'oxuk02cob0ostcncdojhr5drfvu7sytdbsur83hg7yfncl2x5k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wz3cozcoswqffgg', '19mqt1zlk1cekk2tznh266d6rol8dg9ona2qof6r5eoeq3yg3r');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', '86xk68rnp1pgguedjjji6g7l965wahns7bnvdbh3j13le9z54v');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', 'd02z4msmigr1qulxqkj1j7su3le97kzybxdh847bcsqardk923');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', 'j8yrdt14x2hgxqwxjaadkw5onlpy8zrr3mqtqoqnhv04jb7f0n');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', 'ua3h997qltambid4z3z7netdlr3xbmgkmjxohydv2959mr13kf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', 'id35t860e0bws5rl2kg18u4366v50cynbrkii1n0rucj0pzx9f');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', '96t3zmjy8wjte0cc4du1c75neczhj5fuydbizo6ihm4mry1hot');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', 'grvn57rm81nzwyjowaqn4spz52pzmltaptf2tpgce3amyi48gr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', '6hajelcle6sd5e9886dklzny2j3zr15wvk6x5pdxkx3h5wtunt');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', 'h2ldqzpn5q3tbvdwp6kiemyyw965rrv4tog4ux5wfuoncxxt3j');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', 'bkbvjjetwhdb9s8jfkh87gp8wr1posq96z5c8nwln556qtbqv0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', 'v2wbbj54ifmmhze0msh3yt6bsgf57p8705psplcm18888x6zsd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', '1k41vniucs57emb0rrfyzdfznp5obaeo4sj7ce1yh5ya44e7v7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', '4bk1ibs191da0pf40txj2cgybk44nbu7o7gn8ipomaymqww0or');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', '99l8ez3tp9zznuhcv800zqv1tgfcbdh7bikygu90l0cfdp65p2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('i030nuhilwui5lg', 'wx895vdokm2ihafj4rtodiat1ezvunwlhc9rlq5ho5nf70wb2t');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', '6arw0mepoq5ok64ypwdv9nwhjhjy97rgyu04l8nc5szo0o6115');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', 'yxumcou1s36gw0hd6uvnrft41lzg4doh4f0l9qfzt8qrfda1ct');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', 'l5jona3b2wdm48w9un4mqz28lfzepi016b4qvhugn3681ab3wz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', 'pgmp2k1mr3ekjr13w2sbanzdgv4phxii963ds53s4is8fxr887');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', 'flewynip4l57l65co6q52bxue3h5hs759qate6z5zw6k1ttt4w');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', 'inembywhegi23nb81x2xxea2vmaivuy814okfkg9xhu36y2wp2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', 'k3qrzqun5vamv70i7rx5m0hgng0cjwmzpcnsgau4ga5ouno30y');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', '95d6gfutzpady81wvx3dh86psyjg59bvv1rudw9ootj7btixtv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', 'id35t860e0bws5rl2kg18u4366v50cynbrkii1n0rucj0pzx9f');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', '5iuhr67w4bcpff2h13n0d8fflcaayvt61os58a1zcnce4nm0vr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', 'wl1gqk803nl8akblxeayuz6awofaj59lr83g5ivh43qq48h33w');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', '0fgfp2adz49stj2mtp0bsfiipym954xmatzuialyrv9fz1zkr5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', 'es5yja2unoqf2spmpghp4794rkgvxsrf5zwbq52he84plett7v');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', 'zizwrm2qqvh9r15ie6e6nf2jb79ctqh2fuh4mpl7vsn51ebkil');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('z7yl86xj1oco37b', 'pgmahfs82ctzb2kdgiuqs6x0smypxsqqpgzdyc18tcmp9gnjvn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', '66h2antf2l90rhqf15in6cayfgw0gquauaczn87wn9fxg3zg7w');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', 'alkjit6lqgk9p8zyuzrdmmfnoi1etpam2iqpawy7tpxvan8xmw');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', 'qenv0e4rxrjtbofpaob5tghci6jwtf6w458f26k2r2ci5cyd9b');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', '8f0316t8hmle8hy0jb4sakrirtu09z8pbtel47xoankb93sipi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', 'zizwrm2qqvh9r15ie6e6nf2jb79ctqh2fuh4mpl7vsn51ebkil');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', 'lq763e0cys0o37tu1r3lnti6kme18zap4nkv250qqp00gedzzo');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', '1jy5tilsg618zranmtb4tld0wurdyfex491r7mpkgug2rdb3ug');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', 'gqyvjngdi6a432p7yfev0dxdyx2sldxw1mvd53tufaufvit8k5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', 'cueyiz3joy0pcbjo3jl669vl4ku6ed4wetjatrntv74aaudjw1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', 'apvdbepblgyj8woyvumsqoe01kmqs8tvoxvou78508igib3692');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', 'jpzcyywzym9upouhyns8cwgcqbeefyddsfbg1uzlluzzphldzr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', '76h09rvk2bd6eso4dsxxszi2seh25nv63mq16q64cbab8ikfez');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', 'yz0bacxfv71t0v5881il90u28hyic8pj49sketn5edhda7w2oi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', 'rcle0a9vsf8cpr2j6238t3i94niuwugiknt2v9gn4ah4gcea1i');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('2bj3cst7q9mzemf', '9d9xn7ihdcceeluhlnwba7occ69plq1l3nxsii4f7gjjgxe3fo');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', '8k7ew27s60ka1ky7mxneqef5wh1leg8xesath66zmq0gufbcms');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', 'e2wuzoics3zr5dvrhdgp7uklkltuldar642d2eq45fkiwxzxu0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', 'f91r8534ccwca7hsl0qzmz7ng1nxmwjhsu7unqngzqvpwmryv8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', 'fluvqofp6a1czc68pr2h058l930m1vo0zbskogxhx0y8y2lmow');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', '4cs0px0pjz4lnkfjadkada77mqax5hod3v9lzg729c9iin30oq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', 'yw0kysq8fccsxj7h0rtao8w87ht13b254kwaar33nf2aow7f2p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', '5a98fo0h9an4pixp05rvwcaigl5nujty5em2n488smtaq5hxjp');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', 'ssrcqrv27np7vn05799bm086ovnnb4n2yz6tkvbnrpcivnhqnb');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', 'd2z26m38vtg1kwphl8r3du9z4zfv7pybpme3u5evf47e11i02x');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', 'xe0vf1yo67f1ulsg6agat81nh20zud6iq1fqfu7hgft991chwg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', 'rdvhv1o428thpslsn5u89g8agor98umj3qcvdr58iat0mzzty3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', 'flewynip4l57l65co6q52bxue3h5hs759qate6z5zw6k1ttt4w');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', 'dyyg7bq5u8x4vxubjpn4oplu71xq95u1o1maceuxme58fa2vzl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', 'oxuk02cob0ostcncdojhr5drfvu7sytdbsur83hg7yfncl2x5k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('3txkonm6fne60in', '8fh9dc8quom2koo6z2wfp5s3sq7zxb9hq77hno6dewcaedwyu5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', '3tsl1aw2ymm9qtpp7ve8dslv41dhd5yx2vdgx89pe3mavv5msi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', 'amnv09qhr6ga132kkpgfwug72uai2mlcxihdgv4rnehhwvo2cy');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', 'kqrw1254ox5de66g8d78phe5wl0r6uzvflimh75vviaduexvpc');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', 'xs9bzesr6l6qg5teuhvfsu4ujjezsjnlm0vsnuhscucfogsrlu');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', '3og5l1rst7shd89wopffsd51rnmile13eijti7r3f6hkycc2js');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', 'kx7nv49hqypsdupz3ef1jq6e2ihzjiyjg50leoh70dg1ybcgsa');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', 'j6o5iu4setw1nx79uhg33298kx5594ebg4pamzd61m4757ufoq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', '1k41vniucs57emb0rrfyzdfznp5obaeo4sj7ce1yh5ya44e7v7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', 'ots8bxwst9a0wxh5tg7pnk51w1ev1xd80lmbnku20muxx1v3w1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', 'j5954h3d0aaxxiqcur2ajvo2rd5oml84jps9kkf8ngr4x0a0pf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', 'qthkidczxwljts4f031rb6u16v15wkzw8h2mm3wqiw4agrkilg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', 'l5jona3b2wdm48w9un4mqz28lfzepi016b4qvhugn3681ab3wz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', 'thlt7i6epckbni8cm3rv8p6ytfwbyxhryhd8imgyub599x60qf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', 'nayxnvhsncq083416h8gyx4pvewtcp3tjc499c8it3frz5ei6s');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('77yfufw765qzng0', '717qfeoqmfnd2xxoivsnky04t16pzanwl5qbbg0zkbp94vkqgo');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', '85linkqyigo0bz5i5qmxr72qkv489y960mte7mpggrna1fbb3r');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', 'oepfm51t0fmtbi5diswgx0inwbesyvg8nxqy9rg6m7z90ub82p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', 'l5z6dz00vmnhpce52779xf9aid0lyjzunu812am749fqp4ph4u');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', 'bpquq4ebxg70hdk3r0gdabwychyfholj79pta74t191xffyi9w');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', '6gmwqxwerx6b243y5y0pjuyixmf297g2t8lcs42kgk2k0bfriv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', 'tx8d5fsy2z6cv9o1f3auip3na53l0rpcrjuqpy7u8enqvtl09x');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', 'f91r8534ccwca7hsl0qzmz7ng1nxmwjhsu7unqngzqvpwmryv8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', 'lq763e0cys0o37tu1r3lnti6kme18zap4nkv250qqp00gedzzo');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', '1m3fw47btej14hhz5yh44a3e6fu2io3vy8fk67oejehmgc516w');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', 'ayf31oxbecg5mjorp3e98yrmda5avhcodjyq67xx92m23ox4xn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', 'hm6tv5rjdloky3ke7zb8nmzky7d9i6fa83b3m42eb2vgywbcg0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', '5117sesq99uou96rsvjmrijqzrax9nmp7dg89zymss2vl9cmav');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', 'z1goowchy9k8u5hatdk7w9haycpwppogrkc7b1q3u228bbtdas');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', '8at3c5z51p24zum3g5jjsz50iws7fqg0f7mfwdwey54ltlmnk8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('36sbvefc6n81dl1', 'dcwq9lto3gs5mn2hb4wrdw2hvicvivycel92zjb5mtozke8pi8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'yw0kysq8fccsxj7h0rtao8w87ht13b254kwaar33nf2aow7f2p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'j5ey1x4le8iy7u7v0n1ss3zasagpofmu1k4e7to9lxn7qb83h7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'gvhlkk65cmt686j8xmg7dgewbj22jd9laavoze2ddehou8e1om');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '3tsl1aw2ymm9qtpp7ve8dslv41dhd5yx2vdgx89pe3mavv5msi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '6arw0mepoq5ok64ypwdv9nwhjhjy97rgyu04l8nc5szo0o6115');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'gtv31x53dc93i8ubt5o9ujm2ii8fedm87q0vejnjxjynoat6ui');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '66h2antf2l90rhqf15in6cayfgw0gquauaczn87wn9fxg3zg7w');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '600yp6t1isvg5dideszhm1mejlwzlpubmtfcwid5cnvtc3gh5f');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'eqdbuu94bzs8cllkkja83rvt66rkzhyyehy567zzol8gwehs34');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'swdxtaq5boh3uxm0dc92bafv5qu6gzgo7x0k919gek3dtn468b');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '0slqhag1rksleo9rgbjouv8qa454f9q3p029jay1hnhujl7i30');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'rqnii27986x5q93kh3d1vx2var0zz7uc6gda6cmtbr1qf8xzyq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'nmqycq32fa2c1dvjscx2jacqd1fb51in0g9q3uemb8bfi5ku1o');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'e1vyiyt5g9px9x9xr6za76jkof0exli95ypx6abunspqb95qmn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'hu1j5lyp4xui1pg4mtpnmi0kbmnn91dz5nuf9fus69bbxlu0qr');
-- User Song Recommendations
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('1iaupkqo3hgxv5pp9amvi3wiz5zerj8q2b05g4p1axaeylr3i0', 'mld5rxkd2j73m1q', '734fldn4e4irgcosqvnbud9lxl915yhyo803ex4ib0xqpgn90e', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('97aywb46pgg4bamxybdyfnvvakx0ml91ede0zx7soaf3ytwps6', 'mld5rxkd2j73m1q', 'fblqcp9a2c5ecc6gkwdvuyw8zs7tly47oui6m520c7srajbgxs', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8flshji5m8ylbbk7o2zu8tqfibnrpyfkmbdw9ib96s0xge8549', 'mld5rxkd2j73m1q', 'ypcwubwpf8bz5vib4zfj8n911s1bzjvh3gjr5krwefnuuprmax', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('mb2ubb1js2oxwsr7s1t1kaxl4p271yo52asox9ly2we3fi15bp', 'mld5rxkd2j73m1q', '85linkqyigo0bz5i5qmxr72qkv489y960mte7mpggrna1fbb3r', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('itjxrif90m6u2iqvlv20rzswauuyw7jqto210cahc0josig9jy', 'mld5rxkd2j73m1q', 'dotiskv9v3337avg1zttesjkq8akwsae90igprsugh1nf05ta8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('dwkkt6rjm9elm9iqg16rouuol6kliangai6s3iv43tpbog5rm5', 'mld5rxkd2j73m1q', 's36i4dlp8mrevpox7w4a0y3almx4r6zrdb42c0sgipze44zr26', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('9nlqyp80uoyyu6sditzyc472kvpzs90b849980v0e0ebi0epjh', 'mld5rxkd2j73m1q', 'e61sfokixzhneii0ezbyeu6hfr8mwgx3sdnmsyjiv71dpqf2gu', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ms1ov3zqjvgo5uiak2mgvfmauy19ocook68veisedgj5fji7hl', 'mld5rxkd2j73m1q', '7uawvdth7x41pdztnaa2dy8rbunme94xiqv8wetypd3lw3bmlr', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('2oggpp58jvjphye1fqde4k65tqv925xnpv24dxk3v73p5rgx01', 'jqoril33u6f9uhl', 'dgwtq7btu5esb6ejsik4k4clf7i6657h9ac7t1q23kfb81a5hq', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('6bm4egky61poljnjkwow7ss801z7svqjoi88y434sdatgmuwit', 'jqoril33u6f9uhl', 'dv2sbbj9zb9wj6atbm019dlhx70hnlpyxemu9dlz50q5zl2dn8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('dsn3l0wd2sdiconfriziw6n0d67ji3uyuu8pw66mqd0c4tdhb9', 'jqoril33u6f9uhl', '96t3zmjy8wjte0cc4du1c75neczhj5fuydbizo6ihm4mry1hot', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5thi8agj5mlksdqhzn682i5runs4mrulsvi5yw0i0iwte0hs0u', 'jqoril33u6f9uhl', '9t5psoduy2hervpca249vkduwjbtj7yqshif7zp2cnxz1a3fxd', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('s2840sgi6yhd8oi0i5uxv51k8wgobxipyyydx39hinzhel94lu', 'jqoril33u6f9uhl', '3womvthi7okqagonk2yedsgigxsucuf59k6vhfxwnva352ugco', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('shlqpzrmei4p1uzzuh23z4s3zxbe2gb691m1jije2k4w89ijhs', 'jqoril33u6f9uhl', 'p472acvlnv1renku9rtn1jmbmoh75m89q2sm859zj4cuytcwha', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('y2o5r0ksti8epnohobzzsuj1juz5nl5vrczwl865mn693h9dre', 'jqoril33u6f9uhl', '97amvayjriwzx6567fmiosnib0tsfp278c0623g6on54bkfks1', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('meqcumz69eouyv38dnw9urjvumoqcppn9oqyzhbkmmxtuaxi7e', 'jqoril33u6f9uhl', '041n8gy4umf7kvo1hefyemaoibdyf043za5expth9heo8dn2ii', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ueziypr5y56pom9t6pkfj92x4qiebnbca6ukyrh2uyh9tlr909', 'd27m312nasvba0x', '38vgnjemk5m1jcvw1vipzbywbfdclb3rnra0wy8k9sywg95zie', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('kxfgxetov46wfjjym0hmfantgxfnjta9uk1gyass6y6t0sn61p', 'd27m312nasvba0x', 'rfnovptrx8xnyi66uxk1s97gua2kcchq4icl99ma6d9b0je1jg', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('qmu2escjikv7nojzdc3brgl4cn5r41lzq6en7ts97ho5f3phk0', 'd27m312nasvba0x', '3womvthi7okqagonk2yedsgigxsucuf59k6vhfxwnva352ugco', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('c9hnc5avm7a9kgsth9kf7p8lcmv4nt69j7kbbqs3chgkqdhv2a', 'd27m312nasvba0x', 'gvhlkk65cmt686j8xmg7dgewbj22jd9laavoze2ddehou8e1om', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('v0z1c64ny0ocgdvitr0v6y7xt6j60i1zpptifd9mu0nw0gftbq', 'd27m312nasvba0x', 'zi8o1lq0glyquoic5b60he0jf19mjziyso2ousf0pv60scilsq', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('g16i3q8zds43n3jnbdt9bq9i261hkdd5ul8ckgc3uxijtfpeii', 'd27m312nasvba0x', 'n6tvw8cljpyo82pd1lk0yn56rubcisl5jinv6fdzfym7ex9and', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('t2o1dgr9004p7nihjo6t0e4a8wxelsv2ft94fizt17fgxx7m32', 'd27m312nasvba0x', '2upd1osptayhyiqh856k477wd3tcjk5hoo57f31oqzb35easlg', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ukl8mgoxfdkk664b1ybsb4hw1aq8y79n9edikweyneb1jy7m5q', 'd27m312nasvba0x', '9qpfnet210bc64mt259xm8v7y68wbq60nj3s1zpl09yn6umnks', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('s2j57q7nhavhqvqed7llmyl16jzsb89frd4bz24fbfl422k1jm', 'wz3cozcoswqffgg', 'ssrcqrv27np7vn05799bm086ovnnb4n2yz6tkvbnrpcivnhqnb', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('hx3nmy53iksngmrpwfqdhqxcfkbccpkwstw2ykuiar9kastm8i', 'wz3cozcoswqffgg', 'wvv7jpjx1nrmzm6ufhvquxtpojsc1iaq1bdfssjk07v7po7zmv', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('e0zr5ww4cdye0lwjvr0xb7a6136k49u7k790k2uhumj9akqtmh', 'wz3cozcoswqffgg', '17dclptz5gvfzveyo5elxbyew72jd840dp6lf64gr1wzehtl3q', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('l6jazlp79p5jk35h8nemx66p0ksb4qmylq9mtguuzfsiickjb5', 'wz3cozcoswqffgg', 'kqrw1254ox5de66g8d78phe5wl0r6uzvflimh75vviaduexvpc', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('b8mjtr9a72pc8uwowmr8pcqcaalwyinz13u2wvmqdt9bmk42eh', 'wz3cozcoswqffgg', 'oskrc0jgol56ubgmaov97o245dy9getl8dcdjqqm149thhji5n', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('7ikdj3y5cfna55mxbjs93zbiuji99wltnr3cmd0ikmpbzc4x4r', 'wz3cozcoswqffgg', 'lbcfrh9s8mccwj4evs9w4oeuf6eh3t15bns1tk268r63bdxoj6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('6ri5h20fk7ic1n2hw2epwsst5v6b4dwr6vw429ynsozjqsya9c', 'wz3cozcoswqffgg', 'pgmp2k1mr3ekjr13w2sbanzdgv4phxii963ds53s4is8fxr887', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('u7wamzlft00yxs4djydai24sfdrvqpu6mwuy88gdd3gx9yics7', 'wz3cozcoswqffgg', '3h6pyh655fd0nh3javtk434vctbwbaz40bek19t6csq272np44', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('7lju5fr1krdvkrxokl27wwud8cak2rxw75gjigk6fyavrbms7w', 'i030nuhilwui5lg', 'po1ntpn1qg0myy3mtvltkdmevlnr8ieebz7ory6xfepc54a46j', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('30wfmap3raars3g0y4r4d2yp62ksn1ssbomtdspw6ft0mirph9', 'i030nuhilwui5lg', 'e59hw4e78qw9gbh8yafza8n0dt1i16ksx4skiucmp3mqnyl8zj', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('mqhj5dcasfc48si6rephl6d6omb2uchoyxa7z9r3ivnpsqt8sr', 'i030nuhilwui5lg', 'ltsntgm5yh29wf82hefiju4qaj4ztaxq8jiobnj83d578s2o9h', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('qtsss25548fnolg0dsfyugj98yraphyupqz1v6ayulv59guhqh', 'i030nuhilwui5lg', 'l5z6dz00vmnhpce52779xf9aid0lyjzunu812am749fqp4ph4u', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('swqtm6fl5cvfyl6b3pb9sd1we4uwuiiel551hxt257yalot0ot', 'i030nuhilwui5lg', '2kwe4ote6c7kaqfrzl48r76jda3fsyd0ethg0kxyh05x9wxsef', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('l7kn0d9ycatj7dnsfewjt3cerxy4gscpaogi5xzkgi5u8a3uab', 'i030nuhilwui5lg', 'sypkfqjgyb1ssowh4zlq3vadklmlmr6e78bwfx64l9gv4khur3', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wy7m1ukv0lt1rv1dl9z972ql31s8jpni0ipqora4ejm41ypr93', 'i030nuhilwui5lg', 'dxwdflnftnzw79paqsgv1jqy8at07ph5s99ypb8lsz3qjzuewf', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ab3n9lnpy5lm4005ao5euplmhee03e33bu0uq17owirfxqbqwq', 'i030nuhilwui5lg', '916tg383filkhsfpnewdtk5jwgwmaoc4qcuz21fl0melymvi2p', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('hx40bpchipbgmjc9u3zlwzqjz4unr5entpjuhoshkmyapnf2pm', 'z7yl86xj1oco37b', 'bkbvjjetwhdb9s8jfkh87gp8wr1posq96z5c8nwln556qtbqv0', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0eq133pu783jzucbjh0n11avv5g0pu4s9fvyqt7h1pvm8ufsd2', 'z7yl86xj1oco37b', 'kfqhq90zx9p7kuacwsykbfbtfekjp59f6yecqd3nrl3orubhx7', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('dtowwlnloflhlaf7e8hra6modygbvyhausnvp4skq2go08d9r0', 'z7yl86xj1oco37b', 'j8yrdt14x2hgxqwxjaadkw5onlpy8zrr3mqtqoqnhv04jb7f0n', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('xju326lc6s1piy9d09dd0vjjm1iz7x3r7i7cdgzi0np56t9r1e', 'z7yl86xj1oco37b', 'vmovsslaqe3vq84xaoqi4595filj79n8yrd1xfox985qy5lc4l', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('isaiuzz6onef3x2jtvq88f6ile3bhv7g92aeklsgdyv897py72', 'z7yl86xj1oco37b', '1p9ktvi5xx2o816mimwhoqgwf34f3kefqwhblvg0407vob6tax', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8mgglog3di8rt7tjinhyyhub8msrw775e6arj03krovq9e5i09', 'z7yl86xj1oco37b', 'fnyth914ycvw45galfu5c7r4xmnb8tnz6xf8vt4hn4a4c0ne5n', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('nvu7pkz73zf2nxbchfokzgq4ulmyhpae2v4u3m0z8nqqzwstqy', 'z7yl86xj1oco37b', 'b4r0kf9skzq6ogkjbjwji0ikzadqmc0ifrxpdut4rc4k8je8op', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('t1vhjz8i41pqnm2whdgtxhiriwd7g8p82jg3d2topk3jrtxaxi', 'z7yl86xj1oco37b', 'fluvqofp6a1czc68pr2h058l930m1vo0zbskogxhx0y8y2lmow', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ed7bj9ty5u9qtnl9si1meyxb0de8nqnwh678t56kz3n4gwbr9o', '2bj3cst7q9mzemf', '53qnj42nwirhsrwfapqgnoioz84izyw9f4sj3r74liteb9ff8a', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('2xhkyznjf014qaf173eljvkszf5hjf3yhgnzlcrctdrm400f5t', '2bj3cst7q9mzemf', '4i6akyxftbhz7jqppvh1va0zmnjqcrzu4psxcmetpz6qicukwt', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('i6ydhg8ax7bdtp0j8lcoojgjcxy2n052tp1ruj6uorchlfe74v', '2bj3cst7q9mzemf', 'alkjit6lqgk9p8zyuzrdmmfnoi1etpam2iqpawy7tpxvan8xmw', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8t746298e5m8vkz56uvxohvw9ffblm7lj8xh24njzfceqo5d4r', '2bj3cst7q9mzemf', 'z631zkkyuufs5eibcm0orataptn125eik9qvlaz3ek599eqthu', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('mupgxuifst9ieycjzw7r2uici12h0i4vlyc620s5lh21ug8wft', '2bj3cst7q9mzemf', '8f0316t8hmle8hy0jb4sakrirtu09z8pbtel47xoankb93sipi', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('3i1dglshp30bb9mvohlik0l8s09jwiye5ctcda217pten5zv6k', '2bj3cst7q9mzemf', 'rqnii27986x5q93kh3d1vx2var0zz7uc6gda6cmtbr1qf8xzyq', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ff35g4ddwcyod3x87gt7kpwmkq86ymzces2gzwfm6bu4pi05ql', '2bj3cst7q9mzemf', 'f5ayv7b9vjvjrrho5iehokp51tdjtqztdblcd1ky14n6er3kfv', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('xldk9aztz0y41q9ifk96o06qgfex1dn3sjxg9bc7k2mk6teqmh', '2bj3cst7q9mzemf', 'dgwtq7btu5esb6ejsik4k4clf7i6657h9ac7t1q23kfb81a5hq', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0gbps8kdzzwj8wal5n56g6dmr3zyc9mdonzmmft63nopa0g1ge', '3txkonm6fne60in', '4i9kdpyxjifckywvcexj8gvbursga4v7l0u1xkqopmtyrkp3og', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('4v2eszeule95qxbenwargiutf6020qrfodf4s3m1ij01jlj18b', '3txkonm6fne60in', 'chbmrpcyqxt7qcmmk6p24m4qgun5g57nsm8551rcu2hwq91rf8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('98j7pqe3y1kdm4k6ijbwjyqsxtn7147c0oqb10adjajx00rclz', '3txkonm6fne60in', 'wl1gqk803nl8akblxeayuz6awofaj59lr83g5ivh43qq48h33w', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('k39cjvn945s97dqidii851yzkmd5i7smxw98pfjdksnkbfznec', '3txkonm6fne60in', '99l8ez3tp9zznuhcv800zqv1tgfcbdh7bikygu90l0cfdp65p2', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0sn1cto6szgn9bid7e4vas676q307xovgupq74yr3d80bbq6dh', '3txkonm6fne60in', 'csfesfvk3phyw9n8wbpnmiyz3k6d55zb46zv4k08b9qbgmu84u', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('sqasfywzbduratwjbynh6s5w9shyza23yhg2uty9od93qk2ic7', '3txkonm6fne60in', '7scayrujefgsjoz5j9kaiqlj7an1r6h52ehcv4edn7t4cpnog4', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('cyy8co5ecv1336w34qfzbvabcrj8ojogutpii331uqgl2pm7i6', '3txkonm6fne60in', 'wpd3wy6k2dxenvrdljtxo9afsh48m4ii6a2o2ty7p3j0w31l96', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0dv9940w2zzgtn7lqf22dx9r2uyi7tno4qua8kkc72n5lfejfa', '3txkonm6fne60in', 'bkbvjjetwhdb9s8jfkh87gp8wr1posq96z5c8nwln556qtbqv0', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('4h5boksfps7w1k6wxtu2zt0g3ona060p037z4pqktt8av8tg3g', '77yfufw765qzng0', 'ulw0dsl2sx5wwml3pqnrnq1dxrkrr7lz72r7xbhydxlxff5gtb', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('55j7rxx1prt14qedi3k94p42wloz5asxigh8ax2tblcaimsp26', '77yfufw765qzng0', '4cs0px0pjz4lnkfjadkada77mqax5hod3v9lzg729c9iin30oq', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('cezz6fj0mdmsux7ymyjvs70x3jv1wyo2mbndxq33im9z4wuz5i', '77yfufw765qzng0', 'rbffwqltf330ggyn9420yfglyllsnxwvz15xwft5dgzlw3i6w3', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('oj9jpzg01ucjrbznw6nfruv99vy75ho1sytky0y4lpvr9j6nhc', '77yfufw765qzng0', 'uzu6ax672e33cpayqpl1a2wz5e3z59k1trqraejzlbtqs2hyni', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wc4m9ebju5bbde3z9utv9tk4929k7gi86os8ucp5lhcac2jmyf', '77yfufw765qzng0', '95d6gfutzpady81wvx3dh86psyjg59bvv1rudw9ootj7btixtv', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('dtw9ft1p4a9njrbl20phqwdxdnxxxjv773yru0i6q4tgqhhgpp', '77yfufw765qzng0', 'twdm1nnfx4t4izw48srjmxvlvxd509sllnd26g7w313guxnnlb', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('rfkdvumme1aoa4gsrkl8kfacmn0217di5wznhdws7p75gd8e7y', '77yfufw765qzng0', 'yutflec8rvcp2xzyubqp6t52q9v1gj7bev9q4y2jbhld6cpaow', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8zpyawji2v3sfw54dhw8g6s1sv0f8nm31onpzm5p2f7ll6vsjt', '77yfufw765qzng0', '22eup1sckullo35wjaaiv71b9y0mf1ubajl5m9czb26r6lz17m', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('kh832oa5z79t2gn942yfkmbr4mrlpakhbftarljmqa4c0vh4nu', '36sbvefc6n81dl1', '8k7ew27s60ka1ky7mxneqef5wh1leg8xesath66zmq0gufbcms', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('nsnpt18oya7pp1oamnh0qjlrh3uwlhpxzjruvwsv823satqu5r', '36sbvefc6n81dl1', 'isx7dqgqv4erffxlzgdflg3jjjk5amogatdissld59dpo3avis', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('elqwcjd826k7qbsg8h56mymljpuowt558lz8czq6ts6cxsw9ua', '36sbvefc6n81dl1', '6arw0mepoq5ok64ypwdv9nwhjhjy97rgyu04l8nc5szo0o6115', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('m1r774vn0ipeht8bq1g9bbj8jsn5kjsfao181ufhm5jqnx4gr5', '36sbvefc6n81dl1', 'syf862q5yv32l0utvpjgcru0qzhuykgttxmzx3dsvkbjwmgn28', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wl9uxgurym3znkeqtpxqu6wkql0jbuyb3ix3wkx0qikqhz5nhm', '36sbvefc6n81dl1', 'g2gyk843jggmdc339fbcjca8mb6co0rn1v7sqiuigjvhj23qdm', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('zda1w5bxdplp1232otcja2fxedostpxxltfs2z43i77djauxrm', '36sbvefc6n81dl1', 'xl1om16agjdwfuigpdblhuri6aklxueu075i60idgwxv4bzzr6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5rerqr2q3c1823c32b4f0cf58mw1wc7i6nz87y1h6j0186ri5g', '36sbvefc6n81dl1', 'z631zkkyuufs5eibcm0orataptn125eik9qvlaz3ek599eqthu', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('g03adrjgppdqnsmp4zhd10t6vbkaevuy48rm8w0b0xifpvh1pf', '36sbvefc6n81dl1', 'tx8d5fsy2z6cv9o1f3auip3na53l0rpcrjuqpy7u8enqvtl09x', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('lspsvgfy9bo9z812gyqo97955npomsh8fia81i960jq1jm6g1j', 'icqlt67n2fd7p34', '4w0ns2ssacekekempismudw7tzza8ra0x7iyvjssc3tyrfhfka', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('q8i2fdlv0wbxzkl4xwjp206fyvmbh7kmyez95qg8trjb1wqahs', 'icqlt67n2fd7p34', '62b9k3o65hlvzf721ehdrirwnnrl5we0ekwgwst88plgvwdf8n', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('jl4vasjqzyi3f28dg09wer21y5umhn2v85ucoqb9wzyez9nggu', 'icqlt67n2fd7p34', 'kpg9vggfh7kb5l7k3fq97rrfi0bcda1s92axparsrqqyg9nluq', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('c21k9k79f7qk1uxqkiqudd86ysfxdrtznw17h1hl1xh9rirpd8', 'icqlt67n2fd7p34', 'm5a5pnmc24wdblfb7mf22sossxvnn5yxo87egn1e09t4ur2beb', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ecfnd5ef5wu61eoe7gfkmqydqygqbf4r1fcrhx55mv661k2fa4', 'icqlt67n2fd7p34', 'y25usfo81ffw2cew8l03r270tt2rgy9h6rmuq54gkx206vz8dt', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('eqbm14mgeqghtshwcolt3cxjsm113xqt947nm6i79rruocdr1m', 'icqlt67n2fd7p34', 'dcwq9lto3gs5mn2hb4wrdw2hvicvivycel92zjb5mtozke8pi8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('9c7gtnnbuxc15ar2gl9c5g6vfnudux17ljaxuwofwmypbszgpr', 'icqlt67n2fd7p34', 'wy7ij3b9t0toz9rjponkrdes55wex6cp6ns077cdmm2epeeb3a', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('m31tuj5v4m4llqar1q6ly6no93sgfsm42cboxxchs7op3nk8bx', 'icqlt67n2fd7p34', 'hzzq7fjsb3f4gcy0vk08xjizsbfknzl7863uqlx82wyo4v6y8e', '2023-11-17 17:00:08.000');


