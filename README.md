# Homelab – Linux/IT Operations Baseline (Ubuntu Server in VMware)

**Ziel:** Praxisaufbau für eine Ausbildung **Fachinformatiker/in Systemintegration (Start 2026)** im Raum **Frankfurt am Main**.  
Fokus: **Linux/IT Operations**, **Security-Basics (Hardening/Logging)** und **einfache Automatisierung** (Script + Cron).

> Hinweis: Dieses Repo enthält **keine Secrets/Keys/Passwörter**. Alle Nachweise sind bewusst minimal und sicher.

---

## Quick Overview
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

---

## Automation & Monitoring Basics
- [`system_check.sh`](system_check.sh) – gibt `date`, `uptime`, `df`, `free` und Service-Status aus  
- Logging via `>>` und `2>&1`
- Cronjob: tägliche Ausführung **08:00** (mit absoluten Pfaden)
- Logrotate: Rotation + Komprimierung verifiziert (`.gz`)
- unattended-upgrades: automatische Security-Updates (Auto-Reboot bewusst deaktiviert)

---

## How it’s used (on the server)
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

