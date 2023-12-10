import { db } from '$lib/db';
import { song, userLikes, artist } from '$lib/db/schema';
import { eq, sql } from 'drizzle-orm';

export const selectTotalLikes = async (artistId: string) => {
	const result = await db
		.select({ count: sql<number>`COUNT(*)` })
		.from(userLikes)
		.innerJoin(song, eq(song.id, userLikes.songId))
		.innerJoin(artist, eq(artist.id, song.artistId))
		.where(eq(artist.id, artistId))
		.groupBy(artist.id);

	// Assuming the result is an array with one object
  // Return the count, or 0 if there's no result
	return result[0]?.count ?? 0; 
};

