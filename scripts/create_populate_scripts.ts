import { appendSqlFiles } from './utils/appendSqlFiles';

appendSqlFiles(
	[
		`${__dirname}/seed/create_tables.sql`,
		`${__dirname}/seed/insert_admin.sql`,
		`${__dirname}/seed/insert_songs.sql`,
		`${__dirname}/seed/insert_relationships.sql`
	],
	'populate',
	`${__dirname}/seed`
);

appendSqlFiles(
	[
		`${__dirname}/seed/create_tables_fk.sql`,
		`${__dirname}/seed/insert_admin.sql`,
		`${__dirname}/seed/insert_songs.sql`,
		`${__dirname}/seed/insert_relationships.sql`
	],
	'populate_fk',
	`${__dirname}/seed`
);
