# 🤖 OneLastAI - Enterprise AI Agent Network Platform

<div align="center">

![OneLastAI Logo](https://img.shields.io/badge/OneLastAI-Enterprise%20Platform-blue?style=for-the-badge&logo=robot)
[![Ruby Version](https://img.shields.io/badge/Ruby-3.3.0-red?style=flat-square&logo=ruby)](https://www.ruby-lang.org/)
[![Rails Version](https://img.shields.io/badge/Rails-7.1.3-red?style=flat-square&logo=rubyonrails)](https://rubyonrails.org/)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen?style=flat-square)](https://github.com/1-ManArmy/fluffy-space-garbanzo)

**The Ultimate AI Agent Network - 24 Specialized AI Agents in One Powerful Platform**

[🚀 Live Demo](https://onelastai.com) • [📖 Documentation](docs/) • [🛠️ API Reference](docs/api.md) • [💬 Community](https://github.com/1-ManArmy/fluffy-space-garbanzo/discussions)

</div>

---

## ✨ **Platform Overview**

OneLastAI is an enterprise-grade AI agent network that brings together 24 specialized AI agents, each designed for specific use cases. From creative content generation to business intelligence, our platform provides everything you need for AI-powered productivity.

### 🎯 **Key Features**

- **24 Specialized AI Agents** - Each with unique capabilities and personalities
- **Enterprise Authentication** - Passwordless auth powered by Passage & 1Password
- **Multi-Payment Gateway** - Stripe, PayPal, and Lemon Squeezy support
- **Creative AI Integration** - RunwayML for video/image generation
- **Production Infrastructure** - MongoDB Atlas, AWS EC2, Docker orchestration
- **Real-time Monitoring** - Health checks, analytics, and error tracking
- **API-First Design** - RESTful APIs for all platform features

---

## 🤖 **AI Agent Network**

<table>
  <tr>
    <td align="center"><strong>🌌 Conversation</strong></td>
    <td align="center"><strong>💻 Technical</strong></td>
    <td align="center"><strong>🎨 Creative</strong></td>
    <td align="center"><strong>📊 Business</strong></td>
  </tr>
  <tr>
    <td>
      • 🔥 <strong>NeoChat</strong> - Advanced conversational AI<br>
      • 👥 <strong>PersonaX</strong> - Personality-driven chat<br>
      • 💕 <strong>Girlfriend</strong> - Emotional companion<br>
      • 🧘 <strong>EmotiSense</strong> - Emotion analysis<br>
      • 📞 <strong>CallGhost</strong> - Voice interactions<br>
      • 🌌 <strong>Memora</strong> - Memory-enhanced AI
    </td>
    <td>
      • 💻 <strong>ConfigAI</strong> - Technical configuration<br>
      • 🔍 <strong>InfoSeek</strong> - Research & analysis<br>
      • 📚 <strong>DocuMind</strong> - Document processing<br>
      • 🌐 <strong>NetScope</strong> - Network analysis<br>
      • 🔒 <strong>AuthWise</strong> - Security consulting<br>
      • 🕵️ <strong>SpyLens</strong> - Data investigation
    </td>
    <td>
      • 🎬 <strong>CineGen</strong> - Video production<br>
      • 🌌 <strong>ContentCrafter</strong> - Content creation<br>
      • 🌟 <strong>DreamWeaver</strong> - Creative ideation<br>
      • 💡 <strong>IdeaForge</strong> - Innovation catalyst<br>
      • 📝 <strong>AIBlogster</strong> - Blog generation<br>
      • 🗣️ <strong>VocaMind</strong> - Voice synthesis
    </td>
    <td>
      • 📊 <strong>DataSphere</strong> - Data analytics<br>
      • 📈 <strong>DataVision</strong> - Business intelligence<br>
      • 📋 <strong>TaskMaster</strong> - Project management<br>
      • 📑 <strong>Reportly</strong> - Report generation<br>
      • 🧬 <strong>DNAForge</strong> - Growth optimization<br>
      • ⚕️ <strong>CareBot</strong> - Health insights
    </td>
  </tr>
</table>

---

## 🚀 **Quick Start**

### **Prerequisites**

- Ruby 3.3.0+
- Node.js 18+
- MongoDB Atlas account
- Redis 6+ (optional, for caching)

### **1. Clone & Setup**

```bash
# Clone the repository
git clone https://github.com/1-ManArmy/fluffy-space-garbanzo.git
cd fluffy-space-garbanzo

# Make setup script executable
chmod +x setup.sh

# Run automated setup
./setup.sh
```

### **2. Environment Configuration**

```bash
# Copy environment template
cp .env.example .env

# Edit .env and add your API keys
nano .env
```

**Required API Keys:**
```bash
# AI Services (choose at least one)
OPENAI_API_KEY=sk-...                    # OpenAI GPT models
ANTHROPIC_API_KEY=sk-ant-...             # Claude models
RUNWAYML_API_KEY=...                     # Creative AI
GOOGLE_AI_API_KEY=...                    # Gemini models

# Database & Infrastructure
MONGODB_URI=mongodb+srv://...            # MongoDB Atlas
AWS_ACCESS_KEY_ID=...                    # AWS services
AWS_SECRET_ACCESS_KEY=...                # AWS services

# Authentication
PASSAGE_APP_ID=...                       # Passage auth
PASSAGE_API_KEY=...                      # Passage auth

# Payment Processing (optional)
STRIPE_SECRET_KEY=sk_live_...            # Stripe payments
PAYPAL_CLIENT_ID=...                     # PayPal payments
```

### **3. Launch Application**

```bash
# Development mode
bundle exec rails server

# Production mode
RAILS_ENV=production bundle exec rails server

# Docker deployment
docker-compose up -d
```

🎉 **Your platform is now running at http://localhost:3000**

---

## 🏗️ **Enterprise Infrastructure**

### **Cloud Architecture**

- **Database**: MongoDB Atlas with automatic backups
- **Compute**: AWS EC2 with auto-scaling groups
- **Storage**: AWS S3 with CloudFront CDN
- **Caching**: Redis for sessions and data caching
- **Monitoring**: New Relic, Sentry error tracking
- **Security**: Passage authentication, 1Password integration

### **Payment Processing**

```ruby
# Multi-provider payment support
payment_service = PaymentService.new(provider: :stripe)
result = payment_service.process_payment(29.99, currency: 'usd')

# Subscription management
subscription = payment_service.create_subscription(customer_id, plan_id)
```

### **AI Service Integration**

```ruby
# Universal AI service
ai_service = BaseAiService.new(provider: :openai, model: 'gpt-4')
response = ai_service.complete("Analyze this business data...")

# Creative AI with RunwayML
runway = BaseAiService.new(provider: :runwayml)
video_url = runway.generate_video("A sunset over mountains", duration: 10)
```

---

## 📊 **API Documentation**

### **Authentication**

All API requests require authentication via Passage tokens:

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://api.onelastai.com/v1/agents
```

### **Core Endpoints**

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/agents` | GET | List all available agents |
| `/api/v1/agents/{id}/chat` | POST | Chat with specific agent |
| `/api/v1/users/profile` | GET | Get user profile |
| `/api/v1/health` | GET | System health check |

### **Agent Interaction**

```bash
# Chat with NeoChat agent
curl -X POST https://api.onelastai.com/v1/agents/neochat/chat \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Help me plan a marketing strategy",
    "context": "SaaS startup, B2B focus"
  }'
```

---

## 🔧 **Development**

### **Project Structure**

```
├── app/
│   ├── controllers/         # Agent controllers
│   ├── services/           # AI service integrations
│   │   ├── agents/         # Individual agent engines
│   │   ├── payment_service.rb
│   │   └── passage_auth_service.rb
│   └── views/              # Agent interfaces
├── config/
│   ├── mongoid.yml         # MongoDB configuration
│   ├── routes.rb           # Application routes
│   └── nginx/              # Production web server
├── docker-compose.yml      # Multi-service orchestration
├── setup.sh               # Automated setup script
└── DEPLOYMENT.md          # Deployment guide
```

### **Adding New Agents**

1. **Create Agent Engine**:
```ruby
# app/services/agents/your_agent_engine.rb
class YourAgentEngine < BaseAgentEngine
  def initialize
    super(
      name: "YourAgent",
      description: "Your agent description",
      capabilities: ["capability1", "capability2"]
    )
  end

  def process_message(message, context = {})
    # Your agent logic here
  end
end
```

2. **Create Controller**:
```ruby
# app/controllers/your_agent_controller.rb
class YourAgentController < ApplicationController
  def index
    @agent = YourAgentEngine.new
  end
end
```

3. **Add Routes**:
```ruby
# config/routes.rb
get '/your-agent', to: 'your_agent#index'
```

### **Testing**

```bash
# Run test suite
bundle exec rspec

# Run specific agent tests
bundle exec rspec spec/services/agents/

# Integration tests
bundle exec rspec spec/controllers/
```

---

## 🚀 **Deployment**

### **Docker Deployment (Recommended)**

```bash
# Build and deploy with Docker Compose
docker-compose up -d

# Scale services
docker-compose up -d --scale web=3
```

### **AWS EC2 Deployment**

```bash
# Production setup script
./setup.sh --production

# Manual deployment
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails assets:precompile
RAILS_ENV=production bundle exec rails server
```

### **Heroku Deployment**

```bash
# Deploy to Heroku
heroku create your-onelastai-app
git push heroku main
heroku run rails db:migrate
```

---

## 📈 **Monitoring & Analytics**

### **Health Monitoring**

- **System Health**: `/health` endpoint
- **Database**: `/health/database`
- **AI Services**: `/health/ai_services`
- **Redis**: `/health/redis`

### **Performance Metrics**

- **Response Times**: New Relic integration
- **Error Tracking**: Sentry monitoring
- **User Analytics**: Built-in dashboard
- **API Usage**: Rate limiting and tracking

---

## 🤝 **Contributing**

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md).

### **Development Setup**

```bash
# Fork the repository
git clone https://github.com/your-username/fluffy-space-garbanzo.git

# Create feature branch
git checkout -b feature/amazing-new-agent

# Make your changes and test
bundle exec rspec

# Submit pull request
git push origin feature/amazing-new-agent
```

---

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 **Acknowledgments**

- **OpenAI** - GPT model integration
- **Anthropic** - Claude model support
- **RunwayML** - Creative AI capabilities
- **Passage** - Authentication infrastructure
- **MongoDB** - Database platform
- **AWS** - Cloud infrastructure

---

## 📞 **Support**

- **Documentation**: [docs/](docs/)
- **Issues**: [GitHub Issues](https://github.com/1-ManArmy/fluffy-space-garbanzo/issues)
- **Discussions**: [GitHub Discussions](https://github.com/1-ManArmy/fluffy-space-garbanzo/discussions)
- **Email**: support@onelastai.com

---

<div align="center">

**Built with ❤️ by the OneLastAI Team**

[⭐ Star this repository](https://github.com/1-ManArmy/fluffy-space-garbanzo) if you find it helpful!

</div>b Codespaces ♥️ Ruby on Rails

Welcome to your shiny new Codespace running Rails! We've got everything fired up and running for you to explore Rails.

You've got a blank canvas to work on from a git perspective as well. There's a single initial commit with the what you're seeing right now - where you go from here is up to you!

Everything you do here is contained within this one codespace. There is no repository on GitHub yet. If and when you’re ready you can click "Publish Branch" and we’ll create your repository and push up your project. If you were just exploring then and have no further need for this code then you can simply delete your codespace and it's gone forever.
