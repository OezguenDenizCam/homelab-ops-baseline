# Homelab – Linux/IT Operations Baseline (Ubuntu Server in VMware)

**Ziel:** Praxisaufbau für eine Ausbildung **Fachinformatiker/in Systemintegration (Start 2026)** im Raum **Frankfurt am Main**.  
Fokus: **Linux/IT Operations**, **Security-Basics (Hardening/Logging)** und **einfache Automatisierung** (Script + Cron).

> Hinweis: Dieses Repo enthält **keine Secrets/Keys/Passwörter**. Alle Nachweise sind bewusst minimal und sicher.

---

## Kurzüberblick
- **Server:** Ubuntu Server (VMware)
- **Hardening:** SSH (Key-only, Root off, Password off), UFW, Fail2ban
- **Ops:** Systemcheck-Script + Cron, Logrotate, unattended-upgrades
- **Proof:** Original-Ausgaben/Snapshots direkt aus dem System (anklickbar)

---

## Setup
- Ubuntu Server als VM (VMware)
- Netzwerk eingerichtet (IP erreichbar)

---

## Security Baseline
- **SSH Hardening:** SSH-Key-Login aktiviert, Root-Login deaktiviert, Passwortauthentifizierung deaktiviert  
- **UFW Firewall:** default deny incoming / allow outgoing; inbound nur **22/tcp (SSH)** & **80/tcp (HTTP)**
- **Fail2ban:** installiert & gestartet (Brute-Force-Schutz, Logquelle: `/var/log/auth.log`)

---

## Services
- **Apache Webserver** installiert & betrieben (Testseite / HTML/CSS Landingpage)

---

## Troubleshooting Workflow (Basics)
- Service-Checks: `systemctl`
- Netzwerk/Port-Checks: `ss`, `curl`
- Logs: `journalctl`, `/var/log`, Apache access/error logs

## Störungsfall-Simulation (Outage Drill): HTTP lokal OK (200), von außen nicht erreichbar
Ich habe den Fehler bewusst erzeugt bzw. reproduziert, um einen realistischen „local works, remote fails“-Fall zu üben.

- **Symptom:** Auf dem Server liefert `curl` lokal **HTTP 200**, aber von außen (Windows) ist HTTP nicht erreichbar.
- **Ziel:** Differenzieren zwischen **Service-Problem** vs. **Netzwerk/Firewall-Problem**.

### Vorgehen (Workflow)
1) **Lokaler HTTP-Check auf dem Server**
   - `curl -I http://127.0.0.1`
   - `curl -I http://<server-ip>`
   - Ergebnis: **HTTP 200** → Apache läuft grundsätzlich.

2) **Listener/Binding prüfen**
   - `ss -tulpn | grep :80`
   - Erwartung: Apache hört auf `0.0.0.0:80` oder `<server-ip>:80` (nicht nur `127.0.0.1:80`)

3) **Externer Check von Windows (PowerShell)**
   - `curl.exe -I http://<server-ip>`
   - Ergebnis: **keine Verbindung / Timeout** → Problem liegt sehr wahrscheinlich **zwischen Client und Server** (Firewall/Netzwerk).

4) **Firewall prüfen**
   - `sudo ufw status verbose`
   - Erwartung: `80/tcp ALLOW IN`

### Fix (typisch)
- Wenn Port 80 nicht erlaubt war:
  - `sudo ufw allow 80/tcp`
  - `sudo ufw reload`

### Verifikation
- `sudo ufw status verbose` → `80/tcp ALLOW IN`
- Windows: `curl.exe -I http://<server-ip>` → HTTP-Response kommt zurück
- Optional: `ss -tulpn | grep :80` + Apache logs check

### Evidence (Snapshots)
- Apache Status: [`configs/apache2_systemctl_status.txt`](configs/apache2_systemctl_status.txt)
- Port 80 Listener: [`configs/ss_listening_80.txt`](configs/ss_listening_80.txt)
- Local curl (200): [`configs/curl_localhost.txt`](configs/curl_localhost.txt)
- Server-IP curl: [`configs/curl_server_ip.txt`](configs/curl_server_ip.txt)
- UFW Status: [`configs/ufw_status_verbose.txt`](configs/ufw_status_verbose.txt)

