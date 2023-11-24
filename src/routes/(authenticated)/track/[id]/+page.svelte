<script lang="ts">
	import CoverImage from '$lib/components/CoverImage.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import Button from '$lib/components/ui/button/button.svelte';
	import { MoveLeft } from 'lucide-svelte';
	import type { PageData } from './$types';
	import PreviewButton from '$lib/components/PreviewButton.svelte';
	import { goto } from '$app/navigation';
	import LikeButton from '$lib/components/LikeButton.svelte';
	import { applyAction, enhance } from '$app/forms';
	import type { ActionResult } from '@sveltejs/kit';

	export let data: PageData;

	let isLiked = data.isLiked;

	const enhanceLikeForm = () => {
		isLiked = !isLiked;
		return async ({ result }: { result: ActionResult }) => {
			await applyAction(result);
		};
	};
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
		<div class="flex justify-end flex-row-reverse sm:flex-row items-center mt-2 sm:mt-0 gap-4">
			<form use:enhance={enhanceLikeForm} action="?/toggleLike" method="post">
				<LikeButton type="submit" value={isLiked} />
			</form>
			<PreviewButton src={data.track.song.previewUrl} class={''} />
		</div>
	</SectionHeader>
</div>
