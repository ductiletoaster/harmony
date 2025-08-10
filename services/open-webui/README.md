# Open WebUI Service

A comprehensive Docker Compose setup for Open WebUI with Ollama, SearXNG, Faster Whisper, and Redis caching. Supports both GPU and CPU-only configurations.

## Quick Start

```bash
docker compose up -d
```

## Post-Install Setup

Before starting the stack, run the post-install script to configure SearXNG:

```bash
./post-install.sh
```

This script will:
- Create necessary directories
- Generate SearXNG configuration with JSON format support
- Set up Redis integration
- Create verification scripts

## Manual SearXNG Configuration (Dockge Users)

If you're using Dockge and need to override the auto-generated SearXNG configuration files, you can manually replace them:

1. **Download the configuration files:**
   ```bash
   wget -O /etc/searxng/settings.yml https://raw.githubusercontent.com/searxng/searxng/master/searx/settings.yml
   wget -O /etc/searxng/limiter.toml https://raw.githubusercontent.com/searxng/searxng/master/searx/limiter.toml
   ```

2. **Restart the SearXNG container** in Dockge

This ensures compatibility with Open WebUI by including the `formats: -json` setting in `settings.yml`.

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