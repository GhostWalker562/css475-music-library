<script lang="ts">
	import * as Form from '$lib/components/ui/form';
	import * as Select from '$lib/components/ui/select';
	import { GENRES } from '$lib/constants/music';
	import { createSongSchema, type CreateSongSchema } from '$lib/types/song';
	import Button from '$ui/button/button.svelte';
	import type { SuperValidated } from 'sveltekit-superforms';

	export let form: SuperValidated<CreateSongSchema>;

	let isLoading = false;
</script>

<Form.Root
	action="/track?/createSong"
	method="POST"
	{form}
	class="grid gap-2"
	schema={createSongSchema}
	let:config
	options={{
		onSubmit: () => (isLoading = true),
		onResult: () => (isLoading = false)
	}}
>
	<Form.Field {config} name="albumId">
		<Form.Item><Form.Input type="hidden" /></Form.Item>
	</Form.Field>

	<Form.Field {config} name="name">
		<Form.Item>
			<Form.Label>Song Name</Form.Label>
			<Form.Input />
			<Form.Description>This is your publicly displayed song name.</Form.Description>
			<Form.Validation />
		</Form.Item>
	</Form.Field>

	<Form.Field {config} name="genre">
		<Form.Item>
			<Form.Label>Genre</Form.Label>
			<Form.Select>
				<Select.Trigger class="w-[180px]">
					<Select.Value placeholder="POP" />
				</Select.Trigger>
				<Select.Content>
					{#each GENRES as genre}
						<Select.Item value={genre}>{genre}</Select.Item>
					{/each}
				</Select.Content>
			</Form.Select>
			<Form.Description>Genre of this song.</Form.Description>
			<Form.Validation />
		</Form.Item>
	</Form.Field>

	<Form.Field {config} name="previewUrl">
		<Form.Item>
			<Form.Label>Preview Url</Form.Label>
			<Form.Input />
			<Form.Description>This must be provided for people to preview your song.</Form.Description>
			<Form.Validation />
		</Form.Item>
	</Form.Field>

	<Button type="submit" {isLoading} class="my-2">Create Song</Button>
</Form.Root>
