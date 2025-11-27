# Quick Setup Instructions

Follow these steps to get your application deployed quickly.

## ✅ Step 1: Configure GitHub Secrets

1. Go to: https://github.com/HarshitaOberoi/Discover_dollar_Harshita/settings/secrets/actions
2. Add these secrets:
   - `DOCKER_HUB_USERNAME` = `harshitaoberoi`
   - `DOCKER_HUB_TOKEN` = `YOUR_DOCKER_HUB_TOKEN`
   - `VM_HOST` = `3.110.183.137`
   - `VM_USERNAME` = `ubuntu`
   - `VM_SSH_KEY` = (Your EC2 private key content)

See [GITHUB_SECRETS_SETUP.md](GITHUB_SECRETS_SETUP.md) for detailed instructions.

## ✅ Step 2: Build and Push Docker Images

### Option A: Manual Build and Push

```bash
# Make script executable
chmod +x build-and-push.sh

# Build and push images
./build-and-push.sh harshitaoberoi
```

### Option B: Let CI/CD Build (Recommended)

Just push to GitHub main branch - the CI/CD pipeline will build and push automatically.

## ✅ Step 3: Deploy to EC2

SSH into your EC2 instance:

```bash
ssh -i your-key.pem ubuntu@3.110.183.137
```

Then run:

```bash
# Install Docker (if not already installed)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone repository
sudo mkdir -p /opt/mean-app
cd /opt/mean-app
git clone https://github.com/HarshitaOberoi/Discover_dollar_Harshita.git .
cd c

# Configure environment
echo "DOCKER_HUB_USERNAME=harshitaoberoi" > .env
echo "DOCKER_HUB_TOKEN=YOUR_DOCKER_HUB_TOKEN" >> .env

# Login to Docker Hub
docker login -u harshitaoberoi -p YOUR_DOCKER_HUB_TOKEN

# Deploy
chmod +x deploy.sh
./deploy.sh
```

## ✅ Step 4: Verify Deployment

1. Check containers: `docker ps`
2. Test locally: `curl http://localhost/health`
3. Access application: http://3.110.183.137

## ✅ Step 5: Configure EC2 Security Group

Make sure your EC2 security group allows:
- **SSH (22)**: From your IP
- **HTTP (80)**: From anywhere (0.0.0.0/0)

## 🎉 Done!

Your application should now be accessible at: **http://3.110.183.137**

## 🔄 Future Updates

After initial setup, updates are automatic:
1. Push code to GitHub main branch
2. CI/CD pipeline builds and deploys automatically
3. Application updates on EC2

## 📚 Need Help?

- See [EC2_DEPLOYMENT.md](EC2_DEPLOYMENT.md) for detailed EC2 setup
- See [GITHUB_SECRETS_SETUP.md](GITHUB_SECRETS_SETUP.md) for GitHub Secrets
- See [README.md](README.md) for complete documentation

