<script lang="ts">
	import { Separator } from './ui/separator';

	export let title: string;
	export let subtitle: string;
</script>

<div class="flex items-center justify-between">
	<div class="space-y-1">
		<h2 class="text-2xl font-semibold tracking-tight">{title}</h2>
		<p class="text-sm text-muted-foreground">{subtitle}</p>
	</div>
	<slot />
</div>
<Separator class="my-4" />
