SELECT
  COUNT(*)
FROM
  (
    SELECT
      "playlist"."id"
    FROM
      "playlist"
      INNER JOIN "playlist_songs" ON "playlist_songs"."playlist_id" = "playlist"."id"
      INNER JOIN "song" ON "song"."id" = "playlist_songs"."song_id"
    WHERE
      "song"."artist_id" = $1
    GROUP BY
      "playlist"."id"
  ) AS "nestedQuery";

-- params: [artistId: string]