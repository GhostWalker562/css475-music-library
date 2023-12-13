UPDATE "album"
SET
    "name" = $1,
    "cover_image_url" = $2
WHERE
    "id" = $3
RETURNING
    *;

-- params: [name: string, coverImageUrl: string, id: string]