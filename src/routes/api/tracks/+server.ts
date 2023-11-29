import type { Track } from '$lib/types/music';
import { z } from 'zod';
import { searchForTracks } from '../../../../scripts/queries/searchForTracks';
import { selectAllTracks } from '../../../../scripts/queries/selectAllTracks';
import { selectTracksCount } from '../../../../scripts/queries/selectTracksCount';
import type { RequestHandler } from './$types';
import { formatSearchQuery } from '$lib/utils/formatSearchQuery';

const searchParamsSchema = z.object({
	page: z
		.string()
		.transform((val) => parseInt(val))
		.catch(0),
	limit: z
		.string()
		.transform((val) => parseInt(val))
		.catch(50),
	search: z.string().optional()
});

export interface TracksResponse {
	tracks: Track[];
	nextPage?: number;
	totalPages: number;
}

export const GET: RequestHandler = async ({ url }) => {
	const searchParams = searchParamsSchema.parse(Object.fromEntries(url.searchParams.entries()));

	const tracks = searchParams.search
		? await searchForTracks(formatSearchQuery(searchParams.search))
		: await selectAllTracks(searchParams.limit, searchParams.page);

	const tracksCount = (await selectTracksCount())[0].count;

	const totalPages = Math.ceil(tracksCount / searchParams.limit);
	const nextPage = searchParams.page + 1 > totalPages ? undefined : searchParams.page + 1;

	return Response.json({
		tracks,
		nextPage,
		totalPages
	} satisfies TracksResponse);
};
