SELECT
    *
FROM
    "song"
    INNER JOIN "playlist_songs" ON "playlist_songs"."song_id" = "song"."id"
    INNER JOIN "artist" ON "artist"."id" = "song"."artist_id"
    INNER JOIN "album_songs" ON "album_songs"."song_id" = "song"."id"
    INNER JOIN "album" ON "album"."id" = "album_songs"."album_id"
    LEFT JOIN "user_likes" ON "user_likes"."song_id" = "song"."id"
    AND "user_likes"."user_id" = $1
WHERE
    "playlist_songs"."playlist_id" = $2
ORDER BY
    "playlist_songs"."order";

-- params: [userId, playlistId]