SELECT
  *
FROM
  "user_likes"
  INNER JOIN "song" ON "song"."id" = "user_likes"."song_id"
  INNER JOIN "album_songs" ON "album_songs"."song_id" = "song"."id"
  INNER JOIN "album" ON "album"."id" = "album_songs"."album_id"
  INNER JOIN "artist" ON "artist"."id" = "song"."artist_id"
WHERE
  "user_likes"."user_id" = $1;

-- params: [userId: string]