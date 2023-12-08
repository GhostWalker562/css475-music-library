import type { AlbumArtist } from '$lib/types/music';
import { formatSearchQuery } from '$lib/utils/formatSearchQuery';
import { z } from 'zod';
import { searchForAlbums } from '../../../../scripts/queries/searchForAlbums';
import { selectAlbumsCount } from '../../../../scripts/queries/selectAlbumsCount';
import { selectAllAlbums } from '../../../../scripts/queries/selectAllAlbums';
import type { RequestHandler } from './$types';

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

export interface AlbumsResponse {
	albums: AlbumArtist[];
	nextPage?: number;
	totalPages: number;
}

export const GET: RequestHandler = async ({ url }) => {
	const searchParams = searchParamsSchema.parse(Object.fromEntries(url.searchParams.entries()));

	const albums = searchParams.search
		? await searchForAlbums(formatSearchQuery(searchParams.search))
		: await selectAllAlbums(searchParams.limit, searchParams.page);

	const albumsCount = (await selectAlbumsCount())[0].count;

	const totalPages = Math.ceil(albumsCount / searchParams.limit);
	const nextPage = searchParams.page + 1 > totalPages ? undefined : searchParams.page + 1;

	return Response.json({
		albums,
		nextPage,
		totalPages
	} satisfies AlbumsResponse);
};
