# OneLastAI Local Development Configuration

## Overview

This document outlines the complete setup and configuration for running OneLastAI locally on `localhost`. The platform includes 24 specialized AI agents accessible via local ports.

## Local Development Structure

### Primary Services
- **Main Site**: `http://localhost:3000`
- **API**: `http://localhost:3000/api`
- **Admin Panel**: `http://localhost:3000/admin`
- **Monitoring**: `http://localhost:3001` (Grafana)

### Agent Routes
Each AI agent is accessible via local routes:

| Agent | Route | Purpose |
|-------|--------|---------|
| NeoChat | `localhost:3000/agents/neochat` | Advanced conversational AI |
| EmotiSense | `localhost:3000/agents/emotisense` | Emotion analysis and empathy |
| CineGen | `localhost:3000/agents/cinegen` | Video generation and editing |
| ContentCrafter | `localhost:3000/agents/contentcrafter` | Content creation and optimization |
| Memora | `localhost:3000/agents/memora` | Memory and knowledge management |
| NetScope | `localhost:3000/agents/netscope` | Network analysis and security |
| AIBlogster | `localhost:3000/agents/aiblogster` | Blog and article generation |
| AuthWise | `localhost:3000/agents/authwise` | Authentication and security |
| CallGhost | `localhost:3000/agents/callghost` | Voice interaction system |
| CareBot | `localhost:3000/agents/carebot` | Healthcare assistance |
| CodeMaster | `localhost:3000/agents/codemaster` | Code generation and review |
| DataSphere | `localhost:3000/agents/datasphere` | Data analysis and visualization |
| DataVision | `localhost:3000/agents/datavision` | Business intelligence |
| DNAForge | `localhost:3000/agents/dnaforge` | Bioinformatics and genetics |
| DocuMind | `localhost:3000/agents/documind` | Document analysis |
| DreamWeaver | `localhost:3000/agents/dreamweaver` | Creative content generation |
| Girlfriend | `localhost:3000/agents/girlfriend` | Emotional companion AI |
| IdeaForge | `localhost:3000/agents/ideaforge` | Innovation and brainstorming |
| InfoSeek | `localhost:3000/agents/infoseek` | Information retrieval |
| LabX | `localhost:3000/agents/labx` | Scientific research assistant |
| PersonaX | `localhost:3000/agents/personax` | Personality-driven interactions |
| QuintExa | `localhost:3000/agents/quintexa` | Advanced analytics |
| VirtualSpace | `localhost:3000/agents/virtualspace` | Virtual environment creation |
| WorldForge | `localhost:3000/agents/worldforge` | World-building and simulation |

## Local Development Setup

### 1. Prerequisites

Install the required dependencies:
```bash
# Ruby and Rails
ruby --version  # Should be 3.3.0
gem install bundler rails

# Node.js for asset compilation
node --version  # Should be 18+
npm --version

# PostgreSQL
# Windows: Download from postgresql.org
# macOS: brew install postgresql
# Linux: sudo apt-get install postgresql-15

# Redis (optional for caching)
# Windows: Download from redis.io
# macOS: brew install redis
# Linux: sudo apt-get install redis-server
```

### 2. Environment Configuration

Create your local environment file:

```bash
# Copy the example environment file
cp .env.example .env

# Edit with your local configuration
# Key settings for localhost:
RAILS_ENV=development
DOMAIN_NAME=localhost
DATABASE_URL=postgresql://onelastai:password@localhost:5432/onelastai_development
REDIS_URL=redis://localhost:6379/0
```

### 3. Database Setup

#### PostgreSQL Setup

```bash
# Create database and user
createdb onelastai_development
createuser -s onelastai

# Run migrations
rails db:create db:migrate db:seed
```

## Local Development Process

### 1. Quick Start

Run OneLastAI locally with these simple commands:

```bash
# Clone and setup
git clone https://github.com/1-ManArmy/fluffy-space-garbanzo.git
cd fluffy-space-garbanzo

# Install dependencies
bundle install
npm install

# Setup environment
cp .env.example .env
# Edit .env with your local settings

# Setup database
rails db:create db:migrate db:seed

# Start the server
rails server
# Visit http://localhost:3000
```

### 2. Docker Development

For a complete local environment with all services:

```bash
# Copy environment file
cp .env.example .env

# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f app
```

### 3. Development Tools

Access these tools during development:

