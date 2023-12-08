<script lang="ts">
	import FormLikeButton from '$lib/components/FormLikeButton.svelte';
	import PreviewButton from '$lib/components/PreviewButton.svelte';
	import TrackDropdown from '$lib/components/TrackDropdown.svelte';

	export let trackId: string;
	export let userId: string;
	export let albumId: string | undefined = undefined;
	export let artistId: string | undefined = undefined;

	export let value: boolean = false;
	export let showLikeButton: boolean = true;
	export let previewUrl: string | null | undefined = undefined;
</script>

<div class="flex justify-end gap-2 lg:gap-4">
	{#if previewUrl}
		<PreviewButton variant="icon" src={previewUrl} />
	{/if}

	{#if showLikeButton}
		<FormLikeButton {trackId} {value} />
	{/if}

	<TrackDropdown {trackId} {userId} {artistId} {albumId} />
</div>
