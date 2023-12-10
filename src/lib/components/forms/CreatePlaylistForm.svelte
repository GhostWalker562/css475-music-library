<script lang="ts">
	import * as Form from '$lib/components/ui/form';
	import { createPlaylistSchema, type CreatePlaylistSchema } from '$lib/types/playlist';
	import Button from '$ui/button/button.svelte';
	import type { SuperValidated } from 'sveltekit-superforms';

	export let form: SuperValidated<CreatePlaylistSchema>;

	let isLoading = false;
</script>

<Form.Root
	action="/playlist?/createPlaylist"
	method="POST"
	{form}
	schema={createPlaylistSchema}
	let:config
	options={{ onSubmit: () => (isLoading = true) }}
>
	<Form.Field {config} name="name">
		<Form.Item>
			<Form.Label>Playlist Name</Form.Label>
			<Form.Input />
			<Form.Description>This is your publicly displayed playlist name.</Form.Description>
			<Form.Validation />
		</Form.Item>
	</Form.Field>
	<Button type="submit" {isLoading} class="my-2">Create Playlist</Button>
</Form.Root>
