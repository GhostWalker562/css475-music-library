<script lang="ts">
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import TrackItem from '$lib/components/TrackItem.svelte';
	import Input from '$lib/components/ui/input/input.svelte';
	import { fetchTracks, getFetchTracksQueryKey } from '$lib/queries/fetchTracks';
	import { infiniteScroll } from '$lib/utils/infiniteScroll';
	import { createInfiniteQuery } from '@tanstack/svelte-query';
	import type { TracksResponse } from '../../api/tracks/+server';

	let timeout: NodeJS.Timeout;

	const debounceSearch = (e: InputEvent, delay: number) => {
		clearTimeout(timeout);
		timeout = setTimeout(() => {
			if (!(e.target as HTMLInputElement).value) goto('/browse', { keepFocus: true });
			else goto(`?search=${(e.target as HTMLInputElement).value}`, { keepFocus: true });
		}, delay);
	};

	$: query = $page.url.searchParams.get('search') ?? undefined;

	$: tracks = createInfiniteQuery<TracksResponse>({
		queryKey: getFetchTracksQueryKey(query),
		queryFn: async ({ pageParam = 0 }) => fetchTracks(pageParam as number, query),
		getNextPageParam: ({ nextPage }: TracksResponse) => nextPage,
		initialPageParam: 0,
		staleTime: 4 * 60 * 1000 // 4 minutes
	});

	$: flatTracks = $tracks.data?.pages.flatMap((page) => page.tracks) ?? [];
</script>

<div class="px-2">
	<SectionHeader title="All Songs" subtitle="Check out all the songs in our library">
		<Input
			on:input={(e) => debounceSearch(e, 600)}
			type="search"
			value={query}
			placeholder="Search..."
			class="h-9 my-2 md:my-0 md:w-[300px] "
		/>
	</SectionHeader>
</div>
<div
	class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-6 pb-12"
>
	{#each flatTracks as track}
		<TrackItem  {track} />
	{/each}
	<div
		use:infiniteScroll={{
			hasMore: $tracks.hasNextPage,
			onEndReached: () => $tracks.fetchNextPage()
		}}
	/>
</div>
