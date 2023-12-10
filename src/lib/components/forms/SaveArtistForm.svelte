<script lang="ts">
	import * as Form from '$lib/components/ui/form';
	import { saveArtistSchema, type SaveArtistSchema } from '$lib/types/artist';
	import type { Artist } from '$lib/types/music';
	import type { SuperValidated } from 'sveltekit-superforms';

	export let form: SuperValidated<SaveArtistSchema>;
	export let artist: Artist | undefined;

	let isFormSubmitting = false;
	let recentlySubmitted = false;

	$: if (recentlySubmitted) setTimeout(() => (recentlySubmitted = false), 2000);
</script>

<Form.Root
	schema={saveArtistSchema}
	action="/settings/artist?/saveArtist"
	method="POST"
	{form}
	let:config
	options={{
		onSubmit: () => (isFormSubmitting = true),
		onResult: () => {
			isFormSubmitting = false;
			recentlySubmitted = true;
		}
	}}
>
	<Form.Field {config} name="name">
		<Form.Item>
			<Form.Label />
			<Form.Input class="w-fit" />
			<Form.Description>Your artist name that will be displayed on your profile.</Form.Description>
			<Form.Validation />
		</Form.Item>
	</Form.Field>
	<Form.Field {config} name="bio">
		<Form.Item>
			<Form.Label />
			<Form.Textarea class="w-1/4" />
			<Form.Description>Your bio for your artist profile.</Form.Description>
			<Form.Validation />
		</Form.Item>
	</Form.Field>
	<Form.Button class="max-w-fit my-3" size="lg" isLoading={isFormSubmitting}>
		{#if recentlySubmitted}
			Saved!
		{:else if !artist}
			Create Profile
		{:else}
			Update Profile
		{/if}
	</Form.Button>
</Form.Root>
