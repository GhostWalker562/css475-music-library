<script lang="ts">
	import AlbumItem from '$lib/components/AlbumItem.svelte';
	import DebouncedSearch from '$lib/components/DebouncedSearch.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import SkeletonMediaItem from '$lib/components/SkeletonMediaItem.svelte';
	import Input from '$lib/components/ui/input/input.svelte';
	import { fetchAlbums, getFetchAlbumsQueryKey } from '$lib/queries/fetchAlbums';
	import { infiniteScroll } from '$lib/utils/infiniteScroll';
	import { createInfiniteQuery } from '@tanstack/svelte-query';
	import { Music } from 'lucide-svelte';
	import type { AlbumsResponse } from '../../api/albums/+server';

	let search: (e: InputEvent) => void | undefined;
	let query: string | undefined;

	$: albums = createInfiniteQuery<AlbumsResponse>({
		queryKey: getFetchAlbumsQueryKey(query),
		queryFn: async ({ pageParam = 0 }) => fetchAlbums(pageParam as number, query),
		getNextPageParam: ({ nextPage }: AlbumsResponse) => nextPage,
		initialPageParam: 0,
		staleTime: 4 * 60 * 1000 // 4 minutes
	});

	$: flatAlbums = $albums.data?.pages.flatMap((page) => page.albums) ?? [];
</script>

<DebouncedSearch bind:search bind:query defaultRoute="/album" />

<div class="px-2">
	<SectionHeader title="Discover Albums" subtitle="Find trending albums">
		<Input
			on:input={(e) => search(e)}
			value={query}
			type="search"
			placeholder="Search..."
			class="h-9 my-2 md:my-0 md:w-[300px] "
		/>
	</SectionHeader>
</div>

{#if $albums.isLoading}
	<div
		class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-6 pb-12"
	>
		{#each new Array(15) as _}
			<SkeletonMediaItem />
		{/each}
	</div>
{:else if flatAlbums.length === 0}
	<div class="h-full center flex-col gap-4 py-24">
		<Music class="h-24 w-24 " />
		<h1 class="text-3xl">No Albums Found</h1>
		<p class="opacity-50">Try searching for something else</p>
	</div>
{:else}
	<div
		class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-6 pb-12"
	>
		{#each flatAlbums as album}
			<AlbumItem item={album} />
		{/each}
		<div
			use:infiniteScroll={{
				hasMore: $albums.hasNextPage,
				onEndReached: () => $albums.fetchNextPage()
			}}
		/>
	</div>
{/if}
