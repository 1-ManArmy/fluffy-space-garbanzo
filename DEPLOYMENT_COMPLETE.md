# 🚀 OneLastAI Platform - Complete Deployment Guide

## 📋 **System Architecture Overview**

Your OneLastAI platform now includes:

### ✅ **Core Features Implemented:**
- **FastAPI Backend** - High-performance Python web framework
- **Real-time WebSockets** - Live agent performance monitoring
- **PostgreSQL Database** - Full relational database with async support
- **Keycloak Authentication** - Enterprise-grade identity management
- **Multi-Payment Integration** - Stripe, PayPal, Lemon Squeezy
- **Docker Containerization** - Ollama AI models pre-loaded
- **Nginx Reverse Proxy** - Production-ready web server
- **Vercel Deployment** - Serverless deployment ready

## 🏗️ **Architecture Components:**

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Nginx Proxy   │────│   FastAPI App    │────│   PostgreSQL    │
│   Port: 80/443  │    │   Port: 3000     │    │   Port: 5432    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                        │                        │
         │              ┌──────────────────┐              │
         │              │   Keycloak Auth  │              │
         │              │   Port: 8080     │              │
         │              └──────────────────┘              │
         │                        │                        │
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Ollama AI     │    │   Redis Cache    │    │   WebSocket     │
│   Port: 11434   │    │   Port: 6379     │    │   Real-time     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 🚀 **Quick Start (Local Development)**

### 1. **Prerequisites**
```bash
- Python 3.11+
- Docker & Docker Compose
- Git
- 8GB+ RAM (for AI models)
```

### 2. **Environment Setup**
```bash
# Clone and navigate
git clone https://github.com/agmgroups/fluffy-space-garbanzo.git
cd fluffy-space-garbanzo

# Create virtual environment
python -m venv .venv
.\.venv\Scripts\Activate.ps1  # Windows
# source .venv/bin/activate    # Linux/Mac

# Install dependencies
pip install -r api/requirements.txt
```

### 3. **Environment Configuration**
```bash
# Copy environment template
cp api/.env.example api/.env

# Edit api/.env with your configurations:
DATABASE_URL=postgresql+asyncpg://postgres:password@localhost:5432/onelastai_db
KEYCLOAK_CLIENT_SECRET=your-secret
STRIPE_SECRET_KEY=sk_test_your-key
# ... etc
```

### 4. **Start Development Server**
```bash
cd api
uvicorn main:app --reload --port 3000
```

**Access Points:**
- 🏠 **Main App**: http://localhost:3000
- 📚 **API Docs**: http://localhost:3000/docs
- 🔌 **WebSocket Test**: ws://localhost:3000/api/ws/global

## 🐳 **Docker Deployment (Full Stack)**

### 1. **Start All Services**
```bash
# Start complete infrastructure
docker-compose -f docker-compose.full.yml up -d

# Check status
docker-compose -f docker-compose.full.yml ps

# View logs
docker-compose -f docker-compose.full.yml logs -f app
```

### 2. **Service Access Points**
- 🌐 **Main Application**: http://localhost
- 📊 **API Documentation**: http://localhost/docs
- 🔐 **Keycloak Admin**: http://localhost:8080 (admin/admin123)
- 🤖 **Ollama API**: http://localhost:11434
- 🗄️ **PostgreSQL**: localhost:5432 (postgres/securepassword123)

## ☁️ **Vercel Deployment**

### 1. **Prepare for Vercel**
```bash
# Install Vercel CLI
npm i -g vercel

# Configure environment variables in Vercel dashboard:
DATABASE_URL=your-production-db-url
KEYCLOAK_URL=your-keycloak-url
STRIPE_SECRET_KEY=your-live-stripe-key
# ... etc
```

### 2. **Deploy to Vercel**
```bash
# Deploy
vercel

# Production deployment
vercel --prod
```

## 🔐 **Authentication Setup (Keycloak)**

### 1. **Keycloak Configuration**
1. Access Keycloak Admin: http://localhost:8080
2. Create realm: `onelastai`
3. Create client: `onelastai-app`
4. Configure client settings:
   - Client Protocol: `openid-connect`
   - Access Type: `confidential`
   - Valid Redirect URIs: `http://localhost:3000/*`

### 2. **Get Client Secret**
```bash
# Copy client secret from Keycloak admin panel
# Add to .env file: KEYCLOAK_CLIENT_SECRET=your-secret
```

## 💳 **Payment Integration Setup**

### 1. **Stripe Configuration**
```bash
# Get keys from Stripe Dashboard
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
```

