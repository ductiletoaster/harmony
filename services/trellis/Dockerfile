# https://github.com/microsoft/TRELLIS/pull/30/files
# FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel AS runtime-nvidia
# @todo can we use the devel image to build and then switch to runtime for the final image?
# FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04 AS runtime-nvidia
FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04 AS runtime-nvidia

ENV NVIDIA_VISIBLE_DEVICES=all
ENV DEBIAN_FRONTEND=noninteractive 
ENV PIP_PREFER_BINARY=1

# Install build dependencies
RUN apt-get update && \
apt-get install -y --no-install-recommends \ 
  build-essential \
  python3 \
  python3-dev \
  python3-pip \
  python3-venv \
  python-is-python3 \
  git \
  wget \
  curl \
  jq \
  ffmpeg \
  libgl1 \
  libglib2.0-0 \
  rdfind \
  strace && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  python -m pip install -U pip && \
  pip cache purge

FROM runtime-nvidia AS application

# Create a g++ wrapper for JIT, since the include dirs are passed with -i rather than -I for some reason
RUN printf '#!/usr/bin/env bash\nexec /usr/bin/g++ -I/usr/local/cuda/include -I/usr/local/cuda/include/crt "$@"\n' > /usr/local/bin/gxx-wrapper && \
    chmod +x /usr/local/bin/gxx-wrapper

ENV CXX=/usr/local/bin/gxx-wrapper

ARG PUID=1000
ARG PGID=1000
RUN groupadd -g $PGID trellis && \
    useradd -m -u $PUID -g $PGID trellis

USER trellis

WORKDIR /home/trellis

# Use bash shell so we can source activate
SHELL ["/bin/bash", "--login", "-c"]

ENV VIRTUAL_ENV=/home/trellis/.venv
ENV XDG_CACHE_HOME=/home/trellis/.cache

# @todo can we just use the onnxruntime-gpu package?
RUN --mount=type=cache,target=~/.cache/pip \ 
  python -m venv $VIRTUAL_ENV && \
  source ~/.venv/bin/activate

ENV PATH="/home/trellis/.local/bin:$PATH"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Setup conda
RUN git clone https://github.com/microsoft/TRELLIS.git app

WORKDIR /home/trellis/app

COPY --chown=trellis:trellis . .

# Run setup.sh - this won't install all the things due to missing GPU in the builder
RUN --mount=type=cache,target=~/.cache/pip \
    source ~/.venv/bin/activate && \ 
    pip install -r requirements.txt && \
    pip install git+https://github.com/NVlabs/nvdiffrast.git

RUN --mount=type=cache,target=~/.cache/pip \
    source ~/.venv/bin/activate && \ 
    # pip install flash_attn && \
    pip install diso && \
    ./setup.sh --basic --xformers --flash-attn --diffoctreerast --vox2seq --spconv --mipgaussian --kaolin --nvdiffrast --demo && \
    chmod +x onstart.sh && \
    chmod +x post_install.sh && \
    pip cache purge

# Deduplicate with rdfind
# This reduces the size of the image by a few hundred megs.
# RUN rdfind -makesymlinks true /opt/conda

ENV GRADIO_SERVER_NAME="0.0.0.0"
ENV GRADIO_SERVER_PORT="7860"

# If you're pushing to a container registry, let this run once, run some
# tests, then do `docker commit` to save the models along with the image.
# This will ensure that it won't fail at runtime due to models being
# unavailable, or network restrictions.
CMD ["bash", "onstart.sh"]

