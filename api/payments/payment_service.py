import stripe
import paypalrestsdk
import requests
from fastapi import HTTPException, status, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from database import get_db, Payment, User
from auth.keycloak_auth import get_current_user
import os
from typing import Dict, Any
from datetime import datetime
import json

# Payment provider configurations
stripe.api_key = os.getenv("STRIPE_SECRET_KEY")

# PayPal configuration
paypalrestsdk.configure({
    "mode": os.getenv("PAYPAL_MODE", "sandbox"),  # sandbox or live
    "client_id": os.getenv("PAYPAL_CLIENT_ID"),
    "client_secret": os.getenv("PAYPAL_CLIENT_SECRET")
})

# Lemon Squeezy configuration
LEMON_SQUEEZY_API_KEY = os.getenv("LEMON_SQUEEZY_API_KEY")
LEMON_SQUEEZY_STORE_ID = os.getenv("LEMON_SQUEEZY_STORE_ID")

class PaymentService:
    
    # Stripe Integration
    @staticmethod
    async def create_stripe_payment(
        amount: float,
        currency: str = "usd",
        description: str = "OneLastAI Premium Subscription",
        user: User = None,
        db: AsyncSession = None
    ) -> Dict[str, Any]:
        try:
            # Create Stripe PaymentIntent
            intent = stripe.PaymentIntent.create(
                amount=int(amount * 100),  # Convert to cents
                currency=currency,
                description=description,
                metadata={
                    "user_id": user.id if user else None,
                    "user_email": user.email if user else None
                }
            )
            
            # Save payment record
            if db and user:
                payment = Payment(
                    user_id=user.id,
                    amount=amount,
                    currency=currency.upper(),
                    provider="stripe",
                    transaction_id=intent.id,
                    status="pending",
                    metadata={"stripe_intent_id": intent.id}
                )
                db.add(payment)
                await db.commit()
            
            return {
                "client_secret": intent.client_secret,
                "payment_intent_id": intent.id,
                "amount": amount,
                "currency": currency
            }
            
        except stripe.error.StripeError as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Stripe error: {str(e)}"
            )

    @staticmethod
    async def confirm_stripe_payment(
        payment_intent_id: str,
        db: AsyncSession
    ) -> Dict[str, Any]:
        try:
            # Retrieve payment intent from Stripe
            intent = stripe.PaymentIntent.retrieve(payment_intent_id)
            
            # Update payment status in database
            payment = await db.execute(
                select(Payment).where(Payment.transaction_id == payment_intent_id)
            )
            payment = payment.scalar_one_or_none()
            
            if payment:
                payment.status = "completed" if intent.status == "succeeded" else "failed"
                await db.commit()
                
                # If payment successful, upgrade user to premium
                if intent.status == "succeeded":
                    user = await db.execute(
                        select(User).where(User.id == payment.user_id)
                    )
                    user = user.scalar_one_or_none()
                    if user:
                        user.is_premium = True
                        await db.commit()
            
            return {
                "status": intent.status,
                "payment_id": payment.id if payment else None
            }
            
        except stripe.error.StripeError as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Stripe error: {str(e)}"
            )

    # PayPal Integration
    @staticmethod
    async def create_paypal_payment(
        amount: float,
        currency: str = "USD",
        description: str = "OneLastAI Premium Subscription",
        user: User = None,
        db: AsyncSession = None
    ) -> Dict[str, Any]:
        try:
            payment = paypalrestsdk.Payment({
                "intent": "sale",
                "payer": {
                    "payment_method": "paypal"
                },
                "redirect_urls": {
                    "return_url": os.getenv("PAYPAL_RETURN_URL", "http://localhost:3000/payment/success"),
                    "cancel_url": os.getenv("PAYPAL_CANCEL_URL", "http://localhost:3000/payment/cancel")
                },
                "transactions": [{
                    "item_list": {
                        "items": [{
                            "name": description,
                            "sku": "premium_subscription",
                            "price": str(amount),
                            "currency": currency,
                            "quantity": 1
                        }]
                    },
                    "amount": {
                        "total": str(amount),
                        "currency": currency
                    },
                    "description": description
                }]
            })

            if payment.create():
                # Save payment record
                if db and user:
                    payment_record = Payment(
                        user_id=user.id,
                        amount=amount,
                        currency=currency,
                        provider="paypal",
                        transaction_id=payment.id,
                        status="pending",
                        metadata={"paypal_payment_id": payment.id}
                    )
                    db.add(payment_record)
                    await db.commit()

                # Get approval URL
                for link in payment.links:
                    if link.rel == "approval_url":
                        return {
                            "approval_url": link.href,
                            "payment_id": payment.id
                        }
            else:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"PayPal error: {payment.error}"
                )

        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"PayPal error: {str(e)}"
            )

    # Lemon Squeezy Integration
    @staticmethod
    async def create_lemon_squeezy_checkout(
        product_id: str,
        variant_id: str,
        user: User = None
    ) -> Dict[str, Any]:
        try:
            headers = {
                "Authorization": f"Bearer {LEMON_SQUEEZY_API_KEY}",
                "Content-Type": "application/vnd.api+json",
                "Accept": "application/vnd.api+json"
            }
            
            checkout_data = {
                "data": {
                    "type": "checkouts",
                    "attributes": {
                        "product_options": {
                            "name": "OneLastAI Premium Subscription",
                            "description": "Access to all premium AI agents and features"
                        },
                        "checkout_options": {
                            "embed": True,
                            "media": False,
                            "logo": True
                        },
                        "checkout_data": {
                            "email": user.email if user else None,
                            "name": user.full_name if user else None,
                            "custom": {
                                "user_id": user.id if user else None
                            }
                        },
                        "expires_at": None
                    },
                    "relationships": {
                        "store": {
                            "data": {
                                "type": "stores",
                                "id": LEMON_SQUEEZY_STORE_ID
                            }
                        },
                        "variant": {
                            "data": {
                                "type": "variants",
                                "id": variant_id
                            }
                        }
                    }
                }
            }
            
            response = requests.post(
                "https://api.lemonsqueezy.com/v1/checkouts",
                headers=headers,
                json=checkout_data
            )
            
            if response.status_code == 201:
                checkout = response.json()
                return {
                    "checkout_url": checkout["data"]["attributes"]["url"],
                    "checkout_id": checkout["data"]["id"]
                }
            else:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Lemon Squeezy error: {response.text}"
                )
                
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Lemon Squeezy error: {str(e)}"
            )

    # Webhook handlers
    @staticmethod
    async def handle_stripe_webhook(payload: dict, db: AsyncSession):
        """Handle Stripe webhook events"""
        event_type = payload.get("type")
        
        if event_type == "payment_intent.succeeded":
            payment_intent = payload["data"]["object"]
            await PaymentService.confirm_stripe_payment(payment_intent["id"], db)
            
    @staticmethod
    async def handle_paypal_webhook(payload: dict, db: AsyncSession):
        """Handle PayPal webhook events"""
        event_type = payload.get("event_type")
        
        if event_type == "PAYMENT.SALE.COMPLETED":
            # Handle successful PayPal payment
            pass
            
    @staticmethod
    async def handle_lemon_squeezy_webhook(payload: dict, db: AsyncSession):
        """Handle Lemon Squeezy webhook events"""
        event_name = payload.get("meta", {}).get("event_name")
        
        if event_name == "order_created":
            # Handle successful Lemon Squeezy payment
            pass
