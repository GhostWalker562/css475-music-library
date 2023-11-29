export function formatSearchQuery(query: string) {
	const words = query.split(' ').filter((word) => word.trim() !== '');
	return words.join(' & ');
}
