import type { TracksResponse } from '../../routes/api/tracks/+server';

export const getFetchTracksQueryKey = (search?: string) => ['tracks', search ?? ''];

export const fetchTracks = async (
	page = 0,
	search?: string,
	svelteFetch?: typeof window.fetch
): Promise<TracksResponse> => {
	const fetch = svelteFetch || window.fetch;

	if (search && page > 0) return { tracks: [], totalPages: 0 };

	const response = search
		? await fetch(`/api/tracks?search=${search}`)
		: await fetch(`/api/tracks?page=${page}&limit=50`);

	return await response.json();
};
