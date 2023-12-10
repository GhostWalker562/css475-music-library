import { updatePlaylistSchema } from '$lib/types/playlist';
import { fail, redirect, type Actions } from '@sveltejs/kit';
import { superValidate } from 'sveltekit-superforms/server';
import { z } from 'zod';
import { deletePlaylist } from '../../../../../scripts/queries/deletePlaylist';
import { updatePlaylist } from '../../../../../scripts/queries/updatePlaylist';
import { togglePlaylistSong } from '../../../../../scripts/queries/togglePlaylistSong';
import { selectPlaylist } from '../../../../../scripts/queries/selectPlaylist';
import type { PageServerLoad } from './$types';

const togglePlaylistSongSchema = z.object({
	songId: z.string(),
	method: z.enum(['ADD', 'REMOVE'])
});

export const load = (async ({ parent }) => {
	const data = await parent();

	const updatePlaylistForm = await superValidate(updatePlaylistSchema);

	return { ...data, updatePlaylistForm };
}) satisfies PageServerLoad;

export const actions = {
	togglePlaylistSong: async ({ locals, params, request }) => {
		if (!params.id) return fail(404);

		const session = await locals.auth.validate();
		const form = await superValidate(request, togglePlaylistSongSchema);

		if (!form.valid) return fail(400, { form });

		if (!session) return fail(401);

		const playlist = await selectPlaylist(params.id);

		if (playlist.at(0)?.userId !== session?.user.userId) return fail(403);

		let value: boolean;
		if (form.data.method === 'ADD') {
			value = await togglePlaylistSong(params.id, form.data.songId, 'ADD');
		} else if (form.data.method === 'REMOVE') {
			value = await togglePlaylistSong(params.id, form.data.songId, 'REMOVE');
		} else return fail(405);

		return { isAdded: value };
	},
	updatePlaylist: async ({ locals, params, request }) => {
		if (!params.id) return fail(404);

		const session = await locals.auth.validate();
		const form = await superValidate(request, updatePlaylistSchema);

		if (!form.valid) return fail(400, { form });

		if (!session) return fail(401);

		const playlist = await selectPlaylist(params.id);

		if (playlist.at(0)?.userId !== session?.user.userId) return fail(403);

		await updatePlaylist(params.id, form.data.name);

		throw redirect(303, `/playlist/${params.id}`);
	},
	deletePlaylist: async ({ locals, params }) => {
		if (!params.id) return fail(404);

		const session = await locals.auth.validate();

		if (!session) return fail(401);

		const playlist = await selectPlaylist(params.id);

		if (playlist.at(0)?.userId !== session?.user.userId) return fail(403);

		await deletePlaylist(params.id);

		throw redirect(303, `/playlist`);
	}
} satisfies Actions;
