import * as fs from 'fs';
import * as path from 'path';

export function appendSqlFiles(
	sqlFilePaths: string[],
	outputName: string,
	outputDir: string
): void {
	let combinedSql = '';

	for (const filePath of sqlFilePaths) {
		const sqlContent = fs.readFileSync(filePath, 'utf8');
		combinedSql += `-- File: ${filePath.split('/').at(-1)}\n${sqlContent}\n\n`;
	}

	// Write the combined SQL to the output file
	const outputFilePath = path.join(outputDir, `${outputName}.sql`);
	fs.writeFileSync(outputFilePath, combinedSql);
	console.log(`Combined SQL file created at: ${outputFilePath}`);
}
