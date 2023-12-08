import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { selectAlbumTracksWithLikes } from '../../../../../scripts/queries/selectAlbumTracksWithLikes';
import { selectArtist } from '../../../../../scripts/queries/selectArtist';

export const load = (async ({ locals, params }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	const tracks = await selectAlbumTracksWithLikes(params.id, session.user.userId);

	const album = tracks.at(0)?.album;

	if (!album?.artistId) throw redirect(303, '/');

	const artist = (await selectArtist(album?.artistId)).at(0);

	if (!tracks.length || !artist || !album) throw redirect(303, '/');

	return { album, artist, tracks };
}) satisfies PageServerLoad;
