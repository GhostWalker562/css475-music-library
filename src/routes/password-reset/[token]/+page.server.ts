import { fail, redirect, type Actions } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { superValidate } from 'sveltekit-superforms/server';
import { z } from 'zod';
import { validatePasswordResetToken } from '$lib/utils/token';
import { auth } from '$lib/server/lucia';
import { LuciaError } from 'lucia';

const resetSchema = z.object({ password: z.string().min(6).max(100) });

export const load = (async ({ locals }) => {
	const session = await locals.auth.validate();

	if (!session) return {};

	throw redirect(303, '/');
}) satisfies PageServerLoad;

export const actions = {
	reset: async ({ locals, request, params }) => {
		const form = await superValidate(request, resetSchema);
		const token: string | undefined = params.token;

		if (!form.valid || !token) return fail(400, { form });

		try {
			const userId = await validatePasswordResetToken(token);
			const user = await auth.getUser(userId);

			if (!user.email) return fail(400, { error: 'User does not have an email address' });

			await auth.invalidateAllUserSessions(user.userId);
			await auth.updateKeyPassword('email', user.email, form.data.password);

			const session = await auth.createSession({ userId: user.userId, attributes: {} });
			locals.auth.setSession(session);
		} catch (error) {
			console.log(error);
			if (error instanceof LuciaError) return fail(400, { error: error.message });
			return fail(400, { error: 'Invalid or expired password reset link' });
		}

		throw redirect(303, '/');
	}
} satisfies Actions;
