#!/usr/bin/env python3
"""
Quick server status check for OneLastAI Platform
"""
import requests
import json
from datetime import datetime

def check_server():
    """Check if the OneLastAI server is running and responding"""
    print("🔍 OneLastAI Server Status Check")
    print("=" * 50)
    
    base_url = "http://localhost:3000"
    
    # Test endpoints
    endpoints = [
        ("/", "Main Page"),
        ("/health", "Health Check"),
        ("/api/test", "API Test"),
        ("/docs", "API Documentation")
    ]
    
    for endpoint, name in endpoints:
        try:
            response = requests.get(f"{base_url}{endpoint}", timeout=5)
            if response.status_code == 200:
                print(f"✅ {name}: OK (200)")
            else:
                print(f"⚠️ {name}: {response.status_code}")
        except requests.exceptions.RequestException as e:
            print(f"❌ {name}: Connection failed ({e})")
    
    # Test health endpoint specifically
    try:
        response = requests.get(f"{base_url}/health", timeout=5)
        if response.status_code == 200:
            health_data = response.json()
            print("\n📊 Health Details:")
            print(f"   Status: {health_data.get('status', 'Unknown')}")
            print(f"   Message: {health_data.get('message', 'N/A')}")
            print(f"   Version: {health_data.get('version', 'N/A')}")
            
            if 'features' in health_data:
                print("   Features:")
                for feature, status in health_data['features'].items():
                    print(f"     {feature}: {status}")
    except Exception as e:
        print(f"❌ Health check failed: {e}")
    
    print("\n🌐 Access Points:")
    print(f"   📍 Main App: {base_url}")
    print(f"   📚 API Docs: {base_url}/docs")
    print(f"   🔍 Health: {base_url}/health")
    print(f"   🧪 API Test: {base_url}/api/test")
    
    print("\n⏰ Check completed at:", datetime.now().strftime("%Y-%m-%d %H:%M:%S"))

if __name__ == "__main__":
    try:
        check_server()
    except KeyboardInterrupt:
        print("\n🛑 Status check cancelled")
    except Exception as e:
        print(f"❌ Status check failed: {e}")
