SELECT
  *
FROM
  "artist"
  INNER JOIN "user" ON "artist"."id" = "user"."id"
WHERE
  "artist"."id" = $1
LIMIT
  1;

-- params: artistId: string]