import { db } from '$lib/db';
import { album, albumSongs, artist, song, userLikes } from '$lib/db/schema';
import { eq, and } from 'drizzle-orm';

export const selectArtistTracksWithLikes = (userId: string, artistId: string) =>
	db
		.select()
		.from(song)
		.innerJoin(artist, eq(artist.id, song.artistId))
		.innerJoin(albumSongs, eq(albumSongs.songId, song.id))
		.innerJoin(album, eq(album.id, albumSongs.albumId))
		.leftJoin(userLikes, and(eq(userLikes.songId, song.id), eq(userLikes.userId, userId)))
		.where(eq(artist.id, artistId));
