# OneLastAI Multi-stage Production Dockerfile

# Base stage with common dependencies  
FROM ruby:3.4.2-alpine AS base

# Install system dependencies (alphabetically sorted and pinned)
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
    yaml-dev && \
    gem install bundler -v 2.4.10

# Set working directory
WORKDIR /app

# Development stage
FROM base AS development

# Copy Gemfile and install all gems (including dev/test)
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Expose port
EXPOSE 3000

# Start development server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]

# Production stage
FROM base AS production

# Copy Gemfile and install only production gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Copy package.json and install Node.js dependencies
COPY package.json ./
RUN npm install --production

# Copy application code
COPY . .

# Precompile assets with proper SECRET_KEY_BASE and skip CSS install
RUN RAILS_ENV=production \
    SECRET_KEY_BASE=d5f8a7b9c3e1f2a6b8d0c4e7f9a2b5c8e1f4a7b0c3e6f9a2b5c8e1f4a7b0c3e6f9a2b5c8e1f4a7b0c3e6 \
    npm run build:css && \
    bundle exec rails assets:precompile && \
    rm -rf node_modules tmp/cache/assets/.sprockets-manifest* tmp/cache/assets/*/

# Create non-root user
RUN addgroup -g 1001 -S appuser && \
    adduser -S appuser -u 1001 -G appuser

# Create necessary directories
RUN mkdir -p /app/log /app/tmp /app/storage && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Start command
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]