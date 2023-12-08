<script lang="ts">
	import AccountImage from '$lib/components/AccountImage.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import TracksTable from '$lib/components/tables/TracksTable';
	import type { PageData } from './$types';

	export let data: PageData;
</script>

<div class="px-2 min-h-screen pb-24">
	<SectionHeader title={data.playlist.name}>
		<div class="flex items-center gap-2">
			<div class="flex items-center gap-2">
				<span class="text-xs opacity-50"> Created by </span>
				<AccountImage
					class="h-6 w-6"
					src={data.creator.profileImageUrl}
					alt={data.creator.username}
				/>
				<span>
					{data.creator.username}
				</span>
			</div>
			•
			{data.tracks.length} tracks
		</div>
	</SectionHeader>

	<TracksTable data={data.tracks} userId={data.user.userId} />
</div>
