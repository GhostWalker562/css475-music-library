<script lang="ts">
	import { env } from '$env/dynamic/public';
	import { createEventDispatcher, onMount } from 'svelte';
	import type { ButtonEventHandler } from 'bits-ui/dist/bits/button';
	import type { UploadInfo } from '$lib/types/cloudinary';
	import { cn } from '$lib/utils';

	const dispatch = createEventDispatcher<{ upload: UploadInfo }>();

	export let className: string | undefined | null = undefined;
	export { className as class };

	let widget: any;

	onMount(() => {
		if ('cloudinary' in window) {
			widget = window.cloudinary.createUploadWidget(
				{
					cloudName: env.PUBLIC_CLOUDINARY_CLOUD_NAME,
					uploadPreset: env.PUBLIC_CLOUDINARY_UPLOAD_PRESET
				},
				(error: any, result: any) => {
					if (!error && result && result.event === 'success') {
						dispatch('upload', result.info as UploadInfo);
					}
				}
			);
		}
	});

	const handleUpload = (e: ButtonEventHandler<MouseEvent>) => {
		e.preventDefault();
		if (widget) widget.open();
	};
</script>

<button on:click={handleUpload} class={cn('w-fit', className)}><slot /></button>
