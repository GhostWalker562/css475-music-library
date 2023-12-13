SELECT
    *
FROM
    "user_session"
WHERE
    "id" = $1;

-- params: [id: string]