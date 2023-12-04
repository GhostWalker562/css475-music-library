import type {
	selectAlbumSchema,
	selectArtistSchema,
	selectSongSchema,
	selectUserLikeSchema,
	selectUserSchema
} from '$lib/db/schema';
import type { z } from 'zod';

export type Artist = z.infer<typeof selectArtistSchema>;

export type User = z.infer<typeof selectUserSchema>;

export type UserLike = z.infer<typeof selectUserLikeSchema>;

export type ArtistUser = { artist: Artist; auth_user: User };

export type Song = z.infer<typeof selectSongSchema>;

export type Album = z.infer<typeof selectAlbumSchema>;

export type Track = { song: Song; artist: Artist; album: Album; user_likes?: UserLike | null };

export type Recommendation = { song: Song; artist: Artist; album: Album };
