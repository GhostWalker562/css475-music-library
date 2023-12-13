SELECT
    *
FROM
    "password_reset"
WHERE
    "user_id" = $1;

-- params: [userId: string]