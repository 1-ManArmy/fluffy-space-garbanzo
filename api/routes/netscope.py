from fastapi import APIRouter, Request
from datetime import datetime
import random

router = APIRouter()

@router.get("/netscope")
def index():
    agent_stats = {
        "total_conversations": random.randint(156, 342),
        "average_rating": 4.8,
        "response_time": "< 2s",
        "specializations": ["Network Security", "Penetration Testing", "Threat Analysis"]
    }
    network_stats = {
        "active_connections": random.randint(23, 89),
        "monitored_hosts": random.randint(45, 156),
        "security_alerts": random.randint(0, 12),
        "bandwidth_usage": f"{random.randint(50, 95)}%",
        "last_scan_time": f"{random.randint(1, 15)} min ago"
    }
    return {"agent_stats": agent_stats, "network_stats": network_stats}

@router.post("/netscope/chat")
def chat(request: Request):
    return {
        "success": True,
        "message": "Simulated NetScope response",
        "processing_time": "1s",
        "timestamp": datetime.utcnow().strftime('%H:%M:%S')
    }
