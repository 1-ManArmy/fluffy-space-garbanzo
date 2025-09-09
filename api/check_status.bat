@echo off
echo ============================================
echo    OneLastAI Server Status Check
echo ============================================

echo 📊 Checking server status...
echo.

rem Test basic endpoint
echo 🌐 Testing main endpoint:
curl -s http://localhost:3000 2>nul
if %errorlevel% == 0 (
    echo ✅ Main endpoint is responding
) else (
    echo ❌ Main endpoint not responding
)

echo.
echo 📚 Testing API documentation:
curl -s http://localhost:3000/docs 2>nul
if %errorlevel% == 0 (
    echo ✅ API docs are available
) else (
    echo ❌ API docs not available  
)

echo.
echo 🔍 Testing health endpoint:
curl -s http://localhost:3000/health 2>nul
if %errorlevel% == 0 (
    echo ✅ Health check is working
) else (
    echo ❌ Health check not working
)

echo.
echo 🧪 Testing API endpoint:
curl -s http://localhost:3000/api/test 2>nul
if %errorlevel% == 0 (
    echo ✅ API test endpoint is working
) else (
    echo ❌ API test endpoint not working
)

echo.
echo ============================================
echo 🚀 OneLastAI Server Status Summary:
echo    📍 URL: http://localhost:3000
echo    📚 Docs: http://localhost:3000/docs
echo    🔌 WebSocket: ws://localhost:3000/api/ws/global
echo ============================================

pause
