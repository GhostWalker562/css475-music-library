import { db } from '$lib/db';
import { album, albumSongs, artist, song } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectTrack = (id: string) =>
	db
		.select()
		.from(albumSongs)
		.where(eq(albumSongs.songId, id))
		.innerJoin(song, eq(song.id, albumSongs.songId))
		.innerJoin(album, eq(album.id, albumSongs.albumId))
		.innerJoin(artist, eq(artist.id, song.artistId))
		.limit(1);
