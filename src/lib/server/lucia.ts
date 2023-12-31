import { pg } from '@lucia-auth/adapter-postgresql';
import { lucia } from 'lucia';
import { sveltekit } from 'lucia/middleware';
import { dev } from '$app/environment';
import { github } from '@lucia-auth/oauth/providers';
import { env } from '$env/dynamic/private';
import { pool } from '$lib/db';

export const auth = lucia({
	adapter: pg(pool, { key: 'user_key', session: 'user_session', user: 'auth_user' }),
	env: dev ? 'DEV' : 'PROD',
	getUserAttributes: (userData) => ({
		username: userData.username,
		githubUsername: userData.github_username,
		email: userData.email,
		profileImageUrl: userData.profile_image_url,
		createdAt: userData.created_at
	}),
	middleware: sveltekit()
});

export const githubAuth = github(auth, {
	clientId: env.GITHUB_CLIENT_ID,
	clientSecret: env.GITHUB_CLIENT_SECRET
});

export type Auth = typeof auth;
