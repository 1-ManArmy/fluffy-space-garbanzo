@echo off
echo ========================================
echo 📊 OneLastAI Platform Status Monitor
echo ========================================

echo.
echo 🐳 Docker Containers Status:
echo ========================================
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 🌐 Service Health Check:
echo ========================================

echo 📡 Checking Rails Server (Port 3000)...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:3000' -TimeoutSec 5 -UseBasicParsing; Write-Host '✅ Rails Server: ONLINE' -ForegroundColor Green } catch { Write-Host '❌ Rails Server: OFFLINE' -ForegroundColor Red }"

echo.
echo 🗄️ Checking PostgreSQL (Port 5432)...
powershell -Command "try { $connection = New-Object System.Net.Sockets.TcpClient; $connection.Connect('localhost', 5432); $connection.Close(); Write-Host '✅ PostgreSQL: ONLINE' -ForegroundColor Green } catch { Write-Host '❌ PostgreSQL: OFFLINE' -ForegroundColor Red }"

echo.
echo 📦 Checking Redis (Port 6379)...
powershell -Command "try { $connection = New-Object System.Net.Sockets.TcpClient; $connection.Connect('localhost', 6379); $connection.Close(); Write-Host '✅ Redis: ONLINE' -ForegroundColor Green } catch { Write-Host '❌ Redis: OFFLINE' -ForegroundColor Red }"

echo.
echo 🤖 AI Models Status:
echo ========================================
echo 🦙 Llama3.2 (Port 11434)...
powershell -Command "try { $connection = New-Object System.Net.Sockets.TcpClient; $connection.Connect('localhost', 11434); $connection.Close(); Write-Host '✅ Llama3.2: READY' -ForegroundColor Green } catch { Write-Host '❌ Llama3.2: OFFLINE' -ForegroundColor Red }"

echo 💎 Gemma2 (Port 11435)...
powershell -Command "try { $connection = New-Object System.Net.Sockets.TcpClient; $connection.Connect('localhost', 11435); $connection.Close(); Write-Host '✅ Gemma2: READY' -ForegroundColor Green } catch { Write-Host '❌ Gemma2: OFFLINE' -ForegroundColor Red }"

echo 🧠 Phi-4 (Port 11436)...
powershell -Command "try { $connection = New-Object System.Net.Sockets.TcpClient; $connection.Connect('localhost', 11436); $connection.Close(); Write-Host '✅ Phi-4: READY' -ForegroundColor Green } catch { Write-Host '❌ Phi-4: OFFLINE' -ForegroundColor Red }"

echo 🔍 DeepSeek (Port 11437)...
powershell -Command "try { $connection = New-Object System.Net.Sockets.TcpClient; $connection.Connect('localhost', 11437); $connection.Close(); Write-Host '✅ DeepSeek: READY' -ForegroundColor Green } catch { Write-Host '❌ DeepSeek: OFFLINE' -ForegroundColor Red }"

echo 🐭 SmolLM2 (Port 11438)...
powershell -Command "try { $connection = New-Object System.Net.Sockets.TcpClient; $connection.Connect('localhost', 11438); $connection.Close(); Write-Host '✅ SmolLM2: READY' -ForegroundColor Green } catch { Write-Host '❌ SmolLM2: OFFLINE' -ForegroundColor Red }"

echo 🌪️ Mistral (Port 11439)...
powershell -Command "try { $connection = New-Object System.Net.Sockets.TcpClient; $connection.Connect('localhost', 11439); $connection.Close(); Write-Host '✅ Mistral: READY' -ForegroundColor Green } catch { Write-Host '❌ Mistral: OFFLINE' -ForegroundColor Red }"

echo 🐹 TinyLlama (Port 11440)...
powershell -Command "try { $connection = New-Object System.Net.Sockets.TcpClient; $connection.Connect('localhost', 11440); $connection.Close(); Write-Host '✅ TinyLlama: READY' -ForegroundColor Green } catch { Write-Host '❌ TinyLlama: OFFLINE' -ForegroundColor Red }"

echo.
echo 🌍 Public Access Status:
echo ========================================
powershell -Command "try { $ngrok = Get-Process ngrok -ErrorAction Stop; Write-Host '✅ Ngrok: RUNNING (Check ngrok terminal for public URL)' -ForegroundColor Green } catch { Write-Host '❌ Ngrok: NOT RUNNING' -ForegroundColor Red }"

echo.
echo 📈 System Resources:
echo ========================================
powershell -Command "Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty LoadPercentage | ForEach-Object { Write-Host 'CPU Usage: ' $_'%' }"
powershell -Command "$memory = Get-WmiObject -Class Win32_OperatingSystem; $usedMemory = [math]::Round(($memory.TotalVisibleMemorySize - $memory.FreePhysicalMemory) / $memory.TotalVisibleMemorySize * 100, 2); Write-Host 'Memory Usage: ' $usedMemory'%'"

echo.
echo ========================================
echo 📊 Status Check Complete!
echo ========================================
pause
