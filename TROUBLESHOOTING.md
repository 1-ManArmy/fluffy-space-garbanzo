# Rails Server Troubleshooting Guide

## Current Issue: Sprockets Permission Error
The Rails server is failing due to Sprockets asset pipeline permission issues on Windows.

## Quick Solutions (Run these commands manually):

### Solution 1: Clear Cache and Start Simple
```powershell
# Clear asset cache
Remove-Item -Path "tmp\cache\assets" -Recurse -Force -ErrorAction SilentlyContinue

# Kill any existing Rails processes
Get-Process | Where-Object {$_.ProcessName -like "*ruby*"} | Stop-Process -Force

# Set environment variables
$env:RAILS_ENV='development'
$env:SECRET_KEY_BASE='e8f9a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0'
$env:DATABASE_URL='postgresql://onelastai_user:secure_password_123@localhost:5432/onelastai_development'
$env:REDIS_URL='redis://localhost:6379/0'

# Start Rails server
bundle exec rails server -p 3000
```

### Solution 2: Use Production Mode (No Asset Compilation)
```powershell
# Set environment for production
$env:RAILS_ENV='production'
$env:SECRET_KEY_BASE='e8f9a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0'
$env:DATABASE_URL='postgresql://onelastai_user:secure_password_123@localhost:5432/onelastai_production'
$env:REDIS_URL='redis://localhost:6379/0'

# Precompile assets once
bundle exec rails assets:precompile

# Start server
bundle exec rails server -p 3000
```

### Solution 3: Use Custom Simple Environment
```powershell
# Use the simple environment we created (no assets)
$env:RAILS_ENV='simple'
$env:SECRET_KEY_BASE='e8f9a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0'
$env:DATABASE_URL='postgresql://onelastai_user:secure_password_123@localhost:5432/onelastai_development'
$env:REDIS_URL='redis://localhost:6379/0'

bundle exec rails server -p 3000
```

## Verification Steps:
1. After starting the server, check: http://localhost:3000
2. Health check endpoint: http://localhost:3000/health (if available)
3. Check server logs for any remaining issues

## Database Status:
- ✅ PostgreSQL running: localhost:5432
- ✅ Redis running: localhost:6379  
- ✅ Database migrations completed
- ✅ All models and tables ready

## Common Issues:
1. **Permission Denied**: Run PowerShell as Administrator
2. **Port 3000 in use**: Kill process with `Get-Process | Where-Object {$_.ProcessName -like "*ruby*"} | Stop-Process -Force`
3. **Asset issues**: Use Solution 2 or 3 above

## Files Created:
- `config/environments/simple.rb` - Asset-free environment
- `start_simple.bat` - Windows batch starter
- `.ruby-version` - Ruby version specification

## Next Steps:
Once the server starts successfully:
1. Test basic functionality
2. Verify database connections
3. Check AI agent endpoints
4. Set up CSS/Tailwind if needed (npm install)
