<script lang="ts">
	import AccountImage from '$lib/components/AccountImage.svelte';
	import BackButton from '$lib/components/BackButton.svelte';
	import CoverImage from '$lib/components/CoverImage.svelte';
	import SectionHeader from '$lib/components/SectionHeader.svelte';
	import TracksTable from '$lib/components/tables/TracksTable';
	import type { PageData } from './$types';

	export let data: PageData;
</script>

<div class="px-2 min-h-screen pb-24">
	<BackButton label="Album" defaultRoute="/album" />

	<CoverImage
		src={data.album.coverImageUrl}
		fallbackSeed={data.album.name}
		class="w-full h-72 rounded-lg border"
	/>

	<br />

	<SectionHeader title={data.album.name}>
		<div class="flex items-center gap-2">
			<div class="flex items-center gap-2">
				<span class="text-xs opacity-50"> Created by </span>
				<AccountImage
					class="h-6 w-6"
					src={data.artist.auth_user.profileImageUrl}
					alt={data.artist.auth_user.username}
				/>
				<a class="hover:underline underline-offset-4" href={`/artist/${data.artist.artist.id}`}>
					{data.artist.auth_user.username}
				</a>
			</div>
			•
			{data.tracks.length} tracks
		</div>
	</SectionHeader>

	<TracksTable
		data={data.tracks}
		userId={data.user.userId}
		showAlbum={false}
		showGoToAlbum={false}
	/>
</div>
