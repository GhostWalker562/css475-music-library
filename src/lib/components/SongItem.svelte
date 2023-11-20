<script lang="ts">
	import { AspectRatio } from '$lib/components/ui/aspect-ratio';
	import { Separator } from '$lib/components/ui/separator';
	import type { SongWithArtist } from '$lib/types/music';

	export let item: SongWithArtist;
</script>

<div class="border-none flex flex-col gap-3">
	<AspectRatio ratio={1 / 1} class="bg-muted rounded-md overflow-hidden">
		<img
			alt="Song Cover"
			src={`https://source.unsplash.com/random/?${item.song.name}`}
			class="object-cover w-full h-full"
		/>
	</AspectRatio>
	<div class="space-y-1 text-sm">
		<h3 class="font-medium leading-none line-clamp-2">{item.song.name}</h3>
		<p class="text-xs text-muted-foreground">{item.artist.name}</p>
	</div>
</div>
