import { db } from '$lib/db';
import { userSongRecommendations } from '$lib/db/schema';
import { generateRandomString } from 'lucia/utils';
import { getRandomElements } from '../utils/getRandomElement';
import { eq, sql } from 'drizzle-orm';

export const createRecommendation = (userId: string, songId: string) =>
	db.insert(userSongRecommendations).values({
		id: generateRandomString(50),
		songId,
		userId
	});

export const createRandomRecommendations = async (userId: string, count: number) => {
	try {
		await db.transaction(async (tx) => {
			// Check if user already has recommendations
			const currentRecommendationsCount = (
				await tx
					.select({ count: sql<number>`COUNT(*)` })
					.from(userSongRecommendations)
					.where(eq(userSongRecommendations.userId, userId))
					.limit(1)
			)[0].count;
			if (currentRecommendationsCount > 0) return;

			// Get random songs
			const songs = await tx.query.song.findMany();
			if (songs.length < count) return;
			const randomSongs = getRandomElements(songs, count);

			// Insert recommendations into database
			for (const song of randomSongs) {
				await tx.insert(userSongRecommendations).values({
					id: generateRandomString(50),
					songId: song.id,
					userId
				});
			}
		});
	} catch (error) {
		console.warn(`Failed to create recommendations for ${userId}`, error);
	}
};
