import { db } from '$lib/db';
import { song, userLikes } from '$lib/db/schema';
import { eq, sql } from 'drizzle-orm';

export const selectTotalLikes = async (artistId: string) => {
	const nestedQuery = db
		.select({ likesSongId: userLikes.songId })
		.from(userLikes)
		.innerJoin(song, eq(song.id, userLikes.songId))
		.where(eq(song.artistId, artistId))
		.as('nestedQuery');

	const result = await db.select({ count: sql<number>`COUNT(*)` }).from(nestedQuery);
	return result[0]?.count ?? 0;
};
