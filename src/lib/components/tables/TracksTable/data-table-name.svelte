<script lang="ts">
	import CoverImage from '$lib/components/CoverImage.svelte';
	import Badge from '$lib/components/ui/badge/badge.svelte';
	import Button from '$lib/components/ui/button/button.svelte';

	export let imageUrl: string | undefined | null;
	export let previewUrl: string | undefined | null = undefined;
	export let trackId: string;
	export let name: string;
</script>

<div class="flex items-center">
	<CoverImage src={imageUrl} class="w-8 h-8" />
	<Button variant="link" href={`/track/${trackId}`}>
		{name}
	</Button>
	{#if previewUrl}
		<Badge href={`/track/${trackId}`}>PREVIEW</Badge>
	{/if}
</div>
