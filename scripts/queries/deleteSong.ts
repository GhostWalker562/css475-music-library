import { db } from '$lib/db';
import { albumSongs, playlistSongs, song, userLikes } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const deleteSong = (id: string) =>
	db.transaction(async () => {
		await db.delete(albumSongs).where(eq(albumSongs.songId, id));
		await db.delete(playlistSongs).where(eq(playlistSongs.songId, id));
		await db.delete(userLikes).where(eq(userLikes.songId, id));
		return db.delete(song).where(eq(song.id, id)).returning();
	});
