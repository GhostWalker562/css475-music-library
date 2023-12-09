export const createPlaylist = async (
	playlistId: string,
	name: string,
	svelteFetch?: typeof window.fetch
): Promise<string | null> => {
	const fetch = svelteFetch || window.fetch;
	const response = await fetch(`/api/playlist/${playlistId}?name=${name}`, { method: 'POST' });
	return response.headers.get('Location');
};
