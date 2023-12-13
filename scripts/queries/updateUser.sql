UPDATE "auth_user"
SET
    username = $1,
    github_username = $2,
    email = $3,
    created_at = $4,
    profile_image_url = $5
WHERE
    id = $6;

-- params: [username: string, github_username: string, email: string, created_at: string, profile_image_url: string, id: string]