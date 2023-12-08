import { db } from '$lib/db';
import { playlist, playlistSongs } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectPlaylistsWithTrack = (songId: string) =>
	db
		.select()
		.from(playlist)
		.innerJoin(playlistSongs, eq(playlistSongs.playlistId, playlist.id))
		.where(eq(playlistSongs.songId, songId));
