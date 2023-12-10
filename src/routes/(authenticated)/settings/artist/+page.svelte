<script lang="ts">
	import BackButton from '$lib/components/BackButton.svelte';
	import GenericEmptyState from '$lib/components/GenericEmptyState.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import UploadButton from '$lib/components/UploadButton.svelte';
	import SaveArtistForm from '$lib/components/forms/SaveArtistForm.svelte';
	import AlbumsTable from '$lib/components/tables/AlbumsTable.svelte';
	import { Album } from 'lucide-svelte';
	import type { PageData } from './$types';
	import Button from '$ui/button/button.svelte';
	import * as Sheet from '$ui/sheet';
	import CreateAlbumForm from '$lib/components/forms/CreateAlbumForm.svelte';

	export let data: PageData;

	let recentlySubmitted = false;

	// Effects

	$: if (recentlySubmitted) setTimeout(() => (recentlySubmitted = false), 2000);
</script>

<Sheet.Root>
	<Sheet.Trigger asChild let:builder>
		<div class="px-2">
			<BackButton defaultRoute="/settings" label="Settings" />

			<SectionHeader title="Artist Profile" subtitle="Manage your artist profile" />

			<SaveArtistForm form={data.saveArtistForm} artist={data.user?.artist} />

			<br />

			{#if data.user}
				<SectionHeader title="Albums" subtitle="Release new songs and manage albums">
					<div>
						<Button size="lg" builders={[builder]}>Create Album</Button>
					</div>
				</SectionHeader>
				{#if data.albums.length === 0}
					<GenericEmptyState icon={Album}>
						<h2 slot="title">You have no albums</h2>
						<p slot="subtitle">You can create one by clicking the button below</p>
						<Button size="lg" builders={[builder]}>Create Album</Button>
					</GenericEmptyState>
				{:else}
					<AlbumsTable data={data.albums} />
				{/if}
			{/if}
		</div>
	</Sheet.Trigger>

	<Sheet.Content>
		<Sheet.Header class="pb-4">
			<Sheet.Title>Create Album</Sheet.Title>
			<Sheet.Description>
				Enter a name for your album and upload an image for your playlist. You can change these
				later.
			</Sheet.Description>
		</Sheet.Header>
		<CreateAlbumForm form={data.createAlbumForm} />
	</Sheet.Content>
</Sheet.Root>
