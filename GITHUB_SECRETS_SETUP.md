# GitHub Secrets Configuration Guide

This guide will help you configure GitHub Secrets for the CI/CD pipeline.

## 🔐 Required GitHub Secrets

You need to add the following secrets to your GitHub repository:

1. **DOCKER_HUB_USERNAME**: `harshitaoberoi`
2. **DOCKER_HUB_TOKEN**: `YOUR_DOCKER_HUB_TOKEN`
3. **VM_HOST**: `3.110.183.137`
4. **VM_USERNAME**: `ubuntu` (or your EC2 username)
5. **VM_SSH_KEY**: Your private SSH key for EC2 access

## 📝 Step-by-Step Setup

### Step 1: Navigate to Repository Settings

1. Go to your GitHub repository: https://github.com/HarshitaOberoi/Discover_dollar_Harshita
2. Click on **Settings** (top menu)
3. In the left sidebar, click on **Secrets and variables** → **Actions**

### Step 2: Add Secrets

Click **New repository secret** for each secret:

#### Secret 1: DOCKER_HUB_USERNAME
- **Name**: `DOCKER_HUB_USERNAME`
- **Value**: `harshitaoberoi`
- Click **Add secret**

#### Secret 2: DOCKER_HUB_TOKEN
- **Name**: `DOCKER_HUB_TOKEN`
- **Value**: `YOUR_DOCKER_HUB_TOKEN`
- Click **Add secret**

#### Secret 3: VM_HOST
- **Name**: `VM_HOST`
- **Value**: `3.110.183.137`
- Click **Add secret**

#### Secret 4: VM_USERNAME
- **Name**: `VM_USERNAME`
- **Value**: `ubuntu` (or `ec2-user` depending on your EC2 instance)
- Click **Add secret**

#### Secret 5: VM_SSH_KEY
- **Name**: `VM_SSH_KEY`
- **Value**: Your private SSH key content (the entire content of your `.pem` file)
  - Open your `.pem` file in a text editor
  - Copy the entire content including `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----`
  - Paste it as the value
- Click **Add secret**

### Step 3: Verify Secrets

After adding all secrets, you should see:
- ✅ DOCKER_HUB_USERNAME
- ✅ DOCKER_HUB_TOKEN
- ✅ VM_HOST
- ✅ VM_USERNAME
- ✅ VM_SSH_KEY

## 🔑 Getting Your SSH Key

If you need to get your SSH key:

1. **If you have the .pem file locally:**
   ```bash
   cat /path/to/your-key.pem
   ```
   Copy the entire output.

2. **If you need to generate a new key pair:**
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```
   Then copy the private key content.

## ⚠️ Important Notes

1. **Never commit secrets to the repository** - Always use GitHub Secrets
2. **Keep your .pem file secure** - Don't share it publicly
3. **The SSH key should be the private key** - Not the public key (.pub)
4. **EC2 Username varies by AMI:**
   - Ubuntu: `ubuntu`
   - Amazon Linux: `ec2-user`
   - Debian: `admin`
   - Check your EC2 instance details if unsure

## 🧪 Testing the Setup

After adding all secrets:

1. Push a change to your repository
2. Go to **Actions** tab in GitHub
3. Watch the workflow run
4. Check if it successfully:
   - Builds Docker images
   - Pushes to Docker Hub
   - Deploys to your EC2 instance

## 🔍 Troubleshooting

### Workflow fails at Docker login
- Verify `DOCKER_HUB_TOKEN` is correct
- Check if the token has proper permissions

### Workflow fails at SSH connection
- Verify `VM_HOST` is correct (3.110.183.137)
- Verify `VM_USERNAME` matches your EC2 instance
- Verify `VM_SSH_KEY` is the complete private key
- Check EC2 security group allows SSH from GitHub Actions IPs

### Workflow fails at deployment
- SSH into your EC2 instance manually to verify access
- Check if Docker and Docker Compose are installed on EC2
- Verify the repository is cloned on EC2

## 📚 Additional Resources

- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Docker Hub Access Tokens](https://docs.docker.com/docker-hub/access-tokens/)
- [AWS EC2 SSH Access](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)

