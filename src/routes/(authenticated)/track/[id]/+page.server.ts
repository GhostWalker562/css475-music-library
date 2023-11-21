import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { selectTrack } from '../../../../../scripts/queries/selectTrack';

export const load = (async ({ locals, params }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	const track = (await selectTrack(params.id))[0];

	return { track };
}) satisfies PageServerLoad;
