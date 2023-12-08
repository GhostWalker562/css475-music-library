import { z } from 'zod';
import type { PageLoad } from './$types';
import type { AlbumsResponse } from '../../api/albums/+server';
import { fetchAlbums, getFetchAlbumsQueryKey } from '$lib/queries/fetchAlbums';

const searchParamsSchema = z.object({
	page: z
		.string()
		.transform((val) => parseInt(val))
		.catch(0),
	search: z.string().optional()
});

export const load = (async ({ parent, url }) => {
	const { queryClient } = await parent();

	const searchParams = searchParamsSchema.parse(Object.fromEntries(url.searchParams.entries()));

	await queryClient.prefetchInfiniteQuery<AlbumsResponse>({
		queryKey: getFetchAlbumsQueryKey(searchParams.search),
		queryFn: async ({ pageParam = 0 }) =>
			fetchAlbums(pageParam as number, searchParams.search, fetch),
		getNextPageParam: ({ nextPage }: AlbumsResponse) => nextPage,
		initialPageParam: 0,
		pages: 1,
		staleTime: 60 * 1000 * 3 // 3 minutes
	});

	return {};
}) satisfies PageLoad;
