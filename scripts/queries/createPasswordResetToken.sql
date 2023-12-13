INSERT INTO
    "password_reset" ("id", "user_id", "expires")
VALUES
    ($1, $2, $3);

-- params: [generateRandomString(63), userId: string, expires: number]