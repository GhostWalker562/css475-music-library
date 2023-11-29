import type { ArtistsResponse } from '../../routes/api/artists/+server';

export const getFetchArtistsQueryKey = (search?: string) => ['artists', search ?? ''];

export const fetchArtists = async (
	page = 0,
	search?: string,
	svelteFetch?: typeof window.fetch
): Promise<ArtistsResponse> => {
	const fetch = svelteFetch || window.fetch;

	if (search && page > 0) return { artists: [], totalPages: 0 };

	const response = search
		? await fetch(`/api/artists?search=${search}`)
		: await fetch(`/api/artists?page=${page}&limit=50`);

	return await response.json();
};
