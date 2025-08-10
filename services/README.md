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

## File Structure

Each service follows this pattern:
```
service-name/
├── docker-compose.yml      # Single compose file for both environments
├── .env.local.example      # Local development environment template
├── .env.truenas.example    # TrueNAS Dockge environment template
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
- `PROXY_NETWORK` - Name of the proxy network
- `PROXY_NETWORK_EXTERNAL` - Whether to use external network (true for TrueNAS, false for local)

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

### Local Development
- Networks are created locally with `external: false`
- Services can communicate via local Docker networking

### TrueNAS Dockge  
- Networks are external references (`external: true`)
- Ensure `proxy` network exists before deploying services
- Network names must match across all services

## Migration Notes

When migrating from local to TrueNAS:
1. Copy `.env.truenas.example` to `.env`
2. Update volume paths for your TrueNAS mount points
3. Set `PROXY_NETWORK_EXTERNAL=true`
4. Ensure external networks exist
5. Set appropriate file permissions for TrueNAS paths
6. Consider using `SEARXNG_REMOTE_SETUP=1` for services that support it

## Example Environment Files

### Local Development (.env)
```bash
PROXY_NETWORK=proxy
PROXY_NETWORK_EXTERNAL=false
OPEN_WEBUI_DATA_PATH=./open-webui
OLLAMA_DATA_PATH=./ollama
```

### TrueNAS Dockge (.env)
```bash
PROXY_NETWORK=proxy
PROXY_NETWORK_EXTERNAL=true
OPEN_WEBUI_DATA_PATH=/mnt/Media/libraries/dockge/open-webui
OLLAMA_DATA_PATH=/mnt/Media/libraries/dockge/containers/ollama
``` 