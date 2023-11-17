import { sql } from 'drizzle-orm';
import { bigint, mysqlTable, timestamp, varchar } from 'drizzle-orm/mysql-core';
import { createSelectSchema } from 'drizzle-zod';
import type { z } from 'zod';

// Note: PlanetScale does not support foreign keys, that's why the references() method is commented out.

// table definitions

export const user = mysqlTable('auth_user', {
	id: varchar('id', { length: 15 }).primaryKey(),
	// other user attributes
	username: varchar('username', { length: 55 }).notNull(),
	email: varchar('email', { length: 255 }).unique().notNull(),
	createdAt: timestamp('created_at')
		.notNull()
		.default(sql`CURRENT_TIMESTAMP`),
	profileImageUrl: varchar('profile_image_url', { length: 255 })
});

export const session = mysqlTable('user_session', {
	id: varchar('id', { length: 128 }).primaryKey(),
	userId: varchar('user_id', { length: 15 }).notNull(),
	// .references(() => user.id),
	activeExpires: bigint('active_expires', { mode: 'number' }).notNull(),
	idleExpires: bigint('idle_expires', { mode: 'number' }).notNull()
});

export const key = mysqlTable('user_key', {
	id: varchar('id', { length: 255 }).primaryKey(),
	userId: varchar('user_id', { length: 15 }).notNull(),
	// .references(() => user.id),
	hashedPassword: varchar('hashed_password', { length: 255 })
});

export const passwordReset = mysqlTable('password_reset', {
	id: varchar('id', { length: 128 }).primaryKey(),
	expires: bigint('expires', { mode: 'number' }).notNull(),
	userId: varchar('user_id', { length: 15 }).notNull()
	// .references(() => user.id),
});

// zod schemas

export const selectUserSchema = createSelectSchema(user);

// misc

export type UserSchema = z.infer<typeof selectUserSchema>;

export type UserAttributes = {
	username: UserSchema['username'];
	email: UserSchema['email'];
	created_at: UserSchema['createdAt'];
	profile_image_url: UserSchema['profileImageUrl'];
};
