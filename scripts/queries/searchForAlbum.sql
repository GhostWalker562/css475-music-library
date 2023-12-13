SELECT
    *
FROM
    "album"
    INNER JOIN "artist" ON "artist"."id" = "album"."artist_id"
WHERE
    to_tsvector('simple', "album"."name") @@ to_tsquery('simple', $1);

-- params: [searchQuery: string]