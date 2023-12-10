<script lang="ts">
	import CoverImage from '$lib/components/CoverImage.svelte';
	import Button from '$lib/components/ui/button/button.svelte';

	export let albumId: string;
	export let coverImageUrl: string | null | undefined;
	export let name: string;
</script>

<div class="flex items-center w-full">
	<CoverImage src={coverImageUrl} fallbackSeed={name} class="w-8 h-8" />
	<Button variant="link" href={`/album/${albumId}`}>
		{name}
	</Button>
</div>
