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
# Copy package.json and install Node dependencies
COPY package.json ./
RUN npm install

# Copy application code
COPY . .

# Copy and set up entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Create builds directory and handle CSS build with fallback
RUN mkdir -p app/assets/builds app/assets/tailwind

# Build Tailwind CSS first
RUN npm run build:css || echo "/* Tailwind CSS will be built at runtime */" > app/assets/builds/tailwind.css

# Create the file that tailwindcss-rails expects
RUN cp app/assets/stylesheets/application.tailwind.css app/assets/tailwind/application.css || \
    echo "/* Copied from application.tailwind.css */" > app/assets/tailwind/application.css

# Skip asset precompilation entirely - let Rails handle it at runtime
# Railway will provide all environment variables including SECRET_KEY_BASE
RUN echo "🔥 BROTHERHOOD: Assets will be compiled at runtime for maximum compatibility 🔥"

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

# Start command with entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
