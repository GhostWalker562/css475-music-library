import { redirect } from '@sveltejs/kit';
import { selectArtist } from '../../../../../scripts/queries/selectArtist';
import { selectArtistTracksWithUserLikes } from '../../../../../scripts/queries/selectArtistTracksWithUserLikes';
import type { PageServerLoad } from './$types';

export const load = (async ({ locals, params }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	const [artist, tracks] = await Promise.all([
		(async () => (await selectArtist(params.id)).at(0))(),
		selectArtistTracksWithUserLikes(session.user.userId, params.id)
	]);

	if (!artist) throw redirect(303, '/');

	return { artist, tracks };
}) satisfies PageServerLoad;
