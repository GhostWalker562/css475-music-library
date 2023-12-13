SELECT
    *
FROM
    "user_session"
WHERE
    "user_id" = $1;

-- params: [userId: string]