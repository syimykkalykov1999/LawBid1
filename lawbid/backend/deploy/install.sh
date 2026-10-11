#!/usr/bin/env bash
# One-time setup of the LawBid test server on a fresh Ubuntu/Debian machine.
# Run as root (cloud-init does). Safe to run again: keeps existing secrets.
set -euo pipefail
REPO="${REPO:-https://github.com/syimykkalykov1999/LawBid1.git}"
BRANCH="${BRANCH:-main}"
DIR=/opt/lawbid
WEB_ORIGINS="${WEB_ORIGINS:-https://syimykkalykov1999.github.io}"

if ! command -v docker >/dev/null; then curl -fsSL https://get.docker.com | sh; fi
apt-get install -y -qq git >/dev/null
# 2 GB of swap: the image build is hungry on small machines.
if ! swapon --show | grep -q .; then
  fallocate -l 2G /swapfile && chmod 600 /swapfile && mkdir -p /opt && mkswap /swapfile >/dev/null && swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

[ -d "$DIR/.git" ] || git clone --depth 1 --branch "$BRANCH" "$REPO" "$DIR"
cd "$DIR/lawbid/backend/deploy"

if [ ! -f .env ]; then
  IP="$(curl -fsS https://api.ipify.org)"
  HOST="${IP//./-}.sslip.io"
  r() { head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n'; }
  cat > .env <<EOF
API_HOST=$HOST
S3_HOST=s3.$HOST
WEB_ORIGINS=$WEB_ORIGINS
DB_PASSWORD=$(r)
S3_SECRET=$(r)
JWT_SECRET=$(r)
OTP_SECRET=$(r)
OTP_PEPPER=$(r)
EVENT_PEPPER=$(r)
EOF
  chmod 600 .env
fi

cp update.sh /usr/local/bin/lawbid-update && chmod +x /usr/local/bin/lawbid-update
cat > /etc/systemd/system/lawbid-update.service <<EOF
[Unit]
Description=LawBid test server: pull new code and rebuild
[Service]
Type=oneshot
Environment=BRANCH=$BRANCH
ExecStart=/usr/local/bin/lawbid-update
EOF
cat > /etc/systemd/system/lawbid-update.timer <<EOF
[Unit]
Description=LawBid test server: check for new code every 2 minutes
[Timer]
OnBootSec=1min
OnUnitActiveSec=2min
[Install]
WantedBy=timers.target
EOF
systemctl daemon-reload
FORCE=1 BRANCH="$BRANCH" /usr/local/bin/lawbid-update
systemctl enable --now lawbid-update.timer
echo "Done: https://$(grep ^API_HOST .env | cut -d= -f2)/api/v1"
