import { db } from '$lib/db';
import { playlist } from '$lib/db/schema';
import { generateRandomString } from 'lucia/utils';

export const createPlaylist = (userId: string, name: string) =>
	db
		.insert(playlist)
		.values({
			id: generateRandomString(50),
			name,
			userId
		})
		.returning();
