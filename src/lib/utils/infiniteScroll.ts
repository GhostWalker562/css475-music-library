import type { Action } from 'svelte/action';

export const infiniteScroll: Action<
	HTMLElement,
	{
		hasMore?: boolean;
		onEndReached?: () => void;
	}
> = (node, { onEndReached, hasMore = false }) => {
	const observer = new IntersectionObserver((entries) => {
		const first = entries[0];
		if (first.isIntersecting && hasMore) onEndReached?.();
	});

	observer.observe(node);

	return {
		destroy() {
			observer?.disconnect();
		}
	};
};
