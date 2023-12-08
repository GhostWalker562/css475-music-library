import { db } from '$lib/db';
import { playlist, user } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectPlaylistCreator = (playlistId: string) =>
	db
		.select()
		.from(playlist)
		.where(eq(playlist.id, playlistId))
		.innerJoin(user, eq(user.id, playlist.userId))
		.limit(1);
