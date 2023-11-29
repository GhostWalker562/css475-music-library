import type { ArtistUser } from '$lib/types/music';
import { z } from 'zod';
import { searchForArtists } from '../../../../scripts/queries/searchForArtists';
import { selectAllArtists } from '../../../../scripts/queries/selectAllArtists';
import { selectArtistsCount } from '../../../../scripts/queries/selectArtistsCount';
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

export interface ArtistsResponse {
	artists: ArtistUser[];
	nextPage?: number;
	totalPages: number;
}

export const GET: RequestHandler = async ({ url }) => {
	const searchParams = searchParamsSchema.parse(Object.fromEntries(url.searchParams.entries()));

	const artists = searchParams.search
		? await searchForArtists(formatSearchQuery(searchParams.search))
		: await selectAllArtists(searchParams.limit, searchParams.page);

	const tracksCount = (await selectArtistsCount())[0].count;

	const totalPages = Math.ceil(tracksCount / searchParams.limit);
	const nextPage = searchParams.page + 1 > totalPages ? undefined : searchParams.page + 1;

	return Response.json({
		artists,
		nextPage,
		totalPages
	} satisfies ArtistsResponse);
};
