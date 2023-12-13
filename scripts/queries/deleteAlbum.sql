BEGIN;

CREATE TEMP TABLE
    temp_deleted_songs (song_id VARCHAR(128));

INSERT INTO
    temp_deleted_songs (song_id)
SELECT
    "song_id"
FROM
    "album_songs"
WHERE
    "album_id" = $1
RETURNING
    "song_id";

-- Delete from user_likes
DELETE FROM "user_likes"
WHERE
    "song_id" IN (
        SELECT
            song_id
        FROM
            temp_deleted_songs
    );

-- Delete from playlist_songs
DELETE FROM "playlist_songs"
WHERE
    "song_id" IN (
        SELECT
            song_id
        FROM
            temp_deleted_songs
    );

-- Delete from recommendations
DELETE FROM "user_song_recommendations"
WHERE
    "song_id" IN (
        SELECT
            song_id
        FROM
            temp_deleted_songs
    );

-- Delete from album_songs 
DELETE FROM "album_songs"
WHERE
    "album_id" = $1;

-- Delete from songs
DELETE FROM "song"
WHERE
    "id" IN (
        SELECT
            song_id
        FROM
            temp_deleted_songs
    );

-- Finally, delete the album
DELETE FROM "album"
WHERE
    "id" = $1;

-- Drop the temporary table
DROP TABLE temp_deleted_songs;

COMMIT;

-- params: [albumId: string]