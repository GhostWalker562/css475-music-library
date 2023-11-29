function getRandomElement<T>(array: T[]): T {
	return array[Math.floor(Math.random() * array.length)];
}

export function generateRandomName(): string {
	const firstNames = [
		'Alice',
		'Bob',
		'Charlie',
		'Diana',
		'Edward',
		'Fiona',
		'George',
		'Hannah',
		'Ivan',
		'Julia'
	];
	const lastNames = [
		'Smith',
		'Johnson',
		'Williams',
		'Brown',
		'Jones',
		'Garcia',
		'Miller',
		'Davis',
		'Rodriguez',
		'Martinez'
	];

	const firstName = getRandomElement(firstNames);
	const lastName = getRandomElement(lastNames);

	return `${firstName} ${lastName}`;
}
