import { db } from '$lib/db';
import { playlist } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const modifyPlaylist = (playlistId: string, name: string) =>
	db.update(playlist).set({ name }).where(eq(playlist.id, playlistId)).returning();
