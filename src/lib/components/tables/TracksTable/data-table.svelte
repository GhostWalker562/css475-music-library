<script lang="ts">
	import FormLikeButton from '$lib/components/FormLikeButton.svelte';
	import * as Table from '$lib/components/ui/table';
	import type { Track } from '$lib/types/music';
	import { Render, Subscribe, createRender, createTable } from 'svelte-headless-table';
	import { addSelectedRows } from 'svelte-headless-table/plugins';
	import { get, readable } from 'svelte/store';
	import DataTableName from './data-table-name.svelte';
	import DataTableActions from './data-table-actions.svelte';
	import { browser } from '$app/environment';
	import { cn } from '$lib/utils';

	export let data: Track[];
	export let showHeader = true;

	const table = createTable(readable(data), {
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
		table.column({ id: 'hidden', accessor: (e) => e.album.name, header: 'Album' }),
		table.column({
			id: 'actions',
			accessor: (e) => ({
				trackId: e.song.id,
				isLiked: !!e.user_likes,
				previewUrl: e.song.previewUrl
			}),
			header: '',
			cell: ({ value }) =>
				createRender(DataTableActions, {
					trackId: value.trackId,
					value: value.isLiked,
					previewUrl: value.previewUrl
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
									{#if cell.id === 'hidden'}
										<Table.Head {...attrs} class="hidden md:table-cell">
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
								{#if cell.id === 'hidden'}
									<Table.Cell {...attrs} class="hidden md:table-cell">
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
