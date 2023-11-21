import { promises as fs } from 'fs';
import { parse } from 'csv-parse';
import { generateRandomString } from 'lucia/utils';
import { connect } from '@planetscale/database';
import { executeQuery } from './utils/executeQuery';

interface Song {
	track_name: string;
	artists_name: string;
	artist_count: number;
	released_year: number;
	released_month: number;
	released_day: number;
	spotify_track_id: string;
	spotify_preview_url: string;
	spotify_album_cover_url: string;
}

const fileContent = await fs.readFile(`${__dirname}/seed/updated-dataset.csv`, {
	encoding: 'utf-8'
});

const headers = [
	'track_name',
	'artists_name',
	'artist_count',
	'released_year',
	'released_month',
	'released_day',
	'in_spotify_playlists',
	'in_spotify_charts',
	'streams',
	'in_apple_playlists',
	'in_apple_charts',
	'in_deezer_playlists',
	'in_deezer_charts',
	'in_shazam_charts',
	'bpm',
	'key',
	'mode',
	'danceability_%',
	'valence_%',
	'energy_%',
	'acousticness_%',
	'instrumentalness_%',
	'liveness_%',
	'speechiness_%',
	'spotify_track_id',
	'spotify_preview_url',
	'spotify_album_cover_url'
];

parse(
	fileContent,
	{
		delimiter: ',',
		columns: headers
	},
	async (error, result: Song[]) => {
		if (error) {
			console.error(error);
		}
		await main(result);
	}
);

const sanitizeSongName = (songName: string) => songName.replaceAll("'", '');

async function main(songs: Song[]) {
	const artists: { [name: string]: Song[] } = {};

	for (let i = 1; i <= 100; i++) {
		const song = songs[i];

		// If artists[song.artists_name] exists, push song to it
		const artist = song.artists_name.split(',')[0];
		if (artists[artist]) {
			artists[artist].push(song);
		} else {
			artists[artist] = [song];
		}
	}

	const insertSongsPath = `${__dirname}/seed/insert_songs.sql`;

	await fs.writeFile(insertSongsPath, '', {});

	for (let i = 0; i < Object.keys(artists).length; i++) {
		const artist = Object.keys(artists)[i];
		const artistSongs = artists[artist];

		const email = `${i}@artist.com`;
		const artistId = generateRandomString(15);

		await fs.appendFile(insertSongsPath, `-- ${artist}\n`, {});

		// Generate insert statements for artist user
		const insertArtistUserQuery = `INSERT INTO \`auth_user\` (\`id\`, \`username\`, \`email\`, \`created_at\`) VALUES ('${artistId}', '${artist}', '${email}', '2023-11-17 17:00:08.000');\n`;
		const insertArtistKeyQuery = `INSERT INTO \`user_key\` (\`id\`, \`user_id\`, \`hashed_password\`) VALUES ('email:${email}', '${artistId}', 's2:ypixvsa9kdptdm5e:9772b9b97a807a7f47ec6097088d2a4024dba58149f0ca73e063e373505e7d6d73558d9111681e34fee10c4b14d8ee4af03030521f41d555cc1fef79872ce189');\n`;
		const insertArtistQuery = `INSERT INTO \`artist\` (\`id\`, \`bio\`, \`name\`) VALUES ('${artistId}', 'My name is ${artist}', '${artist}');\n`;

		await fs.appendFile(insertSongsPath, insertArtistUserQuery, {});
		await fs.appendFile(insertSongsPath, insertArtistKeyQuery, {});
		await fs.appendFile(insertSongsPath, insertArtistQuery, {});

		// Generate insert statements for artist album
		const albumId = generateRandomString(50);
		const albumName = `${artist} Album`;
		const insertAlbumQuery = `INSERT INTO \`album\` (\`id\`, \`artist_id\`, \`cover_image_url\`, \`name\`, \`created_at\`) VALUES ('${albumId}','${artistId}', ${
			artistSongs[0].spotify_album_cover_url
				? `'${artistSongs[0].spotify_album_cover_url}'`
				: 'NULL'
		}, '${albumName}','2023-11-17 17:00:08.000');\n`;
		await fs.appendFile(insertSongsPath, insertAlbumQuery, {});

		// Generate insert statements for artist songs for album
		for (let j = 0; j < artistSongs.length; j++) {
			const songId = generateRandomString(50);
			const song = artistSongs[j];
			const insertSongQuery = `INSERT INTO \`song\` (\`id\`, \`name\`, \`artist_id\`,\`duration\`, \`genre\`, \`spotify_id\`, \`preview_url\`, \`created_at\`) VALUES ('${songId}','${sanitizeSongName(
				song.track_name
			)}','${artistId}',100,'POP',${
				song.spotify_track_id ? `'${song.spotify_track_id}'` : 'NULL'
			},${
				song.spotify_preview_url ? `'${song.spotify_preview_url}'` : 'NULL'
			},'2023-11-17 17:00:08.000');\n`;
			const inserAlbumSongQuery = `INSERT INTO \`album_songs\`(\`album_id\`, \`song_id\`, \`order\`) VALUES ('${albumId}', '${songId}', '${j}');\n`;
			await fs.appendFile(insertSongsPath, insertSongQuery, {});
			await fs.appendFile(insertSongsPath, inserAlbumSongQuery, {});
		}
	}

	console.log('Generated insert statements for songs!');

	console.log('Inserting songs data...');
	const songsQuery = await fs.readFile(`${__dirname}/seed/insert_songs.sql`, {
		encoding: 'utf-8'
	});
	const connection = connect({ url: process.env.DATABASE_URL });
	await executeQuery(songsQuery, connection, false);
	console.log('Inserted songs data!');
}
