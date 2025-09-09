from fastapi_mail import FastMail, MessageSchema, ConnectionConfig
import asyncio

conf = ConnectionConfig(
    MAIL_USERNAME="your@email.com",
    MAIL_PASSWORD="password",
    MAIL_FROM="your@email.com",
    MAIL_PORT=587,
    MAIL_SERVER="smtp.yourserver.com",
    MAIL_STARTTLS=True,
    MAIL_SSL_TLS=False
)


async def send_mail(email: str):
    message = MessageSchema(
        subject="Test",
        recipients=[email],
        body="Hello from FastAPI!",
        subtype="plain"
    )
    fm = FastMail(conf)
    await fm.send_message(message)

# Contact form mailer
async def send_contact_email(name: str, email: str, subject: str, message: str, to_email: str):
    body = f"Name: {name}\nEmail: {email}\nSubject: {subject}\nMessage: {message}"
    msg = MessageSchema(
        subject=subject,
        recipients=[to_email],
        body=body,
        subtype="plain"
    )
    fm = FastMail(conf)
    await fm.send_message(msg)
