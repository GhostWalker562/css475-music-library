import { redirect, type Actions, fail } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { selectTrack } from '../../../../../scripts/queries/selectTrack';
import { selectIsTrackLiked } from '../../../../../scripts/queries/selectIsTrackLiked';
import { toggleLike } from '../../../../../scripts/queries/toggleLike';
import { z } from 'zod';
import { superValidate } from 'sveltekit-superforms/server';

const toggleLikeSchema = z.object({ isLiked: z.boolean() });

export const load = (async ({ locals, params }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	const track = (await selectTrack(params.id))[0];

	if (!track) throw redirect(303, '/');

	const isLiked = await selectIsTrackLiked(session.user.userId, params.id);

	return { track, isLiked };
}) satisfies PageServerLoad;

export const actions = {
	toggleLike: async ({ locals, params, request }) => {
		const session = await locals.auth.validate();

		const form = await superValidate(request, toggleLikeSchema);

		if (!session || !params.id || !form.valid) return fail(401);

		let value: boolean;
		try {
			// Toggle like by passing the opposite of the current value
			value = await toggleLike(session.user.userId, params.id, !form.data.isLiked);
		} catch (error) {
			return fail(400, { error: 'Failed to toggle like' });
		}

		return { isLiked: value };
	}
} satisfies Actions;
