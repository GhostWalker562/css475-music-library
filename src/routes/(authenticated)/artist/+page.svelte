<script lang="ts">
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import ArtistItem from '$lib/components/ArtistItem.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import { Input } from '$lib/components/ui/input';
	import { fetchArtists, getFetchArtistsQueryKey } from '$lib/queries/fetchArtists';
	import { infiniteScroll } from '$lib/utils/infiniteScroll';
	import { createInfiniteQuery } from '@tanstack/svelte-query';
	import type { ArtistsResponse } from '../../api/artists/+server';

	let timeout: NodeJS.Timeout;

	const debounceSearch = (e: InputEvent, delay: number) => {
		clearTimeout(timeout);
		timeout = setTimeout(() => {
			if (!(e.target as HTMLInputElement).value) goto('/artist', { keepFocus: true });
			else goto(`?search=${(e.target as HTMLInputElement).value}`, { keepFocus: true });
		}, delay);
	};

	$: query = $page.url.searchParams.get('search') ?? undefined;

	$: artists = createInfiniteQuery<ArtistsResponse>({
		queryKey: getFetchArtistsQueryKey(query),
		queryFn: async ({ pageParam = 0 }) => fetchArtists(pageParam as number, query),
		getNextPageParam: ({ nextPage }: ArtistsResponse) => nextPage,
		initialPageParam: 0,

		staleTime: 2 * 60 * 1000 // 2 minutes
	});

	$: flatArtists = $artists.data?.pages.flatMap((page) => page.artists) ?? [];
</script>

<div class="px-2">
	<SectionHeader title="Discover Artists" subtitle="Find trending artists">
		<Input
			on:input={(e) => debounceSearch(e, 600)}
			type="search"
			value={query}
			placeholder="Search..."
			class="h-9 my-2 md:my-0 md:w-[300px] "
		/>
	</SectionHeader>
</div>

<div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-6">
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
