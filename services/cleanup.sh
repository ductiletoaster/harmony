# Kill / Destroy any running containers (data lose)
docker kill $(docker ps -q)

# Kill / Destroy any volumes (data lose)
docker volume prune --all

# Remove any images not attached to a container
docker image rmi $(docker images -a -q)

# Clean up unused resources
docker system prune -a
