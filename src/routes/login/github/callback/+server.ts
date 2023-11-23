import { auth, githubAuth } from '$lib/server/lucia.js';
import { OAuthRequestError } from '@lucia-auth/oauth';
import type { RequestHandler } from '@sveltejs/kit';
import { createRandomRecommendations } from '../../../../../scripts/queries/createRecommendations';

export const GET: RequestHandler = async ({ url, cookies, locals }) => {
	const storedState = cookies.get('github_oauth_state');
	const state = url.searchParams.get('state');
	const code = url.searchParams.get('code');

	if (!storedState || !state || storedState !== state || !code) {
		return new Response(null, { status: 400 });
	}

	try {
		const { getExistingUser, githubUser, createUser } = await githubAuth.validateCallback(code);

		const getUser = async () => {
			const existingUser = await getExistingUser();

			// If the user already exists, return it and update the GitHub username if it has changed
			if (existingUser) {
				if (existingUser.githubUsername !== githubUser.login) {
					await auth.updateUserAttributes(existingUser.userId, {
						github_username: githubUser.login
					});
				}
				return existingUser;
			}

			// If the user does not exist, create it
			const user = await createUser({
				attributes: {
					email: githubUser.email,
					created_at: new Date(),
					profile_image_url: githubUser.avatar_url,
					username: githubUser.login,
					github_username: githubUser.login
				}
			});

			// Create recommendations for the user
			await createRandomRecommendations(user.userId, 5);

			return user;
		};

		// Create a session for the user
		const user = await getUser();
		const session = await auth.createSession({
			userId: user.userId,
			attributes: {}
		});
		locals.auth.setSession(session);

		// Redirect to the home page
		return new Response(null, {
			status: 302,
			headers: { Location: '/' }
		});
	} catch (e) {
		if (e instanceof OAuthRequestError) {
			// invalid code
			return new Response(null, {
				status: 400
			});
		}
		return new Response(null, { status: 500 });
	}
};
