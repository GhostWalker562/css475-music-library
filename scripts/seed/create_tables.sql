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