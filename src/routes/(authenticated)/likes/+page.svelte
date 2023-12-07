<script lang="ts">
	import TrackItem from '$lib/components/TrackItem.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import TracksTable from '$lib/components/tables/TracksTable';
	import type { PageData } from './$types';

	export let data: PageData;

</script>

<SectionHeader title="Liked Songs" subtitle="View the songs you've liked" />

<div class="px-2 min-h-screen pb-24">
		<TracksTable data={data.likedTracks} />
</div>
