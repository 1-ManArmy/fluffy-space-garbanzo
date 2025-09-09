from fastapi import APIRouter, Request, Form, status
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates
from mailers.fastapi_mailer import send_contact_email

router = APIRouter()
templates = Jinja2Templates(directory="api/templates")

@router.get("/pages/about")
async def about(request: Request):
    return templates.TemplateResponse("about.html", {"request": request})

@router.get("/pages/contact")
async def contact(request: Request):
    return templates.TemplateResponse("contact.html", {"request": request})

@router.post("/pages/contact_submit")
async def contact_submit(request: Request, name: str = Form(...), email: str = Form(...), subject: str = Form("Contact Form Submission"), message: str = Form(...)):
    # Send email using FastAPI mailer
    await send_contact_email(name, email, subject, message, "mail@onelastai.com")
    return RedirectResponse(url="/pages/contact", status_code=status.HTTP_303_SEE_OTHER)

@router.get("/pages/blog")
async def blog(request: Request):
    return templates.TemplateResponse("blog.html", {"request": request})

@router.get("/pages/news")
async def news(request: Request):
    return templates.TemplateResponse("news.html", {"request": request})

@router.get("/pages/faq")
async def faq(request: Request):
    return templates.TemplateResponse("faq.html", {"request": request})

@router.get("/pages/signup")
async def signup(request: Request):
    return templates.TemplateResponse("signup.html", {"request": request})

# Add more routes as needed for other pages

@router.post("/pages/login_submit")
def login_submit(request: Request):
    return {"message": "Logged in successfully!"}

@router.post("/pages/logout")
def logout(request: Request):
    return {"message": "Logged out successfully!"}

@router.post("/pages/schedule_demo_submit")
def schedule_demo_submit(request: Request):
    return {"message": "Demo scheduled successfully! We will contact you soon."}
