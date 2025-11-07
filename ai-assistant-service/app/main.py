from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="AI Assistant Service")

class AnalyzeRequest(BaseModel):
    title: str

class AnalyzeResponse(BaseModel):
    category: str
    priority: str

@app.post("/analyze", response_model=AnalyzeResponse)
def analyze(req: AnalyzeRequest):
    text = req.title.lower()
    if "urgent" in text or "prod" in text:
        return AnalyzeResponse(category="incident", priority="high")
    if "learn" in text or "study" in text:
        return AnalyzeResponse(category="learning", priority="medium")
    return AnalyzeResponse(category="general", priority="low")

@app.get("/health")
def health():
    return {"status": "ok", "service": "ai-assistant-service"}
