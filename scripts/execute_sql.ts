import { promises as fs } from 'fs';
import * as dotenv from 'dotenv';
import { executeQuery } from './utils/executeQuery';
import * as process from 'process';
import { connection } from './utils/connection';
dotenv.config();

async function runSqlFile(filePath: string, ordered: boolean): Promise<void> {
	try {
		const sqlQuery = await fs.readFile(`${__dirname}/${filePath}`, { encoding: 'utf-8' });

		console.log(`Executing SQL file: ${filePath}`);

		await executeQuery(sqlQuery, connection, ordered);

		console.log('SQL execution completed!');
	} catch (error) {
		console.error('Error executing SQL file:', error);
	}
}

async function main() {
	let ordered = true;

	const sqlFilePaths = process.argv.slice(2).filter((arg) => {
		if (arg === '--unordered') {
			ordered = false;
			return false; // Remove the flag argument from the paths array
		}
		return true;
	});

	if (sqlFilePaths.length === 0) {
		console.error('Please provide at least one path to a SQL file.');
		process.exit(1);
	}

	for (const filePath of sqlFilePaths) {
		await runSqlFile(filePath, ordered);
	}
}

main();
