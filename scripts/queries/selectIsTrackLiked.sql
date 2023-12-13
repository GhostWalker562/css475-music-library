SELECT
    COUNT(*) AS count
FROM
    "user_likes"
    INNER JOIN "auth_user" ON "auth_user"."id" = "user_likes"."user_id"
    INNER JOIN "song" ON "song"."id" = "user_likes"."song_id"
WHERE
    "user_likes"."user_id" = $1
    AND "user_likes"."song_id" = $2;

-- params: [userId: string, songId: string]