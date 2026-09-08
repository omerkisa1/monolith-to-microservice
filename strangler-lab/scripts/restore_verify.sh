#!/bin/sh
set -e

FILE=${1:?usage: restore_verify.sh /backups/xxx.dump}
: "${POSTGRES_NAME:?POSTGRES_NAME required}"
: "${POSTGRES_USER:?POSTGRES_USER required}"
: "${POSTGRES_PASSWORD:?POSTGRES_PASSWORD required}"

export PGPASSWORD="$POSTGRES_PASSWORD"

VDB="restore_verify"

echo "Restore verification for: $FILE"

psql -h db -U "$POSTGRES_USER" postgres -c "DROP DATABASE IF EXISTS $VDB;" > /dev/null
psql -h db -U "$POSTGRES_USER" postgres -c "CREATE DATABASE $VDB OWNER $POSTGRES_USER;" > /dev/null

pg_restore -h db -U "$POSTGRES_USER" -d "$VDB" "$FILE"

ORDERS=$(psql -h db -U "$POSTGRES_USER" "$VDB" -tAc "select count(*) from orders_order;")
echo "restore verify ok $FILE orders_order=$ORDERS"

psql -h db -U "$POSTGRES_USER" postgres -c "DROP DATABASE $VDB;" > /dev/null
echo "cleanup: dropped $VDB"
