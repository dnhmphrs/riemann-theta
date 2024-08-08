<script>
	import { onMount, onDestroy  } from 'svelte';
	import { screenType } from '$lib/store/store';
	import { page } from '$app/stores';
	import { afterNavigate } from '$app/navigation';

	import * as THREE from 'three';
	import Stats from 'stats.js'

	// old
	// import vertexShader from './shaders/vertexShader-three.glsl';
  // import riemannRealFragShaderSource from './shaders/riemannRealFrag.glsl';
  // import riemannImaginaryFragShaderSource from './shaders/riemannImaginaryFrag.glsl';
  // import riemannLatticeFragShaderSource from './shaders/riemannLatticeFrag.glsl';
  // import kpEquationFragShaderSource from './shaders/kpEquationFrag.glsl';

	// new
	import vertexShader from './shaders/vertexShader-three.glsl';
	import fragmentShader_riemann_real from './shaders/riemannRealFrag.glsl';
	import fragmentShader_riemann_imaginary from './shaders/riemannImaginaryFrag.glsl';
	import fragmentShader_riemann_lattice from './shaders/riemannLatticeFrag.glsl';
	import fragmentShader_kp from './shaders/kpEquationFrag.glsl';



	let shaderMaterial_riemann_lattice, shaderMaterial_riemann_real, shaderMaterial_riemann_imaginary, shaderMaterial_riemann, shaderMaterial_kp;

	let container;
	let stats;

	let camera, scene, renderer;

	let width = window.innerWidth;
	let height = window.innerHeight;

	let mouse = new THREE.Vector2();
	const clock = new THREE.Clock();

	stats = new Stats()
	stats.showPanel(0) // 0: fps, 1: ms, 2: mb, 3+: custom
	document.body.appendChild(stats.dom)
	
	init();
	animate();

	function setupShaderMaterials() {
		const uniformsBase = {
			time: { value: 0 },
			mouse: { value: mouse }
		};

		const colors = {
			color1: new THREE.Color(0xd0d0d0),
			color2: new THREE.Color(0xbb4500),
			color3: new THREE.Color(0xdaaa55),
			color4: new THREE.Color(0x006994 ),
			color5: new THREE.Color(0x5099b4 ),
			color6: new THREE.Color(0x0000ff),
			color7: new THREE.Color(0x00ff00),
			color9: new THREE.Color(0x8fbd5a),
			color0: new THREE.Color(0x232323),
		}

		shaderMaterial_riemann_real = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_riemann_real,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color1 },
				color2: { value: colors.color2 },
				color3: { value: colors.color6 },
				color4: { value: colors.color7 },
			}
		});

		shaderMaterial_riemann_imaginary = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_riemann_imaginary,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color1 },
				color2: { value: colors.color2 },
				color3: { value: colors.color6 },
				color4: { value: colors.color7 },
			}
		});

		shaderMaterial_riemann_lattice = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_riemann_lattice,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color1 },
				color2: { value: colors.color5 },
				color3: { value: colors.color9 },
			}
		});

		shaderMaterial_kp = new THREE.ShaderMaterial({
			vertexShader: vertexShader,
			fragmentShader: fragmentShader_kp,
			uniforms: {
				...uniformsBase,
				color1: { value: colors.color4 },
				color2: { value: colors.color5 },
				color3: { value: colors.color4 },
			}
		});
	}

	function updateShaderUniforms() {
		// const elapsedTime = clock.getElapsedTime();

		// if ($page.url.pathname == '/') {
		// 	if ($screenType == 1) {
		// 		shaderMaterial_aufbau.uniforms.time.value = elapsedTime;
		// 		shaderMaterial_aufbau.uniforms.mouse.value = {
		// 			x: 4 * Math.cos(elapsedTime * 0.1),
		// 			y: 5 * Math.cos(elapsedTime * 0.1)
		// 		} 
		// 	} else {
		// 		shaderMaterial_aufbau.uniforms.mouse.value = mouse;
		// 		shaderMaterial_aufbau.uniforms.time.value = elapsedTime ;
		// 	}
		// }

		// if ($page.url.pathname == '/riemann') {
		// 	if ($screenType == 1) {
		// 		shaderMaterial_riemann.uniforms.mouse.value = {
		// 			x: clock.getElapsedTime() * 1,
		// 			y: clock.getElapsedTime() * 0.1
		// 		};
		// 	} else {
		// 		shaderMaterial_riemann.uniforms.mouse.value = {
		// 			x: mouse.x + clock.getElapsedTime() * 0.1,
		// 			y: mouse.y + clock.getElapsedTime() * 1
		// 		};
		// 	}
		// }

		// if ($page.url.pathname == '/tangent') {
		// 	shaderMaterial_raum.uniforms.mouse.value = mouse;
		// 	shaderMaterial_raum.uniforms.time.value = elapsedTime;
		// }
	}

	function init() {
		camera = new THREE.PerspectiveCamera(20, width / height, 1, 800);
		camera.position.z = 400;

		scene = new THREE.Scene();
		scene.background = new THREE.Color(0x232323);

		setupShaderMaterials();
		setScene();

		renderer = new THREE.WebGLRenderer({ antialias: false });
		renderer.setPixelRatio(window.devicePixelRatio);
		renderer.setSize(width, height);

		onMount(() => {
			container.appendChild(renderer.domElement);


		});

		window.addEventListener('mousemove', onDocumentMouseMove);
		window.addEventListener('resize', onWindowResize);
		// window.addEventListener('navigate', onNavigate);
	}

	function setHome () {

		let plane4 = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_kp);
		let plane5 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial_kp);
		scene.add(plane4);

		if ($screenType != 1) {
			plane5.position.z = 200;
			scene.add(plane5);

		} else {
			plane5.position.z = 100;
			plane5.rotation.z = Math.PI / 2
			scene.add(plane5);
		}
	}

	function setRiemannReal () {

		let plane4 = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_riemann_real);
		let plane5 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial_riemann_real);
		scene.add(plane4);

		if ($screenType != 1) {
			plane5.position.z = 200;
			scene.add(plane5);

		} else {
			plane5.position.z = 100;
			plane5.rotation.z = Math.PI / 2
			scene.add(plane5);
		}
	}

	function setRiemannImaginary () {

		let plane4 = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_riemann_imaginary);
		let plane5 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial_riemann_imaginary);
		scene.add(plane4);

		if ($screenType != 1) {
			plane5.position.z = 200;
			scene.add(plane5);

		} else {
			plane5.position.z = 100;
			plane5.rotation.z = Math.PI / 2
			scene.add(plane5);
		}
	}

	function setRiemannLattice () {

		let plane4 = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000), shaderMaterial_riemann_lattice);
		let plane5 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), shaderMaterial_riemann_lattice);
		scene.add(plane4);

		if ($screenType != 1) {
			plane5.position.z = 200;
			scene.add(plane5);

		} else {
			plane5.position.z = 100;
			plane5.rotation.z = Math.PI / 2
			scene.add(plane5);
		}
	}

	function setScene () {

		if ($page.url.pathname == '/') {
			setHome();
		}

		if ($page.url.pathname == '/riemann-real') {
			setRiemannReal();
		}

		if ($page.url.pathname == '/riemann-imaginary') {
			setRiemannImaginary();
		}

		if ($page.url.pathname == '/riemann-tangent') {
			setRiemannLattice();
		}
	}

	afterNavigate (onNavigate);
	function onNavigate() {

		for( var i = scene.children.length - 1; i >= 0; i--) { 
				let obj = scene.children[i];
				scene.remove(obj); 
		}

		setScene();

	}

	function onWindowResize() {
		let width = window.innerWidth;
		let height = window.innerHeight;

		camera.aspect = width / height;
		camera.updateProjectionMatrix();

		renderer.setSize(width, height);
	}

	function onDocumentMouseMove(event) {
    var clientX = event.clientX;
    var clientY = event.clientY;

    mouse.x = (clientX / window.innerWidth) * 2 - 1;
		mouse.y = -(clientY / window.innerHeight) * 2 + 1;

	};

	function animate() {
		requestAnimationFrame(animate);
		stats.begin()
		render();
		stats.end()
	}

	function render() {
		updateShaderUniforms();
		renderer.render(scene, camera);
	}

	onDestroy(() => {
    // Remove event listeners
    window.removeEventListener('mousemove', onDocumentMouseMove);
    window.removeEventListener('resize', onWindowResize);
    // Dispose of the materials, geometries, textures etc.
    scene.traverse(object => {
        if (object instanceof THREE.Mesh) {
            object.geometry.dispose();
            object.material.dispose();
        }
        // Consider adding other types if they hold resources (like textures).
    });
    
    // If you've added any textures, dispose of them too
    // texture.dispose();

    renderer.dispose();  // Dispose of the renderer's resources
});

</script>

<div bind:this={container} class:geometry={true} />

<style>
	.geometry {
		position: absolute;
		overflow: hidden;
		z-index: -1;
	}
</style>
