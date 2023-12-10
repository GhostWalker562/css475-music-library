<script lang="ts">
	import { page } from '$app/stores';
	import Menu from '$lib/components/Menu.svelte';
	import Sidebar from '$lib/components/Sidebar.svelte';
	import ViewTransition from '$lib/components/ViewTransition.svelte';
	import posthog from 'posthog-js';
	import type { LayoutData } from './$types';
	import { onMount } from 'svelte';

	export let data: LayoutData;

	onMount(() => {
		if ($page.url.searchParams.get('signedIn') === 'True' && data.user) {
			posthog.identify(data.user.userId, { username: data.user.username, email: data.user.email });
		}
	});
</script>

<ViewTransition />

<!-- Navigation Bar -->
<header class="fixed w-full z-30 top-0 bg-background">
	<Menu user={data.user} />
</header>

<div class="grid lg:grid-cols-5 xl:grid-cols-7 h-full pt-14 mb-14">
	<Sidebar class="hidden lg:block" />
	<div
		class="lg:col-span-4 xl:col-span-6 w-full pr-8 pl-4 py-8 h-full overflow-y-auto overflow-x-hidden"
	>
		<slot />
	</div>
</div>
