BEGIN;

-- Delete the song from albumSongs
DELETE FROM "album_songs"
WHERE "song_id" = $1;

-- Delete the song from playlistSongs
DELETE FROM "playlist_songs"
WHERE "song_id" = $1;

-- Delete the song from userSongRecommendations
DELETE FROM "user_song_recommendations"
WHERE "song_id" = $1;

-- Delete the song from userLikes
DELETE FROM "user_likes"
WHERE "song_id" = $1;

-- Finally, delete the song itself
DELETE FROM "song"
WHERE "id" = $1;

COMMIT;

-- params: [songId: string]