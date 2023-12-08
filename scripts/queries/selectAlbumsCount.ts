import { db } from '$lib/db';
import { album, artist } from '$lib/db/schema';
import { eq, sql } from 'drizzle-orm';

export const selectAlbumsCount = () =>
	db
		.select({ count: sql<number>`COUNT(*)` })
		.from(album)
		.innerJoin(artist, eq(artist.id, album.artistId));
