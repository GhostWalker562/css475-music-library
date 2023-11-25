export function transformCloudinaryURL(url: string): string {
	// Define a regular expression to match the specific Cloudinary URL format
	const regex =
		/^(https:\/\/res\.cloudinary\.com\/\w+\/image\/upload\/)(v\d+\/)([^/]+\/)(.+)\.jpg$/;

	// Test the URL against the regex
	const match = url.match(regex);

	// If the URL matches the regex, transform it
	if (match) {
		const [, base, , folderPath, filenameWithoutExtension] = match;
		return `${base}f_auto,q_auto/v1/${folderPath}${filenameWithoutExtension}`;
	}

	// If the URL doesn't match the expected format, return the original URL
	return url;
}
