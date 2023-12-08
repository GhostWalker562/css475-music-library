import { db } from '$lib/db';
import { album, artist } from '$lib/db/schema';
import { eq, or, sql } from 'drizzle-orm';

export const searchForAlbums = (query: string) =>
	db
		.select()
		.from(album)
		.innerJoin(artist, eq(artist.id, album.artistId))
		.where(or(sql`to_tsvector('simple', ${album.name}) @@ to_tsquery('simple', ${query})`));
