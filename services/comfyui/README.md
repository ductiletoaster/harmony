# Stabe Diffusion Setup

A simple setup to deploy Portainer using `docker-compose` or `docker stack deploy` (Swarm).

## Requirements

1. Install [Docker](http://docker.io).
2. (optional) Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Clone this repository

## Usage

### ComfyUI (Compose)

Build images using `docker compose` (Compose):
```
docker compose build
```

Deploy using `docker compose` (Compose):
```
docker compose up -d
```


### ComfyUI (Swarm)

Deploy using `docker stack deploy` (Swarm):
```
docker stack deploy -c docker-swarm.yml stable-diffusion
```
## References
- [GPU Support For Docker Swarm](https://gist.github.com/coltonbh/374c415517dbeb4a6aa92f462b9eb287) - We should save this some where
