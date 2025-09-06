#!/bin/sh
set -e

echo "[entrypoint] Rails env: ${RAILS_ENV:-development}"

# Ensure required dirs exist
mkdir -p /app/tmp /app/tmp/pids /app/log /app/storage /app/public/assets

# Wait for database if DATABASE_URL is present
if [ -n "$DATABASE_URL" ]; then
  echo "[entrypoint] Waiting for database to be ready..."
  # Try up to 60 times (about 2 minutes)
  i=0
  until bundle exec rails db:version > /dev/null 2>&1; do
    i=$((i+1))
    if [ $i -ge 60 ]; then
      echo "[entrypoint] Database not ready after waiting; proceeding anyway"
      break
    fi
    sleep 2
  done
fi

# Run migrations/setup (skip if explicitly disabled)
if [ "${RUN_MIGRATIONS:-true}" = "true" ]; then
  echo "[entrypoint] Running database migrations..."
  if ! bundle exec rails db:migrate; then
    echo "[entrypoint] Migrate failed; attempting db:prepare"
    bundle exec rails db:prepare || true
  fi
fi

# Optionally compile assets in production if not present
if [ "${RAILS_ENV}" = "production" ]; then
  if [ ! -f "/app/public/assets/.manifest.json" ] && [ -z "${SKIP_ASSETS}" ]; then
    echo "[entrypoint] Precompiling assets (production)..."
    bundle exec rails assets:precompile || echo "[entrypoint] Asset precompile skipped/failed; continuing"
  else
    echo "[entrypoint] Skipping asset precompile"
  fi
fi

# Ensure PID directory exists just before starting Puma
mkdir -p /app/tmp/pids
echo "[entrypoint] Starting Puma..."
exec bundle exec puma -C config/puma.rb
