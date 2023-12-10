import { redirect, type Actions, fail } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { superValidate } from 'sveltekit-superforms/server';
import { createAlbumSchema } from '$lib/types/album';
import { createAlbum } from '../../../../scripts/queries/createAlbum';
import { selectArtist } from '../../../../scripts/queries/selectArtist';

export const load = (async ({ locals }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	return {};
}) satisfies PageServerLoad;

export const actions = {
	createAlbum: async ({ locals, request }) => {
		const session = await locals.auth.validate();
		const form = await superValidate(request, createAlbumSchema);

		if (!form.valid) return fail(400, { form });

		if (!session) return fail(401);

		const artist = (await selectArtist(session.user.userId)).at(0);

		if (!artist) return fail(401);

		const album = (await createAlbum(session.user.userId, form.data.name, form.data.imageUrl)).at(
			0
		);

		if (!album) return fail(500);

		throw redirect(303, `/album/${album?.id}`);
	}
} satisfies Actions;
