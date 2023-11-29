import { db } from '$lib/db';
import { album, albumSongs, artist, song } from '$lib/db/schema';
import { eq, or, sql } from 'drizzle-orm';

export const searchForTracks = (query: string) =>
	db
		.select()
		.from(albumSongs)
		.innerJoin(song, eq(song.id, albumSongs.songId))
		.innerJoin(album, eq(album.id, albumSongs.albumId))
		.innerJoin(artist, eq(artist.id, song.artistId))
		.where(
			or(
				sql`to_tsvector('simple', ${song.name}) @@ to_tsquery('simple', ${query})`,
				sql`to_tsvector('simple', ${artist.name}) @@ to_tsquery('simple', ${query})`
			)
		);
