SELECT
    *
FROM
    "auth_user"
WHERE
    "id" = $1;

-- params: [userId: string]