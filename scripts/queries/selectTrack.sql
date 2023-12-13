SELECT
  *
FROM
  "album_songs"
  INNER JOIN "song" ON "song"."id" = "album_songs"."song_id"
  INNER JOIN "album" ON "album"."id" = "album_songs"."album_id"
  INNER JOIN "artist" ON "artist"."id" = "song"."artist_id"
WHERE
  "album_songs"."song_id" = $1
LIMIT
  1;

-- params: [id: string]