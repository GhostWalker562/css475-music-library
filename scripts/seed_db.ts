import { promises as fs } from 'fs';
import { connect } from '@planetscale/database';
import * as dotenv from 'dotenv';
import { executeQuery } from './utils/executeQuery';
dotenv.config();

const tableQuery = await fs.readFile(`${__dirname}/seed/insert_table_data.sql`, {
	encoding: 'utf-8'
});

const connection = connect({ url: process.env.DATABASE_URL });

console.log('Seeding DB...');

await executeQuery(tableQuery, connection, false);
console.log('Inserted table data!');
