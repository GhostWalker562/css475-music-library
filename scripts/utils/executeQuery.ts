import type { Connection, ExecutedQuery } from '@planetscale/database';

export const executeQuery = async (query: string, connection: Connection, ordered = true) => {
	const statements = query.split(/;\s*$/gm).filter((statement) => statement.trim() !== '');
	if (ordered) {
		for (const statement of statements) await connection.execute(statement);
	} else {
		const executions: Promise<ExecutedQuery>[] = [];
		for (const statement of statements) executions.push(connection.execute(statement));
		await Promise.all(executions);
	}
};
