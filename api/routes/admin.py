from fastapi import APIRouter

router = APIRouter()

@router.get("/admin/dashboard")
def dashboard():
    return {"page": "Admin Dashboard"}

@router.get("/admin/users")
def users():
    return {"page": "Admin Users"}

@router.get("/admin/agents")
def agents():
    return {"page": "Admin Agents"}

@router.get("/admin/reports")
def reports():
    return {"page": "Admin Reports"}

@router.get("/admin/payments")
def payments():
    return {"page": "Admin Payments"}

@router.get("/admin/analytics")
def analytics():
    return {"page": "Admin Analytics"}
