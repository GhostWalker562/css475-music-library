<script lang="ts">
	import { applyAction, enhance } from '$app/forms';
	import Button from '$ui/button/button.svelte';
	import { getContext } from 'svelte';

	export let action: string;
	export let label: string;
	export let warning: string;
	export let isDeleting = false;
	export let closeDialog = false;

	let confirmingDeletion = false;

	const dialog = getContext('dialog');
	$: isDialogOpen = (dialog as any)?.states?.open;
</script>

<form
	{action}
	method="POST"
	use:enhance={() => {
		isDeleting = true;
		return async ({ result }) => {
			if (closeDialog) $isDialogOpen = false;
			await applyAction(result);
		};
	}}
>
	{#if confirmingDeletion}
		<Button variant="destructive" type="submit" isLoading={isDeleting}>Confirm Delete</Button>
		<Button
			variant="secondary"
			type="button"
			isLoading={isDeleting}
			class={isDeleting ? 'hidden' : ''}
			on:click={() => (confirmingDeletion = false)}
		>
			Cancel
		</Button>
		<p class="text-xs my-4 text-red-500">
			{warning}
		</p>
	{:else}
		<Button variant="destructive" type="button" on:click={() => (confirmingDeletion = true)}>
			{label}
		</Button>
	{/if}
</form>
