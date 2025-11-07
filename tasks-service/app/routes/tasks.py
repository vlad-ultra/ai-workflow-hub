from fastapi import APIRouter
from app.models.task import Task

router = APIRouter(prefix="/tasks", tags=["tasks"])

DB = [
    Task(id=1, title="Learn Docker", status="in-progress"),
    Task(id=2, title="Deploy to Kubernetes", status="pending"),
]

@router.get("/")
def list_tasks():
    return DB

@router.post("/")
def add_task(task: Task):
    DB.append(task)
    return {"msg": "task_added", "task": task}
