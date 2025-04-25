# Portainer Setup

A simple setup to deploy Portainer using `docker-compose` or `docker stack deploy` (Swarm).

## Requirements

1. Install [Docker](http://docker.io).
2. (optional) Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Clone this repository

## Usage

### Portainer & Agent

Deploy using `docker-compose`:
```
docker-compose up -d
```
### Agent Only
Deploy using `docker-compose`:
```
docker-compose up -d agent
```

## References
- [Deploying Portainer behind Traefik Proxy](https://docs.portainer.io/advanced/reverse-proxy/traefik)


---
### New Swarm set
https://docs.portainer.io/start/install-ce/server/swarm/wsl

```
docker stack deploy -c docker-compose.yml portainer
```