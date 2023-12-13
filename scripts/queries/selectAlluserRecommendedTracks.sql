SELECT
    *
FROM
    "user_song_recommendations"
    INNER JOIN "song" ON "song"."id" = "user_song_recommendations"."song_id"
    INNER JOIN "album_songs" ON "album_songs"."song_id" = "song"."id"
    INNER JOIN "album" ON "album"."id" = "album_songs"."album_id"
    INNER JOIN "artist" ON "artist"."id" = "song"."artist_id"
WHERE
    "user_song_recommendations"."user_id" = $1;

-- params: [id: string]