<script lang="ts">
	import CoverImage from '$lib/components/CoverImage.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import Button from '$lib/components/ui/button/button.svelte';
	import { MoveLeft } from 'lucide-svelte';
	import type { PageData } from './$types';
	import PreviewButton from '$lib/components/PreviewButton.svelte';
	import { goto } from '$app/navigation';

	export let data: PageData;
</script>

<div class="w-full pr-8 pl-4 py-8">
	<Button
		variant="link"
		class="mb-4"
		on:click={() => (history.length > 1 ? history.go(-1) : goto('/browse'))}
	>
		<MoveLeft class="w-4 h-4 mr-2" />
		Browse
	</Button>

	<CoverImage
		src={data.track.album.coverImageUrl}
		fallbackSeed={data.track.song.name}
		class="w-full h-72 rounded-lg border"
	/>

	<br />

	<SectionHeader title={data.track.song.name} subtitle={data.track.artist.name}>
		<PreviewButton src={data.track.song.previewUrl} class={'hidden sm:flex'} />
	</SectionHeader>

	<div class="flex items-center gap-4">
		<PreviewButton src={data.track.song.previewUrl} class={'flex sm:hidden'} />
	</div>
</div>
