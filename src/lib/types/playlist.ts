import { z } from 'zod';

export const modifyPlaylistSchema = z.object({ name: z.string().min(3).max(50) });

export type ModifyPlaylistSchema = typeof modifyPlaylistSchema;

export const createPlaylistSchema = z.object({ name: z.string().min(3).max(50) });

export type CreatePlaylistSchema = typeof createPlaylistSchema;
