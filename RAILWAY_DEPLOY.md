# OneLastAI - Railway Deployment Guide

## Quick Railway Setup

### 1. Install Railway CLI
```bash
npm install -g @railway/cli
```

### 2. Login to Railway
```bash
railway login
```

### 3. Initialize Railway Project
```bash
railway init
```

### 4. Add PostgreSQL Database
```bash
railway add --database postgresql
```

### 5. Deploy Application
```bash
railway up
```

### 6. Generate Domain
```bash
railway domain
```

## Environment Variables
Railway will automatically set:
- `DATABASE_URL` - PostgreSQL connection string
- `PORT` - Application port
- `RAILWAY_ENVIRONMENT` - Deployment environment

## Database Migration
After deployment, run:
```bash
railway run rails db:migrate
railway run rails db:seed
```

## Monitoring
- View logs: `railway logs`
- Check status: `railway status`
- Open app: `railway open`

## Custom Domain (Optional)
```bash
railway domain add yourdomain.com
```

Your OneLastAI platform will be available at: `https://your-app.railway.app`
