import { db } from '$lib/db';
import { song, user, userLikes } from '$lib/db/schema';
import { and, eq, sql } from 'drizzle-orm';

export const toggleLike = (userId: string, songId: string, like: boolean) =>
	db.transaction(async (tx) => {
		const isLiked =
			(
				await tx
					.select({ count: sql<number>`COUNT(*)` })
					.from(userLikes)
					.innerJoin(user, eq(userLikes.userId, userId))
					.innerJoin(song, eq(userLikes.songId, songId))
			)[0].count > 0;

		if (like === isLiked) return like;

		if (like) {
			await tx.insert(userLikes).values({ userId, songId });
		} else if (!like) {
			await tx
				.delete(userLikes)
				.where(and(eq(userLikes.songId, songId), eq(userLikes.userId, userId)));
		}

		return like;
	});
