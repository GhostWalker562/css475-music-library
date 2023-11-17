<script>
	import ViewTransition from '$lib/components/ViewTransition.svelte';
	import '../app.postcss';
	import { ModeWatcher } from 'mode-watcher';
</script>

<ModeWatcher />

<div class="min-h-screen">
	<slot />
</div>
