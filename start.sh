#!/bin/bash

# Simple start script for Zammad

# Check if .env exists
if [ ! -f .env ]; then
    echo "Creating .env file with default values..."
    cat > .env << EOF
# Zammad Configuration
VERSION=6.4.1
RESTART=always
POSTGRES_PASSWORD=postgres
ELASTICSEARCH_ENABLED=true
ELASTICSEARCH_SSL=false
EOF
fi

echo "Starting Zammad on port 9000..."
docker-compose up -d

echo ""
echo "Checking container status..."
docker-compose ps

echo ""
echo "Zammad is accessible at:"
echo "- http://your-server-ip:9000"
echo "- http://zammad.quickyprime.com:9000 (if DNS is configured)"
echo ""
echo "Default admin login:"
echo "- Email: admin@zammad.org"
echo "- Set password on first login"
echo ""
echo "To view logs: docker-compose logs -f"
echo "To stop: docker-compose down"