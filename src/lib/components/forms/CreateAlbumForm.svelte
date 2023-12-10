<script lang="ts">
	import * as Form from '$lib/components/ui/form';
	import { createAlbumSchema, type CreateAlbumSchema } from '$lib/types/album';
	import Button from '$ui/button/button.svelte';
	import type { SuperValidated } from 'sveltekit-superforms';
	import ImageInput from '../ImageInput.svelte';

	export let form: SuperValidated<CreateAlbumSchema>;

	let isLoading = false;
</script>

<Form.Root
	action="/album?/createAlbum"
	method="POST"
	{form}
	schema={createAlbumSchema}
	let:config
	options={{
		onSubmit: () => (isLoading = true),
		onResult: (e) => (isLoading = false)
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
			<Form.Description>This is your publicly displayed album cover.</Form.Description>
			<Form.Validation />
		</Form.Item>
	</Form.Field>

	<Button type="submit" {isLoading} class="my-2">Create Album</Button>
</Form.Root>
