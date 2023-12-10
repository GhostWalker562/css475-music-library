<script lang="ts">
	import { applyAction, enhance } from '$app/forms';
	import * as Form from '$lib/components/ui/form';
	import type { Playlist } from '$lib/types/music';
	import { createPlaylistSchema, type CreatePlaylistSchema } from '$lib/types/playlist';
	import Button from '$ui/button/button.svelte';
	import Separator from '$ui/separator/separator.svelte';
	import { getContext } from 'svelte';
	import type { SuperValidated } from 'sveltekit-superforms';
	import DeleteConfirmationForm from './DeleteConfirmationForm.svelte';

	export let playlist: Playlist;
	export let form: SuperValidated<CreatePlaylistSchema>;

	const dialog = getContext('dialog');

	let isModifying = false;

	let isDeleting = false;

	$: isDialogOpen = (dialog as any)?.states?.open;

	// View

	$: isLoading = isModifying || isDeleting;
</script>

<Form.Root
	action={`/playlist/${playlist.id}?/updatePlaylist`}
	method="POST"
	{form}
	schema={createPlaylistSchema}
	let:config
	options={{
		onSubmit: () => (isModifying = true),
		onResult: (e) => {
			isModifying = false;
			if (e.result.type !== 'failure') $isDialogOpen = false;
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

<DeleteConfirmationForm
	bind:isDeleting
	action={`/playlist/${playlist.id}?/deletePlaylist`}
	label="Delete Playlist"
	warning="You will not be able to recover this playlist once it has been deleted."
/>
