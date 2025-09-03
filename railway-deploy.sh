#!/bin/bash
set -e

echo "🚀 Starting Railway deployment for OneLastAI..."

# Install Railway CLI if not present
if ! command -v railway &> /dev/null; then
    echo "📦 Installing Railway CLI..."
    npm install -g @railway/cli
fi

# Login to Railway
echo "🔐 Login to Railway..."
railway login

# Initialize project
echo "🎯 Initializing Railway project..."
railway init

# Add PostgreSQL database
echo "🗄️ Adding PostgreSQL database..."
railway add --database postgresql

# Deploy application
echo "🚀 Deploying application..."
railway up

# Generate domain
echo "🌐 Generating domain..."
railway domain

echo "✅ Railway deployment completed!"
echo "🎉 Your OneLastAI platform is now live on Railway!"
