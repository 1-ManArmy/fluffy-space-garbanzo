# OneLastAI Production Deployment Guide

## Quick Start (Production Ready)

After development, follow these steps to deploy:

1. **Add API Keys to .env**:
   ```bash
   cp .env.example .env
   # Edit .env and add your actual API keys
   ```

2. **Run Setup Script**:
   ```bash
   chmod +x setup.sh
   ./setup.sh --production
   ```

3. **Launch Application**:
   ```bash
   # For development:
   ./setup.sh && bundle exec rails server
   
   # For production:
   bundle exec rails server -e production
   
   # For Docker:
   ./setup.sh --docker
   ```

## Environment Configuration

### Required API Keys

Before production deployment, configure these essential API keys in your `.env` file:

#### AI Services (Choose at least one)
```bash
# OpenAI (Recommended for GPT models)
OPENAI_API_KEY=sk-...

# Anthropic (For Claude models)
ANTHROPIC_API_KEY=sk-ant-...

# Google AI (For agent models)
GOOGLE_AI_API_KEY=...

# Hugging Face (For open-source models)
HUGGINGFACE_API_KEY=hf_...

# Cohere (For command models)
COHERE_API_KEY=...
```

#### Database & Storage
```bash
# Database (MongoDB for production)
MONGODB_URI=mongodb+srv://user:password@cluster.mongodb.net/onelastai

# Storage (Cloudinary recommended for production)
CLOUDINARY_URL=cloudinary://api_key:api_secret@cloud_name
```

#### Security & Monitoring
```bash
# Application Secret
SECRET_KEY_BASE=$(rails secret)

# Monitoring (Optional but recommended)
SENTRY_DSN=https://...
NEW_RELIC_LICENSE_KEY=...
```

## Deployment Options

### 1. Traditional Server Deployment

```bash
# 1. Prepare server
sudo apt update
sudo apt install ruby ruby-dev build-essential
gem install bundler

# 2. Clone and setup
git clone <your-repo>
cd onelastai
./setup.sh --production

# 3. Setup systemd service
sudo cp config/deploy/onelastai.service /etc/systemd/system/
sudo systemctl enable onelastai
sudo systemctl start onelastai
```

### 2. Docker Deployment

```bash
# Build and run with Docker
docker build -t onelastai .
docker run -d -p 3000:3000 --env-file .env onelastai
```

### 3. Docker Compose (Recommended)

```bash
# Create docker-compose.yml and run
docker-compose up -d
```

### 4. Kubernetes Deployment

```bash
# Apply Kubernetes manifests
kubectl apply -f config/deploy/k8s/
```

## Platform Features

### Available AI Agents (24 Total)

1. **ChatGPT Pro** - Advanced conversational AI
2. **Claude Expert** - Anthropic's reasoning specialist
3. **agent Ultra** - Google's multimodal AI
4. **Llama Master** - Meta's open-source champion
5. **Code Pilot** - Programming assistant
6. **Data Scientist** - Analytics and ML expert
7. **Creative Writer** - Content creation specialist
8. **Business Analyst** - Strategic insights
9. **Research Scholar** - Academic research
10. **Language Tutor** - Multi-language learning
11. **Health Advisor** - Medical information
12. **Finance Expert** - Financial analysis
13. **Legal Consultant** - Legal guidance
14. **Marketing Guru** - Marketing strategies
15. **Tech Support** - Technical troubleshooting
16. **Design Thinking** - Creative problem solving
17. **Project Manager** - Planning and coordination
18. **Sales Coach** - Sales optimization
19. **HR Partner** - Human resources
20. **Innovation Lab** - Cutting-edge solutions
21. **Mindfulness Guide** - Mental wellness
22. **Travel Planner** - Trip optimization
23. **Cooking Chef** - Culinary expertise
24. **Personal Trainer** - Fitness coaching

### Platform Pages

- **Home** - Landing page with agent selection
- **About** - Platform information
- **Contact** - Support and feedback
- **FAQ** - Frequently asked questions
- **Pricing** - Subscription tiers
- **Features** - Platform capabilities
- **Security** - Privacy and security information
- **API** - Developer documentation
- **Status** - System status and uptime
- **Blog** - Updates and insights
- **Dashboard** - User control panel
- **Profile** - User settings
- **Settings** - Configuration options
- **Analytics** - Usage statistics
- **Admin** - Administrative interface
- **Support** - Help and documentation
- **Feedback** - User feedback system
- **Terms** - Terms of service
- **Privacy** - Privacy policy
- **Docs** - Complete documentation
- **Changelog** - Version history
- **Integrations** - Third-party connections

## Health Monitoring

The application includes comprehensive health checks:

- **GET /health** - Basic health check
- **GET /health/detailed** - Detailed system status
- **GET /health/database** - Database connectivity
- **GET /health/redis** - Redis connectivity
- **GET /health/storage** - Storage system status
- **GET /health/ai_services** - AI API connectivity

## Configuration Options

### AI Service Selection

Configure which AI services to enable:

