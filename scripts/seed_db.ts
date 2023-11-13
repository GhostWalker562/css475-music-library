import { promises as fs } from 'fs';
import { connect } from '@planetscale/database';
import * as dotenv from 'dotenv';
dotenv.config();

const query = await fs.readFile(`${__dirname}/seed/seed_table_data.sql`, { encoding: 'utf-8' });

const connection = connect({ url: process.env.DATABASE_URL });

console.log('Executing query...');

const statements = query.split(/;\s*$/gm).filter((statement) => statement.trim() !== '');
for (const statement of statements) await connection.execute(statement);

console.log('Seeded database!');
