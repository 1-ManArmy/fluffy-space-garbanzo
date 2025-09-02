@echo off
echo Starting OneLastAI Rails Server...
echo.

REM Set environment variables
set RAILS_ENV=development
set SECRET_KEY_BASE=e8f9a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0
set DATABASE_URL=postgresql://onelastai_user:secure_password_123@localhost:5432/onelastai_development
set REDIS_URL=redis://localhost:6379/0

REM Clear any existing asset cache issues
echo Clearing asset cache...
if exist "tmp\cache\assets" (
    rmdir /s /q "tmp\cache\assets" 2>nul
)
mkdir "tmp\cache\assets" 2>nul

echo.
echo Environment configured. Starting Rails server on port 3000...
echo You can access the application at: http://localhost:3000
echo.

REM Start the Rails server
bundle exec rails server -p 3000

pause
