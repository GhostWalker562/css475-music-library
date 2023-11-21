import { db } from '$lib/db';
import { album, albumSongs, artist, song } from '$lib/db/schema';
import { eq, sql } from 'drizzle-orm';

export const selectAllTracksSQL = sql`select \`album_songs\`.\`album_id\`, \`album_songs\`.\`song_id\`, \`album_songs\`.\`order\`, \`song\`.\`id\`, \`song\`.\`name\`, \`song\`.\`artist_id\`, \`song\`.\`duration\`, \`song\`.\`genre\`, \`song\`.\`spotify_id\`, \`song\`.\`preview_url\`, \`song\`.\`created_at\`, \`album\`.\`id\`, \`album\`.\`artist_id\`, \`album\`.\`name\`, \`album\`.\`cover_image_url\`, \`album\`.\`created_at\`, \`artist\`.\`id\`, \`artist\`.\`bio\`, \`artist\`.\`name\` from \`album_songs\` inner join \`song\` on \`song\`.\`id\` = \`album_songs\`.\`song_id\` inner join \`album\` on \`album\`.\`id\` = \`album_songs\`.\`album_id\` inner join \`artist\` on \`artist\`.\`id\` = \`song\`.\`artist_id\``;

export const selectAllTracks = () =>
	db
		.select()
		.from(albumSongs)
		.innerJoin(song, eq(song.id, albumSongs.songId))
		.innerJoin(album, eq(album.id, albumSongs.albumId))
		.innerJoin(artist, eq(artist.id, song.artistId));
