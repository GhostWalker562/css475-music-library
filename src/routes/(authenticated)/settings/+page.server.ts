import { fail, redirect, type Actions } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { z } from 'zod';
import { superValidate } from 'sveltekit-superforms/server';
import { LuciaError } from 'lucia';
import { auth } from '$lib/server/lucia';

const saveProfileSchema = z.object({
	username: z.string().min(3).max(20),
	avatar: z.string().url()
});

export const load = (async ({ locals }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	return {};
}) satisfies PageServerLoad;

export const actions = {
	saveProfile: async ({ request, locals }) => {
		const form = await superValidate(request, saveProfileSchema);

		if (!form.valid) return fail(400, { form });

		try {
			const session = await locals.auth.validate();

			if (!session) throw redirect(303, '/login');

			await auth.updateUserAttributes(session.user.userId, {
				username: form.data.username,
				profile_image_url: form.data.avatar
			});
		} catch (error) {
			console.log(error);
			if (error instanceof LuciaError) {
				return fail(400, { error: error.message });
			}
			return fail(400, { error: 'Issue occured logging in' });
		}
	}
} satisfies Actions;
