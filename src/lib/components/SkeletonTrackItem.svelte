<script>
	import { AspectRatio } from './ui/aspect-ratio';
	import { Skeleton } from './ui/skeleton';
</script>

<div class="border-none flex flex-col gap-3">
	<AspectRatio ratio={1} class="rounded-md overflow-hidden">
		<Skeleton class="w-full h-full" />
	</AspectRatio>
	<div class="space-y-1 text-sm">
		<Skeleton class="w-full h-3" />
		<Skeleton class="w-1/3 h-3" />
	</div>
</div>
