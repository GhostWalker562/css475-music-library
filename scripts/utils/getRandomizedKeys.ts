/* eslint-disable @typescript-eslint/no-explicit-any */
function shuffleArray(array: any[]) {
	for (let i = array.length - 1; i > 0; i--) {
		const j = Math.floor(Math.random() * (i + 1));
		[array[i], array[j]] = [array[j], array[i]];
	}
	return array;
}

export function getRandomizedKeys(obj: object) {
	const keys = Object.keys(obj);
	return shuffleArray(keys);
}
