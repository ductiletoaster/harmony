# Syncthing Setup

A simple setup to deploy Syncthing using `docker stack deploy` (Swarm).

## Requirements

1. Install [Docker](http://docker.io).
2. (optional) Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Clone this repository

## Usage

### Syncthing

Deploy using `docker stack deploy` (Swarm):
```
docker stack deploy -c docker-swarm.yml syncthing
```

## References
- [Docker Hub](https://hub.docker.com/r/linuxserver/syncthing)
