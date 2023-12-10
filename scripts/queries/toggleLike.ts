import { db } from '$lib/db';
import { userLikes } from '$lib/db/schema';
import { and, eq } from 'drizzle-orm';

export const toggleLike = (userId: string, songId: string, like: boolean) =>
	db.transaction(async (tx) => {
		if (like) {
			await tx.insert(userLikes).values({ userId, songId }).onConflictDoNothing();
		} else {
			await tx
				.delete(userLikes)
				.where(and(eq(userLikes.songId, songId), eq(userLikes.userId, userId)));
		}

		return like;
	});
