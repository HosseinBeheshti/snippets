#!/bin/bash

# Start system services needed for GUI and VPN
service dbus start
service NetworkManager start

# Start VNC server as docker user
su - docker -c "vncserver :1 -geometry 1280x800 -depth 24"

# Ensure xfce4-terminal is default in XFCE
su - docker -c "xfconf-query -c xsettings -p /Default/TerminalEmulator -s xfce4-terminal || true"

# Keep container running
tail -f /dev/null
