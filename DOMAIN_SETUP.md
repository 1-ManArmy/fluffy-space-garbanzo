# OneLastAI Domain Configuration - onelastai.com

## Overview

This document outlines the complete setup and configuration for deploying OneLastAI to the `onelastai.com` domain. The platform includes 24 specialized AI agents accessible via subdomains.

## Domain Structure

### Primary Domains
- **Main Site**: `https://onelastai.com`
- **API**: `https://api.onelastai.com`
- **CDN**: `https://cdn.onelastai.com`
- **Monitoring**: `https://monitoring.onelastai.com`

### Agent Subdomains
Each AI agent is accessible via its own subdomain:

| Agent | Subdomain | Purpose |
|-------|-----------|---------|
| NeoChat | `neochat.onelastai.com` | Advanced conversational AI |
| EmotiSense | `emotisense.onelastai.com` | Emotion analysis and empathy |
| CineGen | `cinegen.onelastai.com` | Video generation and editing |
| ContentCrafter | `contentcrafter.onelastai.com` | Content creation and optimization |
| Memora | `memora.onelastai.com` | Memory and knowledge management |
| NetScope | `netscope.onelastai.com` | Network analysis and security |
| AIBlogster | `aiblogster.onelastai.com` | Blog and article generation |
| AuthWise | `authwise.onelastai.com` | Authentication and security |
| CallGhost | `callghost.onelastai.com` | Voice interaction system |
| CareBot | `carebot.onelastai.com` | Healthcare assistance |
| CodeMaster | `codemaster.onelastai.com` | Code generation and review |
| DataSphere | `datasphere.onelastai.com` | Data analysis and visualization |
| DataVision | `datavision.onelastai.com` | Business intelligence |
| DNAForge | `dnaforge.onelastai.com` | Bioinformatics and genetics |
| DocuMind | `documind.onelastai.com` | Document analysis |
| DreamWeaver | `dreamweaver.onelastai.com` | Creative content generation |
| Girlfriend | `girlfriend.onelastai.com` | Emotional companion AI |
| IdeaForge | `ideaforge.onelastai.com` | Innovation and brainstorming |
| InfoSeek | `infoseek.onelastai.com` | Information retrieval |
| LabX | `labx.onelastai.com` | Scientific research assistant |
| PersonaX | `personax.onelastai.com` | Personality-driven interactions |
| QuintExa | `quintexa.onelastai.com` | Advanced analytics |
| VirtualSpace | `virtualspace.onelastai.com` | Virtual environment creation |
| WorldForge | `worldforge.onelastai.com` | World-building and simulation |

## Infrastructure Setup

### 1. Domain and DNS Configuration

#### A Records
```
onelastai.com                → [SERVER_IP]
www.onelastai.com           → [SERVER_IP]
api.onelastai.com           → [SERVER_IP]
cdn.onelastai.com           → [CDN_IP]
monitoring.onelastai.com    → [SERVER_IP]
```

#### Wildcard Record
```
*.onelastai.com             → [SERVER_IP]
```

#### CNAME Records (if using CDN)
```
cdn.onelastai.com           → [CDN_DOMAIN]
```

### 2. SSL Certificate Requirements

#### Primary Certificate
- **Domain**: `onelastai.com`
- **SAN**: `www.onelastai.com`, `api.onelastai.com`

#### Wildcard Certificate
- **Domain**: `*.onelastai.com`
- **Purpose**: All agent subdomains

#### Let's Encrypt Setup
```bash
# Install certbot
sudo apt-get install certbot python3-certbot-nginx

# Generate main domain certificate
sudo certbot --nginx -d onelastai.com -d www.onelastai.com -d api.onelastai.com

# Generate wildcard certificate
sudo certbot certonly --manual --preferred-challenges=dns -d *.onelastai.com
```

### 3. NGINX Configuration

The NGINX configuration includes:
- HTTP to HTTPS redirect
- Subdomain routing
- Load balancing
- Rate limiting
- Security headers
- Static asset optimization

Key features:
- **Rate Limiting**: Different limits for API, agents, and general traffic
- **SSL Termination**: All traffic encrypted
- **WebSocket Support**: For real-time features
- **Compression**: Gzip enabled for all text content

### 4. Application Configuration

#### Environment Variables
Key environment variables for production:

```bash
# Core Settings
RAILS_ENV=production
DOMAIN_NAME=onelastai.com
PRODUCTION_HOST=onelastai.com
API_BASE_URL=https://api.onelastai.com
CDN_URL=https://cdn.onelastai.com

# Security
FORCE_SSL=true
SSL_REDIRECT=true
ALLOWED_HOSTS=onelastai.com,www.onelastai.com,api.onelastai.com,*.onelastai.com

# Database URLs
DATABASE_URL=postgresql://...
MONGODB_URI=mongodb://...
REDIS_URL=redis://...
```

#### Rails Configuration
- **Session cookies** configured for `.onelastai.com` domain
- **CORS** enabled for subdomain communication
- **Action Cable** configured for WebSocket connections
- **Security headers** via SecureHeaders gem

### 5. Database Setup

#### PostgreSQL (Primary)
```sql
CREATE DATABASE onelastai_production;
CREATE USER onelastai WITH PASSWORD 'secure_password';
GRANT ALL PRIVILEGES ON DATABASE onelastai_production TO onelastai;
```

#### MongoDB (AI Data)
```javascript
use onelastai_production
db.createUser({
  user: "onelastai",
  pwd: "secure_password",
  roles: [
    { role: "readWrite", db: "onelastai_production" }
  ]
})
```

