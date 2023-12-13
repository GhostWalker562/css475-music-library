BEGIN;

SELECT
    1
FROM
    artist
WHERE
    id = $1;

-- If the artist exists, update the name and bio
UPDATE artist
SET
    name = $2,
    bio = $3
WHERE
    id = $1;

-- If the artist does not exist, insert a new row
INSERT INTO
    artist (id, name, bio)
VALUES
    ($1, $2, $3);

COMMIT;

-- params: [userId: string, name: string, bio: string]