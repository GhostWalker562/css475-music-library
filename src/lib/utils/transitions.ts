/* eslint-disable @typescript-eslint/no-explicit-any */
import type { Action } from 'svelte/action';

export const resizeContainer: Action = (node) => {
	function updateDimensions() {
		// Calculate total height of all children
		const childrenHeight = [...node.children].reduce(
			(acc, item) => acc + (item as HTMLElement).offsetHeight,
			0
		);

		// Find the maximum width among all children
		const childrenWidth = [...node.children].reduce(
			(max, item) => Math.max(max, (item as HTMLElement).offsetWidth),
			0
		);

		// Update container's height and width
		node.style.setProperty('height', `${childrenHeight}px`);
		node.style.setProperty('width', `${childrenWidth}px`);
	}

	const observer = new MutationObserver(() => {
		updateDimensions();
	});

	observer.observe(node, {
		characterData: true,
		subtree: true,
		childList: true
	});

	updateDimensions();

	node.style.setProperty('overflow', 'hidden');
	node.style.setProperty('transition', 'height 300ms ease, width 300ms ease');

	return {
		destroy() {
			observer?.disconnect();
		}
	};
};
