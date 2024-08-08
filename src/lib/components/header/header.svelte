<script>
	import Nav from './nav.svelte';
	import Matrix from './matrix.svelte';
	// import { darkMode, screenType } from '$lib/store/store';

	// import { page } from '$app/stores';
	// import { goto } from '$app/navigation';

	// stub data out
	const navItems = [
		{
			name: 'Riemann Theta - Real Part (N=2)',
			href: '/'
		},
		{
			name: 'KP Equation (N=2)',
			href: '/kp-equation'
		},
		// {
		// 	name: 'Siegel Upper Half Space (N=2)',
		// 	href: '/siegel-upper-half-space'
		// },
		{
			name: 'Tangent Lattice (N=1)',
			href: '/tangent-lattice'
		},
	];

	// let toggleDarkMode = () => {
	// 	darkMode.set(!$darkMode);
	// 	document.querySelector(':root').classList.toggle('dark-mode');
	// 	};
</script>

<header>
	<main>

		<div></div>
		<Matrix />
		<Nav {navItems} />

	<!-- <div on:click={() => toggleDarkMode()} on:keydown={() => toggleDarkMode()} class="darkMode right">
		<p class:selected={$darkMode == false}>ONLINE</p>
		<p class="selected">/</p>
		<p class:selected={$darkMode == true}>OFFLINE</p>
	</div> -->

	<!-- <div class="icons">
    <a href="/dan_humphries_cv.pdf">
        <img src="/icons/cv.svg" alt="cv" class="icon" />
    </a>
    <a href="mailto: dan@aufbau.io">
        <img src="/icons/mail.svg" alt="mail" class="icon" />
    </a>
    <a href="https://www.instagram.com/dn.niels" target="_blank" rel="noreferrer">
        <img src="/icons/insta.svg" alt="instagram" class="icon" />
    </a>
	</div> -->

</main>
</header>

<style>
	header {
		user-select: none;
		color: var(--primary);
	}

	main {
		margin: auto;
		max-width: 100vw;
		display: flex;
		flex-flow: row nowrap;
		justify-content: space-between;

		padding: 20px;
		font-size: 12px;
		height: calc(2 * var(--margin));
	}
</style>
