<script lang="ts">
	import AccountImage from '$lib/components/AccountImage.svelte';
	import BackButton from '$lib/components/BackButton.svelte';
	import CoverImage from '$lib/components/CoverImage.svelte';
	import GenericEmptyState from '$lib/components/GenericEmptyState.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import TracksTable from '$lib/components/tables/TracksTable';
	import Button from '$ui/button/button.svelte';
	import { Album, Pencil, Plus } from 'lucide-svelte';
	import type { PageData } from './$types';
	import * as Sheet from '$ui/sheet';
	import SheetContent from '$ui/sheet/sheet-content.svelte';
	import UpdateAlbumForm from '$lib/components/forms/UpdateAlbumForm.svelte';
	import CreateSongForm from '$lib/components/forms/CreateSongForm.svelte';

	export let data: PageData;
</script>

<div class="px-2 min-h-screen pb-24">
	<BackButton label="Album" defaultRoute="/album" />

	<CoverImage
		src={data.album.coverImageUrl}
		fallbackSeed={data.album.name}
		class="w-full h-72 rounded-lg border"
	/>

	<br />

	<SectionHeader title={data.album.name}>
		<div class="flex items-center gap-2">
			<div class="flex items-center gap-2">
				<span class="text-xs opacity-50"> Created by </span>
				<AccountImage
					class="h-6 w-6"
					src={data.artist.auth_user.profileImageUrl}
					alt={data.artist.auth_user.username}
				/>
				<a class="hover:underline underline-offset-4" href={`/artist/${data.artist.artist.id}`}>
					{data.artist.auth_user.username}
				</a>
			</div>
			•
			{data.tracks.length} tracks
			{#if data.artist.artist.id === data.user.userId}
				<div class="flex gap-2">
					<Sheet.Root>
						<Sheet.Trigger asChild let:builder>
							<Button variant="secondary" builders={[builder]}>
								Edit Album
								<Pencil class="ml-2 w-3 h-3" />
							</Button>
						</Sheet.Trigger>
						<SheetContent>
							<Sheet.Header class="pb-4">
								<Sheet.Title>Edit Album</Sheet.Title>
								<Sheet.Description>
									Enter a name for your album and upload an image for your playlist. You can change
									these later.
								</Sheet.Description>
							</Sheet.Header>
							<UpdateAlbumForm form={data.updateAlbumForm} albumId={data.album.id} />
						</SheetContent>
					</Sheet.Root>
					<Sheet.Root>
						<Sheet.Trigger>
							<Button variant="secondary">
								Release Song
								<Plus class="ml-1 w-4 h-4" />
							</Button>
						</Sheet.Trigger>
						<SheetContent>
							<Sheet.Header class="pb-4">
								<Sheet.Title>Release Song</Sheet.Title>
								<Sheet.Description>
									Enter a name for your album and upload an image for your playlist. You can change
									these later.
								</Sheet.Description>
							</Sheet.Header>
							<CreateSongForm form={data.createSongForm} />
						</SheetContent>
					</Sheet.Root>
				</div>
			{/if}
		</div>
	</SectionHeader>

	{#if data.tracks.length === 0}
		<GenericEmptyState icon={Album}>
			<h2 slot="title">This album is empty</h2>
			<p slot="subtitle">You can find more albums by clicking the button below</p>
			<Button href={`/album`} size="lg">Discover Albums</Button>
		</GenericEmptyState>
	{:else}
		<TracksTable
			data={data.tracks}
			userId={data.user.userId}
			showAlbum={false}
			showGoToAlbum={false}
			updateSongForms={data.updateSongForms}
		/>
	{/if}
</div>
