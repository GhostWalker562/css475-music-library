<script lang="ts">
	import { cn } from '$lib/utils';
	import { Button } from '$lib/components/ui/button';
	import { page } from '$app/stores';
	import { categories } from '$lib/constants/paths';

	let className: string | null | undefined = undefined;
	export { className as class };

	const isPathSelected = (path: string, currentPath: string) => {
		if (path === '/') return path === currentPath;
		return currentPath.includes(path);
	};
</script>

<div class={cn('pb-12', className)}>
	<div class="space-y-4 py-4">
		{#each categories as category}
			<div class="px-3 py-2">
				<h2 class="mb-2 px-4 text-lg font-semibold tracking-tight">{category.title}</h2>
				<div class="space-y-1">
					{#each category.actions as action}
						<Button
							href={action.href}
							variant={isPathSelected(action.href, $page.url.pathname) ? 'secondary' : 'ghost'}
							class="w-full justify-start"
						>
							<svelte:component this={action.icon} class="mr-2 h-4 w-4" />
							{action.title}
						</Button>
					{/each}
				</div>
			</div>
		{/each}
	</div>
</div>
