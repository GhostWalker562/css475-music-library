<script lang="ts">
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import PlaylistsTable from '$lib/components/tables/PlaylistsTable';
	import type { PageData } from './$types';

	export let data: PageData;
</script>

<div class="px-2 min-h-screen pb-24">
	<SectionHeader title="Your Playlists" subtitle="Manage your playlists" />

	<PlaylistsTable data={data.playlists} />
</div>
