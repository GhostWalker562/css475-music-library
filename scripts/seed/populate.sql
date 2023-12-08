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
-- Beach House
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7qxupjgxjo14eig', 'Beach House', '0@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb3e38a46a56a423d8f741c09','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:0@artist.com', '7qxupjgxjo14eig', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7qxupjgxjo14eig', 'A journey through the spectrum of sound in every album.', 'Beach House');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zpvfo6fuct3d5gpdqr7ryp0pp0cskufqsrrdilc0w30gzad5rx','7qxupjgxjo14eig', 'https://i.scdn.co/image/ab67616d0000b2739b7190e673e46271b2754aab', 'Beach House Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e04mfvgsvtf8vzf9gg85z8u6jldxtvh0xbpy123xs3mg21b6s1','Space Song','7qxupjgxjo14eig','POP','7H0ya83CMmgFcOhw0UB6ow','https://p.scdn.co/mp3-preview/3d50d7331c2ef197699e796d08cf8d4009591be0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zpvfo6fuct3d5gpdqr7ryp0pp0cskufqsrrdilc0w30gzad5rx', 'e04mfvgsvtf8vzf9gg85z8u6jldxtvh0xbpy123xs3mg21b6s1', '0');
-- Don Omar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pjo7gh034qmmgnj', 'Don Omar', '1@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:1@artist.com', 'pjo7gh034qmmgnj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pjo7gh034qmmgnj', 'A tapestry of rhythms that echo the pulse of life.', 'Don Omar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sh5ox120rkcovd42e62b1100xexqhz55015x1djx8nqcj1628l','pjo7gh034qmmgnj', 'https://i.scdn.co/image/ab67616d0000b2734640a26eb27649006be29a94', 'Don Omar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('eiybte5uzduma3yk3hzgwvwm72zvrl9itf28yx1e8ajqads3sa','Danza Kuduro','pjo7gh034qmmgnj','POP','2a1o6ZejUi8U3wzzOtCOYw',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sh5ox120rkcovd42e62b1100xexqhz55015x1djx8nqcj1628l', 'eiybte5uzduma3yk3hzgwvwm72zvrl9itf28yx1e8ajqads3sa', '0');
-- Andy Williams
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2vxw9kuoicsyl30', 'Andy Williams', '2@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5888acdca5e748e796b4e69b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:2@artist.com', '2vxw9kuoicsyl30', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2vxw9kuoicsyl30', 'A confluence of cultural beats and contemporary tunes.', 'Andy Williams');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('buz5vmfh0qmdgt2ogz3d208jk605j6keygl730havm817ynoep','2vxw9kuoicsyl30', 'https://i.scdn.co/image/ab67616d0000b27398073965947f92f1641b8356', 'Andy Williams Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rxczjtgr5h7gam49f7k49f5kqirucuxn0lzsnauxgev33kt9f2','Its the Most Wonderful Time of the Year','2vxw9kuoicsyl30','POP','5hslUAKq9I9CG2bAulFkHN','https://p.scdn.co/mp3-preview/853f441c5fc1b25ba88bb300c17119cde36da675?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('buz5vmfh0qmdgt2ogz3d208jk605j6keygl730havm817ynoep', 'rxczjtgr5h7gam49f7k49f5kqirucuxn0lzsnauxgev33kt9f2', '0');
-- Brray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7k7a88f3jzj3dwh', 'Brray', '3@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2c7fe2c8895d2cd41e25aed6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:3@artist.com', '7k7a88f3jzj3dwh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7k7a88f3jzj3dwh', 'Revolutionizing the music scene with innovative compositions.', 'Brray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ry3l0dhuv4kaqzjxxotb26d7hto2rozdmqyyyns6i2gqbot7ts','7k7a88f3jzj3dwh', NULL, 'Brray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ob6cvhkcd5xx19eaj9k0je08ui6iv0ou8qmuxibry5w9tvpz73','LOKERA','7k7a88f3jzj3dwh','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ry3l0dhuv4kaqzjxxotb26d7hto2rozdmqyyyns6i2gqbot7ts', 'ob6cvhkcd5xx19eaj9k0je08ui6iv0ou8qmuxibry5w9tvpz73', '0');
-- Twisted
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xcvuq8fp877tjp7', 'Twisted', '4@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2615ef39cf9128c447b31619','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:4@artist.com', 'xcvuq8fp877tjp7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xcvuq8fp877tjp7', 'Redefining what it means to be an artist in the digital age.', 'Twisted');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rmp22xx9wzyoyu1js9fh6mxx90j4o17bfdpvhnrhgijcyu5bcj','xcvuq8fp877tjp7', 'https://i.scdn.co/image/ab67616d0000b273f5e2ffd88f07e55f34c361c8', 'Twisted Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('si2w095y2mutzmo2bz6zlyykldbfzk5a3an9nyeeznekbucc27','WORTH NOTHING','xcvuq8fp877tjp7','POP','3PjbA0O5olhampPMdaB0V1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rmp22xx9wzyoyu1js9fh6mxx90j4o17bfdpvhnrhgijcyu5bcj', 'si2w095y2mutzmo2bz6zlyykldbfzk5a3an9nyeeznekbucc27', '0');
-- Nicki Minaj
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qpdbk86serq098f', 'Nicki Minaj', '5@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03578c92e15089c645b794f5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:5@artist.com', 'qpdbk86serq098f', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qpdbk86serq098f', 'A rap icon known for her versatile flow and bold personality.', 'Nicki Minaj');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jmvc1auc3l17ehsdpizctqjxtq7q56a1g9wyt56gsklvk3zka8','qpdbk86serq098f', 'https://i.scdn.co/image/ab67616d0000b2737e8f938c02fac3b564931116', 'Nicki Minaj Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1s9jdbd53wbd9m5giegjxwyitqtq7n7iigxr5ivthnfaryzfxs','Barbie World (with Aqua) [From Barbie The Album]','qpdbk86serq098f','POP','741UUVE2kuITl0c6zuqqbO','https://p.scdn.co/mp3-preview/f654928ccaa4e6a9fb09a6eb3f208383eccc12a9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jmvc1auc3l17ehsdpizctqjxtq7q56a1g9wyt56gsklvk3zka8', '1s9jdbd53wbd9m5giegjxwyitqtq7n7iigxr5ivthnfaryzfxs', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('so67logjfpikreijb4xrvepxe6mdggo2hv7sjbq2bwy7f6hk9l','Princess Diana (with Nicki Minaj)','qpdbk86serq098f','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jmvc1auc3l17ehsdpizctqjxtq7q56a1g9wyt56gsklvk3zka8', 'so67logjfpikreijb4xrvepxe6mdggo2hv7sjbq2bwy7f6hk9l', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0jagwlnf81dvugvcfgykmm9arswljwa1n3zs3f4s7ojst12ejn','Red Ruby Da Sleeze','qpdbk86serq098f','POP','4ZYAU4A2YBtlNdqOUtc7T2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jmvc1auc3l17ehsdpizctqjxtq7q56a1g9wyt56gsklvk3zka8', '0jagwlnf81dvugvcfgykmm9arswljwa1n3zs3f4s7ojst12ejn', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uiwl03dj8hcu6twkyxdbu04vj42ogyxwdib3ywyg4irb2ytoe4','Super Freaky Girl','qpdbk86serq098f','POP','4C6Uex2ILwJi9sZXRdmqXp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jmvc1auc3l17ehsdpizctqjxtq7q56a1g9wyt56gsklvk3zka8', 'uiwl03dj8hcu6twkyxdbu04vj42ogyxwdib3ywyg4irb2ytoe4', '3');
-- Mambo Kingz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('shct50rtcsyy0q0', 'Mambo Kingz', '6@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb881ed0aa97cc8420685dc90e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:6@artist.com', 'shct50rtcsyy0q0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('shct50rtcsyy0q0', 'A symphony of emotions expressed through sound.', 'Mambo Kingz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ira9xf33b4wgphdw8twu1mtssm4z9gh679cmet3o4b241htoa6','shct50rtcsyy0q0', NULL, 'Mambo Kingz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gxthmdyoocucdyulztqd4ifutxdnqgbi1ir4raab2ish5zc3wo','Mejor Que Yo','shct50rtcsyy0q0','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ira9xf33b4wgphdw8twu1mtssm4z9gh679cmet3o4b241htoa6', 'gxthmdyoocucdyulztqd4ifutxdnqgbi1ir4raab2ish5zc3wo', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c09vipslk01el537runr94km8qc23l6fkzewiqk3r2651s2e9j','Mas Rica Que Ayer','shct50rtcsyy0q0','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ira9xf33b4wgphdw8twu1mtssm4z9gh679cmet3o4b241htoa6', 'c09vipslk01el537runr94km8qc23l6fkzewiqk3r2651s2e9j', '1');
-- Lil Durk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1q0upso77i3f93l', 'Lil Durk', '7@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3513370298ee50e52dfc7326','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:7@artist.com', '1q0upso77i3f93l', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1q0upso77i3f93l', 'A symphony of emotions expressed through sound.', 'Lil Durk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9227msouz39bh81omssomum7k8jr6k9mc8kfkzpma2yau9llgh','1q0upso77i3f93l', 'https://i.scdn.co/image/ab67616d0000b2736234c2c6d4bb935839ac4719', 'Lil Durk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fdgc3uto15vni5lfu4ntpzwow5ihvog17ylt87wbq9f31rj3xq','Stand By Me (feat. Morgan Wallen)','1q0upso77i3f93l','POP','1fXnu2HzxbDtoyvFPWG3Bw','https://p.scdn.co/mp3-preview/ed64766975b1f0b3aa57741935c3f20e833c47db?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9227msouz39bh81omssomum7k8jr6k9mc8kfkzpma2yau9llgh', 'fdgc3uto15vni5lfu4ntpzwow5ihvog17ylt87wbq9f31rj3xq', '0');
-- Tyler The Creator
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('arp52o6153abpqs', 'Tyler The Creator', '8@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:8@artist.com', 'arp52o6153abpqs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('arp52o6153abpqs', 'Pushing the boundaries of music with unique style and bold lyrics.', 'Tyler The Creator');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ckzqa35p5cxjutfld064yb92sccg2fitxp2c6d4g1ac8l8davn','arp52o6153abpqs', 'https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3', 'Tyler The Creator Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g4klk7sah7zs0p0mzkzorke9qt2ei1c3k3j4lawyutvz3s0tgj','See You Again','arp52o6153abpqs','POP','7KA4W4McWYRpgf0fWsJZWB','https://p.scdn.co/mp3-preview/c703198293891e3b276800ea6b187cf7951d3d7d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ckzqa35p5cxjutfld064yb92sccg2fitxp2c6d4g1ac8l8davn', 'g4klk7sah7zs0p0mzkzorke9qt2ei1c3k3j4lawyutvz3s0tgj', '0');
-- MC Caverinha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ozwtvl65ux4o7zo', 'MC Caverinha', '9@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb48d62acd2e6408096141a088','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:9@artist.com', 'ozwtvl65ux4o7zo', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ozwtvl65ux4o7zo', 'A journey through the spectrum of sound in every album.', 'MC Caverinha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ddljkrsivbyunkmcgtstnapnjmo6fxuenc3uofp542fgg5jm7s','ozwtvl65ux4o7zo', NULL, 'MC Caverinha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c7oxh0xmmlld2mvbx54gafyq2bh16ohnzid26uqe9m81kxbeq0','Carto B','ozwtvl65ux4o7zo','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ddljkrsivbyunkmcgtstnapnjmo6fxuenc3uofp542fgg5jm7s', 'c7oxh0xmmlld2mvbx54gafyq2bh16ohnzid26uqe9m81kxbeq0', '0');
-- J Balvin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c07jnf2483hosni', 'J Balvin', '10@artist.com', 'https://i.scdn.co/image/ab67616d0000b273498cf6571df9adf37e46b527','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:10@artist.com', 'c07jnf2483hosni', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c07jnf2483hosni', 'A journey through the spectrum of sound in every album.', 'J Balvin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jqgs5sb4heocmp8e164pblf9k1lyvo357qxdmax9kmci23obxl','c07jnf2483hosni', 'https://i.scdn.co/image/ab67616d0000b2734891d9b25d8919448388f3bb', 'J Balvin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vezncmffjwoqf904xs5tef8op7uj454gf7nggos39fzasobufp','LA CANCI','c07jnf2483hosni','POP','0fea68AdmYNygeTGI4RC18',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jqgs5sb4heocmp8e164pblf9k1lyvo357qxdmax9kmci23obxl', 'vezncmffjwoqf904xs5tef8op7uj454gf7nggos39fzasobufp', '0');
-- Mr.Kitty
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3b3fecfpww9z0ke', 'Mr.Kitty', '11@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb78ed447c78f07632e82ec0d8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:11@artist.com', '3b3fecfpww9z0ke', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3b3fecfpww9z0ke', 'An endless quest for musical perfection.', 'Mr.Kitty');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5nfvuf4ixetficr6sknnmgbpsbmt29zfscqa9hnv0ntv3l30wa','3b3fecfpww9z0ke', 'https://i.scdn.co/image/ab67616d0000b273b492477206075438e0751176', 'Mr.Kitty Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u97lrtyx7lied7d2lls6qaj4hl4r6ya5zffa3o1fe5810caag3','After Dark','3b3fecfpww9z0ke','POP','2LKOHdMsL0K9KwcPRlJK2v','https://p.scdn.co/mp3-preview/eb9de15a4465f504ee0eadba93e7d265ee0ee6ba?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5nfvuf4ixetficr6sknnmgbpsbmt29zfscqa9hnv0ntv3l30wa', 'u97lrtyx7lied7d2lls6qaj4hl4r6ya5zffa3o1fe5810caag3', '0');
-- Grupo Marca Registrada
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mel4c1sdl9ol6ku', 'Grupo Marca Registrada', '12@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8059103a66f9c25b91b375a9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:12@artist.com', 'mel4c1sdl9ol6ku', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('mel4c1sdl9ol6ku', 'Igniting the stage with electrifying performances.', 'Grupo Marca Registrada');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rcue941l7azf5fy94usw0f4mqix3hxs9sfnoga9hj95h1950td','mel4c1sdl9ol6ku', 'https://i.scdn.co/image/ab67616d0000b273bae22025cf282ad72b167e79', 'Grupo Marca Registrada Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('htgr52tfobbffc2uhy5n82kd8npvoi3dqt8fom8iv5cmtczs2r','Di Que Si','mel4c1sdl9ol6ku','POP','0pliiCOWPN0IId8sXAqNJr','https://p.scdn.co/mp3-preview/622a816595469fdb54c42c88259f303266dc8aa7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rcue941l7azf5fy94usw0f4mqix3hxs9sfnoga9hj95h1950td', 'htgr52tfobbffc2uhy5n82kd8npvoi3dqt8fom8iv5cmtczs2r', '0');
-- Shakira
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6glmoz5ayzezk1r', 'Shakira', '13@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb284894d68fe2f80cad555110','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:13@artist.com', '6glmoz5ayzezk1r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6glmoz5ayzezk1r', 'Pushing the boundaries of sound with each note.', 'Shakira');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i11880qbr8e5uw9396purq1zr1780kq56yx6y3flij5mgt93r4','6glmoz5ayzezk1r', NULL, 'Shakira Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('40ahyvzgnnt3ro82uw0ckbgs6nq2p1d980slrneli3upg4o0fy','Shakira: Bzrp Music Sessions, Vol. 53','6glmoz5ayzezk1r','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i11880qbr8e5uw9396purq1zr1780kq56yx6y3flij5mgt93r4', '40ahyvzgnnt3ro82uw0ckbgs6nq2p1d980slrneli3upg4o0fy', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('sjz1vj1qumudln3akmmuqzz88xr1hnaygmt08alosokvh1gxe5','Acrs','6glmoz5ayzezk1r','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i11880qbr8e5uw9396purq1zr1780kq56yx6y3flij5mgt93r4', 'sjz1vj1qumudln3akmmuqzz88xr1hnaygmt08alosokvh1gxe5', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xiu3a3ruz5ih1uar8m3h2h84becxblluq3exbmvue76uehka63','Te Felicito','6glmoz5ayzezk1r','POP','2rurDawMfoKP4uHyb2kJBt','https://p.scdn.co/mp3-preview/6b4b2be03b14bf758835c8f28f35834da35cc1c3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i11880qbr8e5uw9396purq1zr1780kq56yx6y3flij5mgt93r4', 'xiu3a3ruz5ih1uar8m3h2h84becxblluq3exbmvue76uehka63', '2');
-- Arctic Monkeys
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d6igj8oxl4ykk7x', 'Arctic Monkeys', '14@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:14@artist.com', 'd6igj8oxl4ykk7x', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('d6igj8oxl4ykk7x', 'Rock innovators, known for their sharp lyrics and compelling sound.', 'Arctic Monkeys');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xllvjs9kxekmgjc638scl7kmd08yfub7i7m1syf03x2g6u6sh4','d6igj8oxl4ykk7x', 'https://i.scdn.co/image/ab67616d0000b2734ae1c4c5c45aabe565499163', 'Arctic Monkeys Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uq3gfi2wu06i2th3jjkbgdig7o13pus0ur70dkpsqfn4rhs9kb','I Wanna Be Yours','d6igj8oxl4ykk7x','POP','5XeFesFbtLpXzIVDNQP22n','https://p.scdn.co/mp3-preview/07de30bde8363d9ff78b72339245c151f67af451?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xllvjs9kxekmgjc638scl7kmd08yfub7i7m1syf03x2g6u6sh4', 'uq3gfi2wu06i2th3jjkbgdig7o13pus0ur70dkpsqfn4rhs9kb', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('swiim390n98q48kg721i138s43inybu0gmas3rq1ysg37v4s5a','505','d6igj8oxl4ykk7x','POP','58ge6dfP91o9oXMzq3XkIS','https://p.scdn.co/mp3-preview/1b23606bada6aacb339535944c1fe505898195e1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xllvjs9kxekmgjc638scl7kmd08yfub7i7m1syf03x2g6u6sh4', 'swiim390n98q48kg721i138s43inybu0gmas3rq1ysg37v4s5a', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('akps2z50jq1w8gfaj5k2g4t3eskoxuo1qtm8l85oatkqz69iyz','Do I Wanna Know?','d6igj8oxl4ykk7x','POP','5FVd6KXrgO9B3JPmC8OPst','https://p.scdn.co/mp3-preview/006bc465fe3d1c04dae93a050eca9d402a7322b8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xllvjs9kxekmgjc638scl7kmd08yfub7i7m1syf03x2g6u6sh4', 'akps2z50jq1w8gfaj5k2g4t3eskoxuo1qtm8l85oatkqz69iyz', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2keh7obku8zvbr74spg8aovmlzrv0bq3r3j837le5tgqu11iie','Whyd You Only Call Me When Youre High?','d6igj8oxl4ykk7x','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xllvjs9kxekmgjc638scl7kmd08yfub7i7m1syf03x2g6u6sh4', '2keh7obku8zvbr74spg8aovmlzrv0bq3r3j837le5tgqu11iie', '3');
-- Veigh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fquivpyoo4mhthe', 'Veigh', '15@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfe49a8f4b6b1a82a29f43112','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:15@artist.com', 'fquivpyoo4mhthe', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fquivpyoo4mhthe', 'Where words fail, my music speaks.', 'Veigh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zcsrqouwagupzr3rcz48gudquxr5pp1wwoja589avf3bpuke3n','fquivpyoo4mhthe', 'https://i.scdn.co/image/ab67616d0000b273ce0947b85c30490447dbbd91', 'Veigh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('y15kfy5kv7hl3o3qn5jqxkaftqiz0tr01vvtm2u550nawtzq55','Novo Balan','fquivpyoo4mhthe','POP','4hKLzFvNwHF6dPosGT30ed','https://p.scdn.co/mp3-preview/af031ca41aac7b60676833187f323d94fc387bce?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zcsrqouwagupzr3rcz48gudquxr5pp1wwoja589avf3bpuke3n', 'y15kfy5kv7hl3o3qn5jqxkaftqiz0tr01vvtm2u550nawtzq55', '0');
-- Daddy Yankee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5r8ghd0s9bktdvk', 'Daddy Yankee', '16@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf9ad208bbff79c1ce09c77c1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:16@artist.com', '5r8ghd0s9bktdvk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5r8ghd0s9bktdvk', 'Striking chords that resonate across generations.', 'Daddy Yankee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qusnczr5tv6y89judjmfrobgpi2mes1yummkehmiil2qudxr3n','5r8ghd0s9bktdvk', 'https://i.scdn.co/image/ab67616d0000b2736bdcdf82ecce36bff808a40c', 'Daddy Yankee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yjk2ixdni9kuqkk28b8lbznys2x3iku4zmtnmbgp8g0jsg9q71','Gasolina','5r8ghd0s9bktdvk','POP','228BxWXUYQPJrJYHDLOHkj','https://p.scdn.co/mp3-preview/7c545be6847f3a6b13c4ad9c70d10a34f49a92d3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qusnczr5tv6y89judjmfrobgpi2mes1yummkehmiil2qudxr3n', 'yjk2ixdni9kuqkk28b8lbznys2x3iku4zmtnmbgp8g0jsg9q71', '0');
-- Sachin-Jigar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5z4btibk3il3cy8', 'Sachin-Jigar', '17@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba038d7d87f8577bbb9686bd3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:17@artist.com', '5z4btibk3il3cy8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5z4btibk3il3cy8', 'Blending genres for a fresh musical experience.', 'Sachin-Jigar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5ks5im4146fl7183xrgyk3vd8syh3bhkvv5ko04yqxsirccgqw','5z4btibk3il3cy8', NULL, 'Sachin-Jigar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pu7srdo8v6aoo7rg0u1xc7h7xetn5894hyd50u97k6a8womk0n','Tere Vaaste (From "Zara Hatke Zara Bachke")','5z4btibk3il3cy8','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5ks5im4146fl7183xrgyk3vd8syh3bhkvv5ko04yqxsirccgqw', 'pu7srdo8v6aoo7rg0u1xc7h7xetn5894hyd50u97k6a8womk0n', '0');
-- Bad Bunny
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('03km7b1729p8e2u', 'Bad Bunny', '18@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9ad50e478a469448c6f369df','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:18@artist.com', '03km7b1729p8e2u', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('03km7b1729p8e2u', 'A trailblazer in Latin trap and reggaeton, known for his charismatic style and innovative music.', 'Bad Bunny');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('z9so1enq9rnrpr4v0umu1zhzjkiu4h5xdwp6ytug075ornq9l8','03km7b1729p8e2u', 'https://i.scdn.co/image/ab67616d0000b273ab5c9cd818ad6ed3e9b79cd1', 'Bad Bunny Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('87h9gsuy0ldqu82k4xtw4jf3zrjidxlsnay2houlugyhptx86e','WHERE SHE GOES','03km7b1729p8e2u','POP','7ro0hRteUMfnOioTFI5TG1','https://p.scdn.co/mp3-preview/b9b7e4c982b33ee23c4867f7a3025e3598c35760?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z9so1enq9rnrpr4v0umu1zhzjkiu4h5xdwp6ytug075ornq9l8', '87h9gsuy0ldqu82k4xtw4jf3zrjidxlsnay2houlugyhptx86e', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zjuka8uhx0q2a5cu6s0olayjoz29lfhsrx63advyjxvgp8kv4l','un x100to','03km7b1729p8e2u','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z9so1enq9rnrpr4v0umu1zhzjkiu4h5xdwp6ytug075ornq9l8', 'zjuka8uhx0q2a5cu6s0olayjoz29lfhsrx63advyjxvgp8kv4l', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('prxsoyyptujky9dkjdrm3i55d78y4s4eggx6lz4s6zzset2s9i','Coco Chanel','03km7b1729p8e2u','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z9so1enq9rnrpr4v0umu1zhzjkiu4h5xdwp6ytug075ornq9l8', 'prxsoyyptujky9dkjdrm3i55d78y4s4eggx6lz4s6zzset2s9i', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xojihmqtvq2dg8ssov5oo62ax5oc7nwcirp1rli58pz546yzj8','Titi Me Pregunt','03km7b1729p8e2u','POP','1IHWl5LamUGEuP4ozKQSXZ','https://p.scdn.co/mp3-preview/53a6217761f8fdfcff92189cafbbd1cc21fdb813?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z9so1enq9rnrpr4v0umu1zhzjkiu4h5xdwp6ytug075ornq9l8', 'xojihmqtvq2dg8ssov5oo62ax5oc7nwcirp1rli58pz546yzj8', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ehmxjjjy240qewrckcvzrmemo68k7dd7jclunqspf1yrq1ry82','Efecto','03km7b1729p8e2u','POP','5Eax0qFko2dh7Rl2lYs3bx','https://p.scdn.co/mp3-preview/a622a47c8df98ef72676608511c0b2e1d5d51268?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z9so1enq9rnrpr4v0umu1zhzjkiu4h5xdwp6ytug075ornq9l8', 'ehmxjjjy240qewrckcvzrmemo68k7dd7jclunqspf1yrq1ry82', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uybo2xneaxbuxbbftvb426amogyowf1hyw6ntuy6rod75wv2a3','Neverita','03km7b1729p8e2u','POP','31i56LZnwE6uSu3exoHjtB','https://p.scdn.co/mp3-preview/b50a3cafa2eb688f811d4079812649bfba050417?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z9so1enq9rnrpr4v0umu1zhzjkiu4h5xdwp6ytug075ornq9l8', 'uybo2xneaxbuxbbftvb426amogyowf1hyw6ntuy6rod75wv2a3', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xxd84zm47bbrom310rfaeellfahlp7wapx07gmtxn6g927unoc','Moscow Mule','03km7b1729p8e2u','POP','6Xom58OOXk2SoU711L2IXO','https://p.scdn.co/mp3-preview/77b12f38abcff65705166d67b5657f70cd890635?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z9so1enq9rnrpr4v0umu1zhzjkiu4h5xdwp6ytug075ornq9l8', 'xxd84zm47bbrom310rfaeellfahlp7wapx07gmtxn6g927unoc', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lqhcp6flrc4ynasdoni0j8t5fe6m53xrsl34p4iysin1p39tm5','Yonaguni','03km7b1729p8e2u','POP','2JPLbjOn0wPCngEot2STUS','https://p.scdn.co/mp3-preview/cbade9b0e669565ac8c7c07490f961e4c471b9ee?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z9so1enq9rnrpr4v0umu1zhzjkiu4h5xdwp6ytug075ornq9l8', 'lqhcp6flrc4ynasdoni0j8t5fe6m53xrsl34p4iysin1p39tm5', '7');
-- SEVENTEEN
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lbv4brabyv92ucl', 'SEVENTEEN', '19@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb61916bb9f5c6a1a9ba1c9ab6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:19@artist.com', 'lbv4brabyv92ucl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lbv4brabyv92ucl', 'The heartbeat of a new generation of music lovers.', 'SEVENTEEN');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('whebpws57wa37su47teklx7l6bjhx7ayn56xc82r2j8xomswld','lbv4brabyv92ucl', 'https://i.scdn.co/image/ab67616d0000b27380e31ba0c05187e6310ef264', 'SEVENTEEN Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kcq8z9485e3vfc6ppzpc7dorx2ia88z9z4pq9gzgpiflsx59yp','Super','lbv4brabyv92ucl','POP','3AOf6YEpxQ894FmrwI9k96','https://p.scdn.co/mp3-preview/1dd31996959e603934dbe4c7d3ee377243a0f890?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('whebpws57wa37su47teklx7l6bjhx7ayn56xc82r2j8xomswld', 'kcq8z9485e3vfc6ppzpc7dorx2ia88z9z4pq9gzgpiflsx59yp', '0');
-- Maroon 5
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rfr4fb3x3qgkyq6', 'Maroon 5', '20@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:20@artist.com', 'rfr4fb3x3qgkyq6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rfr4fb3x3qgkyq6', 'Music is my canvas, and notes are my paint.', 'Maroon 5');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tyk3pahd7iyj9s7juta4riguiocn7xwt9gnl8u44bc9my72p23','rfr4fb3x3qgkyq6', 'https://i.scdn.co/image/ab67616d0000b273ce7d499847da02a9cbd1c084', 'Maroon 5 Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r6pd5fxzwav14t3euh6c7yn6b6cmys6f7ugnzl5y6kecwn4tg5','Payphone','rfr4fb3x3qgkyq6','POP','4P0osvTXoSYZZC2n8IFH3c',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tyk3pahd7iyj9s7juta4riguiocn7xwt9gnl8u44bc9my72p23', 'r6pd5fxzwav14t3euh6c7yn6b6cmys6f7ugnzl5y6kecwn4tg5', '0');
-- Vishal-Shekhar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sfz8wymsu3eemzv', 'Vishal-Shekhar', '21@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb90b6c3d093f9b02aad628eaf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:21@artist.com', 'sfz8wymsu3eemzv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sfz8wymsu3eemzv', 'Pushing the boundaries of sound with each note.', 'Vishal-Shekhar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9qvg3p2mwfflzu6lkunizbu5nv8pdaym2wa2esk89q7k6z9b64','sfz8wymsu3eemzv', NULL, 'Vishal-Shekhar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k5j77qgi7wppnw8ti5q9y47jd0jfl7ucfmod3wlhcxst7aahn3','Besharam Rang (From "Pathaan")','sfz8wymsu3eemzv','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9qvg3p2mwfflzu6lkunizbu5nv8pdaym2wa2esk89q7k6z9b64', 'k5j77qgi7wppnw8ti5q9y47jd0jfl7ucfmod3wlhcxst7aahn3', '0');
-- Melanie Martinez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('o76464g2xbzz9ov', 'Melanie Martinez', '22@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb77ecd63aaebe2225b07c89f0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:22@artist.com', 'o76464g2xbzz9ov', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('o76464g2xbzz9ov', 'Sculpting soundwaves into masterpieces of auditory art.', 'Melanie Martinez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('triww53xyxm13o36vsxpfnuqxdz3m0b3q35hs62p6vcomf41k7','o76464g2xbzz9ov', 'https://i.scdn.co/image/ab67616d0000b2733c6c534cdacc9cf53e6d2977', 'Melanie Martinez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mskcef4c2asmtnv0cnssv2w5vxovhvuciyaoj16dxxind7m22g','VOID','o76464g2xbzz9ov','POP','6wmKvtSmyTqHNo44OBXVN1','https://p.scdn.co/mp3-preview/9a2ae9278ecfe2ed8d628dfe05699bf24395d6a0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('triww53xyxm13o36vsxpfnuqxdz3m0b3q35hs62p6vcomf41k7', 'mskcef4c2asmtnv0cnssv2w5vxovhvuciyaoj16dxxind7m22g', '0');
-- Meghan Trainor
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yt16gxbv1ur0a8k', 'Meghan Trainor', '23@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4d8f97058ff993df0f4eb9ee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:23@artist.com', 'yt16gxbv1ur0a8k', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yt16gxbv1ur0a8k', 'A confluence of cultural beats and contemporary tunes.', 'Meghan Trainor');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3gq9ovsjhi87r9fpmbyad0ty61g6cbxgccthdlcr788hi8c3kh','yt16gxbv1ur0a8k', 'https://i.scdn.co/image/ab67616d0000b2731a4f1ada93881da4ca8060ff', 'Meghan Trainor Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yzg40b5ve05ugengehb6jf9kcjlxd8jnkty5hs8uz25goqizsm','Made You Look','yt16gxbv1ur0a8k','POP','0QHEIqNKsMoOY5urbzN48u','https://p.scdn.co/mp3-preview/f0eb89945aa820c0f30b5e97f8e2cab42d9f0a99?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3gq9ovsjhi87r9fpmbyad0ty61g6cbxgccthdlcr788hi8c3kh', 'yzg40b5ve05ugengehb6jf9kcjlxd8jnkty5hs8uz25goqizsm', '0');
-- Dave
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xfqfavvocei2thj', 'Dave', '24@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:24@artist.com', 'xfqfavvocei2thj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xfqfavvocei2thj', 'A master of words, blending rap with social commentary and raw emotion.', 'Dave');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('csqx3f8cwjw05zqlhvntk3vykosecgfzi9632q0kzg619ko8wf','xfqfavvocei2thj', 'https://i.scdn.co/image/ab67616d0000b273e3a09a9ae3f1fa102c110e60', 'Dave Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7y7dmrlgqx48vvpkejeltwupae9zbvnrvswm4ohxroc65r2d77','Sprinter','xfqfavvocei2thj','POP','2FDTHlrBguDzQkp7PVj16Q',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('csqx3f8cwjw05zqlhvntk3vykosecgfzi9632q0kzg619ko8wf', '7y7dmrlgqx48vvpkejeltwupae9zbvnrvswm4ohxroc65r2d77', '0');
-- Manuel Turizo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xhx0vt58d6ie6ub', 'Manuel Turizo', '25@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebabd3e69b432d6187cf4e28c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:25@artist.com', 'xhx0vt58d6ie6ub', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xhx0vt58d6ie6ub', 'A standout in reggaeton, known for his smooth voice and romantic lyrics.', 'Manuel Turizo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('a3rrxxrva2pgt2as68mbaypf53q44h9n2iclbzl1i35xemipch','xhx0vt58d6ie6ub', 'https://i.scdn.co/image/ab67616d0000b273c9f744b0d62da795bc21d04a', 'Manuel Turizo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dt3uu1q4aqilkkwvdg2zyltjbxxgafcndnjvvwyfn8dphuckhl','La Bachata','xhx0vt58d6ie6ub','POP','5ww2BF9slyYgNOk37BlC4u','https://p.scdn.co/mp3-preview/0232b53fd7849e6696e1ab3099dd01dd00823f17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a3rrxxrva2pgt2as68mbaypf53q44h9n2iclbzl1i35xemipch', 'dt3uu1q4aqilkkwvdg2zyltjbxxgafcndnjvvwyfn8dphuckhl', '0');
-- Ana Castela
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tt19xigucwz84uh', 'Ana Castela', '26@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26abde7ba3cfdfb8c1900baf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:26@artist.com', 'tt19xigucwz84uh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tt19xigucwz84uh', 'The heartbeat of a new generation of music lovers.', 'Ana Castela');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('c512716t54f84djvyb3u32a88cgdwjk24h82g5zz0ibgj5t3qr','tt19xigucwz84uh', NULL, 'Ana Castela Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('im52v4wyfzc3p5d5izkac3wra5fq5x2p2dw38i7duc54yswdmi','Nosso Quadro','tt19xigucwz84uh','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c512716t54f84djvyb3u32a88cgdwjk24h82g5zz0ibgj5t3qr', 'im52v4wyfzc3p5d5izkac3wra5fq5x2p2dw38i7duc54yswdmi', '0');
-- SZA
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uj8v036e04nyze3', 'SZA', '27@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7eb7f6371aad8e67e01f0a03','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:27@artist.com', 'uj8v036e04nyze3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uj8v036e04nyze3', 'An avant-garde R&B artist painting vivid stories through her music.', 'SZA');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6cqqzwqm2bngutnzzvpp7ebmdppoyldwsqz9te6yd5nn0a5sv8','uj8v036e04nyze3', 'https://i.scdn.co/image/ab67616d0000b2730c471c36970b9406233842a5', 'SZA Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wo83e1jqo9rvrugu1bfuwxu5zdf1cm1tq6z0rnkk7rr4ogt9nj','Kill Bill','uj8v036e04nyze3','POP','1Qrg8KqiBpW07V7PNxwwwL','https://p.scdn.co/mp3-preview/4bd2dc84016f3743add7eea8b988407b1b900672?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6cqqzwqm2bngutnzzvpp7ebmdppoyldwsqz9te6yd5nn0a5sv8', 'wo83e1jqo9rvrugu1bfuwxu5zdf1cm1tq6z0rnkk7rr4ogt9nj', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h4xfwzykzblm6l3yy4t8rjdt2ixxz0gv9tvvp0ynnidl6gz1fz','Snooze','uj8v036e04nyze3','POP','4iZ4pt7kvcaH6Yo8UoZ4s2','https://p.scdn.co/mp3-preview/8c53920b5fd2c3178afa36cac9eec68b5ee9204a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6cqqzwqm2bngutnzzvpp7ebmdppoyldwsqz9te6yd5nn0a5sv8', 'h4xfwzykzblm6l3yy4t8rjdt2ixxz0gv9tvvp0ynnidl6gz1fz', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hi61dl1heuylcpazzdao9cp4erh420t0xr2zplwrr3pg78zfn3','Low','uj8v036e04nyze3','POP','2GAhgAjOhEmItWLfgisyOn','https://p.scdn.co/mp3-preview/5b6dd5a1d06d0bdfd57382a584cbf0227b4d9a4b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6cqqzwqm2bngutnzzvpp7ebmdppoyldwsqz9te6yd5nn0a5sv8', 'hi61dl1heuylcpazzdao9cp4erh420t0xr2zplwrr3pg78zfn3', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kr576yx82bivqcb6tkepuoo7ywfu0xl0ze9h6vbcp3hfz9k2we','Nobody Gets Me','uj8v036e04nyze3','POP','5Y35SjAfXjjG0sFQ3KOxmm','https://p.scdn.co/mp3-preview/36cfe8fbfb78aa38ca3b222c4b9fc88cda992841?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6cqqzwqm2bngutnzzvpp7ebmdppoyldwsqz9te6yd5nn0a5sv8', 'kr576yx82bivqcb6tkepuoo7ywfu0xl0ze9h6vbcp3hfz9k2we', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0agvj30wl2047ep1qakf9n9oyatvq9pqe2p51gw5g44w6n2yq1','Shirt','uj8v036e04nyze3','POP','2wSTnntOPRi7aQneobFtU4','https://p.scdn.co/mp3-preview/8819fb0dc127d1d777a776f4d1186be783334ae5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6cqqzwqm2bngutnzzvpp7ebmdppoyldwsqz9te6yd5nn0a5sv8', '0agvj30wl2047ep1qakf9n9oyatvq9pqe2p51gw5g44w6n2yq1', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lh4ytes3min0n77blitrygd4mn6d90yz8mnyfrexg9cz4yw57i','Blind','uj8v036e04nyze3','POP','2CSRrnOEELmhpq8iaAi9cd','https://p.scdn.co/mp3-preview/56cd00fd7aa857bd25e4ed25aebc0e41a24bfd4f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6cqqzwqm2bngutnzzvpp7ebmdppoyldwsqz9te6yd5nn0a5sv8', 'lh4ytes3min0n77blitrygd4mn6d90yz8mnyfrexg9cz4yw57i', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1x33wcqtb4g6zj0ilu7c8fjdbsi29jdikfps632gdaef7p1dnn','Good Days','uj8v036e04nyze3','POP','4PMqSO5qyjpvzhlLI5GnID','https://p.scdn.co/mp3-preview/d7fd97c8190baa298af9b4e778d2ba940fcd13a4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6cqqzwqm2bngutnzzvpp7ebmdppoyldwsqz9te6yd5nn0a5sv8', '1x33wcqtb4g6zj0ilu7c8fjdbsi29jdikfps632gdaef7p1dnn', '6');
-- Dean Lewis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('r1vezz6ydh9sdj4', 'Dean Lewis', '28@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4fc14e184f9e05ba0676ddee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:28@artist.com', 'r1vezz6ydh9sdj4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('r1vezz6ydh9sdj4', 'A journey through the spectrum of sound in every album.', 'Dean Lewis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zvievkt26tuj0fcdfcifwzq3kxeqt7348uzru5d60syohm9x00','r1vezz6ydh9sdj4', 'https://i.scdn.co/image/ab67616d0000b273bfedccaca3c8425fdc0a7c73', 'Dean Lewis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('el6w7j1jjwz4hri7jc0nwbez1ov8bm3b7zzpeek51oi68uj4tf','How Do I Say Goodbye','r1vezz6ydh9sdj4','POP','5hnGrTBaEsdukpDF6aZg8a',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zvievkt26tuj0fcdfcifwzq3kxeqt7348uzru5d60syohm9x00', 'el6w7j1jjwz4hri7jc0nwbez1ov8bm3b7zzpeek51oi68uj4tf', '0');
-- Bellakath
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('suj5ravrgoajubt', 'Bellakath', '29@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb008a12ca09c3acec7c536d53','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:29@artist.com', 'suj5ravrgoajubt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('suj5ravrgoajubt', 'A beacon of innovation in the world of sound.', 'Bellakath');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('me1jcj904kklezqevq1mu5ystwjd31jelv6x2arec62oqixkwg','suj5ravrgoajubt', 'https://i.scdn.co/image/ab67616d0000b273584e78471da03acbc05dde0b', 'Bellakath Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('melkijdnwnmrxyx097zwg5zha4yqt1wdzgwpqk7vg8lejdz7qc','Gatita','suj5ravrgoajubt','POP','4ilZV1WNjL7IxwE81OnaRY','https://p.scdn.co/mp3-preview/ed363508374055584f0a42a003473c065fbe4f61?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('me1jcj904kklezqevq1mu5ystwjd31jelv6x2arec62oqixkwg', 'melkijdnwnmrxyx097zwg5zha4yqt1wdzgwpqk7vg8lejdz7qc', '0');
-- Rauw Alejandro
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wr19n7pskl04poq', 'Rauw Alejandro', '30@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9047f938310ea16b68a5bdeb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:30@artist.com', 'wr19n7pskl04poq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wr19n7pskl04poq', 'A fusion of Latin trap and reggaeton, setting the stage on fire.', 'Rauw Alejandro');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ty62yizbhwvdlwy4a82s0urpzclek2jd2uxdeyscv87biwu9f7','wr19n7pskl04poq', NULL, 'Rauw Alejandro Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vj836qzdx5ffhh7db8zubent4relm1h4kfma9e2uv8l7ajc58j','BESO','wr19n7pskl04poq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ty62yizbhwvdlwy4a82s0urpzclek2jd2uxdeyscv87biwu9f7', 'vj836qzdx5ffhh7db8zubent4relm1h4kfma9e2uv8l7ajc58j', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r39yy5p3j5t296qhqzie1gis036bq9rnmgpr1u9mboheb2gp3v','BABY HELLO','wr19n7pskl04poq','POP','2SOvWt6igzXViIjIiWNWEP','https://p.scdn.co/mp3-preview/8a9ca6c81e6e6ad48758f02017456405fd7a476d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ty62yizbhwvdlwy4a82s0urpzclek2jd2uxdeyscv87biwu9f7', 'r39yy5p3j5t296qhqzie1gis036bq9rnmgpr1u9mboheb2gp3v', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kr9pvg2c8kfubc22qtrph3gwfzxeyrhs3sk1c4hbmi3rg5wsj1','Rauw Alejandro: Bzrp Music Sessions, Vol. 56','wr19n7pskl04poq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ty62yizbhwvdlwy4a82s0urpzclek2jd2uxdeyscv87biwu9f7', 'kr9pvg2c8kfubc22qtrph3gwfzxeyrhs3sk1c4hbmi3rg5wsj1', '2');
-- Ozuna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2levdbby8caf3qy', 'Ozuna', '31@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd45efec1d439cfd8bd936421','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:31@artist.com', '2levdbby8caf3qy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2levdbby8caf3qy', 'Dominating reggaeton and Latin trap with catchy tunes and charismatic energy.', 'Ozuna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('k1f086nidl24mgu1c37uhiekcrubxsccc5hw52sj394prg01ja','2levdbby8caf3qy', 'https://i.scdn.co/image/ab67616d0000b273125624f2e04f5a1ccb0dfb45', 'Ozuna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('loj5v8od2baxh0a3evfp5yg9ndigxvhwzzxumm5htlan5vplm8','Hey Mor','2levdbby8caf3qy','POP','1zsPaEkglFvxjAhrM8yhpr','https://p.scdn.co/mp3-preview/cd2d2242b748408da15c2b66f47d54b3f0793ae0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k1f086nidl24mgu1c37uhiekcrubxsccc5hw52sj394prg01ja', 'loj5v8od2baxh0a3evfp5yg9ndigxvhwzzxumm5htlan5vplm8', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tb47z7mpvt7e09sxkemeiy5lhqz67u8je2gv7erlvlm7mx5lbz','Monoton','2levdbby8caf3qy','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k1f086nidl24mgu1c37uhiekcrubxsccc5hw52sj394prg01ja', 'tb47z7mpvt7e09sxkemeiy5lhqz67u8je2gv7erlvlm7mx5lbz', '1');
-- Doja Cat
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5tmx82ejmfdqt9b', 'Doja Cat', '32@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7f6d6cac38d494e87692af99','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:32@artist.com', '5tmx82ejmfdqt9b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5tmx82ejmfdqt9b', 'Blending traditional rhythms with modern beats.', 'Doja Cat');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d00h2og5946e26cfjrddsrrnho88957j28selqdbswksgsvvqf','5tmx82ejmfdqt9b', 'https://i.scdn.co/image/ab67616d0000b273be841ba4bc24340152e3a79a', 'Doja Cat Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('upkodw00xeau4uqvepqxih39yl1ths9trskqu3rtjqcxtp4y7j','Woman','5tmx82ejmfdqt9b','POP','6Uj1ctrBOjOas8xZXGqKk4','https://p.scdn.co/mp3-preview/2ae0b61e45d9a5d6454a3e5ab75f8628dd89aa85?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d00h2og5946e26cfjrddsrrnho88957j28selqdbswksgsvvqf', 'upkodw00xeau4uqvepqxih39yl1ths9trskqu3rtjqcxtp4y7j', '0');
-- JISOO
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2cytjqt517toqmr', 'JISOO', '33@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcb6017286dd64ca6b77c879f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:33@artist.com', '2cytjqt517toqmr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2cytjqt517toqmr', 'A visionary in the world of music, redefining genres.', 'JISOO');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zll9s3n22nwm69bqv5mfk2wal1rpv0cvci4bv5dvw5qv7fv45b','2cytjqt517toqmr', 'https://i.scdn.co/image/ab67616d0000b273f35b8a6c03cc633f734bd8ac', 'JISOO Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ghd1dvtm49sn0t8l85q89jly9yq8j0ex8whb6amw2ia1yrlt3y','FLOWER','2cytjqt517toqmr','POP','69CrOS7vEHIrhC2ILyEi0s',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zll9s3n22nwm69bqv5mfk2wal1rpv0cvci4bv5dvw5qv7fv45b', 'ghd1dvtm49sn0t8l85q89jly9yq8j0ex8whb6amw2ia1yrlt3y', '0');
-- Carin Leon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z87g1haos374ghg', 'Carin Leon', '34@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb7cc22fee89df015c6ba2636','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:34@artist.com', 'z87g1haos374ghg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z87g1haos374ghg', 'Exploring the depths of sound and rhythm.', 'Carin Leon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xkwki6dwlr4p4n8s5q3veyj2makci3v2jvpv93s5745yqrq3me','z87g1haos374ghg', 'https://i.scdn.co/image/ab67616d0000b273dc0bb68a08c069cf8467f1bd', 'Carin Leon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5a1p5pvda4p5tmhqp9zsrg00u5tsm6ucrftqnlli9ffdt8k1z9','Primera Cita','z87g1haos374ghg','POP','4mGrWfDISjNjgeQnH1B8IE','https://p.scdn.co/mp3-preview/7eea768397c9ad0989a55f26f4cffbe6f334874a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xkwki6dwlr4p4n8s5q3veyj2makci3v2jvpv93s5745yqrq3me', '5a1p5pvda4p5tmhqp9zsrg00u5tsm6ucrftqnlli9ffdt8k1z9', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mue86c3m98a43s58ohaofqur1ed98c9979ssp7wd5p24pzwam8','Que Vuelvas','z87g1haos374ghg','POP','6Um358vY92UBv5DloTRX9L','https://p.scdn.co/mp3-preview/19a1e58ae965c24e3ca4d0637857456887e31cd1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xkwki6dwlr4p4n8s5q3veyj2makci3v2jvpv93s5745yqrq3me', 'mue86c3m98a43s58ohaofqur1ed98c9979ssp7wd5p24pzwam8', '1');
-- Latto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bc7sdmd2pbko18o', 'Latto', '35@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:35@artist.com', 'bc7sdmd2pbko18o', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bc7sdmd2pbko18o', 'A bold and dynamic rapper, making waves with her fiery lyrics.', 'Latto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qzfonyax8fo0ehh3uwdagj2vsx06fn1crhto8xyn75fvey85xw','bc7sdmd2pbko18o', NULL, 'Latto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jrmo39srpyjsnlnbynrgmi232goc35s6ybrxbj1jp5vs5ruxcr','Seven (feat. Latto) (Explicit Ver.)','bc7sdmd2pbko18o','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qzfonyax8fo0ehh3uwdagj2vsx06fn1crhto8xyn75fvey85xw', 'jrmo39srpyjsnlnbynrgmi232goc35s6ybrxbj1jp5vs5ruxcr', '0');
-- Frank Ocean
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('z5t8c0khryu1eip', 'Frank Ocean', '36@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebee3123e593174208f9754fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:36@artist.com', 'z5t8c0khryu1eip', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('z5t8c0khryu1eip', 'A maestro of melodies, orchestrating auditory bliss.', 'Frank Ocean');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xpjlszyrs5ag9fjkmpmybcfzlbtw98db1iw2eatp8owwv9aukt','z5t8c0khryu1eip', 'https://i.scdn.co/image/ab67616d0000b273c5649add07ed3720be9d5526', 'Frank Ocean Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mnv920pjaylo5rub8o23v7pks3vpqamv9k50fwk6t3wtowzq6i','Pink + White','z5t8c0khryu1eip','POP','3xKsf9qdS1CyvXSMEid6g8','https://p.scdn.co/mp3-preview/0e3ca894e19c37cbbbd511d9eb682d8bee030126?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xpjlszyrs5ag9fjkmpmybcfzlbtw98db1iw2eatp8owwv9aukt', 'mnv920pjaylo5rub8o23v7pks3vpqamv9k50fwk6t3wtowzq6i', '0');
-- Israel & Rodolffo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('igt9ds1d4cy4zwy', 'Israel & Rodolffo', '37@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb697f5ad0867793de624bbb5f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:37@artist.com', 'igt9ds1d4cy4zwy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('igt9ds1d4cy4zwy', 'Pushing the boundaries of sound with each note.', 'Israel & Rodolffo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1xo0y0c0we46veuyhun7ngfd9kb0kkx04jzm9qsmy4xbddz2n9','igt9ds1d4cy4zwy', 'https://i.scdn.co/image/ab67616d0000b2736ccbcc3358d31dcba6e7c035', 'Israel & Rodolffo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2bfzz5macothqljj3n53vfw5aoman1s1n148j18gwo0geg3x6k','Seu Brilho Sumiu - Ao Vivo','igt9ds1d4cy4zwy','POP','3PH1nUysW7ybo3Yu8sqlPN','https://p.scdn.co/mp3-preview/125d70024c88bb1bf45666f6396dc21a181c416e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1xo0y0c0we46veuyhun7ngfd9kb0kkx04jzm9qsmy4xbddz2n9', '2bfzz5macothqljj3n53vfw5aoman1s1n148j18gwo0geg3x6k', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('eixrg0uvawg6kybywamsipsx2djglvfrz38tftxotrnrzd3xj5','Bombonzinho - Ao Vivo','igt9ds1d4cy4zwy','POP','0SCMVUZ21uYYB8cc0ScfbV','https://p.scdn.co/mp3-preview/b7d7cfb08d5384a52deb562a3e496881c978a9f1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1xo0y0c0we46veuyhun7ngfd9kb0kkx04jzm9qsmy4xbddz2n9', 'eixrg0uvawg6kybywamsipsx2djglvfrz38tftxotrnrzd3xj5', '1');
-- King
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7s6vwsawu4wyrfu', 'King', '38@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5c0b2129a88c7d6ed0704556','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:38@artist.com', '7s6vwsawu4wyrfu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7s6vwsawu4wyrfu', 'Weaving lyrical magic into every song.', 'King');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6h4l1yg1zcqmnvhs1fnvvtifah9hr0s74354msgvm7n94onk5i','7s6vwsawu4wyrfu', 'https://i.scdn.co/image/ab67616d0000b27337f65266754703fd20d29854', 'King Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pkf67tdsba7xz9m36ph9zgdulvt0jvk1km87lm7ljy74bvbqyf','Maan Meri Jaan','7s6vwsawu4wyrfu','POP','1418IuVKQPTYqt7QNJ9RXN','https://p.scdn.co/mp3-preview/cf886ec5f6a46c234bcfdd043ab5db03db0015b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6h4l1yg1zcqmnvhs1fnvvtifah9hr0s74354msgvm7n94onk5i', 'pkf67tdsba7xz9m36ph9zgdulvt0jvk1km87lm7ljy74bvbqyf', '0');
-- Rihanna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u0rh30leewseb2j', 'Rihanna', '39@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:39@artist.com', 'u0rh30leewseb2j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u0rh30leewseb2j', 'Blending genres for a fresh musical experience.', 'Rihanna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('davfe6532zbn9yutdxzcvwubtlqt5opf0rmgwqvnur67mlvrel','u0rh30leewseb2j', 'https://i.scdn.co/image/ab67616d0000b273bef074de9ca825bddaeb9f46', 'Rihanna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z4uj1o56fc22tlz1a0j748k85e8kx3vholvkk1zj0f0kpf1iob','We Found Love','u0rh30leewseb2j','POP','6qn9YLKt13AGvpq9jfO8py',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('davfe6532zbn9yutdxzcvwubtlqt5opf0rmgwqvnur67mlvrel', 'z4uj1o56fc22tlz1a0j748k85e8kx3vholvkk1zj0f0kpf1iob', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ebk2z6llwpkwn871vjxrtu6hij24x7a3ziwyixs4rgu5nl4u9t','Lift Me Up - From Black Panther: Wakanda Forever - Music From and Inspired By','u0rh30leewseb2j','POP','35ovElsgyAtQwYPYnZJECg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('davfe6532zbn9yutdxzcvwubtlqt5opf0rmgwqvnur67mlvrel', 'ebk2z6llwpkwn871vjxrtu6hij24x7a3ziwyixs4rgu5nl4u9t', '1');
-- The Police
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c332klklqq7vyj4', 'The Police', '40@artist.com', 'https://i.scdn.co/image/1f73a61faca2942cd5ea29c2143184db8645f0b3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:40@artist.com', 'c332klklqq7vyj4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c332klklqq7vyj4', 'A journey through the spectrum of sound in every album.', 'The Police');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4nqar5u8yezy6qhq7kva6woartnm2rtthdkhux1lkxjncg2y0w','c332klklqq7vyj4', 'https://i.scdn.co/image/ab67616d0000b2730408dc279dd7c7354ff41014', 'The Police Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u25qxwue5mgywyoxf8b5i5qmzn8645r8ciitkk1oo7l1okj86x','Every Breath You Take - Remastered 2003','c332klklqq7vyj4','POP','0wF2zKJmgzjPTfircPJ2jg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4nqar5u8yezy6qhq7kva6woartnm2rtthdkhux1lkxjncg2y0w', 'u25qxwue5mgywyoxf8b5i5qmzn8645r8ciitkk1oo7l1okj86x', '0');
-- ROSAL
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sh453qof79ir3u9', 'ROSAL', '41@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd7bb678bef6d2f26110cae49','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:41@artist.com', 'sh453qof79ir3u9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sh453qof79ir3u9', 'The architect of aural landscapes that inspire and captivate.', 'ROSAL');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vpt0mfqoeem1sh1frhrv2jdlop47r9vku15jylabrifclhym3m','sh453qof79ir3u9', 'https://i.scdn.co/image/ab67616d0000b273efc0ef9dd996312ebaf0bf52', 'ROSAL Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2t1idvzb90q2o22fur4g3l43l01sks2myce2tqip6a8321drea','DESPECH','sh453qof79ir3u9','POP','53tfEupEzQRtVFOeZvk7xq','https://p.scdn.co/mp3-preview/304868e078d8f2c3209977997c47542181096b61?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vpt0mfqoeem1sh1frhrv2jdlop47r9vku15jylabrifclhym3m', '2t1idvzb90q2o22fur4g3l43l01sks2myce2tqip6a8321drea', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jf1b6zyllxxosjqhay3h7d39fkezsh5nq2gwoefdb0ymx3ntlh','LLYLM','sh453qof79ir3u9','POP','2SiAcexM2p1yX6joESbehd','https://p.scdn.co/mp3-preview/6f41063b2e36fb31fbd08c39b6c56012e239365b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vpt0mfqoeem1sh1frhrv2jdlop47r9vku15jylabrifclhym3m', 'jf1b6zyllxxosjqhay3h7d39fkezsh5nq2gwoefdb0ymx3ntlh', '1');
-- Peggy Gou
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('okeic15nsy38dgh', 'Peggy Gou', '42@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf5c17aa075c03c5c4d2c693','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:42@artist.com', 'okeic15nsy38dgh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('okeic15nsy38dgh', 'A dynamic force in the electronic music scene, known for her eclectic mixes.', 'Peggy Gou');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hp5dc7k3c7e0cqd2grm8bumjyg2axttrmzkfi5gjtwchxz1ahg','okeic15nsy38dgh', 'https://i.scdn.co/image/ab67616d0000b27388d71aadd009fe1a83df88f2', 'Peggy Gou Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rfojulzpa29f2qqddqbgf2u2mgd7yi5504hsflkhvsec89f72r','(It Goes Like) Nanana - Edit','okeic15nsy38dgh','POP','23RoR84KodL5HWvUTneQ1w','https://p.scdn.co/mp3-preview/e36e0bd4714844f1f9d992398b41a3e333f15cc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hp5dc7k3c7e0cqd2grm8bumjyg2axttrmzkfi5gjtwchxz1ahg', 'rfojulzpa29f2qqddqbgf2u2mgd7yi5504hsflkhvsec89f72r', '0');
-- A$AP Rocky
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('nnj4w44huraatgk', 'A$AP Rocky', '43@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:43@artist.com', 'nnj4w44huraatgk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('nnj4w44huraatgk', 'Revolutionizing the music scene with innovative compositions.', 'A$AP Rocky');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wl4phu7enfe7turmh5qox9896q0llo6mqh1l9iis8ala4t9t3k','nnj4w44huraatgk', NULL, 'A$AP Rocky Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j9z06br7m0n4jp0gr0a3pr5eap7zax3iiqvlyj2yyuk0csaaah','Am I Dreaming (Metro Boomin & A$AP Rocky, Roisee)','nnj4w44huraatgk','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wl4phu7enfe7turmh5qox9896q0llo6mqh1l9iis8ala4t9t3k', 'j9z06br7m0n4jp0gr0a3pr5eap7zax3iiqvlyj2yyuk0csaaah', '0');
-- Charlie Puth
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('egujsaurn2oj980', 'Charlie Puth', '44@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb63de91415970a2f5bc920fa8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:44@artist.com', 'egujsaurn2oj980', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('egujsaurn2oj980', 'A pop maestro, combining catchy melodies with his exceptional musical talent.', 'Charlie Puth');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oh01avtfxcfjlhwnscok4c7x9n1r5x8ii56zercad0ygncomqz','egujsaurn2oj980', 'https://i.scdn.co/image/ab67616d0000b27335d2e0ed94a934f2cc46fa49', 'Charlie Puth Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0q6onmqf4emugi5ivj81375xiow612acohfv1ir3ws82u49obi','Left and Right (Feat. Jung Kook of BTS)','egujsaurn2oj980','POP','5Odq8ohlgIbQKMZivbWkEo','https://p.scdn.co/mp3-preview/9e4342eefa4f33df4e9b199e60dbce0f59e46eff?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oh01avtfxcfjlhwnscok4c7x9n1r5x8ii56zercad0ygncomqz', '0q6onmqf4emugi5ivj81375xiow612acohfv1ir3ws82u49obi', '0');
-- Billie Eilish
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5w76wsrqbj69mqs', 'Billie Eilish', '45@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd8b9980db67272cb4d2c3daf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:45@artist.com', '5w76wsrqbj69mqs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5w76wsrqbj69mqs', 'An icon in modern pop, known for her haunting vocals and introspective lyrics.', 'Billie Eilish');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3b6osi63hvzb93pu83grbfmay4arqtmq8al9cwiivu0rokuf7s','5w76wsrqbj69mqs', NULL, 'Billie Eilish Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d50irtz8a5f51uoqhx9k0xkiycpdp4rmh75rik6bcmvh81qw9b','What Was I Made For? [From The Motion Picture "Barbie"]','5w76wsrqbj69mqs','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3b6osi63hvzb93pu83grbfmay4arqtmq8al9cwiivu0rokuf7s', 'd50irtz8a5f51uoqhx9k0xkiycpdp4rmh75rik6bcmvh81qw9b', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ct4mfn0fwo0ekbpd0jgja722a23msfay9yw8ittvjen70leyqb','lovely - Bonus Track','5w76wsrqbj69mqs','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3b6osi63hvzb93pu83grbfmay4arqtmq8al9cwiivu0rokuf7s', 'ct4mfn0fwo0ekbpd0jgja722a23msfay9yw8ittvjen70leyqb', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4yeq001h17fp5uaveos7qknwpz7xsv031nw4qfnjt49s5z2f7e','TV','5w76wsrqbj69mqs','POP','3GYlZ7tbxLOxe6ewMNVTkw',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3b6osi63hvzb93pu83grbfmay4arqtmq8al9cwiivu0rokuf7s', '4yeq001h17fp5uaveos7qknwpz7xsv031nw4qfnjt49s5z2f7e', '2');
-- Radiohead
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tnkp41gpnof21ax', 'Radiohead', '46@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba03696716c9ee605006047fd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:46@artist.com', 'tnkp41gpnof21ax', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tnkp41gpnof21ax', 'Crafting melodies that resonate with the soul.', 'Radiohead');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3tyz3do0dli14kvdttkce6h7ljg7iy2ebizkeyhndseyrnkxcx','tnkp41gpnof21ax', 'https://i.scdn.co/image/ab67616d0000b273df55e326ed144ab4f5cecf95', 'Radiohead Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ohfigcjwhbd5fm4gld4js12pkoefqqeo1r7i7v7dws6hpwhz8o','Creep','tnkp41gpnof21ax','POP','70LcF31zb1H0PyJoS1Sx1r','https://p.scdn.co/mp3-preview/713b601d02641a850f2a3e6097aacaff52328d57?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3tyz3do0dli14kvdttkce6h7ljg7iy2ebizkeyhndseyrnkxcx', 'ohfigcjwhbd5fm4gld4js12pkoefqqeo1r7i7v7dws6hpwhz8o', '0');
-- Shubh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ddro1eljpixlq4i', 'Shubh', '47@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3eac18e003a215ce96654ce1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:47@artist.com', 'ddro1eljpixlq4i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ddro1eljpixlq4i', 'Sculpting soundwaves into masterpieces of auditory art.', 'Shubh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('msu7kmly7lnf6tehbkcyj9pz6wgz0lz30x8k9u9kvguyoxytx1','ddro1eljpixlq4i', 'https://i.scdn.co/image/ab67616d0000b2731a8c4618eda885a406958dd0', 'Shubh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w7ufo2fe7iouo6qkm908uzeepa5x8dg68lcn6ho4khijj6svo7','Cheques','ddro1eljpixlq4i','POP','4eBvRhTJ2AcxCsbfTUjoRp','https://p.scdn.co/mp3-preview/c607b777f851d56dd524f845957e24901adbf1eb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('msu7kmly7lnf6tehbkcyj9pz6wgz0lz30x8k9u9kvguyoxytx1', 'w7ufo2fe7iouo6qkm908uzeepa5x8dg68lcn6ho4khijj6svo7', '0');
-- sped up nightcore
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('d3ygwre7fswxp6v', 'sped up nightcore', '48@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebbf73929f8c684fed7af7e767','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:48@artist.com', 'd3ygwre7fswxp6v', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('d3ygwre7fswxp6v', 'Melodies that capture the essence of human emotion.', 'sped up nightcore');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6g6ha2oxxjsxgzgk7zuphqj4btrnzex978sxjyeh8y1qgr215d','d3ygwre7fswxp6v', NULL, 'sped up nightcore Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v3mm2ltnh46vewwp01l8w7et7w8bv6pexo4iyhhledechxa6ax','Watch This - ARIZONATEARS Pluggnb Remix','d3ygwre7fswxp6v','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6g6ha2oxxjsxgzgk7zuphqj4btrnzex978sxjyeh8y1qgr215d', 'v3mm2ltnh46vewwp01l8w7et7w8bv6pexo4iyhhledechxa6ax', '0');
-- The Weeknd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q58rvsbjzqrqvqr', 'The Weeknd', '49@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:49@artist.com', 'q58rvsbjzqrqvqr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q58rvsbjzqrqvqr', 'A trailblazer in the world of R&B, constantly redefining the genre.', 'The Weeknd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk','q58rvsbjzqrqvqr', NULL, 'The Weeknd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('72k6ujq345r7npmepmn9vjyynt0bvgffiqttajoe8xnz6tgnfb','Popular (with Playboi Carti & Madonna) - The Idol Vol. 1 (Music from the HBO Original Series)','q58rvsbjzqrqvqr','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk', '72k6ujq345r7npmepmn9vjyynt0bvgffiqttajoe8xnz6tgnfb', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vmisct6636gjswjns7b1oogz6nhwoz3i6wavqurnez6eqghyhe','Creepin','q58rvsbjzqrqvqr','POP','1zOf6IuM8HgaB4Jo6I8D11','https://p.scdn.co/mp3-preview/185d0909b7f2086f4cdd0af4b166df5676542343?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk', 'vmisct6636gjswjns7b1oogz6nhwoz3i6wavqurnez6eqghyhe', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gy03q7x1ldjnbvzmmotvsa52vosroh8sb9a0kyxqzvn37ejlg0','Die For You','q58rvsbjzqrqvqr','POP','2LBqCSwhJGcFQeTHMVGwy3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk', 'gy03q7x1ldjnbvzmmotvsa52vosroh8sb9a0kyxqzvn37ejlg0', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j1g7zvshf9yqfsyzozilp3i4csxi4u7q6o619509nefi7z3jze','Starboy','q58rvsbjzqrqvqr','POP','7MXVkk9YMctZqd1Srtv4MB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk', 'j1g7zvshf9yqfsyzozilp3i4csxi4u7q6o619509nefi7z3jze', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1x73hybnvcdzudozgd2u1ahir3vi9py482ozpaane6l1sizjpk','Blinding Lights','q58rvsbjzqrqvqr','POP','0VjIjW4GlUZAMYd2vXMi3b',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk', '1x73hybnvcdzudozgd2u1ahir3vi9py482ozpaane6l1sizjpk', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nv03m3288aq59fyyymt9ptmuhxehezemg4f9ppvw36gvdslfsq','Stargirl Interlude','q58rvsbjzqrqvqr','POP','5gDWsRxpJ2lZAffh5p7K0w',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk', 'nv03m3288aq59fyyymt9ptmuhxehezemg4f9ppvw36gvdslfsq', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('85ccmr2ymgrr270kknqyil6wmz8d17tc9oyeowzvn8pg6ju7i3','Save Your Tears','q58rvsbjzqrqvqr','POP','5QO79kh1waicV47BqGRL3g',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk', '85ccmr2ymgrr270kknqyil6wmz8d17tc9oyeowzvn8pg6ju7i3', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ff79bg3k4zlphs6ube4xyuspjhqce89x3wk2ih1c8wwny6swqq','Reminder','q58rvsbjzqrqvqr','POP','37F0uwRSrdzkBiuj0D5UHI',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk', 'ff79bg3k4zlphs6ube4xyuspjhqce89x3wk2ih1c8wwny6swqq', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cfgmgwsvdzvibmdji5g8z9oeu3k6ti15zdpnd54coij2bdlfxk','Double Fantasy (with Future)','q58rvsbjzqrqvqr','POP','4VMRsbfZzd3SfQtaJ1Wpwi',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk', 'cfgmgwsvdzvibmdji5g8z9oeu3k6ti15zdpnd54coij2bdlfxk', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ir3mtjrdkpp7130rw1aqu8fdpy6s92mpaafwa0kx8iozfcrbdh','I Was Never There','q58rvsbjzqrqvqr','POP','1cKHdTo9u0ZymJdPGSh6nq',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk', 'ir3mtjrdkpp7130rw1aqu8fdpy6s92mpaafwa0kx8iozfcrbdh', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0gd2qid8lkhpfslsmfcx6jripja4dt49pczwn84bv58cltyuxw','Call Out My Name','q58rvsbjzqrqvqr','POP','09mEdoA6zrmBPgTEN5qXmN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk', '0gd2qid8lkhpfslsmfcx6jripja4dt49pczwn84bv58cltyuxw', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d316n05w99qzkb6vozdp2thi10kpbooyuwfhxt3np45580n3ib','The Hills','q58rvsbjzqrqvqr','POP','7fBv7CLKzipRk6EC6TWHOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk', 'd316n05w99qzkb6vozdp2thi10kpbooyuwfhxt3np45580n3ib', '11');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bn0v8pa36vwg5zkyoh1lm7zn5qg70znxxcnxpo6flo6befa2u6','After Hours','q58rvsbjzqrqvqr','POP','2p8IUWQDrpjuFltbdgLOag',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nbdhtochk9y21l9rdsm2fykq2smabwcuyyg7kti9ce9xvlolyk', 'bn0v8pa36vwg5zkyoh1lm7zn5qg70znxxcnxpo6flo6befa2u6', '12');
-- ENHYPEN
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vbgtdqjjp85keoy', 'ENHYPEN', '50@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a48a236a01fa62db8c7a6f6','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:50@artist.com', 'vbgtdqjjp85keoy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vbgtdqjjp85keoy', 'A maestro of melodies, orchestrating auditory bliss.', 'ENHYPEN');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('39ir4abfmx8iyf5aua3ojwbgi92dw0gymdixxh9l33681656tg','vbgtdqjjp85keoy', 'https://i.scdn.co/image/ab67616d0000b2731d03b5e88cee6870778a4d27', 'ENHYPEN Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x502xis8lrxzictf0aqs4aw7fk5kycchvyq6jyyiykzb6bl7dy','Bite Me','vbgtdqjjp85keoy','POP','7mpdNiaQvygj2rHoxkzMfa','https://p.scdn.co/mp3-preview/ff4e3c3d8464e572759ba2169332743c2889d97e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('39ir4abfmx8iyf5aua3ojwbgi92dw0gymdixxh9l33681656tg', 'x502xis8lrxzictf0aqs4aw7fk5kycchvyq6jyyiykzb6bl7dy', '0');
-- Drake
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kka9mmuzqeu1el5', 'Drake', '51@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb35ca7d2181258b51c0f2cf9e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:51@artist.com', 'kka9mmuzqeu1el5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kka9mmuzqeu1el5', 'Delivering soul-stirring tunes that linger in the mind.', 'Drake');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('w5aak9g8sabs0aiyis3tst8fk1pwj05tnlvmzh9mgzhidf690j','kka9mmuzqeu1el5', 'https://i.scdn.co/image/ab67616d0000b2738dc0d801766a5aa6a33cbe37', 'Drake Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2j1066rqnpht94w2oqhxmz5doe1v197pomtx1m25i5b6fih324','Jimmy Cooks (feat. 21 Savage)','kka9mmuzqeu1el5','POP','3F5CgOj3wFlRv51JsHbxhe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w5aak9g8sabs0aiyis3tst8fk1pwj05tnlvmzh9mgzhidf690j', '2j1066rqnpht94w2oqhxmz5doe1v197pomtx1m25i5b6fih324', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cjw5thchsl31q5oxev2a8i1xtj3v0lsdwy8rowi3cenat8ho95','One Dance','kka9mmuzqeu1el5','POP','1zi7xx7UVEFkmKfv06H8x0',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w5aak9g8sabs0aiyis3tst8fk1pwj05tnlvmzh9mgzhidf690j', 'cjw5thchsl31q5oxev2a8i1xtj3v0lsdwy8rowi3cenat8ho95', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('40594xcu92kcppm1vmqgeoupgvkp2uareca1scs2v9yecu2oqf','Search & Rescue','kka9mmuzqeu1el5','POP','7aRCf5cLOFN1U7kvtChY1G',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w5aak9g8sabs0aiyis3tst8fk1pwj05tnlvmzh9mgzhidf690j', '40594xcu92kcppm1vmqgeoupgvkp2uareca1scs2v9yecu2oqf', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3771zugyonkpqehqunoztsw5fnwxk4gw2u0v739tq0xebr6zrd','Rich Flex','kka9mmuzqeu1el5','POP','1bDbXMyjaUIooNwFE9wn0N',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w5aak9g8sabs0aiyis3tst8fk1pwj05tnlvmzh9mgzhidf690j', '3771zugyonkpqehqunoztsw5fnwxk4gw2u0v739tq0xebr6zrd', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9p83v9cn5x3cahhgufc8gbmdpgqcws4omhec7uzkb5abt1ko28','WAIT FOR U (feat. Drake & Tems)','kka9mmuzqeu1el5','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('w5aak9g8sabs0aiyis3tst8fk1pwj05tnlvmzh9mgzhidf690j', '9p83v9cn5x3cahhgufc8gbmdpgqcws4omhec7uzkb5abt1ko28', '4');
-- Peso Pluma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wxm1k25l8v5hcdp', 'Peso Pluma', '52@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:52@artist.com', 'wxm1k25l8v5hcdp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wxm1k25l8v5hcdp', 'Infusing music with energetic beats and captivating lyrics.', 'Peso Pluma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('k7fce4s23ikmhirt7eah31imcgnl1eg3gksymy4jwdp9gs3fvc','wxm1k25l8v5hcdp', NULL, 'Peso Pluma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g8ig3jn18765bgjndvyv74h8wim2s4rpaubwi1lprf3knb2h8v','La Bebe - Remix','wxm1k25l8v5hcdp','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k7fce4s23ikmhirt7eah31imcgnl1eg3gksymy4jwdp9gs3fvc', 'g8ig3jn18765bgjndvyv74h8wim2s4rpaubwi1lprf3knb2h8v', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0n92cfermlo4q2gv2ivzz8kxlz21ftmace9zmqc4qfwzwa9n90','TULUM','wxm1k25l8v5hcdp','POP','7bPp2NmpmyhLJ7zWazAXMu','https://p.scdn.co/mp3-preview/164468e67b8da8053036c68533ffa473ab680c51?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k7fce4s23ikmhirt7eah31imcgnl1eg3gksymy4jwdp9gs3fvc', '0n92cfermlo4q2gv2ivzz8kxlz21ftmace9zmqc4qfwzwa9n90', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7wp81yt7rzfx79uukpqrtr5oxh4cdpoly9u7h0su1z3lnutkvs','Por las Noches','wxm1k25l8v5hcdp','POP','2VzCjpKvPB1l1tqLndtAQa','https://p.scdn.co/mp3-preview/ba2f667c373e2d12343ac00b162886caca060c93?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k7fce4s23ikmhirt7eah31imcgnl1eg3gksymy4jwdp9gs3fvc', '7wp81yt7rzfx79uukpqrtr5oxh4cdpoly9u7h0su1z3lnutkvs', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('74t0t3dapi9y788xq3quut6joaeijvtpoky5hjhc0g5erejo72','Bye','wxm1k25l8v5hcdp','POP','6n2P81rPk2RTzwnNNgFOdb','https://p.scdn.co/mp3-preview/94ef6a9f37e088fff4b37e098a46561e74dab95b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('k7fce4s23ikmhirt7eah31imcgnl1eg3gksymy4jwdp9gs3fvc', '74t0t3dapi9y788xq3quut6joaeijvtpoky5hjhc0g5erejo72', '3');
-- Joji
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wzhcrrbtst8iw6r', 'Joji', '53@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4111c95b5f430c3265c7304b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:53@artist.com', 'wzhcrrbtst8iw6r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wzhcrrbtst8iw6r', 'Sculpting soundwaves into masterpieces of auditory art.', 'Joji');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wtpuq7t9p1f3ilsn9falv5kgeqvew7kdd9r81g9ovih59f07xq','wzhcrrbtst8iw6r', 'https://i.scdn.co/image/ab67616d0000b27308596cc28b9f5b00bfe08ae7', 'Joji Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jxkq8uq5owe41fqtqfbr3yl8ji8kttyfgcff6vhlxb27racy3y','Glimpse of Us','wzhcrrbtst8iw6r','POP','6xGruZOHLs39ZbVccQTuPZ','https://p.scdn.co/mp3-preview/12e4a7ef3f1051424e6e282dfba83fe8448e122f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wtpuq7t9p1f3ilsn9falv5kgeqvew7kdd9r81g9ovih59f07xq', 'jxkq8uq5owe41fqtqfbr3yl8ji8kttyfgcff6vhlxb27racy3y', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3age2cm185ehs2g2tkkdgnrpsw8lz18tuyq7ygy2cy9lxycpft','Die For You','wzhcrrbtst8iw6r','POP','26hOm7dTtBi0TdpDGl141t','https://p.scdn.co/mp3-preview/85d19ba2d8274ab29f474b3baf07b6ac6ba6d35a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wtpuq7t9p1f3ilsn9falv5kgeqvew7kdd9r81g9ovih59f07xq', '3age2cm185ehs2g2tkkdgnrpsw8lz18tuyq7ygy2cy9lxycpft', '1');
-- Brenda Lee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ufhwq787mha66mc', 'Brenda Lee', '54@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4ea49bdca366a3baa5cbb006','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:54@artist.com', 'ufhwq787mha66mc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ufhwq787mha66mc', 'Igniting the stage with electrifying performances.', 'Brenda Lee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7r2bwfw2vx3hhlq7tvi7ao91gg2exwrxl8dlwrn0gzb87j5qcv','ufhwq787mha66mc', 'https://i.scdn.co/image/ab67616d0000b2737845f74d6db14b400fa61cd3', 'Brenda Lee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x7q9lqxnx58653gbi1mc8vprzkw4ktq0ix970k274dyxovg2d7','Rockin Around The Christmas Tree','ufhwq787mha66mc','POP','2EjXfH91m7f8HiJN1yQg97',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7r2bwfw2vx3hhlq7tvi7ao91gg2exwrxl8dlwrn0gzb87j5qcv', 'x7q9lqxnx58653gbi1mc8vprzkw4ktq0ix970k274dyxovg2d7', '0');
-- Becky G
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('a9hcn0l0hl218kb', 'Becky G', '55@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd132bf0d4a9203404cd66f79','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:55@artist.com', 'a9hcn0l0hl218kb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('a9hcn0l0hl218kb', 'Melodies that capture the essence of human emotion.', 'Becky G');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hjtverkpfwyfqrsjtn7dqpp3uoia2mcgmujbop4yqhnzqr5g08','a9hcn0l0hl218kb', 'https://i.scdn.co/image/ab67616d0000b273c3bb167f0e78b15e5588c296', 'Becky G Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8y7ma6zibw2nc2xs3ka3ix5ntw0dmfvy7sbagmevkrf33qimv6','Chanel','a9hcn0l0hl218kb','POP','5RcxRGvmYai7kpFSfxe5GY','https://p.scdn.co/mp3-preview/38dbb82dace64ea92e1dafe5989c1d1861656595?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hjtverkpfwyfqrsjtn7dqpp3uoia2mcgmujbop4yqhnzqr5g08', '8y7ma6zibw2nc2xs3ka3ix5ntw0dmfvy7sbagmevkrf33qimv6', '0');
-- Kaifi Khalil
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('n5m23pr28jx46cy', 'Kaifi Khalil', '56@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8b3d777345ecd2f25f408586','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:56@artist.com', 'n5m23pr28jx46cy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('n5m23pr28jx46cy', 'Creating a tapestry of tunes that celebrates diversity.', 'Kaifi Khalil');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jkkza3zh0lekzz3sfilc6entorv6vlqylvl4iib9fjw7eyray9','n5m23pr28jx46cy', 'https://i.scdn.co/image/ab67616d0000b2734697d4ee22b3f63c17a3b9ec', 'Kaifi Khalil Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5lw4g0azbyaf74ddpohr18x47ylx7sjke4xfqzi9ug24mxznek','Kahani Suno 2.0','n5m23pr28jx46cy','POP','4VsP4Dm8gsibRxB5I2hEkw','https://p.scdn.co/mp3-preview/2c644e9345d1a0ab97e4541d26b6b8ccb2c889f9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jkkza3zh0lekzz3sfilc6entorv6vlqylvl4iib9fjw7eyray9', '5lw4g0azbyaf74ddpohr18x47ylx7sjke4xfqzi9ug24mxznek', '0');
-- dennis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6azbahtc0cqdbn2', 'dennis', '57@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8a1ec9781a1542458b3b961b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:57@artist.com', '6azbahtc0cqdbn2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6azbahtc0cqdbn2', 'Uniting fans around the globe with universal rhythms.', 'dennis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y6w5xsj3dre2xyfhim8dd0mufsqxykh9xjrrhuqru24kmzaql2','6azbahtc0cqdbn2', 'https://i.scdn.co/image/ab67616d0000b273ddfc406de0d7dbc2e339f016', 'dennis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wp7op9n7eqfu6lwlh3i7x2dcz9uuzjimk68in4fc13wh14to8p','T','6azbahtc0cqdbn2','POP','35FW5OEe4p38LdjK1KqT2X','https://p.scdn.co/mp3-preview/eaa522f48564e43e33e00c011aef0489526d1072?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y6w5xsj3dre2xyfhim8dd0mufsqxykh9xjrrhuqru24kmzaql2', 'wp7op9n7eqfu6lwlh3i7x2dcz9uuzjimk68in4fc13wh14to8p', '0');
-- Glass Animals
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vak5h7xht716m8f', 'Glass Animals', '58@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb66b27eccb69756f8eceabc23','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:58@artist.com', 'vak5h7xht716m8f', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vak5h7xht716m8f', 'Crafting psychedelic pop with intricate melodies and immersive soundscapes.', 'Glass Animals');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('43owssv6ngkgrvwl1fsliht9z47zfow5q5ni0vvpx5t5yejbhg','vak5h7xht716m8f', 'https://i.scdn.co/image/ab67616d0000b273712701c5e263efc8726b1464', 'Glass Animals Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3prmlvh71oh9pi14m004a25clgrvdonrmtl3fti42cr216xo4n','Heat Waves','vak5h7xht716m8f','POP','3USxtqRwSYz57Ewm6wWRMp',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('43owssv6ngkgrvwl1fsliht9z47zfow5q5ni0vvpx5t5yejbhg', '3prmlvh71oh9pi14m004a25clgrvdonrmtl3fti42cr216xo4n', '0');
-- j-hope
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x3yjryltmvaf1bx', 'j-hope', '59@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeb746063d1aafa2817ea11b5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:59@artist.com', 'x3yjryltmvaf1bx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x3yjryltmvaf1bx', 'A unique voice in the contemporary music scene.', 'j-hope');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j13huea9hrwq09nvjrgzmd745sc6735ho6fcwzb8pyscmz8xd7','x3yjryltmvaf1bx', 'https://i.scdn.co/image/ab67616d0000b2735e8286ff63f7efce1881a02b', 'j-hope Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xd5o8d7yts2edx832cthuwjqbg88c6zr3wgk8yf6aurof8m06q','on the street (with J. Cole)','x3yjryltmvaf1bx','POP','5wxYxygyHpbgv0EXZuqb9V','https://p.scdn.co/mp3-preview/c69cf6ed41027bd08a5953b556cca144ff8ed2bf?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j13huea9hrwq09nvjrgzmd745sc6735ho6fcwzb8pyscmz8xd7', 'xd5o8d7yts2edx832cthuwjqbg88c6zr3wgk8yf6aurof8m06q', '0');
-- Aerosmith
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8uacx616ga6mj3w', 'Aerosmith', '60@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5733401b4689b2064458e7d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:60@artist.com', '8uacx616ga6mj3w', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8uacx616ga6mj3w', 'Weaving lyrical magic into every song.', 'Aerosmith');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('agderkouu9aad2o6xs3luaplhxwkiryexsih65s5kxu9p1bnbo','8uacx616ga6mj3w', 'https://i.scdn.co/image/ab67616d0000b273bbf0146981704a073405b6c2', 'Aerosmith Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iaf50onh5pa8qz0unvqlagnmx0rxec1m0gtb310bza3lxgv2nb','Dream On','8uacx616ga6mj3w','POP','1xsYj84j7hUDDnTTerGWlH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('agderkouu9aad2o6xs3luaplhxwkiryexsih65s5kxu9p1bnbo', 'iaf50onh5pa8qz0unvqlagnmx0rxec1m0gtb310bza3lxgv2nb', '0');
-- New West
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('upkabglmzt8rdql', 'New West', '61@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb32a5faa77c82348cf5d13590','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:61@artist.com', 'upkabglmzt8rdql', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('upkabglmzt8rdql', 'Sculpting soundwaves into masterpieces of auditory art.', 'New West');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('by08e4awfajka473o6rtxkuxgero1txbhsjoegfhgaephphu6b','upkabglmzt8rdql', 'https://i.scdn.co/image/ab67616d0000b2731bb5dc21200bfc56d8f7ef41', 'New West Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('by17bv6hcqp2wiwylrm5l0vu27hw036l9mo7h0feofep0cd9gi','Those Eyes','upkabglmzt8rdql','POP','50x1Ic8CaXkYNvjmxe3WXy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('by08e4awfajka473o6rtxkuxgero1txbhsjoegfhgaephphu6b', 'by17bv6hcqp2wiwylrm5l0vu27hw036l9mo7h0feofep0cd9gi', '0');
-- BTS
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('rmbl8tjq3nbsdny', 'BTS', '62@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd642648235ebf3460d2d1f6a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:62@artist.com', 'rmbl8tjq3nbsdny', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('rmbl8tjq3nbsdny', 'A global phenomenon, setting new standards in K-pop with their music and performances.', 'BTS');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('a8rt6pu238fyxuaplj0ctxkyzw1l4eb29oj90fu5snj167djxv','rmbl8tjq3nbsdny', 'https://i.scdn.co/image/ab67616d0000b2738a701e76e8845928f6cd81c8', 'BTS Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('eikl6bixmosejqdmyc4c7gqorxl2u37uutax47sw2o7hpdkw4a','Take Two','rmbl8tjq3nbsdny','POP','5IAESfJjmOYu7cHyX557kz','https://p.scdn.co/mp3-preview/ef43da30a06fcad16898e9fff1cadd0ccf953fc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a8rt6pu238fyxuaplj0ctxkyzw1l4eb29oj90fu5snj167djxv', 'eikl6bixmosejqdmyc4c7gqorxl2u37uutax47sw2o7hpdkw4a', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('njehcmeyz89jh05jq9wvo1ubvilzc1966h1x4wmm85yfc3i8sr','Dreamers [Music from the FIFA World Cup Qatar 2022 Official Soundtrack]','rmbl8tjq3nbsdny','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a8rt6pu238fyxuaplj0ctxkyzw1l4eb29oj90fu5snj167djxv', 'njehcmeyz89jh05jq9wvo1ubvilzc1966h1x4wmm85yfc3i8sr', '1');
-- Harry Styles
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uikqhkpu9s6xdrv', 'Harry Styles', '63@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf7db7c8ede90a019c54590bb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:63@artist.com', 'uikqhkpu9s6xdrv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uikqhkpu9s6xdrv', 'Defining modern pop-rock with his charismatic presence and bold choices.', 'Harry Styles');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gnacld1545z2gafhu967q239zwvdcgdoc2r1baxomzhjjrlltd','uikqhkpu9s6xdrv', 'https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0', 'Harry Styles Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mvm6mc0bseaxl4hku2kth9j6h8abw46eu7zn6ycpscajrihn0q','As It Was','uikqhkpu9s6xdrv','POP','4Dvkj6JhhA12EX05fT7y2e','https://p.scdn.co/mp3-preview/c43dd07043b29e800c1a65b3a0102861fa3cf418?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gnacld1545z2gafhu967q239zwvdcgdoc2r1baxomzhjjrlltd', 'mvm6mc0bseaxl4hku2kth9j6h8abw46eu7zn6ycpscajrihn0q', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5lwihgie7gid5a6yu5a885ruzi8wb37uv8bjwx3ffwjyvcfwph','Watermelon Sugar','uikqhkpu9s6xdrv','POP','6UelLqGlWMcVH1E5c4H7lY','https://p.scdn.co/mp3-preview/824cd58da2e9a15eeaaa6746becc09093547a09b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gnacld1545z2gafhu967q239zwvdcgdoc2r1baxomzhjjrlltd', '5lwihgie7gid5a6yu5a885ruzi8wb37uv8bjwx3ffwjyvcfwph', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gckflgsm9568j2l7xla4bghjhieed65d9a374cq8m98ga5mwaw','Late Night Talking','uikqhkpu9s6xdrv','POP','1qEmFfgcLObUfQm0j1W2CK','https://p.scdn.co/mp3-preview/50f056e2ab4a1bef762661dbbf2da751beeffe39?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gnacld1545z2gafhu967q239zwvdcgdoc2r1baxomzhjjrlltd', 'gckflgsm9568j2l7xla4bghjhieed65d9a374cq8m98ga5mwaw', '2');
-- Lord Huron
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q3jafx1p3gbcae6', 'Lord Huron', '64@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1d4e4e7e3c5d8fa494fc5f10','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:64@artist.com', 'q3jafx1p3gbcae6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q3jafx1p3gbcae6', 'Where words fail, my music speaks.', 'Lord Huron');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('abefs0s7igda1e16yn7zmjw2btpaox8bo54t0mz40nc735erae','q3jafx1p3gbcae6', 'https://i.scdn.co/image/ab67616d0000b2739d2efe43d5b7ebc7cb60ca81', 'Lord Huron Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dpmnutiig5nt65p5bnoj4eo3thby43tywbz0u433g3ospc6se5','The Night We Met','q3jafx1p3gbcae6','POP','0QZ5yyl6B6utIWkxeBDxQN','https://p.scdn.co/mp3-preview/f10f271b165ee07e3d49d9f961d08b7ad74ebd5b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('abefs0s7igda1e16yn7zmjw2btpaox8bo54t0mz40nc735erae', 'dpmnutiig5nt65p5bnoj4eo3thby43tywbz0u433g3ospc6se5', '0');
-- RM
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hfttvf6vxsdqjtf', 'RM', '65@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3b8f6208d84e28f63841e43c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:65@artist.com', 'hfttvf6vxsdqjtf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hfttvf6vxsdqjtf', 'Crafting melodies that resonate with the soul.', 'RM');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7bjuchonbbl9lid701xbc35dohjd9oqxsw6hn1agrlt4gozuuw','hfttvf6vxsdqjtf', NULL, 'RM Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aqe4o2gok1lhtc342nk1owbfd56rvfkuca5mlqecoffaehyn9d','Dont ever say love me (feat. RM of BTS)','hfttvf6vxsdqjtf','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7bjuchonbbl9lid701xbc35dohjd9oqxsw6hn1agrlt4gozuuw', 'aqe4o2gok1lhtc342nk1owbfd56rvfkuca5mlqecoffaehyn9d', '0');
-- Tears For Fears
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('40yqaqb4othftyk', 'Tears For Fears', '66@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb42ed2cb48c231f545a5a3dad','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:66@artist.com', '40yqaqb4othftyk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('40yqaqb4othftyk', 'Melodies that capture the essence of human emotion.', 'Tears For Fears');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('p4meg04fyvlkwro378kbxh04bnwb3i7da7wvo9bxu7ji6edzke','40yqaqb4othftyk', 'https://i.scdn.co/image/ab67616d0000b27322463d6939fec9e17b2a6235', 'Tears For Fears Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oyu07zi03vy5ecqw99atyfd9n8d2tqk6glql6k5155g248gf9b','Everybody Wants To Rule The World','40yqaqb4othftyk','POP','4RvWPyQ5RL0ao9LPZeSouE',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p4meg04fyvlkwro378kbxh04bnwb3i7da7wvo9bxu7ji6edzke', 'oyu07zi03vy5ecqw99atyfd9n8d2tqk6glql6k5155g248gf9b', '0');
-- Mc Livinho
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qm9tusbsf7cwrpf', 'Mc Livinho', '67@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd353ef9564cfbb5f2b3bffb2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:67@artist.com', 'qm9tusbsf7cwrpf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qm9tusbsf7cwrpf', 'Bringing Brazilian funk rhythms to the global music stage.', 'Mc Livinho');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xezvzp9jpm2c1zhcjfxhbbmlwfvkng50u30mk33dtehjkbdekk','qm9tusbsf7cwrpf', 'https://i.scdn.co/image/ab67616d0000b273369c960fed23353176da1218', 'Mc Livinho Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('74agrgkc4we7v7j73d0f4sl4rftk89gq40yhe03758a1vq8lwf','Novidade na ','qm9tusbsf7cwrpf','POP','2uhw2oYbugGJbn10wipNX5','https://p.scdn.co/mp3-preview/6bff8c1079d87a672d6b9ee5c3c6ca5e7d9ff45b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xezvzp9jpm2c1zhcjfxhbbmlwfvkng50u30mk33dtehjkbdekk', '74agrgkc4we7v7j73d0f4sl4rftk89gq40yhe03758a1vq8lwf', '0');
-- Ayparia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('a4fcwsh4xb475ss', 'Ayparia', '68@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebff258a75f7364baaaf9ed011','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:68@artist.com', 'a4fcwsh4xb475ss', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('a4fcwsh4xb475ss', 'Delivering a unique blend of sounds, showcasing versatility and artistic depth.', 'Ayparia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('38ln7oxlkqv3gmncguku7x13fu20d4ms3yrvqcsomfzozursqp','a4fcwsh4xb475ss', NULL, 'Ayparia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zdmcqib54chq9x4gci1kei72jk2sp1rkj7ap8c7bfk3zrnegnu','MONTAGEM - FR PUNK','a4fcwsh4xb475ss','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('38ln7oxlkqv3gmncguku7x13fu20d4ms3yrvqcsomfzozursqp', 'zdmcqib54chq9x4gci1kei72jk2sp1rkj7ap8c7bfk3zrnegnu', '0');
-- Em Beihold
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zkai9jwftmqlh30', 'Em Beihold', '69@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb23c885de4c81852c917608ac','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:69@artist.com', 'zkai9jwftmqlh30', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zkai9jwftmqlh30', 'A voice that captivates, combining depth of lyrics with a melodic finesse.', 'Em Beihold');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('b4gors36w9m3tykmkgs73r0dresyw1gvp6uol7rc4bx7q9t0kc','zkai9jwftmqlh30', NULL, 'Em Beihold Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('q0q1zaet4rnc8e94xvv9k3v33zgjfint2iyhrt7owhiry86j63','Until I Found You (with Em Beihold) - Em Beihold Version','zkai9jwftmqlh30','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('b4gors36w9m3tykmkgs73r0dresyw1gvp6uol7rc4bx7q9t0kc', 'q0q1zaet4rnc8e94xvv9k3v33zgjfint2iyhrt7owhiry86j63', '0');
-- Fifty Fifty
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('trrykozako0pkie', 'Fifty Fifty', '70@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5a60b0f886b5deb8518e4a41','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:70@artist.com', 'trrykozako0pkie', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('trrykozako0pkie', 'Blending a rich array of genres to create a unique musical experience.', 'Fifty Fifty');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('crl8k8xodc7k9946wcxxoedqnvxddcy8zyxp2cwdgjfiw8j59s','trrykozako0pkie', 'https://i.scdn.co/image/ab67616d0000b27337c0b3670236c067c8e8bbcb', 'Fifty Fifty Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4g1ekfb1td80wcvtecif0sw7smgi4kezztb8m00azwkkeic6k2','Cupid - Twin Ver.','trrykozako0pkie','POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('crl8k8xodc7k9946wcxxoedqnvxddcy8zyxp2cwdgjfiw8j59s', '4g1ekfb1td80wcvtecif0sw7smgi4kezztb8m00azwkkeic6k2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9hav66ls1twtfhlzmomntmb6vhnxh1gi9ka0nyg5axceo2q1uz','Cupid','trrykozako0pkie','POP','7FbrGaHYVDmfr7KoLIZnQ7','https://p.scdn.co/mp3-preview/af5c16d4c69be9b3278e7079d5aab14aa425127b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('crl8k8xodc7k9946wcxxoedqnvxddcy8zyxp2cwdgjfiw8j59s', '9hav66ls1twtfhlzmomntmb6vhnxh1gi9ka0nyg5axceo2q1uz', '1');
-- Michael Bubl
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cn1f5et9ag3n0zl', 'Michael Bubl', '71@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebef8cf61fea4923d2bde68200','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:71@artist.com', 'cn1f5et9ag3n0zl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cn1f5et9ag3n0zl', 'Where words fail, my music speaks.', 'Michael Bubl');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('u53cyrgllsm9co4r7n6shll1s5l8xzz89tlsai7rwgci25pmvv','cn1f5et9ag3n0zl', 'https://i.scdn.co/image/ab67616d0000b273119e4094f07a8123b471ac1d', 'Michael Bubl Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mn7dg243rxaw1ngjr63evvw7ws4porw2fehw1quw8m0nkgg6oj','Its Beginning To Look A Lot Like Christmas','cn1f5et9ag3n0zl','POP','5a1iz510sv2W9Dt1MvFd5R','https://p.scdn.co/mp3-preview/51f36d7e04069ef4869ea575fb21e5404710b1c4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('u53cyrgllsm9co4r7n6shll1s5l8xzz89tlsai7rwgci25pmvv', 'mn7dg243rxaw1ngjr63evvw7ws4porw2fehw1quw8m0nkgg6oj', '0');
-- Coolio
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2c8nx3fyteafyso', 'Coolio', '72@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5ea53fc78df8f7e7559e228d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:72@artist.com', '2c8nx3fyteafyso', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2c8nx3fyteafyso', 'A voice that echoes the sentiments of a generation.', 'Coolio');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('g9ferppwjmxpmbomalipok46qv8eu0sgo01al45am5ggh7ve8z','2c8nx3fyteafyso', 'https://i.scdn.co/image/ab67616d0000b273c31d3c870a3dbaf7b53186cc', 'Coolio Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hz0k0sheec30jepugrmecfv0ilpwzqb2sfqjwpvg74xvrq8pab','Gangstas Paradise','2c8nx3fyteafyso','POP','1DIXPcTDzTj8ZMHt3PDt8p','https://p.scdn.co/mp3-preview/1454c63a66c27ac745f874d6c113270a9c62d28e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('g9ferppwjmxpmbomalipok46qv8eu0sgo01al45am5ggh7ve8z', 'hz0k0sheec30jepugrmecfv0ilpwzqb2sfqjwpvg74xvrq8pab', '0');
-- Calvin Harris
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hen7kkpb5au4bz6', 'Calvin Harris', '73@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb37bff6aa1d42bede9048750f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:73@artist.com', 'hen7kkpb5au4bz6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hen7kkpb5au4bz6', 'A harmonious blend of passion and creativity.', 'Calvin Harris');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3kudk1kn53ywzl2cvws99hzio7t9q9vt2xgsw076bm3nok688k','hen7kkpb5au4bz6', 'https://i.scdn.co/image/ab67616d0000b273c58e22815048f8dfb1aa8bd0', 'Calvin Harris Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('86nza8vmf7kri5p5pqmvyedzr7bk0elcaweek8vyyk2m5n44je','Miracle (with Ellie Goulding)','hen7kkpb5au4bz6','POP','5eTaQYBE1yrActixMAeLcZ','https://p.scdn.co/mp3-preview/48a88093bc85e735791115290125fc354f8ed068?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3kudk1kn53ywzl2cvws99hzio7t9q9vt2xgsw076bm3nok688k', '86nza8vmf7kri5p5pqmvyedzr7bk0elcaweek8vyyk2m5n44je', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bbpzi0we7y9xacfahi3z5c35slfhe2s9tpgq6m4s8nh8ipshdk','One Kiss (with Dua Lipa)','hen7kkpb5au4bz6','POP','7ef4DlsgrMEH11cDZd32M6','https://p.scdn.co/mp3-preview/0c09da1fe6f1da091c05057835e6be2312e2dc18?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3kudk1kn53ywzl2cvws99hzio7t9q9vt2xgsw076bm3nok688k', 'bbpzi0we7y9xacfahi3z5c35slfhe2s9tpgq6m4s8nh8ipshdk', '1');
-- Yahritza Y Su Esencia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gmq33s37x4vr9t5', 'Yahritza Y Su Esencia', '74@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68d4ccdc175f594122f1eee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:74@artist.com', 'gmq33s37x4vr9t5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gmq33s37x4vr9t5', 'Infusing traditional melodies with youthful vigor.', 'Yahritza Y Su Esencia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nm82fm4v9ojob1ha6jp7b31apal5zh54u2dr2m6klgfa2q3hu1','gmq33s37x4vr9t5', NULL, 'Yahritza Y Su Esencia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yupicu922dmxf0d78b4silunewm7f9m1c34o4ka9510x93c69t','Frgil (feat. Grupo Front','gmq33s37x4vr9t5','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nm82fm4v9ojob1ha6jp7b31apal5zh54u2dr2m6klgfa2q3hu1', 'yupicu922dmxf0d78b4silunewm7f9m1c34o4ka9510x93c69t', '0');
-- WizKid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('emufh4jwcljv0hc', 'WizKid', '75@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9050b61368975fda051cdc06','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:75@artist.com', 'emufh4jwcljv0hc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('emufh4jwcljv0hc', 'An alchemist of harmonies, transforming notes into gold.', 'WizKid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('d8vvykois2dlpkn7nlh8sh4i7tmn1ujrlxedvwiy3fmcm7kg7g','emufh4jwcljv0hc', NULL, 'WizKid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('747z3xkv2n5smercmp87xrvxywy8dtc30e42o40zus07t4l7yf','Link Up (Metro Boomin & Don Toliver, Wizkid feat. BEAM & Toian) - Spider-Verse Remix (Spider-Man: Across the Spider-Verse )','emufh4jwcljv0hc','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('d8vvykois2dlpkn7nlh8sh4i7tmn1ujrlxedvwiy3fmcm7kg7g', '747z3xkv2n5smercmp87xrvxywy8dtc30e42o40zus07t4l7yf', '0');
-- Steve Aoki
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fuk3ezibb5nbwe6', 'Steve Aoki', '76@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:76@artist.com', 'fuk3ezibb5nbwe6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fuk3ezibb5nbwe6', 'Breathing new life into classic genres.', 'Steve Aoki');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('28ya8c39xs86svckdqd63wcigxq5o6jcslzjg6gp2smfqwuuho','fuk3ezibb5nbwe6', NULL, 'Steve Aoki Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h5wlx67mmrutrmnrwi25zs3ar7lxv8m6c9mt1xwux8z8fv75ox','Mu','fuk3ezibb5nbwe6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('28ya8c39xs86svckdqd63wcigxq5o6jcslzjg6gp2smfqwuuho', 'h5wlx67mmrutrmnrwi25zs3ar7lxv8m6c9mt1xwux8z8fv75ox', '0');
-- Vance Joy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kp82d80zsxkhjrt', 'Vance Joy', '77@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f074ec8c25406680bf26422','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:77@artist.com', 'kp82d80zsxkhjrt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kp82d80zsxkhjrt', 'Crafting folk-pop anthems that resonate with heartfelt sincerity.', 'Vance Joy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('du3pmf2bd4d4rmsg7ou8xfy9oxvsoud73immqcgdpcgpzmanro','kp82d80zsxkhjrt', 'https://i.scdn.co/image/ab67616d0000b273a9929deb093a6617d2493b03', 'Vance Joy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8or5shs5dexymh9yvrtd5kp63csuhipfubk3m8sxqbi9vxou2x','Riptide','kp82d80zsxkhjrt','POP','3JvrhDOgAt6p7K8mDyZwRd','https://p.scdn.co/mp3-preview/74698d907d114f4ba0b2c129bbf260724be80b64?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('du3pmf2bd4d4rmsg7ou8xfy9oxvsoud73immqcgdpcgpzmanro', '8or5shs5dexymh9yvrtd5kp63csuhipfubk3m8sxqbi9vxou2x', '0');
-- Kelly Clarkson
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vh7j7tltqe0m6r7', 'Kelly Clarkson', '78@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb305a7cc6760b53a67aaae19d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:78@artist.com', 'vh7j7tltqe0m6r7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vh7j7tltqe0m6r7', 'Redefining what it means to be an artist in the digital age.', 'Kelly Clarkson');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('og59atqy92idocwmzwdxugh63f17ego6c8m386fzoz7uu2rkhy','vh7j7tltqe0m6r7', 'https://i.scdn.co/image/ab67616d0000b273f54a315f1d2445791fe601a7', 'Kelly Clarkson Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xl9cub5nz2m7waakwir1hy4d4xf6v2t12ribjws4te0u1pcsr8','Underneath the Tree','vh7j7tltqe0m6r7','POP','3YZE5qDV7u1ZD1gZc47ZeR','https://p.scdn.co/mp3-preview/9d6040eda6551e1746409ca2c8cf04d95475019a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('og59atqy92idocwmzwdxugh63f17ego6c8m386fzoz7uu2rkhy', 'xl9cub5nz2m7waakwir1hy4d4xf6v2t12ribjws4te0u1pcsr8', '0');
-- Stephen Sanchez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6jpmgamwmg5ojw4', 'Stephen Sanchez', '79@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1e97fce6fa6fc4ebc3ebda25','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:79@artist.com', '6jpmgamwmg5ojw4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6jpmgamwmg5ojw4', 'Creating a tapestry of tunes that celebrates diversity.', 'Stephen Sanchez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8e0xg46igukmiub719uwugi0jcavv3xzn5ymwmvivdwc8o78rz','6jpmgamwmg5ojw4', 'https://i.scdn.co/image/ab67616d0000b2732bf0876d42b90a8852ad6244', 'Stephen Sanchez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bc7z1a9wiz3rizraqpomy4nsyp8rqzd88p1gmaan52kwf8cban','Until I Found You','6jpmgamwmg5ojw4','POP','1Y3LN4zO1Edc2EluIoSPJN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8e0xg46igukmiub719uwugi0jcavv3xzn5ymwmvivdwc8o78rz', 'bc7z1a9wiz3rizraqpomy4nsyp8rqzd88p1gmaan52kwf8cban', '0');
-- Tini
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xkqf6823mpkeahx', 'Tini', '80@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd1ee0c41d3c79e916b910696','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:80@artist.com', 'xkqf6823mpkeahx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xkqf6823mpkeahx', 'Creating a tapestry of tunes that celebrates diversity.', 'Tini');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lpesswhuqs1oqmnj7yjxxyaimaxhlt09yhmwhvxt8iykzg379b','xkqf6823mpkeahx', 'https://i.scdn.co/image/ab67616d0000b273f5409c637b9a7244e0c0d11d', 'Tini Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mn0y0qwlc9ml26smlnddx0n4q4mik3by57gybtv3ev87ub73ue','Cupido','xkqf6823mpkeahx','POP','04ndZkbKGthTgYSv3xS7en','https://p.scdn.co/mp3-preview/15bc4fa0d69ae03a045704bcc8731def7453458b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lpesswhuqs1oqmnj7yjxxyaimaxhlt09yhmwhvxt8iykzg379b', 'mn0y0qwlc9ml26smlnddx0n4q4mik3by57gybtv3ev87ub73ue', '0');
-- Mariah Carey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y851k6nftn3hdit', 'Mariah Carey', '81@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21b66418f7f3b86967f85bce','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:81@artist.com', 'y851k6nftn3hdit', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y851k6nftn3hdit', 'Breathing new life into classic genres.', 'Mariah Carey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tgjhx2pkti91eqhw01hm2bjakyrhlza9lnp1jl8i2h19mi751n','y851k6nftn3hdit', 'https://i.scdn.co/image/ab67616d0000b2734246e3158421f5abb75abc4f', 'Mariah Carey Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a51gcot15d0apm4i05vlyu3rdkhl262tjek8ih2ibp46l6ist1','All I Want for Christmas Is You','y851k6nftn3hdit','POP','0bYg9bo50gSsH3LtXe2SQn','https://p.scdn.co/mp3-preview/6b1557cd25d543940a3decd85a7bf2bc136c51f8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tgjhx2pkti91eqhw01hm2bjakyrhlza9lnp1jl8i2h19mi751n', 'a51gcot15d0apm4i05vlyu3rdkhl262tjek8ih2ibp46l6ist1', '0');
-- Feid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lvmk555ln73ybq8', 'Feid', '82@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0a248d29f8faa91f971e5cae','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:82@artist.com', 'lvmk555ln73ybq8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lvmk555ln73ybq8', 'A standout artist in urban Latin music, known for his catchy melodies and smooth vocals.', 'Feid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('euk8i5l8v6x7qjnbludin98zf8cqaqmf48egz1lp2z0qr5e0ur','lvmk555ln73ybq8', 'https://i.scdn.co/image/ab67616d0000b27329ebee2b5fb008871fcd201a', 'Feid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f4g4i5p02cfqupx1zmz6yznbt58i6mjpkjb8dqqh4x4212tb46','Classy 101','lvmk555ln73ybq8','POP','6XSqqQIy7Lm7SnwxS4NrGx',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('euk8i5l8v6x7qjnbludin98zf8cqaqmf48egz1lp2z0qr5e0ur', 'f4g4i5p02cfqupx1zmz6yznbt58i6mjpkjb8dqqh4x4212tb46', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3ptpyvgmuryepk6smlmxu6wyuajvkz59lzl08we6qcj7jfz8y2','El Cielo','lvmk555ln73ybq8','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('euk8i5l8v6x7qjnbludin98zf8cqaqmf48egz1lp2z0qr5e0ur', '3ptpyvgmuryepk6smlmxu6wyuajvkz59lzl08we6qcj7jfz8y2', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t2571qkfcf4ico2be3fxdlayehyjtsgi4uupw9cghevby3pvgk','Feliz Cumpleaos Fe','lvmk555ln73ybq8','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('euk8i5l8v6x7qjnbludin98zf8cqaqmf48egz1lp2z0qr5e0ur', 't2571qkfcf4ico2be3fxdlayehyjtsgi4uupw9cghevby3pvgk', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fz78hepb1hs54l7jx2x5uf6qbkvocbx36as8hq423nj73dx9pv','POLARIS - Remix','lvmk555ln73ybq8','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('euk8i5l8v6x7qjnbludin98zf8cqaqmf48egz1lp2z0qr5e0ur', 'fz78hepb1hs54l7jx2x5uf6qbkvocbx36as8hq423nj73dx9pv', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lwa4f2r4uufrz6nsw82uh28g6i8l3yiskoerps2ksdf2ojgqth','CHORRITO PA LAS ANIMAS','lvmk555ln73ybq8','POP','0CYTGMBYkwUxrj1MWDLrC5',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('euk8i5l8v6x7qjnbludin98zf8cqaqmf48egz1lp2z0qr5e0ur', 'lwa4f2r4uufrz6nsw82uh28g6i8l3yiskoerps2ksdf2ojgqth', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('teyprcjqx3mbxl74qocdr15flaf3axc4mgmqmcz73lf4gvaoov','Normal','lvmk555ln73ybq8','POP','0T2pB7P1VdXPhLdQZ488uH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('euk8i5l8v6x7qjnbludin98zf8cqaqmf48egz1lp2z0qr5e0ur', 'teyprcjqx3mbxl74qocdr15flaf3axc4mgmqmcz73lf4gvaoov', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f4pesdom7kjhbe92hxozmwcaylhae2uvxsec6vrljnrhbxuulp','REMIX EXCLUSIVO','lvmk555ln73ybq8','POP','3eqCJfgJJs8iKx49KO12s3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('euk8i5l8v6x7qjnbludin98zf8cqaqmf48egz1lp2z0qr5e0ur', 'f4pesdom7kjhbe92hxozmwcaylhae2uvxsec6vrljnrhbxuulp', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2uvu5tlocje8dyi7j7wtc16wzwbkksuek342uwpa4of594chn0','LA INOCENTE','lvmk555ln73ybq8','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('euk8i5l8v6x7qjnbludin98zf8cqaqmf48egz1lp2z0qr5e0ur', '2uvu5tlocje8dyi7j7wtc16wzwbkksuek342uwpa4of594chn0', '7');
-- Duki
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xcx4o4fkd0xe96i', 'Duki', '83@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4293b81686e67e3041aec80c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:83@artist.com', 'xcx4o4fkd0xe96i', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xcx4o4fkd0xe96i', 'A tapestry of rhythms that echo the pulse of life.', 'Duki');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l3y8myr9k3am5ftk9w6iek972w63my91peyqhvp2jg40jsw48k','xcx4o4fkd0xe96i', NULL, 'Duki Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0wv5f2kko4olc29xmvy9fug0bx8bbleki1vuhs24zebq78a3du','Marisola - Remix','xcx4o4fkd0xe96i','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l3y8myr9k3am5ftk9w6iek972w63my91peyqhvp2jg40jsw48k', '0wv5f2kko4olc29xmvy9fug0bx8bbleki1vuhs24zebq78a3du', '0');
-- Niall Horan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2th32wv271igeg6', 'Niall Horan', '84@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebeccc1cde8e9fdcf1c9289897','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:84@artist.com', '2th32wv271igeg6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2th32wv271igeg6', 'Pushing the boundaries of sound with each note.', 'Niall Horan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vpbd0xpzd034cl90q0zkazay7h80tf4pn0tfw5djqgdc6c6gls','2th32wv271igeg6', 'https://i.scdn.co/image/ab67616d0000b2732a368fea49f5c489a9dc3949', 'Niall Horan Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('573pm4uq0yu2cp56lrc6ntszv1ad5t1qetpsvcdg46jltznfah','Heaven','2th32wv271igeg6','POP','5FQ77Cl1ndljtwwImdtjMy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vpbd0xpzd034cl90q0zkazay7h80tf4pn0tfw5djqgdc6c6gls', '573pm4uq0yu2cp56lrc6ntszv1ad5t1qetpsvcdg46jltznfah', '0');
-- Wisin & Yandel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('i1x30c8lqy5em4c', 'Wisin & Yandel', '85@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5496c4b788e181679069ee8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:85@artist.com', 'i1x30c8lqy5em4c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('i1x30c8lqy5em4c', 'Uniting fans around the globe with universal rhythms.', 'Wisin & Yandel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hq0lqjx43f0mrj7zienled3xxmlfw8pveeoin9n0ldcy187a5y','i1x30c8lqy5em4c', 'https://i.scdn.co/image/ab67616d0000b2739f05bb270f81880fd844aae8', 'Wisin & Yandel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dy9xhnpbm85on6rduhk0yc2af164o5mlh1kv8gbi9n5hqwbl2r','Besos Moja2','i1x30c8lqy5em4c','POP','6OzUIp8KjuwxJnCWkXp1uL','https://p.scdn.co/mp3-preview/8b17c9ae5706f7f2e41a6ec3470631b3094017b6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hq0lqjx43f0mrj7zienled3xxmlfw8pveeoin9n0ldcy187a5y', 'dy9xhnpbm85on6rduhk0yc2af164o5mlh1kv8gbi9n5hqwbl2r', '0');
-- Kendrick Lamar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c20gyk87fr1b1o5', 'Kendrick Lamar', '86@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb52696416126917a827b514d2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:86@artist.com', 'c20gyk87fr1b1o5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c20gyk87fr1b1o5', 'A journey through the spectrum of sound in every album.', 'Kendrick Lamar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('n4soqvd1i3d44dvcpdlwzn52o9e4vievot0kdmv3nl7j5s4gxb','c20gyk87fr1b1o5', 'https://i.scdn.co/image/ab67616d0000b273d28d2ebdedb220e479743797', 'Kendrick Lamar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4xp9trnwwedy0efl1x0jxnc6rjz5drbs0l41zualdosxvypia2','Money Trees','c20gyk87fr1b1o5','POP','2HbKqm4o0w5wEeEFXm2sD4',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n4soqvd1i3d44dvcpdlwzn52o9e4vievot0kdmv3nl7j5s4gxb', '4xp9trnwwedy0efl1x0jxnc6rjz5drbs0l41zualdosxvypia2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('341yfwguq4fqdjufuojv6xju1oee1aesktdhfsg57ezwmnc0r8','AMERICA HAS A PROBLEM (feat. Kendrick Lamar)','c20gyk87fr1b1o5','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n4soqvd1i3d44dvcpdlwzn52o9e4vievot0kdmv3nl7j5s4gxb', '341yfwguq4fqdjufuojv6xju1oee1aesktdhfsg57ezwmnc0r8', '1');
-- BLESSD
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pyq7h18759wi2wr', 'BLESSD', '87@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:87@artist.com', 'pyq7h18759wi2wr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pyq7h18759wi2wr', 'The heartbeat of a new generation of music lovers.', 'BLESSD');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rultg9e2d87ilco0yxfyn4hampl0uc3k515wm8qgs2sbo9863o','pyq7h18759wi2wr', NULL, 'BLESSD Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dih634k1vse3r4igi1wp3rnljnzyudhgxoi640aycmc8lu8y2v','Las Morras','pyq7h18759wi2wr','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rultg9e2d87ilco0yxfyn4hampl0uc3k515wm8qgs2sbo9863o', 'dih634k1vse3r4igi1wp3rnljnzyudhgxoi640aycmc8lu8y2v', '0');
-- MC Xenon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yzu08uj58kii9rg', 'MC Xenon', '88@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb14b5fcee11164723953781ff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:88@artist.com', 'yzu08uj58kii9rg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yzu08uj58kii9rg', 'Breathing new life into classic genres.', 'MC Xenon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vx72a5xj1e0djnwuz5w8995g9ot3xpl5xmgbxtjjjq5vg44syi','yzu08uj58kii9rg', NULL, 'MC Xenon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('opp1nptvobcivmpojo008gm33n9me32j4zxnup9ck7f5tr2l35','Sem Aliana no ','yzu08uj58kii9rg','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vx72a5xj1e0djnwuz5w8995g9ot3xpl5xmgbxtjjjq5vg44syi', 'opp1nptvobcivmpojo008gm33n9me32j4zxnup9ck7f5tr2l35', '0');
-- sped up 8282
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('u75x0x8qd3o8uqi', 'sped up 8282', '89@artist.com', 'https://i.scdn.co/image/ab67616d0000b2730a0ba228b5be4ffb7c7c59fb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:89@artist.com', 'u75x0x8qd3o8uqi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('u75x0x8qd3o8uqi', 'Harnessing the power of melody to tell compelling stories.', 'sped up 8282');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wvupf2bn200zlm2yfi3cfwqu5ff58jsfszwj9yrp05k9x7hw25','u75x0x8qd3o8uqi', 'https://i.scdn.co/image/ab67616d0000b2730a0ba228b5be4ffb7c7c59fb', 'sped up 8282 Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a05jrhcj9na8u0rqveghjna98jwimfom1n3dv88c8mh4q09epp','Cupid  Twin Ver. (FIFTY FIFTY)  Spe','u75x0x8qd3o8uqi','POP','3B228N0GxfUCwPyfNcJxps','https://p.scdn.co/mp3-preview/29e8870f55c261ec995edfe4a3e9f30e4d4527e0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wvupf2bn200zlm2yfi3cfwqu5ff58jsfszwj9yrp05k9x7hw25', 'a05jrhcj9na8u0rqveghjna98jwimfom1n3dv88c8mh4q09epp', '0');
-- P!nk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fyzqs4d9vbazj8c', 'P!nk', '90@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7bbad89a61061304ec842588','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:90@artist.com', 'fyzqs4d9vbazj8c', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fyzqs4d9vbazj8c', 'Revolutionizing the music scene with innovative compositions.', 'P!nk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('thdepazikdtzfpo23m0kntyd5m4f2xa0eyxj0qq8kg6uhhwgoh','fyzqs4d9vbazj8c', 'https://i.scdn.co/image/ab67616d0000b27302f93e92bdd5b3793eb688c0', 'P!nk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r7hbg8cmhxuztcsmuu8qe5fa5xf43j0tmx3kjp2t73kj6138fz','TRUSTFALL','fyzqs4d9vbazj8c','POP','4FWbsd91QSvgr1dSWwW51e','https://p.scdn.co/mp3-preview/4a8b78e434e2dda75bc679955c3fbd8b4dad372b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('thdepazikdtzfpo23m0kntyd5m4f2xa0eyxj0qq8kg6uhhwgoh', 'r7hbg8cmhxuztcsmuu8qe5fa5xf43j0tmx3kjp2t73kj6138fz', '0');
-- Stray Kids
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4gmxpd9tm6cj9po', 'Stray Kids', '91@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0610877c41cb9cc12ad39cc0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:91@artist.com', '4gmxpd9tm6cj9po', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4gmxpd9tm6cj9po', 'A voice that echoes the sentiments of a generation.', 'Stray Kids');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j8cgkmq1gr1thz49k65tecpkm7g7qlp5dsdunv4x065y1yett0','4gmxpd9tm6cj9po', 'https://i.scdn.co/image/ab67616d0000b273e27ba26bc14a563bf3d09882', 'Stray Kids Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mtzhnnoyyi3ngc3yyfexzppplc1y98lokx5g1wolgumyh69anr','S-Class','4gmxpd9tm6cj9po','POP','3gTQwwDNJ42CCLo3Sf4JDd','https://p.scdn.co/mp3-preview/4ea586fdcc2c9aec34a18d2034d1dec78a3b5e25?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j8cgkmq1gr1thz49k65tecpkm7g7qlp5dsdunv4x065y1yett0', 'mtzhnnoyyi3ngc3yyfexzppplc1y98lokx5g1wolgumyh69anr', '0');
-- Gabito Ballesteros
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5m8aqnkzomr9qpr', 'Gabito Ballesteros', '92@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:92@artist.com', '5m8aqnkzomr9qpr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5m8aqnkzomr9qpr', 'A vibrant force in the music scene, infusing every performance with passion.', 'Gabito Ballesteros');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dmlzjihna354uyxyqvny15rjcghsom0embpusd0qe21xjz4dqo','5m8aqnkzomr9qpr', NULL, 'Gabito Ballesteros Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nn1tz74r7nt9hevtn2rnjy8hop5snb1x48pt6ba3c0eq64drg1','LADY GAGA','5m8aqnkzomr9qpr','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dmlzjihna354uyxyqvny15rjcghsom0embpusd0qe21xjz4dqo', 'nn1tz74r7nt9hevtn2rnjy8hop5snb1x48pt6ba3c0eq64drg1', '0');
-- Leo Santana
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('pgnd0kciowux3ar', 'Leo Santana', '93@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9c301d2486e33ad58c85db8e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:93@artist.com', 'pgnd0kciowux3ar', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('pgnd0kciowux3ar', 'Crafting soundscapes that transport listeners to another world.', 'Leo Santana');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('svsx1ejl3ttyehf17qnizssq0qrwi01kjzz6dvyowqemdvfr76','pgnd0kciowux3ar', 'https://i.scdn.co/image/ab67616d0000b273d5efcc40f158ae827c28eee9', 'Leo Santana Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j9ggb0qc8k5mmijgwcopndb160fjvq3698sn8vn9377p9b3nca','Zona De Perigo','pgnd0kciowux3ar','POP','4lsQKByQ7m1o6oEKdrJycU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('svsx1ejl3ttyehf17qnizssq0qrwi01kjzz6dvyowqemdvfr76', 'j9ggb0qc8k5mmijgwcopndb160fjvq3698sn8vn9377p9b3nca', '0');
-- BLACKPINK
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('oclgrcjkuti7ync', 'BLACKPINK', '94@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc9690bc711d04b3d4fd4b87c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:94@artist.com', 'oclgrcjkuti7ync', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('oclgrcjkuti7ync', 'Pushing the boundaries of sound with each note.', 'BLACKPINK');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dir4wjazv3klyi6h6rgyitn1wbctzlettdkq1vonsbodbghjin','oclgrcjkuti7ync', 'https://i.scdn.co/image/ab67616d0000b273002ef53878df1b4e91c15406', 'BLACKPINK Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rg7gyy72lkeptjypkk99lfaz3ly8kv2i581fghcg1xvb10arcj','Shut Down','oclgrcjkuti7ync','POP','7gRFDGEzF9UkBV233yv2dc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dir4wjazv3klyi6h6rgyitn1wbctzlettdkq1vonsbodbghjin', 'rg7gyy72lkeptjypkk99lfaz3ly8kv2i581fghcg1xvb10arcj', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k9lgpzto30kg2gym7unnyc81yrixhr7q7y6fv4j1py63k7u027','Pink Venom','oclgrcjkuti7ync','POP','5zwwW9Oq7ubSxoCGyW1nbY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dir4wjazv3klyi6h6rgyitn1wbctzlettdkq1vonsbodbghjin', 'k9lgpzto30kg2gym7unnyc81yrixhr7q7y6fv4j1py63k7u027', '1');
-- Rich The Kid
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zvlyu9qz9m5aehc', 'Rich The Kid', '95@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb10379ac1a13fa06e703bf421','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:95@artist.com', 'zvlyu9qz9m5aehc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zvlyu9qz9m5aehc', 'Transcending language barriers through the universal language of music.', 'Rich The Kid');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('c945azs4w85ey1gz6ta742035oe97hubu1mxlhsb2nol6qmm93','zvlyu9qz9m5aehc', NULL, 'Rich The Kid Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fvp27v61i0odv8fmuakaxrt59vuquv42fhooxovcgj4p6ai9w1','Conexes de Mfia (feat. Rich ','zvlyu9qz9m5aehc','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c945azs4w85ey1gz6ta742035oe97hubu1mxlhsb2nol6qmm93', 'fvp27v61i0odv8fmuakaxrt59vuquv42fhooxovcgj4p6ai9w1', '0');
-- Imagine Dragons
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hxzh65u3fvkin2z', 'Imagine Dragons', '96@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb920dc1f617550de8388f368e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:96@artist.com', 'hxzh65u3fvkin2z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hxzh65u3fvkin2z', 'Weaving lyrical magic into every song.', 'Imagine Dragons');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yf2tfxi8p87zzxsllduptj9djcvrpy955bncrqdg9ebl5s9kcl','hxzh65u3fvkin2z', 'https://i.scdn.co/image/ab67616d0000b273fc915b69600dce2991a61f13', 'Imagine Dragons Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xdmg1bxj28xljoqenklox7spbl92psqysaha1r8ukm1uk7xji7','Bones','hxzh65u3fvkin2z','POP','54ipXppHLA8U4yqpOFTUhr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yf2tfxi8p87zzxsllduptj9djcvrpy955bncrqdg9ebl5s9kcl', 'xdmg1bxj28xljoqenklox7spbl92psqysaha1r8ukm1uk7xji7', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4ckp4gx3af3jocbxux8vyn1bl5cjs2780lmsf62knvmfvtb4vz','Believer','hxzh65u3fvkin2z','POP','0pqnGHJpmpxLKifKRmU6WP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yf2tfxi8p87zzxsllduptj9djcvrpy955bncrqdg9ebl5s9kcl', '4ckp4gx3af3jocbxux8vyn1bl5cjs2780lmsf62knvmfvtb4vz', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('60gvhvc52fg9x392e3fx0ahhepnjqxv63s7bf21jqhvbyiyx9x','Demons','hxzh65u3fvkin2z','POP','3LlAyCYU26dvFZBDUIMb7a',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yf2tfxi8p87zzxsllduptj9djcvrpy955bncrqdg9ebl5s9kcl', '60gvhvc52fg9x392e3fx0ahhepnjqxv63s7bf21jqhvbyiyx9x', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ihwhevl5rshuza219tilezb32ra1t3j0f98ycriz0mprzjhj9j','Enemy (with JID) - from the series Arcane League of Legends','hxzh65u3fvkin2z','POP','3CIyK1V4JEJkg02E4EJnDl',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yf2tfxi8p87zzxsllduptj9djcvrpy955bncrqdg9ebl5s9kcl', 'ihwhevl5rshuza219tilezb32ra1t3j0f98ycriz0mprzjhj9j', '3');
-- The Neighbourhood
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9ket93mg254g4fc', 'The Neighbourhood', '97@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf0b5ac84376a0a4b2166816','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:97@artist.com', '9ket93mg254g4fc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9ket93mg254g4fc', 'Melding alternative rock with introspective lyrics.', 'The Neighbourhood');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('m4zay24y01p6djg5e9tpidro9nzhxhicg49iuhjjk64p0963vj','9ket93mg254g4fc', 'https://i.scdn.co/image/ab67616d0000b2738265a736a1eb838ad5a0b921', 'The Neighbourhood Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rrb4vq2qircu8te65bg2gp201er4h7cguqlfh4lacuziv4xhyj','Sweater Weather','9ket93mg254g4fc','POP','2QjOHCTQ1Jl3zawyYOpxh6','https://p.scdn.co/mp3-preview/877602f424a9dea277b13301ffc516f9fd1fbe7e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m4zay24y01p6djg5e9tpidro9nzhxhicg49iuhjjk64p0963vj', 'rrb4vq2qircu8te65bg2gp201er4h7cguqlfh4lacuziv4xhyj', '0');
-- Plan B
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0uh5ua1vzef5rxz', 'Plan B', '98@artist.com', 'https://i.scdn.co/image/eb21793908d1eabe0fba02659bdff4e4a4b3724a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:98@artist.com', '0uh5ua1vzef5rxz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0uh5ua1vzef5rxz', 'Pioneering new paths in the musical landscape.', 'Plan B');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ozaray0r6dn5yzqxpa1f047wv3zpwuel6x0nbhgjxqphgtlmuh','0uh5ua1vzef5rxz', 'https://i.scdn.co/image/ab67616d0000b273913ef74e0272d688c512200b', 'Plan B Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ejddz9j19w1914h2b0nqnt2e6l47grl5ky37xfhztq21jr9b9h','Es un Secreto','0uh5ua1vzef5rxz','POP','7JwdbqIpiuWvGbRryKSuBz','https://p.scdn.co/mp3-preview/feeeb03d75e53b19bb2e67502a1b498e87cdfef8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ozaray0r6dn5yzqxpa1f047wv3zpwuel6x0nbhgjxqphgtlmuh', 'ejddz9j19w1914h2b0nqnt2e6l47grl5ky37xfhztq21jr9b9h', '0');
-- Cigarettes After Sex
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7k69v9khtviacui', 'Cigarettes After Sex', '99@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb41a26ad71de86acf45dc886','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:99@artist.com', '7k69v9khtviacui', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7k69v9khtviacui', 'A symphony of emotions expressed through sound.', 'Cigarettes After Sex');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('eda1bpq5boaoh8c97iptwofdxbj5muypfs7p99c7lfrnlged32','7k69v9khtviacui', 'https://i.scdn.co/image/ab67616d0000b27312b69bf576f5e80291f75161', 'Cigarettes After Sex Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p0uun1dm2adxwg7fw8hrq8vjzj88ukn8drcmiy1pyqhnbj2awn','Apocalypse','7k69v9khtviacui','POP','0yc6Gst2xkRu0eMLeRMGCX','https://p.scdn.co/mp3-preview/1f89f0156113dfb87572382b531459bb8cb711a1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eda1bpq5boaoh8c97iptwofdxbj5muypfs7p99c7lfrnlged32', 'p0uun1dm2adxwg7fw8hrq8vjzj88ukn8drcmiy1pyqhnbj2awn', '0');
-- Nile Rodgers
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('oqy4ocuzu2q5wgi', 'Nile Rodgers', '100@artist.com', 'https://i.scdn.co/image/6511b1fe261da3b6c6b69ae2aa771cfd307a18ae','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:100@artist.com', 'oqy4ocuzu2q5wgi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('oqy4ocuzu2q5wgi', 'A journey through the spectrum of sound in every album.', 'Nile Rodgers');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('s9ol56zydp6i0p0bupj5ykuukqr9h4hkh5du78dpb2kn0cozqi','oqy4ocuzu2q5wgi', NULL, 'Nile Rodgers Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8ar7nz3b747qg0xfe7ku1r16cdwzel118y49wihdg67so7n1nu','UNFORGIVEN (feat. Nile Rodgers)','oqy4ocuzu2q5wgi','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s9ol56zydp6i0p0bupj5ykuukqr9h4hkh5du78dpb2kn0cozqi', '8ar7nz3b747qg0xfe7ku1r16cdwzel118y49wihdg67so7n1nu', '0');
-- Coi Leray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bfzjx1cadri40jx', 'Coi Leray', '101@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:101@artist.com', 'bfzjx1cadri40jx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bfzjx1cadri40jx', 'Pioneering new paths in the musical landscape.', 'Coi Leray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('93534wy1d4vofmip3augagscgzwidvjet2bqdbgvmozgbfdtlp','bfzjx1cadri40jx', 'https://i.scdn.co/image/ab67616d0000b2735626453d29a0124dea22fb1b', 'Coi Leray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zonagelmbtzyp1dz0q7zg1h1hudx6yxe6t227hgut2s1404x2l','Players','bfzjx1cadri40jx','POP','6UN73IYd0hZxLi8wFPMQij',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('93534wy1d4vofmip3augagscgzwidvjet2bqdbgvmozgbfdtlp', 'zonagelmbtzyp1dz0q7zg1h1hudx6yxe6t227hgut2s1404x2l', '0');
-- Linkin Park
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('43qc4fngnet6v49', 'Linkin Park', '102@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb811da3b2e7c9e5a9c1a6c4f7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:102@artist.com', '43qc4fngnet6v49', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('43qc4fngnet6v49', 'An alchemist of harmonies, transforming notes into gold.', 'Linkin Park');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('11egr07komovqqu3zygg5pqup5gz9l0yrvx4wr99sxfppfjeic','43qc4fngnet6v49', 'https://i.scdn.co/image/ab67616d0000b273b4ad7ebaf4575f120eb3f193', 'Linkin Park Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('27lb7e4fcs572r3nte0ue6zj2tyli4irt2xu6xc2csb5nbsulr','Numb','43qc4fngnet6v49','POP','2nLtzopw4rPReszdYBJU6h','https://p.scdn.co/mp3-preview/15e1178c9eb7f626ac1112ad8f56eccbec2cd6e5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('11egr07komovqqu3zygg5pqup5gz9l0yrvx4wr99sxfppfjeic', '27lb7e4fcs572r3nte0ue6zj2tyli4irt2xu6xc2csb5nbsulr', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jaifpy08ayp98s1cz5h7gimb1m8f1vbo17exc9djdlkxqfprd6','In The End','43qc4fngnet6v49','POP','60a0Rd6pjrkxjPbaKzXjfq','https://p.scdn.co/mp3-preview/b5ee275ca337899f762b1c1883c11e24a04075b0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('11egr07komovqqu3zygg5pqup5gz9l0yrvx4wr99sxfppfjeic', 'jaifpy08ayp98s1cz5h7gimb1m8f1vbo17exc9djdlkxqfprd6', '1');
-- Chencho Corleone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('84xkors9ztvqymz', 'Chencho Corleone', '103@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2e862710857d2b3e1b5fb4f4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:103@artist.com', '84xkors9ztvqymz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('84xkors9ztvqymz', 'A dynamic presence in reggaeton, known for his catchy beats and vibrant performances.', 'Chencho Corleone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jfbuw3st3pzjbtvtng32a3jfbprf3aejiztgb2dsjh0icczuur','84xkors9ztvqymz', NULL, 'Chencho Corleone Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qrgy2q6xe1hxx010pctellgmyik9ofbpuxmidw52zclox7xaik','Me Porto Bonito','84xkors9ztvqymz','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jfbuw3st3pzjbtvtng32a3jfbprf3aejiztgb2dsjh0icczuur', 'qrgy2q6xe1hxx010pctellgmyik9ofbpuxmidw52zclox7xaik', '0');
-- Baby Rasta
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5wa7phwfzaco1bh', 'Baby Rasta', '104@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb18f9c5cb23e65bd55af69f24','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:104@artist.com', '5wa7phwfzaco1bh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5wa7phwfzaco1bh', 'Sculpting soundwaves into masterpieces of auditory art.', 'Baby Rasta');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bex5hixpmwk16sqmb8n492l8js8o9te3cgjkmbyfjd1cuyi10j','5wa7phwfzaco1bh', NULL, 'Baby Rasta Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qagz8oflzmfjfks2x42di8tnef5pvrc5f4s59tcpdhusgg9f5v','PUNTO 40','5wa7phwfzaco1bh','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bex5hixpmwk16sqmb8n492l8js8o9te3cgjkmbyfjd1cuyi10j', 'qagz8oflzmfjfks2x42di8tnef5pvrc5f4s59tcpdhusgg9f5v', '0');
-- Travis Scott
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s8d4n5rtndiqtid', 'Travis Scott', '105@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:105@artist.com', 's8d4n5rtndiqtid', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s8d4n5rtndiqtid', 'Transcending language barriers through the universal language of music.', 'Travis Scott');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ij34s4kuypakkobsuvs126xycvg8idhyr8zwjtdze8gky0lao2','s8d4n5rtndiqtid', NULL, 'Travis Scott Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('b093t3d9skl3uxi844zkltp0ft6pcrfx48jjcy3k9a1ijk5l1t','Trance (with Travis Scott & Young Thug)','s8d4n5rtndiqtid','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ij34s4kuypakkobsuvs126xycvg8idhyr8zwjtdze8gky0lao2', 'b093t3d9skl3uxi844zkltp0ft6pcrfx48jjcy3k9a1ijk5l1t', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iid09i6488gevksjl114p717bpnd6siytgj8qia6mfc3pb43ax','Niagara Falls (Foot or 2) [with Travis Scott & 21 Savage]','s8d4n5rtndiqtid','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ij34s4kuypakkobsuvs126xycvg8idhyr8zwjtdze8gky0lao2', 'iid09i6488gevksjl114p717bpnd6siytgj8qia6mfc3pb43ax', '1');
-- Dua Lipa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lm52wg9d5ao31em', 'Dua Lipa', '106@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1bbee4a02f85ecc58d385c3e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:106@artist.com', 'lm52wg9d5ao31em', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lm52wg9d5ao31em', 'A pop phenomenon, known for her empowering anthems and dynamic presence.', 'Dua Lipa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t71nfsph4mxn042l1v96m6tec26v9om9jrvdtv252d8oakv7b4','lm52wg9d5ao31em', 'https://i.scdn.co/image/ab67616d0000b2737dd3ba455ee3390cb55b0192', 'Dua Lipa Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('a8rqbhlplom4871qoezhzeujazr7c1in374h4ppmfkjhiithif','Dance The Night (From Barbie The Album)','lm52wg9d5ao31em','POP','1vYXt7VSjH9JIM5oRRo7vA','https://p.scdn.co/mp3-preview/acaea048f50a3b30ca24b348c84a6047373baabb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t71nfsph4mxn042l1v96m6tec26v9om9jrvdtv252d8oakv7b4', 'a8rqbhlplom4871qoezhzeujazr7c1in374h4ppmfkjhiithif', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('293mhgkad6zy28glrwdcpnhewk2dj4085cy4wx5jm6jbltbjxs','Cold Heart - PNAU Remix','lm52wg9d5ao31em','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t71nfsph4mxn042l1v96m6tec26v9om9jrvdtv252d8oakv7b4', '293mhgkad6zy28glrwdcpnhewk2dj4085cy4wx5jm6jbltbjxs', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k78c41oyshghpjlzr12osamm7tsudjpch321zuvopezehenxur','Dont Start Now','lm52wg9d5ao31em','POP','3li9IOaMFu8S56r9uP6wcO','https://p.scdn.co/mp3-preview/cfc6684fc467e40bb9c7e6da2ea1b22eeccb211c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t71nfsph4mxn042l1v96m6tec26v9om9jrvdtv252d8oakv7b4', 'k78c41oyshghpjlzr12osamm7tsudjpch321zuvopezehenxur', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qqsjtlzrlem0w4haiezpjzz9gzro74k6mdmxzv5w5w6q08hhn5','Levitating (feat. DaBaby)','lm52wg9d5ao31em','POP','5nujrmhLynf4yMoMtj8AQF','https://p.scdn.co/mp3-preview/6af6db91dba9103cca41d6d5225f6fe120fcfcd3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t71nfsph4mxn042l1v96m6tec26v9om9jrvdtv252d8oakv7b4', 'qqsjtlzrlem0w4haiezpjzz9gzro74k6mdmxzv5w5w6q08hhn5', '3');
-- Bobby Helms
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ztefdmdkhqvwhtj', 'Bobby Helms', '107@artist.com', 'https://i.scdn.co/image/1dcd3f5d64a65f19d085b8e78746e457bd2d2e05','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:107@artist.com', 'ztefdmdkhqvwhtj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ztefdmdkhqvwhtj', 'Blending traditional rhythms with modern beats.', 'Bobby Helms');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t15ulf8dq0pumjt9mofdm48s45wityo7ghnimxicv4rdmk1q0x','ztefdmdkhqvwhtj', 'https://i.scdn.co/image/ab67616d0000b273fd56f3c7a294f5cfe51c7b17', 'Bobby Helms Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h5wtg12dbmp36pk335yaatv1q7s1dbngi9k06vtu3nj2prao4i','Jingle Bell Rock','ztefdmdkhqvwhtj','POP','7vQbuQcyTflfCIOu3Uzzya',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t15ulf8dq0pumjt9mofdm48s45wityo7ghnimxicv4rdmk1q0x', 'h5wtg12dbmp36pk335yaatv1q7s1dbngi9k06vtu3nj2prao4i', '0');
-- NewJeans
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6ypb941w7tz6m1m', 'NewJeans', '108@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5da361915b1fa48895d4f23f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:108@artist.com', '6ypb941w7tz6m1m', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6ypb941w7tz6m1m', 'Redefining K-pop with their fresh style and energetic performances.', 'NewJeans');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6wpcc8ly157jzx10xmreciy199lfce8qdroqi6us4qvpmmnz57','6ypb941w7tz6m1m', 'https://i.scdn.co/image/ab67616d0000b2733d98a0ae7c78a3a9babaf8af', 'NewJeans Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rswrq4cryp3odh7wv1b35zgqvldgurbutewm5j0jgzaubxeza8','Super Shy','6ypb941w7tz6m1m','POP','5sdQOyqq2IDhvmx2lHOpwd','https://p.scdn.co/mp3-preview/dab062e2cc708a2680ce84953a3581c5a679a230?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6wpcc8ly157jzx10xmreciy199lfce8qdroqi6us4qvpmmnz57', 'rswrq4cryp3odh7wv1b35zgqvldgurbutewm5j0jgzaubxeza8', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('egw2gloqycid3dtvm1vv8tvbunw45gfuv7irztf03j00hawoaa','New Jeans','6ypb941w7tz6m1m','POP','6rdkCkjk6D12xRpdMXy0I2','https://p.scdn.co/mp3-preview/a37b4269b0dc5e952826d8c43d1b7c072ac39b4c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6wpcc8ly157jzx10xmreciy199lfce8qdroqi6us4qvpmmnz57', 'egw2gloqycid3dtvm1vv8tvbunw45gfuv7irztf03j00hawoaa', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bfyhitdg09owo3tjnciu6tvc1um64hluc3m1o4odje6h529xln','OMG','6ypb941w7tz6m1m','POP','65FftemJ1DbbZ45DUfHJXE','https://p.scdn.co/mp3-preview/b9e344aa96afc45a56df77ca63c78786bdaa0047?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6wpcc8ly157jzx10xmreciy199lfce8qdroqi6us4qvpmmnz57', 'bfyhitdg09owo3tjnciu6tvc1um64hluc3m1o4odje6h529xln', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e4hv9dwpp7ba2smkn2wi64nekjlixcesjyph393s7l6w89dt6p','Ditto','6ypb941w7tz6m1m','POP','3r8RuvgbX9s7ammBn07D3W','https://p.scdn.co/mp3-preview/4f048713ddfa434539dec7c3cb689f3393353edd?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6wpcc8ly157jzx10xmreciy199lfce8qdroqi6us4qvpmmnz57', 'e4hv9dwpp7ba2smkn2wi64nekjlixcesjyph393s7l6w89dt6p', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7enstw7704q8wyvcjxcpr4h39dgkx5783nl78h3oko71ak9h3r','Hype Boy','6ypb941w7tz6m1m','POP','0a4MMyCrzT0En247IhqZbD','https://p.scdn.co/mp3-preview/7c55950057fc446dc2ce59671dff4fa6b3ef52a7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6wpcc8ly157jzx10xmreciy199lfce8qdroqi6us4qvpmmnz57', '7enstw7704q8wyvcjxcpr4h39dgkx5783nl78h3oko71ak9h3r', '4');
-- Rma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ajpbzgl9o6cbeeq', 'Rma', '109@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3b8f6208d84e28f63841e43c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:109@artist.com', 'ajpbzgl9o6cbeeq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ajpbzgl9o6cbeeq', 'Pioneering new sounds and delivering electrifying performances.', 'Rma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('q43k2dsh9too1oxnoc3hxqxqs1m0jggwiuf4khqlxm36cfqnut','ajpbzgl9o6cbeeq', NULL, 'Rma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('of5vphmzo2er5qb0gyj8xp3xank2ljhoswjnnzfxawvaqzu6dv','Calm Down (with Selena Gomez)','ajpbzgl9o6cbeeq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('q43k2dsh9too1oxnoc3hxqxqs1m0jggwiuf4khqlxm36cfqnut', 'of5vphmzo2er5qb0gyj8xp3xank2ljhoswjnnzfxawvaqzu6dv', '0');
-- IVE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wcftrq76v9pl4wn', 'IVE', '110@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0e46f140189de1eba9ab6230','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:110@artist.com', 'wcftrq76v9pl4wn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wcftrq76v9pl4wn', 'A confluence of cultural beats and contemporary tunes.', 'IVE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4nxbaq5xvzs5dld25efnk5eaq6ogqksqvgmsvjfkrmy7cvzc3e','wcftrq76v9pl4wn', 'https://i.scdn.co/image/ab67616d0000b27325ef3cec1eceefd4db2f91c8', 'IVE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i6u3d2sbazhamvg4bal84np94j6mkwplxom9xv5y298nomp1cu','I AM','wcftrq76v9pl4wn','POP','70t7Q6AYG6ZgTYmJWcnkUM','https://p.scdn.co/mp3-preview/8d1fa5354093e98745ccef77ecb60fac3c9d38d0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4nxbaq5xvzs5dld25efnk5eaq6ogqksqvgmsvjfkrmy7cvzc3e', 'i6u3d2sbazhamvg4bal84np94j6mkwplxom9xv5y298nomp1cu', '0');
-- Jack Harlow
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ixcm12jxuoisxc2', 'Jack Harlow', '111@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5ee4635b0775e342e064657','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:111@artist.com', 'ixcm12jxuoisxc2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ixcm12jxuoisxc2', 'Melodies that capture the essence of human emotion.', 'Jack Harlow');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('acx3coeok6ngpg7s5ultiehdpw3eywm0a4ins0i6pmj14ddw55','ixcm12jxuoisxc2', NULL, 'Jack Harlow Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ozcyl0mbwwy2h4ei3cweonuecwllg8obiz1vf76zpgqu02zpjc','INDUSTRY BABY (feat. Jack Harlow)','ixcm12jxuoisxc2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('acx3coeok6ngpg7s5ultiehdpw3eywm0a4ins0i6pmj14ddw55', 'ozcyl0mbwwy2h4ei3cweonuecwllg8obiz1vf76zpgqu02zpjc', '0');
-- James Arthur
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5qvaqent498dyl3', 'James Arthur', '112@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2a0c6d0343c82be9dd6fce0b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:112@artist.com', '5qvaqent498dyl3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5qvaqent498dyl3', 'Where words fail, my music speaks.', 'James Arthur');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t0rkffnuhdk8yak6klbun7gu5cvi2qq57svpepepbr7ga0491o','5qvaqent498dyl3', 'https://i.scdn.co/image/ab67616d0000b273dc16d839ab77c64bdbeb3660', 'James Arthur Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6qkvn2dpw68oo40kmb175kodxwjm4q3chymlxxzh4do9hjugdm','Cars Outside','5qvaqent498dyl3','POP','0otRX6Z89qKkHkQ9OqJpKt','https://p.scdn.co/mp3-preview/cfaa30729da8d2d8965fae154b6e9d0964a2ea6b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t0rkffnuhdk8yak6klbun7gu5cvi2qq57svpepepbr7ga0491o', '6qkvn2dpw68oo40kmb175kodxwjm4q3chymlxxzh4do9hjugdm', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mzxni88v0k8ekqto6xwd7m7ud1r5k4amdpvauqtg3h7i3dod0q','Say You Wont Let Go','5qvaqent498dyl3','POP','5uCax9HTNlzGybIStD3vDh','https://p.scdn.co/mp3-preview/2eed95a3c08cd10669768ce60d1140f85ba8b951?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t0rkffnuhdk8yak6klbun7gu5cvi2qq57svpepepbr7ga0491o', 'mzxni88v0k8ekqto6xwd7m7ud1r5k4amdpvauqtg3h7i3dod0q', '1');
-- Post Malone
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('s4lpplo6nundxni', 'Post Malone', '113@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:113@artist.com', 's4lpplo6nundxni', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('s4lpplo6nundxni', 'Blurring genre lines with his unique blend of hip-hop and pop.', 'Post Malone');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ucjsy465ackbem8x275nhhx2jm6ur7stso747lqbbyfetey6mx','s4lpplo6nundxni', 'https://i.scdn.co/image/ab67616d0000b2739478c87599550dd73bfa7e02', 'Post Malone Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7oyrvv8bbh6e9ce09aifwa7sdpdlk27s2dc2z09klxzjqjd9z2','Sunflower - Spider-Man: Into the Spider-Verse','s4lpplo6nundxni','POP','0RiRZpuVRbi7oqRdSMwhQY',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ucjsy465ackbem8x275nhhx2jm6ur7stso747lqbbyfetey6mx', '7oyrvv8bbh6e9ce09aifwa7sdpdlk27s2dc2z09klxzjqjd9z2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('noubfoqbf8x9wrmwau1b8y8pam1q8230ul0js5tzn5hffmsygc','Overdrive','s4lpplo6nundxni','POP','3t0ic4mkhvhamrKDkulB8v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ucjsy465ackbem8x275nhhx2jm6ur7stso747lqbbyfetey6mx', 'noubfoqbf8x9wrmwau1b8y8pam1q8230ul0js5tzn5hffmsygc', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hzmkylohwqbkdmqakkkrzb69o21nukz7eqsboi25955rm8iol1','Chemical','s4lpplo6nundxni','POP','5w40ZYhbBMAlHYNDaVJIUu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ucjsy465ackbem8x275nhhx2jm6ur7stso747lqbbyfetey6mx', 'hzmkylohwqbkdmqakkkrzb69o21nukz7eqsboi25955rm8iol1', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dpwglkq7o72ib6prvu2m9mchkj1wjk2s8a02u9106kx1kg2eiv','Circles','s4lpplo6nundxni','POP','21jGcNKet2qwijlDFuPiPb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ucjsy465ackbem8x275nhhx2jm6ur7stso747lqbbyfetey6mx', 'dpwglkq7o72ib6prvu2m9mchkj1wjk2s8a02u9106kx1kg2eiv', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('h58x49c03xpo5g5yzkk26r4o2mw3n2tvol3bcoe5d0js4p6eto','I Like You (A Happier Song) (with Doja Cat)','s4lpplo6nundxni','POP','0O6u0VJ46W86TxN9wgyqDj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ucjsy465ackbem8x275nhhx2jm6ur7stso747lqbbyfetey6mx', 'h58x49c03xpo5g5yzkk26r4o2mw3n2tvol3bcoe5d0js4p6eto', '4');
-- LE SSERAFIM
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hrk8fajosivcb8q', 'LE SSERAFIM', '114@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb99752c006407988976248679','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:114@artist.com', 'hrk8fajosivcb8q', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hrk8fajosivcb8q', 'Harnessing the power of melody to tell compelling stories.', 'LE SSERAFIM');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hxtjwrrun09mzvhin1kkm9htfs6a7skv1zeeba1zqftaqz2tid','hrk8fajosivcb8q', 'https://i.scdn.co/image/ab67616d0000b273a991995542d50a691b9ae5be', 'LE SSERAFIM Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m0wdm6uacgj3p5r4an8nm3wmrslsr0glck72auwk099eh54h4i','ANTIFRAGILE','hrk8fajosivcb8q','POP','4fsQ0K37TOXa3hEQfjEic1','https://p.scdn.co/mp3-preview/97a1c7e470172e0993f8f65dc109ab9d017d7adc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hxtjwrrun09mzvhin1kkm9htfs6a7skv1zeeba1zqftaqz2tid', 'm0wdm6uacgj3p5r4an8nm3wmrslsr0glck72auwk099eh54h4i', '0');
-- Omar Apollo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vmidx59h843c7nl', 'Omar Apollo', '115@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0e2a3a2c664a4bbb14e44f8e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:115@artist.com', 'vmidx59h843c7nl', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vmidx59h843c7nl', 'A harmonious blend of passion and creativity.', 'Omar Apollo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pljmbb7r6sxrc8w6p982wwsmj347zb0jzmc1h31peqzb1li9yx','vmidx59h843c7nl', 'https://i.scdn.co/image/ab67616d0000b27390cf5d1ccfca2beb86149a19', 'Omar Apollo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rky3j36ffgo5fwtw5tyxpjqa69d4nha0px232roh294azpe45n','Evergreen (You Didnt Deserve Me A','vmidx59h843c7nl','POP','2TktkzfozZifbQhXjT6I33','https://p.scdn.co/mp3-preview/f9db43c10cfab231d9448792464a23f6e6d607e7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pljmbb7r6sxrc8w6p982wwsmj347zb0jzmc1h31peqzb1li9yx', 'rky3j36ffgo5fwtw5tyxpjqa69d4nha0px232roh294azpe45n', '0');
-- Grupo Frontera
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ke4tbl2g1ibik4t', 'Grupo Frontera', '116@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f1a7e9f510bf0501e209c58','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:116@artist.com', 'ke4tbl2g1ibik4t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ke4tbl2g1ibik4t', 'An alchemist of harmonies, transforming notes into gold.', 'Grupo Frontera');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rxb0wb20d2wolyug9r2v6w4qk64n5lg07u2kaeln4vi1ib4kk8','ke4tbl2g1ibik4t', 'https://i.scdn.co/image/ab67616d0000b27382ce4c7bbf861185252e82ae', 'Grupo Frontera Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gn6xra0idvco34l9hna2pkpn5qd0c56xnfkcdh5q65e7kps8mo','No Se Va','ke4tbl2g1ibik4t','POP','76kelNDs1ojicx1s6Urvck','https://p.scdn.co/mp3-preview/1aa36481ad26b54ce635e7eb7d7360353c09d9ea?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rxb0wb20d2wolyug9r2v6w4qk64n5lg07u2kaeln4vi1ib4kk8', 'gn6xra0idvco34l9hna2pkpn5qd0c56xnfkcdh5q65e7kps8mo', '0');
-- Yuridia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('g9v2ehfy5lbu2hn', 'Yuridia', '117@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb238b537cb702308e59f709bf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:117@artist.com', 'g9v2ehfy5lbu2hn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('g9v2ehfy5lbu2hn', 'Elevating the ordinary to extraordinary through music.', 'Yuridia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uunatm3qrfwse6l79syiemhgs04w8glvy38nl8npzi9e42okvl','g9v2ehfy5lbu2hn', 'https://i.scdn.co/image/ab67616d0000b2732e9425d8413217cc2942cacf', 'Yuridia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('37h7pez8fiokqanqykkxh3gxmt0b5t6c8cma4ylgr64e9rqu1q','Qu Ago','g9v2ehfy5lbu2hn','POP','4H6o1bxKRGzmsE0vzo968m','https://p.scdn.co/mp3-preview/5576fde4795672bfa292bbf58adf0f9159af0be3?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uunatm3qrfwse6l79syiemhgs04w8glvy38nl8npzi9e42okvl', '37h7pez8fiokqanqykkxh3gxmt0b5t6c8cma4ylgr64e9rqu1q', '0');
-- Kodak Black
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dzn0e9dkdzla640', 'Kodak Black', '118@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb70c05cf4dc9a7d3ffd02ba19','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:118@artist.com', 'dzn0e9dkdzla640', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dzn0e9dkdzla640', 'Crafting a unique sonic identity in every track.', 'Kodak Black');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4qdg173gu2wz2a0zdy67hvfytgtuph6nrweph7tsevuujbmpl9','dzn0e9dkdzla640', 'https://i.scdn.co/image/ab67616d0000b273445afb6341d2685b959251cc', 'Kodak Black Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('blqgip7ww9m3mttfealjjk4vjmdkadt2o2y5z896lron86n0sn','Angel Pt 1 (feat. Jimin of BTS, JVKE & Muni Long)','dzn0e9dkdzla640','POP','1vvcEHQdaUTvWt0EIUYcFK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4qdg173gu2wz2a0zdy67hvfytgtuph6nrweph7tsevuujbmpl9', 'blqgip7ww9m3mttfealjjk4vjmdkadt2o2y5z896lron86n0sn', '0');
-- Natanael Cano
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5wpg3grvbv3hnsh', 'Natanael Cano', '119@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0819edd43096a2f0dde7cd44','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:119@artist.com', '5wpg3grvbv3hnsh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5wpg3grvbv3hnsh', 'An endless quest for musical perfection.', 'Natanael Cano');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ivl5hzzgeb7hftbjg0do91jl19l2czs2dwoxv3txznbo97omwq','5wpg3grvbv3hnsh', 'https://i.scdn.co/image/ab67616d0000b273e2e093427065eaca9e2f2970', 'Natanael Cano Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z5sv63z2o7jkpcolhgl7rpvs22kzkwf6poigryrllbwuwrwynd','Mi Bello Angel','5wpg3grvbv3hnsh','POP','4t46soaqA758rbukTO5pp1','https://p.scdn.co/mp3-preview/07854d155311327027a073aeb36f0f61cdb07096?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ivl5hzzgeb7hftbjg0do91jl19l2czs2dwoxv3txznbo97omwq', 'z5sv63z2o7jkpcolhgl7rpvs22kzkwf6poigryrllbwuwrwynd', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dtx0abc7034pvxkpi6qe3tn3v4f0f8duvjepepfdoa0pbp0om1','PRC','5wpg3grvbv3hnsh','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ivl5hzzgeb7hftbjg0do91jl19l2czs2dwoxv3txznbo97omwq', 'dtx0abc7034pvxkpi6qe3tn3v4f0f8duvjepepfdoa0pbp0om1', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ifr6s3gz6blcjv45qpvhky6a7df35qwm66vymjx91kyd6kdusg','AMG','5wpg3grvbv3hnsh','POP','1lRtH4FszTrwwlK5gTSbXO','https://p.scdn.co/mp3-preview/2a54eb02ee2a7e8c47c6107f16272a19a0e6362b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ivl5hzzgeb7hftbjg0do91jl19l2czs2dwoxv3txznbo97omwq', 'ifr6s3gz6blcjv45qpvhky6a7df35qwm66vymjx91kyd6kdusg', '2');
-- Rosa Linn
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('aae2q7e5boadiy3', 'Rosa Linn', '120@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc5fe9684ed75d00000b63791','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:120@artist.com', 'aae2q7e5boadiy3', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('aae2q7e5boadiy3', 'An odyssey of sound that defies conventions.', 'Rosa Linn');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vbsgypk49uuw23n4jzz03baeupl9acicp7sd8ia7yfk0a16jrd','aae2q7e5boadiy3', 'https://i.scdn.co/image/ab67616d0000b2731391b1fdb63da53e5b112224', 'Rosa Linn Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('29nb83axm8geu1ffwp3btlxedawuw9j923wtto8fxenqc8q5gw','SNAP','aae2q7e5boadiy3','POP','76OGwb5RA9h4FxQPT33ekc','https://p.scdn.co/mp3-preview/0a41500662a6b6223dcb026b20ef1437985574b8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vbsgypk49uuw23n4jzz03baeupl9acicp7sd8ia7yfk0a16jrd', '29nb83axm8geu1ffwp3btlxedawuw9j923wtto8fxenqc8q5gw', '0');
-- Sean Paul
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2fgrp0hyqpass1n', 'Sean Paul', '121@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb60c3e9abe7327c0097738f22','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:121@artist.com', '2fgrp0hyqpass1n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2fgrp0hyqpass1n', 'Melodies that capture the essence of human emotion.', 'Sean Paul');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('p3f5e10nl4ixc3l580n0aocit8b6jdaiutoiyjj6tc4k5gaang','2fgrp0hyqpass1n', NULL, 'Sean Paul Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s2lgayd979ngev32rrov83bfi92dn1xurzezks1fj7yyw4k5ep','Nia Bo','2fgrp0hyqpass1n','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('p3f5e10nl4ixc3l580n0aocit8b6jdaiutoiyjj6tc4k5gaang', 's2lgayd979ngev32rrov83bfi92dn1xurzezks1fj7yyw4k5ep', '0');
-- Yandel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('8bwumy2agnj675b', 'Yandel', '122@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7dbaf2fabcbd4b37168397fd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:122@artist.com', '8bwumy2agnj675b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('8bwumy2agnj675b', 'A powerhouse of reggaeton, blending rhythms that move the soul.', 'Yandel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3rmxicnvz5g50lelr4z4emjsv00ychedxrm3ndbizses5u03az','8bwumy2agnj675b', 'https://i.scdn.co/image/ab67616d0000b273b2aec01b56eeb74610532700', 'Yandel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4tysd6ew0ww767lpv6vsy444zuj2anr45y75oktzgxc3jitd6t','Yandel 150','8bwumy2agnj675b','POP','4FAKtPVycI4DxoOHC01YqD','https://p.scdn.co/mp3-preview/338ed053ce26ccc3313b00b5e6153e60ffd2eb19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3rmxicnvz5g50lelr4z4emjsv00ychedxrm3ndbizses5u03az', '4tysd6ew0ww767lpv6vsy444zuj2anr45y75oktzgxc3jitd6t', '0');
-- Eslabon Armado
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bfqs3enfb1ocqyg', 'Eslabon Armado', '123@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5ccab5d3dc10a08d89cbd76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:123@artist.com', 'bfqs3enfb1ocqyg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bfqs3enfb1ocqyg', 'Bringing a fresh take to traditional music, weaving in modern influences.', 'Eslabon Armado');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bkbx8qulnkg3974z0960ic5ehxebe2kru0jd2ppvsqozoabkqv','bfqs3enfb1ocqyg', 'https://i.scdn.co/image/ab67616d0000b2732071a0c79802d9375a53bfef', 'Eslabon Armado Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ijt4z4euw3t4mrlbatqwk60r3itvdtlwjt3b12wp78h40h0tia','Ella Baila Sola','bfqs3enfb1ocqyg','POP','3dnP0JxCgygwQH9Gm7q7nb','https://p.scdn.co/mp3-preview/5d39f3e17f1e20e2711d033001e48b8d4249b992?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bkbx8qulnkg3974z0960ic5ehxebe2kru0jd2ppvsqozoabkqv', 'ijt4z4euw3t4mrlbatqwk60r3itvdtlwjt3b12wp78h40h0tia', '0');
-- Central Cee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wkwrq51r1gnzde5', 'Central Cee', '124@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5fe7cabb8de1c0266cd2179c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:124@artist.com', 'wkwrq51r1gnzde5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wkwrq51r1gnzde5', 'Breathing new life into classic genres.', 'Central Cee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('r3p8ky4xx9muj78k0i6y6r8hrgiz1fec1c5o6xzlvcpth9q5n4','wkwrq51r1gnzde5', 'https://i.scdn.co/image/ab67616d0000b273cbb3701743a568e7f1c4e967', 'Central Cee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4nhz7bcr4no8uop8y5ljwyph7ggkdnaitnxtcy0cdu3mmmo98n','LET GO','wkwrq51r1gnzde5','POP','3zkyus0njMCL6phZmNNEeN','https://p.scdn.co/mp3-preview/5391f8e7621898d3f5237e297e3fbcabe1fe3494?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r3p8ky4xx9muj78k0i6y6r8hrgiz1fec1c5o6xzlvcpth9q5n4', '4nhz7bcr4no8uop8y5ljwyph7ggkdnaitnxtcy0cdu3mmmo98n', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('iu0335gc5v1y1qcjm5yi964vhkchu8jijz4icb5zdrbr5h71l7','Doja','wkwrq51r1gnzde5','POP','3LtpKP5abr2qqjunvjlX5i','https://p.scdn.co/mp3-preview/41105628e270a026ac9aecacd44e3373fceb9f43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r3p8ky4xx9muj78k0i6y6r8hrgiz1fec1c5o6xzlvcpth9q5n4', 'iu0335gc5v1y1qcjm5yi964vhkchu8jijz4icb5zdrbr5h71l7', '1');
-- (G)I-DLE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gptvg94mwtkjmwb', '(G)I-DLE', '125@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8abd5f97fc52561939ebbc89','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:125@artist.com', 'gptvg94mwtkjmwb', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gptvg94mwtkjmwb', 'A confluence of cultural beats and contemporary tunes.', '(G)I-DLE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fg7n6sc8d3un37ciodripnzi8jaisuvlx63rr40y5sf6i1d4dx','gptvg94mwtkjmwb', 'https://i.scdn.co/image/ab67616d0000b27382dd2427e6d302711b1b9616', '(G)I-DLE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x04dyhhnz5w8slyr0e3z373r1ewjfsdq1uph287vwrnd045efq','Queencard','gptvg94mwtkjmwb','POP','4uOBL4DDWWVx4RhYKlPbPC','https://p.scdn.co/mp3-preview/9f36e86bca0911d3f849197e8f531b9d0c34f002?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fg7n6sc8d3un37ciodripnzi8jaisuvlx63rr40y5sf6i1d4dx', 'x04dyhhnz5w8slyr0e3z373r1ewjfsdq1uph287vwrnd045efq', '0');
-- Offset
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wtcn89f73aep9aj', 'Offset', '126@artist.com', 'https://i.scdn.co/image/ab67616d0000b2736edd8e309824c6f3fd3f3466','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:126@artist.com', 'wtcn89f73aep9aj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wtcn89f73aep9aj', 'A visionary in the world of music, redefining genres.', 'Offset');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3udtz9gfhi4t9ks9x6q6536111gwd2lw5ci4y6tfluky883rp7','wtcn89f73aep9aj', 'https://i.scdn.co/image/ab67616d0000b2736ed9aef791159496b286179f', 'Offset Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l0op5duy6070cs15ukzwf7avs5ygkroqyx3eo0cnjau1rmf53z','Danger (Spider) (Offset & JID)','wtcn89f73aep9aj','POP','3X6qK1LdMkSOhklwRa2ZfG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3udtz9gfhi4t9ks9x6q6536111gwd2lw5ci4y6tfluky883rp7', 'l0op5duy6070cs15ukzwf7avs5ygkroqyx3eo0cnjau1rmf53z', '0');
-- David Guetta
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('bpbwthhbtbjhhr9', 'David Guetta', '127@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0448096d85094a6ec5e8fab','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:127@artist.com', 'bpbwthhbtbjhhr9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('bpbwthhbtbjhhr9', 'A legend in the electronic music world, constantly innovating and entertaining.', 'David Guetta');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('haey6p292zm5t4xyis18w8rd7jzbg97hzdf52upb5og5jusxw4','bpbwthhbtbjhhr9', 'https://i.scdn.co/image/ab67616d0000b2730b4ef75c3728599aa4104f7a', 'David Guetta Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4c36inhkdfqo41edyk07cv05edt3re00zgy3usthkfpgn9mjkp','Baby Dont Hurt Me','bpbwthhbtbjhhr9','POP','3BKD1PwArikchz2Zrlp1qi','https://p.scdn.co/mp3-preview/a8f2e176e17e0f6298b42ef8e96118318fdd2b89?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('haey6p292zm5t4xyis18w8rd7jzbg97hzdf52upb5og5jusxw4', '4c36inhkdfqo41edyk07cv05edt3re00zgy3usthkfpgn9mjkp', '0');
-- Alec Benjamin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wchobrm7ayg7llq', 'Alec Benjamin', '128@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc7e8521887c99b10c8bbfbac','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:128@artist.com', 'wchobrm7ayg7llq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wchobrm7ayg7llq', 'Elevating the ordinary to extraordinary through music.', 'Alec Benjamin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('de1p2vl4vdnz6xkyr921250ywg5g2b6z219hxd450ygyui3h2q','wchobrm7ayg7llq', 'https://i.scdn.co/image/ab67616d0000b273459d675aa0b6f3b211357370', 'Alec Benjamin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g264cyatca1ypi7l05bei7uxvh1tsxikcsl3twol7kb4rugsmz','Let Me Down Slowly','wchobrm7ayg7llq','POP','2qxmye6gAegTMjLKEBoR3d','https://p.scdn.co/mp3-preview/19007111a4e21096bcefef77842d7179f0cdf12a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('de1p2vl4vdnz6xkyr921250ywg5g2b6z219hxd450ygyui3h2q', 'g264cyatca1ypi7l05bei7uxvh1tsxikcsl3twol7kb4rugsmz', '0');
-- NLE Choppa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('phnr2v41wxk6zng', 'NLE Choppa', '129@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcc5865053e7177aeb0c26b62','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:129@artist.com', 'phnr2v41wxk6zng', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('phnr2v41wxk6zng', 'Music is my canvas, and notes are my paint.', 'NLE Choppa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y5k4f01nkvklzpa9toqe89sdjvqy83lhqc0jjq03v4n7h7rngj','phnr2v41wxk6zng', 'https://i.scdn.co/image/ab67616d0000b27349a4f6c9a637e02252a0076d', 'NLE Choppa Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('94dzctvzf1vooofueuwd9bxl9q3eb8jqbzlo85r3qalek8nvka','Slut Me Out','phnr2v41wxk6zng','POP','5BmB3OaQyYXCqRyN8iR2Yi','https://p.scdn.co/mp3-preview/84ef49a1e71bdac04b7dfb1dea3a56d1ffc50357?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y5k4f01nkvklzpa9toqe89sdjvqy83lhqc0jjq03v4n7h7rngj', '94dzctvzf1vooofueuwd9bxl9q3eb8jqbzlo85r3qalek8nvka', '0');
-- Migrantes
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jpcv1psn1obz4vu', 'Migrantes', '130@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb676e77ad14850536079e2ea8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:130@artist.com', 'jpcv1psn1obz4vu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jpcv1psn1obz4vu', 'An alchemist of harmonies, transforming notes into gold.', 'Migrantes');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ar0j0flhdb7xu9qf0e6higjyt3po14yghf3pbmwz0lhow3iamu','jpcv1psn1obz4vu', NULL, 'Migrantes Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fs3unrxnn4ow1xd4aac7v4qmz34kdb9u69m8h2kestuzrzcrkz','MERCHO','jpcv1psn1obz4vu','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ar0j0flhdb7xu9qf0e6higjyt3po14yghf3pbmwz0lhow3iamu', 'fs3unrxnn4ow1xd4aac7v4qmz34kdb9u69m8h2kestuzrzcrkz', '0');
-- Robin Schulz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y4qu5sskngm195l', 'Robin Schulz', '131@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2615ef39cf9128c447b31619','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:131@artist.com', 'y4qu5sskngm195l', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y4qu5sskngm195l', 'Weaving lyrical magic into every song.', 'Robin Schulz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xrurlr5s9rcwkr74amp7uhvhcgix5i13dms78tyt7cjrbrtang','y4qu5sskngm195l', NULL, 'Robin Schulz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6pjiaeeehuvi028dxc2n4sh79kkqwok4o23baclz2yv28fsde7','Miss You','y4qu5sskngm195l','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xrurlr5s9rcwkr74amp7uhvhcgix5i13dms78tyt7cjrbrtang', '6pjiaeeehuvi028dxc2n4sh79kkqwok4o23baclz2yv28fsde7', '0');
-- d4vd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('sffb9dtve9rq98g', 'd4vd', '132@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad447187a35f422307e88ad3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:132@artist.com', 'sffb9dtve9rq98g', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('sffb9dtve9rq98g', 'Crafting a unique sonic identity in every track.', 'd4vd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yz5qayy4hmm19qxlaucl5s9tz4q3zmt4s2yd8jrgls69ot86u8','sffb9dtve9rq98g', 'https://i.scdn.co/image/ab67616d0000b27364fa1bda999f4fbd2b7c4bb7', 'd4vd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1zwuzn2al6exkto0vut8lsa93tt700ul6raioc8o2nv1007nkf','Here With Me','sffb9dtve9rq98g','POP','5LrN7yUQAzvthd4QujgPFr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yz5qayy4hmm19qxlaucl5s9tz4q3zmt4s2yd8jrgls69ot86u8', '1zwuzn2al6exkto0vut8lsa93tt700ul6raioc8o2nv1007nkf', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('glc1whvd9jfp6tx41hwu0zcehpxsfk3fp7fhiz6ioqco0yoprh','Romantic Homicide','sffb9dtve9rq98g','POP','1xK59OXxi2TAAAbmZK0kBL',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yz5qayy4hmm19qxlaucl5s9tz4q3zmt4s2yd8jrgls69ot86u8', 'glc1whvd9jfp6tx41hwu0zcehpxsfk3fp7fhiz6ioqco0yoprh', '1');
-- Conan Gray
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fuzdyopjnzm6ffd', 'Conan Gray', '133@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc1c8fa15e08cb31eeb03b771','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:133@artist.com', 'fuzdyopjnzm6ffd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fuzdyopjnzm6ffd', 'A tapestry of rhythms that echo the pulse of life.', 'Conan Gray');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('m2nrk6s6705r6bkcj91inl2gk5527to4fyg54rt04a2ghdtj8a','fuzdyopjnzm6ffd', 'https://i.scdn.co/image/ab67616d0000b27388e3cda6d29b2552d4d6bc43', 'Conan Gray Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n75c7q8a7yswr8uhmpdwk1rivsbag50kcoohc71lwdtt5lv28x','Heather','fuzdyopjnzm6ffd','POP','4xqrdfXkTW4T0RauPLv3WA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m2nrk6s6705r6bkcj91inl2gk5527to4fyg54rt04a2ghdtj8a', 'n75c7q8a7yswr8uhmpdwk1rivsbag50kcoohc71lwdtt5lv28x', '0');
-- RAYE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2fx7skb8j6745ek', 'RAYE', '134@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0550f0badff3ad04802b1e86','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:134@artist.com', '2fx7skb8j6745ek', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2fx7skb8j6745ek', 'Sculpting soundwaves into masterpieces of auditory art.', 'RAYE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('n2i9xqrmremt023u2bjgwnt4n4mqoifamzywus9eogl8vcb851','2fx7skb8j6745ek', 'https://i.scdn.co/image/ab67616d0000b27394e5237ce925531dbb38e75f', 'RAYE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g6bbt2vzfonf950ad3j6d0ubkogq1z9nftjfmh9zb57d72te7z','Escapism.','2fx7skb8j6745ek','POP','5mHdCZtVyb4DcJw8799hZp','https://p.scdn.co/mp3-preview/8a8fcaf9ddf050562048d1632ddc880c9ce7c972?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n2i9xqrmremt023u2bjgwnt4n4mqoifamzywus9eogl8vcb851', 'g6bbt2vzfonf950ad3j6d0ubkogq1z9nftjfmh9zb57d72te7z', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('64ggjxhjrnxl3jbzvezd9g70x9g74qjwj16xjb1005lcsyd35a','Escapism. - Sped Up','2fx7skb8j6745ek','POP','3XCpS4k8WqNnCpcDOSRRuz','https://p.scdn.co/mp3-preview/22be59e4d5da403513e02e90c27bc1d0965b5f1f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n2i9xqrmremt023u2bjgwnt4n4mqoifamzywus9eogl8vcb851', '64ggjxhjrnxl3jbzvezd9g70x9g74qjwj16xjb1005lcsyd35a', '1');
-- Miley Cyrus
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('7f7e59knxetrqfj', 'Miley Cyrus', '135@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5af3b38f053486ab0784dee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:135@artist.com', '7f7e59knxetrqfj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('7f7e59knxetrqfj', 'Constantly evolving, from pop sensation to rock powerhouse.', 'Miley Cyrus');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8602illymqfjb9x53ioqi9rtjw5s148ackk3gahx71dglxlgxm','7f7e59knxetrqfj', 'https://i.scdn.co/image/ab67616d0000b273cd222052a2594be29a6616b5', 'Miley Cyrus Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p3awl7ladjmti44sawhcyl6ti80bwrd4clvne558tlx7x8e51h','Flowers','7f7e59knxetrqfj','POP','7DSAEUvxU8FajXtRloy8M0','https://p.scdn.co/mp3-preview/5184d19d1b7fcc3e7c067e38af45a7cc80851440?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8602illymqfjb9x53ioqi9rtjw5s148ackk3gahx71dglxlgxm', 'p3awl7ladjmti44sawhcyl6ti80bwrd4clvne558tlx7x8e51h', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('14gmoh0ska6oigzyy4wm0wnnnckfn24gn5gn1e9lfacis4bbve','Angels Like You','7f7e59knxetrqfj','POP','1daDRI9ahBonbWD8YcxOIB','https://p.scdn.co/mp3-preview/4db8314199c0d49e95c786792ecd06eadae9f510?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8602illymqfjb9x53ioqi9rtjw5s148ackk3gahx71dglxlgxm', '14gmoh0ska6oigzyy4wm0wnnnckfn24gn5gn1e9lfacis4bbve', '1');
-- Ray Dalton
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q58r8wj5si9sjyh', 'Ray Dalton', '136@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb761f04a794923fde50fcb9fb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:136@artist.com', 'q58r8wj5si9sjyh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q58r8wj5si9sjyh', 'Revolutionizing the music scene with innovative compositions.', 'Ray Dalton');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('07gbvivkqtkuo2d6qa1ovbjhrz0nq4v8s7rpu6u1dkpzuh6s21','q58r8wj5si9sjyh', NULL, 'Ray Dalton Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x87hinyr500z7wc1b0auw74wmzr5047tptxu1jn70xd7eile25','Cant Hold Us (feat. Ray Dalton)','q58r8wj5si9sjyh','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('07gbvivkqtkuo2d6qa1ovbjhrz0nq4v8s7rpu6u1dkpzuh6s21', 'x87hinyr500z7wc1b0auw74wmzr5047tptxu1jn70xd7eile25', '0');
-- Elley Duh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j75w8sqtowlgrqg', 'Elley Duh', '137@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb44efd91d240d9853049612b4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:137@artist.com', 'j75w8sqtowlgrqg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('j75w8sqtowlgrqg', 'An endless quest for musical perfection.', 'Elley Duh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hiy60wa2op7q88tn4lxhtozv2o3bb4lei1axiq07qjugnngegz','j75w8sqtowlgrqg', 'https://i.scdn.co/image/ab67616d0000b27353a2e11c1bde700722fecd2e', 'Elley Duh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i4eqatjajd6hrqkd9m4u9k2x2ld2qz39dmm5tb857tl6u9hfrc','MIDDLE OF THE NIGHT','j75w8sqtowlgrqg','POP','58HvfVOeJY7lUuCqF0m3ly','https://p.scdn.co/mp3-preview/e7c2441dcf8e321237c35085e4aa05bd0dcfa2c4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hiy60wa2op7q88tn4lxhtozv2o3bb4lei1axiq07qjugnngegz', 'i4eqatjajd6hrqkd9m4u9k2x2ld2qz39dmm5tb857tl6u9hfrc', '0');
-- Quevedo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5aru95xha44zqgz', 'Quevedo', '138@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb2394e996716534bc2c937a1a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:138@artist.com', '5aru95xha44zqgz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5aru95xha44zqgz', 'Merging lyrical depth with compelling urban beats.', 'Quevedo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('x0d8chepwd9g1gcxw869s38pswd04ido3amjiavzsdqe1oru6y','5aru95xha44zqgz', 'https://i.scdn.co/image/ab67616d0000b273a00a817b017c6f6bf8460be9', 'Quevedo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rlcd05zgjg15d5rhyboc8ztry6ygwnd5hz8ktgqn73p7ux4zny','Columbia','5aru95xha44zqgz','POP','6XbtvPmIpyCbjuT0e8cQtp','https://p.scdn.co/mp3-preview/e3d6df66fe67f618166a2cab858580ac8a96486a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x0d8chepwd9g1gcxw869s38pswd04ido3amjiavzsdqe1oru6y', 'rlcd05zgjg15d5rhyboc8ztry6ygwnd5hz8ktgqn73p7ux4zny', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ojyticgib3n4mod19y09w6oncaynwjjjth57wa0djugldyq8gd','Punto G','5aru95xha44zqgz','POP','4WiQA1AGWHFvaxBU6bHghs','https://p.scdn.co/mp3-preview/a1275d1dcfb4c25bc48821b19b81ff853386c148?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x0d8chepwd9g1gcxw869s38pswd04ido3amjiavzsdqe1oru6y', 'ojyticgib3n4mod19y09w6oncaynwjjjth57wa0djugldyq8gd', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tu8cppql89tfcfk0y0jewf2wzpb1xiyh53u0hm8zyhfjck7gzt','Mami Chula','5aru95xha44zqgz','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x0d8chepwd9g1gcxw869s38pswd04ido3amjiavzsdqe1oru6y', 'tu8cppql89tfcfk0y0jewf2wzpb1xiyh53u0hm8zyhfjck7gzt', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ixq4fox8myilqbdep9t5zmcopd3myo34azwm2v7j7265exex4r','WANDA','5aru95xha44zqgz','POP','0Iozrbed8spxoBnmtBMshO','https://p.scdn.co/mp3-preview/a6de4c6031032d886d67e88ec6db1a1c521ed023?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x0d8chepwd9g1gcxw869s38pswd04ido3amjiavzsdqe1oru6y', 'ixq4fox8myilqbdep9t5zmcopd3myo34azwm2v7j7265exex4r', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j1g0ajuu8t9styxm7hmf144vto7toy9kmflwwffrn8pvhy7ghc','Vista Al Mar','5aru95xha44zqgz','POP','5q86iSKkBtOoNkdgEDY5WV','https://p.scdn.co/mp3-preview/6896535fbb6690492102bdb7ca181f33de63ef4e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('x0d8chepwd9g1gcxw869s38pswd04ido3amjiavzsdqe1oru6y', 'j1g0ajuu8t9styxm7hmf144vto7toy9kmflwwffrn8pvhy7ghc', '4');
-- Seafret
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('54k95yvi05muxrq', 'Seafret', '139@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7f753324eacfbe0db36d64e5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:139@artist.com', '54k95yvi05muxrq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('54k95yvi05muxrq', 'The architect of aural landscapes that inspire and captivate.', 'Seafret');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fv2crgvvvyv3eekcz9v0m39a26wg8i3j0brbxrzxcn5vatziyi','54k95yvi05muxrq', 'https://i.scdn.co/image/ab67616d0000b2738c33272a7c77042f5eb39d75', 'Seafret Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qre7tonuoj9oa0ojdf7eldqx7npm0luvfau6uhht1sujz9gj1n','Atlantis','54k95yvi05muxrq','POP','1Fid2jjqsHViMX6xNH70hE','https://p.scdn.co/mp3-preview/2097364ff6c9f41d658ea1b00a5e2153dc61144b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fv2crgvvvyv3eekcz9v0m39a26wg8i3j0brbxrzxcn5vatziyi', 'qre7tonuoj9oa0ojdf7eldqx7npm0luvfau6uhht1sujz9gj1n', '0');
-- Junior H
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kbfrelscrr0xiek', 'Junior H', '140@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:140@artist.com', 'kbfrelscrr0xiek', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kbfrelscrr0xiek', 'A fresh voice in regional Mexican music, blending tradition with modernity.', 'Junior H');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xn3ywn4hqxj9isump1n2ruosaksy0aogt05rip8t0lzq6ri9nb','kbfrelscrr0xiek', 'https://i.scdn.co/image/ab67616d0000b27333ed356efed99b158c4267c6', 'Junior H Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nd1x2ghn0ditxqe23p6bbv814t6zbx7vjjnd29l3orcnz4r59t','El Azul','kbfrelscrr0xiek','POP','1haJsMtoBhHfvuM7XWuT3W','https://p.scdn.co/mp3-preview/f9df136c3a2d3c0c5424e2c4b75a303f35c08af5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xn3ywn4hqxj9isump1n2ruosaksy0aogt05rip8t0lzq6ri9nb', 'nd1x2ghn0ditxqe23p6bbv814t6zbx7vjjnd29l3orcnz4r59t', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('g9ynecli49efcfhe22tiwmtbntmj6lq39qkufjzic7dp9xrc2z','LUNA','kbfrelscrr0xiek','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xn3ywn4hqxj9isump1n2ruosaksy0aogt05rip8t0lzq6ri9nb', 'g9ynecli49efcfhe22tiwmtbntmj6lq39qkufjzic7dp9xrc2z', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2f3idjnt23zaf81b9fr4t74lia7see665o28vrixc9wulbq93n','Abcdario','kbfrelscrr0xiek','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xn3ywn4hqxj9isump1n2ruosaksy0aogt05rip8t0lzq6ri9nb', '2f3idjnt23zaf81b9fr4t74lia7see665o28vrixc9wulbq93n', '2');
-- Beach Weather
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5dzz5rqkuww73j5', 'Beach Weather', '141@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebed9ce2779a99efc01b4f918c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:141@artist.com', '5dzz5rqkuww73j5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5dzz5rqkuww73j5', 'Crafting melodies that resonate with the soul.', 'Beach Weather');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('240euo6v9limwppbsiywb63kbjbjijmz8iy3entzl7jifq6hil','5dzz5rqkuww73j5', 'https://i.scdn.co/image/ab67616d0000b273a03e3d24ccee1c370899c342', 'Beach Weather Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('crfekst9t9wfvp11e7rx0rv0y834eqvoy664m14aucrjbqq2p1','Sex, Drugs, Etc.','5dzz5rqkuww73j5','POP','7MlDNspYwfqnHxORufupwq','https://p.scdn.co/mp3-preview/a423aecddb590788a61f2a7b4d325bf461f88dc8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('240euo6v9limwppbsiywb63kbjbjijmz8iy3entzl7jifq6hil', 'crfekst9t9wfvp11e7rx0rv0y834eqvoy664m14aucrjbqq2p1', '0');
-- Lizzo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jm6c6lp1axzdtk9', 'Lizzo', '142@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0d66b3670294bf801847dae2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:142@artist.com', 'jm6c6lp1axzdtk9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jm6c6lp1axzdtk9', 'Music is my canvas, and notes are my paint.', 'Lizzo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('z925587p5a4v738q5pn2wi159fx2z3yld3bw4d5jwdz9m82wnh','jm6c6lp1axzdtk9', 'https://i.scdn.co/image/ab67616d0000b273b817e721691aff3d67f26c04', 'Lizzo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z02qkseaxczmeuh20jxqqdmkzgp092a7cc9cciso0vj1tqx4p3','About Damn Time','jm6c6lp1axzdtk9','POP','1PckUlxKqWQs3RlWXVBLw3','https://p.scdn.co/mp3-preview/bbf8a26d38f7d8c7191dd64bd7c21a4cec8b61a0?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('z925587p5a4v738q5pn2wi159fx2z3yld3bw4d5jwdz9m82wnh', 'z02qkseaxczmeuh20jxqqdmkzgp092a7cc9cciso0vj1tqx4p3', '0');
-- Arijit Singh
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q0w9dvcfn4nfotz', 'Arijit Singh', '143@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0261696c5df3be99da6ed3f3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:143@artist.com', 'q0w9dvcfn4nfotz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q0w9dvcfn4nfotz', 'A voice that echoes the sentiments of a generation.', 'Arijit Singh');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uq7eiw7h8in66w9nocs48qgp5lhrmda2yfskztd4o7qf84ag37','q0w9dvcfn4nfotz', NULL, 'Arijit Singh Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('usrfhqt4ltjybc1r4tw486qdywo2u9lcp80kruo8nr0pz5hpr9','Phir Aur Kya Chahiye (From "Zara Hatke Zara Bachke")','q0w9dvcfn4nfotz','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uq7eiw7h8in66w9nocs48qgp5lhrmda2yfskztd4o7qf84ag37', 'usrfhqt4ltjybc1r4tw486qdywo2u9lcp80kruo8nr0pz5hpr9', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('szjx3xcc2723guta1kc861oqzougg0o44e08cearn9cc9gdzd2','Apna Bana Le (From "Bhediya")','q0w9dvcfn4nfotz','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uq7eiw7h8in66w9nocs48qgp5lhrmda2yfskztd4o7qf84ag37', 'szjx3xcc2723guta1kc861oqzougg0o44e08cearn9cc9gdzd2', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('11uzatntlojfgtt1r9v5zwepqifvi09fq295w9dgh5nftrcxkn','Jhoome Jo Pathaan','q0w9dvcfn4nfotz','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uq7eiw7h8in66w9nocs48qgp5lhrmda2yfskztd4o7qf84ag37', '11uzatntlojfgtt1r9v5zwepqifvi09fq295w9dgh5nftrcxkn', '2');
-- Loreen
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('yppij2sv93x1jgh', 'Loreen', '144@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3ca2710f45c2993c415a1c5e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:144@artist.com', 'yppij2sv93x1jgh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('yppij2sv93x1jgh', 'Blending genres for a fresh musical experience.', 'Loreen');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0hkiex0oah04zjf82aziss6xbf0oo2tebf6b85at30m0pnxtp5','yppij2sv93x1jgh', 'https://i.scdn.co/image/ab67616d0000b2732b0ba87db609976eee193bd6', 'Loreen Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2efnt74dck91lw7bw97rhme074r8xzniyuqsabxc87ayl0jcj1','Tattoo','yppij2sv93x1jgh','POP','1DmW5Ep6ywYwxc2HMT5BG6',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0hkiex0oah04zjf82aziss6xbf0oo2tebf6b85at30m0pnxtp5', '2efnt74dck91lw7bw97rhme074r8xzniyuqsabxc87ayl0jcj1', '0');
-- Dean Martin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('16w1eidh1a01ubk', 'Dean Martin', '145@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdc6d54b08006b8896cb199e5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:145@artist.com', '16w1eidh1a01ubk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('16w1eidh1a01ubk', 'Uniting fans around the globe with universal rhythms.', 'Dean Martin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wpri8xhsh7rlczx00kmsmfqwb8o4ivbhw9d15zwg1ldr0wvtvk','16w1eidh1a01ubk', 'https://i.scdn.co/image/ab67616d0000b2736d88028a85c771f37374c8ea', 'Dean Martin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ijlv1jzuzad4kax4svm9lpy76uqclhv697igwn787as2qith0z','Let It Snow! Let It Snow! Let It Snow!','16w1eidh1a01ubk','POP','2uFaJJtFpPDc5Pa95XzTvg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wpri8xhsh7rlczx00kmsmfqwb8o4ivbhw9d15zwg1ldr0wvtvk', 'ijlv1jzuzad4kax4svm9lpy76uqclhv697igwn787as2qith0z', '0');
-- Don Toliver
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gg6aueckdtjw9ws', 'Don Toliver', '146@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:146@artist.com', 'gg6aueckdtjw9ws', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gg6aueckdtjw9ws', 'A beacon of innovation in the world of sound.', 'Don Toliver');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y19pj7qbbtnummbbauj78m72q0tkqtr0zwcqs0w8ka1pmoqg1b','gg6aueckdtjw9ws', 'https://i.scdn.co/image/ab67616d0000b273feeff698e6090e6b02f21ec0', 'Don Toliver Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0aqziizjurne1svinvtcma19t4qlby4tuf816wjrftc66yf75b','Private Landing (feat. Justin Bieber & Future)','gg6aueckdtjw9ws','POP','52NGJPcLUzQq5w7uv4e5gf','https://p.scdn.co/mp3-preview/511bdf681359f3b57dfa25344f34c2b66ecc4326?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y19pj7qbbtnummbbauj78m72q0tkqtr0zwcqs0w8ka1pmoqg1b', '0aqziizjurne1svinvtcma19t4qlby4tuf816wjrftc66yf75b', '0');
-- El Chachito
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('f7d2xf63qlw1pxw', 'El Chachito', '147@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb5ccab5d3dc10a08d89cbd76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:147@artist.com', 'f7d2xf63qlw1pxw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('f7d2xf63qlw1pxw', 'Elevating the ordinary to extraordinary through music.', 'El Chachito');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('opbfqa2r8d4kkl3rbejhgmbgwu3qpfn7fuh8zkgbcmifq6z9rz','f7d2xf63qlw1pxw', 'https://i.scdn.co/image/ab67616d0000b27354c372ef8e7b53bb3c932ac5', 'El Chachito Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('363xf5skmg8597aeh87ush0u9undpwhi5vr7sehxg23dvsy07s','En Paris','f7d2xf63qlw1pxw','POP','1Fuc3pBiPFxAeSJoO8tDh5','https://p.scdn.co/mp3-preview/c57f1229ca237b01f9dbd839bc3ca97f22395a87?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('opbfqa2r8d4kkl3rbejhgmbgwu3qpfn7fuh8zkgbcmifq6z9rz', '363xf5skmg8597aeh87ush0u9undpwhi5vr7sehxg23dvsy07s', '0');
-- David Kushner
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wfk9urqo6egq1oj', 'David Kushner', '148@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12fd1bd22516e35ef8c2e591','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:148@artist.com', 'wfk9urqo6egq1oj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wfk9urqo6egq1oj', 'A rising talent, creating music that resonates with a generation.', 'David Kushner');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qfb0lr5dp2ph0g1s5r2m1qpk7occoait3y4qkb80lwt6y74uvy','wfk9urqo6egq1oj', 'https://i.scdn.co/image/ab67616d0000b27395ca6a9b4083a86c149934ae', 'David Kushner Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z60lpo1cilyo5j2cv3p6dlli371dxica8tx4cc53rfdpvdhus7','Daylight','wfk9urqo6egq1oj','POP','1odExI7RdWc4BT515LTAwj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qfb0lr5dp2ph0g1s5r2m1qpk7occoait3y4qkb80lwt6y74uvy', 'z60lpo1cilyo5j2cv3p6dlli371dxica8tx4cc53rfdpvdhus7', '0');
-- Marshmello
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('14rkyz07krp8pha', 'Marshmello', '149@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41e4a3b8c1d45a9e49b6de21','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:149@artist.com', '14rkyz07krp8pha', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('14rkyz07krp8pha', 'An electronic music maestro known for his infectious beats.', 'Marshmello');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ih90szdz02qwy38ve78nk5ym0dv6b7pnp0dzh17y47s6ki8pia','14rkyz07krp8pha', 'https://i.scdn.co/image/ab67616d0000b273f404676577626a87d92cf33f', 'Marshmello Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o99znevaqkfetixx6zr4ybos4xr1jjdjearl9lsmjcbeqs6inx','El Merengue','14rkyz07krp8pha','POP','51FvjPEGKq2zByeeEQ43V9','https://p.scdn.co/mp3-preview/a933b6e1d6a47e591c13192f2b5e58739d3d5a06?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ih90szdz02qwy38ve78nk5ym0dv6b7pnp0dzh17y47s6ki8pia', 'o99znevaqkfetixx6zr4ybos4xr1jjdjearl9lsmjcbeqs6inx', '0');
-- Ruth B.
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0bulfullstym2pf', 'Ruth B.', '150@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1da7ba1c178ab9f68d065197','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:150@artist.com', '0bulfullstym2pf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0bulfullstym2pf', 'Music is my canvas, and notes are my paint.', 'Ruth B.');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('072yjoi31ld2pectyckrgn4rmnz70gjn9tr453295ovvymh9xq','0bulfullstym2pf', 'https://i.scdn.co/image/ab67616d0000b27397e971f3e53475091dc8d707', 'Ruth B. Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ioupde1al8qvbxmhsl89z33aipm587imps2bcu5ni63fyih4jw','Dandelions','0bulfullstym2pf','POP','2eAvDnpXP5W0cVtiI0PUxV','https://p.scdn.co/mp3-preview/3e55602bc286bc1fad9347931327e649ff9adfa1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('072yjoi31ld2pectyckrgn4rmnz70gjn9tr453295ovvymh9xq', 'ioupde1al8qvbxmhsl89z33aipm587imps2bcu5ni63fyih4jw', '0');
-- Steve Lacy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0b718wh73udlwyc', 'Steve Lacy', '151@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb09ac9d040c168d4e4f58eb42','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:151@artist.com', '0b718wh73udlwyc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0b718wh73udlwyc', 'Pushing the boundaries of sound with each note.', 'Steve Lacy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('lr4dv18il2uxva5t4aqdtdsbccetuzp07b65lfvp6n1xu1sre0','0b718wh73udlwyc', 'https://i.scdn.co/image/ab67616d0000b27368968350c2550e36d96344ee', 'Steve Lacy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qjw004t3jc3982bu3ubxn48l6x1x7kr6q5lt6jpyh2ukg1olf1','Bad Habit','0b718wh73udlwyc','POP','4k6Uh1HXdhtusDW5y8Gbvy','https://p.scdn.co/mp3-preview/efe7c2fdd8fa727a108a1270b114ebedabfd766c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lr4dv18il2uxva5t4aqdtdsbccetuzp07b65lfvp6n1xu1sre0', 'qjw004t3jc3982bu3ubxn48l6x1x7kr6q5lt6jpyh2ukg1olf1', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5d77j0co1tih6nw7t4mqmql03crxhnulxvmy2fobqo013ash2w','Dark Red','0b718wh73udlwyc','POP','3EaJDYHA0KnX88JvDhL9oa','https://p.scdn.co/mp3-preview/90b3855fd50a4c4878a2d5117ebe73f658a97285?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('lr4dv18il2uxva5t4aqdtdsbccetuzp07b65lfvp6n1xu1sre0', '5d77j0co1tih6nw7t4mqmql03crxhnulxvmy2fobqo013ash2w', '1');
-- Maria Becerra
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('72puf5pawq8q5v6', 'Maria Becerra', '152@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb6cfa517b8f5a152d63c4ffb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:152@artist.com', '72puf5pawq8q5v6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('72puf5pawq8q5v6', 'A vibrant new voice in Latin pop, fusing catchy melodies with urban sounds.', 'Maria Becerra');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ouy4lsj5wwwwb7ph8t3gud5knmsd3bdykcjhzt0n1yju2ybcpl','72puf5pawq8q5v6', NULL, 'Maria Becerra Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8u5oz5e0479b9e9f58yemwuqvdp4etqjsp587hx07tiy0s4uc7','CORAZN VA','72puf5pawq8q5v6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ouy4lsj5wwwwb7ph8t3gud5knmsd3bdykcjhzt0n1yju2ybcpl', '8u5oz5e0479b9e9f58yemwuqvdp4etqjsp587hx07tiy0s4uc7', '0');
-- Jack Black
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jx4zxrajo38mjtd', 'Jack Black', '153@artist.com', 'https://i.scdn.co/image/ab6772690000c46ca156a562884cb76eeb0b75e9','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:153@artist.com', 'jx4zxrajo38mjtd', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jx4zxrajo38mjtd', 'A voice that echoes the sentiments of a generation.', 'Jack Black');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dirvtg6c6dgz3cyoe1qao00afpykmew6cwhdwc443bhdlx0oz1','jx4zxrajo38mjtd', NULL, 'Jack Black Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tkpqczh01vs56eaayj2i7n6nwvcr8o8nmvw60xefa6xq405457','Peaches (from The Super Mario Bros. Movie)','jx4zxrajo38mjtd','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dirvtg6c6dgz3cyoe1qao00afpykmew6cwhdwc443bhdlx0oz1', 'tkpqczh01vs56eaayj2i7n6nwvcr8o8nmvw60xefa6xq405457', '0');
-- a-ha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ugotuklreli7sud', 'a-ha', '154@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb0168ba8148c07c2cdeb7d067','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:154@artist.com', 'ugotuklreli7sud', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ugotuklreli7sud', 'An odyssey of sound that defies conventions.', 'a-ha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j657b4fdl88igh7d98oraf4x7buohbmaxx8uhkg5ydu3u400bl','ugotuklreli7sud', 'https://i.scdn.co/image/ab67616d0000b273e8dd4db47e7177c63b0b7d53', 'a-ha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x0qq38diwekysgihz5zmuugtrmv910imr423w27s1h37687sil','Take On Me','ugotuklreli7sud','POP','2WfaOiMkCvy7F5fcp2zZ8L','https://p.scdn.co/mp3-preview/ed66a8c444c35b2f5029c04ae8e18f69d952c2bb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j657b4fdl88igh7d98oraf4x7buohbmaxx8uhkg5ydu3u400bl', 'x0qq38diwekysgihz5zmuugtrmv910imr423w27s1h37687sil', '0');
-- Bizarrap
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zah8kutgooa2vkg', 'Bizarrap', '155@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:155@artist.com', 'zah8kutgooa2vkg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zah8kutgooa2vkg', 'Revolutionizing the music scene with his unique production style and collaborations.', 'Bizarrap');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y6dt04znacy8fpj4d0i1ix2jig7opea46uw1o9xhlo8a73sczc','zah8kutgooa2vkg', 'https://i.scdn.co/image/ab67616d0000b27315583045b2fdb7d7bab10e81', 'Bizarrap Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l7xp1nloc1gwdjknbon3n7ryxdt847i3lirjbior69lhson3h3','Peso Pluma: Bzrp Music Sessions, Vol. 55','zah8kutgooa2vkg','POP','5AqiaZwhmC6dIbgWrD5SzV','https://p.scdn.co/mp3-preview/9d61998a29c2e8b52a7d46885352f5507eb219e2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y6dt04znacy8fpj4d0i1ix2jig7opea46uw1o9xhlo8a73sczc', 'l7xp1nloc1gwdjknbon3n7ryxdt847i3lirjbior69lhson3h3', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n1pc1j4m54nush0j0u29weonc1l9vlv88xfy6c1kf9xd7bxswv','Quevedo: Bzrp Music Sessions, Vol. 52','zah8kutgooa2vkg','POP','2tTmW7RDtMQtBk7m2rYeSw','https://p.scdn.co/mp3-preview/e9c0ed735e611f6af45bc946bd4c31590df09ed6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y6dt04znacy8fpj4d0i1ix2jig7opea46uw1o9xhlo8a73sczc', 'n1pc1j4m54nush0j0u29weonc1l9vlv88xfy6c1kf9xd7bxswv', '1');
-- Yng Lvcas
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('n71hd9cgen0ig89', 'Yng Lvcas', '156@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3df5eb47e5d93bd2ca536a5a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:156@artist.com', 'n71hd9cgen0ig89', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('n71hd9cgen0ig89', 'Music is my canvas, and notes are my paint.', 'Yng Lvcas');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('40eew77irgu53631hlwnagjcqvuthetuf2zrmlnmzko93jly8p','n71hd9cgen0ig89', 'https://i.scdn.co/image/ab67616d0000b273a04be3ad7c8c67f4109111a9', 'Yng Lvcas Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kzj69ddoa13zu4zckbpvdhdbi73uil3wntnfmby55razoqw2k9','La Bebe','n71hd9cgen0ig89','POP','2UW7JaomAMuX9pZrjVpHAU','https://p.scdn.co/mp3-preview/57c5d5266219b32d455ed22417155bbabde7170f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('40eew77irgu53631hlwnagjcqvuthetuf2zrmlnmzko93jly8p', 'kzj69ddoa13zu4zckbpvdhdbi73uil3wntnfmby55razoqw2k9', '0');
-- James Blake
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('x73wiv8c5zjz1ck', 'James Blake', '157@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb93fe5fc8fdb5a98248911a07','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:157@artist.com', 'x73wiv8c5zjz1ck', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('x73wiv8c5zjz1ck', 'A voice that echoes the sentiments of a generation.', 'James Blake');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hoube86pjdoqkhu6g6u44q1ye2ae5a6e3z3o09638j38kjrwtu','x73wiv8c5zjz1ck', NULL, 'James Blake Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4l2q8cfqas9n1i1z3fjqoqb4u4f1z4rfmb1p2mcmx3a5akdoje','Hummingbird (Metro Boomin & James Blake)','x73wiv8c5zjz1ck','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hoube86pjdoqkhu6g6u44q1ye2ae5a6e3z3o09638j38kjrwtu', '4l2q8cfqas9n1i1z3fjqoqb4u4f1z4rfmb1p2mcmx3a5akdoje', '0');
-- Mahalini
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('g1j5ttwjeqrxz50', 'Mahalini', '158@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb8333468abeb2e461d1ab5ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:158@artist.com', 'g1j5ttwjeqrxz50', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('g1j5ttwjeqrxz50', 'A symphony of emotions expressed through sound.', 'Mahalini');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('t2vgxx9dkz13ggfdw904kd1kp628qnju44l69prsts6t5v24i2','g1j5ttwjeqrxz50', 'https://i.scdn.co/image/ab67616d0000b2736f713eb92ebf7ca05a562542', 'Mahalini Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dhmiav2hrqda3t1dn8vc1z2o1rin73btmhf9egnszkb6mzbxlb','Sial','g1j5ttwjeqrxz50','POP','6O0WEM0QNEhqpU50BKui7o','https://p.scdn.co/mp3-preview/1285e7f97156037b5c1c958513ff3f8176a68a33?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('t2vgxx9dkz13ggfdw904kd1kp628qnju44l69prsts6t5v24i2', 'dhmiav2hrqda3t1dn8vc1z2o1rin73btmhf9egnszkb6mzbxlb', '0');
-- Jain
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('52qlbr4x44dmudn', 'Jain', '159@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb673f287fead1f6c83b9b68ea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:159@artist.com', '52qlbr4x44dmudn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('52qlbr4x44dmudn', 'Mixing electronic beats with multicultural influences to create a unique sound.', 'Jain');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6n9jmee9djmrdz2pjq7b8z8r8tdfgxnvk8boltpise5gu7g81f','52qlbr4x44dmudn', 'https://i.scdn.co/image/ab67616d0000b27364ba66f8a81c52364e55db50', 'Jain Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vqlu5f6o2qxbgrihaumwpqoj49zseu6p3c4xkho6eh7vqj9qnj','Makeba','52qlbr4x44dmudn','POP','4TNFLwe6DhtR3Wn1JKMqMJ','https://p.scdn.co/mp3-preview/41db29480f9d12734adf491d3b5dd4da1005047c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6n9jmee9djmrdz2pjq7b8z8r8tdfgxnvk8boltpise5gu7g81f', 'vqlu5f6o2qxbgrihaumwpqoj49zseu6p3c4xkho6eh7vqj9qnj', '0');
-- Karol G
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('4xc9kgjka3fbj4j', 'Karol G', '160@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb284894d68fe2f80cad555110','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:160@artist.com', '4xc9kgjka3fbj4j', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('4xc9kgjka3fbj4j', 'A queen of reggaeton, known for her empowering anthems and vibrant performances.', 'Karol G');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jba1n73oafwvgxgr8728aah9liq5g70coyx52p40jvpn25otom','4xc9kgjka3fbj4j', 'https://i.scdn.co/image/ab67616d0000b27382de1ca074ae63cb18fce335', 'Karol G Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('m092nlrue1o15fjivqro7g17pajfmyvolo8xn4nkotb6udlt9v','TQG','4xc9kgjka3fbj4j','POP','0DWdj2oZMBFSzRsi2Cvfzf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jba1n73oafwvgxgr8728aah9liq5g70coyx52p40jvpn25otom', 'm092nlrue1o15fjivqro7g17pajfmyvolo8xn4nkotb6udlt9v', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('50w1ncf5p36v4ez1ev79h7ro8i1siw19snbf5u75p20w86ygcu','AMARGURA','4xc9kgjka3fbj4j','POP','505v13epFXodT9fVAJ6h8k',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jba1n73oafwvgxgr8728aah9liq5g70coyx52p40jvpn25otom', '50w1ncf5p36v4ez1ev79h7ro8i1siw19snbf5u75p20w86ygcu', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('85zy97ad39lytntr6u7swfboi6rlbculi6gg49n1h2zp010jvy','S91','4xc9kgjka3fbj4j','POP','7EpOXgSRgnglRWr86pZfGU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jba1n73oafwvgxgr8728aah9liq5g70coyx52p40jvpn25otom', '85zy97ad39lytntr6u7swfboi6rlbculi6gg49n1h2zp010jvy', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4k1rshx6ccr0n84qhxn7v2di4o1xhzqzlsgifx44ims7ltyht4','MIENTRAS ME CURO DEL CORA','4xc9kgjka3fbj4j','POP','6otePxalBK8AVa20xhZYVQ',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jba1n73oafwvgxgr8728aah9liq5g70coyx52p40jvpn25otom', '4k1rshx6ccr0n84qhxn7v2di4o1xhzqzlsgifx44ims7ltyht4', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('dtqmboawnfjzg3v8aytg3o5zuqsun9e4f1xmn5jn94bkqfk5fu','X SI VOLVEMOS','4xc9kgjka3fbj4j','POP','4NoOME4Dhf4xgxbHDT7VGe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jba1n73oafwvgxgr8728aah9liq5g70coyx52p40jvpn25otom', 'dtqmboawnfjzg3v8aytg3o5zuqsun9e4f1xmn5jn94bkqfk5fu', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2biqd9n9tq5v2fxfq8z8man0s1cxvx2h3ehtfa0rw0w5qfo82f','PROVENZA','4xc9kgjka3fbj4j','POP','3HqcNJdZ2seoGxhn0wVNDK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jba1n73oafwvgxgr8728aah9liq5g70coyx52p40jvpn25otom', '2biqd9n9tq5v2fxfq8z8man0s1cxvx2h3ehtfa0rw0w5qfo82f', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7znv6xilz0t9omp4401u7sp3fuhxw3l2dvml10u5chx5nyl3wn','CAIRO','4xc9kgjka3fbj4j','POP','16dUQ4quIHDe4ZZ0wF1EMN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jba1n73oafwvgxgr8728aah9liq5g70coyx52p40jvpn25otom', '7znv6xilz0t9omp4401u7sp3fuhxw3l2dvml10u5chx5nyl3wn', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1en6s6hrso81bj1dxymwpkdj0j70jv95a5yin591njgy6dfp6v','PERO T','4xc9kgjka3fbj4j','POP','1dw7qShk971xMD6r6mA4VN',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jba1n73oafwvgxgr8728aah9liq5g70coyx52p40jvpn25otom', '1en6s6hrso81bj1dxymwpkdj0j70jv95a5yin591njgy6dfp6v', '7');
-- Styrx
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ikvgd6evmddp5we', 'Styrx', '161@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfef3008e708e59efaa5667ed','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:161@artist.com', 'ikvgd6evmddp5we', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ikvgd6evmddp5we', 'Weaving lyrical magic into every song.', 'Styrx');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7hlka1a66wcg0xdajcusgv9l7338hfhr372m3lxyed5h7l42te','ikvgd6evmddp5we', NULL, 'Styrx Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('az9eyw4nmtf6gth96fle0027ttanooo8o1r9qzf8s9phtjbvz8','Agudo Mgi','ikvgd6evmddp5we','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7hlka1a66wcg0xdajcusgv9l7338hfhr372m3lxyed5h7l42te', 'az9eyw4nmtf6gth96fle0027ttanooo8o1r9qzf8s9phtjbvz8', '0');
-- Metro Boomin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('r8l2rhuuqx9emqu', 'Metro Boomin', '162@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:162@artist.com', 'r8l2rhuuqx9emqu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('r8l2rhuuqx9emqu', 'Crafting melodies that resonate with the soul.', 'Metro Boomin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('51rytnplok9yhr0khxy4wezeksnidcjrfv6mmvr58oy3e5derd','r8l2rhuuqx9emqu', 'https://i.scdn.co/image/ab67616d0000b2736ed9aef791159496b286179f', 'Metro Boomin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jjhpy47b6dpt2yalqaaned9mawbsew53pn4o7r87oxnkebfz9k','Self Love (Spider-Man: Across the Spider-Verse) (Metro Boomin & Coi Leray)','r8l2rhuuqx9emqu','POP','0AAMnNeIc6CdnfNU85GwCH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('51rytnplok9yhr0khxy4wezeksnidcjrfv6mmvr58oy3e5derd', 'jjhpy47b6dpt2yalqaaned9mawbsew53pn4o7r87oxnkebfz9k', '0');
-- R
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9z134vdrbh4oc8y', 'R', '163@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6334ab6a83196f36475ada7f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:163@artist.com', '9z134vdrbh4oc8y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9z134vdrbh4oc8y', 'Sculpting soundwaves into masterpieces of auditory art.', 'R');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('h2ofscc0clznh26vq8gieb2283449r80g6xy0zay80h6fwsnho','9z134vdrbh4oc8y', 'https://i.scdn.co/image/ab67616d0000b273a3a7f38ea2033aa501afd4cf', 'R Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ihp28kpju6tr7gz31pdnov14k0ei9io4q8b34u7v8jpsnewbva','Calm Down','9z134vdrbh4oc8y','POP','0WtM2NBVQNNJLh6scP13H8',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('h2ofscc0clznh26vq8gieb2283449r80g6xy0zay80h6fwsnho', 'ihp28kpju6tr7gz31pdnov14k0ei9io4q8b34u7v8jpsnewbva', '0');
-- Future
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5hlu9y1penbcpo6', 'Future', '164@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdf9a1555f53a20087b8c5a5c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:164@artist.com', '5hlu9y1penbcpo6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5hlu9y1penbcpo6', 'Crafting melodies that resonate with the soul.', 'Future');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('n05gg1c1b261kd5sjf3f9cdf1fj3pikl9w98i8m0tn2fnerd7z','5hlu9y1penbcpo6', NULL, 'Future Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r4e5a719qhhyhkefmdvsjmz303t3gcmp34rjrpbnwkgcce9f0c','Too Many Nights (feat. Don Toliver & with Future)','5hlu9y1penbcpo6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n05gg1c1b261kd5sjf3f9cdf1fj3pikl9w98i8m0tn2fnerd7z', 'r4e5a719qhhyhkefmdvsjmz303t3gcmp34rjrpbnwkgcce9f0c', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('89hcqnkqya2dbm40wp571o3tmkl82jdashhbl9q3pzho9omolu','All The Way Live (Spider-Man: Across the Spider-Verse) (Metro Boomin & Future, Lil Uzi Vert)','5hlu9y1penbcpo6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n05gg1c1b261kd5sjf3f9cdf1fj3pikl9w98i8m0tn2fnerd7z', '89hcqnkqya2dbm40wp571o3tmkl82jdashhbl9q3pzho9omolu', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3i4d6w2gigknr5h4kirctkld167ffp7zr2wnqy9v8udjxrxlcq','Superhero (Heroes & Villains) [with Future & Chris Brown]','5hlu9y1penbcpo6','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('n05gg1c1b261kd5sjf3f9cdf1fj3pikl9w98i8m0tn2fnerd7z', '3i4d6w2gigknr5h4kirctkld167ffp7zr2wnqy9v8udjxrxlcq', '2');
-- J. Cole
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('640tqlatp50mjof', 'J. Cole', '165@artist.com', 'https://i.scdn.co/image/ab67616d0000b273d092fc596478080bb0e06aea','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:165@artist.com', '640tqlatp50mjof', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('640tqlatp50mjof', 'A profound lyricist and rapper, known for his thought-provoking music.', 'J. Cole');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kwirtthzih4tyzwsykc8wn40u1mrzw7fb50dj9chixroszi85g','640tqlatp50mjof', NULL, 'J. Cole Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('62yhc2gvdwk90eld7l2vyrn6o9nbsw7yrr96pf9pvq7m6517gm','All My Life (feat. J. Cole)','640tqlatp50mjof','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kwirtthzih4tyzwsykc8wn40u1mrzw7fb50dj9chixroszi85g', '62yhc2gvdwk90eld7l2vyrn6o9nbsw7yrr96pf9pvq7m6517gm', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7rn40982fh4efggkmqd3ninfpsu3pmeonmfa0ifum8d7ocsqfi','No Role Modelz','640tqlatp50mjof','POP','68Dni7IE4VyPkTOH9mRWHr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kwirtthzih4tyzwsykc8wn40u1mrzw7fb50dj9chixroszi85g', '7rn40982fh4efggkmqd3ninfpsu3pmeonmfa0ifum8d7ocsqfi', '1');
-- Gorillaz
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('foezmekfiayt3fe', 'Gorillaz', '166@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb337d671a32b2f44d4a4e6cf2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:166@artist.com', 'foezmekfiayt3fe', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('foezmekfiayt3fe', 'A visionary in the world of music, redefining genres.', 'Gorillaz');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tarkvz73m3k1pllar5ebbijpap77q7pmgoiaooo07wjtqn5ava','foezmekfiayt3fe', 'https://i.scdn.co/image/ab67616d0000b2734b0ddebba0d5b34f2a2f07a4', 'Gorillaz Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0th0aio4v5svtp5f6us9b9lr2onor292onpjgyke0omnjbtsi9','Tormenta (feat. Bad Bunny)','foezmekfiayt3fe','POP','38UYeBLfvpnDSG9GznZdnL','https://p.scdn.co/mp3-preview/3f89a1c3ec527e23fdefdd03da7797b83eb6e14f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tarkvz73m3k1pllar5ebbijpap77q7pmgoiaooo07wjtqn5ava', '0th0aio4v5svtp5f6us9b9lr2onor292onpjgyke0omnjbtsi9', '0');
-- Taiu
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hieqpnprm3fktwv', 'Taiu', '167@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebdb80abf52d59577d244b8019','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:167@artist.com', 'hieqpnprm3fktwv', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hieqpnprm3fktwv', 'Harnessing the power of melody to tell compelling stories.', 'Taiu');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dtg22l38rbpixqdzz23qfpzfgp9hvbtpozpfd1lp1goce5dhn6','hieqpnprm3fktwv', 'https://i.scdn.co/image/ab67616d0000b273d467bed4e6b2a01ea8569100', 'Taiu Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bo6b7g8kt56pzn3154onxg33fm4t3iihbsq80irg7skkw8aj18','Rara Vez','hieqpnprm3fktwv','POP','7MVIfkyzuUmQ716j8U7yGR',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dtg22l38rbpixqdzz23qfpzfgp9hvbtpozpfd1lp1goce5dhn6', 'bo6b7g8kt56pzn3154onxg33fm4t3iihbsq80irg7skkw8aj18', '0');
-- Sog
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fb9jaj1e9g8grdn', 'Sog', '168@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:168@artist.com', 'fb9jaj1e9g8grdn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fb9jaj1e9g8grdn', 'Breathing new life into classic genres.', 'Sog');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wtx0j2c554nbnmy5xyqnx3zzokgaph0djhlta9o9rrc8osssza','fb9jaj1e9g8grdn', NULL, 'Sog Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('he4c571b901plou2g7t8hnt444lf8df94g271pp7owsgudebh4','QUEMA','fb9jaj1e9g8grdn','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wtx0j2c554nbnmy5xyqnx3zzokgaph0djhlta9o9rrc8osssza', 'he4c571b901plou2g7t8hnt444lf8df94g271pp7owsgudebh4', '0');
-- Beyonc
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('897v311sn0gadfx', 'Beyonc', '169@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb12e3f20d05a8d6cfde988715','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:169@artist.com', '897v311sn0gadfx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('897v311sn0gadfx', 'Pioneering new paths in the musical landscape.', 'Beyonc');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('uanceifqno8mmm19057dhuxgm8l4pa9ki145x2o1n71n7zl9o2','897v311sn0gadfx', 'https://i.scdn.co/image/ab67616d0000b2730e58a0f8308c1ad403d105e7', 'Beyonc Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vkamquopy5s0de86merfczhraksxqsgwchtjg7ntr1uohhwdw1','CUFF IT','897v311sn0gadfx','POP','1xzi1Jcr7mEi9K2RfzLOqS','https://p.scdn.co/mp3-preview/1799de9ff42644af9773b6353358e54615696f19?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('uanceifqno8mmm19057dhuxgm8l4pa9ki145x2o1n71n7zl9o2', 'vkamquopy5s0de86merfczhraksxqsgwchtjg7ntr1uohhwdw1', '0');
-- Wham!
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qpjkieawnbuhs3n', 'Wham!', '170@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03e73d13341a8419eea9fcfb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:170@artist.com', 'qpjkieawnbuhs3n', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qpjkieawnbuhs3n', 'Music is my canvas, and notes are my paint.', 'Wham!');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vbyvhvunclcq0vumfoov11jtw4zawdcpn8yigb30d5fn1ll7hx','qpjkieawnbuhs3n', 'https://i.scdn.co/image/ab67616d0000b273f2d2adaa21ad616df6241e7d', 'Wham! Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hxfjetbmfsmqhexy6khk772e2vknaniqakbbvyqdnsnihgjqxw','Last Christmas','qpjkieawnbuhs3n','POP','2FRnf9qhLbvw8fu4IBXx78','https://p.scdn.co/mp3-preview/5c6b42e86dba5ec9e8346a345b3a8822b2396d3f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vbyvhvunclcq0vumfoov11jtw4zawdcpn8yigb30d5fn1ll7hx', 'hxfjetbmfsmqhexy6khk772e2vknaniqakbbvyqdnsnihgjqxw', '0');
-- Anggi Marito
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q6mgcr6mcqc6b2h', 'Anggi Marito', '171@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb604493f4d58b7d152a2d5f79','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:171@artist.com', 'q6mgcr6mcqc6b2h', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q6mgcr6mcqc6b2h', 'Redefining what it means to be an artist in the digital age.', 'Anggi Marito');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vp7n3olzwpf1m4gqwasgrh3qts4y9vyuis9rzylpncjmduh0vn','q6mgcr6mcqc6b2h', 'https://i.scdn.co/image/ab67616d0000b2732844c4e4e984ea408ab7fd6f', 'Anggi Marito Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rardux5hjulchy50mhcz6x7a2nal9dtep2k9mhl04z6ar1gnc5','Tak Segampang Itu','q6mgcr6mcqc6b2h','POP','26cvTWJq2E1QqN4jyH2OTU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vp7n3olzwpf1m4gqwasgrh3qts4y9vyuis9rzylpncjmduh0vn', 'rardux5hjulchy50mhcz6x7a2nal9dtep2k9mhl04z6ar1gnc5', '0');
-- Simone Mendes
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0p1290wskmr99mw', 'Simone Mendes', '172@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb80e5acf09546a1fa2ca12a49','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:172@artist.com', '0p1290wskmr99mw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0p1290wskmr99mw', 'A harmonious blend of passion and creativity.', 'Simone Mendes');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dajio0mubgms71zj27m2gpflhs1fz7t7n7pmgntp42t0eq0lrc','0p1290wskmr99mw', 'https://i.scdn.co/image/ab67616d0000b27379dcbcbbc872003eea5fd10f', 'Simone Mendes Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cxwl16nzerr5zr8w0ewjd7h8zgowjiumidji7j0ja5fp59chcr','Erro Gostoso - Ao Vivo','0p1290wskmr99mw','POP','4R1XAT4Ix7kad727aKh7Pj',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dajio0mubgms71zj27m2gpflhs1fz7t7n7pmgntp42t0eq0lrc', 'cxwl16nzerr5zr8w0ewjd7h8zgowjiumidji7j0ja5fp59chcr', '0');
-- XXXTENTACION
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gewz9sc95yxq0s4', 'XXXTENTACION', '173@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf0c20db5ef6c6fbe5135d2e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:173@artist.com', 'gewz9sc95yxq0s4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gewz9sc95yxq0s4', 'Blending genres for a fresh musical experience.', 'XXXTENTACION');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o19iu2aet4xc10azzgg4nmp36tbkedl03ebcdtojf53dd9fcvk','gewz9sc95yxq0s4', 'https://i.scdn.co/image/ab67616d0000b273203c89bd4391468eea4cc3f5', 'XXXTENTACION Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jzoc3mvt4vgq4linvv2oxhuz41j0vmy93eqrls2wifv3pw5vmv','Revenge','gewz9sc95yxq0s4','POP','5TXDeTFVRVY7Cvt0Dw4vWW','https://p.scdn.co/mp3-preview/8f5fe8bb510463b2da20325c8600200bf2984d83?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o19iu2aet4xc10azzgg4nmp36tbkedl03ebcdtojf53dd9fcvk', 'jzoc3mvt4vgq4linvv2oxhuz41j0vmy93eqrls2wifv3pw5vmv', '0');
-- ThxSoMch
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('impdx8odc8amxaf', 'ThxSoMch', '174@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcce84671d294b0cefb8fe1c0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:174@artist.com', 'impdx8odc8amxaf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('impdx8odc8amxaf', 'Blending genres for a fresh musical experience.', 'ThxSoMch');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hdj7ettam3xwjrmqnmql0y03vlrtevt0w45z5bl6twb0jws3n9','impdx8odc8amxaf', 'https://i.scdn.co/image/ab67616d0000b27360ddc59c8d590a37cf2348f3', 'ThxSoMch Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1t3aqau9v7sjguqbftg6s5uarl0malg21ykngvh7eqj1bx6jzx','SPIT IN MY FACE!','impdx8odc8amxaf','POP','1N8TTK1Uoy7UvQNUazfUt5','https://p.scdn.co/mp3-preview/a4146e5dd430d70eda83e57506ba5ed402935200?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hdj7ettam3xwjrmqnmql0y03vlrtevt0w45z5bl6twb0jws3n9', '1t3aqau9v7sjguqbftg6s5uarl0malg21ykngvh7eqj1bx6jzx', '0');
-- Cartel De Santa
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ue4tvwrxwfwu5ke', 'Cartel De Santa', '175@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb72d02b5f21c6364c3d1928d7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:175@artist.com', 'ue4tvwrxwfwu5ke', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ue4tvwrxwfwu5ke', 'Blending genres for a fresh musical experience.', 'Cartel De Santa');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('c0n6kjw5oqd7dpj0ewojlz0smxsomahtapxpgnc9tpj8im3842','ue4tvwrxwfwu5ke', 'https://i.scdn.co/image/ab67616d0000b273608e249e118a39e897f149ce', 'Cartel De Santa Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wlp4ikdae0r2g97bntbf9747ws6p39rh38rwu3uid0qcaagp23','Shorty Party','ue4tvwrxwfwu5ke','POP','55ZATsjPlTeSTNJOuW90pW','https://p.scdn.co/mp3-preview/861a31225cff10db2eedeb5c28bf6d0a4ecc4bc9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('c0n6kjw5oqd7dpj0ewojlz0smxsomahtapxpgnc9tpj8im3842', 'wlp4ikdae0r2g97bntbf9747ws6p39rh38rwu3uid0qcaagp23', '0');
-- Chris Molitor
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xmg8ipx714rdavk', 'Chris Molitor', '176@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03851b1c2471a8c0b57371c4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:176@artist.com', 'xmg8ipx714rdavk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xmg8ipx714rdavk', 'Delivering heartfelt music that speaks to the soul, blending folk and indie vibes.', 'Chris Molitor');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vaipb597064utskn29tei6rd527y3saxhj3lx2nktq55k7jimd','xmg8ipx714rdavk', 'https://i.scdn.co/image/ab67616d0000b273be011d16b9360a7dee109774', 'Chris Molitor Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wol9xb7bkveftqtw9gpdmk51h1qrbhgi6tv56wg7h38f7qz5di','Yellow','xmg8ipx714rdavk','POP','6tvs7zEP8d1SBgSqZQ84OT','https://p.scdn.co/mp3-preview/ea93f9b43fc638111ad661719037bfb88cd9c05d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vaipb597064utskn29tei6rd527y3saxhj3lx2nktq55k7jimd', 'wol9xb7bkveftqtw9gpdmk51h1qrbhgi6tv56wg7h38f7qz5di', '0');
-- Hozier
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uwxkfpfgfvlmdl6', 'Hozier', '177@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebad85a585103dfc2f3439119a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:177@artist.com', 'uwxkfpfgfvlmdl6', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uwxkfpfgfvlmdl6', 'Pioneering new paths in the musical landscape.', 'Hozier');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('73cr2on7zwl9sr177dle5lcczbj2w2w93gj7ixvf1i76m7739x','uwxkfpfgfvlmdl6', 'https://i.scdn.co/image/ab67616d0000b2734ca68d59a4a29c856a4a39c2', 'Hozier Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1hg01ew0fa47r0l85zj24larlu4uhrs39xwecq98vs5aa14pu6','Take Me To Church','uwxkfpfgfvlmdl6','POP','1CS7Sd1u5tWkstBhpssyjP','https://p.scdn.co/mp3-preview/d6170162e349338277c97d2fab42c386701a4089?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('73cr2on7zwl9sr177dle5lcczbj2w2w93gj7ixvf1i76m7739x', '1hg01ew0fa47r0l85zj24larlu4uhrs39xwecq98vs5aa14pu6', '0');
-- Doechii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cgq0v22ihrk0bea', 'Doechii', '178@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5f9f729e1e5182fbf1030dbe','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:178@artist.com', 'cgq0v22ihrk0bea', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cgq0v22ihrk0bea', 'Breaking barriers with her unique sound and powerful lyrical storytelling.', 'Doechii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('041f9pj00dsfb876l04k0k2u5meth6leo83ehfzx7nurjnum65','cgq0v22ihrk0bea', 'https://i.scdn.co/image/ab67616d0000b2732ee85751f6f503fa9a533eba', 'Doechii Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('w5mv28mlnqs7iqqzevasmyq65e00cldmym34hun5ri1ij75yuf','What It Is (Solo Version)','cgq0v22ihrk0bea','POP','73RbfOTJIjHzi2pcVHjeHM',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('041f9pj00dsfb876l04k0k2u5meth6leo83ehfzx7nurjnum65', 'w5mv28mlnqs7iqqzevasmyq65e00cldmym34hun5ri1ij75yuf', '0');
-- Kaliii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('frxavt9perd454l', 'Kaliii', '179@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb749bcc7f4b8d1d60f5f13744','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:179@artist.com', 'frxavt9perd454l', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('frxavt9perd454l', 'Sculpting soundwaves into masterpieces of auditory art.', 'Kaliii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('b8rey68fthl0i5e2olj9xo3owb7ax5nm5df57gk88w72u3116r','frxavt9perd454l', 'https://i.scdn.co/image/ab67616d0000b2733eecc265c134153c14794aab', 'Kaliii Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('re5y4b2n9ju2e2twudjb28n6uurt1f5pi9jczu9ohmljj2kjb0','Area Codes','frxavt9perd454l','POP','7sliFe6W30tPBPh6dvZsIH','https://p.scdn.co/mp3-preview/d1beed2734f948ec9c33164d3aa818e04f4afd30?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('b8rey68fthl0i5e2olj9xo3owb7ax5nm5df57gk88w72u3116r', 're5y4b2n9ju2e2twudjb28n6uurt1f5pi9jczu9ohmljj2kjb0', '0');
-- Jung Kook
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zj5oaipcyjnflz2', 'Jung Kook', '180@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb40a7268dd742e5f63759b960','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:180@artist.com', 'zj5oaipcyjnflz2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zj5oaipcyjnflz2', 'A member of BTS, captivating fans with his powerful vocals and dynamic performances.', 'Jung Kook');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hhluj34tj656397h6d4wbg4azxwmahj6oticq8vodixj74l8lf','zj5oaipcyjnflz2', 'https://i.scdn.co/image/ab67616d0000b273a7f42c375578df426b37638d', 'Jung Kook Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yffg6bvgrqdrpf3ka9ixyr69zxtfsbjohghvqdnx4xpq0l7g70','Still With You','zj5oaipcyjnflz2','POP','0eFMbKCRw8KByXyWBw8WO7','https://p.scdn.co/mp3-preview/af2a740e10a6956dedd7e7f66fd65d7166e9187f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hhluj34tj656397h6d4wbg4azxwmahj6oticq8vodixj74l8lf', 'yffg6bvgrqdrpf3ka9ixyr69zxtfsbjohghvqdnx4xpq0l7g70', '0');
-- Z Neto & Crist
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('48e3oi2brcj0y5e', 'Z Neto & Crist', '181@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1bb9201db3ff149830f0139a','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:181@artist.com', '48e3oi2brcj0y5e', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('48e3oi2brcj0y5e', 'Delivering soul-stirring tunes that linger in the mind.', 'Z Neto & Crist');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('011dsycryovfhrviy1hz01wxf08dq4is6mdhax1s3dqn6imqms','48e3oi2brcj0y5e', 'https://i.scdn.co/image/ab67616d0000b27339833b5940945cf013e8406c', 'Z Neto & Crist Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uu23gxueqmgpza0t96xokl7hjemog9v3j533pda3p092e7urfv','Oi Balde - Ao Vivo','48e3oi2brcj0y5e','POP','4xAGuRRKOgoaZbMGdmTD3N','https://p.scdn.co/mp3-preview/a6318531e5f8243a9d1df067570b50210b2729cc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('011dsycryovfhrviy1hz01wxf08dq4is6mdhax1s3dqn6imqms', 'uu23gxueqmgpza0t96xokl7hjemog9v3j533pda3p092e7urfv', '0');
-- Sebastian Yatra
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('udieampuv2avtsf', 'Sebastian Yatra', '182@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb650a498358171e1990efeeff','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:182@artist.com', 'udieampuv2avtsf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('udieampuv2avtsf', 'Transcending language barriers through the universal language of music.', 'Sebastian Yatra');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hgec5of0ugs9n92a2c68dshyggqdrwjwjs3ri3wr5chj2wkzyu','udieampuv2avtsf', 'https://i.scdn.co/image/ab67616d0000b2732d6016751b8ea5e66e83cd04', 'Sebastian Yatra Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hpxbm97c679iwj0nwxgghwpctswy9avsbtd74ndivibz3aggp1','VAGABUNDO','udieampuv2avtsf','POP','1MB8kTH7VKvAMfL9SHgJmG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hgec5of0ugs9n92a2c68dshyggqdrwjwjs3ri3wr5chj2wkzyu', 'hpxbm97c679iwj0nwxgghwpctswy9avsbtd74ndivibz3aggp1', '0');
-- TAEYANG
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ia7kxkshj4bk68b', 'TAEYANG', '183@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb496189630cd3cb0c7b593fee','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:183@artist.com', 'ia7kxkshj4bk68b', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ia7kxkshj4bk68b', 'A journey through the spectrum of sound in every album.', 'TAEYANG');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oysdjda7vlz5ycis3bbbuah9z174fez5h0fvdxkaxjbwdiawe8','ia7kxkshj4bk68b', 'https://i.scdn.co/image/ab67616d0000b27346313223adf2b6d726388328', 'TAEYANG Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('s9d7fbgutro5dwkcwl75oy8n80fw9kps6yx6f7ujkvk6y3lg1a','Shoong! (feat. LISA of BLACKPINK)','ia7kxkshj4bk68b','POP','5HrIcZOo1DysX53qDRlRnt',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oysdjda7vlz5ycis3bbbuah9z174fez5h0fvdxkaxjbwdiawe8', 's9d7fbgutro5dwkcwl75oy8n80fw9kps6yx6f7ujkvk6y3lg1a', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qh9z8myrgbbz24lhrmcxefqsiby9bositojufsrmcwaer5y8b4','VIBE (feat. Jimin of BTS)','ia7kxkshj4bk68b','POP','4NIe9Is7bN5JWyTeCW2ahK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oysdjda7vlz5ycis3bbbuah9z174fez5h0fvdxkaxjbwdiawe8', 'qh9z8myrgbbz24lhrmcxefqsiby9bositojufsrmcwaer5y8b4', '1');
-- JVKE
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6pj9iqej3uxw6sp', 'JVKE', '184@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebce33386a81a202e149934ec1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:184@artist.com', '6pj9iqej3uxw6sp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6pj9iqej3uxw6sp', 'A rising star, blending heartfelt lyrics with catchy pop melodies.', 'JVKE');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4o2ei9vhd7svxo2y8k3sg6bsho40dgmu61hkocgifc9dm9ib7c','6pj9iqej3uxw6sp', 'https://i.scdn.co/image/ab67616d0000b273c2504e80ba2f258697ab2954', 'JVKE Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1xzk2u7ulx04717l8w1tn76bdo1cujssppn8nqfc8ae2w2y2in','golden hour','6pj9iqej3uxw6sp','POP','5odlY52u43F5BjByhxg7wg','https://p.scdn.co/mp3-preview/bcc17f30841d6fbf3cd7954c3e3cf669f11b6a21?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4o2ei9vhd7svxo2y8k3sg6bsho40dgmu61hkocgifc9dm9ib7c', '1xzk2u7ulx04717l8w1tn76bdo1cujssppn8nqfc8ae2w2y2in', '0');
-- Chris Brown
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('er1gmdtzn2sqrdx', 'Chris Brown', '185@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba48397e590a1c70e2cda7728','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:185@artist.com', 'er1gmdtzn2sqrdx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('er1gmdtzn2sqrdx', 'A visionary in the world of music, redefining genres.', 'Chris Brown');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('aats922y21tdfehyulhg17ggzf2u6qv1wztg6742eflfe3agtb','er1gmdtzn2sqrdx', 'https://i.scdn.co/image/ab67616d0000b2739a494f7d8909a6cc4ceb74ac', 'Chris Brown Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('mxxs9f97cqk7fhars8kyrzcyx5xb0jwqwee87ynbbmddxruxdj','Under The Influence','er1gmdtzn2sqrdx','POP','5IgjP7X4th6nMNDh4akUHb','https://p.scdn.co/mp3-preview/52295df71df20e33e1510e3983975cd59f6664a4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('aats922y21tdfehyulhg17ggzf2u6qv1wztg6742eflfe3agtb', 'mxxs9f97cqk7fhars8kyrzcyx5xb0jwqwee87ynbbmddxruxdj', '0');
-- Abhijay Sharma
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('owvpbjjee2turgt', 'Abhijay Sharma', '186@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf58e0bff09fc766a22cd3bdb','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:186@artist.com', 'owvpbjjee2turgt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('owvpbjjee2turgt', 'A confluence of cultural beats and contemporary tunes.', 'Abhijay Sharma');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wj1dwhc3pq9ryjp4s1wcwzpemk9s6iqo8goxplv79i8r4j2bms','owvpbjjee2turgt', NULL, 'Abhijay Sharma Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4sqa3dl50vcv3zdum4q1ev4kea5skt4t2n1519b9jspulu9osv','Obsessed','owvpbjjee2turgt','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wj1dwhc3pq9ryjp4s1wcwzpemk9s6iqo8goxplv79i8r4j2bms', '4sqa3dl50vcv3zdum4q1ev4kea5skt4t2n1519b9jspulu9osv', '0');
-- Lil Uzi Vert
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fxfo23x0cv5e8oj', 'Lil Uzi Vert', '187@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1234d2f516796badbdf16a89','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:187@artist.com', 'fxfo23x0cv5e8oj', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('fxfo23x0cv5e8oj', 'Weaving lyrical magic into every song.', 'Lil Uzi Vert');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l07ptve28b4w9010j3d17x76e1acmeynm2k9ruwnwu2t4iflc5','fxfo23x0cv5e8oj', 'https://i.scdn.co/image/ab67616d0000b273438799bc344744c12028bb0f', 'Lil Uzi Vert Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xq5wwa3aktll156lnrh6q8h9fvokluw5n9g4f4up731x4r4ryt','Just Wanna Rock','fxfo23x0cv5e8oj','POP','4FyesJzVpA39hbYvcseO2d','https://p.scdn.co/mp3-preview/72dce26448e87be36c3776ded36b75a9fd01359e?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l07ptve28b4w9010j3d17x76e1acmeynm2k9ruwnwu2t4iflc5', 'xq5wwa3aktll156lnrh6q8h9fvokluw5n9g4f4up731x4r4ryt', '0');
-- Halsey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jspk5jk8bh6unhi', 'Halsey', '188@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd707e1c5177614c4ec95a06c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:188@artist.com', 'jspk5jk8bh6unhi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jspk5jk8bh6unhi', 'An alchemist of harmonies, transforming notes into gold.', 'Halsey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('unkdta3h6ya741o4dqz2rf8kad61nptgrtv29ajbcpm0nnlf62','jspk5jk8bh6unhi', 'https://i.scdn.co/image/ab67616d0000b273f19310c007c0fad365b0542e', 'Halsey Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ntb40a60o9yy8ckxyvr8htw3s5lba0la99oyxvd1n9eq58roy2','Lilith (feat. SUGA of BTS) (Diablo IV Anthem)','jspk5jk8bh6unhi','POP','3l6LBCOL9nPsSY29TUY2VE',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('unkdta3h6ya741o4dqz2rf8kad61nptgrtv29ajbcpm0nnlf62', 'ntb40a60o9yy8ckxyvr8htw3s5lba0la99oyxvd1n9eq58roy2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k5y29k7ho1kkerpzucjlund1jexjzbm0v1uqthgqjq3ilskh5f','Boy With Luv (feat. Halsey)','jspk5jk8bh6unhi','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('unkdta3h6ya741o4dqz2rf8kad61nptgrtv29ajbcpm0nnlf62', 'k5y29k7ho1kkerpzucjlund1jexjzbm0v1uqthgqjq3ilskh5f', '1');
-- Mac DeMarco
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xcj8k242g0v6e7y', 'Mac DeMarco', '189@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3cef7752073cbbd2cc04c6f0','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:189@artist.com', 'xcj8k242g0v6e7y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xcj8k242g0v6e7y', 'Harnessing the power of melody to tell compelling stories.', 'Mac DeMarco');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6tpobesvszek1k5jcbj1urnp8dhdrd4gvq40c5ccbr3ob7nvh3','xcj8k242g0v6e7y', 'https://i.scdn.co/image/ab67616d0000b273fa1323bb50728c7489980672', 'Mac DeMarco Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nhrhegnrrq3jmw63ultlz5cyjlbuuspqza5crs0c6k3y1n72kw','Heart To Heart','xcj8k242g0v6e7y','POP','7EAMXbLcL0qXmciM5SwMh2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6tpobesvszek1k5jcbj1urnp8dhdrd4gvq40c5ccbr3ob7nvh3', 'nhrhegnrrq3jmw63ultlz5cyjlbuuspqza5crs0c6k3y1n72kw', '0');
-- TV Girl
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xyny768xjf2fbk4', 'TV Girl', '190@artist.com', 'https://i.scdn.co/image/ab67616d0000b27332f5fec7a879ed6ef28f0dfd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:190@artist.com', 'xyny768xjf2fbk4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xyny768xjf2fbk4', 'A unique voice in the contemporary music scene.', 'TV Girl');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nw4rhl69gq7ovweiy8hvh4f4tpnrun6nsdmjusi2cc4re64sso','xyny768xjf2fbk4', 'https://i.scdn.co/image/ab67616d0000b273e1bc1af856b42dd7fdba9f84', 'TV Girl Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('25pwtqoho0p63qllubczskp1ap1zbgj865fr2raef40ulf01h6','Lovers Rock','xyny768xjf2fbk4','POP','6dBUzqjtbnIa1TwYbyw5CM','https://p.scdn.co/mp3-preview/922a42db5aa8f8d335725697b7d7a12af6808f3a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nw4rhl69gq7ovweiy8hvh4f4tpnrun6nsdmjusi2cc4re64sso', '25pwtqoho0p63qllubczskp1ap1zbgj865fr2raef40ulf01h6', '0');
-- Bruno Mars
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('n5ih7fzofvq02r9', 'Bruno Mars', '191@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc36dd9eb55fb0db4911f25dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:191@artist.com', 'n5ih7fzofvq02r9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('n5ih7fzofvq02r9', 'Crafting melodies that resonate with the soul.', 'Bruno Mars');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('l9puqsqpprkp7vsysca1bquw5anzjkal2bs9p60pfre6x6r6a7','n5ih7fzofvq02r9', 'https://i.scdn.co/image/ab67616d0000b273926f43e7cce571e62720fd46', 'Bruno Mars Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ap21m3xvy2kfmmvfppwgg8ydah2r8sxfql8cb7trb85g5fhmur','Locked Out Of Heaven','n5ih7fzofvq02r9','POP','3w3y8KPTfNeOKPiqUTakBh','https://p.scdn.co/mp3-preview/5a0318e6c43964786d22b9431af35490e96cff3d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l9puqsqpprkp7vsysca1bquw5anzjkal2bs9p60pfre6x6r6a7', 'ap21m3xvy2kfmmvfppwgg8ydah2r8sxfql8cb7trb85g5fhmur', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vs3vplyoka4h1dtl3em0v0lmoon4h4tvkt5l4jivzrj1nuuy7k','When I Was Your Man','n5ih7fzofvq02r9','POP','0nJW01T7XtvILxQgC5J7Wh','https://p.scdn.co/mp3-preview/159fc05584217baa99581c4821f52d04670db6b2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l9puqsqpprkp7vsysca1bquw5anzjkal2bs9p60pfre6x6r6a7', 'vs3vplyoka4h1dtl3em0v0lmoon4h4tvkt5l4jivzrj1nuuy7k', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('svriyn1y4dlkdn2ednx32g0lh5ixf6qun8krf6yi4fbyszblpg','Just The Way You Are','n5ih7fzofvq02r9','POP','7BqBn9nzAq8spo5e7cZ0dJ','https://p.scdn.co/mp3-preview/6d1a901b10c7dc609d4c8628006b04bc6e672be8?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('l9puqsqpprkp7vsysca1bquw5anzjkal2bs9p60pfre6x6r6a7', 'svriyn1y4dlkdn2ednx32g0lh5ixf6qun8krf6yi4fbyszblpg', '2');
-- Coldplay
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('b15nw54hyjd98fi', 'Coldplay', '192@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb989ed05e1f0570cc4726c2d3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:192@artist.com', 'b15nw54hyjd98fi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('b15nw54hyjd98fi', 'Global icons in rock, known for their anthemic songs and impactful lyrics.', 'Coldplay');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zicjokekkjektbz7n5iag4d1g80y6ka6ixkv8q9jomfd5vbulk','b15nw54hyjd98fi', 'https://i.scdn.co/image/ab67616d0000b273e21cc1db05580b6f2d2a3b6e', 'Coldplay Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ucmzhvkyxeu51b9qdso3sxwugcv6csyys1f76otb7dl7dbsgqw','Viva La Vida','b15nw54hyjd98fi','POP','1mea3bSkSGXuIRvnydlB5b','https://p.scdn.co/mp3-preview/fb9f4a9b0887326776b4fb7c6d331acd167a7778?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zicjokekkjektbz7n5iag4d1g80y6ka6ixkv8q9jomfd5vbulk', 'ucmzhvkyxeu51b9qdso3sxwugcv6csyys1f76otb7dl7dbsgqw', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('b0b3gglgnisj629rp4ip6s2qqsdnflybweq2t1u6nvqwju1yrs','My Universe','b15nw54hyjd98fi','POP','3FeVmId7tL5YN8B7R3imoM','https://p.scdn.co/mp3-preview/e6b780d0df7927114477a786b6a638cf40d19579?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zicjokekkjektbz7n5iag4d1g80y6ka6ixkv8q9jomfd5vbulk', 'b0b3gglgnisj629rp4ip6s2qqsdnflybweq2t1u6nvqwju1yrs', '1');
-- Mc Pedrinho
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qv9ndph7n8d8gp4', 'Mc Pedrinho', '193@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba19ab278a7a01b077bb17e75','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:193@artist.com', 'qv9ndph7n8d8gp4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qv9ndph7n8d8gp4', 'A journey through the spectrum of sound in every album.', 'Mc Pedrinho');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('o9rc6xnomq5eeod8lupsrbvmppvyhf5wn1rsn97f4i4bum7ill','qv9ndph7n8d8gp4', 'https://i.scdn.co/image/ab67616d0000b27319d60821e80a801506061776', 'Mc Pedrinho Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3icr4rdgqgdp6gmez0nzci3m3ekaw3pnvh37vf82287s9ksjuc','Gol Bolinha, Gol Quadrado 2','qv9ndph7n8d8gp4','POP','0U9CZWq6umZsN432nh3WWT','https://p.scdn.co/mp3-preview/385a48d0a130895b2b0ec2f731cc744207d0a745?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('o9rc6xnomq5eeod8lupsrbvmppvyhf5wn1rsn97f4i4bum7ill', '3icr4rdgqgdp6gmez0nzci3m3ekaw3pnvh37vf82287s9ksjuc', '0');
-- Lana Del Rey
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cvl5p0lckdkmmrk', 'Lana Del Rey', '194@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb99cacf8acd5378206767261','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:194@artist.com', 'cvl5p0lckdkmmrk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cvl5p0lckdkmmrk', 'An ethereal presence in music, known for her cinematic and nostalgic sound.', 'Lana Del Rey');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('wtag6hkaha0l784u3o0czgbbp5k46te4j86reidgeej5123jti','cvl5p0lckdkmmrk', 'https://i.scdn.co/image/ab67616d0000b273aa27708d07f49c82ff0d0dae', 'Lana Del Rey Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ikbzd4rpn0z74d9678eeqredsldjbyxnnerx8pfcgxtspeaj2x','Say Yes To Heaven','cvl5p0lckdkmmrk','POP','6GGtHZgBycCgGBUhZo81xe',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wtag6hkaha0l784u3o0czgbbp5k46te4j86reidgeej5123jti', 'ikbzd4rpn0z74d9678eeqredsldjbyxnnerx8pfcgxtspeaj2x', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x7hptos0fn1x5ljwxf01ybmplf1q7fb20sjgobooogrymyy48u','Summertime Sadness','cvl5p0lckdkmmrk','POP','1Ist6PR2BZR3n2z2Y5R6S1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wtag6hkaha0l784u3o0czgbbp5k46te4j86reidgeej5123jti', 'x7hptos0fn1x5ljwxf01ybmplf1q7fb20sjgobooogrymyy48u', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6tj8lqggjeck8vunas2zcuh11ng7yq6fl8x2briqx3m37464ln','Radio','cvl5p0lckdkmmrk','POP','3QhfFRPkhPCR1RMJWV1gde',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wtag6hkaha0l784u3o0czgbbp5k46te4j86reidgeej5123jti', '6tj8lqggjeck8vunas2zcuh11ng7yq6fl8x2briqx3m37464ln', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jzdeve7kuxnk2w56x7uth0hyx6za0dir5unqseqp6o0xllzszj','Snow On The Beach (feat. More Lana Del Rey)','cvl5p0lckdkmmrk','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('wtag6hkaha0l784u3o0czgbbp5k46te4j86reidgeej5123jti', 'jzdeve7kuxnk2w56x7uth0hyx6za0dir5unqseqp6o0xllzszj', '3');
-- Lizzy McAlpine
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6ss7ir4lh5x2hff', 'Lizzy McAlpine', '195@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb10e2b618880f429a3967185','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:195@artist.com', '6ss7ir4lh5x2hff', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6ss7ir4lh5x2hff', 'The architect of aural landscapes that inspire and captivate.', 'Lizzy McAlpine');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qy5xsbicnnf5p1ayqak4g9oadf4ga9k9t0ib2je5eedgdr8rc5','6ss7ir4lh5x2hff', 'https://i.scdn.co/image/ab67616d0000b273d370fdc4dbc47778b9b667c3', 'Lizzy McAlpine Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('29nc08a6wbhjn96ilxrqe0tb1dxpbgijqsw2aq4eyk011ddx9o','ceilings','6ss7ir4lh5x2hff','POP','2L9N0zZnd37dwF0clgxMGI','https://p.scdn.co/mp3-preview/580782ffb17d468fe5d000bdf86cc07926ff9a5a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qy5xsbicnnf5p1ayqak4g9oadf4ga9k9t0ib2je5eedgdr8rc5', '29nc08a6wbhjn96ilxrqe0tb1dxpbgijqsw2aq4eyk011ddx9o', '0');
-- Fuerza Regida
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('16tpa81cfog8935', 'Fuerza Regida', '196@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1b85fbf9507041aab224336d','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:196@artist.com', '16tpa81cfog8935', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('16tpa81cfog8935', 'Revitalizing the regional music scene with their unique sound and powerful lyrics.', 'Fuerza Regida');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hx7ijap73nhs1co8ll2c1rkuviqpgz2mlyjwipdjsfcwf9mdlr','16tpa81cfog8935', 'https://i.scdn.co/image/ab67616d0000b273cfe3eb72c48b93971e53efd9', 'Fuerza Regida Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vyime8h1d3h9b5njzilxpaocd20l93a0hg82mboc7m7ad95suo','SABOR FRESA','16tpa81cfog8935','POP','1UMm1Qs3u59Wvk53zBUE8r','https://p.scdn.co/mp3-preview/590ae0b69465339d97ef5db9f7e36fe0c452fbb4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hx7ijap73nhs1co8ll2c1rkuviqpgz2mlyjwipdjsfcwf9mdlr', 'vyime8h1d3h9b5njzilxpaocd20l93a0hg82mboc7m7ad95suo', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('igdi8nhux80kcw41wmtagrmpq9xydh7pax2zy4bp0rvb6li9id','TQM','16tpa81cfog8935','POP','368eeEO3Y2uZUQ6S5oIjcu','https://p.scdn.co/mp3-preview/63f6b66cfcc3d7bd396dcbe18d6e3dee05fdb956?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hx7ijap73nhs1co8ll2c1rkuviqpgz2mlyjwipdjsfcwf9mdlr', 'igdi8nhux80kcw41wmtagrmpq9xydh7pax2zy4bp0rvb6li9id', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('184zh8gjkxju4kbyn5kouqn633ihr8evlge3px3ivy99ndd2ze','Bebe Dame','16tpa81cfog8935','POP','0IKeDy5bT9G0bA7ZixRT4A','https://p.scdn.co/mp3-preview/408ffb4fffcd26cda82f2b3cda7726ea1f6ebd74?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hx7ijap73nhs1co8ll2c1rkuviqpgz2mlyjwipdjsfcwf9mdlr', '184zh8gjkxju4kbyn5kouqn633ihr8evlge3px3ivy99ndd2ze', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i2du040lkxxcz4vbwau6a0b83c15tnwswmi0if9msxggj5jmev','Ch y la Pizza','16tpa81cfog8935','POP','0UbesRsX2TtiCeamOIVEkp','https://p.scdn.co/mp3-preview/212acba217ff0304f6cbb41eb8f43cd27d991c7b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hx7ijap73nhs1co8ll2c1rkuviqpgz2mlyjwipdjsfcwf9mdlr', 'i2du040lkxxcz4vbwau6a0b83c15tnwswmi0if9msxggj5jmev', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1fuk8vyvxbqty5lkfwmxt0fx1tyksegcn0jwpln18sgdkse4v9','Igualito a Mi Ap','16tpa81cfog8935','POP','17js0w8GTkTUFGFM6PYvBd','https://p.scdn.co/mp3-preview/f0f87682468e9baa92562cd4d797ce8af5337ca6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hx7ijap73nhs1co8ll2c1rkuviqpgz2mlyjwipdjsfcwf9mdlr', '1fuk8vyvxbqty5lkfwmxt0fx1tyksegcn0jwpln18sgdkse4v9', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fns7vvgnuo6vstoo69gdsi7u8fxel6cm5af5ixxkw453r4thcd','Dijeron Que No La Iba Lograr','16tpa81cfog8935','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hx7ijap73nhs1co8ll2c1rkuviqpgz2mlyjwipdjsfcwf9mdlr', 'fns7vvgnuo6vstoo69gdsi7u8fxel6cm5af5ixxkw453r4thcd', '5');
-- Tyler
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m38z0ibhjtwgbdz', 'Tyler', '197@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8278b782cbb5a3963db88ada','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:197@artist.com', 'm38z0ibhjtwgbdz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m38z0ibhjtwgbdz', 'An odyssey of sound that defies conventions.', 'Tyler');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kzxej172md65w9n26d9s7kndeej185mcq377it1p7jy6i95ctl','m38z0ibhjtwgbdz', 'https://i.scdn.co/image/ab67616d0000b273aa95a399fd30fbb4f6f59fca', 'Tyler Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3yqtzqbtt205h9i5xto1ydp65qwajjqycde8wu3gjur0ckqonj','DOGTOOTH','m38z0ibhjtwgbdz','POP','6OfOzTitafSnsaunQLuNFw','https://p.scdn.co/mp3-preview/5de4c8c30108bc114f9f38a28ac0832936a852bf?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kzxej172md65w9n26d9s7kndeej185mcq377it1p7jy6i95ctl', '3yqtzqbtt205h9i5xto1ydp65qwajjqycde8wu3gjur0ckqonj', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jaxv3cy5tbdbdkb5a1y4p8lslvh6ng5nbk3jq6pry1orb3f2ng','SORRY NOT SORRY','m38z0ibhjtwgbdz','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kzxej172md65w9n26d9s7kndeej185mcq377it1p7jy6i95ctl', 'jaxv3cy5tbdbdkb5a1y4p8lslvh6ng5nbk3jq6pry1orb3f2ng', '1');
-- PinkPantheress
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2wvfkyahlxej8yi', 'PinkPantheress', '198@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb03578c92e15089c645b794f5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:198@artist.com', '2wvfkyahlxej8yi', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2wvfkyahlxej8yi', 'Redefining pop music with her distinct sound and style.', 'PinkPantheress');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('325ngq75hbv09ajt4dr2sbu090gyjszz51jepnxq1i74xgsgay','2wvfkyahlxej8yi', 'https://i.scdn.co/image/ab67616d0000b2739567e1aa41657425d046733b', 'PinkPantheress Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jz4ndce6ol2d767vvniuk3gurfzawncep9sdmtbvp8ctefzexg','Boys a liar Pt. 2','2wvfkyahlxej8yi','POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('325ngq75hbv09ajt4dr2sbu090gyjszz51jepnxq1i74xgsgay', 'jz4ndce6ol2d767vvniuk3gurfzawncep9sdmtbvp8ctefzexg', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5qa7s16wr48m07brflaog5nlo1z4f1uk3dir08ok13fuf8sni0','Boys a liar','2wvfkyahlxej8yi','POP','6AQbmUe0Qwf5PZnt4HmTXv','https://p.scdn.co/mp3-preview/543d8d09a5530a1ab94dd0c6f83fc4ee3e0d7f96?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('325ngq75hbv09ajt4dr2sbu090gyjszz51jepnxq1i74xgsgay', '5qa7s16wr48m07brflaog5nlo1z4f1uk3dir08ok13fuf8sni0', '1');
-- Treyce
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('blxdj4vu4ovcyhs', 'Treyce', '199@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7b48fa6e2c8280e205c5ea7b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:199@artist.com', 'blxdj4vu4ovcyhs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('blxdj4vu4ovcyhs', 'Sculpting soundwaves into masterpieces of auditory art.', 'Treyce');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ms23trqhb6xudz609rksuc34atryl7ncjfkwmktw4jfdx11gxx','blxdj4vu4ovcyhs', NULL, 'Treyce Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('34loa7g72cfbrwe1bidwyoulc5yd10kijsxyoomkebr43dkp57','Lovezinho','blxdj4vu4ovcyhs','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ms23trqhb6xudz609rksuc34atryl7ncjfkwmktw4jfdx11gxx', '34loa7g72cfbrwe1bidwyoulc5yd10kijsxyoomkebr43dkp57', '0');
-- Baby Tate
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dx4rj57vhl52dvf', 'Baby Tate', '200@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe7b0d119183e74ec390d7aec','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:200@artist.com', 'dx4rj57vhl52dvf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dx4rj57vhl52dvf', 'A visionary in the world of music, redefining genres.', 'Baby Tate');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0tcr7cj1ne85rkepufiwvw9xyooqcwmk3r84rc252abd7s96cr','dx4rj57vhl52dvf', 'https://i.scdn.co/image/ab67616d0000b2732571034f34b381958f8cc727', 'Baby Tate Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('e1yr4eb77jpfe5l93ezdekmqelv4p7fo306883f7op1dwzpk4r','Hey, Mickey!','dx4rj57vhl52dvf','POP','3RKjTYlQrtLXCq5ncswBPp','https://p.scdn.co/mp3-preview/2bfe39402bec233fbb5b2c06ffedbbf4d6fbc38a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0tcr7cj1ne85rkepufiwvw9xyooqcwmk3r84rc252abd7s96cr', 'e1yr4eb77jpfe5l93ezdekmqelv4p7fo306883f7op1dwzpk4r', '0');
-- Sam Smith
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('y4osizt22h16cx4', 'Sam Smith', '201@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd0aa135d864bdcf4eb112112','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:201@artist.com', 'y4osizt22h16cx4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('y4osizt22h16cx4', 'A soulful voice delivering deep emotional resonance.', 'Sam Smith');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0wbycvm07hqe4rczhya6j9ut1k73pgfdtkcq019ab2g49dkw80','y4osizt22h16cx4', 'https://i.scdn.co/image/ab67616d0000b273a935e4689f15953311772cc4', 'Sam Smith Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x571y56p1zd1z7z7kh3s0t5j5amh1q4vzxsjy6if8oo5f79zir','Unholy (feat. Kim Petras)','y4osizt22h16cx4','POP','3nqQXoyQOWXiESFLlDF1hG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0wbycvm07hqe4rczhya6j9ut1k73pgfdtkcq019ab2g49dkw80', 'x571y56p1zd1z7z7kh3s0t5j5amh1q4vzxsjy6if8oo5f79zir', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6y2asiirvgorlfm8xeyodmvsgjgsp34vn8isfkrs0qo0fy5lvw','Im Not Here To Make Friends','y4osizt22h16cx4','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0wbycvm07hqe4rczhya6j9ut1k73pgfdtkcq019ab2g49dkw80', '6y2asiirvgorlfm8xeyodmvsgjgsp34vn8isfkrs0qo0fy5lvw', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gly8n09c7g5eqsygn8pxlhghw9wknu05lr90t1297pizaon0ao','Im Not The Only One','y4osizt22h16cx4','POP','5RYtz3cpYb28SV8f1FBtGc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0wbycvm07hqe4rczhya6j9ut1k73pgfdtkcq019ab2g49dkw80', 'gly8n09c7g5eqsygn8pxlhghw9wknu05lr90t1297pizaon0ao', '2');
-- Olivia Rodrigo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q0k3tbqfqcmhans', 'Olivia Rodrigo', '202@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe03a98785f3658f0b6461ec4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:202@artist.com', 'q0k3tbqfqcmhans', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q0k3tbqfqcmhans', 'A new voice in pop, channeling raw emotions into her songs.', 'Olivia Rodrigo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('3siva7ql2qzgdfz4zfjsunodaodni2uxxyslq6pd8wdq3cpoir','q0k3tbqfqcmhans', 'https://i.scdn.co/image/ab67616d0000b273e85259a1cae29a8d91f2093d', 'Olivia Rodrigo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t37flcy10wqn28bwds547g6apcxo2ozqvuohvet50jcdg3gs71','vampire','q0k3tbqfqcmhans','POP','1kuGVB7EU95pJObxwvfwKS',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('3siva7ql2qzgdfz4zfjsunodaodni2uxxyslq6pd8wdq3cpoir', 't37flcy10wqn28bwds547g6apcxo2ozqvuohvet50jcdg3gs71', '0');
-- The Walters
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uvsbnxlyyl9mtuy', 'The Walters', '203@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6c4366f40ea49c1318707f97','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:203@artist.com', 'uvsbnxlyyl9mtuy', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uvsbnxlyyl9mtuy', 'Transcending language barriers through the universal language of music.', 'The Walters');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('5ujgx0my74lgva2z1vspjiaaivyurxkkeerphhrcqlkbdrv79e','uvsbnxlyyl9mtuy', 'https://i.scdn.co/image/ab67616d0000b2739214ff0109a0e062f8a6cf0f', 'The Walters Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rs63z6t5mbcavvueykkvdp2ukup7hh8y9bdl3z3v7h2xv1ydzt','I Love You So','uvsbnxlyyl9mtuy','POP','4SqWKzw0CbA05TGszDgMlc','https://p.scdn.co/mp3-preview/83919b3d62a4ae352229c0a779e8aa0c1b2f4f40?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('5ujgx0my74lgva2z1vspjiaaivyurxkkeerphhrcqlkbdrv79e', 'rs63z6t5mbcavvueykkvdp2ukup7hh8y9bdl3z3v7h2xv1ydzt', '0');
-- Bebe Rexha
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('c245pndj25xm59o', 'Bebe Rexha', '204@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41c4dd328bbea2f0a19c7522','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:204@artist.com', 'c245pndj25xm59o', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('c245pndj25xm59o', 'A dynamic voice in pop music, known for her powerful vocals and catchy tunes.', 'Bebe Rexha');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('tcyeni9yd3mtygnc71qyjn9hf8kamyj0maj4okhakrkswzc1zh','c245pndj25xm59o', NULL, 'Bebe Rexha Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4ymnd80tds4tuqlkw374acujm1iu1y6v7axk96iwwpd71zwo4h','Im Good (Blue)','c245pndj25xm59o','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('tcyeni9yd3mtygnc71qyjn9hf8kamyj0maj4okhakrkswzc1zh', '4ymnd80tds4tuqlkw374acujm1iu1y6v7axk96iwwpd71zwo4h', '0');
-- Ed Sheeran
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('h5vxlmhewb5ol32', 'Ed Sheeran', '205@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3bcef85e105dfc42399ef0ba','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:205@artist.com', 'h5vxlmhewb5ol32', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('h5vxlmhewb5ol32', 'The heartbeat of a new generation of music lovers.', 'Ed Sheeran');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('j891xq0xi9zn0ju438klk0y839olr5hxg7tlqkqmu9v0q7ar0e','h5vxlmhewb5ol32', 'https://i.scdn.co/image/ab67616d0000b273ba5db46f4b838ef6027e6f96', 'Ed Sheeran Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6r2fi1tvlc2fihlxvasf476fb3u70px1ietu23bjskxaov0q4b','Perfect','h5vxlmhewb5ol32','POP','0tgVpDi06FyKpA1z0VMD4v','https://p.scdn.co/mp3-preview/4e30857a3c7da3f8891483643e310bb233afadd2?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j891xq0xi9zn0ju438klk0y839olr5hxg7tlqkqmu9v0q7ar0e', '6r2fi1tvlc2fihlxvasf476fb3u70px1ietu23bjskxaov0q4b', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('4q2cq4km9mtsy7jxqq6u29tb1tf7v3cu6b0dd7s9gfs9nzngok','Shape of You','h5vxlmhewb5ol32','POP','7qiZfU4dY1lWllzX7mPBI3','https://p.scdn.co/mp3-preview/7339548839a263fd721d01eb3364a848cad16fa7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j891xq0xi9zn0ju438klk0y839olr5hxg7tlqkqmu9v0q7ar0e', '4q2cq4km9mtsy7jxqq6u29tb1tf7v3cu6b0dd7s9gfs9nzngok', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('hq8pwj9b50a7y60s149scr4ar4mytxmafpxdlzdb7jhvxl0nbg','Eyes Closed','h5vxlmhewb5ol32','POP','3p7XQpdt8Dr6oMXSvRZ9bg','https://p.scdn.co/mp3-preview/7cd2576f2d27799fe8c515c4e0fc880870a5cc88?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j891xq0xi9zn0ju438klk0y839olr5hxg7tlqkqmu9v0q7ar0e', 'hq8pwj9b50a7y60s149scr4ar4mytxmafpxdlzdb7jhvxl0nbg', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('nitz8cpwvil579ckstmyqikz3kzmee7zsm5cin38v09m815t3p','Curtains','h5vxlmhewb5ol32','POP','6ZZf5a8oiInHDkBe9zXfLP','https://p.scdn.co/mp3-preview/5a519e5823df4fe468c8a45a7104a632553e09a5?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j891xq0xi9zn0ju438klk0y839olr5hxg7tlqkqmu9v0q7ar0e', 'nitz8cpwvil579ckstmyqikz3kzmee7zsm5cin38v09m815t3p', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('di910tvgda0gmcs3c5moqdalnuix9ty4gqb2d1641fzmzoh5ns','Shivers','h5vxlmhewb5ol32','POP','50nfwKoDiSYg8zOCREWAm5','https://p.scdn.co/mp3-preview/08cec59d36ac30ae9ce1e2944f206251859844af?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j891xq0xi9zn0ju438klk0y839olr5hxg7tlqkqmu9v0q7ar0e', 'di910tvgda0gmcs3c5moqdalnuix9ty4gqb2d1641fzmzoh5ns', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('37rfw6th3gdavh1mve4sre7inkaw2ly78cmkdg222a1rwikda1','Bad Habits','h5vxlmhewb5ol32','POP','3rmo8F54jFF8OgYsqTxm5d','https://p.scdn.co/mp3-preview/22f3a86c8a83e364db595007f9ac1d666596a335?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('j891xq0xi9zn0ju438klk0y839olr5hxg7tlqkqmu9v0q7ar0e', '37rfw6th3gdavh1mve4sre7inkaw2ly78cmkdg222a1rwikda1', '5');
-- Tom Odell
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m84f3ibrbyf5oha', 'Tom Odell', '206@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb532e8dd8ba9fbd5e78105a78','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:206@artist.com', 'm84f3ibrbyf5oha', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m84f3ibrbyf5oha', 'Stirring emotions with piano-driven melodies and poetic lyrics.', 'Tom Odell');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ol127em1okmdqokkof8u5vk1btr0mwvgqk14lc2yocylhr2chw','m84f3ibrbyf5oha', 'https://i.scdn.co/image/ab67616d0000b2731917a0f3f4152622a040913f', 'Tom Odell Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('gle9ito4ixoqxlty8dv4tmjrd976khwoyx6e2291du2mg2x2sf','Another Love','m84f3ibrbyf5oha','POP','3JvKfv6T31zO0ini8iNItO','https://p.scdn.co/mp3-preview/0369cb748bc968ffd34fb4ac60f5403f2aad032f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ol127em1okmdqokkof8u5vk1btr0mwvgqk14lc2yocylhr2chw', 'gle9ito4ixoqxlty8dv4tmjrd976khwoyx6e2291du2mg2x2sf', '0');
-- Ariana Grande
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('upz8g3g33bi9knx', 'Ariana Grande', '207@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb456c82553e0efcb7e13365b1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:207@artist.com', 'upz8g3g33bi9knx', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('upz8g3g33bi9knx', 'A powerhouse vocalist, dominating pop with her range and iconic style.', 'Ariana Grande');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('gqtjs6wbkgbxtr8pnyow0zv58u5ghf09zhl9swasw4bfb27mnf','upz8g3g33bi9knx', NULL, 'Ariana Grande Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0947vd9etovbu63m0oc10p5mbh04xpatwzuwvcwiqse8chpdlv','Die For You - Remix','upz8g3g33bi9knx','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gqtjs6wbkgbxtr8pnyow0zv58u5ghf09zhl9swasw4bfb27mnf', '0947vd9etovbu63m0oc10p5mbh04xpatwzuwvcwiqse8chpdlv', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i1igdcvjfqvsvx7c4lewcuox3xu8c8eyrnqhxnqpd1y2vorb91','Save Your Tears (with Ariana Grande) (Remix)','upz8g3g33bi9knx','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gqtjs6wbkgbxtr8pnyow0zv58u5ghf09zhl9swasw4bfb27mnf', 'i1igdcvjfqvsvx7c4lewcuox3xu8c8eyrnqhxnqpd1y2vorb91', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ivoek61cknbd3v2bhpoztps1e46aa694ida27tw5yeqr1e4wgu','Santa Tell Me','upz8g3g33bi9knx','POP','0lizgQ7Qw35od7CYaoMBZb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('gqtjs6wbkgbxtr8pnyow0zv58u5ghf09zhl9swasw4bfb27mnf', 'ivoek61cknbd3v2bhpoztps1e46aa694ida27tw5yeqr1e4wgu', '2');
-- Kordhell
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ag15pshzq08to36', 'Kordhell', '208@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb15862815bf4d2446b8ecf55f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:208@artist.com', 'ag15pshzq08to36', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ag15pshzq08to36', 'Creating a tapestry of tunes that celebrates diversity.', 'Kordhell');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0t7eet6pug30bfp8s7ktszqhrrkejx4odxbm803r1om3qbygov','ag15pshzq08to36', 'https://i.scdn.co/image/ab67616d0000b2731440ffaa43c53d65719e0150', 'Kordhell Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v912nr7nwpq8rk42y3367z5zi5nkdozqzr407bdv2mjzhuvzgf','Murder In My Mind','ag15pshzq08to36','POP','6qyS9qBy0mEk3qYaH8mPss','https://p.scdn.co/mp3-preview/ec3b94db31d9fb9821cfea0f7a4cdc9d2a85e969?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0t7eet6pug30bfp8s7ktszqhrrkejx4odxbm803r1om3qbygov', 'v912nr7nwpq8rk42y3367z5zi5nkdozqzr407bdv2mjzhuvzgf', '0');
-- Tisto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lwb944oboh8cinc', 'Tisto', '209@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7afd1dcf8bc34612f16ee39c','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:209@artist.com', 'lwb944oboh8cinc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lwb944oboh8cinc', 'An endless quest for musical perfection.', 'Tisto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('znmbzg7al65cfw3vtuh9op8v5ky1q41lwaah9poba6yp3yj9n6','lwb944oboh8cinc', NULL, 'Tisto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x9h6k5nl6awwb6aqfxgzhn4abhw9er9zivmywngh3ihnhaqora','10:35','lwb944oboh8cinc','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('znmbzg7al65cfw3vtuh9op8v5ky1q41lwaah9poba6yp3yj9n6', 'x9h6k5nl6awwb6aqfxgzhn4abhw9er9zivmywngh3ihnhaqora', '0');
-- One Direction
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jmkcj6p46ovi1sn', 'One Direction', '210@artist.com', 'https://i.scdn.co/image/5bb443424a1ad71603c43d67f5af1a04da6bb3c8','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:210@artist.com', 'jmkcj6p46ovi1sn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jmkcj6p46ovi1sn', 'Creating a tapestry of tunes that celebrates diversity.', 'One Direction');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('58xqlbsm0k0h5110coym07wk0hnyy2qbtsboe7blraihuft60p','jmkcj6p46ovi1sn', 'https://i.scdn.co/image/ab67616d0000b273d304ba2d71de306812eebaf4', 'One Direction Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3b7ls661xqtcyrylvoe91jj1sxvabjj56m1s1k1wcxscyhkkt8','Night Changes','jmkcj6p46ovi1sn','POP','5O2P9iiztwhomNh8xkR9lJ','https://p.scdn.co/mp3-preview/359be833b46b250c696bbb64caa5dc91f2a38c6a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('58xqlbsm0k0h5110coym07wk0hnyy2qbtsboe7blraihuft60p', '3b7ls661xqtcyrylvoe91jj1sxvabjj56m1s1k1wcxscyhkkt8', '0');
-- Raim Laode
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('m8q3p7irwxl38c2', 'Raim Laode', '211@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8f5fe38a2d25be089bf281e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:211@artist.com', 'm8q3p7irwxl38c2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('m8q3p7irwxl38c2', 'Exploring the depths of sound and rhythm.', 'Raim Laode');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('35mrzy6v27ldgb4f9vpmnz0vrka5qo66njk2bp3wm8eank0lgy','m8q3p7irwxl38c2', 'https://i.scdn.co/image/ab67616d0000b273f20ec6ba1f431a90dbf2e8b6', 'Raim Laode Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('12e6ck12shndf4878ly7v7hkh6zdk0bh1q2zxmdttk3tepq136','Komang','m8q3p7irwxl38c2','POP','2AaaE0qvFWtyT8srKNfRhH','https://p.scdn.co/mp3-preview/47575d13a133216ab684c5211af483a7524e89db?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('35mrzy6v27ldgb4f9vpmnz0vrka5qo66njk2bp3wm8eank0lgy', '12e6ck12shndf4878ly7v7hkh6zdk0bh1q2zxmdttk3tepq136', '0');
-- Oscar Maydon
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('siwmm1dqvvazehu', 'Oscar Maydon', '212@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8920adf64930d6f26e34b7c4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:212@artist.com', 'siwmm1dqvvazehu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('siwmm1dqvvazehu', 'Crafting a unique sonic identity in every track.', 'Oscar Maydon');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('026aw2t820nj6xs13c22e6ih88verkg9eyisdoeg29jqes5gww','siwmm1dqvvazehu', 'https://i.scdn.co/image/ab67616d0000b2739b7e1ea3815a172019bc5e56', 'Oscar Maydon Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('807n1uex9rhkcdvg3yfmxbsx32ugniwy0i7qfrfari8bgd1v3l','Fin de Semana','siwmm1dqvvazehu','POP','6TBzRwnX2oYd8aOrOuyK1p','https://p.scdn.co/mp3-preview/71ee8bdc0a34790ad549ba750665808f08f5e46b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('026aw2t820nj6xs13c22e6ih88verkg9eyisdoeg29jqes5gww', '807n1uex9rhkcdvg3yfmxbsx32ugniwy0i7qfrfari8bgd1v3l', '0');
-- James Hype
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qtq87c965n51q1o', 'James Hype', '213@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb3735de17f641144240511000','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:213@artist.com', 'qtq87c965n51q1o', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qtq87c965n51q1o', 'Melodies that capture the essence of human emotion.', 'James Hype');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('zkqrn7ctc0qy81drdofsonphv3c6we5914j6ebyr4o483jsnyz','qtq87c965n51q1o', 'https://i.scdn.co/image/ab67616d0000b2736cc861b5c9c7cdef61b010b4', 'James Hype Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xnrg8lvb6cew8tvxnxhts6iinyv1ceqz3sl86me711r38msvtl','Ferrari','qtq87c965n51q1o','POP','4zN21mbAuaD0WqtmaTZZeP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('zkqrn7ctc0qy81drdofsonphv3c6we5914j6ebyr4o483jsnyz', 'xnrg8lvb6cew8tvxnxhts6iinyv1ceqz3sl86me711r38msvtl', '0');
-- NF
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jmuc2cmopkgm4p7', 'NF', '214@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb1cf142a710a2f3d9b7a62da1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:214@artist.com', 'jmuc2cmopkgm4p7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jmuc2cmopkgm4p7', 'Creating a tapestry of tunes that celebrates diversity.', 'NF');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('68ojseeu35u4xtoqr40jz2e65g1fmj10h1wl7tpiyfgbyeavci','jmuc2cmopkgm4p7', 'https://i.scdn.co/image/ab67616d0000b273ff8a4276b3be31c839557439', 'NF Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6m3ii1mc29c9mdjyrts7m39u4m6rrk1twbq6283nub2p20hgtb','HAPPY','jmuc2cmopkgm4p7','POP','3ZEno9fORwMA1HPecdLi0R',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('68ojseeu35u4xtoqr40jz2e65g1fmj10h1wl7tpiyfgbyeavci', '6m3ii1mc29c9mdjyrts7m39u4m6rrk1twbq6283nub2p20hgtb', '0');
-- Gunna
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('5te18t4goui83gw', 'Gunna', '215@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6501f8a7d50c56e86e46f920','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:215@artist.com', '5te18t4goui83gw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('5te18t4goui83gw', 'A trailblazer in trap music, known for his smooth flow and catchy beats.', 'Gunna');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('eirndhnq1ki08ix7abnfj1d1mfoj24nxel5e8dwap11jwoge86','5te18t4goui83gw', 'https://i.scdn.co/image/ab67616d0000b273017d5e26552345c4b1575b6c', 'Gunna Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('laun0h7iq83acykg8uku36m1f9zmq5i3d2xfb0jfumvpejypcl','fukumean','5te18t4goui83gw','POP','4rXLjWdF2ZZpXCVTfWcshS','https://p.scdn.co/mp3-preview/f237ab921af697ba9b49e12fa167c2ce1a82d6b4?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('eirndhnq1ki08ix7abnfj1d1mfoj24nxel5e8dwap11jwoge86', 'laun0h7iq83acykg8uku36m1f9zmq5i3d2xfb0jfumvpejypcl', '0');
-- Kenia OS
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qz5ia9rfynjfbgn', 'Kenia OS', '216@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7cee297b5eaaa121f9558d7e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:216@artist.com', 'qz5ia9rfynjfbgn', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qz5ia9rfynjfbgn', 'An odyssey of sound that defies conventions.', 'Kenia OS');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ih2etlfqxmghbzymbpbhuvr6hx0piy23tprjqhje7r1j7u7axg','qz5ia9rfynjfbgn', 'https://i.scdn.co/image/ab67616d0000b2739afe5698b0a9559dabc44ac8', 'Kenia OS Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2z3623c4qyqh3a4bk8ssh8wgkdn9otthynib16qsk4aa0surdo','Malas Decisiones','qz5ia9rfynjfbgn','POP','6Xj014IHwbLVjiVT6H89on','https://p.scdn.co/mp3-preview/9a71f09b224a9e6f521743423bd53e99c7c4793c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ih2etlfqxmghbzymbpbhuvr6hx0piy23tprjqhje7r1j7u7axg', '2z3623c4qyqh3a4bk8ssh8wgkdn9otthynib16qsk4aa0surdo', '0');
-- Sabrina Carpenter
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ua60t87l7tp0s5p', 'Sabrina Carpenter', '217@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb00e540b760b56d02cc415c47','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:217@artist.com', 'ua60t87l7tp0s5p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ua60t87l7tp0s5p', 'Crafting melodies that resonate with the soul.', 'Sabrina Carpenter');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ui1g7zldyz3ifxhpm6vhcq9z0rqk6s5dqx4evn3e4gt2tb1are','ua60t87l7tp0s5p', 'https://i.scdn.co/image/ab67616d0000b273700f7bf79c9f063ad0362bdf', 'Sabrina Carpenter Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('wyepokvf34k21zk23etowj2z50pxz9sa4el5xuxwjp67g2jb2u','Nonsense','ua60t87l7tp0s5p','POP','6dgUya35uo964z7GZXM07g',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ui1g7zldyz3ifxhpm6vhcq9z0rqk6s5dqx4evn3e4gt2tb1are', 'wyepokvf34k21zk23etowj2z50pxz9sa4el5xuxwjp67g2jb2u', '0');
-- Labrinth
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('kgbmlf1alqvs5xe', 'Labrinth', '218@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb7885d725841e0338092f5f6f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:218@artist.com', 'kgbmlf1alqvs5xe', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('kgbmlf1alqvs5xe', 'Elevating the ordinary to extraordinary through music.', 'Labrinth');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pz0xq2526yjmklc7ile4kj4y603fdb9hwrbo46i5uqbmup4963','kgbmlf1alqvs5xe', 'https://i.scdn.co/image/ab67616d0000b2731df535f5089e544a3cc86069', 'Labrinth Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7clm2vhprzd7y2049r3nf9sa7nv5pgv36dc4y3g15dqzknewd1','Never Felt So Alone','kgbmlf1alqvs5xe','POP','6unndO70DvZfnXYcYQMyQJ','https://p.scdn.co/mp3-preview/d33db796d822aa77728af0f4abb06ccd596d2920?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pz0xq2526yjmklc7ile4kj4y603fdb9hwrbo46i5uqbmup4963', '7clm2vhprzd7y2049r3nf9sa7nv5pgv36dc4y3g15dqzknewd1', '0');
-- Skrillex
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('dqgk9hke79lht85', 'Skrillex', '219@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb61f92702ca14484aa263a931','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:219@artist.com', 'dqgk9hke79lht85', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('dqgk9hke79lht85', 'Exploring the depths of sound and rhythm.', 'Skrillex');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('f6obw2y63wjgjmqrwj0qiqaww6hdwzxitud0igajy9amazmaai','dqgk9hke79lht85', 'https://i.scdn.co/image/ab67616d0000b273352f154c54727bc8024629bc', 'Skrillex Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2y0hx0d7ynzcf3psnj72b4w8bp34pr7pcufypk2lv9024txwi6','Rumble','dqgk9hke79lht85','POP','1GfBLbAhZUWdseuDqhocmn','https://p.scdn.co/mp3-preview/eb79af9f809883de0632f02388ec354478612754?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('f6obw2y63wjgjmqrwj0qiqaww6hdwzxitud0igajy9amazmaai', '2y0hx0d7ynzcf3psnj72b4w8bp34pr7pcufypk2lv9024txwi6', '0');
-- Luke Combs
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('uzm09ghhhl1igwp', 'Luke Combs', '220@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb5db6179b28f7e3654898b279','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:220@artist.com', 'uzm09ghhhl1igwp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('uzm09ghhhl1igwp', 'Reigniting country music with his powerful voice and relatable songs.', 'Luke Combs');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vuunrm6mzpjha03d49awea68h5pq3rpykp5rxap4tvpn2nsgl3','uzm09ghhhl1igwp', 'https://i.scdn.co/image/ab67616d0000b273ca650d3a95022e0490434ba1', 'Luke Combs Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9ptmwrwl8rqf2uqi6mctoh94w55erdoq95t463dqcvp7nhhl8x','Fast Car','uzm09ghhhl1igwp','POP','1Lo0QY9cvc8sUB2vnIOxDT','https://p.scdn.co/mp3-preview/1dc0426c95058783e0fe1d70c41583ca98317108?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vuunrm6mzpjha03d49awea68h5pq3rpykp5rxap4tvpn2nsgl3', '9ptmwrwl8rqf2uqi6mctoh94w55erdoq95t463dqcvp7nhhl8x', '0');
-- Kate Bush
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('qfne50rf6idcvru', 'Kate Bush', '221@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb187017724e58e78ee1f5a8e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:221@artist.com', 'qfne50rf6idcvru', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('qfne50rf6idcvru', 'Pushing the boundaries of sound with each note.', 'Kate Bush');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('13t899976k77g866uu41fxmjt5n1b41h5men335e5hrpp6fkol','qfne50rf6idcvru', 'https://i.scdn.co/image/ab67616d0000b273ad08f4b38efbff0c0da0f252', 'Kate Bush Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('flhyzba4yefqvgyo99jqa3exjdimr6p4zweoxosmn47sy28d5s','Running Up That Hill (A Deal With God)','qfne50rf6idcvru','POP','1PtQJZVZIdWIYdARpZRDFO','https://p.scdn.co/mp3-preview/861d26b52ece3e3ad72a7dc3463daece3478801a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('13t899976k77g866uu41fxmjt5n1b41h5men335e5hrpp6fkol', 'flhyzba4yefqvgyo99jqa3exjdimr6p4zweoxosmn47sy28d5s', '0');
-- TOMORROW X TOGETHER
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hedb8yn0dcwdpxp', 'TOMORROW X TOGETHER', '222@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8b446e5bd3820ac772155b31','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:222@artist.com', 'hedb8yn0dcwdpxp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hedb8yn0dcwdpxp', 'A symphony of emotions expressed through sound.', 'TOMORROW X TOGETHER');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('dum9cs05j1c1wuexyzk1iibbxe1ndyrss5yqrbw8nmjlz2mwbh','hedb8yn0dcwdpxp', 'https://i.scdn.co/image/ab67616d0000b2733bb056e3160b85ee86c1194d', 'TOMORROW X TOGETHER Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5e9sy3tpldddsvh8hm6ujkyx36h19etagsoddjj8kzmz8w2wd5','Sugar Rush Ride','hedb8yn0dcwdpxp','POP','0rhI6gvOeCKA502RdJAbfs','https://p.scdn.co/mp3-preview/691f502777012a09541b5265cfddaa4401470759?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('dum9cs05j1c1wuexyzk1iibbxe1ndyrss5yqrbw8nmjlz2mwbh', '5e9sy3tpldddsvh8hm6ujkyx36h19etagsoddjj8kzmz8w2wd5', '0');
-- Gustavo Mioto
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gavvlgl3mfe4lh2', 'Gustavo Mioto', '223@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcec51a9ef6fe19159cb0452f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:223@artist.com', 'gavvlgl3mfe4lh2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gavvlgl3mfe4lh2', 'Melodies that capture the essence of human emotion.', 'Gustavo Mioto');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kpto2scuu76oq2i71a6u1opz8gb304uus4fmi5lgjfpty9urv1','gavvlgl3mfe4lh2', 'https://i.scdn.co/image/ab67616d0000b27319bb2fb697a42c1084d71f6c', 'Gustavo Mioto Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zvu3pb1wf510uhphafpr3uxl3vfhsphvoq1y5wi552p55n5jbs','Eu Gosto Assim - Ao Vivo','gavvlgl3mfe4lh2','POP','4ASA1PZyWGbuc4d9N8OAcF',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kpto2scuu76oq2i71a6u1opz8gb304uus4fmi5lgjfpty9urv1', 'zvu3pb1wf510uhphafpr3uxl3vfhsphvoq1y5wi552p55n5jbs', '0');
-- Myke Towers
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('vvg56zxx86xdy8z', 'Myke Towers', '224@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9e35c3c5de877f99a8f6192f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:224@artist.com', 'vvg56zxx86xdy8z', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('vvg56zxx86xdy8z', 'A rising star in Latin music, known for his distinctive flow.', 'Myke Towers');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('54gsavxh6pcg6r2m0cz530o5469obmsopfgmet3vha1mqet3ub','vvg56zxx86xdy8z', 'https://i.scdn.co/image/ab67616d0000b2730656d5ce813ca3cc4b677e05', 'Myke Towers Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l0qmlkjidr1s5s6c0un1gh0rrai7jzwfit8i5wvqsehd9ofqes','LALA','vvg56zxx86xdy8z','POP','7ABLbnD53cQK00mhcaOUVG','https://p.scdn.co/mp3-preview/42772b16b4e575d1b15b0ec7f94e335539390d2d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('54gsavxh6pcg6r2m0cz530o5469obmsopfgmet3vha1mqet3ub', 'l0qmlkjidr1s5s6c0un1gh0rrai7jzwfit8i5wvqsehd9ofqes', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('pa9wloale8q6fake879ay5mysi2ayeuv8tij54txa1hpnrws71','PLAYA DEL INGL','vvg56zxx86xdy8z','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('54gsavxh6pcg6r2m0cz530o5469obmsopfgmet3vha1mqet3ub', 'pa9wloale8q6fake879ay5mysi2ayeuv8tij54txa1hpnrws71', '1');
-- Swae Lee
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0wljwju97xdg95r', 'Swae Lee', '225@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebf1be22786da29b0a1284c0a5','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:225@artist.com', '0wljwju97xdg95r', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0wljwju97xdg95r', 'An endless quest for musical perfection.', 'Swae Lee');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('bxte747bus8nkvgy5m3ro43hu2x7tig2csrofav9ris654xlg1','0wljwju97xdg95r', NULL, 'Swae Lee Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r94t36ob7myp1y6xiwunq6zdc0yshr7k7mlw19guz7ba5geol7','Calling (Spider-Man: Across the Spider-Verse) (Metro Boomin & Swae Lee, NAV, feat. A Boogie Wit da Hoodie)','0wljwju97xdg95r','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bxte747bus8nkvgy5m3ro43hu2x7tig2csrofav9ris654xlg1', 'r94t36ob7myp1y6xiwunq6zdc0yshr7k7mlw19guz7ba5geol7', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zbuy7tu3nbzy87un7c92q64gvexz865ovv9ghnp9r9buldp3zj','Annihilate (Spider-Man: Across the Spider-Verse) (Metro Boomin & Swae Lee, Lil Wayne, Offset)','0wljwju97xdg95r','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('bxte747bus8nkvgy5m3ro43hu2x7tig2csrofav9ris654xlg1', 'zbuy7tu3nbzy87un7c92q64gvexz865ovv9ghnp9r9buldp3zj', '1');
-- Adele
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('q9xirkim3rg0bpm', 'Adele', '226@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb68f6e5892075d7f22615bd17','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:226@artist.com', 'q9xirkim3rg0bpm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('q9xirkim3rg0bpm', 'Pioneering new paths in the musical landscape.', 'Adele');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4fu3qa3orutdjjlef17g1gep7675pj0ldbbtc6qllj2zks8777','q9xirkim3rg0bpm', 'https://i.scdn.co/image/ab67616d0000b2732118bf9b198b05a95ded6300', 'Adele Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('efz7m8tqp2kwwqd37mvlu77q757sbgvf4dr3vz42llgx0itwed','Set Fire to the Rain','q9xirkim3rg0bpm','POP','73CMRj62VK8nUS4ezD2wvi','https://p.scdn.co/mp3-preview/6fc68c105e091645376471727960d2ba3cd0ee01?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4fu3qa3orutdjjlef17g1gep7675pj0ldbbtc6qllj2zks8777', 'efz7m8tqp2kwwqd37mvlu77q757sbgvf4dr3vz42llgx0itwed', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v9tu93kjotwjtn8f3vng9dkg7a6wlgviehztbpzth9zdlydjgy','Easy On Me','q9xirkim3rg0bpm','POP','46IZ0fSY2mpAiktS3KOqds','https://p.scdn.co/mp3-preview/a0cd8077c79a4aa3dcaa68bbc5ecdeda46e8d13f?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4fu3qa3orutdjjlef17g1gep7675pj0ldbbtc6qllj2zks8777', 'v9tu93kjotwjtn8f3vng9dkg7a6wlgviehztbpzth9zdlydjgy', '1');
-- INTERWORLD
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('jc90pvegppda2vq', 'INTERWORLD', '227@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4ba846e4a963c8558471e3af','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:227@artist.com', 'jc90pvegppda2vq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('jc90pvegppda2vq', 'Blending genres for a fresh musical experience.', 'INTERWORLD');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('kvnyc64zk8zxysqs1vpyyxdt3nq03gebmym9pbw5kxjyxgs3s7','jc90pvegppda2vq', 'https://i.scdn.co/image/ab67616d0000b273b852a616ae3a49a1f6b0f16e', 'INTERWORLD Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5o8deqwihzoc0eiqo34tjosgr7oftg1xp84mv0p9fdmttz1k9y','METAMORPHOSIS','jc90pvegppda2vq','POP','2ksyzVfU0WJoBpu8otr4pz','https://p.scdn.co/mp3-preview/61baac6cfee58ae57f9f767a86fa5e99f9797664?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('kvnyc64zk8zxysqs1vpyyxdt3nq03gebmym9pbw5kxjyxgs3s7', '5o8deqwihzoc0eiqo34tjosgr7oftg1xp84mv0p9fdmttz1k9y', '0');
-- OneRepublic
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('617p5xv23qb8zv9', 'OneRepublic', '228@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb57138b98e7ddd5a86ee97a9b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:228@artist.com', '617p5xv23qb8zv9', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('617p5xv23qb8zv9', 'Delivering anthemic pop-rock tracks that resonate globally.', 'OneRepublic');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xn7ztd373dxcehbs9pxzpjgxen6fnyqd6e0amg2t4nkxpcq89g','617p5xv23qb8zv9', 'https://i.scdn.co/image/ab67616d0000b273ec96e006b8bdfc582610ec13', 'OneRepublic Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d9huouenp4s2o836krea8bthal2eoxb5135gd5nnryj934amy2','I Aint Worried','617p5xv23qb8zv9','POP','4h9wh7iOZ0GGn8QVp4RAOB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xn7ztd373dxcehbs9pxzpjgxen6fnyqd6e0amg2t4nkxpcq89g', 'd9huouenp4s2o836krea8bthal2eoxb5135gd5nnryj934amy2', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ffvmk74m1yijmzw6cuonwth30do5k745eribquqd054w2nz9eh','Counting Stars','617p5xv23qb8zv9','POP','2tpWsVSb9UEmDRxAl1zhX1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xn7ztd373dxcehbs9pxzpjgxen6fnyqd6e0amg2t4nkxpcq89g', 'ffvmk74m1yijmzw6cuonwth30do5k745eribquqd054w2nz9eh', '1');
-- IU
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('59w69n7emy611mw', 'IU', '229@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb006ff3c0136a71bfb9928d34','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:229@artist.com', '59w69n7emy611mw', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('59w69n7emy611mw', 'Elevating the ordinary to extraordinary through music.', 'IU');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9xk1crjbfkd4n3y72x368w017nyzvjn3mlvbddxcyst34e1um4','59w69n7emy611mw', NULL, 'IU Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('p6jx361bk0uv7d9lftbri9dhq0ay5zoe34jmvkfmqnqmmz8t9b','People Pt.2 (feat. IU)','59w69n7emy611mw','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9xk1crjbfkd4n3y72x368w017nyzvjn3mlvbddxcyst34e1um4', 'p6jx361bk0uv7d9lftbri9dhq0ay5zoe34jmvkfmqnqmmz8t9b', '0');
-- Lewis Capaldi
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('acv37hlxf36rtuf', 'Lewis Capaldi', '230@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebea7538654040e553a7b0fc28','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:230@artist.com', 'acv37hlxf36rtuf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('acv37hlxf36rtuf', 'Delivering emotional ballads with his powerful, soul-stirring voice.', 'Lewis Capaldi');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('jrdurgr2hs44mpgdcz5ub39zb5d1qaurxjaveehcz4pbw8z3g8','acv37hlxf36rtuf', 'https://i.scdn.co/image/ab67616d0000b273fc2101e6889d6ce9025f85f2', 'Lewis Capaldi Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l0r74ipxdzmja2bj07wt0kr9rlakks5whldigqjh4709u2ikbs','Someone You Loved','acv37hlxf36rtuf','POP','7qEHsqek33rTcFNT9PFqLf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('jrdurgr2hs44mpgdcz5ub39zb5d1qaurxjaveehcz4pbw8z3g8', 'l0r74ipxdzmja2bj07wt0kr9rlakks5whldigqjh4709u2ikbs', '0');
-- Lil Nas X
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('le0kf3dwdowcjje', 'Lil Nas X', '231@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd66f1e0c883f319443d68c45','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:231@artist.com', 'le0kf3dwdowcjje', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('le0kf3dwdowcjje', 'A unique voice in the contemporary music scene.', 'Lil Nas X');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('m7cdyv1sb1lw9h0a1b0n0hvf9g1y5k01olhw2dav6vbgpl03lh','le0kf3dwdowcjje', 'https://i.scdn.co/image/ab67616d0000b27304cd9a1664fb4539a55643fe', 'Lil Nas X Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yge2cptgd0bniuexjh95w655h1fb5ygntgjhwlybfci5fhjduv','STAR WALKIN (League of Legends Worlds Anthem)','le0kf3dwdowcjje','POP','38T0tPVZHcPZyhtOcCP7pF','https://p.scdn.co/mp3-preview/ffa9d53ff1f83a322ac0523d7a6ce13b231e4a3a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('m7cdyv1sb1lw9h0a1b0n0hvf9g1y5k01olhw2dav6vbgpl03lh', 'yge2cptgd0bniuexjh95w655h1fb5ygntgjhwlybfci5fhjduv', '0');
-- Hotel Ugly
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('0yfkw0ftenyw6as', 'Hotel Ugly', '232@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb939033cc36c08ab68b33f760','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:232@artist.com', '0yfkw0ftenyw6as', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('0yfkw0ftenyw6as', 'Pioneering new paths in the musical landscape.', 'Hotel Ugly');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('s5s5uz06hpjbwvlnwk5yhct3owrxyak87zjtrxjvwndm4kxp8y','0yfkw0ftenyw6as', 'https://i.scdn.co/image/ab67616d0000b273350ab7a839c04bfd5225a9f5', 'Hotel Ugly Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('c8r7hhqagr78rvpbsh6x1dysslhkkqpu8kfttecqkqozx19455','Shut up My Moms Calling','0yfkw0ftenyw6as','POP','3hxIUxnT27p5WcmjGUXNwx','https://p.scdn.co/mp3-preview/7642409265c74b714a2f0f0dd8663c031e253485?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s5s5uz06hpjbwvlnwk5yhct3owrxyak87zjtrxjvwndm4kxp8y', 'c8r7hhqagr78rvpbsh6x1dysslhkkqpu8kfttecqkqozx19455', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('br3y7gf7s23ny7e8qh6rjpum0lyam9oz2yt3uamrlpqfrmwo8m','Shut up My Moms Calling - (Sped Up)','0yfkw0ftenyw6as','POP','31mzt4ZV8C0f52pIz1NSwd','https://p.scdn.co/mp3-preview/4417d6fbf78b2a96b067dc092f888178b155b6b7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('s5s5uz06hpjbwvlnwk5yhct3owrxyak87zjtrxjvwndm4kxp8y', 'br3y7gf7s23ny7e8qh6rjpum0lyam9oz2yt3uamrlpqfrmwo8m', '1');
-- Mae Stephens
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ol6e4y431bux3ik', 'Mae Stephens', '233@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb743f68b46b3909d5f74da093','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:233@artist.com', 'ol6e4y431bux3ik', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ol6e4y431bux3ik', 'Weaving lyrical magic into every song.', 'Mae Stephens');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('9cntszg6e3frhc32dxydo88duxbs8qgl1wm94l7q12fx9j0hf5','ol6e4y431bux3ik', 'https://i.scdn.co/image/ab67616d0000b2731fc63c898797e3dbf04ad611', 'Mae Stephens Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('u03d87sg8fhaxxr27be284fb0vjoaj6hnfhvda44g76onraadx','If We Ever Broke Up','ol6e4y431bux3ik','POP','6maTPqynTmrkWIralgGaoP',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('9cntszg6e3frhc32dxydo88duxbs8qgl1wm94l7q12fx9j0hf5', 'u03d87sg8fhaxxr27be284fb0vjoaj6hnfhvda44g76onraadx', '0');
-- Miguel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3ebww19e0b3oatz', 'Miguel', '234@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4669166b571594eade778990','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:234@artist.com', '3ebww19e0b3oatz', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3ebww19e0b3oatz', 'Delivering soul-stirring tunes that linger in the mind.', 'Miguel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('v2dga8c7xy5rw2fv9f82vl1dfx84n4ibgeflcaaazxeen8c2jo','3ebww19e0b3oatz', 'https://i.scdn.co/image/ab67616d0000b273d5a8395b0d80b8c48a5d851c', 'Miguel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9z2tb1s7evtogunyhwn56hpq96hvbs7g5o38t3v555gl04cg0p','Sure Thing','3ebww19e0b3oatz','POP','0JXXNGljqupsJaZsgSbMZV','https://p.scdn.co/mp3-preview/d337faa4bb71c8ac9a13998be64fbb0d7d8b8463?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('v2dga8c7xy5rw2fv9f82vl1dfx84n4ibgeflcaaazxeen8c2jo', '9z2tb1s7evtogunyhwn56hpq96hvbs7g5o38t3v555gl04cg0p', '0');
-- Tainy
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xo6hcz2xvgdgebe', 'Tainy', '235@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb50d43598b9074f0d6146127','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:235@artist.com', 'xo6hcz2xvgdgebe', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xo6hcz2xvgdgebe', 'Revolutionizing reggaeton and Latin music with groundbreaking production.', 'Tainy');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vdq0fnoezrtmf0bj30shnoopzk94yxb8scysps9hohrdiil9ew','xo6hcz2xvgdgebe', 'https://i.scdn.co/image/ab67616d0000b273de7b9af78fbdda96c5a0635b', 'Tainy Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('rhbtzdfpvyh2pd42xh4lh3rsywwy1gskw0naj9oaufs3leknx4','MOJABI GHOST','xo6hcz2xvgdgebe','POP','4eMKD8MRroxCqugpsxCCNb','https://p.scdn.co/mp3-preview/a6d8180d52b759c3e3db9aa78e841ffc06e26c17?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vdq0fnoezrtmf0bj30shnoopzk94yxb8scysps9hohrdiil9ew', 'rhbtzdfpvyh2pd42xh4lh3rsywwy1gskw0naj9oaufs3leknx4', '0');
-- Kanii
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('9y4c5ku8et9gub8', 'Kanii', '236@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb777f2bab9e5f1e343c3126d4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:236@artist.com', '9y4c5ku8et9gub8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('9y4c5ku8et9gub8', 'A maestro of melodies, orchestrating auditory bliss.', 'Kanii');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qp16xjj3x0zbp77majmfaybdi1gttmuydvnqoppcjpyx9rkdir','9y4c5ku8et9gub8', 'https://i.scdn.co/image/ab67616d0000b273efae10889cd442784f3acd3d', 'Kanii Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9f555r0y6l2u5chdb4qykykoci0vv33zhepcqv0mpoersyrop1','I Know - PR1SVX Edit','9y4c5ku8et9gub8','POP','3vcLw8QA3yCOkrj9oLSZNs','https://p.scdn.co/mp3-preview/146ad1bb65b8f9b097f356d2d5758657a06466dc?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qp16xjj3x0zbp77majmfaybdi1gttmuydvnqoppcjpyx9rkdir', '9f555r0y6l2u5chdb4qykykoci0vv33zhepcqv0mpoersyrop1', '0');
-- Creedence Clearwater Revival
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1836c4f3p8ofs27', 'Creedence Clearwater Revival', '237@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebd2e2b04b7ba5d60b72f54506','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:237@artist.com', '1836c4f3p8ofs27', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1836c4f3p8ofs27', 'A symphony of emotions expressed through sound.', 'Creedence Clearwater Revival');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('pihvdynoyre1c8rwsvcgf5ylb1xrco4pkry431bzlznsdlse4u','1836c4f3p8ofs27', 'https://i.scdn.co/image/ab67616d0000b27351f311c2fb06ad2789e3ff91', 'Creedence Clearwater Revival Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('kwm7usww3adpof2bx6jhioouck0sjedlmhjir406mcla3qvf9h','Have You Ever Seen The Rain?','1836c4f3p8ofs27','POP','2LawezPeJhN4AWuSB0GtAU',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('pihvdynoyre1c8rwsvcgf5ylb1xrco4pkry431bzlznsdlse4u', 'kwm7usww3adpof2bx6jhioouck0sjedlmhjir406mcla3qvf9h', '0');
-- The Kid Laroi
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('id0mwlpopobt8sf', 'The Kid Laroi', '238@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb393666951ab8b14e9c4ed386','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:238@artist.com', 'id0mwlpopobt8sf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('id0mwlpopobt8sf', 'Pioneering new paths in the musical landscape.', 'The Kid Laroi');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('fdeqw5b2wrip7t0b29fox8v1gog1jdlpk825fh16kjg2vibhi9','id0mwlpopobt8sf', 'https://i.scdn.co/image/ab67616d0000b273a53643fc03785efb9926443d', 'The Kid Laroi Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('cukcs1uz4006lpi7hyuwmq82yhb1rzoq7l0arr1ud5i0unwxt8','Love Again','id0mwlpopobt8sf','POP','4sx6NRwL6Ol3V6m9exwGlQ','https://p.scdn.co/mp3-preview/4baae2685eaac7401ae183c54642c9ddf3b9e057?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('fdeqw5b2wrip7t0b29fox8v1gog1jdlpk825fh16kjg2vibhi9', 'cukcs1uz4006lpi7hyuwmq82yhb1rzoq7l0arr1ud5i0unwxt8', '0');
-- Kenshi Yonezu
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('10nmtvggnbud25l', 'Kenshi Yonezu', '239@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc147e0888e83919d317c1103','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:239@artist.com', '10nmtvggnbud25l', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('10nmtvggnbud25l', 'Revolutionizing the music scene with innovative compositions.', 'Kenshi Yonezu');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('i80a0yw0lap8yextaf6ltglv3ivlwi84xcni7cqvvz3agjunde','10nmtvggnbud25l', 'https://i.scdn.co/image/ab67616d0000b273303d8545fce8302841c39859', 'Kenshi Yonezu Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('x8lzo8npgcfvzdhqt28zqw07ifqjwu5lm9c5fa1jfzklpgc95k','KICK BACK','10nmtvggnbud25l','POP','3khEEPRyBeOUabbmOPJzAG','https://p.scdn.co/mp3-preview/003a7a062f469db238cf5206626f08f3263c68e6?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('i80a0yw0lap8yextaf6ltglv3ivlwi84xcni7cqvvz3agjunde', 'x8lzo8npgcfvzdhqt28zqw07ifqjwu5lm9c5fa1jfzklpgc95k', '0');
-- Nengo Flow
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('6pgmpy1ejh6fso8', 'Nengo Flow', '240@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebda3f48cf2309aacaab0edce2','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:240@artist.com', '6pgmpy1ejh6fso8', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('6pgmpy1ejh6fso8', 'Igniting the stage with electrifying performances.', 'Nengo Flow');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rd6w07deg6mfyb8n0nsgkkrn5fior5bs7eqrlqa6m161l8darz','6pgmpy1ejh6fso8', 'https://i.scdn.co/image/ab67616d0000b273ed132404686f567c8f793058', 'Nengo Flow Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('lk9a6i2bczfr05nx1688x4lj54xixlafk6mu5kjgi4znwsi8k1','Gato de Noche','6pgmpy1ejh6fso8','POP','54ELExv56KCAB4UP9cOCzC','https://p.scdn.co/mp3-preview/7d6a9dab2f3779eef37ef52603d20607a1390d91?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rd6w07deg6mfyb8n0nsgkkrn5fior5bs7eqrlqa6m161l8darz', 'lk9a6i2bczfr05nx1688x4lj54xixlafk6mu5kjgi4znwsi8k1', '0');
-- Semicenk
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('drlgm1y3653zmnu', 'Semicenk', '241@artist.com', 'https://i.scdn.co/image/ab67616d0000b2730b8da935d3ba07f14f01eb32','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:241@artist.com', 'drlgm1y3653zmnu', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('drlgm1y3653zmnu', 'The heartbeat of a new generation of music lovers.', 'Semicenk');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ks2aw12tsi9wp003nswypsdodynzzjiiqf79hx7o9au61v4fel','drlgm1y3653zmnu', NULL, 'Semicenk Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('o44do1mlvz6vlzrls8qs9ucx62sft094xmpha8n8siau22iai9','Piman De','drlgm1y3653zmnu','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ks2aw12tsi9wp003nswypsdodynzzjiiqf79hx7o9au61v4fel', 'o44do1mlvz6vlzrls8qs9ucx62sft094xmpha8n8siau22iai9', '0');
-- Bomba Estreo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ft3c3om2exogjdt', 'Bomba Estreo', '242@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcc4d7c642f167846d8aa743b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:242@artist.com', 'ft3c3om2exogjdt', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ft3c3om2exogjdt', 'The heartbeat of a new generation of music lovers.', 'Bomba Estreo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6nux5ogw24vt7r0z7bja77gtcead2ju7ar6dnmfkmkzhgqkt49','ft3c3om2exogjdt', NULL, 'Bomba Estreo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('282qxrqsgitimh8rt99nbn8j85utpyvo88hv1kms6165cn8v4g','Ojitos Lindos','ft3c3om2exogjdt','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6nux5ogw24vt7r0z7bja77gtcead2ju7ar6dnmfkmkzhgqkt49', '282qxrqsgitimh8rt99nbn8j85utpyvo88hv1kms6165cn8v4g', '0');
-- Agust D
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1q3z5w8w3xor6no', 'Agust D', '243@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb191d43dca6f2f5a126e43e4b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:243@artist.com', '1q3z5w8w3xor6no', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1q3z5w8w3xor6no', 'Weaving lyrical magic into every song.', 'Agust D');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vvi59juqvnqicooontp884byw38d4ddynn89461vne27n3ik7w','1q3z5w8w3xor6no', 'https://i.scdn.co/image/ab67616d0000b273fa9247b68471b82d2125651e', 'Agust D Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5cr0vuisks2t7dyyi4ogtmle6np945zjoni6iqrg9emt7mva0n','Haegeum','1q3z5w8w3xor6no','POP','4bjN59DRXFRxBE1g5ne6B1','https://p.scdn.co/mp3-preview/3c2f1894de0f6a51f557131c3eb275cb8bc80831?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vvi59juqvnqicooontp884byw38d4ddynn89461vne27n3ik7w', '5cr0vuisks2t7dyyi4ogtmle6np945zjoni6iqrg9emt7mva0n', '0');
-- Kali Uchis
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('gyboxosg7rtcs02', 'Kali Uchis', '244@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb51dfdac248da65a860963b68','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:244@artist.com', 'gyboxosg7rtcs02', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('gyboxosg7rtcs02', 'A fusion of soul, R&B, and Latin beats, creating a unique sound experience.', 'Kali Uchis');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('vztvfd5cgbm90qytxlhh5x4xtxoiv52iulxgyb2qnd3fys3j4b','gyboxosg7rtcs02', 'https://i.scdn.co/image/ab67616d0000b27381fccd758776d16b87721b17', 'Kali Uchis Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ylw6mucbhfdp7gvcrr3nz5zs2fhxsfxqzg15r11wvixrtqh9l4','Moonlight','gyboxosg7rtcs02','POP','0JmnkIqdlnUzPaf8sqBRs3',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('vztvfd5cgbm90qytxlhh5x4xtxoiv52iulxgyb2qnd3fys3j4b', 'ylw6mucbhfdp7gvcrr3nz5zs2fhxsfxqzg15r11wvixrtqh9l4', '0');
-- Tory Lanez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('lheh6sgj2xkxmxs', 'Tory Lanez', '245@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebbd5d3e1b363c3e26710661c3','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:245@artist.com', 'lheh6sgj2xkxmxs', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('lheh6sgj2xkxmxs', 'A journey through the spectrum of sound in every album.', 'Tory Lanez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('rwcpztkmp6b0wj3fvx0qcqmw5hfye5vp4ovpfpe65071gwhaxi','lheh6sgj2xkxmxs', 'https://i.scdn.co/image/ab67616d0000b2730c5f23cbf0b1ab7e37d0dc67', 'Tory Lanez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9vuh6w7v5bxshur88ifj51xtfyju5hx623ryq9notyth7olz7t','The Color Violet','lheh6sgj2xkxmxs','POP','3azJifCSqg9fRij2yKIbWz','https://p.scdn.co/mp3-preview/1d7c627bf549328110519c4bd21ac39d7ca50ea1?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('rwcpztkmp6b0wj3fvx0qcqmw5hfye5vp4ovpfpe65071gwhaxi', '9vuh6w7v5bxshur88ifj51xtfyju5hx623ryq9notyth7olz7t', '0');
-- Eminem
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ov0qd6u4wbka54t', 'Eminem', '246@artist.com', 'https://i.scdn.co/image/ab6761610000e5eba00b11c129b27a88fc72f36b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:246@artist.com', 'ov0qd6u4wbka54t', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ov0qd6u4wbka54t', 'A journey through the spectrum of sound in every album.', 'Eminem');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('hlb6zfn4aor21dmudbq6hehrw1j4p7w9nmr7c2kecgrzfulkdg','ov0qd6u4wbka54t', 'https://i.scdn.co/image/ab67616d0000b273726d48d93d02e1271774f023', 'Eminem Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('vihiq28e2gnnjwdnkrmwck1atc27vmetgbfqfxd53cnkcse9mr','Mockingbird','ov0qd6u4wbka54t','POP','561jH07mF1jHuk7KlaeF0s',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hlb6zfn4aor21dmudbq6hehrw1j4p7w9nmr7c2kecgrzfulkdg', 'vihiq28e2gnnjwdnkrmwck1atc27vmetgbfqfxd53cnkcse9mr', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n2xfp55gawucbodcmyemjcxz49dlssm8hae59du89xe9unkkx2','Without Me','ov0qd6u4wbka54t','POP','7lQ8MOhq6IN2w8EYcFNSUk',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hlb6zfn4aor21dmudbq6hehrw1j4p7w9nmr7c2kecgrzfulkdg', 'n2xfp55gawucbodcmyemjcxz49dlssm8hae59du89xe9unkkx2', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('5ovtvxqhght33annzsyaboi8om4kvujq3o5c138c54551ho1g0','The Real Slim Shady','ov0qd6u4wbka54t','POP','3yfqSUWxFvZELEM4PmlwIR',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hlb6zfn4aor21dmudbq6hehrw1j4p7w9nmr7c2kecgrzfulkdg', '5ovtvxqhght33annzsyaboi8om4kvujq3o5c138c54551ho1g0', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z0hxuemaqz6k9m2j3db7fu0d967zjcnocrl2mkztd1mrsa6loh','Lose Yourself - Soundtrack Version','ov0qd6u4wbka54t','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hlb6zfn4aor21dmudbq6hehrw1j4p7w9nmr7c2kecgrzfulkdg', 'z0hxuemaqz6k9m2j3db7fu0d967zjcnocrl2mkztd1mrsa6loh', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7qg23ucevqx4ym17f0eaol2iydvghshk0nrmrtagzxirrdg0rf','Superman','ov0qd6u4wbka54t','POP','4woTEX1wYOTGDqNXuavlRC',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('hlb6zfn4aor21dmudbq6hehrw1j4p7w9nmr7c2kecgrzfulkdg', '7qg23ucevqx4ym17f0eaol2iydvghshk0nrmrtagzxirrdg0rf', '4');
-- Justin Bieber
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('xzzzexjbxnhz8ya', 'Justin Bieber', '247@artist.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:247@artist.com', 'xzzzexjbxnhz8ya', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('xzzzexjbxnhz8ya', 'From teen idol to global pop star, constantly evolving his sound.', 'Justin Bieber');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('2yx0ze1q4b7ieognwpzx9ebwo4crql8e7xig5fs6hsc9h6g8ak','xzzzexjbxnhz8ya', NULL, 'Justin Bieber Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('qsq58ak71ljkznw7awb6nf8b1u4j7dskm06lza2i30te3ifm25','STAY (with Justin Bieber)','xzzzexjbxnhz8ya','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2yx0ze1q4b7ieognwpzx9ebwo4crql8e7xig5fs6hsc9h6g8ak', 'qsq58ak71ljkznw7awb6nf8b1u4j7dskm06lza2i30te3ifm25', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('seajghjl8v9ofw89p1kdwb2elihwkif40huyek69ouw1ew3n4g','Ghost','xzzzexjbxnhz8ya','POP','6I3mqTwhRpn34SLVafSH7G',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('2yx0ze1q4b7ieognwpzx9ebwo4crql8e7xig5fs6hsc9h6g8ak', 'seajghjl8v9ofw89p1kdwb2elihwkif40huyek69ouw1ew3n4g', '1');
-- Nicky Jam
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('o5u3pjui1k49nqk', 'Nicky Jam', '248@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebb02bec146cac39466d3f8ee1','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:248@artist.com', 'o5u3pjui1k49nqk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('o5u3pjui1k49nqk', 'An alchemist of harmonies, transforming notes into gold.', 'Nicky Jam');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oaeu40yno1ivehhjd4wuhmfavgwlip23c6r60kam8sxub54c9f','o5u3pjui1k49nqk', 'https://i.scdn.co/image/ab67616d0000b273ea97d86f1fa8532cd8c75188', 'Nicky Jam Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ei8ekfpxepcc47d1djat70jbzk33zqhmiaq1iyej6veboy213z','69','o5u3pjui1k49nqk','POP','13Z5Q40pa1Ly7aQk1oW8Ce','https://p.scdn.co/mp3-preview/966457479d8cd723838150ddd1f3010f4383994d?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oaeu40yno1ivehhjd4wuhmfavgwlip23c6r60kam8sxub54c9f', 'ei8ekfpxepcc47d1djat70jbzk33zqhmiaq1iyej6veboy213z', '0');
-- Morgan Wallen
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('hy18c0p4bxphujr', 'Morgan Wallen', '249@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb21ed0100a3a4e5aa3c57f6dd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:249@artist.com', 'hy18c0p4bxphujr', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('hy18c0p4bxphujr', 'Blending country charm with rock energy to create memorable tunes.', 'Morgan Wallen');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('nla1uncut6hjosbqdmloqomabp5gf8ejz1gyjsim61bneud0qg','hy18c0p4bxphujr', 'https://i.scdn.co/image/ab67616d0000b273705079df9a25a28b452c1fc9', 'Morgan Wallen Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7o08armbjf1cbtyu5wvj568tvtxmx00ffdyitgyhbtf4hhy6ac','Last Night','hy18c0p4bxphujr','POP','7K3BhSpAxZBznislvUMVtn',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nla1uncut6hjosbqdmloqomabp5gf8ejz1gyjsim61bneud0qg', '7o08armbjf1cbtyu5wvj568tvtxmx00ffdyitgyhbtf4hhy6ac', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('n8zfdd61gtdf91y50z6teep0ro3l46fmcgycg0hi9rdi40p67r','You Proof','hy18c0p4bxphujr','POP','5W4kiM2cUYBJXKRudNyxjW',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nla1uncut6hjosbqdmloqomabp5gf8ejz1gyjsim61bneud0qg', 'n8zfdd61gtdf91y50z6teep0ro3l46fmcgycg0hi9rdi40p67r', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1uhnqtfiic8zt7xtzmjln9zy5jd5q49pd5skq28ecr1ypsa0au','One Thing At A Time','hy18c0p4bxphujr','POP','1rXq0uoV4KTgRN64jXzIxo',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nla1uncut6hjosbqdmloqomabp5gf8ejz1gyjsim61bneud0qg', '1uhnqtfiic8zt7xtzmjln9zy5jd5q49pd5skq28ecr1ypsa0au', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('bjnqrkpj4wr3amcig8nvcqiehcge4lfw6fufvttrqazqcfpuio','Aint Tha','hy18c0p4bxphujr','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nla1uncut6hjosbqdmloqomabp5gf8ejz1gyjsim61bneud0qg', 'bjnqrkpj4wr3amcig8nvcqiehcge4lfw6fufvttrqazqcfpuio', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('i1vh9p2p3ixsf36ugqn6e04g8pyep6lrmsufzojhu5peo0kpyt','Thinkin B','hy18c0p4bxphujr','POP','0PAcdVzhPO4gq1Iym9ESnK',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nla1uncut6hjosbqdmloqomabp5gf8ejz1gyjsim61bneud0qg', 'i1vh9p2p3ixsf36ugqn6e04g8pyep6lrmsufzojhu5peo0kpyt', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ge2t5mpg5cmmg5vehoykmjbhmnd7tp0iwfvyrizckbagseer95','Everything I Love','hy18c0p4bxphujr','POP','03fs6oV5JAlbytRYf3371S',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nla1uncut6hjosbqdmloqomabp5gf8ejz1gyjsim61bneud0qg', 'ge2t5mpg5cmmg5vehoykmjbhmnd7tp0iwfvyrizckbagseer95', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('43lcxsf9y9v3a356iv9qbha0rnxlg1g83lbckr5xpcjb52j8bm','I Wrote The Book','hy18c0p4bxphujr','POP','7phmBo7bB9I9YifAXqnlqV',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nla1uncut6hjosbqdmloqomabp5gf8ejz1gyjsim61bneud0qg', '43lcxsf9y9v3a356iv9qbha0rnxlg1g83lbckr5xpcjb52j8bm', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('ps81bqb2ftewpmkwpijqeb78x9anz4zjwep6hqr7k0eokrwhfj','Man Made A Bar (feat. Eric Church)','hy18c0p4bxphujr','POP','73zawW1ttszLRgT9By826D',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nla1uncut6hjosbqdmloqomabp5gf8ejz1gyjsim61bneud0qg', 'ps81bqb2ftewpmkwpijqeb78x9anz4zjwep6hqr7k0eokrwhfj', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('f2b79ortni7w4rsj60iczy0ctzya9oetnm8op0id2z7sebzmz4','98 Braves','hy18c0p4bxphujr','POP','3oZ6dlSfCE9gZ55MGPJctc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nla1uncut6hjosbqdmloqomabp5gf8ejz1gyjsim61bneud0qg', 'f2b79ortni7w4rsj60iczy0ctzya9oetnm8op0id2z7sebzmz4', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('31uziyypet8i6je8n8cboa5m4xf8cqomtna12rtu720xjl916h','Thought You Should Know','hy18c0p4bxphujr','POP','3Qu3Zh4WTKhP9GEXo0aDnb',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nla1uncut6hjosbqdmloqomabp5gf8ejz1gyjsim61bneud0qg', '31uziyypet8i6je8n8cboa5m4xf8cqomtna12rtu720xjl916h', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('df6se4pxxgmm8bfn8x9ymdqp3dwolcj3eo37m1ax4fr516ppu1','Born With A Beer In My Hand','hy18c0p4bxphujr','POP','1BAU6v0fuAV914qMUEESR1',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nla1uncut6hjosbqdmloqomabp5gf8ejz1gyjsim61bneud0qg', 'df6se4pxxgmm8bfn8x9ymdqp3dwolcj3eo37m1ax4fr516ppu1', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('73qwu54zjg67vddyxfh0moq8xbqzv62ko94oj58lnrhtne4apn','Devil Don','hy18c0p4bxphujr','POP','2PsbT927UanvyH9VprlNOu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('nla1uncut6hjosbqdmloqomabp5gf8ejz1gyjsim61bneud0qg', '73qwu54zjg67vddyxfh0moq8xbqzv62ko94oj58lnrhtne4apn', '11');
-- Jasiel Nuez
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ufqhncg4bouzvcq', 'Jasiel Nuez', '250@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb730e71d60e047f1061a9e697','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:250@artist.com', 'ufqhncg4bouzvcq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ufqhncg4bouzvcq', 'The architect of aural landscapes that inspire and captivate.', 'Jasiel Nuez');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0zt7jluz4283mhtv81npng2anl1f4a6nccgukodaxtjsq7bzqn','ufqhncg4bouzvcq', NULL, 'Jasiel Nuez Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l5t65gpmydh2phjh6i738r3uklz5rplr2iilmtsj7s2nsvvpe7','LAGUNAS','ufqhncg4bouzvcq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0zt7jluz4283mhtv81npng2anl1f4a6nccgukodaxtjsq7bzqn', 'l5t65gpmydh2phjh6i738r3uklz5rplr2iilmtsj7s2nsvvpe7', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('xpts46j50g4pi1d93scwnblv7hhst9utkbd743xmw6qevwsb29','Rosa Pastel','ufqhncg4bouzvcq','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0zt7jluz4283mhtv81npng2anl1f4a6nccgukodaxtjsq7bzqn', 'xpts46j50g4pi1d93scwnblv7hhst9utkbd743xmw6qevwsb29', '1');
-- Lady Gaga
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('t60ee2rf2rxseew', 'Lady Gaga', '251@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebc8d3d98a1bccbe71393dbfbf','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:251@artist.com', 't60ee2rf2rxseew', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('t60ee2rf2rxseew', 'A beacon of innovation in the world of sound.', 'Lady Gaga');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('yhcr7mrx2x64btyfiqsgrlgm18sda5nppg3zf0rlb9df3eu43o','t60ee2rf2rxseew', 'https://i.scdn.co/image/ab67616d0000b273a47c0e156ea3cebe37fdcab8', 'Lady Gaga Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('301rp09dsb89t8dalfgd95e1lc7nrip42nthz3yunw6j3snqv6','Bloody Mary','t60ee2rf2rxseew','POP','11BKm0j4eYoCPPpCONAVwA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('yhcr7mrx2x64btyfiqsgrlgm18sda5nppg3zf0rlb9df3eu43o', '301rp09dsb89t8dalfgd95e1lc7nrip42nthz3yunw6j3snqv6', '0');
-- Sia
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('k1mx87mj3vuuu1y', 'Sia', '252@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb25a749000611559f1719cc5f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:252@artist.com', 'k1mx87mj3vuuu1y', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('k1mx87mj3vuuu1y', 'Breathing new life into classic genres.', 'Sia');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('1nkpphd5mm25m481ntw31eb3k0ywah6rx9uricizscvknz1g75','k1mx87mj3vuuu1y', 'https://i.scdn.co/image/ab67616d0000b273754b2fddebe7039fdb912837', 'Sia Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('aon9eyg3twl0xnhjyzhckg6okc6arqtgmqzdwbrrdszbjb2uka','Unstoppable','k1mx87mj3vuuu1y','POP','1yvMUkIOTeUNtNWlWRgANS','https://p.scdn.co/mp3-preview/99a07d00531c0053f55a46e94ed92b1560396754?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1nkpphd5mm25m481ntw31eb3k0ywah6rx9uricizscvknz1g75', 'aon9eyg3twl0xnhjyzhckg6okc6arqtgmqzdwbrrdszbjb2uka', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l9qqgeju15cojpwgmgba4o5dpcbg3o5w5clgx3sbol8t3o6zg4','Snowman','k1mx87mj3vuuu1y','POP','7uoFMmxln0GPXQ0AcCBXRq','https://p.scdn.co/mp3-preview/a936030efc27a4fc52d8c42b20d03ca4cab30836?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('1nkpphd5mm25m481ntw31eb3k0ywah6rx9uricizscvknz1g75', 'l9qqgeju15cojpwgmgba4o5dpcbg3o5w5clgx3sbol8t3o6zg4', '1');
-- Chino Pacas
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('tvvmzk2tsmvw6xp', 'Chino Pacas', '253@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb8ff524b416384fe673ebf52e','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:253@artist.com', 'tvvmzk2tsmvw6xp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('tvvmzk2tsmvw6xp', 'Delivering soul-stirring tunes that linger in the mind.', 'Chino Pacas');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('0n0qatbn1rfaz0af07w0iv4ptwsqd4ctfy5y1bmt2hyw0rkwp2','tvvmzk2tsmvw6xp', 'https://i.scdn.co/image/ab67616d0000b2736a6ab689151163a1e9f60f36', 'Chino Pacas Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('go9n1ap38iytqmpk6fhu0ghg0devrbpozz9dlqojbsjgi3sngh','El Gordo Trae El Mando','tvvmzk2tsmvw6xp','POP','3kf0WdFOalKWBkCCLJo4mA','https://p.scdn.co/mp3-preview/b7989992ce6651eea980627ad17b1f9a2fa2a224?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('0n0qatbn1rfaz0af07w0iv4ptwsqd4ctfy5y1bmt2hyw0rkwp2', 'go9n1ap38iytqmpk6fhu0ghg0devrbpozz9dlqojbsjgi3sngh', '0');
-- Freddie Dredd
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('zyir8z8urzqqlgq', 'Freddie Dredd', '254@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb9d100e5a9cf34beab8e75750','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:254@artist.com', 'zyir8z8urzqqlgq', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('zyir8z8urzqqlgq', 'A confluence of cultural beats and contemporary tunes.', 'Freddie Dredd');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('r4lzyc8t2640w2jt7hkimz4z22nngssx93i4obrlwz2ttjc1se','zyir8z8urzqqlgq', 'https://i.scdn.co/image/ab67616d0000b27369b381d574b329409bd806e6', 'Freddie Dredd Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('zgdpjn3ijug8qobc8u7bk9f4xfe3bgtjeiic15fve3s00wmsmf','Limbo','zyir8z8urzqqlgq','POP','37F7E7BKEw2E4O2L7u0IEp','https://p.scdn.co/mp3-preview/1715e2acb52d6fdd0e4b11ea8792688c12987ff7?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('r4lzyc8t2640w2jt7hkimz4z22nngssx93i4obrlwz2ttjc1se', 'zgdpjn3ijug8qobc8u7bk9f4xfe3bgtjeiic15fve3s00wmsmf', '0');
-- Jimin
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('eq54ck7kp9dsijk', 'Jimin', '255@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb59f8cfc8e71dcaf8c6ec4bde','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:255@artist.com', 'eq54ck7kp9dsijk', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('eq54ck7kp9dsijk', 'Known for his expressive voice and mesmerizing dance moves in BTS.', 'Jimin');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('a0wcng0s9fwah4bachk5ye2ibp53p6joga9s0burjth3igltdt','eq54ck7kp9dsijk', 'https://i.scdn.co/image/ab67616d0000b2732b46078245d0120690eb560d', 'Jimin Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9ffr693q9dnc39jlo4ugwg5au6m7sfy4qzlzudbcohb8j8ckzd','Like Crazy','eq54ck7kp9dsijk','POP','3Ua0m0YmEjrMi9XErKcNiR','https://p.scdn.co/mp3-preview/2db5f36096963d97afc870c50990d62d27858a43?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a0wcng0s9fwah4bachk5ye2ibp53p6joga9s0burjth3igltdt', '9ffr693q9dnc39jlo4ugwg5au6m7sfy4qzlzudbcohb8j8ckzd', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t7oc7v6onaeduka398br7z7mbbdrpvpqkhljntjbtrwy9oihio','Set Me Free Pt.2','eq54ck7kp9dsijk','POP','59hBR0BCtJsfIbV9VzCVAp','https://p.scdn.co/mp3-preview/275a3a0843bb55c251cda45ef17a905dab31624c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a0wcng0s9fwah4bachk5ye2ibp53p6joga9s0burjth3igltdt', 't7oc7v6onaeduka398br7z7mbbdrpvpqkhljntjbtrwy9oihio', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6gtjo4fvn6xku31spp0htxrujkmthssft4er7zdm2chkh6nnyz','Like Crazy (English Version)','eq54ck7kp9dsijk','POP','0u8rZGtXJrLtiSe34FPjGG','https://p.scdn.co/mp3-preview/3752bae14d7952abe6f93649d85d53bfe98f1165?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('a0wcng0s9fwah4bachk5ye2ibp53p6joga9s0burjth3igltdt', '6gtjo4fvn6xku31spp0htxrujkmthssft4er7zdm2chkh6nnyz', '2');
-- Lost Frequencies
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('e8vxbse4ji8vlcp', 'Lost Frequencies', '256@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebfd28880f1b1fa8f93d05eb76','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:256@artist.com', 'e8vxbse4ji8vlcp', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('e8vxbse4ji8vlcp', 'Sculpting soundwaves into masterpieces of auditory art.', 'Lost Frequencies');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('sfnui1vsrj7e7ylgozt1ks1zxj18b7qdredss8a18o4canvwv0','e8vxbse4ji8vlcp', 'https://i.scdn.co/image/ab67616d0000b2738d7a7f1855b04104ba59c18b', 'Lost Frequencies Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('8scio4bst82gb7t1li0lw4xuti2gvsse0ae427wovtjpwcm1c2','Where Are You Now','e8vxbse4ji8vlcp','POP','3uUuGVFu1V7jTQL60S1r8z','https://p.scdn.co/mp3-preview/e2646d5bc8c56e4a91582a03c089f8038772aecb?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('sfnui1vsrj7e7ylgozt1ks1zxj18b7qdredss8a18o4canvwv0', '8scio4bst82gb7t1li0lw4xuti2gvsse0ae427wovtjpwcm1c2', '0');
-- Nicky Youre
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('stagz9gkrxeanjm', 'Nicky Youre', '257@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebe726c8549d387a241f979acd','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:257@artist.com', 'stagz9gkrxeanjm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('stagz9gkrxeanjm', 'An endless quest for musical perfection.', 'Nicky Youre');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qcp2fhagvajg72ey93r9ydiq95k3i3vvftyzwjytzhs85mgl2v','stagz9gkrxeanjm', 'https://i.scdn.co/image/ab67616d0000b273ecd970d1d2623b6c7fc6080c', 'Nicky Youre Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('petdyq20wm3fm5qowogywcadz8e4dbzgyl5kmpqw8yaxiscafo','Sunroof','stagz9gkrxeanjm','POP','5YqEzk3C5c3UZ1D5fJUlXA','https://p.scdn.co/mp3-preview/605058558fd8d10c420b56c41555e567645d5b60?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qcp2fhagvajg72ey93r9ydiq95k3i3vvftyzwjytzhs85mgl2v', 'petdyq20wm3fm5qowogywcadz8e4dbzgyl5kmpqw8yaxiscafo', '0');
-- Pritam
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('a7onajd1n50rfu5', 'Pritam', '258@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcb6926f44f620555ba444fca','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:258@artist.com', 'a7onajd1n50rfu5', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('a7onajd1n50rfu5', 'Blending genres for a fresh musical experience.', 'Pritam');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('y37robhq3c9gfplczxa66rjrptdlm6w9z553yarue607b6knlb','a7onajd1n50rfu5', NULL, 'Pritam Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('2j9ywa7sl7oo1b558acnnogabso4d2b629sg276jk37bbdxlif','Kesariya (From "Brahmastra")','a7onajd1n50rfu5','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('y37robhq3c9gfplczxa66rjrptdlm6w9z553yarue607b6knlb', '2j9ywa7sl7oo1b558acnnogabso4d2b629sg276jk37bbdxlif', '0');
-- Libianca
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('81j0pzcd7ufk9s4', 'Libianca', '259@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb6a42e7c32ead029c0285c12f','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:259@artist.com', '81j0pzcd7ufk9s4', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('81j0pzcd7ufk9s4', 'A fresh talent, blending Afrobeat rhythms with soulful melodies.', 'Libianca');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('oxf740l4yidy2nw2drs3ourqfjp81hrxrxe6rxrbcpsli11k30','81j0pzcd7ufk9s4', 'https://i.scdn.co/image/ab67616d0000b273fc342f95f117d48dbdde9735', 'Libianca Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jm1kurgaxdx1zinq9trb7gme99gkl3x46i8z35aajt3f36sfxt','People','81j0pzcd7ufk9s4','POP','26b3oVLrRUaaybJulow9kz','https://p.scdn.co/mp3-preview/abcbc9adf10ae4901b40b80a30dc194d589c2d62?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('oxf740l4yidy2nw2drs3ourqfjp81hrxrxe6rxrbcpsli11k30', 'jm1kurgaxdx1zinq9trb7gme99gkl3x46i8z35aajt3f36sfxt', '0');
-- Big One
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('i1pjqt4d4npv8r2', 'Big One', '260@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebcd00b46bac23bbfbcdcd10bc','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:260@artist.com', 'i1pjqt4d4npv8r2', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('i1pjqt4d4npv8r2', 'Bringing a unique energy to every track, fusing various styles into a cohesive sound.', 'Big One');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('222eivvrdr7liddu5svmec2ccg81nsdxah761x0u51lx0s2b8j','i1pjqt4d4npv8r2', NULL, 'Big One Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('uqz3zi2uwnd401t5bo953hycp1amk3n83op2rtksdwti3ydmol','Los del Espacio','i1pjqt4d4npv8r2','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('222eivvrdr7liddu5svmec2ccg81nsdxah761x0u51lx0s2b8j', 'uqz3zi2uwnd401t5bo953hycp1amk3n83op2rtksdwti3ydmol', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0k409g3nrjsnqe7jdplipy7tz8fsmf1ch6yp6rntkkev8xu9oz','Un Finde | CROSSOVER #2','i1pjqt4d4npv8r2','POP','3tiJUOfAEqIrLFRQgGgdoY','https://p.scdn.co/mp3-preview/38b8f2c063a896c568b9741dcd6e194be0a0376b?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('222eivvrdr7liddu5svmec2ccg81nsdxah761x0u51lx0s2b8j', '0k409g3nrjsnqe7jdplipy7tz8fsmf1ch6yp6rntkkev8xu9oz', '1');
-- Arcangel
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('2szu8iljrqcw000', 'Arcangel', '261@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebafdf17286a0d7a23ad388587','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:261@artist.com', '2szu8iljrqcw000', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('2szu8iljrqcw000', 'Delivering soul-stirring tunes that linger in the mind.', 'Arcangel');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('qognxlq4meubd7vgl3c70jowqamfwn5p6jpr4siuqi0oe054pp','2szu8iljrqcw000', 'https://i.scdn.co/image/ab67616d0000b27330326b23e30ae93d4d48165b', 'Arcangel Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('v9t3lmazunu4yj8ty0mto53z0qvp265bujvebkigm922oicujt','La Jumpa','2szu8iljrqcw000','POP','2mnXxnrX5vCGolNkaFvVeM','https://p.scdn.co/mp3-preview/8bcdff4719a7a4211128ec93da03892e46c4bc6a?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qognxlq4meubd7vgl3c70jowqamfwn5p6jpr4siuqi0oe054pp', 'v9t3lmazunu4yj8ty0mto53z0qvp265bujvebkigm922oicujt', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('6pj49t71j08xd0fg9vr9coloxd4fzvb406vksabro4kc76ktqx','Arcngel: Bzrp Music Sessions, Vol','2szu8iljrqcw000','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('qognxlq4meubd7vgl3c70jowqamfwn5p6jpr4siuqi0oe054pp', '6pj49t71j08xd0fg9vr9coloxd4fzvb406vksabro4kc76ktqx', '1');
-- Troye Sivan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wz2x4of3dq6u5ch', 'Troye Sivan', '262@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb26e8cb3ff6fc7744b312811b','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:262@artist.com', 'wz2x4of3dq6u5ch', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('wz2x4of3dq6u5ch', 'A voice that encapsulates the spirit of modern pop.', 'Troye Sivan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('6vwi0lutqf4dhlp96m2sk3lfogg1xq48p6wcpaigsunrsmxf7e','wz2x4of3dq6u5ch', 'https://i.scdn.co/image/ab67616d0000b27367103283a4eb57578a428252', 'Troye Sivan Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7ykl880gakjirag73nhedrjcimlpfq9o6qidmm6w72ksy9tdu8','Rush','wz2x4of3dq6u5ch','POP','4ZnkygoWLzcGbQYCm3lkae',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('6vwi0lutqf4dhlp96m2sk3lfogg1xq48p6wcpaigsunrsmxf7e', '7ykl880gakjirag73nhedrjcimlpfq9o6qidmm6w72ksy9tdu8', '0');
-- Zach Bryan
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('iyqu0wr3ap7xqs1', 'Zach Bryan', '263@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb4fd54df35bfcfa0fc9fc2da7','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:263@artist.com', 'iyqu0wr3ap7xqs1', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('iyqu0wr3ap7xqs1', 'Breathing new life into classic genres.', 'Zach Bryan');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('8ozma3dp2wf4s1ga5gzubjg0cfziaf0mdj9a1i6z6hke1k5tvn','iyqu0wr3ap7xqs1', 'https://i.scdn.co/image/ab67616d0000b273b2b6670e3aca9bcd55fbabbb', 'Zach Bryan Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yfwkk01vfxy7mew9cccnvjfs4zndpuyrzexy9tdhcf4dku7sp4','Something in the Orange','iyqu0wr3ap7xqs1','POP','3WMj8moIAXJhHsyLaqIIHI','https://p.scdn.co/mp3-preview/d33dc9df586e24c9d8f640df08b776d94680f529?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('8ozma3dp2wf4s1ga5gzubjg0cfziaf0mdj9a1i6z6hke1k5tvn', 'yfwkk01vfxy7mew9cccnvjfs4zndpuyrzexy9tdhcf4dku7sp4', '0');
-- Keane
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ckjv45ha56vgwtc', 'Keane', '264@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb41222a45dc0b10f65cbe8160','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:264@artist.com', 'ckjv45ha56vgwtc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('ckjv45ha56vgwtc', 'A visionary in the world of music, redefining genres.', 'Keane');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('7znpwg2883tql5lo0dps64cb91melzaxef0ovyrytgjmfhpgvm','ckjv45ha56vgwtc', 'https://i.scdn.co/image/ab67616d0000b273045d0a38105fbe7bde43c490', 'Keane Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('7136zuqhxgs15q2fztg4pp5c5qhhiihnbhd0gwmvshauz5loeu','Somewhere Only We Know','ckjv45ha56vgwtc','POP','0ll8uFnc0nANY35E0Lfxvg',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('7znpwg2883tql5lo0dps64cb91melzaxef0ovyrytgjmfhpgvm', '7136zuqhxgs15q2fztg4pp5c5qhhiihnbhd0gwmvshauz5loeu', '0');
-- Marlia Mendo
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('1e6lpaecm3l6klh', 'Marlia Mendo', '265@artist.com', 'https://i.scdn.co/image/ab6761610000e5ebffaebdbc972967729f688e25','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:265@artist.com', '1e6lpaecm3l6klh', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('1e6lpaecm3l6klh', 'Weaving lyrical magic into every song.', 'Marlia Mendo');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('4d6yn1lhigjkn8encpvcjtnuqndwo76fcso3slp6g9sxid28v7','1e6lpaecm3l6klh', NULL, 'Marlia Mendo Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('az7g02twfaqk4q0zft0n9pm7w0i3mhxa2ywkn8b3x5o2dytouz','Le','1e6lpaecm3l6klh','POP',NULL,NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('4d6yn1lhigjkn8encpvcjtnuqndwo76fcso3slp6g9sxid28v7', 'az7g02twfaqk4q0zft0n9pm7w0i3mhxa2ywkn8b3x5o2dytouz', '0');
-- Taylor Swift
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('3edmx9chbcnts25', 'Taylor Swift', '266@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb859e4c14fa59296c8649e0e4','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:266@artist.com', '3edmx9chbcnts25', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('3edmx9chbcnts25', 'A storytelling icon, weaving life experiences into musical masterpieces.', 'Taylor Swift');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4','3edmx9chbcnts25', 'https://i.scdn.co/image/ab67616d0000b273e787cffec20aa2a396a61647', 'Taylor Swift Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('95hpikobptqi8cc5y7ukufx6w9uwd4dm2cp6njyq5cc7z4sz2w','Cruel Summer','3edmx9chbcnts25','POP','1BxfuPKGuaTgP7aM0Bbdwr',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', '95hpikobptqi8cc5y7ukufx6w9uwd4dm2cp6njyq5cc7z4sz2w', '0');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('znencmakhenot8ffay9dgq0i8atjngmtezsunuolbspp3w08g4','I Can See You (Taylors Version) (From The ','3edmx9chbcnts25','POP','5kHMfzgLZP95O9NBy0ku4v',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', 'znencmakhenot8ffay9dgq0i8atjngmtezsunuolbspp3w08g4', '1');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('36xmff8ffvftlunehlr6rf05jw7evd9f8ovtxhjtud5a4oxmxc','Anti-Hero','3edmx9chbcnts25','POP','0V3wPSX9ygBnCm8psDIegu',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', '36xmff8ffvftlunehlr6rf05jw7evd9f8ovtxhjtud5a4oxmxc', '2');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('k9c6pkyqgacho3rqtgx7elaihx2iog0sw0imoxcccvtzosfs6p','Blank Space','3edmx9chbcnts25','POP','1p80LdxRV74UKvL8gnD7ky',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', 'k9c6pkyqgacho3rqtgx7elaihx2iog0sw0imoxcccvtzosfs6p', '3');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('z3e6cu8qdvqnz2ayvy57rvdl61xlmq9agc6pmaol97e9fpk5wx','Style','3edmx9chbcnts25','POP','1hjRhYpWyqDpPahmSlUTlc',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', 'z3e6cu8qdvqnz2ayvy57rvdl61xlmq9agc6pmaol97e9fpk5wx', '4');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('38gtzdn02jbxbq8ny60g90d7pljhedufgsi6fj5pb0t0u3lt8c','cardigan','3edmx9chbcnts25','POP','4R2kfaDFhslZEMJqAFNpdd',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', '38gtzdn02jbxbq8ny60g90d7pljhedufgsi6fj5pb0t0u3lt8c', '5');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1goln0aykop4lwlalpazfn6feef1vndou23klmnw0qy61sogru','Karma','3edmx9chbcnts25','POP','7KokYm8cMIXCsGVmUvKtqf',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', '1goln0aykop4lwlalpazfn6feef1vndou23klmnw0qy61sogru', '6');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('0oaeabv8v3mfp59wfec53uxcpilpr3hzbbd2df8k3lkqdaif1k','Enchanted (Taylors Version)','3edmx9chbcnts25','POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', '0oaeabv8v3mfp59wfec53uxcpilpr3hzbbd2df8k3lkqdaif1k', '7');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('050wr8s8nhrvhxegxxwg67133amv05bvp5gpveo6g2ncyi4bl1','Back To December (Taylors Version)','3edmx9chbcnts25','POP','79uDOz0zuuWS7HWxzMmTa2',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', '050wr8s8nhrvhxegxxwg67133amv05bvp5gpveo6g2ncyi4bl1', '8');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('d0c1j8tfluhbjxw9t2bvvivtvx5tuwuf5t1wvyyyo2xv7wkgc7','Dont Bl','3edmx9chbcnts25','POP','59ZmeIz57cGU5Gp9omjlYB',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', 'd0c1j8tfluhbjxw9t2bvvivtvx5tuwuf5t1wvyyyo2xv7wkgc7', '9');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l9074kwg2c4u4a5hocugi2umvyj6a9vpvxqu4mjtw4vb7clfqc','Mine (Taylors Version)','3edmx9chbcnts25','POP','7G0gBu6nLdhFDPRLc0HdDG',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', 'l9074kwg2c4u4a5hocugi2umvyj6a9vpvxqu4mjtw4vb7clfqc', '10');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('t63f3m1sro5l2wmxqc2fl8cpc60dzgfsreq305u0lmuex3577d','august','3edmx9chbcnts25','POP','3hUxzQpSfdDqwM3ZTFQY0K',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', 't63f3m1sro5l2wmxqc2fl8cpc60dzgfsreq305u0lmuex3577d', '11');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('jg276ucqn51cvszzsdzmlyslna0tz0m0d91t8o2booko5bl9fr','Enchanted','3edmx9chbcnts25','POP','3sW3oSbzsfecv9XoUdGs7h',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', 'jg276ucqn51cvszzsdzmlyslna0tz0m0d91t8o2booko5bl9fr', '12');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('yu6innx3o06ms87s6brp7bqts7c5l0bfrtmsm216exdhtkxi7u','Shake It Off','3edmx9chbcnts25','POP','3pv7Q5v2dpdefwdWIvE7yH',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', 'yu6innx3o06ms87s6brp7bqts7c5l0bfrtmsm216exdhtkxi7u', '13');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('oxacni15skgddyohskmw08lplv0b6hgkjp62xgpftmy1s9dlg8','You Belong With Me (Taylors Ve','3edmx9chbcnts25','POP','1qrpoAMXodY6895hGKoUpA',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', 'oxacni15skgddyohskmw08lplv0b6hgkjp62xgpftmy1s9dlg8', '14');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('9pq9kwqaiqz9ejhuzn1p7te5xo0cc20th7hh81a38bkvozp40k','Better Than Revenge (Taylors Version)','3edmx9chbcnts25','POP','0NwGC0v03ysCYINtg6ns58',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', '9pq9kwqaiqz9ejhuzn1p7te5xo0cc20th7hh81a38bkvozp40k', '15');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('1gywnc773lbinuvs965kp9s65rh61tvft5ci9ask4xvg39e3fj','Hits Different','3edmx9chbcnts25','POP','3xYJScVfxByb61dYHTwiby',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', '1gywnc773lbinuvs965kp9s65rh61tvft5ci9ask4xvg39e3fj', '16');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('tu5f9j9o8f86qqno6nhls9xpeqoogr0yc4hz5e6yjfs0iq5na5','Karma (feat. Ice Spice)','3edmx9chbcnts25','POP','4i6cwNY6oIUU2XZxPIw82Y',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', 'tu5f9j9o8f86qqno6nhls9xpeqoogr0yc4hz5e6yjfs0iq5na5', '17');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('j4xe6tlyitd1f4339dc82ta35nkhgnl1fetcvhm3jx5xw7y1b7','Lavender Haze','3edmx9chbcnts25','POP','5jQI2r1RdgtuT8S3iG8zFC',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', 'j4xe6tlyitd1f4339dc82ta35nkhgnl1fetcvhm3jx5xw7y1b7', '18');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('r5xcdx1veehwt7njcu827ht732ee6kilgeqkr5efxkzifgshd4','All Of The Girls You Loved Before','3edmx9chbcnts25','POP','4P9Q0GojKVXpRTJCaL3kyy',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', 'r5xcdx1veehwt7njcu827ht732ee6kilgeqkr5efxkzifgshd4', '19');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('3f50yrcp7qixb91pz6iz8s0toadqmo1tvm5vti2wfq1tx8aw3q','Midnight Rain','3edmx9chbcnts25','POP','3rWDp9tBPQR9z6U5YyRSK4',NULL,'2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', '3f50yrcp7qixb91pz6iz8s0toadqmo1tvm5vti2wfq1tx8aw3q', '20');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('fjan39umoj9l4p6t6mk7uazbk4q7nexhi31g73zh10u90wrhar','Youre On Your Own, Kid','3edmx9chbcnts25','POP','1yMjWvw0LRwW5EZBPh9UyF','https://p.scdn.co/mp3-preview/cb8981007d0606f43b3051b3633f890d0a70de8c?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('ft1ne16bsrt0nu0w30emmp1zdqhl74sbhokiieydx8fogpxun4', 'fjan39umoj9l4p6t6mk7uazbk4q7nexhi31g73zh10u90wrhar', '21');
-- DJ Escobar
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('cnu3exdal0f22tg', 'DJ Escobar', '267@artist.com', 'https://i.scdn.co/image/ab6761610000e5eb62fa9c7f56a64dc956ec2621','2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:267@artist.com', 'cnu3exdal0f22tg', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "artist" ("id", "bio", "name") VALUES ('cnu3exdal0f22tg', 'Crafting a unique sonic identity in every track.', 'DJ Escobar');
INSERT INTO "album" ("id", "artist_id", "cover_image_url", "name", "created_at") VALUES ('xf73mv5pgmxmrbzqckaizr1iuj7en3xxn2az765q45a47a1sjk','cnu3exdal0f22tg', 'https://i.scdn.co/image/ab67616d0000b273769f6572dfa10ee7827edbf2', 'DJ Escobar Album','2023-11-17 17:00:08.000');
INSERT INTO "song" ("id", "name", "artist_id", "genre", "spotify_id", "preview_url", "created_at") VALUES ('l4344lm8ayrgzps56lsa63268ywt2jtuj6cnrau3mwhm8cac2y','Evoque Prata','cnu3exdal0f22tg','POP','4mQ2UZzSH3T4o4Gr9phTgL','https://p.scdn.co/mp3-preview/f2c69618853c528447f24f0102d0e5404fe31ed9?cid=6c77115735724c94af0b7a434aef3fc3','2023-11-17 17:00:08.000');
INSERT INTO "album_songs"("album_id", "song_id", "order") VALUES ('xf73mv5pgmxmrbzqckaizr1iuj7en3xxn2az765q45a47a1sjk', 'l4344lm8ayrgzps56lsa63268ywt2jtuj6cnrau3mwhm8cac2y', '0');


-- File: insert_relationships.sql
-- Users
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('n4ui9y09tewznoe', 'Ivan Johnson (0)', '0@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:0@g.com', 'n4ui9y09tewznoe', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('fg4y77qklwmyyo0', 'Bob Brown (1)', '1@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:1@g.com', 'fg4y77qklwmyyo0', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('mtpfpk9v3ev87ai', 'Edward Miller (2)', '2@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:2@g.com', 'mtpfpk9v3ev87ai', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('wf8quespmaf9ye7', 'Edward Martinez (3)', '3@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:3@g.com', 'wf8quespmaf9ye7', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('otoox1klhz0a3lm', 'Ivan Smith (4)', '4@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:4@g.com', 'otoox1klhz0a3lm', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('j4fzpxduhkq981v', 'Ivan Davis (5)', '5@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:5@g.com', 'j4fzpxduhkq981v', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('ms5gxmmwjk1a93p', 'Diana Rodriguez (6)', '6@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:6@g.com', 'ms5gxmmwjk1a93p', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('r6em9gfc7ihcq2s', 'Diana Davis (7)', '7@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:7@g.com', 'r6em9gfc7ihcq2s', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('t0mupf97ak4jsnf', 'Diana Smith (8)', '8@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:8@g.com', 't0mupf97ak4jsnf', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
INSERT INTO "auth_user" ("id", "username", "email", "profile_image_url", "created_at") VALUES ('houhask03jin4bc', 'Diana Williams (9)', '9@g.com', NULL,'2023-11-17 17:00:08.000');
INSERT INTO "user_key" ("id", "user_id", "hashed_password") VALUES ('email:9@g.com', 'houhask03jin4bc', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');
-- Playlists
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('lua9rsf1cry2v0ijzpupfr15xsysp5t2t36us5x75t50i24mye', 'Playlist 0', '2023-11-17 17:00:08.000','n4ui9y09tewznoe');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wo83e1jqo9rvrugu1bfuwxu5zdf1cm1tq6z0rnkk7rr4ogt9nj', 'lua9rsf1cry2v0ijzpupfr15xsysp5t2t36us5x75t50i24mye', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1x73hybnvcdzudozgd2u1ahir3vi9py482ozpaane6l1sizjpk', 'lua9rsf1cry2v0ijzpupfr15xsysp5t2t36us5x75t50i24mye', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('i1igdcvjfqvsvx7c4lewcuox3xu8c8eyrnqhxnqpd1y2vorb91', 'lua9rsf1cry2v0ijzpupfr15xsysp5t2t36us5x75t50i24mye', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('y15kfy5kv7hl3o3qn5jqxkaftqiz0tr01vvtm2u550nawtzq55', 'lua9rsf1cry2v0ijzpupfr15xsysp5t2t36us5x75t50i24mye', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t7oc7v6onaeduka398br7z7mbbdrpvpqkhljntjbtrwy9oihio', 'lua9rsf1cry2v0ijzpupfr15xsysp5t2t36us5x75t50i24mye', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qqsjtlzrlem0w4haiezpjzz9gzro74k6mdmxzv5w5w6q08hhn5', 'lua9rsf1cry2v0ijzpupfr15xsysp5t2t36us5x75t50i24mye', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('el6w7j1jjwz4hri7jc0nwbez1ov8bm3b7zzpeek51oi68uj4tf', 'lua9rsf1cry2v0ijzpupfr15xsysp5t2t36us5x75t50i24mye', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('w5mv28mlnqs7iqqzevasmyq65e00cldmym34hun5ri1ij75yuf', 'lua9rsf1cry2v0ijzpupfr15xsysp5t2t36us5x75t50i24mye', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ijlv1jzuzad4kax4svm9lpy76uqclhv697igwn787as2qith0z', 'lua9rsf1cry2v0ijzpupfr15xsysp5t2t36us5x75t50i24mye', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('a05jrhcj9na8u0rqveghjna98jwimfom1n3dv88c8mh4q09epp', 'lua9rsf1cry2v0ijzpupfr15xsysp5t2t36us5x75t50i24mye', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('fy940kw85jdrpxalhg5t6chh8t1u35tr2qxehxucykwc71w4kw', 'Playlist 1', '2023-11-17 17:00:08.000','n4ui9y09tewznoe');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9vuh6w7v5bxshur88ifj51xtfyju5hx623ryq9notyth7olz7t', 'fy940kw85jdrpxalhg5t6chh8t1u35tr2qxehxucykwc71w4kw', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('c7oxh0xmmlld2mvbx54gafyq2bh16ohnzid26uqe9m81kxbeq0', 'fy940kw85jdrpxalhg5t6chh8t1u35tr2qxehxucykwc71w4kw', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jg276ucqn51cvszzsdzmlyslna0tz0m0d91t8o2booko5bl9fr', 'fy940kw85jdrpxalhg5t6chh8t1u35tr2qxehxucykwc71w4kw', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qsq58ak71ljkznw7awb6nf8b1u4j7dskm06lza2i30te3ifm25', 'fy940kw85jdrpxalhg5t6chh8t1u35tr2qxehxucykwc71w4kw', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xl9cub5nz2m7waakwir1hy4d4xf6v2t12ribjws4te0u1pcsr8', 'fy940kw85jdrpxalhg5t6chh8t1u35tr2qxehxucykwc71w4kw', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nhrhegnrrq3jmw63ultlz5cyjlbuuspqza5crs0c6k3y1n72kw', 'fy940kw85jdrpxalhg5t6chh8t1u35tr2qxehxucykwc71w4kw', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e4hv9dwpp7ba2smkn2wi64nekjlixcesjyph393s7l6w89dt6p', 'fy940kw85jdrpxalhg5t6chh8t1u35tr2qxehxucykwc71w4kw', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1gywnc773lbinuvs965kp9s65rh61tvft5ci9ask4xvg39e3fj', 'fy940kw85jdrpxalhg5t6chh8t1u35tr2qxehxucykwc71w4kw', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('w5mv28mlnqs7iqqzevasmyq65e00cldmym34hun5ri1ij75yuf', 'fy940kw85jdrpxalhg5t6chh8t1u35tr2qxehxucykwc71w4kw', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dpwglkq7o72ib6prvu2m9mchkj1wjk2s8a02u9106kx1kg2eiv', 'fy940kw85jdrpxalhg5t6chh8t1u35tr2qxehxucykwc71w4kw', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('33evw1q1xk68zmnftg0v52ty5kmjn05o33z7ekzlvz57l8l20b', 'Playlist 0', '2023-11-17 17:00:08.000','fg4y77qklwmyyo0');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xq5wwa3aktll156lnrh6q8h9fvokluw5n9g4f4up731x4r4ryt', '33evw1q1xk68zmnftg0v52ty5kmjn05o33z7ekzlvz57l8l20b', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dhmiav2hrqda3t1dn8vc1z2o1rin73btmhf9egnszkb6mzbxlb', '33evw1q1xk68zmnftg0v52ty5kmjn05o33z7ekzlvz57l8l20b', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('by17bv6hcqp2wiwylrm5l0vu27hw036l9mo7h0feofep0cd9gi', '33evw1q1xk68zmnftg0v52ty5kmjn05o33z7ekzlvz57l8l20b', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7136zuqhxgs15q2fztg4pp5c5qhhiihnbhd0gwmvshauz5loeu', '33evw1q1xk68zmnftg0v52ty5kmjn05o33z7ekzlvz57l8l20b', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('s9d7fbgutro5dwkcwl75oy8n80fw9kps6yx6f7ujkvk6y3lg1a', '33evw1q1xk68zmnftg0v52ty5kmjn05o33z7ekzlvz57l8l20b', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bn0v8pa36vwg5zkyoh1lm7zn5qg70znxxcnxpo6flo6befa2u6', '33evw1q1xk68zmnftg0v52ty5kmjn05o33z7ekzlvz57l8l20b', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wp7op9n7eqfu6lwlh3i7x2dcz9uuzjimk68in4fc13wh14to8p', '33evw1q1xk68zmnftg0v52ty5kmjn05o33z7ekzlvz57l8l20b', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8u5oz5e0479b9e9f58yemwuqvdp4etqjsp587hx07tiy0s4uc7', '33evw1q1xk68zmnftg0v52ty5kmjn05o33z7ekzlvz57l8l20b', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ehmxjjjy240qewrckcvzrmemo68k7dd7jclunqspf1yrq1ry82', '33evw1q1xk68zmnftg0v52ty5kmjn05o33z7ekzlvz57l8l20b', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nhrhegnrrq3jmw63ultlz5cyjlbuuspqza5crs0c6k3y1n72kw', '33evw1q1xk68zmnftg0v52ty5kmjn05o33z7ekzlvz57l8l20b', 5);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('6ohbzubq4hrtdakxckfhfxr8kmzomsofik82e3un77m9m9x3yd', 'Playlist 1', '2023-11-17 17:00:08.000','fg4y77qklwmyyo0');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d9huouenp4s2o836krea8bthal2eoxb5135gd5nnryj934amy2', '6ohbzubq4hrtdakxckfhfxr8kmzomsofik82e3un77m9m9x3yd', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3prmlvh71oh9pi14m004a25clgrvdonrmtl3fti42cr216xo4n', '6ohbzubq4hrtdakxckfhfxr8kmzomsofik82e3un77m9m9x3yd', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('27lb7e4fcs572r3nte0ue6zj2tyli4irt2xu6xc2csb5nbsulr', '6ohbzubq4hrtdakxckfhfxr8kmzomsofik82e3un77m9m9x3yd', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hq8pwj9b50a7y60s149scr4ar4mytxmafpxdlzdb7jhvxl0nbg', '6ohbzubq4hrtdakxckfhfxr8kmzomsofik82e3un77m9m9x3yd', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2j9ywa7sl7oo1b558acnnogabso4d2b629sg276jk37bbdxlif', '6ohbzubq4hrtdakxckfhfxr8kmzomsofik82e3un77m9m9x3yd', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0k409g3nrjsnqe7jdplipy7tz8fsmf1ch6yp6rntkkev8xu9oz', '6ohbzubq4hrtdakxckfhfxr8kmzomsofik82e3un77m9m9x3yd', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('re5y4b2n9ju2e2twudjb28n6uurt1f5pi9jczu9ohmljj2kjb0', '6ohbzubq4hrtdakxckfhfxr8kmzomsofik82e3un77m9m9x3yd', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e04mfvgsvtf8vzf9gg85z8u6jldxtvh0xbpy123xs3mg21b6s1', '6ohbzubq4hrtdakxckfhfxr8kmzomsofik82e3un77m9m9x3yd', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2t1idvzb90q2o22fur4g3l43l01sks2myce2tqip6a8321drea', '6ohbzubq4hrtdakxckfhfxr8kmzomsofik82e3un77m9m9x3yd', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r4e5a719qhhyhkefmdvsjmz303t3gcmp34rjrpbnwkgcce9f0c', '6ohbzubq4hrtdakxckfhfxr8kmzomsofik82e3un77m9m9x3yd', 5);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('6svi29v19v636ixj69zkxsijapijjr48k212w4ebelx753juqt', 'Playlist 0', '2023-11-17 17:00:08.000','mtpfpk9v3ev87ai');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('g4klk7sah7zs0p0mzkzorke9qt2ei1c3k3j4lawyutvz3s0tgj', '6svi29v19v636ixj69zkxsijapijjr48k212w4ebelx753juqt', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('64ggjxhjrnxl3jbzvezd9g70x9g74qjwj16xjb1005lcsyd35a', '6svi29v19v636ixj69zkxsijapijjr48k212w4ebelx753juqt', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('z5sv63z2o7jkpcolhgl7rpvs22kzkwf6poigryrllbwuwrwynd', '6svi29v19v636ixj69zkxsijapijjr48k212w4ebelx753juqt', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pkf67tdsba7xz9m36ph9zgdulvt0jvk1km87lm7ljy74bvbqyf', '6svi29v19v636ixj69zkxsijapijjr48k212w4ebelx753juqt', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('teyprcjqx3mbxl74qocdr15flaf3axc4mgmqmcz73lf4gvaoov', '6svi29v19v636ixj69zkxsijapijjr48k212w4ebelx753juqt', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cxwl16nzerr5zr8w0ewjd7h8zgowjiumidji7j0ja5fp59chcr', '6svi29v19v636ixj69zkxsijapijjr48k212w4ebelx753juqt', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ct4mfn0fwo0ekbpd0jgja722a23msfay9yw8ittvjen70leyqb', '6svi29v19v636ixj69zkxsijapijjr48k212w4ebelx753juqt', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('v3mm2ltnh46vewwp01l8w7et7w8bv6pexo4iyhhledechxa6ax', '6svi29v19v636ixj69zkxsijapijjr48k212w4ebelx753juqt', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3prmlvh71oh9pi14m004a25clgrvdonrmtl3fti42cr216xo4n', '6svi29v19v636ixj69zkxsijapijjr48k212w4ebelx753juqt', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gckflgsm9568j2l7xla4bghjhieed65d9a374cq8m98ga5mwaw', '6svi29v19v636ixj69zkxsijapijjr48k212w4ebelx753juqt', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('rblgnpoap08xv5r8ip82kjvrm1rrm77baj0yjugg2fpcajhe08', 'Playlist 1', '2023-11-17 17:00:08.000','mtpfpk9v3ev87ai');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8u5oz5e0479b9e9f58yemwuqvdp4etqjsp587hx07tiy0s4uc7', 'rblgnpoap08xv5r8ip82kjvrm1rrm77baj0yjugg2fpcajhe08', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nn1tz74r7nt9hevtn2rnjy8hop5snb1x48pt6ba3c0eq64drg1', 'rblgnpoap08xv5r8ip82kjvrm1rrm77baj0yjugg2fpcajhe08', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('uq3gfi2wu06i2th3jjkbgdig7o13pus0ur70dkpsqfn4rhs9kb', 'rblgnpoap08xv5r8ip82kjvrm1rrm77baj0yjugg2fpcajhe08', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6pj49t71j08xd0fg9vr9coloxd4fzvb406vksabro4kc76ktqx', 'rblgnpoap08xv5r8ip82kjvrm1rrm77baj0yjugg2fpcajhe08', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0aqziizjurne1svinvtcma19t4qlby4tuf816wjrftc66yf75b', 'rblgnpoap08xv5r8ip82kjvrm1rrm77baj0yjugg2fpcajhe08', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('31uziyypet8i6je8n8cboa5m4xf8cqomtna12rtu720xjl916h', 'rblgnpoap08xv5r8ip82kjvrm1rrm77baj0yjugg2fpcajhe08', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vj836qzdx5ffhh7db8zubent4relm1h4kfma9e2uv8l7ajc58j', 'rblgnpoap08xv5r8ip82kjvrm1rrm77baj0yjugg2fpcajhe08', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wo83e1jqo9rvrugu1bfuwxu5zdf1cm1tq6z0rnkk7rr4ogt9nj', 'rblgnpoap08xv5r8ip82kjvrm1rrm77baj0yjugg2fpcajhe08', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('az7g02twfaqk4q0zft0n9pm7w0i3mhxa2ywkn8b3x5o2dytouz', 'rblgnpoap08xv5r8ip82kjvrm1rrm77baj0yjugg2fpcajhe08', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('n1pc1j4m54nush0j0u29weonc1l9vlv88xfy6c1kf9xd7bxswv', 'rblgnpoap08xv5r8ip82kjvrm1rrm77baj0yjugg2fpcajhe08', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('sajpafjosom37tg5d43w2zgcbhy81k8cmeqc7xlsq6a2754i8a', 'Playlist 0', '2023-11-17 17:00:08.000','wf8quespmaf9ye7');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dpmnutiig5nt65p5bnoj4eo3thby43tywbz0u433g3ospc6se5', 'sajpafjosom37tg5d43w2zgcbhy81k8cmeqc7xlsq6a2754i8a', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('el6w7j1jjwz4hri7jc0nwbez1ov8bm3b7zzpeek51oi68uj4tf', 'sajpafjosom37tg5d43w2zgcbhy81k8cmeqc7xlsq6a2754i8a', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0947vd9etovbu63m0oc10p5mbh04xpatwzuwvcwiqse8chpdlv', 'sajpafjosom37tg5d43w2zgcbhy81k8cmeqc7xlsq6a2754i8a', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0gd2qid8lkhpfslsmfcx6jripja4dt49pczwn84bv58cltyuxw', 'sajpafjosom37tg5d43w2zgcbhy81k8cmeqc7xlsq6a2754i8a', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('w7ufo2fe7iouo6qkm908uzeepa5x8dg68lcn6ho4khijj6svo7', 'sajpafjosom37tg5d43w2zgcbhy81k8cmeqc7xlsq6a2754i8a', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('az9eyw4nmtf6gth96fle0027ttanooo8o1r9qzf8s9phtjbvz8', 'sajpafjosom37tg5d43w2zgcbhy81k8cmeqc7xlsq6a2754i8a', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3b7ls661xqtcyrylvoe91jj1sxvabjj56m1s1k1wcxscyhkkt8', 'sajpafjosom37tg5d43w2zgcbhy81k8cmeqc7xlsq6a2754i8a', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hz0k0sheec30jepugrmecfv0ilpwzqb2sfqjwpvg74xvrq8pab', 'sajpafjosom37tg5d43w2zgcbhy81k8cmeqc7xlsq6a2754i8a', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jaxv3cy5tbdbdkb5a1y4p8lslvh6ng5nbk3jq6pry1orb3f2ng', 'sajpafjosom37tg5d43w2zgcbhy81k8cmeqc7xlsq6a2754i8a', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vkamquopy5s0de86merfczhraksxqsgwchtjg7ntr1uohhwdw1', 'sajpafjosom37tg5d43w2zgcbhy81k8cmeqc7xlsq6a2754i8a', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('0tajda31rueybtavyd4dtcx3izbwckn2spznvvkqydf6z0z7q3', 'Playlist 1', '2023-11-17 17:00:08.000','wf8quespmaf9ye7');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ohfigcjwhbd5fm4gld4js12pkoefqqeo1r7i7v7dws6hpwhz8o', '0tajda31rueybtavyd4dtcx3izbwckn2spznvvkqydf6z0z7q3', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('x0qq38diwekysgihz5zmuugtrmv910imr423w27s1h37687sil', '0tajda31rueybtavyd4dtcx3izbwckn2spznvvkqydf6z0z7q3', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('he4c571b901plou2g7t8hnt444lf8df94g271pp7owsgudebh4', '0tajda31rueybtavyd4dtcx3izbwckn2spznvvkqydf6z0z7q3', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8ar7nz3b747qg0xfe7ku1r16cdwzel118y49wihdg67so7n1nu', '0tajda31rueybtavyd4dtcx3izbwckn2spznvvkqydf6z0z7q3', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mvm6mc0bseaxl4hku2kth9j6h8abw46eu7zn6ycpscajrihn0q', '0tajda31rueybtavyd4dtcx3izbwckn2spznvvkqydf6z0z7q3', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('flhyzba4yefqvgyo99jqa3exjdimr6p4zweoxosmn47sy28d5s', '0tajda31rueybtavyd4dtcx3izbwckn2spznvvkqydf6z0z7q3', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('62yhc2gvdwk90eld7l2vyrn6o9nbsw7yrr96pf9pvq7m6517gm', '0tajda31rueybtavyd4dtcx3izbwckn2spznvvkqydf6z0z7q3', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ixq4fox8myilqbdep9t5zmcopd3myo34azwm2v7j7265exex4r', '0tajda31rueybtavyd4dtcx3izbwckn2spznvvkqydf6z0z7q3', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('o44do1mlvz6vlzrls8qs9ucx62sft094xmpha8n8siau22iai9', '0tajda31rueybtavyd4dtcx3izbwckn2spznvvkqydf6z0z7q3', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('w5mv28mlnqs7iqqzevasmyq65e00cldmym34hun5ri1ij75yuf', '0tajda31rueybtavyd4dtcx3izbwckn2spznvvkqydf6z0z7q3', 3);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('qdu611xzoylgg44w97m80gux79d7tqexq5iz38qr7kpnqopn4k', 'Playlist 0', '2023-11-17 17:00:08.000','otoox1klhz0a3lm');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t37flcy10wqn28bwds547g6apcxo2ozqvuohvet50jcdg3gs71', 'qdu611xzoylgg44w97m80gux79d7tqexq5iz38qr7kpnqopn4k', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ir3mtjrdkpp7130rw1aqu8fdpy6s92mpaafwa0kx8iozfcrbdh', 'qdu611xzoylgg44w97m80gux79d7tqexq5iz38qr7kpnqopn4k', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7qg23ucevqx4ym17f0eaol2iydvghshk0nrmrtagzxirrdg0rf', 'qdu611xzoylgg44w97m80gux79d7tqexq5iz38qr7kpnqopn4k', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('iu0335gc5v1y1qcjm5yi964vhkchu8jijz4icb5zdrbr5h71l7', 'qdu611xzoylgg44w97m80gux79d7tqexq5iz38qr7kpnqopn4k', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('k9c6pkyqgacho3rqtgx7elaihx2iog0sw0imoxcccvtzosfs6p', 'qdu611xzoylgg44w97m80gux79d7tqexq5iz38qr7kpnqopn4k', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vqlu5f6o2qxbgrihaumwpqoj49zseu6p3c4xkho6eh7vqj9qnj', 'qdu611xzoylgg44w97m80gux79d7tqexq5iz38qr7kpnqopn4k', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('72k6ujq345r7npmepmn9vjyynt0bvgffiqttajoe8xnz6tgnfb', 'qdu611xzoylgg44w97m80gux79d7tqexq5iz38qr7kpnqopn4k', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r5xcdx1veehwt7njcu827ht732ee6kilgeqkr5efxkzifgshd4', 'qdu611xzoylgg44w97m80gux79d7tqexq5iz38qr7kpnqopn4k', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ijt4z4euw3t4mrlbatqwk60r3itvdtlwjt3b12wp78h40h0tia', 'qdu611xzoylgg44w97m80gux79d7tqexq5iz38qr7kpnqopn4k', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('40ahyvzgnnt3ro82uw0ckbgs6nq2p1d980slrneli3upg4o0fy', 'qdu611xzoylgg44w97m80gux79d7tqexq5iz38qr7kpnqopn4k', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('a75b05t30v2hojsaca7ri40zf47cr0ch51x8twfsmi61lrt4qa', 'Playlist 1', '2023-11-17 17:00:08.000','otoox1klhz0a3lm');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('a8rqbhlplom4871qoezhzeujazr7c1in374h4ppmfkjhiithif', 'a75b05t30v2hojsaca7ri40zf47cr0ch51x8twfsmi61lrt4qa', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('50w1ncf5p36v4ez1ev79h7ro8i1siw19snbf5u75p20w86ygcu', 'a75b05t30v2hojsaca7ri40zf47cr0ch51x8twfsmi61lrt4qa', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('29nc08a6wbhjn96ilxrqe0tb1dxpbgijqsw2aq4eyk011ddx9o', 'a75b05t30v2hojsaca7ri40zf47cr0ch51x8twfsmi61lrt4qa', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ikbzd4rpn0z74d9678eeqredsldjbyxnnerx8pfcgxtspeaj2x', 'a75b05t30v2hojsaca7ri40zf47cr0ch51x8twfsmi61lrt4qa', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t37flcy10wqn28bwds547g6apcxo2ozqvuohvet50jcdg3gs71', 'a75b05t30v2hojsaca7ri40zf47cr0ch51x8twfsmi61lrt4qa', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('crfekst9t9wfvp11e7rx0rv0y834eqvoy664m14aucrjbqq2p1', 'a75b05t30v2hojsaca7ri40zf47cr0ch51x8twfsmi61lrt4qa', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('i1igdcvjfqvsvx7c4lewcuox3xu8c8eyrnqhxnqpd1y2vorb91', 'a75b05t30v2hojsaca7ri40zf47cr0ch51x8twfsmi61lrt4qa', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7y7dmrlgqx48vvpkejeltwupae9zbvnrvswm4ohxroc65r2d77', 'a75b05t30v2hojsaca7ri40zf47cr0ch51x8twfsmi61lrt4qa', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gn6xra0idvco34l9hna2pkpn5qd0c56xnfkcdh5q65e7kps8mo', 'a75b05t30v2hojsaca7ri40zf47cr0ch51x8twfsmi61lrt4qa', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dtx0abc7034pvxkpi6qe3tn3v4f0f8duvjepepfdoa0pbp0om1', 'a75b05t30v2hojsaca7ri40zf47cr0ch51x8twfsmi61lrt4qa', 2);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('itxz5quxxdl3m3p3im9456vl5lwq5ehpr5pe487y5uf65srqva', 'Playlist 0', '2023-11-17 17:00:08.000','j4fzpxduhkq981v');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('8ar7nz3b747qg0xfe7ku1r16cdwzel118y49wihdg67so7n1nu', 'itxz5quxxdl3m3p3im9456vl5lwq5ehpr5pe487y5uf65srqva', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('n1pc1j4m54nush0j0u29weonc1l9vlv88xfy6c1kf9xd7bxswv', 'itxz5quxxdl3m3p3im9456vl5lwq5ehpr5pe487y5uf65srqva', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6tj8lqggjeck8vunas2zcuh11ng7yq6fl8x2briqx3m37464ln', 'itxz5quxxdl3m3p3im9456vl5lwq5ehpr5pe487y5uf65srqva', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('pu7srdo8v6aoo7rg0u1xc7h7xetn5894hyd50u97k6a8womk0n', 'itxz5quxxdl3m3p3im9456vl5lwq5ehpr5pe487y5uf65srqva', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('flhyzba4yefqvgyo99jqa3exjdimr6p4zweoxosmn47sy28d5s', 'itxz5quxxdl3m3p3im9456vl5lwq5ehpr5pe487y5uf65srqva', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9hav66ls1twtfhlzmomntmb6vhnxh1gi9ka0nyg5axceo2q1uz', 'itxz5quxxdl3m3p3im9456vl5lwq5ehpr5pe487y5uf65srqva', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bc7z1a9wiz3rizraqpomy4nsyp8rqzd88p1gmaan52kwf8cban', 'itxz5quxxdl3m3p3im9456vl5lwq5ehpr5pe487y5uf65srqva', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('rs63z6t5mbcavvueykkvdp2ukup7hh8y9bdl3z3v7h2xv1ydzt', 'itxz5quxxdl3m3p3im9456vl5lwq5ehpr5pe487y5uf65srqva', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('nhrhegnrrq3jmw63ultlz5cyjlbuuspqza5crs0c6k3y1n72kw', 'itxz5quxxdl3m3p3im9456vl5lwq5ehpr5pe487y5uf65srqva', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7enstw7704q8wyvcjxcpr4h39dgkx5783nl78h3oko71ak9h3r', 'itxz5quxxdl3m3p3im9456vl5lwq5ehpr5pe487y5uf65srqva', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('6focc76bdirsicpzrsgncnjz024f21djsupqhm3mt0gvmwxl8k', 'Playlist 1', '2023-11-17 17:00:08.000','j4fzpxduhkq981v');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('petdyq20wm3fm5qowogywcadz8e4dbzgyl5kmpqw8yaxiscafo', '6focc76bdirsicpzrsgncnjz024f21djsupqhm3mt0gvmwxl8k', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('glc1whvd9jfp6tx41hwu0zcehpxsfk3fp7fhiz6ioqco0yoprh', '6focc76bdirsicpzrsgncnjz024f21djsupqhm3mt0gvmwxl8k', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('lk9a6i2bczfr05nx1688x4lj54xixlafk6mu5kjgi4znwsi8k1', '6focc76bdirsicpzrsgncnjz024f21djsupqhm3mt0gvmwxl8k', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('blqgip7ww9m3mttfealjjk4vjmdkadt2o2y5z896lron86n0sn', '6focc76bdirsicpzrsgncnjz024f21djsupqhm3mt0gvmwxl8k', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3771zugyonkpqehqunoztsw5fnwxk4gw2u0v739tq0xebr6zrd', '6focc76bdirsicpzrsgncnjz024f21djsupqhm3mt0gvmwxl8k', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9vuh6w7v5bxshur88ifj51xtfyju5hx623ryq9notyth7olz7t', '6focc76bdirsicpzrsgncnjz024f21djsupqhm3mt0gvmwxl8k', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('n1pc1j4m54nush0j0u29weonc1l9vlv88xfy6c1kf9xd7bxswv', '6focc76bdirsicpzrsgncnjz024f21djsupqhm3mt0gvmwxl8k', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('akps2z50jq1w8gfaj5k2g4t3eskoxuo1qtm8l85oatkqz69iyz', '6focc76bdirsicpzrsgncnjz024f21djsupqhm3mt0gvmwxl8k', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wlp4ikdae0r2g97bntbf9747ws6p39rh38rwu3uid0qcaagp23', '6focc76bdirsicpzrsgncnjz024f21djsupqhm3mt0gvmwxl8k', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('rhbtzdfpvyh2pd42xh4lh3rsywwy1gskw0naj9oaufs3leknx4', '6focc76bdirsicpzrsgncnjz024f21djsupqhm3mt0gvmwxl8k', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('uvo54cveiiwcuv441bpcbrrs93hedmxaiuge1aizdodawr4hr2', 'Playlist 0', '2023-11-17 17:00:08.000','ms5gxmmwjk1a93p');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9hav66ls1twtfhlzmomntmb6vhnxh1gi9ka0nyg5axceo2q1uz', 'uvo54cveiiwcuv441bpcbrrs93hedmxaiuge1aizdodawr4hr2', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('89hcqnkqya2dbm40wp571o3tmkl82jdashhbl9q3pzho9omolu', 'uvo54cveiiwcuv441bpcbrrs93hedmxaiuge1aizdodawr4hr2', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('az9eyw4nmtf6gth96fle0027ttanooo8o1r9qzf8s9phtjbvz8', 'uvo54cveiiwcuv441bpcbrrs93hedmxaiuge1aizdodawr4hr2', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('6m3ii1mc29c9mdjyrts7m39u4m6rrk1twbq6283nub2p20hgtb', 'uvo54cveiiwcuv441bpcbrrs93hedmxaiuge1aizdodawr4hr2', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qrgy2q6xe1hxx010pctellgmyik9ofbpuxmidw52zclox7xaik', 'uvo54cveiiwcuv441bpcbrrs93hedmxaiuge1aizdodawr4hr2', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('12e6ck12shndf4878ly7v7hkh6zdk0bh1q2zxmdttk3tepq136', 'uvo54cveiiwcuv441bpcbrrs93hedmxaiuge1aizdodawr4hr2', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('by17bv6hcqp2wiwylrm5l0vu27hw036l9mo7h0feofep0cd9gi', 'uvo54cveiiwcuv441bpcbrrs93hedmxaiuge1aizdodawr4hr2', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ffvmk74m1yijmzw6cuonwth30do5k745eribquqd054w2nz9eh', 'uvo54cveiiwcuv441bpcbrrs93hedmxaiuge1aizdodawr4hr2', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5lw4g0azbyaf74ddpohr18x47ylx7sjke4xfqzi9ug24mxznek', 'uvo54cveiiwcuv441bpcbrrs93hedmxaiuge1aizdodawr4hr2', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('dpmnutiig5nt65p5bnoj4eo3thby43tywbz0u433g3ospc6se5', 'uvo54cveiiwcuv441bpcbrrs93hedmxaiuge1aizdodawr4hr2', 2);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('kkdz3uqtz93a17umhsbeseert3tl1j4jhef6r7wfoytk4vxkyu', 'Playlist 1', '2023-11-17 17:00:08.000','ms5gxmmwjk1a93p');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7oyrvv8bbh6e9ce09aifwa7sdpdlk27s2dc2z09klxzjqjd9z2', 'kkdz3uqtz93a17umhsbeseert3tl1j4jhef6r7wfoytk4vxkyu', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yjk2ixdni9kuqkk28b8lbznys2x3iku4zmtnmbgp8g0jsg9q71', 'kkdz3uqtz93a17umhsbeseert3tl1j4jhef6r7wfoytk4vxkyu', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5d77j0co1tih6nw7t4mqmql03crxhnulxvmy2fobqo013ash2w', 'kkdz3uqtz93a17umhsbeseert3tl1j4jhef6r7wfoytk4vxkyu', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('h58x49c03xpo5g5yzkk26r4o2mw3n2tvol3bcoe5d0js4p6eto', 'kkdz3uqtz93a17umhsbeseert3tl1j4jhef6r7wfoytk4vxkyu', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('64ggjxhjrnxl3jbzvezd9g70x9g74qjwj16xjb1005lcsyd35a', 'kkdz3uqtz93a17umhsbeseert3tl1j4jhef6r7wfoytk4vxkyu', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qagz8oflzmfjfks2x42di8tnef5pvrc5f4s59tcpdhusgg9f5v', 'kkdz3uqtz93a17umhsbeseert3tl1j4jhef6r7wfoytk4vxkyu', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('37h7pez8fiokqanqykkxh3gxmt0b5t6c8cma4ylgr64e9rqu1q', 'kkdz3uqtz93a17umhsbeseert3tl1j4jhef6r7wfoytk4vxkyu', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7wp81yt7rzfx79uukpqrtr5oxh4cdpoly9u7h0su1z3lnutkvs', 'kkdz3uqtz93a17umhsbeseert3tl1j4jhef6r7wfoytk4vxkyu', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vqlu5f6o2qxbgrihaumwpqoj49zseu6p3c4xkho6eh7vqj9qnj', 'kkdz3uqtz93a17umhsbeseert3tl1j4jhef6r7wfoytk4vxkyu', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('qsq58ak71ljkznw7awb6nf8b1u4j7dskm06lza2i30te3ifm25', 'kkdz3uqtz93a17umhsbeseert3tl1j4jhef6r7wfoytk4vxkyu', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('1dmh30uehli04ixur6k9je2oqg8a3f7yb0pbk6gp7vpkkkdbp3', 'Playlist 0', '2023-11-17 17:00:08.000','r6em9gfc7ihcq2s');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('x0qq38diwekysgihz5zmuugtrmv910imr423w27s1h37687sil', '1dmh30uehli04ixur6k9je2oqg8a3f7yb0pbk6gp7vpkkkdbp3', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d316n05w99qzkb6vozdp2thi10kpbooyuwfhxt3np45580n3ib', '1dmh30uehli04ixur6k9je2oqg8a3f7yb0pbk6gp7vpkkkdbp3', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('htgr52tfobbffc2uhy5n82kd8npvoi3dqt8fom8iv5cmtczs2r', '1dmh30uehli04ixur6k9je2oqg8a3f7yb0pbk6gp7vpkkkdbp3', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xnrg8lvb6cew8tvxnxhts6iinyv1ceqz3sl86me711r38msvtl', '1dmh30uehli04ixur6k9je2oqg8a3f7yb0pbk6gp7vpkkkdbp3', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5qa7s16wr48m07brflaog5nlo1z4f1uk3dir08ok13fuf8sni0', '1dmh30uehli04ixur6k9je2oqg8a3f7yb0pbk6gp7vpkkkdbp3', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7qg23ucevqx4ym17f0eaol2iydvghshk0nrmrtagzxirrdg0rf', '1dmh30uehli04ixur6k9je2oqg8a3f7yb0pbk6gp7vpkkkdbp3', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('a05jrhcj9na8u0rqveghjna98jwimfom1n3dv88c8mh4q09epp', '1dmh30uehli04ixur6k9je2oqg8a3f7yb0pbk6gp7vpkkkdbp3', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('oyu07zi03vy5ecqw99atyfd9n8d2tqk6glql6k5155g248gf9b', '1dmh30uehli04ixur6k9je2oqg8a3f7yb0pbk6gp7vpkkkdbp3', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wo83e1jqo9rvrugu1bfuwxu5zdf1cm1tq6z0rnkk7rr4ogt9nj', '1dmh30uehli04ixur6k9je2oqg8a3f7yb0pbk6gp7vpkkkdbp3', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('gy03q7x1ldjnbvzmmotvsa52vosroh8sb9a0kyxqzvn37ejlg0', '1dmh30uehli04ixur6k9je2oqg8a3f7yb0pbk6gp7vpkkkdbp3', 5);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('j5j2i0g0lm39m0acp8oi386zs1ah3eo8eld21wu880ln5eqfek', 'Playlist 1', '2023-11-17 17:00:08.000','r6em9gfc7ihcq2s');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9hav66ls1twtfhlzmomntmb6vhnxh1gi9ka0nyg5axceo2q1uz', 'j5j2i0g0lm39m0acp8oi386zs1ah3eo8eld21wu880ln5eqfek', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4c36inhkdfqo41edyk07cv05edt3re00zgy3usthkfpgn9mjkp', 'j5j2i0g0lm39m0acp8oi386zs1ah3eo8eld21wu880ln5eqfek', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('flhyzba4yefqvgyo99jqa3exjdimr6p4zweoxosmn47sy28d5s', 'j5j2i0g0lm39m0acp8oi386zs1ah3eo8eld21wu880ln5eqfek', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('szjx3xcc2723guta1kc861oqzougg0o44e08cearn9cc9gdzd2', 'j5j2i0g0lm39m0acp8oi386zs1ah3eo8eld21wu880ln5eqfek', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vyime8h1d3h9b5njzilxpaocd20l93a0hg82mboc7m7ad95suo', 'j5j2i0g0lm39m0acp8oi386zs1ah3eo8eld21wu880ln5eqfek', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ejddz9j19w1914h2b0nqnt2e6l47grl5ky37xfhztq21jr9b9h', 'j5j2i0g0lm39m0acp8oi386zs1ah3eo8eld21wu880ln5eqfek', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('wol9xb7bkveftqtw9gpdmk51h1qrbhgi6tv56wg7h38f7qz5di', 'j5j2i0g0lm39m0acp8oi386zs1ah3eo8eld21wu880ln5eqfek', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ps81bqb2ftewpmkwpijqeb78x9anz4zjwep6hqr7k0eokrwhfj', 'j5j2i0g0lm39m0acp8oi386zs1ah3eo8eld21wu880ln5eqfek', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e4hv9dwpp7ba2smkn2wi64nekjlixcesjyph393s7l6w89dt6p', 'j5j2i0g0lm39m0acp8oi386zs1ah3eo8eld21wu880ln5eqfek', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1x33wcqtb4g6zj0ilu7c8fjdbsi29jdikfps632gdaef7p1dnn', 'j5j2i0g0lm39m0acp8oi386zs1ah3eo8eld21wu880ln5eqfek', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('tk97v4hu2n9hxtv00ckr5flkezl67m6r2f5vn4oovmdp8d93ek', 'Playlist 0', '2023-11-17 17:00:08.000','t0mupf97ak4jsnf');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mn0y0qwlc9ml26smlnddx0n4q4mik3by57gybtv3ev87ub73ue', 'tk97v4hu2n9hxtv00ckr5flkezl67m6r2f5vn4oovmdp8d93ek', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('hq8pwj9b50a7y60s149scr4ar4mytxmafpxdlzdb7jhvxl0nbg', 'tk97v4hu2n9hxtv00ckr5flkezl67m6r2f5vn4oovmdp8d93ek', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('usrfhqt4ltjybc1r4tw486qdywo2u9lcp80kruo8nr0pz5hpr9', 'tk97v4hu2n9hxtv00ckr5flkezl67m6r2f5vn4oovmdp8d93ek', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mxxs9f97cqk7fhars8kyrzcyx5xb0jwqwee87ynbbmddxruxdj', 'tk97v4hu2n9hxtv00ckr5flkezl67m6r2f5vn4oovmdp8d93ek', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9ptmwrwl8rqf2uqi6mctoh94w55erdoq95t463dqcvp7nhhl8x', 'tk97v4hu2n9hxtv00ckr5flkezl67m6r2f5vn4oovmdp8d93ek', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d50irtz8a5f51uoqhx9k0xkiycpdp4rmh75rik6bcmvh81qw9b', 'tk97v4hu2n9hxtv00ckr5flkezl67m6r2f5vn4oovmdp8d93ek', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('u97lrtyx7lied7d2lls6qaj4hl4r6ya5zffa3o1fe5810caag3', 'tk97v4hu2n9hxtv00ckr5flkezl67m6r2f5vn4oovmdp8d93ek', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('uqz3zi2uwnd401t5bo953hycp1amk3n83op2rtksdwti3ydmol', 'tk97v4hu2n9hxtv00ckr5flkezl67m6r2f5vn4oovmdp8d93ek', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('melkijdnwnmrxyx097zwg5zha4yqt1wdzgwpqk7vg8lejdz7qc', 'tk97v4hu2n9hxtv00ckr5flkezl67m6r2f5vn4oovmdp8d93ek', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('seajghjl8v9ofw89p1kdwb2elihwkif40huyek69ouw1ew3n4g', 'tk97v4hu2n9hxtv00ckr5flkezl67m6r2f5vn4oovmdp8d93ek', 6);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('y53b77uxbymmwb85dg42sbqovnnjm2o2eci2gc2kxmlrl2102r', 'Playlist 1', '2023-11-17 17:00:08.000','t0mupf97ak4jsnf');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('cjw5thchsl31q5oxev2a8i1xtj3v0lsdwy8rowi3cenat8ho95', 'y53b77uxbymmwb85dg42sbqovnnjm2o2eci2gc2kxmlrl2102r', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('1en6s6hrso81bj1dxymwpkdj0j70jv95a5yin591njgy6dfp6v', 'y53b77uxbymmwb85dg42sbqovnnjm2o2eci2gc2kxmlrl2102r', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('m092nlrue1o15fjivqro7g17pajfmyvolo8xn4nkotb6udlt9v', 'y53b77uxbymmwb85dg42sbqovnnjm2o2eci2gc2kxmlrl2102r', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('bfyhitdg09owo3tjnciu6tvc1um64hluc3m1o4odje6h529xln', 'y53b77uxbymmwb85dg42sbqovnnjm2o2eci2gc2kxmlrl2102r', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3yqtzqbtt205h9i5xto1ydp65qwajjqycde8wu3gjur0ckqonj', 'y53b77uxbymmwb85dg42sbqovnnjm2o2eci2gc2kxmlrl2102r', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('w7ufo2fe7iouo6qkm908uzeepa5x8dg68lcn6ho4khijj6svo7', 'y53b77uxbymmwb85dg42sbqovnnjm2o2eci2gc2kxmlrl2102r', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('282qxrqsgitimh8rt99nbn8j85utpyvo88hv1kms6165cn8v4g', 'y53b77uxbymmwb85dg42sbqovnnjm2o2eci2gc2kxmlrl2102r', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('25pwtqoho0p63qllubczskp1ap1zbgj865fr2raef40ulf01h6', 'y53b77uxbymmwb85dg42sbqovnnjm2o2eci2gc2kxmlrl2102r', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('b0b3gglgnisj629rp4ip6s2qqsdnflybweq2t1u6nvqwju1yrs', 'y53b77uxbymmwb85dg42sbqovnnjm2o2eci2gc2kxmlrl2102r', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('swiim390n98q48kg721i138s43inybu0gmas3rq1ysg37v4s5a', 'y53b77uxbymmwb85dg42sbqovnnjm2o2eci2gc2kxmlrl2102r', 9);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('147xobpm4mm89oft6oq9j5yq6mysricuq5o4gvfwkb4p1deuwu', 'Playlist 0', '2023-11-17 17:00:08.000','houhask03jin4bc');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('0n92cfermlo4q2gv2ivzz8kxlz21ftmace9zmqc4qfwzwa9n90', '147xobpm4mm89oft6oq9j5yq6mysricuq5o4gvfwkb4p1deuwu', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('9vuh6w7v5bxshur88ifj51xtfyju5hx623ryq9notyth7olz7t', '147xobpm4mm89oft6oq9j5yq6mysricuq5o4gvfwkb4p1deuwu', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('jrmo39srpyjsnlnbynrgmi232goc35s6ybrxbj1jp5vs5ruxcr', '147xobpm4mm89oft6oq9j5yq6mysricuq5o4gvfwkb4p1deuwu', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4yeq001h17fp5uaveos7qknwpz7xsv031nw4qfnjt49s5z2f7e', '147xobpm4mm89oft6oq9j5yq6mysricuq5o4gvfwkb4p1deuwu', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ihp28kpju6tr7gz31pdnov14k0ei9io4q8b34u7v8jpsnewbva', '147xobpm4mm89oft6oq9j5yq6mysricuq5o4gvfwkb4p1deuwu', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('rfojulzpa29f2qqddqbgf2u2mgd7yi5504hsflkhvsec89f72r', '147xobpm4mm89oft6oq9j5yq6mysricuq5o4gvfwkb4p1deuwu', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('3i4d6w2gigknr5h4kirctkld167ffp7zr2wnqy9v8udjxrxlcq', '147xobpm4mm89oft6oq9j5yq6mysricuq5o4gvfwkb4p1deuwu', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('64ggjxhjrnxl3jbzvezd9g70x9g74qjwj16xjb1005lcsyd35a', '147xobpm4mm89oft6oq9j5yq6mysricuq5o4gvfwkb4p1deuwu', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xnrg8lvb6cew8tvxnxhts6iinyv1ceqz3sl86me711r38msvtl', '147xobpm4mm89oft6oq9j5yq6mysricuq5o4gvfwkb4p1deuwu', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('2y0hx0d7ynzcf3psnj72b4w8bp34pr7pcufypk2lv9024txwi6', '147xobpm4mm89oft6oq9j5yq6mysricuq5o4gvfwkb4p1deuwu', 7);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('4f7kv7konr3gycciwqnugi055wztdn4q94hy8f3b27ne7dn8bt', 'Playlist 1', '2023-11-17 17:00:08.000','houhask03jin4bc');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xnrg8lvb6cew8tvxnxhts6iinyv1ceqz3sl86me711r38msvtl', '4f7kv7konr3gycciwqnugi055wztdn4q94hy8f3b27ne7dn8bt', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ifr6s3gz6blcjv45qpvhky6a7df35qwm66vymjx91kyd6kdusg', '4f7kv7konr3gycciwqnugi055wztdn4q94hy8f3b27ne7dn8bt', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xl9cub5nz2m7waakwir1hy4d4xf6v2t12ribjws4te0u1pcsr8', '4f7kv7konr3gycciwqnugi055wztdn4q94hy8f3b27ne7dn8bt', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('teyprcjqx3mbxl74qocdr15flaf3axc4mgmqmcz73lf4gvaoov', '4f7kv7konr3gycciwqnugi055wztdn4q94hy8f3b27ne7dn8bt', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('e4hv9dwpp7ba2smkn2wi64nekjlixcesjyph393s7l6w89dt6p', '4f7kv7konr3gycciwqnugi055wztdn4q94hy8f3b27ne7dn8bt', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ikbzd4rpn0z74d9678eeqredsldjbyxnnerx8pfcgxtspeaj2x', '4f7kv7konr3gycciwqnugi055wztdn4q94hy8f3b27ne7dn8bt', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('yu6innx3o06ms87s6brp7bqts7c5l0bfrtmsm216exdhtkxi7u', '4f7kv7konr3gycciwqnugi055wztdn4q94hy8f3b27ne7dn8bt', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('im52v4wyfzc3p5d5izkac3wra5fq5x2p2dw38i7duc54yswdmi', '4f7kv7konr3gycciwqnugi055wztdn4q94hy8f3b27ne7dn8bt', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4yeq001h17fp5uaveos7qknwpz7xsv031nw4qfnjt49s5z2f7e', '4f7kv7konr3gycciwqnugi055wztdn4q94hy8f3b27ne7dn8bt', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('85zy97ad39lytntr6u7swfboi6rlbculi6gg49n1h2zp010jvy', '4f7kv7konr3gycciwqnugi055wztdn4q94hy8f3b27ne7dn8bt', 4);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('fj75yxzuzwjihmy0u43incasff0s6ltfnbowxzdl0oudpsg7rt', 'Playlist 0', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('eixrg0uvawg6kybywamsipsx2djglvfrz38tftxotrnrzd3xj5', 'fj75yxzuzwjihmy0u43incasff0s6ltfnbowxzdl0oudpsg7rt', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('az9eyw4nmtf6gth96fle0027ttanooo8o1r9qzf8s9phtjbvz8', 'fj75yxzuzwjihmy0u43incasff0s6ltfnbowxzdl0oudpsg7rt', 4);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('vs3vplyoka4h1dtl3em0v0lmoon4h4tvkt5l4jivzrj1nuuy7k', 'fj75yxzuzwjihmy0u43incasff0s6ltfnbowxzdl0oudpsg7rt', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('60gvhvc52fg9x392e3fx0ahhepnjqxv63s7bf21jqhvbyiyx9x', 'fj75yxzuzwjihmy0u43incasff0s6ltfnbowxzdl0oudpsg7rt', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7clm2vhprzd7y2049r3nf9sa7nv5pgv36dc4y3g15dqzknewd1', 'fj75yxzuzwjihmy0u43incasff0s6ltfnbowxzdl0oudpsg7rt', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('4yeq001h17fp5uaveos7qknwpz7xsv031nw4qfnjt49s5z2f7e', 'fj75yxzuzwjihmy0u43incasff0s6ltfnbowxzdl0oudpsg7rt', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('v3mm2ltnh46vewwp01l8w7et7w8bv6pexo4iyhhledechxa6ax', 'fj75yxzuzwjihmy0u43incasff0s6ltfnbowxzdl0oudpsg7rt', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('7wp81yt7rzfx79uukpqrtr5oxh4cdpoly9u7h0su1z3lnutkvs', 'fj75yxzuzwjihmy0u43incasff0s6ltfnbowxzdl0oudpsg7rt', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ob6cvhkcd5xx19eaj9k0je08ui6iv0ou8qmuxibry5w9tvpz73', 'fj75yxzuzwjihmy0u43incasff0s6ltfnbowxzdl0oudpsg7rt', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('r5xcdx1veehwt7njcu827ht732ee6kilgeqkr5efxkzifgshd4', 'fj75yxzuzwjihmy0u43incasff0s6ltfnbowxzdl0oudpsg7rt', 1);
INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('80q44adz870wvfzhex6oyokkj9eukw0n86wllwp3y0wa0cj8al', 'Playlist 1', '2023-11-17 17:00:08.000','icqlt67n2fd7p34');
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('t2571qkfcf4ico2be3fxdlayehyjtsgi4uupw9cghevby3pvgk', '80q44adz870wvfzhex6oyokkj9eukw0n86wllwp3y0wa0cj8al', 0);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mue86c3m98a43s58ohaofqur1ed98c9979ssp7wd5p24pzwam8', '80q44adz870wvfzhex6oyokkj9eukw0n86wllwp3y0wa0cj8al', 7);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('az9eyw4nmtf6gth96fle0027ttanooo8o1r9qzf8s9phtjbvz8', '80q44adz870wvfzhex6oyokkj9eukw0n86wllwp3y0wa0cj8al', 3);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('xpts46j50g4pi1d93scwnblv7hhst9utkbd743xmw6qevwsb29', '80q44adz870wvfzhex6oyokkj9eukw0n86wllwp3y0wa0cj8al', 2);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5cr0vuisks2t7dyyi4ogtmle6np945zjoni6iqrg9emt7mva0n', '80q44adz870wvfzhex6oyokkj9eukw0n86wllwp3y0wa0cj8al', 1);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('d9huouenp4s2o836krea8bthal2eoxb5135gd5nnryj934amy2', '80q44adz870wvfzhex6oyokkj9eukw0n86wllwp3y0wa0cj8al', 5);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('11uzatntlojfgtt1r9v5zwepqifvi09fq295w9dgh5nftrcxkn', '80q44adz870wvfzhex6oyokkj9eukw0n86wllwp3y0wa0cj8al', 6);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('5lwihgie7gid5a6yu5a885ruzi8wb37uv8bjwx3ffwjyvcfwph', '80q44adz870wvfzhex6oyokkj9eukw0n86wllwp3y0wa0cj8al', 9);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('ehmxjjjy240qewrckcvzrmemo68k7dd7jclunqspf1yrq1ry82', '80q44adz870wvfzhex6oyokkj9eukw0n86wllwp3y0wa0cj8al', 8);
INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('mtzhnnoyyi3ngc3yyfexzppplc1y98lokx5g1wolgumyh69anr', '80q44adz870wvfzhex6oyokkj9eukw0n86wllwp3y0wa0cj8al', 4);
-- User Likes
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', '5cr0vuisks2t7dyyi4ogtmle6np945zjoni6iqrg9emt7mva0n');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', 'aon9eyg3twl0xnhjyzhckg6okc6arqtgmqzdwbrrdszbjb2uka');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', 'mn0y0qwlc9ml26smlnddx0n4q4mik3by57gybtv3ev87ub73ue');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', '9ptmwrwl8rqf2uqi6mctoh94w55erdoq95t463dqcvp7nhhl8x');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', 'uu23gxueqmgpza0t96xokl7hjemog9v3j533pda3p092e7urfv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', 'zjuka8uhx0q2a5cu6s0olayjoz29lfhsrx63advyjxvgp8kv4l');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', 'o44do1mlvz6vlzrls8qs9ucx62sft094xmpha8n8siau22iai9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', 're5y4b2n9ju2e2twudjb28n6uurt1f5pi9jczu9ohmljj2kjb0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', 'f4pesdom7kjhbe92hxozmwcaylhae2uvxsec6vrljnrhbxuulp');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', 'm0wdm6uacgj3p5r4an8nm3wmrslsr0glck72auwk099eh54h4i');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', '37rfw6th3gdavh1mve4sre7inkaw2ly78cmkdg222a1rwikda1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', 'ffvmk74m1yijmzw6cuonwth30do5k745eribquqd054w2nz9eh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', 'x7q9lqxnx58653gbi1mc8vprzkw4ktq0ix970k274dyxovg2d7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', '7qg23ucevqx4ym17f0eaol2iydvghshk0nrmrtagzxirrdg0rf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('n4ui9y09tewznoe', '2bfzz5macothqljj3n53vfw5aoman1s1n148j18gwo0geg3x6k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', 'n2xfp55gawucbodcmyemjcxz49dlssm8hae59du89xe9unkkx2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', '8or5shs5dexymh9yvrtd5kp63csuhipfubk3m8sxqbi9vxou2x');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', '0jagwlnf81dvugvcfgykmm9arswljwa1n3zs3f4s7ojst12ejn');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', '6gtjo4fvn6xku31spp0htxrujkmthssft4er7zdm2chkh6nnyz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', '0947vd9etovbu63m0oc10p5mbh04xpatwzuwvcwiqse8chpdlv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', '2bfzz5macothqljj3n53vfw5aoman1s1n148j18gwo0geg3x6k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', 'z02qkseaxczmeuh20jxqqdmkzgp092a7cc9cciso0vj1tqx4p3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', '0q6onmqf4emugi5ivj81375xiow612acohfv1ir3ws82u49obi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', 'jg276ucqn51cvszzsdzmlyslna0tz0m0d91t8o2booko5bl9fr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', 'zjuka8uhx0q2a5cu6s0olayjoz29lfhsrx63advyjxvgp8kv4l');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', 'tu5f9j9o8f86qqno6nhls9xpeqoogr0yc4hz5e6yjfs0iq5na5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', '6y2asiirvgorlfm8xeyodmvsgjgsp34vn8isfkrs0qo0fy5lvw');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', 'jaifpy08ayp98s1cz5h7gimb1m8f1vbo17exc9djdlkxqfprd6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', '5o8deqwihzoc0eiqo34tjosgr7oftg1xp84mv0p9fdmttz1k9y');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('fg4y77qklwmyyo0', '4ckp4gx3af3jocbxux8vyn1bl5cjs2780lmsf62knvmfvtb4vz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', 'bbpzi0we7y9xacfahi3z5c35slfhe2s9tpgq6m4s8nh8ipshdk');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', 'ucmzhvkyxeu51b9qdso3sxwugcv6csyys1f76otb7dl7dbsgqw');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', 'c09vipslk01el537runr94km8qc23l6fkzewiqk3r2651s2e9j');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', 'rky3j36ffgo5fwtw5tyxpjqa69d4nha0px232roh294azpe45n');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', 'wol9xb7bkveftqtw9gpdmk51h1qrbhgi6tv56wg7h38f7qz5di');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', 'im52v4wyfzc3p5d5izkac3wra5fq5x2p2dw38i7duc54yswdmi');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', 'oyu07zi03vy5ecqw99atyfd9n8d2tqk6glql6k5155g248gf9b');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', '27lb7e4fcs572r3nte0ue6zj2tyli4irt2xu6xc2csb5nbsulr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', 'rs63z6t5mbcavvueykkvdp2ukup7hh8y9bdl3z3v7h2xv1ydzt');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', '5qa7s16wr48m07brflaog5nlo1z4f1uk3dir08ok13fuf8sni0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', '6gtjo4fvn6xku31spp0htxrujkmthssft4er7zdm2chkh6nnyz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', 'x7q9lqxnx58653gbi1mc8vprzkw4ktq0ix970k274dyxovg2d7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', 'rrb4vq2qircu8te65bg2gp201er4h7cguqlfh4lacuziv4xhyj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', '573pm4uq0yu2cp56lrc6ntszv1ad5t1qetpsvcdg46jltznfah');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('mtpfpk9v3ev87ai', 'xnrg8lvb6cew8tvxnxhts6iinyv1ceqz3sl86me711r38msvtl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'e04mfvgsvtf8vzf9gg85z8u6jldxtvh0xbpy123xs3mg21b6s1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'x87hinyr500z7wc1b0auw74wmzr5047tptxu1jn70xd7eile25');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'rxczjtgr5h7gam49f7k49f5kqirucuxn0lzsnauxgev33kt9f2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'z0hxuemaqz6k9m2j3db7fu0d967zjcnocrl2mkztd1mrsa6loh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'nitz8cpwvil579ckstmyqikz3kzmee7zsm5cin38v09m815t3p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'vihiq28e2gnnjwdnkrmwck1atc27vmetgbfqfxd53cnkcse9mr');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'e4hv9dwpp7ba2smkn2wi64nekjlixcesjyph393s7l6w89dt6p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'ixq4fox8myilqbdep9t5zmcopd3myo34azwm2v7j7265exex4r');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'a8rqbhlplom4871qoezhzeujazr7c1in374h4ppmfkjhiithif');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'nv03m3288aq59fyyymt9ptmuhxehezemg4f9ppvw36gvdslfsq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'q0q1zaet4rnc8e94xvv9k3v33zgjfint2iyhrt7owhiry86j63');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', '2j9ywa7sl7oo1b558acnnogabso4d2b629sg276jk37bbdxlif');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'u03d87sg8fhaxxr27be284fb0vjoaj6hnfhvda44g76onraadx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'usrfhqt4ltjybc1r4tw486qdywo2u9lcp80kruo8nr0pz5hpr9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('wf8quespmaf9ye7', 'r6pd5fxzwav14t3euh6c7yn6b6cmys6f7ugnzl5y6kecwn4tg5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', '184zh8gjkxju4kbyn5kouqn633ihr8evlge3px3ivy99ndd2ze');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', 'bbpzi0we7y9xacfahi3z5c35slfhe2s9tpgq6m4s8nh8ipshdk');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', 'bo6b7g8kt56pzn3154onxg33fm4t3iihbsq80irg7skkw8aj18');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', 'jzdeve7kuxnk2w56x7uth0hyx6za0dir5unqseqp6o0xllzszj');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', 'eiybte5uzduma3yk3hzgwvwm72zvrl9itf28yx1e8ajqads3sa');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', 'n1pc1j4m54nush0j0u29weonc1l9vlv88xfy6c1kf9xd7bxswv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', '37rfw6th3gdavh1mve4sre7inkaw2ly78cmkdg222a1rwikda1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', '6pj49t71j08xd0fg9vr9coloxd4fzvb406vksabro4kc76ktqx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', 'wp7op9n7eqfu6lwlh3i7x2dcz9uuzjimk68in4fc13wh14to8p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', 'g8ig3jn18765bgjndvyv74h8wim2s4rpaubwi1lprf3knb2h8v');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', 'xl9cub5nz2m7waakwir1hy4d4xf6v2t12ribjws4te0u1pcsr8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', 'l4344lm8ayrgzps56lsa63268ywt2jtuj6cnrau3mwhm8cac2y');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', 'ivoek61cknbd3v2bhpoztps1e46aa694ida27tw5yeqr1e4wgu');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', 'r6pd5fxzwav14t3euh6c7yn6b6cmys6f7ugnzl5y6kecwn4tg5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('otoox1klhz0a3lm', 'iid09i6488gevksjl114p717bpnd6siytgj8qia6mfc3pb43ax');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', 'm0wdm6uacgj3p5r4an8nm3wmrslsr0glck72auwk099eh54h4i');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', 'yjk2ixdni9kuqkk28b8lbznys2x3iku4zmtnmbgp8g0jsg9q71');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', '7o08armbjf1cbtyu5wvj568tvtxmx00ffdyitgyhbtf4hhy6ac');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', 'd316n05w99qzkb6vozdp2thi10kpbooyuwfhxt3np45580n3ib');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', '573pm4uq0yu2cp56lrc6ntszv1ad5t1qetpsvcdg46jltznfah');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', 'n8zfdd61gtdf91y50z6teep0ro3l46fmcgycg0hi9rdi40p67r');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', 'ehmxjjjy240qewrckcvzrmemo68k7dd7jclunqspf1yrq1ry82');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', 'bjnqrkpj4wr3amcig8nvcqiehcge4lfw6fufvttrqazqcfpuio');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', 'w5mv28mlnqs7iqqzevasmyq65e00cldmym34hun5ri1ij75yuf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', 'u03d87sg8fhaxxr27be284fb0vjoaj6hnfhvda44g76onraadx');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', 'nitz8cpwvil579ckstmyqikz3kzmee7zsm5cin38v09m815t3p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', 'v3mm2ltnh46vewwp01l8w7et7w8bv6pexo4iyhhledechxa6ax');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', 'xd5o8d7yts2edx832cthuwjqbg88c6zr3wgk8yf6aurof8m06q');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', '3b7ls661xqtcyrylvoe91jj1sxvabjj56m1s1k1wcxscyhkkt8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('j4fzpxduhkq981v', '3f50yrcp7qixb91pz6iz8s0toadqmo1tvm5vti2wfq1tx8aw3q');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', 'yupicu922dmxf0d78b4silunewm7f9m1c34o4ka9510x93c69t');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', '1zwuzn2al6exkto0vut8lsa93tt700ul6raioc8o2nv1007nkf');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', 'e1yr4eb77jpfe5l93ezdekmqelv4p7fo306883f7op1dwzpk4r');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', 'xl9cub5nz2m7waakwir1hy4d4xf6v2t12ribjws4te0u1pcsr8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', 'f4g4i5p02cfqupx1zmz6yznbt58i6mjpkjb8dqqh4x4212tb46');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', 'm0wdm6uacgj3p5r4an8nm3wmrslsr0glck72auwk099eh54h4i');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', '9z2tb1s7evtogunyhwn56hpq96hvbs7g5o38t3v555gl04cg0p');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', 'l7xp1nloc1gwdjknbon3n7ryxdt847i3lirjbior69lhson3h3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', 'yffg6bvgrqdrpf3ka9ixyr69zxtfsbjohghvqdnx4xpq0l7g70');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', 'z60lpo1cilyo5j2cv3p6dlli371dxica8tx4cc53rfdpvdhus7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', 'az7g02twfaqk4q0zft0n9pm7w0i3mhxa2ywkn8b3x5o2dytouz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', 'dih634k1vse3r4igi1wp3rnljnzyudhgxoi640aycmc8lu8y2v');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', '85zy97ad39lytntr6u7swfboi6rlbculi6gg49n1h2zp010jvy');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', '3f50yrcp7qixb91pz6iz8s0toadqmo1tvm5vti2wfq1tx8aw3q');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('ms5gxmmwjk1a93p', 'fns7vvgnuo6vstoo69gdsi7u8fxel6cm5af5ixxkw453r4thcd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', '5o8deqwihzoc0eiqo34tjosgr7oftg1xp84mv0p9fdmttz1k9y');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', '9ffr693q9dnc39jlo4ugwg5au6m7sfy4qzlzudbcohb8j8ckzd');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', 'yge2cptgd0bniuexjh95w655h1fb5ygntgjhwlybfci5fhjduv');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', 'pu7srdo8v6aoo7rg0u1xc7h7xetn5894hyd50u97k6a8womk0n');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', 'ihwhevl5rshuza219tilezb32ra1t3j0f98ycriz0mprzjhj9j');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', 'o44do1mlvz6vlzrls8qs9ucx62sft094xmpha8n8siau22iai9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', 'nhrhegnrrq3jmw63ultlz5cyjlbuuspqza5crs0c6k3y1n72kw');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', 'l5t65gpmydh2phjh6i738r3uklz5rplr2iilmtsj7s2nsvvpe7');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', '3prmlvh71oh9pi14m004a25clgrvdonrmtl3fti42cr216xo4n');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', 'qh9z8myrgbbz24lhrmcxefqsiby9bositojufsrmcwaer5y8b4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', '9hav66ls1twtfhlzmomntmb6vhnxh1gi9ka0nyg5axceo2q1uz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', 'm092nlrue1o15fjivqro7g17pajfmyvolo8xn4nkotb6udlt9v');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', 'wlp4ikdae0r2g97bntbf9747ws6p39rh38rwu3uid0qcaagp23');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', '5qa7s16wr48m07brflaog5nlo1z4f1uk3dir08ok13fuf8sni0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('r6em9gfc7ihcq2s', 'hq8pwj9b50a7y60s149scr4ar4mytxmafpxdlzdb7jhvxl0nbg');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', 'b0b3gglgnisj629rp4ip6s2qqsdnflybweq2t1u6nvqwju1yrs');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', 'iaf50onh5pa8qz0unvqlagnmx0rxec1m0gtb310bza3lxgv2nb');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', 'jaifpy08ayp98s1cz5h7gimb1m8f1vbo17exc9djdlkxqfprd6');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', '6m3ii1mc29c9mdjyrts7m39u4m6rrk1twbq6283nub2p20hgtb');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', 'xl9cub5nz2m7waakwir1hy4d4xf6v2t12ribjws4te0u1pcsr8');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', 'x571y56p1zd1z7z7kh3s0t5j5amh1q4vzxsjy6if8oo5f79zir');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', 'mnv920pjaylo5rub8o23v7pks3vpqamv9k50fwk6t3wtowzq6i');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', 'yfwkk01vfxy7mew9cccnvjfs4zndpuyrzexy9tdhcf4dku7sp4');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', 'lwa4f2r4uufrz6nsw82uh28g6i8l3yiskoerps2ksdf2ojgqth');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', 'ffvmk74m1yijmzw6cuonwth30do5k745eribquqd054w2nz9eh');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', 'iid09i6488gevksjl114p717bpnd6siytgj8qia6mfc3pb43ax');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', 'dt3uu1q4aqilkkwvdg2zyltjbxxgafcndnjvvwyfn8dphuckhl');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', 'sjz1vj1qumudln3akmmuqzz88xr1hnaygmt08alosokvh1gxe5');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', '50w1ncf5p36v4ez1ev79h7ro8i1siw19snbf5u75p20w86ygcu');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('t0mupf97ak4jsnf', '9hav66ls1twtfhlzmomntmb6vhnxh1gi9ka0nyg5axceo2q1uz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', 'k78c41oyshghpjlzr12osamm7tsudjpch321zuvopezehenxur');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', '85ccmr2ymgrr270kknqyil6wmz8d17tc9oyeowzvn8pg6ju7i3');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', '50w1ncf5p36v4ez1ev79h7ro8i1siw19snbf5u75p20w86ygcu');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', 'xpts46j50g4pi1d93scwnblv7hhst9utkbd743xmw6qevwsb29');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', 'ijt4z4euw3t4mrlbatqwk60r3itvdtlwjt3b12wp78h40h0tia');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', 'egw2gloqycid3dtvm1vv8tvbunw45gfuv7irztf03j00hawoaa');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', 'i1vh9p2p3ixsf36ugqn6e04g8pyep6lrmsufzojhu5peo0kpyt');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', 'x571y56p1zd1z7z7kh3s0t5j5amh1q4vzxsjy6if8oo5f79zir');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', 'szjx3xcc2723guta1kc861oqzougg0o44e08cearn9cc9gdzd2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', '1fuk8vyvxbqty5lkfwmxt0fx1tyksegcn0jwpln18sgdkse4v9');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', '5qa7s16wr48m07brflaog5nlo1z4f1uk3dir08ok13fuf8sni0');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', 'd9huouenp4s2o836krea8bthal2eoxb5135gd5nnryj934amy2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', '89hcqnkqya2dbm40wp571o3tmkl82jdashhbl9q3pzho9omolu');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', '9hav66ls1twtfhlzmomntmb6vhnxh1gi9ka0nyg5axceo2q1uz');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('houhask03jin4bc', '31uziyypet8i6je8n8cboa5m4xf8cqomtna12rtu720xjl916h');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '7oyrvv8bbh6e9ce09aifwa7sdpdlk27s2dc2z09klxzjqjd9z2');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'n8zfdd61gtdf91y50z6teep0ro3l46fmcgycg0hi9rdi40p67r');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'pu7srdo8v6aoo7rg0u1xc7h7xetn5894hyd50u97k6a8womk0n');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'dy9xhnpbm85on6rduhk0yc2af164o5mlh1kv8gbi9n5hqwbl2r');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'p6jx361bk0uv7d9lftbri9dhq0ay5zoe34jmvkfmqnqmmz8t9b');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'xq5wwa3aktll156lnrh6q8h9fvokluw5n9g4f4up731x4r4ryt');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'x8lzo8npgcfvzdhqt28zqw07ifqjwu5lm9c5fa1jfzklpgc95k');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'ihp28kpju6tr7gz31pdnov14k0ei9io4q8b34u7v8jpsnewbva');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '5o8deqwihzoc0eiqo34tjosgr7oftg1xp84mv0p9fdmttz1k9y');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'i1vh9p2p3ixsf36ugqn6e04g8pyep6lrmsufzojhu5peo0kpyt');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '807n1uex9rhkcdvg3yfmxbsx32ugniwy0i7qfrfari8bgd1v3l');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'ff79bg3k4zlphs6ube4xyuspjhqce89x3wk2ih1c8wwny6swqq');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'lk9a6i2bczfr05nx1688x4lj54xixlafk6mu5kjgi4znwsi8k1');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', '282qxrqsgitimh8rt99nbn8j85utpyvo88hv1kms6165cn8v4g');
INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('icqlt67n2fd7p34', 'hzmkylohwqbkdmqakkkrzb69o21nukz7eqsboi25955rm8iol1');
-- User Song Recommendations
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('dz0lk945nrnyv925iltqv9etqg9ne8g3r7jmvdvdx2jzg9cyy9', 'n4ui9y09tewznoe', 'gle9ito4ixoqxlty8dv4tmjrd976khwoyx6e2291du2mg2x2sf', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('h437iaf94cw91757eeq5ibwqn0ha7ivge392w3pv1ims30vx9x', 'n4ui9y09tewznoe', '747z3xkv2n5smercmp87xrvxywy8dtc30e42o40zus07t4l7yf', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('bun5bma3didyeppue1s04xbeew0gzrqrxuhmw3x2romn6vzpgp', 'n4ui9y09tewznoe', 'ejddz9j19w1914h2b0nqnt2e6l47grl5ky37xfhztq21jr9b9h', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('6wc4iyp507qpnbzty4zsmqzi9bcmfxka95xe5hqmovq8cnki6o', 'n4ui9y09tewznoe', '0wv5f2kko4olc29xmvy9fug0bx8bbleki1vuhs24zebq78a3du', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('m5b6yy5oq6vciypj1v3xdhurmy7ndxpr876ppf7cxibqlthzt6', 'n4ui9y09tewznoe', '4ckp4gx3af3jocbxux8vyn1bl5cjs2780lmsf62knvmfvtb4vz', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('3xgtvic974f2642k5k8pl7mqrlwktasegy9vyzia2kjh5mf4j3', 'n4ui9y09tewznoe', 'vmisct6636gjswjns7b1oogz6nhwoz3i6wavqurnez6eqghyhe', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8p6w42lzw21984zme9nzm3lmp9mk3lnjmqtgr8pgp1wynj3ghf', 'n4ui9y09tewznoe', '62yhc2gvdwk90eld7l2vyrn6o9nbsw7yrr96pf9pvq7m6517gm', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('n12m25yr99fqqhha4g9nnis7w5mpi767jaintuqy8f57f9hezn', 'n4ui9y09tewznoe', '7ykl880gakjirag73nhedrjcimlpfq9o6qidmm6w72ksy9tdu8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('kvedmd5epu1k15tvxeu2b3ex8nben6tnsd5msxo36967orsdg4', 'fg4y77qklwmyyo0', 'aon9eyg3twl0xnhjyzhckg6okc6arqtgmqzdwbrrdszbjb2uka', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('n7ewnkxrb1pqz7y85913ibphl5tm0vhgia9frc164veb0kt0iy', 'fg4y77qklwmyyo0', 'i1igdcvjfqvsvx7c4lewcuox3xu8c8eyrnqhxnqpd1y2vorb91', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('z1i3fcf2pnnfhp3sxkx42n54r8lcj7pqdvg1lt5nkato6xcpuq', 'fg4y77qklwmyyo0', 'yjk2ixdni9kuqkk28b8lbznys2x3iku4zmtnmbgp8g0jsg9q71', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('n1zz0jajs82or28viyug42fyi1cduxsxe2pjfretr2r90pg2g2', 'fg4y77qklwmyyo0', '747z3xkv2n5smercmp87xrvxywy8dtc30e42o40zus07t4l7yf', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('djxqy6b1d43el4s9435kbd61468ebqduptcnz3dx9bc9tiade5', 'fg4y77qklwmyyo0', 'f2b79ortni7w4rsj60iczy0ctzya9oetnm8op0id2z7sebzmz4', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('i774jeh0jqnhnb229b3vewtfszz4iqnyyup6gcou1la6us2hmc', 'fg4y77qklwmyyo0', 'wp7op9n7eqfu6lwlh3i7x2dcz9uuzjimk68in4fc13wh14to8p', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('t9r6eeet42r6z29xca0w10h1ym8cnkkmxauwuf1g3xjf5sq4yr', 'fg4y77qklwmyyo0', 'br3y7gf7s23ny7e8qh6rjpum0lyam9oz2yt3uamrlpqfrmwo8m', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('t176n7w4yi38jywcox0q9f4xr7dlsv2j7jwr7f9l46g2f5omtu', 'fg4y77qklwmyyo0', 'd0c1j8tfluhbjxw9t2bvvivtvx5tuwuf5t1wvyyyo2xv7wkgc7', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('rro7u0mtejwauskll4z2f7ywuzy2uqtrna9mdidst5ztkqoi1r', 'mtpfpk9v3ev87ai', 'bjnqrkpj4wr3amcig8nvcqiehcge4lfw6fufvttrqazqcfpuio', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('sjk9r40qhaetk60o76lv3hjw7s1d58kde6u6rnrw9p3s61iuwn', 'mtpfpk9v3ev87ai', 'c7oxh0xmmlld2mvbx54gafyq2bh16ohnzid26uqe9m81kxbeq0', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('em579fjw3v5qn7z8nm3o0nhzhukjtrxm0jrwsj0wmi7sqojm98', 'mtpfpk9v3ev87ai', 'hxfjetbmfsmqhexy6khk772e2vknaniqakbbvyqdnsnihgjqxw', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('gl8ak632sazfne6wwovqmqkr9xfc5s3n76pg14aqkhsz0jp9zu', 'mtpfpk9v3ev87ai', '3age2cm185ehs2g2tkkdgnrpsw8lz18tuyq7ygy2cy9lxycpft', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('7gulxrosudyx3arfc49qz0tbrpcc8ae5nndhc81pwkvsfaweq1', 'mtpfpk9v3ev87ai', '74agrgkc4we7v7j73d0f4sl4rftk89gq40yhe03758a1vq8lwf', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('3ucd05yzk7deingcvk1cwwuhjzo2lad53fuwbepcy1yjcah7km', 'mtpfpk9v3ev87ai', 'v3mm2ltnh46vewwp01l8w7et7w8bv6pexo4iyhhledechxa6ax', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('p3d75yucacotmvyaydyafox4axqgh9gev5yql5onso9ke7o6ih', 'mtpfpk9v3ev87ai', 'ap21m3xvy2kfmmvfppwgg8ydah2r8sxfql8cb7trb85g5fhmur', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('e6e0bexu53hi31cut0j0gen8l0xp62msc5dkxrhj3bzxpnhf4a', 'mtpfpk9v3ev87ai', 'j1g7zvshf9yqfsyzozilp3i4csxi4u7q6o619509nefi7z3jze', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('irnt1bo4ony0p7cyw7h3vu36z05efss7bvylzt74f5tpn3zil7', 'wf8quespmaf9ye7', 'f4g4i5p02cfqupx1zmz6yznbt58i6mjpkjb8dqqh4x4212tb46', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('5m7zezfnyolbxgyl9u33ghut45snstoy84f55p460isk20mnhx', 'wf8quespmaf9ye7', '0n92cfermlo4q2gv2ivzz8kxlz21ftmace9zmqc4qfwzwa9n90', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ntfs5cgdyvs0ckchjz2djqd6mbfejaxh97i9ioqud5ubz9jy55', 'wf8quespmaf9ye7', 'i2du040lkxxcz4vbwau6a0b83c15tnwswmi0if9msxggj5jmev', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('7e6nsc7d5006mau8m7tja6m7nncudeirzg464e2pg97dfvq97g', 'wf8quespmaf9ye7', 'b093t3d9skl3uxi844zkltp0ft6pcrfx48jjcy3k9a1ijk5l1t', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('phrm9dlw8ym102z7ncfoe34t6bc8nuv3aqkgbkyk9uu45nzcoz', 'wf8quespmaf9ye7', 'vmisct6636gjswjns7b1oogz6nhwoz3i6wavqurnez6eqghyhe', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('emm6vq9gz22iiww4qy477sckvcki35r67i3b63r0kwh2h9mdti', 'wf8quespmaf9ye7', 'q0q1zaet4rnc8e94xvv9k3v33zgjfint2iyhrt7owhiry86j63', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('k5uue2fv2wvga2arrd0rw023jzyvvxvklzrnq22xn3qnfy198e', 'wf8quespmaf9ye7', 'z5sv63z2o7jkpcolhgl7rpvs22kzkwf6poigryrllbwuwrwynd', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('j5fy0xos14rhxzk1870a37ezr0fiosrileqxnteun46jwxcm1s', 'wf8quespmaf9ye7', 'bc7z1a9wiz3rizraqpomy4nsyp8rqzd88p1gmaan52kwf8cban', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8y04zgh0dgrav0piezx3jkjk504fq0x3lqe7kujvid9h11oc1j', 'otoox1klhz0a3lm', 'rky3j36ffgo5fwtw5tyxpjqa69d4nha0px232roh294azpe45n', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('tvpbht7t3g94uey1fwlevvre63077bdjc2t8uu860fdkfdag8q', 'otoox1klhz0a3lm', 'vyime8h1d3h9b5njzilxpaocd20l93a0hg82mboc7m7ad95suo', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('3hvc58u9b2a11kx3njv3masksim0bfvv6lijhm1pwidp705aus', 'otoox1klhz0a3lm', 'lh4ytes3min0n77blitrygd4mn6d90yz8mnyfrexg9cz4yw57i', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('libvfeemje14sj9mbb9houi14796yvp78fyvn3wfm7r82uel7t', 'otoox1klhz0a3lm', '6y2asiirvgorlfm8xeyodmvsgjgsp34vn8isfkrs0qo0fy5lvw', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('m5expno55crx2c2ecqe59l2yxf5vwiv1wjela0g3lf8f3h66c9', 'otoox1klhz0a3lm', 'd0c1j8tfluhbjxw9t2bvvivtvx5tuwuf5t1wvyyyo2xv7wkgc7', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('amxv8wr37jodke70ndpd7avhv8l77ehy7gr2yub8aw1skzprhf', 'otoox1klhz0a3lm', 'o99znevaqkfetixx6zr4ybos4xr1jjdjearl9lsmjcbeqs6inx', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('7v0ynfeqt84rmox4mr6j8j30czzbw3rhx8k1f43sd6rwblki8m', 'otoox1klhz0a3lm', '807n1uex9rhkcdvg3yfmxbsx32ugniwy0i7qfrfari8bgd1v3l', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('o1gskcro2hx2k6uxz4bvgicv93lt8wtblbwb6lyzgzm7cfyz7y', 'otoox1klhz0a3lm', '1s9jdbd53wbd9m5giegjxwyitqtq7n7iigxr5ivthnfaryzfxs', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('0x2j6kkjlw69v217sebq0w80e9i6gq1fx6tiveb1cdfty6m1pc', 'j4fzpxduhkq981v', 'flhyzba4yefqvgyo99jqa3exjdimr6p4zweoxosmn47sy28d5s', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('lwirr6f8fxz0o19ke0w323a0vfu4gcf6gvh08tqf4ef41xrdg2', 'j4fzpxduhkq981v', 'iaf50onh5pa8qz0unvqlagnmx0rxec1m0gtb310bza3lxgv2nb', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('bsymf89ph3zl6o0b45pvtfw0be00kgsnsptiyxjbsx14pmpqon', 'j4fzpxduhkq981v', 'jzoc3mvt4vgq4linvv2oxhuz41j0vmy93eqrls2wifv3pw5vmv', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('aqly2nqj2s74arhpcuqm2sc8zhqo3sxen6pk13ehkskfkuss04', 'j4fzpxduhkq981v', 'b0b3gglgnisj629rp4ip6s2qqsdnflybweq2t1u6nvqwju1yrs', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8yawqer8dudknkg5r0btqad30rfq20wjfkmcymga7fzsqti2m0', 'j4fzpxduhkq981v', 'wlp4ikdae0r2g97bntbf9747ws6p39rh38rwu3uid0qcaagp23', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('zet7zlwzll35agn6xjmj8vtaj64qe323u1u3dfs8plc2w47x6o', 'j4fzpxduhkq981v', 'rlcd05zgjg15d5rhyboc8ztry6ygwnd5hz8ktgqn73p7ux4zny', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('asg2gml0sdkzgt00h18k8nh5irhmdz4y0yd827dmgw8aockhxs', 'j4fzpxduhkq981v', '3ptpyvgmuryepk6smlmxu6wyuajvkz59lzl08we6qcj7jfz8y2', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('4rmr8zt4ryddn8fd29hayvih7qaq1fe7cl1j0rkghe6z7sbryf', 'j4fzpxduhkq981v', '9ptmwrwl8rqf2uqi6mctoh94w55erdoq95t463dqcvp7nhhl8x', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('di4w5syxjzifcfjbi8ylt2hf1iqut7sys29o7pbjrr2enxnvjd', 'ms5gxmmwjk1a93p', '301rp09dsb89t8dalfgd95e1lc7nrip42nthz3yunw6j3snqv6', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ltnqw81mjj3ysplradgvvfp5956hccjblmhtm4xe2bvbawxjtp', 'ms5gxmmwjk1a93p', 'nd1x2ghn0ditxqe23p6bbv814t6zbx7vjjnd29l3orcnz4r59t', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('3dn2ikgi6ryhel5rgrnk20fjjxral8gfxbl6si9sdfqmhea025', 'ms5gxmmwjk1a93p', 'xl9cub5nz2m7waakwir1hy4d4xf6v2t12ribjws4te0u1pcsr8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('8wfwhfxsxltx97spkrvyeol1xo0x0gl52fhpygzpj36155r6df', 'ms5gxmmwjk1a93p', 'zonagelmbtzyp1dz0q7zg1h1hudx6yxe6t227hgut2s1404x2l', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('08wmd648u7tdc7s70ilmo2ru8ognyfu12611ami0dpowzqz8ea', 'ms5gxmmwjk1a93p', 'x8lzo8npgcfvzdhqt28zqw07ifqjwu5lm9c5fa1jfzklpgc95k', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('i5h5kvujhpa7op2zbpaw1k66nphzwjmmu1u9y4fijfpwgpf9yx', 'ms5gxmmwjk1a93p', 'r5xcdx1veehwt7njcu827ht732ee6kilgeqkr5efxkzifgshd4', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wh5jkc258cxzhad107y1hpmtkqjtdsv7d8w1lmndjqqfjh5aut', 'ms5gxmmwjk1a93p', 'k5j77qgi7wppnw8ti5q9y47jd0jfl7ucfmod3wlhcxst7aahn3', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('c53psxtnmzmypvrhg9ewtoqmuudwtgxa3ifznitgda7rhb5v7p', 'ms5gxmmwjk1a93p', 'ob6cvhkcd5xx19eaj9k0je08ui6iv0ou8qmuxibry5w9tvpz73', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('kmsnr3tfp40ncixynd5zpt61itsypi0bc6ixgbshkzynwc224k', 'r6em9gfc7ihcq2s', 'fvp27v61i0odv8fmuakaxrt59vuquv42fhooxovcgj4p6ai9w1', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('2359bepn0ya02r5lz414xnqyu0hq58ubf45oi9tvfq3uqyv4yb', 'r6em9gfc7ihcq2s', 'c8r7hhqagr78rvpbsh6x1dysslhkkqpu8kfttecqkqozx19455', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('uigc7yviump5d64xqpokc9szrpu27zr4mffnqoq32hn1ki20kn', 'r6em9gfc7ihcq2s', '60gvhvc52fg9x392e3fx0ahhepnjqxv63s7bf21jqhvbyiyx9x', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('q1bpo7gq83oo91xn16eayuyoyftuxdc36crswop2msdwtl9ywz', 'r6em9gfc7ihcq2s', 'blqgip7ww9m3mttfealjjk4vjmdkadt2o2y5z896lron86n0sn', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('d5e96o9wgw8sumvscn2h4fu8d523h097zoe9m38745if8foi7w', 'r6em9gfc7ihcq2s', 'rxczjtgr5h7gam49f7k49f5kqirucuxn0lzsnauxgev33kt9f2', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('jmsxks171ct6ag38i9ifqhjakkcfsaxq7w1yu8siwwa8p4dnf1', 'r6em9gfc7ihcq2s', 'zgdpjn3ijug8qobc8u7bk9f4xfe3bgtjeiic15fve3s00wmsmf', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('w9vtct87pnlub8rshma076ix1zc5qc9siihgpyca0wnzfklwq3', 'r6em9gfc7ihcq2s', '1x33wcqtb4g6zj0ilu7c8fjdbsi29jdikfps632gdaef7p1dnn', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('9x59dfbaucvcvyc3kugr0al8k0m5ak2fg9ccxnaymo8auen35j', 'r6em9gfc7ihcq2s', 'z5sv63z2o7jkpcolhgl7rpvs22kzkwf6poigryrllbwuwrwynd', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('e4zcsgrf4condbhpm9ao3xoth4w8j9xz022q4wi2ytlbmkztw1', 't0mupf97ak4jsnf', 'ei8ekfpxepcc47d1djat70jbzk33zqhmiaq1iyej6veboy213z', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('v2scq457fnr7jm1qkkf7un0ajpl3r5cqp2ehzb9l412bgwpnsz', 't0mupf97ak4jsnf', 'ihp28kpju6tr7gz31pdnov14k0ei9io4q8b34u7v8jpsnewbva', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('2ystjs1odl49ycrplrs9119lv4szfsrpxcr0jdb3601upmcxry', 't0mupf97ak4jsnf', 'nitz8cpwvil579ckstmyqikz3kzmee7zsm5cin38v09m815t3p', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ahss0zqoou6vivmxlhcvsf9zzoa9s841c19fycxxsjlp2ilwp5', 't0mupf97ak4jsnf', 'zgdpjn3ijug8qobc8u7bk9f4xfe3bgtjeiic15fve3s00wmsmf', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('r65hzzaziqrl2xq1gsxz4olft4gth54lwp6qpuzth4vclpu190', 't0mupf97ak4jsnf', 'iaf50onh5pa8qz0unvqlagnmx0rxec1m0gtb310bza3lxgv2nb', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('wrksxt7gr1a31pkqb8fd347zdi2o9psuecsbgymmzwmrokjsif', 't0mupf97ak4jsnf', '7ykl880gakjirag73nhedrjcimlpfq9o6qidmm6w72ksy9tdu8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('24rjw9qs9lplnb82qaj7bhce6mihqlt4piucr5z8e9hm8lsvbg', 't0mupf97ak4jsnf', '6r2fi1tvlc2fihlxvasf476fb3u70px1ietu23bjskxaov0q4b', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('w132swh49fxxmlfzhakt04yvn1q1d0zpbbekrc2yiqgvow481s', 't0mupf97ak4jsnf', 'swiim390n98q48kg721i138s43inybu0gmas3rq1ysg37v4s5a', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('jjwz4b6rzs1tbg8c4u38nu0y67a6mmijx8jnyl5t6fsf3q8zsn', 'houhask03jin4bc', 'fs3unrxnn4ow1xd4aac7v4qmz34kdb9u69m8h2kestuzrzcrkz', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('y80umwwucumjnqk49h1ce9voezzas1dd5xsvjz85h9woaw6bz0', 'houhask03jin4bc', 'u03d87sg8fhaxxr27be284fb0vjoaj6hnfhvda44g76onraadx', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('3n644aplcvrjqsf2rx4skmct4zgdduf0q7cwm01paetfsnw14j', 'houhask03jin4bc', 'vyime8h1d3h9b5njzilxpaocd20l93a0hg82mboc7m7ad95suo', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('vnogxz6esim1q1rv91mahakjjgtpebbtrsgf64o60z9vung1jv', 'houhask03jin4bc', 'x571y56p1zd1z7z7kh3s0t5j5amh1q4vzxsjy6if8oo5f79zir', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('6bp6lsgoa1s9w31nithte24f4rfhjuiia6olqxjk58kgr4oxez', 'houhask03jin4bc', 'crfekst9t9wfvp11e7rx0rv0y834eqvoy664m14aucrjbqq2p1', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('bu453h4eu8fnuxefku6kmj5bu2rpwc531mhp3qco7bqcf1vjil', 'houhask03jin4bc', 'l0op5duy6070cs15ukzwf7avs5ygkroqyx3eo0cnjau1rmf53z', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('tkdu305qewhswy1gmb6pfqjq69k9pfx43syqrjg2xgrqfrrgaz', 'houhask03jin4bc', 'ei8ekfpxepcc47d1djat70jbzk33zqhmiaq1iyej6veboy213z', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('qd8hjlbvii0waftwgz2csxvmh1khf7bbrfiblj0p558tjcl8mf', 'houhask03jin4bc', 'r4e5a719qhhyhkefmdvsjmz303t3gcmp34rjrpbnwkgcce9f0c', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('jqrcbglaict2o5dpk4y5nozflh59mqvbzp83znf4nemw91q327', 'icqlt67n2fd7p34', 'ntb40a60o9yy8ckxyvr8htw3s5lba0la99oyxvd1n9eq58roy2', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('kl7zjyte0w1nec4rxvtbhtv1cqi2xarykndq3ocsgly4lmzglr', 'icqlt67n2fd7p34', 'mvm6mc0bseaxl4hku2kth9j6h8abw46eu7zn6ycpscajrihn0q', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('awvet71hrwpy79mgwm6lo0wdjnw1aomjmclswxe1viu5rllg2y', 'icqlt67n2fd7p34', 'i1igdcvjfqvsvx7c4lewcuox3xu8c8eyrnqhxnqpd1y2vorb91', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('lve9omrxdhfmj7vcue5jvhbdrmds507h6biig00kia85rjq9dn', 'icqlt67n2fd7p34', 'rswrq4cryp3odh7wv1b35zgqvldgurbutewm5j0jgzaubxeza8', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('szf54o3yei2u0ya6def6t4yn208dra5vv21wfuvds3xph5i8zk', 'icqlt67n2fd7p34', '14gmoh0ska6oigzyy4wm0wnnnckfn24gn5gn1e9lfacis4bbve', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ulllwlsg7n5un2vg903bpghgc15dgkhe3rfmbikimnaedbgpl6', 'icqlt67n2fd7p34', 'p3awl7ladjmti44sawhcyl6ti80bwrd4clvne558tlx7x8e51h', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('ud53jim4q3ph7c58t23rnirkjv90oonlz2gltvl46hxz6e5x9j', 'icqlt67n2fd7p34', 'z60lpo1cilyo5j2cv3p6dlli371dxica8tx4cc53rfdpvdhus7', '2023-11-17 17:00:08.000');
INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('xfg9yk0hkw1jxhqoyynjknemzki5qw8lrmjwp7n6aqt2plz3q7', 'icqlt67n2fd7p34', 'jaifpy08ayp98s1cz5h7gimb1m8f1vbo17exc9djdlkxqfprd6', '2023-11-17 17:00:08.000');


