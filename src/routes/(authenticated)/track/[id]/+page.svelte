<script lang="ts">
	import CoverImage from '$lib/components/CoverImage.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import type { PageData } from './$types';
	import PreviewButton from '$lib/components/PreviewButton.svelte';
	import LikeButton from '$lib/components/LikeButton.svelte';
	import { applyAction, enhance } from '$app/forms';
	import type { ActionResult } from '@sveltejs/kit';
	import BackButton from '$lib/components/BackButton.svelte';

	export let data: PageData;

	let isLiked = data.isLiked;

	const enhanceLikeForm = () => {
		isLiked = !isLiked;
		return async ({ result }: { result: ActionResult }) => {
			await applyAction(result);
		};
	};
</script>

<div class="px-2">
	<BackButton label="Browse" defaultRoute="/browse" />

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
