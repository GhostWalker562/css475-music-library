<script lang="ts">
	import { applyAction, enhance } from '$app/forms';
	import * as Form from '$lib/components/ui/form';
	import type { Playlist } from '$lib/types/music';
	import { createPlaylistSchema, type CreatePlaylistSchema } from '$lib/types/playlist';
	import Button from '$ui/button/button.svelte';
	import Separator from '$ui/separator/separator.svelte';
	import { getContext } from 'svelte';
	import type { SuperValidated } from 'sveltekit-superforms';

	export let playlist: Playlist;
	export let form: SuperValidated<CreatePlaylistSchema>;

	const dialog = getContext('dialog');

	let isModifying = false;

	let isDeleting = false;

	let confirmingDeletion = false;

	$: isDialogOpen = (dialog as any)?.states?.open;

	// View

	$: isLoading = isModifying || isDeleting;
</script>

<Form.Root
	action={`/playlist/${playlist.id}?/modifyPlaylist`}
	method="POST"
	{form}
	schema={createPlaylistSchema}
	let:config
	options={{
		onSubmit: () => (isModifying = true),
		onResult: () => {
			isModifying = false;
			$isDialogOpen = false;
		}
	}}
>
	<Form.Field {config} name="name">
		<Form.Item>
			<Form.Label>Playlist Name</Form.Label>
			<Form.Input placeholder={playlist.name} type="text" />
			<Form.Description>This is your publicly displayed playlist name.</Form.Description>
			<Form.Validation />
		</Form.Item>
	</Form.Field>
	<Button type="submit" disabled={isLoading} isLoading={isModifying} class="my-2">
		Modify Playlist
	</Button>
</Form.Root>

<Separator class="my-4" />

<form
	action={`/playlist/${playlist.id}?/deletePlaylist`}
	method="POST"
	use:enhance={() => {
		isDeleting = true;
		return async ({ result }) => await applyAction(result);
	}}
>
	{#if confirmingDeletion}
		<Button variant="destructive" type="submit" isLoading={isDeleting} disabled={isLoading}
			>Confirm Delete</Button
		>
		<Button
			variant="secondary"
			type="button"
			isLoading={isDeleting}
			class={isDeleting ? 'hidden' : ''}
			on:click={() => {
				confirmingDeletion = false;
			}}
		>
			Cancel
		</Button>
		<p class="text-xs my-4 text-red-500">
			You will not be able to recover this playlist once it has been deleted.
		</p>
	{:else}
		<Button variant="destructive" type="button" on:click={() => (confirmingDeletion = true)}>
			Delete Playlist
		</Button>
	{/if}
</form>
