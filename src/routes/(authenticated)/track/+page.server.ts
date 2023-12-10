import { createSongSchema } from '$lib/types/song';
import { fail, redirect, type Actions } from '@sveltejs/kit';
import { superValidate } from 'sveltekit-superforms/server';
import { createSong } from '../../../../scripts/queries/createSong';

export const actions = {
	createSong: async ({ locals, request }) => {
		const session = await locals.auth.validate();

		const form = await superValidate(request, createSongSchema);

		if (!session || !form.valid) return fail(401);

		const song = await createSong(
			session.user.userId,
			form.data.albumId,
			form.data.name,
			form.data.previewUrl,
			form.data.genre
		);

		throw redirect(303, `/track/${song.id}`);
	}
} satisfies Actions;
