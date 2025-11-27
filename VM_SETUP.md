# Ubuntu VM Setup Guide

This guide will help you set up an Ubuntu VM on a cloud platform and deploy the MEAN stack application.

## Prerequisites

- Account on a cloud platform (AWS, Azure, GCP, DigitalOcean, etc.)
- Basic knowledge of SSH and Linux commands

## Step 1: Create Ubuntu VM

### AWS EC2
1. Log in to AWS Console
2. Navigate to EC2 → Launch Instance
3. Choose Ubuntu Server 20.04 LTS or 22.04 LTS
4. Select instance type (t2.micro or t3.micro for testing)
5. Configure security group:
   - SSH (port 22) from your IP
   - HTTP (port 80) from anywhere (0.0.0.0/0)
6. Launch instance and download key pair (.pem file)

### Azure VM
1. Log in to Azure Portal
2. Create a resource → Virtual Machine
3. Choose Ubuntu Server 20.04 LTS or 22.04 LTS
4. Configure networking:
   - Allow SSH (port 22)
   - Allow HTTP (port 80)
5. Create and download SSH key

### GCP Compute Engine
1. Log in to GCP Console
2. Navigate to Compute Engine → VM instances
3. Create instance with Ubuntu 20.04 or 22.04
4. Configure firewall rules for SSH and HTTP
5. Create and download SSH key

## Step 2: Connect to VM

```bash
# AWS/Azure/GCP
ssh -i /path/to/your-key.pem ubuntu@<VM-PUBLIC-IP>

# Or if using password authentication
ssh username@<VM-PUBLIC-IP>
```

## Step 3: Install Docker

```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to docker group (to run docker without sudo)
sudo usermod -aG docker $USER

# Log out and log back in for group changes to take effect
# Or run: newgrp docker

# Verify installation
docker --version
docker compose version
```

## Step 4: Install Git (if not already installed)

```bash
sudo apt-get install -y git
```

## Step 5: Clone Repository

```bash
# Create application directory
sudo mkdir -p /opt/mean-app
cd /opt/mean-app

# Clone your repository
git clone https://github.com/<your-username>/<your-repo>.git .

# Or if you need to set up the repository manually, copy files via SCP
```

## Step 6: Configure Environment

```bash
cd /opt/mean-app

# Create .env file
cat > .env << EOF
DOCKER_HUB_USERNAME=your-dockerhub-username
DOCKER_HUB_TOKEN=your-dockerhub-token
EOF

# Edit with your actual values
nano .env
```

## Step 7: Make Deploy Script Executable

```bash
chmod +x deploy.sh
```

## Step 8: Deploy Application

### Option A: Using Deploy Script
```bash
./deploy.sh
```

### Option B: Manual Deployment
```bash
# Login to Docker Hub
docker login

# Pull and start services
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d

# Check status
docker-compose -f docker-compose.prod.yml ps
```

## Step 9: Verify Deployment

```bash
# Check containers
docker ps

# Check logs
docker-compose -f docker-compose.prod.yml logs -f

# Test health endpoint
curl http://localhost/health

# Get VM public IP
curl ifconfig.me
# Or
hostname -I
```

## Step 10: Access Application

Open your browser and navigate to:
```
http://<VM-PUBLIC-IP>
```

## Troubleshooting

### Permission Denied
```bash
# If you get permission denied for docker commands
sudo usermod -aG docker $USER
newgrp docker
```

### Port Already in Use
```bash
# Check what's using port 80
sudo lsof -i :80
# Or
sudo netstat -tulpn | grep :80

# Stop the service or change port in docker-compose.yml
```

### Containers Not Starting
```bash
# Check logs
docker-compose -f docker-compose.prod.yml logs

# Check specific service
docker-compose -f docker-compose.prod.yml logs backend
docker-compose -f docker-compose.prod.yml logs frontend
docker-compose -f docker-compose.prod.yml logs nginx
```

### MongoDB Connection Issues
```bash
# Verify MongoDB container is running
docker ps | grep mongodb

# Check MongoDB logs
docker-compose -f docker-compose.prod.yml logs mongodb

# Test connection
docker-compose -f docker-compose.prod.yml exec backend sh
# Inside container: ping mongodb
```

## Updating Application

When you push changes to GitHub and the CI/CD pipeline runs, it will automatically:
1. Build new images
2. Push to Docker Hub
3. Pull and restart containers on the VM

Or manually update:
```bash
cd /opt/mean-app
git pull
./deploy.sh
```

## Security Considerations

1. **Firewall**: Only open necessary ports (22, 80)
2. **SSH Keys**: Use SSH keys instead of passwords
3. **Docker Hub**: Use access tokens, not passwords
4. **Secrets**: Never commit .env files to git
5. **Updates**: Regularly update system packages:
   ```bash
   sudo apt-get update && sudo apt-get upgrade -y
   ```

## Monitoring

### View Logs
```bash
# All services
docker-compose -f docker-compose.prod.yml logs -f

# Specific service
docker-compose -f docker-compose.prod.yml logs -f backend
```

### Container Stats
```bash
docker stats
```

### Disk Usage
```bash
docker system df
```

### Clean Up
```bash
# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Full cleanup (be careful!)
docker system prune -a --volumes
```