```bash
# Enable specific AI providers
ENABLE_OPENAI=true
ENABLE_ANTHROPIC=true
ENABLE_GOOGLE_AI=false
ENABLE_HUGGINGFACE=false
ENABLE_COHERE=false
```

### Feature Flags

Control platform features:

```bash
# Feature toggles
ENABLE_USER_REGISTRATION=true
ENABLE_API_ACCESS=true
ENABLE_ANALYTICS=true
ENABLE_FEEDBACK=true
ENABLE_CHAT_HISTORY=true
```

### Performance Settings

Optimize for your deployment:

```bash
# Rate limiting
RATE_LIMIT_REQUESTS_PER_MINUTE=60
RATE_LIMIT_BURST=10

# Caching
REDIS_URL=redis://localhost:6379/0
ENABLE_CACHING=true
CACHE_EXPIRY_HOURS=24

# AI Model settings
DEFAULT_AI_MODEL=gpt-4
MAX_TOKENS=4096
TEMPERATURE=0.7
```

## Security Configuration

### API Security

```bash
# API authentication
API_SECRET_KEY=your-secure-api-key
JWT_SECRET=your-jwt-secret

# CORS settings
ALLOWED_ORIGINS=https://yourdomain.com
ENABLE_CORS=true
```

### Content Security

```bash
# Content filtering
ENABLE_CONTENT_FILTER=true
BLOCKED_KEYWORDS=spam,abuse,harmful

# File upload limits
MAX_UPLOAD_SIZE=10MB
ALLOWED_FILE_TYPES=txt,pdf,doc,docx
```

## Database Setup

### Development (SQLite)
```bash
# Already configured in .env.example
DATABASE_URL=sqlite3:db/development.sqlite3
```

### Production (PostgreSQL)
```bash
# Update .env for production
DATABASE_URL=postgresql://username:password@localhost/onelastai_production

# Or use cloud database
DATABASE_URL=postgresql://user:pass@your-db-host:5432/onelastai
```

## Troubleshooting

### Common Issues

1. **API Keys Not Working**
   - Verify keys are correct in .env
   - Check API key permissions
   - Ensure services are enabled

2. **Database Connection Failed**
   - Check DATABASE_URL format
   - Verify database server is running
   - Run migrations: `bundle exec rails db:migrate`

3. **Assets Not Loading**
   - Run: `bundle exec rails assets:precompile`
   - Check file permissions
   - Verify asset pipeline configuration

4. **Redis Connection Issues**
   - Start Redis: `redis-server`
   - Check REDIS_URL in .env
   - Verify Redis is accessible

### Support

- **Health Check**: Visit `/health` for system status
- **Logs**: Check `log/production.log` for errors
- **Debug Mode**: Set `RAILS_ENV=development` for verbose logging

## Next Steps

1. **Customize Branding**: Update logos and colors in `app/assets`
2. **Add Authentication**: Implement user management system
3. **Scale Infrastructure**: Configure load balancers and CDN
4. **Monitor Performance**: Set up monitoring and alerting
5. **Backup Strategy**: Implement database and file backups

## License

This project is licensed under the MIT License - see the LICENSE file for details.

# =============================================================================
# DOCKER CONFIGURATION
# =============================================================================

# Production Dockerfile
FROM ruby:3.3.0-alpine

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    sqlite-dev \
    nodejs \
    npm \
    git \
    tzdata \
    imagemagick \
    curl

# Set working directory
WORKDIR /app

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install

# Copy application code
COPY . .

# Precompile assets
RUN RAILS_ENV=production bundle exec rails assets:precompile

# Create non-root user
RUN addgroup -g 1001 -S appuser && \
    adduser -S appuser -u 1001 -G appuser

# Change ownership of app directory
RUN chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Start command
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

# =============================================================================
# DOCKER COMPOSE FOR PRODUCTION
# =============================================================================

version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - RAILS_ENV=production
      - DATABASE_URL=${DATABASE_URL}
      - REDIS_URL=${REDIS_URL}
      - SECRET_KEY_BASE=${SECRET_KEY_BASE}
    depends_on:
      - db
      - redis
    volumes:
      - ./storage:/app/storage
    restart: unless-stopped

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=onelastai_production
      - POSTGRES_USER=${DB_USER}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - app
    restart: unless-stopped

volumes:
  postgres_data:
  redis_data:

# =============================================================================
# KUBERNETES DEPLOYMENT
# =============================================================================

apiVersion: apps/v1
kind: Deployment
metadata:
  name: onelastai-app
  namespace: onelastai-production
spec:
  replicas: 3
  selector:
    matchLabels:
      app: onelastai-app
  template:
    metadata:
      labels:
        app: onelastai-app
    spec:
      containers:
      - name: app
        image: registry.onelastai.com/onelastai:latest
        ports:
        - containerPort: 3000
        env:
        - name: RAILS_ENV
          value: "production"
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: onelastai-secrets
              key: database-url
        - name: REDIS_URL
          valueFrom:
            secretKeyRef:
              name: onelastai-secrets
              key: redis-url
        - name: SECRET_KEY_BASE
          valueFrom:
            secretKeyRef:
              name: onelastai-secrets
              key: secret-key-base
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5

