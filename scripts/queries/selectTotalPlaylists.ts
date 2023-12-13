import { db } from '$lib/db';
import { song, playlist, playlistSongs } from '$lib/db/schema';
import { eq, sql } from 'drizzle-orm';

export const selectTotalPlaylists = async (artistId: string) => {
	const nestedQuery = db
		.select({ playlistId: playlist.id })
		.from(playlist)
		.innerJoin(playlistSongs, eq(playlistSongs.playlistId, playlist.id))
		.innerJoin(song, eq(song.id, playlistSongs.songId))
		.where(eq(song.artistId, artistId))
		.groupBy(playlist.id)
		.as('nestedQuery');

	const result = await db.select({ count: sql<number>`COUNT(*)` }).from(nestedQuery);
	return result[0]?.count ?? 0;
};
