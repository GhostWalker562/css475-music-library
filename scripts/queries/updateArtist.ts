import { db } from '$lib/db';
import { artist } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const updateArtist = (userId: string, name: string, bio: string) =>
	db.transaction(async (tx) => {
		const user = (await db.select().from(artist).where(eq(artist.id, userId)).limit(0)).at(0);

		if (!user) {
			await tx.insert(artist).values({ id: userId, name, bio });
		} else {
			await tx.update(artist).set({ name, bio }).where(eq(artist.id, userId));
		}
	});
