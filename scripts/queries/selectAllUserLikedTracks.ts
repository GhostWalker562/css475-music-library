import { db } from '$lib/db';
import { album, albumSongs, artist, song, userLikes } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectAllUserLikedTracks = (id: string) =>
	db
		.select()
		.from(userLikes)
		.where(eq(userLikes.userId, id))
		.innerJoin(song, eq(song.id, albumSongs.songId))
		.innerJoin(album, eq(album.id, albumSongs.albumId))
		.innerJoin(artist, eq(artist.id, song.artistId));
