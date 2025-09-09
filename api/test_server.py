"""
Simple FastAPI test server for OneLastAI Platform
"""
from fastapi import FastAPI
from fastapi.responses import JSONResponse

# Create FastAPI app
app = FastAPI(
    title="OneLastAI Platform - Test Server",
    description="Testing FastAPI setup",
    version="1.0.0"
)

@app.get("/")
async def root():
    return {"message": "🚀 OneLastAI Platform is running!", "status": "healthy"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "message": "Server is running properly"}

@app.get("/api/test")
async def api_test():
    return {
        "message": "API is working",
        "features": [
            "FastAPI Backend",
            "WebSocket Support", 
            "PostgreSQL Database",
            "Keycloak Authentication",
            "Payment Processing",
            "AI Model Integration"
        ]
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=3000, reload=True)
