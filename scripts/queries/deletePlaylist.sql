BEGIN;

-- Delete all songs associated with the playlist
DELETE FROM "playlist_songs"
WHERE "playlist_id" = $1;

-- Delete the playlist
DELETE FROM "playlist"
WHERE "id" = $1;

COMMIT;

-- params: [playlistId: string]