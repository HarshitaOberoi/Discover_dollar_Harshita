# Complete Deployment Guide

This guide will walk you through deploying everything step by step.

## 🎯 Overview

We'll complete these steps:
1. ✅ Prepare and commit all files
2. ✅ Push to GitHub
3. ✅ Configure GitHub Secrets
4. ✅ Build and push Docker images
5. ✅ Deploy to EC2 instance

## Step 1: Prepare Repository and Push to GitHub

### Option A: Using PowerShell Script (Windows)

```powershell
cd "C:\Users\Elite BooK\Downloads\crud-dd-task-mean-app\c"
.\deploy-complete.ps1
```

### Option B: Manual Git Commands

```bash
cd "C:\Users\Elite BooK\Downloads\crud-dd-task-mean-app\c"

# Initialize git if not already done
git init
git branch -M main

# Add remote
git remote add origin https://github.com/HarshitaOberoi/Discover_dollar_Harshita.git

# Stage all files
git add .

# Commit
git commit -m "Initial commit: Complete MEAN stack application with Docker, CI/CD, and deployment configuration"

# Push to GitHub
git push -u origin main
```

**Note**: If push fails due to authentication, you may need to:
- Use GitHub Personal Access Token as password
- Or configure SSH keys
- Or use GitHub CLI: `gh auth login`

## Step 2: Configure GitHub Secrets

1. Go to: https://github.com/HarshitaOberoi/Discover_dollar_Harshita/settings/secrets/actions

2. Click **New repository secret** for each:

   | Secret Name | Value |
   |------------|-------|
   | `DOCKER_HUB_USERNAME` | `harshitaoberoi` |
   | `DOCKER_HUB_TOKEN` | `YOUR_DOCKER_HUB_TOKEN` (see GITHUB_SECRETS_SETUP.md) |
   | `VM_HOST` | `3.110.183.137` |
   | `VM_USERNAME` | `ubuntu` |
   | `VM_SSH_KEY` | (Your EC2 private key - entire .pem file content) |

3. Save each secret

See [GITHUB_SECRETS_SETUP.md](GITHUB_SECRETS_SETUP.md) for detailed instructions.

## Step 3: Build and Push Docker Images

### Option A: Let CI/CD Do It (Recommended)

After pushing to GitHub and configuring secrets:
1. The CI/CD pipeline will automatically trigger
2. It will build and push images to Docker Hub
3. Check GitHub Actions tab to see progress

### Option B: Manual Build and Push

If you want to build manually first:

**On Windows (using WSL or Git Bash):**
```bash
cd "C:\Users\Elite BooK\Downloads\crud-dd-task-mean-app\c"

# Make script executable (in Git Bash)
chmod +x build-and-push.sh

# Run script
./build-and-push.sh harshitaoberoi
```

**Or using Docker commands directly:**
```bash
# Login to Docker Hub
docker login -u harshitaoberoi -p YOUR_DOCKER_HUB_TOKEN

# Build backend
cd backend
docker build -t harshitaoberoi/mean-app-backend:latest .
docker push harshitaoberoi/mean-app-backend:latest
cd ..

# Build frontend
cd frontend
docker build -t harshitaoberoi/mean-app-frontend:latest .
docker push harshitaoberoi/mean-app-frontend:latest
cd ..
```

## Step 4: Deploy to EC2

### Connect to EC2

```bash
ssh -i /path/to/your-key.pem ubuntu@3.110.183.137
```

### Install Docker and Docker Compose

```bash
# Update system
sudo apt-get update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker --version
docker-compose --version
```

### Clone and Deploy

```bash
# Create directory and clone
sudo mkdir -p /opt/mean-app
cd /opt/mean-app
git clone https://github.com/HarshitaOberoi/Discover_dollar_Harshita.git .
cd c

# Configure environment
cat > .env << EOF
DOCKER_HUB_USERNAME=harshitaoberoi
DOCKER_HUB_TOKEN=YOUR_DOCKER_HUB_TOKEN
EOF

# Login to Docker Hub
docker login -u harshitaoberoi -p YOUR_DOCKER_HUB_TOKEN

# Make deploy script executable
chmod +x deploy.sh

# Deploy
./deploy.sh
```

### Or Use Manual Deployment

```bash
cd /opt/mean-app/c

# Pull images
docker-compose -f docker-compose.prod.yml pull

# Start services
docker-compose -f docker-compose.prod.yml up -d

# Check status
docker-compose -f docker-compose.prod.yml ps
```

## Step 5: Verify Deployment

### On EC2

```bash
# Check containers
docker ps

# Check logs
docker-compose -f docker-compose.prod.yml logs -f

# Test health endpoint
curl http://localhost/health
```

### From Your Local Machine

1. Open browser: http://3.110.183.137
2. Test API: http://3.110.183.137/api/tutorials
3. Test health: http://3.110.183.137/health

## Step 6: Configure EC2 Security Group

Make sure your EC2 security group allows:

1. **SSH (port 22)**: From your IP address
2. **HTTP (port 80)**: From anywhere (0.0.0.0/0)

To update:
1. AWS Console → EC2 → Security Groups
2. Select your instance's security group
3. Edit inbound rules
4. Add HTTP rule (port 80, source 0.0.0.0/0)

## ✅ Verification Checklist

- [ ] Code pushed to GitHub
- [ ] GitHub Secrets configured
- [ ] Docker images built and pushed to Docker Hub
- [ ] EC2 instance accessible via SSH
- [ ] Docker installed on EC2
- [ ] Application deployed on EC2
- [ ] Security group allows HTTP (port 80)
- [ ] Application accessible at http://3.110.183.137
- [ ] CI/CD pipeline working (check GitHub Actions)

## 🔄 Automatic Updates

Once everything is set up:
- Push code to GitHub main branch
- CI/CD automatically builds and deploys
- Application updates on EC2 automatically

## 🆘 Troubleshooting

### Git Push Issues
- Use Personal Access Token as password
- Or configure SSH keys: `ssh-keygen` then add to GitHub
- Or use GitHub CLI: `gh auth login`

### Docker Build Issues
- Make sure Docker Desktop is running (Windows)
- Or use WSL2 for better compatibility

### EC2 Connection Issues
- Verify security group allows SSH from your IP
- Check key file permissions: `chmod 400 your-key.pem`
- Verify instance is running

### Application Not Accessible
- Check security group allows HTTP (port 80)
- Verify containers are running: `docker ps`
- Check logs: `docker-compose -f docker-compose.prod.yml logs`

## 📚 Additional Resources

- [README.md](README.md) - Complete documentation
- [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) - Quick setup
- [EC2_DEPLOYMENT.md](EC2_DEPLOYMENT.md) - Detailed EC2 guide
- [GITHUB_SECRETS_SETUP.md](GITHUB_SECRETS_SETUP.md) - GitHub Secrets

## 🎉 Success!

Once all steps are complete, your application will be:
- ✅ On GitHub
- ✅ Building automatically via CI/CD
- ✅ Deployed on EC2
- ✅ Accessible at http://3.110.183.137

