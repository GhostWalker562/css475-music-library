<script lang="ts">
	import { cn } from '$lib/utils';
	import type { HTMLImgAttributes } from 'svelte/elements';

	type $$Props = HTMLImgAttributes & { src: string | null | undefined; fallbackSeed?: string };

	export let src: string | null | undefined;
	export let fallbackSeed: string = 'city,night';
	export let className: string | undefined | null = undefined;
	export { className as class };

	const fallback = `https://source.unsplash.com/random/?${fallbackSeed}`;

	$: image = src ?? fallback;
</script>

<img alt="Cover" src={image} class={cn('object-cover w-full h-full', className)} {...$$restProps} />
