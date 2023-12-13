SELECT COUNT(*) AS count
FROM "album"
INNER JOIN "artist" ON "artist"."id" = "album"."artist_id";

-- params: []