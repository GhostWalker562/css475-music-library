<script lang="ts">
	import GenericEmptyState from '$lib/components/GenericEmptyState.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import TracksTable from '$lib/components/tables/TracksTable';
	import { Button } from '$ui/button';
	import { Heart } from 'lucide-svelte';
	import type { PageData } from './$types';

	export let data: PageData;
</script>

<div class="px-2 min-h-screen pb-24">
	<SectionHeader title="Liked Songs" subtitle="View the songs you've liked" />

	{#if data.likedTracks.length === 0}
		<GenericEmptyState icon={Heart}>
			<h2 slot="title">You have no liked songs</h2>
			<p slot="subtitle">
				You can like a song by clicking on the
				<span class="font-bold">Heart</span> button on any track.
			</p>
			<Button size="lg" href="/browse">Browse Songs</Button>
		</GenericEmptyState>
	{:else}
		<TracksTable data={data.likedTracks} userId={data.user.userId} />
	{/if}
</div>
