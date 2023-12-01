<script lang="ts">
	import Menu from '$lib/components/Menu.svelte';
	import Sidebar from '$lib/components/Sidebar.svelte';
	import ViewTransition from '$lib/components/ViewTransition.svelte';
	import type { LayoutData } from './$types';

	export let data: LayoutData;
</script>

<ViewTransition />

<!-- Navigation Bar -->
<header class="fixed w-full z-30 top-0 bg-background">
	<Menu user={data.user} />
</header>

<div class="grid lg:grid-cols-5 h-full pt-14 mb-14">
	<Sidebar class="hidden lg:block" />
	<div class="col-span-4 w-full pr-8 pl-4 py-8 h-full overflow-y-auto overflow-x-hidden">
		<slot />
	</div>
</div>
