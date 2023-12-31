import type {
	selectAlbumSchema,
	selectArtistSchema,
	selectSongSchema,
	selectUserLikeSchema,
	selectUserSchema,
	selectPlaylistSchema
} from '$lib/db/schema';
import type { z } from 'zod';

export type Artist = z.infer<typeof selectArtistSchema>;

export type User = z.infer<typeof selectUserSchema>;

export type UserLike = z.infer<typeof selectUserLikeSchema>;

export type ArtistUser = { artist: Artist; auth_user: User };

export type Song = z.infer<typeof selectSongSchema>;

export type Album = z.infer<typeof selectAlbumSchema>;

export type AlbumArtist = { album: Album; artist: Artist };

export type Track = { song: Song; artist: Artist; album: Album; user_likes?: UserLike | null };

export type Playlist = z.infer<typeof selectPlaylistSchema>;

export type PlaylistTrack = Track & { playlist: Playlist };

export type Recommendation = { song: Song; artist: Artist; album: Album };

export type Genre = Song['genre'];
