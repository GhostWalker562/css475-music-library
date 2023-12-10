import { db } from '$lib/db';
import { album, albumSongs, artist, playlistSongs, song, userLikes } from '$lib/db/schema';
import { and, eq } from 'drizzle-orm';

export const selectPlaylistTracksWithLikes = (userId: string, playlistId: string) =>
	db
		.select()
		.from(song)
		.innerJoin(playlistSongs, eq(playlistSongs.songId, song.id))
		.where(and(eq(playlistSongs.playlistId, playlistId), eq(playlistSongs.songId, song.id)))
		.innerJoin(artist, eq(artist.id, song.artistId))
		.innerJoin(albumSongs, eq(albumSongs.songId, song.id))
		.innerJoin(album, eq(album.id, albumSongs.albumId))
		.leftJoin(userLikes, and(eq(userLikes.songId, song.id), eq(userLikes.userId, userId)))
		.orderBy(playlistSongs.order);
