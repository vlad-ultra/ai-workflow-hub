#!/bin/bash

# Цвета для вывода
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

BASE_URL="http://localhost:8080"
PASSED=0
FAILED=0

# Функция для проверки ответа
check_response() {
    local test_name="$1"
    local response="$2"
    local expected="$3"
    
    if echo "$response" | grep -q "$expected"; then
        echo -e "${GREEN}✓${NC} $test_name"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} $test_name"
        echo -e "  Response: $response"
        ((FAILED++))
        return 1
    fi
}

echo "=========================================="
echo "  Тестирование всех сервисов"
echo "=========================================="
echo ""

# 1. Health Check API Gateway
echo "1. Проверка API Gateway..."
RESPONSE=$(curl -s "$BASE_URL/health")
check_response "API Gateway Health" "$RESPONSE" "ok"
echo ""

# 2. Auth Service - Login
echo "2. Тестирование Auth Service..."
RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"email":"test@example.com"}')
check_response "Auth Login" "$RESPONSE" "token"
TOKEN=$(echo "$RESPONSE" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
echo ""

# 3. Tasks Service - GET
echo "3. Тестирование Tasks Service (GET)..."
RESPONSE=$(curl -s "$BASE_URL/tasks")
check_response "Get Tasks" "$RESPONSE" "id"
echo ""

# 4. Tasks Service - POST
echo "4. Тестирование Tasks Service (POST)..."
RESPONSE=$(curl -s -X POST "$BASE_URL/tasks" \
    -H "Content-Type: application/json" \
    -d '{"id":100,"title":"Auto Test Task","status":"pending"}')
check_response "Create Task" "$RESPONSE" "task_added"
echo ""

# 5. AI Service - Health
echo "5. Тестирование AI Service (Health)..."
RESPONSE=$(curl -s "$BASE_URL/ai/health")
check_response "AI Health" "$RESPONSE" "ok"
echo ""

# 6. AI Service - Analyze (High Priority)
echo "6. Тестирование AI Service (Analyze - High Priority)..."
RESPONSE=$(curl -s -X POST "$BASE_URL/ai/analyze" \
    -H "Content-Type: application/json" \
    -d '{"title":"Urgent production issue"}')
check_response "AI Analyze High Priority" "$RESPONSE" "high"
echo ""

# 7. AI Service - Analyze (Medium Priority)
echo "7. Тестирование AI Service (Analyze - Medium Priority)..."
RESPONSE=$(curl -s -X POST "$BASE_URL/ai/analyze" \
    -H "Content-Type: application/json" \
    -d '{"title":"Learn Python programming"}')
check_response "AI Analyze Medium Priority" "$RESPONSE" "medium"
echo ""

# 8. AI Service - Analyze (Low Priority)
echo "8. Тестирование AI Service (Analyze - Low Priority)..."
RESPONSE=$(curl -s -X POST "$BASE_URL/ai/analyze" \
    -H "Content-Type: application/json" \
    -d '{"title":"Regular task"}')
check_response "AI Analyze Low Priority" "$RESPONSE" "low"
echo ""

# Итоги
echo "=========================================="
echo "  Результаты тестирования"
echo "=========================================="
echo -e "${GREEN}Пройдено: $PASSED${NC}"
echo -e "${RED}Провалено: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ Все тесты пройдены успешно!${NC}"
    exit 0
else
    echo -e "${RED}✗ Некоторые тесты провалились${NC}"
    exit 1
fi

