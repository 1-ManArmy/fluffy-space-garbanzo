# PostgreSQL Migration Guide for OneLastAI

## Migration Overview

This document outlines the complete migration from MongoDB to PostgreSQL for the OneLastAI platform, including integration with Keycloak authentication and local AI models.

## 🎯 Migration Goals

1. **Database Migration**: MongoDB → PostgreSQL with data preservation
2. **Authentication**: Passage → Keycloak (Red Hat SSO)
3. **AI Models**: Integration of 7 quantized local models
4. **Payment Systems**: Maintain Stripe, Lemon Squeezy, PayPal
5. **Performance**: Improved query performance and ACID compliance

## 📋 Pre-Migration Checklist

- [ ] Backup all MongoDB data
- [ ] Ensure PostgreSQL 16+ is installed
- [ ] Configure Keycloak server
- [ ] Update environment variables
- [ ] Test local AI model endpoints
- [ ] Verify payment gateway configurations

## 🔧 Migration Steps

### Phase 1: Database Setup

```bash
# 1. Create PostgreSQL database
createdb onelastai_production

# 2. Run Rails migrations
rails db:create db:migrate

# 3. Verify schema
rails db:schema:dump
```

### Phase 2: Data Migration

```bash
# 1. Execute migration service
rails db:migrate_from_mongo

# 2. Verify data integrity
rails db:verify_migration

# 3. Create sample data (optional)
rails db:create_sample_data
```

### Phase 3: Authentication Setup

```bash
# 1. Start Keycloak server
docker-compose up -d keycloak

# 2. Configure Keycloak realm
# - Import realm configuration from config/keycloak/realm-export.json
# - Create client for OneLastAI web app
# - Configure user federation (if needed)

# 3. Update application configuration
# Set KEYCLOAK_CLIENT_SECRET and other auth variables
```

### Phase 4: AI Models Integration

```bash
# 1. Start AI models
docker-compose -f docker-compose.ai-models.yml up -d

# 2. Verify model endpoints
curl http://localhost:11434/api/tags  # Llama 3.2
curl http://localhost:11435/api/tags  # Gemma 3
# ... (check all 7 models)

# 3. Test LocalAiModelsService
rails console
> LocalAiModelsService.health_check_all
```

### Phase 5: Production Deployment

```bash
# 1. Update production environment
rails db:setup_postgresql_env

# 2. Deploy with Docker Compose
docker-compose -f docker-compose.production.yml up -d

# 3. Run production migrations
docker-compose exec app rails db:migrate

# 4. Verify all services
docker-compose ps
```

## 📊 New Database Schema

### Core Tables

| Table | Purpose | Key Features |
|-------|---------|-------------|
| `users` | User accounts with Keycloak integration | UUID primary keys, subscription tiers |
| `agents` | AI agent configurations | Subdomain routing, model preferences |
| `conversations` | Chat conversations | Full-text search, session tracking |
| `messages` | Individual messages | Token usage, processing time metrics |
| `subscriptions` | Payment subscriptions | Multi-provider support (Stripe, Lemon Squeezy, PayPal) |
| `usage_metrics` | Daily usage tracking | Per-user, per-agent analytics |
| `user_sessions` | Authentication sessions | Keycloak session integration |
| `api_keys` | API access management | Scoped permissions, rate limiting |
| `agent_interactions` | Interaction analytics | Performance monitoring, error tracking |
| `audit_logs` | Security and compliance | Action tracking, change history |

### Key Improvements

- **ACID Compliance**: Guaranteed data consistency
- **Foreign Key Constraints**: Referential integrity
- **Full-Text Search**: PostgreSQL's native search capabilities
- **JSON Support**: Flexible metadata and configuration storage
- **Performance Indexes**: Optimized for common query patterns
- **UUID Primary Keys**: Better for distributed systems

## 🔐 Authentication Architecture

### Keycloak Integration

```mermaid
graph LR
    A[User] --> B[OneLastAI Web App]
    B --> C[Keycloak Server]
    C --> D[JWT Token]
    D --> B
    B --> E[Agent Subdomain]
    E --> F[LocalAiModelsService]
```

### Key Features

- **Single Sign-On (SSO)**: Unified authentication across all agents
- **Role-Based Access Control**: Fine-grained permissions
- **JWT Tokens**: Stateless authentication
- **Agent Subdomain Security**: Keycloak-protected agent access
- **User Management**: Self-service password reset, profile management

## 🤖 AI Models Configuration

### Local Models (7 Total)

