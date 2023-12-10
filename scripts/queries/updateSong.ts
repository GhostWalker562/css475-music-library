import { db } from '$lib/db';
import { song } from '$lib/db/schema';
import type { Genre } from '$lib/types/music';
import { eq } from 'drizzle-orm';

export const updateSong = (
	id: string,
	name: string,
	previewUrl: string | null | undefined,
	genre: Genre
) => db.update(song).set({ name, previewUrl, genre }).where(eq(song.id, id)).returning();
