import { redirect } from '@sveltejs/kit';
import { selectAllSongsWithArtist } from '../../../../scripts/queries/selectAllSongs';
import type { PageServerLoad } from './$types';

export const load = (async ({ locals }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	const songsWithArtist = await selectAllSongsWithArtist();

	return { songsWithArtist };
}) satisfies PageServerLoad;
