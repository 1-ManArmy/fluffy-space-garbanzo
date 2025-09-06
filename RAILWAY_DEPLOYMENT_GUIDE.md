# 🚀 OneLastAI Railway Deployment Guide

## Pre-Deployment Checklist ✅

Before deploying to Railway, ensure you have:

- [ ] Railway CLI installed (`npm install -g @railway/cli`)
- [ ] Railway account created and logged in
- [ ] All environment variables ready
- [ ] Database migrations tested locally
- [ ] Assets building successfully

## Quick Deploy to Railway 🎯

### Step 1: Install Railway CLI
```bash
npm install -g @railway/cli
railway login
```

### Step 2: Initialize Project
```bash
railway init
```

### Step 3: Add Database
```bash
railway add postgresql
```

### Step 4: Set Environment Variables
```bash
# Essential production variables
railway variables set RAILS_ENV=production
railway variables set RAILS_SERVE_STATIC_FILES=true
railway variables set RAILS_LOG_TO_STDOUT=true
railway variables set NODE_ENV=production

# Generate secret key
railway variables set SECRET_KEY_BASE=$(openssl rand -hex 64)
```

### Step 5: Deploy
```bash
railway up
```

### Step 6: Run Database Migrations
```bash
railway run rails db:migrate
railway run rails db:seed
```

### Step 7: Generate Domain
```bash
railway domain
```

## Environment Variables Required 🔧

### Essential Variables (Railway Auto-Sets)
- `DATABASE_URL` - Automatically provided by Railway PostgreSQL
- `PORT` - Automatically set by Railway
- `RAILWAY_ENVIRONMENT` - Set by Railway

### Required Manual Setup
```bash
# Application Secret (Generate with: openssl rand -hex 64)
SECRET_KEY_BASE=your_64_character_secret_key

# AI API Keys (Add your actual keys)
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_AI_API_KEY=...
```

## Deployment Files Overview 📁

### Core Files
- `Procfile` - Defines web and release processes
- `railway.toml` - Railway-specific configuration
- `package.json` - Node.js dependencies for Tailwind
- `Gemfile` - Ruby dependencies

### Build Process
1. **Install Dependencies**: Ruby gems + Node.js packages
2. **Build Assets**: Tailwind CSS compilation
3. **Precompile**: Rails asset pipeline
4. **Release**: Database migrations

## Health Check 🏥

Railway will monitor your app at `/health` endpoint.

Test locally:
```bash
curl http://localhost:3000/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2024-01-01T00:00:00Z",
  "version": "OneLastAI",
  "environment": "production",
  "checks": {
    "database": true,
    "redis": true,
    "storage": true,
    "ai_apis": true
  }
}
```

## Troubleshooting 🔧

### Common Issues & Solutions

#### 1. Build Failures
```bash
# Check build logs
railway logs --deployment

# Common fix: Clear cache and redeploy
railway run rails tmp:clear
railway up
```

#### 2. Database Connection Issues
```bash
# Check database status
railway run rails db:version

# Reset database if needed
railway run rails db:drop db:create db:migrate db:seed
```

#### 3. Asset Compilation Errors
```bash
# Check if Tailwind builds locally
npm run build:css

# Precompile assets locally to test
RAILS_ENV=production bundle exec rails assets:precompile
```

#### 4. Environment Variable Issues
```bash
# List all variables
railway variables

# Set missing variables
railway variables set VARIABLE_NAME=value
```

### Debug Commands
```bash
# View logs
railway logs

# Check status
railway status

# Connect to Rails console
railway run rails console

# Run specific commands
railway run rails db:migrate:status
```

## Domain Configuration 🌐

### Custom Domain Setup
```bash
# Add your domain
railway domain add yourdomain.com

# Set up DNS records (A/CNAME)
# Point to your Railway app URL
```

### Subdomain Setup
```bash
# For agent subdomains (neochat.yourdomain.com)
# Add wildcard DNS: *.yourdomain.com -> Railway app
```

## Monitoring & Maintenance 📊

### Regular Tasks
```bash
# Update dependencies
railway run bundle update
railway run npm update

# Check application health
curl https://your-app.railway.app/health

# View recent logs
railway logs --tail
```

### Performance Monitoring
- Railway provides built-in metrics
- Monitor response times and error rates
- Set up alerts for downtime

## Scaling 📈

### Vertical Scaling
Railway automatically handles scaling based on:
- CPU usage
- Memory consumption
- Request volume

### Database Scaling
- Railway PostgreSQL auto-scales
- Monitor database performance in Railway dashboard

## Backup & Recovery 💾

### Database Backups
```bash
# Manual backup
railway run pg_dump $DATABASE_URL > backup.sql

# Restore from backup
railway run psql $DATABASE_URL < backup.sql
```

### Configuration Backup
```bash
# Export environment variables
railway variables > .env.production.backup
```

## Security Checklist 🔒

- [ ] Secret keys are properly generated and set
- [ ] No sensitive data in version control
- [ ] HTTPS is enforced (Railway default)
- [ ] CORS properly configured
- [ ] Environment variables secured

## Support 🆘

If deployment fails:
1. Check Railway logs: `railway logs`
2. Verify all environment variables are set
3. Test build process locally
4. Contact Railway support if needed

---

**Pro Tip**: Use `railway-deploy.sh` script for automated deployment!

```bash
./railway-deploy.sh
```

🎉 **Your OneLastAI platform will be live at**: `https://your-app.railway.app`
