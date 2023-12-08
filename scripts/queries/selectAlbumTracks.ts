		/**
		 * Build a query in `scripts/queries` that takes an albumId, 
		 * this query should get all of the tracks 
		 * (artist, song, and album) for a certain album and return it.
		 */
import { db } from '$lib/db';
import { song, albumSongs, album, artist } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectAlbumTracks = (albumId: string) =>
db  
    .select()
    .from(albumSongs)
    .where(eq(albumSongs.albumId, albumId))
    .innerJoin(album, eq(album.id, albumSongs.albumId))
    .innerJoin(song, eq(song.id, albumSongs.songId))
    .innerJoin(artist, eq(artist.id, song.artistId));
    // .orderBy(albumSongs.order, 'ASC');
		// .innerJoin(artist, eq(artist.id, song.artistId))
		// .innerJoin(albumSongs, eq(albumSongs.songId, song.id))
		// .innerJoin(album, eq(album.id, albumSongs.albumId))
    // .where(eq(album.id, albumId));