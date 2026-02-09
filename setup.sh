#!/bin/bash

# Future Technologies Lab Dashboard - Setup Script
# This script helps you set up the dashboard quickly

set -e

echo "========================================="
echo "  Future Technologies Lab Dashboard     "
echo "  Setup Script                          "
echo "========================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker is not installed"
    echo "Please install Docker from: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Error: Docker Compose is not installed"
    echo "Please install Docker Compose from: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✅ Docker is installed"
echo "✅ Docker Compose is installed"
echo ""

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "❌ Error: Docker daemon is not running"
    echo "Please start Docker and try again"
    exit 1
fi

echo "✅ Docker daemon is running"
echo ""

# Check if ports are available
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t &> /dev/null ; then
        echo "⚠️  Warning: Port $1 is already in use"
        echo "   You may need to stop the service using this port or change the port in docker-compose.yml"
        return 1
    else
        echo "✅ Port $1 is available"
        return 0
    fi
}

echo "Checking ports..."
check_port 3000
check_port 5432
echo ""

# Create necessary directories if they don't exist
echo "Creating directory structure..."
mkdir -p grafana/provisioning/datasources
mkdir -p grafana/provisioning/dashboards
mkdir -p grafana/dashboards
echo "✅ Directory structure created"
echo ""

# Start the services
echo "Starting services..."
echo "This may take a few minutes on first run as Docker downloads images..."
echo ""

docker-compose up -d

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check if containers are running
if docker-compose ps | grep -q "Up"; then
    echo "✅ Services are running!"
    echo ""
    echo "========================================="
    echo "  Setup Complete!                       "
    echo "========================================="
    echo ""
    echo "📊 Access Grafana Dashboard:"
    echo "   URL: http://localhost:3000"
    echo ""
    echo "🔐 Default Credentials:"
    echo "   Username: admin"
    echo "   Password: admin"
    echo ""
    echo "👀 Anonymous Viewing: Enabled"
    echo "   Visitors can view dashboards without login"
    echo ""
    echo "📁 Main Dashboard:"
    echo "   http://localhost:3000/d/lab-overview/future-technologies-lab-overview"
    echo ""
    echo "📚 Documentation:"
    echo "   - README.md - Getting started guide"
    echo "   - docs/CUSTOMIZATION.md - Customization options"
    echo "   - docs/TROUBLESHOOTING.md - Common issues"
    echo "   - GITHUB_SETUP.md - GitHub upload instructions"
    echo ""
    echo "🔧 Useful Commands:"
    echo "   View logs:     docker-compose logs -f"
    echo "   Stop services: docker-compose stop"
    echo "   Restart:       docker-compose restart"
    echo "   Remove all:    docker-compose down -v"
    echo ""
else
    echo "❌ Error: Services failed to start"
    echo "Check logs with: docker-compose logs"
    exit 1
fi

# Optional: Open browser (macOS/Linux)
read -p "Would you like to open Grafana in your browser? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open http://localhost:3000
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open http://localhost:3000 2>/dev/null || echo "Please open http://localhost:3000 in your browser"
    else
        echo "Please open http://localhost:3000 in your browser"
    fi
fi

echo ""
echo "Happy visualizing! 🚀"
