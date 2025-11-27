#!/bin/bash

# Script to build and push Docker images to Docker Hub
# Usage: ./build-and-push.sh <dockerhub-username>

set -e

DOCKER_HUB_USERNAME=${1:-${DOCKER_HUB_USERNAME:-harshitaoberoi}}

if [ -z "$DOCKER_HUB_USERNAME" ]; then
    echo "❌ Error: Docker Hub username is required"
    echo "Usage: ./build-and-push.sh <dockerhub-username>"
    echo "   Or set DOCKER_HUB_USERNAME environment variable"
    exit 1
fi

echo "🔐 Logging in to Docker Hub..."
docker login -u "$DOCKER_HUB_USERNAME"

echo "🏗️  Building backend image..."
cd backend
docker build -t "$DOCKER_HUB_USERNAME/mean-app-backend:latest" .
docker tag "$DOCKER_HUB_USERNAME/mean-app-backend:latest" "$DOCKER_HUB_USERNAME/mean-app-backend:$(git rev-parse --short HEAD 2>/dev/null || echo 'latest')"
cd ..

echo "🏗️  Building frontend image..."
cd frontend
docker build -t "$DOCKER_HUB_USERNAME/mean-app-frontend:latest" .
docker tag "$DOCKER_HUB_USERNAME/mean-app-frontend:latest" "$DOCKER_HUB_USERNAME/mean-app-frontend:$(git rev-parse --short HEAD 2>/dev/null || echo 'latest')"
cd ..

echo "📤 Pushing backend image..."
docker push "$DOCKER_HUB_USERNAME/mean-app-backend:latest"
docker push "$DOCKER_HUB_USERNAME/mean-app-backend:$(git rev-parse --short HEAD 2>/dev/null || echo 'latest')"

echo "📤 Pushing frontend image..."
docker push "$DOCKER_HUB_USERNAME/mean-app-frontend:latest"
docker push "$DOCKER_HUB_USERNAME/mean-app-frontend:$(git rev-parse --short HEAD 2>/dev/null || echo 'latest')"

echo "✅ Build and push completed!"
echo "📦 Images pushed:"
echo "   - $DOCKER_HUB_USERNAME/mean-app-backend:latest"
echo "   - $DOCKER_HUB_USERNAME/mean-app-frontend:latest"

