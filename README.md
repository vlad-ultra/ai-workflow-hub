# AI Workflow Hub (DevOps Portfolio Project)

Моно-репозиторий для тренировки Docker Compose → Kubernetes → Helm → ArgoCD.

Сервисы:

- api-gateway (Node.js, порт 8080)
- auth-service (Node.js, порт 4000)
- user-service (Node.js, порт 4001)
- tasks-service (FastAPI, порт 4002)
- ai-assistant-service (FastAPI, порт 4003)
- notifications-service (Node.js, порт 4004)
- postgres, redis (infra)

Запуск локально:

```bash
cd deploy
docker compose up --build
```

После запуска проверь:
- http://localhost:8080/health        — api-gateway
- http://localhost:8080/tasks         — прокси на tasks-service
- http://localhost:4002/health        — tasks-service
```