- **Rails Console**: `rails console`
- **Database Console**: `rails dbconsole`
- **Logs**: `tail -f log/development.log`
- **Routes**: `rails routes`
- **Tests**: `rails test` or `rspec`

## Local Testing and Development

### Health Checks

The application includes health check endpoints:

- **Main**: `http://localhost:3000/health`
- **API**: `http://localhost:3000/api/health`
- **Agents**: `http://localhost:3000/agents/[agent]/health`

### Development Workflow

1. **Start Services**:
   ```bash
   # PostgreSQL
   brew services start postgresql  # macOS
   sudo systemctl start postgresql  # Linux
   
   # Redis (optional)
   brew services start redis  # macOS
   sudo systemctl start redis-server  # Linux
   
   # Rails server
   rails server
   ```

2. **Access the Application**:
   - Main site: `http://localhost:3000`
   - Admin panel: `http://localhost:3000/admin`
   - API documentation: `http://localhost:3000/api/docs`

3. **Database Management**:
   ```bash
   # Reset database
   rails db:drop db:create db:migrate db:seed
   
   # Generate new migration
   rails generate migration AddColumnToModel column:type
   
   # Run specific migration
   rails db:migrate:up VERSION=20240101000000
   ```

### Log Locations

During local development:

- **Application**: `log/development.log`
- **Rails Server**: Terminal output
- **PostgreSQL**: Check with `brew services list` or `systemctl status postgresql`
- **Redis**: Check with `brew services list` or `systemctl status redis-server`

### Development Tips

1. **Performance Optimization**:
   - Use `rails dev:cache` to toggle caching in development
   - Monitor database queries with the Rails logger
   - Use `bullet` gem to detect N+1 queries

2. **Asset Pipeline**:
   - Assets auto-compile in development mode
   - Use `rails assets:precompile` for production builds
   - Tailwind CSS automatically rebuilds on file changes

3. **Environment Variables**:
   - Use `dotenv-rails` for local environment management
   - Keep sensitive data out of version control
   - Use different .env files for different environments

## Development Security

### Local Security Considerations

- **Environment Variables**: Never commit `.env` files
- **Database**: Use development-specific credentials
- **HTTPS**: Not required for localhost development
- **CORS**: Configure for local development if using separate frontend
- **API Keys**: Use development/sandbox keys when possible

### Code Quality

```bash
# Run tests
rails test
# or
rspec

# Code linting
rubocop
rubocop -a  # Auto-fix issues

# Security scanning
bundle audit
```

## Troubleshooting

### Common Development Issues

1. **Server Won't Start**:
   - Check if port 3000 is in use: `lsof -i :3000`
   - Kill existing process: `kill -9 $(lsof -ti :3000)`
   - Check for syntax errors: `ruby -c config/application.rb`

2. **Database Connection Issues**:
   - Verify PostgreSQL is running: `brew services list` or `systemctl status postgresql`
   - Check credentials in `.env` file
   - Ensure database exists: `rails db:create`

3. **Asset Issues**:
   - Clear asset cache: `rails tmp:clear`
   - Recompile assets: `rails assets:clobber assets:precompile`
   - Check Tailwind build: `npm run build:css`

### Debugging Tools

```bash
# Check application status
rails runner "puts 'Rails app loaded successfully'"

# Test database connection
rails runner "puts User.count"

# Check environment
rails runner "puts Rails.env"

# View routes
rails routes | grep agent
```

## API Documentation

The OneLastAI API is available at `http://localhost:3000/api` with the following endpoints:

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

## Development Support

### Getting Help

For development questions and support:

- **Documentation**: Check the `docs/` directory
- **GitHub Issues**: Report bugs and feature requests
- **Local Testing**: Use `rails console` for interactive debugging
- **Development Tools**: Use Rails generators and built-in debugging tools

### Development Best Practices

1. **Daily Workflow**:
   - Pull latest changes: `git pull origin main`
   - Run migrations: `rails db:migrate`
   - Check test suite: `rails test`

2. **Code Quality**:
   - Write tests for new features
   - Follow Rails conventions
   - Use meaningful commit messages
   - Keep dependencies updated: `bundle update`

3. **Performance Monitoring**:
   - Monitor development logs for slow queries
   - Use Rails performance tools
   - Test with realistic data volumes

---

*This documentation is for local OneLastAI development. Last updated: September 2025*
