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

# Skip asset precompilation for Railway deployment (using pre-built CSS)
echo "🎨 Using pre-built assets..."
echo "✅ Skipping asset compilation to avoid Tailwind issues"

echo "🔥 Starting Rails server on port ${PORT:-3000}..."
exec "$@"
