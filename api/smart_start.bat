@echo off
echo ============================================
echo    OneLastAI Platform - Smart Startup
echo ============================================

cd /d "%~dp0"

echo 📦 Checking and installing dependencies...

rem Install basic FastAPI dependencies first
echo Installing core dependencies...
python -m pip install fastapi uvicorn jinja2 python-multipart aiofiles

rem Try to install WebSocket support
echo Installing WebSocket support...
python -m pip install websockets==12.0 wsproto httptools

rem Install database and other dependencies
echo Installing database support...
python -m pip install sqlalchemy asyncpg psycopg2-binary redis

rem Install authentication and payment dependencies
echo Installing auth and payment support...
python -m pip install python-jose[cryptography] stripe paypalrestsdk

echo.
echo ✅ Dependencies installation complete!
echo.

rem Try to start the full server first
echo 🚀 Attempting to start full OneLastAI server...
python -c "import main" 2>nul
if %errorlevel% == 0 (
    echo ✅ Full server ready - starting with all features...
    python -m uvicorn main:app --reload --port 3000 --host 0.0.0.0
) else (
    echo ⚠️ Full server has import issues - starting basic server...
    echo.
    echo 🌐 Basic server starting with core features...
    python basic_server.py
)

pause
