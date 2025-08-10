# SearXNG Service

A standalone SearXNG metasearch engine service with Redis caching support.

## Quick Start

1. **Copy environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Start the service:**
   ```bash
   docker-compose up -d
   ```

3. **Access the service:**
   - Local: http://searxng.docker.localhost:8080
   - Network: http://searxng.storage-01.lan:8080

## Features

- **Metasearch Engine**: Aggregates results from multiple search engines
- **Redis Caching**: Improves performance with in-memory caching
- **Traefik Integration**: Automatic reverse proxy configuration
- **Configuration Management**: Support for remote configuration setup

## Configuration

### Environment Variables

- `SEARXNG_REMOTE_SETUP`: Set to `1` to download config files from remote repository
- `SEARXNG_HOSTNAME`: Hostname for Traefik routing
- `REDIS_URL`: Redis connection string for caching

### Manual Configuration (Dockge Users)

If you're using Dockge and need to override the auto-generated SearXNG configuration files, you can manually replace them:

1. **Download the configuration files:**
   ```bash
   wget -O /etc/searxng/settings.yml https://raw.githubusercontent.com/searxng/searxng/master/searx/settings.yml
   wget -O /etc/searxng/limiter.toml https://raw.githubusercontent.com/searxng/searxng/master/searx/limiter.toml
   ```

2. **Restart the SearXNG container** in Dockge

This ensures compatibility by including the `formats: -json` setting in `settings.yml`.

## Networks

- `proxy`: External network for Traefik integration
- `searxng`: Internal network for service communication

## Volumes

- `./config`: Configuration files
- `searxng_data`: Cache and data persistence
- `valkey_data`: Redis data persistence
