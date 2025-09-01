#!/bin/bash

# AI Models Docker Deployment Script
# This script sets up and starts all AI models for the OneLastAI platform

set -e

echo "🚀 Starting AI Models Docker Deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}[DEPLOY]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    print_error "docker-compose is not installed. Please install docker-compose and try again."
    exit 1
fi

print_header "AI Models Deployment for OneLastAI Platform"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check available system resources
print_status "Checking system resources..."
TOTAL_MEM=$(free -g | awk '/^Mem:/{print $2}')
AVAILABLE_MEM=$(free -g | awk '/^Mem:/{print $7}')

echo "Total Memory: ${TOTAL_MEM}GB"
echo "Available Memory: ${AVAILABLE_MEM}GB"

if [ "$AVAILABLE_MEM" -lt 16 ]; then
    print_warning "System has less than 16GB available memory. Some models may not start properly."
    echo "Recommended: 32GB+ RAM for optimal performance"
fi

# Create necessary directories
print_status "Creating necessary directories..."
mkdir -p logs/ai-models
mkdir -p data/models
mkdir -p config/nginx

# Start the AI models
print_header "Starting AI Model Services..."

# Pull the latest ollama image
print_status "Pulling latest Ollama Docker image..."
docker pull ollama/ollama:latest

# Start AI models in the background
print_status "Starting AI model containers..."
docker-compose -f docker-compose.ai-models.yml up -d

# Wait for services to be ready
print_status "Waiting for services to start..."
sleep 30

# Check service health
print_header "Checking Service Health..."

check_service() {
    local service_name=$1
    local port=$2
    local max_attempts=30
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        if curl -s -f "http://localhost:$port/api/version" > /dev/null 2>&1; then
            print_status "$service_name is healthy (port $port)"
            return 0
        fi
        echo -n "."
        sleep 2
        ((attempt++))
    done
    
    print_error "$service_name failed to start (port $port)"
    return 1
}

echo "Checking model services..."
check_service "Llama 3.2" 11434 &
check_service "Gemma 3" 11435 &
check_service "Phi-4" 11436 &
check_service "DeepSeek" 11437 &
check_service "GPT-OSS" 11438 &

wait

# Check gateway
print_status "Checking AI Gateway..."
if curl -s -f "http://localhost:8080/health" > /dev/null 2>&1; then
    print_status "AI Gateway is healthy (port 8080)"
else
    print_warning "AI Gateway may still be starting..."
fi

# Display service status
print_header "Service Status Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "🤖 AI Models:"
echo "  • Llama 3.2 (3.21B):     http://localhost:11434"
echo "  • Gemma 3 (3.88B):       http://localhost:11435"  
echo "  • Phi-4 (14.66B):        http://localhost:11436"
echo "  • DeepSeek (8.03B):      http://localhost:11437"
echo "  • GPT-OSS:               http://localhost:11438"
echo ""
echo "🌐 AI Gateway:             http://localhost:8080"
echo "📊 Gateway API:            http://localhost:8080/api/status"
echo ""

# Display resource usage
print_header "Current Resource Usage"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" $(docker ps --format "{{.Names}}" | grep -E "(llama32|gemma3|phi4|deepseek|gpt_oss|ai_model_gateway)")

echo ""
print_header "Deployment Complete!"
print_status "All AI models are now running and ready for production use."
print_status "You can check the status anytime with: docker-compose -f docker-compose.ai-models.yml ps"

echo ""
print_status "Next steps:"
echo "  1. Test the models: curl http://localhost:8080/api/status"
echo "  2. Start your Rails application"
echo "  3. Navigate to CineGen or other agents to test AI functionality"

print_warning "Note: First API calls may be slower as models initialize."
