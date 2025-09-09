from keycloak import KeycloakOpenID, KeycloakAdmin
from fastapi import HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import JWTError, jwt
import os
from typing import Optional, Dict, Any
from database import get_db, User
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

# Keycloak configuration
KEYCLOAK_URL = os.getenv("KEYCLOAK_URL", "http://localhost:8080")
KEYCLOAK_REALM = os.getenv("KEYCLOAK_REALM", "onelastai")
KEYCLOAK_CLIENT_ID = os.getenv("KEYCLOAK_CLIENT_ID", "onelastai-app")
KEYCLOAK_CLIENT_SECRET = os.getenv("KEYCLOAK_CLIENT_SECRET", "")

# Initialize Keycloak
keycloak_openid = KeycloakOpenID(
    server_url=KEYCLOAK_URL,
    client_id=KEYCLOAK_CLIENT_ID,
    realm_name=KEYCLOAK_REALM,
    client_secret_key=KEYCLOAK_CLIENT_SECRET
)

keycloak_admin = KeycloakAdmin(
    server_url=KEYCLOAK_URL,
    client_id=KEYCLOAK_CLIENT_ID,
    realm_name=KEYCLOAK_REALM,
    client_secret_key=KEYCLOAK_CLIENT_SECRET,
    verify=True
)

security = HTTPBearer()

class AuthService:
    @staticmethod
    def get_public_key():
        try:
            return keycloak_openid.public_key()
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Could not retrieve public key: {str(e)}"
            )

    @staticmethod
    def decode_token(token: str) -> Dict[str, Any]:
        try:
            # Get public key
            public_key = AuthService.get_public_key()
            
            # Decode and validate token
            decoded_token = jwt.decode(
                token,
                public_key,
                algorithms=["RS256"],
                audience=KEYCLOAK_CLIENT_ID,
                issuer=f"{KEYCLOAK_URL}/realms/{KEYCLOAK_REALM}"
            )
            return decoded_token
        except JWTError as e:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail=f"Token validation failed: {str(e)}",
                headers={"WWW-Authenticate": "Bearer"},
            )

    @staticmethod
    async def get_or_create_user(decoded_token: Dict[str, Any], db: AsyncSession) -> User:
        keycloak_id = decoded_token.get("sub")
        email = decoded_token.get("email")
        username = decoded_token.get("preferred_username")
        full_name = decoded_token.get("name")

        # Check if user exists
        result = await db.execute(
            select(User).where(User.keycloak_id == keycloak_id)
        )
        user = result.scalar_one_or_none()

        if not user:
            # Create new user
            user = User(
                keycloak_id=keycloak_id,
                email=email,
                username=username,
                full_name=full_name,
                is_active=True
            )
            db.add(user)
            await db.commit()
            await db.refresh(user)

        return user

    @staticmethod
    def create_user_in_keycloak(username: str, email: str, password: str, first_name: str = "", last_name: str = ""):
        try:
            user_data = {
                "username": username,
                "email": email,
                "firstName": first_name,
                "lastName": last_name,
                "enabled": True,
                "credentials": [
                    {
                        "type": "password",
                        "value": password,
                        "temporary": False
                    }
                ]
            }
            
            user_id = keycloak_admin.create_user(user_data, exist_ok=False)
            return user_id
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Failed to create user in Keycloak: {str(e)}"
            )

# Dependency for token validation
async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: AsyncSession = Depends(get_db)
) -> User:
    token = credentials.credentials
    
    # Decode and validate token
    decoded_token = AuthService.decode_token(token)
    
    # Get or create user in database
    user = await AuthService.get_or_create_user(decoded_token, db)
    
    return user

# Optional authentication (for public/private endpoints)
async def get_current_user_optional(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(HTTPBearer(auto_error=False)),
    db: AsyncSession = Depends(get_db)
) -> Optional[User]:
    if not credentials:
        return None
    
    try:
        token = credentials.credentials
        decoded_token = AuthService.decode_token(token)
        user = await AuthService.get_or_create_user(decoded_token, db)
        return user
    except HTTPException:
        return None

# Check if user is premium
async def get_premium_user(current_user: User = Depends(get_current_user)) -> User:
    if not current_user.is_premium:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Premium subscription required"
        )
    return current_user
