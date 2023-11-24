import { db } from '$lib/db';
import { artist, user } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectArtist = (artistId: string) =>
	db
		.select()
		.from(artist)
		.innerJoin(user, eq(artist.id, user.id))
		.where(eq(artist.id, artistId))
		.limit(1);
