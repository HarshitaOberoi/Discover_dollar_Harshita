# Quick Start Guide

This is a quick reference guide for common tasks.

## 🚀 Local Development

### Start Backend
```bash
cd backend
npm install
node server.js
```

### Start Frontend
```bash
cd frontend
npm install
ng serve --port 8081
```

## 🐳 Docker Commands

### Build Images Locally
```bash
# Backend
cd backend
docker build -t mean-app-backend:latest .

# Frontend
cd frontend
docker build -t mean-app-frontend:latest .
```

### Run with Docker Compose
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild and restart
docker-compose up -d --build
```

### Build and Push to Docker Hub
```bash
# Make script executable
chmod +x build-and-push.sh

# Run script
./build-and-push.sh your-dockerhub-username
```

## ☁️ VM Deployment

### Initial Setup
1. Create Ubuntu VM on cloud platform
2. Install Docker and Docker Compose (see VM_SETUP.md)
3. Clone repository: `git clone <repo-url> /opt/mean-app`
4. Configure `.env` file with Docker Hub credentials
5. Run: `./deploy.sh`

### Update Application
```bash
cd /opt/mean-app
git pull
./deploy.sh
```

### Manual Update
```bash
cd /opt/mean-app
docker login
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

## 🔍 Troubleshooting

### Check Container Status
```bash
docker ps
docker-compose ps
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f nginx
docker-compose logs -f mongodb
```

### Restart Service
```bash
docker-compose restart backend
docker-compose restart frontend
```

### Clean Up
```bash
# Remove stopped containers
docker-compose down

# Remove unused images
docker image prune -a

# Full cleanup
docker system prune -a
```

## 📝 Common Issues

### Port 80 Already in Use
```bash
sudo lsof -i :80
# Kill the process or change port in docker-compose.yml
```

### MongoDB Connection Failed
```bash
# Check if MongoDB container is running
docker ps | grep mongodb

# Check MongoDB logs
docker-compose logs mongodb
```

### Frontend Not Loading
```bash
# Check Nginx logs
docker-compose logs nginx

# Verify Nginx config
docker-compose exec nginx nginx -t
```

## 🔗 Useful Links

- Application: `http://localhost` (or VM IP)
- Backend API: `http://localhost/api/tutorials`
- Health Check: `http://localhost/health`

## 📋 Environment Variables

### Backend
- `PORT`: Server port (default: 8080)
- `MONGODB_URI`: MongoDB connection string

### Frontend
- Uses environment files: `src/environments/environment.prod.ts`

### Docker Compose
- `DOCKER_HUB_USERNAME`: Your Docker Hub username

