import type { selectArtistSchema, selectSongSchema } from '$lib/db/schema';
import type { z } from 'zod';

export type Artist = z.infer<typeof selectArtistSchema>;

export type Song = z.infer<typeof selectSongSchema>;

export type SongWithArtist = { song: Song; artist: Artist };
