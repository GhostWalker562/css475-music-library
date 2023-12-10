import { z } from 'zod';

export const updatePlaylistSchema = z.object({ name: z.string().min(3).max(50) });

export type ModifyPlaylistSchema = typeof updatePlaylistSchema;

export const createPlaylistSchema = z.object({ name: z.string().min(3).max(50) });

export type CreatePlaylistSchema = typeof createPlaylistSchema;
