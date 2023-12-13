SELECT
    *
FROM
    "album_songs"
    INNER JOIN "album" ON "album"."id" = "album_songs"."album_id"
    INNER JOIN "song" ON "song"."id" = "album_songs"."song_id"
    INNER JOIN "artist" ON "artist"."id" = "song"."artist_id"
    LEFT JOIN "user_likes" ON "user_likes"."song_id" = "song"."id"
    AND "user_likes"."user_id" = $1
WHERE
    "album_songs"."album_id" = $2
ORDER BY
    "album_songs"."order";

-- params: [userId: string, albumId: string]