| Model | Quantization | Size | Endpoint | Use Case |
|-------|-------------|------|----------|----------|
| Llama 3.2 | IQ2_XXS/Q4_K_M | 3.21B | :11434 | General conversation |
| Gemma 3 QAT | Q4_0 | 3.88B | :11435 | Question answering |
| Phi-4 | IQ2_XXS/Q4_K_M | 14.66B | :11436 | Reasoning tasks |
| DeepSeek R1 Distill | IQ2_XXS/Q4_K_M | 8.03B | :11437 | Code analysis |
| GPT-OSS | - | Variable | :11438 | Open source alternative |
| SmolLM2 | IQ2_XXS/Q4_K_M | 361.82M | :11439 | Lightweight tasks |
| Mistral | IQ2_XXS/Q4_K_M | 7.25B | :11440 | Multilingual support |

### Load Balancing & Failover

```ruby
# LocalAiModelsService automatically handles:
# 1. Health checking of all models
# 2. Load balancing across available instances
# 3. Fallback to cloud models if local models fail
# 4. Agent-to-model routing based on preferences
```

## 💳 Payment Integration

### Supported Providers

- **Stripe**: Primary payment processor
- **Lemon Squeezy**: Alternative for digital products
- **PayPal**: Additional payment option

### Subscription Tiers

- **Free**: Basic access, limited usage
- **Pro**: Enhanced features, higher limits
- **Enterprise**: Full access, custom limits

## 🚀 Deployment Configuration

### Environment Variables

```bash
# Database
DATABASE_URL=postgresql://onelastai:password@postgres:5432/onelastai_production
DATABASE_HOST=postgres
DATABASE_PORT=5432
DATABASE_USERNAME=onelastai
DATABASE_PASSWORD=your_secure_password

# Authentication
KEYCLOAK_URL=http://keycloak:8080
KEYCLOAK_REALM=onelastai
KEYCLOAK_CLIENT_ID=onelastai-web
KEYCLOAK_CLIENT_SECRET=your_client_secret
KEYCLOAK_ADMIN_PASSWORD=admin_password

# AI Models
LOCAL_AI_MODELS_ENABLED=true
FALLBACK_TO_CLOUD=true

# Payment
STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_SECRET_KEY=sk_live_...
LEMON_SQUEEZY_API_KEY=...
PAYPAL_CLIENT_ID=...
```

### Docker Services

```yaml
services:
  - app: Rails application
  - postgres: PostgreSQL database
  - keycloak: Authentication server
  - redis: Caching and sessions
  - nginx: Reverse proxy
  - llama32: Local AI model
  - gemma3: Local AI model
  - phi4: Local AI model
  - deepseek: Local AI model
  - gptoss: Local AI model
  - smollm2: Local AI model
  - mistral: Local AI model
```

## 📈 Performance Monitoring

### Key Metrics

- **Response Time**: Average AI model response time
- **Token Usage**: Per-user, per-model token consumption
- **Error Rate**: Failed requests and model availability
- **User Engagement**: Conversation length and frequency
- **Resource Utilization**: CPU, memory, and storage usage

### Monitoring Tools

- **Prometheus**: Metrics collection
- **Grafana**: Visualization dashboards
- **PostgreSQL Stats**: Query performance monitoring
- **Application Logs**: Structured logging with JSON format

## 🔧 Troubleshooting

### Common Issues

1. **Migration Fails**
   - Check MongoDB connection
   - Verify PostgreSQL permissions
   - Review migration logs

2. **Keycloak Authentication Issues**
   - Verify realm configuration
   - Check client secret
   - Confirm network connectivity

3. **AI Model Unavailable**
   - Check Docker container status
   - Verify model endpoints
   - Review Ollama logs

4. **Performance Issues**
   - Monitor database query performance
   - Check AI model response times
   - Verify resource allocation

### Debug Commands

```bash
# Check database connectivity
rails db:migrate:status

# Verify Keycloak integration
rails console > KeycloakAuthService.health_check

# Test AI models
rails console > LocalAiModelsService.health_check_all

# Monitor logs
docker-compose logs -f app
docker-compose logs -f keycloak
docker-compose logs -f llama32
```

## 📚 Additional Resources

- [PostgreSQL Documentation](https://postgresql.org/docs/)
- [Keycloak Administration Guide](https://www.keycloak.org/documentation)
- [Ollama Model Documentation](https://ollama.ai/library)
- [Rails Active Record Guide](https://guides.rubyonrails.org/active_record_basics.html)

## ✅ Post-Migration Verification

1. **Data Integrity**: All users, conversations, and messages migrated
2. **Authentication**: Keycloak SSO working across all agents
3. **AI Models**: All 7 local models responding correctly
4. **Payment Processing**: Stripe, Lemon Squeezy, PayPal functional
5. **Performance**: Query response times within acceptable limits
6. **Security**: Audit logs capturing all critical actions
7. **Monitoring**: Prometheus and Grafana dashboards operational

---

**Migration Status**: Ready for execution
**Estimated Downtime**: 2-4 hours (depending on data volume)
**Rollback Plan**: MongoDB backup restoration available
