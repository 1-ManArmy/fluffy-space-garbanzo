#!/usr/bin/env python3
"""
OneLastAI Platform - System Status Check
Tests all components and verifies deployment readiness
"""

import os
import sys
import subprocess
import json
from pathlib import Path

def check_python_version():
    """Check Python version compatibility"""
    version = sys.version_info
    print(f"🐍 Python Version: {version.major}.{version.minor}.{version.micro}")
    
    if version.major >= 3 and version.minor >= 8:
        print("✅ Python version is compatible")
        return True
    else:
        print("❌ Python 3.8+ required")
        return False

def check_dependencies():
    """Check if required packages are installed"""
    required_packages = [
        'fastapi',
        'uvicorn',
        'sqlalchemy',
        'asyncpg',
        'redis',
        'python-jose',
        'python-multipart',
        'aiofiles',
        'jinja2',
        'stripe',
        'paypalrestsdk',
        'requests'
    ]
    
    missing_packages = []
    
    for package in required_packages:
        try:
            __import__(package.replace('-', '_'))
            print(f"✅ {package}")
        except ImportError:
            print(f"❌ {package} - MISSING")
            missing_packages.append(package)
    
    if missing_packages:
        print(f"\n📦 Install missing packages:")
        print(f"pip install {' '.join(missing_packages)}")
        return False
    return True

def check_file_structure():
    """Verify file structure is correct"""
    required_files = [
        'main.py',
        'database.py',
        'templates/index.html',
        'services/websocket_manager.py',
        'services/keycloak_auth.py',
        'services/payment_service.py',
        'routes/api.py',
        'routes/agents.py',
        'routes/auth.py',
        'routes/payments.py',
        'routes/websockets.py',
        '.env.example'
    ]
    
    missing_files = []
    
    for file_path in required_files:
        if os.path.exists(file_path):
            print(f"✅ {file_path}")
        else:
            print(f"❌ {file_path} - MISSING")
            missing_files.append(file_path)
    
    return len(missing_files) == 0

def check_docker_setup():
    """Check Docker configuration"""
    docker_files = [
        '../docker-compose.full.yml',
        '../Dockerfile'
    ]
    
    for file_path in docker_files:
        if os.path.exists(file_path):
            print(f"✅ {file_path}")
        else:
            print(f"❌ {file_path} - MISSING")

def check_environment_config():
    """Check environment configuration"""
    env_example = '.env.example'
    env_file = '.env'
    
    if os.path.exists(env_example):
        print(f"✅ {env_example}")
    else:
        print(f"❌ {env_example} - MISSING")
    
    if os.path.exists(env_file):
        print(f"✅ {env_file}")
    else:
        print(f"⚠️  {env_file} - Not found (copy from .env.example)")

def test_fastapi_import():
    """Test FastAPI application import"""
    try:
        sys.path.insert(0, '.')
        from main import app
        print("✅ FastAPI app imports successfully")
        return True
    except Exception as e:
        print(f"❌ FastAPI import failed: {e}")
        return False

def generate_status_report():
    """Generate comprehensive status report"""
    print("=" * 60)
    print("🚀 OneLastAI Platform - System Status Check")
    print("=" * 60)
    
    checks = []
    
    print("\n📋 SYSTEM REQUIREMENTS:")
    print("-" * 30)
    checks.append(("Python Version", check_python_version()))
    
    print("\n📦 DEPENDENCIES:")
    print("-" * 30)
    checks.append(("Required Packages", check_dependencies()))
    
    print("\n📁 FILE STRUCTURE:")
    print("-" * 30)
    checks.append(("Core Files", check_file_structure()))
    
    print("\n🐳 DOCKER SETUP:")
    print("-" * 30)
    check_docker_setup()
    
    print("\n⚙️  CONFIGURATION:")
    print("-" * 30)
    check_environment_config()
    
    print("\n🧪 APPLICATION TEST:")
    print("-" * 30)
    checks.append(("FastAPI Import", test_fastapi_import()))
    
    # Summary
    passed = sum(1 for _, status in checks if status)
    total = len(checks)
    
    print("\n" + "=" * 60)
    print(f"📊 SUMMARY: {passed}/{total} critical checks passed")
    
    if passed == total:
        print("🎉 All checks passed! System is ready for deployment.")
        print("\n🚀 Next steps:")
        print("1. Copy .env.example to .env and configure")
        print("2. Run: uvicorn main:app --reload --port 3000")
        print("3. Visit: http://localhost:3000")
    else:
        print("⚠️  Some issues need attention before deployment.")
    
    print("=" * 60)

if __name__ == "__main__":
    generate_status_report()
