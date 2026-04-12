from fastapi import FastAPI
from src.config import settings

app = FastAPI(title="Apollo Core", version=settings.version)


@app.get("/health")
async def health():
    return {
        "status": "ok",
        "version": settings.version,
        "hostname": settings.hostname,
        "device": settings.device,
        "env": settings.env,
    }
