import { eq } from 'drizzle-orm';
import { promises as fs } from 'fs';
import { generateRandomString } from 'lucia/utils';
import * as schema from '../src/lib/db/schema';
import { db } from './utils/connection';
import { getRandomElements } from './utils/getRandomElement';

const user = await db.query.user.findFirst({ where: eq(schema.user.email, 'g@g.com') });

if (!user) throw new Error('User not found');

const songs = await db.query.song.findMany();

const insertRelationshipsPath = `${__dirname}/seed/insert_relationships.sql`;
await fs.writeFile(insertRelationshipsPath, '', {});

// Generate insert statements for playlists
const generatePlaylists = async (filePath: string) => {
	await fs.appendFile(filePath, '-- Playlists\n', {});
	for (let i = 0; i < 2; i++) {
		const playlistSongs = getRandomElements(songs, 5);
		const playlistId = generateRandomString(50);

		const insertPlaylistQuery = `INSERT INTO "playlist" ("id", "name", "created_at", "user_id") VALUES ('${playlistId}', 'Playlist ${i}', '2023-11-17 17:00:08.000','${user.id}');\n`;
		await fs.appendFile(filePath, insertPlaylistQuery, {});

		await Promise.all(
			playlistSongs.map(async (song, i) => {
				const insertPlaylistSongQuery = `INSERT INTO "playlist_songs" ("song_id", "playlist_id", "order") VALUES ('${song.id}', '${playlistId}', ${i});\n`;
				await fs.appendFile(filePath, insertPlaylistSongQuery, {});
			})
		);
	}
};

// Generate insert statements for user likes
const generateUserLikes = async (filePath: string) => {
	await fs.appendFile(filePath, '-- User Likes\n', {});
	const userLikes = getRandomElements(songs, 10);
	await Promise.all(
		userLikes.map(async (song) => {
			const insertUserLikeQuery = `INSERT INTO "user_likes" ("user_id", "song_id") VALUES ('${user.id}', '${song.id}');\n`;
			await fs.appendFile(filePath, insertUserLikeQuery, {});
		})
	);
};

// Generate insert statements for user song recommendations
const generateUserSongRecommendations = async (filePath: string) => {
	await fs.appendFile(filePath, '-- User Song Recommendations\n', {});
	const userSongRecommendations = getRandomElements(songs, 10);
	await Promise.all(
		userSongRecommendations.map(async (song) => {
			const recommendationId = generateRandomString(50);
			const insertUserSongRecommendationQuery = `INSERT INTO "user_song_recommendations" ("id", "user_id", "song_id", "created_at") VALUES ('${recommendationId}', '${user.id}', '${song.id}', '2023-11-17 17:00:08.000');\n`;
			await fs.appendFile(filePath, insertUserSongRecommendationQuery, {});
		})
	);
};

async function main() {
	await generatePlaylists(insertRelationshipsPath);
	await generateUserLikes(insertRelationshipsPath);
	await generateUserSongRecommendations(insertRelationshipsPath);

	console.log('Generated insert statements for relationships!');
	process.exit(0);
}
await main();
