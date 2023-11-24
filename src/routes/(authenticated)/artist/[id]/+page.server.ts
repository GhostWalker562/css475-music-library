import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { selectArtist } from '../../../../../scripts/queries/selectArtist';

export const load = (async ({ locals, params }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	const artist = (await selectArtist(params.id))[0];

	if (!artist) throw redirect(303, '/');

	return { artist };
}) satisfies PageServerLoad;
