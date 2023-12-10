import { z } from 'zod';

export const saveArtistSchema = z.object({
	name: z.string().min(3).max(50),
	bio: z.string().min(10).max(400)
});

export type SaveArtistSchema = typeof saveArtistSchema;
