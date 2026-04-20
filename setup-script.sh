#!/usr/bin/env bash
set -e

echo "===> Start docker containers"
docker compose down -v
docker compose build --no-cache
docker compose up

echo "===> Catalog service: install + migrate"
cd services/catalog-service
bun install --frozen-lockfile
bunx drizzle-kit push
cd ../..

echo "===> Order service: install + migrate"
cd services/order-service
bun install --frozen-lockfile
bunx drizzle-kit push
cd ../..

echo "===> Notification service: install + migrate"
cd services/notification-service
bun install --frozen-lockfile
bunx drizzle-kit push
cd ../..

echo "===> Seed catalog service"
cd services/catalog-service
bun run src/db/seed.ts
cd ../..

echo "===> All setup complete"