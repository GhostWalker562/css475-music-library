import { Disc3, Heart, Home, Library, Search, Settings } from 'lucide-svelte';

export const categories = [
	{
		title: 'Discover',
		actions: [
			{
				title: 'Listen Now',
				icon: Home,
				href: '/'
			},
			{
				title: 'Browse',
				icon: Search,
				href: '/browse'
			},
			{
				title: 'Albums',
				icon: Library,
				href: '/album'
			}
		]
	},
	{
		title: 'Library',
		actions: [
			{
				title: 'Playlists',
				icon: Disc3,
				href: '/playlist'
			},
			{
				title: 'Likes',
				icon: Heart,
				href: '/likes'
			},
			{
				title: 'Settings',
				icon: Settings,
				href: '/settings'
			}
		]
	}
] as const;
