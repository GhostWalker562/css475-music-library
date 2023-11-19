const DEFAULT_ALPHABET = 'abcdefghijklmnopqrstuvwxyz1234567890';
export const generateRandomString = (length: number, alphabet = DEFAULT_ALPHABET) => {
	const randomUint32Values = new Uint32Array(length);
	crypto.getRandomValues(randomUint32Values);
	const u32Max = 0xffffffff;
	let result = '';
	for (let i = 0; i < randomUint32Values.length; i++) {
		const rand = randomUint32Values[i] / (u32Max + 1);
		result += alphabet[Math.floor(alphabet.length * rand)];
	}
	return result;
};
