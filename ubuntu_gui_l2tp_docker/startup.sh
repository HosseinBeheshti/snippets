#!/bin/bash

# Start needed services
service dbus start
service NetworkManager start

# Start VNC with 1920x1080 resolution
su - docker -c "vncserver :1 -geometry 1920x1080 -depth 24"

# Set default terminal emulator in XFCE
su - docker -c "xfconf-query -c xsettings -p /Default/TerminalEmulator -s xfce4-terminal || true"

# Keep container alive with interactive shell (login shell = bash completion works)
su - docker -c "bash --login"

# Keep container running
tail -f /dev/null