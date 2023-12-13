UPDATE "auth_user"
SET
    username = $1,
    email = $2,
    created_at = $3,
    profile_image_url = $4
WHERE
    id = $5;

-- params: [username: string, email: string, createdAt: string, profileImageUrl: string, id: string]