import { sql } from '@vercel/postgres';
import { drizzle } from 'drizzle-orm/vercel-postgres';
import { Client } from 'pg';
import * as dotenv from 'dotenv';
import * as schema from '../../src/lib/db/schema';
dotenv.config();

export const client = new Client({ connectionString: process.env.POSTGRES_URL, ssl: true });
await client.connect();

export const db = drizzle(sql, { schema });
