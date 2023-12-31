import { redirect, type Actions, fail } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { auth } from '$lib/server/lucia';
import { selectAllUserRecommendedTracks } from '../../../scripts/queries/selectAllUserRecommendedTracks';
import { selectAllTracks } from '../../../scripts/queries/selectAllTracks';

export const load = (async ({ locals, setHeaders }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	setHeaders({
		'Cache-Control': 'max-age=300',
		Vary: 'Cookie'
	});

	return {
		tracks: selectAllTracks(10),
		recommendations: selectAllUserRecommendedTracks(session.user.userId)
	};
}) satisfies PageServerLoad;

export const actions = {
	logout: async ({ locals }) => {
		const session = await locals.auth.validate();

		if (!session) return fail(401);

		// this is how we invalidate the session meang that the session is not valid anymore
		await auth.invalidateSession(session.sessionId);

		// now let's set the session to null
		locals.auth.setSession(null);

		// next we redirect to the login page
		throw redirect(303, '/login?signedOut=True');
	}
} satisfies Actions;
