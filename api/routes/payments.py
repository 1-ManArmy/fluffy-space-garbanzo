from fastapi import APIRouter, Depends, HTTPException, Request, status
from fastapi.responses import RedirectResponse
from sqlalchemy.ext.asyncio import AsyncSession
from database import get_db, Payment, User
from auth.keycloak_auth import get_current_user, get_current_user_optional
from payments.payment_service import PaymentService
from pydantic import BaseModel
from typing import Optional
import json

router = APIRouter()

class PaymentRequest(BaseModel):
    amount: float
    currency: str = "USD"
    provider: str  # stripe, paypal, lemon_squeezy
    product_id: Optional[str] = None
    variant_id: Optional[str] = None

class WebhookPayload(BaseModel):
    payload: dict

# Payment creation endpoints
@router.post("/create-payment")
async def create_payment(
    payment_request: PaymentRequest,
    user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Create a payment with specified provider"""
    
    if payment_request.provider == "stripe":
        return await PaymentService.create_stripe_payment(
            amount=payment_request.amount,
            currency=payment_request.currency,
            user=user,
            db=db
        )
    
    elif payment_request.provider == "paypal":
        return await PaymentService.create_paypal_payment(
            amount=payment_request.amount,
            currency=payment_request.currency,
            user=user,
            db=db
        )
    
    elif payment_request.provider == "lemon_squeezy":
        if not payment_request.product_id or not payment_request.variant_id:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Product ID and Variant ID required for Lemon Squeezy"
            )
        
        return await PaymentService.create_lemon_squeezy_checkout(
            product_id=payment_request.product_id,
            variant_id=payment_request.variant_id,
            user=user
        )
    
    else:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid payment provider"
        )

# Webhook endpoints
@router.post("/webhooks/stripe")
async def stripe_webhook(request: Request, db: AsyncSession = Depends(get_db)):
    """Handle Stripe webhook events"""
    payload = await request.json()
    await PaymentService.handle_stripe_webhook(payload, db)
    return {"status": "success"}

@router.post("/webhooks/paypal")
async def paypal_webhook(request: Request, db: AsyncSession = Depends(get_db)):
    """Handle PayPal webhook events"""
    payload = await request.json()
    await PaymentService.handle_paypal_webhook(payload, db)
    return {"status": "success"}

@router.post("/webhooks/lemon-squeezy")
async def lemon_squeezy_webhook(request: Request, db: AsyncSession = Depends(get_db)):
    """Handle Lemon Squeezy webhook events"""
    payload = await request.json()
    await PaymentService.handle_lemon_squeezy_webhook(payload, db)
    return {"status": "success"}

# Payment success/cancel pages
@router.get("/payment/success")
async def payment_success(
    payment_intent: Optional[str] = None,
    paymentId: Optional[str] = None,
    PayerID: Optional[str] = None,
    db: AsyncSession = Depends(get_db)
):
    """Handle successful payment redirect"""
    
    # Handle Stripe success
    if payment_intent:
        await PaymentService.confirm_stripe_payment(payment_intent, db)
    
    # Handle PayPal success
    if paymentId and PayerID:
        # Execute PayPal payment
        payment = paypalrestsdk.Payment.find(paymentId)
        if payment.execute({"payer_id": PayerID}):
            # Update payment status in database
            pass
    
    return {"message": "Payment successful! Welcome to OneLastAI Premium!"}

@router.get("/payment/cancel")
async def payment_cancel():
    """Handle payment cancellation"""
    return {"message": "Payment was cancelled"}

# Get user payment history
@router.get("/payments/history")
async def get_payment_history(
    user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Get user's payment history"""
    from sqlalchemy import select
    
    result = await db.execute(
        select(Payment).where(Payment.user_id == user.id).order_by(Payment.created_at.desc())
    )
    payments = result.scalars().all()
    
    return {
        "payments": [
            {
                "id": payment.id,
                "amount": payment.amount,
                "currency": payment.currency,
                "provider": payment.provider,
                "status": payment.status,
                "created_at": payment.created_at.isoformat()
            }
            for payment in payments
        ]
    }

# Subscription plans
@router.get("/plans")
async def get_subscription_plans():
    """Get available subscription plans"""
    return {
        "plans": [
            {
                "id": "basic",
                "name": "Basic Plan",
                "price": 9.99,
                "currency": "USD",
                "features": [
                    "Access to 10 AI agents",
                    "100 requests per day",
                    "Basic support"
                ]
            },
            {
                "id": "premium",
                "name": "Premium Plan",
                "price": 29.99,
                "currency": "USD",
                "features": [
                    "Access to all 45+ AI agents",
                    "Unlimited requests",
                    "Real-time performance monitoring",
                    "Priority support",
                    "Advanced analytics"
                ]
            },
            {
                "id": "enterprise",
                "name": "Enterprise Plan",
                "price": 99.99,
                "currency": "USD",
                "features": [
                    "Everything in Premium",
                    "Custom AI agents",
                    "API access",
                    "White-label solution",
                    "Dedicated support"
                ]
            }
        ]
    }
