export const getRandomElements = <T>(arr: T[], count: number): T[] => {
	const result: T[] = [];
	const chosenIndices = new Set<number>();

	while (result.length < count && result.length < arr.length) {
		const randomIndex = Math.floor(Math.random() * arr.length);
		if (!chosenIndices.has(randomIndex)) {
			chosenIndices.add(randomIndex);
			result.push(arr[randomIndex]);
		}
	}

	return result;
};
