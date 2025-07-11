# Trellis Docker Troubleshooting Guide

This document provides detailed solutions for common issues encountered when building and running the Trellis Docker container.

## Build Issues

### Issue 1: Conda Activation in RUN Commands

**Error:**
```
CondaError: Run 'conda init' before 'conda activate'
```

**Root Cause:**
Each `RUN` command in Dockerfile runs in a separate shell session, so `conda activate` doesn't persist between commands.

**Solution:**
Use `conda run -n trellis` instead of `conda activate` in RUN commands:

```dockerfile
# ❌ Wrong
RUN conda activate trellis && pip install package

# ✅ Correct
RUN conda run -n trellis pip install package
```

**Files Modified:**
- `Dockerfile`: Lines 40-42, 44-51, 65-66
- `onstart.sh`: Line 8
- `post_install.sh`: Lines 10, 16

### Issue 2: PyTorch/Torchvision Version Mismatch

**Error:**
```
RuntimeError: operator torchvision::nms does not exist
```

**Root Cause:**
Version incompatibility between PyTorch and torchvision. The base image had PyTorch 2.7.1 but we were trying to install PyTorch 2.4.0.

**Solution:**
Let conda resolve compatible versions automatically:

```dockerfile
# ❌ Wrong - forcing specific versions
RUN conda run -n trellis conda install \
    pytorch=2.4.0 \
    torchvision=0.19.0 \
    pytorch-cuda=12.4

# ✅ Correct - let conda resolve
RUN conda run -n trellis conda install \
    pytorch \
    torchvision \
    torchaudio \
    pytorch-cuda
```

**Files Modified:**
- `Dockerfile`: Lines 44-51

### Issue 3: Missing Torch During Pip Install

**Error:**
```
ModuleNotFoundError: No module named 'torch'
```

**Root Cause:**
Pip packages that require torch during build time couldn't find it because PyTorch wasn't properly installed in the conda environment.

**Solution:**
1. Install PyTorch packages via conda first
2. Then install pip packages that depend on torch

```dockerfile
# ✅ Correct order
RUN conda run -n trellis conda install pytorch torchvision torchaudio pytorch-cuda
RUN conda run -n trellis pip install package-that-needs-torch
```

**Files Modified:**
- `Dockerfile`: Lines 44-51, 58

### Issue 4: Package Build Failures

**Error:**
```
error: subprocess-exited-with-error
Getting requirements to build wheel did not run successfully
```

**Affected Packages:**
- `flash_attn` - Requires specific CUDA/PyTorch versions
- `spconv` - Needs pre-built wheels for current environment  
- `diso` - Build-time torch dependency issues

**Root Cause:**
These packages require:
- Specific CUDA versions (11.8, 12.1, etc.)
- Compatible PyTorch versions
- Additional build dependencies
- Pre-built wheels for the current environment

**Solution:**
Temporarily exclude problematic packages and install them manually if needed:

```dockerfile
# ✅ Current working setup
RUN conda run -n trellis pip install plyfile utils3d xformers onnxscript gradio

# ❌ Problematic packages (commented out)
# RUN conda run -n trellis pip install flash_attn spconv diso
```

**Files Modified:**
- `Dockerfile`: Line 58

## Runtime Issues

### Issue 5: Permission Denied on Scripts

**Error:**
```
onstart.sh: line 4: ./post_install.sh: Permission denied
```

**Root Cause:**
Scripts copied into container don't have execute permissions.

**Solution:**
Make scripts executable during build:

```dockerfile
COPY --chown=trellis:trellis . .
RUN chmod +x onstart.sh && \
    chmod +x post_install.sh
```

**Files Modified:**
- `Dockerfile`: Lines 75-76

### Issue 6: Incorrect File Paths

**Error:**
```
./setup.sh: No such file or directory
```

**Root Cause:**
Absolute paths in scripts don't match container working directory.

**Solution:**
Use relative paths since working directory is already set:

