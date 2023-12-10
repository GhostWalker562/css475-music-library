import { z } from 'zod';

export const createAlbumSchema = z.object({
	name: z.string().min(3).max(50),
	imageUrl: z.string().url()
});

export type CreateAlbumSchema = typeof createAlbumSchema;

export const updateAlbumSchema = z.object({
	name: z.string().min(3).max(50),
	imageUrl: z.string().url()
});

export type UpdateAlbumSchema = typeof updateAlbumSchema;
