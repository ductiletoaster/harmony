#!/bin/bash

# Download new files
wget -N https://raw.githubusercontent.com/danny-avila/LibreChat/refs/heads/main/deploy-compose.yml -O docker-compose.yml
wget -N https://raw.githubusercontent.com/danny-avila/LibreChat/refs/heads/main/librechat.example.yaml -O librechat.yaml

# Download and create ENV files
wget -N https://raw.githubusercontent.com/danny-avila/LibreChat/refs/heads/main/.env.example -O .env.example
cp .env.example .env
cp .env.example stack.env
