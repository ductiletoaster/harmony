# LibreChat Setup

A simple setup to deploy LibreChat using `docker-compose`.
> **_NOTE:_** The `librechat.yml` and `.env.example` were copied from [LibreChat](https://github.com/danny-avila/LibreChat) repository. While `stack.env` is a copy of the `.env.example` file.

## Requirements

1. Install [Docker](http://docker.io).
2. (optional) Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Clone this repository

## Usage

### Compose

See `nginx-proxy/` or `traefik/` for Compose deployments.

## References
- [Local Installation of LibreChat with Docker](https://www.librechat.ai/docs/local/docker)
- [Using LibreChat with LiteLLM Proxy](https://www.librechat.ai/blog/2023-11-30_litellm)


---
### New Swarm set

```
docker stack deploy -c docker-compose.yml librechat
```