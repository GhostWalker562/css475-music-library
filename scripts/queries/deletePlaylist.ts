import { db } from '$lib/db';
import { playlist, playlistSongs } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const deletePlaylist = (playlistId: string) =>
	db.transaction(async () => {
		await db.delete(playlistSongs).where(eq(playlistSongs.playlistId, playlistId));
		return db.delete(playlist).where(eq(playlist.id, playlistId)).returning();
	});
