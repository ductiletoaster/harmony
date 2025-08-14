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
- ✅ Setup custom https cert with Let's Encrypt
- ✅ Setup multi-environment Traefik deployment

### Infrastructure Overview

The project now supports a multi-environment setup with proper domain-based routing:

| Environment | Domain | IP Address | Purpose |
|-------------|--------|-------------|---------|
| Storage Server | `s01.pixeloven.com` | 192.168.8.200 | Storage and backup services |
| Workstation 1 | `w01.pixeloven.com` | 192.168.8.201 | Development and AI services |
| Workstation 2 | `w02.pixeloven.com` | 192.168.8.202 | Additional services |

Each environment supports individual subdomains with automatic Let's Encrypt certificates. No DNS API configuration required - each service gets its own certificate automatically.

### References
- Heavily influenced by [Techno Tim's AI Stack Tutorial](https://technotim.live/posts/ai-stack-tutorial/).
- [Portainer](https://github.com/portainer/portainer-compose) docker compose example setup.
- [Traefik](https://doc.traefik.io/) reverse proxy for service routing and SSL termination.

## Requirements

1. Install [Docker](http://docker.io).
2. (optional) Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Clone this repository
4. Configure DNS for your domains to point to the correct IP addresses

### System Setup

Install CachyOS 
- Load ISO onto Ventroy 
- Setup for Gaming - https://wiki.cachyos.org/configuration/gaming/

- Install 1Password Desktop - https://support.1password.com/install-linux/#arch-linux
    - Setup SSH Agent

### Quick Start

1. **Choose your environment** and copy the appropriate configuration:
   ```bash
   cd services/traefik
   cp .env.s01.example .env.s01  # For storage server
   # or
   cp .env.w01.example .env.w01  # For workstation 1
   # or  
   cp .env.w02.example .env.w02  # For workstation 2
   ```

2. **Customize the environment file** with your domain and email:
   ```bash
   DOMAIN_SUFFIX=s01.pixeloven.com
   ACME_EMAIL=admin@pixeloven.com
   ```

3. **Deploy** using Docker Compose:
   ```bash
   docker-compose up -d
   ```

4. **Access your services**:
   - Traefik Dashboard: `https://traefik.yourdomain.com`
   - Test Service: `https://whoami.yourdomain.com`

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
and to kill all swarm services
```
docker service rm $(docker service ls -q)
```