import { db } from '$lib/db';
import { artist, user } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectAllArtists = () =>
	db.select().from(artist).innerJoin(user, eq(artist.id, user.id));
