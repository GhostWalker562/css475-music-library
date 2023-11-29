import { db } from '$lib/db';
import { artist, user } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectAllArtists = (limit = 30, offset = 0) =>
	db
		.select()
		.from(artist)
		.innerJoin(user, eq(artist.id, user.id))
		.limit(limit)
		.offset(offset * limit);
