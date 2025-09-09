from fastapi import APIRouter, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

router = APIRouter()
templates = Jinja2Templates(directory="api/templates")

@router.get("/hello", response_class=HTMLResponse)
def index(request: Request):
    return templates.TemplateResponse("hello/index.html", {"request": request})
