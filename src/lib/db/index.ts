import { connect } from '@planetscale/database';
import mysql from 'mysql2/promise';
import { DATABASE_URL } from '$env/static/private';
import { drizzle as drizzlePlanetScale } from 'drizzle-orm/planetscale-serverless';
import { drizzle as drizzleMySql2 } from 'drizzle-orm/mysql2';
import * as schema from '$lib/db/schema';
import { env } from '$env/dynamic/private';

export const connection = connect({ url: DATABASE_URL });

export const localConnection =
	env.NODE_ENV === 'local'
		? await mysql.createConnection({ uri: env.LOCAL_DATABASE_URL })
		: undefined;

// If the current environment is local, use the local connection instead of the remote one.
// Check out the README for more information on how to set up a local database.
export const db =
	env.NODE_ENV === 'local'
		? drizzleMySql2(localConnection!, { schema, mode: 'default' })
		: drizzlePlanetScale(connection, { schema });
