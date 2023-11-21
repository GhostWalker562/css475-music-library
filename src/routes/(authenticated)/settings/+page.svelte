<script lang="ts">
	import { Separator } from '$lib/components/ui/separator';
	import * as Select from '$lib/components/ui/select';
	import type { PageData } from './$types';
	import Label from '$lib/components/ui/label/label.svelte';
	import { setMode, mode, resetMode } from 'mode-watcher';

	export let data: PageData;

	const mapModeToValue = (mode: 'dark' | 'light' | undefined) => {
		return !mode ? 'System' : { light: 'Light', dark: 'Dark' }[mode];
	};

	const handleOnThemeChange = (mode: any) => {
		if (mode.value === 'system') return resetMode();
		setMode(mode.value as 'dark' | 'light' | 'system');
	};
</script>

<div class="w-full pr-8 pl-4 py-8">
	<div class="space-y-0.5">
		<h2 class="text-2xl font-bold tracking-tight">Apperance</h2>
		<p class="text-muted-foreground">Customize the look of your Music Library</p>
	</div>
	<Separator class="my-6" />

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
</div>
