import { redirect } from '@sveltejs/kit';
import { selectUserLikedTracks } from '../../../../scripts/queries/selectUserLikedTracks';
import type { PageServerLoad } from './$types';

export const load = (async ({ locals }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	return { likedTracks: selectUserLikedTracks(session.user.userId) };
}) satisfies PageServerLoad;
