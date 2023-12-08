import type { Playlist } from '$lib/types/music';
import { z } from 'zod';
import { selectUserPlaylists } from '../../../../scripts/queries/selectUserPlaylists';
import type { RequestHandler } from './$types';
import { selectPlaylistsWithTrack } from '../../../../scripts/queries/selectPlaylistsWithTrack';

const searchParamsSchema = z.object({
	userId: z.string().optional(),
	songId: z.string().optional()
});

export interface PlaylistsResponse {
	playlists: Playlist[];
}

export const GET: RequestHandler = async ({ url }) => {
	const searchParams = searchParamsSchema.parse(Object.fromEntries(url.searchParams.entries()));

	let playlists: Playlist[];

	if (searchParams.songId) {
		playlists = (await selectPlaylistsWithTrack(searchParams.songId)).map((e) => ({
			...e.playlist
		}));
	} else if (searchParams.userId) {
		playlists = await selectUserPlaylists(searchParams.userId);
	} else {
		return Response.error();
	}

	return Response.json({ playlists } satisfies PlaylistsResponse);
};
