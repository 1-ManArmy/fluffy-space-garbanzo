from fastapi import Request, status
from fastapi.responses import JSONResponse
import logging

# Error handling utilities

def handle_db_connection_error(request: Request, exc: Exception):
    logging.error(f"PostgreSQL connection failed: {exc}")
    return JSONResponse(
        status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
        content={"detail": "Our database is temporarily unavailable. Some features may be limited."}
    )

def handle_db_timeout_error(request: Request, exc: Exception):
    logging.error(f"PostgreSQL statement timeout: {exc}")
    return JSONResponse(
        status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
        content={"detail": "Database query timeout. Please try again in a moment."}
    )

def database_available():
    # Implement database check using SQLAlchemy
    from sqlalchemy import text
    from database import engine
    try:
        with engine.connect() as conn:
            conn.execute(text('SELECT 1'))
        return True
    except Exception:
        return False
