# Baseline measurements

Fill this in **before** you change anything. These numbers are your
reference point for every optimization or migration decision you make
later - without them you're just guessing whether something got better
or worse.

## Environment

| Field | Value |
|---|---|
| Date measured | |
| Git commit | |
| Host machine (CPU / RAM) | |
| `docker compose` version | |
| Number of `web` replicas | |

## Cold start

| Measurement | Value |
|---|---|
| Time from `docker compose up` to first successful `/health/` response | |
| Time from `docker compose up` to first successful `/` response | |

## Endpoint latency (single replica, idle system)

Run each load test script individually and record k6's reported p50/p95/p99.

| Endpoint | Script | p50 (ms) | p95 (ms) | p99 (ms) | Error rate |
|---|---|---|---|---|---|
| `GET /` | `browse.js` | | | | |
| `GET /products/` | `browse.js` | | | | |
| `GET /products/<slug>/` | `browse.js` | | | | |
| Full checkout flow | `checkout.js` | | | | |
| `GET /reports/sales/` | `report.js` | | | | |

## Interference

| Scenario | `browse.js` p95 before | `browse.js` p95 while `report.js` runs concurrently |
|---|---|---|
| Single replica | | |

## Data operations

| Measurement | Value |
|---|---|
| `seed_data` duration | |
| Row count: `auth_user` | |
| Row count: `catalog_product` | |
| Row count: `orders_order` | |
| Row count: `orders_orderitem` | |
| Row count: `payments_payment` | |
| `pg_dump` duration (full DB) | |
| `pg_dump` output size | |
| Restore duration (fresh DB from dump) | |

## Session integrity

| Scenario | `session-integrity.js` result |
|---|---|
| 1 replica | |
| 3 replicas | |
