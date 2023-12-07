<script lang="ts">
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import type { PageData } from './$types';

	export let data: PageData;
	const user = data.user;
</script>

<div class="px-2">
	<SectionHeader title="Discover Album" subtitle="Find trending albums" />
</div>
