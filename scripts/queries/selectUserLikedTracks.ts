import { db } from '$lib/db';
import { song, albumSongs, userLikes, album, artist } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectUserLikedTracks = (userId: string) =>
	db
		.select()
		.from(userLikes)
		.where(eq(userLikes.userId, userId))
		.innerJoin(song, eq(song.id, userLikes.songId))
		.innerJoin(albumSongs, eq(albumSongs.songId, song.id))
		.innerJoin(album, eq(albumSongs.albumId, album.id))
		.innerJoin(artist, eq(artist.id, song.artistId));
