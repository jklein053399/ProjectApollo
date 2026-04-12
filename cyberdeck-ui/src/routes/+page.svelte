<script lang="ts">
	import { fetchHealth, type HealthResponse } from '$lib/api';

	let health: HealthResponse | null = $state(null);
	let error: string | null = $state(null);
	let checking = $state(true);

	async function check() {
		checking = true;
		error = null;
		try {
			health = await fetchHealth();
		} catch (e) {
			error = e instanceof Error ? e.message : 'Connection failed';
			health = null;
		} finally {
			checking = false;
		}
	}

	$effect(() => {
		check();
		const interval = setInterval(check, 15000);
		return () => clearInterval(interval);
	});
</script>

<div class="status-panel">
	<h1>APOLLO</h1>

	{#if checking && !health}
		<p class="checking">Connecting to Core...</p>
	{:else if health}
		<div class="connected">
			<span class="dot online"></span>
			<span>ONLINE</span>
		</div>
		<table>
			<tr><td>Host</td><td>{health.hostname}</td></tr>
			<tr><td>Device</td><td>{health.device}</td></tr>
			<tr><td>Version</td><td>{health.version}</td></tr>
			<tr><td>Env</td><td>{health.env}</td></tr>
		</table>
	{:else}
		<div class="connected">
			<span class="dot offline"></span>
			<span>OFFLINE</span>
		</div>
		<p class="error">{error}</p>
	{/if}
</div>

<style>
	.status-panel {
		text-align: center;
	}

	h1 {
		font-size: 2.5rem;
		letter-spacing: 0.5em;
		color: var(--accent, #00ffcc);
		margin-bottom: 1.5rem;
	}

	.connected {
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 0.5rem;
		font-size: 1.2rem;
		margin-bottom: 1rem;
	}

	.dot {
		width: 12px;
		height: 12px;
		border-radius: 50%;
	}

	.dot.online { background: #00ff88; }
	.dot.offline { background: #ff4444; }

	.checking { color: #888; }
	.error { color: #ff4444; font-size: 0.85rem; }

	table {
		margin: 0 auto;
		text-align: left;
		border-collapse: collapse;
	}

	td {
		padding: 0.25rem 0.75rem;
		font-size: 0.9rem;
	}

	td:first-child {
		color: var(--accent, #00ffcc);
		text-transform: uppercase;
		font-size: 0.75rem;
	}
</style>
