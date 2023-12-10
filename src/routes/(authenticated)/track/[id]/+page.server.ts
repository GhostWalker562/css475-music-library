import { fail, redirect, type Actions } from '@sveltejs/kit';
import { superValidate } from 'sveltekit-superforms/server';
import { z } from 'zod';
import { selectAlbumTracksWithLikes } from '../../../../../scripts/queries/selectAlbumTracksWithLikes';
import { selectIsTrackLiked } from '../../../../../scripts/queries/selectIsTrackLiked';
import { selectTrack } from '../../../../../scripts/queries/selectTrack';
import { toggleLike } from '../../../../../scripts/queries/toggleLike';
import type { PageServerLoad } from './$types';
import { updateSongSchema } from '$lib/types/song';
import { updateSong } from '../../../../../scripts/queries/updateSong';
import { deleteSong } from '../../../../../scripts/queries/deleteSong';

const toggleLikeSchema = z.object({ isLiked: z.boolean() });

export const load = (async ({ locals, params }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	const [track, isLiked] = await Promise.all([
		(async () => (await selectTrack(params.id)).at(0))(),
		selectIsTrackLiked(session.user.userId, params.id)
	]);

	if (!track) throw redirect(303, '/');

	const albumId = track.album.id;
	const albumTracks = (await selectAlbumTracksWithLikes(albumId, session.user.userId)).filter(
		(albumTrack) => albumTrack.song.id !== track.song.id
	);

	return { track, isLiked, albumTracks };
}) satisfies PageServerLoad;

export const actions = {
	deleteSong: async ({ locals, params }) => {
		const session = await locals.auth.validate();

		if (!session || !params.id) return fail(401);

		const song = (await selectTrack(params.id)).at(0);

		if (!song) return fail(404);

		if (song.song.artistId !== session.user.userId) return fail(403);

		await deleteSong(song.song.id);

		throw redirect(303, `/album/${song.album.id}`);
	},
	updateSong: async ({ locals, params, request }) => {
		const session = await locals.auth.validate();

		const form = await superValidate(request, updateSongSchema);

		if (!form.valid) return fail(400, { form });

		if (!session || !params.id) return fail(401);

		const song = (
			await updateSong(params.id, form.data.name, form.data.previewUrl, form.data.genre)
		).at(0);

		if (!song) return fail(400, { error: 'Failed to modify song' });

		return { song, form };
	},
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
