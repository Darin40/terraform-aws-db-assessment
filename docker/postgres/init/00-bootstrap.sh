#!/usr/bin/env bash
set -euo pipefail

shopt -s nullglob

echo "Applying database migrations, indexes, and seed data"

for sql_file in /workspace/database/migrations/*.sql /workspace/database/indexes/*.sql /workspace/database/seeds/*.sql; do
  echo "Running ${sql_file}"
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$sql_file"
done