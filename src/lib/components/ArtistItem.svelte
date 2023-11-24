<script lang="ts">
	import { AspectRatio } from '$lib/components/ui/aspect-ratio';
	import type { ArtistUser } from '$lib/types/music';
	import CoverImage from './CoverImage.svelte';

	export let item: ArtistUser;
</script>

<a
	class="text-left hover:bg-muted-foreground/20 hover:scale-95 active:bg-muted-foreground/25 p-3 rounded-md transition-all"
	href={`/artist/${item.artist.id}`}
>
	<div class="border-none flex flex-col gap-3">
		<AspectRatio ratio={1} class="bg-muted rounded-md overflow-hidden">
			<CoverImage src={item.auth_user.profileImageUrl} fallbackSeed={item.auth_user.username} />
		</AspectRatio>
		<div class="space-y-1 text-sm">
			<h3 class="font-medium leading-none line-clamp-2">{item.artist.name}</h3>
		</div>
	</div>
</a>
