# OneLastAI Railway Production Dockerfile
FROM ruby:3.4.2-alpine

# Install system dependencies including Node.js for asset compilation
RUN apk add --no-cache \
    bash \
    build-base \
    curl \
    git \
    imagemagick \
    nodejs \
    npm \
    postgresql-dev \
    sqlite-dev \
    tzdata \
    yaml-dev

# Install specific bundler version
RUN gem install bundler -v 2.4.10

# Set working directory
WORKDIR /app

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Copy package.json and install Node dependencies
COPY package.json package-lock.json* ./
RUN npm ci --only=production

# Copy application code
COPY . .

# Build Tailwind CSS for production
RUN npm run build:css

# Precompile Rails assets for production
RUN RAILS_ENV=production bundle exec rake assets:precompile

# Copy and set up entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Create necessary directories and ensure CSS file exists
RUN mkdir -p app/assets/builds app/assets/tailwind log tmp storage

# Create non-root user
RUN addgroup -g 1001 -S appuser && \
    adduser -S appuser -u 1001 -G appuser && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port (Railway will override this)
# Expose the port for Railway
EXPOSE 3000

# Health check using dynamic port
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD sh -c 'curl -f http://localhost:${PORT:-3000}/health || exit 1'

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Start command with dynamic port
CMD ["sh", "-c", "bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000} -e production"]
