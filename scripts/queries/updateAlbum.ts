import { db } from '$lib/db';
import { album } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const updateAlbum = (id: string, name: string, coverImageUrl: string) =>
	db.update(album).set({ name, coverImageUrl }).where(eq(album.id, id)).returning();
