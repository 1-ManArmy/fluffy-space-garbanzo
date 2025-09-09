from fastapi import WebSocket, WebSocketDisconnect
from typing import List, Dict
import json
import asyncio
import time
from datetime import datetime

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []
        self.agent_connections: Dict[str, List[WebSocket]] = {}

    async def connect(self, websocket: WebSocket, agent_name: str = None):
        await websocket.accept()
        self.active_connections.append(websocket)
        
        if agent_name:
            if agent_name not in self.agent_connections:
                self.agent_connections[agent_name] = []
            self.agent_connections[agent_name].append(websocket)

    def disconnect(self, websocket: WebSocket, agent_name: str = None):
        if websocket in self.active_connections:
            self.active_connections.remove(websocket)
        
        if agent_name and agent_name in self.agent_connections:
            if websocket in self.agent_connections[agent_name]:
                self.agent_connections[agent_name].remove(websocket)

    async def send_personal_message(self, message: str, websocket: WebSocket):
        try:
            await websocket.send_text(message)
        except:
            await self.disconnect_websocket(websocket)

    async def broadcast_to_agent(self, message: str, agent_name: str):
        if agent_name in self.agent_connections:
            disconnected = []
            for connection in self.agent_connections[agent_name]:
                try:
                    await connection.send_text(message)
                except:
                    disconnected.append(connection)
            
            # Clean up disconnected connections
            for conn in disconnected:
                self.disconnect(conn, agent_name)

    async def broadcast_to_all(self, message: str):
        disconnected = []
        for connection in self.active_connections:
            try:
                await connection.send_text(message)
            except:
                disconnected.append(connection)
        
        # Clean up disconnected connections
        for conn in disconnected:
            self.disconnect(conn)

    async def disconnect_websocket(self, websocket: WebSocket):
        # Remove from all connections
        if websocket in self.active_connections:
            self.active_connections.remove(websocket)
        
        # Remove from agent-specific connections
        for agent_name in self.agent_connections:
            if websocket in self.agent_connections[agent_name]:
                self.agent_connections[agent_name].remove(websocket)

# Global connection manager
manager = ConnectionManager()

# Agent performance monitoring
class AgentPerformanceMonitor:
    def __init__(self):
        self.agent_stats = {}
        self.is_monitoring = False

    async def start_monitoring(self):
        self.is_monitoring = True
        while self.is_monitoring:
            # Simulate agent performance data
            performance_data = await self.get_agent_performance()
            
            # Broadcast to all connected clients
            for agent_name, stats in performance_data.items():
                message = json.dumps({
                    "type": "agent_performance",
                    "agent": agent_name,
                    "data": stats,
                    "timestamp": datetime.now().isoformat()
                })
                await manager.broadcast_to_agent(message, agent_name)
            
            await asyncio.sleep(2)  # Update every 2 seconds

    async def get_agent_performance(self):
        """Simulate real-time agent performance metrics"""
        import random
        
        agents = [
            "aiblogster", "girlfriend", "taskmaster", "spylens", "reportly",
            "personax", "netscope", "neochat", "memora", "learn", "labx",
            "infoseek", "ideaforge", "tradesage", "vocamind"
        ]
        
        performance_data = {}
        for agent in agents:
            performance_data[agent] = {
                "cpu_usage": random.uniform(10, 90),
                "memory_usage": random.uniform(20, 85),
                "response_time": random.uniform(50, 500),
                "requests_per_minute": random.randint(10, 100),
                "success_rate": random.uniform(95, 99.9),
                "active_connections": random.randint(0, 50),
                "status": random.choice(["active", "busy", "idle"]),
                "last_activity": datetime.now().isoformat()
            }
        
        return performance_data

    def stop_monitoring(self):
        self.is_monitoring = False

# Global performance monitor
performance_monitor = AgentPerformanceMonitor()
