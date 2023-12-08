import type { AlbumsResponse } from '../../routes/api/albums/+server';

export const getFetchAlbumsQueryKey = (search?: string) => ['albums', search ?? ''];

export const fetchAlbums = async (
	page = 0,
	search?: string,
	svelteFetch?: typeof window.fetch
): Promise<AlbumsResponse> => {
	const fetch = svelteFetch || window.fetch;

	if (search && page > 0) return { albums: [], totalPages: 0 };

	const response = search
		? await fetch(`/api/albums?search=${search}`)
		: await fetch(`/api/albums?page=${page}&limit=50`);

	return await response.json();
};
