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

# Create builds directory and handle CSS build with fallback
RUN mkdir -p app/assets/builds app/assets/tailwind

# Build Tailwind CSS first
RUN npm run build:css || echo "/* Tailwind CSS will be built at runtime */" > app/assets/builds/tailwind.css

# Create the file that tailwindcss-rails expects
RUN cp app/assets/stylesheets/application.tailwind.css app/assets/tailwind/application.css || \
    echo "/* Copied from application.tailwind.css */" > app/assets/tailwind/application.css

# Precompile Rails assets using environment variables (Railway will provide SECRET_KEY_BASE)
# Skip CSS build since Tailwind is already built
RUN RAILS_ENV=production \
    OPENAI_API_KEY=dummy_key_for_precompile \
    SECRET_KEY_BASE=${SECRET_KEY_BASE:-5e92c23a402c53408ed1ed85c5597b965a6ca2c3916ee0cd68205e8a7066503194446603bcef60c0b78dcf3f0b14c1f4c693b3030a25ee469ed0eee275dcf157} \
    SKIP_CSS_BUILD=true \
    bundle exec rails assets:precompile

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
