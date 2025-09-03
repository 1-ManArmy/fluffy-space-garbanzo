@echo off
echo ========================================
echo 🔧 OneLastAI Platform Quick Tools
echo ========================================

echo.
echo Available Commands:
echo ========================================
echo 1. 🚀 Launch Platform       - .\launch-live.bat
echo 2. 📊 Check Status         - .\check-status.bat  
echo 3. 🛑 Shutdown Platform    - .\shutdown.bat
echo 4. 🔄 Restart Platform     - .\restart.bat
echo 5. 📱 Open App             - start http://localhost:3000
echo 6. 🌐 Check Ngrok URL      - .\get-ngrok-url.bat
echo 7. 📋 View Logs           - .\view-logs.bat
echo 8. 🐳 Docker Status       - docker ps
echo 9. 💾 Backup Data         - .\backup.bat
echo 0. ❌ Exit
echo ========================================

set /p choice="Enter your choice (0-9): "

if "%choice%"=="1" call launch-live.bat
if "%choice%"=="2" call check-status.bat
if "%choice%"=="3" call shutdown.bat
if "%choice%"=="4" call restart.bat
if "%choice%"=="5" start http://localhost:3000
if "%choice%"=="6" call get-ngrok-url.bat
if "%choice%"=="7" call view-logs.bat
if "%choice%"=="8" docker ps
if "%choice%"=="9" call backup.bat
if "%choice%"=="0" exit

echo.
echo Press any key to return to menu...
pause > nul
goto :eof
