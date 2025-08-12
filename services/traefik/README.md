# Traefik Setup

A simple setup to deploy Traefik and a whoami service using either `docker compose` (Standalone) or `docker stack deploy` (Swarm).

## Requirements

1. Install [Docker](http://docker.io).
2. (optional) Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Clone this repository

## Environment Configuration

This setup supports both local development and TrueNAS Dockge deployments using environment variables.

### Local Development
```bash
cp .env.local.example .env
# Edit .env if needed
docker-compose up -d
```

### TrueNAS Dockge
```bash
cp .env.truenas.example .env
# Edit .env with your domain and paths
# Copy to Dockge and deploy
```

## SSL Certificate Configuration

### Automatic Let's Encrypt Integration

Traefik automatically handles SSL certificates using Let's Encrypt with the following features:

- **HTTP Challenge**: Uses port 80 for domain validation
- **Automatic Renewal**: Certificates are automatically renewed before expiration
- **Persistent Storage**: Certificates are stored in persistent volumes to avoid rate limits
- **Multi-Domain Support**: Automatically generates certificates for all configured domains

### SSL Configuration

To enable SSL for a service, add these labels:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.service-secure.entrypoints=websecure"
  - "traefik.http.services.service-secure.service=service"
  - "traefik.http.routers.service-secure.rule=Host(`yourdomain.com`)"
  - "traefik.http.routers.service-secure.tls=true"
  - "traefik.http.routers.service-secure.tls.certresolver=letencrypt"
```

### HTTP to HTTPS Redirects

All services automatically redirect HTTP traffic to HTTPS for enhanced security:

- **Automatic Redirects**: HTTP requests are automatically redirected to HTTPS
- **Permanent Redirects**: Uses 301 redirects for better SEO and caching
- **Service-Specific Middleware**: Each service has its own redirect middleware
- **No Configuration Needed**: Redirects are automatically configured

#### Redirect Example
```yaml
labels:
  # HTTP router (redirects to HTTPS)
  - "traefik.http.routers.service-http.entrypoints=web"
  - "traefik.http.routers.service-http.middlewares=service-http-to-https"
  
  # HTTPS router with SSL
  - "traefik.http.routers.service-https.entrypoints=websecure"
  - "traefik.http.routers.service-https.tls=true"
  
  # Redirect middleware
  - "traefik.http.middlewares.service-http-to-https.redirectscheme.scheme=https"
  - "traefik.http.middlewares.service-http-to-https.redirectscheme.permanent=true"
```

### Rate Limit Considerations

As mentioned in the [Let's Encrypt community discussion](https://community.letsencrypt.org/t/how-to-continuously-create-renew-certificates-without-hitting-limits/184562/24), using persistent storage for certificates is **mandatory** to avoid hitting rate limits. This setup ensures:

- Certificates are stored in persistent volumes (`traefik-certs`)
- No duplicate certificate requests across container restarts
- Proper renewal handling without rate limit issues

### Local Development vs Production SSL

**Local Development (`.localhost` domains):**
- HTTP access works normally (redirects to HTTPS)
- HTTPS access will show certificate errors (expected)
- Let's Encrypt cannot issue certificates for `.localhost` domains
- Use HTTP for local testing (will redirect to HTTPS)

**Production (real domains):**
- Both HTTP and HTTPS work normally
- HTTP automatically redirects to HTTPS
- Let's Encrypt automatically issues valid certificates
- Automatic renewal handles certificate lifecycle

## Network Access Configuration

### Domain Resolution Strategy

This setup uses a dual-domain approach for accessing services:

- **`.localhost`** - For on-machine access (resolves to 127.0.0.1)
- **`.lan`** - For network access (configured in OpenWrt router settings)

The default Traefik rule automatically generates both domains for each service:
- `servicename.docker.localhost` (local access)
- `servicename.storage-01.lan` (network access)

### OpenWrt Configuration

The `.lan` domain resolution is configured in your OpenWrt router settings to point to your server's IP address. This allows other devices on your network to access services using the `.lan` domain.

## Docker Standalone

### Deployment:
Deploy using `docker compose` (Standalone):
```bash
docker-compose up -d
```

## Docker Swarm

### Features:

- Traefik will be deployed to all manager nodes (to have access to Swarm docker.sock)
- Traefik is listening on ports 80 (http) and 443 (https) on the node itself
- All http requests will be redirected to secure https requests
- Docker services with label `traefik.enable=true` will automatically be discovered by Traefik
- Letsencrypt will automatically generate TLS/SSL certificates for all domains in `Host()`
- Traefik log (`level=INFO`) and access log are enabled to container stdout/stderr
- Traefik dashboard is enabled at `https://traefik.example.com/dashboard/` with user/pass test/test
- Traefik `whoami` will be deployed to all Swarm nodes, available at `https://whoami.example.com`

### Setup:

- Adapt all domain names in `Host()`
- Adapt `acme.email`
- Adapt dashboard username/password
- For production: write logs files to mounted folder on host

### Deployment:
Deploy using `docker stack deploy` (Swarm):
```bash
docker stack deploy -c docker-swarm.yml proxy
```

### Challenges:

- Only a single Traefik instance should be run for `httpChallenge` or `tlsChallenge` to work, as Traefik CE (community edition) is not cluster-enabled. If you need clustered LetsEncrypt TLS, use `dnsChallenge` or a different method to generate the certs.
- Make sure to persist the LetsEncrypt TLS certs, as LetsEncrypt has strict limits. Note that the content of volumes is not shared across nodes.

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PROXY_NETWORK` | Name of the proxy network | `proxy` |
| `PROXY_NETWORK_EXTERNAL` | Whether to use external network | `false` (local) / `true` (TrueNAS) |
| `TRAEFIK_CERTS_VOLUME` | Volume name for certificates | `traefik-certs` |
| `TRAEFIK_CERTS_NAME` | Name for the certificates volume | `traefik-certs` |
| `LETSENCRYPT_EMAIL` | Email for Let's Encrypt notifications | `admin@example.com` |

## Testing Your Setup

### Local Development Testing
```bash
# Test HTTP access (should redirect to HTTPS)
curl -I http://whoami.docker.localhost
# Returns: 301 Moved Permanently with Location: https://whoami.docker.localhost

# Test Traefik dashboard (should work)
curl http://traefik.docker.localhost:8080

# Test HTTPS access (will show certificate errors - this is normal)
curl -k https://whoami.docker.localhost
```

### Production Testing
```bash
# Test HTTP access (should redirect to HTTPS)
curl -I http://yourdomain.com
# Returns: 301 Moved Permanently with Location: https://yourdomain.com

# Test HTTPS access (should work with valid certificate)
curl https://yourdomain.com

# Check certificate validity
openssl s_client -connect yourdomain.com:443 -servername yourdomain.com
```

### Testing Redirects
```bash
# Check redirect behavior
curl -I http://whoami.docker.localhost | grep -E "(HTTP|Location)"

# Expected output:
# HTTP/1.1 301 Moved Permanently
# Location: https://whoami.docker.localhost
```

## Troubleshooting

### Certificate Issues
- Ensure port 80 is accessible for HTTP challenges
- Check that the `LETSENCRYPT_EMAIL` is set correctly
- Verify the `traefik-certs` volume is persistent
- Check Traefik logs for ACME errors
- **Local development**: `.localhost` domains cannot get Let's Encrypt certificates (expected)

### Network Issues
- Ensure the `proxy` network exists
- Verify external network references for TrueNAS deployments
- Check that services are properly labeled for Traefik discovery

### Service Access Issues
- Verify service ports are correct (e.g., whoami uses port 80, not 8080)
- Check that router-service linking is properly configured
- Ensure services are on the `proxy` network

### Redirect Issues
- Verify middleware names match between router and definition
- Check that each service has unique middleware names
- Ensure HTTP routers are properly configured with middleware