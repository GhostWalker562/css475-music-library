<script lang="ts">
	import GenericEmptyState from '$lib/components/GenericEmptyState.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import CreatePlaylistForm from '$lib/components/forms/CreatePlaylistForm.svelte';
	import PlaylistsTable from '$lib/components/tables/PlaylistsTable';
	import Button from '$ui/button/button.svelte';
	import * as Sheet from '$ui/sheet';
	import { Disc3 } from 'lucide-svelte';
	import type { PageData } from './$types';

	export let data: PageData;
</script>

<Sheet.Root>
	<Sheet.Trigger asChild let:builder>
		<div class="px-2 min-h-screen pb-24">
			<SectionHeader title="Your Playlists" subtitle="Manage your playlists">
				<div>
					<Button builders={[builder]}>Create Playlist</Button>
				</div>
			</SectionHeader>

			{#if data.playlists.length === 0}
				<GenericEmptyState icon={Disc3}>
					<h2 slot="title">You have no playlists</h2>
					<p slot="subtitle">You can create one by clicking the button below</p>
					<Button size="lg" builders={[builder]}>Create Playlist</Button>
				</GenericEmptyState>
			{:else}
				<PlaylistsTable data={data.playlists} />
			{/if}
		</div>
	</Sheet.Trigger>

	<Sheet.Content>
		<Sheet.Header class="pb-4">
			<Sheet.Title>Create Playlist</Sheet.Title>
			<Sheet.Description>
				Enter a name for your playlist. You can change this later.
			</Sheet.Description>
		</Sheet.Header>
		<CreatePlaylistForm form={data.form} />
	</Sheet.Content>
</Sheet.Root>
