import { db } from '$lib/db';
import { playlistSongs } from '$lib/db/schema';
import { and, eq, sql } from 'drizzle-orm';

export const modifyPlaylistSong = (playlistId: string, songId: string, method: 'ADD' | 'REMOVE') =>
	db.transaction(async (tx) => {
		const [playlistSongExists, latestOrder] = await Promise.all([
			(async () =>
				(
					await tx
						.select({ count: sql<number>`COUNT(*)` })
						.from(playlistSongs)
						.where(and(eq(playlistSongs.playlistId, playlistId), eq(playlistSongs.songId, songId)))
						.limit(1)
				).length === 0)(),
			(async () =>
				(
					await tx
						.select({ order: sql<number>`MAX(${playlistSongs.order})` })
						.from(playlistSongs)
						.where(eq(playlistSongs.playlistId, playlistId))
				)[0].order || 0)()
		]);

		if (playlistSongExists && method === 'ADD') return true;

		if (method === 'ADD') {
			await tx.insert(playlistSongs).values({ playlistId, songId, order: latestOrder + 1 });
			return true;
		} else {
			await tx
				.delete(playlistSongs)
				.where(and(eq(playlistSongs.playlistId, playlistId), eq(playlistSongs.songId, songId)));
			return false;
		}
	});
