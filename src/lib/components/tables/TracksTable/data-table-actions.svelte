<script lang="ts">
	import FormLikeButton from '$lib/components/FormLikeButton.svelte';
	import PreviewButton from '$lib/components/PreviewButton.svelte';
	import Button from '$lib/components/ui/button/button.svelte';
	import { ArrowUpRightFromCircle } from 'lucide-svelte';

	export let trackId: string;
	export let value: boolean = false;
	export let previewUrl: string | null | undefined = undefined;
</script>

<div class="flex justify-end gap-2 lg:gap-4">
	{#if previewUrl}
		<PreviewButton variant="icon" src={previewUrl} />
	{/if}

	<FormLikeButton {trackId} {value} />
	<Button variant="ghost" size="icon" href={`/track/${trackId}`}>
		<ArrowUpRightFromCircle />
	</Button>
</div>
