import { db } from '$lib/db';
import { playlist } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectPlaylist = (playlistId: string) =>
	db.select().from(playlist).where(eq(playlist.id, playlistId)).limit(1);
