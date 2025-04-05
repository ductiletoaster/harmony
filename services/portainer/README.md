# Portainer Setup

A simple setup to deploy Portainer using `docker-compose` or `docker stack deploy` (Swarm).

## Requirements

1. Install [Docker](http://docker.io).
2. (optional) Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Clone this repository

## Installation on TrueNAS (optional)
Depending on your setup this step may not be applicable. 

1. Login to the TrueNAS console.
2. Navigate to Apps on the primary sidebar menu.
3. Click the "Discover Apps" button in the top right corner.
4. Search "Portainer" click and install.

### Setup for Traefik
More often than note running Portainer on TrueNAS typically means we are managing most of the rest of our applications through Portainer rathern than through the native application manager. In some cases this may even include a container for Traefik. 

#### Locating Portainer Container Configurations
1. Login to the TrueNAS console.
2. Navigate to Apps on the primary sidebar menu.
3. Under Applications search for "portainer" and click.
4. Look for a widget labelled "Application Info". 
5. Click the Edit button in the top right corner of this widget.

#### Recommended Network Configuration
1. Locate the section called "Network Configuration"
2. Locate WebUI Port and update it to 9000
3. (optional) Check "Tunnel" and enter 8000 for tunnel

#### Adding labels for Traefik 
6. Scroll down and localte the section called "Labels Configuration"
7. Click add and enter the following key / value pairs:

To register a proxy for the Frontend UI:
```
traefik.enable=true
traefik.http.routers.frontend.rule=Host(`proxy.local.pixeloven.com`)
traefik.http.routers.frontend.entrypoints=websecure
traefik.http.services.frontend.loadbalancer.server.port=9000
traefik.http.routers.frontend.service=portainer-frontend
traefik.http.routers.frontend.tls.certresolver=leresolver
```

To register a proxy for Edge Agent support:
```
traefik.http.routers.edge.rule=Host(`edge.local.pixeloven.com`)
traefik.http.routers.edge.entrypoints=websecure
traefik.http.services.edge.loadbalancer.server.port=8000
traefik.http.routers.edge.service=portainer-edge
traefik.http.routers.edge.tls.certresolver=leresolver
```
These are the same values found in our compose file.

> **_NOTE:_** Though it is possible to run and manage Traefik from TrueNAS it is generally recommended to deploy this to a seperate machine. In my particular case I am only using it to support internal resolution of internal domains for my local enviroment. In other words nothing is being exposed to external traffic.

## Usage

### Compose

Deploy using `docker-compose`:
```
docker-compose up -d
```

### Swarm

Deploy this stack on a manager node inside your Swarm cluster:

```
docker stack deploy --compose-file=docker-stack.yml portainer
```

You can then access Portainer by using the IP address of any node in your Swarm cluster over port 9000 with a web browser.

## References
- [Deploying Portainer behind Traefik Proxy](https://docs.portainer.io/advanced/reverse-proxy/traefik)