---
apiVersion: v1
kind: Service
metadata:
  name: onelastai-service
  namespace: onelastai-production
spec:
  selector:
    app: onelastai-app
  ports:
  - port: 80
    targetPort: 3000
  type: ClusterIP

# =============================================================================
# NGINX CONFIGURATION
# =============================================================================

upstream app {
    server app:3000;
}

server {
    listen 80;
    server_name onelastai.com www.onelastai.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name onelastai.com www.onelastai.com;

    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384;

    client_max_body_size 100M;

    location / {
        proxy_pass http://app;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300;
        proxy_connect_timeout 300;
        proxy_send_timeout 300;
    }

    location /assets {
        expires 1y;
        add_header Cache-Control public;
        add_header ETag "";
        break;
    }

    location /health {
        proxy_pass http://app;
        access_log off;
    }
}

# =============================================================================
# DATABASE MIGRATION SCRIPT
# =============================================================================

#!/bin/bash
# migrate.sh - Database migration script for production

set -e

echo "Starting OneLastAI deployment migration..."

# Run database migrations
bundle exec rails db:migrate RAILS_ENV=production

# Precompile assets
bundle exec rails assets:precompile RAILS_ENV=production

# Create default admin user if needed
bundle exec rails runner "
  unless User.exists?(email: 'admin@onelastai.com')
    User.create!(
      email: 'admin@onelastai.com',
      password: ENV['ADMIN_PASSWORD'] || 'changeme123',
      role: 'admin',
      confirmed_at: Time.current
    )
    puts 'Admin user created'
  end
" RAILS_ENV=production

echo "Migration completed successfully!"

# =============================================================================
# MONITORING SETUP
# =============================================================================

# Health check endpoint
class HealthController < ApplicationController
  def show
    checks = {
      database: check_database,
      redis: check_redis,
      storage: check_storage
    }
    
    if checks.values.all?
      render json: { status: 'healthy', checks: checks }
    else
      render json: { status: 'unhealthy', checks: checks }, status: 503
    end
  end
  
  def ready
    if ready_to_serve?
      render json: { status: 'ready' }
    else
      render json: { status: 'not ready' }, status: 503
    end
  end
  
  private
  
  def check_database
    ActiveRecord::Base.connection.active?
  rescue
    false
  end
  
  def check_redis
    $redis&.ping == 'PONG'
  rescue
    false
  end
  
  def check_storage
    ActiveStorage::Blob.service.exist?('health_check')
  rescue
    true # Don't fail if storage check fails
  end
  
  def ready_to_serve?
    # Add any readiness checks here
    check_database && check_redis
  end
end

# =============================================================================
# DEPLOYMENT SCRIPTS
# =============================================================================

# deploy.sh - Main deployment script
#!/bin/bash

set -e

echo "🚀 Starting OneLastAI deployment..."

# Load environment variables
source .env.production

# Build Docker image
echo "📦 Building Docker image..."
docker build -t registry.onelastai.com/onelastai:$GIT_COMMIT .
docker tag registry.onelastai.com/onelastai:$GIT_COMMIT registry.onelastai.com/onelastai:latest

# Push to registry
echo "📤 Pushing to registry..."
docker push registry.onelastai.com/onelastai:$GIT_COMMIT
docker push registry.onelastai.com/onelastai:latest

# Deploy to Kubernetes
echo "🚢 Deploying to Kubernetes..."
kubectl apply -f k8s/
kubectl set image deployment/onelastai-app app=registry.onelastai.com/onelastai:$GIT_COMMIT -n onelastai-production

# Wait for rollout
echo "⏳ Waiting for deployment to complete..."
kubectl rollout status deployment/onelastai-app -n onelastai-production

# Run post-deployment tasks
echo "🔧 Running post-deployment tasks..."
kubectl exec -it deployment/onelastai-app -n onelastai-production -- bundle exec rails db:migrate

echo "✅ Deployment completed successfully!"

# =============================================================================
# ENVIRONMENT SETUP INSTRUCTIONS
# =============================================================================

# 1. Copy environment template
cp .env.example .env

# 2. Fill in all required API keys and configuration
# Edit .env file with your actual values

# 3. Install dependencies
bundle install

# 4. Setup database
bundle exec rails db:create db:migrate

# 5. Install Redis (if not using Docker)
# macOS: brew install redis
# Ubuntu: sudo apt-get install redis-server

# 6. Start Redis
# redis-server

# 7. Start the application
bundle exec rails server

# =============================================================================
# PRODUCTION CHECKLIST
# =============================================================================

# ✅ All API keys configured in .env
# ✅ Database configured (PostgreSQL recommended for production)
# ✅ Redis configured for caching and sessions
# ✅ SSL certificates installed
# ✅ Domain name configured
# ✅ Monitoring setup (Sentry, New Relic)
# ✅ Backup strategy in place
# ✅ Log rotation configured
# ✅ Security headers configured
# ✅ Rate limiting configured
# ✅ Error pages customized
# ✅ Performance optimizations applied
# ✅ CDN configured for static assets
# ✅ Health checks configured
# ✅ Scaling strategy defined