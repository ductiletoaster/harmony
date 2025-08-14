# Services Deployment Pattern

This directory contains services that can be deployed in two different environments using a single `docker-compose.yml` file per service.

## Deployment Options

### Local Development
- Use `docker-compose.yml` with `.env` file
- Local volume paths (e.g., `./data`, `./config`)
- Local network configurations
- Suitable for development and testing

### TrueNAS Dockge (Remote)
- Use the same `docker-compose.yml` with different `.env` file
- TrueNAS-specific volume paths (e.g., `/mnt/Media/libraries/dockge/`)
- External network references
- Suitable for production deployment on TrueNAS Scale

## Available Services

- **traefik** - Reverse proxy with Let's Encrypt support
- **komodo** - Container and server management platform
- **portainer** - Container management interface
- **comfyui** - AI image generation interface
- **filebrowser** - Web-based file manager
- **immich** - Photo and video backup service
- **invokeai** - AI image generation
- **open-webui** - Web interface for AI models
- **searxng** - Privacy-focused meta search engine
- **syncthing** - File synchronization service

## File Structure

Each service follows this pattern:
```
service-name/
├── docker-compose.yml      # Single compose file for both environments
├── .env.example            # Environment configuration template
├── .env.local.example      # Local development environment template (if applicable)
├── .env.truenas.example    # TrueNAS Dockge environment template (if applicable)
└── README.md              # Service-specific documentation
```

## Usage

### Local Development
1. Copy `.env.local.example` to `.env`
2. Modify environment variables as needed
3. Run `docker-compose up -d`

```bash
cd services/service-name
cp .env.local.example .env
# Edit .env if needed
docker-compose up -d
```

### TrueNAS Dockge
1. Copy `.env.truenas.example` to `.env`
2. Modify environment variables for your TrueNAS setup
3. Copy the entire service directory to Dockge
4. Deploy via Dockge web interface

## Environment Variables

Key environment variables control the deployment behavior:

### Network Configuration
- Proxy network is hardcoded to `proxy` and set as external for all services
- No environment variables needed for network configuration

### Volume Paths
- `*_DATA_PATH` - Paths for service data directories
- `*_CONFIG_PATH` - Paths for configuration files
- `*_VOLUME` - Names for Docker volumes

### Service-Specific Variables
- `PUID` - User ID for file permissions
- `PGID` - Group ID for file permissions
- `SEARXNG_REMOTE_SETUP` - Whether to download configs remotely

## Volume Paths

### Local Development (Default)
- `./config` - Configuration files
- `./data` - Application data
- `./logs` - Log files

### TrueNAS Dockge
- `/mnt/Media/libraries/dockge/service-name` - Configuration and data
- `/mnt/Media/libraries/dockge/containers/service-name` - Large data volumes
- `/mnt/Performance/configs/dockge/data/service-name` - Performance-critical data

## Networks

### Network Configuration
- All services use the `proxy` network which is set as external
- The `proxy` network must be created before deploying any services
- Network configuration is consistent across all environments

## Migration Notes

When migrating from local to TrueNAS:
1. Copy `.env.truenas.example` to `.env`
2. Update volume paths for your TrueNAS mount points
3. Ensure the `proxy` network exists (it's external for all environments)
4. Set appropriate file permissions for TrueNAS paths
5. Consider using `SEARXNG_REMOTE_SETUP=1` for services that support it

## Example Environment Files

### Local Development (.env)
```bash
# No network configuration needed - proxy network is hardcoded
OPEN_WEBUI_DATA_PATH=./open-webui
OLLAMA_DATA_PATH=./ollama
```

### TrueNAS Dockge (.env)
```bash
# No network configuration needed - proxy network is hardcoded
OPEN_WEBUI_DATA_PATH=/mnt/Media/libraries/dockge/open-webui
OLLAMA_DATA_PATH=/mnt/Media/libraries/dockge/containers/ollama
``` 