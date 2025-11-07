# Quick Testing Guide

## 🚀 Quick Start

```bash
# Start all services
docker-compose up -d

# Run automated testing
./test_services.sh
```

## 📋 Main Testing Commands

### Health Checks
```bash
curl http://localhost:8080/health
curl http://localhost:8080/ai/health
```

### Auth Service
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com"}'
```

### Tasks Service
```bash
# Get tasks
curl http://localhost:8080/tasks

# Add task
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"id":1,"title":"Test","status":"pending"}'
```

### AI Service
```bash
# Analyze task
curl -X POST http://localhost:8080/ai/analyze \
  -H "Content-Type: application/json" \
  -d '{"title":"Urgent production issue"}'
```

## 🔍 Useful Commands

```bash
# View logs
docker logs api-gateway --tail 20

# Container status
docker ps

# Restart service
docker-compose restart api-gateway

# Rebuild and restart
docker-compose build api-gateway && docker-compose up -d api-gateway
```

## 📚 Detailed Documentation

See `TEST_COMMANDS.md` for the complete list of testing commands.
