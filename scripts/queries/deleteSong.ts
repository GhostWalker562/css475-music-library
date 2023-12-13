import { db } from '$lib/db';
import {
	albumSongs,
	playlistSongs,
	song,
	userLikes,
	userSongRecommendations
} from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const deleteSong = (id: string) =>
	db.transaction(async (tx) => {
		await tx.delete(albumSongs).where(eq(albumSongs.songId, id));
		await tx.delete(playlistSongs).where(eq(playlistSongs.songId, id));
		await tx.delete(userSongRecommendations).where(eq(userSongRecommendations.songId, id));
		await tx.delete(userLikes).where(eq(userLikes.songId, id));
		return tx.delete(song).where(eq(song.id, id)).returning();
	});
