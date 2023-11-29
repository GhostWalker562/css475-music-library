import { eq } from 'drizzle-orm';
import { promises as fs } from 'fs';
import { generateRandomString } from 'lucia/utils';
import * as schema from '../src/lib/db/schema';
import { db } from './utils/connection';
import { getRandomElements } from './utils/getRandomElement';
import { generateRandomName } from './utils/generateRandomName';
import { generateRandomUserInsert } from './utils/generateRandomUserInsert';

const songs = await db.query.song.findMany();
const insertRelationshipsPath = `${__dirname}/seed/insert_relationships.sql`;
await fs.writeFile(insertRelationshipsPath, '', {});

const generateUsers = async (filePath: string): Promise<string[]> => {
	const userIds: string[] = [];
	await fs.appendFile(filePath, '-- Users\n', {});
	for (let i = 0; i < 10; i++) {
		const username = `${generateRandomName()} (${i})`;
		const email = `${i}@g.com`;
		const { id, query } = generateRandomUserInsert(username, email);
		await fs.appendFile(filePath, query, {});
		userIds.push(id);
	}
	return userIds;
};

// Generate insert statements for playlists
const generatePlaylists = async (
	filePath: string,
	userIds: string[],
	playlistCount: number,
	songsPerPlaylist: number
) => {
	await fs.appendFile(filePath, '-- Playlists\n', {});
	for (const userId of userIds) {
		for (let i = 0; i < playlistCount; i++) {
			const playlistSongs = getRandomElements(songs, songsPerPlaylist);
			const playlistId = generateRandomString(50);

			const insertPlaylistQuery = `INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('${playlistId}', 'Playlist ${i}', '2023-11-17 17:00:08.000','${userId}');\n`;
			await fs.appendFile(filePath, insertPlaylistQuery, {});

			await Promise.all(
				playlistSongs.map(async (song, i) => {
					const insertPlaylistSongQuery = `INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('${song.id}', '${playlistId}', ${i});\n`;
					await fs.appendFile(filePath, insertPlaylistSongQuery, {});
				})
			);
		}
	}
};

// Generate insert statements for user likes
const generateUserLikes = async (filePath: string, userIds: string[], songsPerUserId: number) => {
	await fs.appendFile(filePath, '-- User Likes\n', {});
	for (const userId of userIds) {
		const userLikes = getRandomElements(songs, songsPerUserId);
		await Promise.all(
			userLikes.map(async (song) => {
				const insertUserLikeQuery = `INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('${userId}', '${song.id}');\n`;
				await fs.appendFile(filePath, insertUserLikeQuery, {});
			})
		);
	}
};

// Generate insert statements for user song recommendations
const generateUserSongRecommendations = async (
	filePath: string,
	userIds: string[],
	songsPerUserId: number
) => {
	await fs.appendFile(filePath, '-- User Song Recommendations\n', {});
	for (const userId of userIds) {
		const userSongRecommendations = getRandomElements(songs, songsPerUserId);
		await Promise.all(
			userSongRecommendations.map(async (song) => {
				const recommendationId = generateRandomString(50);
				const insertUserSongRecommendationQuery = `INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('${recommendationId}', '${userId}', '${song.id}', '2023-11-17 17:00:08.000');\n`;
				await fs.appendFile(filePath, insertUserSongRecommendationQuery, {});
			})
		);
	}
};

async function main() {
	const user = await db.query.user.findFirst({ where: eq(schema.user.email, 'g@g.com') });
	if (!user) throw new Error('Admin user not found');

	const userIds = await generateUsers(insertRelationshipsPath);
	userIds.push(user.id);

	await generatePlaylists(insertRelationshipsPath, userIds, 2, 10);
	await generateUserLikes(insertRelationshipsPath, userIds, 15);
	await generateUserSongRecommendations(insertRelationshipsPath, userIds, 8);

	console.log('Generated insert statements for relationships!');
	process.exit(0);
}
await main();
