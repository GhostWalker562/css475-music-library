INSERT INTO
    "album" ("id", "name", "artistId", "coverImageUrl")
VALUES
    ($1, $2, $3, $4)
RETURNING
    *;

-- params: [generateRandomString(50), name, artistId, coverImageUrl]