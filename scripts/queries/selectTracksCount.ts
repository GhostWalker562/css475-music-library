import { db } from '$lib/db';
import { album, albumSongs, artist, song } from '$lib/db/schema';
import { eq, sql } from 'drizzle-orm';

export const selectTracksCount = () =>
	db
		.select({ count: sql<number>`COUNT(*)` })
		.from(albumSongs)
		.innerJoin(song, eq(song.id, albumSongs.songId))
		.innerJoin(album, eq(album.id, albumSongs.albumId))
		.innerJoin(artist, eq(artist.id, song.artistId));
