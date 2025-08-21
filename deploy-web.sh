#!/bin/bash
# Simple deployment script for Flutter web

# Configuration
WEB_REPO_PATH="d:/project/SinaShop/shop-web"
PROJECT_PATH="d:/project/SinaShop/shop"

echo "🚀 Starting Flutter Web Deployment..."

# Build Flutter web
cd "$PROJECT_PATH"
echo "📦 Building Flutter for web..."
flutter build web --release

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

# Create web repo if it doesn't exist
if [ ! -d "$WEB_REPO_PATH" ]; then
    echo "📁 Creating web repository..."
    mkdir -p "$WEB_REPO_PATH"
    cd "$WEB_REPO_PATH"
    git init
    echo "# SinaShop Web Build" > README.md
    git add README.md
    git commit -m "Initial commit"
else
    cd "$WEB_REPO_PATH"
    git pull
fi

# Copy files
echo "📋 Copying web build files..."
find . -maxdepth 1 -not -name '.git' -not -name 'README.md' -not -name '.' -exec rm -rf {} \;
cp -r "$PROJECT_PATH/build/web"/* .

# Commit and push
echo "🔄 Committing changes..."
git add .
if [ -n "$(git status --porcelain)" ]; then
    git commit -m "Deploy web build - $(date)"
    git push origin main
    echo "✅ Deployment completed!"
else
    echo "ℹ️ No changes to deploy."
fi
