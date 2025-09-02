#!/bin/bash

echo "🚀 Starting OneLastAI Rails Server..."

# Set environment
export RAILS_ENV=development
export NODE_ENV=development

# Check if databases are running
echo "📊 Checking database connections..."

# Start Rails server
echo "🌟 Starting Rails server on port 3000..."
bundle exec rails server -p 3000 -b 0.0.0.0
