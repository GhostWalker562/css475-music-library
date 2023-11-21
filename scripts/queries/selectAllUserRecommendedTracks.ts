import { db } from '$lib/db';
import { album, albumSongs, artist, song, userSongRecommendations } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectAllUserRecommendedTracks = (id: string) =>
	db
		.select()
		.from(userSongRecommendations)
		.where(eq(userSongRecommendations.userId, id))
		.innerJoin(song, eq(song.id, userSongRecommendations.songId))
		.innerJoin(albumSongs, eq(albumSongs.songId, song.id))
		.innerJoin(album, eq(album.id, albumSongs.albumId))
		.innerJoin(artist, eq(artist.id, song.artistId));
