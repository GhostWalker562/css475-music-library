import { db } from '$lib/db';
import { album } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectArtistsAlbums = (userId: string) =>
	db.select().from(album).where(eq(album.artistId, userId));
