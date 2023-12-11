<script lang="ts">
	import Button from '$lib/components/ui/button/button.svelte';
	import { cn } from '$lib/utils';
	import { currentAudioPlayer } from '$lib/utils/globalAudio';
	import { Pause, Play } from 'lucide-svelte';
	import posthog from 'posthog-js';

	let player: HTMLAudioElement;
	let isPlaying = false;

	export let variant: 'button' | 'icon' = 'button';
	export let src: string | null | undefined;
	export let songName: string | null | undefined = undefined;
	export let className: string | null | undefined = undefined;
	export { className as class };

	$: onPreview = () => {
		if (!src) return;

		if (player.paused) {
			if ($currentAudioPlayer) $currentAudioPlayer.pause();
			$currentAudioPlayer = player;
			player.play();
			isPlaying = true;
			posthog.capture('Previewed Audio', { src, songName });
		} else {
			player.pause();
		}
	};

	$: {
		if (player) {
			player.addEventListener('ended', () => (isPlaying = false));
			player.addEventListener('pause', () => (isPlaying = false));
		}
	}
</script>

<audio bind:this={player} {src} />
{#if variant === 'button'}
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
{:else if variant === 'icon'}
	<Button
		on:click={onPreview}
		size="icon"
		variant={isPlaying ? 'secondary' : 'ghost'}
		class={cn('transition-all active:scale-95', className)}
		disabled={!src}
	>
		{#if src}
			{#if isPlaying}
				<Pause />
			{:else}
				<Play />
			{/if}
		{:else if !src}
			<Play />
		{/if}
	</Button>
{/if}
