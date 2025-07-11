FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel AS runtime-nvidia

# Install build dependencies
RUN apt-get update && \
    apt-get install -y \
    ffmpeg \
    build-essential \
    git \
    rdfind \
    strace \
    vim && \
    rm -rf /var/lib/apt/lists/*

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

# Setup conda
RUN conda config --set always_yes true && \
    conda init && \
    conda config --add channels defaults

WORKDIR /home/trellis/app

RUN git clone https://github.com/microsoft/TRELLIS.git . && \
    conda create -n trellis -y
# Install PyTorch and related packages in the conda environment
RUN conda run -n trellis conda install \
    pytorch=2.4.0 \
    torchvision \
    torchaudio \
    pytorch-cuda=12.4 \
    onnx==1.17.0 \
    -c pytorch \
    -c nvidia \
    -c conda-forge

# Run setup.sh - this won't install all the things due to missing GPU in the builder
RUN conda run -n trellis ./setup.sh --basic --xformers --flash-attn --diffoctreerast --vox2seq --spconv --mipgaussian --kaolin --nvdiffrast --demo

# Now install additional Python packages
# These ones work inside the builder
RUN conda run -n trellis pip install plyfile utils3d flash_attn spconv xformers onnxscript gradio diso
RUN conda run -n trellis pip install kaolin -f https://nvidia-kaolin.s3.us-east-2.amazonaws.com/torch-2.4.0_cu121.html
RUN conda run -n trellis pip install git+https://github.com/NVlabs/nvdiffrast.git

# Remove downloaded packages from conda and pip
RUN conda run -n trellis conda clean --all -f -y
RUN conda run -n trellis pip cache purge

# Deduplicate with rdfind
# This reduces the size of the image by a few hundred megs.
RUN rdfind -makesymlinks true /opt/conda

COPY --chown=trellis:trellis . .

RUN chmod +x onstart.sh && \
    chmod +x post_install.sh

ENV PATH=/opt/conda/bin:$PATH

ENV GRADIO_SERVER_NAME="0.0.0.0"
ENV GRADIO_SERVER_PORT="7860"

# If you're pushing to a container registry, let this run once, run some
# tests, then do `docker commit` to save the models along with the image.
# This will ensure that it won't fail at runtime due to models being
# unavailable, or network restrictions.
CMD ["bash", "onstart.sh"]

