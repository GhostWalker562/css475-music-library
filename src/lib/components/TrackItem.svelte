<script lang="ts">
	import { AspectRatio } from '$lib/components/ui/aspect-ratio';
	import type { Track } from '$lib/types/music';
	import CoverImage from './CoverImage.svelte';

	export let track: Track;
</script>

<a
	class="text-left hover:bg-muted-foreground/20 hover:scale-95 active:bg-muted-foreground/25 p-3 rounded-md transition-all"
	href={`/track/${track.song.id}`}
>
	<div class="border-none flex flex-col gap-3">
		<AspectRatio ratio={1 / 1} class="bg-muted rounded-md overflow-hidden">
			<CoverImage src={track.album.coverImageUrl} fallbackSeed={track.song.name} />
		</AspectRatio>
		<div class="space-y-1 text-sm">
			<h3 class="font-medium leading-none line-clamp-2">{track.song.name}</h3>
			<p class="text-xs text-muted-foreground">{track.artist.name}</p>
		</div>
	</div>
</a>
