<script lang="ts">
	import { Separator } from './ui/separator';

	export let title: string;
	export let subtitle: string | undefined | null = undefined;

	export let subtitleHref: string | undefined | null = undefined;
</script>

<div class="flex flex-col sm:flex-row sm:items-center gap-2 sm:gap-0 justify-between">
	<div class="space-y-1">
		<h2 class="text-2xl font-semibold tracking-tight">{title}</h2>
		{#if subtitle && subtitleHref}
			<a href={subtitleHref} class="hover:underline">
				<p class="text-sm pointer-cursor text-muted-foreground">{subtitle}</p>
			</a>
		{:else if subtitle}
			<p class="text-sm text-muted-foreground">{subtitle}</p>
		{/if}
		<slot name="subtitle" />
	</div>
	<slot />
</div>
<Separator class="my-4" />
