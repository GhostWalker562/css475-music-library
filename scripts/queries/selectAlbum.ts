import { db } from '$lib/db';
import { album } from '$lib/db/schema';
import { eq } from 'drizzle-orm';

export const selectAlbum = (id: string) => db.select().from(album).where(eq(album.id, id)).limit(1);
