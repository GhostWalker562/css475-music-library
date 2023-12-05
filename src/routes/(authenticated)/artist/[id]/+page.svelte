<script lang="ts">
	import { goto } from '$app/navigation';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import type { PageData } from './$types';
	import CoverImage from '$lib/components/CoverImage.svelte';
	import TracksTable from '$lib/components/tables/TracksTable';
	import BackButton from '$lib/components/BackButton.svelte';

	export let data: PageData;
</script>

<div class="px-2 min-h-screen pb-24">
	<BackButton label="Artists" defaultRoute="/artist" />

	<CoverImage
		src={data.artist.auth_user.profileImageUrl}
		fallbackSeed={data.artist.artist.name}
		class="w-72 h-72 rounded-lg border mb-4"
	/>

	<SectionHeader title={data.artist.artist.name} subtitle={data.artist.artist.bio} />

	<TracksTable data={data.tracks} />
</div>
