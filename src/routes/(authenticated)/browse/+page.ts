import { fetchTracks, getFetchTracksQueryKey } from '$lib/queries/fetchTracks';
import { z } from 'zod';
import type { TracksResponse } from '../../api/tracks/+server';
import type { PageLoad } from './$types';

const searchParamsSchema = z.object({
	page: z
		.string()
		.transform((val) => parseInt(val))
		.catch(0),
	search: z.string().optional()
});

export const load = (async ({ parent, fetch, url, setHeaders }) => {
	const { queryClient } = await parent();

	const searchParams = searchParamsSchema.parse(Object.fromEntries(url.searchParams.entries()));

	await queryClient.prefetchInfiniteQuery<TracksResponse>({
		queryKey: getFetchTracksQueryKey(searchParams.search),
		queryFn: async ({ pageParam = 0 }) =>
			fetchTracks(pageParam as number, searchParams.search, fetch),
		getNextPageParam: ({ nextPage }: TracksResponse) => nextPage,
		initialPageParam: 0,
		pages: 1,
		staleTime: 60 * 1000 * 3 // 3 minutes
	});

	setHeaders({ 'Cache-Control': 'public, max-age=180' });

	return {};
}) satisfies PageLoad;
