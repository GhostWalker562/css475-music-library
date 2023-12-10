import type { Actions } from '@sveltejs/kit';
import { auth } from '$lib/server/lucia';
import { fail, redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { z } from 'zod';
import { superValidate } from 'sveltekit-superforms/server';
import { LuciaError } from 'lucia';

const loginSchema = z.object({
	email: z.string().email(),
	password: z.string().min(6).max(100)
});

export const load = (async ({ locals }) => {
	const session = await locals.auth.validate();

	if (!session) return {};

	throw redirect(303, '/');
}) satisfies PageServerLoad;

export const actions = {
	login: async ({ request, locals }) => {
		const form = await superValidate(request, loginSchema);

		if (!form.valid) return fail(400, { form });

		try {
			const key = await auth.useKey('email', form.data.email, form.data.password);

			const session = await auth.createSession({
				userId: key.userId,
				attributes: {}
			});

			locals.auth.setSession(session);
		} catch (error) {
			console.log(error);
			if (error instanceof LuciaError) return fail(400, { error: error.message });
			return fail(400, { error: 'Issue occured logging in' });
		}

		throw redirect(303, '/?signedIn=True');
	}
} satisfies Actions;
