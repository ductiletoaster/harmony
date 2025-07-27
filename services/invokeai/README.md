# Invoke AI Docker Setup

> **Note:** The official Invoke AI Docker image is hosted on GitHub Container Registry, not Docker Hub. The image reference is `ghcr.io/invoke-ai/invokeai:latest`. See [official docs](https://invoke-ai.github.io/InvokeAI/installation/docker/#tldr).

This directory contains Docker configurations for running Invoke AI in both standalone and swarm modes with Traefik integration.

## Quick Start

### Standalone Mode
```bash
# Create necessary directories
mkdir -p models outputs configs databases logs

# Start the service
docker-compose up -d
```

### Swarm Mode
```bash
# Create necessary directories
mkdir -p models outputs configs databases logs

# Copy and configure environment file
cp stack.env .env
# Edit .env with your specific configuration

# Deploy the stack
docker stack deploy -c docker-stack.yml invokeai
```

## Configuration

### Environment Variables
Copy `stack.env` to `.env` and modify the following key variables:

- `INVOKEAI_ROOT`: Root directory for Invoke AI (default: `/workspace`)
- `INVOKEAI_HOST`: Host binding (default: `0.0.0.0`)
- `INVOKEAI_PORT`: Port for the web interface (default: `9090`)

### Volumes
The following directories are mounted:
- `./models` → `/workspace/models` - AI models storage
- `./outputs` → `/workspace/outputs` - Generated images
- `./configs` → `/workspace/configs` - Configuration files
- `./databases` → `/workspace/databases` - Database files

### Traefik Integration
The service is configured with Traefik labels for automatic HTTPS routing:
- Domain: `invokeai.local.briangebel.com`
- Port: `9090`
- TLS: Automatic via Let's Encrypt

## Access
- Web Interface: https://invokeai.local.briangebel.com
- Direct Access: http://localhost:9090 (standalone mode only)

## Management

### Standalone Mode
```bash
# Start
docker-compose up -d

# Stop
docker-compose down

# View logs
docker-compose logs -f invokeai

# Update
docker-compose pull
docker-compose up -d
```

### Swarm Mode
```bash
# Deploy
docker stack deploy -c docker-stack.yml invokeai

# Remove
docker stack rm invokeai

# View logs
docker service logs invokeai_invokeai

# Update
docker service update --image invokeai/invokeai:latest invokeai_invokeai
```

## Initial Setup
1. Access the web interface
2. Follow the initial setup wizard
3. Download your preferred models
4. Configure your settings

## Troubleshooting

### Common Issues
1. **Port already in use**: Change `INVOKEAI_PORT` in your environment file
2. **Permission denied**: Ensure Docker has access to the mounted directories
3. **Model download issues**: Check network connectivity and disk space

### Logs
```bash
# Standalone
docker-compose logs invokeai

# Swarm
docker service logs invokeai_invokeai
```

## Documentation
For more information, visit: https://invoke-ai.github.io/InvokeAI/installation/docker/