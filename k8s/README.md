# Kubernetes Deployment Guide

This directory contains Helm charts for deploying AI Workflow Hub to Kubernetes.

## Prerequisites

1. **Kubernetes cluster** (local or remote)
   - For local: [Minikube](https://minikube.sigs.k8s.io/docs/start/) or [Kind](https://kind.sigs.k8s.io/)
   - For remote: Access to your Kubernetes cluster

2. **kubectl** - Kubernetes command-line tool
   ```bash
   # Check if installed
   kubectl version --client
   ```

3. **Helm** - Package manager for Kubernetes
   ```bash
   # Install Helm
   brew install helm  # macOS
   # or
   curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
   
   # Verify installation
   helm version
   ```

4. **Docker images** - Build and push images to a registry
   - For local: Use Minikube's Docker daemon or Kind's registry
   - For remote: Push to Docker Hub, ECR, GCR, etc.

## Local Setup (Minikube)

### 1. Start Minikube

```bash
# Start Minikube
minikube start

# Enable Minikube's Docker daemon (to use local images)
eval $(minikube docker-env)
```

### 2. Build Docker Images

```bash
# Build all images
cd /path/to/ai-workflow-hub

docker build -t ai-workflow-hub-api-gateway:latest ./api-gateway
docker build -t ai-workflow-hub-auth-service:latest ./auth-service
docker build -t ai-workflow-hub-user-service:latest ./user-service
docker build -t ai-workflow-hub-tasks-service:latest ./tasks-service
docker build -t ai-workflow-hub-ai-assistant-service:latest ./ai-assistant-service
docker build -t ai-workflow-hub-notifications-service:latest ./notifications-service
```

### 3. Deploy with Helm

```bash
# Navigate to helm chart directory
cd k8s/helm-chart

# Install the chart
helm install ai-workflow-hub . --namespace default --create-namespace

# Check deployment status
kubectl get pods
kubectl get services
```

### 4. Access the Application

```bash
# Get NodePort for nginx
kubectl get service nginx

# Get Minikube IP
minikube ip

# Access via: http://<minikube-ip>:30080
# Or use port-forward
kubectl port-forward service/nginx 8080:80
# Then access: http://localhost:8080
```

## Local Setup (Kind)

### 1. Create Kind Cluster

```bash
# Create cluster
kind create cluster --name ai-workflow-hub

# Load images into Kind
kind load docker-image ai-workflow-hub-api-gateway:latest --name ai-workflow-hub
kind load docker-image ai-workflow-hub-auth-service:latest --name ai-workflow-hub
kind load docker-image ai-workflow-hub-user-service:latest --name ai-workflow-hub
kind load docker-image ai-workflow-hub-tasks-service:latest --name ai-workflow-hub
kind load docker-image ai-workflow-hub-ai-assistant-service:latest --name ai-workflow-hub
kind load docker-image ai-workflow-hub-notifications-service:latest --name ai-workflow-hub
```

### 2. Deploy with Helm

```bash
cd k8s/helm-chart
helm install ai-workflow-hub . --namespace default --create-namespace
```

## Helm Commands

### Install

```bash
helm install ai-workflow-hub ./k8s/helm-chart
```

### Upgrade

```bash
helm upgrade ai-workflow-hub ./k8s/helm-chart
```

### Uninstall

```bash
helm uninstall ai-workflow-hub
```

### List Releases

```bash
helm list
```

### View Values

```bash
helm show values ./k8s/helm-chart
```

### Dry Run (Test)

```bash
helm install ai-workflow-hub ./k8s/helm-chart --dry-run --debug
```

## Customization

Edit `k8s/helm-chart/values.yaml` to customize:

- Replica counts
- Resource limits
- Image tags
- Service types
- Configuration values

Then upgrade:

```bash
helm upgrade ai-workflow-hub ./k8s/helm-chart
```

## Troubleshooting

### Check Pod Status

```bash
kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Check Services

```bash
kubectl get services
kubectl describe service <service-name>
```

### Check ConfigMaps and Secrets

```bash
kubectl get configmaps
kubectl get secrets
kubectl describe configmap <configmap-name>
```

### Port Forward for Testing

```bash
# API Gateway
kubectl port-forward service/api-gateway 8080:8080

# Nginx
kubectl port-forward service/nginx 8080:80

# PostgreSQL
kubectl port-forward service/postgres 5432:5432

# Redis
kubectl port-forward service/redis 6379:6379
```

## Next Steps

- Set up Ingress for external access
- Configure persistent volumes for PostgreSQL
- Set up monitoring (Prometheus, Grafana)
- Configure logging (ELK, Loki)
- Set up CI/CD with ArgoCD

