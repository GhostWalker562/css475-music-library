import { db } from '$lib/db';
import { song, playlist, playlistSongs, artist } from '$lib/db/schema';
import { eq, sql } from 'drizzle-orm';

export const selectTotalPlaylists = async (artistId: string) => {
	const result = await db
		.select({ count: sql<number>`COUNT(*)` })
		.from(playlist)
		.innerJoin(playlistSongs, eq(playlistSongs.playlistId, playlist.id))
		.innerJoin(song, eq(song.id, playlistSongs.songId))
		.innerJoin(artist, eq(artist.id, song.artistId))
		.where(eq(artist.id, artistId))
		.groupBy(artist.id);
	return result[0]?.count ?? 0;
}; 
