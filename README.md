# OneLastAI - FastAPI Backend

A modern AI agent platform built with FastAPI and Python, migrated from Ruby on Rails.

## 🚀 Features

- **45+ AI Agents** - Specialized agents for different tasks
- **FastAPI Backend** - High-performance Python web framework
- **Jinja2 Templates** - Modern templating engine
- **Static Assets** - CSS, JavaScript, and image resources
- **Agent Dashboard** - Manage and interact with AI agents
- **Admin Panel** - Administrative interface
- **API Endpoints** - RESTful API for all functionality

## 📁 Project Structure

```
api/
├── main.py              # FastAPI application entry point
├── routes/              # API endpoint handlers (converted from Rails controllers)
├── templates/           # Jinja2 HTML templates (converted from Rails views)
├── static/              # CSS, JS, and image assets
├── services/            # Business logic and AI agent engines
├── models/              # Data models
├── config/              # Configuration files
├── helpers/             # Helper functions
├── jobs/                # Background job handlers
├── mailers/             # Email functionality
└── channels/            # WebSocket/real-time features
```

## 🛠️ Installation

### Prerequisites
- Python 3.8 or higher
- pip (Python package installer)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/agmgroups/fluffy-space-garbanzo.git
   cd fluffy-space-garbanzo
   ```

2. **Create virtual environment**
   ```bash
   python -m venv .venv
   ```

3. **Activate virtual environment**
   
   **Windows:**
   ```bash
   .venv\Scripts\activate
   ```
   
   **macOS/Linux:**
   ```bash
   source .venv/bin/activate
   ```

4. **Install dependencies**
   ```bash
   pip install -r api/requirements.txt
   ```

5. **Run the application**
   ```bash
   cd api
   uvicorn main:app --reload --port 3000
   ```

6. **Open in browser**
   ```
   http://localhost:3000
   ```

## 📋 Dependencies

- **FastAPI** - Modern web framework for building APIs
- **Uvicorn** - ASGI web server implementation
- **Jinja2** - Templating engine for Python
- **Python-multipart** - Form data parsing
- **Additional packages** - See `api/requirements.txt`

## 🔧 Development

### Running in Development Mode
```bash
cd api
uvicorn main:app --reload --port 3000 --host 0.0.0.0
```

### Key Files
- `api/main.py` - Main FastAPI application
- `api/routes/` - All API endpoints
- `api/templates/` - HTML templates
- `api/static/` - Static assets (CSS, JS, images)

## 🚀 Deployment

This FastAPI application is compatible with:
- **Vercel** (primary deployment target)
- **Railway**
- **Render**
- **Heroku**
- **Any cloud provider supporting Python**

### Vercel Deployment
The project includes `vercel.json` configuration for easy deployment to Vercel.

## 🤖 AI Agents

The platform includes 45+ specialized AI agents:
- **AiBlogster** - Blog content generation
- **CodeMaster** - Code assistance
- **DataSphere** - Data analysis
- **GirlfriendAI** - Companion AI
- **And many more...**

## 📝 API Documentation

Once running, visit:
- **API Docs**: http://localhost:3000/docs
- **Alternative Docs**: http://localhost:3000/redoc

## 🔒 Environment Variables

Create a `.env` file in the `api/` directory:
```env
# Add your environment variables here
DATABASE_URL=your_database_url
SECRET_KEY=your_secret_key
```

## 🛠️ Migration Notes

This project was migrated from Ruby on Rails to FastAPI:
- ✅ All Rails controllers → FastAPI routes
- ✅ All ERB templates → Jinja2 HTML templates  
- ✅ All assets preserved and optimized
- ✅ All functionality maintained
- ✅ Modern Python architecture

## 📄 License

See LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📞 Support

For support and questions, please open an issue in the GitHub repository.

---

**Powered by FastAPI + Python** 🐍⚡
