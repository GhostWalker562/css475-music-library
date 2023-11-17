import { env } from '$env/dynamic/private';
import { db } from '$lib/db';
import { user } from '$lib/db/schema';
import { generatePasswordResetToken } from '$lib/utils/token';
import { fail, redirect, type Actions } from '@sveltejs/kit';
import { eq } from 'drizzle-orm';
import { LuciaError } from 'lucia';
import sgMail from '@sendgrid/mail';
import { superValidate } from 'sveltekit-superforms/server';
import { z } from 'zod';
import type { PageServerLoad } from './$types';

const sendResetSchema = z.object({ email: z.string().email() });

export const load = (async ({ locals }) => {
	const session = await locals.auth.validate();

	if (!session) return {};

	throw redirect(303, '/');
}) satisfies PageServerLoad;

export const actions = {
	sendReset: async ({ request, url }) => {
		const form = await superValidate(request, sendResetSchema);

		if (!form.valid) return fail(400, { form });

		try {
			const storedUser = await db.query.user.findFirst({
				where: eq(user.email, form.data.email)
			});

			if (!storedUser) return fail(400, { error: 'User not found' });

			const token = await generatePasswordResetToken(storedUser.id);

			sgMail.setApiKey(env.EMAIL_API_KEY);

			await sgMail.send({
				from: 'vuphi21@uw.edu',
				to: form.data.email,
				personalizations: [
					{
						to: [{ email: form.data.email }],
						dynamicTemplateData: { resetLink: `${url.origin}/password-reset/${token}` }
					}
				],
				templateId: 'd-04151035d7724091a4a75d51b2e0d045'
			});

			return {
				success: 'Reset link has been sent to your email! Make sure to check your spam/junk.'
			};
		} catch (error) {
			console.log(error);
			if (error instanceof LuciaError) return fail(400, { error: error.message });
			return fail(400, { error: 'Issue sending reset link' });
		}
	}
} satisfies Actions;
