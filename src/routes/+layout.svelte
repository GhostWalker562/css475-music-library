<script lang="ts">
	import '../app.postcss';
	import { ModeWatcher } from 'mode-watcher';
	import { dev } from '$app/environment';
	import { QueryClientProvider } from '@tanstack/svelte-query';
	import { inject } from '@vercel/analytics';
	import type { LayoutData } from './$types';

	export let data: LayoutData;

	inject({ mode: dev ? 'development' : 'production' });
</script>

<ModeWatcher />

<svelte:head>
	<!-- Primary Tags -->
	<title>Skypix - Music Library</title>
	<meta name="title" content="Skypix - Music Library" />
	<meta name="description" content="Listen, save, and share music!" />

	<!-- Twitter -->
	<meta property="twitter:title" content="Skypix - Music Library" />
	<meta property="twitter:description" content="Listen, save, and share music!" />
	<meta property="twitter:image" content="https://i.ibb.co/4ZK4Gs9/skypix-og.png" />
	<meta property="twitter:url" content="https://skypix.vercel.app" />
	<meta property="twitter:card" content="summary_large_image" />

	<!-- Facebook -->
	<meta property="og:title" content="Skypix - Music Library" />
	<meta property="og:description" content="Listen, save, and share music!" />
	<meta property="og:url" content="https://skypix.vercel.app" />
	<meta property="og:image" content="https://i.ibb.co/4ZK4Gs9/skypix-og.png" />
	<meta property="og:type" content="website" />
</svelte:head>

<QueryClientProvider client={data.queryClient}>
	<div class="h-screen overflow-y-hidden">
		<slot />
	</div>
</QueryClientProvider>
