import { promises as fs } from 'fs';
import * as dotenv from 'dotenv';
import { connect } from '@planetscale/database';
import { executeQuery } from './utils/executeQuery';
dotenv.config();

const query = await fs.readFile(`${__dirname}/seed/create_tables.sql`, { encoding: 'utf-8' });

const connection = connect({ url: process.env.DATABASE_URL });

console.log('Setting up DB...');

await executeQuery(query, connection);

console.log('Tables created!');
