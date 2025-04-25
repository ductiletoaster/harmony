#!/bin/bash

docker stack deploy -c ./traefik/docker-compose.yml proxy
docker stack deploy -c ./portainer/docker-compose.yml portainer
docker stack deploy -c ./librechat/docker-compose.yml librechat
docker stack deploy -c ./stable-diffusion/docker-swarm.yml diffusion
