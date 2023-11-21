<script lang="ts">
	import { applyAction, enhance } from '$app/forms';
	import Logo from '$lib/components/Logo.svelte';
	import ShapeBackground from '$lib/components/ShapeBackground.svelte';
	import ViewTransition from '$lib/components/ViewTransition.svelte';
	import { Button } from '$lib/components/ui/button';
	import * as Card from '$lib/components/ui/card';
	import Input from '$lib/components/ui/input/input.svelte';
	import { Label } from '$lib/components/ui/label';
	import type { ActionData } from './$types';

	export let form: ActionData;

	let isFormSubmitting = false;
</script>

<ViewTransition />

<div class="w-full h-screen relative center">
	<ShapeBackground />

	<form
		use:enhance={() => {
			isFormSubmitting = true;
			return async ({ result }) => {
				await applyAction(result);
				isFormSubmitting = false;
			};
		}}
		action="?/reset"
		method="post"
	>
		<Card.Root class="max-w-xs bg-card min-w-[320px]">
			<div class="auth-header">
				<Card.Header class="flex flex-col gap-1">
					<div class="flex center mb-2 text-lg"><Logo class="w-4 h-4 mr-1" /> Skypix</div>
					<Card.Title class="text-2xl">Reset Password</Card.Title>
					<Card.Description>Enter a new password</Card.Description>
				</Card.Header>
			</div>

			<div class="auth-content">
				<Card.Content class="flex flex-col gap-4">
					<div class="grid gap-2">
						<Label for="password">Password</Label>
						<Input
							type="password"
							autocomplete="off"
							placeholder="Password"
							name="password"
							id="password"
							required
						/>
						{#if form?.form?.errors.password}
							<p class="text-xs text-red-600">{form.form.errors.password}</p>
						{/if}
					</div>
				</Card.Content>
			</div>

			<div class="auth-footer">
				<Card.Footer class="flex flex-col gap-4">
					<Button type="submit" isLoading={isFormSubmitting} class="w-full">Reset Password</Button>
					<Button href="/signup" class="w-full" variant="outline">Return</Button>
					{#if form?.error}
						<p class="text-xs text-red-600">{form.error}</p>
					{/if}
				</Card.Footer>
			</div>
		</Card.Root>
	</form>
</div>

<style>
	.auth-header {
		view-transition-name: auth-header;
	}

	.auth-content {
		view-transition-name: auth-buttons;
	}

	.auth-footer {
		view-transition-name: auth-footer;
	}
</style>
