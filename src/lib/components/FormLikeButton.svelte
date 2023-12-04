<script lang="ts">
	import { applyAction, enhance } from '$app/forms';
	import LikeButton from '$lib/components/LikeButton.svelte';
	import type { ActionResult } from '@sveltejs/kit';

	export let trackId: string;
	export let value: boolean;

	const enhanceLikeForm = () => {
		value = !value;
		return async ({ result }: { result: ActionResult }) => await applyAction(result);
	};
</script>

<form use:enhance={enhanceLikeForm} action={`/track/${trackId}?/toggleLike`} method="post">
	<LikeButton type="submit" {value} />
</form>
