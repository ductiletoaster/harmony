# Services

This directory contains various Docker Compose services that can be deployed independently or as part of a larger stack.

## Available Services

- **[ComfyUI](./comfyui/)**: AI image generation with ComfyUI
- **[Filebrowser](./filebrowser/)**: Web-based file manager
- **[InvokeAI](./invokeai/)**: AI image generation with InvokeAI
- **[Open WebUI](./open-webui/)**: AI development stack with Open WebUI, Ollama, and Faster Whisper
- **[Portainer](./portainer/)**: Docker container management
- **[SearXNG](./searxng/)**: Standalone metasearch engine with Redis caching
- **[Syncthing](./syncthing/)**: File synchronization service
- **[Traefik](./traefik/)**: Edge router and reverse proxy

## Common Setup

Most services require:
1. Copy `.env.example` to `.env`
2. Configure environment variables
3. Run `docker-compose up -d`

## Network Integration

Services can be integrated via the shared `proxy` network for Traefik routing. 