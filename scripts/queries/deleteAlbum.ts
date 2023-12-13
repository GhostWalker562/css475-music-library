import { db } from '$lib/db';
import {
	album,
	albumSongs,
	playlistSongs,
	song,
	userLikes,
	userSongRecommendations
} from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const deleteAlbum = (id: string) =>
	db.transaction(async (tx) => {
		const rows = await tx.delete(albumSongs).where(eq(albumSongs.albumId, id)).returning();
		for (const albumSong of rows) {
			await tx.delete(userLikes).where(eq(userLikes.songId, albumSong.songId));
			await tx.delete(playlistSongs).where(eq(playlistSongs.songId, albumSong.songId));
			await tx
				.delete(userSongRecommendations)
				.where(eq(userSongRecommendations.songId, albumSong.songId));
			await tx.delete(song).where(eq(song.id, albumSong.songId));
		}
		return tx.delete(album).where(eq(album.id, id)).returning();
	});
