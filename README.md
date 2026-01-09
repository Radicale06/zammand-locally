# Zammad Deployment

Simple Zammad deployment using Docker Compose.

## Quick Start

```bash
./start.sh
```

Access Zammad at: `http://YOUR_SERVER_IP:9000`

## Commands

- Start: `docker-compose up -d`
- Stop: `docker-compose down`
- Logs: `docker-compose logs -f`
- Status: `docker-compose ps`

## Default Login

- Email: `admin@zammad.org`
- Password: Set on first login

## Clean Restart

```bash
docker-compose down -v
./start.sh
```