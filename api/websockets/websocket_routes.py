from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Query
from websockets.connection_manager import manager, performance_monitor
import json
import asyncio

router = APIRouter()

@router.websocket("/ws/{agent_name}")
async def websocket_agent_endpoint(websocket: WebSocket, agent_name: str):
    """WebSocket endpoint for specific agent monitoring"""
    await manager.connect(websocket, agent_name)
    
    # Send initial connection message
    await manager.send_personal_message(json.dumps({
        "type": "connection_established",
        "agent": agent_name,
        "message": f"Connected to {agent_name} performance monitoring"
    }), websocket)
    
    try:
        while True:
            # Wait for client messages
            data = await websocket.receive_text()
            client_message = json.loads(data)
            
            # Handle different message types
            if client_message.get("type") == "get_status":
                # Send current agent status
                status_message = json.dumps({
                    "type": "agent_status",
                    "agent": agent_name,
                    "status": "active",
                    "timestamp": performance_monitor.agent_stats.get(agent_name, {})
                })
                await manager.send_personal_message(status_message, websocket)
                
            elif client_message.get("type") == "start_monitoring":
                # Start performance monitoring if not already running
                if not performance_monitor.is_monitoring:
                    asyncio.create_task(performance_monitor.start_monitoring())
                
            elif client_message.get("type") == "agent_interaction":
                # Broadcast agent interaction to all connected clients
                interaction_message = json.dumps({
                    "type": "agent_interaction",
                    "agent": agent_name,
                    "data": client_message.get("data"),
                    "user": client_message.get("user", "anonymous"),
                    "timestamp": client_message.get("timestamp")
                })
                await manager.broadcast_to_agent(interaction_message, agent_name)
                
    except WebSocketDisconnect:
        manager.disconnect(websocket, agent_name)

@router.websocket("/ws/global")
async def websocket_global_endpoint(websocket: WebSocket):
    """WebSocket endpoint for global system monitoring"""
    await manager.connect(websocket)
    
    # Send initial connection message
    await manager.send_personal_message(json.dumps({
        "type": "global_connection_established",
        "message": "Connected to global system monitoring"
    }), websocket)
    
    try:
        while True:
            data = await websocket.receive_text()
            client_message = json.loads(data)
            
            if client_message.get("type") == "get_all_agents":
                # Send status of all agents
                all_agents_message = json.dumps({
                    "type": "all_agents_status",
                    "data": performance_monitor.agent_stats,
                    "active_connections": len(manager.active_connections)
                })
                await manager.send_personal_message(all_agents_message, websocket)
                
            elif client_message.get("type") == "broadcast_message":
                # Broadcast message to all connected clients
                broadcast_message = json.dumps({
                    "type": "global_broadcast",
                    "message": client_message.get("message"),
                    "from": client_message.get("from", "system")
                })
                await manager.broadcast_to_all(broadcast_message)
                
    except WebSocketDisconnect:
        manager.disconnect(websocket)

@router.get("/ws/status")
async def get_websocket_status():
    """Get current WebSocket connection status"""
    return {
        "total_connections": len(manager.active_connections),
        "agent_connections": {
            agent: len(connections) 
            for agent, connections in manager.agent_connections.items()
        },
        "monitoring_active": performance_monitor.is_monitoring
    }
