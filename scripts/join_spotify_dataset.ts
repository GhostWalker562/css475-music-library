import axios from 'axios';
import * as fs from 'fs';
import { parse } from 'csv-parse/sync';
import { stringify } from 'csv-stringify/sync';
import * as dotenv from 'dotenv';
dotenv.config();

if (!process.env.SPOTIFY_CLIENT_ID || !process.env.SPOTIFY_CLIENT_SECRET) {
	throw new Error('Missing Spotify credentials');
}

const CLIENT_ID = process.env.SPOTIFY_CLIENT_ID;
const CLIENT_SECRET = process.env.SPOTIFY_CLIENT_SECRET;
const datasetPath = `${__dirname}/seed/small-spotify-2023.csv`;
const updatedDatasetPath = `${__dirname}/seed/updated-dataset.csv`;

async function getSpotifyToken(clientId: string, clientSecret: string): Promise<string> {
	const url = 'https://accounts.spotify.com/api/token';
	const credentials = Buffer.from(`${clientId}:${clientSecret}`).toString('base64');
	const headers = {
		'Content-Type': 'application/x-www-form-urlencoded',
		Authorization: `Basic ${credentials}`
	};
	const data = 'grant_type=client_credentials';

	const response = await axios.post(url, data, { headers });
	return response.data.access_token;
}

const artistImageCache: Record<string, string> = {};
async function getArtistImageURL(token: string, artistName: string) {
	if (artistImageCache[artistName]) return artistImageCache[artistName];

	const url = `https://api.spotify.com/v1/search?q=${encodeURIComponent(
		artistName
	)}&type=artist&limit=1`;
	const headers = { Authorization: `Bearer ${token}` };

	try {
		const response = await axios.get(url, { headers });
		const items = response.data.artists.items;
		if (items.length > 0 && items[0].images.length > 0) {
			artistImageCache[artistName] = items[0].images[0].url;
			return items[0].images[0].url; // Return the URL of the first image
		}
	} catch (error) {
		console.error('Error fetching artist image:', error);
	}
	return null;
}

async function searchTrack(token: string, trackName: string, artistName: string) {
	const url = `https://api.spotify.com/v1/search?q=track:${encodeURIComponent(
		trackName
	)}%20artist:${encodeURIComponent(artistName)}&type=track&limit=1`;
	const headers = { Authorization: `Bearer ${token}` };

	try {
		const response = await axios.get(url, { headers });
		const items = response.data.tracks.items;
		if (items.length > 0) {
			const trackId = items[0].id;
			const previewUrl = items[0].preview_url;
			const albumCoverUrl = items[0].album.images[0].url;
			return { trackId, previewUrl, albumCoverUrl };
		}
	} catch (error) {
		console.error('Error searching track:', error);
	}
	return { trackId: null, previewUrl: null, albumCoverUrl: null };
}

async function updateDataset() {
	const token = await getSpotifyToken(CLIENT_ID, CLIENT_SECRET);
	const fileContent = fs.readFileSync(datasetPath, { encoding: 'utf-8' });
	const records = parse(fileContent, { columns: true, delimiter: ',', skip_empty_lines: true });

	for (const row of records) {
		const { trackId, previewUrl, albumCoverUrl } = await searchTrack(
			token,
			row['track_name'],
			row['artist(s)_name']
		);
		row['spotify_track_id'] = trackId;
		row['spotify_preview_url'] = previewUrl;
		row['spotify_album_cover_url'] = albumCoverUrl;
		row['spotify_artist_image_url'] = await getArtistImageURL(token, row['artist(s)_name']);
	}

	const updatedCsv = stringify(records, { header: true });
	fs.writeFileSync(updatedDatasetPath, updatedCsv);
	console.log('Dataset updated.');
}

await updateDataset();
