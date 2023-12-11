import { createPool } from '@vercel/postgres';
import { drizzle } from 'drizzle-orm/vercel-postgres';
import * as schema from '$lib/db/schema';
import { env } from '$env/dynamic/private';

export const pool = createPool({ connectionString: env.POSTGRES_URL });

export const db = drizzle(pool, { schema, logger: true });
