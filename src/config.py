import socket
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    model_config = {"env_prefix": "APOLLO_", "env_file": ".env", "env_file_encoding": "utf-8"}

    # Server
    host: str = "0.0.0.0"
    port: int = 8000
    env: str = "development"

    # Device identity — change this to switch Pi→GEEKOM behavior
    device: str = "pi5"  # "pi5" | "core"
    hostname: str = socket.gethostname()

    # Version
    version: str = "0.1.1"


settings = Settings()
