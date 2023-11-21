<script lang="ts">
	import { enhance } from '$app/forms';
	import * as Menubar from '$lib/components/ui/menubar';
	import * as Avatar from '$lib/components/ui/avatar';
	import * as Sheet from '$lib/components/ui/sheet';
	import type { User } from 'lucia';
	import { Button } from './ui/button';
	import { Menu } from 'lucide-svelte';
	import { categories } from '$lib/constants/paths';
	import { page } from '$app/stores';
	import ThemeSwitch from './ThemeSwitch.svelte';

	export let user: User;

	const isPathSelected = (path: string, currentPath: string) => {
		if (path === '/') return path === currentPath;
		return currentPath.includes(path);
	};
</script>

<div class="py-2 border-b">
	<Menubar.Root class="rounded-none border-none border-b px-2 lg:px-4 justify-between">
		<!-- Logo -->
		<Menubar.Menu>
			<a href="/"><Menubar.Item class="font-bold">Music Library</Menubar.Item></a>
		</Menubar.Menu>
		<!-- Account -->
		<Menubar.Menu>
			<div class="flex gap-0 md:gap-2">
				<!-- Theme -->
				<div class="hidden md:flex">
					<ThemeSwitch />
				</div>
				<!-- User -->
				<Menubar.Trigger class="cursor-pointer flex gap-2">
					{user.username}
					<Avatar.Root class="w-6 h-6 border ">
						<Avatar.Image src={user.profileImageUrl} alt={user.username} />
						<Avatar.Fallback>
							<img
								src={`https://api.dicebear.com/7.x/notionists/svg?seed=${user.username}`}
								alt={user.username}
							/>
						</Avatar.Fallback>
					</Avatar.Root>
				</Menubar.Trigger>
				<!-- Collapsible -->
				<Sheet.Root>
					<Sheet.Trigger class="block lg:hidden">
						<Button variant="ghost" size="icon">
							<Menu />
						</Button>
					</Sheet.Trigger>
					<Sheet.Content>
						<div class="space-y-4 py-4 text-left">
							{#each categories as category}
								<div class="md:px-3 py-2">
									<h2 class="mb-2 px-4 text-lg font-semibold tracking-tight">{category.title}</h2>
									<div class="space-y-1">
										{#each category.actions as action}
											<Sheet.Close asChild let:builder>
												<Button
													builders={[builder]}
													href={action.href}
													variant={isPathSelected(action.href, $page.url.pathname)
														? 'secondary'
														: 'ghost'}
													class="w-full justify-start"
												>
													<svelte:component this={action.icon} class="mr-2 h-4 w-4" />
													{action.title}
												</Button>
											</Sheet.Close>
										{/each}
									</div>
								</div>
							{/each}
						</div>
					</Sheet.Content>
				</Sheet.Root>
			</div>
			<Menubar.Content>
				<a href="/settings"><Menubar.Item inset>Settings</Menubar.Item> </a>
				<Menubar.Separator />
				<form action="/?/logout" method="post" use:enhance>
					<button type="submit" class="w-full">
						<Menubar.Item inset>Logout</Menubar.Item>
					</button>
				</form>
			</Menubar.Content>
		</Menubar.Menu>
	</Menubar.Root>
</div>
