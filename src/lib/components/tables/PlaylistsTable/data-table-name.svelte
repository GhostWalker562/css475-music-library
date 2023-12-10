<script lang="ts">
	import CoverImage from '$lib/components/CoverImage.svelte';
	import Button from '$lib/components/ui/button/button.svelte';

	export let playlistId: string;
	export let name: string;
</script>

<div class="flex items-center w-full">
	<CoverImage src={undefined} fallbackSeed={name} class="w-8 h-8" />
	<Button variant="link" href={`/playlist/${playlistId}`}>
		{name}
	</Button>
</div>
