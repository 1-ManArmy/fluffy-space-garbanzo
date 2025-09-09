from fastapi import APIRouter, Request

router = APIRouter()

@router.get("/reportly")
def index():
    # Simulate agent stats
    agent_stats = {
        "total_conversations": 100,
        "average_rating": 4.8,
        "response_time": "< 2s",
        "specializations": ["BI", "Analytics"]
    }
    return {"agent_stats": agent_stats}

@router.post("/reportly/chat")
def chat(request: Request):
    # Simulate chat response
    return {
        "success": True,
        "message": "Simulated response",
        "processing_time": "1s"
    }
