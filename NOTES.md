# Homelab Setup


## System Setup
### TrueNAS

- Domain setup `nas.local.briangebel.com`
- Document current setup and configuration
- Applications: Portainer, Syncthing

### Docker Swarm

Setup for Workstaion-01 and Workstation-02
- Rename AMD build to `workstation-02`
- Connect docker swarm 
- Setup static ips for each .201 and .202
- Setup domain names for each `workstation-01.local.briangebel.com` and `workstation-02.local.briangebel.com`
- Setup docker deployments that target hostname
- Setup Traeffic labels to work for either

### Other Ideas
- Connect swarm directly to docker on nas but if not use portainer.
- Install Windows 10 in VM and Office 
- Try Dockage vs Portainer

## Apaplications
My current plan is to deploy as much as possible through docker swarm. Where necessary utilize TrueNAS apps and portainer. 

For `nas.local.briangebel.com`
- portainer <> apps
- traefik <> swarm
- syncthing <> swarm

For `workstation-01.local.briangebel.com`
- portainer <> swarm
- traefik <> swarm
- syncthing <> swarm

For `workstation-02.local.briangebel.com`
- portainer <> swarm
- traefik <> swarm
- syncthing <> swarm