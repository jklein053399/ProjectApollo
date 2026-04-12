const BASE_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:8000';

export interface HealthResponse {
	status: string;
	version: string;
	hostname: string;
	device: string;
	env: string;
}

export async function fetchHealth(): Promise<HealthResponse> {
	const res = await fetch(`${BASE_URL}/health`);
	if (!res.ok) throw new Error(`Health check failed: ${res.status}`);
	return res.json();
}
