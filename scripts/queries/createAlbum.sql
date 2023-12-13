INSERT INTO
    "album" ("id", "name", "artist_id", "cover_image_url")
VALUES
    ($1, $2, $3, $4)
RETURNING
    *;

-- params: [generateRandomString(50), name, artistId, coverImageUrl]