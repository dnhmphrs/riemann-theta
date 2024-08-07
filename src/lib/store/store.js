import { writable } from 'svelte/store';

export const userType = writable(null);
export const screenType = writable(null);
export const isIframe = writable(true);
export const darkMode = writable(false);

export const lobbySelected = writable(false);
export const mouseOnLink = writable(false);

export const mousePosition = writable({ x: 0, y: 0, z: 0 });

export function persistentStore(key, startValue) {
	const storedValue = typeof window !== 'undefined' ? localStorage.getItem(key) : null;
	const initial = storedValue ? JSON.parse(storedValue) : startValue;

	const store = writable(initial);

	store.subscribe((value) => {
		if (typeof window !== 'undefined') {
			localStorage.setItem(key, JSON.stringify(value));
		}
	});

	return store;
}

export const renderer = persistentStore('renderer', 'three');
