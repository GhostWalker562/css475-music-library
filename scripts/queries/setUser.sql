-- If the user exists
INSERT INTO
    "auth_user" (
        "id",
        "username",
        "github_username",
        "email",
        "created_at",
        "profile_image_url"
    )
VALUES
    ($1, $2, $3, $4, $5, $6);

-- If the user does not exist
BEGIN;

INSERT INTO
    "auth_user" (
        "id",
        "username",
        "github_username",
        "email",
        "created_at",
        "profile_image_url"
    )
VALUES
    ($1, $2, $3, $4, $5, $6);

INSERT INTO
    "user_key" ("id", "user_id", "hashed_password")
VALUES
    ($7, $1, $8);

COMMIT;

-- params: [generateRandomString(15), username: string, githubUsername: string | null, email: string | null, createdAt: string, profileImageUrl: string | null, keyId: string, hashedPassword: string]