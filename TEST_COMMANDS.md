# Service Testing Commands

## Setup

### Start all services
```bash
cd /Users/vladstadnyk/infrusctucture/ai-workflow-hub
docker-compose up -d
```

### Check container status
```bash
docker ps
```

### View service logs
```bash
docker logs api-gateway
docker logs auth-service
docker logs user-service
docker logs tasks-service
docker logs ai-assistant-service
docker logs notifications-service
```

---

## Testing via API Gateway (port 8080)

### 1. API Gateway Health Check
```bash
curl http://localhost:8080/health
```

**Expected response:**
```json
{"status":"ok","service":"api-gateway"}
```

---

### 2. Auth Service Testing

#### 2.1. Login (get JWT token)
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com"}'
```

**Expected response:**
```json
{"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."}
```

#### 2.2. Login with different email
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com"}'
```

---

### 3. Tasks Service Testing

#### 3.1. Get all tasks
```bash
curl http://localhost:8080/tasks
```

**Expected response:**
```json
[
  {"id":1,"title":"Learn Docker","status":"in-progress"},
  {"id":2,"title":"Deploy to Kubernetes","status":"pending"}
]
```

#### 3.2. Add new task
```bash
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "id": 3,
    "title": "Test new task",
    "status": "pending"
  }'
```

**Expected response:**
```json
{"msg":"task_added","task":{"id":3,"title":"Test new task","status":"pending"}}
```

#### 3.3. Add task with "in-progress" status
```bash
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "id": 4,
    "title": "Fix bug in production",
    "status": "in-progress"
  }'
```

#### 3.4. Verify task was added
```bash
curl http://localhost:8080/tasks
```

---

### 4. AI Assistant Service Testing

#### 4.1. AI Service Health Check
```bash
curl http://localhost:8080/ai/health
```

**Expected response:**
```json
{"status":"ok","service":"ai-assistant-service"}
```

#### 4.2. Analyze task with high priority (urgent/production)
```bash
curl -X POST http://localhost:8080/ai/analyze \
  -H "Content-Type: application/json" \
  -d '{"title":"Urgent production issue"}'
```

**Expected response:**
```json
{"category":"incident","priority":"high"}
```

#### 4.3. Analyze task with "prod" priority
```bash
curl -X POST http://localhost:8080/ai/analyze \
  -H "Content-Type: application/json" \
  -d '{"title":"Fix prod database"}'
```

**Expected response:**
```json
{"category":"incident","priority":"high"}
```

#### 4.4. Analyze learning task
```bash
curl -X POST http://localhost:8080/ai/analyze \
  -H "Content-Type: application/json" \
  -d '{"title":"Learn Python programming"}'
```

**Expected response:**
```json
{"category":"learning","priority":"medium"}
```

#### 4.5. Analyze task with "study" keyword
```bash
curl -X POST http://localhost:8080/ai/analyze \
  -H "Content-Type: application/json" \
  -d '{"title":"Study Kubernetes"}'
```

**Expected response:**
```json
{"category":"learning","priority":"medium"}
```

#### 4.6. Analyze regular task (general)
```bash
curl -X POST http://localhost:8080/ai/analyze \
  -H "Content-Type: application/json" \
  -d '{"title":"Regular task"}'
```

**Expected response:**
```json
{"category":"general","priority":"low"}
```

---

## Direct Testing (inside Docker network)

### Check Tasks Service directly
```bash
docker exec tasks-service curl -s http://localhost:4002/health
docker exec tasks-service curl -s http://localhost:4002/tasks
```

### Check AI Assistant Service directly
```bash
docker exec ai-assistant-service curl -s http://localhost:4003/health
docker exec ai-assistant-service curl -s http://localhost:4003/analyze \
  -X POST -H "Content-Type: application/json" \
  -d '{"title":"Test"}'
```

### Check Auth Service directly
```bash
docker exec auth-service curl -s http://localhost:4000/health
docker exec auth-service curl -s http://localhost:4000/login \
  -X POST -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}'
```

---

## Comprehensive Testing (full scenario)

