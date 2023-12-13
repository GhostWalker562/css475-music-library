SELECT
    *
FROM
    "user_key"
WHERE
    "user_id" = $1;

-- params: [userId: string]