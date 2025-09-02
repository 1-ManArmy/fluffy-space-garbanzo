# OneLastAI Credentials Setup Guide

## 🔐 Current Status
You have a `credentials_temp.yml` file with placeholder values that need to be properly configured for production.

## 🎯 Required API Keys & Credentials

### Essential Services
1. **OpenAI API Key** - For GPT models integration
2. **Hugging Face Token** - For model downloads and inference
3. **Database Credentials** - PostgreSQL connection
4. **Secret Key Base** - Rails application security

### Optional Services (for enhanced features)
- **Anthropic API Key** - For Claude models
- **Groq API Key** - For fast inference
- **Cohere API Key** - For embedding models
- **Redis Password** - If using Redis AUTH

## 🔧 Setup Options

### Option 1: Rails Encrypted Credentials (Recommended)
```powershell
# Edit encrypted credentials
rails credentials:edit

# Add this content:
# secret_key_base: <your-generated-key>
# 
# openai:
#   api_key: <your-openai-api-key>
# 
# huggingface:
#   token: <your-hf-token>
# 
# database:
#   username: onelastai
#   password: <your-db-password>
# 
# anthropic:
#   api_key: <your-anthropic-key>
# 
# groq:
#   api_key: <your-groq-key>
```

### Option 2: Environment Variables (.env file)
```bash
# Create .env file in project root
SECRET_KEY_BASE=<your-generated-key>
OPENAI_API_KEY=<your-openai-api-key>
HUGGINGFACE_TOKEN=<your-hf-token>
DATABASE_PASSWORD=<your-db-password>
ANTHROPIC_API_KEY=<your-anthropic-key>
GROQ_API_KEY=<your-groq-key>
```

### Option 3: Docker Environment (for containers)
```yaml
# In docker-compose.yml
environment:
  - SECRET_KEY_BASE=${SECRET_KEY_BASE}
  - OPENAI_API_KEY=${OPENAI_API_KEY}
  - HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN}
```

## 🔑 How to Get API Keys

### OpenAI API Key
1. Go to https://platform.openai.com/api-keys
2. Create new secret key
3. Copy the key (starts with `sk-`)

### Hugging Face Token
1. Go to https://huggingface.co/settings/tokens
2. Create new token with "Read" access
3. Copy the token (starts with `hf_`)

### Anthropic API Key (Optional)
1. Go to https://console.anthropic.com/
2. Create API key
3. Copy the key

### Groq API Key (Optional)
1. Go to https://console.groq.com/keys
2. Create new API key
3. Copy the key

## 🔒 Security Best Practices

### ✅ DO
- Use Rails encrypted credentials for production
- Keep `master.key` secure and never commit it
- Use environment variables for Docker deployments
- Rotate API keys regularly
- Use different keys for development/production

### ❌ DON'T
- Commit API keys to Git
- Share credentials in plain text
- Use production keys in development
- Store credentials in code files

## 🚀 Quick Setup Commands

### Generate New Secret Key Base
```powershell
rails secret
```

### Test Credentials Access
```ruby
# In Rails console
Rails.application.credentials.openai[:api_key]
Rails.application.credentials.secret_key_base
```

### Verify Environment Setup
```powershell
# Check environment variables
echo $env:OPENAI_API_KEY
echo $env:SECRET_KEY_BASE
```

## 🔧 Integration with OneLastAI

Your AI agents configuration will automatically use these credentials:

```yaml
# config/ai_agents.env references these
openai_api_key: <%= Rails.application.credentials.openai[:api_key] %>
huggingface_token: <%= Rails.application.credentials.huggingface[:token] %>
```

## 📋 Checklist

- [ ] Obtain OpenAI API key
- [ ] Get Hugging Face token
- [ ] Generate new secret_key_base
- [ ] Choose setup method (encrypted credentials recommended)
- [ ] Configure credentials
- [ ] Test API connectivity
- [ ] Update AI agents configuration
- [ ] Deploy with proper environment variables

## 🆘 Troubleshooting

### Rails Credentials Not Working
```powershell
# Set editor environment variable
$env:EDITOR = "code --wait"
rails credentials:edit
```

### Environment Variables Not Loading
```powershell
# Check if dotenv gem is installed
bundle list | grep dotenv

# Add to Gemfile if missing
gem 'dotenv-rails', groups: [:development, :test]
```

### API Key Validation
```ruby
# Test OpenAI connection
OpenAI::Client.new(access_token: "your-api-key").models.list
```

---
*Next step: Choose your preferred setup method and configure your API keys!*
