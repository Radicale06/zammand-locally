#!/bin/bash

# Simple start script for Zammad

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