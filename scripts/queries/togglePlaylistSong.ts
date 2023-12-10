import { db } from '$lib/db';
import { playlistSongs } from '$lib/db/schema';
import { and, eq, sql } from 'drizzle-orm';

export const togglePlaylistSong = (playlistId: string, songId: string, method: 'ADD' | 'REMOVE') =>
	db.transaction(async (tx) => {
		if (method === 'ADD') {
			const latestOrder =
				(
					await tx
						.select({ order: sql<number>`MAX(${playlistSongs.order})` })
						.from(playlistSongs)
						.where(eq(playlistSongs.playlistId, playlistId))
						.limit(1)
				).at(0)?.order ?? 0;
			await tx
				.insert(playlistSongs)
				.values({ playlistId, songId, order: latestOrder + 1 })
				.onConflictDoNothing();
			return true;
		} else {
			await tx
				.delete(playlistSongs)
				.where(and(eq(playlistSongs.playlistId, playlistId), eq(playlistSongs.songId, songId)));
			return false;
		}
	});
