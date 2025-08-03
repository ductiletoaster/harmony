# Harmony Services

This directory contains service configurations and setup scripts for the Harmony project.

## 🐳 Docker Services

The following Docker services are available:

- **ComfyUI** - AI image generation service
- **Filestash** - Web file manager
- **InvokeAI** - AI image generation and editing
- **Open WebUI** - Web interface for AI models
- **Portainer** - Docker container management
- **Syncthing** - File synchronization
- **Traefik** - Reverse proxy and load balancer

## 📋 Service Management

Each service has its own docker-compose.yml file in its respective directory:

```bash
# Navigate to a service directory
cd services/comfyui

# Start the service
docker-compose up -d

# Stop the service
docker-compose down

# View logs
docker-compose logs -f
```

## 🔧 General Utilities

- `cleanup.sh` - Docker cleanup script for removing unused containers, volumes, and images 