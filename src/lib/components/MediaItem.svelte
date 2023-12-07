<script lang="ts">
	import { AspectRatio } from '$lib/components/ui/aspect-ratio';
	import CoverImage from './CoverImage.svelte';

	export let imageUrl: string | undefined | null = undefined;
	export let title: string;
	export let subtitle: string | undefined | null = undefined;
	export let href: string;
</script>

<a
	class="text-left hover:bg-muted-foreground/20 hover:scale-95 active:bg-muted-foreground/25 p-3 rounded-md transition-all"
	{href}
>
	<div class="border-none flex flex-col gap-3">
		<AspectRatio ratio={1 / 1} class="bg-muted rounded-md overflow-hidden">
			<CoverImage src={imageUrl} fallbackSeed={title} />
		</AspectRatio>
		<div class="space-y-1 text-sm">
			<h3 class="font-medium leading-none line-clamp-2">{title}</h3>
			{#if subtitle}
				<p class="text-xs text-muted-foreground">{subtitle}</p>
			{/if}
		</div>
	</div>
</a>