### Lernpunkt
- **Lokaler 200** beweist: Service läuft.
- **Externer Fail** beweist: Netzwerkpfad/Firewall/Binding ist der Engpass.
- Deshalb immer: **local test + external test + firewall/listener check**.


---

## Automation & Monitoring Basics
- [`system_check.sh`](system_check.sh) – gibt `date`, `uptime`, `df`, `free` und Service-Status aus  
- Logging via `>>` und `2>&1`
- Cronjob: tägliche Ausführung **08:00** (mit absoluten Pfaden)
- Logrotate: Rotation + Komprimierung verifiziert (`.gz`)
- unattended-upgrades: automatische Security-Updates (Auto-Reboot bewusst deaktiviert)

---

## So wird es auf dem Server genutzt
Das Script läuft auf meinem Ubuntu-Server (VM) per Cron täglich um 08:00 und schreibt in ein Logfile.

- Script: [`system_check.sh`](system_check.sh)
- Logfile: `/home/deniz/system_check.log`
- Cron: siehe [`configs/cron.txt`](configs/cron.txt)

---

## Repo-Inhalt (Originale Snapshots vom Server)
- [`system_check.sh`](system_check.sh) – Daily system check script
- [`configs/cron.txt`](configs/cron.txt) – Cron schedule (08:00) + logfile redirect
- [`configs/ufw_status_verbose.txt`](configs/ufw_status_verbose.txt) – UFW Snapshot (inbound nur 22/tcp & 80/tcp)
- [`configs/sshd_effective_settings.txt`](configs/sshd_effective_settings.txt) – Effective SSH settings (root login off, password auth off, pubkey auth on)
- [`configs/fail2ban_status.txt`](configs/fail2ban_status.txt) – Fail2ban Status (jail: sshd)
- [`configs/logrotate_systemcheck_check.txt`](configs/logrotate_systemcheck_check.txt) – Logrotate-Regel für `system_check.log`
- [`configs/system_check_log_listing.txt`](configs/system_check_log_listing.txt) – Rotation-Beleg (`.1.gz` vorhanden)
- [`configs/20auto-upgrades.txt`](configs/20auto-upgrades.txt) – Auto-Updates aktiv
- [`configs/50unattended-upgrades_key_settings.txt`](configs/50unattended-upgrades_key_settings.txt) – Key Settings (u.a. `Automatic-Reboot "false"`)

- ## Was ich dabei gelernt habe
- Ubuntu Server in VMware sauber aufsetzen und Netzwerk so konfigurieren, dass die VM zuverlässig erreichbar ist
- SSH Hardening praktisch umsetzen (Key-only, Root-Login aus, Passwortauth aus) und die **wirksamen** Einstellungen verifizieren (`sshd -T`)
- Firewall-Regeln als Baseline setzen (UFW: default deny incoming / allow outgoing) und nur benötigte Ports freigeben (22/80)
- Brute-Force-Schutz mit Fail2ban verstehen (Jail `sshd`, Logquelle `/var/log/auth.log`) und Status/Filter/Actions prüfen
- Standard-Troubleshooting im Linux-Betrieb: Services (`systemctl`), Ports/Sockets (`ss`), HTTP-Checks (`curl`), Logs (`journalctl`, `/var/log`)
- Automatisierung mit Bash + Cron: wiederholbare Checks per Script, Ausgabe/Fehler sauber in Logfiles schreiben (`>>` und `2>&1`)
- Log-Hygiene mit Logrotate: Rotation, Komprimierung und Aufbewahrung (rotate 7) nachvollziehbar verifizieren (`.gz` vorhanden)
- Patch-Management Basics: unattended-upgrades aktivieren und eine sichere Entscheidung treffen (Auto-Reboot bewusst deaktiviert)

