<script lang="ts">
	import { MoveLeft } from 'lucide-svelte';
	import { Button } from './ui/button';
	import { goto } from '$app/navigation';
	import { browser } from '$app/environment';

	export let label: string;
	export let defaultRoute: string;
</script>

<Button
	variant="link"
	class="mb-4"
	on:click={() => (history.length > 1 ? history.go(-1) : goto(defaultRoute))}
>
	<MoveLeft class="w-4 h-4 mr-2" />
	{browser && history.length > 1 ? 'Back' : label}
</Button>