```bash
# ❌ Wrong - absolute paths
cd /app
touch /app/.post_install_done

# ✅ Correct - relative paths  
cd .
touch .post_install_done
```

**Files Modified:**
- `post_install.sh`: Lines 4, 6, 20

## Package-Specific Solutions

### Flash Attention Installation

**Manual Installation Steps:**
```bash
# Enter container
docker exec -it trellis-trellis-1 bash

# Activate environment
conda activate trellis

# Try different installation methods
pip install flash-attn --no-build-isolation
# OR
pip install flash-attn --no-build-isolation --no-cache-dir
# OR
pip install flash-attn --index-url https://download.pytorch.org/whl/cu121
```

**Requirements Check:**
```bash
python -c "import torch; print(f'PyTorch: {torch.__version__}')"
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
nvidia-smi  # Check CUDA version
```

### Sparse Convolution (spconv)

**Installation Options:**
```bash
# Try pre-built wheels first
pip install spconv-cu121  # CUDA 12.1
pip install spconv-cu118  # CUDA 11.8
pip install spconv-cu117  # CUDA 11.7

# Build from source if needed
pip install spconv --no-cache-dir
```

**Dependencies:**
```bash
# Install build dependencies
conda install -c conda-forge ninja cmake
```

### DISO Package

**Installation:**
```bash
# Install after torch is available
pip install diso

# May need additional dependencies
pip install ninja
```

## Debugging Commands

### Check Environment
```bash
# Verify conda environment
conda info --envs
conda list | grep torch

# Check Python packages
pip list | grep -E "(torch|flash|spconv|diso)"

# Verify CUDA
python -c "import torch; print(torch.version.cuda)"
nvidia-smi
```

### Test Package Imports
```bash
# Test basic imports
python -c "import torch; print('PyTorch OK')"
python -c "import torchvision; print('Torchvision OK')"
python -c "import gradio; print('Gradio OK')"

# Test problematic packages
python -c "import flash_attn; print('Flash Attention OK')" 2>/dev/null || echo "Flash Attention failed"
python -c "import spconv; print('Sparse Conv OK')" 2>/dev/null || echo "Sparse Conv failed"
python -c "import diso; print('DISO OK')" 2>/dev/null || echo "DISO failed"
```

### Build Debugging
```bash
# Build with verbose output
docker-compose build --progress=plain

# Check intermediate layers
docker build --target application -t trellis-debug .

# Enter debug container
docker run -it trellis-debug bash
```

## Prevention Strategies

### 1. Version Compatibility Matrix
Maintain a compatibility matrix for:
- PyTorch versions
- CUDA versions  
- Python versions
- Package versions

### 2. Incremental Testing
Test package installation individually:
```dockerfile
# Test each package separately
RUN conda run -n trellis pip install package1 && \
    conda run -n trellis pip install package2 && \
    conda run -n trellis pip install package3
```

### 3. Pre-built Wheels
Prefer pre-built wheels over source builds:
```bash
# Check available wheels
pip index versions package_name
```

### 4. Alternative Packages
Consider alternatives for problematic packages:
- `flash_attn` → `xformers` (already working)
- `spconv` → `torchsparse` or `MinkowskiEngine`
- `diso` → `gaussian-splatting` or similar

## Future Improvements

### 1. Multi-stage Build
Separate build and runtime stages:
```dockerfile
FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel AS builder
# Build packages here

FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-runtime AS runtime
# Copy built packages here
```

### 2. Package Version Pinning
Pin specific working versions:
```dockerfile
RUN conda run -n trellis conda install \
    pytorch=2.4.0 \
    torchvision=0.20.0 \
    torchaudio=2.4.0
```

### 3. Runtime Package Installation
Install problematic packages at runtime:
```bash
# In onstart.sh
if [ ! -f .flash_attn_installed ]; then
    conda run -n trellis pip install flash-attn --no-build-isolation
    touch .flash_attn_installed
fi
```

### 4. Health Checks
Add health checks to verify installation:
```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD conda run -n trellis python -c "import torch; print('OK')" || exit 1
``` 