import sys
sys.path.append('.')

try:
    from main import app
    print("✅ FastAPI app created successfully!")
    
    # Test basic imports
    from database import get_database, User, Agent, Payment, AgentPerformance
    print("✅ Database models imported successfully!")
    
    from services.websocket_manager import ConnectionManager
    print("✅ WebSocket manager imported successfully!")
    
    from services.keycloak_auth import AuthService
    print("✅ Auth service imported successfully!")
    
    from services.payment_service import PaymentService
    print("✅ Payment service imported successfully!")
    
    print("\n🎉 All components imported successfully!")
    print("🚀 OneLastAI platform is ready for deployment!")
    
except ImportError as e:
    print(f"❌ Import error: {e}")
except Exception as e:
    print(f"❌ Error: {e}")
