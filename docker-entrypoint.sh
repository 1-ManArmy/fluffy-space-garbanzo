#!/bin/bash
set -e

echo "🚀 Starting OneLastAI Application..."

# Check if DATABASE_URL is available
if [ -n "$DATABASE_URL" ]; then
  echo "✅ Database URL found!"
  
  # Run database migrations
  echo "🔄 Running database migrations..."
  bundle exec rails db:create db:migrate || echo "⚠️ Migration failed, continuing..."
else
  echo "⚠️ No database URL found, skipping migrations"
fi

# Assets are already precompiled in Dockerfile for better performance
echo "🎨 Using precompiled assets from build stage..."
echo "✅ Assets ready for production serving"

echo "🔥 Starting Rails server on port ${PORT:-3000}..."
exec "$@"
