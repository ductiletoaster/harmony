# Traefik Setup

A simple setup to deploy Traefik and a whoami service using either `docker compose` (Standalone) or `docker stack deploy` (Swarm).

## Requirements

1. Install [Docker](http://docker.io).
2. (optional) Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Clone this repository

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