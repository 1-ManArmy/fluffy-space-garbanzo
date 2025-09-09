#!/usr/bin/env python3
"""
OneLastAI FastAPI Server Startup Script
Handles dependencies and starts the server properly
"""

import os
import sys
import subprocess
import time
from pathlib import Path

def check_dependencies():
    """Install missing dependencies if needed"""
    required_packages = [
        'fastapi',
        'uvicorn[standard]',
        'sqlalchemy',
        'asyncpg',
        'redis',
        'python-jose[cryptography]',
        'python-multipart',
        'aiofiles',
        'jinja2',
        'stripe',
        'paypalrestsdk', 
        'requests'
    ]
    
    print("📦 Checking dependencies...")
    
    missing = []
    for package in required_packages:
        try:
            __import__(package.replace('-', '_').replace('[cryptography]', '').replace('[standard]', ''))
        except ImportError:
            missing.append(package)
    
    if missing:
        print(f"Installing missing packages: {', '.join(missing)}")
        subprocess.run([
            sys.executable, '-m', 'pip', 'install'
        ] + missing, check=True)
        print("✅ Dependencies installed")
    else:
        print("✅ All dependencies satisfied")

def start_server():
    """Start the FastAPI server"""
    print("🚀 Starting OneLastAI FastAPI server...")
    
    # Change to the api directory
    api_dir = Path(__file__).parent
    os.chdir(api_dir)
    
    # Start uvicorn
    try:
        subprocess.run([
            sys.executable, '-m', 'uvicorn',
            'main:app',
            '--reload',
            '--port', '3000',
            '--host', '0.0.0.0'
        ], check=True)
    except KeyboardInterrupt:
        print("\n🛑 Server stopped by user")
    except Exception as e:
        print(f"❌ Server error: {e}")
        return False
    
    return True

def main():
    """Main startup function"""
    print("=" * 60)
    print("🚀 OneLastAI Platform - Server Startup")
    print("=" * 60)
    
    try:
        # Check and install dependencies
        check_dependencies()
        
        # Start server
        print("\n🌐 Server will be available at:")
        print("   📍 Local: http://localhost:3000")
        print("   📍 Network: http://0.0.0.0:3000")
        print("   📚 API Docs: http://localhost:3000/docs")
        print("   🔌 WebSocket Test: ws://localhost:3000/api/ws/global")
        print("\n⚡ Press Ctrl+C to stop the server")
        print("-" * 60)
        
        start_server()
        
    except Exception as e:
        print(f"❌ Startup failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
