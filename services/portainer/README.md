# Portainer Setup

A simple setup to deploy Portainer and Portainer Agent using `docker stack deploy` (Swarm).

> Portainer can be directly deployed as a service in your Docker Swarm cluster. Note that this method will automatically deploy a single instance of the Portainer Server, and deploy the Portainer Agent as a global service on every node in your cluster.



## Requirements

1. Install [Docker](http://docker.io).
2. (optional) Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Clone this repository

## Usage

### Portainer & Agent

Deploy using `docker stack deploy` (Swarm):
```
docker stack deploy -c docker-compose.yml portainer
```

## References
- [Deploying Portainer behind Traefik Proxy](https://docs.portainer.io/advanced/reverse-proxy/traefik)
- [Install Portainer CE with Docker Swarm on Linux](https://docs.portainer.io/start/install-ce/server/swarm/linux)
