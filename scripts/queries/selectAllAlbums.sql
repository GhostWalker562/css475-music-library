SELECT
    *
FROM
    "album"
    INNER JOIN "artist" ON "artist"."id" = "album"."artist_id"
LIMIT
    $1
OFFSET
    $2;

-- params: [limit: number, offset: number]