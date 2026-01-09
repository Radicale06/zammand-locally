# Zammad Deployment Guide

This directory contains everything needed to deploy Zammad for your team's ticketing system.

## Quick Start

1. Run the setup script as root:
   ```bash
   sudo ./setup.sh
   ```

2. Access Zammad at: https://zammad.quickyprime.com

## Manual Installation Steps

If you prefer to install manually:

### 1. Install Prerequisites
```bash
# Docker
curl -fsSL https://get.docker.com | sh

# Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Nginx
sudo apt-get install nginx certbot python3-certbot-nginx
```

### 2. Configure Environment
Edit `.env` file and set a secure PostgreSQL password.

### 3. Start Zammad
```bash
docker-compose up -d
```

### 4. Configure Nginx
```bash
sudo cp nginx-zammad.conf /etc/nginx/sites-available/zammad
sudo ln -s /etc/nginx/sites-available/zammad /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 5. Get SSL Certificate
```bash
sudo certbot certonly --nginx -d zammad.quickyprime.com
```

## Container Management

### Check status:
```bash
docker-compose ps
```

### View logs:
```bash
docker-compose logs -f [service-name]
```

### Stop all containers:
```bash
docker-compose down
```

### Start containers:
```bash
docker-compose up -d
```

### Update Zammad:
```bash
# Update version in .env file
docker-compose pull
docker-compose down
docker-compose up -d
```

## Backup

Run the backup script:
```bash
sudo ./backup.sh
```

Or manually:
```bash
docker-compose exec zammad-backup zammad-backup
```

## Restore from Backup

```bash
# Stop containers
docker-compose down

# Extract backup
tar -xzf /backup/zammad/zammad_backup_YYYYMMDD_HHMMSS.tar.gz

# Copy files to volumes
docker-compose run --rm zammad-init cp -r /path/to/backup/zammad/* /opt/zammad/
docker-compose run --rm zammad-postgresql cp -r /path/to/backup/postgresql/* /var/lib/postgresql/data/

# Start containers
docker-compose up -d
```

## Troubleshooting

### Check container logs:
```bash
docker-compose logs zammad-railsserver
docker-compose logs zammad-nginx
```

### Reset admin password:
```bash
docker-compose exec zammad-railsserver rails c
# In Rails console:
User.find_by(email: 'admin@zammad.org').update(password: 'new_password')
```

### Database connection issues:
Check PostgreSQL password in `.env` matches container configuration.

### Performance tuning:
Edit `docker-compose.yml` to increase memory limits for Elasticsearch and PostgreSQL.

## Security Notes

1. **Change default passwords** immediately after installation
2. **Enable firewall** (ufw is configured by setup script)
3. **Regular backups** - set up cron job for backup.sh
4. **Monitor logs** regularly for suspicious activity
5. **Keep Zammad updated** - check for security updates

## Support

- Official Docs: https://docs.zammad.org/
- Community Forum: https://community.zammad.org/
- GitHub: https://github.com/zammad/zammad