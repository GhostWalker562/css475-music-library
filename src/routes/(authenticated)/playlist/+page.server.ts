import { fail, redirect, type Actions } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { selectUserPlaylists } from '../../../../scripts/queries/selectUserPlaylists';
import { superValidate } from 'sveltekit-superforms/server';
import { createPlaylist } from '../../../../scripts/queries/createPlaylist';
import { createPlaylistSchema } from '$lib/types/playlist';

export const load = (async ({ locals }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	return {
		playlists: selectUserPlaylists(session.user.userId),
		form: superValidate(createPlaylistSchema)
	};
}) satisfies PageServerLoad;

export const actions = {
	createPlaylist: async ({ locals, request }) => {
		const session = await locals.auth.validate();
		const form = await superValidate(request, createPlaylistSchema);

		if (!form.valid) return fail(400, { form });

		if (!session) return fail(401);

		const playlist = (await createPlaylist(session.user.userId, form.data.name)).at(0);

		if (!playlist) return fail(500);

		throw redirect(303, `/playlist/${playlist?.id}`);
	}
} satisfies Actions;
