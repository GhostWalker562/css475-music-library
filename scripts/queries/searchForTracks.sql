SELECT
    *
FROM
    "album_songs"
    INNER JOIN "song" ON "song"."id" = "album_songs"."song_id"
    INNER JOIN "album" ON "album"."id" = "album_songs"."album_id"
    INNER JOIN "artist" ON "artist"."id" = "song"."artist_id"
WHERE
    to_tsvector('simple', "song"."name") @@ to_tsquery('simple', $1)
    OR to_tsvector('simple', "artist"."name") @@ to_tsquery('simple', $1);

-- params: [searchQuery: string]