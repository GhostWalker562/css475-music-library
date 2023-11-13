import { sql } from 'drizzle-orm';
import { int, mysqlTable, timestamp, varchar } from 'drizzle-orm/mysql-core';
import { createSelectSchema } from 'drizzle-zod';
import type { z } from 'zod';

// Note: PlanetScale does not support foreign keys, that's why the references() method is commented out.

// table definitions

export const user = mysqlTable('auth_user', {
	id: varchar('id', { length: 15 }).primaryKey(),
	// other user attributes
	username: varchar('username', { length: 55 }).notNull(),
	email: varchar('email', { length: 255 }).notNull(),
	createdAt: timestamp('date_created')
		.notNull()
		.default(sql`CURRENT_TIMESTAMP`),
	profileImageUrl: varchar('profile_image_url', { length: 255 })
});

export const session = mysqlTable('user_session', {
	id: varchar('id', { length: 128 }).primaryKey(),
	userId: varchar('user_id', { length: 15 }).notNull(),
	activeExpires: int('active_expires').notNull(),
	idleExpires: int('idle_expires').notNull()
});

export const key = mysqlTable('user_key', {
	id: varchar('id', { length: 255 }).primaryKey(),
	userId: varchar('user_id', { length: 15 }).notNull(),
	// .references(() => user.id),
	hashedPassword: varchar('hashed_password', { length: 255 })
});

// zod schemas

export const selectUserSchema = createSelectSchema(user);

// misc

export type UserAttributes = Pick<
	z.infer<typeof selectUserSchema>,
	'createdAt' | 'profileImageUrl' | 'email' | 'username'
>;
