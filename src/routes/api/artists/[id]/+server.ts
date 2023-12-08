import type { ArtistUser } from '$lib/types/music';
import { selectArtist } from '../../../../../scripts/queries/selectArtist';
import type { RequestHandler } from './$types';

export interface ArtistResponse {
	artist: ArtistUser;
}

export const GET: RequestHandler = async ({ params }) => {
	const artist = (await selectArtist(params.id)).at(0);

	if (!artist) {
		return new Response(null, { status: 404 });
	}

	return Response.json({ artist } satisfies ArtistResponse);
};
