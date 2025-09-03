@echo off
echo ========================================
echo 🛑 OneLastAI Platform Shutdown
echo ========================================

echo.
echo 📋 Stopping Rails Server...
taskkill /f /im ruby.exe 2>nul
taskkill /f /im rails.exe 2>nul

echo.
echo 🌍 Stopping Ngrok...
taskkill /f /im ngrok.exe 2>nul

echo.
echo 🐳 Stopping Docker Containers...
docker-compose down

echo.
echo 🧹 Cleaning up Docker volumes (optional)...
set /p cleanup="Clean up Docker volumes? (y/N): "
if /i "%cleanup%"=="y" (
    docker volume prune -f
    echo ✅ Docker volumes cleaned
) else (
    echo ⏭️ Docker volumes preserved
)

echo.
echo ========================================
echo ✅ OneLastAI Platform Shutdown Complete!
echo ========================================
echo.
echo All services stopped and resources freed.
pause
