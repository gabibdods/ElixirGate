#!/usr/bin/env sh
set -e

until pg_isready -h "$POSTGRES_HOST" -p 5432 -U $POSTGRES_USER >/dev/null 2>&1; do
  sleep 1
done

/app/hazegate/bin/hazegate eval "Hazegate.Release.migrate()"

dump() {
  pg_dump -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" > "/dumps/dump_$(date +%F_%H%M%S).sql"
}
trap dump TERM INT

exec /app/hazegate/bin/hazegate start
