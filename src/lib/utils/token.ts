import { db } from '$lib/db';
import { passwordReset } from '$lib/db/schema';
import { eq } from 'drizzle-orm';
import { generateRandomString, isWithinExpiration } from 'lucia/utils';

const EXPIRES_IN = 1000 * 60 * 60 * 2; // 2 hours

export const generatePasswordResetToken = async (userId: string) => {
	const storedUserTokens = await db.query.passwordReset.findMany({
		where: eq(passwordReset.userId, userId)
	});

	// check if there are any stored tokens
	if (storedUserTokens.length > 0) {
		const reusableStoredToken = storedUserTokens.find((token) => {
			// check if expiration is within 1 hour
			// and reuse the token if true
			return isWithinExpiration(Number(token.expires) - EXPIRES_IN / 2);
		});
		if (reusableStoredToken) return reusableStoredToken.id;
	}

	const token = generateRandomString(63);
	await db.insert(passwordReset).values({
		id: token,
		expires: new Date().getTime() + EXPIRES_IN,
		userId
	});

	return token;
};

export const validatePasswordResetToken = async (token: string) => {
	const storedToken = await db.transaction(async (tx) => {
		const storedToken = await tx.query.passwordReset.findFirst({
			where: eq(passwordReset.id, token)
		});
		if (!storedToken) throw new Error('Invalid token');
		tx.delete(passwordReset).where(eq(passwordReset.id, storedToken.id));
		return storedToken;
	});
	const tokenExpires = Number(storedToken.expires); // bigint => number conversion
	if (!isWithinExpiration(tokenExpires)) {
		throw new Error('Expired token');
	}
	return storedToken.userId;
};
