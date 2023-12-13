SELECT
    *
FROM
    "user_key"
WHERE
    "id" = $1;

-- params: [keyId: string]