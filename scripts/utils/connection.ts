import { connect } from '@planetscale/database';
import * as dotenv from 'dotenv';
import { drizzle } from 'drizzle-orm/planetscale-serverless';
import * as schema from '../../src/lib/db/schema';
dotenv.config();

export const connection = connect({ url: process.env.DATABASE_URL });

export const db = drizzle(connection, { schema });
