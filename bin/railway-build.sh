#!/bin/bash

# Railway build script for OneLastAI
set -o errexit

echo "🚀 Building OneLastAI for Railway..."

# Install system dependencies
echo "📦 Installing system dependencies..."

# Install bundler dependencies
echo "💎 Installing Ruby gems..."
bundle install --without development test

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
npm install

# Build CSS assets
echo "🎨 Building CSS assets..."
npm run build:css

# Precompile Rails assets
echo "🏗️ Precompiling Rails assets..."
RAILS_ENV=production bundle exec rails assets:precompile

echo "✅ Build complete!"
