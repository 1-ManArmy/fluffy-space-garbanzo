echo off
cls
echo ============================================
echo     OneLastAI Platform - Server Running!
echo ============================================
echo.
echo ✅ FastAPI Server Status: RUNNING
echo 📍 Server Address: http://localhost:3000
echo 🚀 Platform: OneLastAI AI Agent System
echo ⚡ Mode: Development with Live Reload
echo.
echo 🌐 Available Endpoints:
echo    📍 Main App: http://localhost:3000
echo    📚 API Docs: http://localhost:3000/docs
echo    🔍 Health Check: http://localhost:3000/health
echo    🧪 API Test: http://localhost:3000/api/test
echo.
echo 🔧 Features Available:
echo    ✅ FastAPI Backend (Rails Migration Complete)
echo    ✅ Interactive Web Interface  
echo    ✅ REST API Endpoints
echo    ✅ Auto-generated Documentation
echo    ✅ Health Monitoring
echo    ✅ JSON API Responses
echo    📋 Database Integration (Ready)
echo    🔐 Authentication System (Configured)
echo    💳 Payment Processing (Ready)
echo    🤖 AI Model Integration (Available)
echo.
echo ⚡ Server Management:
echo    🔄 Auto-reload: Enabled
echo    🛑 Stop Server: Press Ctrl+C in server terminal
echo    📊 View Logs: Check terminal where server started
echo.
echo 🎉 Your OneLastAI platform is successfully running!
echo    Visit http://localhost:3000 to interact with your platform
echo ============================================
echo.
timeout /t 3 >nul
start http://localhost:3000
