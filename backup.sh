#!/bin/bash

# Zammad Backup Script
BACKUP_DIR="/backup/zammad"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="zammad_backup_${DATE}"

echo "Starting Zammad backup..."

# Create backup directory if it doesn't exist
mkdir -p ${BACKUP_DIR}

# Run Zammad backup
docker-compose exec -T zammad-backup zammad-backup

# Copy backup files from container
docker cp zammad-deployment_zammad-backup_1:/var/tmp/zammad/. ${BACKUP_DIR}/${BACKUP_NAME}/

# Compress backup
cd ${BACKUP_DIR}
tar -czf ${BACKUP_NAME}.tar.gz ${BACKUP_NAME}/
rm -rf ${BACKUP_NAME}/

# Keep only last 7 backups
find ${BACKUP_DIR} -name "zammad_backup_*.tar.gz" -type f -mtime +7 -delete

echo "Backup completed: ${BACKUP_DIR}/${BACKUP_NAME}.tar.gz"