<script lang="ts">
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import CreatePlaylistForm from '$lib/components/forms/CreatePlaylistForm.svelte';
	import PlaylistsTable from '$lib/components/tables/PlaylistsTable';
	import Button from '$ui/button/button.svelte';
	import * as Sheet from '$ui/sheet';
	import type { PageData } from './$types';

	export let data: PageData;
</script>

<div class="px-2 min-h-screen pb-24">
	<SectionHeader title="Your Playlists" subtitle="Manage your playlists">
		<div>
			<Sheet.Root>
				<Sheet.Trigger asChild let:builder>
					<Button builders={[builder]}>Create Playlist</Button>
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
		</div>
	</SectionHeader>

	<PlaylistsTable data={data.playlists} />
</div>
