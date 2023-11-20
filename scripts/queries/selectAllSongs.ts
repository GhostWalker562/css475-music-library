import { db } from '$lib/db';
import { artist, song } from '$lib/db/schema';
import { eq, sql } from 'drizzle-orm';

export const selectAllSongsWithArtistSQL = sql`select * from \`song\` inner join \`artist\` on \`artist\`.\`id\` = \`song\`.\`artist_id\``;

export const selectAllSongsWithArtist = () =>
	db.select().from(song).innerJoin(artist, eq(artist.id, song.artistId));
