<script lang="ts">
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { onMount } from 'svelte';

	// State

	/** Must bind this function in order to receive changes */
	export let query: string | undefined;
	/** Must bind this function in order to receive the function */
	export let search: (e: InputEvent) => void | undefined;
	export let defaultRoute: string;
	export let delay: number = 600;

	let timeout: NodeJS.Timeout;

	// Functionality

	const debounceSearch = (e: InputEvent) => {
		clearTimeout(timeout);
		timeout = setTimeout(() => {
			const val = (e.target as HTMLInputElement).value;
			if (!val) goto(`${defaultRoute}`, { keepFocus: true });
			else goto(`?search=${val}`, { keepFocus: true, replaceState: true });
			query = val;
		}, delay);
	};

	onMount(() => {
		query = $page.url.searchParams.get('search') ?? undefined;
		search = debounceSearch;
	});
</script>
