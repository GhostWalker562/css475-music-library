SELECT
  *
FROM
  "playlist"
WHERE
  "playlist"."id" = $1
LIMIT
  1;

-- params: [playlistId: string]