# Open WebUI Service

A comprehensive Docker Compose setup for Open WebUI with Ollama, SearXNG, Faster Whisper, and Redis caching. Supports both GPU and CPU-only configurations.

## Quick Start

```bash
docker compose up -d
```
## What's Included

- **Open WebUI**: Web interface for AI models with RAG capabilities
- **Ollama**: AI model server (CPU/GPU)
- **SearXNG**: Search engine for RAG functionality with Redis caching
- **Faster Whisper**: Speech-to-text transcription service
- **Redis**: Caching and session management

## Access URLs

### Local Development:
- Open WebUI: http://open-webui.docker.localhost
- Ollama: http://ollama.docker.localhost
- SearXNG: http://searxng.docker.localhost
- Faster Whisper: http://faster-whisper.docker.localhost

### Network Access:
- Open WebUI: http://open-webui.storage-01.lan
- Ollama: http://ollama.storage-01.lan
- SearXNG: http://searxng.storage-01.lan
- Faster Whisper: http://faster-whisper.storage-01.lan

## Configuration

Copy `.env.example` to `.env` and configure GPU settings if needed:
- `GPU_DRIVER`: nvidia, rocm, etc.
- `GPU_COUNT`: all, 1, 2, etc.
- `GPU_CAPABILITIES`: gpu, compute, utility