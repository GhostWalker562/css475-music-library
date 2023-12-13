SELECT
  *
FROM
  "playlist"
  INNER JOIN "playlist_songs" ON "playlist_songs"."playlist_id" = "playlist"."id"
WHERE
  "playlist_songs"."song_id" = $1;

-- params: [songId: string]