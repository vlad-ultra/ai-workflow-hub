# Quick Local Deployment Guide

## Prerequisites Check

```bash
# Check if kubectl is installed
kubectl version --client

# Check if Helm is installed
helm version

# Check if Minikube is running (if using Minikube)
minikube status
```

## Quick Start with Minikube

### Step 1: Start Minikube and Build Images

```bash
# Start Minikube
minikube start

# Use Minikube's Docker daemon
eval $(minikube docker-env)

# Build all images
cd /path/to/ai-workflow-hub
docker build -t ai-workflow-hub-api-gateway:latest ./api-gateway
docker build -t ai-workflow-hub-auth-service:latest ./auth-service
docker build -t ai-workflow-hub-user-service:latest ./user-service
docker build -t ai-workflow-hub-tasks-service:latest ./tasks-service
docker build -t ai-workflow-hub-ai-assistant-service:latest ./ai-assistant-service
docker build -t ai-workflow-hub-notifications-service:latest ./notifications-service
```

### Step 2: Deploy with Helm

```bash
cd k8s/helm-chart
helm install ai-workflow-hub . --namespace default --create-namespace
```

### Step 3: Wait for Pods to be Ready

```bash
kubectl wait --for=condition=ready pod -l app=api-gateway --timeout=300s
kubectl wait --for=condition=ready pod -l app=nginx --timeout=300s
```

### Step 4: Access the Application

```bash
# Option 1: Port forward
kubectl port-forward service/nginx 8080:80

# Option 2: Get NodePort and Minikube IP
minikube service nginx --url
```

Then open browser: `http://localhost:8080`

## Quick Start with Kind

### Step 1: Create Cluster and Build Images

```bash
# Create Kind cluster
kind create cluster --name ai-workflow-hub

# Build images
docker build -t ai-workflow-hub-api-gateway:latest ./api-gateway
docker build -t ai-workflow-hub-auth-service:latest ./auth-service
docker build -t ai-workflow-hub-user-service:latest ./user-service
docker build -t ai-workflow-hub-tasks-service:latest ./tasks-service
docker build -t ai-workflow-hub-ai-assistant-service:latest ./ai-assistant-service
docker build -t ai-workflow-hub-notifications-service:latest ./notifications-service

# Load images into Kind
kind load docker-image ai-workflow-hub-api-gateway:latest --name ai-workflow-hub
kind load docker-image ai-workflow-hub-auth-service:latest --name ai-workflow-hub
kind load docker-image ai-workflow-hub-user-service:latest --name ai-workflow-hub
kind load docker-image ai-workflow-hub-tasks-service:latest --name ai-workflow-hub
kind load docker-image ai-workflow-hub-ai-assistant-service:latest --name ai-workflow-hub
kind load docker-image ai-workflow-hub-notifications-service:latest --name ai-workflow-hub
```

### Step 2: Deploy

```bash
cd k8s/helm-chart
helm install ai-workflow-hub . --namespace default --create-namespace
```

### Step 3: Access

```bash
kubectl port-forward service/nginx 8080:80
```

## Testing

```bash
# Health check
curl http://localhost:8080/health

# Get tasks
curl http://localhost:8080/tasks

# Login
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}'
```

## Cleanup

```bash
# Uninstall Helm release
helm uninstall ai-workflow-hub

# Delete namespace (if created)
kubectl delete namespace default

# Stop Minikube (if using)
minikube stop

# Delete Kind cluster (if using)
kind delete cluster --name ai-workflow-hub
```

