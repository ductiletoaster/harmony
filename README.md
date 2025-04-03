# Harmony

This project is an attempt to bring order to my diverse software interests. In this project you will find a collection of docker [services](./services/README.md) ranging in interests from AI to Media serving and more. My focus is in creating a simple to use and familiar (to me) set of workflows for developing applications and leveraging state of the art technology to do so. 

In the future you can expect to see me introduce more robust tooling to help support development of applications. My aim is not to necessary revent the wheel but instead use common well established technologies to create a fun to use solution to meet my needs. 

### Current Project Goals
Primary goal is to create easy to use set of workflows for managing services. The focus will be on deploying AI based services via docker. Bonus if it can be setup to deploy to Windows, Linux and even virtualized enviroments on Proxmox.

#### Tasks
- Create a simple Docker based deployment strategy leveraging [Portainer](https://github.com/portainer/portainer-compose)
- Follow [Techno Tim's AI Stack Tutorial](https://technotim.live/posts/ai-stack-tutorial/)
- [] Expand on instructions of desktop setup
- [] Setup DNSmasq for resolving local dns
- [] Setup custom https cert
- [] Setup .env for traefik and unified launcher https://github.com/dbushell/docker-traefik

### References
- Heavily influenced by [Techno Tim's AI Stack Tutorial](https://technotim.live/posts/ai-stack-tutorial/).
- [Portainer](https://github.com/portainer/portainer-compose) docker compose example setup.

## Requirements

1. Install [Docker](http://docker.io).
2. (optional) Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Clone this repository

### System Setup

Install CachyOS 
- Load ISO onto Ventroy 
- Setup for Gaming - https://wiki.cachyos.org/configuration/gaming/

- Install 1Password Desktop - https://support.1password.com/install-linux/#arch-linux
    - Setup SSH Agent

### Setup DNS
Create /etc/NetworkManager/conf.d/use-dnsmasq.conf
``` 
sudo touch /etc/NetworkManager/conf.d/use-dnsmasq.conf
sudo nano /etc/NetworkManager/conf.d/use-dnsmasq.conf
```
Update with
```
[main]
dns=dnsmasq
```
Create/etc/NetworkManager/dnsmasq.d/local.conf
``` 
sudo touch /etc/NetworkManager/dnsmasq.d/local.conf
sudo nano /etc/NetworkManager/dnsmasq.d/local.conf
```
Update with
```
address=/.local.pixeloven.com/127.0.0.1
```

then run
```
sudo systemctl restart NetworkManager
```

### Debug
Permission issues when running docker commands
```
sudo usermod -aG docker $USER
sudo systemctl start docker
docker login
```
Conflict with existing containers try removing all containers
```
docker rm -v -f $(docker ps -qa)
```
