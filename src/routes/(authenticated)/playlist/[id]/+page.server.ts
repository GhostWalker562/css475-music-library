import { redirect } from '@sveltejs/kit';
import { selectPlaylistTracksWithUserLikes } from '../../../../../scripts/queries/selectPlaylistTracksWithUserLikes';
import type { PageServerLoad } from './$types';
import { selectPlaylist } from '../../../../../scripts/queries/selectPlaylist';

export const load = (async ({ locals, params }) => {
	const session = await locals.auth.validate();

	if (!session) throw redirect(303, '/login');

	const [playlist, tracks] = await Promise.all([
		(await selectPlaylist(params.id)).at(0),
		selectPlaylistTracksWithUserLikes(session.user.userId, params.id)
	]);

	if (!playlist) throw redirect(303, '/');

	return { playlist, tracks };
}) satisfies PageServerLoad;
