<script lang="ts">
	import Button from '$ui/button/button.svelte';

	export let name: string;
	export let href: string;
</script>

<Button {href} variant="link" class="-translate-x-4">
	{name}
</Button>
