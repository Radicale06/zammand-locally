#!/bin/bash

set -e

echo "=== Zammad Setup Script ==="
echo "This script will help you set up Zammad on your server"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root or with sudo${NC}" 
   exit 1
fi

echo "Step 1: Installing prerequisites..."

# Update system
apt-get update && apt-get upgrade -y

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    systemctl enable docker
    systemctl start docker
else
    echo "Docker is already installed"
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
else
    echo "Docker Compose is already installed"
fi

# Install Nginx if not present
if ! command -v nginx &> /dev/null; then
    echo "Installing Nginx..."
    apt-get install -y nginx
    systemctl enable nginx
else
    echo "Nginx is already installed"
fi

# Install Certbot for Let's Encrypt
if ! command -v certbot &> /dev/null; then
    echo "Installing Certbot..."
    apt-get install -y certbot python3-certbot-nginx
else
    echo "Certbot is already installed"
fi

echo -e "${GREEN}Prerequisites installed successfully!${NC}"
echo ""

echo "Step 2: Setting up Zammad..."

# Generate secure password
POSTGRES_PASS=$(openssl rand -base64 32)

# Update .env file with secure password
cat > .env << EOF
# Zammad Configuration
VERSION=6.4.1
RESTART=always
POSTGRES_PASSWORD=${POSTGRES_PASS}
ELASTICSEARCH_ENABLED=true
ELASTICSEARCH_SSL=false
EOF

echo -e "${GREEN}Generated secure database password${NC}"

# Start Zammad containers
echo "Starting Zammad containers..."
docker-compose up -d

echo "Waiting for Zammad to initialize (this may take a few minutes)..."
sleep 30

# Check container status
docker-compose ps

echo ""
echo "Step 3: Configuring Nginx..."

# Copy Nginx configuration
cp nginx-zammad.conf /etc/nginx/sites-available/zammad

# Enable the site
ln -sf /etc/nginx/sites-available/zammad /etc/nginx/sites-enabled/

# Test Nginx configuration
nginx -t

echo ""
echo "Step 4: Setting up SSL with Let's Encrypt..."
echo -e "${YELLOW}Please make sure your subdomain (zammad.quickyprime.com) is pointing to this server's IP address${NC}"
echo ""
read -p "Press enter to continue with SSL setup..."

# Get SSL certificate
certbot certonly --nginx -d zammad.quickyprime.com

# Reload Nginx
systemctl reload nginx

echo ""
echo "Step 5: Setting up firewall..."

# Install ufw if not present
if ! command -v ufw &> /dev/null; then
    apt-get install -y ufw
fi

# Configure firewall
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

echo -e "${GREEN}=== Setup Complete! ===${NC}"
echo ""
echo "Your Zammad installation should now be accessible at:"
echo -e "${GREEN}https://zammad.quickyprime.com${NC}"
echo ""
echo "Default admin credentials:"
echo "Email: admin@zammad.org"
echo "Password: (you'll set this on first login)"
echo ""
echo -e "${YELLOW}Important: Please save your database password securely:${NC}"
echo "PostgreSQL Password: ${POSTGRES_PASS}"
echo ""
echo "To check the status of your containers, run:"
echo "cd $(pwd) && docker-compose ps"
echo ""
echo "To view logs, run:"
echo "cd $(pwd) && docker-compose logs -f"