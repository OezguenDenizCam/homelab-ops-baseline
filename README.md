# Homelab – Linux/IT Operations Baseline (Ubuntu Server in VMware)

**Ziel:** Praxisaufbau für die Ausbildung **Fachinformatiker Systemintegration (Start 2026)** – Fokus auf Linux/IT Operations & Security-Basics.

## Setup
- Ubuntu Server als VM (VMware)
- Netzwerk eingerichtet (IP erreichbar)

## Security Baseline
- SSH Hardening: SSH-Key-Login, Root-Login deaktiviert, Passwortauth deaktiviert
- UFW Firewall: default deny incoming / allow outgoing; inbound nur 22/tcp (SSH) & 80/tcp (HTTP)
- Fail2ban: installiert & gestartet (Brute-Force-Schutz, Einstieg auth.log Analyse)

## Services
- Apache Webserver installiert & betrieben (Eigene Website /Landingpage ausgeliefert)

## Troubleshooting Workflow
- Service-Checks: `systemctl`
- Netzwerk/Port-Checks: `ss`, `curl`
- Logs: `journalctl`, `/var/log`, Apache access/error logs

## Automation & Monitoring Basics
- `system_check.sh` (date, uptime, df, free, service status)
- Logging via `>>` und `2>&1`
- Cronjob: tägliche Ausführung (08:00) mit absoluten Pfaden
- Logrotate: Rotation + Komprimierung verifiziert (`.1.gz`)
- unattended-upgrades: automatische Security-Updates (Auto-Reboot bewusst deaktiviert)

## Repo-Struktur (kommt als nächstes)
- `system_check.sh`
- `configs/ufw_rules.txt`
- `configs/fail2ban-jail.local`
