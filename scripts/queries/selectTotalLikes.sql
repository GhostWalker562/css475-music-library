SELECT
  COUNT(*)
FROM
  (
    SELECT
      "user_likes"."song_id"
    FROM
      "user_likes"
      INNER JOIN "song" ON "song"."id" = "user_likes"."song_id"
    WHERE
      "song"."artist_id" = $1
  ) AS "nestedQuery";

-- params: [artistId: string]