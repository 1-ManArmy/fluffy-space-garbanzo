@echo off
echo ========================================
echo 🌐 Getting Ngrok Public URL
echo ========================================

echo.
echo Checking Ngrok status...

powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:4040/api/tunnels' -TimeoutSec 5; if ($response.tunnels.Count -gt 0) { $publicUrl = $response.tunnels[0].public_url; Write-Host '✅ Public URL Found:' -ForegroundColor Green; Write-Host $publicUrl -ForegroundColor Cyan; Write-Host ''; Write-Host 'Opening in browser...' -ForegroundColor Yellow; Start-Process $publicUrl } else { Write-Host '❌ No active tunnels found' -ForegroundColor Red } } catch { Write-Host '❌ Ngrok not running or API not accessible' -ForegroundColor Red; Write-Host 'Make sure to start ngrok first with: ngrok http 3000' -ForegroundColor Yellow }"

echo.
pause
