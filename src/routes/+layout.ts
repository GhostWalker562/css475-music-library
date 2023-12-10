import type { LayoutLoad } from './$types';
import { browser } from '$app/environment';
import { QueryClient } from '@tanstack/svelte-query';
import posthog from 'posthog-js';
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

		posthog.init('phc_7q3HlnonTBD8lFw5NxNEc6PxNqTF9abcPeB6MpK8isv', {
			api_host: 'https://app.posthog.com',
			capture_pageview: false,
			capture_pageleave: false
		});
	}

	return { queryClient };
}) satisfies LayoutLoad;
