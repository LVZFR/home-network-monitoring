# Hardware List

## Required Hardware

| Item | Model | Purpose | Notes |
|---|---|---|---|
| Single Board Computer | Raspberry Pi 3 | Runs Pi-hole | Any Pi 3 variant works |
| SD Card | 16GB+ recommended | Pi OS storage | 8GB minimum |
| SD Card Reader | Any | Flash OS to SD card | |
| Router | Asus ZenWiFi XD5 (AX3000) | Secondary router | Any router with configurable DHCP DNS works |
| Ethernet Cable x2 | Cat5e or better | Wired connections | Starlink → ZenWiFi XD5, ZenWiFi XD5 → Pi |
| Power Supply | Micro USB, 2.5A minimum | Powers the Pi | Official Pi PSU recommended |

## Network Equipment

### Asus ZenWiFi XD5 (AX3000)
- Wi-Fi 6 (AX3000) mesh system, expandable with additional nodes
- Dual-band, up to 3000Mbps combined
- Admin panel at `192.168.50.1` (or `router.asus.com`)
- Used as secondary router behind Starlink

### Raspberry Pi 3
- Quad-core 1.2GHz CPU
- 1GB RAM
- Built-in ethernet and Wi-Fi
- Sufficient for Pi-hole on a home network

## Software Required on PC/Mac

| Software | Purpose | Download |
|---|---|---|
| Raspberry Pi Imager or balenaEtcher | Flash OS to SD card | raspberrypi.com/software / etcher.balena.io |
| Terminal (Mac) or PuTTY (Windows) | SSH access to Pi | Built-in on Mac |
| GitHub Desktop (optional) | Manage this repository | desktop.github.com |

## Notes

- Firewalla (easier plug-and-play alternative) is **not available in Australia**
- Starlink router has no admin panel access — this is why a secondary router is required
- Pi 3 Wi-Fi can be used, but ethernet is more reliable for a DNS server
