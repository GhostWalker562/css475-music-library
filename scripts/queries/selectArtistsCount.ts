import { db } from '$lib/db';
import { artist, user } from '$lib/db/schema';
import { eq, sql } from 'drizzle-orm';

export const selectArtistsCount = () =>
	db
		.select({ count: sql<number>`COUNT(*)` })
		.from(artist)
		.innerJoin(user, eq(artist.id, user.id));
