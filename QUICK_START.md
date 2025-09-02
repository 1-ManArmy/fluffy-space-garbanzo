# OneLastAI Quick Start Guide

## 🚀 Current Status
✅ Database migration completed successfully
✅ PostgreSQL running in Docker (postgres_quick)
✅ Redis running in Docker (redis_quick)
✅ .ruby-version file created (3.4.0)
✅ CSS bundling gem reinstalled

## 📋 Manual Server Startup

### Step 1: Verify Database Containers
```bash
docker ps
# Should show postgres_quick and redis_quick running
```

### Step 2: Start Rails Server
```bash
# In the project directory:
bundle exec rails server -p 3000
```

### Step 3: Access Application
- Open browser to: http://localhost:3000
- Health check: http://localhost:3000/health

## 🔧 If Containers Stopped
```bash
# Restart PostgreSQL
docker start postgres_quick

# Restart Redis  
docker start redis_quick
```

## 🎨 CSS Bundling (Optional)
If Node.js is installed:
```bash
npm install
npm run build:css
```

## 📊 Database Info
- Host: localhost:5432
- Database: onelastai_production
- User: onelastai
- Password: secure123

## 🔴 Redis Info
- Host: localhost:6379
- No authentication required

## 🏗️ Architecture
```
OneLastAI Application
├── PostgreSQL (Docker) - Main database
├── Redis (Docker) - Cache & sessions
└── Rails App (Local) - Main application server
```

## 🚀 Production Deployment
Use docker-compose.simple.yml for production deployment with full Docker stack.
