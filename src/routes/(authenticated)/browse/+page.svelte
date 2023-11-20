<script lang="ts">
	import TrackItem from '$lib/components/TrackItem.svelte';
	import { Separator } from '$lib/components/ui/separator';
	import type { PageData } from './$types';

	export let data: PageData;
</script>

<div class="w-full pr-8 pl-4 py-8">
	<div class="flex items-center justify-between">
		<div class="space-y-1">
			<h2 class="text-2xl font-semibold tracking-tight">All Songs</h2>
			<p class="text-sm text-muted-foreground">Check out all the songs in our library</p>
		</div>
	</div>
	<Separator class="my-4" />
	<div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-8">
		{#each data.tracks as track}
			<TrackItem {track} />
		{/each}
	</div>
</div>
