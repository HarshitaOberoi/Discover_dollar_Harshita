# AWS EC2 Deployment Guide

This guide provides specific instructions for deploying to your AWS EC2 instance.

## 🖥️ Your EC2 Details

- **Public IPv4**: `3.110.183.137`
- **Repository**: https://github.com/HarshitaOberoi/Discover_dollar_Harshita.git
- **Docker Hub Username**: `harshitaoberoi`

## 📋 Prerequisites

- AWS EC2 instance running Ubuntu
- SSH access to the instance
- Security group configured to allow:
  - SSH (port 22) from your IP
  - HTTP (port 80) from anywhere (0.0.0.0/0)

## 🚀 Step 1: Connect to EC2 Instance

```bash
# Replace with your key file path
ssh -i /path/to/your-key.pem ubuntu@3.110.183.137
```

## 🔧 Step 2: Install Docker and Docker Compose

Once connected to your EC2 instance:

```bash
# Update system
sudo apt-get update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installations
docker --version
docker-compose --version
```

## 📥 Step 3: Clone Repository

```bash
# Create application directory
sudo mkdir -p /opt/mean-app
cd /opt/mean-app

# Clone repository
git clone https://github.com/HarshitaOberoi/Discover_dollar_Harshita.git .

# Navigate to the 'c' directory (where docker-compose files are)
cd c
```

## ⚙️ Step 4: Configure Environment

```bash
# Create .env file
cat > .env << EOF
DOCKER_HUB_USERNAME=harshitaoberoi
DOCKER_HUB_TOKEN=YOUR_DOCKER_HUB_TOKEN
EOF

# Make deploy script executable
chmod +x deploy.sh
chmod +x build-and-push.sh
```

## 🐳 Step 5: Login to Docker Hub

```bash
docker login -u harshitaoberoi -p YOUR_DOCKER_HUB_TOKEN
```

## 🚀 Step 6: Deploy Application

### Option A: Using Deploy Script
```bash
./deploy.sh
```

### Option B: Manual Deployment
```bash
# Pull latest images
docker-compose -f docker-compose.prod.yml pull

# Start services
docker-compose -f docker-compose.prod.yml up -d

# Check status
docker-compose -f docker-compose.prod.yml ps
```

## ✅ Step 7: Verify Deployment

```bash
# Check all containers are running
docker ps

# Check logs
docker-compose -f docker-compose.prod.yml logs -f

# Test health endpoint
curl http://localhost/health

# Test from your local machine
curl http://3.110.183.137/health
```

## 🌐 Step 8: Access Application

Open your browser and navigate to:
```
http://3.110.183.137
```

The application should be accessible on port 80.

## 🔒 Step 9: Configure EC2 Security Group

Ensure your EC2 security group allows:

1. **SSH (port 22)**: From your IP address
2. **HTTP (port 80)**: From anywhere (0.0.0.0/0)

To update security group:
1. Go to AWS Console → EC2 → Security Groups
2. Select your instance's security group
3. Edit inbound rules
4. Add rule:
   - Type: HTTP
   - Port: 80
   - Source: 0.0.0.0/0

## 🔄 Step 10: Set Up Automatic Updates (CI/CD)

The CI/CD pipeline will automatically deploy when you push to the main branch. Make sure:

1. GitHub Secrets are configured (see GITHUB_SECRETS_SETUP.md)
2. Your EC2 instance allows SSH from GitHub Actions
3. The repository is cloned on EC2 at `/opt/mean-app/c`

## 📊 Monitoring

### View Container Logs
```bash
# All services
docker-compose -f docker-compose.prod.yml logs -f

# Specific service
docker-compose -f docker-compose.prod.yml logs -f backend
docker-compose -f docker-compose.prod.yml logs -f frontend
docker-compose -f docker-compose.prod.yml logs -f nginx
```

### Check Container Status
```bash
docker ps
docker-compose -f docker-compose.prod.yml ps
```

### Container Stats
```bash
docker stats
```

## 🐛 Troubleshooting

### Cannot connect via SSH
- Verify security group allows SSH from your IP
- Check if the instance is running
- Verify the key file permissions: `chmod 400 your-key.pem`

### Application not accessible on port 80
- Check security group allows HTTP (port 80)
- Verify containers are running: `docker ps`
- Check Nginx logs: `docker-compose -f docker-compose.prod.yml logs nginx`

### Docker login fails
- Verify Docker Hub token is correct
- Check token hasn't expired

### Containers not starting
- Check logs: `docker-compose -f docker-compose.prod.yml logs`
- Verify Docker images exist: `docker images | grep harshitaoberoi`
- Check if ports are available: `sudo netstat -tulpn | grep :80`

## 🔄 Updating the Application

### Manual Update
```bash
cd /opt/mean-app/c
git pull
./deploy.sh
```

### Automatic Update (via CI/CD)
1. Push changes to GitHub main branch
2. GitHub Actions will automatically:
   - Build new images
   - Push to Docker Hub
   - Deploy to EC2

## 📝 Quick Reference

```bash
# SSH to EC2
ssh -i your-key.pem ubuntu@3.110.183.137

# Navigate to app directory
cd /opt/mean-app/c

# View logs
docker-compose -f docker-compose.prod.yml logs -f

# Restart services
docker-compose -f docker-compose.prod.yml restart

# Stop services
docker-compose -f docker-compose.prod.yml down

# Start services
docker-compose -f docker-compose.prod.yml up -d
```

## 🔗 Useful Links

- **Application URL**: http://3.110.183.137
- **GitHub Repository**: https://github.com/HarshitaOberoi/Discover_dollar_Harshita
- **Docker Hub**: https://hub.docker.com/u/harshitaoberoi

