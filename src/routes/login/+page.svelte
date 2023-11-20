<script lang="ts">
	import { applyAction, enhance } from '$app/forms';
	import ViewTransition from '$lib/components/ViewTransition.svelte';
	import GithubIcon from '$lib/components/icons/GithubIcon.svelte';

	import { Button } from '$lib/components/ui/button';
	import * as Card from '$lib/components/ui/card';
	import { Input } from '$lib/components/ui/input';
	import { Label } from '$lib/components/ui/label';
	import Separator from '$lib/components/ui/separator/separator.svelte';
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
		action="?/login"
		method="post"
	>
		<Card.Root class="max-w-xs">
			<div class="auth-header">
				<Card.Header class="space-y-1">
					<Card.Title class="text-2xl">Login</Card.Title>
					<Card.Description
						>Enter your email and password to login to your account
					</Card.Description>
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
						<a href="/password-reset" class=" text-xs"
							><span class="opacity-50"> Forgot your password? </span>
							<span class="text-blue-600"> Reset it</span>
						</a>
						{#if form?.form?.errors.password}
							<p class="text-xs text-red-600">{form.form.errors.password}</p>
						{/if}
					</div>
				</Card.Content>
			</div>

			<div class="auth-footer">
				<Card.Footer class="flex-col gap-4">
					<Button type="submit" class="w-full" isLoading={isFormSubmitting}>Login</Button>
					{#if form?.error}
						<p class="text-xs text-red-600">{form.error}</p>
					{/if}
					<Separator />
					<Button href="/login/github" variant="outline" class=" w-full">
						<GithubIcon class="mr-2 h-4 w-4" />
						Github
					</Button>
					<a class="text-xs" href="/signup">
						Don't have an account? <span class=" text-blue-600">Sign Up</span>
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
