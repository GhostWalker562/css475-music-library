<script lang="ts">
	import { applyAction, enhance } from '$app/forms';
	import { invalidateAll } from '$app/navigation';
	import AccountImage from '$lib/components/AccountImage.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import UploadButton from '$lib/components/UploadButton.svelte';
	import Button from '$lib/components/ui/button/button.svelte';
	import Input from '$lib/components/ui/input/input.svelte';
	import Label from '$lib/components/ui/label/label.svelte';
	import * as Select from '$lib/components/ui/select';
	import type { UploadInfo } from '$lib/types/cloudinary';
	import { mapModeToValue } from '$lib/utils/theme';
	import { transformCloudinaryURL } from '$lib/utils/transformCloudinaryUrl';
	import { mode, resetMode, setMode } from 'mode-watcher';
	import type { ActionData, PageData } from './$types';
	import { ArrowUpRight } from 'lucide-svelte';

	export let data: PageData;
	const user = data.user;

	export let form: ActionData;

	// State

	let profileImageUrl = user.profileImageUrl;
	let isFormSubmitting = false;
	let recentlySubmitted = false;

	// Actions

	const handleOnThemeChange = (mode: any) => {
		if (mode.value === 'system') return resetMode();
		setMode(mode.value as 'dark' | 'light' | 'system');
	};

	const handleOnUpload = (e: CustomEvent<UploadInfo>) =>
		(profileImageUrl = transformCloudinaryURL(e.detail.secure_url));

	// Effects

	$: {
		if (recentlySubmitted) {
			setTimeout(() => {
				recentlySubmitted = false;
			}, 2000);
		}
	}
</script>

<div class="px-2">
	<SectionHeader title="Profile" subtitle="Edit your profile" />
	<form
		class="grid max-w-lg"
		use:enhance={() => {
			isFormSubmitting = true;
			return async ({ result }) => {
				await applyAction(result);
				isFormSubmitting = false;
				recentlySubmitted = true;
				invalidateAll();
			};
		}}
		action="?/saveProfile"
		method="post"
	>
		<div class="grid gap-8 pt-6 pb-8">
			<div class="grid gap-2">
				<Label for="avatar" class="block">Profile Picture</Label>
				<input type="hidden" bind:value={profileImageUrl} name="avatar" id="avatar" />
				<UploadButton on:upload={handleOnUpload}>
					<AccountImage src={profileImageUrl} alt={user.username} class="w-36 h-36 border" />
				</UploadButton>
			</div>

			<div class="grid gap-2">
				<Label for="username">Username</Label>
				<Input
					type="text"
					autocomplete="off"
					value={data.user.username}
					name="username"
					id="username"
					required
				/>
				{#if form?.form?.errors.username}
					<p class="text-xs text-red-600">{form.form.errors.username}</p>
				{/if}
				<p class="text-xs text-muted-foreground">
					This is the name that will be displayed on your profile
				</p>
			</div>
		</div>
		<Button type="submit" class="max-w-fit" size="lg" isLoading={isFormSubmitting}>
			{recentlySubmitted ? 'Saved!' : 'Update Profile'}
		</Button>
	</form>

	<br />
	<br />

	<SectionHeader title="Apperance" subtitle="Choose a theme for your music library" />
	<div class="flex flex-col gap-2">
		<Label for="theme">Theme</Label>
		<Select.Root onSelectedChange={handleOnThemeChange}>
			<Select.Trigger id="theme" class="w-[180px]">
				<Select.Value placeholder={mapModeToValue($mode)} />
			</Select.Trigger>
			<Select.Content>
				<Select.Item value="light">Light</Select.Item>
				<Select.Item value="dark">Dark</Select.Item>
				<Select.Item value="system">System</Select.Item>
			</Select.Content>
		</Select.Root>
	</div>

	<br />
	<br />

	<SectionHeader title="Artist" subtitle="Manage your artist profile" />
	<div class="flex flex-col gap-2">
		<Label for="theme">Go to Profile</Label>
		<Button class="w-fit" variant="secondary" href="/settings/artist">
			Artist Profile
			<ArrowUpRight class="w-4 h-4 ml-1" />
		</Button>
	</div>
</div>
