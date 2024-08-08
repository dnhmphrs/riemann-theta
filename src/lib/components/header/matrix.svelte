<script>
  import { onMount } from 'svelte';
  import { mousePosition } from '$lib/store/store';

  function calculateMatrix(mouse) {
    const sin = Math.sin;
    const cos = Math.cos;
    const pi = Math.PI;
    const x = mouse.x * 0.6;
    const y = mouse.y * 0.6;
    return [
      [1.0 + 0.5 * sin(x * pi), 0.5 * cos(y * pi), 0.2 * sin(x)],
      [0.5 * cos(x), 1.0 + 0.5 * cos(y * pi), 0.1 * sin(x * pi)],
      [0.2 * sin(x), 0.1 * cos(x), 1.0 + 0.5 * sin(y * pi)]
    ];
  }

  $: dynamicMatrix = calculateMatrix($mousePosition);
</script>

<div class="matrix">
  <p>: Riemann Matrix :</p>
  <table>
    <tr>
    </tr>
    {#each dynamicMatrix as row}
      <tr>
        {#each row as cell}
          <td>{cell.toFixed(2)}</td>
        {/each}
      </tr>
    {/each}
  </table>
</div>

<style>
  .matrix {
    background: var(--background);
    height: fit-content;
    width: fit-content;
    padding: 0;
    z-index: 2;
    font-family: Arial, sans-serif;
  }
  table {
    border-collapse: collapse;
  }
  td {
    padding: 5px;
    border: 1px solid #444;
    text-align: center;
    min-width: 50px;
  }
  p{
    text-align: center;
    PADDING: 5PX;
  }
</style>
