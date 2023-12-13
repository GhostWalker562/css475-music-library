DO $$
DECLARE
    user_exists boolean;
BEGIN
    -- Check if the artist exists
    SELECT EXISTS(SELECT 1 FROM artist WHERE id = $1) INTO user_exists;

    IF user_exists THEN
        -- Update the existing artist
        UPDATE artist
        SET name = $2, bio = $3
        WHERE id = $1;
    ELSE
        -- Insert a new artist
        INSERT INTO artist (id, name, bio)
        VALUES ($1, $2, $3);
    END IF;
END $$;

-- params: [userId: string, name: string, bio: string]