@echo off
echo ============================================
echo    OneLastAI FastAPI Server Startup
echo ============================================

cd /d "%~dp0"

echo 📦 Installing dependencies...
python -m pip install fastapi uvicorn[standard] sqlalchemy asyncpg redis python-jose[cryptography] python-multipart aiofiles jinja2 stripe paypalrestsdk requests

echo.
echo 🚀 Starting FastAPI server...
echo.
echo 🌐 Server will be available at:
echo    📍 Local: http://localhost:3000
echo    📚 API Docs: http://localhost:3000/docs  
echo    🔌 WebSocket: ws://localhost:3000/api/ws/global
echo.
echo ⚡ Press Ctrl+C to stop the server
echo --------------------------------------------

python -m uvicorn main:app --reload --port 3000 --host 0.0.0.0

pause
