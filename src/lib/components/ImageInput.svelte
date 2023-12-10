<script lang="ts">
	import type { UploadInfo } from '$lib/types/cloudinary';
	import { transformCloudinaryURL } from '$lib/utils/transformCloudinaryUrl';
	import { getFormField } from 'formsnap';
	import CoverImage from './CoverImage.svelte';
	import UploadButton from './UploadButton.svelte';

	const handleOnUpload = (e: CustomEvent<UploadInfo>) =>
		setValue(transformCloudinaryURL(e.detail.secure_url));

	const { attrStore, setValue, value } = getFormField();

	$: imageUrl = $value as string | undefined;
</script>

<div>
	<input
		type="hidden"
		{...$attrStore}
		bind:value={imageUrl}
		{...$$restProps}
		name="imageUrl"
		id="imageUrl"
	/>
	<UploadButton on:upload={handleOnUpload}>
		<div class="relative">
			{#if !imageUrl}
				<div class="absolute inset-0 bg-gray-100 dark:bg-card rounded-md border center">
					<span class="opacity-50"> Upload Image </span>
				</div>
			{/if}
			<CoverImage
				src={imageUrl}
				alt={'Unknown Upload'}
				class="w-36 h-36 border rounded-md"
				showFallback={false}
			/>
		</div>
	</UploadButton>
</div>
