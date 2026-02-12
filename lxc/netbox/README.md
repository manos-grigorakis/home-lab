# Netbox Deployment (Docker Compose)

## 1. Copy Docker Compose override
```bash
cp docker-compose.override.yml.example netbox-docker/docker-compose.override.yml
```

## 2. Copy environment templates:
```bash
cp env/netbox.env.example env/netbox.env
cp env/postgres.env.example env/postgres.env
cp env/redis.env.example env/redis.env
cp env/redis-cache.env.example env/redis-cache.env
```

## 3. Configure environment variables
>[Official Docs](https://github.com/netbox-community/netbox-docker/wiki/Configuration)
### Generate `SECRET_KEY`
```bash
docker compose run netbox python3 /opt/netbox/netbox/generate_secret_key.py
```
### Generate `API_TOKEN_PEPPER_1`
```bash
openssl rand -hex 32
```
Modify the remaining environment variables as needed

## 4. Run
```bash
cd netbox-docker
docker compose up -d
```

## 5. Create superuser
```bash
docker compose exec netbox /opt/netbox/netbox/manage.py createsuperuser
```