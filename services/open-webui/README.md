# Open WebUI Setup

A comprehensive AI development stack featuring Open WebUI, Ollama, and Faster Whisper with GPU acceleration support.

## Requirements

1. Install [Docker](http://docker.io).
2. (optional) Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Clone this repository

## Quick Start

1. **Copy environment file:**
   ```bash
   # For local development
   cp .env.local.example .env
   
   # For TrueNAS deployment
   cp .env.truenas.example .env
   ```

2. **Edit the .env file** with your specific configuration (especially API keys)

3. **Start the stack:**
   ```bash
   docker-compose up -d
   ```

4. **Access services:**
   - **Open WebUI**: http://open-webui.docker.localhost:8080
   - **Ollama**: http://ollama.docker.localhost:11434
   - **Faster Whisper**: http://faster-whisper.docker.localhost:10300

## Services

- **Open WebUI**: Web interface for AI models with RAG capabilities
- **Ollama**: AI model server with GPU acceleration
- **Faster Whisper**: Speech-to-text transcription service

## Features

- **Local AI Models**: Run AI models locally via Ollama with GPU acceleration
- **OpenAI Integration**: Connect to OpenAI, Azure, and other OpenAI-compatible APIs
- **RAG Support**: Document processing and knowledge base creation with web search integration
- **Voice & Video**: Speech-to-text transcription and hands-free voice/video calls
- **Function Calling**: Native Python function execution and custom tools
- **Multi-Domain Access**: Accessible via `docker.localhost` and `storage-01.lan`

## Configuration

Environment variables are documented in the example files:
- `.env.local.example` - Local development configuration
- `.env.truenas.example` - TrueNAS deployment configuration

### GPU Setup

Enable GPU acceleration by uncommenting the `deploy` sections in `docker-compose.yml` and setting the appropriate environment variables.

## Network Access

This service is configured with Traefik labels for automatic reverse proxy routing. Services are accessible via:
- `servicename.docker.localhost` (local access)
- `servicename.storage-01.lan` (network access)

For detailed network setup instructions, see the [Network Access documentation](../../documentation/site/src/content/network_access.mdx).

## Networks

- `proxy`: External network for Traefik integration
- `open-webui`: Internal network for service communication

## Volumes

- `./open-webui`: Open WebUI data
- `./ollama`: Ollama models and data
- `./faster-whisper`: Faster Whisper configuration