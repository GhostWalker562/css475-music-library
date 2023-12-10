import { db } from '$lib/db';
import { album } from '$lib/db/schema';
import { generateRandomString } from 'lucia/utils';

export const createAlbum = (artistId: string, name: string, coverImageUrl: string) =>
	db
		.insert(album)
		.values({ id: generateRandomString(50), name, artistId, coverImageUrl })
		.returning();
