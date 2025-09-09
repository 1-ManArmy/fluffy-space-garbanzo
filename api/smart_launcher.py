#!/usr/bin/env python3
"""
OneLastAI Platform - Smart Server Launcher
Handles dependency issues and starts appropriate server mode
"""

import subprocess
import sys
import os
from pathlib import Path

def install_package(package):
    """Install a package using pip"""
    try:
        subprocess.check_call([sys.executable, '-m', 'pip', 'install', package])
        return True
    except subprocess.CalledProcessError:
        return False

def check_import(module_name):
    """Check if a module can be imported"""
    try:
        __import__(module_name)
        return True
    except ImportError:
        return False

def install_dependencies():
    """Install required dependencies with error handling"""
    print("📦 Installing dependencies...")
    
    # Core dependencies - these are essential
    core_deps = [
        'fastapi',
        'uvicorn', 
        'jinja2',
        'python-multipart',
        'aiofiles'
    ]
    
    for dep in core_deps:
        if not check_import(dep.replace('-', '_')):
            print(f"Installing {dep}...")
            install_package(dep)
    
    # WebSocket support - try different approaches
    if not check_import('websockets'):
        print("Installing WebSocket support...")
        # Try different websocket packages
        for ws_pkg in ['websockets==12.0', 'websockets==11.0', 'websockets']:
            if install_package(ws_pkg):
                break
    
    # Optional dependencies - install if possible
    optional_deps = [
        'sqlalchemy',
        'asyncpg', 
        'redis',
        'python-jose[cryptography]',
        'stripe'
    ]
    
    for dep in optional_deps:
        if not check_import(dep.replace('-', '_').replace('[cryptography]', '')):
            print(f"Installing optional {dep}...")
            install_package(dep)

def start_server():
    """Start the appropriate server based on what's available"""
    print("🚀 Starting OneLastAI Platform...")
    
    # Change to script directory
    os.chdir(Path(__file__).parent)
    
    # Try to import main server
    try:
        import main
        print("✅ Full server available - starting with all features...")
        print("🌐 Server URL: http://localhost:3000")
        print("📚 API Docs: http://localhost:3000/docs")
        print("🔌 WebSocket: ws://localhost:3000/api/ws/global")
        
        # Start with uvicorn
        subprocess.run([
            sys.executable, '-m', 'uvicorn',
            'main:app',
            '--reload',
            '--port', '3000',
            '--host', '0.0.0.0'
        ])
        
    except ImportError as e:
        print(f"⚠️ Full server unavailable ({e})")
        print("🔧 Starting basic server mode...")
        
        # Check if basic server exists
        if os.path.exists('basic_server.py'):
            print("✅ Basic server available")
            print("🌐 Server URL: http://localhost:3000")
            print("📚 API Docs: http://localhost:3000/docs")
            
            subprocess.run([sys.executable, 'basic_server.py'])
        else:
            print("❌ No server available")
            return False
    
    return True

def main():
    """Main function"""
    print("=" * 60)
    print("🚀 OneLastAI Platform - Smart Launcher")
    print("=" * 60)
    
    try:
        # Install dependencies
        install_dependencies()
        
        print("\n" + "=" * 60)
        
        # Start server
        start_server()
        
    except KeyboardInterrupt:
        print("\n🛑 Startup cancelled by user")
    except Exception as e:
        print(f"❌ Startup failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
