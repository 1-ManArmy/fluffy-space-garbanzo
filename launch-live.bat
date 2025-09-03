@echo off
echo ========================================
echo 🚀 OneLastAI Platform Live Launch
echo ========================================

echo.
echo 📋 Step 1: Starting Database Services...
docker-compose up -d db redis

echo.
echo ⏳ Waiting for databases to initialize...
timeout /t 10 /nobreak

echo.
echo 🤖 Step 2: Starting Web and Nginx Services...
docker-compose up -d web nginx

echo.
echo ⏳ Waiting for web and nginx to load...
timeout /t 15 /nobreak

echo.
echo 🌐 Step 3: Starting Rails Server...
start "Rails Server" cmd /k "rails server -p 3000 -b 0.0.0.0"

echo.
echo ⏳ Waiting for Rails to start...
timeout /t 5 /nobreak

echo.
echo 🌍 Step 4: Starting Ngrok for Public Access...
start "Ngrok Tunnel" cmd /k "ngrok http 3000"

echo.
echo ========================================
echo ✅ OneLastAI Platform Launch Complete!
echo ========================================
echo.
echo 🔗 Local Access: http://localhost:3000
echo 🌐 Public Access: Check ngrok terminal for URL
echo 📊 Docker Status: docker ps
echo.
echo Press any key to open browser...
pause > nul
start http://localhost:3000

echo.
echo Platform is now LIVE! 🎉
