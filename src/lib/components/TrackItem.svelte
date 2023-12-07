<script lang="ts">
	import type { Track } from '$lib/types/music';
	import MediaItem from './MediaItem.svelte';

	export let item: Track;
</script>

<MediaItem
	imageUrl={item.album.coverImageUrl}
	title={item.song.name}
	subtitle={item.artist.name}
	href={`/track/${item.song.id}`}
/>
