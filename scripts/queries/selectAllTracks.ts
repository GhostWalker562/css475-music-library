import { db } from '$lib/db';
import { album, albumSongs, artist, song } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectAllTracks = (limit = 30, offset = 0) =>
	db
		.select()
		.from(albumSongs)
		.innerJoin(song, eq(song.id, albumSongs.songId))
		.innerJoin(album, eq(album.id, albumSongs.albumId))
		.innerJoin(artist, eq(artist.id, song.artistId))
		.limit(limit)
		.offset(offset);
