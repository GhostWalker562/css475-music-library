import { redirect } from '@sveltejs/kit';
import { selectPlaylistCreator } from '../../../../../scripts/queries/selectPlaylistCreator';
import { selectPlaylistTracksWithLikes } from '../../../../../scripts/queries/selectPlaylistTracksWithLikes';
import type { LayoutServerLoad } from './$types';

export const load = (async ({ locals, params }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	const [playlistCreator, tracks] = await Promise.all([
		(async () => (await selectPlaylistCreator(params.id)).at(0))(),
		selectPlaylistTracksWithLikes(session.user.userId, params.id)
	]);

	if (!playlistCreator) throw redirect(303, '/');

	return { playlist: playlistCreator.playlist, creator: playlistCreator.auth_user, tracks };
}) satisfies LayoutServerLoad;
