SELECT
    *
FROM
    "artist"
    INNER JOIN "auth_user" ON "auth_user"."id" = "artist"."id"
LIMIT
    $1
OFFSET
    $2;

-- params: [limit: number, offset: number]