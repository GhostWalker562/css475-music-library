INSERT INTO
    "user_key" ("id", "user_id", "hashed_password")
VALUES
    ($1, $2, $3);

-- params: [keyId: string, userId: string, hashedPassword: string | Null]