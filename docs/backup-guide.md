# Backup Guide

Weekly automated backups of the Pi-hole configuration using Teleporter and cron.

## What Gets Backed Up

Pi-hole's **Teleporter** exports everything that defines your setup:

- Adlists (blocklists)
- Whitelist / blacklist / regex filters
- Local DNS records and CNAMEs
- Client and group assignments
- DHCP settings (if used)

It does **not** back up the query history database — only configuration. That's intentional: config is what you can't easily recreate.

## Setup

### Step 1: Copy the Script to the Pi

From your Mac, inside the repo folder:

```bash
scp scripts/pihole-backup.sh pi@192.168.0.200:/home/pi/
```

### Step 2: Make It Executable

SSH into the Pi and set permissions:

```bash
ssh pi@192.168.0.200
chmod +x /home/pi/pihole-backup.sh
```

### Step 3: Test It Manually

```bash
sudo /home/pi/pihole-backup.sh
ls -lh /home/pi/pihole-backups/
```

You should see a dated backup file and a `backup.log`.

### Step 4: Schedule It with Cron

Teleporter needs root, so add it to **root's** crontab:

```bash
sudo crontab -e
```

Add this line (runs every Sunday at 3:00 AM):

```
0 3 * * 0 /home/pi/pihole-backup.sh
```

Save and exit. Verify it's registered:

```bash
sudo crontab -l
```

### Cron Syntax Reference

```
┌──────── minute (0–59)
│ ┌────── hour (0–23)
│ │ ┌──── day of month (1–31)
│ │ │ ┌── month (1–12)
│ │ │ │ ┌ day of week (0–6, 0 = Sunday)
0 3 * * 0  /home/pi/pihole-backup.sh
```

## Rotation

The script keeps the **last 8 backups** (~2 months of weekly snapshots) and deletes older ones automatically. Adjust the `KEEP` variable in the script to change this.

## Restoring a Backup

1. Open the Pi-hole admin panel: `http://192.168.0.200/admin`
2. Go to **Settings → Teleporter**
3. Under **Import**, choose the backup file and click **Import**

For a fresh Pi (e.g. dead SD card): reinstall Pi-hole first using the [Setup Guide](setup-guide.md), then import the backup.

## Off-Pi Copies (Recommended)

Backups stored on the same SD card die with the SD card. Pull the latest backup to your Mac periodically:

```bash
scp pi@192.168.0.200:/home/pi/pihole-backups/$(ssh pi@192.168.0.200 'ls -t /home/pi/pihole-backups/pihole-backup_* | head -1 | xargs basename') ~/Documents/pihole-backups/
```

Or simply:

```bash
scp "pi@192.168.0.200:/home/pi/pihole-backups/pihole-backup_*" ~/Documents/pihole-backups/
```

## Monitoring

Check the backup log anytime:

```bash
ssh pi@192.168.0.200 'tail /home/pi/pihole-backups/backup.log'
```

Each run appends a dated success or error line.
