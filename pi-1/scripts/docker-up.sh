# Start from `pi-1` directory
cd "$(dirname "$0")/.." || exit 1

echo "Starting the containers"

# Start all the containers in detached mode
docker compose -f dashboards/docker-compose.yml up -d
docker compose -f dns/docker-compose.yml up -d
docker compose -f exporters/docker-compose.yml up -d
docker compose -f monitoring/docker-compose.yml up -d
docker compose -f reverse-proxy/docker-compose.yml up -d