from fastapi import APIRouter, Request, status
from fastapi.responses import JSONResponse

router = APIRouter()

@router.get("/application/database_available")
def database_available():
    # Simulate database check
    return {"database_available": True}

@router.get("/application/fallback_agent")
def create_fallback_agent(agent_type: str, name: str):
    # Simulate fallback agent creation
    agent = {
        "agent_type": agent_type,
        "name": name,
        "tagline": "AI Agent",
        "description": "Advanced AI assistance",
        "use_case": "General AI assistance",
        "created_at": "2025-09-08T00:00:00Z",
        "updated_at": "2025-09-08T00:00:00Z",
        "id": f"fallback_{agent_type}",
        "persisted": False
    }
    return agent
