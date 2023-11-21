import { db } from '$lib/db';
import { album, albumSongs, artist, song } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectAllTracksLimited = (limit: number) =>
	db
		.select()
		.from(albumSongs)
		.innerJoin(song, eq(song.id, albumSongs.songId))
		.innerJoin(album, eq(album.id, albumSongs.albumId))
		.innerJoin(artist, eq(artist.id, song.artistId))
		.limit(limit);
