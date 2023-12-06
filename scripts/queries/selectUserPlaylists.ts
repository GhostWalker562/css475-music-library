import { db } from '$lib/db';
import { playlist } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectUserPlaylists = (userId: string) =>
	db.select().from(playlist).where(eq(playlist.userId, userId));
