from fastapi import APIRouter

router = APIRouter()

@router.get("/infrastructure")
def index():
    page_title = "Infrastructure - Enterprise-Grade Platform"
    tech_stack = [
        {
            "name": "AWS EC2",
            "description": "Auto-scaling cloud infrastructure with 99.9% uptime",
            "icon": "☁️",
            "category": "cloud",
            "features": ["Auto-scaling", "Load Balancing", "Global CDN"]
        },
        {
            "name": "PostgreSQL Database",
            "description": "Secure, scalable NoSQL database with automated backups",
            "icon": "🍃",
            "category": "database",
            "features": ["Auto-scaling", "Backups", "Security"]
        },
        {
            "name": "Passage Auth",
            "description": "Passwordless authentication powered by 1Password",
            "icon": "🔐",
            "category": "security",
            "features": ["Passwordless", "Biometric", "Zero Trust"]
        },
        {
            "name": "Payment Systems",
            "description": "Multiple payment providers for global accessibility",
            "icon": "💳",
            "category": "payments",
            "features": ["Stripe", "PayPal", "Lemon Squeezy"]
        }
    ]
    return {"page_title": page_title, "tech_stack": tech_stack}
