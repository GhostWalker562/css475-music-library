UPDATE "user_key"
SET
    "id" = $1,
    "user_id" = $2,
    "hashed_password" = $3,
WHERE
    "id" = $4;

-- params: [id: string, userId: string, hashedPassword: string | null, id: string]