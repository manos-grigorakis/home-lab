# Start from `pi-1` directory
cd "$(dirname "$0")/.." || exit 1

echo "Stopping the containers"

# Stop all the containers
docker compose -f dashboards/docker-compose.yml down
docker compose -f dns/docker-compose.yml down
docker compose -f exporters/docker-compose.yml down
docker compose -f monitoring/docker-compose.yml down
docker compose -f reverse-proxy/docker-compose.yml down