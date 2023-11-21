<script lang="ts">
	import Button from '$lib/components/ui/button/button.svelte';
	import { cn } from '$lib/utils';
	import { Pause, Play } from 'lucide-svelte';

	let player: HTMLAudioElement;
	let isPlaying = false;

	export let src: string | null | undefined;
	export let className: string;
	export { className as class };

	const onPreview = () => {
		if (!src) return;
		player.paused ? player.play() : player.pause();
		isPlaying = !player.paused;
	};
</script>

<audio bind:this={player} {src} />
<Button
	on:click={onPreview}
	size="lg"
	class={cn('transition-all active:scale-95', className)}
	disabled={!src}
>
	{#if src}
		{#if isPlaying}
			<Pause class="w-4 h-4 mr-2" /> Pause
		{:else}
			<Play class="w-4 h-4 mr-2" /> Preview
		{/if}
	{:else if !src}
		<Play class="w-4 h-4 mr-2" /> No Preview
	{/if}
</Button>
