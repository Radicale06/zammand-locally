#!/bin/bash

echo "Starting Zammad..."

docker-compose up -d

echo ""
echo "Waiting for services to start..."
sleep 10

echo "Container status:"
docker-compose ps

echo ""
echo "=== IMPORTANT ==="
echo "Zammad will be available at: http://YOUR_SERVER_IP:9000"
echo ""
echo "It may take 2-3 minutes for initial setup to complete."
echo "Check logs with: docker-compose logs -f"
echo ""
echo "Default admin credentials:"
echo "Email: admin@zammad.org"
echo "Password: (set on first login)"