### Scenario: Create task and analyze via AI
```bash
# 1. Get task list
curl http://localhost:8080/tasks

# 2. Create new task
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "id": 5,
    "title": "Urgent: Fix production bug",
    "status": "pending"
  }'

# 3. Analyze task via AI
curl -X POST http://localhost:8080/ai/analyze \
  -H "Content-Type: application/json" \
  -d '{"title":"Urgent: Fix production bug"}'

# 4. Get updated task list
curl http://localhost:8080/tasks
```

---

## Testing with JWT Token

### Get token and use for verification
```bash
# 1. Get token
TOKEN=$(curl -s -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com"}' | jq -r '.token')

# 2. Use token (if there was a protected endpoint)
echo "Token: $TOKEN"

# 3. Verify token directly in auth-service
docker exec auth-service curl -s http://localhost:4000/verify \
  -H "Authorization: Bearer $TOKEN"
```

---

## Infrastructure Checks

### Check PostgreSQL
```bash
docker exec postgres psql -U app -d postgres -c "SELECT version();"
```

### Check Redis
```bash
docker exec redis redis-cli ping
```

### Check Redis connection from notifications-service
```bash
docker exec notifications-service node -e "const Redis = require('ioredis'); const r = new Redis({host: 'redis', port: 6379}); r.ping().then(console.log).then(() => r.quit());"
```

---

## Testing with Script

### Create test script
```bash
cat > test_all.sh << 'EOF'
#!/bin/bash

echo "=== Testing API Gateway ==="
curl -s http://localhost:8080/health | jq

echo -e "\n=== Testing Auth Service ==="
curl -s -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}' | jq

echo -e "\n=== Testing Tasks Service (GET) ==="
curl -s http://localhost:8080/tasks | jq

echo -e "\n=== Testing Tasks Service (POST) ==="
curl -s -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"id":999,"title":"Script Test","status":"pending"}' | jq

echo -e "\n=== Testing AI Service (Health) ==="
curl -s http://localhost:8080/ai/health | jq

echo -e "\n=== Testing AI Service (Analyze) ==="
curl -s -X POST http://localhost:8080/ai/analyze \
  -H "Content-Type: application/json" \
  -d '{"title":"Urgent production fix"}' | jq

echo -e "\n=== All tests completed ==="
EOF

chmod +x test_all.sh
./test_all.sh
```

---

## Log Checking for Debugging

### View logs of all services
```bash
# API Gateway
docker logs api-gateway --tail 50

# Auth Service
docker logs auth-service --tail 50

# Tasks Service
docker logs tasks-service --tail 50

# AI Assistant Service
docker logs ai-assistant-service --tail 50

# Notifications Service
docker logs notifications-service --tail 50
```

### View logs in real-time
```bash
docker-compose logs -f api-gateway
```

---

## Restart Services for Testing

### Rebuild and restart specific service
```bash
docker-compose build api-gateway
docker-compose up -d api-gateway
```

### Rebuild and restart all services
```bash
docker-compose build
docker-compose up -d
```

### Stop all services
```bash
docker-compose down
```

### Stop and remove volumes
```bash
docker-compose down -v
```

---

## Useful Debugging Commands

### Check Docker network
```bash
docker network inspect ai-workflow-hub_backend
```

### Check container environment variables
```bash
docker exec api-gateway env | grep SERVICE_URL
```

### Execute command inside container
```bash
docker exec -it api-gateway sh
docker exec -it tasks-service bash
```

### Check if ports are open
```bash
netstat -an | grep 8080
lsof -i :8080
```

---

## Testing Examples with jq (for pretty output)

If `jq` is installed:
```bash
# Pretty JSON output
curl -s http://localhost:8080/tasks | jq

# Extract specific field
curl -s http://localhost:8080/auth/login \
  -X POST -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}' | jq -r '.token'
```

---

## Testing Checklist

- [ ] API Gateway health check works
- [ ] Auth Service: login returns JWT token
- [ ] Tasks Service: GET /tasks returns task list
- [ ] Tasks Service: POST /tasks creates new task
- [ ] AI Service: health check works
- [ ] AI Service: analyzing urgent tasks returns priority="high"
- [ ] AI Service: analyzing learning tasks returns priority="medium"
- [ ] AI Service: analyzing regular tasks returns priority="low"
- [ ] All services are running and working
- [ ] Logs don't contain critical errors
