#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
COMPOSE_FILE="$REPO_ROOT/docker-compose.yml"
SERVICE_NAME="${DB_SERVICE_NAME:-db}"
BACKUP_DIR="${BACKUP_DIR:-$REPO_ROOT/backups}"
RESTORE_DB="${POSTGRES_RESTORE_DB:-hotel_assessment_restored}"

if [ $# -gt 0 ]; then
  BACKUP_FILE="$1"
else
  BACKUP_FILE=$(ls -1t "$BACKUP_DIR"/*.dump 2>/dev/null | head -n 1 || true)
fi

if [ -z "${BACKUP_FILE:-}" ] || [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file not found. Pass a .dump file path or run ./scripts/backup.sh first." >&2
  exit 1
fi

docker compose -f "$COMPOSE_FILE" up -d "$SERVICE_NAME" >/dev/null

for _ in $(seq 1 30); do
  if docker compose -f "$COMPOSE_FILE" exec -T "$SERVICE_NAME" sh -lc 'pg_isready -U "$POSTGRES_USER" -d postgres' >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

docker compose -f "$COMPOSE_FILE" exec -T "$SERVICE_NAME" sh -lc "psql -v ON_ERROR_STOP=1 -U \"\$POSTGRES_USER\" -d postgres -c 'DROP DATABASE IF EXISTS \"$RESTORE_DB\";' -c 'CREATE DATABASE \"$RESTORE_DB\";'"

docker compose -f "$COMPOSE_FILE" exec -T "$SERVICE_NAME" sh -lc "pg_restore -U \"\$POSTGRES_USER\" -d \"$RESTORE_DB\" --no-owner --no-privileges" < "$BACKUP_FILE"

echo "Restore completed into database: $RESTORE_DB"
