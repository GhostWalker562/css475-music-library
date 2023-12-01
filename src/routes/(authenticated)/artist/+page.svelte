<script lang="ts">
	import ArtistItem from '$lib/components/ArtistItem.svelte';
	import DebouncedSearch from '$lib/components/DebouncedSearch.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import { Input } from '$lib/components/ui/input';
	import { fetchArtists, getFetchArtistsQueryKey } from '$lib/queries/fetchArtists';
	import { infiniteScroll } from '$lib/utils/infiniteScroll';
	import { createInfiniteQuery } from '@tanstack/svelte-query';
	import { Users } from 'lucide-svelte';
	import type { ArtistsResponse } from '../../api/artists/+server';

	let search: (e: InputEvent) => void | undefined;
	let query: string | undefined;

	$: artists = createInfiniteQuery<ArtistsResponse>({
		queryKey: getFetchArtistsQueryKey(query),
		queryFn: async ({ pageParam = 0 }) => fetchArtists(pageParam as number, query),
		getNextPageParam: ({ nextPage }: ArtistsResponse) => nextPage,
		initialPageParam: 0,
		staleTime: 4 * 60 * 1000 // 2 minutes
	});

	$: flatArtists = $artists.data?.pages.flatMap((page) => page.artists) ?? [];
</script>

<DebouncedSearch bind:search bind:query defaultRoute="/artist" />

<div class="px-2">
	<SectionHeader title="Discover Artists" subtitle="Find trending artists">
		<Input
			on:input={(e) => search?.(e)}
			type="search"
			value={query}
			placeholder="Search..."
			class="h-9 my-2 md:my-0 md:w-[300px] "
		/>
	</SectionHeader>
</div>

{#if flatArtists.length === 0}
	<div class="h-full center flex-col gap-4 py-24">
		<Users class="h-24 w-24 " />
		<h1 class="text-3xl">No Artists Found</h1>
		<p class="opacity-50">Try searching for something else</p>
	</div>
{:else}
	<div
		class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-6 pb-12"
	>
		{#each flatArtists as item}
			<ArtistItem {item} />
		{/each}
		<div
			use:infiniteScroll={{
				hasMore: $artists.hasNextPage,
				onEndReached: () => $artists.fetchNextPage()
			}}
		/>
	</div>
{/if}
