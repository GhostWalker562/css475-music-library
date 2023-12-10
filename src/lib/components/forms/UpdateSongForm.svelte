<script lang="ts">
	import * as Form from '$lib/components/ui/form';
	import * as Select from '$lib/components/ui/select';
	import { GENRES } from '$lib/constants/music';
	import { updateSongSchema, type UpdateSongSchema } from '$lib/types/song';
	import Button from '$ui/button/button.svelte';
	import Separator from '$ui/separator/separator.svelte';
	import { getContext } from 'svelte';
	import type { SuperValidated } from 'sveltekit-superforms';
	import DeleteConfirmationForm from './DeleteConfirmationForm.svelte';

	export let form: SuperValidated<UpdateSongSchema>;
	export let songId: string;

	const dialog = getContext('dialog');

	let isUpdating = false;

	let isDeleting = false;

	let isLoading = isUpdating || isDeleting;

	$: isDialogOpen = (dialog as any)?.states?.open;
</script>

<Form.Root
	action={`/track/${songId}?/updateSong`}
	method="POST"
	{form}
	class="grid gap-2"
	schema={updateSongSchema}
	let:config
	options={{
		onSubmit: () => (isUpdating = true),
		onResult: (e) => {
			isUpdating = false;
			if (e.result.type !== 'failure') $isDialogOpen = false;
		}
	}}
>
	<Form.Field {config} name="id">
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

	<Button type="submit" isLoading={isUpdating} disabled={isLoading} class="my-2 w-fit">
		Edit Song
	</Button>
</Form.Root>

<Separator class="my-4" />

<DeleteConfirmationForm
	bind:isDeleting
	action={`/track/${songId}?/deleteSong`}
	label="Delete Song"
	warning="You will not be able to recover this song once it has been deleted."
	closeDialog
/>
