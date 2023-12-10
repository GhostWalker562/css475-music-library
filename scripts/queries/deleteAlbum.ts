import { db } from '$lib/db';
import { album, albumSongs, song } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const deleteAlbum = (id: string) =>
	db.transaction(async () => {
		const rows = await db.delete(albumSongs).where(eq(albumSongs.albumId, id)).returning();
		for (const albumSong of rows) await db.delete(song).where(eq(song.id, albumSong.songId));
		return db.delete(album).where(eq(album.id, id)).returning();
	});
