<script lang="ts">
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import TrackItem from '$lib/components/TrackItem.svelte';
	import Button from '$lib/components/ui/button/button.svelte';
	import { ListMusic } from 'lucide-svelte';
	import type { PageData } from './$types';
	import ShapeBackground from '$lib/components/ShapeBackground.svelte';
	import Logo from '$lib/components/Logo.svelte';

	export let data: PageData;
</script>

<div class="w-full pr-8 pl-4 py-8">
	<div class="mx-2 border rounded-md relative overflow-hidden -z-50">
		<ShapeBackground />
		<div class="p-8 bg-black/40 w-full h-full center flex-col">
			<div class="flex center mb-2 text-3xl md:text-4xl md:font-light">
				<Logo class="w-8 h-8 mr-4" /> Skypix
			</div>
			<div class="ml-8 opacity-70 tracking-wide mt-2 hidden md:block">
				Your Minimal Music Library
			</div>
		</div>
	</div>
	<br />

	<!-- Discover -->
	<div class="px-2">
		<SectionHeader title="Discover" subtitle="Find trending music this year">
			<Button href="/browse" variant="outline" size="lg">
				<ListMusic class="w-4 h-4 mr-2" />
				Browse All
			</Button>
		</SectionHeader>
	</div>
	<div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-6">
		{#each data.tracks as track}
			<TrackItem {track} />
		{/each}
	</div>

	<br />

	<!-- Recommendations -->
	{#if data.recommendations.length > 0}
		<div class="px-2">
			<SectionHeader
				title="Recommendations"
				subtitle="Check out a list of recommendations made for you"
			/>
		</div>
		<div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-6">
			{#each data.recommendations as recommendation}
				<TrackItem track={recommendation} />
			{/each}
		</div>
	{/if}
</div>
