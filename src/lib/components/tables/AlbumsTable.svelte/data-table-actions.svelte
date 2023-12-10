<script lang="ts">
	import Button from '$lib/components/ui/button/button.svelte';
	import { ArrowUpRightFromCircle } from 'lucide-svelte';

	export let albumId: string;
</script>

<div class="flex justify-end gap-2 lg:gap-4">
	<Button variant="ghost" size="icon" href={`/album/${albumId}`}>
		<ArrowUpRightFromCircle />
	</Button>
</div>
