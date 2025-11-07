# AI Workflow Hub
Microservices-based task management system with AI-powered analysis, deployed on Kubernetes using Helm.

## Architecture

6 microservices: API Gateway, Auth Service, User Service, Tasks Service, AI Assistant Service, Notifications Service
Infrastructure: PostgreSQL, Redis
```
Client → Ingress → API Gateway → Services
```

## Prerequisites

Kubernetes cluster (Docker Desktop, Minikube, or Kind), kubectl, Helm, Docker, Ingress Controller

## Quick Start

```bash
docker build -t ai-workflow-hub-api-gateway:latest ./api-gateway
docker build -t ai-workflow-hub-auth-service:latest ./auth-service
docker build -t ai-workflow-hub-user-service:latest ./user-service
docker build -t ai-workflow-hub-tasks-service:latest ./tasks-service
docker build -t ai-workflow-hub-ai-assistant-service:latest ./ai-assistant-service
docker build -t ai-workflow-hub-notifications-service:latest ./notifications-service
cd k8s/helm-chart && helm install ai-workflow-hub . --namespace default --create-namespace
```

## Access

```bash
kubectl port-forward -n ingress-nginx service/ingress-nginx-controller 8080:80
# Or: kubectl port-forward service/api-gateway 8080:8080
```

## Testing

```bash
curl -H "Host: ai-workflow-hub.local" http://localhost:8080/health
curl -X POST -H "Host: ai-workflow-hub.local" -H "Content-Type: application/json" -d '{"email":"user@example.com"}' http://localhost:8080/auth/login
curl -H "Host: ai-workflow-hub.local" http://localhost:8080/tasks
curl -X POST -H "Host: ai-workflow-hub.local" -H "Content-Type: application/json" -d '{"id":1,"title":"Test","status":"pending"}' http://localhost:8080/tasks
curl -X POST -H "Host: ai-workflow-hub.local" -H "Content-Type: application/json" -d '{"title":"Urgent production issue"}' http://localhost:8080/ai/analyze
```

## Helm Commands

```bash
helm upgrade ai-workflow-hub ./k8s/helm-chart
helm uninstall ai-workflow-hub
```
