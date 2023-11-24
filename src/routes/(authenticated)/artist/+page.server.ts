import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { selectAllArtists } from '../../../../scripts/queries/selectAllArtists';

export const load = (async ({ locals }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	const artists = await selectAllArtists();

	return { artists };
}) satisfies PageServerLoad;
