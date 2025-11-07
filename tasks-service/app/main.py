from fastapi import FastAPI
from app.routes import tasks

app = FastAPI(title="Tasks Service")
app.include_router(tasks.router)

@app.get("/health")
def health():
    return {"status": "ok", "service": "tasks-service"}
