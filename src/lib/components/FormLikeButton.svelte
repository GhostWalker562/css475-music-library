<script lang="ts">
	import { applyAction, enhance } from '$app/forms';
	import { invalidateAll } from '$app/navigation';
	import LikeButton from '$lib/components/LikeButton.svelte';
	import type { Track } from '$lib/types/music';
	import type { ActionResult } from '@sveltejs/kit';
	import posthog from 'posthog-js';

	export let track: Track;
	export let value: boolean;

	const enhanceLikeForm = () => {
		value = !value;
		return async ({ result }: { result: ActionResult }) => {
			invalidateAll();
			if (result.type === 'success') {
				if (result.data?.isLiked === true)
					posthog.capture('Liked Song', { songName: track.song.name });
				else posthog.capture('Unliked Song', { songName: track.song.name });
			}
			await applyAction(result);
		};
	};
</script>

<form use:enhance={enhanceLikeForm} action={`/track/${track.song.id}?/toggleLike`} method="post">
	<LikeButton type="submit" {value} />
</form>
