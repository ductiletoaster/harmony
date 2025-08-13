# Immich Service

A self-hosted photo and video backup solution that provides a Google Photos alternative with AI-powered features.

## Overview

Immich is a high-performance self-hosted photo and video backup solution that offers:
- Automatic photo/video backup from mobile devices
- AI-powered face recognition and object detection
- Duplicate detection and smart albums
- Web interface for browsing and managing media
- API for integration with other services

## Services

This deployment includes:

- **immich-server**: Main API service handling uploads, metadata, and core functionality
- **immich-web**: Web frontend for browsing and managing photos/videos
- **immich-machine-learning**: AI processing service for face recognition and object detection
- **immich-microservices**: Background processing for tasks like thumbnail generation
- **immich-postgres**: PostgreSQL database for metadata storage
- **immich-redis**: Redis cache for session management and temporary data

## Quick Start

### Local Development

1. Navigate to the service directory:
   ```bash
   cd services/immich
   ```

2. Copy the local environment template:
   ```bash
   cp env.local.example .env
   ```

3. Modify the `.env` file as needed (especially database passwords)

4. Start the service:
   ```bash
   docker-compose up -d
   ```

5. Access the web interface at `http://immich.docker.localhost`

### TrueNAS Dockge Deployment

1. Copy the TrueNAS environment template:
   ```bash
   cp env.truenas.example .env
   ```

2. Modify the `.env` file for your TrueNAS mount points and network configuration

3. Copy the entire service directory to your Dockge stacks location

4. Deploy via the Dockge web interface

## Configuration

### Environment Variables

#### Network Configuration
- Proxy network is hardcoded to `proxy` and set as external for all environments

#### File Permissions
- `PUID`: User ID for file permissions (default: `1000`)
- `PGID`: Group ID for file permissions (default: `1000`)

#### Database Configuration
- `DB_USERNAME`: PostgreSQL username (default: `postgres`)
- `DB_PASSWORD`: PostgreSQL password (default: `postgres`)
- `DB_DATABASE_NAME`: Database name (default: `immich`)

#### Volume Paths
- `IMMICH_UPLOAD_PATH`: Path for uploaded photos/videos
- `IMMICH_DB_PATH`: Path for PostgreSQL data
- `IMMICH_REDIS_PATH`: Path for Redis data
- `IMMICH_ML_MODELS_PATH`: Path for machine learning models

#### Optional Features
- `DISABLE_REVERSE_GEOCODING`: Disable location reverse geocoding (default: `false`)
- `REVERSE_GEOCODING_PRECISION`: Precision for reverse geocoding (default: `3`)
- `LOG_LEVEL`: Logging level (default: `log`)
- `ENABLE_DIAGNOTICS`: Enable diagnostic reporting (default: `true`)

### GPU Acceleration

To enable GPU acceleration for machine learning tasks:

1. Uncomment and configure GPU variables in your `.env` file:
   ```bash
   GPU_DRIVER=nvidia
   GPU_COUNT=all
   GPU_CAPABILITIES=gpu
   ```

2. Uncomment the GPU configuration section in `docker-compose.yml`

3. Ensure your Docker installation supports GPU passthrough

## Usage

### First Time Setup

1. Access the web interface
2. Create an admin account
3. Configure your mobile app with the server URL
4. Start uploading photos and videos

### Mobile App

Download the Immich mobile app from:
- [iOS App Store](https://apps.apple.com/us/app/immich/id1614494373)
- [Google Play Store](https://play.google.com/store/apps/details?id=app.immich)

### API Access

The service exposes a REST API at `/api` endpoint for integration with other services.

## Storage

### Local Development
- Photos/videos: `./library`
- Database: `./postgres`
- Redis: `./redis`
- ML Models: `./ml-models`

### TrueNAS Dockge
- Photos/videos: `/mnt/Media/libraries/dockge/containers/immich/library`
- Database: `/mnt/Media/libraries/dockge/immich/postgres`
- Redis: `/mnt/Media/libraries/dockge/immich/redis`
- ML Models: `/mnt/Media/libraries/dockge/immich/ml-models`

## Security Notes

- Change default database passwords in production
- Consider enabling Redis authentication
- Use reverse proxy with SSL termination for production deployments
- Regularly backup the PostgreSQL database

## Troubleshooting

### Common Issues

1. **Permission Errors**: Ensure `PUID` and `PGID` match your user/group
2. **Database Connection**: Verify PostgreSQL is healthy before starting other services
3. **GPU Issues**: Check Docker GPU support and driver compatibility
4. **Storage Space**: Monitor available space in upload and database directories

### Logs

View service logs:
```bash
docker-compose logs -f [service-name]
```

### Health Checks

The PostgreSQL service includes health checks to ensure proper startup order.

## Updating

To update to a newer version:

1. Update `IMMICH_VERSION` in your `.env` file
2. Pull new images: `docker-compose pull`
3. Restart services: `docker-compose up -d`

## Resources

- [Official Documentation](https://immich.app/docs)
- [GitHub Repository](https://github.com/immich-app/immich)
- [Community Discord](https://discord.gg/immich) 