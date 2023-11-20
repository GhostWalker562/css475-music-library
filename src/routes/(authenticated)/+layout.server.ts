import { redirect } from '@sveltejs/kit';
import type { LayoutServerLoad } from './$types';

export const load = (async ({ locals }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	return { user: session.user };
}) satisfies LayoutServerLoad;
