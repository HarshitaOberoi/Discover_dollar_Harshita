# Script to clean git history and push to GitHub
Write-Host "🧹 Cleaning git history..." -ForegroundColor Yellow

# Abort any ongoing rebase
git rebase --abort 2>$null

# Remove .git folder
if (Test-Path .git) {
    Remove-Item -Recurse -Force .git
    Write-Host "✅ Removed old git repository" -ForegroundColor Green
}

# Initialize fresh git repository
Write-Host "📦 Initializing fresh git repository..." -ForegroundColor Yellow
git init
git branch -M main

# Add remote
Write-Host "🔗 Adding remote..." -ForegroundColor Yellow
git remote add origin https://github.com/HarshitaOberoi/Discover_dollar_Harshita.git

# Stage all files
Write-Host "📝 Staging files..." -ForegroundColor Yellow
git add .

# Commit
Write-Host "💾 Committing..." -ForegroundColor Yellow
git commit -m "Initial commit: Complete MEAN stack application with Docker, CI/CD, and deployment configuration"

# Push
Write-Host "📤 Pushing to GitHub..." -ForegroundColor Yellow
Write-Host "⚠️  Note: You may need to authenticate. Use GitHub Personal Access Token as password." -ForegroundColor Cyan
git push -u origin main --force

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
} else {
    Write-Host "❌ Push failed. You may need to:" -ForegroundColor Red
    Write-Host "   1. Authenticate with GitHub" -ForegroundColor Yellow
    Write-Host "   2. Use Personal Access Token as password" -ForegroundColor Yellow
    Write-Host "   3. Or use: git push -u origin main --force" -ForegroundColor Yellow
}

