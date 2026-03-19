#!/usr/bin/env bash
set -euo pipefail

mkdir -p /root/.config/rclone /tmp/backup
echo "$RCLONE_CONFIG_BASE64" | base64 -d > /root/.config/rclone/rclone.conf

STAMP="$(date -u +%Y-%m-%d_%H-%M-%S)"
FILE="/tmp/backup/zakatin_${STAMP}.dump"
DEST="${GDRIVE_DEST:-gdrive:zakatin-backup}"
RET="${RETENTION:-30d}"

pg_dump --format=custom --no-owner --no-privileges --file "$FILE" "$DATABASE_URL"
rclone copy "$FILE" "$DEST"
rclone delete "$DEST" --min-age "$RET" --rmdirs

echo "Backup selesai"