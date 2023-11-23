export const mapModeToValue = (mode: 'dark' | 'light' | undefined) => {
	return !mode ? 'System' : { light: 'Light', dark: 'Dark' }[mode];
};
