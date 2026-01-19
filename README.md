# Homelab – Linux/IT Operations Baseline (Ubuntu Server in VMware)

**Ziel:** Praxisaufbau für die Ausbildung **Fachinformatiker/in Systemintegration (Start 2026)** – Fokus auf **Linux/IT Operations** und **Security-Basics** (Hardening, Logging, Automatisierung).

## Setup
- Ubuntu Server als VM (VMware)
- Netzwerk eingerichtet (IP erreichbar)

## Security Baseline
- **SSH Hardening:** SSH-Key-Login aktiviert, Root-Login deaktiviert, Passwortauthentifizierung deaktiviert  
- **UFW Firewall:** default deny incoming / allow outgoing; inbound nur **22/tcp (SSH)** & **80/tcp (HTTP)**
- **Fail2ban:** installiert & gestartet (Brute-Force-Schutz, Logquelle: `/var/log/auth.log`)

## Services
- **Apache Webserver** installiert & betrieben (Eigene HTML/CSS Seite/Landingpage ausgeliefert)

## Troubleshooting Workflow
- Service-Checks: `systemctl`
- Netzwerk/Port-Checks: `ss`, `curl`
- Logs: `journalctl`, `/var/log`, Apache access/error logs

## Automation & Monitoring Basics
- `system_check.sh` (date, uptime, df, free, service status)
- Logging via `>>` und `2>&1`
- Cronjob: tägliche Ausführung **08:00** (mit absoluten Pfaden)
- Logrotate: Rotation + Komprimierung verifiziert (`.1.gz`)
- unattended-upgrades: automatische Security-Updates (Auto-Reboot bewusst deaktiviert)

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
