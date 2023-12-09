<script lang="ts">
	import AccountImage from '$lib/components/AccountImage.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import TracksTable from '$lib/components/tables/TracksTable';
	import { Album } from 'lucide-svelte';
	import type { PageData } from './$types';
	import Button from '$ui/button/button.svelte';

	export let data: PageData;
</script>

<div class="px-2 min-h-screen pb-24">
	<SectionHeader title={data.playlist.name}>
		<div class="flex items-center gap-2">
			<div class="flex items-center gap-2">
				<span class="text-xs opacity-50"> Created by </span>
				<AccountImage
					class="h-6 w-6"
					src={data.creator.profileImageUrl}
					alt={data.creator.username}
				/>
				<span>
					{data.creator.username}
				</span>
			</div>
			•
			{data.tracks.length} tracks
		</div>
	</SectionHeader>

	{#if data.tracks.length === 0}
		<div class="py-24">
			<div class="flex flex-col items-center gap-4">
				<Album class="w-24 h-24 opacity-80 stroke-1" />
				<h2 class="text-2xl font-bold">This playlist is empty</h2>
				<p class="text-sm text-center max-w-xs opacity-80">
					You can add tracks to this playlist by clicking the
					<span class="font-bold">Add to Playlist</span> button on any track.
				</p>
				<Button size="lg" href="/browse">Browse Songs</Button>
			</div>
		</div>
	{:else}
		<TracksTable data={data.tracks} userId={data.user.userId} />
	{/if}
</div>
