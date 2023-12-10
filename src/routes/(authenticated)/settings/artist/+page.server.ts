import { saveArtistSchema } from '$lib/types/artist';
import { fail, redirect, type Actions } from '@sveltejs/kit';
import { LuciaError } from 'lucia';
import { superValidate } from 'sveltekit-superforms/server';
import { selectArtist } from '../../../../../scripts/queries/selectArtist';
import { updateArtist } from '../../../../../scripts/queries/updateArtist';
import type { PageServerLoad } from './$types';
import { selectArtistsAlbums } from '../../../../../scripts/queries/selectArtistAlbums';
import type { Album } from '$lib/types/music';
import { createAlbumSchema } from '$lib/types/album';

export const load = (async ({ locals }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	const artist = (await selectArtist(session.user.userId)).at(0);

	const saveArtistForm = await superValidate(
		{ name: artist?.artist.name || '', bio: artist?.artist.bio || '' },
		saveArtistSchema
	);
	const createAlbumForm = await superValidate(createAlbumSchema);

	return {
		user: artist,
		albums: artist ? selectArtistsAlbums(artist.artist.id) : ([] as Album[]),
		createAlbumForm,
		saveArtistForm
	};
}) satisfies PageServerLoad;

export const actions = {
	saveArtist: async ({ request, locals }) => {
		const form = await superValidate(request, saveArtistSchema);

		if (!form.valid) return fail(400, { form });

		const session = await locals.auth.validate();

		if (!session) throw redirect(303, '/login');

		try {
			await updateArtist(session.user.userId, form.data.name, form.data.bio);
		} catch (error) {
			if (error instanceof LuciaError) return fail(400, { error: error.message, form });
			return fail(400, { error: 'Issue occured saving profile', form });
		}

		return { form };
	}
} satisfies Actions;
