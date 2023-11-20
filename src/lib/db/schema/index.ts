import { sql } from 'drizzle-orm';
import {
	bigint,
	int,
	mysqlEnum,
	mysqlTable,
	primaryKey,
	timestamp,
	varchar
} from 'drizzle-orm/mysql-core';
import { createSelectSchema } from 'drizzle-zod';
import type { z } from 'zod';

// Note: PlanetScale does not support foreign keys, that's why the references() method is commented out.

// auth definitions

const createdAt = timestamp('created_at')
	.notNull()
	.default(sql`CURRENT_TIMESTAMP`);

export const user = mysqlTable('auth_user', {
	id: varchar('id', { length: 15 }).primaryKey(),
	// other user attributes
	username: varchar('username', { length: 55 }).notNull(),
	githubUsername: varchar('github_username', { length: 255 }).unique(),
	email: varchar('email', { length: 255 }).unique(),
	profileImageUrl: varchar('profile_image_url', { length: 255 }),
	createdAt
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

// application tables

export const artist = mysqlTable('artist', {
	id: varchar('id', { length: 15 }).primaryKey(),
	// .references(() => user.id),
	bio: varchar('bio', { length: 400 }),
	name: varchar('name', { length: 100 }).notNull()
});

export const album = mysqlTable('album', {
	id: varchar('id', { length: 128 }).primaryKey(),
	artistId: varchar('artist_id', { length: 15 }).notNull(),
	// .references(() => artist.id),
	name: varchar('name', { length: 200 }).notNull(),
	coverImageUrl: varchar('cover_image_url', { length: 255 }),
	createdAt
});

export const song = mysqlTable('song', {
	id: varchar('id', { length: 128 }).primaryKey(),
	name: varchar('name', { length: 150 }).notNull(),
	artistId: varchar('artist_id', { length: 15 }).notNull(),
	// .references(() => artist.id),
	duration: int('duration').notNull(),
	genre: mysqlEnum('genre', ['COUNTRY', 'POP', 'RAP', 'ROCK', 'CLASSICAL', 'JAZZ']).notNull(),
	spotifyId: varchar('spotify_id', { length: 128 }),
	previewUrl: varchar('preview_url', { length: 255 }),
	createdAt
});

export const playlist = mysqlTable('playlist', {
	id: varchar('id', { length: 128 }).primaryKey(),
	name: varchar('name', { length: 150 }).notNull(),
	creatorId: varchar('creator_id', { length: 15 }).notNull(),
	// .references(() => user.id),
	createdAt
});

// index tables

export const userSongRecommendations = mysqlTable(
	'user_song_recommendations',
	{
		id: varchar('id', { length: 128 }).notNull(),
		userId: varchar('user_id', { length: 15 }).notNull(),
		// .references(() => user.id),
		songId: varchar('song_id', { length: 128 }).notNull(),
		// .references(() => song.id),
		createdAt
	},
	(t) => ({ pk: primaryKey({ columns: [t.id, t.userId, t.songId] }) })
);

export const playlistSongs = mysqlTable(
	'playlist_songs',
	{
		playlistId: varchar('playlist_id', { length: 128 }).notNull(),
		// .references(() => playlist.id),
		songId: varchar('song_id', { length: 128 }).notNull(),
		// .references(() => song.id),
		order: int('order').notNull().default(0)
	},
	(t) => ({ pk: primaryKey({ columns: [t.playlistId, t.songId] }) })
);

export const albumSongs = mysqlTable(
	'album_songs',
	{
		albumId: varchar('album_id', { length: 128 }).notNull(),
		// .references(() => album.id),
		songId: varchar('song_id', { length: 128 }).unique().notNull(),
		// .references(() => song.id),
		order: int('order').notNull().default(0)
	},
	(t) => ({ pk: primaryKey({ columns: [t.albumId, t.songId] }) })
);

export const userLikes = mysqlTable(
	'user_likes',
	{
		userId: varchar('user_id', { length: 15 }).notNull(),
		// .references(() => user.id),
		albumId: varchar('song_id', { length: 128 }).notNull()
		// .references(() => song.id),
	},
	(t) => ({ pk: primaryKey({ columns: [t.userId, t.albumId] }) })
);

// zod schemas

export const selectUserSchema = createSelectSchema(user);

export const selectSongSchema = createSelectSchema(song);

export const selectArtistSchema = createSelectSchema(artist);

export const selectAlbumSchema = createSelectSchema(album);

// misc

export type UserSchema = z.infer<typeof selectUserSchema>;

export type UserAttributes = {
	username: UserSchema['username'];
	github_username: UserSchema['githubUsername'];
	email: UserSchema['email'];
	created_at: UserSchema['createdAt'];
	profile_image_url: UserSchema['profileImageUrl'];
};
