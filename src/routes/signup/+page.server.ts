import { redirect, type Actions, fail } from '@sveltejs/kit';
import { auth } from '$lib/server/lucia';
import type { PageServerLoad } from './$types';
import { z } from 'zod';
import { superValidate } from 'sveltekit-superforms/server';
import { LuciaError } from 'lucia';

const signupSchema = z.object({
	username: z.string().min(3).max(20),
	password: z.string().min(6).max(100),
	email: z.string().email()
});

export const load = (async ({ locals }) => {
	const session = await locals.auth.validate();

	if (!session) return {};

	throw redirect(303, '/');
}) satisfies PageServerLoad;

export const actions = {
	register: async ({ request }) => {
		const form = await superValidate(request, signupSchema);

		if (!form.valid) return fail(400, { form });

		try {
			await auth.createUser({
				key: {
					providerId: 'email',
					providerUserId: form.data.email.toLowerCase(),
					password: form.data.password
				},
				attributes: {
					username: form.data.username,
					email: form.data.email.toLowerCase(),
					created_at: new Date(),
					github_username: null,
					profile_image_url: null
				}
			});
		} catch (error) {
			console.log(error);
			if (error instanceof LuciaError) {
				return fail(400, { error: error.message });
			}
			return fail(400, { error: 'Issue occured logging in' });
		}

		throw redirect(303, '/login');
	}
} satisfies Actions;
