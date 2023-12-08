<script lang="ts">
	import type { AlbumArtist } from '$lib/types/music';
	import MediaItem from './MediaItem.svelte';

	export let item: AlbumArtist;
</script>

<MediaItem
	imageUrl={item.album.coverImageUrl}
	title={item.album.name}
	subtitle={item.artist.name}
	href={`/album/${item.album.id}`}
/>
