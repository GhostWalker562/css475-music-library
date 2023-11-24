<script lang="ts">
	import { page } from '$app/stores';
	import Logo from '$lib/components/Logo.svelte';
	import Button from '$lib/components/ui/button/button.svelte';
	import * as Card from '$lib/components/ui/card';
</script>

<div class="center flex-col h-screen">
	<Card.Root class="min-w-[300px]">
		<Card.Header>
			<div class="flex center text-lg"><Logo class="w-4 h-4 mr-1" /> Skypix</div>
		</Card.Header>
		<Card.Content class="center flex-col ">
			<h2 class="font-mono">{$page.status}: {$page.error?.message}</h2>
		</Card.Content>
		<Card.Footer class="w-full">
			<Button class="w-full" href="/">Return</Button>
		</Card.Footer>
	</Card.Root>
</div>
