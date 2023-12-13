SELECT
  *
FROM
  "playlist"
  INNER JOIN "user" ON "user"."id" = "playlist"."user_id"
WHERE
  "playlist"."id" = $1
LIMIT
  1;

-- params: [playlistId: string]