### 2. **PayPal Configuration**
```bash
# Get credentials from PayPal Developer Console
PAYPAL_CLIENT_ID=your-client-id
PAYPAL_CLIENT_SECRET=your-client-secret
PAYPAL_MODE=sandbox  # or 'live' for production
```

### 3. **Lemon Squeezy Configuration**
```bash
# Get API key from Lemon Squeezy Dashboard
LEMON_SQUEEZY_API_KEY=your-api-key
LEMON_SQUEEZY_STORE_ID=your-store-id
```

## 🔌 **WebSocket Real-time Features**

### **Available WebSocket Endpoints:**
- `/api/ws/global` - Global system monitoring
- `/api/ws/{agent_name}` - Agent-specific monitoring
- `/api/ws/status` - Connection status (HTTP endpoint)

### **WebSocket Events:**
```javascript
// Connect to global monitoring
const ws = new WebSocket('ws://localhost:3000/api/ws/global');

// Listen for agent performance updates
ws.onmessage = (event) => {
    const data = JSON.parse(event.data);
    if (data.type === 'agent_performance') {
        console.log(`Agent ${data.agent}: CPU ${data.data.cpu_usage}%`);
    }
};

// Request all agents status
ws.send(JSON.stringify({
    type: 'get_all_agents'
}));
```

## 🤖 **AI Models (Ollama Integration)**

### **Pre-loaded Models in Docker:**
The Ollama service includes AI models in the `ollama_data` volume:
- **Chat Models**: llama2, mistral, codellama
- **Embedding Models**: nomic-embed-text
- **Code Models**: starcoder, codeup

### **Model Management:**
```bash
# List available models
curl http://localhost:11434/api/tags

# Pull new model
curl -X POST http://localhost:11434/api/pull -d '{"name": "llama2"}'

# Generate response
curl -X POST http://localhost:11434/api/generate -d '{
  "model": "llama2",
  "prompt": "Hello, AI!"
}'
```

## 📊 **Database Schema**

### **Main Tables:**
- `users` - User accounts and Keycloak integration
- `agents` - AI agent configurations
- `agent_interactions` - User-agent conversation logs
- `agent_performance` - Real-time performance metrics
- `payments` - Payment transactions and subscriptions

## 🔧 **API Endpoints Overview**

### **Authentication:**
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/auth/me` - Get current user

### **Payments:**
- `POST /api/create-payment` - Create payment intent
- `GET /api/plans` - Get subscription plans
- `GET /api/payments/history` - Payment history
- `POST /api/webhooks/{provider}` - Payment webhooks

### **Agents:**
- `GET /agents` - List all agents
- `GET /agents/{agent_name}` - Agent details
- `POST /api/agents/{agent_name}/interact` - Chat with agent

### **Real-time:**
- `WS /api/ws/global` - Global monitoring
- `WS /api/ws/{agent}` - Agent monitoring
- `GET /api/ws/status` - WebSocket status

## 📈 **Monitoring & Analytics**

### **Performance Metrics:**
- CPU usage per agent
- Memory consumption
- Response times
- Request rates
- Success/failure rates
- Active connections

### **Business Metrics:**
- User registrations
- Subscription conversions
- Payment transactions
- Agent usage patterns
- Feature adoption rates

## 🛠️ **Development Commands**

```bash
# Start development server
cd api && uvicorn main:app --reload --port 3000

# Run database migrations
alembic upgrade head

# Start background worker
celery -A services.celery_app worker --loglevel=info

# Run tests
pytest tests/

# Format code
black api/
isort api/

# Type checking
mypy api/
```

## 🚀 **Production Deployment Checklist**

### **Security:**
- [ ] Change default passwords
- [ ] Configure SSL certificates
- [ ] Set up firewall rules
- [ ] Enable rate limiting
- [ ] Configure CORS properly

### **Performance:**
- [ ] Set up database connection pooling
- [ ] Configure Redis caching
- [ ] Optimize Nginx settings
- [ ] Set up CDN for static assets
- [ ] Enable Gzip compression

### **Monitoring:**
- [ ] Set up logging aggregation
- [ ] Configure health checks
- [ ] Set up alerts and notifications
- [ ] Monitor resource usage
- [ ] Track performance metrics

### **Backup & Recovery:**
- [ ] Database backup strategy
- [ ] File system backups
- [ ] Disaster recovery plan
- [ ] Data retention policies

---

**🎉 Your OneLastAI platform is now fully equipped with enterprise-grade features!**

**📞 Support:** For issues, check the logs or create an issue in the repository.
**📚 Documentation:** Full API docs available at `/docs` endpoint.
**🔄 Updates:** Pull latest changes with `git pull origin main`.
