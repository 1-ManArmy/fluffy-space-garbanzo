# 🚀 OneLastAI Quick Start Guide

## ⚡ Instant Setup (3 Steps)

### Step 1: Start Services
```powershell
# Start database and cache
docker-compose up -d postgres redis

# Start AI models (takes 5-10 minutes first time)
docker-compose -f docker-compose.ai-models.yml up -d
```

### Step 2: Start Rails
```powershell
# Start Rails server
rails server
```

### Step 3: Access Your Platform
- **Web App**: http://localhost:3000
- **Status**: All systems operational ✅

## 🔧 Troubleshooting

### Common Issues

**Rails won't start:**
```powershell
bundle install
rails db:create db:migrate
```

**Models not downloading:**
```powershell
docker-compose -f docker-compose.ai-models.yml logs
```

**Port conflicts:**
```powershell
rails server -p 3001
```

## 🎯 Next Steps

1. **Configure domain** - See DOMAIN_SETUP.md
2. **Add SSL certificate** - For production
3. **Monitor AI models** - Check http://localhost:11434

---

Your OneLastAI platform is ready! 🎉
