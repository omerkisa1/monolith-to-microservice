#!/bin/sh
set -e

: "${POSTGRES_NAME:?POSTGRES_NAME required}"
: "${POSTGRES_USER:?POSTGRES_USER required}"
: "${POSTGRES_PASSWORD:?POSTGRES_PASSWORD required}"

export PGPASSWORD="$POSTGRES_PASSWORD"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/backups/storefront_${DATE}.dump"

mkdir -p /backups
echo "Starting pg_dump..."
pg_dump -h db -U "$POSTGRES_USER" -Fc "$POSTGRES_NAME" -f "$FILE"
echo "backup ok $FILE $(stat -c%s "$FILE") bytes"

find /backups -name "*.dump" -mtime +7 -delete
echo "retention: pruned dumps older than 7 days"

/usr/local/bin/restore_verify.sh "$FILE"
