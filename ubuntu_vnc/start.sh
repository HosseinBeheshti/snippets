#!/bin/bash

# Start X session in background
Xvfb :0 -screen 0 1024x768x16 &

# Wait for X to start
sleep 2

# Set DISPLAY env
export DISPLAY=:0

# Start XFCE session
startxfce4 &

# Optional: start L2TP VPN here (example only)
# Modify /etc/ipsec.conf, /etc/ipsec.secrets, etc. beforehand

# Start VNC with TLS
x11vnc -display :0 -ssl -usepw -forever