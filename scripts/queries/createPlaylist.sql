INSERT INTO
    "playlist" ("id", "name", "user_id")
VALUES
    ($1, $2, $3)
RETURNING
    *;

-- params: [generateRandomString(50), name, userId],