<script lang="ts">
	import * as Table from '$lib/components/ui/table';
	import type { Playlist } from '$lib/types/music';
	import { Render, Subscribe, createRender, createTable } from 'svelte-headless-table';
	import { readable } from 'svelte/store';
	import DataTableActions from './data-table-actions.svelte';
	import DataTableName from './data-table-name.svelte';

	export let data: Playlist[];
	export let showHeader = true;

	const table = createTable(readable(data));

	const columns = table.createColumns([
		table.column({
			accessor: (e) => e.id,
			header: '#',
			cell: ({ row }) => Number(row.id) + 1
		}),
		table.column({
			id: 'name',
			header: 'Title',
			accessor: (e) => ({ name: e.name, playlistId: e.id }),
			cell: ({ value }) =>
				createRender(DataTableName, {
					name: value.name,
					playlistId: value.playlistId
				})
		}),
		table.column({
			id: 'actions',
			accessor: (e) => ({ playlistId: e.id }),
			header: '',
			cell: ({ value }) => createRender(DataTableActions, { playlistId: value.playlistId })
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
									{#if cell.id === 'name'}
										<Table.Head {...attrs} class="w-full">
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
								{#if cell.id === 'name'}
									<Table.Cell {...attrs} class="w-full">
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
