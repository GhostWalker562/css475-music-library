-- If 'like' is true, insert a new record
INSERT INTO
    "user_likes" ("user_id", "song_id")
VALUES
    ($1, $2) ON CONFLICT
DO NOTHING;

-- If 'like' is false, delete the existing record
DELETE FROM "user_likes"
WHERE
    "song_id" = $1
    AND "user_id" = $2;

-- params: [userId: string, songId: string]