<script lang="ts">
	import PreviewButton from '$lib/components/PreviewButton.svelte';
	import Button from '$lib/components/ui/button/button.svelte';
	import { ArrowUpRightFromCircle } from 'lucide-svelte';

	export let playlistId: string;
</script>

<div class="flex justify-end gap-2 lg:gap-4">
	<Button variant="ghost" size="icon" href={`/playlist/${playlistId}`}>
		<ArrowUpRightFromCircle />
	</Button>
</div>
