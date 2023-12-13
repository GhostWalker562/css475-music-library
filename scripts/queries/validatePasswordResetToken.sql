BEGIN;

SELECT
    *
FROM
    "password_reset"
WHERE
    "id" = $1;

-- If the token exists and is not expired, then delete it and all sessions for the user.
DELETE FROM "password_reset"
WHERE
    "id" = $2;

COMMIT;

-- params: [id: string, tokenId: string]