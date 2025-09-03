@echo off
echo Stopping any existing ngrok processes...
taskkill /f /im ngrok.exe 2>nul
timeout /t 3 /nobreak >nul

echo Starting ngrok tunnel for OneLastAI...
ngrok http 3000 --host-header=rewrite

pause
