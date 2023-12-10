import { db } from '$lib/db';
import { playlist } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const updatePlaylist = (playlistId: string, name: string) =>
	db.update(playlist).set({ name }).where(eq(playlist.id, playlistId)).returning();
