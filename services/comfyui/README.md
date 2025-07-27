# ComfyUI Setup

A Docker-based setup for running [ComfyUI](https://github.com/comfyanonymous/ComfyUI), a powerful and modular stable diffusion GUI and backend, based on the [pixeloven/ComfyUI-Docker](https://github.com/pixeloven/ComfyUI-Docker) project.

## About This Project

ComfyUI provides a **production-ready, containerized solution** for running ComfyUI - the powerful node-based Stable Diffusion interface. 
Our goal is to eliminate the complexity of AI image generation setup while maintaining the flexibility and power that advanced users need.

### Key Features
- **Node-based workflow editor** - Visual programming interface for AI image generation
- **GPU acceleration** - Optimized for NVIDIA GPUs with proper CUDA support
- **Persistent storage** - Your models, configs, and outputs survive container restarts
- **Simple deployment** - Single service configuration for easy management
- **Model path management** - Organized model structure via `extra_model_paths.yaml`

## Requirements

1. Install [Docker](http://docker.io).
2. (optional) Install [Docker-compose](http://docs.docker.com/compose/install/).
3. NVIDIA GPU with proper drivers (for GPU acceleration)
4. Clone this repository

**Note**: Traefik proxy network is required only for swarm deployment or if you want HTTPS access in standalone mode.

## Quick Start

### 1. Setup Environment
```bash
# Copy environment file
cp env.example .env

# Edit environment variables if needed
nano .env
```

### 2. Create Model Directories
```bash
# Create the necessary model directories
mkdir -p data/models/{Stable-diffusion,VAE,Lora,ControlNet,RealESRGAN,ESRGAN,SwinIR,GFPGAN,BSRGAN,ScuNET,LDSR,Codeformer,Hypernetwork,Unet,Diffusers,SVD,Karlo,AfterDetailer,PromptExpansion,DeepDanbooru,ApproxVAE,ClipVision,IpAdapter,LyCORIS,TextualInversion,GLIGEN,T2IAdapter}
mkdir -p data/config/comfy/custom_nodes
```

### 3. Start ComfyUI

#### Using Docker Compose
```bash
# Start ComfyUI with GPU acceleration
docker compose up -d
```

#### Using Docker Swarm
```bash
# Deploy to swarm
docker stack deploy -c docker-swarm.yml comfyui
```

### 4. Access ComfyUI
Open your browser and navigate to:
- **Direct Access**: http://localhost:8188 (always available)
- **Traefik Proxy**: https://comfyui.local.briangebel.com (requires Traefik setup)

## Configuration

### Environment Variables
- `PUID` / `PGID`: User/group IDs for file permissions (default: 1000)
- `COMFY_PORT`: Port for ComfyUI web interface (default: 8188)

### Model Management
Models are organized through the `extra_model_paths.yaml` file which defines:
- **Checkpoints**: Stable Diffusion models
- **VAE**: Variational Autoencoders for better color reproduction
- **LoRA**: Low-Rank Adaptation models
- **ControlNet**: Control and conditioning models
- **Upscalers**: Image enhancement models
- **Embeddings**: Textual inversion models

### Model Paths
The default configuration organizes models in the following structure:
```
data/
├── models/
│   ├── Stable-diffusion/    # Checkpoint models
│   ├── VAE/                 # VAE models
│   ├── Lora/                # LoRA models
│   ├── ControlNet/          # ControlNet models
│   ├── RealESRGAN/          # Upscaling models
│   └── ...                  # Other model types
└── config/
    └── comfy/
        └── custom_nodes/    # Custom ComfyUI nodes
```

## Project Structure

```
services/comfyui/
├── docker-compose.yml          # Standalone deployment
├── docker-swarm.yml           # Swarm deployment
├── CONFIGURATION.md           # Configuration guide
├── env.example                # Environment variables template
├── extra_model_paths.yaml     # Model path configuration
├── data/                      # Persistent data storage
└── output/                    # Generated image outputs
```

## Usage

### Daily Operations
1. **Start**: `docker compose up -d`
2. **Stop**: `docker compose down`
3. **Logs**: `docker compose logs -f`
4. **Update**: Pull latest images and restart

### Adding Models
1. Place model files in the appropriate directories under `data/models/`
2. Restart ComfyUI to load new models
3. Models will appear in the ComfyUI interface based on their type

## Troubleshooting

### Common Issues
1. **GPU not detected**: Ensure NVIDIA drivers and nvidia-docker are installed
2. **Permission errors**: Check PUID/PGID match your user
3. **Port conflicts**: Change COMFY_PORT in environment
4. **Models not loading**: Verify models are in correct directories
5. **Traefik not accessible**: Ensure proxy network exists and Traefik is running

### Logs and Debugging
```bash
# View logs
docker compose logs

# Check container status
docker compose ps

# Access container shell
docker compose exec comfy-nvidia bash
```

### GPU Verification
```bash
# Test NVIDIA Docker
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi

# Check GPU in container
docker compose exec comfy-nvidia nvidia-smi
```

## Configuration

Both Docker Compose and Docker Swarm configurations include Traefik labels for reverse proxy access, but with different network requirements:

### Docker Compose (Standalone):
- **Direct Access**: Always available via `http://localhost:8188`
- **Traefik Access**: Optional, requires external Traefik setup
- **Network**: Uses internal bridge network only

### Docker Swarm (Production):
- **Direct Access**: Not available (no port publishing)
- **Traefik Access**: Required for external access
- **Network**: Uses external proxy network + internal overlay network

### Key Features:
- **Traefik Integration**: Both configurations include Traefik labels
- **HTTPS Access**: Automatic SSL/TLS termination via Let's Encrypt (when Traefik is available)
- **Consistent URLs**: Same domain for both deployments
- **Flexible Access**: Direct access for development, Traefik for production

## References
- [ComfyUI Documentation](https://github.com/comfyanonymous/ComfyUI)
- [pixeloven/ComfyUI-Docker](https://github.com/pixeloven/ComfyUI-Docker)
- [GPU Support For Docker Swarm](https://gist.github.com/coltonbh/374c415517dbeb4a6aa92f462b9eb287)
