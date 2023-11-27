import { promises as fs } from 'fs';
import { client } from './utils/connection';
import * as dotenv from 'dotenv';
import * as process from 'process';
dotenv.config();

async function runSqlFile(filePath: string): Promise<void> {
	try {
		const sqlQuery = await fs.readFile(`${__dirname}/${filePath}`, { encoding: 'utf-8' });

		console.log(`Executing SQL file: ${filePath}`);

		await client.query(sqlQuery);

		console.log('SQL execution completed!');
	} catch (error) {
		console.error('Error executing SQL file:', error);
	}
}

async function main() {
	const sqlFilePaths = process.argv.slice(2);

	if (sqlFilePaths.length === 0) {
		console.error('Please provide at least one path to a SQL file.');
		process.exit(1);
	}

	for (const filePath of sqlFilePaths) {
		await runSqlFile(filePath);
	}

	process.exit(0);
}

await main();
