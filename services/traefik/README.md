# Traefik Reverse Proxy

Production-ready Traefik configuration with Let's Encrypt certificates for multiple environments.

## Overview

This Traefik setup provides:
- **Automatic HTTPS** with Let's Encrypt certificates
- **Individual certificates** for each subdomain
- **Multi-environment support** via environment variables
- **Domain-based routing** for your pixeloven.com subdomains
- **Automatic HTTP to HTTPS redirects**
- **Docker service discovery**

## Domain Structure

| Environment | Domain | IP Address | Purpose |
|-------------|--------|-------------|---------|
| Storage Server | `s01.pixeloven.com` | 192.168.8.200 | Storage and backup services |
| Workstation 1 | `w01.pixeloven.com` | 192.168.8.201 | Development and AI services |
| Workstation 2 | `w02.pixeloven.com` | 192.168.8.202 | Additional services |

### Subdomain Support
Each environment supports individual subdomains with automatic certificates:
- `traefik.w01.pixeloven.com` → Traefik dashboard (separate certificate)
- `whoami.w01.pixeloven.com` → Test service (separate certificate)
- `comfyui.w01.pixeloven.com` → ComfyUI service (separate certificate)
- Any new service gets its own certificate automatically

**Note:** Uses HTTP-01 challenges - no DNS API configuration required. Each subdomain gets its own Let's Encrypt certificate.

## Prerequisites

1. **DNS Configuration**: Ensure your domains point to the correct IP addresses
2. **Port Access**: Ports 80 and 443 must be accessible from the internet
3. **Docker**: Docker and Docker Compose must be installed
4. **Network**: The `proxy` network must exist

## Quick Start

### 1. Choose Your Environment

Copy the appropriate environment file:

```bash
# For Storage Server (s01.pixeloven.com)
cp .env.s01.example .env.s01

# For Workstation 1 (w01.pixeloven.com)  
cp .env.w01.example .env.w01

# For Workstation 2 (w02.pixeloven.com)
cp .env.w02.example .env.w02
```

### 2. Customize Environment Variables

Edit your `.env` file:

```bash
# Required: Your domain suffix
HOSTNAME=s01.pixeloven.com

# Required: Email for Let's Encrypt notifications
ACME_EMAIL=admin@pixeloven.com

# Optional: Customize logging
TRAEFIK_LOG_LEVEL=INFO
TRAEFIK_ACCESS_LOG=true
```

### 3. Deploy

```bash
docker-compose up -d
```

### 4. Access Your Services

- Traefik Dashboard: `https://traefik.yourdomain.com`
- Test Service: `https://whoami.yourdomain.com`

## Configuration Details

### Let's Encrypt Setup

- **ACME Protocol**: HTTP-01 challenge for certificate validation
- **Storage**: Certificates stored in `/certs/acme.json`
- **Auto-renewal**: Automatic certificate renewal before expiration
- **Rate Limits**: Let's Encrypt has rate limits (50 certificates per domain per week)

### Service Discovery

Services are automatically discovered via Docker labels:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.myapp.entrypoints=websecure"
        - "traefik.http.routers.myapp.rule=Host(`myapp.${HOSTNAME}`)"
  - "traefik.http.routers.myapp.tls=true"
  - "traefik.http.routers.myapp.tls.certresolver=letsencrypt"
  - "traefik.http.services.myapp.loadbalancer.server.port=80"
```

### Network Configuration

- **Proxy Network**: External Docker network for service communication
- **Port Mapping**: 80 (HTTP), 443 (HTTPS), 8080 (Dashboard)
- **Dashboard**: Accessible at `https://traefik.${HOSTNAME}`
- **Configuration**: All configuration handled via command-line arguments and Docker labels

## Troubleshooting

### Certificate Issues

1. **Check DNS**: Ensure domain resolves to correct IP
2. **Port Access**: Verify ports 80/443 are accessible
3. **Rate Limits**: Check Let's Encrypt rate limits
4. **Logs**: Review Traefik logs for errors

```bash
# Check Traefik logs
docker-compose logs -f traefik

# Check certificate status
docker exec traefik ls -la /certs/
```

### Common Issues

- **"Too Many Redirects"**: Check HTTP to HTTPS redirect configuration
- **"Certificate Not Trusted"**: Wait for Let's Encrypt validation
- **"Service Not Found"**: Verify Docker labels and network configuration

## Security Considerations

- **Dashboard Access**: Traefik dashboard is publicly accessible (consider IP restrictions)
- **Certificate Storage**: ACME account key stored in `/certs/acme.json`
- **Network Isolation**: Services communicate via `proxy` network
- **Automatic Updates**: Let's Encrypt certificates auto-renew

## Monitoring

### Health Checks

```bash
# Service status
docker-compose ps

# Network connectivity
docker network inspect proxy

# Certificate expiration
docker exec traefik openssl x509 -in /certs/acme.json -text -noout
```

### Logs

```bash
# Real-time logs
docker-compose logs -f

# Service-specific logs
docker-compose logs -f traefik
docker-compose logs -f whoami
```

## Support

For additional help:
- [Traefik Documentation](https://doc.traefik.io/)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)
- Project issues and discussions
