<script lang="ts">
	import { applyAction, enhance } from '$app/forms';
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

<div class="w-full h-screen center">
	<form
		use:enhance={() => {
			isFormSubmitting = true;
			return async ({ result }) => {
				await applyAction(result);
				isFormSubmitting = false;
			};
		}}
		action="?/register"
		method="post"
	>
		<Card.Root class="max-w-xs">
			<div class="auth-header">
				<Card.Header class="space-y-1">
					<Card.Title class="text-2xl">Create an account</Card.Title>
					<Card.Description>
						Enter your username and email below to create your account
					</Card.Description>
				</Card.Header>
			</div>

			<div class="auth-content">
				<Card.Content class="flex flex-col gap-4">
					<div class="grid gap-2">
						<Label for="username">Username</Label>
						<Input type="text" autocomplete="off" placeholder="Username" name="username" required />
						{#if form?.form?.errors.username}
							<p class="text-xs text-red-600">{form.form.errors.username}</p>
						{/if}
					</div>

					<div class="grid gap-2">
						<Label for="email">Email</Label>
						<Input type="text" autocomplete="off" placeholder="Email" name="email" required />
						{#if form?.form?.errors.email}
							<p class="text-xs text-red-600">{form.form.errors.email}</p>
						{/if}
					</div>

					<div class="grid gap-2">
						<Label for="password">Password</Label>
						<Input
							type="password"
							autocomplete="off"
							placeholder="Password"
							name="password"
							required
						/>
						{#if form?.form?.errors.password}
							<p class="text-xs text-red-600">{form.form.errors.password}</p>
						{/if}
					</div>
				</Card.Content>
			</div>

			<div class="auth-footer">
				<Card.Footer class="flex-col">
					<Button type="submit" class="w-full" isLoading={isFormSubmitting}>Create Account</Button>
					{#if form?.error}
						<p class="pt-4 text-xs text-red-600">{form.error}</p>
					{/if}
					<a href="/login" class="pt-4 text-xs">
						Already have an account? <span class=" text-blue-600">Login</span>
					</a>
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
