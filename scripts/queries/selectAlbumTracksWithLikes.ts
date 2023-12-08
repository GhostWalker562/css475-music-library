/**
 * Build a query in `scripts/queries` that takes an albumId,
 * this query should get all of the tracks
 * (artist, song, and album) for a certain album and return it.
 */
import { db } from '$lib/db';
import { song, albumSongs, album, artist, userLikes } from '$lib/db/schema';
import { and, eq } from 'drizzle-orm';

export const selectAlbumTracksWithLikes = (albumId: string, userId: string) =>
	db
		.select()
		.from(albumSongs)
		.where(eq(albumSongs.albumId, albumId))
		.innerJoin(album, eq(album.id, albumSongs.albumId))
		.innerJoin(song, eq(song.id, albumSongs.songId))
		.innerJoin(artist, eq(artist.id, song.artistId))
		.leftJoin(userLikes, and(eq(userLikes.songId, song.id), eq(userLikes.userId, userId)))
		.orderBy(albumSongs.order);
