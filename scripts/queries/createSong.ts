import { db } from '$lib/db';
import { albumSongs, song } from '$lib/db/schema';
import type { Genre } from '$lib/types/music';
import { generateRandomString } from 'lucia/utils';

export const createSong = (
	artistId: string,
	albumId: string,
	name: string,
	previewUrl: string | undefined,
	genre: Genre
) =>
	db.transaction(async (tx) => {
		const insertedSong = (
			await tx
				.insert(song)
				.values({
					id: generateRandomString(50),
					artistId: artistId,
					name,
					previewUrl,
					genre
				})
				.returning()
		).at(0);

		if (!insertedSong) throw new Error('Failed to insert song');

		await tx.insert(albumSongs).values({
			albumId,
			songId: insertedSong.id
		});

		return insertedSong;
	});
