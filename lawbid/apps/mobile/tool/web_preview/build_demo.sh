#!/usr/bin/env bash
# Веб-версия приложения в демо-режиме: без сервера, ответы берутся из assets/demo/api.json.
# Вход: любой номер и код 000000, либо демо-код (AAAAAAAA адвокат, BBBBBBBB клиент).
#
#   tool/web_preview/build_demo.sh [out_dir] [base_href]
set -euo pipefail
cd "$(dirname "$0")/../.."
OUT="${1:-build/web_demo}"
BASE="${2:-/}"

if [[ ! -f web/index.html ]]; then
  flutter create --platforms=web --project-name lawbid . >/dev/null
  git checkout -- .metadata analysis_options.yaml pubspec.yaml 2>/dev/null || true
fi
cp tool/web_preview/index.html tool/web_preview/flutter_bootstrap.js web/

# drift на вебе: SQLite в wasm и воркер drift тех же версий, что в pubspec.lock.
ver() { awk -v p="  $1:" '$0==p{f=1} f&&/version:/{gsub(/"/,"",$2);print $2;exit}' pubspec.lock; }
DRIFT="$(ver drift)"; SQLITE="$(ver sqlite3)"
[[ -f web/drift_worker.js ]] || curl -fsSL -o web/drift_worker.js \
  "https://github.com/simolus3/drift/releases/download/drift-$DRIFT/drift_worker.js"
[[ -f web/sqlite3.wasm ]] || curl -fsSL -o web/sqlite3.wasm \
  "https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-$SQLITE/sqlite3.wasm"

flutter pub get >/dev/null
dart run build_runner build --delete-conflicting-outputs >/dev/null
CONFIG="$(mktemp -d)/demo.json"
sed 's#"API_BASE_URL": *"[^"]*"#"API_BASE_URL": "http://demo.invalid/api/v1"#' config/prod.example.json > "$CONFIG"
flutter build web --release -t lib/main_prod.dart \
  --dart-define-from-file="$CONFIG" --dart-define=DEMO_MODE=true \
  --no-web-resources-cdn --base-href "$BASE" -o "$OUT"
rm -f "$CONFIG"
printf 'User-agent: *\nDisallow: /\n' > "$OUT/robots.txt"
git rev-parse --short HEAD > "$OUT/preview-commit.txt"
echo "Built $OUT ($(cat "$OUT/preview-commit.txt"))"
