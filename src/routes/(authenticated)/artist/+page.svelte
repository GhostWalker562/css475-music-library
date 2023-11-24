<script lang="ts">
	import ArtistItem from '$lib/components/ArtistItem.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import Fuse from 'fuse.js';
	import type { PageData } from './$types';
	import { page } from '$app/stores';
	import { goto } from '$app/navigation';
	import { Input } from '$lib/components/ui/input';

	export let data: PageData;

	const fuse = new Fuse(data.artists, {
		keys: ['artist.name']
	});

	$: query = $page.url.searchParams.get('search') ?? '';

	$: artists = query === '' ? data.artists : fuse.search(query);
</script>

<div class="px-2">
	<SectionHeader title="Discover Artists" subtitle="Find trending artists">
		<Input
			on:input={(e) => goto('?search=' + e.currentTarget.value, { keepFocus: true })}
			type="search"
			value={query}
			placeholder="Search..."
			class="h-9 my-2 md:my-0 md:w-[300px] "
		/>
	</SectionHeader>
</div>

<div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-6">
	{#each artists as artistUser}
		<ArtistItem item={'item' in artistUser ? artistUser.item : artistUser} />
	{/each}
</div>
