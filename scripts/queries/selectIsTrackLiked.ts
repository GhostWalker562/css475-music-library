import { db } from '$lib/db';
import { song, user, userLikes } from '$lib/db/schema';
import { eq, sql } from 'drizzle-orm';

export const selectIsTrackLiked = async (userId: string, songId: string) =>
	(
		await db
			.select({ count: sql<number>`COUNT(*)` })
			.from(userLikes)
			.innerJoin(user, eq(userLikes.userId, userId))
			.innerJoin(song, eq(userLikes.songId, songId))
	)[0].count > 0;
