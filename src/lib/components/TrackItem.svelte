<script lang="ts">
	import { AspectRatio } from '$lib/components/ui/aspect-ratio';
	import type { Track } from '$lib/types/music';

	export let track: Track;

	const fallback = `https://source.unsplash.com/random/?${track.song.name}`;

	$: image = track.album.coverImageUrl ?? fallback;
</script>

<div class="border-none flex flex-col gap-3">
	<AspectRatio ratio={1 / 1} class="bg-muted rounded-md overflow-hidden">
		<img alt="Track Cover" src={image} class="object-cover w-full h-full" />
	</AspectRatio>
	<div class="space-y-1 text-sm">
		<h3 class="font-medium leading-none line-clamp-2">{track.song.name}</h3>
		<p class="text-xs text-muted-foreground">{track.artist.name}</p>
	</div>
</div>
