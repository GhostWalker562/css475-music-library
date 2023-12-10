<script lang="ts">
	import { applyAction, enhance } from '$app/forms';
	import { Button } from '$lib/components/ui/button';
	import * as Command from '$lib/components/ui/command';
	import * as DropdownMenu from '$lib/components/ui/dropdown-menu';
	import type { ActionResult } from '@sveltejs/kit';
	import { createQuery, useQueryClient } from '@tanstack/svelte-query';
	import { Album, Check, Copy, MoreHorizontal, Music, Tags, User } from 'lucide-svelte';
	import { tick } from 'svelte';
	import type { PlaylistsResponse } from '../../routes/api/playlists/+server';

	// State

	export let userId: string;
	export let trackId: string;
	export let albumId: string | undefined = undefined;
	export let artistId: string | undefined = undefined;
	export let showGoToSong = true;
	export let showAddToPlaylist = true;

	let open = false;

	// Queries

	const queryClient = useQueryClient();

	const playlists = createQuery({
		queryKey: ['userPlaylists', userId],
		queryFn: async () => {
			const res = await fetch(`/api/playlists?userId=${userId}`);
			return (await res.json()) as PlaylistsResponse;
		}
	});

	const trackPlaylists = createQuery({
		queryKey: ['trackPlaylists', trackId],
		queryFn: async () => {
			const res = await fetch(`/api/playlists?songId=${trackId}`);
			return (await res.json()) as PlaylistsResponse;
		}
	});

	// Mutations

	// View

	// We want to refocus the trigger button when the user selects
	// an item from the list so users can continue navigating the
	// rest of the form with the keyboard.
	const closeAndFocusTrigger = (triggerId: string) => {
		open = false;
		tick().then(() => document.getElementById(triggerId)?.focus());
	};

	const onCopy = () => navigator.clipboard.writeText(`${window.location.origin}/track/${trackId}`);

	const enhancePlaylistModification = async (triggerId: string) => {
		closeAndFocusTrigger(triggerId);
		return async ({ result }: { result: ActionResult }) => {
			await applyAction(result);
			await queryClient.invalidateQueries({ queryKey: ['trackPlaylists', trackId] });
		};
	};

	$: hasSongInPlaylist = (playlistId: string) =>
		$trackPlaylists.data?.playlists.some((p) => p.id === playlistId);
</script>

<DropdownMenu.Root bind:open let:ids>
	<DropdownMenu.Trigger asChild let:builder>
		<Button builders={[builder]} variant="ghost" size="icon" aria-label="Open menu">
			<MoreHorizontal />
		</Button>
	</DropdownMenu.Trigger>
	<DropdownMenu.Content class="w-[200px]">
		<DropdownMenu.Group>
			<DropdownMenu.Label>Actions</DropdownMenu.Label>
			{#if showGoToSong}
				<DropdownMenu.Item href={`/track/${trackId}`}>
					<Music class="mr-2 h-4 w-4" />
					Go to Song
				</DropdownMenu.Item>
			{/if}
			{#if albumId}
				<DropdownMenu.Item href={`/album/${albumId}`}>
					<Album class="mr-2 h-4 w-4" />
					Go to Album
				</DropdownMenu.Item>
			{/if}
			{#if artistId}
				<DropdownMenu.Item href={`/artist/${artistId}`}>
					<User class="mr-2 h-4 w-4" />
					Go to Artist
				</DropdownMenu.Item>
			{/if}
			{#if albumId || artistId || showGoToSong}
				<DropdownMenu.Separator />
			{/if}
			<DropdownMenu.Item on:click={onCopy}>
				<Copy class="mr-2 h-4 w-4" />
				Copy Link
			</DropdownMenu.Item>
			{#if showAddToPlaylist}
				<DropdownMenu.Separator />
				<DropdownMenu.Sub>
					<DropdownMenu.SubTrigger>
						<Tags class="mr-2 h-4 w-4" />
						Add to Playlist
					</DropdownMenu.SubTrigger>
					<DropdownMenu.SubContent class="p-0">
						<Command.Root>
							<Command.Input autofocus placeholder="Filter playlist..." />
							<Command.List>
								<Command.Empty>No label found.</Command.Empty>
								<Command.Group>
									{#if $playlists.isLoading}
										<Command.Item>Loading...</Command.Item>
									{:else if $playlists.isError}
										<Command.Item>Error loading playlists.</Command.Item>
									{:else if $playlists.isSuccess && $playlists.data?.playlists.length === 0}
										<Command.Item>No playlists found.</Command.Item>
									{:else if $playlists.isSuccess && $playlists.data?.playlists.length > 0}
										{#each $playlists.data.playlists as playlist}
											<Command.Item value={playlist.id} class="p-0">
												<form
													use:enhance={() => enhancePlaylistModification(ids.trigger)}
													method="POST"
													action={`/playlist/${playlist.id}?/togglePlaylistSong`}
													class="w-full"
												>
													<input type="hidden" name="songId" id="songId" value={trackId} />
													<input
														type="hidden"
														name="method"
														id="method"
														value={hasSongInPlaylist(playlist.id) ? 'REMOVE' : 'ADD'}
													/>
													<button type="submit" class="w-full flex items-center px-2 py-1.5">
														{playlist.name}
														{#if hasSongInPlaylist(playlist.id)}
															<Check class="ml-2 h-4 w-4" />
														{/if}
													</button>
												</form>
											</Command.Item>
										{/each}
									{/if}
								</Command.Group>
							</Command.List>
						</Command.Root>
					</DropdownMenu.SubContent>
				</DropdownMenu.Sub>
			{/if}
		</DropdownMenu.Group>
	</DropdownMenu.Content>
</DropdownMenu.Root>
