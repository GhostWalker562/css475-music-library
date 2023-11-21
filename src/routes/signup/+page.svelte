<script lang="ts">
	import { applyAction, enhance } from '$app/forms';
	import Logo from '$lib/components/Logo.svelte';
	import ShapeBackground from '$lib/components/ShapeBackground.svelte';
	import ViewTransition from '$lib/components/ViewTransition.svelte';
	import GithubIcon from '$lib/components/icons/GithubIcon.svelte';
	import { Button } from '$lib/components/ui/button';
	import * as Card from '$lib/components/ui/card';
	import Input from '$lib/components/ui/input/input.svelte';
	import { Label } from '$lib/components/ui/label';
	import { Separator } from '$lib/components/ui/separator';
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
		action="?/register"
		method="post"
	>
		<Card.Root class="max-w-xs bg-card">
			<div class="auth-header">
				<Card.Header class="flex flex-col gap-1">
					<div class="flex center mb-2 text-lg"><Logo class="w-4 h-4 mr-1" /> Skypix</div>
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
						<Input
							type="text"
							autocomplete="off"
							placeholder="Username"
							name="username"
							id="username"
							required
						/>
						{#if form?.form?.errors.username}
							<p class="text-xs text-red-600">{form.form.errors.username}</p>
						{/if}
					</div>

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
				<Card.Footer class="flex-col gap-4">
					<Button type="submit" class="w-full" isLoading={isFormSubmitting}>Create Account</Button>
					{#if form?.error}
						<p class="text-xs text-red-600">{form.error}</p>
					{/if}
					<Separator />
					<Button href="/login/github" variant="outline" class=" w-full">
						<GithubIcon class="mr-2 h-4 w-4" />
						Github
					</Button>
					<a href="/login" class="text-xs">
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
