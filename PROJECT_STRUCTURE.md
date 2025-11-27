# Project Structure

This document outlines the complete project structure after DevOps setup.

```
c/
├── backend/                          # Node.js/Express Backend
│   ├── app/
│   │   ├── config/
│   │   │   └── db.config.js         # MongoDB configuration (uses env vars)
│   │   ├── controllers/
│   │   │   └── tutorial.controller.js
│   │   ├── models/
│   │   │   ├── index.js
│   │   │   └── tutorial.model.js
│   │   └── routes/
│   │       └── turorial.routes.js
│   ├── Dockerfile                    # Backend Docker image
│   ├── .dockerignore                 # Docker ignore file
│   ├── package.json                  # Backend dependencies
│   └── server.js                     # Express server (CORS enabled)
│
├── frontend/                         # Angular 15 Frontend
│   ├── src/
│   │   ├── app/
│   │   │   ├── services/
│   │   │   │   └── tutorial.service.ts  # Uses environment config
│   │   │   └── ...
│   │   ├── environments/
│   │   │   ├── environment.ts       # Development environment
│   │   │   └── environment.prod.ts  # Production environment
│   │   └── ...
│   ├── Dockerfile                    # Frontend Docker image (multi-stage)
│   ├── .dockerignore                 # Docker ignore file
│   ├── angular.json                  # Angular config (env file replacement)
│   └── package.json                  # Frontend dependencies
│
├── nginx/                            # Nginx Configuration
│   └── nginx.conf                    # Reverse proxy configuration
│
├── .github/                          # GitHub Actions CI/CD
│   └── workflows/
│       └── ci-cd.yml                 # CI/CD pipeline configuration
│
├── docker-compose.yml                # Local development Docker Compose
├── docker-compose.prod.yml           # Production Docker Compose (uses Docker Hub images)
│
├── deploy.sh                         # VM deployment automation script
├── build-and-push.sh                 # Manual Docker build and push script
│
├── README.md                         # Main documentation
├── VM_SETUP.md                       # VM setup guide
├── QUICK_START.md                    # Quick reference guide
├── DEPLOYMENT_CHECKLIST.md           # Deployment checklist
├── PROJECT_STRUCTURE.md              # This file
│
└── .gitignore                        # Git ignore file
```

## Key Files Description

### Docker Configuration
- **backend/Dockerfile**: Builds Node.js backend image
- **frontend/Dockerfile**: Multi-stage build (Angular build + Nginx serve)
- **docker-compose.yml**: Local development with build context
- **docker-compose.prod.yml**: Production with Docker Hub images

### CI/CD
- **.github/workflows/ci-cd.yml**: GitHub Actions pipeline that:
  - Builds Docker images on push
  - Pushes to Docker Hub
  - Deploys to VM automatically

### Deployment Scripts
- **deploy.sh**: Automated deployment script for VM
- **build-and-push.sh**: Manual script to build and push images

### Configuration
- **nginx/nginx.conf**: Reverse proxy routing:
  - `/` → Frontend
  - `/api/` → Backend
  - `/health` → Health check
- **backend/app/config/db.config.js**: MongoDB URI from environment
- **frontend/src/environments/**: Environment-specific API URLs

### Documentation
- **README.md**: Comprehensive main documentation
- **VM_SETUP.md**: Step-by-step VM setup guide
- **QUICK_START.md**: Quick reference for common tasks
- **DEPLOYMENT_CHECKLIST.md**: Complete deployment checklist

## Environment Variables

### Backend
- `PORT`: Server port (default: 8080)
- `MONGODB_URI`: MongoDB connection string

### Frontend
- Uses Angular environment files (build-time configuration)

### Docker Compose
- `DOCKER_HUB_USERNAME`: Your Docker Hub username

## Services Architecture

1. **MongoDB**: Database service (port 27017 internal)
2. **Backend**: Node.js API (port 8080 internal)
3. **Frontend**: Angular app served by Nginx (port 80 internal)
4. **Nginx**: Reverse proxy (port 80 external)

All services communicate via Docker bridge network (`app-network`).

