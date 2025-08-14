#!/bin/bash

# Komodo Service Setup Script

echo "Setting up Komodo service..."

# Copy environment file
if [ ! -f .env ]; then
    cp .env.example .env
    echo "Created .env file from template"
    echo "Please edit .env and set your secret keys"
else
    echo ".env file already exists"
fi

# Generate random secrets if not set
if grep -q "your-secret-key-here" .env; then
    echo "Generating random secrets..."
    sed -i "s/your-secret-key-here/$(openssl rand -hex 32)/" .env
    sed -i "s/your-session-secret-here/$(openssl rand -hex 32)/" .env
    echo "Generated random secrets"
fi

echo "Setup complete. Run 'docker-compose up -d' to start Komodo" 