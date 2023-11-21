<script lang="ts">
	import Fuse from 'fuse.js';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import TrackItem from '$lib/components/TrackItem.svelte';
	import Input from '$lib/components/ui/input/input.svelte';
	import type { PageData } from './$types';
	import { page } from '$app/stores';
	import { goto } from '$app/navigation';

	export let data: PageData;

	const fuse = new Fuse(data.tracks, {
		keys: ['song.name', 'artist.name']
	});

	$: query = $page.url.searchParams.get('search') ?? '';

	$: tracks = query === '' ? data.tracks : fuse.search(query);
</script>

<div class="w-full pr-8 pl-4 py-8">
	<div class="px-2">
		<SectionHeader title="All Songs" subtitle="Check out all the songs in our library">
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
		{#each tracks as track}
			<TrackItem track={'item' in track ? track.item : track} />
		{/each}
	</div>
</div>
