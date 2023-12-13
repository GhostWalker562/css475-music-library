SELECT
    *
FROM
    "artist"
    INNER JOIN "auth_user" ON "auth_user"."id" = "artist"."id"
WHERE
    to_tsvector('simple', "artist"."name") @@ to_tsquery('simple', $1);

-- params: [searchQuery: string]