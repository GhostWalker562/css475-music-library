SELECT
  *
FROM
  "album"
WHERE
  "album"."artist_id" = $1;

-- params: [userId: string]