<script lang="ts">
	import { Button as ButtonPrimitive } from 'bits-ui';
	import Spinner from '$lib/components/Spinner.svelte';
	import { cn } from '$lib/utils';
	import { buttonVariants, type Props, type Events } from '.';

	type $$Props = Props & { loadingProps?: Spinner['$$prop_def'] };
	type $$Events = Events;

	let className: $$Props['class'] = undefined;
	export let variant: $$Props['variant'] = 'default';
	export let size: $$Props['size'] = 'default';
	export let builders: $$Props['builders'] = [];
	export let isLoading: $$Props['isLoading'] = false;
	export let loadingProps: $$Props['loadingProps'] = {};
	export { className as class };
</script>

<ButtonPrimitive.Root
	{builders}
	class={cn(buttonVariants({ variant, size, className }))}
	type="button"
	{...$$restProps}
	disabled={$$restProps.disabled || isLoading}
	on:click
	on:keydown
>
	{#if isLoading}
		<Spinner size="6" {...loadingProps} />
	{:else}
		<slot />
	{/if}
</ButtonPrimitive.Root>
