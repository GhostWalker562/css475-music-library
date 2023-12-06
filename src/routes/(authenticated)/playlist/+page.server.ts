import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { selectUserPlaylists } from '../../../../scripts/queries/selectUserPlaylists';

export const load = (async ({ locals }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	return { playlists: selectUserPlaylists(session.user.userId) };
}) satisfies PageServerLoad;
