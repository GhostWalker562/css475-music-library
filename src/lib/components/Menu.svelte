<script lang="ts">
	import { enhance } from '$app/forms';
	import * as Menubar from '$lib/components/ui/menubar';
	import * as Avatar from '$lib/components/ui/avatar';
	import type { User } from 'lucia';

	export let user: User;
</script>

<div class="py-2 border-b">
	<Menubar.Root class="rounded-none border-none border-b px-2 lg:px-4 justify-between">
		<!-- Logo -->
		<Menubar.Menu>
			<Menubar.Item class="font-bold">Music Library</Menubar.Item>
		</Menubar.Menu>
		<!-- Account -->
		<Menubar.Menu>
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

			<Menubar.Content>
				<Menubar.Item inset>Settings</Menubar.Item>
				<Menubar.Separator />
				<form action="?/logout" method="post" use:enhance>
					<button type="submit" class="w-full">
						<Menubar.Item inset>Logout</Menubar.Item>
					</button>
				</form>
			</Menubar.Content>
		</Menubar.Menu>
	</Menubar.Root>
</div>
