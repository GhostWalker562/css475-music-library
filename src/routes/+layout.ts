import type { LayoutLoad } from './$types';
import { browser } from '$app/environment';
import { QueryClient } from '@tanstack/svelte-query';
import { createSyncStoragePersister } from '@tanstack/query-sync-storage-persister';
import { persistQueryClient } from '@tanstack/query-persist-client-core';

export const load = (async () => {
	const queryClient = new QueryClient({
		defaultOptions: {
			queries: {
				gcTime: 1_000 * 60 * 60 * 24, // 24 hours,
				enabled: browser
			}
		}
	});

	if (browser) {
		const persister = createSyncStoragePersister({
			storage: window.localStorage
		});
		persistQueryClient({ queryClient, persister });
	}

	return { queryClient };
}) satisfies LayoutLoad;
