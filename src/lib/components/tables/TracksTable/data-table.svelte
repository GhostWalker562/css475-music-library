<script lang="ts">
	import * as Table from '$lib/components/ui/table';
	import type { Track } from '$lib/types/music';
	import { Render, Subscribe, createRender, createTable } from 'svelte-headless-table';
	import { addSelectedRows } from 'svelte-headless-table/plugins';
	import { writable } from 'svelte/store';
	import DataTableActions from './data-table-actions.svelte';
	import DataTableName from './data-table-name.svelte';

	export let data: Track[];
	export let userId: string;

	export let showGoToArtist = true;
	export let showGoToAlbum = true;

	export let showAlbum = true;

	export let showHeader = true;
	export let showLikeButton = true;

	const tableData = writable(data);
	$: tableData.set(data);

	const table = createTable(tableData, {
		select: addSelectedRows({
			initialSelectedDataIds: data.reduce((acc, e, i) => ({ ...acc, [i]: !!e.user_likes }), {})
		})
	});

	const columns = table.createColumns([
		table.column({
			accessor: (e) => e.song.id,
			header: '#',
			cell: ({ row }) => Number(row.id) + 1
		}),
		table.column({
			id: 'name',
			header: 'Title',
			accessor: (e) => ({
				name: e.song.name,
				imageUrl: e.album.coverImageUrl,
				previewUrl: e.song.previewUrl,
				trackId: e.song.id
			}),
			cell: ({ value }) =>
				createRender(DataTableName, {
					imageUrl: value.imageUrl,
					name: value.name,
					previewUrl: value.previewUrl,
					trackId: value.trackId
				})
		}),
		table.column({ id: 'album', accessor: (e) => e.album.name, header: 'Album' }),
		table.column({
			id: 'actions',
			accessor: (e) => ({
				trackId: e.song.id,
				albumId: e.album.id,
				artistId: e.artist.id,
				isLiked: !!e.user_likes,
				previewUrl: e.song.previewUrl
			}),
			header: '',
			cell: ({ value }) =>
				createRender(DataTableActions, {
					trackId: value.trackId,
					albumId: showGoToAlbum ? value.albumId : undefined,
					artistId: showGoToArtist ? value.artistId : undefined,
					userId,
					value: value.isLiked,
					previewUrl: value.previewUrl,
					showLikeButton
				})
		})
	]);

	const { headerRows, pageRows, tableAttrs, tableBodyAttrs } = table.createViewModel(columns);
</script>

<div class="rounded-md border">
	<Table.Root {...$tableAttrs} class="table-auto">
		{#if showHeader}
			<Table.Header>
				{#each $headerRows as headerRow}
					<Subscribe rowAttrs={headerRow.attrs()}>
						<Table.Row>
							{#each headerRow.cells as cell (cell.id)}
								<Subscribe attrs={cell.attrs()} let:attrs props={cell.props()}>
									{#if cell.id === 'album'}
										<Table.Head {...attrs} class={!showAlbum ? 'hidden' : 'hidden md:table-cell'}>
											<Render of={cell.render()} />
										</Table.Head>
									{:else}
										<Table.Head {...attrs}>
											<Render of={cell.render()} />
										</Table.Head>
									{/if}
								</Subscribe>
							{/each}
						</Table.Row>
					</Subscribe>
				{/each}
			</Table.Header>
		{/if}

		<Table.Body {...$tableBodyAttrs}>
			{#each $pageRows as row (row.id)}
				<Subscribe rowAttrs={row.attrs()} let:rowAttrs>
					<Table.Row {...rowAttrs}>
						{#each row.cells as cell (cell.id)}
							<Subscribe attrs={cell.attrs()} let:attrs>
								{#if cell.id === 'album'}
									<Table.Cell {...attrs} class={!showAlbum ? 'hidden' : 'hidden md:table-cell'}>
										<Render of={cell.render()} />
									</Table.Cell>
								{:else}
									<Table.Cell {...attrs}>
										<Render of={cell.render()} />
									</Table.Cell>
								{/if}
							</Subscribe>
						{/each}
					</Table.Row>
				</Subscribe>
			{/each}
		</Table.Body>
	</Table.Root>
</div>
