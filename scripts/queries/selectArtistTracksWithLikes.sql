SELECT
  *
FROM
  "song"
  INNER JOIN "artist" ON "artist"."id" = "song"."artist_id"
  INNER JOIN "album_songs" ON "album_songs"."song_id" = "song"."id"
  INNER JOIN "album" ON "album"."id" = "album_songs"."album_id"
  LEFT JOIN "user_likes" ON "user_likes"."song_id" = "song"."id"
  AND "user_likes"."user_id" = $1
WHERE
  "artist"."id" = $2;

-- params: [userId: string, artistId: string]