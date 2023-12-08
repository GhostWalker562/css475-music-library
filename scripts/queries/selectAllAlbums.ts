import { db } from '$lib/db';
import { album, artist } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectAllAlbums = (limit = 30, offset = 0) =>
	db
		.select()
		.from(album)
		.innerJoin(artist, eq(artist.id, album.artistId))
		.limit(limit)
		.offset(offset * limit);
