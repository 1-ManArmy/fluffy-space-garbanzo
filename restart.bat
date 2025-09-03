@echo off
echo ========================================
echo 🔄 OneLastAI Platform Restart
echo ========================================

echo.
echo 🛑 Step 1: Shutting down current services...
call shutdown.bat

echo.
echo ⏳ Waiting for cleanup...
timeout /t 5 /nobreak

echo.
echo 🚀 Step 2: Starting platform...
call launch-live.bat

echo.
echo ========================================
echo ✅ Platform Restart Complete!
echo ========================================
