<script lang="ts">
	import FormLikeButton from '$lib/components/FormLikeButton.svelte';
	import PreviewButton from '$lib/components/PreviewButton.svelte';
	import TrackDropdown from '$lib/components/TrackDropdown.svelte';
	import UpdateSongForm from '$lib/components/forms/UpdateSongForm.svelte';
	import type { Track } from '$lib/types/music';
	import type { UpdateSongSchema } from '$lib/types/song';
	import Button from '$ui/button/button.svelte';
	import * as Sheet from '$ui/sheet';
	import { Pencil } from 'lucide-svelte';
	import type { SuperValidated } from 'sveltekit-superforms';

	export let track: Track;

	export let userId: string;
	export let albumId: string | undefined = undefined;
	export let artistId: string | undefined = undefined;

	export let value: boolean = false;
	export let showLikeButton: boolean = true;
	export let previewUrl: string | null | undefined = undefined;

	export let updateSongForms: SuperValidated<UpdateSongSchema>[] | undefined = undefined;

	$: songForm = updateSongForms?.find((e) => e.data.id === track.song.id);
</script>

<div class="flex justify-end gap-2 lg:gap-4">
	{#if previewUrl}
		<PreviewButton variant="icon" src={previewUrl} />
	{/if}

	{#if artistId === userId && songForm}
		<Sheet.Root>
			<Sheet.Trigger asChild let:builder>
				<Button size="icon" variant="outline" builders={[builder]}>
					<Pencil class="h-4 w-4" />
				</Button>
			</Sheet.Trigger>

			<Sheet.Content>
				<Sheet.Header class="pb-4">
					<Sheet.Title>Edit Song</Sheet.Title>
					<Sheet.Description>You can update the song name and genre here.</Sheet.Description>
				</Sheet.Header>

				<UpdateSongForm songId={track.song.id} form={songForm} />
			</Sheet.Content>
		</Sheet.Root>
	{/if}

	{#if showLikeButton}
		<FormLikeButton trackId={track.song.id} {value} />
	{/if}

	<TrackDropdown trackId={track.song.id} {userId} {artistId} {albumId} />
</div>
