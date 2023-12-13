SELECT
  COUNT(*)
FROM
  "artist"
  INNER JOIN "auth_user" ON "artist"."id" = "auth_user"."id"