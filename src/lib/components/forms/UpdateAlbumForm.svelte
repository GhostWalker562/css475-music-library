<script lang="ts">
	import * as Form from '$lib/components/ui/form';
	import { createAlbumSchema, type CreateAlbumSchema } from '$lib/types/album';
	import Button from '$ui/button/button.svelte';
	import type { SuperValidated } from 'sveltekit-superforms';
	import ImageInput from '../ImageInput.svelte';
	import { getContext } from 'svelte';
	import Separator from '$ui/separator/separator.svelte';
	import DeleteConfirmationForm from './DeleteConfirmationForm.svelte';

	export let form: SuperValidated<CreateAlbumSchema>;

	export let albumId: string;

	const dialog = getContext('dialog');

	let isUpdating = false;

	let isDeleting = false;

	let isLoading = isUpdating || isDeleting;

	$: isDialogOpen = (dialog as any)?.states?.open;
</script>

<Form.Root
	action={`/album/${albumId}?/updateAlbum`}
	method="POST"
	{form}
	schema={createAlbumSchema}
	let:config
	options={{
		onSubmit: () => (isUpdating = true),
		onResult: (e) => {
			isUpdating = false;
			if (e.result.type !== 'failure') $isDialogOpen = false;
		}
	}}
>
	<Form.Field {config} name="name">
		<Form.Item>
			<Form.Label>Album Name</Form.Label>
			<Form.Input />
			<Form.Description>This is your publicly displayed album name.</Form.Description>
			<Form.Validation />
		</Form.Item>
	</Form.Field>

	<Form.Field {config} name="imageUrl">
		<Form.Item>
			<Form.Label>Album Cover</Form.Label>
			<ImageInput />
			<Form.Description>This is your publicly displayed cover image.</Form.Description>
			<Form.Validation />
		</Form.Item>
	</Form.Field>

	<Button type="submit" isLoading={isUpdating} disabled={isLoading} class="my-2">Edit Album</Button>
</Form.Root>

<Separator class="my-4" />

<DeleteConfirmationForm
	bind:isDeleting
	action={`/album/${albumId}?/deleteAlbum`}
	label="Delete Album"
	warning="You will not be able to recover this album once it has been deleted. You will delete all the songs under this album."
/>
