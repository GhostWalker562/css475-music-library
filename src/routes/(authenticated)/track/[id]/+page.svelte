<script lang="ts">
	import { applyAction, enhance } from '$app/forms';
	import ArtistCard from '$lib/components/ArtistCard.svelte';
	import BackButton from '$lib/components/BackButton.svelte';
	import CoverImage from '$lib/components/CoverImage.svelte';
	import LikeButton from '$lib/components/LikeButton.svelte';
	import PreviewButton from '$lib/components/PreviewButton.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import TrackDropdown from '$lib/components/TrackDropdown.svelte';
	import TracksTable from '$lib/components/tables/TracksTable';
	import Card from '$lib/components/ui/card/card.svelte';
	import Separator from '$lib/components/ui/separator/separator.svelte';
	import type { ActionResult } from '@sveltejs/kit';
	import { Album, Heart, Search } from 'lucide-svelte';
	import type { PageData } from './$types';

	export let data: PageData;

	$: isLiked = data.isLiked;

	const enhanceLikeForm = () => {
		isLiked = !isLiked;
		return async ({ result }: { result: ActionResult }) => {
			await applyAction(result);
		};
	};
</script>

<div class="px-2 min-h-screen pb-24">
	<BackButton label="Browse" defaultRoute="/browse" />

	<CoverImage
		src={data.track.album.coverImageUrl}
		fallbackSeed={data.track.song.name}
		class="w-full h-72 rounded-lg border"
	/>

	<br />

	<SectionHeader
		title={data.track.song.name}
		subtitle={data.track.artist.name}
		subtitleHref={`/artist/${data.track.artist.id}`}
	>
		<div class="flex justify-end flex-row-reverse sm:flex-row items-center mt-2 sm:mt-0 gap-4">
			<TrackDropdown
				userId={data.user.userId}
				trackId={data.track.song.id}
				artistId={data.track.artist.id}
				albumId={data.track.album.id}
				showGoToSong={false}
			/>
			<form use:enhance={enhanceLikeForm} action="?/toggleLike" method="post">
				<LikeButton type="submit" value={isLiked} />
			</form>
			<PreviewButton src={data.track.song.previewUrl} />
		</div>
	</SectionHeader>

	<div class="grid md:grid-cols-3 gap-4">
		<ArtistCard artistId={data.track.artist.id} />
		<Card class="p-4">
			<div class="flex flex-col gap-2 justify-between h-full">
				<div class="flex items-center justify-between">
					<div class="flex items-start flex-col">
						<h1 class="text-sm">Total Likes</h1>
						<p class="text-2xl font-bold">3210</p>
					</div>
					<Heart class="opacity-50" />
				</div>
				<Separator />
				<div class="flex items-center justify-between">
					<div class="flex items-start flex-col">
						<h1 class="text-sm">Total Playlists</h1>
						<p class="text-2xl font-bold">14</p>
					</div>
					<Album class="opacity-50" />
				</div>
			</div>
		</Card>
	</div>

	<Separator class="my-4" />

	<SectionHeader
		title={'Album Songs'}
		subtitle={`${data.track.album.name} • ${data.albumTracks.length + 1} Songs`}
	/>
	{#if data.albumTracks.length > 0}
		<TracksTable data={data.albumTracks} userId={data.user.userId} showAlbum={false} />
	{:else}
		<div class=" py-20 grid gap-4">
			<Search class="w-12 h-12 mx-auto opacity-50" />
			<p class="text-center text-foreground/60">No other songs found</p>
		</div>
	{/if}
</div>
