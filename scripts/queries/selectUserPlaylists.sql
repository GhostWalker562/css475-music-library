SELECT
  *
FROM
  "playlist"
WHERE
  "playlist"."user_id" = $1;

-- params: [userId: string]