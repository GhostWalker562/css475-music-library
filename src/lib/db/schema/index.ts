import {
	pgTable,
	primaryKey,
	varchar,
	timestamp,
	bigint,
	integer,
	pgEnum
} from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';
import { createSelectSchema } from 'drizzle-zod';
import type { z } from 'zod';

export const genreEnum = pgEnum('genre', ['COUNTRY', 'POP', 'RAP', 'ROCK', 'CLASSICAL', 'JAZZ']);

// auth definitions

const createdAt = timestamp('created_at')
	.notNull()
	.default(sql`CURRENT_TIMESTAMP`);

export const user = pgTable('auth_user', {
	id: varchar('id', { length: 15 }).primaryKey(),
	// other user attributes
	username: varchar('username', { length: 128 }).notNull(),
	githubUsername: varchar('github_username', { length: 255 }).unique(),
	email: varchar('email', { length: 128 }).unique(),
	profileImageUrl: varchar('profile_image_url', { length: 255 }),
	createdAt
});

export const session = pgTable('user_session', {
	id: varchar('id', { length: 128 }).primaryKey(),
	userId: varchar('user_id', { length: 15 })
		.notNull()
		.references(() => user.id),
	activeExpires: bigint('active_expires', { mode: 'number' }).notNull(),
	idleExpires: bigint('idle_expires', { mode: 'number' }).notNull()
});

export const key = pgTable('user_key', {
	id: varchar('id', { length: 255 }).primaryKey(),
	userId: varchar('user_id', { length: 15 })
		.notNull()
		.references(() => user.id),
	hashedPassword: varchar('hashed_password', { length: 255 })
});

export const passwordReset = pgTable('password_reset', {
	id: varchar('id', { length: 128 }).primaryKey(),
	expires: bigint('expires', { mode: 'number' }).notNull(),
	userId: varchar('user_id', { length: 15 })
		.notNull()
		.references(() => user.id)
});

// application tables

export const artist = pgTable('artist', {
	id: varchar('id', { length: 15 })
		.primaryKey()
		.references(() => user.id),
	bio: varchar('bio', { length: 400 }),
	name: varchar('name', { length: 128 }).notNull()
});

export const album = pgTable('album', {
	id: varchar('id', { length: 128 }).primaryKey(),
	artistId: varchar('artist_id', { length: 15 })
		.notNull()
		.references(() => artist.id),
	name: varchar('name', { length: 128 }).notNull(),
	coverImageUrl: varchar('cover_image_url', { length: 255 }),
	createdAt
});

export const song = pgTable('song', {
	id: varchar('id', { length: 128 }).primaryKey(),
	name: varchar('name', { length: 128 }).notNull(),
	artistId: varchar('artist_id', { length: 15 })
		.notNull()
		.references(() => artist.id),
	genre: genreEnum('genre').notNull(),
	spotifyId: varchar('spotify_id', { length: 128 }),
	previewUrl: varchar('preview_url', { length: 255 }),
	createdAt
});

export const playlist = pgTable('playlist', {
	id: varchar('id', { length: 128 }).primaryKey(),
	name: varchar('name', { length: 128 }).notNull(),
	userId: varchar('user_id', { length: 15 })
		.notNull()
		.references(() => user.id),
	createdAt
});

// index tables

export const userSongRecommendations = pgTable(
	'user_song_recommendations',
	{
		id: varchar('id', { length: 128 }).notNull(),
		userId: varchar('user_id', { length: 15 })
			.notNull()
			.references(() => user.id),
		songId: varchar('song_id', { length: 128 })
			.notNull()
			.references(() => song.id),
		createdAt
	},
	(t) => ({ pk: primaryKey({ columns: [t.id, t.userId, t.songId] }) })
);

export const playlistSongs = pgTable(
	'playlist_songs',
	{
		playlistId: varchar('playlist_id', { length: 128 })
			.notNull()
			.references(() => playlist.id),
		songId: varchar('song_id', { length: 128 })
			.notNull()
			.references(() => song.id),
		order: integer('order').notNull().default(0)
	},
	(t) => ({ pk: primaryKey({ columns: [t.playlistId, t.songId] }) })
);

export const albumSongs = pgTable(
	'album_songs',
	{
		albumId: varchar('album_id', { length: 128 })
			.notNull()
			.references(() => album.id),
		songId: varchar('song_id', { length: 128 })
			.unique()
			.notNull()
			.references(() => song.id),
		order: integer('order').notNull().default(0)
	},
	(t) => ({ pk: primaryKey({ columns: [t.albumId, t.songId] }) })
);

export const userLikes = pgTable(
	'user_likes',
	{
		userId: varchar('user_id', { length: 15 })
			.notNull()
			.references(() => user.id),
		songId: varchar('song_id', { length: 128 })
			.notNull()
			.references(() => song.id)
	},
	(t) => ({ pk: primaryKey({ columns: [t.userId, t.songId] }) })
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
