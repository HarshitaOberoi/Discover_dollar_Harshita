# MEAN Stack CRUD Application - DevOps Deployment

This project is a full-stack CRUD application built with the MEAN stack (MongoDB, Express.js, Angular 15, and Node.js). The application manages a collection of tutorials with features to create, retrieve, update, and delete tutorials, along with search functionality.

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Local Development Setup](#local-development-setup)
- [Docker Setup](#docker-setup)
- [Cloud Deployment](#cloud-deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Infrastructure Details](#infrastructure-details)
- [Troubleshooting](#troubleshooting)

## 🎯 Project Overview

The application consists of:
- **Backend**: Node.js/Express REST API server running on port 8080
- **Frontend**: Angular 15 application
- **Database**: MongoDB
- **Reverse Proxy**: Nginx serving the application on port 80

### Features
- Create, Read, Update, Delete (CRUD) operations for tutorials
- Search tutorials by title
- Published/Unpublished status for tutorials
- RESTful API endpoints

## 🏗️ Architecture

```
┌─────────────┐
│   Client    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Nginx     │ Port 80
│ (Reverse    │
│   Proxy)    │
└──────┬──────┘
       │
   ┌───┴───┐
   │       │
   ▼       ▼
┌──────┐ ┌────────┐
│Front │ │Backend │ Port 8080
│ end  │ │ (API)  │
└──────┘ └───┬────┘
             │
             ▼
        ┌─────────┐
        │ MongoDB │ Port 27017
        └─────────┘
```

## 📦 Prerequisites

### Local Development
- Node.js 18+ and npm
- MongoDB (local or remote)
- Angular CLI 15+

### Docker Deployment
- Docker 20.10+
- Docker Compose 2.0+
- Docker Hub account (for CI/CD)

### Cloud Deployment
- Ubuntu 20.04+ VM on AWS/Azure/GCP
- SSH access to the VM
- Git installed on VM
- Docker and Docker Compose installed on VM

## 🚀 Local Development Setup

### Backend Setup

1. Navigate to the backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Configure MongoDB connection in `app/config/db.config.js`:
```javascript
module.exports = {
  url: "mongodb://localhost:27017/dd_db"
};
```

4. Start the server:
```bash
node server.js
```

The backend will run on `http://localhost:8080`

### Frontend Setup

1. Navigate to the frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
ng serve --port 8081
```

The frontend will be available at `http://localhost:8081`

## 🐳 Docker Setup

### Building Docker Images Locally

#### Backend Image
```bash
cd backend
docker build -t mean-app-backend:latest .
```

#### Frontend Image
```bash
cd frontend
docker build -t mean-app-frontend:latest .
```

### Running with Docker Compose

1. Navigate to the project root:
```bash
cd c
```

2. Start all services:
```bash
docker-compose up -d
```

3. Check running containers:
```bash
docker-compose ps
```

4. View logs:
```bash
docker-compose logs -f
```

5. Stop all services:
```bash
docker-compose down
```

The application will be accessible at `http://localhost:80`

### Building and Pushing to Docker Hub

1. Login to Docker Hub:
```bash
docker login
```

2. Tag your images:
```bash
docker tag mean-app-backend:latest <your-dockerhub-username>/mean-app-backend:latest
docker tag mean-app-frontend:latest <your-dockerhub-username>/mean-app-frontend:latest
```

3. Push images:
```bash
docker push <your-dockerhub-username>/mean-app-backend:latest
docker push <your-dockerhub-username>/mean-app-frontend:latest
```

## ☁️ Cloud Deployment

### Step 1: Set Up Ubuntu VM

1. Create an Ubuntu 20.04+ VM on your preferred cloud platform (AWS EC2, Azure VM, GCP Compute Engine)
2. Configure security groups/firewalls to allow:
   - SSH (port 22)
   - HTTP (port 80)
   - Optional: Backend API (port 8080) for direct access

### Step 2: Install Docker and Docker Compose on VM

SSH into your VM and run:

```bash
# Update system
sudo apt-get update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group (optional, to run docker without sudo)
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installations
docker --version
docker-compose --version
```

### Step 3: Clone Repository on VM

```bash
# Create application directory
sudo mkdir -p /opt/mean-app
cd /opt/mean-app

# Clone your repository
git clone https://github.com/<your-username>/<your-repo>.git .

# Or if repository already exists, pull latest changes
git pull origin main
```

### Step 4: Configure Environment Variables

Create a `.env` file in the project root:

```bash
cd /opt/mean-app
nano .env
```

Add your Docker Hub username:
```
DOCKER_HUB_USERNAME=your-dockerhub-username
```

### Step 5: Deploy with Docker Compose

```bash
# Login to Docker Hub
docker login

# Pull latest images
docker-compose -f docker-compose.prod.yml pull

# Start services
docker-compose -f docker-compose.prod.yml up -d

# Check status
docker-compose -f docker-compose.prod.yml ps

# View logs
docker-compose -f docker-compose.prod.yml logs -f
```

### Step 6: Verify Deployment

1. Check if all containers are running:
```bash
docker ps
```

2. Test the application:
```bash
curl http://localhost/health
```

3. Access the application via your VM's public IP:
   - Open browser: `http://<your-vm-public-ip>`

## 🔄 CI/CD Pipeline

### GitHub Actions Configuration

The CI/CD pipeline is configured in `.github/workflows/ci-cd.yml`. It automatically:

1. **Builds Docker images** when code is pushed to main/master/develop branches
2. **Pushes images to Docker Hub** with tags: `latest` and commit SHA
3. **Deploys to VM** automatically on main/master branch pushes

### Setting Up GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions, and add:

1. `DOCKER_HUB_USERNAME`: Your Docker Hub username
2. `DOCKER_HUB_TOKEN`: Your Docker Hub access token (Settings → Security → New Access Token)
3. `VM_HOST`: Your VM's public IP address
4. `VM_USERNAME`: SSH username (usually `ubuntu` or `admin`)
5. `VM_SSH_KEY`: Your private SSH key for VM access

### Pipeline Workflow

```
Push to GitHub
    ↓
GitHub Actions Triggered
    ↓
Build Backend Image → Push to Docker Hub
    ↓
Build Frontend Image → Push to Docker Hub
    ↓
SSH to VM → Pull Images → Restart Containers
    ↓
Application Updated
```

### Manual Pipeline Execution

You can also manually trigger the workflow from the GitHub Actions tab.

## 🔧 Infrastructure Details

### Services Configuration

#### MongoDB
- **Image**: `mongo:7`
- **Port**: 27017 (internal)
- **Volume**: Persistent data storage
- **Database**: `dd_db`

#### Backend API
- **Port**: 8080 (internal)
- **Environment Variables**:
  - `PORT`: 8080
  - `MONGODB_URI`: mongodb://mongodb:27017/dd_db

#### Frontend
- **Port**: 80 (internal, served by Nginx)
- **Build**: Production build of Angular app

#### Nginx Reverse Proxy
- **Port**: 80 (external)
- **Configuration**: `nginx/nginx.conf`
- **Routes**:
  - `/` → Frontend
  - `/api/*` → Backend API

### Network Architecture

All services communicate through a Docker bridge network (`app-network`), ensuring:
- Service discovery by container name
- Isolated network environment
- Secure internal communication

## 📸 Screenshots Guide

To document your deployment, capture screenshots of:

1. **CI/CD Configuration**:
   - GitHub Actions workflow file
   - Workflow execution logs
   - Successful build and push steps

2. **Docker Image Build and Push**:
   - Docker Hub repository showing pushed images
   - Image tags (latest and commit SHA)
   - Build logs from GitHub Actions

3. **Application Deployment**:
   - Running containers (`docker ps`)
   - Application UI in browser
   - API endpoints working (use browser dev tools or Postman)

4. **Nginx Setup**:
   - Nginx configuration file
   - Nginx container logs
   - Access logs showing requests

5. **Infrastructure**:
   - VM details from cloud console
   - Network/firewall rules
   - Docker Compose status

## 🐛 Troubleshooting

### Containers not starting

```bash
# Check logs
docker-compose logs

# Check specific service
docker-compose logs backend
docker-compose logs frontend
docker-compose logs nginx
```

### MongoDB connection issues

```bash
# Verify MongoDB is running
docker-compose ps mongodb

# Check MongoDB logs
docker-compose logs mongodb

# Test connection from backend container
docker-compose exec backend sh
# Inside container: ping mongodb
```

### Frontend not loading

```bash
# Check if frontend container is running
docker ps | grep frontend

# Verify Nginx configuration
docker-compose exec nginx nginx -t

# Check Nginx logs
docker-compose logs nginx
```

### Port conflicts

If port 80 is already in use:

```bash
# Find process using port 80
sudo lsof -i :80

# Or change port in docker-compose.yml
# Update nginx service ports to "8080:80"
```

### CI/CD Pipeline failures

1. Check GitHub Actions logs
2. Verify all secrets are set correctly
3. Ensure VM is accessible via SSH
4. Check Docker Hub credentials

### Rebuilding after changes

```bash
# Rebuild and restart
docker-compose down
docker-compose up -d --build

# Or for production
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

## 📝 API Endpoints

### Base URL
- Local: `http://localhost:8080/api/tutorials`
- Production: `http://<your-domain>/api/tutorials`

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tutorials` | Get all tutorials |
| GET | `/api/tutorials?title=keyword` | Search tutorials by title |
| GET | `/api/tutorials/:id` | Get tutorial by ID |
| POST | `/api/tutorials` | Create new tutorial |
| PUT | `/api/tutorials/:id` | Update tutorial |
| DELETE | `/api/tutorials/:id` | Delete tutorial |
| DELETE | `/api/tutorials` | Delete all tutorials |
| GET | `/api/tutorials/published` | Get published tutorials |

### Example Request

```bash
# Create tutorial
curl -X POST http://localhost/api/tutorials \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Docker Tutorial",
    "description": "Learn Docker basics",
    "published": true
  }'

# Get all tutorials
curl http://localhost/api/tutorials
```

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [MongoDB Documentation](https://docs.mongodb.com/)

## 📄 License

This project is licensed under the ISC License.

## 👥 Contributors

- Initial setup and DevOps configuration

## 🔗 Repository

GitHub: https://github.com/HarshitaOberoi/Discover_dollar_Harshita.git

## 🖥️ Deployment Information

- **Docker Hub Username**: `harshitaoberoi`
- **AWS EC2 Public IP**: `3.110.183.137`
- **Application URL**: http://3.110.183.137

## 📚 Additional Documentation

- **[GITHUB_SECRETS_SETUP.md](GITHUB_SECRETS_SETUP.md)** - Configure GitHub Secrets for CI/CD
- **[EC2_DEPLOYMENT.md](EC2_DEPLOYMENT.md)** - Step-by-step EC2 deployment guide
- **[VM_SETUP.md](VM_SETUP.md)** - General VM setup instructions
- **[QUICK_START.md](QUICK_START.md)** - Quick reference guide

---

**Note**: Make sure to configure GitHub Secrets as described in GITHUB_SECRETS_SETUP.md before using the CI/CD pipeline!
