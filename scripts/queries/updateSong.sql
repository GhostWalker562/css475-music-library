UPDATE "song"
SET
    "name" = $1,
    "preview_url" = $2,
    "genre" = $3
WHERE
    "id" = $4
RETURNING
    *;

-- params: [name: string, previewUrl: string | null | undefined, genre: Genre, id: string]