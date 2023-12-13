SELECT
    *
FROM
    "album"
WHERE
    "id" = $1
LIMIT
    1;

-- params: [id: string]