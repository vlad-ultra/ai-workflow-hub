# AI Workflow Hub (DevOps Portfolio Project)

Monorepo for practicing Docker Compose → Kubernetes → Helm → ArgoCD.

Services:

- nginx (reverse proxy, port 80)
- api-gateway (Node.js, port 8080)
- auth-service (Node.js, port 4000)
- user-service (Node.js, port 4001)
- tasks-service (FastAPI, port 4002)
- ai-assistant-service (FastAPI, port 4003)
- notifications-service (Node.js, port 4004)
- postgres, redis (infra)

## Setup

1. **Copy environment file:**
```bash
cp .env.example .env
```

2. **Edit `.env` file** and set your values (especially secrets like `JWT_SECRET` and `POSTGRES_PASSWORD`)

3. **Start services:**
```bash
docker-compose up -d --build
```

4. **Access application:**
- Via Nginx: http://localhost (port 80)
- Direct API Gateway: http://localhost:8080

## Testing

After startup, check:
- http://localhost/health        — api-gateway via nginx
- http://localhost/tasks         — proxy to tasks-service via nginx
- http://localhost:8080/health   — api-gateway directly
```
