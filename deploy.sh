#!/bin/bash

# OneLastAI Production Deployment Script
set -e

echo "🚀 Starting OneLastAI deployment..."

# Build and start services
echo "📦 Building Docker images..."
docker-compose -f docker-compose.full.yml build

echo "🗄️ Starting database services..."
docker-compose -f docker-compose.full.yml up -d postgres redis

echo "⏳ Waiting for database to be ready..."
sleep 10

echo "🔑 Starting Keycloak authentication server..."
docker-compose -f docker-compose.full.yml up -d keycloak

echo "🤖 Starting Ollama AI models server..."
docker-compose -f docker-compose.full.yml up -d ollama

echo "📱 Starting FastAPI application..."
docker-compose -f docker-compose.full.yml up -d app celery

echo "🌐 Starting Nginx proxy..."
docker-compose -f docker-compose.full.yml up -d nginx

echo "✅ Deployment completed successfully!"
echo ""
echo "🌟 OneLastAI is now running:"
echo "   🏠 Main App: http://localhost"
echo "   📊 API Docs: http://localhost/docs"
echo "   🔐 Keycloak: http://localhost:8080"
echo "   🤖 Ollama API: http://localhost:11434"
echo ""
echo "🔧 To check status: docker-compose -f docker-compose.full.yml ps"
echo "📋 To view logs: docker-compose -f docker-compose.full.yml logs -f"
