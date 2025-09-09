from fastapi import APIRouter, Request

router = APIRouter()

@router.get("/neochat")
def index():
    # Simulate NeoChat agent stats
    agent_stats = {
        "total_conversations": "0+",
        "average_rating": "4.9/5.0",
        "response_time": "< 1s"
    }
    return {"agent_stats": agent_stats}

@router.post("/neochat/chat")
def chat(request: Request):
    # Simulate chat response
    return {
        "success": True,
        "message": "Simulated NeoChat response"
    }
