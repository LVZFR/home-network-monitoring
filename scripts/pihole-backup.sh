#!/bin/bash
#
# pihole-backup.sh
# Weekly Pi-hole configuration backup using Teleporter
# Keeps the last 8 backups (~2 months of weekly backups)
#
# Repo: https://github.com/LVZFR/home-network-monitoring
#

BACKUP_DIR="/home/don/pihole-backups"
KEEP=8
DATE=$(date +%Y-%m-%d_%H%M)

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR" || exit 1

# Run Teleporter export
# Pi-hole v6 uses pihole-FTL --teleporter; v5 used pihole -a -t
if pihole-FTL --teleporter >/dev/null 2>&1; then
    # v6 names the file itself; stamp it with our date format
    LATEST=$(ls -t pi-hole*teleporter*.zip 2>/dev/null | head -1)
    [ -n "$LATEST" ] && mv "$LATEST" "pihole-backup_${DATE}.zip"
else
    # Fallback for Pi-hole v5
    pihole -a -t "pihole-backup_${DATE}.tar.gz"
fi

# Verify a backup was produced
if ls pihole-backup_${DATE}.* >/dev/null 2>&1; then
    echo "$(date): Backup created: pihole-backup_${DATE}" >> "$BACKUP_DIR/backup.log"
else
    echo "$(date): ERROR - backup failed" >> "$BACKUP_DIR/backup.log"
    exit 1
fi

# Rotation: delete all but the newest $KEEP backups
ls -t pihole-backup_* 2>/dev/null | tail -n +$((KEEP + 1)) | xargs -r rm --

exit 0
