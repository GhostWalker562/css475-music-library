import { promises as fs } from 'fs';
import { connect } from '@planetscale/database';
import * as dotenv from 'dotenv';
import * as schema from '../src/lib/db/schema';
import { drizzle } from 'drizzle-orm/planetscale-serverless';
import { eq } from 'drizzle-orm';
import { getRandomElements } from './utils/getRandomElement';
import { generateRandomString } from 'lucia/utils';
import { executeQuery } from './utils/executeQuery';
dotenv.config();

export const connection = connect({ url: process.env.DATABASE_URL });

export const db = drizzle(connection, { schema });

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

		const insertPlaylistQuery = `INSERT INTO \`playlist\` (\`id\`, \`name\`, \`created_at\`, \`creator_id\`) VALUES ('${playlistId}', 'Playlist ${i}', '2023-11-17 17:00:08.000','${user.id}');\n`;
		await fs.appendFile(filePath, insertPlaylistQuery, {});

		await Promise.all(
			playlistSongs.map(async (song, i) => {
				const insertPlaylistSongQuery = `INSERT INTO \`playlist_songs\` (\`song_id\`, \`playlist_id\`, \`order\`) VALUES ('${song.id}', '${playlistId}', ${i});\n`;
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
			const insertUserLikeQuery = `INSERT INTO \`user_likes\` (\`user_id\`, \`song_id\`) VALUES ('${user.id}', '${song.id}');\n`;
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
			const insertUserSongRecommendationQuery = `INSERT INTO \`user_song_recommendations\` (\`id\`, \`user_id\`, \`song_id\`, \`created_at\`) VALUES ('${recommendationId}', '${user.id}', '${song.id}', '2023-11-17 17:00:08.000');\n`;
			await fs.appendFile(filePath, insertUserSongRecommendationQuery, {});
		})
	);
};

await generatePlaylists(insertRelationshipsPath);
await generateUserLikes(insertRelationshipsPath);
await generateUserSongRecommendations(insertRelationshipsPath);

console.log('Generated insert statements for relationships!');
console.log('Inserting relationships data...');
const relationshipsQuery = await fs.readFile(`${__dirname}/seed/insert_relationships.sql`, {
	encoding: 'utf-8'
});
await executeQuery(relationshipsQuery, connection, false);
console.log('Inserted relationships data!');
