import { updateAlbumSchema } from '$lib/types/album';
import { createSongSchema, updateSongSchema, type UpdateSongSchema } from '$lib/types/song';
import { fail, redirect, type Actions } from '@sveltejs/kit';
import { superValidate } from 'sveltekit-superforms/server';
import { deleteAlbum } from '../../../../../scripts/queries/deleteAlbum';
import { updateAlbum } from '../../../../../scripts/queries/updateAlbum';
import { selectAlbum } from '../../../../../scripts/queries/selectAlbum';
import { selectAlbumTracksWithLikes } from '../../../../../scripts/queries/selectAlbumTracksWithLikes';
import { selectArtist } from '../../../../../scripts/queries/selectArtist';
import type { PageServerLoad } from './$types';
import type { SuperValidated } from 'sveltekit-superforms';

export const load = (async ({ locals, params }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	const album = (await selectAlbum(params.id)).at(0);

	if (!album) throw redirect(303, '/');

	const tracks = await selectAlbumTracksWithLikes(params.id, session.user.userId);

	const artist = (await selectArtist(album.artistId)).at(0);

	if (!artist) throw redirect(303, '/');

	return {
		album,
		artist,
		tracks,
		updateAlbumForm: superValidate(
			{ name: album.name, imageUrl: album.coverImageUrl ?? '' },
			updateAlbumSchema
		),
		createSongForm: superValidate({ albumId: params.id, genre: 'POP', name: '' }, createSongSchema),
		updateSongForms:
			album.artistId === session.user.userId
				? Promise.all(tracks.map((e) => superValidate(e.song, updateSongSchema)))
				: ([] as SuperValidated<UpdateSongSchema>[])
	};
}) satisfies PageServerLoad;

export const actions = {
	deleteAlbum: async ({ locals, params }) => {
		if (!params.id) return fail(404);

		const session = await locals.auth.validate();

		if (!session) return fail(401);

		const playlist = await selectAlbum(params.id);

		if (playlist.at(0)?.artistId !== session.user.userId) return fail(403);

		await deleteAlbum(params.id);

		throw redirect(303, `/settings/artist`);
	},
	updateAlbum: async ({ locals, params, request }) => {
		if (!params.id) return fail(404);

		const session = await locals.auth.validate();
		const form = await superValidate(request, updateAlbumSchema);

		if (!form.valid) return fail(400, { form });

		if (!session) return fail(401);

		const playlist = await selectAlbum(params.id);

		if (playlist.at(0)?.artistId !== session.user.userId) return fail(403);

		await updateAlbum(params.id, form.data.name, form.data.imageUrl);

		throw redirect(303, `/album/${params.id}`);
	}
} satisfies Actions;
