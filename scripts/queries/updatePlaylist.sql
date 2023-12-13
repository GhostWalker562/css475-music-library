UPDATE "playlist"
SET
    "name" = $1
WHERE
    "id" = $2
RETURNING
    *;

-- params: [name: string, playlistId: string]