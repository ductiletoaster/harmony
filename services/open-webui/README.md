# Open WebUI Stack

A comprehensive AI development stack featuring Open WebUI, Ollama, and Faster Whisper with GPU acceleration support.

## Quick Start

1. **Copy environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Start the stack:**
   ```bash
   docker-compose up -d
   ```

3. **Access services:**
   - **Open WebUI**: http://open-webui.docker.localhost:8080
   - **Ollama**: http://ollama.docker.localhost:11434
   - **Faster Whisper**: http://faster-whisper.docker.localhost:10300

## Services

- **Open WebUI**: Web interface for AI models with RAG capabilities
- **Ollama**: AI model server with GPU acceleration
- **Faster Whisper**: Speech-to-text transcription service

## Features

- **GPU Acceleration**: Support for NVIDIA and AMD ROCm drivers
- **Traefik Integration**: Automatic reverse proxy configuration
- **Dual Domain Support**: Accessible via `docker.localhost` and `storage-01.lan`
- **RAG Support**: Web search integration (requires external SearXNG service)

## Configuration

### Environment Variables

- `PUID`/`PGID`: User/Group IDs for file permissions
- `GPU_DRIVER`: GPU driver type (nvidia, rocm)
- `GPU_COUNT`: Number of GPUs to use
- `GPU_CAPABILITIES`: GPU capabilities

### GPU Setup

Enable GPU acceleration by uncommenting the `deploy` sections in `docker-compose.yml` and setting the appropriate environment variables.

## Networks

- `proxy`: External network for Traefik integration
- `open-webui`: Internal network for service communication

## Volumes

- `./open-webui`: Open WebUI data
- `./ollama`: Ollama models and data
- `./faster-whisper`: Faster Whisper configuration