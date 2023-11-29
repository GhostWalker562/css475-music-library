import { db } from '$lib/db';
import { artist, user } from '$lib/db/schema';
import { eq, or, sql } from 'drizzle-orm';

export const searchForArtists = (query: string) =>
	db
		.select()
		.from(artist)
		.innerJoin(user, eq(artist.id, user.id))
		.where(or(sql`to_tsvector('simple', ${artist.name}) @@ to_tsquery('simple', ${query})`));
