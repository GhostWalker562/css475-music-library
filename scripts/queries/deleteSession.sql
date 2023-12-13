DELETE FROM "user_session"
WHERE
    "id" = $1;

-- params: [sessionId: string]