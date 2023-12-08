<script lang="ts">
	import * as Avatar from '$lib/components/ui/avatar';
	import { cn } from '$lib/utils';

	export let className: string | undefined | null = undefined;
	export let src: string | undefined | null;
	export let alt: string;
	export { className as class };
</script>

<Avatar.Root class={cn('w-6 h-6 border ', className)}>
	<Avatar.Image {src} {alt} class="object-cover" />
	<Avatar.Fallback>
		<img src={`https://api.dicebear.com/7.x/notionists/svg?seed=${alt}`} {alt} />
	</Avatar.Fallback>
</Avatar.Root>
