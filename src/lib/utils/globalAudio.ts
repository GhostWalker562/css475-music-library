import { writable } from 'svelte/store';

export const currentAudioPlayer = writable<HTMLAudioElement>();
