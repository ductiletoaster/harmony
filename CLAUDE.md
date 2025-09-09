# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is **Harmony**, a Docker-based homelab infrastructure project focused on deploying AI services and media applications. The project emphasizes simplicity, standardization, and multi-environment deployment capabilities.

## Core Architecture

### Multi-Environment Infrastructure

The project supports three distinct environments with domain-based routing:

- **Storage Server** (`s01.pixeloven.com` - 192.168.8.200): Storage and backup services
- **Workstation 1** (`w01.pixeloven.com` - 192.168.8.201): Development and AI services  
- **Workstation 2** (`w02.pixeloven.com` - 192.168.8.202): Additional services

### Service Deployment Pattern

All services follow a standardized Docker Compose architecture:

```
services/[service-name]/
├── docker-compose.yml       # Single compose file for both environments
├── .env.example            # Environment configuration template
├── .env.local.example      # Local development template (if applicable)
├── .env.truenas.example    # TrueNAS Dockge template (if applicable)
└── README.md              # Service-specific documentation
```

Each service uses:
- **External `proxy` network** for Traefik routing
- **Environment-specific volume paths** via `.env` files
- **Traefik labels** for automatic HTTPS and routing

### Key Components

- **Traefik**: Reverse proxy with automatic Let's Encrypt certificates (HTTP-01 challenge)
- **Portainer/Komodo**: Container management interfaces
- **AI Services**: ComfyUI, InvokeAI, Open WebUI with Ollama integration
- **Media/Utility Services**: Immich, Filebrowser, Syncthing, SearXNG

## Common Development Tasks

### Service Deployment

**Local Development:**
```bash
cd services/[service-name]
cp .env.local.example .env
# Edit .env as needed
docker-compose up -d
```

**TrueNAS Dockge (Production):**
```bash
cd services/[service-name]  
cp .env.truenas.example .env
# Edit .env for TrueNAS paths
# Deploy via Dockge web interface
```

### Network Management

Create the proxy network (required for all services):
```bash
docker network create proxy
```

### Environment Setup

For multi-environment Traefik setup:
```bash
cd services/traefik
cp .env.s01.example .env.s01    # Storage server
cp .env.w01.example .env.w01    # Workstation 1
cp .env.w02.example .env.w02    # Workstation 2
```

### Docker Maintenance

Clean up containers and resources:
```bash
# Use the provided cleanup script (DESTRUCTIVE - removes all containers/volumes)
./services/cleanup.sh

# Or individual cleanup commands
docker container prune
docker volume prune
docker image prune
```

### Documentation Site

The project includes a Next.js documentation site:
```bash
cd documentation/site
npm install
npm run dev        # Development server
npm run build      # Production build  
npm run lint       # ESLint
npm run format     # Prettier check
npm run format:fix # Prettier fix
```

## Environment Variables

### Volume Path Conventions

**Local Development:**
- `./config` - Configuration files
- `./data` - Application data
- `./logs` - Log files

**TrueNAS Dockge:**
- `/mnt/Media/libraries/dockge/[service-name]` - Configuration and data
- `/mnt/Media/libraries/dockge/containers/[service-name]` - Large data volumes
- `/mnt/Performance/configs/dockge/data/[service-name]` - Performance-critical data

### Required Variables

- `HOSTNAME` - Domain suffix (e.g., `w01.pixeloven.com`)
- `ACME_EMAIL` - Email for Let's Encrypt certificates
- `PUID/PGID` - User/Group IDs for file permissions
- `*_DATA_PATH` / `*_CONFIG_PATH` - Service-specific volume paths

## Commit Convention

Follow conventional commit format:
```
<type>(<scope>): <subject>

Types: feat, fix, docs, style, refactor, test, chore
Scope: service name, networks, nginx, etc.
Subject: imperative, present tense, no capitalization, no period
```

## Service-Specific Notes

### Traefik
- Uses HTTP-01 challenge (no DNS API required)
- Individual certificates per subdomain
- Dashboard accessible at `https://traefik.[hostname]`

### AI Services  
- ComfyUI and InvokeAI require GPU access
- Open WebUI integrates with Ollama for local LLM inference
- Custom nodes and models stored in persistent volumes

### File Management
- Filebrowser provides web-based file access
- Syncthing handles file synchronization between environments
- Immich manages photo/video backup and organization

## Infrastructure Goals

The project aims to create easy-to-use workflows for:
1. Docker-based AI service deployment
2. Multi-environment consistency (dev/production)
3. Automatic HTTPS with domain routing
4. Scalable homelab infrastructure supporting Windows, Linux, and virtualized environments