-- If the session does not exists
INSERT INTO
    "user_session" ("id", "user_id", "active_expires", "idle_expires")
VALUES
    ($1, $2, $3, $4);

-- params: [sessionId: string, userId: string, activeExpires: number, idleExpires: number]