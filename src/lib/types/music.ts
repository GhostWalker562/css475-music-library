import type { selectAlbumSchema, selectArtistSchema, selectSongSchema } from '$lib/db/schema';
import type { z } from 'zod';

export type Artist = z.infer<typeof selectArtistSchema>;

export type Song = z.infer<typeof selectSongSchema>;

export type Album = z.infer<typeof selectAlbumSchema>;

export type Track = { song: Song; artist: Artist; album: Album };

export type Recommendation = { song: Song; artist: Artist; album: Album; };