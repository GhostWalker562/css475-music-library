import { dev } from '$app/environment';
import { githubAuth } from '$lib/server/lucia.js';
import type { RequestHandler } from '@sveltejs/kit';

export const GET: RequestHandler = async ({ cookies }) => {
	const [url, state] = await githubAuth.getAuthorizationUrl();

	// Store the state in a cookie for later validation
	cookies.set('github_oauth_state', state, {
		httpOnly: true,
		secure: !dev,
		path: '/',
		maxAge: 60 * 60
	});

	return new Response(null, {
		status: 302,
		headers: { Location: url.toString() }
	});
};
