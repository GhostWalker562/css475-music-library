BEGIN;

-- Insert the song into the song table
INSERT INTO
    "song" ("id", "artist_id", "name", "preview_url", "genre")
VALUES
    ($1, $2, $3, $4, $5);

-- Insert the relationship between the album and the song into the album_songs table
INSERT INTO
    "album_songs" ("album_id", "song_id")
VALUES
    ($6, $1);

COMMIT;

-- params: [songId: string, artistId: string, name: string, previewUrl: string | null, genre: Genre, albumId: string]