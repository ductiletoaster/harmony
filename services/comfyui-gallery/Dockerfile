# Smart ComfyUI Gallery Dockerfile
FROM python:3.11-slim

# Install system dependencies including FFmpeg for video metadata extraction
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone the repository
RUN git clone https://github.com/biagiomaf/comfyui-gallery.git . && \
    rm -rf .git

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create necessary directories
RUN mkdir -p /app/data

# Expose port 8189
EXPOSE 8189

# Set environment variables for paths (can be overridden)
ENV BASE_OUTPUT_PATH=/comfyui/output
ENV BASE_INPUT_PATH=/comfyui/input
ENV FFPROBE_MANUAL_PATH=""

# Run the application
CMD ["python", "app.py"]
