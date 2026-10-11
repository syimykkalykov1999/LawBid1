#!/usr/bin/env bash
# Pulls new code from GitHub; rebuilds and restarts only when something changed.
set -euo pipefail
cd /opt/lawbid
BRANCH="${BRANCH:-main}"
git fetch -q --depth 1 origin "$BRANCH"
if [ "${FORCE:-}" = 1 ] || [ "$(git rev-parse HEAD)" != "$(git rev-parse FETCH_HEAD)" ]; then
  git reset -q --hard FETCH_HEAD
  cd lawbid/backend/deploy
  docker compose up -d --build --remove-orphans
  docker image prune -f >/dev/null
fi
