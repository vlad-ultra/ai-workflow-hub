# AI Workflow Hub (DevOps Portfolio Project)

A mono-repository for practicing Docker Compose → Kubernetes → Helm → ArgoCD.

Services:

- api-gateway (Node.js, port 8080)
- auth-service (Node.js, port 4000)
- user-service (Node.js, port 4001)
- tasks-service (FastAPI, port 4002)
- ai-assistant-service (FastAPI, port 4003)
- notifications-service (Node.js, port 4004)
- postgres, redis (infra)

Running locally:

```bash
cd deploy
docker compose up --build
```

After launch, check:
- http://localhost:8080/health        — api-gateway
- http://localhost:8080/tasks         — proxy to tasks-service
- http://localhost:4002/health        — tasks-service