#!/usr/bin/env bash
# Поднимает СТАРОЕ приложение (репозиторий LawBid) в облачной сессии на пустой базе,
# чтобы снимать скриншоты для паспортов. Только для чтения старого кода: LawBid не меняется.
# Занимает около 15 минут (скачивает Flutter, собирает веб-версию). Запускать из корня LawBid1.
# Что нужно заранее: клон LawBid рядом (~/LawBid), docker, node 22, redis-server.
set -euo pipefail
OLD="${OLD:-$HOME/LawBid}"
export PATH=/opt/flutter/bin:$PATH
# 1. Flutter (версия из pubspec.lock старого приложения: >=3.47)
[ -x /opt/flutter/bin/flutter ] || { cd /opt && curl -sS -o f.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.7-stable.tar.xz && tar xf f.tar.xz && rm f.tar.xz; git config --global --add safe.directory /opt/flutter; }
# 2. База (образ через зеркало, docker.io тут режет лимитами) и redis
pgrep dockerd >/dev/null || (dockerd >/tmp/dockerd.log 2>&1 &) ; sleep 6
docker run -d --name crdb -p 26257:26257 mirror.gcr.io/cockroachdb/cockroach:v25.3.0 start-single-node --insecure >/dev/null 2>&1 || true
redis-server --daemonize yes >/dev/null
# 3. Сервер: зависимости, миграции, сид, сборка, запуск (демо-мир создаётся сам)
cd "$OLD" && npm ci --ignore-scripts --no-audit --no-fund
cd apps/api && cp -n .env.example .env && sed -i '/^[A-Z0-9_]*=$/d; s/^JOBS_ENABLED=.*/JOBS_ENABLED=false/' .env
npx prisma generate
docker exec crdb ./cockroach sql --insecure -e "CREATE DATABASE IF NOT EXISTS lawbid"
npx prisma migrate deploy && npx prisma db seed && npx nest build
# AWS_* в песочнице это заглушки прокси, серверу они мешают
(env -u AWS_ACCESS_KEY_ID -u AWS_SECRET_ACCESS_KEY -u AWS_CA_BUNDLE nohup node dist/src/main >/tmp/api.log 2>&1 &)
# 4. Веб-версия приложения и сервер статики с прокси на локальный API
cd "$OLD/apps/mobile" && PREVIEW_API_BASE=/api/v1 bash tool/web_preview/build.sh /tmp/old_web /
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
(PREVIEW_API=http://localhost:3000 nohup node "$HERE/serve_local.mjs" /tmp/old_web 8090 >/tmp/serve.log 2>&1 &)
echo "Готово: http://localhost:8090 (только внутри этой сессии)"