#### Redis (Caching/Sessions)
```bash
# Configure in redis.conf
requirepass secure_redis_password
maxmemory 2gb
maxmemory-policy allkeys-lru
```

## Deployment Process

### 1. Automated Deployment

Use the provided deployment script:

```bash
# Basic deployment
./deploy_onelastai.sh

# With Let's Encrypt SSL
./deploy_onelastai.sh --letsencrypt

# With database seeding
./deploy_onelastai.sh --seed

# Full deployment with SSL and seeding
./deploy_onelastai.sh --letsencrypt --seed
```

### 2. Docker Deployment

For containerized deployment:

```bash
# Copy environment file
cp .env.example .env.production

# Edit environment variables
nano .env.production

# Deploy with Docker Compose
docker-compose -f docker-compose.production.yml up -d

# Check status
docker-compose -f docker-compose.production.yml ps
```

### 3. Manual Deployment Steps

If deploying manually:

1. **Prepare Server**:
   ```bash
   sudo apt-get update
   sudo apt-get install ruby nodejs postgresql mongodb redis-server nginx
   ```

2. **Clone Repository**:
   ```bash
   git clone https://github.com/1-ManArmy/fluffy-space-garbanzo.git /var/www/onelastai
   cd /var/www/onelastai
   git checkout domain-onelastai-setup
   ```

3. **Install Dependencies**:
   ```bash
   bundle install --deployment --without development test
   npm install --production
   ```

4. **Configure Environment**:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

5. **Setup Database**:
   ```bash
   RAILS_ENV=production bundle exec rails db:create db:migrate
   ```

6. **Compile Assets**:
   ```bash
   RAILS_ENV=production bundle exec rails assets:precompile
   ```

7. **Configure NGINX**:
   ```bash
   sudo cp config/nginx/onelastai.conf /etc/nginx/sites-available/
   sudo ln -s /etc/nginx/sites-available/onelastai.conf /etc/nginx/sites-enabled/
   sudo nginx -t && sudo systemctl reload nginx
   ```

8. **Start Application**:
   ```bash
   RAILS_ENV=production bundle exec rails server -p 3000 -d
   ```

## Monitoring and Maintenance

### Health Checks

The application includes health check endpoints:
- **Main**: `https://onelastai.com/health`
- **API**: `https://api.onelastai.com/health`
- **Agents**: `https://[agent].onelastai.com/health`

### Log Locations
- **Application**: `/var/log/onelastai/`
- **NGINX**: `/var/log/nginx/`
- **PostgreSQL**: `/var/log/postgresql/`
- **MongoDB**: `/var/log/mongodb/`

### Backup Strategy

Automated backups include:
- **Database dumps**: Daily PostgreSQL and MongoDB backups
- **Application files**: Weekly full backups
- **User uploads**: Daily incremental backups
- **Configuration**: Version controlled

### Performance Optimization

1. **Database Optimization**:
   - Connection pooling
   - Query optimization
   - Index optimization

2. **Caching**:
   - Redis for session storage
   - Application-level caching
   - CDN for static assets

3. **Asset Optimization**:
   - Gzip compression
   - Asset fingerprinting
   - CDN distribution

## Security Considerations

### SSL/TLS Configuration
- **TLS 1.2/1.3 only**
- **Strong cipher suites**
- **HSTS headers**
- **Certificate pinning**

### Application Security
- **Content Security Policy**
- **XSS protection**
- **CSRF protection**
- **Rate limiting**
- **Input validation**

### Infrastructure Security
- **Firewall configuration**
- **Regular security updates**
- **Access logging**
- **Intrusion detection**

## Troubleshooting

### Common Issues

1. **Subdomain Not Working**:
   - Check DNS propagation
   - Verify NGINX configuration
   - Check SSL certificate validity

2. **Database Connection Issues**:
   - Verify credentials in .env
   - Check database service status
   - Review connection limits

3. **SSL Certificate Problems**:
   - Check certificate expiration
   - Verify certificate chain
   - Review NGINX SSL configuration

### Debugging Tools

```bash
# Check NGINX configuration
sudo nginx -t

# Test SSL certificate
openssl s_client -connect onelastai.com:443 -servername onelastai.com

# Check application logs
tail -f /var/log/onelastai/production.log

# Monitor system resources
htop
```

## API Documentation

The OneLastAI API is available at `https://api.onelastai.com` with the following endpoints:

### Authentication
- `POST /api/auth/login`
- `POST /api/auth/logout`
- `POST /api/auth/refresh`

### Agents
- `GET /api/agents` - List all agents
- `POST /api/agents/{agent}/chat` - Chat with specific agent
- `GET /api/agents/{agent}/status` - Get agent status

### User Management
- `GET /api/user/profile`
- `PUT /api/user/profile`
- `GET /api/user/usage`

## Support and Maintenance

### Regular Maintenance Tasks

1. **Weekly**:
   - Review application logs
   - Check system resource usage
   - Verify backup integrity

2. **Monthly**:
   - Update dependencies
   - Review security patches
   - Performance optimization

3. **Quarterly**:
   - Security audit
   - Capacity planning
   - Disaster recovery testing

### Contact Information

For technical support or questions about the OneLastAI platform:
- **Email**: mail@onelastai.com
- **Documentation**: https://docs.onelastai.com
- **GitHub**: https://github.com/1-ManArmy/fluffy-space-garbanzo

---

*This documentation is maintained as part of the OneLastAI project. Last updated: August 2025*
