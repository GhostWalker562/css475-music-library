<script lang="ts">
	import Button from '$lib/components/ui/button/button.svelte';
	import { cn } from '$lib/utils';
	import type { Events, Props } from 'bits-ui/dist/bits/button';
	import { Heart } from 'lucide-svelte';

	type $$Props = Omit<Props, 'value'> & { value?: boolean };
	type $$Events = Events;

	export let value: boolean = false;
	let className: $$Props['class'] = undefined;
	export { className as class };
</script>

<input type="hidden" name="isLiked" value={value} />
<Button
	size="icon"
	variant="ghost"
	{...$$restProps}
	class={cn(className, 'center transition-all active:scale-90')}
	on:click
	on:keydown
>
	<Heart class={cn('w-6 h-6 transition-all', value ? 'fill-red-700 text-red-700' : '')} />
</Button>
