<script lang="ts">
	import { createQuery } from '@tanstack/svelte-query';
	import * as Card from './ui/card';
	import type { ArtistResponse } from '../../routes/api/artists/[id]/+server';
	import AccountImage from './AccountImage.svelte';
	import Shape3 from './shapes/Shape3.svelte';
	import Shape2 from './shapes/Shape2.svelte';
	import Shape1 from './shapes/Shape1.svelte';
	import Button from './ui/button/button.svelte';
	import { ArrowUpRight } from 'lucide-svelte';
	import Skeleton from './ui/skeleton/skeleton.svelte';

	export let artistId: string;

	const artist = createQuery({
		queryKey: ['artist', artistId],
		queryFn: async () => {
			const res = await fetch(`/api/artists/${artistId}`);
			return (await res.json()) as ArtistResponse;
		},
		staleTime: 1000 * 60 * 60 * 24
	});

	$: artistUser = $artist.data?.artist;
</script>

<Card.Root class="flex p-4 gap-4 md:col-span-2 relative overflow-clip bg-card">
	<Shape2 class="absolute -left-10 -top-5 w-24 h-24 opacity-20 pointer-events-none" />
	<Shape1 class="absolute left-1/2 -bottom-10 w-24 h-24 opacity-20 pointer-events-none" />
	<Shape3 class="absolute -right-10 -top-5 w-24 h-24 opacity-20 pointer-events-none" />

	{#if artistUser}
		<AccountImage
			class="h-36 w-36 rounded-md"
			src={artistUser.auth_user.profileImageUrl}
			alt={artistUser.auth_user.username}
		/>
		<div class="flex flex-col justify-between gap-2">
			<div>
				<h1 class="text-lg font-bold">{artistUser.artist.name}</h1>
				<p class="text-sm text-foreground/80 line-clamp-3">{artistUser.artist.bio}</p>
			</div>
			<Button variant="outline" class="w-fit" href={`/artist/${artistUser.artist.id}`}>
				View Artist
				<ArrowUpRight class="ml-2 w-4 h-4" />
			</Button>
		</div>
	{:else}
		<Skeleton class="h-36 w-36 rounded-md" />
		<div class="flex flex-col justify-between gap-2">
			<div class="grid gap-2">
				<Skeleton class="h-6 w-36 rounded-md" />
				<Skeleton class="h-12 w-72 rounded-md" />
			</div>
			<Skeleton class="h-10 w-36 rounded-md" />
		</div>
	{/if}
</Card.Root>
