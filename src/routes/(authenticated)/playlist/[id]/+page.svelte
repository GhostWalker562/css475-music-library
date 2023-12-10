<script lang="ts">
	import AccountImage from '$lib/components/AccountImage.svelte';
	import GenericEmptyState from '$lib/components/GenericEmptyState.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import ModifyPlaylistForm from '$lib/components/forms/UpdatePlaylistForm.svelte';
	import TracksTable from '$lib/components/tables/TracksTable';
	import Button from '$ui/button/button.svelte';
	import * as Sheet from '$ui/sheet';
	import { Album } from 'lucide-svelte';
	import type { PageData } from './$types';

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
			{#if data.creator.id === data.user.userId}
				<Sheet.Root>
					<Sheet.Trigger asChild let:builder>
						<Button builders={[builder]} variant="secondary" class="ml-2">Modify Playlist</Button>
					</Sheet.Trigger>
					<Sheet.Content>
						<Sheet.Header class="pb-4">
							<Sheet.Title>Modify Playlist</Sheet.Title>
							<Sheet.Description>Enter a new name for your playlist.</Sheet.Description>
						</Sheet.Header>
						<ModifyPlaylistForm playlist={data.playlist} form={data.updatePlaylistForm} />
					</Sheet.Content>
				</Sheet.Root>
			{/if}
		</div>
	</SectionHeader>

	{#if data.tracks.length === 0}
		<GenericEmptyState icon={Album}>
			<h2 slot="title">This playlist is empty</h2>
			<p slot="subtitle">
				You can add tracks to this playlist by clicking the
				<span class="font-bold">Add to Playlist</span> button on any track.
			</p>
			<Button size="lg" href="/browse">Browse Songs</Button>
		</GenericEmptyState>
	{:else}
		<TracksTable data={data.tracks} userId={data.user.userId} />
	{/if}
</div>
