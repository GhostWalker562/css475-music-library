UPDATE "user_session"
SET
    "active_expires" = $1,
    "idle_expires" = $2
WHERE
    "id" = $3;

-- params: [activeExpires: bigint, idleExpires: bigint, id: string]