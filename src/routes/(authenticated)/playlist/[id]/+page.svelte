<script lang="ts">
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import TracksTable from '$lib/components/tables/TracksTable';
	import type { PageData } from './$types';

	export let data: PageData;
</script>

<div class="px-2 min-h-screen pb-24">
	<SectionHeader title={data.playlist.name} subtitle="Manage your playlists" />

	<TracksTable data={data.tracks} userId={data.user.userId} />
</div>
