@echo off
echo.
echo ======================================
echo   OneLastAI - Enterprise AI Platform
echo ======================================
echo.

echo Starting PostgreSQL and Redis...
docker-compose up -d postgres redis

echo.
echo Starting AI Models (this may take 5-10 minutes)...
docker-compose -f docker-compose.ai-models.yml up -d

echo.
echo Starting Rails Server...
echo.
echo Your OneLastAI platform will be available at:
echo http://localhost:3000
echo.

rails server
