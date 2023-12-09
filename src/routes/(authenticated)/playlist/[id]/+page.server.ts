import { fail, type Actions } from '@sveltejs/kit';
import { superValidate } from 'sveltekit-superforms/server';
import { z } from 'zod';
import { modifyPlaylistSong } from '../../../../../scripts/queries/modifyPlaylistSong';
import { selectPlaylist } from '../../../../../scripts/queries/selectPlaylist';
import type { PageServerLoad } from './$types';

const modifyPlaylistSongSchema = z.object({
	songId: z.string(),
	method: z.enum(['ADD', 'REMOVE'])
});

export const load = (async ({ parent }) => {
	const data = await parent();

	return data;
}) satisfies PageServerLoad;

export const actions = {
	modifyPlaylistSongs: async ({ locals, params, request }) => {
		if (!params.id) return fail(404);

		const session = await locals.auth.validate();
		const form = await superValidate(request, modifyPlaylistSongSchema);

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
