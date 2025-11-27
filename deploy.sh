#!/bin/bash

# Deployment script for Ubuntu VM
# This script automates the deployment process on the VM

set -e

echo "🚀 Starting MEAN App Deployment..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Navigate to application directory
APP_DIR="/opt/mean-app"
if [ ! -d "$APP_DIR" ]; then
    echo "📁 Creating application directory..."
    sudo mkdir -p $APP_DIR
fi

cd $APP_DIR

# Pull latest changes if git repo exists
if [ -d ".git" ]; then
    echo "📥 Pulling latest changes from repository..."
    git pull origin main || git pull origin master
else
    echo "⚠️  Not a git repository. Skipping git pull."
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "⚠️  .env file not found. Creating from example..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "📝 Please update .env file with your Docker Hub username:"
        echo "   DOCKER_HUB_USERNAME=your-username"
    else
        echo "DOCKER_HUB_USERNAME=your-username" > .env
        echo "📝 Please update .env file with your Docker Hub username"
    fi
fi

# Load environment variables
export $(cat .env | grep -v '^#' | xargs)

# Login to Docker Hub if credentials are provided
if [ ! -z "$DOCKER_HUB_USERNAME" ] && [ ! -z "$DOCKER_HUB_TOKEN" ]; then
    echo "🔐 Logging in to Docker Hub..."
    echo "$DOCKER_HUB_TOKEN" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin
fi

# Pull latest images
echo "📦 Pulling latest Docker images..."
docker-compose -f docker-compose.prod.yml pull || {
    echo "⚠️  Failed to pull images. Building locally..."
    docker-compose -f docker-compose.prod.yml build
}

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.prod.yml down

# Start containers
echo "🚀 Starting containers..."
docker-compose -f docker-compose.prod.yml up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# Check container status
echo "📊 Container status:"
docker-compose -f docker-compose.prod.yml ps

# Health check
echo "🏥 Performing health check..."
if curl -f http://localhost/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Application is healthy and running!${NC}"
else
    echo -e "${YELLOW}⚠️  Health check failed. Check logs with: docker-compose -f docker-compose.prod.yml logs${NC}"
fi

# Clean up unused images
echo "🧹 Cleaning up unused Docker images..."
docker image prune -f

echo -e "${GREEN}✅ Deployment completed!${NC}"
echo "🌐 Application should be available at: http://$(hostname -I | awk '{print $1}')"
echo "📋 View logs with: docker-compose -f docker-compose.prod.yml logs -f"

