<script lang="ts">
	import { goto } from '$app/navigation';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import { Button } from '$lib/components/ui/button';
	import { MoveLeft } from 'lucide-svelte';
	import type { PageData } from './$types';
	import CoverImage from '$lib/components/CoverImage.svelte';
	import TracksTable from '$lib/components/tables/TracksTable';

	export let data: PageData;
</script>

<Button
	variant="link"
	class="mb-4"
	on:click={() => (history.length > 1 ? history.go(-1) : goto('/browse'))}
>
	<MoveLeft class="w-4 h-4 mr-2" />
	Artists
</Button>

<CoverImage
	src={data.artist.auth_user.profileImageUrl}
	fallbackSeed={data.artist.artist.name}
	class="w-72 h-72 rounded-lg border mb-4"
/>

<SectionHeader title={data.artist.artist.name} subtitle={data.artist.artist.bio} />

<TracksTable data={data.tracks} />
