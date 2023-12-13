-- If 'method' is 'ADD', get the latest order and insert a new record
BEGIN;

WITH
    max_order AS ( -- Get the latest order
        SELECT
            COALESCE(MAX("order"), 0) AS latest_order -- If there is no record, set the latest order to 0
        FROM
            "playlist_songs"
        WHERE
            "playlist_id" = $1
    )
INSERT INTO
    "playlist_songs" ("playlist_id", "song_id", "order") -- Insert a new record using the data from the previous query.
SELECT
    $1,
    $2,
    latest_order + 1
FROM
    max_order ON CONFLICT
DO NOTHING;

COMMIT;

-- If 'method' is 'REMOVE', delete the existing record
DELETE FROM "playlist_songs"
WHERE
    "playlist_id" = $1
    AND "song_id" = $2;

-- params: [playlistId: string, songId: string]