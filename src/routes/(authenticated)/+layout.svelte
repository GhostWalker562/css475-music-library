<script lang="ts">
	import Menu from '$lib/components/Menu.svelte';
	import Sidebar from '$lib/components/Sidebar.svelte';
	import ViewTransition from '$lib/components/ViewTransition.svelte';
	import type { LayoutData } from './$types';

	export let data: LayoutData;
</script>

<ViewTransition />

<div class="h-screen overflow-y-hidden">
	<!-- Navigation Bar -->
	<Menu user={data.user} />

	<div class="grid lg:grid-cols-5 h-full">
		<Sidebar class="hidden lg:block" />
		<div class="col-span-4 w-full pr-8 pl-4 py-8 h-full overflow-y-auto overflow-x-hidden">
			<slot />
		</div>
	</div>
</div>
