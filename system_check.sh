#!/bin/bash

echo "===== SYSTEM CHECK ====="
date
echo

echo "---- UPTIME / LOAD ----"
uptime
echo

echo "---- DISK (/) ----"
df -h /
echo

echo "---- MEMORY ----"
free -h
echo

echo "---- SERVICE STATUS ----"
systemctl is-active ssh apache2

echo "====================================================="
echo
