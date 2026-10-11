#!/usr/bin/env bash
# Создаёт два демо-аккаунта (адвокат, клиент) и коды AAAAAAAA / BBBBBBBB для входа. Нужен запущенный сервер на :3000.
cd "$(dirname "$0")"
redis-cli flushall >/dev/null
node -e "import('./login.mjs').then(async m=>{await m.loginDemo('+12025550116','attorney');await m.loginDemo('+12025550117','client');})"
H1=$(printf 'AAAAAAAA' | sha256sum | cut -d' ' -f1); H2=$(printf 'BBBBBBBB' | sha256sum | cut -d' ' -f1)
D="docker exec crdb ./cockroach sql --insecure -d lawbid --format=csv -e"
$D "update demo_accounts set invite_code_hash='$H1', invite_expires_at=now()+interval '7 days' where role='attorney'; update demo_accounts set invite_code_hash='$H2', invite_expires_at=now()+interval '7 days' where role='client'"
