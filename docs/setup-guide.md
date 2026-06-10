# Setup Guide

## Prerequisites

- Raspberry Pi 3 with SD card
- Asus ZenWiFi XD5 (AX3000) connected to the Starlink router via ethernet
- Mac or Windows PC with SD card reader
- 2x ethernet cables

---

## Part 1: Prepare the SD Card

### Step 1: Download Raspberry Pi Imager
- Get it from **raspberrypi.com/software**
- On Mac, make sure you download the correct build for your hardware (Intel vs Apple Silicon — check **Apple Menu → About This Mac**)

### Step 2: Flash Raspberry Pi OS Lite
1. Insert the SD card into your reader
2. Open Raspberry Pi Imager
3. Choose **Raspberry Pi OS Lite (64-bit)** — no desktop needed for a headless DNS server
4. Before writing, open the **advanced settings** (gear icon / Cmd+Shift+X) and:
   - Set hostname (e.g. `pihole`)
   - **Enable SSH** with password authentication
   - Set username and password
   - Configure Wi-Fi only if not using ethernet
5. Write the image and wait for verification

### Step 3: Boot the Pi
1. Insert the SD card into the Pi
2. Connect the Pi to the ZenWiFi XD5 via ethernet
3. Power it on and give it 1–2 minutes for first boot

---

## Part 2: Connect via SSH

### Step 1: Find the Pi's IP
- Log in to the ZenWiFi XD5 admin panel at `192.168.50.1`
- Check the connected devices / DHCP client list for the Pi

### Step 2: SSH In
```bash
ssh don@192.168.50.xxx
```
Accept the host key prompt and enter your password.

### Step 3: Update the System
```bash
sudo apt update && sudo apt upgrade -y
```

---

## Part 3: Set a Static IP on the Pi

Pi-hole must have a fixed IP so the router's DNS setting never breaks.

Edit the DHCP client config:
```bash
sudo nano /etc/dhcpcd.conf
```

Add at the bottom (adjust interface name if using Wi-Fi):
```
interface eth0
static ip_address=192.168.50.200/24
static routers=192.168.50.1
static domain_name_servers=1.1.1.1 8.8.8.8
```

Reboot and reconnect on the new address:
```bash
sudo reboot
# then
ssh don@192.168.50.200
```

> Alternatively (or additionally), set a DHCP reservation for the Pi's MAC address in the ZenWiFi XD5 so the router never hands `192.168.50.200` to anything else.

---

## Part 4: Install Pi-hole

### Step 1: Run the Installer
```bash
curl -sSL https://install.pi-hole.net | bash
```

Walk through the installer prompts:
1. **Interface:** `eth0`
2. **Upstream DNS:** Cloudflare (1.1.1.1) or your preference
3. **Blocklists:** accept the default (StevenBlack's list)
4. **Admin web interface:** Yes
5. **Web server (lighttpd):** Yes
6. **Query logging:** Yes
7. **Privacy mode:** 0 (show everything)

At the end, the installer displays the admin URL and a generated password — note these down.

### Step 2: Set the Admin Password
```bash
pihole -a -p
```
Enter your chosen password.

> **Note:** On newer Python versions the legacy `crypt` module is removed. If a password-related script fails, use `passlib` instead — see [Troubleshooting](troubleshooting.md).

### Step 3: Verify the Dashboard
Browse to:
```
http://192.168.50.200/admin
```
Log in with your admin password. The dashboard should load with zero or minimal queries at this point.

---

## Part 5: Point the Network at Pi-hole

### Step 1: Set DNS in the ZenWiFi XD5
1. Log in to `192.168.50.1`
2. Go to **LAN → DHCP Server**
3. Under **DNS and WINS Server Setting**, set **DNS Server 1** to `192.168.50.200`
4. Leave DNS Server 2 blank (a fallback DNS lets devices bypass Pi-hole)
5. Click **Apply**

### Step 2: Disable Starlink Wi-Fi
In the Starlink app, disable the built-in Wi-Fi (bypass/router settings) so every device must connect through the ZenWiFi XD5. Devices left on Starlink Wi-Fi will never appear in Pi-hole.

### Step 3: Renew DHCP Leases
Reconnect devices (toggle Wi-Fi off/on, or reboot them) so they pick up the new DNS setting.

### Step 4: Verify
- Watch the Pi-hole dashboard — queries should start appearing within minutes
- Test from any device:
```bash
nslookup doubleclick.net
```
A blocked domain should resolve to `0.0.0.0`.

---

## Part 6: Ongoing Use

- **Identify devices:** In Pi-hole, label clients by their MAC/IP (cross-reference the ZenWiFi XD5 device list)
- **Update Pi-hole:**
```bash
pihole -up
```
- **Update blocklists (gravity):**
```bash
pihole -g
```
- **Keep the OS patched:**
```bash
sudo apt update && sudo apt upgrade -y
```
