import { fetchArtists, getFetchArtistsQueryKey } from '$lib/queries/fetchArtists';
import { z } from 'zod';
import type { ArtistsResponse } from '../../api/artists/+server';
import type { PageLoad } from './$types';

const searchParamsSchema = z.object({
	page: z
		.string()
		.transform((val) => parseInt(val))
		.catch(0),
	search: z.string().optional()
});

export const load = (async ({ parent, fetch, url }) => {
	const { queryClient } = await parent();

	const searchParams = searchParamsSchema.parse(Object.fromEntries(url.searchParams.entries()));

	await queryClient.prefetchInfiniteQuery<ArtistsResponse>({
		queryKey: getFetchArtistsQueryKey(searchParams.search),
		queryFn: async ({ pageParam = 0 }) =>
			fetchArtists(pageParam as number, searchParams.search, fetch),
		getNextPageParam: ({ nextPage }: ArtistsResponse) => nextPage,
		initialPageParam: 0,
		pages: 1,
		staleTime: 60 * 1000 * 3 // 3 minutes
	});

	return {};
}) satisfies PageLoad;
