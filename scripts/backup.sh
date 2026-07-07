#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
COMPOSE_FILE="$REPO_ROOT/docker-compose.yml"
SERVICE_NAME="${DB_SERVICE_NAME:-db}"
BACKUP_DIR="${BACKUP_DIR:-$REPO_ROOT/backups}"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_FILE="$BACKUP_DIR/postgres-$TIMESTAMP.dump"

mkdir -p "$BACKUP_DIR"

docker compose -f "$COMPOSE_FILE" up -d "$SERVICE_NAME" >/dev/null

for _ in $(seq 1 30); do
  if docker compose -f "$COMPOSE_FILE" exec -T "$SERVICE_NAME" sh -lc 'pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"' >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

docker compose -f "$COMPOSE_FILE" exec -T "$SERVICE_NAME" sh -lc 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" -Fc' > "$BACKUP_FILE"

echo "Backup created: $BACKUP_FILE"
