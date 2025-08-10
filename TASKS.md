# Goal

Build an free / open source workflow for AI empowered development for both development and design workflows. 

### Action Items
- [] Watch this https://www.youtube.com/watch?v=E2GIZrsDvuM
- [] Develp Agent workflow https://github.com/coleam00/ai-agents-masterclass/blob/main/local-ai-packaged/README.md
- [] runpodctl scripts to deploy services?
- [] custom filebrowser image for runpod?
- [] easier start of services from root of project


### Reconfigure TrueNAS Dockge 
Might need to consider whether harmony is one size or only for truenas/dockge 

- docker-compose.yml for local
- docker-stack.yml for dockage (remote)
- common.yml for shared

But also 
https://forums.truenas.com/t/electric-eel-beta-where-are-files-for-dockge-containers-stored/13439/3
https://forums.truenas.com/t/any-tutorials-on-getting-started-with-docker-dockge-in-truenas-scale/29399/3
**/dockge/data
**/dockge/stacks
**/dockge/containers/ollama
**/dockge/containers/open-webui

How can we make it so files co to HDD and containers host off performance?