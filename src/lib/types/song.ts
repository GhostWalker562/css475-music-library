import { GENRES } from '$lib/constants/music';
import { z } from 'zod';

export const createSongSchema = z.object({
	name: z.string().min(3).max(50),
	previewUrl: z.string().url().optional(),
	albumId: z.string(),
	genre: z.enum(GENRES)
});

export type CreateSongSchema = typeof createSongSchema;

export const updateSongSchema = z.object({
	id: z.string(),
	name: z.string().min(3).max(50),
	previewUrl: z.string().url().nullable().optional(),
	genre: z.enum(GENRES)
});

export type UpdateSongSchema = typeof updateSongSchema;
