<script lang="ts">
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import TrackItem from '$lib/components/TrackItem.svelte';
	import type { PageData } from './$types';

	export let data: PageData;
</script>

<div class="w-full pr-8 pl-4 py-8">
	<div class="px-2">
		<SectionHeader title="All Songs" subtitle="Check out all the songs in our library" />
	</div>
	<div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-6">
		{#each data.tracks as track}
			<TrackItem {track} />
		{/each}
	</div>
</div>
