# Homelab Setup

- All apps should run in standalone and swarm

## System Setup
### TrueNAS

- Domain setup `nas.local.briangebel.com`
- Document current setup and configuration
- Applications: Portainer, Syncthing
- VM with swarm?

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

## Applications
My current plan is to deploy as much as possible through docker swarm. Where necessary utilize TrueNAS apps and portainer. 

For `nas.local.briangebel.com`
- portainer <> apps (standalone)
- traefik <> swarm
- syncthing <> apps (standalone)

For `workstation-01.local.briangebel.com`
- portainer <> swarm
- traefik <> swarm
- syncthing <> swarm

For `workstation-02.local.briangebel.com`
- portainer <> standalone
- traefik <> swarm
- syncthing <> standalone

# Thoughts
- Maybe kill swarm for now?
