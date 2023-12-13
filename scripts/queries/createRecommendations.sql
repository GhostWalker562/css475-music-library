INSERT INTO
    "user_song_recommendations" ("id", "song_id", "user_id")
VALUES
    ($1, $2, $3);

-- params: [generateRandomString(50): string, name: string, userId: string]