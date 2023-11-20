<script lang="ts">
	import { applyAction, enhance } from '$app/forms';
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
		action="?/sendReset"
		method="post"
	>
		<Card.Root class="max-w-xs bg-card">
			<div class="auth-header">
				<Card.Header class="space-y-1">
					<Card.Title class="text-2xl">Reset Password</Card.Title>
					<Card.Description>Enter your email below to reset your password</Card.Description>
				</Card.Header>
			</div>

			<div class="auth-content">
				<Card.Content class="flex flex-col gap-4">
					<div class="grid gap-2">
						<Label for="email">Email</Label>
						<Input
							type="text"
							autocomplete="off"
							placeholder="Email"
							name="email"
							id="email"
							required
						/>
						{#if form?.form?.errors.email}
							<p class="text-xs text-red-600">{form.form.errors.email}</p>
						{/if}
					</div>
				</Card.Content>
			</div>

			<div class="auth-footer">
				<Card.Footer class="flex-col gap-4 text-center">
					<Button type="submit" class="w-full" isLoading={isFormSubmitting}>Send Reset Link</Button>
					<Button href="/signup" class="w-full" variant="outline">Return</Button>
					{#if form?.error}
						<p class="text-xs text-red-600">{form.error}</p>
					{/if}
					{#if form?.success}
						<p class="text-xs text-green-600">{form.success}</p>
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
