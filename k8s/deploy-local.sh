#!/bin/bash

set -e

echo "🚀 AI Workflow Hub - Local Kubernetes Deployment"
echo "=================================================="

# Check prerequisites
echo ""
echo "📋 Checking prerequisites..."

if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed. Please install it first."
    exit 1
fi

if ! command -v helm &> /dev/null; then
    echo "❌ Helm is not installed. Please install it first."
    exit 1
fi

echo "✅ kubectl found"
echo "✅ Helm found"

# Detect Kubernetes environment
if kubectl cluster-info &> /dev/null; then
    echo "✅ Kubernetes cluster is accessible"
else
    echo "❌ Cannot connect to Kubernetes cluster"
    echo "   Please start Minikube: minikube start"
    echo "   Or configure kubectl for your cluster"
    exit 1
fi

# Check if using Minikube
if command -v minikube &> /dev/null && minikube status &> /dev/null; then
    echo "✅ Minikube detected"
    USE_MINIKUBE=true
    echo "🔄 Using Minikube's Docker daemon..."
    eval $(minikube docker-env)
else
    USE_MINIKUBE=false
    echo "⚠️  Minikube not detected. Assuming images are in registry."
fi

# Build images
if [ "$USE_MINIKUBE" = true ]; then
    echo ""
    echo "🔨 Building Docker images..."
    cd "$(dirname "$0")/.."
    
    docker build -t ai-workflow-hub-api-gateway:latest ./api-gateway
    docker build -t ai-workflow-hub-auth-service:latest ./auth-service
    docker build -t ai-workflow-hub-user-service:latest ./user-service
    docker build -t ai-workflow-hub-tasks-service:latest ./tasks-service
    docker build -t ai-workflow-hub-ai-assistant-service:latest ./ai-assistant-service
    docker build -t ai-workflow-hub-notifications-service:latest ./notifications-service
    
    echo "✅ Images built"
fi

# Deploy with Helm
echo ""
echo "📦 Deploying with Helm..."
cd "$(dirname "$0")/helm-chart"

# Check if release exists
if helm list -n default | grep -q "ai-workflow-hub"; then
    echo "⚠️  Release 'ai-workflow-hub' already exists. Upgrading..."
    helm upgrade ai-workflow-hub . \
        --namespace default \
        --wait \
        --timeout 5m
else
    echo "✨ Installing new release..."
    helm install ai-workflow-hub . \
        --namespace default \
        --create-namespace \
        --wait \
        --timeout 5m
fi

echo "✅ Deployment complete!"

# Wait for pods
echo ""
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=api-gateway --timeout=300s -n default || true
kubectl wait --for=condition=ready pod -l app=nginx --timeout=300s -n default || true

# Show status
echo ""
echo "📊 Deployment Status:"
echo "===================="
kubectl get pods -n default
echo ""
kubectl get services -n default

# Show access information
echo ""
echo "🌐 Access Information:"
echo "======================"

if [ "$USE_MINIKUBE" = true ]; then
    echo "Minikube IP: $(minikube ip)"
    echo ""
    echo "Access via NodePort:"
    minikube service nginx --url -n default || echo "Run: minikube service nginx -n default"
else
    echo "Port forward to access locally:"
    echo "  kubectl port-forward service/nginx 8080:80 -n default"
    echo ""
    echo "Then access: http://localhost:8080"
fi

echo ""
echo "✅ Done! Check the services above for access URLs."

