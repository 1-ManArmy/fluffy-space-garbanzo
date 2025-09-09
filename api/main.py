from fastapi import FastAPI, BackgroundTasks, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from routes import (
    user, home, agents, agent, reportly, press, personax, pages, netscope, neochat, memora, learn, labx, infrastructure, infoseek, ideaforge, taskmaster, spylens, health, girlfriend, application, aiblogster, hello, payments, admin, tradesage, vocamind
)
from websockets import websocket_routes
from database import init_db
from jobs.background_job import example_job
from mailers.fastapi_mailer import send_mail
from services.example_service import ExampleService
import asyncio


app = FastAPI(
    title="OneLastAI Platform",
    description="AI Agent Platform with Real-time Performance Monitoring",
    version="2.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

templates = Jinja2Templates(directory="templates")
app.mount("/static", StaticFiles(directory="static"), name="static")

# Include WebSocket routes
app.include_router(websocket_routes.router, prefix="/api")

# Include payment routes
from routes import payments
app.include_router(payments.router, prefix="/api", tags=["payments"])

# Include all existing routes
app.include_router(user.router, prefix="/api", tags=["users"])
app.include_router(home.router, tags=["home"])
app.include_router(agents.router, tags=["agents"])
app.include_router(agent.router, tags=["agent"])
app.include_router(reportly.router, tags=["reportly"])
app.include_router(press.router, tags=["press"])
app.include_router(personax.router, tags=["personax"])
app.include_router(pages.router, tags=["pages"])
app.include_router(netscope.router, tags=["netscope"])
app.include_router(neochat.router, tags=["neochat"])
app.include_router(memora.router, tags=["memora"])
app.include_router(learn.router, tags=["learn"])
app.include_router(labx.router, tags=["labx"])
app.include_router(infrastructure.router, tags=["infrastructure"])
app.include_router(infoseek.router, tags=["infoseek"])
app.include_router(ideaforge.router, tags=["ideaforge"])
app.include_router(taskmaster.router, tags=["taskmaster"])
app.include_router(spylens.router, tags=["spylens"])
app.include_router(health.router, tags=["health"])
app.include_router(girlfriend.router, tags=["girlfriend"])
app.include_router(application.router, tags=["application"])
app.include_router(aiblogster.router, tags=["aiblogster"])
app.include_router(hello.router, tags=["hello"])

# Initialize database on startup
@app.on_event("startup")
async def startup_event():
    await init_db()
    # Start performance monitoring
    from websockets.connection_manager import performance_monitor
    asyncio.create_task(performance_monitor.start_monitoring())

@app.get("/", response_class=HTMLResponse)
def homepage(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

app.include_router(user.router)
app.include_router(home.router)
app.include_router(agents.router)
app.include_router(agent.router)
app.include_router(reportly.router)
app.include_router(press.router)
app.include_router(personax.router)
app.include_router(pages.router)
app.include_router(netscope.router)
app.include_router(neochat.router)
app.include_router(memora.router)
app.include_router(learn.router)
app.include_router(labx.router)
app.include_router(infrastructure.router)
app.include_router(infoseek.router)
app.include_router(ideaforge.router)
app.include_router(taskmaster.router)
app.include_router(spylens.router)
app.include_router(health.router)
app.include_router(girlfriend.router)
app.include_router(application.router)
app.include_router(aiblogster.router)
app.include_router(hello.router)

@app.post("/run-job/")
def run_job(background_tasks: BackgroundTasks):
    background_tasks.add_task(example_job)
    return {"message": "Background job started"}

@app.post("/send-mail/")
async def send_mail_endpoint(email: str):
    await send_mail(email)
    return {"message": "Mail sent"}

@app.post("/service-process/")
def service_process(data: str):
    service = ExampleService()
    result = service.process(data)
    return result
