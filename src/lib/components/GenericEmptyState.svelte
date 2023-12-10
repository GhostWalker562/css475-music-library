<script lang="ts">
	import type { SvelteComponent } from 'svelte';

	export let icon: typeof SvelteComponent<any>;
</script>

<div class="py-24">
	<div class="flex flex-col items-center gap-4">
		<svelte:component this={icon} class="w-24 h-24 opacity-80 stroke-1" />
		<div class="text-2xl font-bold"><slot name="title" /></div>
		<div class="text-sm text-center max-w-xs opacity-80">
			<slot name="subtitle" />
		</div>
		<slot />
	</div>
</div>
