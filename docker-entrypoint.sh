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

# Precompile assets if needed (skip if pre-built CSS exists)
echo "🎨 Handling assets..."
if [ ! -f app/assets/builds/tailwind.css ]; then
  bundle exec rails assets:precompile || echo "⚠️ Asset precompile failed, continuing..."
else
  echo "✅ Pre-built CSS found, skipping asset compilation"
fi

echo "🔥 Starting Rails server on port ${PORT:-3000}..."
exec "$@"
