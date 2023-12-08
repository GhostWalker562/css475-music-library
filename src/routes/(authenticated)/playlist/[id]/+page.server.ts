import { fail, redirect, type Actions } from '@sveltejs/kit';
import { superValidate } from 'sveltekit-superforms/server';
import { z } from 'zod';
import { modifyPlaylistSong } from '../../../../../scripts/queries/modifyPlaylistSong';
import { selectPlaylist } from '../../../../../scripts/queries/selectPlaylist';
import { selectPlaylistCreator } from '../../../../../scripts/queries/selectPlaylistCreator';
import { selectPlaylistTracksWithUserLikes } from '../../../../../scripts/queries/selectPlaylistTracksWithUserLikes';
import type { PageServerLoad } from './$types';

const modifyPlaylistSchema = z.object({
	songId: z.string(),
	method: z.enum(['ADD', 'REMOVE'])
});

export const load = (async ({ locals, params }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	const [playlistCreator, tracks] = await Promise.all([
		(await selectPlaylistCreator(params.id)).at(0),
		selectPlaylistTracksWithUserLikes(session.user.userId, params.id)
	]);

	if (!playlistCreator) throw redirect(303, '/');

	return { playlist: playlistCreator.playlist, creator: playlistCreator.auth_user, tracks };
}) satisfies PageServerLoad;

export const actions = {
	modifyPlaylist: async ({ locals, params, request }) => {
		if (!params.id) return fail(404);

		const session = await locals.auth.validate();
		const form = await superValidate(request, modifyPlaylistSchema);

		if (!form.valid) return fail(400, { form });

		if (!session) return fail(401);

		const playlist = await selectPlaylist(params.id);

		if (playlist.at(0)?.userId !== session?.user.userId) return fail(403);

		let value: boolean;
		if (form.data.method === 'ADD') {
			value = await modifyPlaylistSong(params.id, form.data.songId, 'ADD');
		} else if (form.data.method === 'REMOVE') {
			value = await modifyPlaylistSong(params.id, form.data.songId, 'REMOVE');
		} else return fail(405);

		return { isAdded: value };
	}
} satisfies Actions;
