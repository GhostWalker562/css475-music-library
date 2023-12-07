<script lang="ts">
	import type { ArtistUser } from '$lib/types/music';
	import MediaItem from './MediaItem.svelte';

	export let item: ArtistUser;
</script>

<MediaItem
	imageUrl={item.auth_user.profileImageUrl}
	title={item.artist.name}
	href={`/artist/${item.artist.id}`}
/>
