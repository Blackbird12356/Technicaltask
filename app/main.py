from __future__ import annotations

from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from app.api.routes import router
from app.db.session import init_db
from app.logging_setup import setup_logging
from app.scheduler.jobs import start_scheduler, stop_scheduler

BASE = Path(__file__).resolve().parent
templates = Jinja2Templates(directory=str(BASE / "templates"))


@asynccontextmanager
async def lifespan(_app: FastAPI):
    setup_logging()
    init_db()
    start_scheduler()
    yield
    stop_scheduler()


app = FastAPI(
    title="Итоги торгов ETS и Каспий",
    version="1.0.0",
    lifespan=lifespan,
)
app.include_router(router)
app.mount("/static", StaticFiles(directory=str(BASE / "static")), name="static")


@app.get("/", response_class=HTMLResponse)
def index(request: Request) -> HTMLResponse:
    return templates.TemplateResponse(request, "index.html")


@app.get("/status", response_class=HTMLResponse)
def status_page(request: Request) -> HTMLResponse:
    return templates.TemplateResponse(request, "status.html")
