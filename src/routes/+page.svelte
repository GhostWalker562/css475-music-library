<script lang="ts">
	import Menu from '$lib/components/Menu.svelte';
	import ViewTransition from '$lib/components/ViewTransition.svelte';
	import type { PageData } from './$types';

	export let data: PageData;
</script>

<ViewTransition />

<!-- Navigation Bar -->
<Menu user={data.user} />

<h1 class="my-4 font-semibold">Logged in!</h1>
