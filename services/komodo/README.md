# Komodo Service

[Komodo](https://komo.do/docs/intro) is a web application for managing servers, builds, deployments, and automated procedures. It provides a comprehensive interface for container management, server monitoring, and infrastructure automation.

## Features

- **Server Management**: Connect and monitor multiple servers with CPU, memory, and disk usage alerts
- **Container Management**: Create, start, stop, and restart Docker containers with real-time status and logs
- **Docker Compose**: Deploy and manage docker-compose stacks with Git integration
- **Build Automation**: Build application source into auto-versioned Docker images
- **Configuration Management**: Centralized environment variables and secrets management
- **Permission System**: Granular user permissions for team collaboration

## Quick Start

1. **Copy environment file**:
   ```bash
   cp .env.example .env
   ```

2. **Customize environment variables**:
   - Set `KOMODO_SECRET_KEY` and `KOMODO_SESSION_SECRET` to secure random values
   - Configure database settings if using external database
   - Adjust domain settings in your main environment file

3. **Start the service**:
   ```bash
   docker-compose up -d
   ```

4. **Access Komodo**:
   - URL: `https://komodo.yourdomain.com`
   - Default: SQLite database (no initial setup required)

## Configuration

### Environment Variables

- `KOMODO_SECRET_KEY`: Secret key for encryption (required)
- `KOMODO_SESSION_SECRET`: Session encryption secret (required)
- `KOMODO_DB_TYPE`: Database type (`sqlite`, `postgres`, `mysql`)
- `KOMODO_DB_*`: Database connection settings (if using external database)

### Database Options

- **SQLite** (default): Simple file-based database, good for single-server deployments
- **PostgreSQL/MySQL**: External database for multi-server or production deployments

### Traefik Integration

The service is configured to work behind Traefik with:
- Automatic HTTPS via Let's Encrypt
- Domain-based routing
- TLS termination

## Architecture

Komodo consists of two main components:

1. **Komodo Core**: Central web server with API and browser UI
2. **Komodo Periphery**: Lightweight agent running on managed servers

This setup includes only the Core component. Periphery agents can be deployed separately on servers you want to manage.

## Security

- Uses environment variables for sensitive configuration
- Docker socket access is read-only
- TLS encryption via Traefik
- Session-based authentication

## Troubleshooting

- Check container logs: `docker-compose logs komodo-core`
- Verify Traefik labels are correct
- Ensure the `proxy` network exists
- Check database permissions if using external database

## Documentation

- [Official Komodo Documentation](https://komo.do/docs/intro)
- [API Reference](https://komo.do/docs/api)
- [Permission System](https://komo.do/docs/permissioning) 