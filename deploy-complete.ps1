# Complete Deployment Script for Windows
# This script helps you deploy everything step by step

Write-Host "🚀 MEAN Stack Application - Complete Deployment Script" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Check if git is initialized
if (-not (Test-Path .git)) {
    Write-Host "📦 Initializing Git repository..." -ForegroundColor Yellow
    git init
    git branch -M main
    Write-Host "✅ Git repository initialized" -ForegroundColor Green
} else {
    Write-Host "✅ Git repository already initialized" -ForegroundColor Green
}

# Check if remote exists
$remoteExists = git remote get-url origin 2>$null
if (-not $remoteExists) {
    Write-Host "🔗 Adding GitHub remote..." -ForegroundColor Yellow
    git remote add origin https://github.com/HarshitaOberoi/Discover_dollar_Harshita.git
    Write-Host "✅ Remote added" -ForegroundColor Green
} else {
    Write-Host "✅ Remote already configured: $remoteExists" -ForegroundColor Green
}

# Stage all files
Write-Host ""
Write-Host "📝 Staging all files..." -ForegroundColor Yellow
git add .

# Check if there are changes to commit
$status = git status --porcelain
if ($status) {
    Write-Host "💾 Committing changes..." -ForegroundColor Yellow
    git commit -m "Initial commit: Complete MEAN stack application with Docker, CI/CD, and deployment configuration"
    Write-Host "✅ Changes committed" -ForegroundColor Green
} else {
    Write-Host "ℹ️  No changes to commit" -ForegroundColor Blue
}

Write-Host ""
Write-Host "📤 Ready to push to GitHub!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Push to GitHub: git push -u origin main" -ForegroundColor White
Write-Host "2. Configure GitHub Secrets (see GITHUB_SECRETS_SETUP.md)" -ForegroundColor White
Write-Host "3. Build and push Docker images: ./build-and-push.sh harshitaoberoi" -ForegroundColor White
Write-Host "4. Deploy to EC2 (see EC2_DEPLOYMENT.md)" -ForegroundColor White
Write-Host ""
Write-Host "Would you like to push to GitHub now? (y/n)" -ForegroundColor Cyan
$response = Read-Host

if ($response -eq 'y' -or $response -eq 'Y') {
    Write-Host "📤 Pushing to GitHub..." -ForegroundColor Yellow
    git push -u origin main
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
    } else {
        Write-Host "❌ Push failed. You may need to authenticate or set up credentials." -ForegroundColor Red
        Write-Host "   Try: git push -u origin main" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "🎉 Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor Cyan
Write-Host "   - README.md - Complete documentation" -ForegroundColor White
Write-Host "   - SETUP_INSTRUCTIONS.md - Quick setup guide" -ForegroundColor White
Write-Host "   - GITHUB_SECRETS_SETUP.md - GitHub Secrets configuration" -ForegroundColor White
Write-Host "   - EC2_DEPLOYMENT.md - EC2 deployment guide" -ForegroundColor White

