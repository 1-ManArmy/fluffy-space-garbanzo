from fastapi import APIRouter, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from datetime import datetime

router = APIRouter()
templates = Jinja2Templates(directory="api/templates")

@router.get("/agents", response_class=HTMLResponse)
def index(request: Request):
    agents = [
        {
            "id": 1,
            "name": "Agent Smith",
            "agent_type": "multiverse",
            "tagline": "Your AI agent",
            "avatar_url": "",
            "status": "active",
            "personality_traits": ["intelligent", "helpful"],
            "capabilities": ["chat", "analyze"],
            "total_interactions": 100,
            "average_rating": 4.9,
            "last_active": datetime.utcnow().isoformat(),
            "preview_message": "Hello!"
        }
    ]
    return templates.TemplateResponse("agents/index.html", {"request": request, "agents": agents})
