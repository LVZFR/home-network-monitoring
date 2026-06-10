# Troubleshooting

Real issues hit during this build, with causes and fixes.

---

## SD Card / Imaging Issues

### Raspberry Pi Imager Won't Open on Mac
**Cause:** Wrong build downloaded for your Mac's CPU (Intel vs Apple Silicon).

**Fix:** Check **Apple Menu → About This Mac**, then re-download the matching version from raspberrypi.com/software.

---

## SSH / Linux Issues

### `openssl passwd -6` Fails
**Cause:** Some macOS openssl builds don't support the `-6` (SHA-512) flag when pre-generating password hashes for headless setup.

**Fix:** Generate the hash on the Pi itself, or use Raspberry Pi Imager's advanced settings to set the password instead.

### Python `crypt` Module Missing
**Cause:** The legacy `crypt` module was removed in Python 3.13.

**Fix:** Use `passlib` instead:
```bash
pip3 install passlib
python3 -c "from passlib.hash import sha512_crypt; print(sha512_crypt.hash('yourpassword'))"
```

---

## Pi-hole Issues

### Devices Not Showing in Pi-hole Dashboard
**Cause:** Devices may still be connected to Starlink Wi-Fi instead of the AX1800.

**Fix:**
1. Disable Starlink Wi-Fi in the Starlink app
2. Reconnect all devices to AX1800 Wi-Fi
3. Verify DNS is set correctly in the AX1800 DHCP settings

### Pi-hole Dashboard Not Loading
**Cause:** The Pi may have received a different IP after a reboot.

**Fix:** Set a static IP in `/etc/dhcpcd.conf` as documented in the setup guide. Also check the AX1800 device list for the Pi's current IP.

### Some Devices Bypass Pi-hole
**Cause:** A secondary DNS was set in the router, or the device has hardcoded DNS (common on smart TVs and some IoT gear).

**Fix:** Remove any secondary DNS in the AX1800 DHCP settings. For stubborn devices, set DNS manually on the device to `192.168.0.200`.

---

## Network Issues

### Double NAT Warning
**Cause:** Having two routers (Starlink → AX1800) creates double NAT.

**Impact:** Generally fine for home monitoring. Only an issue if you need port forwarding or strict NAT for gaming.

**Fix (if needed):** Enable IP Passthrough/Bypass Mode in the Starlink app to pass the public IP to the AX1800.
