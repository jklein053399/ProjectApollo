<script lang="ts">
	let { children } = $props();
</script>

<svelte:head>
	<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
	<title>Apollo Cyberdeck</title>
</svelte:head>

<div class="cyberdeck">
	{@render children()}
</div>

<style>
	:global(html, body) {
		margin: 0;
		padding: 0;
		width: 100vw;
		height: 100vh;
		overflow: hidden;
		background: var(--bg, #0a0a0f);
		color: var(--fg, #e0e0e0);
		font-family: 'Courier New', monospace;
	}

	.cyberdeck {
		width: 100vw;
		height: 100vh;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
	}
</style>
