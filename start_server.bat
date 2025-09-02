@echo off
echo 🚀 Starting OneLastAI Rails Server...

REM Set environment
set RAILS_ENV=development
set NODE_ENV=development

REM Check database connection
echo 📊 Checking database connections...
docker ps | findstr postgres_quick
docker ps | findstr redis_quick

REM Start Rails server
echo 🌟 Starting Rails server on port 3000...
bundle exec rails server -p 3000 -b 0.0.0.0

pause
